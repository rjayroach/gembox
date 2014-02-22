# unicorn.rb
APP_NAME = 'ngems'
APP_PATH = File.expand_path(File.dirname(File.dirname(__FILE__)))

worker_processes 2
preload_app true

working_directory APP_PATH
listen "unix:/tmp/unicorn.#{APP_NAME}_private.sock", backlog: 512
timeout 30
pid APP_PATH + "/tmp/unicorn_private.pid"

stderr_path "#{APP_PATH}/log/unicorn_private.stderr.log"
stdout_path "#{APP_PATH}/log/unicorn_private.stdout.log"

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  old_pid = File.join(shared_path, 'pids/unicorn.pid.oldbin')
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
