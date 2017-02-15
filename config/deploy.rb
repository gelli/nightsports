set :application, 'nightsports.de'
set :repo_url, 'git@github.com:gelli/nightsports.git'

set :wpcli_rsync_options, %w[-avz --rsh=ssh --iconv=utf-8-mac,utf-8]

# Branch options
# Prompts for the branch name (defaults to current branch)
#ask :branch, -> { `git rev-parse --abbrev-ref HEAD`.chomp }

# Hardcodes branch to always be master
# This could be overridden in a stage config file
set :branch, :master

# set :deploy_to, -> { "/srv/www/#{fetch(:application)}" }

# Use :debug for more verbose output when troubleshooting
set :log_level, :info

# Apache users with .htaccess files:
# it needs to be added to linked_files so it persists across deploys:
set :linked_files, fetch(:linked_files, []).push('.env', 'web/.htaccess')
# set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs, fetch(:linked_dirs, []).push('web/app/uploads')

# woothemes-sensei installed manually (paid plugin)
set :linked_dirs, fetch(:linked_dirs, []).push('web/app/plugins/woothemes-sensei')
set :linked_dirs, fetch(:linked_dirs, []).push('web/app/plugins/woothemes-updater')
set :linked_dirs, fetch(:linked_dirs, []).push('web/app/plugins/instagram-feed-pro')

set :default_env, { path: "~/bin:$PATH" }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :service, :nginx, :reload
    end
  end
end

# The above restart task is not run by default
# Uncomment the following line to run it on deploys if needed
# after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  desc 'Update WordPress template root paths to point to the new release'
  task :update_option_paths do
    on roles(:app) do
      within fetch(:release_path) do
        if test :wp, :core, 'is-installed'
          [:stylesheet_root, :template_root].each do |option|
            # Only change the value if it's an absolute path
            # i.e. The relative path "/themes" must remain unchanged
            # Also, the option might not be set, in which case we leave it like that
            value = capture :wp, :option, :get, option, raise_on_non_zero_exit: false
            if value != '' && value != '/themes'
              execute :wp, :option, :set, option, fetch(:release_path).join('web/wp/wp-content/themes')
            end
          end
        end
      end
    end
  end
end

# The above update_option_paths task is not run by default
# Note that you need to have WP-CLI installed on your server
# Uncomment the following line to run it on deploys if needed
# after 'deploy:publishing', 'deploy:update_option_paths'
namespace :deploy do
  desc 'Activate configured plugins'
  task :update_config do
    on roles(:app) do
      within fetch(:release_path) do
        fetch(:wpcli_options).each do |option|
          execute :wp, option
        end
      end
    end
  end
end
#after 'deploy:publishing', 'deploy:update_config'



# Build dist files in the sage theme. This is done locally
# and then pushed on the server
#set :theme_path, Pathname.new('web/app/themes/stonyray')
#set :local_app_path, Pathname.new('.')
#set :local_theme_path, fetch(:local_app_path).join(fetch(:theme_path))

#namespace :assets do
#  task :compile do
#    run_locally do
#      within fetch(:local_theme_path) do
#        execute :gulp, '--production'
#      end
#    end
#  end

#  task :copy do
#    # invoke 'deploy:compile_assets'

#    on roles(:web) do
#      upload! fetch(:local_theme_path).join('dist').to_s, release_path.join(fetch(:theme_path)), recursive: true
#    end
#  end

#  task :cleanup do
#    on roles(:web) do
#      within fetch(:release_path).join(fetch(:theme_path)) do
#        execute :rm, '-rf', "assets"
#        #execute :rm, '-f', ".bowerrc"
#        #execute :rm, '-f', ".editorconfig"
#        #execute :rm, '-f', ".git"
#        #execute :rm, '-f', ".gitignore"
#        #execute :rm, '-f', ".jscsrc"
#        #execute :rm, '-f', ".jshintrc"
#        #execute :rm, '-f', ".travis.yml"
#        execute :rm, '-f', "bower.json"
#        execute :rm, '-f', "gulpfile.js"
#        execute :rm, '-f', "package.json"
#        execute :rm, '-f', "ruleset.xml"
#      end
#    end
#  end

#  task deploy: %w(compile copy cleanup)
#end

#before 'deploy:updated', 'assets:deploy'

# Manual commands to sync database and files
namespace :sync do
  task local: %w(wpcli:db:pull wpcli:uploads:rsync:pull)
  task remote: %w(wpcli:db:push wpcli:uploads:rsync:push)
end
