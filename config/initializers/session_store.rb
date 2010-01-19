# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_scalpel_session',
  :secret      => '8221d65a134387de00f2c3b0d4fc39e11f252e520089fabeccdf71759222dfb4a39e835872ae122d29ceec105d0cb2e849056e81e353196b84bb103dc8eae03f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
