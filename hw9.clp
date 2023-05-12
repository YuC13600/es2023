(deftemplate binary-# (multislot name) (multislot digits))
(deftemplate binary-adder (multislot name-1) (multislot name-2) (slot carry)
    (multislot #-1) (multislot #-2) (multislot result)
)

(deffacts initial-facts
    (phase input-amount)
    (number 0)
)

(defrule inpt-amount
    (phase input-amount)
    =>
    (printout t "Please input the amount of binary numbers to be added: ")
    (assert (amount (read)))
    (assert (phase input-binary-#))
)
(defrule input-checker
    ?f1 <- (phase input-amount)
    ?f2 <- (amount ?a)
    (test (< ?a 0))
    =>
    (retract ?f1 ?f2)
    (printout t "Please input a positive integer!!" crlf)
    (assert (phase input-amount))
)
(defrule input-binary-#
    (phase input-binary-#)
    (amount ?a)
    ?f <- (number ?n)
    (test (< ?n ?a))
    =>
    (retract ?f)
    (printout t "Please input binary number #" (+ ?n 1) ": ")
    (assert (binary-# (name (+ ?n 1)) (digits (explode$ (readline)))))
    (assert (number (+ ?n 1)))
    (assert (processing-counter ?a))
)
(defrule input-binary-checker
    (declare (salience 10))
    (phase input-binary-#)
    ?f1 <- (binary-# (name $?) (digits $? ?e&~0&~1 $?))
    ?f2 <- (number ?n)
    =>
    (retract ?f1 ?f2)
    (printout t "Input error!! Please input binary numbers!!" crlf)
    (assert (number (- ?n 1)))
)

(defrule stage-checker-1
    (amount ?a)
    (number ?n&?a)
    =>
    (assert (phase add-binary-#))
)
(defrule create-adder
    (phase add-binary-#)
    ?f1 <- (binary-# (name $?n1) (digits $?d1))
    ?f2 <- (binary-# (name $?n2&~$?n1) (digits $?d2))
    =>
    (retract ?f1 ?f2)
    (assert (binary-adder (name-1 ?n1) (name-2 ?n2) (carry 0) (#-1 ?d1) (#-2 ?d2) (result)))
)

(defrule adder-case-1
    (phase add-binary-#)
    ?f <- (binary-adder (name-1 $?na1) (name-2 $?na2)(carry ?c) (#-1 $?n1 ?d1) (#-2 $?n2 ?d2) (result $?r))
    =>
    (modify ?f (carry (integer (/ (+ ?c ?d1 ?d2) 2)))
        (result (mod (+ ?c ?d1 ?d2) 2) ?r) (#-1 ?n1) (#-2 ?n2))
)

(defrule adder-case-2
    (phase add-binary-#)
    ?f <- (binary-adder (name-1 $?na1) (name-2 $?na2)(carry ?c) (#-1 $?n1 ?d1) (#-2) (result $?r))
    =>
    (modify ?f (carry (integer (/ (+ ?c ?d1) 2)))
        (result (mod (+ ?c ?d1) 2) ?r) (#-1 ?n1) (#-2))
)

(defrule adder-case-3
    (phase add-binary-#)
    ?f <- (binary-adder (name-1 $?na1) (name-2 $?na2) (carry ?c) (#-1) (#-2 $?n2 ?d2) (result $?r))
    =>
    (modify ?f (carry (integer (/ (+ ?c ?d2) 2)))
        (result (mod (+ ?c ?d2) 2) ?r) (#-1) (#-2 ?n2))
)

(defrule adder-case-4
    (phase add-binary-#)
    ?f <- (binary-adder (name-1 $?na1) (name-2 $?na2) (carry 1) (#-1) (#-2) (result $?r))
    =>
    (modify ?f (carry 0) (result 1 ?r))
)

(defrule conver-adder-to-number
    (phase add-binary-#)
    ?f1 <- (binary-adder (name-1 $?n1) (name-2 $?n2) (carry 0) (#-1) (#-2) (result $?r))
    ?f2 <- (processing-counter ?c)
    =>
    (retract ?f1 ?f2)
    (assert (binary-# (name { ?n1 + ?n2 })(digits ?r)))
    (assert (processing-counter (- ?c 1)))
)
(defrule print-result
    (declare (salience -10))
    (processing-counter 1)
    (binary-# (name $?n) (digits $?d))
    =>
    (printout t (implode$ ?n) ": " (implode$ ?d) crlf)
)
