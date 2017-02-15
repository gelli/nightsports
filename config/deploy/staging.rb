set :stage, :staging

set :deploy_to, -> { ENV['STAGE_DEPLOY_TO'] }
set :tmp_dir, ENV['STAGE_TMP_DIR']

# Simple Role Syntax
# ==================
#role :app, %w{deploy@example.com}
#role :web, %w{deploy@example.com}
#role :db,  %w{deploy@example.com}


# Extended Server Syntax
# ======================
server 'home521512186.1and1-data.host', user: 'u76768874', roles: %w{web app db}

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(~/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }

fetch(:default_env).merge!(wp_env: :staging)

set :wpcli_remote_url, 'http://skunkworks.mindblast.info'
set :wpcli_local_url, 'http://localhost:8080'

#set :wpcli_options, [
#	"plugin deactivate w3-total-cache",
#	"plugin activate ninja-forms"
#]