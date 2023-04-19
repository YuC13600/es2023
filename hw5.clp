(deftemplate arr (multislot element))

(defrule read-data
    (declare (salience 100))
    =>
    (printout t "Data sorting: ")
    (bind ?input (explode$ (readline)))
    (assert (arr (element ?input)))
)

(defrule swap
    ?oldarr <- (arr (element $?front ?a $?mid ?b $?back))
    (test (> ?a ?b))
    =>
    (retract ?oldarr)
    (assert (arr (element $?front ?b $?mid ?a $?back)))
)

(defrule output
    (declare (salience -100))
    (arr (element $?all))
    =>
    (printout t "The result is " $?all crlf)
)