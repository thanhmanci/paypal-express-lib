require 'spec_helper.rb'

describe Paypal::Payment::Response::Info do
  let :attributes do
    {
      :NAME => 'Item Name',
      :DESC => 'Item Description',
      :QTY => '1',
      :NUMBER => '1',
      :ITEMCATEGORY => 'Digital',
      :ITEMWIDTHVALUE => '1.0',
      :ITEMHEIGHTVALUE => '2.0',
      :ITEMLENGTHVALUE => '3.0',
      :ITEMWEIGHTVALUE => '4.0'
    }
  end

  describe '.new' do
    subject { Paypal::Payment::Response::Item.new(attributes) }

    describe '#name' do
      subject { super().name }
      it { is_expected.to eq('Item Name') }
    end

    describe '#description' do
      subject { super().description }
      it { is_expected.to eq('Item Description') }
    end

    describe '#quantity' do
      subject { super().quantity }
      it { is_expected.to eq(1) }
    end

    describe '#category' do
      subject { super().category }
      it { is_expected.to eq('Digital') }
    end

    describe '#width' do
      subject { super().width }
      it { is_expected.to eq('1.0') }
    end

    describe '#height' do
      subject { super().height }
      it { is_expected.to eq('2.0') }
    end

    describe '#length' do
      subject { super().length }
      it { is_expected.to eq('3.0') }
    end

    describe '#weight' do
      subject { super().weight }
      it { is_expected.to eq('4.0') }
    end

    describe '#number' do
      subject { super().number }
      it { is_expected.to eq('1') }
    end

    context 'when non-supported attributes are given' do
      it 'should ignore them and warn' do
        _attr_ = attributes.merge(
          :ignored => 'Ignore me!'
        )
        expect(Paypal.logger).to receive(:warn).with(
          "Ignored Parameter (Paypal::Payment::Response::Item): ignored=Ignore me!"
        )
        Paypal::Payment::Response::Item.new _attr_
      end
    end
  end
end
