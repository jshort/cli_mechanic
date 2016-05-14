
module ConfigValidator
  def self.validate(hash)
    if !hash['cli']
      puts 'Root yaml element must been \'cli\''
      exit 7 
    end
  end
end