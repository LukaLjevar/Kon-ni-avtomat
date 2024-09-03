type t = { niz : string; indeks_trenutnega_znaka : int }
              
let trenutni_znak nadniz = String.get nadniz.niz nadniz.indeks_trenutnega_znaka
let je_na_koncu nadniz = String.length nadniz.niz = nadniz.indeks_trenutnega_znaka
                                                      
let premakni_naprej nadniz =
  { nadniz with indeks_trenutnega_znaka = succ nadniz.indeks_trenutnega_znaka }