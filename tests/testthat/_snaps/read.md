# Test entry with non standard fields

    @Article{newspaper}
      author:
        given = "Jean-Claude" | family = "Van Damme"
      title = "Article title"
      date = "2016-12-21"
      journal = "Newspaper name"
      hyphen-field = "This one"
      under_field = "This one"
      double:field = "This one"
      year = "2016"

---

    @Article{newspaper,
      author = {Jean-Claude {Van Damme}},
      title = {Article title},
      date = {2016-12-21},
      journal = {Newspaper name},
      hyphen-field = {This one},
      under_field = {This one},
      double:field = {This one},
      year = {2016},
    }

