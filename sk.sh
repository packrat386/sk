#!/usr/bin/env bash

SK_SCRIPT_DIR="${SK_SCRIPT_DIR:=$HOME/sk}"

_sk_usage() {
  echo "sk r(un)? <script> <args...> to run <script> with <args...>"
  echo "sk l(ist)? to show the list of availble scripts"
  echo "sk c(at)? <script> to print the named script"
  echo "sk s(ave)? <file> to save the file as a script for sk to run (must be executable)"
  echo "sk h(elp)? to show this usage message"
  echo ""
  echo "the variable SK_SCRIPT_DIR should point to a directory where the scripts live and it defaults to ~/sk"
  echo ""
  echo "sk home page: https://github.com/packrat386/sk"
}

_sk_ensure_script_dir() {
  if [ ! -d "${SK_SCRIPT_DIR}" ]; then
    echo "SK_SCRIPT_DIR (${SK_SCRIPT_DIR}) doesn't exist, creating it"
    mkdir "${SK_SCRIPT_DIR}"
  fi
}

_sk_error_with_usage() {
  printf "error: %s\n\n" "$1" >&2
  _sk_usage >&2
  return 1
}

_sk_list() {
  _sk_ensure_script_dir

  echo "$(find $SK_SCRIPT_DIR -type f -exec bash -c 'test -x {} && basename {}' \;)"
}

_sk_run() {
  _sk_ensure_script_dir

  local to_run=$1; shift

  if [ -z "${to_run}" ]; then
    _sk_error_with_usage "script name required"; return
  fi
  
  "${SK_SCRIPT_DIR}/${to_run}" "$@"
}

_sk_cat() {
  _sk_ensure_script_dir

  local to_run=$1; shift

  if [ -z "${to_run}" ]; then
    _sk_error_with_usage "script name required"; return
  fi
  
  cat "${SK_SCRIPT_DIR}/${to_run}"
}

_sk_save() {
  _sk_ensure_script_dir
  
  local to_save=$1; shift

  if [ -z "${to_save}" ]; then
    _sk_error_with_usage "script name required"; return
  fi
  

  if [ -x $to_save ]; then
    cp "${to_save}" "${SK_SCRIPT_DIR}/"
  else
    printf "error: ${to_save} is not executable"
    return 1
  fi
}

sk() {
  local cmd=${1}; shift

  case ${cmd} in
    l | list)
      _sk_list
      ;;
    r | run)
      _sk_run "$@"
      ;;
    c | cat )
      _sk_cat "$@"
      ;;
    s | save)
      _sk_save "$@"
      ;;
    h | help)
      _sk_usage
      ;;
    *)
      _sk_error_with_usage "command not recognized"; return
      ;;
  esac
}

_sk_completions() {
  if [ "${COMP_CWORD}" == "1" ]; then
    COMPREPLY=($(compgen -W "list run cat save help" "${COMP_WORDS[1]}"))
  else
    local base_cmd="${COMP_WORDS[1]}"
    local available_cmds=$(_sk_list)

    case ${base_cmd} in
      r | run)
        if [ "${COMP_CWORD}" == "2" ]; then
          COMPREPLY=($(compgen -W "${available_cmds}" "${COMP_WORDS[2]}"))
        else
          COMPREPLY=($(compgen -o default -o bashdefault "${COMP_WORDS[$COMP_CWORD]}"))
        fi
        ;;
      c | cat)
        if [ "${COMP_CWORD}" == "2" ]; then
          COMPREPLY=($(compgen -W "${available_cmds}" "${COMP_WORDS[2]}"))
        else
          return
        fi
        ;;
      s | save)
        if [ "${COMP_CWORD}" == "2" ]; then
          COMPREPLY=($(compgen -o default -o bashdefault "${COMP_WORDS[2]}"))
        else
          return
        fi
        ;;
      l | list | h | help)
        return
        ;;
      *)
        return
        ;;
    esac
  fi
}

complete -F _sk_completions sk
