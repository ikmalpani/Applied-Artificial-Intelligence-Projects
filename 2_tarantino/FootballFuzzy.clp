;Football Player Evaluation Engine

;Fuzzy Variables

;(load-package nrc.fuzzy.jess.FuzzyFunctions)

(defglobal ?*age* = 
    (new nrc.fuzzy.FuzzyVariable "age" 0.0 100.0 "years"))
(defglobal ?*experience* =
    (new nrc.fuzzy.FuzzyVariable "experience" 0.0 50.0 "years"))
(defglobal ?*relevantXP* =
    (new nrc.fuzzy.FuzzyVariable "relevantXP" 0.0 50.0 "years"))
(defglobal ?*rating* =
    (new nrc.fuzzy.FuzzyVariable "rating" 0.0 10.0 "score"))


(defrule initial-terms
    (declare (salience 100))
=>
(import nrc.fuzzy.*)
(load-package nrc.fuzzy.jess.FuzzyFunctions)

;Primary Terms

(?*age* addTerm "low" (new ZFuzzySet 50.00 80.00))
(?*age* addTerm "medium" (new nrc.fuzzy.TriangleFuzzySet 34.00 44.00 55.00))
(?*age* addTerm "high" (new SFuzzySet 16.00 35.00))

(?*experience* addTerm "low" (new ZFuzzySet 1.00 6.00))
(?*experience* addTerm "medium" (new nrc.fuzzy.TriangleFuzzySet 4.00 8.00 12.00))
(?*experience* addTerm "high" (new SFuzzySet 10.00 40.00))

(?*relevantXP* addTerm "low" (new ZFuzzySet 1.00 6.00))
(?*relevantXP* addTerm "medium" (new nrc.fuzzy.TriangleFuzzySet 4.00 8.00 12.00))
(?*relevantXP* addTerm "high" (new SFuzzySet 10.00 40.00))

    
(?*rating* addTerm "low" (new ZFuzzySet 3.0 5.0))
(?*rating* addTerm "medium" (new PIFuzzySet 6.0 4.0))
(?*rating* addTerm "high" (new SFuzzySet 7.0 10.0))
)


;Startup module

(defrule welcome-user
(declare(salience 50))
=>

(printout t "Welcome to the Football Player Evaluation Engine(FPEE)!" crlf)
(printout t "Type the name of the player and press Enter> ")
(bind ?name (read))
(printout t "Let us begin the performance evaluation for " ?name "." crlf)
(printout t "Please provide the required details and" crlf)
(printout t "the FPEE will tell you the rating and recommendation for the player." crlf))


;Initialization


(defrule assert-answers "initialization"
=>
    (printout t "What is the players's age ? ")
    (bind ?age-value (float (readline t)))
	(printout t "How many years of total experience does the candidate have? ")
    (bind ?experience-value (float (readline t)))
    (printout t "How many years of relevant experience does the candidate have in the premier league? ")   
    (bind ?relevantXP-value (float (readline t)))
    (printout t "How much would you rate the player in terms of skills(1-10)? ")   
    (bind ?interpersonal-value (float (readline t)))
    (printout t "How much would you rate the player as a team player(1-10)? ")   
    (bind ?teamplayer-value (float (readline t)))
    (printout t "How much did the candidate score on the pace test(1-10)? ")
    (bind ?pace-value (float (readline t)))
    (printout t "How much did the candidate score on the passing passing(1-10)? ")
    (bind ?passing-value (float (readline t)))
    (printout t "How much did the candidate score on the fitness test(1-10)? ")
    (bind ?fitness-value (float (readline t)))


    (assert(theAge
        (new nrc.fuzzy.FuzzyValue ?*age*
        (new nrc.fuzzy.TriangleFuzzySet
        (- ?age-value 2.0)
        ?age-value
        (+ ?age-value 2.0)))))
    (assert(theExperience
        (new nrc.fuzzy.FuzzyValue ?*experience*
        (new nrc.fuzzy.TriangleFuzzySet
        (- ?experience-value 0.5)
        ?experience-value
        (+ ?experience-value 0.5)))))
    (assert(theRelevantXP
        (new nrc.fuzzy.FuzzyValue ?*relevantXP*
        (new nrc.fuzzy.TriangleFuzzySet
        (- ?relevantXP-value 0.5)
        ?relevantXP-value
        (+ ?relevantXP-value 0.5)))))
    (assert(theInterpersonal ?interpersonal-value))
    (assert(theTeamPlayer ?teamplayer-value))
    (assert(thePace ?pace-value))
    (assert(thePassing  ?passing-value))
    (assert(theFitness ?fitness-value)))


;Fuzzy Rules for calculation


(defrule rating-group1 ;"low age & low experience & low relevantXP=> rating very low or low"
    (theAge ?a &: (fuzzy-match ?a "low"))
    (theExperience ?e &: (fuzzy-match ?e "low"))
    (theRelevantXP ?r &: (fuzzy-match ?r "low"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "very low or low"))))

(defrule rating-group2 ;"low age & high experience & low relevantXP => rating low or medium or high"
    (theAge ?a &: (fuzzy-match ?a "low"))
    (theExperience ?e &: (fuzzy-match ?e "high"))
    (theRelevantXP ?r &: (fuzzy-match ?r "low"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "low or medium or high"))))

(defrule rating-group3 ;"low age & medium experience & low relevantXP => rating low or medium"
    (theAge ?a &: (fuzzy-match ?a "low"))
    (theExperience ?e &: (fuzzy-match ?e "medium"))
    (theRelevantXP ?r &: (fuzzy-match ?r "low"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "low or medium"))))

(defrule rating-group4 ;"high age & high experience & low relevantXP=> rating high or medium or low"
    (theAge ?a &: (fuzzy-match ?a "high"))
    (theExperience ?e &: (fuzzy-match ?e "high"))
    (theRelevantXP ?r &: (fuzzy-match ?r "low"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "high or medium or low"))))

(defrule rating-group5 ;"high age & low experience & low relevantXP => rating high or medium or low"
    (theAge ?a &: (fuzzy-match ?a "high"))
    (theExperience ?e &: (fuzzy-match ?e "low"))
    (theRelevantXP ?r &: (fuzzy-match ?r "low"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "high or medium or low"))))

(defrule rating-group6 ;"high age & medium experience & low relevantXP=> rating low or medium or high"
    (theAge ?a &: (fuzzy-match ?a "high"))
    (theExperience ?e &: (fuzzy-match ?e "medium"))
    (theRelevantXP ?r &: (fuzzy-match ?r "low"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "high or medium or low"))))

(defrule rating-group7 ;"medium age & high experience & low relevantXP=> rating low or medium or high"
    (theAge ?a &: (fuzzy-match ?a "medium"))
    (theExperience ?e &: (fuzzy-match ?e "high"))
    (theRelevantXP ?r &: (fuzzy-match ?r "low"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "low or medium or high"))))

(defrule rating-group8 ;"medium age & medium experience & low relevantXP=> rating low or medium"
    (theAge ?a &: (fuzzy-match ?a "medium"))
    (theExperience ?e &: (fuzzy-match ?e "medium"))
    (theRelevantXP ?r &: (fuzzy-match ?r "low"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* " low or medium "))))

(defrule rating-group9 ;"medium age & low experience & low relevantXP=> rating medium or low"
    (theAge ?a &: (fuzzy-match ?a "medium"))
    (theExperience ?e &: (fuzzy-match ?e "low"))
    (theRelevantXP ?r &: (fuzzy-match ?r "low"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "medium or low"))))

(defrule rating-group10 ;"low age & low experience & medium relevantXP=> rating very low or low or medium"
    (theAge ?a &: (fuzzy-match ?a "low"))
    (theExperience ?e &: (fuzzy-match ?e "low"))
    (theRelevantXP ?r &: (fuzzy-match ?r "medium"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "very low or low or medium"))))

(defrule rating-group11 ;"low age & high experience  & medium relevantXP=> rating low or medium or high"
    (theAge ?a &: (fuzzy-match ?a "low"))
    (theExperience ?e &: (fuzzy-match ?e "high"))
    (theRelevantXP ?r &: (fuzzy-match ?r "medium"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "low or medium or high"))))

(defrule rating-group12 ;"low age & medium experience  & medium relevantXP=> rating low or medium"
    (theAge ?a &: (fuzzy-match ?a "low"))
    (theExperience ?e &: (fuzzy-match ?e "medium"))
    (theRelevantXP ?r &: (fuzzy-match ?r "medium"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "low or medium"))))

(defrule rating-group13 ;"high age & high experience  & medium relevantXP=> rating high or medium"
    (theAge ?a &: (fuzzy-match ?a "high"))
    (theExperience ?e &: (fuzzy-match ?e "high"))
    (theRelevantXP ?r &: (fuzzy-match ?r "medium"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "high or medium"))))

(defrule rating-group14 ;"high age & low experience  & medium relevantXP=> rating high or medium or low"
    (theAge ?a &: (fuzzy-match ?a "high"))
    (theExperience ?e &: (fuzzy-match ?e "low"))
    (theRelevantXP ?r &: (fuzzy-match ?r "medium"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "high or medium or low"))))

(defrule rating-group15 ;"high age & medium experience  & medium relevantXP=> rating low or medium or high"
    (theAge ?a &: (fuzzy-match ?a "high"))
    (theExperience ?e &: (fuzzy-match ?e "medium"))
    (theRelevantXP ?r &: (fuzzy-match ?r "low"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "high or medium or low"))))

(defrule rating-group16 ;"medium age & high experience  & medium relevantXP=> rating medium or high"
    (theAge ?a &: (fuzzy-match ?a "medium"))
    (theExperience ?e &: (fuzzy-match ?e "high"))
    (theRelevantXP ?r &: (fuzzy-match ?r "medium"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* " medium or high"))))

(defrule rating-group17 ;"medium age & medium experience  & medium relevantXP=> rating medium"
    (theAge ?a &: (fuzzy-match ?a "medium"))
    (theExperience ?e &: (fuzzy-match ?e "medium"))
    (theRelevantXP ?r &: (fuzzy-match ?r "medium"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* " medium "))))

(defrule rating-group18 ;"medium age & low experience  & medium relevantXP=> rating medium or low"
    (theAge ?a &: (fuzzy-match ?a "medium"))
    (theExperience ?e &: (fuzzy-match ?e "low"))
    (theRelevantXP ?r &: (fuzzy-match ?r "medium"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "medium or low"))))

(defrule rating-group19 ;"low age & low experience  & high relevantXP=> rating low or medium or high"
    (theAge ?a &: (fuzzy-match ?a "low"))
    (theExperience ?e &: (fuzzy-match ?e "low"))
    (theRelevantXP ?r &: (fuzzy-match ?r "high"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* " low or medium or high"))))

(defrule rating-group20 ;"low age & high experience & high relevantXP=> rating low or medium or high"
    (theAge ?a &: (fuzzy-match ?a "low"))
    (theExperience ?e &: (fuzzy-match ?e "high"))
    (theRelevantXP ?r &: (fuzzy-match ?r "high"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "low or medium or high"))))

(defrule rating-group21 ;"low age & medium experience & high relevantXP=> rating low or medium or high"
    (theAge ?a &: (fuzzy-match ?a "low"))
    (theExperience ?e &: (fuzzy-match ?e "medium"))
    (theRelevantXP ?r &: (fuzzy-match ?r "high"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "low or medium or high"))))

(defrule rating-group22 ;"high age & high experience & high relevantXP=> rating very high or high"
    (theAge ?a &: (fuzzy-match ?a "high"))
    (theExperience ?e &: (fuzzy-match ?e "high"))
    (theRelevantXP ?r &: (fuzzy-match ?r "high"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "high or very high"))))

(defrule rating-group23 ;"high age & low experience & high relevantXP=> rating high or medium or low"
    (theAge ?a &: (fuzzy-match ?a "high"))
    (theExperience ?e &: (fuzzy-match ?e "low"))
    (theRelevantXP ?r &: (fuzzy-match ?r "high"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "high or medium or low"))))

(defrule rating-group24 ;"high age & medium experience & high relevantXP=> rating medium or high"
    (theAge ?a &: (fuzzy-match ?a "high"))
    (theExperience ?e &: (fuzzy-match ?e "medium"))
    (theRelevantXP ?r &: (fuzzy-match ?r "high"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "high or medium"))))

(defrule rating-group25 ;"medium age & high experience & high relevantXP=> rating medium or high"
    (theAge ?a &: (fuzzy-match ?a "medium"))
    (theExperience ?e &: (fuzzy-match ?e "high"))
    (theRelevantXP ?r &: (fuzzy-match ?r "high"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "medium or high"))))

(defrule rating-group26 ;"medium age & medium experience & high relevantXP=> rating medium or high"
    (theAge ?a &: (fuzzy-match ?a "medium"))
    (theExperience ?e &: (fuzzy-match ?e "medium"))
    (theRelevantXP ?r &: (fuzzy-match ?r "high"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* " medium or high "))))

(defrule rating-group27 ;"medium age & low experience & high relevantXP=> rating medium or low or high"
    (theAge ?a &: (fuzzy-match ?a "medium"))
    (theExperience ?e &: (fuzzy-match ?e "low"))
    (theRelevantXP ?r &: (fuzzy-match ?r "high"))
=>
    (assert(theRating (new nrc.fuzzy.FuzzyValue ?*rating* "medium or low or high"))))

;Defuzzification

(defrule defuzzification-and-display-rating
    (declare (salience -1))
    ?f <- (theRating ?z)
    (theInterpersonal ?p)
    (theTeamPlayer ?t)
    (thePace ?n)
   	(thePassing ?v)
    (theFitness ?i)
=>
    (str-cat "rating: " (?z momentDefuzzify))
	(bind ?calculated-rating (integer (+ (* 0.10 ?p) (* 0.05 ?t) (* 0.15 ?i)  (* .15 ?n) (* .15 ?v) (* .40 (?z momentDefuzzify)))))
    (if(> ?calculated-rating 10) then
    (printout t "rating : 10" crlf)
    else 
    (printout t "rating": ?calculated-rating crlf))
    (if (eq ?calculated-rating 5) then
    (printout t "The candidate has a mediocre rating and may or may not be a good fit for the job!" crlf)
    elif(eq ?calculated-rating 6) then
    (printout t "The candidate has a mediocre rating and may or may not be a good fit for the job!" crlf)    
    elif(eq ?calculated-rating 7) then
    (printout t "The candidate has a good rating and will be a good fit for the job!" crlf)
    elif(eq ?calculated-rating 8) then
    (printout t "The candidate has a good rating and will be a good fit for the job!" crlf)
    elif(eq ?calculated-rating 9) then
    (printout t "The candidate has a great rating and would be a perfect fit for the job!" crlf)
    elif(eq ?calculated-rating 10) then
    (printout t "The candidate has a great rating and would be a perfect fit for the job!" crlf)
    elif(> ?calculated-rating 10) then
    (printout t "The candidate has a great rating and would be a perfect fit for the job!" crlf)
    else
    (printout t "The candidate has a low rating and is not suitable for the job!" crlf))  
    
    (halt))

;function to run the application

(deffunction run-application ()
(reset)
(run))

;Run the above function in a loop to get back the prompt every time we have to enter the values for another candidate or re-run the program

(while TRUE
(run-application))


