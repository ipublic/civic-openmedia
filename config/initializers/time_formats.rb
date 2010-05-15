# config/initializers/time_formats.rb
  Time::DATE_FORMATS[:month_and_year] = "%B %Y"
  Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") }
  Time::DATE_FORMATS[:simple] = "%B %d, %Y"
  
