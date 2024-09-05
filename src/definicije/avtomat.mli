type t

type stanje = Stanje.t
val razbij_v_tabelo_stanj : string -> stanje array
val iz_tabele_stanj : stanje array -> string
val prehodna : stanje array -> stanje list -> char -> stanje list
val sprejemno_stanje : stanje array -> stanje
val napolni_avtomat : string -> t
val stanja : t -> stanje array
val trenutna_stanja : t -> stanje list
val ali_vsebuje_sprejemno_stanje : stanje array -> stanje list -> bool