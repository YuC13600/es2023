(deftemplate sales (slot id) (multislot items))
(deftemplate record (slot id) (multislot pair))
(deftemplate combination (multislot pair) (slot number))

(deffacts initial (phase load-data))

(defrule assert-data
    (phase load-data)
    =>
    (load-facts "sales-03.txt")
)

(defrule generate-records-and-combination
    (declare (salience 100))
    (sales (id ?sales_id) (items $? ?i1 $? ?i2 $?))
    =>
    (assert (record (id ?sales_id) (pair ?i1 ?i2)))
    (assert (combination (pair ?i1 ?i2) (number 0)))
)

(defrule count-records
    ?f1 <- (record (id ?sales_id) (pair ?i1 ?i2))
    ?f2 <- (combination (pair ?i1 ?i2) (number ?previous_number))
    =>
    (retract ?f1 ?f2)
    (assert (combination (pair ?i1 ?i2) (number (+ ?previous_number 1))))
)

(defrule find-max
    (declare (salience -50))
    ?f1 <- (combination (pair ?i1 ?i2) (number ?number1))
    ?f2 <- (combination (pair ?i3 ?i4) (number ?number2))
    (test (> ?number1 ?number2))
    =>
    (retract ?f2)
)

(defrule print-result
    (declare (salience -100))
    ?f1 <- (combination (pair $?pair) (number ?number))
    =>
    (open "result.txt" out "a")
    (printout out $?pair ": " ?number crlf)
    (close out)
)