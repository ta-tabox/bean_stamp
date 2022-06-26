max_threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'development') == 'development'

environment ENV.fetch('RAILS_ENV') { 'production' }

pidfile ENV.fetch('PIDFILE') { 'tmp/pids/server.pid' }

plugin :tmp_restart

# プロキシサーバーNginx用の設定
app_root = File.expand_path('../..', __dir__) # 2段階上の階層をルートに指定
bind "unix://#{app_root}/tmp/sockets/puma.sock"

stdout_redirect "#{app_root}/log/puma.stdout.log", "#{app_root}/log/puma.stderr.log", true
