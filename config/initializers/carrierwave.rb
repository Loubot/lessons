CarrierWave.configure do |config|
  config.fog_credentials = {
  :provider => 'AWS', # required
  :aws_access_key_id => ENV['aws_key'], # required
  :aws_secret_access_key => ENV['aws_secret_key'], # required
  :region => 'eu-west-1',
  :path_style => true
  }
  config.fog_directory = 'lessons.photos' # required
  config.fog_public = false # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'} #
end