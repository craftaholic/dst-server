#!/bin/bash

steamcmd_dir="$HOME/steamcmd"
install_dir="$HOME/downloaded"
cluster_name="MyDediServer"
dontstarve_dir="$HOME/.klei/DoNotStarveTogether"

function fail()
{
	echo Error: "$@" >&2
	exit 1
}

function check_for_file()
{
	if [ ! -e "$1" ]; then
		fail "Missing file: $1"
	fi
}

cd "$steamcmd_dir" || fail "Missing $steamcmd_dir directory!"

check_for_file "steamcmd.sh"
check_for_file "$dontstarve_dir/$cluster_name/cluster.ini"
check_for_file "$dontstarve_dir/$cluster_name/cluster_token.txt"
check_for_file "$dontstarve_dir/$cluster_name/Master/server.ini"
check_for_file "$dontstarve_dir/$cluster_name/Caves/server.ini"

./steamcmd.sh +force_install_dir $install_dir +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +app_update 343050 validate +quit

# Configure mod:
ds_mods_setup="$dontstarve_dir/$cluster_name/mods/dedicated_server_mods_setup.lua"
if [ -f "$ds_mods_setup" ]
then
  cp $ds_mods_setup "$HOME/downloaded/mods/"
fi

# Copy modoverrides.lua
modoverrides="$dontstarve_dir/$cluster_name/mods/modoverrides.lua"
if [ -f "$modoverrides" ]
then
  cp $modoverrides "$HOME/.klei/DoNotStarveTogether/DSTWhalesCluster/Master/"
  cp $modoverrides "$HOME/.klei/DoNotStarveTogether/DSTWhalesCluster/Caves/"
fi

check_for_file "$install_dir/bin"

cd "$install_dir/bin" || fail

run_shared=(./dontstarve_dedicated_server_nullrenderer)
run_shared+=(-cluster "$cluster_name")

"${run_shared[@]}" -shard Caves  | sed 's/^/Caves:  /' &
"${run_shared[@]}" -shard Master | sed 's/^/Master: /'
