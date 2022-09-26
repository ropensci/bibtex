# parse strings

    structure(list(name_string = c("STOC-key", "ACM", "STOC"), value = c("OX{\\singleletter{stoc}}", 
    "The OX Association for Computing Machinery", "The OX Association for Computing Machinery Symposium on the Theory of Computing"
    )), row.names = c(NA, 3L), class = "data.frame")

# parse single entry

    structure(c(author = "Nijenhuis, A. and Wilf, H.S.", year = "1978", 
    title = "Combinatorial Algorithms for Computers and Calculators", 
    publisher = "Academic Press", address = "New York"), entry = "book", key = "nijenhuis+wilf:1978")

# replace and concat

    [1] "CIA means Central Intelligence Agency"

---

    [1] "Central Intelligence Agency can be abbreviated as CIA, and FBI stands for Federal Bureau of Investigation"

---

    [1] "\"Central Intelligence Agency\""

---

    [1] "\"CIA\""

---

    [1] "{CIA}"

