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
