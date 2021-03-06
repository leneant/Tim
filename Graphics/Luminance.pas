unit Luminance;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, ExtCtrls, Math, MemoryPix, ProgressWindows, Forms,
  constantes, Global, marqueurs, utils, TSL;


function GetLuminance(R,G,B : Byte) : integer;
procedure GetCourbeLumiereGAMMA (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma : real);
procedure GetCourbeLumiereanteGAMMA (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma : real);
procedure GetCourbeLumiereMixt (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma, poidsgamma : real);
procedure ApplyCourbeLumiereContrastG (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ;
  contrastG : integer; _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ; _progress : boolean);
Procedure CalcGammaCL (var CGamma : MyTCourbe; var gamma : real);
procedure CalcanteGammaCL (var CanteGamma : MyTCourbe; var gamma : real);
procedure CalcMixGammaanteGamma(var Mix : MyTCourbe; var gamma : real ; coef:real);
procedure ApplyGAMMA (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ; gamma : real ; t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ; _progress : boolean);
procedure ApplyanteGAMMA (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ; gamma : real ; t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ; _progress : boolean);
procedure ApplyMix (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ; gamma, poidsgamma : real ; t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ; _progress : boolean);
procedure createLumScaleCoef(a, b : integer);
function applyLumScaleCoef (x : integer) : integer;
function applyLumScaleCoef (x : float) : float;
function Lum_g_x (x : real; a,b,c : integer) : real;

var
  Lumiere, lumGamma, lumAnteGamma, lumGanteG, GammaAnteGamma, cGamma : MyTCourbe;
  _isImg : boolean;
  lumScale_a, lumScale_b : real; // echelle de luminance [lumScale_]a.x + [lumScale_]b
  c63, c127, c190 : integer; // Coef d'amplification des tons clairs, moyens et sombres


implementation

function Lum_g_x (x : real ; a,b,c : integer) : real;
var y : real;
  ka,kb,kc : real;
  mds,mdm,mdc : real;
  Lum_ka, Lum_kb, Lum_kc : real;
begin
  Lum_ka :=  _CTonsSombres +1;
  Lum_kb := _CTonsMoyens - _CTonsSombres +1;
  Lum_kc := 255 - _CTonsMoyens +1;
  mds := (_CTonsSombres / 2);
  mdm := (_CTonsMoyens - _CTonsSombres) / 2 + _CTonsSombres;
  mdc := (255 - _CTonsMoyens) / 2 + _CTonsMoyens;
  ka := (1 + power((x-mds)/Lum_ka,2)) * 250;
  kb := (1 + power((x-mdm)/Lum_kb,2)) * 250;
  kc := (1 + power((x-mdc)/Lum_kc,2)) * 250;
  y := x * (1 + (a / ka) + (b / kb) + (c / kc));
  Lum_g_x := y;
end;

function GetLuminance (R,G,B : Byte) : integer;
begin
  GetLuminance := round(R*_C_LR + G*_C_LV + B*_C_LB);
end;


procedure ApplyCourbeLumiereContrastG (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ;
  contrastG : integer; _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ; _progress : boolean);
var
  i,j, width, height : LongInt;
  R,G,B : Byte;
  ca, R1,G1,B1 : real;
  _teinte, _luminance : integer;
begin
  // Calcul des coef de la droite de contraste
  ca := (contrastG + 101) / 100 ;
  // Application du contraste
  SourceIMG.getImageSize(width,height);
  bouchee := false;
  cramee := false;
  for i := 0 to width -1 do begin
    for j := 0 to height - 1 do
      begin
        SourceIMG.getPixel(i,j,R,G,B);
        // Determination de la teinte
        _teinte := TSL_getTeinteIndex(R,G,B);
        // Calcul de la couleur résultante
        _luminance := GetLuminance (R,G,B);
        // La teinte est-elle dans le domaine de calcul
        if ((t_rouge   and (_teinte = 1)) or
            (t_jaune   and (_teinte = 2)) or
            (t_vert    and (_teinte = 3)) or
            (t_cyan    and (_teinte = 4)) or
            (t_bleu    and (_teinte = 5)) or
            (t_magenta and (_teinte = 6)) or
            (t_mono    and (_teinte = 7))) and
           ((((_luminance < _CTonsSombres) and _ATonsSombres)) or
            (((_luminance < _CTonsMoyens) and _ATonsMoyens and (_luminance >= _CTonsSombres))) or
            (((_luminance >= _CTonsMoyens) and _ATonsClairs))) then begin
          //lum := (R+G+B)/3;
          R1 := (R-127) * ca + 127 ; //* coef_sc;
          G1 := (G-127) * ca + 127; //* coef_sc;
          B1 := (B-127) * ca + 127; //* coef_sc;
            if R1 > 255 then begin
              R1 := 255 ;
              cramee := true;
            end else if R1 < 0 then begin
              R1 := 0;
              bouchee := true;
            end;
            if G1 > 255 then begin
              G1 := 255;
              cramee := true;
            end else if G1 < 0 then begin
              G1 := 0;
              bouchee := true;
            end;
            if B1 > 255 then begin
              B1 := 255 ;
              cramee := true;
            end else if B1 < 0 then begin
              B1 := 0;
              bouchee := true;
            end;
          if contrastG = 0 then begin
                cramee := false;
                bouchee := false;
          end;
          R := round (R1);
          G := round (G1);
          B := round (B1);
        end;
        DestIMG.setPixel(i,j,R,G,B);
      end;
    if (i mod c_refresh = 0) and _progress then ProgressWindow.SetProgressInc(i/(width-1)*_Prog_Calc);
  end;
  // Copie image de destination
  DestIMG.copyImageIntoTImage(ImageDest, _progress);
  ImageDest.Refresh;
  Application.ProcessMessages;
end;

procedure GetCourbeLumiereGAMMA (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma : real);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum : integer;
  a, invgamma, depart : float;
  mx_lum : integer;
  inter : MyTCourbe;
  coef_sc : real;
begin
    mx_lum := 0;
    invgamma := 1.0/gamma;
    a := 255/power(255.0,invgamma);
    for i := 0 to 255 do
      inter[i] := 0;
    Image.getImageSize(width,height);
    for i := 0 to width -1 do begin
      for j := 0 to height - 1 do
        begin
          Image.getPixel(i,j,R,G,B,L);
          lum := round((R*0.2126 + G*0.7152 + B*0.0722)* L / 255.0);
          if gamma <> 1 then
            lum := round(a * power(lum, invgamma));
          coef_sc := applyLumScaleCoef(lum);
          if coef_sc > 255 then coef_sc := 255 else if coef_sc < 0 then coef_sc := 0;
          inc(inter[round(coef_sc)],1);
        end;
      if i mod c_refresh = 0 then ProgressWindow.SetProgressInc(i/(width-1)*100);
    end;
    // limage de la courbe sur 5 mesures
    for i:= 0 to 255 do begin
      depart := (i*250/255);
      Courbe[i] := Approx(inter, i, round(depart), round(depart+5));
      if Courbe[i] > mx_lum then mx_lum := Courbe[i];
    end;
    // normalisation des valeurs sur une échelle de 255
    if mx_lum = 0 then mx_lum := 1;
    for i:= 0 to 255 do begin
      Courbe[i] := round(Courbe[i]*255.0/mx_lum);
    end;
end;

procedure GetCourbeLumiereanteGAMMA (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma : real);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum : integer;
  a, invgamma, depart : float;
  mx_lum : integer;
  inter : MyTCourbe;
  coef_sc : real;
begin
    mx_lum := 0;
    invgamma := 1.0/gamma;
    a := 255/power(255.0,invgamma);
    for i := 0 to 255 do
      inter[i] := 0;
    Image.getImageSize(width,height);
    for i := 0 to width -1 do begin
      for j := 0 to height - 1 do
        begin
          Image.getPixel(i,j,R,G,B,L);
          lum := round((R*0.2126 + G*0.7152 + B*0.0722)* L / 255.0);
          if gamma <> 1 then
            lum := round(255 + a * -power(255-lum, invgamma));
          coef_sc := applyLumScaleCoef(lum);
          if coef_sc > 255 then coef_sc := 255 else if coef_sc < 0 then coef_sc := 0;
          inc(inter[round(coef_sc)],1);
        end;
      if i mod c_refresh = 0 then ProgressWindow.SetProgressInc(i/(width-1)*100);
    end;
    // limage de la courbe sur 5 mesures
    for i:= 0 to 255 do begin
      depart := (i*250/255);
      Courbe[i] := Approx(inter, i, round(depart), round(depart+5));
      if Courbe[i] > mx_lum then mx_lum := Courbe[i];
    end;
    if mx_lum = 0 then mx_lum := 1;
    // normalisation des valeurs sur une échelle de 255
    for i:= 0 to 255 do
      Courbe[i] := round(Courbe[i]*255.0/mx_lum);
end;

procedure GetCourbeLumiereMixt (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma, poidsgamma : real);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum : integer;
  a, invgamma, depart, bc, cc : float;
  mx_lum : integer;
  inter : MyTCourbe;
  coef_sc : real;
begin
    mx_lum := 0;
    cc := poidsgamma;
    bc := 1 - cc;
    invgamma := 1.0/gamma;
    a := 255/power(255.0,invgamma);
    for i := 0 to 255 do
      inter[i] := 0;
    Image.getImageSize(width,height);
    for i := 0 to width -1 do begin
      for j := 0 to height - 1 do
        begin
          Image.getPixel(i,j,R,G,B,L);
          lum := round((R*0.2126 + G*0.7152 + B*0.0722)* L / 255.0);
          if gamma <> 1 then
            lum := round(((255 + a * -power(255-lum, invgamma))*cc) + ((a * power(lum, invgamma))*bc));
          coef_sc := applyLumScaleCoef(lum);
          if coef_sc > 255 then coef_sc := 255 else if coef_sc < 0 then coef_sc := 0;
          inc(inter[round(coef_sc)],1);
        end;
      if i mod c_refresh = 0 then ProgressWindow.SetProgressInc(i/(width-1)*100);
    end;
    // limage de la courbe sur 5 mesures
    for i:= 0 to 255 do begin
      depart := (i*250/255);
      Courbe[i] := Approx(inter, i, round(depart), round(depart+5));
      if Courbe[i] > mx_lum then mx_lum := Courbe[i];
    end;
    if mx_lum = 0 then mx_lum := 1;
    // normalisation des valeurs sur une échelle de 255
    for i:= 0 to 255 do
      Courbe[i] := round(Courbe[i]*255.0/mx_lum);
end;


Procedure CalcGammaCL (var CGamma : MyTCourbe; var gamma : real);
var a, invgamma : float;
  i : integer;
  y : float;
begin
    invgamma := 1.0/gamma;
    a := 255/power(255.0,invgamma);
    for i := 0 to 255 do begin
      y := applyLumScaleCoef(round(a*power(i,invgamma)));
      if y < 0 then y := 0 else if y > 255 then y := 255;
      CGamma[i] := round(y);
    end;
end;

procedure CalcanteGammaCL (var CanteGamma : MyTCourbe; var gamma : real);
var a, invgamma : float;
  i : integer;
  y : float;
begin
    invgamma := 1.0/gamma;
    a := 255/power(255.0,invgamma);
    for i:= 0 to 255 do begin
      y := applyLumScaleCoef(round(255 + a * -power(255-i, invgamma)));
      if y < 0 then y := 0 else if y > 255 then y := 255;
      CanteGamma[i] := round(y);
    end;
end;


procedure CalcMixGammaanteGamma(var Mix : MyTCourbe ; var gamma : real ; coef:real);
var i : integer;
  pa, pb : real;
  invgamma, a : float;
  y : float;
begin
    invgamma := 1.0/gamma;
    a := 255/power(255.0,invgamma);
    pa := coef;
    pb:= 1-coef;
    for i:=0 to 255 do begin
      y := applyLumScaleCoef(round(a*power(i,invgamma)*pb+(255 + a * -power(255-i, invgamma))*pa));
      if y < 0 then y := 0 else if y > 255 then y := 255;
      Mix[i] := round(y);
    end;
end;

procedure ApplyGAMMA (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ;
  gamma : real ; t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ; _progress : boolean);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum, coef_l, R1, G1, B1 : float;
  a, invgamma : float;
  _teinte : integer;
begin
  invgamma := 1.0/gamma;
  a := 255/power(255.0,invgamma);
  SourceIMG.getImageSize(width,height);
  L := 255;
  bouchee := false;
  cramee := false;
  for i := 0 to width -1 do begin
    for j := 0 to height - 1 do
      begin
        SourceIMG.getPixel(i,j,R,G,B);
        // La teinte est-elle dans le domaine de calcul
        _teinte := TSL_getTeinteIndex(R,G,B);
        if (t_rouge   and (_teinte = 1)) or
           (t_jaune   and (_teinte = 2)) or
           (t_vert    and (_teinte = 3)) or
           (t_cyan    and (_teinte = 4)) or
           (t_bleu    and (_teinte = 5)) or
           (t_magenta and (_teinte = 6)) or
           (t_mono and (_teinte = 7)) then begin

          lum := (R + G + B) / 3 * L / 255.0;
          if gamma <> 1 then
            coef_l := a * power(lum, invgamma) else coef_l := lum;
          coef_l := applyLumScaleCoef(coef_l);
          if lum <> 0 then lum := coef_l / lum else lum := 1;
          //coef_sc := Lum_g_x(lum, c63, c127, c190);
          R1 := R * lum ; //* coef_sc;
          G1 := G * lum ; //* coef_sc;
          B1 := B * lum ; //* coef_sc;
          if R1 > 255 then begin
            R1 := 255 ;
            cramee := true;
          end else if R1 < 0 then begin
            R1 := 0;
            bouchee := true;
          end;
          if G1 > 255 then begin
            G1 := 255;
            cramee := true;
          end else if G1 < 0 then begin
            G1 := 0;
            bouchee := true;
          end;
          if B1 > 255 then begin
            B1 := 255 ;
            cramee := true;
          end else if B1 < 0 then begin
            B1 := 0;
            bouchee := true;
          end;
          R := round (R1);
          G := round (G1);
          B := round (B1);

        end;
        DestIMG.setPixel(i,j,R,G,B,L);
      end;
    if (i mod c_refresh = 0) and _progress then ProgressWindow.SetProgressInc(i/(width-1)*_Prog_Calc);
  end;
  // Copie image de destination
  DestIMG.copyImageIntoTImage(ImageDest, _progress);
  ImageDest.Refresh;
  Application.ProcessMessages;
end;


procedure ApplyanteGAMMA (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ;
  gamma : real ; t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ; _progress : boolean);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum, coef_l, R1, G1, B1 : float;
  a, invgamma : float;
  _teinte : integer;
  //coef_sc : real;
begin
  invgamma := 1.0/gamma;
  a := 255/power(255.0,invgamma);
  SourceIMG.getImageSize(width,height);
  L := 255;
  cramee := false;
  bouchee := false;
  for i := 0 to width -1 do begin
    for j := 0 to height - 1 do
      begin
        SourceIMG.getPixel(i,j,R,G,B);
        // La teinte est-elle dans le domaine de calcul
        _teinte := TSL_getTeinteIndex(R,G,B);
        if (t_rouge   and (_teinte = 1)) or
           (t_jaune   and (_teinte = 2)) or
           (t_vert    and (_teinte = 3)) or
           (t_cyan    and (_teinte = 4)) or
           (t_bleu    and (_teinte = 5)) or
           (t_magenta and (_teinte = 6)) or
           (t_mono    and (_teinte = 7)) then begin
          lum := (R + G + B) / 3 * L / 255.0;
          coef_l := lum;
          if gamma <> 1 then
            coef_l := 255 + a * -power(255-lum, invgamma) else coef_l := lum;
          coef_l := applyLumScaleCoef(coef_l);
          if lum <> 0 then lum := coef_l / lum else lum := 1;
          R1 := R * lum ; //* coef_sc;
          G1 := G * lum ; //* coef_sc;
          B1 := B * lum ; //* coef_sc;
          if R1 > 255 then begin
            R1 := 255 ;
            cramee := true;
          end else if R1 < 0 then begin
            R1 := 0;
            bouchee := true;
          end;
          if G1 > 255 then begin
            G1 := 255;
            cramee := true;
          end else if G1 < 0 then begin
            G1 := 0;
            bouchee := true;
          end;
          if B1 > 255 then begin
            B1 := 255 ;
            cramee := true;
          end else if B1 < 0 then begin
            B1 := 0;
            bouchee := true;
          end;
          R := round (R1);
          G := round (G1);
          B := round (B1);
        end;
        DestIMG.setPixel(i,j,R,G,B,L);
      end;
    if (i mod c_refresh = 0) and _progress then ProgressWindow.SetProgressInc(i/(width-1)*_Prog_Calc);
  end;
  // Copie image de destination
  DestIMG.copyImageIntoTImage(ImageDest, _progress);
  ImageDest.Refresh;
  Application.ProcessMessages;
end;

procedure ApplyMix (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ;
  gamma, poidsgamma : real ; t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ; _progress : boolean);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum, coef_l, R1, G1, B1 : float;
  a, invgamma, cc, bc : float;
  _teinte : integer;
begin
  cc := poidsgamma;
  bc := 1 - cc;
  invgamma := 1.0/gamma;
  a := 255/power(255.0,invgamma);
  SourceIMG.getImageSize(width,height);
  L := 255;
  cramee := false;
  bouchee := false;
  for i := 0 to width -1 do begin
    for j := 0 to height - 1 do
      begin
        SourceIMG.getPixel(i,j,R,G,B);
        // La teinte est-elle dans le domaine de calcul
        _teinte := TSL_getTeinteIndex(R,G,B);
        if (t_rouge   and (_teinte = 1)) or
           (t_jaune   and (_teinte = 2)) or
           (t_vert    and (_teinte = 3)) or
           (t_cyan    and (_teinte = 4)) or
           (t_bleu    and (_teinte = 5)) or
           (t_magenta and (_teinte = 6)) or
           (t_mono    and (_teinte = 7)) then begin
          lum := (R + G + B) / 3 * L / 255.0;
          coef_l := lum;
          if gamma <> 1 then
            coef_l := ((255 + a * -power(255-lum, invgamma))*cc) + ((a * power(lum, invgamma))*bc)
            else coef_l := lum;
          coef_l := applyLumScaleCoef(coef_l);
          if lum <> 0 then lum := coef_l / lum else lum := 1;
          R1 := R * lum ; //* coef_sc;
          G1 := G * lum ; //* coef_sc;
          B1 := B * lum ; //* coef_sc;
          if R1 > 255 then begin
            R1 := 255 ;
            cramee := true;
          end else if R1 < 0 then begin
            R1 := 0;
            bouchee := true;
          end;
          if G1 > 255 then begin
            G1 := 255;
            cramee := true;
          end else if G1 < 0 then begin
            G1 := 0;
            bouchee := true;
          end;
          if B1 > 255 then begin
            B1 := 255 ;
            cramee := true;
          end else if B1 < 0 then begin
            B1 := 0;
            bouchee := true;
          end;
          R := round (R1);
          G := round (G1);
          B := round (B1);
        end;
        DestIMG.setPixel(i,j,R,G,B,L);
      end;
    if (i mod c_refresh = 0) and _progress then ProgressWindow.SetProgressInc(i/(width-1)*_Prog_Calc);
  end;
  // Copie image de destination
  DestIMG.copyImageIntoTImage(ImageDest, _progress);
  ImageDest.Refresh;
  Application.ProcessMessages;
end;

procedure createLumScaleCoef(a, b : integer);
begin
  lumScale_b := a ;
  lumScale_a := (b-a)/255;
end;

function applyLumScaleCoef (x : integer) : integer;
var
  y : real;
begin
  y := Lum_g_x(lumScale_a * x + lumScale_b, c63,c127,c190);
  applyLumScaleCoef := round(y);
end;

function applyLumScaleCoef (x : float) : float;
var
  y : float;
begin
  y := Lum_g_x(lumScale_a * x + lumScale_b, c63,c127,c190);
  applyLumScaleCoef := y;
end;

begin
  _isImg := false;
  c63 := 0;
  c127 := 0;
  c190 := 0;
end.

