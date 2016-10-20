#!/bin/bash
UPLOAD=false
VARS_FILE=vars.txt
# read in the VERSION
source $VARS_FILE

while getopts "u" opt; do
    case $opt in
    u) UPLOAD=true ;;
    \?) ;; # Handle error: unknown option or missing required argument.
    esac
done

echo_log() {
  date +"%Y-%m-%d_%H:%M:%S.%3N: $1" 
}

echo_log "starting build for $HTMLAPP version: $VERSION ..."

echo_log "cleaning $BUILD_DIR ..."
rm -Rf $BUILD_DIR
echo_log "creating build directory structure $BUILD_APP_DIR ..."
mkdir -p $BUILD_APP_DIR
echo_log "copying files to $BUILD_APP_DIR ..."
rsync -a --exclude="$BUILD_DIR" --exclude='.*'  --exclude='*.sh' . $BUILD_APP_DIR
cd $BUILD_DIR
echo_log "creating archive $ARCHIVE_FILE ..."
tar -czf $ARCHIVE_FILE $BUILD_ARCHIVE_DIR
echo_log "listing $ARCHIVE_FILE contents ..."
tar -tvf $ARCHIVE_FILE
echo_log "build complete."

if [ "$UPLOAD" = true ]; then
	echo_log "uploading artifact..."
fi