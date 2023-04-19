(deftemplate sort (slot super) (slot sub))
(deftemplate relationship (multislot sort01) (multislot sort02))

(deffacts initial
    (sort (super Mammalia) (sub Primates))
    (sort (super Mammalia) (sub Artiodactyla))
    (sort (super Mammalia) (sub Rodentia))
    (sort (super Primates) (sub Cercopithecidae))
    (sort (super Primates) (sub Hominoidea))
    (sort (super Artiodactyla) (sub Cervidae))
    (sort (super Artiodactyla) (sub Bovidae))
    (sort (super Rodentia) (sub Sciuridae))
    (sort (super Cercopithecidae) (sub Macaca))
    (sort (super Cercopithecidae) (sub Papio))
    (sort (super Cercopithecidae) (sub Mandrillus))
    (sort (super Hominoidea) (sub Pongo))
    (sort (super Hominoidea) (sub Pan))
    (sort (super Hominoidea) (sub Homo))
    (sort (super Cervidae) (sub Rangifer))
    (sort (super Cervidae) (sub Elaphurus))
    (sort (super Bovidae) (sub Bison))
    (sort (super Bovidae) (sub Bubalus))
    (sort (super Sciuridae) (sub Tamias))
    (sort (super Macaca) (sub Sylvanus))
    (sort (super Macaca) (sub Cyclopis))
    (sort (super Papio) (sub Anubis))
    (sort (super Papio) (sub Ursinus))
    (sort (super Mandrillus) (sub Sphinx))
    (sort (super Mandrillus) (sub Leucophaeus))
    (sort (super Pongo) (sub Pygmaeus))
    (sort (super Pongo) (sub Abelii))
    (sort (super Pan) (sub Troglodytes))
    (sort (super Pan) (sub Paniscus))
    (sort (super Homo) (sub Sapiens))
    (sort (super Rangifer) (sub Tarandus))
    (sort (super Rangifer) (sub Caribou))
    (sort (super Elaphurus) (sub Davidianus))
    (sort (super Bison) (sub Athabascae))
    (sort (super Bison) (sub Bonasus))
    (sort (super Bubalus) (sub Arnee))
    (sort (super Tamias) (sub Ochrogenys))
    (phase input)
    (full01 undo)
    (full02 undo)
)

(defrule input
    (declare (salience 100))
    (phase input)
    =>
    (printout t "Enter sort #1: ")
    (bind ?input1 (read))
    (printout t "Enter sort #2: ")
    (bind ?input2 (read))
    (assert (relationship (sort01 ?input1) (sort02 ?input2)))
    (assert (full01 undo))
    (assert (full02 undo))
)

(defrule full-path-01
    (declare (salience 80))
    (full01 undo)
    ?f1 <- (relationship (sort01 ?this $?back) (sort02 $?rest))
    (sort (super ?this_super) (sub ?this))
    =>
    (retract ?f1)
    (assert (relationship (sort01 ?this_super ?this $?back) (sort02 $?rest)))
)

(defrule full01-check
    (declare (salience 80))
    ?f1 <- (full01 undo)
    (relationship (sort01 Mammalia $?rest01) (sort02 $?rest02))
    =>
    (retract ?f1)
)

(defrule full-path-02
    (declare (salience 70))
    (full02 undo)
    ?f1 <- (relationship (sort01 $?rest) (sort02 ?this $?back))
    (sort (super ?this_super) (sub ?this))
    =>
    (retract ?f1)
    (assert (relationship (sort01 $?rest) (sort02 ?this_super ?this $?back)))
)

(defrule full02-check
    (declare (salience 70))
    ?f1 <- (full02 undo)
    (relationship (sort01 $?rest01) (sort02 Mammalia $?rest02))
    =>
    (retract ?f1)
)

(defrule erase-dep
    (declare (salience 60))
    ?f1 <- (relationship (sort01 ?head01 $?rest01) (sort02 ?head02 $?rest02))
    (test (eq ?head01 ?head02))
    =>
    (retract ?f1)
    (assert (relationship (sort01 $?rest01) (sort02 $?rest02)))
)

(defrule count-and-print
    (declare (salience 40))
    ?f1 <- (relationship (sort01 $?sort01) (sort02 $?sort02))
    =>
    (printout t "The relationship distance is " (+ (length$ $?sort01) (length$ $?sort02)) crlf)
    (retract ?f1)
)

(defrule change-phase
    (declare (salience -10))
    ?f1 <- (phase input)
    =>
    (retract ?f1)
    (assert (phase input))
)