require 'net/http'
require 'httparty'
require 'json'

class BudgetSimpleAPI
  include HTTParty

  BSHOSTNAME = "newdev.budgetsimple.com"

  attr_reader :email, :password, :token, :secret

  def initialize(email, password)
    @base_uri = "https://#{BSHOSTNAME}/api"
    @email = email
    @password = password
    @salt = SecureRandom.hex(10)
    authenticate!
  end

  def validate
    fetch("users", function: "validate")
  end

  def budget_summary
    fetch("budget", function: "summary")
  end

  private

  def fetch(path, params)
    request = build_request(path, params)
    send_request_and_get_response(request)
  end

  def build_request(path, params)
    params = Params.new(params)
    uri = URI("#{@base_uri}/#{path}.php?#{params.to_query_string}&")
    request = Net::HTTP::Post.new(uri)
    request['Token'] = @token
    request['Sodium'] = @salt
    request['Authorization'] = AuthHeaderBuilder.new.build("#{path}.php", params, @salt, @secret)
    request
  end

  def send_request_and_get_response(request)
    response = Net::HTTP.start(BSHOSTNAME, nil, :use_ssl => true) { |http|
      http.request(request) 
    }
    JSON.parse(response.body)
  end

  def authenticate!
    options = {
      query: {
        function: "login",
        username: @email,
        password: @password
      }
    }

    response = self.class.post("#{@base_uri}/users.php", options) 
    body = JSON.parse(response.body)
    if body.has_key?("token")
      @token = body["token"]
      @secret = body["secret"]
    else
      raise ArgumentError, "Incorrect username or password."
    end
  end

  class Params
    def initialize(hash)
      @hash = hash   
    end

    def to_query_string
      @hash.map do |k, v|
        "#{k}=#{v}"
      end.join("&")
    end
  end

  class AuthHeaderBuilder
    def initialize
      @base = 'https://newdev.budgetsimple.com/api'
      @digest = OpenSSL::Digest.new("sha256")
    end

    def build(path, params, salt, secret) 
      uri = "#{@base}/#{path}?" +
        params.to_query_string + "&"
      data = "GET:#{uri}:#{secret}" 
      hash = OpenSSL::HMAC.digest(@digest, salt, data) 
      Base64.encode64(hash).chomp
    end
  end
end