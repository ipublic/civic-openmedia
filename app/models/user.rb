# == Schema Information
# Schema version: 20100225223923
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  email              :string(255)     not null
#  crypted_password   :string(255)     not null
#  password_salt      :string(255)     not null
#  persistence_token  :string(255)     not null
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(3), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string(255)
#  last_login_ip      :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class User < ActiveRecord::Base
 acts_as_authentic

 # acts_as_authentic do |c|
 #   c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
 # end # block optional
end

# class User  < CouchRest::ExtendedDocument
#   include CouchRest::Validation
#   include CouchRest::Callbacks
# 
# #  use_database SERVER.default_database
#   use_database :site
# 
#   acts_as_authentic
# 
#   property :login # optional, you can use email instead, or both
#   property :email # optional, you can use login instead, or both
#   property :crypted_password # optional, see below
#   property :password_salt # optional, but highly recommended
#   property :persistence_token # required
#   property :single_access_token # optional, see Authlogic::Session::Params
#   property :perishable_token # optional, see Authlogic::Session::Perishability
# 
#   # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
#   property :login_count, :type => Integer # optional, see Authlogic::Session::MagicColumns
#   property :failed_login_count, :type => Integer # optional, see Authlogic::Session::MagicColumns
#   property :last_request_at, :cast_as => 'Time' # optional, see Authlogic::Session::MagicColumns
#   property :current_login_at, :cast_as => 'Time' # optional, see Authlogic::Session::MagicColumns
#   property :last_login_at, :cast_as => 'Time' # optional, see Authlogic::Session::MagicColumns
#   property :current_login_ip # optional, see Authlogic::Session::MagicColumns
#   property :last_login_ip # optional, see Authlogic::Session::MagicColumns
# 
#   timestamps!
# 
#   def self.default_timezone
#     :utc
#   end

# end