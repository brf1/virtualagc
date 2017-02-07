### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    GROUND_TRACKING_DETERMINATION_PROGRAM_-_P21.agc
## Purpose:     The main source file for Luminary revision 069.
##              It is part of the source code for the original release
##              of the flight software for the Lunar Module's (LM) Apollo
##              Guidance Computer (AGC) for Apollo 10. The actual flown
##              version was Luminary 69 revision 2, which included a
##              newer lunar gravity model and only affected module 2.
##              This file is intended to be a faithful transcription, except
##              that the code format has been changed to conform to the
##              requirements of the yaYUL assembler rather than the
##              original YUL assembler.
## Reference:   pp. 664-666
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Mod history: 2016-12-13 MAS  Created from Luminary 99.
##              2016-12-14 MAS  Updated from comment-proofed Luminary 99 version.
##              2016-12-15 RRB  Updated for Luminary 69.
##		2017-01-28 RSB	Proofed comment text using octopus/prooferComments
##				but no errors found.

## Page 664
# GROUND TRACKING DETERMINATION PROGRAM P21
# PROGRAM DESCRIPTION
# MOD NO - 1
# MOD BY - N. M. NEVILLE
#
# FUNCTIONAL DECRIPTION -
#
# TO PROVIDE THE ASTRONAUT DETAILS OF THE LM OR CSM GROUND TRACK WITHOUT
# THE NEED FOR GROUND COMMUNICATION (REQUESTED BY DSKY).
# CALLING SEQUENCE -
#
#	ASTRONAUT REQUEST THROUGH DSKY V37E21E
# SUBROUTINES CALLED -
#
# GOPERF4
# GOFLASH
# THISPREC
# OTHPREC
# LAT-LONG
#
# NORMAL EXIT MODES -
#
# ASTRONAUT REQUEST TROUGH DSKY TO TERMINATE PROGRAM V34E
# ALARM OR ABORT EXIT MODES -
#
# NONE
# OUTPUT -
#
# OCTAL DISPLAY OF OPTION CODE AND VEHICLE WHOSE GROUND TRACK IS TO BE
# COMPUTED
#	OPTION CODE	00002
#	THIS		00001
#	OTHER		00002
# DECIMAL DISPLAY OF TIME TO BE INTEGRATED TO HOURS , MINUTES , SECONDS
# DECIMAL DISPLAY OF LAT,LONG,ALT
#
# ERASABLE INITIALIZATION REQUIRED
#
# AX0		2DEC	4.652459653 E-5 RADIANS		%68-69 CONSTANTS*
#
# -AY0		2DEC	2.147535898 E-5 RADIANS
#
# AZ0		2DEC	.7753206164	REVOLUTIONS
# FOR LUNAR ORBITS 504LM VECTOR IS NEEDED
#
# 504LM		2DEC	-2.700340600 E-5 RADIANS
#
# 504LM _2	2DEC	-7.514128400 E-4 RADIANS
#
# 504LM _4	2DEC	_2.553198641 E-4 RADIANS
#
# NONE
# DEBRIS
## Page 665
#
# CENTRALS-A,Q,L
# OTHER - THOSE USED BY THE ABOVE LISTED SUBROUTINES
# SEE LEMPREC, LAT-LONG

		SBANK=	LOWSUPER	# FOR LOW 2CADR'S.

		BANK	33
		SETLOC	P20S
		BANK

		EBANK=	P21TIME
		COUNT*	$$/P21
PROG21		CAF	ONE
		TS	OPTION2		# ASSUMED VEHICLE IS LM, R2 = 00001
		CAF	BIT2		# OPTION 2
		TC	BANKCALL
		CADR	GOPERF4
		TC	GOTOPOOH	# TERMINATE
		TC	+2		# PROCEED VALUE OF ASSUMED VEHICLE OK
		TC	-5		# R2 LOADED THROUGH DSKY
P21PROG1	CAF	V6N34		# LOAD DESIRED TIME OF LAT-LONG.
		TC	BANKCALL
		CADR	GOFLASH
		TC	GOTOPOOH	# TERM
		TC	+2		# PROCEED VALUES OK
		TC	-5		# TIME LOADED THROUGH DSKY
		TC	INTPRET
		DLOAD
			DSPTEM1
		STORE	P21TIME
		SLOAD	DSU
			OPTION2
			P21ONENN
		BHIZ	DLOAD
			P21PROG2	# VEHICLE TO BE INTEGRATED IS LEM
			P21TIME		# VEHICLE TO BE INTEGRATED IS CSM
		STCALL	TDEC1		# INTEGRATE TO TIME SPECIFIED IN TDEC
			OTHPREC		# ADJUST UNITS FOR LAT-LONG ROUTINE
P21PROGA	SLOAD	BHIZ
			X2
			P21PROG3
		VLOAD	SETGO
			RATT
			LUNAFLAG
			P21PROG4
P21PROG2	DLOAD
			P21TIME
		STCALL	TDEC1
			THISPREC
		GOTO
## Page 666
			P21PROGA
P21PROG3	VLOAD	CLEAR
			RATT
			LUNAFLAG
P21PROG4	STODL	ALPHAV
			TAT
		CLEAR	CALL
			ERADFLAG
			LAT-LONG
		EXIT
		CAF	V06N43		# DISPLAY LAT,LONG,ALT
		TC	BANKCALL	# LAT,LONG = 1/2 REVS B0
		CADR	GOFLASH		# ALT = KM B14
		TC	GOTOPOOH	# TERM
		TC	GOTOPOOH
		TC	INTPRET		# V32E RECYCLE
		DLOAD	DAD
			P21TIME
			600SEC		# 600 SECONDS OR 10 MIN
		STORE	DSPTEM1
		RTB
			P21PROG1
600SEC		2DEC	60000		# 10 MIN

P21ONENN	OCT	00001		# NEEDED TO DETERMINE VEHICLE
		OCT	00000		# TO BE INTEGRATED
V06N43		VN	00643
V6N34		VN	00634


