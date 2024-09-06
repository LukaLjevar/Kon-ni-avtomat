open Definicije
open Avtomat

type stanje_vmesnika =
  | SeznamMoznosti
  | IzpisAvtomata
  | BranjeNiza
  | RezultatPrebranegaNiza
  | OpozoriloONapacnemNizu

type model = {
  avtomat : t; (*Ker smo modul Avtomat odprli, ni treba pisati Avtomat.t, zadošča samo t.*)
  trenutna_stanja_avtomata : Stanje.t list;
  stanje_vmesnika : stanje_vmesnika;
}

type msg =
  | VnesiNadniz of string  (*Vnesemo nadniz, vkaterem iščemo podniz*)
  | ZamenjajVmesnik of stanje_vmesnika
  | VrniVPrvotnoStanje

let preberi_niz avtomat q niz = (*q -> trenutna stanja ob začetku procesiranja niza.*)
  let aux acc znak =
    match acc with
    | None -> None
    | Some q -> Some (prehodna avtomat q znak)
  in
  niz |> String.to_seq |> Seq.fold_left aux (Some q)


let update model msg = 
  let update' model = function
    | VnesiNadniz str -> (
        match preberi_niz (stanja (model.avtomat)) (trenutna_stanja model.avtomat) str with
        | None ->{ model with stanje_vmesnika = OpozoriloONapacnemNizu } 
        | Some trenutna_stanja_avtomata -> 
            {
              model with
              trenutna_stanja_avtomata;
              stanje_vmesnika = RezultatPrebranegaNiza;
            })
    | ZamenjajVmesnik stanje_vmesnika ->{ model with 
    trenutna_stanja_avtomata = [(stanja model.avtomat).(0)] ;
    stanje_vmesnika }
    | VrniVPrvotnoStanje ->
        {
          model with
          trenutna_stanja_avtomata = trenutna_stanja (model.avtomat);
          stanje_vmesnika = SeznamMoznosti;
        }
    in 
    natisni_trenutna_stanja ((update' model msg).trenutna_stanja_avtomata); update' model msg


let rec izpisi_moznosti () =
  print_endline " ";
  print_endline "Izberi 1, 2 ali 3:";
  print_endline "1) izpiši avtomat";
  print_endline "2) beri znake";
  print_endline "3) nastavi na začetno stanje";
  print_string "> ";
  match read_line () with
  | "1" -> ZamenjajVmesnik IzpisAvtomata
  | "2" -> ZamenjajVmesnik BranjeNiza
  | "3" -> VrniVPrvotnoStanje
  | _ ->
      print_endline "** REKEL SEM VNESI 1, 2 ALI 3! Če pa ne znaš prešteti do tri, pa raje pojdi nazaj v vrtec! **";
      izpisi_moznosti ()

let izpisi_avtomat avtomat =
  let izpisi_stanje stanje =
    let indeks_stanja, char_stanja = stanje in
    let prikaz =  "(" ^ (string_of_int indeks_stanja) ^ ", " ^ (String.make 1 char_stanja) ^ ")" in
    let prikaz =
      if stanje = (stanja avtomat).(0) then "-> " ^ prikaz else prikaz
    in
    let prikaz =
      if stanje = sprejemno_stanje (stanja avtomat) then prikaz ^ " +" else prikaz
    in
    print_endline prikaz
  in
  Array.iter izpisi_stanje (stanja avtomat)

let beri_niz _model =
  print_string "Vnesi nadniz brez narekovajev.> ";
  let str = read_line () in
  VnesiNadniz str

let izpisi_rezultat model =
  if ali_vsebuje_sprejemno_stanje (stanja (model.avtomat)) model.trenutna_stanja_avtomata then
    Format.printf "Juhuhuuuuu! Podniz %s je bil najden v nadnizu :) \n%!" (iz_tabele_stanj (stanja (model.avtomat))) 
  else Format.printf  "Podniz %s ni bil najden v nadnizu :( Več sreče prihodnjič! \n%!" (iz_tabele_stanj (stanja (model.avtomat))) 

let view model =
  match model.stanje_vmesnika with
  | SeznamMoznosti -> izpisi_moznosti ()
  | IzpisAvtomata ->
      izpisi_avtomat model.avtomat;
      ZamenjajVmesnik SeznamMoznosti
  | BranjeNiza -> beri_niz model
  | RezultatPrebranegaNiza ->
      izpisi_rezultat model;
      ZamenjajVmesnik SeznamMoznosti
  | OpozoriloONapacnemNizu ->
      print_endline "Niz ni veljaven";
      ZamenjajVmesnik SeznamMoznosti

let init avtomat =
  {
    avtomat;
    trenutna_stanja_avtomata = [(stanja avtomat).(0)];
    stanje_vmesnika = SeznamMoznosti;
  }

let rec loop model =
  let msg = view model in
  let model' = update model msg in
  loop model'

let _ = 
  print_endline "Dobrodošel v iskalniku podnizov!";
  print_string "Vnesi podniz, ki ga iščeš, brez narekovajev.> ";
  let podniz = read_line () in
  loop (init (napolni_avtomat podniz))

