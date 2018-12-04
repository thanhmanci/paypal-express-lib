module Paypal
  module Payment
    class Response::Refund < Base
      attr_optional :transaction_id
      attr_accessor :amount
      attr_accessor :info

      def initialize(attributes = {})
        super
        @info = Response::RefundInfo.new(
          refund_status: attributes.delete(:refund_status)
        )
        @amount = Common::Amount.new(attributes[:amount])
      end
    end
  end
end
