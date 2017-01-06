unit TSL;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math;

type
    TSign = record
      c1, c2, c3 : real;
    end;
    TTeinteTable = array[1..7] of TSign;

var
  TeintesReferences : TTeinteTable ;

function TSL_getTeinteIndex(var R,G,B : Byte) : integer;

implementation

function  TSL_getTeinteIndex(var R,G,B : Byte) : integer;
var
  _max, _teinte, i : integer;
  _delta, _min : real;
  signature : TSign;
begin
  _max := R;
  if G > _max then _max := G;
  if B > _max then _max := B;
  if _max > 0 then begin
    signature.c1 := R / _max;
    signature.c2 := G / _max;
    signature.c3 := B / _max;
  end else begin
    signature.c1 := 1;
    signature.c2 := 1;
    signature.c3 := 1;
  end;
  _delta := power(signature.c1-TeintesReferences[1].c1,2) + power(signature.c2-TeintesReferences[1].c2,2) + power(signature.c3-TeintesReferences[1].c3,2);
  _min := _delta ;
  _teinte := 1;
  for i:= 2 to 7 do begin
    _delta := power(signature.c1-TeintesReferences[i].c1,2) + power(signature.c2-TeintesReferences[i].c2,2) + power(signature.c3-TeintesReferences[i].c3,2);
    if _delta < _min then begin
      _teinte := i;
      _min := _delta;
    end;
  end;
  TSL_getTeinteIndex := _teinte;
end;

begin
  TeintesReferences[1].c1 := 1.0;
  TeintesReferences[1].c2 := 0.0;
  TeintesReferences[1].c3 := 0.0;
  TeintesReferences[2].c1 := 1.0;
  TeintesReferences[2].c2 := 1.0;
  TeintesReferences[2].c3 := 0.0;
  TeintesReferences[3].c1 := 0.0;
  TeintesReferences[3].c2 := 1.0;
  TeintesReferences[3].c3 := 0.0;
  TeintesReferences[4].c1 := 0.0;
  TeintesReferences[4].c2 := 1.0;
  TeintesReferences[4].c3 := 1.0;
  TeintesReferences[5].c1 := 0.0;
  TeintesReferences[5].c2 := 0.0;
  TeintesReferences[5].c3 := 1.0;
  TeintesReferences[6].c1 := 1.0;
  TeintesReferences[6].c2 := 0.0;
  TeintesReferences[6].c3 := 1.0;
  TeintesReferences[7].c1 := 1.0;
  TeintesReferences[7].c2 := 1.0;
  TeintesReferences[7].c3 := 1.0;
end.

