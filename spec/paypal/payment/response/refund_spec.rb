require 'spec_helper.rb'

describe Paypal::Payment::Response::Refund do
  let :attributes do
    {
      transaction_id: '0000000000000000L',
      refund_status: 'Instant'
    }
  end

  describe '.new' do
    subject { Paypal::Payment::Response::Refund.new(attributes) }

    describe '#transaction_id' do
      subject { super().transaction_id }
      it { is_expected.to eq '0000000000000000L' }
    end

    it 'stores refund information in info' do
      info = double(Paypal::Payment::Response::RefundInfo)
      expect(Paypal::Payment::Response::RefundInfo)
        .to receive(:new)
        .with(refund_status: 'Instant')
        .and_return(info)
      expect(subject.info).to eq info
    end
  end
end
