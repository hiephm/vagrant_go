export JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre
setopt rm_star_silent
unsetopt nomatch

transfer() { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }

alias zshconfig="vim ~/.zshrc"
source /vagrant/conf/shell/.bash_aliases
unset LSCOLORS
unset LS_COLORS

export GOPATH=/work
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

