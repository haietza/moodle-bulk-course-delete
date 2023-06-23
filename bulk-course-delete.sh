#!/bin/bash

export BASE_DIR="/var/www/moosh"
export IN_FILE="$BASE_DIR/delete-course-list.txt"
export LOG_FILE="$BASE_DIR/logs/delete-course-log-`date +%Y%m%d%H%M`.txt"
export BREAK_FILE="$BASE_DIR/breakfile.txt"

export MOODLE_DIR="/var/www/html"

# DO SOME SANITY CHECKS
if [ ! -d `dirname $LOG_FILE` ]; then
  mkdir -p `dirname $LOG_FILE` || exit 1
fi

echo "Start bulk course delete" > $LOG_FILE

if [ ! -f $IN_FILE ]; then
  echo "No input file found" >>$LOG_FILE
  exit 1
fi

if [ ! -d $MOODLE_DIR ]; then
  echo "No Moodle dir found ($MOODLE_DIR)" >>$LOG_FILE
  exit 1
fi

cd $MOODLE_DIR

while read courseid; do
  # CHECK FOR BREAK FILE; WE CAN CREATE FILE IF WE NEED LOOP TO BREAK
  if [ -f $BREAK_FILE ]; then
    echo "breaking out of course deletes script" >>$LOG_FILE
    break
    exit 1
  fi

  echo "`date +%Y%m%d%H%M`: delete course with id $courseid" >>$LOG_FILE
  php admin/cli/delete_course.php --courseid="$courseid" --disablerecyclebin --showdebugging --non-interactive >>$LOG_FILE 2>&1
done < $IN_FILE

echo "`date +%Y%m%d%H%M`: clear cache" >>$LOG_FILE 2>&1
php admin/cli/purge_caches.php >>$LOG_FILE 2>&1
