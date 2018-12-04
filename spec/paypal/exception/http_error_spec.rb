require 'spec_helper.rb'

describe Paypal::Exception::HttpError do
  subject { Paypal::Exception::HttpError.new(400, 'BadRequest', 'You are bad man!') }

  describe '#code' do
    subject { super().code }
    it { is_expected.to eq(400) }
  end

  describe '#message' do
    subject { super().message }
    it { is_expected.to eq('BadRequest') }
  end

  describe '#body' do
    subject { super().body }
    it { is_expected.to eq('You are bad man!') }
  end
end
