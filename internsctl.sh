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
    esac
}

# Check for arguments
if [ "$1" ]; then
    main "$@"
else
    display_help
fi
