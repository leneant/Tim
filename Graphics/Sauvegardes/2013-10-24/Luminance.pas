unit Luminance;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, ExtCtrls, Math, MemoryPix, ProgressWindows;

type
  MyTCourbe = Array[0..256] of longint;

//function GetPixelColor(x,y : integer; var Image : TImage) : TColor;
procedure GetCourbeLumiereGAMMA (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma : real);
procedure GetCourbeLumiereanteGAMMA (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma : real);
procedure GetCourbeLumiereMixt (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma, poidsgamma : real);
Procedure CalcGammaCL (var CGamma : MyTCourbe; var gamma : real);
procedure CalcanteGammaCL (var CanteGamma : MyTCourbe; var gamma : real);
procedure CalcMixGammaanteGamma(var Mix : MyTCourbe; var gamma : real ; coef:real);
//procedure Approx(var LuminanceCourbe : MyTCourbe);
procedure ApplyGAMMA (var SourceIMG : TMemoryPix ; var ImageDest : TImage ; gamma : real);
procedure ApplyanteGAMMA (var SourceIMG : TMemoryPix ; var ImageDest : TImage ; gamma : real);
procedure ApplyMix (var SourceIMG : TMemoryPix ; var ImageDest : TImage ; gamma, poidsgamma : real);
function _nameFromPath(path : string) : string;
procedure createLumScaleCoef(a, b : integer);
function applyLumScaleCoef (x : integer) : integer;
function applyLumScaleCoef (x : float) : float;

var
  Lumiere, lumGamma, lumAnteGamma, lumGanteG, GammaAnteGamma, cGamma : MyTCourbe;
  //mx_lum : integer;
  //Image : TImage;
  Image, Img : TMemoryPix;
  lumScale_a, lumScale_b : real; // echelle de luminance [lumScale_]a.x + [lumScale_]b


implementation


function Approx(courbeIn : MyTCourbe; x, a, b : integer) : integer;
var
  i, j : integer;
  r, d ,diviseur : real;
begin
    j := round(x * a / b);
    r := 0;
    d := 0;
    for i:=j to j + b - a do begin
      diviseur := 0.2 * abs(i-x)+1;
      r := r + (courbeIn[i] / diviseur);
      d := d + (1 / diviseur);
    end;
    Approx := round (r/d);
end;

procedure GetCourbeLumiereGAMMA (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma : real);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum : integer;
  color : integer;
  a, invgamma, depart : float;
  mx_lum : integer;
  inter : MyTCourbe;
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
          lum := applyLumScaleCoef(lum);
          //if color > 255 then color := 255 else
          //if color < 0 then color := 0 ;
          inc(inter[lum],1);
          //if inter[lum] > mx_lum then mx_lum := inter[lum];
        end;
      ProgressWindow.SetProgressInc(i/(width-1)*100);
    end;
    // limage de la courbe sur 5 mesures
    for i:= 0 to 255 do begin
      depart := (i*250/255);
      Courbe[i] := Approx(inter, i, round(depart), round(depart+5));
      if Courbe[i] > mx_lum then mx_lum := Courbe[i];
    end;
    // normalisation des valeurs sur une échelle de 255
    for i:= 0 to 255 do
      Courbe[i] := round(Courbe[i]*255.0/mx_lum);
end;

procedure GetCourbeLumiereanteGAMMA (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma : real);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum : integer;
  color : integer;
  a, invgamma, depart : float;
  mx_lum : integer;
  inter : MyTCourbe;
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
          //color := integer(GetPixelColor(i,j, Image));
          //R := Red(color);
          //G := Green(color);
          //B := Blue(color);
          //L = 0.2126.R + 0.7152.V + 0.0722.B
          //lum := round(R*0.2126 + G*0.7152 + B*0.0722)
          lum := round((R*0.2126 + G*0.7152 + B*0.0722)* L / 255.0);
          if gamma <> 1 then
            lum := round(255 + a * -power(255-lum, invgamma));
          lum := applyLumScaleCoef(lum);
          //if color > 255 then color := 255 else
          //if color < 0 then color := 0 ;
          inc(inter[lum],1);
          //if inter[lum] > mx_lum then mx_lum := inter[lum];
        end;
      ProgressWindow.SetProgressInc(i/(width-1)*100);
    end;
    // limage de la courbe sur 5 mesures
    for i:= 0 to 255 do begin
      depart := (i*250/255);
      Courbe[i] := Approx(inter, i, round(depart), round(depart+5));
      if Courbe[i] > mx_lum then mx_lum := Courbe[i];
    end;
    // normalisation des valeurs sur une échelle de 255
    for i:= 0 to 255 do
      Courbe[i] := round(Courbe[i]*255.0/mx_lum);
end;

procedure GetCourbeLumiereMixt (var Image : TMemoryPix; var Courbe : MyTCourbe; gamma, poidsgamma : real);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum : integer;
  color : integer;
  a, invgamma, depart, bc, cc : float;
  mx_lum : integer;
  inter : MyTCourbe;
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
          //color := integer(GetPixelColor(i,j, Image));
          //R := Red(color);
          //G := Green(color);
          //B := Blue(color);
          //L = 0.2126.R + 0.7152.V + 0.0722.B
          //lum := round(R*0.2126 + G*0.7152 + B*0.0722)
          lum := round((R*0.2126 + G*0.7152 + B*0.0722)* L / 255.0);
          if gamma <> 1 then
            lum := round(((255 + a * -power(255-lum, invgamma))*cc) + ((a * power(lum, invgamma))*bc));
          lum := applyLumScaleCoef(lum);
          //if color > 255 then color := 255 else
          //if color < 0 then color := 0 ;
          inc(inter[lum],1);
          //if inter[lum] > mx_lum then mx_lum := inter[lum];
        end;
      ProgressWindow.SetProgressInc(i/(width-1)*100);
    end;
    // limage de la courbe sur 5 mesures
    for i:= 0 to 255 do begin
      depart := (i*250/255);
      Courbe[i] := Approx(inter, i, round(depart), round(depart+5));
      if Courbe[i] > mx_lum then mx_lum := Courbe[i];
    end;
    // normalisation des valeurs sur une échelle de 255
    for i:= 0 to 255 do
      Courbe[i] := round(Courbe[i]*255.0/mx_lum);
end;


Procedure CalcGammaCL (var CGamma : MyTCourbe; var gamma : real);
var a, invgamma : float;
  i : integer;
begin
    invgamma := 1.0/gamma;
    a := 255/power(255.0,invgamma);
    for i := 0 to 255 do
      //CGamma[i] := round(a*power(i,invgamma));
      CGamma[i] := applyLumScaleCoef(round(a*power(i,invgamma)));
end;

procedure CalcanteGammaCL (var CanteGamma : MyTCourbe; var gamma : real);
var a, invgamma : float;
  i : integer;
begin
    invgamma := 1.0/gamma;
    a := 255/power(255.0,invgamma);
    for i:= 0 to 255 do
      //CanteGamma[i] := round(255 + a * -power(255-i, invgamma));
      CanteGamma[i] := applyLumScaleCoef(round(255 + a * -power(255-i, invgamma)));
end;


procedure CalcMixGammaanteGamma(var Mix : MyTCourbe ; var gamma : real ; coef:real);
var i : integer;
  pa, pb : real;
  invgamma, a : float;
begin
    invgamma := 1.0/gamma;
    a := 255/power(255.0,invgamma);
    pa := coef;
    pb:= 1-coef;
    for i:=0 to 255 do begin
      Mix[i] := applyLumScaleCoef(round(a*power(i,invgamma)*pb+(255 + a * -power(255-i, invgamma))*pa));
    end;
end;

procedure ApplyGAMMA (var SourceIMG : TMemoryPix ; var ImageDest : TImage ; gamma : real);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum, coef_l, R1, G1, B1 : float;
  a, invgamma : float;
  //Img : TMemoryPix;
begin
  invgamma := 1.0/gamma;
  a := 255/power(255.0,invgamma);
  SourceIMG.getImageSize(width,height);
  Img.Destroy;
  Img := TMemoryPix.Create(width,height,true);
  L := 255;
  for i := 0 to width -1 do begin
    for j := 0 to height - 1 do
      begin
        SourceIMG.getPixel(i,j,R,G,B);
        //color := integer(GetPixelColor(i,j, Image));
        //R := Red(color);
        //G := Green(color);
        //B := Blue(color);
        //L = 0.2126.R + 0.7152.V + 0.0722.B
        //lum := round(R*0.2126 + G*0.7152 + B*0.0722)
        lum := (R + G + B) / 3 * L / 255.0;
        if gamma <> 1 then
          coef_l := a * power(lum, invgamma) else coef_l := lum;
        coef_l := applyLumScaleCoef(coef_l);
        //if color > 255 then color := 255 else
        //if color < 0 then color := 0 ;
        if lum <> 0 then lum := coef_l / lum else lum := 1;
        R1 := R * lum;
        G1 := G * lum;
        B1 := B * lum;
        if R1 > 255 then R1 := 255;
        if G1 > 255 then G1 := 255;
        if B1 > 255 then B1 := 255;
        R := round (R1);
        G := round (G1);
        B := round (B1);
        Img.setPixel(i,j,R,G,B,L);
      end;
    ProgressWindow.SetProgressInc(i/(width-1)*100);
  end;
  // Copie image de destination
  ImageDest.Picture.Clear;
  Img.copyImageIntoTImage(ImageDest);
  //Img.Destroy;
end;


procedure ApplyanteGAMMA (var SourceIMG : TMemoryPix ; var ImageDest : TImage ; gamma : real);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum, coef_l, R1, G1, B1 : float;
  a, invgamma : float;
  //Img : TMemoryPix;
begin
  invgamma := 1.0/gamma;
  a := 255/power(255.0,invgamma);
  SourceIMG.getImageSize(width,height);
  Img.Destroy;
  Img := TMemoryPix.Create(width,height,true);
  L := 255;
  for i := 0 to width -1 do begin
    for j := 0 to height - 1 do
      begin
        SourceIMG.getPixel(i,j,R,G,B);
        //color := integer(GetPixelColor(i,j, Image));
        //R := Red(color);
        //G := Green(color);
        //B := Blue(color);
        //L = 0.2126.R + 0.7152.V + 0.0722.B
        //lum := round(R*0.2126 + G*0.7152 + B*0.0722)
        lum := (R + G + B) / 3 * L / 255.0;
        coef_l := lum;
        if gamma <> 1 then
          coef_l := 255 + a * -power(255-lum, invgamma) else coef_l := lum;
        coef_l := applyLumScaleCoef(coef_l);
        //if color > 255 then color := 255 else
        //if color < 0 then color := 0 ;
        if lum <> 0 then lum := coef_l / lum else lum := 1;
        R1 := R * lum;
        G1 := G * lum;
        B1 := B * lum;
        if R1 > 255 then R1 := 255;
        if G1 > 255 then G1 := 255;
        if B1 > 255 then B1 := 255;
        R := round (R1);
        G := round (G1);
        B := round (B1);
        Img.setPixel(i,j,R,G,B,L);
      end;
    ProgressWindow.SetProgressInc(i/(width-1)*100);
  end;
  // Copie image de destination
  ImageDest.Picture.Clear;
  Img.copyImageIntoTImage(ImageDest);
  //Img.Destroy;
end;

procedure ApplyMix (var SourceIMG : TMemoryPix ; var ImageDest : TImage ; gamma, poidsgamma : real);
var
  i,j, width, height : LongInt;
  R, G, B, L : Byte;
  lum, coef_l, R1, G1, B1 : float;
  a, invgamma, cc, bc : float;
  //Img : TMemoryPix;
begin
  cc := poidsgamma;
  bc := 1 - cc;
  invgamma := 1.0/gamma;
  a := 255/power(255.0,invgamma);
  SourceIMG.getImageSize(width,height);
  Img.Destroy;
  Img := TMemoryPix.Create(width,height,true);
  L := 255;
  for i := 0 to width -1 do begin
    for j := 0 to height - 1 do
      begin
        SourceIMG.getPixel(i,j,R,G,B);
        //color := integer(GetPixelColor(i,j, Image));
        //R := Red(color);
        //G := Green(color);
        //B := Blue(color);
        //L = 0.2126.R + 0.7152.V + 0.0722.B
        //lum := round(R*0.2126 + G*0.7152 + B*0.0722)
        lum := (R + G + B) / 3 * L / 255.0;
        coef_l := lum;
        if gamma <> 1 then
          coef_l := ((255 + a * -power(255-lum, invgamma))*cc) + ((a * power(lum, invgamma))*bc)
          else coef_l := lum;
        coef_l := applyLumScaleCoef(coef_l);
        //if color > 255 then color := 255 else
        //if color < 0 then color := 0 ;
        if lum <> 0 then lum := coef_l / lum else lum := 1;
        R1 := R * lum;
        G1 := G * lum;
        B1 := B * lum;
        if R1 > 255 then R1 := 255;
        if G1 > 255 then G1 := 255;
        if B1 > 255 then B1 := 255;
        R := round (R1);
        G := round (G1);
        B := round (B1);
        Img.setPixel(i,j,R,G,B,L);
      end;
    ProgressWindow.SetProgressInc(i/(width-1)*100);
  end;
  // Copie image de destination
  ImageDest.Picture.Clear;
  Img.copyImageIntoTImage(ImageDest);
  //Img.Destroy;
end;

function _nameFromPath(path : string) : string;
var i, position, taille : integer;
begin
  position := 0;
  taille := Length(path);
  for i:= taille - 1 downto 0 do
    begin
      if path[i] = '\' then begin
        position := i+1;
        break;
      end;
    end;
  _nameFromPath := copy(path, position, taille - position + 1);
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
  y := lumScale_a * x + lumScale_b;
  if y < 0.0 then y := 0.0 else if y > 255.0 then y := 255.0 ;
  applyLumScaleCoef := round(y);
end;

function applyLumScaleCoef (x : float) : float;
var
  y : float;
begin
  y := lumScale_a * x + lumScale_b;
  if y < 0.0 then y := 0.0 else if y > 255.0 then y := 255.0 ;
  applyLumScaleCoef := y;
end;

end.

