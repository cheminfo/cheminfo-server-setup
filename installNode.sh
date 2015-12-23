
#######################
## INSTALLING NODEJS ##
#######################

installNode() {
  yum --assumeyes install curl > /dev/null

  message "Checking if node is installed"
  if node --version &> /dev/null; then
    if node --version | grep -q "v[567]"; then
      ok
      info "Already installed and version is ok"
    else
      error
      info "Node version is too old, please remove it"
    fi
    return
  else
    ok
    info "Node not installed"
  fi

  message "Checking if username nodejs exists"
  if getent passwd nodejs >/dev/null 2>&1; then
    ok
    info "Username nodejs exists already"
  else
    useradd nodejs --comment "Node.js Administrator" --home-dir /usr/local/node --user-group --system --shell /bin/bash
    ok
    info "User nodejs was created"
  fi
  message "Installing node"
  mkdir -p /usr/local/node && cd /usr/local/node
  NODE_LATEST=$(curl -s https://nodejs.org/dist/index.tab | cut -f 1 | sed -n 2p)
  curl -s https://nodejs.org/dist/$NODE_LATEST/node-$NODE_LATEST-linux-x64.tar.xz | tar --xz --extract
  ln -fs node-$NODE_LATEST-linux-x64 latest
  ln -fs /usr/local/node/latest/bin/node /usr/local/bin/node
  ln -fs /usr/local/node/latest/bin/npm /usr/local/bin/npm
  chown -R nodejs /usr/local/node
  ok
  message "Installing pm2"
  su nodejs -c "npm install -g pm2 > /dev/null"
  env PATH=$PATH:/usr/local/node/latest/bin pm2 startup systemd -u nodejs --hp /usr/local/node > /dev/null
  ok
}

installNode