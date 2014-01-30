#!/usr/bin/gosh
;;Backup a file to the directory named "filename.bak". 
;;By ryok (2014). 

(use file.util)

(define (main args)
  (if (null? (cdr args))
	(print "USAGE: backup.scm filename")
	(map backup-a-file (cdr args))
	) 0)

(define (backup-a-file file)
  (if (not (file-is-regular? file))
	(print "Filename " file " Not Found. Skip it.")
	(receive (fdir fbody fext) 
			 (decompose-path file)
			 (let* ((fname (string-join (list fbody "." fext) ""))
					(fpath (string-join (list fdir "/" fname) ""))
					(bakdir (string-join (list fpath ".bak") "")))
			   (begin 
				 ;(print "input file= " fpath)
				 ;(print "backup directory= " bakdir)
				 (make-directory* bakdir)
				 (if (copy-file fpath (string-join (list bakdir "/" fbody "_latest" "." fext) "")
								:if-exists :supersede)
				   (print "Copy " fpath " to " (string-join (list bakdir "/" fbody "_latest" "." fext) "") ""))
				 (let loop ((count 0))
				   (if (> count 1000)
					 (print "end loop.")
					 (let1 newfpath
						   (string-join (list bakdir "/" fbody "_" (format #f "~3,'0d" (+ 1 count)) "." fext) "")
						   (if (copy-file fpath newfpath :if-exists #f)
							 (print "copy " fpath " to " newfpath)
							 (loop (+ 1 count))
							 )))))))))

