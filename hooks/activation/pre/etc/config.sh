EK_SOURCECONFIG_DIR="/etc/eureka/sourceconfig"
EK_DESTCONFIG_DIR="/etc/eureka/destconfig"
ORACLE_PATH=/usr/lib/oracle/11.2/client64/bin
LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib:$LD_LIBRARY_PATH
TNS_ADMIN=/etc/oracle-instantclient

source "${0%/*}/etc/config_local.sh"

LOG_FILE="${0%/*}/log/hook.log"

if [ ! -f "${0%/*}/log" ] ; then
    mkdir "${0%/*}/log"
fi

function ek_log {
    echo -e `date +"%b %d, %Y %H:%M:%S"` "$1" >>$LOG_FILE
}

function ek_execute_sql {
    typeset user_at=$ORACLE_USER@$ORACLE_SID
    ek_log "Connecting to Oracle as $user_at"
    $ORACLE_PATH/sqlplus -s $user_at/$ORACLE_PSWD<<SQL
$1
SQL
    typeset error_code=$?
    if [ $error_code -ne 0 ]; then
        ek_log "Error when executing SQL commands: $error_code"
        exit 1
    fi
}

function ek_die {
    typeset msg="$NACOR_SCRIPT_NAME failed: $1."               
    nacor_log "$msg"
    echo $msg 1>&2
    $NACOR_DW_DIR/dw_notice_dw "$msg"
    if [ ! -f $NACOR_HOLD_UPLOAD ] ; then
        $NACOR_BIN_DIR/hold_create
    fi
    exit 1    
}

function ek_die_if {
    if [ $? -ne 0 ] ; then
        ek_die "$1"
    fi
}
