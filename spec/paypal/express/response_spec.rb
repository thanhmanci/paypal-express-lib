require 'spec_helper.rb'

describe Paypal::Express::Response do
  before { fake_response 'SetExpressCheckout/success' }

  let(:return_url) { 'http://example.com/success' }
  let(:cancel_url) { 'http://example.com/cancel' }
  let :request do
    Paypal::Express::Request.new(
      :username => 'nov',
      :password => 'password',
      :signature => 'sig'
    )
  end
  let :payment_request do
    Paypal::Payment::Request.new(
      :billing_type => :RecurringPayments,
      :billing_agreement_description => 'Recurring Payment Request'
    )
  end
  let(:response) { request.setup payment_request, return_url, cancel_url }

  describe '#redirect_uri' do
    subject { response.redirect_uri }
    it { is_expected.to include 'https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=' }
  end

  describe '#popup_uri' do
    subject { response.popup_uri }
    it { is_expected.to include 'https://www.paypal.com/incontext?token=' }
  end

  context 'when pay_on_paypal option is given' do
    let(:response) { request.setup payment_request, return_url, cancel_url, :pay_on_paypal => true }

    subject { response }

    describe '#pay_on_paypal' do
      subject { super().pay_on_paypal }
      it { is_expected.to be_truthy }
    end

    describe '#query' do
      # FIXME spec on private method
      subject { super().send(:query) }
      it { is_expected.to include(:useraction => 'commit') }
    end

    describe '#redirect_uri' do
      subject { response.redirect_uri }
      it { is_expected.to include 'useraction=commit' }
    end

    describe '#popup_uri' do
      subject { response.popup_uri }
      it { is_expected.to include 'useraction=commit' }
    end
  end

  context 'when sandbox mode' do
    before do
      Paypal.sandbox!
      fake_response 'SetExpressCheckout/success'
    end
    after { Paypal.sandbox = false }

    describe '#redirect_uri' do
      subject { response.redirect_uri }
      it { is_expected.to include 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=' }
    end

    describe '#popup_uri' do
      subject { response.popup_uri }
      it { is_expected.to include 'https://www.sandbox.paypal.com/incontext?token=' }
    end
  end

  context 'when mobile option is given' do
    let(:response) { request.setup payment_request, return_url, cancel_url, :mobile => true }

    subject { response }

    describe '#redirect_uri' do
      subject { response.redirect_uri }
      it { is_expected.to include 'https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout-mobile&token=' }
    end
  end

end
