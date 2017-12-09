#! /bin/bash

SESSION_COUNTER=0

function print_centered()
{
	clear
	TEXT=$1

	COLS=$(tput cols)
	LINES=$(tput lines)
	for LINE_SKIP in $(seq 1 $(( $LINES / 2 )) );
	do
		echo
	done

	for HORIZONTAL_PADDING in $(seq 1 $(( ($COLS - ${#TEXT}) / 2 )) );
	do
		echo -n ' '
	done

	echo $TEXT
}

function notify_new_session()
{
	MEMBER=$1

	SESSION_COUNTER=$(( $SESSION_COUNTER + 1))
	print_centered "$SESSION_COUNTER $MEMBER"
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

