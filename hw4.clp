(deftemplate conversion (slot character) (multislot morse-code))
(deftemplate translation (multislot string) (multislot code))
(deffacts conversions
   (conversion (character A) (morse-code * -))
   (conversion (character B) (morse-code - * * *))
   (conversion (character C) (morse-code - * - *))
   (conversion (character D) (morse-code - * *))
   (conversion (character E) (morse-code *))
   (conversion (character F) (morse-code * * - *))
   (conversion (character G) (morse-code - - *))
   (conversion (character H) (morse-code * * * *))
   (conversion (character I) (morse-code * *))
   (conversion (character J) (morse-code * - - -))
   (conversion (character K) (morse-code - * -))
   (conversion (character L) (morse-code * - * *))
   (conversion (character M) (morse-code - -))
   (conversion (character N) (morse-code - *))
   (conversion (character O) (morse-code - - -))
   (conversion (character P) (morse-code * - - *))
   (conversion (character Q) (morse-code - - * -))
   (conversion (character R) (morse-code * - *))
   (conversion (character S) (morse-code * * *))
   (conversion (character T) (morse-code -))
   (conversion (character U) (morse-code * * -))
   (conversion (character V) (morse-code * * * -))
   (conversion (character W) (morse-code * - -))
   (conversion (character X) (morse-code - * * -))
   (conversion (character Y) (morse-code - * - -))
   (conversion (character Z) (morse-code - - * *))
)

(defrule get-message
    (declare (salience 100))
    (not (translation (string $?)(code $?)))
    =>
    (printout t "Enter a message (<Enter> to end): ")
    (bind ?input (explode$ (readline)))
    (assert (translation (string) (code ?input)))
    (printout t ?input crlf)
)

(defrule conver
    (declare (salience 50))
    ?oldtranslation <- (translation (string $?oldstr) (code $?thiscode / $?rest))
    (conversion (character ?thischar) (morse-code $?thiscode))
    =>
    (retract ?oldtranslation)
    (assert (translation (string $?oldstr ?thischar) (code $?rest)))
    (printout t "conver" crlf)
)

(defrule conver-lastchar
    (declare (salience 50))
    ?oldtranslation <- (translation (string $?oldstr) (code $?thiscode))
    ;(conversion (character ?thischar) (morse-code $?thiscode))
    =>
    ;(retract ?oldtranslation)
    ;(assert (translation (string $?oldstr ?thischar) (code)))
    (printout t "conver-lastchar: " ?thiscode crlf)
)

(defrule not-match
    ?trans <- (translation (string $?) (code ?something $?))
    =>
    (retract ?trans)
    (printout t "Can't decode this message." crlf)
)

(defrule outpu
    ?trans <- (translation (string $?str) (code))
    =>
    (retract ?trans)
    (printout t "The message is " (implode$ ?str) crlf)
)

(defrule end
    (declare (salience 50))
    (translation (string) (code))
    =>
    (halt)
)