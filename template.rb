# This script is used with the Ruby on Rails' new project generator:
#
#     rails new my_app -m path/to/this/template.rb
#
# For more information about the template API, see:
#    http://edgeguides.rubyonrails.org/rails_application_templates.html
#
# this template assumes:
#
# npm installed
# npm install -g bower
# npm install -g ember-cli

# Install required gems
gem "active_model_serializers"

# kill un-needed gems
run "sed -i.bck '/turbolinks/d' Gemfile"
run "sed -i.bck '/coffee/d' Gemfile"
run "sed -i.bck '/jbuilder/d' Gemfile"
run "sed -i.bck '/jquery-rails/d' Gemfile"

run "bundle install"

# cleanup
run "rm Gemfile.bck"

ember_app = "#{@app_name}-ember"

# create ember-cli app
run "ember new #{ember_app}"
run "cd #{ember_app} && npm link ember-cli"

#don't track node_modules via git
run "echo '/#{ember_app}/node_modules/*' >> .gitignore"

# build rails catch-all route
route "get '*path' => redirect('/')"

generate :serializer, "application", "--parent", "ActiveModel::Serializer"
inject_into_class "app/serializers/application_serializer.rb", "ApplicationSerializer" do
  "  embed :ids, :include => true\n"
end

#create build.sh from template put in bin/
template_dir = File.expand_path(File.dirname(__FILE__))
build_file_path = template_dir + "/build.sh.erb"
template = File.open(build_file_path, "rb") {|io| io.read}

build_content = ERB.new(template).result(binding)
File.open('bin/build.sh', 'w') { |file| file.write(build_content) }
run "chmod a+x bin/build.sh"

puts <<-MESSAGE

***********************************************************

Your ember-cli app is located at: '#{@app_path}/#{ember_app}'
see: https://github.com/stefanpenner/ember-cli

To build the ember project for deployment run

`./bin/build.sh`

***********************************************************

MESSAGE
