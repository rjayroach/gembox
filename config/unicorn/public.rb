# unicorn.rb
APP_NAME = 'gembox'
SOCKET_NAME = "/tmp/unicorn.#{APP_NAME}_public.sock"
APP_PATH = File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__))))

worker_processes 2
preload_app true

working_directory APP_PATH
listen "unix:#{SOCKET_NAME}", backlog: 512
timeout 90

pid APP_PATH + "/tmp/pids/unicorn_public.pid"

stderr_path "#{APP_PATH}/log/unicorn_public.stderr.log"
stdout_path "#{APP_PATH}/log/unicorn_public.stdout.log"

preload_app true
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end
