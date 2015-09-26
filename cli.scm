;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cli.scm
;; Created by Eissek
;; 21 September 2015
;;
;; Provides a Command Line Interface for the
;; quickCommands application
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Dependent on main.scm
(require-extension args)
(declare (uses main))

(define (test-list-commands .)
  (list-stored-commands))

(define (handle-cmd-line-arguments PROC option)
  (let ((first-arg (car (command-line-arguments)))
        (rest (cdr (command-line-arguments))))
    (cond ((equal? option first-arg)
           (PROC rest))
          ((number? (string-contains first-arg "-"))
           (PROC rest)
           (print "FOUND - DASH"))
          (else (PROC (command-line-arguments))))))

(define opts
  (list (args:make-option (c cookie) (required: "name") "Cookie for name"
                          (print "Cookie for " arg)
                          (test-list-commands))
        (args:make-option (a add)
                          (required: "COMMAND" "DESCRIPTION" "TAGS")
                          "Add Command or Data"
                          (handle-cmd-line-arguments add-command arg))
        (args:make-option (d delete) (required: "ID" "COMMAND")
                          "Delete Command"
                          (print "Deleting.."))
        (args:make-option (l list) #:none "List stored commands"
                          (list-stored-commands))
        (args:make-option (t test) (required: "TEST")
                          "testing multiple arguments"
                          (print "cml args " (command-line-arguments))
                          (print "cdr " (string-join (cdr(command-line-arguments))))
                          (print "arg " arg))))

(args:parse (command-line-arguments) opts)