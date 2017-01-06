unit RVB;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, global, MemoryPix, Constantes, ProgressWindows, Utils,
  marqueurs, ExtCtrls, Forms, TimException;

procedure GetCourbesRVB (var _img : TMemoryPix; var _courbeR, _courbeV, _courbeB : MyTCourbe);
procedure ApplyRVBAlign (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ;
  _RB,_GB,_BB,_RP,_GP,_BP : real ; _progress : boolean);

// Rotation of RGB channels
// SourceIMG : Original picture
// DesIMG : Destination of computed picture
// ImageDest : Image object where result should be drawing
// _rot : Rotation 1 R->R, V->B, B->V
//                 2 R->V, V->R, B->B
//                 3 R->B, V->V, B->R
//                 4 R->V, V->B, B->R
//                 5 R->B, V->R, B->V
//                 and 0 : derotate R->R,B->B,V->V
// neg : true neg of colors channels, false : positive of channel colors (no change)
// _progress : true drawing progression windows else not drawing
procedure RotateRVB (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ; _rot : integer ; neg, _progress : boolean);

// Transform RGB in B&W with luminance adaptation on each color chanel
// SourceIMG : Original picture
// DesIMG : Destination of computed picture
// ImageDest : Image object where result should be drawing
// LR : Default luminance for red channel (0 to 10000) 0 no luminance 10000 100% of luminance
// LG : Default luminance for green channel (0 to 10000) 0 no luminance 10000 100% of luminance
// LB : Default luminance for blue channel (0 to 10000) 0 no luminance 10000 100% of luminance
// if LR + LG + LB <> 10000 Exception raised
procedure RGBToLuminance(var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ; LR, LV, LB : integer ; _progress : boolean);

implementation

procedure GetCourbesRVB (var _img : TMemoryPix; var _courbeR, _courbeV, _courbeB : MyTCourbe);
var
  i,j,width,height : integer;
  interR, interG, interB : MyTCourbe;
  R,G,B : Byte;
  mx_lum : integer;
  depart : real;
begin
  mx_lum := 0;
  for i := 0 to 255 do begin
    interR[i] := 0;
    interG[i] := 0;
    interB[i] := 0;
  end;
  _img.getImageSize(width,height);
  for i := 0 to width -1 do begin
    for j := 0 to height - 1 do
      begin
        _img.getPixel(i,j,R,G,B);
        inc(interR[R],1);
        inc(interG[G],1);
        inc(interB[B],1);
      end;
    if i mod c_refresh = 0 then ProgressWindow.SetProgressInc(i/(width-1)*100);
  end;
  // limage de la courbe sur 5 mesures
  for i:= 0 to 255 do begin
    depart := (i*250/255);
    _courbeR[i] := Approx(interR, i, round(depart), round(depart+5));
    if _courbeR[i] > mx_lum then mx_lum := _courbeR[i];
    _courbeV[i] := Approx(interG, i, round(depart), round(depart+5));
    if _courbeV[i] > mx_lum then mx_lum := _courbeV[i];
    _courbeB[i] := Approx(interB, i, round(depart), round(depart+5));
    if _courbeB[i] > mx_lum then mx_lum := _courbeB[i];
  end;
  // normalisation des valeurs sur une échelle de 255
  if mx_lum = 0 then mx_lum :=1;
  for i:= 0 to 255 do begin
    _courbeR[i] := round(_courbeR[i]*255.0/mx_lum);
    _courbeV[i] := round(_courbeV[i]*255.0/mx_lum);
    _courbeB[i] := round(_courbeB[i]*255.0/mx_lum);
  end;
end;

procedure ApplyRVBAlign (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ;
  _RB,_GB,_BB,_RP,_GP,_BP : real ; _progress : boolean);
var
  i,j, width, height : LongInt;
  R,G,B : Byte;
  R1,G1,B1 : real;
begin
  SourceIMG.getImageSize(width,height);
  DestIMG.Init(width,height,false);
  // Application du contraste
  bouchR := false;
  cramR := false;
  bouchG := false;
  cramG := false;
  bouchB := false;
  cramB := false;
  for i := 0 to width -1 do begin
    for j := 0 to height - 1 do
      begin
        SourceIMG.getPixel(i,j,R,G,B);
        R1 := R * _RP + _RB ;
        G1 := G * _GP + _GB ;
        B1 := B * _BP + _BB ;
        if R1 > 255 then begin
          R1 := 255 ;
          cramR := true;
        end else if R1 < 0 then begin
          R1 := 0;
          bouchR := true;
        end;
        if G1 > 255 then begin
          G1 := 255;
          cramG := true;
        end else if G1 < 0 then begin
          G1 := 0;
          bouchG := true;
        end;
        if B1 > 255 then begin
          B1 := 255 ;
          cramB := true;
        end else if B1 < 0 then begin
          B1 := 0;
          bouchB := true;
        end;
        R := round (R1);
        G := round (G1);
        B := round (B1);
        DestIMG.setPixel(i,j,R,G,B);
      end;
    if (i mod c_refresh = 0) and _progress then ProgressWindow.SetProgressInc(i/(width-1)*_Prog_Calc);
  end;
  // Copie image de destination
  DestIMG.copyImageIntoTImage(ImageDest, _progress);
  ImageDest.Refresh;
  Application.ProcessMessages;
end;

procedure RotateRVB (var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ; _rot : integer ; neg, _progress : boolean);
var
  i,j, width, height : LongInt;
  R,V,B : Byte;
  R1,V1,B1 : Byte;
Begin
  SourceIMG.getImageSize(width,height);
  DestIMG.Init(width,height,false);
  // Application du contraste
  bouchR := false;
  cramR := false;
  bouchG := false;
  cramG := false;
  bouchB := false;
  cramB := false;
  for i := 0 to width -1 do begin
    for j := 0 to height - 1 do
      begin
        SourceIMG.getPixel(i,j,R,V,B);
        if _rot <> 0 then begin
            if _rot = 1 then begin
                R1 := R;
                B1 := V;
                V1 := B;
            end else if _rot = 2 then begin
                R1 := V;
                V1 := R;
                B1 := B;
            end else if _rot = 3 then begin
                R1 := B;
                V1 := V;
                B1 := R;
            end else if _rot = 4 then begin
                R1 := V;
                V1 := B;
                B1 := R;
            end else begin
              R1 := B;
              V1 := R;
              B1 := V;
            end;
            R := R1;
            V := V1;
            B := B1;
        end;
        if neg then begin
            R := 255 - R;
            V := 255 - V;
            B := 255 - B;
        end;
        DestIMG.setPixel(i,j,R,V,B);
      end;
    if (i mod c_refresh = 0) and _progress then ProgressWindow.SetProgressInc(i/(width-1)*_Prog_Calc);
  end;
  // Copie image de destination
  DestIMG.copyImageIntoTImage(ImageDest, _progress);
  ImageDest.Refresh;
  Application.ProcessMessages;
end;

// Transform RGB in B&W with luminance adaptation on each color chanel
// SourceIMG : Original picture
// DesIMG : Destination of computed picture
// ImageDest : Image object where result should be drawing
// LR : Default luminance for red channel (0 to 10000) 0 no luminance 10000 100% of luminance
// LG : Default luminance for green channel (0 to 10000) 0 no luminance 10000 100% of luminance
// LB : Default luminance for blue channel (0 to 10000) 0 no luminance 10000 100% of luminance
// if LR + LG + LB <> 10000 Exception raised
procedure RGBToLuminance(var SourceIMG, DestIMG : TMemoryPix ; var ImageDest : TImage ; LR, LV, LB : integer ; _progress : boolean);
var i,j, _height, _width : integer;
  SR,SG,SB,TR,TG,TB : byte;
  Lumi : integer;
begin
  if LR + LV + LB <> 10000 then begin
    raise E_LuminanceFault.Create('bad luminance values.');
  end else begin
    SourceIMG.getImageSize(_width, _height);
    DestImg.Init(_width, _height, false);
    for i := 0 to _width - 1 do begin
      for j := 0 to _height - 1 do begin
        SourceIMG.getPixel(i,j,SR,SG,SB);
        Lumi := trunc(((SR * LR) + (SG * LV) + (SB * LB)) / 10000);
        DestIMG.setPixel(i,j,Lumi,Lumi,Lumi);
        if (j mod c_refresh = 0) and _progress then Application.ProcessMessages;
      end;
      if (i mod c_refresh = 0) and _progress then ProgressWindow.SetProgressInc(i/(_width-1)*_Prog_Calc);
    end;
    DestIMG.copyImageIntoTImage(ImageDest, _progress);
    ImageDest.Refresh;
    Application.ProcessMessages;
  end;
end;

end.

