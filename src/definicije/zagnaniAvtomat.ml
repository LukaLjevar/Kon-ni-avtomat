type t = { avtomat : Avtomat.t; trak : Trak.t; stanje : Stanje.t }

let pozeni avtomat trak podniz =
  { Avtomat.napolni_avtomat podniz; trak; stanje = (Avtomat.razbij_v_tabelo_stanj podniz).(0) }

let avtomat { avtomat; _ } = avtomat
let trak { trak; _ } = trak
let stanje { stanje; _ } = stanje

let korak_naprej { avtomat; trak; stanje } =
  if Trak.je_na_koncu trak then None
  else
    let stanje' =
      Avtomat.prehodna_funkcija avtomat stanje (Trak.trenutni_znak trak)
    in
    match stanje' with
    | None -> None
    | Some stanje' ->
        Some { avtomat; trak = Trak.premakni_naprej trak; stanje = stanje' }

(*Pove, če je avtomat v sprejemnem stanju.*)
let je_v_sprejemnem_stanju { avtomat; stanje; _ } =
  Avtomat.sprejemno_stanje avtomat stanje