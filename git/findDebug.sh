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
	xargs grep --with-filename -i -n -E $FORBIDDEN && echo 'debugging references found, please remove before commiting' && exit 1
exit 0