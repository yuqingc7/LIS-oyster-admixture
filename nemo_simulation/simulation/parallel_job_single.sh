#!/bin/bash -l

# this script parallel runs nemo simulation jobs

## start date
start=`date +%s`

# while IFS= read -r file; do
#   # Check if the file exists
#   if [ -e "$file" ]; then
#     # Execute the command on each file
#     echo "executing $file"
#     ./nemo "$file"
#   else
#     echo "File not found: $file"
#   fi
# done < s40_ini.list

cat single_ini.list | parallel '
  if [ -e "{}" ]; then
    echo "Executing {}"
    ./nemo "{}"
  else
    echo "File not found: {}"
  fi
'

# end date
end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"
