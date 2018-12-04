module Paypal
  module Payment
    class Response::Reference < Base
      attr_required :identifier
      attr_optional :description, :status
      attr_accessor :info, :payee_info

      def initialize(attributes = {})
        super
        store_payee_info(attributes) if attributes[:payee_email]
      end

      private

      def store_payee_info(attributes)
        @payee_info = Response::PayeeInfo.new(
          payee_email: attributes.delete(:payee_email),
          payee_id: attributes.delete(:payee_id)
        )
      end
    end
  end
end
