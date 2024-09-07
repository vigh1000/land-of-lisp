;; (load "graph-util")
;; (load "C:/Repos/land-of-lisp/GrandTheftWumpus/CongestionCity.lsp")


(load "C:/Repos/land-of-lisp/GraphWiz/graph-util.lsp")
(load "C:/Repos/land-of-lisp/GrandTheftWumpus/CongestionCity.lsp")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initializing a New Game of Grand Theft Wumpus
(defun new-game ()
  (setf *congestion-city-edges* (make-city-edges))
  (setf *congestion-city-nodes* (make-city-nodes *congestion-city-edges*))
  (setf *player-pos* (find-empty-node))
  (setf *visited-nodes* (list *player-pos*))
  (draw-city)
  (draw-known-city))

(defun find-empty-node ()
  (let ((x (random-node)))
    (if (cdr (assoc x *congestion-city-nodes*))
        (find-empty-node)
        x)))

(defun draw-city ()
  (ugraph->png "city" *congestion-city-nodes* *congestion-city-edges*))