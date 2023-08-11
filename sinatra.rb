
require 'sinatra'

class APIKeyManager
  def initialize
    @api_keys = []
  end

  def generate_key
    api_key = rand(100_000..999_999)
    @api_keys << { key: api_key, created_at: Time.now, used: false, called_at: "" }
    api_key
  end

  def list_available_keys
    available_keys = @api_keys.select { |key| !key[:used] }
    if available_keys.empty?
      "404"
    else
      selected_key = available_keys.sample
      selected_key[:used] = true
      selected_key[:called_at] = Time.now
      selected_key[:key].to_s
    end
  end

  def unblock_key(key)
    selected_key = @api_keys.find { |k| k[:key].to_s == key.to_s }
    selected_key[:used] = false if selected_key
    "Unblocked #{key}"
  end

  def delete_key(key)
    @api_keys.delete_if { |k| k[:key].to_s == key.to_s }
    "Deleted #{key}"
  end

  def keep_alive(key)
    selected_key = @api_keys.find { |k| k[:key].to_s == key.to_s }
    selected_key[:created_at] = Time.now if selected_key
    "#{key} kept alive"
  end

  def remove_expired
    @api_keys.delete_if { |k| (Time.now - k[:created_at]) >= 300 }
  end

  def revive_keys
    @api_keys.each { |k| k[:used] = false if k[:called_at] != "" && (Time.now - k[:called_at]) >= 60 }
  end

end

api_key_manager = APIKeyManager.new

get '/' do
  api_key = api_key_manager.generate_key
  "Generated API Key: #{api_key}"
end

get '/list' do
  api_key_manager.list_available_keys
end

get '/unblock/:key' do
  api_key_manager.unblock_key(params[:key])
end

get '/delete/:key' do
  api_key_manager.delete_key(params[:key])
end

get '/keepalive/:key' do
  api_key_manager.keep_alive(params[:key])
end

Thread.new do
    while true do
        # sleep 5
        api_key_manager.removeExpired
        api_key_manager.reviveKeys
    end
end

