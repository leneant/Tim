unit TabChainee;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const TTBL_Max = 18000000; // 18 méga

type
  TTBL_Chaine_M = record
    _next : LongInt;
  end;

  TTBL_Chaine_A = record
    _free, _deb : LongInt;
  end;

  TTBL_Chaine = record
    _list : array[1..TTBL_Max] of TTBL_Chaine_M ;
    _ancre : TTBL_Chaine_A ;
  end;


function TTBL_new(var _list : TTBL_Chaine) : LongInt;
procedure TTBL_disposeall(var _list : TTBL_Chaine);
procedure TTBL_init(var _list : TTBL_Chaine);
function TTBL_getNext(_ptr : LongInt; var _list : TTBL_Chaine) : LongInt;

implementation

function TTBL_new(var _list : TTBL_Chaine) : LongInt;
var _int, _freenext : LongInt;
begin
  if _list._ancre._free > 0 then begin
    _int := _list._ancre._free;
    _freenext := _list._list[_int]._next;
    _list._ancre._free := _freenext;
    _list._list[_int]._next := _list._ancre._deb;
    _list._ancre._deb := _int;
    TTBL_new := _int;
  end else TTBL_new := 0;
end;

procedure TTBL_disposeall(var _list : TTBL_Chaine);
var i : LongInt;
begin
  for i := 1 to _list._ancre._deb do
    _list._list[i]._next := i+1;
  _list._list[TTBL_Max]._next := 0; // Fin de la mémoire
  _list._ancre._deb := 0;           // Rien d'alloué
  _list._ancre._free := 1;          // Tout est libre
end;

procedure TTBL_init(var _list : TTBL_Chaine);
var i : LongInt;
begin
  for i := 1 to TTBL_Max - 1 do         // Initialisation des chaînages
    _list._list[i]._next := i+1;
  _list._list[TTBL_Max]._next := 0;
  _list._ancre._deb := 0;
  _list._ancre._free := 1;
end;

function TTBL_getNext(_ptr : LongInt; var _list : TTBL_Chaine) : LongInt;
begin
  if (_ptr > 0) and (_ptr < _list._ancre._free) then
     TTBL_getNext := _list._list[_ptr]._next
  else TTBL_getNext := 0;
end;

end.

