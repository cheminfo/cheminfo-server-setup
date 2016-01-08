## global custom bashrc

# add Node.js bin directory to the PATH
if
  ! echo $PATH | grep "node/latest/bin"
then
  PATH=${PATH}:/usr/local/node/latest/bin
fi
