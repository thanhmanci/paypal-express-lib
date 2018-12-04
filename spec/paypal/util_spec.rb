require 'spec_helper.rb'

describe Paypal::Util do
  describe '.formatted_amount' do
    it 'should return String in "xx.yy" format' do
      expect(Paypal::Util.formatted_amount(nil)).to eq('0.00')
      expect(Paypal::Util.formatted_amount(10)).to eq('10.00')
      expect(Paypal::Util.formatted_amount(BigDecimal('10.02'))).to eq('10.02')
      expect(Paypal::Util.formatted_amount(BigDecimal('10.2'))).to eq('10.20')
      expect(Paypal::Util.formatted_amount(BigDecimal('10.24'))).to eq('10.24')
      expect(Paypal::Util.formatted_amount(BigDecimal('10.255'))).to eq('10.26')
    end
  end

  describe '.to_numeric' do
    it 'should return Integer or BigDecimal' do
      expect(Paypal::Util.to_numeric('10')).to be_kind_of(Integer)
      expect(Paypal::Util.to_numeric('10.5')).to be_kind_of(BigDecimal)
      expect(Paypal::Util.to_numeric('-1.5')).to eq(BigDecimal('-1.5'))
      expect(Paypal::Util.to_numeric('-1')).to eq(-1)
      expect(Paypal::Util.to_numeric('0')).to eq(0)
      expect(Paypal::Util.to_numeric('0.00')).to eq(0)
      expect(Paypal::Util.to_numeric('10')).to eq(10)
      expect(Paypal::Util.to_numeric('10.00')).to eq(10)
      expect(Paypal::Util.to_numeric('10.02')).to eq(BigDecimal('10.02'))
      expect(Paypal::Util.to_numeric('10.2')).to eq(BigDecimal('10.2'))
      expect(Paypal::Util.to_numeric('10.20')).to eq(BigDecimal('10.2'))
      expect(Paypal::Util.to_numeric('10.24')).to eq(BigDecimal('10.24'))
      expect(Paypal::Util.to_numeric('10.25')).to eq(BigDecimal('10.25'))
    end

    it 'returns zero for blank values' do
      expect(Paypal::Util.to_numeric(nil)).to be_zero
      expect(Paypal::Util.to_numeric('')).to be_zero
    end

    it 'raises an ArgumentError when precision is higher than 2 decimals' do
      expect { Paypal::Util.to_numeric('1.234') }.to raise_error(ArgumentError)
    end
  end
end
