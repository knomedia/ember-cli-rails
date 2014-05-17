# This script is used with the Ruby on Rails' new project generator:
#
#     rails new my_app -m path/to/this/ember_cli_template.rb
#
# For more information about the template API, please see the following Rails
# guide:
#
#     http://edgeguides.rubyonrails.org/rails_application_templates.html
# assumes:
#
# npm installed
# npm install -g bower
# npm install -g ember-cli

# Install required gems
gem "active_model_serializers"
gem "nokogiri"

# kill un-needed gems
run "sed -i.bck '/turbolinks/d' Gemfile"
run "sed -i.bck '/coffee/d' Gemfile"
run "sed -i.bck '/jbuilder/d' Gemfile"
run "sed -i.bck '/jquery-rails/d' Gemfile"

run "bundle install"

# cleanup
run "rm Gemfile.bck"

# create ember-cli app
run "ember new ember-app"
run "cd ember-app && npm link ember-cli"

#don't track node_modules via git
run "echo '/ember-app/node_modules/*' >> .gitignore"

# build AssetsController and default to it
generate :controller, "Assets", "index"
run "rm app/views/assets/index.html.erb"
file "app/views/assets/index.html.erb", "<%# Ember Starting Point %>"

route "root 'assets#index'"

generate :serializer, "application", "--parent", "ActiveModel::Serializer"
inject_into_class "app/serializers/application_serializer.rb", "ApplicationSerializer" do
  "  embed :ids, :include => true\n"
end

# pull rake tasks
run "curl -o lib/tasks/ember_cli_rails.rake https://gist.githubusercontent.com/knomedia/2528c6d1054e71402a1f/raw/ember_cli_rails.rake"


#generate application_template, and build ember app
run "bin/rake ember_cli_rails:application_template"
run "bin/rake ember_cli_rails:build"

puts <<-MESSAGE

***********************************************************

Your ember-cli app is located at: 'ember-app'
see: https://github.com/stefanpenner/ember-cli

AssetsController#index is the root route to your ember app

Make changes to app/views/layouts/application_template.html

To build the ember project run:

`bin/rails ember_cli_rails:build`

***********************************************************

MESSAGE
