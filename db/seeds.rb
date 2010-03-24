# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }).save { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Seed default user
User.delete_all
User.new(:login => 'admin', 
  :password => 'password', 
  :password_confirmation => 'password', 
  :email => 'admin@example.com').save

## Syntax for CouchRest documents
#State.all.delete
State.new({:abbreviation => 'AK', :state_fips_code => '02', :name => 'ALASKA'}).save
State.new({:abbreviation => 'AL', :state_fips_code => '01', :name => 'ALABAMA'}).save
State.new({:abbreviation => 'AR', :state_fips_code => '05', :name => 'ARKANSAS'}).save
State.new({:abbreviation => 'AS', :state_fips_code => '60', :name => 'AMERICAN SAMOA'}).save
State.new({:abbreviation => 'AZ', :state_fips_code => '04', :name => 'ARIZONA'}).save
State.new({:abbreviation => 'CA', :state_fips_code => '06', :name => 'CALIFORNIA'}).save
State.new({:abbreviation => 'CO', :state_fips_code => '08', :name => 'COLORADO'}).save
State.new({:abbreviation => 'CT', :state_fips_code => '09', :name => 'CONNECTICUT'}).save
State.new({:abbreviation => 'DC', :state_fips_code => '11', :name => 'DISTRICT OF COLUMBIA'}).save
State.new({:abbreviation => 'DE', :state_fips_code => '10', :name => 'DELAWARE'}).save
State.new({:abbreviation => 'FL', :state_fips_code => '12', :name => 'FLORIDA'}).save
State.new({:abbreviation => 'GA', :state_fips_code => '13', :name => 'GEORGIA'}).save
State.new({:abbreviation => 'GU', :state_fips_code => '66', :name => 'GUAM'}).save
State.new({:abbreviation => 'HI', :state_fips_code => '15', :name => 'HAWAII'}).save
State.new({:abbreviation => 'IA', :state_fips_code => '19', :name => 'IOWA'}).save
State.new({:abbreviation => 'ID', :state_fips_code => '16', :name => 'IDAHO'}).save
State.new({:abbreviation => 'IL', :state_fips_code => '17', :name => 'ILLINOIS'}).save
State.new({:abbreviation => 'IN', :state_fips_code => '18', :name => 'INDIANA'}).save
State.new({:abbreviation => 'KS', :state_fips_code => '20', :name => 'KANSAS'}).save
State.new({:abbreviation => 'KY', :state_fips_code => '21', :name => 'KENTUCKY'}).save
State.new({:abbreviation => 'LA', :state_fips_code => '22', :name => 'LOUISIANA'}).save
State.new({:abbreviation => 'MA', :state_fips_code => '25', :name => 'MASSACHUSETTS'}).save
State.new({:abbreviation => 'MD', :state_fips_code => '24', :name => 'MARYLAND'}).save
State.new({:abbreviation => 'ME', :state_fips_code => '23', :name => 'MAINE'}).save
State.new({:abbreviation => 'MI', :state_fips_code => '26', :name => 'MICHIGAN'}).save
State.new({:abbreviation => 'MN', :state_fips_code => '27', :name => 'MINNESOTA'}).save
State.new({:abbreviation => 'MO', :state_fips_code => '29', :name => 'MISSOURI'}).save
State.new({:abbreviation => 'MS', :state_fips_code => '28', :name => 'MISSISSIPPI'}).save
State.new({:abbreviation => 'MT', :state_fips_code => '30', :name => 'MONTANA'}).save
State.new({:abbreviation => 'NC', :state_fips_code => '37', :name => 'NORTH CAROLINA'}).save
State.new({:abbreviation => 'ND', :state_fips_code => '38', :name => 'NORTH DAKOTA'}).save
State.new({:abbreviation => 'NE', :state_fips_code => '31', :name => 'NEBRASKA'}).save
State.new({:abbreviation => 'NH', :state_fips_code => '33', :name => 'NEW HAMPSHIRE'}).save
State.new({:abbreviation => 'NJ', :state_fips_code => '34', :name => 'NEW JERSEY'}).save
State.new({:abbreviation => 'NM', :state_fips_code => '35', :name => 'NEW MEXICO'}).save
State.new({:abbreviation => 'NV', :state_fips_code => '32', :name => 'NEVADA'}).save
State.new({:abbreviation => 'NY', :state_fips_code => '36', :name => 'NEW YORK'}).save
State.new({:abbreviation => 'OH', :state_fips_code => '39', :name => 'OHIO'}).save
State.new({:abbreviation => 'OK', :state_fips_code => '40', :name => 'OKLAHOMA'}).save
State.new({:abbreviation => 'OR', :state_fips_code => '41', :name => 'OREGON'}).save
State.new({:abbreviation => 'PA', :state_fips_code => '42', :name => 'PENNSYLVANIA'}).save
State.new({:abbreviation => 'PR', :state_fips_code => '72', :name => 'PUERTO RICO'}).save
State.new({:abbreviation => 'RI', :state_fips_code => '44', :name => 'RHODE ISLAND'}).save
State.new({:abbreviation => 'SC', :state_fips_code => '45', :name => 'SOUTH CAROLINA'}).save
State.new({:abbreviation => 'SD', :state_fips_code => '46', :name => 'SOUTH DAKOTA'}).save
State.new({:abbreviation => 'TN', :state_fips_code => '47', :name => 'TENNESSEE'}).save
State.new({:abbreviation => 'TX', :state_fips_code => '48', :name => 'TEXAS'}).save
State.new({:abbreviation => 'UT', :state_fips_code => '49', :name => 'UTAH'}).save
State.new({:abbreviation => 'VA', :state_fips_code => '51', :name => 'VIRGINIA'}).save
State.new({:abbreviation => 'VI', :state_fips_code => '78', :name => 'VIRGIN ISLANDS'}).save
State.new({:abbreviation => 'VT', :state_fips_code => '50', :name => 'VERMONT'}).save
State.new({:abbreviation => 'WA', :state_fips_code => '53', :name => 'WASHINGTON'}).save
State.new({:abbreviation => 'WI', :state_fips_code => '55', :name => 'WISCONSIN'}).save
State.new({:abbreviation => 'WV', :state_fips_code => '54', :name => 'WEST VIRGINIA'}).save
State.new({:abbreviation => 'WY', :state_fips_code => '56', :name => 'WYOMING'}).save

# this call will load the model's predefined views
s = State.all

