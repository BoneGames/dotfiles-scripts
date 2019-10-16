# Remove existing ssh-agent socket if no ssh-agent is using it, otherwise tmux ssh-agent will fail to start
SSH_AGENT_EXISTS=$(ps aux | grep $SSH_AUTH_SOCK | grep -vc grep || echo $?)
SSH_SOCKET_EXISTS=$(test -f $SSH_AUTH_SOCK || echo $?)
if [ "$SSH_AGENT_EXISTS" -eq 0 ] && [ "$SSH_SOCKET_EXISTS" -eq 1 ]; then
  pkill -f ssh-agent
  rm $SSH_AUTH_SOCK 2>/dev/null
fi

# Start the tmux server for long lived services
tmux start-server

# Make ssh-agent available to tmux clients
tmux set-environment SSH_AGENT_PID $SSH_AGENT_PID
tmux set-environment SSH_AUTH_SOCK $SSH_AUTH_SOCK

# Start X server
tmux new-session \
  -d \
  -s xorg \
  xinit /usr/bin/i3 -- $DISPLAY vt2 \
  2>/dev/null

# Start autorandr
tmux new-session \
  -d \
  -s autorandr \
  ~/.config/scripts/monitor-hotplug.sh \
  2>/dev/null

# Start cloudstorage
if [ -d ~/.ssh-private ]; then
  tmux new-session \
    -d \
    -s cloudstorage \
    'CLOUD_COMPUTER_HOST_ID=jackson \
    CLOUD_COMPUTER_REDIRECT_URI=https://localhost:12345 \
    cloudstorage-fuse -f -d -o allow_other,auto_unmount ~/cloudstorage' \
    2>/dev/null
fi

# Start desktop environment shell
tmux new-session \
  -d \
  -s desktop-environment-shell \
  zsh --login \
  2>/dev/null

# Start hotkeys
tmux new-session \
  -d \
  -s sxhkd \
  sxhkd \
  2>/dev/null

# Start irc
if [ -d ~/.ssh-private ]; then
  tmux new-session \
    -d \
    -s irc \
    irssi \
    2>/dev/null
fi

# Start openvpn
if [ -d ~/.ssh-private ]; then
  tmux new-session \
    -d \
    -s openvpn \
    sudo openvpn \
    --config ~/.config/openvpn/sydney.ovpn \
    --auth-user-pass ~/.config/openvpn/credentials \
    --dev-node ~/.config/openvpn/tun \
    2>/dev/null
fi

# Start rescuetime
if [ -d ~/.ssh-private ]; then
  tmux new-session \
    -d \
    -s rescuetime \
    rescuetime \
    2>/dev/null
fi

# Start transmission
tmux new-session \
  -d \
  -s transmission \
  transmission-daemon \
  --bind-address-ipv4 localhost \
  --config-dir $HOME/.config/transmission \
  --download-dir $HOME/torrents \
  --foreground \
  --no-auth \
  --rpc-bind-address localhost \
  --watch-dir $HOME/torrents/.watch \
  2>/dev/null

# Start the ssh-agent
tmux new-session \
  -d \
  -s ssh-agent \
  ssh-agent -D -a $SSH_AUTH_SOCK \
  2>/dev/null

# Swap caps lock and escape
setxkbmap -option caps:swapescape

# Swap right alt and right control
setxkbmap -option ctrl:ralt_rctrl
setxkbmap -option ctrl:rctrl_ralt

# Map print screen to menu
xmodmap -e "keycode 107 = Menu"

# Enable numlock
numlockx on

# Set keyboard repeat delay and rate
xset r rate 180 140
