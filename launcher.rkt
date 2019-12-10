(load "flappy-bird.rkt")

(define
	IMG-TITLE
		(cond
			(
				(equal?
					(find-system-path
						'sys-dir
					)
					(string->path
						"C:\\WINDOWS\\system32\\"
					)
				) ; WINDOWS
				(make-object
					bitmap%
					"assets\\img\\title.png"
				)
			)
			(
				(equal?
					(find-system-path
						'sys-dir
					)
					(string->path
						"/"
					)
				) ; LINUX / MAC OS
				(make-object
					bitmap%
					"assets/img/title.png"
				)
			)
		)
)

(define
	frame
		(new
			frame%
			[label
				"Flappy Bird Launcher"
			]
			[width
				288
			]
			[height
				150
			]
			[style
				'(no-resize-border)
			]
			[alignment
				'(center center)
			]
		)
)

(define
	mcan%
		(class
			canvas%
			(override on-paint)
			(define
				on-paint
					(lambda
						()
						(send
							(send
								this
								get-dc
							)
							draw-bitmap
							IMG-TITLE
							50
							10
						)
					)
			)
			(super-instantiate())
		)
)

(define
	mcan
		(new
			mcan%
			[parent
				frame
			]
			[style
				'(transparent)
			]
			[min-width
				(image-width
					IMG-TITLE
				)
			]
			[min-height
				(image-height
					IMG-TITLE
				)
			]
		)
)

(new
	button%
	[parent
		frame
	]
	[label
		"▶"
	]
	; Callback procedure for a button click:
	[callback
		(lambda
			(button
				event
			)
			(flappy-bird
				0
				#f
			)
		)
	]
)

(new
	button%
	[parent
		frame
	]
	[label
		"❔"
	]
	; Callback procedure for a button click:
	[callback
		(lambda
			(button
				event
			)
			(flappy-bird
				0
				#t
			)
		)
	]
)

(send
	frame
	show
	#t
)