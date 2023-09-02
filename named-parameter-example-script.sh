#!/usr/bin/env bash
# or /bin/sh for a "portable" shebang
# from: https://chat.openai.com/share/eb829ebf-5e05-4e7a-8a00-d5074923f22d

# Initialize variables
name=""
age=""
email=""

usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  name=VALUE    Set the name"
  echo "  age=VALUE     Set the age"
  echo "  email=VALUE   Set the email"
  echo "  help          Show this help message"
  echo
  echo "Example:"
  echo "  $0 name=John age=30 email=john@example.com"
}

parse_arguments() {
  if [[ "$#" -eq 0 ]]; then
    usage
    exit 0
  fi

  for arg in "$@"; do
    # Split argument into key and value
    key="${arg%%=*}"
    value="${arg#*=}"

    # Check if the key and value are the same, indicating that the '=' sign was missing
    if [[ "$key" == "$value" ]]; then
      echo "Invalid argument '$key' expecting '$key=...'"
      usage
      exit 1
    fi

    # Remove quotes if value is wrapped with them
    value="${value%\"}"
    value="${value#\"}"

    # Process the arguments
    case "$key" in
      name)
        name="$value"
        ;;
      age)
        age="$value"
        ;;
      email)
        email="$value"
        ;;
      help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown parameter: $key"
        usage
        exit 1
        ;;
    esac
  done
}

# Parse the arguments
parse_arguments "$@"

# Output the parameters
echo "Name: $name"
echo "Age: $age"
echo "Email: $email"
