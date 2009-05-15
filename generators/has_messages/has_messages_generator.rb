class HasMessagesGenerator < Rails::Generator::Base
  default_options :skip_migration => false
  
  def manifest
    record do |m|
      m.class_collisions "message"
      
      m.directory 'app/models'
      m.directory 'spec/models'
      m.directory 'db/migrate'

      m.template 'message.rb', File.join('app/models', "message.rb")

      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :assigns => {
          :migration_name => "CreateMessages"
        }, :migration_file_name => "create_messages"
      end
    end
  end


  protected
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-migration",
      "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
  end
  
end
