# environmental override allows us to configure a separate file which
# we can set config values on without having to submit them to source
# control
class EnvironmentOverride
  
  def self.load
    override = File.join( Rails.root, 'config', 'overrides', "#{Rails.env}.rb")
    if File.exist?( override )
      puts "loading override configuration for [#{Rails.env}]"
      require override
    end
  end
end