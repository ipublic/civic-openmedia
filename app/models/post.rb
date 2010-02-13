class Post < CouchRestRails::Document

# see http://github.com/hpoydar/couchrest-rails

  use_database :feeds

  property :data_model_identifer

  timestamps!
end