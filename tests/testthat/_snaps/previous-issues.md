# Error message for invalid .bib files to read.bib #3

    [1] "ignoring entry 'brown:1963' (line 6) because :\n\tA bibentry of bibtype 'Book' has to specify the field: title\n\n"

# read.bib can use ? in key #9

    @Misc{key?,
      author = {Bob Smith},
      title = {The Title},
      year = {2012},
    }

# make.bib.entry can generate year from date #15

    @Article{newspaper,
      author = {Author Smith},
      title = {Article title},
      date = {2016-12-21},
      journal = {Newspaper name},
      year = {2016},
    }

# List of author names joined by AND cannot be parsed #18

    [[1]]
    [1] "Yang-Yu"
    
    [[2]]
    [1] "Jose" "C."  
    
    [[3]]
    [1] "Tomoshiro"
    
    [[4]]
    [1] "Mauro"
    
    [[5]]
    [1] "Yaniv"
    

---

    [[1]]
    [1] "Liu"
    
    [[2]]
    [1] "Nacher"
    
    [[3]]
    [1] "Ochiai"
    
    [[4]]
    [1] "Martino"
    
    [[5]]
    [1] "Altshuler"
    

---

    @Article{10.1371/journal.pone.0109458,
      author = {Yang-Yu Liu and Jose C. Nacher and Tomoshiro Ochiai and Mauro Martino and Yaniv Altshuler},
      journal = {PLOS ONE},
      publisher = {Public Library of Science},
      title = {Prospect Theory for Online Financial Trading},
      year = {2014},
      month = {10},
      volume = {9},
      url = {https://doi.org/10.1371/journal.pone.0109458},
      pages = {1-7},
      number = {10},
      doi = {10.1371/journal.pone.0109458},
    }

# caught segfault read.bib() - macOS 10.14.6 #23

    @Article{Hawking1966,
      author = {Stephen William Hawking and Hermann Bondi},
      title = {The occurrence of singularities in cosmology},
      journal = {Proceedings of the Royal Society of London. Series A. Mathematical and Physical Sciences},
      volume = {294},
      number = {1439},
      pages = {511-521},
      year = {1966},
      doi = {10.1098/rspa.1966.0221},
    }

