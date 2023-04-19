(defrule main
    =>
    (open "t.dat" stuff "w")
    (printout stuff "apple" crlf)
    (printout stuff 8 crlf)
    (close stuff)
)