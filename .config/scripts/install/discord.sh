# Install discord
RUN wget -q -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb" && \
  dpkg -i discord.deb || apt-get install -qq --fix-broken && \
  rm discord.deb
