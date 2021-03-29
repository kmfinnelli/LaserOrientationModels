;This code finds the Ionization Intensity of a beam at a given angle. 
; For rotation ONLY theta at paired mirror angles (no moving them separately), it 
; collects the irradaiance screens along the beam path.

(display "start!")

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

(define angle1 0)

(define rot
	(lambda (SM angle1)
		(edit:clear-selection)
		(edit:rotate (entity:get-by-name SM) 0 -140 245 1 0 0 angle1)
	)
)

(define run-nominal 
	(lambda (SM1angle)
		(rot "SM1" SM1angle)
		(rot "SM2" (* 2 SM1angle))
		(raytrace:all-sources)
	)
)

(define run-display
   (lambda (angle4 orig )
		(rot "SM2" angle4)
		(raytrace:all-sources)
		(display "run-save readout #:")
		(display orig)
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
				(run-display incr (+ init incr) )
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
		(run-display start start)
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



(newline)

(define PI 3.14159)

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

(define yPosTop 45)

; yPosBottom = -503 for Inner Field Cage
; (define yPosBottom -503)

; yPosBottom for no Inner field cage
(define yPosBottom -1483)

(define zPosEnd 1362.55)

; (define NameDown " ")
; (define NameUp " ")
(define TestScreen "TestScreen")
(define rootPathSurvey "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/Survey/MidCase/II")

(define delete
	(lambda (name)
		(geometry:delete (entity:get-by-name name))
	)
)

(define save_irr_Survey
	(lambda(surface en num anglee dist )
		(edit:select (tools:face-in-body surface (entity:get-by-name en)))
		(analysis:irradiance)
		(analysis:irradiance-save (string-append rootPathSurvey "_Irr_" en "_DistInc_" (number->string dist) "_" (number->string num) ".txt" ))
		(newline)
		(analysis:irradiance-close)
	)
)


(define save_set_Survey
	(lambda (surface en num anglee dist)
		(raytrace:all-sources)
		(save_irr_Survey surface en num anglee dist)
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
						(move-screens name 0 yPos zPos)
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
	(lambda (SM1angle endSM1 incSM1 distt)
		(cond 
			((> SM1angle endSM1) 'done)
			(else
				(display "SM1 angle pre inc: ")
				(display SM1angle)
				(newline)
				(run SM1angle 0 0 1)
				(display "done with run-restore")
				
				
				(screen-run AnglePos distt)
				(screen-run AngleNeg distt)
				
				(define screenNamePos (string-append "TestScreen_" (number->string AnglePos) ))
				(define screenNameNeg (string-append "TestScreen_" (number->string AngleNeg) ))
				
				(delete screenNamePos)
				(delete screenNameNeg)
				
				(set! AnglePos (+ AnglePos (* 2 incSM1)))
				(set! AngleNeg (- AngleNeg (* 2 incSM1)))

				(restore SM1angle 0)
				(newline)
				(run-set-screen-cheese (+ SM1angle incSM1) endSM1 incSM1 distt)
			)
		)
	)
)

(display "done!")


(define screen-set-angles	
	(lambda (SM1angle endSM1 incSM1 dist ThetaOrig)
		(set! AnglePos ThetaOrig)
		(set! AngleNeg (* -1 ThetaOrig))
		(run-set-screen-cheese SM1angle endSM1 incSM1 dist)
	)
)


(define move-lens
	(lambda ( en xMove yMove zMove)
		(edit:move (entity:get-by-name en) xMove yMove zMove)
	)
)


(define test-beam-waist
	(lambda (screenInc yStartFirst yEndFirst yInc)
		(cond 
			( (< yStartFirst (- yEndFirst yInc)) 'done)
			( else
				(screen-run 0 screenInc)
				; (run -30 0 0 1)
				(move-lens "-250_Lens" 0 (- yStartFirst yInc) 0)
				(move-lens "+250_Lens" 0 (- (- yStartFirst 50) yInc) 0)
				(test-beam-waist screenInc (- yStartFirst yInc) yEndFirst yInc)
			)
		)
	)
)


			