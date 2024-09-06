type stanje = Stanje.t

(*Niz pretvorimo v tabelo stanj*)
let razbij_v_tabelo_stanj niz = 
  if niz = "" then [|(-1, 'X')|] else
    let n = String.length niz in
    let a = Array.make (n + 1) (-1, 'X') in
    for i = 1 to n do
      a.(i) <- (i - 1, String.get  niz (i - 1)) 
    done; a 

let iz_tabele_stanj tab =  
  if tab = [||] then failwith "Tabela stanj je vedno neprazna!" else
    let n  = Array.length tab in
    if n = 1 then "" else
      let r = ref "" in
    for i = 1 to  n - 1 do
     r :=   (!r) ^ (String.make 1 (snd tab.(i)))
    done; !r

    
(*Iz tabele stanj izluščimo sprejemno stanje - to je zadnje stanje v tabeli*)
let sprejemno_stanje tabela_stanj = 
  if tabela_stanj = [||] then failwith "Tabela stanj je vedno neprazna!" else
    let n = Array.length tabela_stanj in
    tabela_stanj.(n - 1)
    
(*Povemo: 1. V katerem stanju se trenutno nahajamo,
2. katera stanja so na voljo, 
3. kateri je naslednji zank iz nadniza, ki ga avtomat prejme
funkcija vrne stanje, v katerem se avtomat nahaja po tem.*)
let pomozna_prehodna_funkcija tabela_stanj (int, char) znak = 
  (*Če smo že začeli v sprejemnem stanju, potem v njem ostanemo*)  
  match int, znak with
  |x, _ when x = (Array.length tabela_stanj) - 2 -> [(int, char)] 
  |(-1),  _ when Array.length tabela_stanj = 1 -> [(int, char)]
  |(-1), z when z = snd (tabela_stanj.(1)) -> [tabela_stanj.(0); tabela_stanj.(1)]
  |n, z when snd tabela_stanj.(n + 2) = z -> [tabela_stanj.(int + 2)] 
  |_ -> [tabela_stanj.(0)] 
        
let prehodna tabela_stanj seznam_vseh_trenutnih_stanj znak = 
  let ls = List.flatten (List.map (fun t -> pomozna_prehodna_funkcija tabela_stanj t znak) seznam_vseh_trenutnih_stanj) in
  if List.mem (tabela_stanj.(0)) ls then ls else (tabela_stanj.(0)) :: ls
                    
type t = 
  {iskani_podniz : string ; 
   zacetno_stanje : stanje ;
   trenutna_stanja : stanje list;
   stanja : stanje array ;
   sprejemno_stanje : stanje ; 
   prehodi : stanje list -> char -> stanje list
  }
  
let napolni_avtomat podniz = 
  {iskani_podniz = podniz ; 
   zacetno_stanje = (-1, 'X') ;
   trenutna_stanja = [(-1, 'X')] ;
   stanja = razbij_v_tabelo_stanj podniz ;
   sprejemno_stanje = sprejemno_stanje (razbij_v_tabelo_stanj podniz) ; 
   prehodi = prehodna (razbij_v_tabelo_stanj podniz)
  }
  
let stanja {stanja; _} = stanja

let trenutna_stanja {trenutna_stanja; _ } = trenutna_stanja

let ali_vsebuje_sprejemno_stanje tabela_stanj ls =   
  List.exists (fun t -> t = (sprejemno_stanje tabela_stanj)) ls


(*Funkcija, ki je odvisna od trenutnih stanj. Tako iz končnega avtomata dobimo Moorov avtomat.*)  
let natisni_trenutna_stanja ls =
  let rec natisni' = function
  |[] -> ()
  |[(n, c)] -> print_string ("(" ^ string_of_int n ^", "^ (String.make 1 c) ^ ")")
  |(n, c)::xs -> print_string ("(" ^ string_of_int n ^", "^ (String.make 1 c) ^ "); "); natisni' xs
in print_endline ""; print_string "Trenutna stanja avtomata: ["; natisni' ls; print_string "]"; print_endline ""; print_endline ""





  

