CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['CARRIER_WAVE_AWS_KEY'],
    aws_secret_access_key: ENV['CARRIER_WAVE_AWS_SEC'],
    region: ENV['CARRIER_WAVE_REGION']
  }

  config.fog_directory = ENV['CARRIER_WAVE_FOG_DIR']
  config.asset_host = ENV['CARRIER_WAVE_ASSET_HOST']
end
