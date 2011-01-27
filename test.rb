
class Average

 def get_for_name(name)
  @name = name
  self
 end

 def and(age)
  @name + "--" + (age * 2).to_s
 end

end

a = Average.new
puts a.get_for_name("hello")\
       .and(22)

