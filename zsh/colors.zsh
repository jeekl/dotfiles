# set colors for use in prompts
if zrcautoload colors && colors 2>/dev/null ; then
    BLUE="%{${fg[blue]}%}"
    BOLD_BLUE="%{${fg_bold[blue]}%}"
    RED="%{${fg[red]}%}"
    BOLD_RED="%{${fg_bold[red]}%}"
    GREEN="%{${fg[green]}%}"
    CYAN="%{${fg[cyan]}%}"
    BOLD_CYAN="%{${fg_bold[cyan]}%}"
    MAGENTA="%{${fg[magenta]}%}"
    YELLOW="%{${fg[yellow]}%}"
    WHITE="%{${fg[white]}%}"
    NO_COLOUR="%{${reset_color}%}"
else
    BLUE=$'%{\e[1;34m%}'
    RED=$'%{\e[1;31m%}'
    GREEN=$'%{\e[1;32m%}'
    CYAN=$'%{\e[1;36m%}'
    WHITE=$'%{\e[1;37m%}'
    MAGENTA=$'%{\e[1;35m%}'
    YELLOW=$'%{\e[1;33m%}'
    NO_COLOUR=$'%{\e[0m%}'
fi

c=()
c+="%F{237}"  # 1.  Prompt decoration
c+="%F{143}"  # 2.  Hostname
c+="%F{160}"  # 3.  Hostname root
c+="%F{067}"  # 4.  Directory
c+="%F{096}"  # 5.  Directory non-multi
c+="%F{196}"  # 6.  Error
c+="%F{184}"  # 7.  Jobs
c+="%F{067}"  # 8.  Clock
c+="%F{195}"  # 9.  Mail
c+="%F{062}"  # 10. Battery percent
c+="%F{063}"  # 11. Battery timeleft
c+="%F{196}"  # 12. TMOUT
c+="%F{066}"  # 13. CVS System
c+="%F{214}"  # 14. CVS Repo
c+="%F{083}"  # 15. CVS Clean
c+="%F{160}"  # 16. CVS Unstaged
c+="%F{095}"  # 17. CVS Action
c+="%F{202}"  # 18. CVS Staged / Debug
c+="%F{120}"  # 19. Enabled / Success
c+="%F{240}"  # 20. Disabled
c+="%F{067}"  # 21. Doc: Function
c+="%F{240}"  # 22. Doc: Undocumented
c+="%F{148}"  # 23. Doc: File
c+="%F{048}"  # 24. Comp: Descriptions
c+="%F{067}"  # 25. Comp: Directories
c+="%F{196}"  # 26. Comp: Corrections
c+="%F{045}"  # 27. IP Adress
c+="%F{123}"  # 28. CVS Super repo

export c
