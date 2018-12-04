module Paypal
  module Payment
    class Response::RefundInfo < Base
      attr_required :refund_status
    end
  end
end
