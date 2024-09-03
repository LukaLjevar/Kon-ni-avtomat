(*Stanja bomo označevali z UREJENIMI PARI int*char *)

type t = { oznaka : int * char }

let iz_para oznaka = { oznaka }
let v_par { oznaka } = oznaka