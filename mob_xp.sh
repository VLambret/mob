#! /bin/bash

DELAY=5m
SWITCH_LIMIT=0
SWITCH_COUNTER=0

TEAM_SIZE=$#

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
	COLOR_NUMBER=$(($SWITCH_COUNTER % $TEAM_SIZE % 7 + 1))
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
	if [ "$SWITCH_COUNTER" -gt "9" ]
	then
		print_break_message
	fi
	reset_color
}

function notify_new_session()
{
	MEMBER=$1

	SWITCH_COUNTER=$(( $SWITCH_COUNTER + 1))
	print_centered "$SWITCH_COUNTER $MEMBER"
}

function wait_until_period_end()
{
	PERIOD=$1
	sleep $PERIOD
	mplayer beep.mp3 > /dev/null 2>&1 &
}

DELAY_PATTERN='^([0-9]+x)?[0-9]+[sm]$'
DELAY_DETECTOR=$(echo $1 | grep -E $DELAY_PATTERN)

if [ ! "$DELAY_DETECTOR" = "" ];
then
	DELAY=$(echo $DELAY_DETECTOR | sed -E "s/[0-9]+x//")
	PARSE_LIMIT=$(echo $DELAY_DETECTOR | sed -E "s/x?${DELAY}//")
	SWITCH_LIMIT=${PARSE_LIMIT:-$SWITCH_LIMIT}
	shift
fi

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

