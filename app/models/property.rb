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
    @type           = options.delete(:type)               if options[:type]
    @definition     = options.delete(:definition)         if options[:definition]
    @default_value  = options.delete(:default_value)      if options[:default_value]
    @example_value  = options.delete(:example_value)      if options[:example_value]
    @comment        = options.delete(:comment)            if options[:comment]
    @can_query      = options[:can_query] ? true : false
    @is_key         = options[:is_key] ? true : false
  end
  
  def to_hash
    rtn_hash = {}
    self.instance_variables.each do |var|
      rtn_hash[var.gsub("@","")] = self.instance_variable_get(var)
    end
    rtn_hash
  end
end

