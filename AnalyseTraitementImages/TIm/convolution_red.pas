unit Convolution_Red;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MemoryPix, ProgressWindows, Constantes, marqueurs, forms;

Type
  TConvMatriceRed = array [-2..2,-2..2] of integer;

  TConvMatriceCoordRed = record
    x, y : integer;
  end;

  TMatConvRed = class(TObject)
    Valeurs : TConvMatriceRed;
    private
    public
      procedure initValeurs(ValuesToSet : TConvMatriceRed);
      procedure getCoef(i : integer; var coef,_x,_y : integer);
      procedure apply(var src, dst : TMemoryPix; _color, _progress : boolean; _prgcoef :integer);
      procedure pixelApply(var src : TMemoryPix; var R,G,B : Byte; var _R,_G,_B : real ; x,y : integer; _color : boolean);
  end;


implementation

type
  TConvMatriceTranscoRed = array[1..25] of TConvMatriceCoordRed;

var
  MC_ConvertRed : TConvMatriceTranscoRed;
  c,i,j : integer;

procedure TMatConvRed.pixelApply(var src : TMemoryPix; var R,G,B : Byte; var _R,_G,_B : real ; x,y : integer; _color : boolean);
var
  _width, _height, x1, y1, x2, y2 : integer;
  P1, CF : integer;
  k : integer;
  P, _luminance, _luminanceN, Rold, Gold, Bold, moy, d1, d2, d3 : real;
  _calc : boolean;
begin
  // Init recup taille image source et init taille image dest
  src.getImageSize(_width,_height);
  _R := 0;
  _G := 0;
  _B := 0;
  CF := 0;
  _luminanceN := 0;
  src.getPixel(x,y,R,G,B);
  // Conservation du pixel initial pour les calculs sur la luminance
  Rold := R;
  Gold := G;
  Bold := B;
  // Détermination de la luminance et s'il faut ou non faire les calculs
  _luminance := round(R*0.2126 + G*0.7152 + B*0.0722);
  _calc := ((_luminance < _CTonsSombres) and _ATonsSombres) or
           ((_luminance < _CTonsMoyens) and _ATonsMoyens) or
           ((_luminance >= _CTonsMoyens) and _ATonsClairs) ;
  if _calc then begin
    _luminance := (R+G+B)/3;
    _luminanceN := 0;
    for k := 1 to 25 do begin
      getCoef(k, P1, x1, y1);
      x2 := x + x1;
      y2 := y + y1;
      if (x2 >= 0) and (x2 < _width) and (y2 >= 0) and (y2 < _height) then begin
        CF := CF + P1;
        src.getPixel(x2,y2,R,G,B);
        if _color then begin
          _R := _R + R * P1;
          _G := _G + G * P1;
          _B := _B + B * P1;
        end else begin
          // Calcul de la nouvelle luminance
          _luminanceN := _luminanceN + (((R + G + B)/3) * P1);
        end;
      end;
    end;
    if CF = 0 then CF := 1;
    if _color then begin
      _R := _R / CF;
      _G := _G / CF;
      _B := _B / CF;
    end else begin
      // Détermination de la nouvelle luminance
      _luminanceN := _luminanceN / CF;
      // Calcul du coefficient a appliquer pour obtenir luminance cible
      P := _luminanceN - _luminance;
      // Calcul du nouveau pixel
      moy := (Rold + Gold + Bold) / 3;
      d1 := Rold - moy ;
      d2 := Gold - moy ;
      d3 := Bold - moy ;
      moy := moy + P ;
      _R := moy + d1;
      _G := moy + d2;
      _B := moy + d3;
    end;
  end else begin
    _R := R;
    _G := G;
    _B := B;
  end;
end;

procedure TMatConvRed.apply(var src, dst : TMemoryPix; _color, _progress : boolean; _prgcoef :integer);
var
  _width, _height, x, y, x1, y1, x2, y2 : integer;
  R,G,B, Rold, Gold, Bold : Byte;
  _R,_G,_B : real;
  P1, CF : integer;
  k : integer;
  P, _luminance, _luminanceN, moy, d1, d2, d3 : real;
  _calc : boolean;
begin
  // Init recup taille image source et init taille image dest
  src.getImageSize(_width,_height);
  dst.Init(_width,_height,false);
  for x := 0 to _width - 1 do begin
    for y := 0 to _height - 1 do begin
      _R := 0;
      _G := 0;
      _B := 0;
      CF := 0;
      _luminanceN := 0;
      src.getPixel(x,y,R,G,B);
      // Sauvegarde du pixel d'origine pour les calculs sur la luminance
      Rold := R;
      Gold := G;
      Bold := B;
      // Détermination de la luminance et s'il faut ou non faire les calculs
      _luminance := round(R*0.2126 + G*0.7152 + B*0.0722);
      _calc := ((_luminance < _CTonsSombres) and _ATonsSombres) or
               ((_luminance < _CTonsMoyens) and _ATonsMoyens) or
               ((_luminance >= _CTonsMoyens) and _ATonsClairs) ;
      if _calc then begin
        _luminanceN := 0;
        for k := 1 to 25 do begin
          getCoef(k, P1, x1, y1);
          x2 := x + x1;
          y2 := y + y1;
          if (x2 >= 0) and (x2 < _width) and (y2 >= 0) and (y2 < _height) then begin
            CF := CF + P1;
            src.getPixel(x2,y2,R,G,B);
            if _color then begin
              _R := _R + R * P1;
              _G := _G + G * P1;
              _B := _B + B * P1;
            end else begin
              // Calcul de la nouvelle luminance
              _luminanceN := _luminanceN + (((R + G + B)/3) * P1);
            end;
          end;
        end;
        if CF = 0 then CF := 1;
        if _color then begin
          _R := _R / CF;
          _G := _G / CF;
          _B := _B / CF;
        end else begin
          // Détermination de la nouvelle luminance
          _luminanceN := _luminanceN / CF;
          // Calcul du coefficient a appliquer pour obtenir luminance cible
          P := _luminanceN - _luminance;
          // Calcul du nouveau pixel
          moy := (Rold + Gold + Bold) / 3;
          d1 := Rold - moy ;
          d2 := Gold - moy ;
          d3 := Bold - moy ;
          moy := moy + P ;
          _R := moy + d1;
          _G := moy + d2;
          _B := moy + d3;
        end;
      end else begin
        _R := R;
        _G := G;
        _B := B;
      end;
      if _R < 0 then _R := 0 else if _R > 255 then _R := 255;
      if _G < 0 then _G := 0 else if _G > 255 then _G := 255;
      if _B < 0 then _B := 0 else if _B > 255 then _B := 255;
      dst.setPixel(x,y,Byte(round(_R)),Byte(round(_G)),Byte(round(_B)));
    end;
    if (x mod c_refresh = 0) and _progress then ProgressWindow.SetProgressInc(x/(_width-1)*_prgcoef) else
        if (x mod c_refresh) = 0 then Application.ProcessMessages;
  end;
end;

procedure TMatConvRed.InitValeurs(ValuesToSet : TConvMatriceRed);
begin
  self.Valeurs := ValuesToSet;
end;

procedure TMatConvRed.getCoef(i : integer; var coef,_x,_y : integer);
begin
  _x := MC_ConvertRed[i].x;
  _y := MC_ConvertRed[i].y;
  coef := self.Valeurs[_x,_y];
end;


begin
  c := 1;
  for i := -2 to 2 do
    for j := -2 to 2 do begin
      MC_ConvertRed[c].x := j;
      MC_ConvertRed[c].y := i;
      inc(c,1);
    end;
end.

