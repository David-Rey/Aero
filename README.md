# David Reynolds
# Start Date: February 13, 2021
# EGR 115 - Section 15 
# Assignment: Final Project

AeroMain.m is the main file to run

The following code is avable on github: https://github.com/David-Rey/Aero

Program info
Lines of code

The following is a program developed by David Reynolds. This program
calculates the trajectories of ballistic objects and objects under thrust.
This program takes into account drag, the rotation of the earth, change 
in gravity, atmospheric properties as a function of height and change in
drag coefficient as a function of mach number.

Programming Techniqes (press 'Ctrl + F' to find faster)
<SM:___>		FILENAME\
<SM:IF>			GUIinput\
<SM:ROP>		GUIinput\
<SM:BOP>		runSimulation\
<SM:FOR>		GUIinput\
<SM:WHILE>		GUIinput\
<SM:NEST>		GUIinput\
<SM:PDF_CALL>		AeroMain\
<SM:PDF_PARAM>		AeroMain\
<SM:PDF_RETURN>		AeroMain\
<SM:STRING>		run3DSimulation\
<SM:REF>		runSimulation\
<SM:AUG>		GUIinput\
<SM:SEARCH>		getAtmosphere\
<SM:RANDGEN>		generateRandomValues\
<SM:RANDUSE>		generateRandomValues\
<SM:PLOT>		plotOutput\
<SM:READ>		GUIinput\
<SM:NEWFUN>		runSimulation\
\
Filename		~ lines		(~ sloc)	size\
AeroMain.m		3 lines* 	(3 sloc)*  	1.32 KB\
GUIinput.m		244 lines	(224 sloc)  	14.5 KB\
calculateRunTime.m	12 lines 	(12 sloc)  	453 Bytes\
cartesionToSpherical.m	9 lines 	(8 sloc)  	204 Bytes\
generateRandomValues.m	6 lines 	(6 sloc)  	229 Bytes\
getAbsVectors.m		7 lines 	(6 sloc)  	282 Bytes\
getAtmosphere.m		77 lines 	(68 sloc)  	4.48 KB\
getAtmosphereAtHeight.m	35 lines 	(34 sloc)  	1.16 KB\
getCD.m			20 lines 	(20 sloc)  	476 Bytes\
getGravity.m		8 lines 	(8 sloc) 	164 Bytes\
getLocalVectors.m	7 lines 	(6 sloc)  	286 Bytes\
getRelHumidity.m	15 lines 	(11 sloc)  	324 Bytes\
getStandardATM.m	42 lines 	(36 sloc)  	1.39 KB\
getThrust.m		25 lines 	(25 sloc)  	877 Bytes\
getUnitVector.m		6 lines 	(6 sloc)  	139 Bytes\
locationUpdate.m	7 lines 	(7 sloc)  	228 Bytes\
plotCircle3D.m		16 lines 	(15 sloc)  	539 Bytes\
plotEarth.m		25 lines 	(21 sloc)  	974 Bytes\
plotOutput.m		213 lines 	(197 sloc)  	8.17 KB\
plotPointGUI.m		4 lines 	(4 sloc)  	369 Bytes\
run3DSimulation.m	247 lines 	(228 sloc)  	10.5 KB\
runSimulation.m		170 lines 	(153 sloc)  	6.76 KB\
sphericalToCartesion.m	9 lines 	(8 sloc)  	211 Bytes\
standardATMUpdate.m	7 lines 	(7 sloc)  	232 Bytes\
staticEnvUpdate.m	7 lines 	(7 sloc)  	226 Bytes\
updateGravityCheckBox.m	7 lines 	(7 sloc)  	148 Bytes\
updateObjectValues.m	13 lines 	(12 sloc)  	528 Bytes\
zoomEarth.m		7 lines 	(7 sloc)  	185 Bytes\
\
Total:			1248 lines	(1146 sloc)	55.7 KB\
note: totals taken on March 26 2020. Data may not be up to date. \
*comments not counted in AeroMain.m\

