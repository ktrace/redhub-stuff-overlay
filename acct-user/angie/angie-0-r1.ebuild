# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID="82"
ACCT_USER_GROUPS=( "angie" )
ACCT_USER_HOME="/var/lib/angie"

acct-user_add_deps
