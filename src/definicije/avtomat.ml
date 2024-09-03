type stanje = Stanje.t

type t = {
  stanja : stanje list;
  zacetno_stanje : stanje;
  sprejemna_stanja : stanje list;
  prehodi : (stanje * char * stanje) list;
}

let prazen_avtomat zacetno_stanje =
  {
    stanja = [ zacetno_stanje ];
    zacetno_stanje;
    sprejemna_stanja = [];
    prehodi = [];
  }

let dodaj_nesprejemno_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja }

let dodaj_sprejemno_stanje stanje avtomat =
  {
    avtomat with
    stanja = stanje :: avtomat.stanja;
    sprejemna_stanja = stanje :: avtomat.sprejemna_stanja;
  }

let dodaj_prehod stanje1 znak stanje2 avtomat =
  { avtomat with prehodi = (stanje1, znak, stanje2) :: avtomat.prehodi }

let prehodna_funkcija avtomat stanje znak =
  match
    List.find_opt
      (fun (stanje1, znak', _stanje2) -> stanje1 = stanje && znak = znak')
      avtomat.prehodi
  with
  | None -> None
  | Some (_, _, stanje2) -> Some stanje2

let zacetno_stanje avtomat = avtomat.zacetno_stanje
let seznam_stanj avtomat = avtomat.stanja
let seznam_prehodov avtomat = avtomat.prehodi

let je_sprejemno_stanje avtomat stanje =
  List.mem stanje avtomat.sprejemna_stanja

(*podniz razbijemo v seznam parov, kjer je prva komponenta indeks elementa v podnizu in je druga
komponenta ta element niza.  
let dvojica_v_niz (a, b) = 
  "(" ^ (string_of_int a) ^ ", " ^ String.make 1 b ^ ")"*)

  let razbij_v_seznam_stanj podniz = 
    let rec razbij_v_seznam' i podniz = 
      if i >= String.length podniz then [] else
        (Stanje.iz_para (i, (String.get podniz i))) :: razbij_v_seznam' (i + 1) podniz in
    (Stanje.iz_para (-1, 'X')) :: razbij_v_seznam' 0 podniz

  let zacetno = (-1, 'X')

  let sprejemno podniz = List.nth (razbij_v_seznam_stanj podniz) (String.length podniz)

(*V dobljenem seznamu nam vsi elementi razen zadnjega dajo nesprejemna stanja, zadnji element
pa nam da sprejemno stanje  

let iskalec_podnizov podniz = 
  if podniz = "" then
  let zacetno = Stanje.iz_niza "zacetno" in
  prazen_avtomat zacetno |> dodaj_sprejemno_stanje zacetno
  else
  match (razbij_v_seznam podniz) with
  (*|[] -> _*)
  |x::[] -> _
  |x::xs -> _*)
  

