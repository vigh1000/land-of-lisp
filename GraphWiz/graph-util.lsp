;; (load "C:/Repos/land-of-lisp/GraphWiz/graph-util.lsp")

(defparameter *max-label-length* 30)

(defun dot-label (exp)
  "Adding Labels to Graph Nodes"
  (if exp
    (let ((s (write-to-string exp :pretty nil)))
      (if (> (length s) *max-label-length*)
          (concatenate 'string (subseq s 0 (- *max-label-length* 3)) "...")
          s))
  ""))

(defun dot-name (exp)
 "Converting Node Identifiers, so that they contain only legal values for GraphWiz"
  (substitute-if #\_ (complement #'alphanumericp) (prin1-to-string exp)))

(defun nodes->dot (nodes)
  "Generating the DOT Information for the Nodes"
  (mapc (lambda (node)
          (fresh-line)
          (princ (dot-name (car node)))
          (princ "[label=\"")
          (princ (dot-label node))
          (princ "\"];"))
    nodes))

(defun edges->dot (edges)
  "Generating the DOT Information for the Edges"
  (mapc (lambda (node)
         (mapc (lambda (edge)
            (fresh-line)
            (princ (dot-name (car node)))
            (princ "->")
            (princ (dot-name (car edge)))
            (princ "[label=\"")
            (princ (dot-label (cdr edge)))
            (princ "\"];"))
          (cdr node)))
    edges))

(defun graph->dot (nodes edges)
  "Generating the complete DOT Data at once"
  (princ "digraph{")
  (nodes->dot nodes)
  (edges->dot edges)
  (princ "}"))

(defun dot->png (fname thunk)
  "Turning the DOT file into a picture"
  (with-open-file (*STANDARD-OUTPUT*
                    fname
                    :direction :output
                    :if-exists :supersede)
    (funcall thunk))
    (ext:shell (concatenate 'string "dot -Tpng -O " fname)))

(defun graph->png (fname nodes edges)
  "Function that ties everything together"
  (dot->png fname
            (lambda ()
              (graph->dot nodes edges))))


;; The same for ugraph
(defun uedges->dot (edges)
  (maplist (lambda (lst)
              (mapc (lambda (edge)
                (unless (assoc (car edge) (cdr lst))
                  (fresh-line)
                  (princ (dot-name (caar lst)))
                  (princ "--")
                  (princ (dot-name (car edge)))
                  (princ "[label=\"")
                  (princ (dot-label (cdr edge)))
                  (princ "\"];")))
                (cdar lst)))
          edges))          

(defun ugraph->dot (nodes edges)
  (princ "graph{")
  (nodes->dot nodes)
  (uedges->dot edges)
  (princ "}"))          

(defun ugraph->png (fname nodes edges)
  (dot->png fname
            (lambda ()
              (ugraph->dot nodes edges))))