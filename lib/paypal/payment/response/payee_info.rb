module Paypal
  module Payment
    class Response::PayeeInfo < Base
      attr_required :payee_email, :payee_id
    end
  end
end
