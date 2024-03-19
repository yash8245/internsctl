#!/bin/bash

VERSION="v0.1.0"

function display_version {
    echo "$VERSION"
}

function display_help {
    echo "Usage: internsctl [OPTION]"
    echo "Custom command for managing interns."
    echo ""
    echo "Options:"
    echo "  -v --version             Display the version information."
    echo "  -h --help                Display this help message."
    echo "  cpu getinfo           Display CPU information."
    echo "  memory getinfo        Display memory information."
    echo "  user create <username>  Create a new user."
    echo "  user list             List all regular users."
    echo "  user list --sudo-only List users with sudo permissions."
    echo "  file getinfo <file-name>  Get information about a file."
    echo ""
    echo "Example:"
    echo "  internsctl -v --version                 Display version information."
    echo "  internsctl -h --help                    Display help message."
    echo "  internsctl cpu getinfo               Display CPU information."
    echo "  internsctl memory getinfo            Display memory information."
    echo "  internsctl user create john          Create a new user 'john'."
    echo "  internsctl user list                 List all regular users."
    echo "  internsctl user list --sudo-only     List users with sudo permissions."
    echo "  internsctl file getinfo <file-name>  Get information about a file."
    echo ""
}

function get_cpu_info {
    lscpu
}

function get_memory_info {
    free
}

function create_user {
    local username="$1"
    
    if [ -z "$username" ]; then
        echo "Please provide a username. Usage: internsctl user create <username>"
        return 1
    fi

    if id "$username" >/dev/null 2>&1; then
        echo "User '$username' already exists."
        return 1
    fi

    sudo useradd -m "$username"
    echo "User '$username' created successfully."
}

function list_users {
    local sudo_group=''
    
    if [ "$1" = "--sudo-only" ]; then
        if grep -q '^sudo:' /etc/group; then
            sudo_group='sudo'
        elif grep -q '^wheel:' /etc/group; then
            sudo_group='wheel'
        elif grep -q '^admin:' /etc/group; then
            sudo_group='admin'
        else
            echo "Unable to find sudo group."
            exit 1
        fi

        grep -E "^$sudo_group" /etc/group | cut -d: -f4 | tr ',' '\n'
    else
        awk -F':' '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd
    fi
}


function main {
    case "$1" in
        -v | --version)
            display_version
            ;;
        -h | --help)
            display_help
            ;;
        cpu)
            case "$2" in
                getinfo)
                    get_cpu_info
                    ;;
                *)
                    echo "Invalid usage. Run 'internsctl --help' for usage instructions."
                    ;;
            esac
            ;;
        memory)
            case "$2" in
                getinfo)
                    get_memory_info
                    ;;
                *)
                    echo "Invalid usage. Run 'internsctl --help' for usage instructions."
                    ;;
            esac
            ;;
        user)
            case "$2" in
                create)
                    create_user "$3"
                    ;;
                list)
                    list_users "$3"
                    ;;
                *)
                    echo "Invalid usage. Run 'internsctl --help' for usage instructions."
                    ;;
            esac
            ;;
        file)
            case "$2" in
                getinfo)
                    get_file_info "$3"
                    ;;
                *)
                    echo "Invalid usage. Run 'internsctl --help' for usage instructions."
                    ;;
            esac
            ;;
        *)
            echo "Invalid usage. Run 'internsctl --help' for usage instructions."
            ;;
    esac
}

# Check for arguments
if [ "$1" ]; then
    main "$@"
else
    display_help
fi
