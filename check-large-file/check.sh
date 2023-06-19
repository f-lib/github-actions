FILE_SIZE_LIMIT_KB=$1
CURRENT_DIR="$(pwd)"
HAS_ERROR=""
COUNTER=0

files=$(git ls-files)
while read -r file; do
	if [ "$file" = "" ]; then
		continue
	fi
	file_path=$file
	file_size=$(ls -l "$file_path" | awk '{print $5}')
	file_size_kb=$((file_size / 1024))
	if [ "$file_size_kb" -ge "$FILE_SIZE_LIMIT_KB" ]; then
		echo "${file} has size ${file_size_kb}KB, over commit limit ${FILE_SIZE_LIMIT_KB}KB."
		HAS_ERROR="YES"
		((COUNTER++))
	fi
done <<< "$files"

if [ "$HAS_ERROR" != "" ]; then
	echo "$COUNTER files are larger than permitted, please fix them before commit"
	exit 1
fi

exit 0