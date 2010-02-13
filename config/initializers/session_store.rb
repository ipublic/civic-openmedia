# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_civic-openmedia_session',
  :secret      => '6022b7143b7fedf6464326d84ec7d1afb0ec6b7cb6858ef56314dfba1522cec7861f7520af6e5934c9fab525d013fc0e31e8fe2be9b1941c4da8ff1ed7122947'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
