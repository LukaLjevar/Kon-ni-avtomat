type t = { avtomat : Avtomat.t; trak : Trak.t; trenutna_stanja : Stanje.t list }

let pozeni trak podniz = (*Avtomat, takoj potem, ko smoga prižgali*)
  { avtomat = Avtomat.napolni_avtomat podniz; trak; trenutna_stanja = [(Avtomat.razbij_v_tabelo_stanj podniz).(0)] }

let avtomat { avtomat; _ } = avtomat
let trak { trak; _ } = trak

let korak_naprej { avtomat; trak; trenutna_stanja } =
  if Trak.je_na_koncu trak then { avtomat; trak; trenutna_stanja }
  else
    let nova_trenutna_stanja =
      Avtomat.prehodna (Avtomat.stanja avtomat) trenutna_stanja (Trak.trenutni_znak trak)
    in
    { avtomat; trak = Trak.premakni_naprej trak; trenutna_stanja = nova_trenutna_stanja }

(*Pove, če je avtomat v sprejemnem stanju. - PRILAGODI ZA SVOJ AVTOMAT - PREIMENUJ!*)
(*let je_v_sprejemnem_stanju { avtomat; stanje; _ } =
  Avtomat.sprejemno_stanje avtomat stanje*)
