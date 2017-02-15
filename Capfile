require 'dotenv'
Dotenv.load

# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Load tasks from gems
require 'capistrano/composer'

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Use wpcli to sync uploads and database
#require 'capistrano/wpcli'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
# Customize this path to change the location of your custom tasks.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
