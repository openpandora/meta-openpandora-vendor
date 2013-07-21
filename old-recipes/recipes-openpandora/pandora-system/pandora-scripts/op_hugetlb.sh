#!/bin/sh

if [ "$#" -ne "1" ]; then
	echo "usage: $0 <megabytes>"
	exit 1
fi

if ! [ -e /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages ]; then
	echo "hugetlb error: no hugetlb support in kernel"
	exit 1
fi

pages_needed=$(( ($1 + 1) / 2 ))

# find amount of pages reserved or in use
pages_nr=`cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages`
pages_free=`cat /sys/kernel/mm/hugepages/hugepages-2048kB/free_hugepages`
pages_resv=`cat /sys/kernel/mm/hugepages/hugepages-2048kB/resv_hugepages`

pages_inuse_before=$(($pages_nr - $pages_free + $pages_resv))
pages_inuse_after=$(($pages_inuse_before + $pages_needed))

for a in `seq 5`; do
	echo $pages_inuse_after > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
	sleep .2
	pages_nr=`cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages`

	if [ "$pages_nr" = "$pages_inuse_after" ]; then
		break
	fi
done

if [ "$pages_nr" != "$pages_inuse_after" ]; then
	echo "hugetlb error: could not alloc $pages_inuse_after pages (got $pages_nr)"
else
	echo "hugetlb: $pages_nr pages allocated."
fi
