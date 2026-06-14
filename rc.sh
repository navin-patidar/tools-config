
export TOOLS_CONFIG_DIR=$(dirname $(realpath "$0"))

source "${TOOLS_CONFIG_DIR}/zshrc.sh"
bash_rc_files=$(find "${TOOLS_CONFIG_DIR}/configs" -type f -name \*.rc.sh | sort)

for file_to_load in ${(f)bash_rc_files};
do
    echo $file_to_load
    source $file_to_load
done
