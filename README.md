# LaserOrientationModels

BeamSteeringYZ.oml

This model represents the combination of the Laser Source, Primary Beam Steering, Secondary Beam Steering, Beam Pipe, and Central Membrane for the Laser Calibration system. 

The dimensions of the distance between elements, the size of the barrel, and size of the primary beam steering mirrors are currently stand-ins to make calculations simpler. The model will be updated with more precise dimensions. 

The beam width is set to .25 mm to simulate the center peak of the Gaussian Beam

The objects in the model include:
1) The grid source of the beam that comes from the origin
2) FM1: A fixed mirror that represents the beam coming from the laser source.
3) FM2: A fixed mirror that reflects the laser from the source to the Dog Leg configuration.
4) DM1: The first mirror in the Primary Beam Steering. Rotates about (0,-50,150)
5) DM2: The second mirror in the Primary Beam Steering. Rotates about (0,0,150). DM1 and 2 together make a dog-leg configuration, which is used to properly align the beam as it enters the barrel to the secondary beam steering. Their goal is to have the laser hit SM1 dead center and at 90 degrees.
6) Barrel: The container that holds the secondary beam steering mirrors. It has an entrance that the beam travels through.
7) SM1: The first mirror in the Secondary Beam Steering. Rotates around (0,0,200). Helps determine the angle of the beam in the TPC
8) SM2: The second mirror in the Secondary Beam Steering. Rotates around (0,0,200). 
9) Wedge: A fused silica wedge of angle 10 degrees, used to make the larger angles less sensitive.
10) Beam Pipe: The Beam Pipe that transports the beam to the TPC. 
11) Viewing Screen Top and Bottom: A thin sheet that represents the Central Membrane about 1 m from the end of the beam pipe. Has a top and bottom as seperate objects.
12) DM1-DM2 Angle: A thin sheet to find the angle of the beam as it leaves DM1 to DM2
13) Egg-trance: A thin sheet to find the angle of the beam as it approached SM1. 
