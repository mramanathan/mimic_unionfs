#!/bin/bash

basedir="${HOME}"
mount_root="${basedir}/test"

if [[ -d "${mount_root}" ]];
then
    echo "[mimic_unionfs]: ${mount_root} exists!"
else
    echo "[mimic_unionfs]: Creating the mount root dir, ${mount_root}"
    cd ${basedir} && mkdir -p ${mount_root}
fi

test_dirs=("lower" "upper" "merged" "work")

echo "[mimic_unionfs]: Creating the test dirs in ${mount_root}"
for this_dir in "${test_dirs[@]}"
do
    echo "[mimic_unionfs]: Creating the test dir, ${this_dir}"
    cd ${mount_root} && mkdir -p ${this_dir}
done

echo "I'm from lower dir!" > ${mount_root}/${test_dirs[0]}/in_lower.txt 
echo "I'm from upper dir!" > ${mount_root}/${test_dirs[1]}/in_upper.txt
# `in_both` is in both directories
echo "I'm from lower dir!" > ${mount_root}/${test_dirs[0]}/in_both.txt 
echo "I'm from upper dir!" > ${mount_root}/${test_dirs[1]}/in_both.txt 

echo "[mimic_unionfs]: Mounting the test dirs using overlay driver..."
mount -t overlay overlay -o lowerdir=${mount_root}/${test_dirs[0]},upperdir=${mount_root}/${test_dirs[1]},workdir=${mount_root}/${test_dirs[3]} ${mount_root}/${test_dirs[2]}