type t = { niz : string; indeks_trenutnega_znaka : int }
              
let trenutni_znak trak = String.get trak.niz trak.indeks_trenutnega_znaka
let je_na_koncu trak = String.length trak.niz = trak.indeks_trenutnega_znaka
                                                      
let premakni_naprej trak =
  { trak with indeks_trenutnega_znaka = succ trak.indeks_trenutnega_znaka }

let iz_niza niz = { niz; indeks_trenutnega_znaka = 0 }
let v_niz trak = trak.niz
