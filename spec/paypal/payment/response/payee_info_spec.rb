require 'spec_helper.rb'

describe Paypal::Payment::Response::PayeeInfo do
  let :attributes do
    {
      payee_email: 'payee@example.org',
      payee_id: '0123456789ABCDEFG'
    }
  end

  describe '.new' do
    subject { Paypal::Payment::Response::PayeeInfo.new(attributes) }

    describe '#payee_email' do
      subject { super().payee_email }
      it { is_expected.to eq 'payee@example.org' }
    end

    describe '#payee_id' do
      subject { super().payee_id }
      it { is_expected.to eq '0123456789ABCDEFG' }
    end
  end
end
