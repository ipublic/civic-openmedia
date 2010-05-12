class Search

  # Uses SearchLogic gem - stubbed out for now
  # Determine how to integrate with CouchDB
  
  attr_accessor :what

  def self.find(what)
    [
      [Dataset, :title_like],
      [Organization, :name_like],
      [Organization, :description_like] ].inject([]) { |results, model| results += model[0].send(model[1],what).to_a }
  end

  def self.recent_changes
    recent=[System, Organization, Segment, PointOfContact].inject([]) do |sum, clazz|
      sum += clazz.find(:all, :order => :updated_at, :limit => 10)
    end

    recent.sort {|a, b| b.updated_at <=> a.updated_at}[0..9]
  end
end
