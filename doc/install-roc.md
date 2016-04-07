# ROC installation instructions

How to install and configure a rest-on-couch server with built-in view manager.

## Step 1: Install Node.js

### Create the "nodejs" account

```bash
useradd nodejs --comment "Node.js Administrator" --home-dir /usr/local/node --user-group
chmod 755 /usr/local/node
```

### Download and install latest Node.js version

```bash
mkdir -p /usr/local/node
cd /usr/local/node
NODE_LATEST=$(curl -s https://nodejs.org/dist/index.tab | cut -f 1 | sed -n 2p)
curl -s https://nodejs.org/dist/${NODE_LATEST}/node-${NODE_LATEST}-linux-x64.tar.xz | tar --xz --extract
ln -fs node-${NODE_LATEST}-linux-x64 latest
chown -R nodejs /usr/local/node
```

### Add Node.js bin directory to the PATH for nodejs

```bash
echo 'PATH=${PATH}:/usr/local/node/latest/bin' >> /usr/local/node/.bashrc
```

## Step 2: Install PM2

```bash
mkdir -p /usr/local/pm2
chown nodejs /usr/local/pm2
su nodejs -l -c "npm install -g pm2@latest"
```

## Step 3: Install rest-on-couch

### Download ROC and install dependencies

```bash
su nodejs -l
cd /usr/local/node
git clone https://github.com/cheminfo/rest-on-couch.git
cd rest-on-couch
npm install
```

### Create rest-on-couch home directory

```bash
mkdir -p /usr/local/rest-on-couch
chown nodejs /usr/local/rest-on-couch
```

### Create PM2 config

Create a file in `/usr/local/pm2/rest-on-couch.json` with the following content:

```json
{
  "name"        : "rest-on-couch",
  "script"      : "bin/rest-on-couch-server.js",
  "cwd"         : "/usr/local/node/rest-on-couch",
  "env"         : { "DEBUG": "couch:error,couch:warn,couch:debug", "REST_ON_COUCH_HOME_DIR": "/usr/local/rest-on-couch" },
  "exec_mode"   : "cluster_mode",
  "instances"   : 4 
}
```

### Create rest-on-couch config

