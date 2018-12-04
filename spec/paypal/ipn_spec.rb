require 'spec_helper'

describe Paypal::IPN do
  describe '.verify!' do
    context 'when valid' do
      before { fake_response 'IPN/valid', :IPN }
      subject { Paypal::IPN.verify!('raw-post-body') }
      it { is_expected.to be_truthy }
    end

    context 'when invalid' do
      before { fake_response 'IPN/invalid', :IPN }
      subject {}
      it do
        expect { Paypal::IPN.verify!('raw-post-body') }.to raise_error(Paypal::Exception::APIError)
      end
    end
  end
end
