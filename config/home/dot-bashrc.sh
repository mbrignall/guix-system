
# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n "$SSH_CLIENT" ]] && source /etc/profile

    # Don't do anything else.
    return
fi

# Source the system-wide file.
if [[ -e /etc/bashrc ]]; then
    source /etc/bashrc
fi

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
    PS1="\[\e[38;5;165m\]\u\[\e[38;5;171m\]@\[\e[38;5;213m\]\h \[\e[38;5;219m\]\w \[\033[0m\]$ [env]"
else
    PS1="\[\e[38;5;165m\]\u\[\e[38;5;171m\]@\[\e[38;5;213m\]\h \[\e[38;5;219m\]\w \[\033[0m\]$ "
fi
