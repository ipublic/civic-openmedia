class Property

  attr_accessor :type, :definition, :default_value, :example_value, :can_query, :is_key, :comment
  attr_reader :name
  
  # attribute to define
  def initialize(name, options = {})
    @name = name.to_s
    parse_options(options)
    self
  end
  
  def parse_options(options)
    return if options.empty?
    self.type           = options.delete(:type)               if options[:type]
    self.definition     = options.delete(:definition)         if options[:definition]
    self.default_value  = options.delete(:default_value)      if options[:default_value]
    self.example_value  = options.delete(:example_value)      if options[:example_value]
    self.comment        = options.delete(:comment)            if options[:comment]
    self.can_query      = options[:can_query] ? true : false
    self.is_key         = options[:is_key] ? true : false
  end
  
  def to_hash
    rtn_hash = {}
    instance_variables.each do |var|
      rtn_hash[var.gsub("@","")] = instance_variable_get(var)
    end
    rtn_hash
  end
end

