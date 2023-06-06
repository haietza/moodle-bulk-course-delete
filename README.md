# Moodle Bulk Course Deletes
Use this script to bulk delete courses in Moodle by course ID.

# Setup
- Put course IDs to be deleted in text file, one per line
- Update bulk-course-delete.sh:
  - IN_FILE: Text file with course IDs to be deleted
  - LOG_FILE: Location of logs for script
  - BREAK_FILE: Location of breakfile for script
  - MOODLE_DIR: Location of Moodle instance

# Run
Run script as apache user in background ./bulk-course-delete.sh &

# Notes
- Keep an eye on the database server space; if lots of (large) courses are being deleted, the binary log files can grow rapidly due to the high number of delete transactions
- Database optimization is recommended after deletes are completed
- If the script needs to be stopped for any reason, simply create a breakfile.txt in the designated BREAK_FILE location and it will exit the loop through course IDs
- The Moodle CLI delete_course script is used with the recycle bin disabled so backup files of courses are not created during the delete process
- Caches are purged at the end of the script

