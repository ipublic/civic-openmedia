class Post < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails

  use_database :public

  property :data_model_identifer
  property :record_count

  timestamps!
end