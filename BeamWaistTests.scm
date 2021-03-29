;This code is to test the effect of the position lenses on the focal length of the beam
; for the full setup of the system. It collects irradiance screen data at 0 deg for
; a variety of L1 and L2 positions with a constant separation

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

(define yPosTop 45)

; yPosBottom = -503 for Inner Field Cage
;(define yPosBottom -503)

; yPosBottom for no Inner field cage
(define yPosBottom -1483)

(define zPosEnd 1362.55)

; (define NameDown " ")
; (define NameUp " ")
(define TestScreen "TestScreen")
(define rootPathSurvey "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/Survey/II_0deg_WithMirrors_LPChamf/II")

(define delete
	(lambda (name)
		(geometry:delete (entity:get-by-name name))
	)
)

(define save_irr_Survey
	(lambda(surface en num anglee dist sep count)
		(edit:select (tools:face-in-body surface (entity:get-by-name en)))
		(analysis:irradiance)
		;(analysis:irradiance-save (string-append rootPathSurvey "_Irr_" en "_DistInc_" (number->string dist) "_" (number->string num) ".txt" ))
		(analysis:irradiance-save (string-append rootPathSurvey "_Irr_" en "_DistInc_" (number->string dist) "_ScreenNum_" (number->string num) "_LensSep_" (number->string sep) "_FirstLensPos_" (number->string count) ".txt" ))

		(newline)
		(analysis:irradiance-close)
	)
)


(define save_set_Survey
	(lambda (surface en num anglee dist sep count)
		(raytrace:all-sources)
		(save_irr_Survey surface en num anglee dist sep count)
	)
)

(define screen-move-loop	
	(lambda ( ThetaAngleDeg  yPos zPos dist name sep count) 
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
						(save_set_Survey 0 name InnerLoopNumber ThetaAngleDeg dist sep count)
						(display "Saved Set1")
						(newline)
						(set! ThetaAngleRad (deg-to-rad ThetaAngleDeg))
						(set! yInc (* dist (sin ThetaAngleRad)))
						(set! zInc (* dist (cos ThetaAngleRad)))

						(display "Upper Inner Loop")
						(display InnerLoopNumber)
						(newline)
						(set! InnerLoopNumber (+ InnerLoopNumber 1))
						(screen-move-loop ThetaAngleDeg (+ yPos yInc) (+ zPos zInc) dist name sep count)
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
						(save_set_Survey 0 name InnerLoopNumber ThetaAngleDeg dist sep count)
						(display "Saved Set2")
						(newline)
						(set! ThetaAngleRad (deg-to-rad ThetaAngleDeg))
						(set! yInc (* dist (sin ThetaAngleRad)))
						(set! zInc (* dist (cos ThetaAngleRad)))
						(display "Lower Inner Loop")
						(display InnerLoopNumber)
						(newline)
						(set! InnerLoopNumber (+ InnerLoopNumber 1))
						(screen-move-loop ThetaAngleDeg (+ yPos yInc) (+ zPos zInc) dist name sep count)
					)
				)
			)
		)
	)
)

(define screen-run
	(lambda (ThetaAngleDeg dist sep count)
		(define yPos -140)
		(define zPos 400)
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
		(screen-move-loop ThetaAngleDeg yPos zPos dist name sep count)
		
	)
)

(define distt 0)
(define AngleNeg 0)
(define AnglePos 0)



(display "done!")



(define move-lens
	(lambda ( en xMove yMove zMove)
		(edit:move (entity:get-by-name en) xMove yMove zMove)
	)
)

(define count 0)
(define angleTest 0)

(define test-beam-waist
	(lambda (screenInc lensSeparation yStartFirst yEndFirst yInc)
		(cond 
			( (< yStartFirst yEndFirst) 'done)
			( else
				(set! angleTest 0)
				(screen-run angleTest screenInc lensSeparation yStartFirst)
				(move-lens "-250_Lens" -38 (- yStartFirst yInc) 60.538)
				(move-lens "+250_Lens" -38 (- (- yStartFirst lensSeparation) yInc) 60.538)
				(define screenName (string-append "TestScreen_" (number->string angleTest) ))
				(delete screenName)
				(test-beam-waist screenInc lensSeparation (- yStartFirst yInc) yEndFirst yInc)
			)
		)
	)
)



(define beam-run
	(lambda (screenInc lensSeparation yStartFirst yEndFirst yInc)
		(run-nominal -30)
		(test-beam-waist screenInc lensSeparation yStartFirst yEndFirst yInc)
		(move-lens "-250_Lens" -38 5 60.538)
		(move-lens "+250_Lens" -38 -45 60.538)
		(restore -30 0)
	)
)
