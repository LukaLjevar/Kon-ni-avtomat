type stanje = Stanje.t

(*Niz pretvorimo v tabelo stanj*)
let razbij_v_tabelo_stanj niz = 
  if niz = "" then [|(-1, 'X')|] else
    let n = String.length niz in
    let a = Array.make (n + 1) (-1, 'X') in
    for i = 1 to n do
      a.(i) <- (i - 1, String.get  niz (i - 1)) 
    done; a 
    
(*Iz tabele stanj izluščimo sprejemno stanje - to je zadnje stanje v tabeli*)
let sprejemno_stanje tabela_stanj = 
  if tabela_stanj = [||] then failwith "Tabela stanj je vedno neprazna!" else
    let n = Array.length tabela_stanj in
    tabela_stanj.(n - 1)
    
(*Povemo: 1. v katerem stanju se nahajamo trenutno
2. katera stanja so na voljo
3. kateri je vaslednji zank iz nadniza, ki ga avtomat prejme
funkcija vrne stanje, v katerem se avtomat nahaja po tem*)
let pomozna_prehodna_funkcija tabela_stanj (int, char) znak = 
  (*Če smo že začeli v sprejemnem stanju, potem v njem ostanemo*)  
  match int, znak with
  |x, _ when x = (Array.length tabela_stanj) - 2 -> [(int, char)] 
  |(-1),  _ when Array.length tabela_stanj = 1 -> [(int, char)]
  |(-1), z when z = snd (tabela_stanj.(1)) -> [tabela_stanj.(0); tabela_stanj.(1)]
  |n, z when snd tabela_stanj.(n + 2) = z -> [tabela_stanj.(int + 2)] 
  |_ -> [tabela_stanj.(0)] 
        
let prehodna tabela_stanj seznam_vseh_trenutnih_stanj znak = 
  List.flatten (List.map (fun t -> pomozna_prehodna_funkcija tabela_stanj t znak) seznam_vseh_trenutnih_stanj) 
                                                                        
type t = 
  {iskani_podniz : string ; 
   zacetno_stanje : stanje ;
   trenutno_stanje : stanje list;
   stanja : stanje array ;
   sprejemno_stanje : stanje ; 
   prehodi : stanje list -> char -> stanje list
  }
  
let napolni_avtomat podniz = 
  {iskani_podniz = podniz ; 
   zacetno_stanje = (-1, 'X') ;
   trenutno_stanje = [(-1, 'X')] ;
   stanja = razbij_v_tabelo_stanj podniz ;
   sprejemno_stanje = sprejemno_stanje (razbij_v_tabelo_stanj podniz) ; 
   prehodi = prehodna (razbij_v_tabelo_stanj podniz)
  }
  
let ali_vsebuje_sprejemno_stanje tabela_stanj ls =   
  List.exists (fun t -> t = (sprejemno_stanje tabela_stanj)) ls


  

