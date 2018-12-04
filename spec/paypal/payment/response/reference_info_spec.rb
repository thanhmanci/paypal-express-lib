require 'spec_helper.rb'

describe Paypal::Payment::Response::Reference do
  let :attributes do
    {
      identifier: 'B-8XW15926RT2253736',
      payee_email: 'payee@example.org',
      payee_id: '0123456789ABCDEFG'
    }
  end

  describe '.new' do
    subject { Paypal::Payment::Response::Reference.new(attributes) }

    describe '#identifier' do
      subject { super().identifier }
      it { is_expected.to eq 'B-8XW15926RT2253736' }
    end

    context 'when no payee info' do
      let(:attributes) { { identifier: 'id' } }
      it 'does not populate payee_info' do
        expect(subject.payee_info).to be_nil
      end
    end

    it 'stores payee information in payee_info' do
      payee_info = double(Paypal::Payment::Response::PayeeInfo)
      expect(Paypal::Payment::Response::PayeeInfo)
        .to receive(:new)
        .with(payee_email: 'payee@example.org', payee_id: '0123456789ABCDEFG')
        .and_return(payee_info)
      expect(subject.payee_info).to eq payee_info
    end
  end
end
