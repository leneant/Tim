unit TSL;

{$mode objfpc}{$H+} {$F+}

interface

uses
  Classes, SysUtils, math, Graphics, marqueurs;

type
    TSign = record
      c1, c2, c3 : real;
    end;
    TTeinteTable = array[1..7] of TSign;
    TCoefSatDSat = record
      r : real;
      g : real;
      b : real;
    end;
    TColorAdapt = record
      R, G, B : integer
    end;

    TCouleur = record
      R, V, B : real;
    end;

    TTSL = record
      T, S, L : real;
    end;

var
  TeintesReferences : TTeinteTable ;

// Calcul de la couleur d'une température donnée sur une échelle de 0 à 1 0->Rouge, 1->Bleue
function TSL_TempColor(x : real) : TCouleur;

//Application de la couleur "de chaleur" à une couleur donnée (on la réchauffe ou on la refroidie ou on fait rien)
function TSL_ApplyAddColor(tempColor : TCouleur; R,G,B : Integer; _coef : real) : TColor;
function TSL_ApplySubColor(tempColor : TCouleur; R,G,B : Integer; _coef : real) : TColor;


// Détermine à quelle teinte appartient la couleur.
//  La teinte d'appartenance est déterminée par la différence minimale
//  de la couleur avec la teinte saturée.
//  L'écart minimum indique à quelle teinte la couleur appartient.
function TSL_getTeinteIndexOld(var R,G,B : Byte) : integer;
function TSL_getTeinteIndex(var R,G,B : Byte) : integer;

// Modification de la saturation (+ ou - le facteur addSat) d'une couleur
function TSL_modifSat(var R,G,B : Byte; addSat : integer; synchro : boolean) : TColor;

// Conversion de l'espace de couleur RGB en TSL
function TSL_getTSLFromRGB(var R,G,B : Byte) : TTSL;

// Détermination de la couleur RGB depuis la couleur TSL
// 0° <= Hue < 360°
// 0 <= Saturation <= 1
// 0 <= Luminance <= 1
function TSL_getRGBColorFromTSL(Hue,Saturation,Luminance:real) : TColor;

// Détermination des coef de saturation de la couleur
function TSL_getSATcoef(_R,_G,_B : Byte) : TCoefSatDSat;

// Déterminantion de la distance d'une couleur à une teinte saturée
function TSL_getColorDistance(TR,TG,TB : boolean; R,G,B : Byte) : real;

// Détermination du décallage de couleur (rotation de teinte)
function TSL_DecalTeinte(indexTeinteBase, coef_delta : integer) : TColorAdapt;

// Détermination de la couleur RGB selon l'angle de la couleur TSL
function TSL_getRGBColorFromTSL(angle : real) : TColor;


implementation

// Internal normalization of color angle
function TSL_NormAngle (angle : real) : real;
var rest, value, ret : real;
begin
  if angle < 0 then begin // angle < 0 il faut le rexprimer entre 0 et 360
    angle := -angle ;
    if angle > 360 then begin // angle > 360, il faut trouver l'angle entre 0 et 360
      value := trunc(angle/360);
      rest := angle - (value * 360);
      ret := 360 - rest;
    end else ret := 360 - angle;
  end else begin // Angle >= 0
    if angle > 360 then begin // angle > 360 il faut l'exprimer entre 0 et 360
      value := trunc(angle/360);
      ret := angle - (value * 360);
    end else ret := angle;
  end;
  TSL_NormAngle := ret;
end;

// Externals

// Modification de la saturation d'un pixel RGB
function TSL_modifSat(var R,G,B : Byte; addSat : integer; synchro : boolean) : TColor;
var TSL : TTSL;
  delta_sat, _coef, _num : real;
  color : TColor;
  _R,_G,_B : integer;
begin
  // Transformation du RGB en TSL
  TSL := TSL_getTSLfromRGB(R,G,B);

  if (R = G) and (G = B) then begin
    _R := R;
    _G := G;
    _B := B;
  end else begin
    // Modification de la saturation
    if addSat = 255 then TSL.S := 1
    else if addSat = -1 then TSL.S := 0 else begin
      if synchro then begin
        if addSat < 0 then begin
          delta_sat := addSat * TSL.S / 255;
        end else begin
           delta_sat := addSat * (1 - TSL.L) / 255;
        end;
      end else begin
        delta_sat := addSat / 255;
      end;
      TSL.S := TSL.S + delta_sat;
    end;
    TSL.T := TSL.T * 360;
    if TSL.S > 1.0 then TSL.S := 1 else if TSL.S < 0.0 then TSL.S := 0;

    // Transformation du TSL en RGB
    color := TSL_getRGBColorFromTSL(TSL.T, TSL.S, TSL.L);
    _R := integer(red(color));
    _G := integer(green(color));
    _B := integer(blue(color));
    if _R < 0 then _R := 0 else if _R > 255 then _R := 255;
    if _G < 0 then _G := 0 else if _G > 255 then _G := 255;
    if _B < 0 then _B := 0 else if _B > 255 then _B := 255;
  end;
  TSL_modifSat := RGBToColor(Byte(_R), Byte(_G), Byte(_B));

end;

// Détermination de la couleur RGB depuis la couleur TSL
function TSL_getRGBColorFromTSL(Hue,Saturation,Luminance:real) : TColor;
// 0° <= Hue < 360°
// 0 <= Saturation <= 1
// 0 <= Luminance <= 1
var
  fChroma, fHue,FhueMod2,fTemp,fRed,FGreen,fBlue,fMin : real;
  iRed,iGreen,iBlue : integer;
begin
   // Normalise hue
   Hue := TSL_NormAngle (Hue);
   fChroma := (1.0 - Abs(2.0 * Luminance - 1.0)) * Saturation;
   fHue := Hue / 60.0;
   fHueMod2 := fHue;
   while (fHueMod2 >= 2.0) do fHueMod2 := fHueMod2 - 2.0;
   fTemp := fChroma * (1.0 - Abs(fHueMod2 - 1.0));

   fRed := 0;
   fGreen := 0;
   fBlue := 0;
   if (fHue < 1.0) then
   begin
       fRed := fChroma;
       fGreen := fTemp;
       fBlue := 0;
   end else if (fHue < 2.0) then
   begin
       fRed := fTemp;
       fGreen := fChroma;
       fBlue := 0;
   end else if (fHue < 3.0) then
   begin
       fRed := 0;
       fGreen := fChroma;
       fBlue := fTemp;
   end else if (fHue < 4.0) then
   begin
       fRed := 0;
       fGreen := fTemp;
       fBlue := fChroma;
   end else if (fHue < 5.0) then
   begin
       fRed := fTemp;
       fGreen := 0;
       fBlue := fChroma;
   end else if (fHue < 6.0) then
   begin
       fRed := fChroma;
       fGreen := 0;
       fBlue := fTemp;
   end else
   begin
       fRed := 0;
       fGreen := 0;
       fBlue := 0;
   end;

   fMin := Luminance - 0.5 * fChroma;
   fRed := fRed + fMin;
   fGreen := fGreen + fMin;
   fBlue := fBlue + fMin;

   fRed := fRed * 255.0;
   fGreen := fGreen * 255.0;
   fBlue := fBlue * 255.0;

   // the default seems to be to truncate rather than round
   iRed := Trunc(fRed);
   iGreen := Trunc(fGreen);
   iBlue := Trunc(fBlue);
   if saturation = 0 then begin
     iRed := (iRed + iGreen + iBlue) div 3;
     iGreen := iRed;
     iBlue := iRed;
   end;
   if (iRed < 0) then iRed := 0 else if (iRed > 255) then iRed := 255;
   if (iGreen < 0) then iGreen := 0 else if (iGreen > 255) then iGreen := 255;
   if (iBlue < 0) then iBlue := 0 else if (iBlue > 255) then iBlue := 255;
   TSL_getRGBColorFromTSL := RGBToColor (Byte(iRed), Byte(iGreen), Byte(iBlue));
end;

// Détermination de la couleur RGB selon l'angle de la couleur TSL
function TSL_getRGBColorFromTSL(angle : real) : TColor;
var ret : TCouleur;
  valeur : real;
begin
  // Normalisation de l'angle
  angle := TSL_NormAngle(angle);
  // 0°, 360° => Rouge
  // 60° => Jaune
  // 120° => Vert
  // 180° => Cyan
  // 240° => Bleu
  // 300° => Magenta
  if angle <= 60 then begin // Rouge vers jaune 0 = Rouge, 60 jaune
    ret.R := 1;
    ret.V := angle / 60;
    ret.B := 0;
  end else if angle <= 120 then begin // Jaune vers vert
    valeur := angle - 60;
    ret.R := (60-valeur)/60;
    ret.V := 1;
    ret.B := 0;
  end else if angle <= 180 then begin // Vert vers Cyan
    valeur := angle - 120;
    ret.R := 0;
    ret.V := 1;
    ret.B := valeur/60;
  end else if angle <= 240 then begin // Cyan vert bleu
    valeur := angle - 180;
    ret.R := 0;
    ret.V := (60-valeur)/60;
    ret.B := 1;
  end else if angle <= 300 then begin // Bleu vers magenta
    valeur := angle - 240;
    ret.R := valeur/60;
    ret.V := 0;
    ret.B := 1;
  end else begin // Magenta vers rouge
    valeur := angle - 300;
    ret.R := 1;
    ret.V := 0;
    ret.B := (60-valeur)/60;
  end;
  TSL_getRGBColorFromTSL := RGBToColor(Byte(round(ret.R*255)),Byte(round(ret.V*255)),Byte(round(ret.B*255)));
end;

// Calcul de la couleur d'une température donnée sur une échelle de 0 à 1 0->Rouge, 1->Bleue
function TSL_TempColor(x : real) : TCouleur;
var _r,_v,_b : real;
  _ret : TCouleur;
begin
  if x < 1/3 then begin
    _r := 1 ;
    _v := 3*x;
    _b := 0;
  end else if x < 2/3 then begin
    _r := 1;
    _v := 1;
    _b := (x - 1/3) * 3;
  end else begin
    _r := 1 - ((x - 2/3) * 3);
    _v := 1;
    _b := 1;
  end;
  with _ret do begin
      R := _r*255;
      V := _v*255;
      B := _b*255;
  end;
  TSL_TempColor := _ret;
end;

//Application de la couleur "de chaleur" à une couleur donnée (on la réchauffe ou on la refroidie ou on fait rien)
function TSL_ApplyAddColor(tempColor : TCouleur; R,G,B : Integer; _coef : real) : TColor;
var lum, _div : real;
  _R,_V,_B : integer;
begin
  // Calcul du coef de lum init.
  lum := (R+G+B)/3/255;
  if lum > 0 then begin
     _div := (1 + (_coef * lum));
     // Determination de la luminance de la temperature cible adaptée à la luminance de la couleur à modifier
     with tempColor do begin
       R := R * lum;
       V := V * lum;
       B := B * lum;
      end;
     // Teinte de la couleur pour la réchauffer ou la refroidir
     _R := round((R + (tempColor.R * _coef))/_div);
     _V := round((G + (tempColor.V * _coef))/_div);
     _B := round((B + (tempColor.B * _coef))/_div);
     // Calcul de la luminance après modif
     // Calcul de la couleur finale
     if _R > 255 then begin
       _R := 255;
       cramee := true;
     end;
     if _V > 255 then begin
       _V := 255;
       cramee := true;
     end;
     if _B > 255 then begin
       _B := 255;
       cramee := true;
     end;
  end else begin
    _R := R;
    _V := G;
    _B := B;
  end;
  TSL_ApplyAddColor := RGBToColor(_R, _V, _B);
end;

// Soustraction de la couleur
function TSL_ApplySubColor(tempColor : TCouleur; R,G,B : Integer; _coef : real) : TColor;
var lum, _div : real;
  _R,_V,_B : integer;
begin
  // Calcul du coef de lum init.
  lum := (R+G+B)/3/255;
  if lum > 0 then begin
     _div := (1 + (_coef * lum));
     // Determination de la luminance de la temperature cible adaptée à la luminance de la couleur à modifier
     with tempColor do begin
       R := R * lum;
       V := V * lum;
       B := B * lum;
      end;
     // Teinte de la couleur pour la réchauffer ou la refroidir
     _R := round((R - (tempColor.R * _coef))*_div);
     _V := round((G - (tempColor.V * _coef))*_div);
     _B := round((B - (tempColor.B * _coef))*_div);
     // Calcul de la luminance après modif
     // Calcul de la couleur finale
     if _R > 255 then begin
       _R := 255;
       cramee := true;
     end else if _R < 0 then begin
       _R := 0;
       bouchee := true;
     end;
     if _V > 255 then begin
       _V := 255;
       cramee := true;
     end else if _V < 0 then
     begin
       _V := 0;
       bouchee := true;
     end;
     if _B > 255 then begin
       _B := 255;
       cramee := true;
     end else if _B < 0 then begin
       _B := 0;
       bouchee := true;
     end;
  end else begin
    _R := R;
    _V := G;
    _B := B;
  end;
  TSL_ApplySubColor := RGBToColor(_R, _V, _B);
end;


// index des teintes
// 1 => IOO [R];
// 2 => IIO [RG];
// 3 => OIO [G];
// 4 => OII [GB];
// 5 => OOI [B];
// 6 => IOI [RB];
// 7 => III [RGB].

function  TSL_getTeinteIndexOld(var R,G,B : Byte) : integer;
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
  TSL_getTeinteIndexOld := _teinte;
end;

function TSL_getTeinteIndex(var R,G,B : Byte) : integer;
var var_r, var_g, var_b, del_r, del_g, del_b : real;
  var_min, var_max, del_max : real;
  L, H, Hue : real;
  idx : integer;

begin
  if (R=G) and (G=B) then idx := 7 else begin
    var_r := R / 255;
    var_g := G / 255;
    var_b := B / 255;

    var_max := max(var_r, max(var_g, var_b));
    var_min := min(var_r, min(var_g, var_b));
    del_max := var_max - var_min;

    L := (var_max + var_min) / 2;

    if del_max = 0 then begin
      H := 0;
    end else begin

      del_R := ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
      del_G := ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
      del_B := ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max;

      if      ( var_R = var_Max ) then H := del_B - del_G
      else if ( var_G = var_Max ) then H := ( 1 / 3 ) + del_R - del_B
      else if ( var_B = var_Max ) then H := ( 2 / 3 ) + del_G - del_R;

      if ( H < 0 ) then H := H+1;
      if ( H > 1 ) then H := H -1;
    end;
    Hue := H * 360;
    if (Hue >= 0) and (Hue <= 30) then idx := 1
    else if Hue <= 90 then idx := 2
    else if Hue <= 150 then idx := 3
    else if Hue <= 210 then idx := 4
    else if Hue <= 270 then idx := 5
    else if Hue <= 330 then idx := 6
    else idx := 1;
  end;
  TSL_GetTeinteIndex := idx;
end;

function TSL_getTSLFromRGB(var R,G,B : Byte) : TTSL;
var var_r, var_g, var_b, del_r, del_g, del_b : real;
  var_min, var_max, del_max : real;
  L, H, S : real;
  idx : TTSL;

begin
  if (R=G) and (G=B) then begin
    idx.T := 0.0;
    idx.S := 0.0;
    idx.L := 0.0;
  end else begin
    var_r := R / 255;
    var_g := G / 255;
    var_b := B / 255;

    var_max := max(var_r, max(var_g, var_b));
    var_min := min(var_r, min(var_g, var_b));
    del_max := var_max - var_min;

    L := (var_max + var_min) / 2;

    if del_max = 0 then begin
      H := 0;
      S := 0;
    end else begin
      if L < 0.5 then S := del_Max / ( var_Max + var_Min )
      else  S := del_Max / ( 2 - var_Max - var_Min );

      del_R := ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
      del_G := ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
      del_B := ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max;

      if      ( var_R = var_Max ) then H := del_B - del_G
      else if ( var_G = var_Max ) then H := ( 1 / 3 ) + del_R - del_B
      else if ( var_B = var_Max ) then H := ( 2 / 3 ) + del_G - del_R;

      if ( H < 0 ) then H := H+1;
      if ( H > 1 ) then H := H -1;
    end;
  end;
  idx.T := H;
  idx.S := S;
  idx.L := L;
  TSL_getTSLFromRGB := idx;
end;


function TSL_getSATcoef(_R,_G,_B : Byte) : TCoefSatDSat;
var iT : integer; // index de la teinte la plus proche de la couleur
  _coef : TCoefSatDSat;
  _distcolor : real;
begin
  // Détermination de la teinte d'appartenance de la couleur
  iT := TSL_getTeinteIndex(_R,_G,_B);
  _distcolor := 1 / 500 ;
  if iT = 1 then begin
    // IOO
    // _distcolor := TSL_getColorDistance(true, false, false, _r,_g,_b) / 500;
    _coef.r := (255 - _R)*_distcolor;
    _coef.g := (- _G)*_distcolor;
    _coef.b := (- _B)*_distcolor;
  end else if iT = 2 then begin
    // IIO
    // _distcolor := TSL_getColorDistance(true, true, false, _r,_g,_b) / 500;
    _coef.r := (255 - _R)*_distcolor;
    _coef.g := (255 - _G)*_distcolor;
    _coef.b := (- _B)*_distcolor;
  end else if iT = 3 then begin
    // OIO
    // _distcolor := TSL_getColorDistance(false, true, false, _r,_g,_b) / 500;
    _coef.r := (- _R)*_distcolor;
    _coef.g := (255 - _G)*_distcolor;
    _coef.b := (- _B)*_distcolor;
  end else if iT = 4 then begin
    // OII
    // _distcolor := TSL_getColorDistance(false, true, true, _r,_g,_b) / 500;
    _coef.r := (- _R)*_distcolor;
    _coef.g := (255 - _G)*_distcolor;
    _coef.b := (255 - _B)*_distcolor;
  end else if iT = 5 then begin
    // OOI
    // _distcolor := TSL_getColorDistance(false, false, true, _r,_g,_b) / 500;
    _coef.r := (- _R)*_distcolor;
    _coef.g := (- _G)*_distcolor;
    _coef.b := (255 - _B)*_distcolor;
  end else if iT = 6 then begin
    // IOI
    // _distcolor := TSL_getColorDistance(true, false, true, _r,_g,_b) / 500;
    _coef.r := (255 - _R)*_distcolor;
    _coef.g := (- _G)*_distcolor;
    _coef.b := (255 - _B)*_distcolor;
  end else if iT = 7 then begin
    // III
    // _distcolor := TSL_getColorDistance(true, true, true, _r,_g,_b) / 500;
    _coef.r := (255 - _R)*_distcolor;
    _coef.g := (255 - _G)*_distcolor;
    _coef.b := (255 - _B)*_distcolor;
  end else begin
    _coef.r := 0.0;
    _coef.g := 0.0;
    _coef.b := 0.0;
  end;
  TSL_getSATcoef := _coef;
end;

function TSL_getColorDistance (TR,TG,TB : boolean; R,G,B : Byte) : real;
var _R,_G,_B, _TR, _TB, _TG, _Delta2, _ret : real;
begin
  _R := R / 255;
  _G := G / 255;
  _B := B / 255;
  if TR then _TR := 1 else _TR := 0;
  if TB then _TB := 1 else _TB := 0;
  if TG then _TG := 1 else _TG := 0;
       _Delta2 := (power(_TR - _R,2) + power(_TG - _G,2) + power(_TB - _B,2)) / 3;
       _ret := sqrt(_Delta2);
       TSL_GetColorDistance := _ret;
end;

// Détermination du décallage de couleur (rotation de teinte)
function TSL_DecalTeinte(indexTeinteBase, coef_delta : integer) : TColorAdapt;
var _R,_G,_B : integer;
  _ret : TColorAdapt;
  _x : real;
begin
  dec(coef_delta,255);
  _x := coef_delta / 255;
  _x := (_x * _x) * 255 ;
  if indexTeinteBase = 1 then begin // Rouge
    if coef_delta < 0 then begin
      _R := round(_x) ;
      _G := 0;
      _B := round(_x) ;
    end else begin
      _R := round(_x) ;
      _G := round(_x) ;
      _B := 0;
    end;
  end else if indexTeinteBase = 2 then begin // Jaune
    if coef_delta < 0 then begin
      _R := round(_x) ;
      _G := round(-_x) ;
      _B := 0;
    end else begin
      _R := round(-_x) ;
      _G := round(_x) ;
      _B := 0;
    end;
  end else if indexTeinteBase = 3 then begin // Vert
    if coef_delta < 0 then begin  // Il faut rajouter du rouge
      _R := round(_x) ;
      _G := round(_x);
      _B := 0;
    end else begin // Il faut rajouter du bleu
      _R := 0;
      _G := round(_x) ;
      _B := round(_x) ;
    end;
  end else if indexTeinteBase = 4 then begin // Cyan
    if coef_delta < 0 then begin // Il faut enlever du bleu
      _R := 0;
      _G := round(_x) ;
      _B := round(-_x) ;
    end else begin // Il faut enlever du vert
      _R := 0;
      _G := round(-_x) ;
      _B := round(_x) ;
    end;
  end else if indexTeinteBase = 5 then begin // Bleu
    if coef_delta < 0 then begin // Il faut ajouter du vert
      _R := 0;
      _G := round(_x) ;
      _B := round(_x) ;
    end else begin // Il faut ajouter du rouge
      _R := round(_x) ;
      _G := 0;
      _B := round(_x) ;
    end;
  end else if indexTeinteBase = 6 then begin // Violet
    if coef_delta < 0 then begin // Il faut enlever du rouge
      _R := round(-_x) ;
      _G := 0;
      _B := round(_x) ;
    end else begin // Il faut enlever du bleu
      _R := round(_x) ;
      _G := 0;
      _B := round(-_x) ;
    end ;
  end else begin
    _R := 0;
    _G := 0;
    _B := 0;
  end;
  if _R < -255 then _R := -255 else if _R > 255 then _R := 255;
  if _G < -255 then _G := -255 else if _G > 255 then _G := 255;
  if _B < -255 then _B := -255 else if _B > 255 then _B := 255;
  with _ret do begin
    R := _R;
    G := _G;
    B := _B;
  end;
  TSL_DecalTeinte := _ret;
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

