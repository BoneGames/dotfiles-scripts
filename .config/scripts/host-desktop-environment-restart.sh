# get git username
GIT_USERNAME=$(git config user.username)

# Restart desktop environment on the host
~/.config/scripts/ssh-host.sh tmux new-session -d /home/$USER/repositories/$GIT_USERNAME/desktop-environment/docker/scripts/restart.sh
