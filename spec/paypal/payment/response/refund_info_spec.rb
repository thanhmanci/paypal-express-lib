require 'spec_helper.rb'

describe Paypal::Payment::Response::RefundInfo do
  let :attributes do
    {
      refund_status: 'Instant'
    }
  end

  describe '.new' do
    subject { Paypal::Payment::Response::RefundInfo.new(attributes) }

    describe '#refund_status' do
      subject { super().refund_status }
      it { is_expected.to eq 'Instant' }
    end
  end
end
