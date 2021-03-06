;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; qucik-commands v. 0.10.0
;; cli.scm
;; Created by Eissek
;; 21 September 2015
;; Copyright 2015
;; Provides a Command Line Interface for the
;; quickCommands application
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Dependent on main.scm
(declare (uses main))
(require-extension args)

(define (print-n-format arg)
  (print arg))

;; (define (print-n-format arg)
;;   (display (string-join (append arg '("\n")))))

(define (handle-cmd-line-arguments PROC option)
  ;; parses the cmdline args by getting the data
  ;; -after the initial option
  ;; e.g. everything after -h
  (let ((first-arg (car (command-line-arguments)))
        (rest (cdr (command-line-arguments))))
    (cond ((equal? option first-arg)
           ;;(print "first ")
           (PROC rest))
          ((number? (string-contains first-arg "-"))
           ;;(print "FOUND - DASH")
           ;;(print (command-line-arguments))
           (PROC rest))
          (else
           ;;(print "args " (command-line-arguments))
           (PROC (command-line-arguments))))))

(define (usage)
  (print "Usage: " (car (argv)) " [options...] [files...]")
      (newline)
      (print (parameterize ((args:separator " ")
                            (args:indent 5)
                            (args:width 35))
               (args:usage opts))))

(define opts
  (list (args:make-option (a add)
                          (required: (string-join '("COMMAND" "DESCRIPTION" "TAGS") " "))
                          "Add Command or Data"
                          (handle-cmd-line-arguments add-command arg))
        
        (args:make-option (d delete) (required: "ROW ID")
                          "Delete Command"
                          ;; (print "Deleting.")
                          (handle-cmd-line-arguments delete-command arg))
        
        (args:make-option (f filter) (required: "TAG")
                          "Filter/Search for a specific tag"
                          (print "Starting filter ")
                          (print-n-format (handle-cmd-line-arguments filter-tags arg)))
        
        (args:make-option (h help) #:none "Display Help"
                          (usage))
        
        (args:make-option (l list) #:none "List stored commands"
                          (print-n-format (list-stored-commands)))
        
        (args:make-option (s search) (required: "QUERY")
                          "Search for a command/data"
                          (print "Starting search ")
                          (print-n-format (handle-cmd-line-arguments search-commands arg)))
        (args:make-option (u update) (required: (string-join '("ROWID" "COLUMN" "DATE") " "))
                          "Update a command"
                          ;; (print "Starting update.")
                          (handle-cmd-line-arguments update-command arg))))

(args:parse (command-line-arguments) opts)
;; Print usage help if no args are provided
(if (= 0 (length (command-line-arguments)))
    (usage))

