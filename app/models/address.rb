class Address < Hash
  include ::CouchRest::CastedModel
  
  property :line_1
  property :line_2
  property :city_name
  property :state_abbreviation
  property :zip_code
  property :country, :default => "USA"
 
  def to_s
    address_str = "#{address_1}"
    address_str << ",\n #{address_2}" if address_2
    address_str << "\n"
    address_str << "#{city_name}, " if city_name
    address_str << "#{state_abbreviation}" if state_abbreviation
    address_str << " #{zip_code}" if zip_code
    address_str << "\n#{country}" if country
    address_str
  end
end

