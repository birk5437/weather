# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_weather_session',
  :secret      => '3adb94e4d4c50608c66f62368f6455ccd19338e0da8fa0ce76c7dedddc5c774512afcc698b957fd0ad2dabd3f0b32d6740a661683fd78c77145b065c339b8fa8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
