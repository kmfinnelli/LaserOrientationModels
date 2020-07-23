(define rootPath "C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/Rot/Wedge6/" )
	; defines the root Path for the csvs to save to

(define switch-wedge
	(lambda ( current next)
		(property:set-raytrace-flag (entity current) #f) ; 8 deg
		(property:set-raytrace-flag (entity next) #t)
	)
)

; Give the entity #'s for the wedges you want to change
; 6 deg= 11, 8 deg=12, 10 deg=13, 12 deg=14
; Could also make it so they go invisible as well for visuals

(define rot
	(lambda (num angle1)
		(edit:clear-selection)
		(edit:rotate (entity num) 0 -140 245 1 0 0 angle1)
	)
)
; Rotates an object with entity # "num" about a fixed point (0, -140, 245) by "angle"
; Can probably generalize center point if necessary

(define rot-ray
	(lambda (num angle1)
		(edit:clear-selection)
		(edit:rotate (entity num) 0 -140 245 1 0 0 angle1)
		(raytrace:all-sources)
	)
)
; rotates an object with rot then raytraces


(define run-nominal
	(lambda ( angle2 )
		(rot 7 angle2)	; rot SM1 (#7)
		(rot 3 (* 2 angle2)) ; rot SM2 (#3) by twice angle
		(raytrace:all-sources)
	)
)
;rotates SM1 by angle2 and SM2 by 2*angle 2 to rotate to where the laser hits SM2 dead center, then raytraces

(define save
	(lambda (surface en angleSM1 angleSM2 name)
		(edit:select (tools:face-in-body surface (entity en)))
		(analysis:incident)
		(analysis:incident-save (string-append rootPath "Incident_Wedge6_" name "_SM1_" (number->string angleSM1) "_SM2_" (number->string angleSM2) ".csv" ) "csv"	#f)
		(newline)
		(analysis:incident-close)
	)
)
; A procedure to save the incident ray table for a entity "en" at surface # "surface". It saves the file as "Incident_"name"_SM1"angleSM1"_SM2_"angleSM2""



(define run-save
   (lambda (angle4 orig anglesSM1)
		(rot 3 angle4)
		(raytrace:all-sources)
		(save 0 15 anglesSM1 orig "CMTop")
		(save 0 16 anglesSM1 orig "CMBottom")
		(save 6 19 anglesSM1 orig "LightPipeChamf")
		(display "run-save readout #" )
		(display orig)
		(newline)
	)
)
; a procedure to rotate just SM2, run the raytrace, then save the incident ray table for CMTop, CMBottom, and the end of the light pipe. anglesSM1 is used to name the file.
; Can tell which CM was hit by size of excel file; if no hit, only 1 KB


(define loop
	(lambda ( init end SM1 incr)
		(cond
			( (> init (- end incr) ) 'done )
			( (<= init (- end incr))
				(run-save incr (+ init incr)  SM1 )
				(display "loop pre inc init:")
				(display init)
				(newline)
				(set! init (+ init incr))
				(display "loop post inc init:")
				(display init)
				(newline)
				(loop init end SM1 incr)
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


(define restore	
	(lambda (SM1angle end)
		(run-nominal (* -1 SM1angle))
		(rot 3 (* -1 end))
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


(newline)