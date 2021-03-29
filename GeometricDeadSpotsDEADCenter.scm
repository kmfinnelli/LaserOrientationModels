; Code to collect info for Geometric Dead spots test where it ALWAYS hits the center of the LP
; Not complete: need to get phi/theta rotations to work.


; Log, exponent, and round definitions
(define log10
  (lambda (x)
    (/ (log x) (log 10) )
   )
)

(define expt_
  (lambda (base exponent)
    (exp (* exponent (log base) ) )
   )
)
	
	
(define round-off
	(lambda (z n)
		(let ( (power (expt_ 10 n)))
			(/ (round (* power z)) power)
		)
	)
)
(define whatPart "Nothing yet!")


; rot: Rotates an object with entity # "num" about a fixed point (0, -140, 245) by
; "angle" in Theta
(define rot
	(lambda (SM angle1)
		(edit:clear-selection)
		(edit:rotate (entity:get-by-name SM) 0 -140 245 1 0 0 angle1)
	)
)

(define rot-object
	(lambda (name xSpot ySpot zSpot xAxis yAxis zAxis RotAngle)
		(edit:clear-selection)
		(edit:rotate (entity:get-by-name name) xSpot ySpot zSpot xAxis yAxis zAxis RotAngle)
	)
)


(define PI 3.14159)

(define deg-to-rad
	(lambda (AngleDeg)
		(* AngleDeg (/ PI 180))
	)
)



; Rotates the laser source about a certain point. The axis by which it rotates is
; required, as it the amount to rotate it by. 


(define rot-source
	(lambda ( xSpot ySpot zSpot xAxis yAxis zAxis RotAngle)
		(edit:clear-selection)
		(edit:rotate-grid-source "Fake Mirrors" xSpot ySpot zSpot xAxis yAxis zAxis RotAngle)
	)
)

(define make-screens
	(lambda ( ThetaAngle PhiAngle Radius x y z NameSheet)
		(geometry:thin-sheet-circle NameSheet Radius (position x y z) ThetaAngle 0 PhiAngle #t)
	)
)

(define rot-source-angles	
	(lambda (r theta phi)
		(edit:clear-selection)
		(rot-source 0 -140 248.25 r 0 0 theta)
		(rot-source 0 -140 248.25 0 0 r phi)
		;(raytrace:all-sources)
	)
)

(define restore-rot-source-angles
	(lambda (r theta phi)
		(edit:clear-selection)
		(rot-source 0 -140 248.25 0 0 r (* -1 phi))
		(rot-source 0 -140 248.25 r 0 0 (* -1 theta))		
		;(raytrace:all-sources)
	)
)

(define dPos -3)
(define dEnd 3)
(define xMove 0)
(define yMove 0)
(define xMoveInc 0)
(define yMoveInc 0)
(define thetaCurrent -5)
(define phiCurrent -15)
(define phiBegin -50)
(define thetaNum 0)
(define phiNum 0)
(define dNum 0)
(define phiOrig 0)
(define thetaOrig 0)

(define GeoRootPath "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/GeometricDeadSpots/Set_2_25m_Extras_4Redux")

(define save
	(lambda ( entity surface name r thetaStart thetaInc phiStart phiInc dPos dInc)
		(edit:select (tools:face-in-body surface (entity:get-by-name entity)))
		(analysis:incident)
		;Save incident csv
		(analysis:incident-save (string-append GeoRootPath  "/" name "_Incident" "_ThetaRot_" (number->string (round-off thetaStart 2) ) "_ThetaInc_" (number->string (round-off thetaInc 2) ) "_PhiRot_" (number->string  (round-off phiStart 2) ) "_PhiInc_" (number->string (round-off phiInc 2) ) "_dPos_" (number->string  dPos ) "_dInc_" (number->string  dInc ) ".csv" ) "csv"	#f)
		;Save incident text
		;(analysis:incident-save (string-append GeoRootPath  "/" name "_Incident" "_ThetaRot_" (number->string thetaStart ) "_ThetaInc_" (number->string thetaInc ) "_PhiRot_" (number->string  phiStart ) "_PhiInc_" (number->string  phiInc ) "_dPos_" (number->string  dPos) "_dInc_" (number->string  dInc ) ".txt" ) "txt"	#f)
		(analysis:incident-close)
		;(newline)
	)
)

(define save-irr
	(lambda ( entity surface name r thetaStart thetaInc phiStart phiInc dPos dInc)
		(edit:select (tools:face-in-body surface (entity:get-by-name entity)))
		(analysis:irradiance)
		; (analysis:irradiance-ray-type "incident")
		; (analysis:irradiance-set-local-coordinates #t)
		; (analysis:irradiance-smooth #f)
		; (analysis:irradiance-set-profiles #f)
		; (analysis:refresh)

		;Save irradiance txt
		(analysis:irradiance-save (string-append GeoRootPath  "Irr/" name "Irr_Incident"  "_ThetaRot_" (number->string (round-off thetaStart 2)) "_ThetaInc_" (number->string (round-off thetaInc 2)) "_PhiRot_" (number->string (round-off phiStart 2)) "_PhiInc_" (number->string (round-off phiInc 2)) "_dPos_" (number->string (round-off dPos 2)) "_dInc_" (number->string (round-off dInc 2)) ".txt" ))

		; ;Save irradiance pic	
		; (analysis:irradiance-save (string-append GeoRootPath  "Irr/" name "Irr_Incident"  "_ThetaRot_" (number->string (round-off thetaStart 2)) "_ThetaInc_" (number->string (round-off thetaInc 2)) "_PhiRot_" (number->string (round-off phiStart 2)) "_PhiInc_" (number->string (round-off phiInc 2)) "_dPos_" (number->string (round-off dPos 2)) "_dInc_" (number->string (round-off dInc 2)) ".jpg" ))
		; ;(newline)
		
		; (analysis:irradiance-smooth #t)
		; (analysis:refresh)
		; (analysis:irradiance-save (string-append GeoRootPath  "Irr/" name "IrrSmooth_Incident"  "_ThetaRot_" (number->string (round-off thetaStart 2)) "_ThetaInc_" (number->string (round-off thetaInc 2)) "_PhiRot_" (number->string (round-off phiStart 2)) "_PhiInc_" (number->string (round-off phiInc 2)) "_dPos_" (number->string (round-off dPos 2)) "_dInc_" (number->string (round-off dInc 2)) ".jpg" ))

		
		(analysis:irradiance-close)
		;(newline)
	)
)


(define save-set
	(lambda (r thetaStart thetaInc phiStart phiInc dPos dInc)
		(raytrace:all-sources)
		(save "LP_Chamf_150_5mm" 9 "LPFrontFace" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "LP_Chamf_150_5mm" 6 "LPBackFace" r thetaStart thetaInc phiStart phiInc dPos dInc)
		;(save "LP_Chamf_150_5mm" 8 "LPLeftFace" r thetaStart thetaInc phiStart phiInc dPos dInc)
		;(save "LP_Chamf_150_5mm" 7 "LPTopFace" r thetaStart thetaInc phiStart phiInc dPos dInc)
		;(save "LP_Chamf_150_5mm" 5 "LPBottomFace" r thetaStart thetaInc phiStart phiInc dPos dInc)
		;(save "LP_Chamf_150_5mm" 4 "LPRightFace" r thetaStart thetaInc phiStart phiInc dPos dInc)
		
		(save "TL Close" 0 "TLCloseAbsScreen" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "TR Close" 0 "TRCloseAbsScreen" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "BL Close" 0 "BLCloseAbsScreen" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "BR Close" 0 "BRCloseAbsScreen" r thetaStart thetaInc phiStart phiInc dPos dInc)
		
		(save "PostFront" 0 "PostFrontScreen" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "PostBack" 0 "PostBackScreen" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "PreBack" 0 "PreBackScreen" r thetaStart thetaInc phiStart phiInc dPos dInc)


		(save "EndcapRight" 0 "EndcapRight" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "EndcapLeft" 0 "EndcapLeft" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "EndcapTop" 0 "EndcapTop" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "EndcapBottom" 0 "EndcapBottom" r thetaStart thetaInc phiStart phiInc dPos dInc)

		(save "BallRight1" 0 "BallRight1" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "BallLeft1" 0 "BallLeft1" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "BallBottom1" 0 "BallBottom1" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "BallTop1" 0 "BallTop1" r thetaStart thetaInc phiStart phiInc dPos dInc)

		(save "BallRight2" 0 "BallRight2" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "BallLeft2" 0 "BallLeft2" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "BallBottom2" 0 "BallBottom2" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "BallTop2" 0 "BallTop2" r thetaStart thetaInc phiStart phiInc dPos dInc)

		(save "BeamScreen1" 0 "BeamScreen1" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "BeamScreen2" 0 "BeamScreen2" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "BeamScreen3" 0 "BeamScreen3" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "BeamScreen4" 0 "BeamScreen4" r thetaStart thetaInc phiStart phiInc dPos dInc)

		(save-irr "BeamScreen1" 0 "BeamScreen1" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save-irr "BeamScreen2" 0 "BeamScreen2" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save-irr "BeamScreen3" 0 "BeamScreen3" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save-irr "BeamScreen4" 0 "BeamScreen4" r thetaStart thetaInc phiStart phiInc dPos dInc)

		(save "PreBeamScreen1" 0 "PreBeamScreen1" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "PreBeamScreen2" 0 "PreBeamScreen2" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "PreBeamScreen3" 0 "PreBeamScreen3" r thetaStart thetaInc phiStart phiInc dPos dInc)
		(save "PreBeamScreen4" 0 "PreBeamScreen4" r thetaStart thetaInc phiStart phiInc dPos dInc)

		; (save-irr "PreBeamScreen1" 0 "PreBeamScreen1" r thetaStart thetaInc phiStart phiInc dPos dInc)
		; (save-irr "PreBeamScreen2" 0 "PreBeamScreen2" r thetaStart thetaInc phiStart phiInc dPos dInc)
		; (save-irr "PreBeamScreen3" 0 "PreBeamScreen3" r thetaStart thetaInc phiStart phiInc dPos dInc)
		; (save-irr "PreBeamScreen4" 0 "PreBeamScreen4" r thetaStart thetaInc phiStart phiInc dPos dInc)

		;(display "Save done!")
	)
)

(define saveSpecialIrr
	(lambda (thetaStart  phiStart)
		(save-irr "BeamScreen1" 0 "BeamScreen1" 7 thetaStart 1 phiStart 1 -3 3)
		(save-irr "BeamScreen2" 0 "BeamScreen2" 7 thetaStart 1 phiStart 1 -3 3)
		(save-irr "BeamScreen3" 0 "BeamScreen3" 7 thetaStart 1 phiStart 1 -3 3)
		(save-irr "BeamScreen4" 0 "BeamScreen4" 7 thetaStart 1 phiStart 1 -3 3)

		(save-irr "PreBeamScreen1" 0 "PreBeamScreen1" 3.5 thetaStart 1 phiStart 1 -3 3)
		(save-irr "PreBeamScreen2" 0 "PreBeamScreen2" 3.5 thetaStart 1 phiStart 1 -3 3)
		(save-irr "PreBeamScreen3" 0 "PreBeamScreen3" 3.5 thetaStart 1 phiStart 1 -3 3)
		(save-irr "PreBeamScreen4" 0 "PreBeamScreen4" 3.5 thetaStart 1 phiStart 1 -3 3)

	)
)





(define rot-screens-quads
	(lambda ( r thetaStart phiStart x y z name)
		(rot-object (string-append name "1") x y z r 0 0 thetaStart)
		(rot-object (string-append name "1") x y z 0 0 r phiStart)
		
		(rot-object (string-append name "2") x y z r 0 0 (* -1 thetaStart))
		(rot-object (string-append name "2") x y z 0 0 r phiStart)
		
		(rot-object (string-append name "3") x y z r 0 0 thetaStart)
		(rot-object (string-append name "3") x y z 0 0 r (* -1 phiStart))
		
		(rot-object (string-append name "4") x y z r 0 0 (* -1 thetaStart))
		(rot-object (string-append name "4") x y z 0 0 r (* -1 phiStart))
	)
)

(define restore-rot-screens-quads
	(lambda ( r thetaStart phiStart x y z name)
		(rot-object (string-append name "1") x y z 0 0 r (* -1 phiStart))	
		(rot-object (string-append name "1") x y z r 0 0 (* -1 thetaStart))
		
		(rot-object (string-append name "2") x y z 0 0 r (* -1 phiStart))
		(rot-object (string-append name "2") x y z r 0 0 thetaStart)
		
		(rot-object (string-append name "3") x y z 0 0 r phiStart)
		(rot-object (string-append name "3") x y z r 0 0 (* -1 thetaStart))
		
		(rot-object (string-append name "4") x y z 0 0 r phiStart)
		(rot-object (string-append name "4") x y z r 0 0 thetaStart)
		
	)
)

(define duo
	(lambda (theta phi)
		(rot-source-angles 7 theta phi)
		(rot-screens-quads 20 theta phi 0 -140 398.25 "BeamScreen")
		(rot-screens-quads 3.5 theta phi 0 -140 248.25 "PreBeamScreen")
		;(raytrace:all-sources)
	)
)

(define r-duo
	(lambda (theta phi)
		(restore-rot-source-angles 7 theta phi)
		(restore-rot-screens-quads 20 theta phi 0 -140 398.25 "BeamScreen")
		(restore-rot-screens-quads 3.5 theta phi 0 -140 248.25 "PreBeamScreen")
		;(raytrace:all-sources)
	)
)


(define phi-loop
	(lambda (r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
		(cond 
			((> phiStart phiEnd) 
				(restore-rot-source-angles r 0 phiStart)
				(set! phiStart phiOrig)
				;(display (string-append "phiStart is moved back to " (number->string phiStart)))
				;(newline)
			)
			(else
				(display whatPart)
				(newline)
				(display (string-append "Before rotating in phi, theta= " (number->string thetaStart) " and phi=" (number->string phiStart)))
				(newline)
				(rot-screens-quads 3.5 thetaStart phiStart 0 -140 248.25 "PreBeamScreen")
				(rot-screens-quads 20 thetaStart phiStart 0 -140 398.25 "BeamScreen")
				(save-set r thetaStart thetaInc phiStart phiInc dPos dInc)				
				(restore-rot-screens-quads 20 thetaStart phiStart 0 -140 398.25 "BeamScreen")
				(restore-rot-screens-quads 3.5 thetaStart phiStart 0 -140 248.25 "PreBeamScreen")
				
				(rot-source-angles r 0 phiInc)
				;(display "Phi moved to next angle by phiInc")
				;(newline)
				(phi-loop r thetaStart thetaEnd thetaInc (+ phiStart phiInc) phiEnd phiInc dPos dEnd dInc)

			)
		)
	)
)


(define theta-loop	
	(lambda (r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
		
		(cond
			( (> thetaStart thetaEnd) 
				;(display "Done with theta loop")
				;(newline)
				(set! thetaStart (- thetaStart thetaInc))
				(restore-rot-source-angles r thetaStart 0)
				(set! thetaStart thetaOrig)
			
			)
			( else
				(set! thetaNum (+ thetaNum 1))
				;(display (string-append "Doing theta loop number " (number->string thetaNum)))
				;(newline)
				;(display (string-append "Starting phi-loop at theta=" (number->string thetaStart)))
				;(newline)
				
				(cond 
					((eqv? thetaStart thetaOrig) 'go)
					(else
						(rot-source-angles r thetaInc 0)
						;(display "Doing theta rot in if!")
					)
				)				

				(set! phiBegin phiStart)
				(rot-source-angles r 0 phiStart)
				(set! phiOrig phiStart)
				(phi-loop r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
				;(display "After this phi loop, the phi should be back to phiOrig so we can rotate to next theta by thetaInc")
				;(newline)
				;(display (string-append "After phi-loop at theta=" (number->string thetaStart ) " and phi=" (number->string phiStart)))
				;(newline)
				

				(theta-loop r (+ thetaStart thetaInc) thetaEnd thetaInc phiBegin phiEnd phiInc dPos dEnd dInc)
			
			)
		)
	)
)


(define run-loop
	(lambda (r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
		;(display (string-append "START: THETA=" (number->string thetaStart) ", PHI=" (number->string phiStart)))
		;(newline)
		;(display (string-append "Does first theta rotation by" (number->string thetaStart)))
		;(newline)
		(rot-source-angles r thetaStart 0)
		;(display "Keeps the original thetaStart as thetaOrig")
		;(newline)
		(set! thetaOrig thetaStart)
		;(display "Starts the theta loop from in the run-loop")
		;(newline)
		(theta-loop r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
		;(display "Theta loop over! Ideally here phi and theta should already be back to normal" )
		;(newline)
		;(display (string-append "Currently at theta=" (number->string thetaStart ) " and phi=" (number->string phiStart)))
		;(newline)
		(raytrace:all-sources)
		(display "All done!")
		(newline)
	)
)

(define deltaX 0)
(define deltaY 0)

(define move-corners
	(lambda (d)
		(set! deltaX (* (/ d 1000) (cos (deg-to-rad 45))))
		(set! deltaY (* (/ d 1000) (sin (deg-to-rad 45))))

		(edit:move (entity:get-by-name "TL Close") (- 2.5 deltaX) (- -137.5 deltaY) 323.25 #f #f)
		(edit:move (entity:get-by-name "TR Close") (+ -2.5 deltaX) (- -137.5 deltaY) 323.25 #f #f)
		(edit:move (entity:get-by-name "BL Close") (- 2.5 deltaX) (+ -142.5 deltaY) 323.25 #f #f)
		(edit:move (entity:get-by-name "BR Close") (+ -2.5 deltaX) (+ -142.5 deltaY) 323.25 #f #f)	
	
	
	)
)

(define turn-on-extras
	(lambda ()
		(property:set-raytrace-flag (entity:get-by-name "EndcapRight") #t)
		(property:set-raytrace-flag (entity:get-by-name "EndcapLeft") #t)
		(property:set-raytrace-flag (entity:get-by-name "EndcapTop") #t)
		(property:set-raytrace-flag (entity:get-by-name "EndcapBottom") #t)
		
		(property:set-raytrace-flag (entity:get-by-name "BallRight1") #t)
		(property:set-raytrace-flag (entity:get-by-name "BallLeft1") #t)
		(property:set-raytrace-flag (entity:get-by-name "BallTop1") #t)
		(property:set-raytrace-flag (entity:get-by-name "BallBottom1") #t)
		
		(property:set-raytrace-flag (entity:get-by-name "BallRight2") #t)
		(property:set-raytrace-flag (entity:get-by-name "BallLeft2") #t)
		(property:set-raytrace-flag (entity:get-by-name "BallTop2") #t)
		(property:set-raytrace-flag (entity:get-by-name "BallBottom2") #t)
	)
)

(define turn-off-extras
	(lambda ()
		(property:set-raytrace-flag (entity:get-by-name "EndcapRight") #f)
		(property:set-raytrace-flag (entity:get-by-name "EndcapLeft") #f)
		(property:set-raytrace-flag (entity:get-by-name "EndcapTop") #f)
		(property:set-raytrace-flag (entity:get-by-name "EndcapBottom") #f)
		
		(property:set-raytrace-flag (entity:get-by-name "BallRight1") #f)
		(property:set-raytrace-flag (entity:get-by-name "BallLeft1") #f)
		(property:set-raytrace-flag (entity:get-by-name "BallTop1") #f)
		(property:set-raytrace-flag (entity:get-by-name "BallBottom1") #f)
		
		(property:set-raytrace-flag (entity:get-by-name "BallRight2") #f)
		(property:set-raytrace-flag (entity:get-by-name "BallLeft2") #f)
		(property:set-raytrace-flag (entity:get-by-name "BallTop2") #f)
		(property:set-raytrace-flag (entity:get-by-name "BallBottom2") #f)
	)
)

(define runSpecialIrr
	(lambda (thetaStart phiStart)
		(duo thetaStart phiStart)
		(saveSpecialIrr thetaStart phiStart)
		(r-duo thetaStart phiStart)
	)
)

(define go
	(lambda ()
		
		; (set! whatPart "First test, 5 microns, No Extras, Regular")
		; (move-corners 5)
		; (set! GeoRootPath "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/GeometricDeadSpots/Next_1_5microns_NoExtras_Reg")
		; (run-loop 7 0 80 1 0 90 1 -3 3 3)
		
		; (set! whatPart "Second test, 25 microns, No Extras, Regular")
		; (move-corners 25)
		; (set! GeoRootPath "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/GeometricDeadSpots/Next_2_25microns_NoExtras_Reg")
		; (run-loop 7 0 80 1 0 90 1 -3 3 3)
		
		(turn-on-extras)
		
		; (set! whatPart "Third test, 5 microns, Extras, Regular")
		; (move-corners 5)
		; (set! GeoRootPath "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/GeometricDeadSpots/Next_3_5microns_Extras_Reg")
		; (run-loop 7 0 80 1 0 90 1 -3 3 3)
		
		(set! whatPart "Fourth test, 25 microns, Extras, Regular")
		(move-corners 25)
		(set! GeoRootPath "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/GeometricDeadSpots/Set_6_25m_Extras_4_Pre_Full_CutBeam")
		(run-loop 7 0 80 1 0 90 1 -3 3 3)
		
		
		; (property:apply-surface (tools:face-in-body 9 (entity:get-by-name "LP_Chamf_150_5mm")) (list "Perfect Transmitter" "Default")
			; (gvector 0 0 0) (gvector 0 0 0)
			; (position 0 0 0) 
			; (gvector 0 0 0) #t #t)
		; (property:apply-surface (tools:face-in-body 6 (entity:get-by-name "LP_Chamf_150_5mm")) (list "Perfect Transmitter" "Default")
			; (gvector 0 0 0) (gvector 0 0 0)
			; (position 0 0 0) 
			; (gvector 0 0 0) #t #t)
			
			
		; (set! whatPart "Fifth test, 5 microns, Extras, Perfect Transmitter")
		; (move-corners 5)
		; (set! GeoRootPath "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/GeometricDeadSpots/Next_5_5microns_Extras_Trans")
		; (run-loop 7 0 80 1 0 90 1 -3 3 3)
		
		; (set! whatPart "Sixth test, 25 microns, Extras, Perfect Transmitter")
		; (move-corners 25)
		; (set! GeoRootPath "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/GeometricDeadSpots/Next_6_25microns_Extras_Trans")
		; (run-loop 7 0 80 1 0 90 1 -3 3 3)
		
		; (runSpecialIrr 0 0)
		
		; (runSpecialIrr 30 0)
		; (runSpecialIrr 30 30)
		; (runSpecialIrr 30 45)
		; (runSpecialIrr 30 60)
		; (runSpecialIrr 30 75)
		; (runSpecialIrr 30 90)
		
		; (runSpecialIrr 45 0)
		; (runSpecialIrr 45 30)
		; (runSpecialIrr 45 45)
		; (runSpecialIrr 45 60)
		; (runSpecialIrr 45 75)
		; (runSpecialIrr 45 90)
		
		; (runSpecialIrr 60 0)
		; (runSpecialIrr 60 30)
		; (runSpecialIrr 60 45)
		; (runSpecialIrr 60 60)
		; (runSpecialIrr 60 75)
		; (runSpecialIrr 60 90)
		
		; (runSpecialIrr 65 0)
		; (runSpecialIrr 65 30)
		; (runSpecialIrr 65 45)
		; (runSpecialIrr 65 60)
		; (runSpecialIrr 65 75)
		; (runSpecialIrr 65 90)
		
		; (runSpecialIrr 70 0)
		; (runSpecialIrr 70 30)
		; (runSpecialIrr 70 45)
		; (runSpecialIrr 70 60)
		; (runSpecialIrr 70 75)
		; (runSpecialIrr 70 90)
		
		; (runSpecialIrr 75 0)
		; (runSpecialIrr 75 30)
		; (runSpecialIrr 75 45)
		; (runSpecialIrr 75 60)
		; (runSpecialIrr 75 75)
		; (runSpecialIrr 75 90)
		
		; (runSpecialIrr 80 0)
		; (runSpecialIrr 80 30)
		; (runSpecialIrr 80 45)
		; (runSpecialIrr 80 60)
		; (runSpecialIrr 80 75)
		; (runSpecialIrr 80 90)


		
		
	)
)



