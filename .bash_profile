# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

export PATH=$PATH:$HOME/bin:/usr/sbin:/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:${HOME}/.cabal/bin
export MANPATH=$MANPATH:/opt/local/share/man:/opt/local/man
export LESSOPEN="|/usr/bin/lesspipe.sh  %s"
 

#timestamp=`date "+%Y%m%d-%H%M%S"`
#logfile="$HOME/Desktop/log/terminal-$timestamp.log"
#script $logfile


. ~/.profile

