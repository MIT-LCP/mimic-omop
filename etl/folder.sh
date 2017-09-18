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
	echo 'omop_table,omop_column,omop_required,omop_type,mimic_table,mimic_column,mimic_type,comments' > "$folder/$file/mapping.csv"
	grep -e "^|" "$f" |sed '/^Field/ d'|sed '/^:--/ d'|sed "s/'/''/g" |sed "s/|[ ]\{0,10\}\([a-z_]*\).*|[ ]\{0,10\}\([A-Za-z]*\).*|[ ]\{0,10\}\([A-Za-z()0-9 ]*\).*|.*|/$file,\1,\2,\3,,,,/g" >> "$folder/$file/mapping.csv"
    else
        echo "$f doesn't match" >&2 # this could get noisy if there are a lot of non-matching files
    fi
	rm "$f"
done
