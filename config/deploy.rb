# cap production deploy
# require "rvm/capistrano"
# https://stackoverflow.com/questions/29547314/how-to-restart-puma-after-deploy
# Only have to restart the puma servers after puma config changes?
# cap production deploy:restart
# bundle exec pumactl -P /home/deploy/.pids/puma.pid restart
# Change these
server 'www.phlurby.com', port: 22, roles: [:web, :app, :db], primary: true

set :repo_url,        'git@github.com:danabr75/phlurby.git'
set :application,     'phlurby'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
set :rvm_type, :user 
set :rvm_ruby_version, '2.4.1@phlurby'
set :bundle_dir, ''
set :bundle_flags, '--deployment'


    # set :nginx_config_name, "#{fetch(:application)}_#{fetch(:stage)}"
    # set :nginx_flags, 'fail_timeout=0'
    # set :nginx_http_flags, fetch(:nginx_flags)
    # set :nginx_server_name, "localhost #{fetch(:application)}.local"
    # set :nginx_sites_available_path, '/etc/nginx/sites-available'
    # set :nginx_sites_enabled_path, '/etc/nginx/sites-enabled'
    # set :nginx_socket_flags, fetch(:nginx_flags)

    #ssl_certificate /etc/nginx/ssl/nginx.crt;
    #ssl_certificate_key /etc/nginx/ssl/nginx.key;
    #ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    #ssl_prefer_server_ciphers on;
    #ssl_ciphers AES256+EECDH:AES256+EDH:!aNULL;
    #ssl on;
  # set :nginx_ssl_certificate, "/etc/nginx/ssl/nginx.crt"
  # set :nginx_ssl_certificate_key, "/etc/nginx/ssl/nginx.key"
  # set :nginx_use_ssl, true

# set :nginx_path, '/etc/nginx' # directory containing sites-available and sites-enabled
# set :nginx_template, 'config/deploy/nginx_conf.erb' # configuration template
# set :nginx_server_name, 'phlurby.com www.phlurby.com' # optional, defaults to :application
# set :nginx_upstream, 'puma' # optional, defaults to :application
# set :nginx_listen, 80 # optional, default is not set
# set :nginx_roles, :all

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc "Copy DB - doesn't work."
  task :copy_sqlite do
    on roles(:app) do
      puts "CURRENT PATH: #{current_path}"
      puts "RELEASE PATH: #{release_path}"
      execute "cp #{current_path}/db/production.sqlite3 #{release_path}/db/"
    end
  end

  before :starting,     :check_revision
  # after  :finishing,     :copy_sqlite
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma