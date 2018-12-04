require 'spec_helper.rb'

describe Paypal::Payment::Common::Amount do
  let :keys do
    Paypal::Payment::Common::Amount.optional_attributes
  end

  describe '.new' do
    it 'should not allow nil for attributes' do
      amount = Paypal::Payment::Common::Amount.new
      keys.each do |key|
        expect(amount.send(key)).to eq(0)
      end
    end

    it 'should treat all attributes as Numeric' do
      # Integer
      attributes = keys.inject({}) do |attributes, key|
        attributes.merge!(key => "100")
      end
      amount = Paypal::Payment::Common::Amount.new attributes
      keys.each do |key|
        expect(amount.send(key)).to eq(100)
      end

      # Float
      attributes = keys.inject({}) do |attributes, key|
        attributes.merge!(key => "10.25")
      end
      amount = Paypal::Payment::Common::Amount.new attributes
      keys.each do |key|
        actual = amount.send(key)
        expect(actual).to be_a(BigDecimal)
        expect(actual).to eq BigDecimal('10.25')
      end
    end
  end
end
