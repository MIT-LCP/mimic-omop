#!/bin/bash
# goal: initiate the mapping files, from omop documentation

find ~/git/CommonDataModel/Documentation/CommonDataModel_Wiki_Files/ -type d -name "Standard*" -exec cp -a {} . \;

regex="^(.*)/([A-Z_]+).md"
for f in Standardized*/*.md
do # Whitespace-safe but not recursive.
    if [[ $f =~ $regex ]]
    then
	folder="${BASH_REMATCH[1]}"
	file="${BASH_REMATCH[2]}"
	mkdir -p "$folder/$file/"
	echo 'omop_table,omop_column,mimic_table,mimic_column,comments' > "$folder/$file/mapping.csv"
	grep -e "^|" "$f" |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/''/g" |sed "s/|[ ]\{0,10\}\([a-z_]*\).*|.*|.*|.*|/$file,\1,,,/g" >> "$folder/$file/mapping.csv"
	rm "$f"
    else
        echo "$f doesn't match" >&2 # this could get noisy if there are a lot of non-matching files
    fi
done
