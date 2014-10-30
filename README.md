Docker! Dropbox! XPRA!
==========================

Run Dropbox inside an isolated [Docker](http://www.docker.io) container on your Linux desktop!

Known Issue: While audio works flawlessly during calls and Dropbox is perfectly usable, the notification sounds such as call ringing do not work.


Building Instructions
=====================

1. Build the container

        docker build -t dropbox .

2. Run the container and forward the appropriate port

        mkdir -p $HOME/Dropbox $HOME/.dropbox
        docker run -d -v $HOME/Dropbox:/home/docker/Dropbox -v $HOME/.dropbox:/home/docker/.dropbox -p 127.0.0.1:22222:22 dropbox

3. Run dropbox with XPRA

        xpra start ssh:docker@localhost:22222:10 --start-child=dropbox
