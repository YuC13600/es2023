(deftemplate permutation (multislot values) (multislot rest))

(deffacts initial (total 0))

(defrule read-base-fact
    (declare (salience 100))
    =>
    (printout t "Please input a base fact for the permutation" crlf)
    (bind ?input (explode$ (readline)))
    (assert (permutation (values) (rest ?input)))
)

(defrule sort
    (permutation (values $?sorted) (rest $?front ?element $?behind))
    =>
    (assert (permutation (values $?sorted ?element) (rest $?front $?behind)))
)

(defrule count
    ?per <- (permutation (values $?sorted) (rest))
    ?oldsum <- (total ?sum)
    =>
    (retract ?per ?oldsum)
    (printout t "Permutation is " $?sorted crlf)
    (assert (total (+ ?sum 1)))
)

(defrule print-sum
    (declare(salience -100))
    ?sumindex <- (total ?sum)
    =>
    (retract ?sumindex)
    (printout t "The total number is " ?sum crlf)
)