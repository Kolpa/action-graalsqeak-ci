readonly ANSI_BOLD="\033[1m"
readonly ANSI_RED="\033[31m"
readonly ANSI_GREEN="\033[32m"
readonly ANSI_YELLOW="\033[33m"
readonly ANSI_BLUE="\033[34m"
readonly ANSI_RESET="\033[0m"
readonly ANSI_CLEAR="\033[0K"


################################################################################
# Run a .st script located in $SMALLTALK_CI_BUILD
################################################################################
run_script() {
  local script="/smalltalkCI/build/$1"
  local vm_flags="--squeaksmalltalk.Headless=true"
  local resolved_vm="/opt/graalvm-ce-19.0.0/bin/graalsqueak"
  local resolved_image="/graalsqueak-0.8/graalsqueak-0.8.image"

  "${resolved_vm}" ${vm_flags} "${resolved_image}" "${script}"
}

################################################################################
# Ensure smalltalkCI is loaded and test project.
################################################################################
test_project() {
  cat >"/smalltalkCI/build/test.st" <<EOL
  | smalltalkCI |
  smalltalkCI := Smalltalk at: #SmalltalkCI.
  smalltalkCI load: '${GITHUB_WORKSPACE}/.smalltalk.ston'.
  smalltalkCI test: '${GITHUB_WORKSPACE}/.smalltalk.ston'.
  smalltalkCI quitImage
EOL

  run_script "test.st"

  printf "\n\n"
}

is_file() {
  local file=$1

  [[ -f $file ]]
}

print_error() {
  printf "${ANSI_BOLD}${ANSI_RED}%s${ANSI_RESET}\n" "$1" 1>&2
}

print_error_and_exit() {
  print_error "$1"
  exit "${2:-1}" # 2nd parameter, 1 if not set
}

signals_error() {
  [[ $1 != "[success]" ]]
}

finalize() {
  local build_status

  if ! is_file "/graalsqueak-0.8/build_status.txt"; then
    print_error_and_exit "Build was unable to report final build status."
  fi
  build_status=$(cat "/graalsqueak-0.8/build_status.txt")
  if signals_error "${build_status}"; then
    if [[ "${build_status}" != "[test failure]" ]]; then
      print_error_and_exit "${build_status}"
    fi
    exit 1
  else
   exit 0
  fi
}

test_project
finalize