; Solver for first-order ODE y'(t) = g (y (t))

(use-modules (srfi srfi-41)) ;; Import streams modules

(define (solve-ode g h y0)
  (stream-cons y0
               (solve-ode g h (+ y0
                                 (* h (g y0))))))

;; Approximation of the exponential function for non-negative X
;; (exp 1) --> 2.716923932235896
(define (exp x)
  (let ((t0 0)
        (y0 1)
        (h 0.001))
    (let ((n (inexact->exact (floor (/ (- x t0) h)))))
      (stream-ref (solve-ode identity h y0) n))))
