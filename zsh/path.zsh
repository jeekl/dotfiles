export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:~/bin
export PATH=/usr/share/perl5/vendor_perl/auto/share/dist/Cope:$PATH
#export PATH=/var/lib/gems/1.9.1/bin:$PATH # Ruby gems, for rails, among other things
export PATH=/opt/java/jre/bin:$PATH
export PATH=/usr/lib/perl5/vendor_perl/bin/:/usr/bin/site_perl:/usr/bin/venor_perl:$PATH
export PATH=~/bin:$PATH
# Perlbrew - custom versions of perl (This script basically just adds the perlbrew path to PATH)
#source /home/jeff/perl5/perlbrew/etc/bashrc
# Ruby Gems
#export PATH=/var/lib/gems/1.9.1/bin:$PATH # Ruby gems, for rails, among other things
# RVM
if [[ -s /home/jeff/.rvm/scripts/rvm ]] ; then source /home/jeff/.rvm/scripts/rvm ; fi


# make python prompt nicer
export PYTHONSTARTUP="$HOME/.config/dotfiles/python-prompt-rc.py"
