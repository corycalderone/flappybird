;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname flappy-bird) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define BG .)

(define FG .)

(define PIPE-1 .)
(define PIPE-2 .)
;(define BIRD-IMG .)
(define BIRD-IMG .)

(define BIRD-X 75) ; default x-position of the bird, it does not move horizontally (i.e., this is static.)

(define PIPE-1-INIT-X 510) ; there are two sets of pipes moving on the "conveyor belt." this is the x for the first set...
(define PIPE-1-INIT-Y 300) ; ...and here is the y...
(define PIPE-2-INIT-X 2000) ; ... and the x for the second set...
(define PIPE-2-INIT-Y 500) ; ...and the second set's y.
(define RANDOM-LIMIT 250) ; upper bound randomly generating y-displacement for pipe heights
(define RANDOM-ADDER 70) ; constant to be added to rand numbers
(define X-DISP 5) ; increments by which we move the pipes

; bird-y, ground-x, pipe-1-x, pipe-1-y, pipe-2-x, pipe-2-y
(define-struct coords [by gx p1x p1y p2x p2y])

(define (flappy-bird INIT-WINDOW)
  (big-bang (make-coords 150 250 PIPE-1-INIT-X (+ (random RANDOM-LIMIT) RANDOM-ADDER) PIPE-2-INIT-X (+ (random RANDOM-LIMIT) RANDOM-ADDER)) ; [by gx p1x p1y p2x p2y]
            [on-tick move-window]
            [on-key move-bird]
            [to-draw draw-window]))


(define (move-bird coords ke)
  (cond 
    [(key=? ke "w") (make-coords (- (coords-by coords) 10) (ground-helper(coords-gx coords))
                                 (coords-p1x coords)
                                 (coords-p1y coords)
                                 (coords-p2x coords)
                                 (coords-p2y coords))]

    [(key=? ke "s")(make-coords (+ (coords-by coords) 10)(coords-gx coords)
                                (coords-p1x coords)
                                (coords-p1y coords)
                                (coords-p2x coords)
                                (coords-p2y coords))] 
    
    [else coords]))

(define (move-window coords) ; on-tick
  (cond
    [(collision? coords) -1]
    [else (make-coords (coords-by coords)
                      (ground-helper (coords-gx coords))
                      (pipe-helper/1 (coords-p1x coords))
                      (randomize-y (coords-p1x coords) (coords-p1y coords))
                      (pipe-helper/2 (coords-p2x coords) (coords-p1x coords))
                      (randomize-y (coords-p2x coords) (coords-p2y coords)))]))

(define (pipe-helper/1 x) ; on-tick/h
  (if (= -50 x)
      575
      (- x X-DISP)))

(define (pipe-helper/2 x adder) ; on-tick/h
  (if (= -50 x)
      (+ 500 adder)
      (- x X-DISP)))

(define (randomize-y x y)
  (if (= -50 x)
      (+ (random RANDOM-LIMIT) RANDOM-ADDER)
      y))
  
(define (ground-helper x)
  (if (= 0 x)
      250
      (- x X-DISP)))

; (flappy-bird 0)

(define PIPE-DISP 50)

(define (collision? coords)
   (or (= (- (coords-p1x coords) PIPE-DISP) BIRD-X)
       (= (- (coords-p2x coords) PIPE-DISP) BIRD-X)))

(define (draw-window coords); to-draw
  (cond
    [(number? coords) (place-image (text "GAME OVER LOSER LOL" 30 "WHITE") 250 250
                    (place-image FG 0 250
                                BG))]
    [else (place-image BIRD-IMG BIRD-X (coords-by coords)
                  (place-image FG (coords-gx coords) 250
                               (place-image PIPE-1 (coords-p1x coords) (coords-p1y coords)
                                            (place-image PIPE-2 (coords-p2x coords) (coords-p2y coords)
                                                         BG))))]))