FILES_PATTERN='\.(js|coffee|php)(\..+)?$'
FORBIDDEN='DD:\s?debug'

pipe_if_not_empty () {
  head=$(dd bs=1 count=1 2>/dev/null; echo a)
  head=${head%a}
  if [ ! $head == $'\n' ]; then
    { printf %s "$head"; cat; } | "$@"
  fi
}

# exit if there are no changes, makes `git commit --amend` work.
git diff-index --quiet head && exit 0

# TODO: make this use the actual diff instead of searching the file on disk.
# Searching the file on disk makes the script succeed if changes have been made but not added.
git diff --cached --name-only | pipe_if_not_empty \
	xargs grep --with-filename -i -n -E $FORBIDDEN && echo 'debugging references found, please remove before commiting' && exit 1
exit 0