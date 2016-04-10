#!/sbin/runscript
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

pidfile="/var/run/ovirt-engine.pid"
command="/usr/share/ovirt-engine/services/ovirt-engine/ovirt-engine.py"
command_args="--redirect-output ${OVIRT_ENGINE_EXTRA_ARGS} start"
command_background="yes"
start_stop_daemon_args="--user ovirt:ovirt"

depend() {
	use logger
	need net
	need postgresql
}

start_pre() {
	ulimit -n ${NOFILE:-65535}
	mkdir -p /var/cache/ovirt-engine
	chown ovirt:ovirt /var/cache/ovirt-engine
}
