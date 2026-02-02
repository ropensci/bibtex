# Full xampl on string

    Code
      names(out)
    Output
       [1] "article-minimal"        "article-full"           "inbook-minimal"        
       [4] "inbook-full"            "inbook-crossref"        "book-minimal"          
       [7] "book-full"              "book-crossref"          "whole-set"             
      [10] "booklet-minimal"        "booklet-full"           "incollection-minimal"  
      [13] "incollection-full"      "incollection-crossref"  "whole-collection"      
      [16] "manual-minimal"         "manual-full"            "mastersthesis-minimal" 
      [19] "mastersthesis-full"     "misc-minimal"           "misc-full"             
      [22] "inproceedings-minimal"  "inproceedings-full"     "inproceedings-crossref"
      [25] "proceedings-minimal"    "proceedings-full"       "whole-proceedings"     
      [28] "phdthesis-minimal"      "phdthesis-full"         "techreport-minimal"    
      [31] "techreport-full"        "unpublished-minimal"    "unpublished-full"      
      [34] "random-note-crossref"  

# Full xampl on bibtex

    @Article{article-minimal,
      author = {L[eslie] A. Aamport},
      title = {The Gnats and Gnus Document Preparation System},
      journal = {\mbox{G-Animal's} Journal},
      year = {1986},
    }
    
    @Article{article-full,
      author = {L[eslie] A. Aamport},
      title = {The Gnats and Gnus Document Preparation System},
      journal = {\mbox{G-Animal's} Journal},
      year = {1986},
      volume = {41},
      number = {7},
      pages = {73+},
      month = {jul},
      note = {This is a full ARTICLE entry},
    }
    
    @InBook{inbook-minimal,
      author = {Donald E. Knuth},
      title = {Fundamental Algorithms},
      publisher = {Addison-Wesley},
      year = {{\noopsort{1973b}}1973},
      chapter = {1.2},
    }
    
    @InBook{inbook-full,
      author = {Donald E. Knuth},
      title = {Fundamental Algorithms},
      volume = {1},
      series = {The Art of Computer Programming},
      publisher = {Addison-Wesley},
      address = {Reading, Massachusetts},
      edition = {Second},
      month = {10~jan},
      year = {{\noopsort{1973b}}1973},
      type = {Section},
      chapter = {1.2},
      pages = {10--119},
      note = {This is a full INBOOK entry},
    }
    
    @InBook{inbook-crossref,
      crossref = {whole-set},
      title = {Fundamental Algorithms},
      volume = {1},
      series = {The Art of Computer Programming},
      edition = {Second},
      year = {{\noopsort{1973b}}1973},
      type = {Section},
      chapter = {1.2},
      note = {This is a cross-referencing INBOOK entry},
    }
    
    @Book{book-minimal,
      author = {Donald E. Knuth},
      title = {Seminumerical Algorithms},
      publisher = {Addison-Wesley},
      year = {{\noopsort{1973c}}1981},
    }
    
    @Book{book-full,
      author = {Donald E. Knuth},
      title = {Seminumerical Algorithms},
      volume = {2},
      series = {The Art of Computer Programming},
      publisher = {Addison-Wesley},
      address = {Reading, Massachusetts},
      edition = {Second},
      month = {10~jan},
      year = {{\noopsort{1973c}}1981},
      note = {This is a full BOOK entry},
    }
    
    @Book{book-crossref,
      crossref = {whole-set},
      title = {Seminumerical Algorithms},
      volume = {2},
      series = {The Art of Computer Programming},
      edition = {Second},
      year = {{\noopsort{1973c}}1981},
      note = {This is a cross-referencing BOOK entry},
    }
    
    @Book{whole-set,
      author = {Donald E. Knuth},
      publisher = {Addison-Wesley},
      title = {The Art of Computer Programming},
      series = {Four volumes},
      year = {{\noopsort{1973a}}{\switchargs{--90}{1968}}},
      note = {Seven volumes planned (this is a cross-referenced set of BOOKs)},
    }
    
    @Booklet{booklet-minimal,
      key = {Kn{\printfirst{v}{1987}}},
      title = {The Programming of Computer Art},
    }
    
    @Booklet{booklet-full,
      author = {Jill C. Knvth},
      title = {The Programming of Computer Art},
      howpublished = {Vernier Art Center},
      address = {Stanford, California},
      month = {feb},
      year = {1988},
      note = {This is a full BOOKLET entry},
    }
    
    @InCollection{incollection-minimal,
      author = {Daniel D. Lincoll},
      title = {Semigroups of Recurrences},
      booktitle = {High Speed Computer and Algorithm Organization},
      publisher = {Academic Press},
      year = {1977},
    }
    
    @InCollection{incollection-full,
      author = {Daniel D. Lincoll},
      title = {Semigroups of Recurrences},
      editor = {David J. Lipcoll and D. H. Lawrie and A. H. Sameh},
      booktitle = {High Speed Computer and Algorithm Organization},
      number = {23},
      series = {Fast Computers},
      chapter = {3},
      type = {Part},
      pages = {179--183},
      publisher = {Academic Press},
      address = {New York},
      edition = {Third},
      month = {sep},
      year = {1977},
      note = {This is a full INCOLLECTION entry},
    }
    
    @InCollection{incollection-crossref,
      crossref = {whole-collection},
      author = {Daniel D. Lincoll},
      title = {Semigroups of Recurrences},
      pages = {179--183},
      note = {This is a cross-referencing INCOLLECTION entry},
    }
    
    @Book{whole-collection,
      editor = {David J. Lipcoll and D. H. Lawrie and A. H. Sameh},
      title = {High Speed Computer and Algorithm Organization},
      booktitle = {High Speed Computer and Algorithm Organization},
      number = {23},
      series = {Fast Computers},
      publisher = {Academic Press},
      address = {New York},
      edition = {Third},
      month = {sep},
      year = {1977},
      note = {This is a cross-referenced BOOK (collection) entry},
    }
    
    @Manual{manual-minimal,
      key = {Manmaker},
      title = {The Definitive Computer Manual},
    }
    
    @Manual{manual-full,
      author = {Larry Manmaker},
      title = {The Definitive Computer Manual},
      organization = {Chips-R-Us},
      address = {Silicon Valley},
      edition = {Silver},
      month = {apr-may},
      year = {1986},
      note = {This is a full MANUAL entry},
    }
    
    @MastersThesis{mastersthesis-minimal,
      author = {Édouard Masterly},
      title = {Mastering Thesis Writing},
      school = {Stanford University},
      year = {1988},
    }
    
    @MastersThesis{mastersthesis-full,
      author = {Édouard Masterly},
      title = {Mastering Thesis Writing},
      school = {Stanford University},
      type = {Master's project},
      address = {English Department},
      month = {jun-aug},
      year = {1988},
      note = {This is a full MASTERSTHESIS entry},
    }
    
    @Misc{misc-minimal,
      key = {Missilany},
      note = {This is a minimal MISC entry},
    }
    
    @Misc{misc-full,
      author = {Joe-Bob Missilany},
      title = {Handing out random pamphlets in airports},
      howpublished = {Handed out at O'Hare},
      month = {oct},
      year = {1984},
      note = {This is a full MISC entry},
    }
    
    @InProceedings{inproceedings-minimal,
      author = {Alfred V. Oaho and Jeffrey D. Ullman and Mihalis Yannakakis},
      title = {On Notions of Information Transfer in {VLSI} Circuits},
      booktitle = {Proc. Fifteenth Annual ACM Symposium on the Theory of Computing},
      year = {1983},
    }
    
    @InProceedings{inproceedings-full,
      author = {Alfred V. Oaho and Jeffrey D. Ullman and Mihalis Yannakakis},
      title = {On Notions of Information Transfer in {VLSI} Circuits},
      editor = {Wizard V. Oz and Mihalis Yannakakis},
      booktitle = {Proc. Fifteenth Annual ACM Symposium on the Theory of Computing},
      number = {17},
      series = {All ACM Conferences},
      pages = {133--139},
      month = {mar},
      year = {1983},
      address = {Boston},
      organization = {The OX Association for Computing Machinery},
      publisher = {Academic Press},
      note = {This is a full INPROCEDINGS entry},
    }
    
    @InProceedings{inproceedings-crossref,
      crossref = {whole-proceedings},
      author = {Alfred V. Oaho and Jeffrey D. Ullman and Mihalis Yannakakis},
      title = {On Notions of Information Transfer in {VLSI} Circuits},
      pages = {133--139},
      note = {This is a cross-referencing INPROCEEDINGS entry},
    }
    
    @Proceedings{proceedings-minimal,
      key = {OX{\singleletter{stoc}}},
      title = {Proc. Fifteenth Annual Symposium on the Theory of Computing},
      year = {1983},
    }
    
    @Proceedings{proceedings-full,
      editor = {Wizard V. Oz and Mihalis Yannakakis},
      title = {Proc. Fifteenth Annual Symposium on the Theory of Computing},
      number = {17},
      series = {All ACM Conferences},
      month = {mar},
      year = {1983},
      address = {Boston},
      organization = {The OX Association for Computing Machinery},
      publisher = {Academic Press},
      note = {This is a full PROCEEDINGS entry},
    }
    
    @Proceedings{whole-proceedings,
      key = {OX{\singleletter{stoc}}},
      organization = {The OX Association for Computing Machinery},
      title = {Proc. Fifteenth Annual Symposium on the Theory of Computing},
      address = {Boston},
      year = {1983},
      booktitle = {Proc. Fifteenth Annual ACM Symposium on the Theory of Computing},
      note = {This is a cross-referenced PROCEEDINGS},
    }
    
    @PhdThesis{phdthesis-minimal,
      author = {F. Phidias Phony-Baloney},
      title = {Fighting Fire with Fire: Festooning {F}rench Phrases},
      school = {Fanstord University},
      year = {1988},
    }
    
    @PhdThesis{phdthesis-full,
      author = {F. Phidias Phony-Baloney},
      title = {Fighting Fire with Fire: Festooning {F}rench Phrases},
      school = {Fanstord University},
      type = {{PhD} Dissertation},
      address = {Department of French},
      month = {jun-aug},
      year = {1988},
      note = {This is a full PHDTHESIS entry},
    }
    
    @TechReport{techreport-minimal,
      author = {Tom Terrific},
      title = {An {$O(n \log n / \! \log\log n)$} Sorting Algorithm},
      institution = {Fanstord University},
      year = {1988},
    }
    
    @TechReport{techreport-full,
      author = {Tom Térrific},
      title = {An {$O(n \log n / \! \log\log n)$} Sorting Algorithm},
      institution = {Fanstord University},
      type = {Wishful Research Result},
      number = {7},
      address = {Computer Science Department, Fanstord, California},
      month = {oct},
      year = {1988},
      note = {This is a full TECHREPORT entry},
    }
    
    @Unpublished{unpublished-minimal,
      author = {Ulrich Ünderwood and Ned Ñet and Paul \=Pot},
      title = {Lower Bounds for Wishful Research Results},
      note = {Talk at Fanstord University (this is a minimal UNPUBLISHED entry)},
    }
    
    @Unpublished{unpublished-full,
      author = {Ulrich Ünderwood and Ned Ñet and Paul \=Pot},
      title = {Lower Bounds for Wishful Research Results},
      month = {nov, dec},
      year = {1988},
      note = {Talk at Fanstord University (this is a full UNPUBLISHED entry)},
    }
    
    @Misc{random-note-crossref,
      key = {Volume-2},
      note = {Volume~2 is listed under Knuth \cite{book-full}},
    }

