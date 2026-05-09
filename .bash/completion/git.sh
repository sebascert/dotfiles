GIT_BASH_COMPLETION="$HOME/.bash/completion/git.completion.sh"

if [ ! -f "$GIT_BASH_COMPLETION" ];then
    curl -Lo "$GIT_BASH_COMPLETION" \
        "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash"
    source "$GIT_BASH_COMPLETION"
fi
