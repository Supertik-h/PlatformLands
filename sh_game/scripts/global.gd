extends Node

var gol_in = false
var przelacznik = false

#walka ze zdrowiem
var globalHealth: int = 3  # Nowa nazwa zmiennej globalnej

#rozwiązanie problemu teleportacji w czasoprzestrzeni po wyjsciu z góry
var last_entry_position = Vector2.ZERO

var klucze = 0

var zebrana = false
var zebrana_ogien = false


var changed = false

#znikajace platformy
var is_player_on_platform = false


var zabite_golemy = 0


#ograniczenie dasha
var dash = 0

var panda_byla_o = false
var tiger_byl_o = false


#pickup
var zebrano = false
var umarto = false
var zebrano_klucz = false
