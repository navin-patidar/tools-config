
export TOOLS_CONFIG_DIR=$(dirname $(realpath "$0"))
export XDG_CONFIG_HOME="${TOOLS_CONFIG_DIR}/configs"

bash_rc_files=$(find "${XDG_CONFIG_HOME}"  -type f -name \*.rc.sh)

for file_to_load in ${(f)bash_rc_files};
do
    echo $file_to_load
    source $file_to_load
    echo "loaded $file_to_load"
done
