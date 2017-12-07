#! /bin/bash


if [ "$#" -lt "3" ]
then
	echo "You should be at least two for mob programming"
	exit
fi

DELAY=$1

shift

for I in $@ ;
do
	echo $I
	sleep $DELAY
done

