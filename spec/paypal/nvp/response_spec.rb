require 'spec_helper.rb'

describe Paypal::NVP::Response do
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
      :amount => 1000,
      :description => 'Instant Payment Request'
    )
  end

  let :recurring_profile do
    Paypal::Payment::Recurring.new(
      :start_date => Time.utc(2011, 2, 8, 9, 0, 0),
      :description => 'Recurring Profile',
      :billing => {
        :period => :Month,
        :frequency => 1,
        :amount => 1000
      }
    )
  end

  describe '.new' do
    context 'when non-supported attributes are given' do
      it 'should ignore them and warn' do
        expect(Paypal.logger).to receive(:warn).with(
          "Ignored Parameter (Paypal::NVP::Response): ignored=Ignore me!"
        )
        Paypal::NVP::Response.new(
          :ignored => 'Ignore me!'
        )
      end
    end

    context 'when SetExpressCheckout response given' do
      before do
        fake_response 'SetExpressCheckout/success'
      end

      it 'should handle all attributes' do
        expect(Paypal.logger).not_to receive(:warn)
        response = request.setup payment_request, return_url, cancel_url
        expect(response.token).to eq('EC-5YJ90598G69065317')
      end
    end

    context 'when GetExpressCheckoutDetails response given' do
      before do
        fake_response 'GetExpressCheckoutDetails/success'
      end

      it 'should handle all attributes' do
        expect(Paypal.logger).not_to receive(:warn)
        response = request.details 'token'
        expect(response.payer.identifier).to eq('9RWDTMRKKHQ8S')
        expect(response.payment_info.size).to eq(0)
      end

      it 'records payment response information' do
        response = request.details 'token'
        expect(response.payment_responses.size).to eq(1)
        payment_response = response.payment_responses.first
        expect(payment_response).to be_instance_of(Paypal::Payment::Response)
        expect(payment_response.custom).to eq 'custom'
        expect(payment_response.bill_to.normalization_status).to eq 'None'
      end

      context 'when BILLINGAGREEMENTACCEPTEDSTATUS included' do
        before do
          fake_response 'GetExpressCheckoutDetails/with_billing_accepted_status'
        end

        it 'should handle all attributes' do
          expect(Paypal.logger).not_to receive(:warn)
          response = request.details 'token'
        end
      end
    end

    context 'when DoExpressCheckoutPayment response given' do
      before do
        fake_response 'DoExpressCheckoutPayment/success'
      end

      it 'should handle all attributes' do
        expect(Paypal.logger).not_to receive(:warn)
        response = request.checkout! 'token', 'payer_id', payment_request
        expect(response.payment_responses.size).to eq(0)
        expect(response.payment_info.size).to eq(1)
        expect(response.payment_info.first).to be_instance_of(Paypal::Payment::Response::Info)
      end

      context 'when billing_agreement is included' do
        before do
          fake_response 'DoExpressCheckoutPayment/success_with_billing_agreement'
        end

        it 'should have billing_agreement' do
          expect(Paypal.logger).not_to receive(:warn)
          response = request.checkout! 'token', 'payer_id', payment_request
          expect(response.billing_agreement.identifier).to eq('B-1XR87946TC504770W')
        end
      end
    end

    context 'when CreateRecurringPaymentsProfile response given' do
      before do
        fake_response 'CreateRecurringPaymentsProfile/success'
      end

      it 'should handle all attributes' do
        expect(Paypal.logger).not_to receive(:warn)
        response = request.subscribe! 'token', recurring_profile
        expect(response.recurring.identifier).to eq('I-L8N58XFUCET3')
      end
    end

    context 'when GetRecurringPaymentsProfileDetails response given' do
      before do
        fake_response 'GetRecurringPaymentsProfileDetails/success'
      end

      it 'should handle all attributes' do
        expect(Paypal.logger).not_to receive(:warn)
        response = request.subscription 'profile_id'
        expect(response.recurring.billing.amount.total).to eq(1000)
        expect(response.recurring.regular_billing.paid).to eq(1000)
        expect(response.recurring.summary.next_billing_date).to eq('2011-03-04T10:00:00Z')
      end
    end

    context 'when ManageRecurringPaymentsProfileStatus response given' do
      before do
        fake_response 'ManageRecurringPaymentsProfileStatus/success'
      end

      it 'should handle all attributes' do
        expect(Paypal.logger).not_to receive(:warn)
        request.renew! 'profile_id', :Cancel
      end
    end

    context 'when RefundTransaction response given' do
      before do
        fake_response 'RefundTransaction/full'
      end

      it 'should handle all attributes' do
        expect(Paypal.logger).not_to receive(:warn)
        request.refund! 'transaction-id'
      end
    end

    context 'when BillAgreementUpdate (BAUpdate) cancellation response given' do
      before do
        fake_response 'BillAgreementUpdate/revoke'
      end

      it 'should handle all attributes' do
        expect(Paypal.logger).not_to receive(:warn)
        request.revoke! 'transaction-id'
      end
    end
  end
end
