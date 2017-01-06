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
    TCoefSatDSat = record
      sat : record
        r,g,b : real;
      end;
{
      dsat : record
        r,g,b : real;
      end;
}
    end;

var
  TeintesReferences : TTeinteTable ;

// Détermine à quelle teinte appartient la couleur.
//  La teinte d'appartenance est déterminée par la différence minimale
//  de la couleur avec la teinte saturée.
//  L'écart minimum indique à quelle teinte la couleur appartient.
function TSL_getTeinteIndex(var R,G,B : Byte) : integer;

// Détermination des coef de saturation de la couleur
function TSL_getSATcoef(R,G,B : Byte) : TCoefSatDSat;

// Déterminantion de la distance d'une couleur à une teinte saturée
function TSL_getColorDistance(TR,TG,TB : boolean; R,G,B : Byte) : real;

implementation

// indes des teintes
// 1 => IOO [R];
// 2 => IIO [RG];
// 3 => OIO [G];
// 4 => OII [GB];
// 5 => OOI [B];
// 6 => IOI [RB];
// 7 => III [RGB].

function  TSL_getTeinteIndex(var R,G,B : Byte) : integer;
var
  _max, _teinte, i : integer;
  _delta, _min : real;
  signature : TSign;
begin
  _teinte := 7;
  if not ((R=G) and (G=B)) then
  begin
    _max := 1;
    if R > _max then _max := R;
    if G > _max then _max := G;
    if B > _max then _max := B;
    signature.c1 := R / _max;
    signature.c2 := G / _max;
    signature.c3 := B / _max;
    _delta := power(signature.c1-TeintesReferences[1].c1,2) + power(signature.c2-TeintesReferences[1].c2,2) + power(signature.c3-TeintesReferences[1].c3,2);
    _min := _delta ;
    _teinte := 1;
    for i:= 2 to 6 do begin
      _delta := power(signature.c1-TeintesReferences[i].c1,2) + power(signature.c2-TeintesReferences[i].c2,2) + power(signature.c3-TeintesReferences[i].c3,2);
      if _delta < _min then begin
        _teinte := i;
        _min := _delta;
      end;
    end;
  end;
  TSL_getTeinteIndex := _teinte;
end;

function TSL_getSATcoef(R,G,B : Byte) : TCoefSatDSat;
var iT : integer; // index de la teinte la plus proche de la couleur
  _coef : TCoefSatDSat;
  _distcolor : real;
begin
  // Détermination de la teinte d'appartenance de la couleur
  iT := TSL_getTeinteIndex(R,G,B);
  if iT = 1 then begin
    // IOO
    _distcolor := 1-TSL_getColorDistance(true, false, false, r,g,b);
    with _coef.sat do
    begin
      r := (255 - R)*_distcolor/255;
      g := (- G)*_distcolor/255;
      b := (- B)*_distcolor/255;
    end;
{
    with _coef.dsat do
    begin
      r := 1 - _coef.sat.r;
      g := 1 - _coef.sat.g;
      b := 1 - _coef.sat.b;
    end;
}
  end else if iT = 2 then begin
    // IIO
    _distcolor := 1-TSL_getColorDistance(true, true, false, r,g,b);
    with _coef.sat do
    begin
      r := (255 - R)*_distcolor/255;
      g := (255 - G)*_distcolor/255;
      b := (- B)*_distcolor/255;
    end;
{
    with _coef.dsat do
    begin
      r := 1 - _coef.sat.r;
      g := 1 - _coef.sat.g;
      b := 1 - _coef.sat.b;
    end;
}
  end else if iT = 3 then begin
    // OIO
    _distcolor := 1-TSL_getColorDistance(false, true, false, r,g,b);
    with _coef.sat do
      begin
        r := (- R)*_distcolor/255;
        g := (255 - G)*_distcolor/255;
        b := (- B)*_distcolor/255;
      end;
{
    with _coef.dsat do
      begin
        r := 1 - _coef.sat.r;
        g := 1 - _coef.sat.g;
        b := 1 - _coef.sat.b;
      end;
}
  end else if iT = 4 then begin
    // OII
    _distcolor := 1-TSL_getColorDistance(false, true, true, r,g,b);
    with _coef.sat do
      begin
        r := (- R)*_distcolor/255;
        g := (255 - G)*_distcolor/255;
        b := (255 - B)*_distcolor/255;
      end;
{
    with _coef.dsat do
      begin
        r := 1 - _coef.sat.r;
        g := 1 - _coef.sat.g;
        b := 1 - _coef.sat.b;
      end;
}
  end else if iT = 5 then begin
    // OOI
    _distcolor := 1-TSL_getColorDistance(false, false, true, r,g,b);
    with _coef.sat do
      begin
        r := (- R)*_distcolor/255;
        g := (- G)*_distcolor/255;
        b := (255 - B)*_distcolor/255;
      end;
{
    with _coef.dsat do
      begin
        r := 1 - _coef.sat.r;
        g := 1 - _coef.sat.g;
        b := 1 - _coef.sat.b;
      end;
}
  end else if iT = 6 then begin
    // IOI
    _distcolor := 1-TSL_getColorDistance(false, false, true, r,g,b);
    with _coef.sat do
      begin
        r := (255 - R)*_distcolor/255;
        g := (- G)*_distcolor/255;
        b := (255 - B)*_distcolor/255;
      end;
{
    with _coef.dsat do
      begin
        r := 1 - _coef.sat.r;
        g := 1 - _coef.sat.g;
        b := 1 - _coef.sat.b;
      end;
}
  end else if iT = 7 then begin
    // III
    _distcolor := 1-TSL_getColorDistance(false, false, true, r,g,b);
    with _coef.sat do
      begin
        r := (255 - R)*_distcolor/255;
        g := (255 - G)*_distcolor/255;
        b := (255 - B)*_distcolor/255;
      end;
{
    with _coef.dsat do
      begin
        r := 1 - _coef.sat.r;
        g := 1 - _coef.sat.g;
        b := 1 - _coef.sat.b;
      end;
}
  end else begin
    with _coef.sat do
    begin
      r := 0.0;
      g := 0.0;
      b := 0.0;
    end;
{
    with _coef.dsat do
    begin
      r := 0.0;
      g := 0.0;
      b := 0.0;
    end;
}
  end;
end;

function TSL_getColorDistance (TR,TG,TB : boolean; R,G,B : Byte) : real;
var _R,_G,_B, _TR, _TB, _TG, _Delta2 : real;
begin
  if TR then _TR := 1 else _TR := 0;
  if TB then _TB := 1 else _TB := 0;
  if TG then _TG := 1 else _TG := 0;
  if _TR + _TG + _TB = 1 then TSL_GetColorDistance := 0
  else begin
       _Delta2 := (power(_TR - R,2) + power(_TG - G,2) + power(_TB - B,2)) / 3;
       TSL_GetColorDistance := sqrt(_Delta2);
  end;
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

