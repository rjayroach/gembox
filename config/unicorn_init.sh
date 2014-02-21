#!/bin/sh

### BEGIN INIT INFO
# Red Hat
#
#  unicorn-mcp_app_pbx  :  Unicorn Worker for mcp_app_pbx
#
#  chkconfig: - 97 02
#  description: provides a unicorn worker process
#  processname: unicorn
#
#
#
# Debian
#
# Provides:          capri
# Required-Start:    $remote_fs $syslog 
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Run /etc/init.d/mcp_main if it exists
### END INIT INFO

set -e

UNICORN_USER=admin
UNICORN_APP_ROOT=/srv/prod/apps/geminabox/current
UNICORN_APP_SHARED=/srv/prod/apps/geminabox/shared
UNICORN_PID_FILE=$UNICORN_APP_SHARED/pids/unicorn.pid
UNICORN_CMD="$UNICORN_APP_ROOT/bin/unicorn -D -E production -c $UNICORN_APP_ROOT/config/unicorn.rb $UNICORN_APP_ROOT/config/rackup.ru"
#UNICORN_CONFIG_FILE=$UNICORN_APP_ROOT/config/init.conf
UNICORN_TIMEOUT=${TIMEOUT-60}
KILL=/bin/kill
action=""
set -u


OLD_PIN="$UNICORN_PID_FILE.oldbin"

sig() {
  test -s "$UNICORN_PID_FILE" && kill -$1 `cat $UNICORN_PID_FILE`
}


oldsig () {
  test -s $OLD_PIN && kill -$1 `cat $OLD_PIN`
}

run () {
  if [ "$(id -un)" = "$UNICORN_USER" ]; then
    eval $1
  else
    su -c "$1" - $UNICORN_USER
  fi
}

case "$1" in
start)
  sig 0 && echo >&2 "Already running" && exit 0
  run "$UNICORN_CMD"
  ;;
stop)
  sig QUIT && exit 0
  echo >&2 "Not running"
  ;;
force-stop)
  sig TERM && exit 0
  echo >&2 "Not running"
  ;;
restart|reload)
  sig HUP && echo reloaded OK && exit 0
  echo >&2 "Couldn't reload, starting '$UNICORN_CMD' instead"
  run ""
  ;;
upgrade)
  if sig USR2 && sleep 2 && sig 0 && oldsig QUIT
  then
    n=$UNICORN_TIMEOUT
    while test -s $OLD_PIN && test $n -ge 0
    do
      printf '.' && sleep 1 && n=$(( $n - 1 ))
    done
    echo

    if test $n -lt 0 && test -s $OLD_PIN
    then
      echo >&2 "$OLD_PIN still exists after $UNICORN_TIMEOUT seconds"
      exit 1
    fi
    exit 0
  fi
  echo >&2 "Couldn't upgrade, starting '$UNICORN_CMD' instead"
  run "$UNICORN_CMD"
  ;;
reopen-logs)
  sig USR1
  ;;
*)
  echo >&2 "Usage: $0 <start|stop|restart|upgrade|force-stop|reopen-logs>"
  exit 1
  ;;
esac

