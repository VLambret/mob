#! /bin/bash

SESSION_COUNTER=0

function notify_new_session()
{
	MEMBER=$1

	clear
	SESSION_COUNTER=$(( $SESSION_COUNTER + 1))
	echo "$SESSION_COUNTER $MEMBER"
}

function wait_until_period_end()
{
	PERIOD=$1
	sleep $PERIOD
	mplayer beep.mp3 > /dev/null 2>&1 &
}

if [ "$#" -lt "3" ]
then
	echo "You should be at least two for mob programming"
	exit
fi

DELAY=$1

shift
clear

while true;
do
	for I in $@ ;
	do
		notify_new_session $I
		wait_until_period_end $DELAY
	done
done

