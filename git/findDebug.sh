pipe_if_not_empty () {
  head=$(dd bs=1 count=1 2>/dev/null; echo a)
  head=${head%a}
  if [ ! $head == $'\n' ]; then
    { printf %s "$head"; cat; } | "$@"
  fi
}
FILES_PATTERN='\.(js|coffee|php)(\..+)?$'
FORBIDDEN='DD:\s?debug'
git diff --cached --name-only | pipe_if_not_empty \
	GREP_COLOR='4;5;37;41' \
	xargs grep --with-filename -n -E $FORBIDDEN && echo 'debugging references found, please remove before commiting' && exit 1
exit 0