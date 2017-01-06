unit Convolution;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MemoryPix, ProgressWindows, Constantes, marqueurs, forms, TSL;

Type
  TConvMatrice = record
    _size : 1..5;
    _data : packed record case integer of
       1 : ( _1 : array [-1..1,-1..1] of integer);
       2 : ( _2 : array [-2..2,-2..2] of integer);
       3 : ( _3 : array [-3..3,-3..3] of integer);
       4 : ( _4 : array [-4..4,-4..4] of integer);
       5 : ( _5 : array [-5..5,-5..5] of integer);
    end;
  end;

  TConvMatriceCoord = record
    x, y : integer;
  end;

  TMatConv = class(TObject)
    Valeurs : TConvMatrice;
    private
    public
      procedure initValeurs(ValuesToSet : TConvMatrice);
      procedure getCoef(i : integer; var coef,_x,_y : integer);
      procedure apply(var src, dst : TMemoryPix;
        _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ;
        _color, _progress : boolean; _prgcoef :integer);
      procedure pixelApply(var src : TMemoryPix; var R,G,B : Byte; var _R,_G,_B : real ; x,y : integer;
         _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ;
         _color : boolean);
  end;


implementation

type
  TConvMatriceTransco_1  = array[1..9] of TConvMatriceCoord;
  TConvMatriceTransco_2  = array[1..25] of TConvMatriceCoord;
  TConvMatriceTransco_3  = array[1..49] of TConvMatriceCoord;
  TConvMatriceTransco_4  = array[1..81] of TConvMatriceCoord;
  TConvMatriceTransco_5  = array[1..121] of TConvMatriceCoord;

var
  MC_Convert_1 : TConvMatriceTransco_1;
  MC_Convert_2 : TConvMatriceTransco_2;
  MC_Convert_3 : TConvMatriceTransco_3;
  MC_Convert_4 : TConvMatriceTransco_4;
  MC_Convert_5 : TConvMatriceTransco_5;
  c_1,c_2,c_3,c_4,c_5,i,j : integer;

procedure TMatConv.pixelApply(var src : TMemoryPix; var R,G,B : Byte; var _R,_G,_B : real ; x,y : integer;
    _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ;
    _color : boolean);
var
  _width, _height, x1, y1, x2, y2 : integer;
  P1, CF : integer;
  k : integer;
  P, _luminance, _luminanceN, Rold, Gold, Bold, moy, d1, d2, d3 : real;
  _calc : boolean;
  _endloop : integer;
  _teinte : integer;
begin
  // Déterminantion de la borne de fin pour la boucle des coordonnées de la matrice de convolution
  if self.Valeurs._size = 1 then
    _endloop := 9
  else if self.Valeurs._size = 2 then
    _endloop := 25
  else if self.Valeurs._size = 3 then
    _endloop := 49
  else if self.Valeurs._size = 4 then
    _endloop := 81
  else _endloop := 121;
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
  // Détermination de la teinte pour s'avoir s'il faut ou non faire les calculs
  _teinte := TSL_getTeinteIndex(R,G,B);
  _calc := (((_luminance < _CTonsSombres) and _ATonsSombres) or
           ((_luminance < _CTonsMoyens) and _ATonsMoyens and (_luminance >= _CTonsSombres)) or
           ((_luminance >= _CTonsMoyens) and _ATonsClairs))
           and
           ((t_rouge   and (_teinte = 1)) or
            (t_jaune   and (_teinte = 2)) or
            (t_vert    and (_teinte = 3)) or
            (t_cyan    and (_teinte = 4)) or
            (t_bleu    and (_teinte = 5)) or
            (t_magenta and (_teinte = 6)) or
            (t_mono    and (_teinte = 7)));
  if _calc then begin
    _luminance := (R+G+B)/3;
    _luminanceN := 0;
    for k := 1 to _endloop do begin
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

procedure TMatConv.apply(var src, dst : TMemoryPix;
    _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean ;
    _color, _progress : boolean; _prgcoef :integer);
var
  _width, _height, x, y, x1, y1, x2, y2 : integer;
  R,G,B, Rold, Gold, Bold : Byte;
  _R,_G,_B : real;
  P1, CF : integer;
  k : integer;
  P, _luminance, _luminanceN, moy, d1, d2, d3 : real;
  _calc : boolean;
  _endloop : integer;
  _teinte : integer;
begin
  // Déterminantion de la borne de fin pour la boucle des coordonnées de la matrice de convolution
  if self.Valeurs._size = 1 then
    _endloop := 9
  else if self.Valeurs._size = 2 then
    _endloop := 25
  else if self.Valeurs._size = 3 then
    _endloop := 49
  else if self.Valeurs._size = 4 then
    _endloop := 81
  else _endloop := 121;
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
      // Détermination de la teinte pour s'avoir s'il faut ou non faire les calculs
      _teinte := TSL_getTeinteIndex(R,G,B);
      _calc := (((_luminance < _CTonsSombres) and _ATonsSombres) or
               ((_luminance < _CTonsMoyens) and _ATonsMoyens and (_luminance >= _CTonsSombres)) or
               ((_luminance >= _CTonsMoyens) and _ATonsClairs))
               and
               ((t_rouge   and (_teinte = 1)) or
                (t_jaune   and (_teinte = 2)) or
                (t_vert    and (_teinte = 3)) or
                (t_cyan    and (_teinte = 4)) or
                (t_bleu    and (_teinte = 5)) or
                (t_magenta and (_teinte = 6)) or
                (t_mono    and (_teinte = 7)));
      if _calc then begin
        _luminanceN := 0;
        for k := 1 to _endloop do begin
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

procedure TMatConv.InitValeurs(ValuesToSet : TConvMatrice);
begin
  self.Valeurs := ValuesToSet;
end;

procedure TMatConv.getCoef(i : integer; var coef,_x,_y : integer);
begin
  if self.Valeurs._size = 1 then begin
    _x := MC_Convert_1[i].x;
    _y := MC_Convert_1[i].y;
    coef := self.Valeurs._data._1[_x,_y];
  end else if self.Valeurs._size = 2 then begin
    _x := MC_Convert_2[i].x;
    _y := MC_Convert_2[i].y;
    coef := self.Valeurs._data._2[_x,_y];
  end else if self.Valeurs._size = 3 then begin
    _x := MC_Convert_3[i].x;
    _y := MC_Convert_3[i].y;
    coef := self.Valeurs._data._3[_x,_y];
  end else if self.Valeurs._size = 4 then begin
    _x := MC_Convert_4[i].x;
    _y := MC_Convert_4[i].y;
    coef := self.Valeurs._data._4[_x,_y];
  end else if self.Valeurs._size = 5 then begin
    _x := MC_Convert_5[i].x;
    _y := MC_Convert_5[i].y;
    coef := self.Valeurs._data._5[_x,_y];
  end;
end;


begin
  c_1 := 1;
  c_2 := 1;
  c_3 := 1;
  C_4 := 1;
  c_5 := 1;
  for i := -5 to 5 do
    for j := -5 to 5 do begin
      MC_Convert_5[c_5].x := j;
      MC_Convert_5[c_5].y := i;
      inc(c_5,1);
      if (i >= -4) and (i<=4) and (j >= -4) and (j <= 4) then begin
        MC_Convert_4[c_4].x := j;
        MC_Convert_4[c_4].y := i;
        inc(c_4,1);
        if (i >= -3) and (i<=3) and (j >= -3) and (j <= 3) then begin
          MC_Convert_3[c_3].x := j;
          MC_Convert_3[c_3].y := i;
          inc(c_3,1);
          if (i >= -2) and (i<=2) and (j >= -2) and (j <= 2) then begin
            MC_Convert_2[c_2].x := j;
            MC_Convert_2[c_2].y := i;
            inc(c_2,1);
            if (i >= -1) and (i<=1) and (j >= -1) and (j <= 1) then begin
              MC_Convert_1[c_1].x := j;
              MC_Convert_1[c_1].y := i;
              inc(c_1,1);
            end;
          end;
        end;
      end;
    end;
end.


