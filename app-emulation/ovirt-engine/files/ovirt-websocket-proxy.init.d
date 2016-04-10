#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

pidfile="/var/run/ovirt-websocket-proxy.pid"
command="/usr/share/ovirt-engine/services/ovirt-websocket-proxy/ovirt-websocket-proxy.py"
command_args="${OVIRT_ENGINE_EXTRA_ARGS} start"
command_background="yes"
start_stop_daemon_args="--user ovirt:ovirt"

depend() {
	use logger
	need net
}

start_pre() {
	ulimit -n ${NOFILE:-65535}
	ulimit -n ${NPROC:-2048}
}
