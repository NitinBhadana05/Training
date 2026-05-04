class Rack::Attack
  throttle("req/ip", limit: 5, period: 10.seconds) do |req|
    req.ip
  end

  self.throttled_response = lambda do |env|
    [429,
     { "Content-Type" => "application/json" },
     [{ error: "Too many requests" }.to_json]
    ]
  end
end