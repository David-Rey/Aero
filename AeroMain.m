%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% David Reynolds
% Email: reynod13@my.erau.edu
% Start Date: February 13, 2021
% EGR 115 - Section 15 
% Assignment: Final Project
% Filename: AeroMain.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The following code is avable on github: https://github.com/David-Rey/Aero

% The following is a program developed by David Reynolds. This program
% calculates the trajectories of ballistic objects and objects under thrust.
% This program takes into account drag, the rotation of the earth, change
% in gravity, atmospheric properties as a function of height and change in
% drag coefficient as a function of mach number.

%%% Programming Techniqes (press 'Ctrl + F' to find faster) %%%
%<SM:___>			FILENAME
%<SM:IF>			GUIinput
%<SM:ROP>			GUIinput
%<SM:BOP>			runSimulation
%<SM:FOR>			GUIinput
%<SM:WHILE>			GUIinput
%<SM:NEST>			GUIinput
%<SM:PDF_CALL>		AeroMain
%<SM:PDF_PARAM>		AeroMain
%<SM:PDF_RETURN>	AeroMain
%<SM:STRING>		run3DSimulation, GUIinput
%<SM:REF>			runSimulation
%<SM:AUG>			GUIinput
%<SM:SEARCH>		getAtmosphere
%<SM:RANDGEN>		generateRandomValues
%<SM:RANDUSE>		generateRandomValues
%<SM:PLOT>			plotOutput
%<SM:READ>			GUIinput
%<SM:NEWFUN>		runSimulation

%%% File Info %%%
%Filename					~ lines		(~ sloc)	size
%AeroMain.m					4 lines* 	(4 sloc)*  	4.24 KB
%GUIinput.m					292 lines	(269 sloc)  17.3 KB
%calculateRunTime.m			15 lines 	(14 sloc)  	556 Bytes
%cartesionToSpherical.m		11 lines 	(9 sloc)  	265 Bytes
%CDUpdate.m					9 lines		(8 sloc)	183 Bytes
%generateRandomValues.m		8 lines 	(7 sloc)  	271 Bytes
%getAbsVectors.m			9 lines 	(7 sloc)  	325 Bytes
%getAtmosphere.m			80 lines 	(71 sloc)  	4.71 KB
%getAtmosphereAtHeight.m	37 lines 	(35 sloc)  	1.3 KB
%getCD.m					22 lines 	(21 sloc)  	521 Bytes
%getExactScreenSize.m		15 lines	(15 sloc)	1008 Bytes
%getGravity.m				10 lines 	(9 sloc) 	196 Bytes
%getLocalVectors.m			9 lines 	(7 sloc)  	340 Bytes
%getRelHumidity.m			8 lines 	(7 sloc)  	276 Bytes
%getStandardATM.m			39 lines 	(34 sloc)  	1.43 KB
%getThrust.m				32 lines 	(30 sloc)  	1.1 KB
%getUnitVector.m			8 lines 	(7 sloc)  	205 Bytes
%locationUpdate.m			9 lines 	(8 sloc)  	273 Bytes
%plotCircle3D.m				15 lines 	(14 sloc)  	573 Bytes
%plotEarth.m				27 lines 	(22 sloc)  	1.04 KB
%plotOutput.m				214 lines 	(197 sloc)  8.22 KB
%plotPointGUI.m				6 lines 	(5 sloc)  	369 Bytes
%run3DSimulation.m			252 lines 	(230 sloc)  10.6 KB
%runSimulation.m			165 lines 	(147 sloc)  6.6 KB
%sphericalToCartesion.m		11 lines 	(9 sloc)  	272 Bytes
%standardATMUpdate.m		9 lines 	(8 sloc)  	277 Bytes
%staticEnvUpdate.m			9 lines 	(8 sloc)  	271 Bytes
%UIanimate.m				19 lines 	(18 sloc)  	463 Bytes
%updateGravityCheckBox.m	9 lines 	(8 sloc)  	193 Bytes
%updateLonLat.m				22 lines 	(21 sloc)  	571 Bytes
%updateObjectValues.m		15 lines 	(13 sloc)  	575 Bytes
%zoomEarth.m				9 lines 	(8 sloc)  	230 Bytes

% *Comments not counted in AeroMain.m

%Total:						1399 lines	(1270 sloc)	64.6 KB

clear

% really? 3 lines of code?
% put true in parameter to get animation i.e. GUIinput(true);
input = GUIinput(true); %<SM:PDF_CALL>

% does computation 
output = runSimulation(input); %<SM:PDF_PARAM> <SM:PDF_RETURN>

% output
plotOutput(output);


%MIT License
%Copyright (c) 2021 David-Rey

%Permission is hereby granted, free of charge, to any person obtaining a copy
%of this software and associated documentation files (the "Software"), to deal
%in the Software without restriction, including without limitation the rights
%to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%copies of the Software, and to permit persons to whom the Software is
%furnished to do so, subject to the following conditions:

%The above copyright notice and this permission notice shall be included in all
%copies or substantial portions of the Software.

%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%SOFTWARE.
