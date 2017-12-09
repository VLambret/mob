#! /bin/bash

DELAY=$1
shift
TEAM_SIZE=$#
SESSION_COUNTER=0

function print_line_centered()
{
	TEXT="$1"
	COLS=$(tput cols)

	for HORIZONTAL_PADDING in $(seq 1 $(( ($COLS - ${#TEXT}) / 2 )) );
	do
		echo -n ' '
	done

	echo "$TEXT"
}

function set_color()
{
	COLOR_NUMBER=$(($SESSION_COUNTER % $TEAM_SIZE % 7 + 1))
	tput setaf $COLOR_NUMBER
}

function reset_color()
{
	tput sgr0
}

function print_break_message()
{
	BREAK_MSG="  TIME FOR A BREAK MAYBE ?  "
	echo
	for HORIZONTAL_PADDING in $(seq 1 $(( ($COLS - ${#BREAK_MSG}) / 2 )) );
	do
		echo -n ' '
	done
	tput setaf 7
	tput setab 1
	echo "$BREAK_MSG"
	reset_color
}

function print_centered()
{
	clear
	TEXT=$*

	LINES=$(tput lines)
	for LINE_SKIP in $(seq 1 $(( $LINES / 2 )) );
	do
		echo
	done

	set_color
	print_line_centered "$TEXT"
	if [ "$SESSION_COUNTER" -gt "9" ]
	then
		print_break_message
	fi
	reset_color
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

if [ "$TEAM_SIZE" -lt "2" ]
then
	echo "You should be at least two for mob programming"
	exit
fi

clear

while true;
do
	for I in $@ ;
	do
		notify_new_session $I
		wait_until_period_end $DELAY
	done
done

