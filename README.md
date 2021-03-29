# LaserOrientationModels

BeamSteeringSimp.oml

This model represents the combination of the Laser Source, Primary Beam Steering, Secondary Beam Steering, Beam Pipe, and Central Membrane for the Laser Calibration system. 

The model is to scale but not exact. Some distances have been rounded down to integer numbers to make calculations easier. 

As of 6/27 the configuration of the primary beam steering is out of date and will be updated.

The beam width is set to .25 mm to simulate the center peak of the Gaussian Beam

The objects in the model include:
1) The grid source of the beam that comes from the origin
2) First Leg Tube: the channel that the laser travels between DM1 and DM2
3) Second Leg Tube: the channel that the laser travels between DM2 and the SM1. Contains the barrel that contains the secondary beam steering. 
4) DM1: The first mirror in the Primary Beam Steering. Rotates about ()
5) DM2: The second mirror in the Primary Beam Steering. Rotates about (). DM1 and 2 together make a dog-leg configuration, which is used to properly align the beam as it enters the barrel to the secondary beam steering. Their goal is to have the laser hit SM1 dead center and at 90 degrees. Both are kinematic mounts so they rotate about their corner.
6) SM1: The first mirror in the Secondary Beam Steering. Rotates around (0,-140,245). Helps determine the angle of the beam in the TPC
7) SM2: The second mirror in the Secondary Beam Steering. Rotates around (0,-140,245). 
8) Wedge Base and various degrees: A fused silica wedge of varying degrees. Wedge base is the solid part, and in the model the different degrees can be moved in and out to test different angles.
9) Beam Pipe: The Beam Pipe that transports the beam to the TPC. 
10) CM Top and Bottom: A thin sheet that represents the Central Membrane about 1 m from the end of the beam pipe. Has a top and bottom as seperate objects.



SCHEME CODES:


BeamSteeringMacros: Original set of macros, includes loop to rotate beam steering mirrors and collect data from screens along the beam path. 

BeamWaist_SampleTests: This code is to test the effect of the lenses on the focal length of the beam for a simplified setup that only consists on the lenses and quartz bar in a straight line.

BeamWaistTests: This code is to test the effect of the position lenses on the focal length of the beam for the full setup of the system. It collects irradiance screen data at 0 deg for a variety of L1 and L2 positions with a constant separation

GeometricDeadSpots: Code to collect info for Geometric Dead spots test with the fake laser source (rotating laser source instead of . Not complete: need to get phi/theta rotations to work. Attempts to be able to have the light be able to hit any point along the surface. Not used.

GeometricDeadSpotsDEADCenter: Code to collect info for Geometric Dead spots test with the fake laser source (rotating laser source instead of .Laser source always hits dead center of light pipe. Currently works. 

LaserPathScreens: ;This code finds the Ionization Intensity of a beam at a given angle. For rotating ONLY theta at paired mirror angles (no moving them separately), it collects the irradaiance screens along the beam path.

ThetaPhiRot: Code to run phi/theta rotations with the mirror setup and save data. Currently not working, still need to get theta and phi rots at same time.
