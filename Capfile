require 'dotenv'
Dotenv.load

# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Load tasks from gems
require 'capistrano/composer'

# Use wpcli to sync uploads and database
require 'capistrano/wpcli'

# Deploy theme submodule 
require 'capistrano/scm'
require 'capistrano/git'
class Capistrano::Git < Capistrano::SCM
  module SubmoduleStrategy
    include DefaultStrategy
 
    def release
      context.execute :rm, '-rf', release_path
      git :clone, '--branch', fetch(:branch),
        '--recursive',
        '--no-hardlinks',
        repo_path, release_path
    end
  end
end

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
# Customize this path to change the location of your custom tasks.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
