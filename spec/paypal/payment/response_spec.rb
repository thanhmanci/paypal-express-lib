require 'spec_helper.rb'

describe Paypal::Payment::Response do
  describe '.new' do
    let :attributes do
      {
        CUSTOM: 'custom'
      }
    end

    subject { Paypal::Payment::Response.new(attributes) }

    describe '#custom' do
      subject { super().custom }
      it { is_expected.to eq 'custom' }
    end

    context 'when non-supported attributes are given' do
      it 'should ignore them and warn' do
        expect(Paypal.logger).to receive(:warn).with(
          "Ignored Parameter (Paypal::Payment::Response): ignored=Ignore me!"
        )
        response = Paypal::Payment::Response.new(
          :ignored => 'Ignore me!'
        )
      end
    end
  end
end
