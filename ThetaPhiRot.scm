; Code to run phi/theta rotations and save data
; Currently not working, still need to get theta and phi rots at 
; same time.



(define rootPath "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/Rot/Wedge" )
	; defines the root Path for the csvs to save to
	
(define rootPathPhi "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/Rot/Phi")

(define rootPathThetaPhi "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/ThetaPhi/Angular2")
	
	
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




(define rot
	(lambda (SM angle1)
		(edit:clear-selection)
		(edit:rotate (entity:get-by-name SM) 0 -140 245 1 0 0 angle1)
	)
)
; Rotates an object with entity name SM about a fixed point (0, -140, 245) by "angle" about x-axis
; Can probably generalize center point if necessary

(define rot-phi
	(lambda (SM angle1)
		(edit:clear-selection)
		(edit:rotate (entity:get-by-name SM) 0 -140 245 0 0 1 angle1)
	)
)
; Rotates the object about the z axis for the phi rotation



(define run-theta
	(lambda ( angle2 )
		(rot "SM1" angle2)	; rot SM1 (#7)
		(rot "SM2" (* 2 angle2)) ; rot SM2 (#3) by twice angle
		(raytrace:all-sources)
	)
)
;Rotates to a single theta (both SM1+2) and raytraces

(define run-phi
	(lambda ( angle2 )
		(rot-phi "SM1" angle2)	; rot SM1 (#7)
		(rot-phi "SM2" angle2) ; rot SM2 (#3) 
		(rot-phi "Second Leg Tube" angle2) ; rot the tube
	)
)

;Rotates to a single phi; rotates SM1 by angle2 and SM2 by 2*angle 2 to rotate to where the laser hits SM2 dead center, then raytraces

; (define save-incident
	; (lambda (surface en angleSM1 angleSM2 name anglePhi)
		; (edit:select (tools:face-in-body surface (entity:get-by-name en)))
		; (analysis:incident)
		; (analysis:incident-save (string-append rootPathThetaPhi "/" "BP_0.001deg" "_Phi_" (number->string ( round-off anglePhi 2 )) "_SM1_" (number->string (round-off angleSM1 2)) "_SM2_" (number->string (round-off angleSM2 2)) "_Incident" "_" name   ".csv" ) "csv"	#f)
		; (newline)
		; (analysis:incident-close)
	; )
; )
; ; A procedure to save the incident ray table for a entity "en" at surface # "surface". It saves the file as "Incident_"name"_SM1"angleSM1"_SM2_"angleSM2""

; (define save-irradiance
	; (lambda (surface en angleSM1 angleSM2 name anglePhi)
		; (edit:select (tools:face-in-body surface (entity:get-by-name en)))
		; (analysis:irradiance)
		; (analysis:irradiance-save (string-append rootPathThetaPhi "/" "BP_0.001deg" "_Phi_" (number->string ( round-off anglePhi 2 )) "_SM1_" (number->string (round-off angleSM1 2)) "_SM2_" (number->string (round-off angleSM2 2)) "_Irradiance" "_" name   ".jpg" ))
		; (newline)
		; (analysis:incident-close)
	; )
; )

; (define save-candela
	; (lambda (surface en angleSM1 angleSM2 name anglePhi)
		; (edit:select (tools:face-in-body surface (entity:get-by-name en)))
		; (analysis:candela "polar")
		; (analysis:candela-save-bmp "polar-iso" (string-append rootPathThetaPhi "/" "Test" "_Phi_" (number->string ( round-off anglePhi 2 )) "_SM1_" (number->string (round-off angleSM1 2)) "_SM2_" (number->string (round-off angleSM2 2)) "_Candela" "_" name   ".bmp" ))
		; (newline)
		; (analysis:incident-close)
	; )
; )

(define save-incident
	(lambda (surface en name )
		(edit:select (tools:face-in-body surface (entity:get-by-name en)))
		(analysis:incident)
		(analysis:incident-save (string-append rootPathThetaPhi "/" "Angular_LP_0" "_Incident" "_" name   ".csv" ) "csv"	#f)
		(newline)
		(analysis:incident-close)
	)
)
; A procedure to save the incident ray table for a entity "en" at surface # "surface". It saves the file as "Incident_"name"_SM1"angleSM1"_SM2_"angleSM2""

(define save-irradiance
	(lambda (surface en name )
		(edit:select (tools:face-in-body surface (entity:get-by-name en)))
		(analysis:irradiance)
		(analysis:irradiance-save (string-append rootPathThetaPhi "/" "Angular_LP_0" "_Irradiance" "_" name   ".jpg" ))
		(analysis:irradiance-save (string-append rootPathThetaPhi "/" "Angular_LP_0" "_Irradiance" "_" name   ".csv" ))
		(analysis:irradiance-save (string-append rootPathThetaPhi "/" "Angular_LP_0" "_Irradiance" "_" name   ".txt" ))
		(newline)
		(analysis:irradiance-close)
	)
)

(define save-candela
	(lambda (surface en name )
		(edit:select (tools:face-in-body surface (entity:get-by-name en)))
		(analysis:candela "polar")
		(analysis:candela-save-bmp "polar-iso" (string-append rootPathThetaPhi "/" "Angular_LP_0" "_Candela" "_" name   ".bmp" ))
		(analysis:candela-save-txt "polar-iso" (string-append rootPathThetaPhi "/" "Angular_LP_0" "_Candela" "_" name   ".csv" ))
		(analysis:candela-save-txt "polar-iso" (string-append rootPathThetaPhi "/" "Angular_LP_0" "_Candela" "_" name   ".txt" ))
		(newline)
		(analysis:candela-close "polar-iso")
	)
)

(define save-set
	(lambda ()
		(raytrace:all-sources)
		(save-incident 6 "LPChamf"  "LPEnd" )
		(save-incident 9 "LPChamf"  "LPFront" ) 
		(save-irradiance 6 "LPChamf" "LPEnd" )
		(save-irradiance 9 "LPChamf"  "LPFront" ) 
		(save-candela 6 "LPChamf"  "LPEnd" )
		(save-candela 9 "LPChamf" "LPFront" ) 
		
		; (save-incident 4 "LP_0.001"  "LPEnd" )
		; (save-incident 5 "LP_0.001"  "LPFront" ) 
		; (save-irradiance 4 "LP_0.001" "LPEnd" )
		; (save-irradiance 5 "LP_0.001"  "LPFront" ) 
		; (save-candela 4 "LP_0.001"  "LPEnd" )
		; (save-candela 5 "LP_0.001" "LPFront" ) 
		
		; (save-incident 4 "LP_3"  "LPEnd" )
		; (save-incident 5 "LP_3"  "LPFront" ) 
		; (save-irradiance 4 "LP_3" "LPEnd" )
		; (save-irradiance 5 "LP_3"  "LPFront" ) 
		; (save-candela 4 "LP_3"  "LPEnd" )
		; (save-candela 5 "LP_3" "LPFront" ) 
		(display "done!")
	)
)

(define run-save
   (lambda (angleSM2 orig angleSM1 anglePhi)
		(rot "SM2" angleSM2)
		(raytrace:all-sources)
		(save-incident 4 "LP_0.001" angleSM1 orig "LPEnd" anglePhi)
		(save-incident 5 "LP_0.001" angleSM1 orig "LPFront" anglePhi) 
		(save-irradiance 4 "LP_0.001" angleSM1 orig "LPEnd" anglePhi)
		(save-irradiance 5 "LP_0.001" angleSM1 orig "LPFront" anglePhi) 
		(save-candela 4 "LP_0.001" angleSM1 orig "LPEnd" anglePhi)
		(save-candela 5 "LP_0.001" angleSM1 orig "LPFront" anglePhi) 
		
		; (save-incident 4 "LP_3" angleSM1 orig "LPEnd" anglePhi)
		; (save-incident 5 "LP_3" angleSM1 orig "LPFront" anglePhi) 
		; (save-irradiance 4 "LP_3" angleSM1 orig "LPEnd" anglePhi)
		; (save-irradiance 5 "LP_3" angleSM1 orig "LPFront" anglePhi) 
		
		; (save-incident 6 "LPChamf" angleSM1 orig "LPEnd" anglePhi)
		; (save-incident 9 "LPChamf" angleSM1 orig "LPFront" anglePhi) 
		; (save-irradiance 6 "LPChamf" angleSM1 orig "LPEnd" anglePhi)
		; (save-irradiance 9 "LPChamf" angleSM1 orig "LPFront" anglePhi) 
		(display "run-save readout #:")
		(display orig)
		(newline)
	)
)


; a procedure to rotate just SM2, run the raytrace, then save the incident ray table for CMTop, CMBottom, and the front and end of the light pipe. anglesSM1 is used to name the file.
; Can tell which CM was hit by size of excel file; if no hit, only 1 KB


(define loop-theta
	(lambda ( init end SM1 incr anglePhi)
		(cond
			( (> init (- end incr) ) 'done )
			( (<= init (- end incr))
				(round-off init 3)
				(run-save incr (+ init incr)  SM1 anglePhi)
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
				(loop-theta init end (round-off SM1 3) incr anglePhi)
			)
		)
	)
)
;The loop takes a starting angle init and end angle end, and runs run-save for SM2 from init to end by increment incr. SM1 is just used for naming purpose here.


(define run-theta-loop
	(lambda( SM1angle start finish incre anglePhi)
		(run-theta SM1angle)
		(run-save start start SM1angle anglePhi)
		(loop-theta start finish SM1angle incre anglePhi)
	)
)
;For a given SM1angle, starting SM2 angle start and finish, and increment, first runs rot-theta, then loops throgh the SM2 angles.
;Result- For one SM1 angle, saves incident ray table for each SM2 angle requested.

(define run-single
	(lambda(SM1angle SM2angle)
		(run-theta SM1angle)
		(rot "SM2" SM2angle)
		(raytrace:all-sources)
	)
)

(define restore	
	(lambda (SM1angle end)
		(run-theta (* -1 SM1angle))
		(rot "SM2" (* -1 end))
		(raytrace:all-sources)
	)
)

(define restore-phi	
	(lambda (phiAngle)
		(run-phi (* -1 phiAngle))
	)
)

;Rotates SM1 and 2 back to original position by giving it the SM1angle and SM2 angle 'end'

(define run-restore-theta
	(lambda (SM1angle start finish incre anglePhi)
		(run-theta-loop SM1angle start finish incre anglePhi)
		(restore SM1angle finish)
	)
)
;Does the run procedure then restores it with those numbers

(define run-set-theta	
	(lambda (SM1angle endSM1 incSM1 startSM2 finishSM2 increSM2 anglePhi )
		(cond 
			((> SM1angle endSM1) 'done)
			(else
				(display "SM1 angle pre inc: ")
				(display SM1angle)
				(newline)
				(run-restore-theta SM1angle startSM2 finishSM2 increSM2 anglePhi)
				(display "done with run-restore")
				(newline)
				(run-set-theta (+ SM1angle incSM1) endSM1 incSM1 startSM2 finishSM2 increSM2 anglePhi)
			)
		)
	)
)
; Loops the run-restore procedure so that it can also loop over multiple SM1 angles as well.

;AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA



(define run-all
	(lambda (startPhi endPhi incPhi startSM1 endSM1 incSM1 startSM2 endSM2 incSM2)
		(cond 
			((> startPhi endPhi) 'done)
			(else
				(display "Phi angle pre inc: ")
				(display startPhi)
				(newline)
				(run-phi startPhi)
				(run-set-theta startSM1 endSM1 incSM1 startSM2 endSM2 incSM2 startPhi)
				(restore-phi startPhi)
				(display "done with run-restore")
				(newline)
				(run-all (+ startPhi incPhi) endPhi incPhi startSM1 endSM1 incSM1 startSM2 endSM2 incSM2)
			)
		)
	)
)

; I think I need to make the interior loop seperate (run-theta-loop) and build in the run-phi loop into the final loop; if they were seperate, 
; it would run the whole phi loop before getting to theta and not increment



; For diff tests, CHANGE raytrace:all-sources to (raytrace:file-source "Name")