require 'webmock/rspec'

module FakeResponseHelper

  def fake_response(file_path, api = :NVP)
    endpoint = case api
    when :NVP
      Paypal::NVP::Request.endpoint
    when :IPN
      Paypal::IPN.endpoint
    else
      raise "Non-supported API: #{api}"
    end
    stub_request(:post, endpoint)
      .to_return(
        body: File.read(File.join(File.dirname(__FILE__), '../fake_response', "#{file_path}.txt"))
      )
  end

  def request_to(endpoint, method = :get)
    raise_error(
      WebMock::NetConnectNotAllowedError,
      /Real HTTP connections are disabled. Unregistered request: #{method.to_s.upcase} #{endpoint}/
    )
  end

end

include FakeResponseHelper
