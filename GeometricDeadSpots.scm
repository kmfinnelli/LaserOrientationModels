; Code to collect info for Geometric Dead spots test.
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



; rot: Rotates an object with entity # "num" about a fixed point (0, -140, 245) by
; "angle" in Theta
(define rot
	(lambda (SM angle1)
		(edit:clear-selection)
		(edit:rotate (entity:get-by-name SM) 0 -140 245 1 0 0 angle1)
	)
)



(define move-source
	(lambda ( xSpot ySpot zSpot)
		(edit:clear-selection)
		(edit:move-grid-source "Fake Mirrors" xSpot ySpot zSpot)
		(raytrace:all-sources)
	)
)

(define PI 3.14159)

(define deg-to-rad
	(lambda (AngleDeg)
		(* AngleDeg (/ PI 180))
	)
)

(define xPos 0)
(define yPos 0)
(define zPos 0)

(define move-source-angles
	(lambda (r theta phi)
		(edit:clear-selection)
		(set! xPos (* r (* (sin (deg-to-rad theta)) (cos (deg-to-rad phi)))))
		(set! yPos (* r (* (sin (deg-to-rad theta)) (sin (deg-to-rad phi)))))		
		(set! zPos (* r (cos (deg-to-rad theta)) ))
		(move-source xPos yPos zPos)
		(raytrace:all-sources)
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

(define rot-source-angles	
	(lambda (r theta phi)
		(edit:clear-selection)
		(rot-source 0 -140 248.25 r 0 0 theta)
		(rot-source 0 -140 248.25 0 0 r phi)
		(raytrace:all-sources)
	)
)

(define restore-rot-source-angles
	(lambda (r theta phi)
		(edit:clear-selection)
		(rot-source 0 -140 248.25 0 0 r (* -1 phi))
		(rot-source 0 -140 248.25 r 0 0 (* -1 theta))		
		(raytrace:all-sources)
	)
)

(define dPos -3)
(define dEnd 3)
(define xMove 0)
(define yMove 0)
(define xMoveInc 0)
(define yMoveInc 0)


(define move-loop
	(lambda (r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
		(cond
			( (> dPos dEnd) 'doneD)
			(else
				(set! xMoveInc (* dInc (sin (deg-to-rad phiStart))))
				(set! yMoveInc (* dInc (cos (deg-to-rad phiStart))))
				(display (string-append "xMoveInc=" (number->string xMoveInc) " and yMoveInc=" (number->string yMoveInc)))
				(newline)
				(move-source xMoveInc yMoveInc 0)
				(display (string-append "Save here for theta=" (number->string thetaStart) ", phi=" (number->string phiStart) ", and d=" (number->string dPos)))
				(newline)
				;(save-set r thetaStart phiStart dPos)
				(move-loop r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc (+ dPos dInc) dEnd dInc)
			)
		)
	)
)


(define phi-loop
	(lambda (r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
		(cond 
			((> phiStart phiEnd) 'donePhi)
			(else
				(rot-source-angles r thetaStart phiStart)
				(set! xMove (* dPos (sin (deg-to-rad phiStart))))
				(set! yMove (* dPos (cos (deg-to-rad phiStart))))
				(display (string-append "xMove=" (number->string xMove) " and yMove=" (number->string yMove)))
				(newline)
				(move-source xMove yMove 0)
				(display (string-append "Starting move-loop at theta=" (number->string thetaStart ) " and phi=" (number->string phiStart)))
				(newline)
				(move-loop r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
				(move-source xMove yMove 0)
				(display "Moved back to center for Phi")
				(newline)
				(restore-rot-source-angles r 0 phiStart)
				(display "Phi restored")
				(newline)
				
				(phi-loop r thetaStart thetaEnd thetaInc (+ phiStart phiInc) phiEnd phiInc dPos dEnd dInc)

			)
		)
	)
)


(define loop-stuff	
	(lambda (r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
		(cond
			( (> thetaStart thetaEnd) 'doneTheta)
			( else
				(display (string-append "Starting phi-loop at theta=" (number->string thetaStart)))
				(newline)
				(phi-loop r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
				(loop-stuff r (+ thetaStart thetaInc) thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
			)
		)
	)
)


(define run-loop
	(lambda (r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
		(loop-stuff r thetaStart thetaEnd thetaInc phiStart phiEnd phiInc dPos dEnd dInc)
		(set! xMove (* dPos (sin (deg-to-rad phiStart))))
		(set! yMove (* dPos (cos (deg-to-rad phiStart))))
		(move-source xMove yMove 0)
		(display "Moved back to center")
		(newline)
		(restore-rot-source-angles r thetaStart phiStart)
		(display "Angle restored")
		(newline)
	)
)


; ;save: Saves 
; (define save-gen-incident
	; (lambda (surface en angleSM1 angleSM2 name)
		; (edit:select (tools:face-in-body surface (entity:get-by-name en)))
		; (analysis:incident)
		; (analysis:incident-save (string-append rootPath (number->string whichWedge) "/" "Incident_Wedge" (number->string whichWedge) "_" name "_SM1_" (number->string (round-off angleSM1 2)) "_SM2_" (number->string (round-off angleSM2 2)) ".csv" ) "csv"	#f)
		; (newline)
		; (analysis:incident-close)
	; )
; )



; (define save-theta
	; (lamda ()
		; save-gen( ; put rootpath and stuff here for diff theta/phi
		
		; )))


; (define rootPath "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/Survey/IISimpleSet_BarMoved/BeamWaistSampleTestsBar")

; (define save
	; (lambda (choiceInIrr choiceThetaPhi rootPath surface en Angle1 Angle2 name)
		; (edit:select (tools:face-in-body surface (entity:get-by-name en)))
		; (cond
			; ( (eqv? choiceInIrr "Incident")
				; (analysis:incident)
				; (analysis:incident-save (string-append rootPath (number->string whichWedge) "/" "Incident_Wedge" (number->string whichWedge) "_" name "_SM1_" (number->string (round-off angleSM1 2)) "_SM2_" (number->string (round-off angleSM2 2)) ".csv" ) "csv"	#f)
				; (newline)
				; (analysis:incident-close)
			; )
			; ( (eqv? choiceInIrr "Irrandiance")
				; (analysis:irradiance)
				; (analysis:irradiance-save (string-append rootPath "_Irr_" en "_DistInc_" (number->string dist) "_ScreenNum_" (number->string num) "_LensSep_" (number->string sep) "_FirstLensPos_" (number->string count) ".txt" ))
				; (newline)
				; (analysis:irradiance-close)
			; )
			; (else 'Wrong)
		; )
	; )
; )

; (define save
	; (lambda (choiceInIrr choiceThetaPhi rootPath surface en Angle1 Angle2 name)
		; (edit:select (tools:face-in-body surface (entity:get-by-name en)))
		; (cond
			; ( (eqv? choiceThetaPhi "Theta")
				; (cond
					; ( (eqv? choiceInIrr "Incident")
						; (analysis:incident)
						; (analysis:incident-save (string-append rootPath (number->string whichWedge) "/" "Incident_Wedge" (number->string whichWedge) "_" name "_SM1_" (number->string (round-off angleSM1 2)) "_SM2_" (number->string (round-off angleSM2 2)) ".csv" ) "csv"	#f)
						; (newline)
						; (analysis:incident-close)
					; )
					; ( (eqv? choiceInIrr "Irrandiance")
						; (analysis:irradiance)
						; (analysis:irradiance-save (string-append rootPath "_Irr_" en "_DistInc_" (number->string dist) "_ScreenNum_" (number->string num) "_LensSep_" (number->string sep) "_FirstLensPos_" (number->string count) ".txt" ))
						; (newline)
						; (analysis:irradiance-close)
					; )
					; (else 'WrongInIrrChoice)
				; )
			; )
			; ( (eqv? choiceThetaPhi "Phi")
				; (cond
					; ( (eqv? choiceInIrr "Incident")
						; (analysis:incident)
						; (analysis:incident-save (string-append rootPath (number->string whichWedge) "/" "Incident_Wedge" (number->string whichWedge) "_" name "_SM1_" (number->string (round-off angleSM1 2)) "_SM2_" (number->string (round-off angleSM2 2)) ".csv" ) "csv"	#f)
						; (newline)
						; (analysis:incident-close)
					; )
					; ( (eqv? choiceInIrr "Irrandiance")
						; (analysis:irradiance)
						; (analysis:irradiance-save (string-append rootPath "_Irr_" en "_DistInc_" (number->string dist) "_ScreenNum_" (number->string num) "_LensSep_" (number->string sep) "_FirstLensPos_" (number->string count) ".txt" ))
						; (newline)
						; (analysis:irradiance-close)
					; )
					; (else 'WrongInIrrChoice)
				; )
			; )
			; (else 'WrongThetaPhiChoice)
		; )
	; )
; )
; (string-append rootpath "_Inc_" en )


; ;Theta or Phi?
; ;	Irr or Inc?
		


; ; Rotates grid source about position at angle around a certain axis




; (define get-set	
	; (lambda ()
		
	
		
		
		
	; )
; )
