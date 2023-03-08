(deftemplate situation (slot type))
(deftemplate problem (slot type))

(defrule situation-a-1
    (situation (type noise-when-brake))
    =>
    (assert (problem (type brake-trouble))))

(defrule situation-a-2
    (situation (type noise-from-tire))
    =>
    (assert (problem (type brake-trouble))))

(defrule situation-b-1
    (situation (type water-thermometer-H))
    =>
    (assert (problem (type water-tank-trouble))))

(defrule situation-b-2
    (situation (type water-leak))
    =>
    (assert (problem (type water-tank-trouble))))

(defrule situation-c-1
    (situation (type noise-from-engine-room))
    =>
    (assert (problem (type engine-belt-loose))))

(defrule situation-d-1
    (situation (type engine-cannot-catch))
    =>
    (assert (problem (type car-battery-no-power))))

(defrule problem-a
    (problem (type brake-trouble))
    =>
    (printout t "problem: brake-trouble solution: check brake pedal and oil" crlf))

(defrule problem-b
    (problem (type water-tank-trouble))
    =>
    (printout t "problem: water-tank-trouble solution: repair the water tank or add water" crlf))

(defrule problem-c
    (problem (type engine-belt-loose))
    =>
    (printout t "problem: engine-belt-loose solution: change the engine belt" crlf))

(defrule problem-d
    (problem (type car-battery-no-power))
    =>
    (printout t "problem: car-battery-no-power solution: replace or change a car battery" crlf))