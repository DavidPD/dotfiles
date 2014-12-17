FILES_PATTERN='\.(js|coffee|php)(\..+)?$'
FORBIDDEN='DD:\s?debug'
git diff --cached --name-only | \
	GREP_COLOR='4;5;37;41' \
	xargs grep --with-filename -n -E $FORBIDDEN && echo 'debugging references found, please remove before commiting' && exit 1
exit 0