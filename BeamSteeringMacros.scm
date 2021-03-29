;The original set of all macros; kind of a mess at this point.

(define whichWedge 420)
	; defines the number of the wedge being measured, used for naming purposes
(display "here!")

(define rootPath "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/Rot/Wedge" )
	; defines the root Path for the csvs to save to
	
(define rootPathPhi "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/Rot/Phi")
	
	
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


(define switch-wedge
	(lambda ( current next)
		(property:set-raytrace-flag (entity:get-by-name current) #f)
		(property:set-raytrace-flag (entity:get-by-name next) #t)
	)
)

; Give the entity #'s for the wedges you want to change
; 6 deg= 11, 8 deg=12, 10 deg=13, 12 deg=14
; Could also make it so they go invisible as well for visuals

(define rot
	(lambda (SM angle1)
		(edit:clear-selection)
		(edit:rotate (entity:get-by-name SM) 0 -140 245 1 0 0 angle1)
	)
)
; Rotates an object with entity # "num" about a fixed point (0, -140, 245) by "angle"
; Can probably generalize center point if necessary

(define rot-phi
	(lambda (SM angle1)
		(edit:clear-selection)
		(edit:rotate (entity:get-by-name SM) 0 -140 245 0 0 1 angle1)
	)
)
; Rotates the object about the z axis for the phi rotation


(define rot-ray
	(lambda (SM angle1)
		(edit:clear-selection)
		(edit:rotate (entity:get-by-name SM) 0 -140 245 1 0 0 angle1)
		(raytrace:all-sources)
	)
)
; rotates an object with rot then raytraces


(define run-nominal
	(lambda ( angle2 )
		(rot "SM1" angle2)	; rot SM1 (#7)
		(rot "SM2" (* 2 angle2)) ; rot SM2 (#3) by twice angle
		(raytrace:all-sources)
	)
)

(define run-phi
	(lambda ( angle2 )
		(rot-phi "SM1" angle2)	; rot SM1 (#7)
		(rot-phi "SM2" angle2) ; rot SM2 (#3) 
		(rot-phi "Second Leg Tube" angle2) ; rot the tube
		(raytrace:all-sources)
	)
)

;rotates SM1 by angle2 and SM2 by 2*angle 2 to rotate to where the laser hits SM2 dead center, then raytraces

(define save
	(lambda (surface en angleSM1 angleSM2 name)
		(edit:select (tools:face-in-body surface (entity:get-by-name en)))
		(analysis:incident)
		(analysis:incident-save (string-append rootPath (number->string whichWedge) "/" "Incident_Wedge" (number->string whichWedge) "_" name "_SM1_" (number->string (round-off angleSM1 2)) "_SM2_" (number->string (round-off angleSM2 2)) ".csv" ) "csv"	#f)
		(newline)
		(analysis:incident-close)
	)
)
; A procedure to save the incident ray table for a entity "en" at surface # "surface". It saves the file as "Incident_"name"_SM1"angleSM1"_SM2_"angleSM2""

(define save-phi
	(lambda (surface en anglePhi name)
		(edit:select (tools:face-in-body surface (entity:get-by-name en)))
		(analysis:incident)
		(analysis:incident-save (string-append rootPathPhi  "/" "Incident" "_" name "_PhiRot_" (number->string (round-off anglePhi 2)) ".csv" ) "csv"	#f)
		(newline)
		(analysis:incident-close)
	)
)

(define save_irr
	(lambda(surface en anglePhi name )
		(edit:select (tools:face-in-body surface (entity:get-by-name en)))
		(analysis:irradiance)
		(analysis:irradiance-save (string-append rootPath (number->string whichWedge) "/" "Irr_Wedge" (number->string whichWedge) "_" name "_PhiRot_" (number->string (round-off anglePhi 2))  ".jpg" ))
		(newline)
		(analysis:irradiance-close)
	)
)


(define run-save
   (lambda (angle4 orig anglesSM1)
		(rot "SM2" angle4)
		(raytrace:all-sources)
		(save 0 "CMTop" anglesSM1 orig "CMTop")
		(save 0 "CMBottom" anglesSM1 orig "CMBottom")
		(save 6 "LPChamf" anglesSM1 orig "LPEnd")
		(save 9 "LPChamf" anglesSM1 orig "LPFront") 
		(save 4 "SM2" anglesSM1 orig "SM2Face")
		; (save 2 "WedgeBase" anglesSM1 orig "WedgeBase")
		
		;(save_irr 0 "LPFrontScreen" anglesSM1 orig "LPFrontScreen")
		(display "run-save readout #:")
		(display orig)
		(newline)
	)
)


; a procedure to rotate just SM2, run the raytrace, then save the incident ray table for CMTop, CMBottom, and the front and end of the light pipe. anglesSM1 is used to name the file.
; Can tell which CM was hit by size of excel file; if no hit, only 1 KB

(define run-save-phi
   (lambda (angle4 )
		(run-phi angle4)
		(raytrace:all-sources)
		(save-phi 0 "CMTop" angle4  "CMTop")
		(save-phi 0 "CMBottom" angle4  "CMBottom")
		(save-phi 6 "LPChamf" angle4  "LPEnd")
		(save-phi 9 "LPChamf" angle4  "LPFront") 
		(save-phi 4 "SM2" angle4  "SM2Face")
		;(save_irr 0 "LPFrontScreen" angle4  "LPFrontScreen")
		(display "run-save readout #:")
		(display angle4)
		(newline)
	)
)

;Loop for rotating SM2 for a SINGLE SM1
(define loop
	(lambda ( init end SM1 incr)
		(cond
			( (> init (- end incr) ) 'done )
			( (<= init (- end incr))
				(round-off init 3)
				(run-save incr (+ init incr)  SM1 )
				(display "loop pre inc init:")
				(display init)
				(newline)
				(set! init (+ init incr))
				(round-off init 3)
				(display "loop post inc init:")
				(display init)
				(display "SM1 angle:")
				(display SM1)
				(newline)
				(loop init end (round-off SM1 3) incr)
			)
		)
	)
)
;The loop takes a starting angle init and end angle end, and runs run-save for SM2 from init to end by increment incr. SM1 is just used for naming purpose here.


(define run	
	(lambda( SM1angle start finish incre)
		(run-nominal SM1angle)
		(run-save start start SM1angle)
		(loop start finish SM1angle incre)
	)
)
;For a given SM1angle, starting SM2 angle start and finish, and increment, first runs rot-nominal, then loops throgh the SM2 angles.
;Result- For one SM1 angle, saves incident ray table for each SM2 angle requested.

(define run-single
	(lambda(SM1angle SM2angle)
		(run-nominal SM1angle)
		(rot "SM2" SM2angle)
		(raytrace:all-sources)
	)
)

(define restore	
	(lambda (SM1angle end)
		(run-nominal (* -1 SM1angle))
		(rot "SM2" (* -1 end))
		(raytrace:all-sources)
	)
)

(define restore-phi	
	(lambda (phiAngle)
		(run-phi (* -1 phiAngle))
		(raytrace:all-sources)
	)
)

;Rotates SM1 and 2 back to original position by giving it the SM1angle and SM2 angle 'end'

(define run-restore
	(lambda (SM1angle start finish incre)
		(run SM1angle start finish incre)
		(restore SM1angle finish)
	)
)
;Does the run procedure then restores it with those numbers

(define run-set	
	(lambda (SM1angle endSM1 incSM1 startSM2 finishSM2 increSM2 )
		(cond 
			((> SM1angle endSM1) 'done)
			(else
				(display "SM1 angle pre inc: ")
				(display SM1angle)
				(newline)
				(run-restore SM1angle startSM2 finishSM2 increSM2)
				(display "done with run-restore")
				(newline)
				(run-set (+ SM1angle incSM1) endSM1 incSM1 startSM2 finishSM2 increSM2)
			)
		)
	)
)
; Loops the run-restore procedure so that it can also loop over multiple SM1 angles as well.

(define run-set-phi	
	(lambda (phiAngleStart phiAngleEnd inc )
		(cond 
			((> phiAngleStart phiAngleEnd) 'done)
			(else
				(display "Phi angle pre inc: ")
				(display phiAngleStart)
				(newline)
				(run-save-phi phiAngleStart)
				(restore-phi phiAngleStart)
				(display "done with run-restore")
				(newline)
				(run-set-phi (+ phiAngleStart inc) phiAngleEnd inc)
			)
		)
	)
)

(define run-save-phi-corners
   (lambda (angle4 LP)
		(run-phi angle4)
		(raytrace:all-sources)
		(save-phi 0 "CMTop" angle4  "CMTop")
		(save-phi 0 "CMBottom" angle4  "CMBottom")
		(save-phi 6 LP angle4  "LPEnd")
		(save-phi 9 LP angle4  "LPFront") 
		(save-phi 4 "SM2" angle4  "SM2Face")
		;(save_irr 0 "LPFrontScreen" angle4  "LPFrontScreen")
		(display "run-save readout #:")
		(display angle4)
		(newline)
	)
)

(define run-set-phi-corners	
	(lambda (phiAngleStart phiAngleEnd inc LP)
		(cond 
			((> phiAngleStart phiAngleEnd) 'done)
			(else
				(display "Phi angle pre inc: ")
				(display phiAngleStart)
				(newline)
				(run-save-phi-corners phiAngleStart LP)
				(restore-phi phiAngleStart)
				(display "done with run-restore")
				(newline)
				(run-set-phi (+ phiAngleStart inc) phiAngleEnd inc)
			)
		)
	)
)
	

(define run-all
	(lambda (SM1Start SM1End SM1Inc SM2Start SM2End SM2Inc PhiStart PhiEnd PhiInc LP)
		(cond	
			( (> SM1Start SM1End) 'done)
			(else	
				(run-set-phi-corners PhiStart PhiEnd PhiInc LP)
				(run-all (+ SM1Start SM1Inc) SM1End SM1Inc SM2Start SM2End SM2Inc PhiStart PhiEnd PhiInc)
			)
		)
	)
)


(newline)

(define PI 3.14159)

(define yPosTop 45)

(define yPosBottom -503)

(define deg-to-rad
	(lambda (AngleDeg)
		(* AngleDeg (/ PI 180))
	)
)

(define make-screens
	(lambda ( ThetaAngle Radius x y z NameSheet)
		(geometry:thin-sheet-circle NameSheet Radius (position x y z) ThetaAngle 0 0 #t)
	)
)

(define move-screens
	(lambda ( en xMove yMove zMove)
		(edit:move (entity:get-by-name en) xMove yMove zMove)
	)
)

(define OuterLoopNumber 0)
(define InnerLoopNumber 0)
(define ThetaAngleRad 0)
(define PhiAngleRad 0)
(define xInc 0)
(define yInc 0)
(define zInc 0)

; (define NameDown " ")
; (define NameUp " ")
(define TestScreen "TestScreen")

(define screen-set-loop	
	(lambda ( ThetaAngleDeg yPos zPos dist) 
		(cond 
			( ( > ThetaAngleDeg 0)
			(display "Outer Loop")
			(newline)
			(display OuterLoopNumber)
			(set! OuterLoopNumber (+ OuterLoopNumber 1))
				(cond 
					( (> yPos yPosTop) 'done1)
					(else	
						(display "Checked Else1")
						(newline)
						(define NameUp (string-append TestScreen "_" (number->string ThetaAngleDeg) "_" (number->string InnerLoopNumber)))
						(make-screens (* -1 ThetaAngleDeg) 10 0 yPos zPos NameUp)
						(display "Made Screen1")
						(newline)
						(display InnerLoopNumber)
						(newline)
						(set! ThetaAngleRad (deg-to-rad ThetaAngleDeg))
						(set! yInc (* dist (sin ThetaAngleRad)))
						(set! zInc (* dist (cos ThetaAngleRad)))
						(display "Upper Inner Loop")
						(display InnerLoopNumber)
						(set! InnerLoopNumber (+ InnerLoopNumber 1))
						(screen-set-loop ThetaAngleDeg (+ yPos yInc) (+ zPos zInc) dist)
					)
				)
			)
			(else
				(cond 
					( (< yPos yPosBottom) 'done2)
					(else	
						(display "Checked Else2")
						(newline)
						(define NameDown (string-append TestScreen "_" (number->string ThetaAngleDeg) "_" (number->string InnerLoopNumber)))
						(make-screens (* -1 ThetaAngleDeg) 10 0 yPos zPos NameDown)
						(display "Made Screen2")
						(newline)
						(display InnerLoopNumber)
						(set! ThetaAngleRad (deg-to-rad ThetaAngleDeg))
						(set! yInc (* dist (sin ThetaAngleRad)))
						(set! zInc (* dist (cos ThetaAngleRad)))
						(display "Lower Inner Loop")
						(display InnerLoopNumber)
						(set! InnerLoopNumber (+ InnerLoopNumber 1))
						(screen-set-loop ThetaAngleDeg (+ yPos yInc) (+ zPos zInc) dist)
					)
				)
			)
		)
	)
)






(define delete
	(lambda (name)
		(geometry:delete (entity:get-by-name name))
	)
)




(define delete-Screens
	(lambda (name)
		(cond ())
		
	)
)

(define rootPathSurvey "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/Survey/BeamWaist3/BW")

(define save_irr_Survey
	(lambda(surface en num anglee dist )
		(edit:select (tools:face-in-body surface (entity:get-by-name en)))
		(analysis:irradiance)
		(analysis:irradiance-save (string-append rootPathSurvey "_Irr_" en "_DistInc_" (number->string dist) "_" (number->string num) ".jpg" ))
		(analysis:irradiance-save (string-append rootPathSurvey "_Irr_" en "_DistInc_" (number->string dist) "_" (number->string num) ".txt" ))
		(analysis:irradiance-save (string-append rootPathSurvey "_Irr_" en "_DistInc_" (number->string dist) "_" (number->string num) ".csv" ))
		(newline)
		(analysis:irradiance-close)
	)
)

(define save_inc_Survey
	(lambda (surface en num anglee dist)
		(edit:select (tools:face-in-body surface (entity:get-by-name en)))
		(analysis:incident)
		(analysis:incident-save (string-append rootPathSurvey "_Inc_" en "_DistInc_" (number->string dist) "_" (number->string num) ".csv" ) "csv"	#f)
		(newline)
		(analysis:incident-close)
	)
)

(define save_set_Survey
	(lambda (surface en num anglee dist)
		(raytrace:all-sources)
		(save_inc_Survey surface en num anglee dist)
		; (display "Saved inc")
		; (newline)
		(save_irr_Survey surface en num anglee dist)
		; (display "Saved pic")
		; (newline)
	)
)

(define zPosEnd 1362.55)

(define circEqn 
	(lambda (x y y0 z z0 r)
		(+ (* x x) (* (- y y0) (- y y0)) (* (- z z0) (- z z0)) (* -1 (* r r)))
	)
)

(define outerCage
	(lambda (x y z)
		(circEqn x y -719.12 z 362.55 764.56)
	)
)

(define innerCage
	(lambda (x y z)
		(circEqn x y -719.12 z 362.55 215.9)
	)
)



(define screen-move-loop	
	(lambda ( ThetaAngleDeg  yPos zPos dist name) 
		(cond 
			( ( > ThetaAngleDeg 0)
			(display "Outer Loop")
			(newline)
			(display OuterLoopNumber)
			(newline)
			(set! OuterLoopNumber (+ OuterLoopNumber 1))
				(cond  
					; ( (> xPos xPos _________________________________________________
					( (> yPos yPosTop) 'done1)
					( (> zPos zPosEnd) 'done2)
					; ( (> 
					(else	
						(display "Checked Else1")
						(newline)
						(move-screens name xPos yPos zPos)
						(display "Moved Screen1")
						(newline)
						(display InnerLoopNumber)
						(newline)
						(save_set_Survey 0 name InnerLoopNumber ThetaAngleDeg dist)
						(display "Saved Set1")
						(newline)
						(set! ThetaAngleRad (deg-to-rad ThetaAngleDeg))
						(set! yInc (* dist (sin ThetaAngleRad)))
						(set! zInc (* dist (cos ThetaAngleRad)))

						(display "Upper Inner Loop")
						(display InnerLoopNumber)
						(newline)
						(set! InnerLoopNumber (+ InnerLoopNumber 1))
						(screen-move-loop ThetaAngleDeg (+ yPos yInc) (+ zPos zInc) dist name)
					)
				)
			)
			(else
				(cond 
					( (< yPos yPosBottom) 'done1)
					( (> zPos zPosEnd) 'done2)
					(else	
						(display "Checked Else2")
						(newline)
						(move-screens name 0 yPos zPos)
						(display "Moved Screen2")
						(newline)
						(display InnerLoopNumber)
						(newline)
						(save_set_Survey 0 name InnerLoopNumber ThetaAngleDeg dist)
						(display "Saved Set2")
						(newline)
						(set! ThetaAngleRad (deg-to-rad ThetaAngleDeg))
						(set! yInc (* dist (sin ThetaAngleRad)))
						(set! zInc (* dist (cos ThetaAngleRad)))
						(display "Lower Inner Loop")
						(display InnerLoopNumber)
						(newline)
						(set! InnerLoopNumber (+ InnerLoopNumber 1))
						(screen-move-loop ThetaAngleDeg (+ yPos yInc) (+ zPos zInc) dist name)
					)
				)
			)
		)
	)
)

; AATEMPT AT MAKING IT PHI-DEP TOO
; (define screen-move-loop	
	; (lambda ( ThetaAngleDeg PhiAngleDeg xPos yPos zPos dist name) 
		; (cond 
			; ( ( > ThetaAngleDeg 0)
			; (display "Outer Loop")
			; (newline)
			; (display OuterLoopNumber)
			; (newline)
			; (set! OuterLoopNumber (+ OuterLoopNumber 1))
				; (cond  
					; ; ( (> xPos xPos _________________________________________________
					; ( (> yPos yPosTop) 'done1)
					; ( (> zPos zPosEnd) 'done2)
					; ; ( (> 
					; (else	
						; (display "Checked Else1")
						; (newline)
						; (move-screens name xPos yPos zPos)
						; (display "Moved Screen1")
						; (newline)
						; (display InnerLoopNumber)
						; (newline)
						; (save_set_Survey 0 name InnerLoopNumber ThetaAngleDeg dist)
						; (display "Saved Set1")
						; (newline)
						
						
						
						; (set! ThetaAngleRad (deg-to-rad ThetaAngleDeg))
						; (set! PhiAngleRad (deg-to-rad PhiAngleDeg))
						; (set! xInc (* dist (sin ThetaAngleRad) (cos PhiAngleRad)))
						; (set! yInc (* dist (sin ThetaAngleRad) (sin PhiAngleRad)))
						; (set! zInc (* dist (cos ThetaAngleRad)))

						; (display "Upper Inner Loop")
						; (display InnerLoopNumber)
						; (newline)
						; (set! InnerLoopNumber (+ InnerLoopNumber 1))
						; (screen-move-loop ThetaAngleDeg (+ xPos xInc) (+ yPos yInc) (+ zPos zInc) dist name)
					; )
				; )
			; )
			; (else
				; (cond 
					; ( (< yPos yPosBottom) 'done1)
					; ( (> zPos zPosEnd) 'done2)
					; (else	
						; (display "Checked Else2")
						; (newline)
						; (move-screens name 0 yPos zPos)
						; (display "Moved Screen2")
						; (newline)
						; (display InnerLoopNumber)
						; (newline)
						; (save_set_Survey 0 name InnerLoopNumber ThetaAngleDeg dist)
						; (display "Saved Set2")
						; (newline)
						; (set! ThetaAngleRad (deg-to-rad ThetaAngleDeg))
						; (set! yInc (* dist (sin ThetaAngleRad)))
						; (set! zInc (* dist (cos ThetaAngleRad)))
						; (display "Lower Inner Loop")
						; (display InnerLoopNumber)
						; (newline)
						; (set! InnerLoopNumber (+ InnerLoopNumber 1))
						; (screen-move-loop ThetaAngleDeg (+ yPos yInc) (+ zPos zInc) dist name)
					; )
				; )
			; )
		; )
	; )
; )

(define screen-run
	(lambda (ThetaAngleDeg dist)
		(define yPos -140)
		(define zPos 394.3)
		(set! OuterLoopNumber 0)
		(set! InnerLoopNumber 0)
		(define yInc 0)
		(define zInc 0)
		(define name (string-append "TestScreen_" (number->string ThetaAngleDeg) ))
		(cond 
			( (eqv? #t (entity? (entity:get-by-name name))) 'ScreenExists)
			(else	
				(make-screens (* -1 ThetaAngleDeg) 10 0 yPos zPos name)
				(display "Made Scren")
			)
		)
		(screen-move-loop ThetaAngleDeg yPos zPos dist name)
		
	)
)


(define distt 0)
(define AngleNeg 0)
(define AnglePos 0)


(define run-set-screen-cheese
	(lambda (SM1angle endSM1 incSM1 startSM2 finishSM2 increSM2 )
		(cond 
			((> SM1angle endSM1) 'done)
			(else
				(display "SM1 angle pre inc: ")
				(display SM1angle)
				(newline)
				(run SM1angle startSM2 finishSM2 increSM2)
				(display "done with run-restore")
				
				(set! distt 10)
				
				(screen-run AnglePos distt)
				(screen-run AngleNeg distt)
				
				(set! AnglePos (+ AnglePos 4))
				(set! AngleNeg (- AngleNeg 4))

				(restore SM1angle finishSM2)
				(newline)
				(run-set-screen-cheese (+ SM1angle incSM1) endSM1 incSM1 startSM2 finishSM2 increSM2)
			)
		)
	)
)

; (define beamIrr
	; (lambda (ThetaAngleDeg yPos zPos dist)
		; (screen-set-loop (ThetaAngleDeg yPos zPos dist))
		; (raytrace:all-sources)
			
		; (save_irr_Survey 0 ScreenName 
	; )
; )

		;(save_irr 0 "LPFrontScreen" anglesSM1 orig "LPFrontScreen")