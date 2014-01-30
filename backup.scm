#!/usr/bin/gosh
;;Backup a file to the directory named "filename.bak". 
;;By ryok (2014). 

(use file.util)

(define (find-file dir fname)
  (fold (lambda (elem val) (if (equal? elem fname) #t (or val #f)))
		#f
		(directory-list dir)))

(define (main args)
  (if (null? (cdr args))
	(print "USAGE: backup.scm filename")
	(receive (fdir fbody fext) 
			 (decompose-path (cadr args))
			 (let* ((fname (string-join (list fbody "." fext) ""))
					(fpath (string-join (list fdir "/" fname) ""))
					(bakdir (string-join (list fpath ".bak") "")))
			   (if (equal? #f (find-file fdir fname))
				 (print "Filename \"" fname  "\" not found.\nExit.")
				 (begin 
				   ;(print "Input file= " fpath)
				   ;(print "backup directory= " bakdir)
				   (make-directory* bakdir)
				   (if (copy-file fpath (string-join (list bakdir "/" fbody "_latest" "." fext) "")
								  :if-exists :supersede)
					 (print "Copy " fpath " to " (string-join (list bakdir "/" fbody "_latest" "." fext) "") ""))
				   (let loop ((count 0))
					 (if (> count 1000)
					   (print "End loop.")
					   (let1 newfpath
							 (string-join (list bakdir "/" fbody "_" (format #f "~3,'0d" (+ 1 count)) "." fext) "")
							 (if (copy-file fpath newfpath :if-exists #f)
							   (print "Copy " fpath " to " newfpath)
							   (loop (+ 1 count))
							   ))))))))) 0)
