require 'net/http'
require 'net/https'

# Create Cookie (GET )
def get_cookie
  uri = URI('http://osrecovery.apple.com')

  # Create client
  http = Net::HTTP.new(uri.host, uri.port)

  # Create Request
  req =  Net::HTTP::Get.new(uri)
  # Add headers
  req.add_field "User-Agent", "InternetRecovery/1.0"
  # Add headers
  req.add_field "Host", "osrecovery.apple.com"

  # Fetch Request
  res = http.request(req)
  puts "Response HTTP Status Code: #{res.code}"
  puts "Response HTTP Response Body: #{res.body}"
rescue StandardError => e
  puts "HTTP Request failed (#{e.message})"
end

def serialize_params(dictionary = {})
    (dictionary.map { |key, value| "#{key}=#{value}" }).join('\n')
end

# Request Parameters (POST )
def request_for_machine(serial_number = 'C079442000SJRWLAX', board_id = 'Mac-7BA5B2DFE22DDD8C', board_rom_version = '17.16.11081.0.0,0')
  uri = URI('http://osrecovery.apple.com/InstallationPayload/RecoveryImage')

  # CID unknown
  cid = 'A64F96125D28533D'
  
  # This seems to be anti-forgery / replay
                        
  # CRNG
  random_challenge = 'CF4EF754A68299485E52179B73382421FDBE38B8A06C7CE518A9A4BA91E3C96D'
                        
  # SHA HMAC-256 (algorithm TBD, only private value may be board UDID)
  forgery_sig = '9ECA302EC3E25279AA80C025EF82A821DAD22197B8516F2E9966CC462B524393'
  
  # Create client
  http = Net::HTTP.new(uri.host, uri.port)
  
  params = {
      cid: cid,
      sn: serial_number,
      bid: board_id,
      k: random_challenge,
      os: 'latest',
      bv: board_rom_version,
      fg: forgery_sig
  }
  
  body = serialize_params(params)

  # Create Request
  req =  Net::HTTP::Post.new(uri)
  # Add headers
  req.add_field "User-Agent", "InternetRecovery/1.0"
  # Add headers
  req.add_field "Content-Type", "text/plain"
  # Add headers
  req.add_field "Host", "osrecovery.apple.com"
  # Set body
  req.body = body

  # Fetch Request
  res = http.request(req)
  puts "Response HTTP Status Code: #{res.code}"
  puts "Response HTTP Response Body: #{res.body}"
                          
  return res.body
rescue StandardError => e
  puts "HTTP Request failed (#{e.message})"
end


# Get the Chunklist (GET )
def get_chunklist(response_params)
  uri = URI('https://echo.paw.cloud')

  # Create client
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  # Create Request
  req =  Net::HTTP::Get.new(uri)
  # Add headers
  req.add_field "User-Agent", "InternetRecovery/1.0"
  # Add headers
  req.add_field "Cookie", "AssetToken="

  # Fetch Request
  res = http.request(req)
  puts "Response HTTP Status Code: #{res.code}"
  puts "Response HTTP Response Body: #{res.body}"
rescue StandardError => e
  puts "HTTP Request failed (#{e.message})"
end



