unit Wavelets;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Global, Convolution, MemoryPix, ProgressWindows, constantes, Luminance,
  marqueurs, math, forms, TSL;

procedure Wavelets_ApplyWavelets(var ImgSrc, ImgDest : TMemoryPix; a1,a2,a3,a4,a5,_surimp : real; _substract, _denose, _ctrboost, _color, _progress : boolean);


implementation

const _coefctrboost = 1.25;
      _coefdenose = 0.5;

var

  _init0 :  TConvMatrice = (_size:(4);_data:(_4:(
                             (000,000,001,001,001,001,001,000,000),
                             (000,001,001,001,001,001,001,001,000),
                             (001,001,001,001,001,001,001,001,001),
                             (001,001,001,001,001,001,001,001,001),
                             (001,001,001,001,002,001,001,001,001),
                             (001,001,001,001,001,001,001,001,001),
                             (001,001,001,001,001,001,001,001,001),
                             (000,001,001,001,001,001,001,001,000),
                             (000,000,001,001,001,001,001,000,000))));

  // a
  _init1  : TConvMatrice = (_size:(4);_data:(_4:(
                            (000,000,001,001,001,001,001,000,000),
                            (000,001,001,001,001,001,001,001,000),
                            (001,001,001,001,001,001,001,001,001),
                            (001,001,001,001,001,001,001,001,001),
                            (001,001,001,001,010,001,001,001,001),
                            (001,001,001,001,001,001,001,001,001),
                            (001,001,001,001,001,001,001,001,001),
                            (000,001,001,001,001,001,001,001,000),
                            (000,000,001,001,001,001,001,000,000))));

  // b
  _init2  : TConvMatrice = (_size:(3);_data:(_3:(
                            (000,001,001,001,001,001,000),
                            (001,001,001,001,001,001,001),
                            (001,001,001,001,001,001,001),
                            (001,001,001,008,001,001,001),
                            (001,001,001,001,001,001,001),
                            (001,001,001,001,001,001,001),
                            (000,001,001,001,001,001,000))));

  // c
  _init3  : TConvMatrice = (_size:(2);_data:(_2:(
                            (000,001,001,001,000),
                            (001,001,001,001,001),
                            (001,001,002,001,001),
                            (001,001,001,001,001),
                            (000,001,001,001,000))));

  // d
  _init4  : TConvMatrice = (_size:(2);_data:(_2:(
                            (000,001,001,001,000),
                            (001,001,001,001,001),
                            (001,001,005,001,001),
                            (001,001,001,001,001),
                            (000,001,001,001,000))));


  // e
  _init5  : TConvMatrice = (_size:(1);_data:(_1:(
                            (000,001,000),
                            (001,004,001),
                            (000,001,000))));

  // Flou
  _init6  : TConvMatrice = (_size:(1);_data:(_1:(
                            (001,001,001),
                            (001,001,001),
                            (001,001,001))));



procedure  Wavelets_ApplyWavelets(var ImgSrc, ImgDest : TMemoryPix; a1,a2,a3,a4,a5, _surimp : real; _substract, _denose, _ctrboost, _color, _progress : boolean);
  var
    x, y, _width, _height : integer;
    _R, _G, _B, _R1, _G1, _B1 : Byte;
    _Rs, _Gs, _Bs, _surimp1 : real;
    _Ri, _Gi, _Bi, _Rd, _Gd, _Bd : array[0..5] of real;
    _luminance : real;
    _calcwaves : boolean;
    _prgcoef : integer;
    _teinte : integer;
  begin
    if _denose then _prgcoef := _Prog_Calc2 else _prgcoef := _Prog_Calc;
    // Init recup taille image source et init taille image dest
    ImgSrc.getImageSize(_width,_height);
    ImgDest.Init(_width,_height,false);
    // Init valeur de la matrice de convolution
    for x := 0 to _width - 1 do begin
      for y := 0 to _height - 1 do begin
        ImgSrc.getPixel(x,y,_R,_G,_B);
        _R1 := _R;
        _G1 := _G;
        _B1 := _B;
        // Détermination de la luminance et s'il faut ou non faire les calculs
        _luminance := GetLuminance (_R,_G,_B);
        // Détermination de la teinte pour s'avoir s'il faut ou non faire les calculs
        _teinte := TSL_getTeinteIndex(_R,_G,_B);
        _calcwaves := (((_luminance < _CTonsSombres) and _ATonsSombres) or
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
        if _calcwaves then begin
          // Calcul du pixel de l'image intermédiaire
          MatConv.initValeurs(_init5);
          MatConv.pixelApply(ImgSrc, _R,_G,_B, _Rs,_Gs, _Bs, x,y,
            _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono,
            _color);
          _Ri[5] := _Rs ;//- _R ;
          _Gi[5] := _Gs ;//- _G ;
          _Bi[5] := _Bs ;//- _B;

          // Calcul plage de fréquence fréquences élevées
          MatConv.initValeurs(_init4);
          _R := _R1;
          _G := _G1;
          _B := _B1;
          MatConv.pixelApply(ImgSrc, _R,_G,_B, _Rs,_Gs, _Bs, x,y,
            _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono,
            _color);
          // Calcul du pixel de l'image intermédiaire
          _Ri[4] :=  _Rs ;
          _Gi[4] :=  _Gs ;
          _Bi[4] :=  _Bs ;

          // Calcul plage de fréquence Moyennes fréquences
          MatConv.initValeurs(_init3);
          _R := _R1;
          _G := _G1;
          _B := _B1;
          MatConv.pixelApply(ImgSrc, _R,_G,_B, _Rs,_Gs, _Bs, x,y,
            _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono,
            _color);
          // Calcul du pixel de l'image intermédiaire
          _Ri[3] :=  _Rs ;
          _Gi[3] :=  _Gs ;
          _Bi[3] :=  _Bs ;
          // Calcul plage de fréquence 4
          MatConv.initValeurs(_init2);
          _R := _R1;
          _G := _G1;
          _B := _B1;
          MatConv.pixelApply(ImgSrc, _R,_G,_B, _Rs,_Gs, _Bs, x,y,
            _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono,
            _color);
          // Calcul du pixel de l'image intermédiaire
          _Ri[2] :=  _Rs ;
          _Gi[2] :=  _Gs ;
          _Bi[2] :=  _Bs ;

          // Calcul plage de fréquence 5
          MatConv.initValeurs(_init1);
          _R := _R1;
          _G := _G1;
          _B := _B1;
          MatConv.pixelApply(ImgSrc, _R,_G,_B, _Rs,_Gs, _Bs, x,y,
            _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono,
            _color);
          // Calcul du pixel de l'image intermédiaire
          _Ri[1] := _Rs ;
          _Gi[1] := _Gs ;
          _Bi[1] := _Bs ;


          // Calcul plage de fréquence Haute fréquences
          MatConv.initValeurs(_init0);
          _R := _R1;
          _G := _G1;
          _B := _B1;
          MatConv.pixelApply(ImgSrc, _R,_G,_B, _Rs,_Gs, _Bs, x,y,
            _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono,
            _color);

          if not(_substract) then begin
            // Calcul du pixel de la base
            _Ri[0] := _Rs ;//- _R ;
            _Gi[0] := _Gs ;//- _G ;
            _Bi[0] := _Bs ;//- _B;

            // Determination des différences
            // Dif 5
            _Rd[5] := _Ri[5] - _Ri[4];
            _Gd[5] := _Gi[5] - _Gi[4];
            _Bd[5] := _Bi[5] - _Bi[4];

            // Dif 4
            _Rd[4] := _Ri[4] - _Ri[3];
            _Gd[4] := _Gi[4] - _Gi[3];
            _Bd[4] := _Bi[4] - _Bi[3];

            // Dif 3
            _Rd[3] := _Ri[3] - _Ri[2];
            _Gd[3] := _Gi[3] - _Gi[2];
            _Bd[3] := _Bi[3] - _Bi[2];

            // Dif 2
            _Rd[2] := _Ri[2] - _Ri[1];
            _Gd[2] := _Gi[2] - _Gi[1];
            _Bd[2] := _Bi[2] - _Bi[1];

            // Dif 1
            _Rd[1] := _Ri[1] - _Ri[0];
            _Gd[1] := _Gi[1] - _Gi[0];
            _Bd[1] := _Bi[1] - _Bi[0];


            // Détermination de l'image résultat
            _Rs :=  (_Ri[0] + (_Rd[1] * a1) + (_Rd[2] * a2) + (_Rd[3] * a3) + (_Rd[4] * a4) + (_Rd[5] * a5));///diviseur;
            _Gs :=  (_Gi[0] + (_Gd[1] * a1) + (_Gd[2] * a2) + (_Gd[3] * a3) + (_Gd[4] * a4) + (_Gd[5] * a5));///diviseur;
            _Bs :=  (_Bi[0] + (_Bd[1] * a1) + (_Bd[2] * a2) + (_Bd[3] * a3) + (_Bd[4] * a4) + (_Bd[5] * a5));///diviseur;
          end else begin
            // Calcul du pixel de la base
            _Ri[0] := _R1 ;//- _R ;
            _Gi[0] := _G1 ;//- _G ;
            _Bi[0] := _B1 ;//- _B;

            // Determination des différences
            // Dif 5
            _Rd[5] := _R1 - _Ri[5] ; //_Ri[5] - _Ri[4];
            _Gd[5] := _G1 - _Gi[5] ; //_Gi[5] - _Gi[4];
            _Bd[5] := _B1 - _Bi[5] ; //_Bi[5] - _Bi[4];

            // Dif 4
            _Rd[4] := _Ri[5] - _Ri[4];
            _Gd[4] := _Gi[5] - _Gi[4];
            _Bd[4] := _Bi[5] - _Bi[4];
            // Dif 3
            _Rd[3] := _Ri[4] - _Ri[3];
            _Gd[3] := _Gi[4] - _Gi[3];
            _Bd[3] := _Bi[4] - _Bi[3];
            // Dif 2
            _Rd[2] := _Ri[3] - _Ri[2];
            _Gd[2] := _Gi[3] - _Gi[2];
            _Bd[2] := _Bi[3] - _Bi[2];
            // Dif 1
            _Rd[1] := _Ri[2] - _Ri[1];
            _Gd[1] := _Gi[2] - _Gi[1];
            _Bd[1] := _Bi[2] - _Bi[1];
            // Détermination de l'image résultat
            _Rs :=  (_Ri[0] - (_Rd[1] * (a1-0.5))- (_Rd[2] * (a2-0.5)) - (_Rd[3] * (a3-0.5)) - (_Rd[4] * (a4-0.5)) - (_Rd[5] * (a5-0.5))) ;
            _Gs :=  (_Gi[0] - (_Gd[1] * (a1-0.5))- (_Gd[2] * (a2-0.5)) - (_Gd[3] * (a3-0.5)) - (_Gd[4] * (a4-0.5)) - (_Gd[5] * (a5-0.5))) ;
            _Bs :=  (_Bi[0] - (_Bd[1] * (a1-0.5))- (_Gd[2] * (a2-0.5)) - (_Gd[3] * (a3-0.5)) - (_Gd[4] * (a4-0.5)) - (_Gd[5] * (a5-0.5))) ;

          end;


        end else begin
          _Rs := _R1 ;
          _Gs := _G1 ;
          _Bs := _B1 ;
        end;
        // Contratse booster si demande
        if _ctrboost then begin
          _Rs := _R + ((_Rs - _R) * _coefctrboost);
          _Gs := _G + ((_Gs - _G) * _coefctrboost);
          _Bs := _B + ((_Bs - _B) * _coefctrboost);
        end;
        // surimpression
        _surimp1 := 1 - _surimp;

        _Rs := (_surimp * _RS) + (_surimp1 * _R1);
        _Gs := (_surimp * _GS) + (_surimp1 * _G1);
        _Bs := (_surimp * _BS) + (_surimp1 * _B1);
        if _Rs < 0 then _Rs := 0 else if _Rs > 255 then _Rs := 255;
        if _Gs < 0 then _Gs := 0 else if _Gs > 255 then _Gs := 255;
        if _Bs < 0 then _Bs := 0 else if _Bs > 255 then _Bs := 255;
        ImgDest.setPixel(x,y,Byte(round(_Rs)),Byte(round(_Gs)),Byte(round(_Bs)));
      end;
      if (x mod c_pixrefresh = 0) and _progress then ProgressWindow.SetProgressInc(x/(_width-1)*_prgcoef)else
        if (x mod c_refresh) = 0 then Application.ProcessMessages;
    end;
    // Si demandé denose
    if _denose then begin
      ProgressWindow.InterCommit;
      MatConv.initValeurs(_init6);
      ImgDest.copy(ImgSrc, false, 0);
      ProgressWindow.SetProgressInc(_Prog_Copy2 div 2);
      ProgressWindow.InterCommit;
      MatConv.Apply(ImgSrc, ImgDest,
        _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono,
        _color, _progress, _Prog_Copy2 div 2);
      _R := byte(round(_Rs));
      _G := byte(round(_GS));
      _B := byte(round(_Bs));
    end;
  end;


end.

