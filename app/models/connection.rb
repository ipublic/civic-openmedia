class Connection < Hash
  
  include CouchRest::CastedModel
  
  property :connection_type  # file, database or webservice
  property :file_path
  property :file_name
  property :full_file_name
  property :url
  property :endpoint

  # database properties
  property :db_connection_type
  property :host_name
  property :database_name
  property :port_number
  
  property :user_name
  property :password
  
end