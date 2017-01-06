unit AdvancedFilters;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MemoryPix, Graphics, Math, ProgressWindows, constantes, Global, Luminance,
  FilePix, Marqueurs, TimException, forms, Convolution, dialogs;

// Calculated background luminance signal
//
// Parameters :
// _input : (in) orginal picture from wich background luminance/color will be extracted
// _output : (out) background luminance/color signal
// radius : (in) force of radius applyied for calc of background/color signal.
//          more radius is strong more longer is the calculation time
// limit : luminance above wich signal is not incorporated in background light calculation
// color : (in) define if background exctraction is only luminance or color extraction true : color, false : luminance
// progress : (in) update progress bar in progress windows (false : no update)
// prgPercent : (in) Percentage of progression when work finished
// Output -> Signal average needed for dynamic adjustement in apply background procedure
function CalcBakgroundLum (var _input, _output : TMemoryPix; limitlow, limit, radius : integer; color, progress : boolean; prgPercent : real) : real;

// Apply background luminance correction on original picture
//    -------------------------------------------------------------------------------------------------
//    Original picture will be override with the new one. It must be save before calling this procedure
//    -------------------------------------------------------------------------------------------------
// _Img and _background picture must have the same size in width en height
//
// Parameters :
// _Img : (in/out) source and target picture,
// _backgroundlum : (in) background ligth to apply on picture
//  AddOrDel : (in) adding or substracting background signal (false : substracting, true : adding)
// invert : (in) inverting or not background signal (false not inverted, true inverted)
// delta : (in) luminance delta between source pixel and background pixel.
//         if absolute value of luminance diff between source pixel luminance and background luminance is fewer or equal
//         to delta value then the corrections on source pixel are calculated else no change on pixel source
// _dynamic : (in) adjust background dynamic signal > 0 Increase the dynamics < 0 Decrease the dynamics
// intensity : (in) apply intensity :  percentage of default signal
// average : (in) average of background signal. Point of dynamics modification if dynamic > 0 then diff beetwen the average and the point increase. if dynamic < 0 then decrease.
// progress : (in) Update progress bar in progress windows (false : no progression, true : update progression)
// prgPercent : (in) Percentage of progression when work finished
procedure ApplyBackGroundLum (var _img, _backgroundlum : TMemoryPix; AddOrDel, invert : boolean; delta, _dynamic : integer; intensity, average: real; progress : boolean; prgPercent : real);

implementation

const deltainc = 1;   // must be one

function max(a,b : integer) : integer;
begin
  if a > b then max := a
  else max := b;
end;

function min(a,b : integer) : integer;
begin
  if a>b then min := b
  else min := a;
end;

function CalcBakgroundLum (var _input, _output : TMemoryPix; limitlow, limit, radius : integer; color, progress : boolean; prgPercent : real) : real;
var i, j, xi, xj : integer ;
    width, height : integer;
    loopmeterj, loopmeteri : longint; // For progress bar
    //
    dcot : integer ; // demi côté
    dx, fx, dy, fy : integer ; // limites de la zone de calcul
    SR, SG, SB : longint ; // Somme des canaux de la zone de calcul
    Total : integer ; // nombre de valeur dans la zone de calcul
    Lum : integer; // Luminance moyenne de la zone de calcul
    sens, increment : integer;
    R,G,B : byte;

    RM, GM, BM : integer ; // Valeur moyenne du pixel de la zone de calcul

    Moyenne   : int64;
    NumberPix : int64;

    procedure init;
    begin
      dcot := radius div 2; // Calcul du demi côté
      sens := 1;
      // Init des compteurs
      SR := 0;
      SG := 0;
      SB := 0;
      Total := 0;
      Moyenne := 0;
      NumberPix := 0;
    end;

    function isPair(valeur : integer) : boolean;
    begin
      if ((valeur div 2) * 10) = ((valeur / 2) * 10) then
        isPair := true else isPair := false;
    end;

    // Nouvelle colonne
    procedure newCol(x,y : integer);
    var i, j, d, fin, cold, cola : integer;
        R,G,B : byte;
        true1, true2 : boolean;
        Lum : integer ;
    begin
      if (x = 0) then begin
        sens := 1 ;
        for i := 0 to dcot do begin
          for j := 0 to dcot do begin
            _input.getpixel(i,j,R,G,B);
            Lum := getLuminance (R,G,B) ;
            if (Lum <= limit) and (Lum >= limitlow) then begin
              SR := SR + R;
              SG := SG + G;
              SB := SB + B;
            end;
            total := total + 1;
          end;
        end;
        dx := 0;
        fx := dcot;
        // Calcul de pixel moyen et sa luminance
        if Total > 0 then begin
          RM := trunc(SR / Total);
          GM := trunc(SG / Total);
          BM := trunc(SB / Total);
          if RM > 255 then RM := 255 else if RM < 0 then RM := 0;
          if GM > 255 then GM := 255 else if GM < 0 then GM := 0;
          if BM > 255 then BM := 255 else if BM < 0 then BM := 0;
          Lum := getLuminance(RM,GM,BM);
        end else begin
          RM := 0;
          GM := 0;
          BM := 0;
          Lum := 0;
        end;
      end else begin
        // changing way
        sens := - sens ;
        if sens = -1 then begin
          fin := height - 1; // ok
          d := fin - dcot; // ok
        end else begin
          d := 0;  // ok
          fin := dcot; // ok
        end;
        true1 := x > dcot;
        true2 := x < (width - dcot - 1);
        cold := x - dcot - 1; // ok
        cola := x + dcot;  // ok

        for i := d to fin do begin
            // delete if needed
            if true1 then begin
              _input.getpixel(cold,i,R,G,B);
              Lum := getLuminance (R,G,B);
              if (Lum <= limit) and (Lum >= limitlow) then begin
                SR := SR - R;
                SG := SG - G;
                SB := SB - B;
              end;
                Total := Total - 1;
              //end;
            end;

            // adding if needed
            if true2 then begin
              _input.getpixel(cola,i,R,G,B);
              Lum := getLuminance (R,G,B);
              if (Lum <= limit) and (Lum >= limitlow) then begin
                SR := SR + R;
                SG := SG + G;
                SB := SB + B;
              end;
                Total := Total + 1;
              //end;
            end;
        end;
        dx := max(0, x - dcot);
        fx := min(x+dcot, width-1);
        // Calcul du pixel moyen et de sa luminance
        if Total > 0 then begin
          RM := trunc(SR / Total);
          GM := trunc(SG / Total);
          BM := trunc(SB / Total);
          if RM > 255 then RM := 255 else if RM < 0 then RM := 0;
          if GM > 255 then GM := 255 else if GM < 0 then GM := 0;
          if BM > 255 then BM := 255 else if BM < 0 then BM := 0;
          Lum := getLuminance(RM,GM,BM);
        end else begin
          RM := 0;
          GM := 0;
          BM := 0;
          Lum := 0;
        end;

      end;
      // Ecriture du pixel
      if sens = 1 then fin := 0 else fin := width-1;
      if color then _output.setPixel(x,fin,RM,GM,BM)
      else _output.setPixel(x,fin,Lum,Lum,Lum);
    end;

    procedure newLine(x,y : integer);
    var i,j, fin, finx, finy : integer;
        R,G,B : byte;
    begin
      // ligne à supprimer de la moyenne
      if sens = 1 then begin
        dy := (y-1) - dcot ; // dcot déjà calculé à l'init

        // ligne à ajouter
        fy := y + dcot ; // dcot déjà calculé à l'init

      end else begin
        // ligne à supprimer de la moyenne
        dy := (y+1) + dcot;

        // ligne à ajouter à la moyenne
        fy :=  y - dcot;
      end;

      // Suppression de la ligne précédente et ajout de la nouvelle ligne. dx et fx dejà calculés
      i := min(dx,fx);
      fin := max(dx,fx);
      while i <= fin do begin
        if (dy >= 0) and (dy < height) then begin // suppression
          // lecture du pixel
          _input.getPixel(i, dy, R,G,B);
          Lum := getLuminance (R,G,B);
          if (Lum <= limit) and (Lum >= limitlow) then begin
            // Suppression
            SR := SR - R;
            SG := SG - G;
            SB := SB - B;
          end;
            Total := Total - 1;
          //end;
        end;
        if (fy >= 0) and (fy < height) then begin // ajout
          // lecture du pixel
          _input.getPixel(i,fy, R,G,B);
          Lum := getLuminance (R,G,B);
          if (Lum <= limit) and (Lum >= limitlow) then begin
            // Ajout
            SR := SR + R;
            SG := SG + G;
            SB := SB + B;
          end;
            Total := Total + 1;
          //end;
        end;
        inc(i);
      end;

      // Calcul du pixel moyen et de sa luminance
      if Total > 0 then begin
        RM := trunc(SR / Total);
        GM := trunc(SG / Total);
        BM := trunc(SB / Total);
        if RM > 255 then RM := 255 else if RM < 0 then RM := 0;
        if GM > 255 then GM := 255 else if GM < 0 then GM := 0;
        if BM > 255 then BM := 255 else if BM < 0 then BM := 0;
        Lum := getLuminance(RM,GM,BM);
      end else begin
        RM := 0;
        GM := 0;
        BM := 0;
        Lum := 0;
      end;

      // Ecriture du pixel
      if Color then
            _output.setPixel(x,y,RM,GM,BM)
      else
            _output.setPixel(x,y,Lum,Lum,Lum);

    end;

begin
  // Get Source size
  _input.getImageSize(width,height);
  // Set Destination size
  _output.Init(width,height,false);
  // Setting the pixel in ouput pix
  // 1 - Init
  Init;
  loopmeteri := 0;
  xj := 0;
  xi := 0;
  // 2 - compute background image
  while xi < width do begin
    // Init new colomn
    newCol(xi,xj);
    xj := xj + sens;
    loopmeterj :=0;
    while ((xj>=0) and (xj<height)) do begin
      // Calc average
      _input.getPixel(xi,xj,R,G,B);
      Lum := getLuminance(R,G,B);
      if (Lum <= limit) and (Lum >= limitlow) then begin
        Moyenne := Moyenne + Lum;
      end;
        NumberPix := NumberPix + 1;
      //end;
      // del old line and add new line
      newLine(xi,xj);
      if (loopmeterj mod (c_refresh) = 0) then Application.ProcessMessages;
      inc(loopmeterj);
      xj:=xj+sens;
    end;
    xj:=xj-sens;
    if (loopmeteri mod c_pixrefresh = 0) and progress then ProgressWindow.SetProgressInc((xi/width)*prgPercent);
    inc(loopmeteri);
    xi:=xi+1;
  end;
  // Progression bar commiting for continue progression from new position
  if progress then ProgressWindow.InterCommit;

  // Compute retrun value
  if NumberPix <> 0 then
    CalcBakgroundLum := Moyenne/NumberPix
  else CalcBakgroundLum := 0;

end;


procedure ApplyBackGroundLum (var _img, _backgroundlum : TMemoryPix; AddOrDel,invert : boolean; delta, _dynamic : integer; intensity, average: real; progress : boolean; prgPercent : real);
var i, j : integer;
    width, height, widthbgr, heightbgr : integer;
    R,G,B, RBG, GBG, BBG : Byte;
    SR, SG, SB, RSR, RSG, RSB : real;
    RR, GR, BR : integer;
    Lum, LumS, LumC, Diff : integer;
    coefDelta, dynamicadjust, diffdyn : real;

    procedure definedynamic (R,G,B : byte; average : real; coefdyn : integer; var RS,GS,BS : integer);
    var lum : integer;          // luminance of pixel
        target_lum : integer;   // what luminance should be after dynamic adjustement
        delta_average : real;   // delta between pixel luminance and average
        to_add : real;          // value to add on each chanel
        dynamic_coef : real;    // coef to dynamic modification
    begin
      // #1 define diff between signal and average
      // #1.1 getting signal luminance
      lum := getLuminance(R,G,B);
      // #1.2 cal difference between average and signal if signal > average diff > 0
      delta_average := lum - average;

      // #2 cal the dynamic change
      // #2.1 transformation scale -200 -> +200 into / 2 -> * 2
      if _dynamic < 0 then dynamic_coef := -100/_dynamic
      else dynamic_coef := _dynamic/100;

      // #3 cal what the luminance signal shlould be
      // #3.1 adjust delta whith dynamic coef
      delta_average := delta_average * dynamic_coef;
      // #3.2 cal new luminance
      target_lum := round(average + delta_average);

      // #4 cal value to add to each chanel of the pixel
      to_add := target_lum - lum;

      // #5 cal the new value of the pixel
      RS := round(R + to_add);
      GS := round(G + to_add);
      BS := round(B + to_add);

      // #6 limit scale of values
      if RS < 0 then RS := 0 else if RS > 255 then RS := 255;
      if GS < 0 then GS := 0 else if GS > 255 then GS := 255;
      if BS < 0 then BS := 0 else if BS > 255 then BS := 255;
    end;

begin
  // Init indicators for pixels over numerical limits
  bouchR := false;
  cramR := false;
  bouchG := false;
  cramG := false;
  bouchB := false;
  cramB := false;
  intensity := intensity / 100;

  // 1 - Getting pictures size
  // 1.1 - Picture size
  _img.getImageSize (width, height);
  // 1.2 - Background size
  _backgroundlum.getImageSize (widthbgr, heightbgr);
  // 1.3 - compare size and raise exception if size are diferents
  if (width <> widthbgr) or (height <> heightbgr) then
    raise E_PictureSizeFault.Create('pictures size differents');
  // 2 - loops on picture size
  for i := 0 to width - 1 do begin
    for j := 0 to height - 1 do begin
      // 2.1 - Getting pixels from source and background
      _img.getPixel(i,j,R,G,B); // getting from source
      _backgroundlum.getPixel(i,j,RBG,GBG,BBG); // getting from background

      // 2.2 dynamic adjustement
      definedynamic(RBG,GBG,BBG,average,_dynamic,RR,GR,BR);
      RBG := byte(RR);
      GBG := byte(GR);
      BBG := byte(BR);

      // 2.3 Inverting background signal if asked
      if invert then begin
        RBG := 255 - RBG;
        GBG := 255 - GBG;
        BBG := 255 - BBG;
      end;

      // 2.4 - Apply intensity coef
      SR := RBG * intensity;
      SG := GBG * intensity;
      SB := BBG * intensity;

      // 2.5 - diff beetwen picture and background signals
      LumS := getLuminance(R,G,B);
      if invert then
        LumC := getLuminance(255-RBG,255-GBG,255-BBG)
      else
        LumC := getLuminance(RBG, GBG, BBG);
      diff := abs(LumS - LumC);
      if delta = 0 then coefDelta := 0 else begin
        if diff > delta then coefDelta := 0 else
          coefDelta := (Delta - diff) / delta;
      end;
      // 2.6 - applying modification
      SR := SR * coefDelta;
      SG := SG * coefDelta;
      SB := SB * coefDelta;
      // 2.7 - Calculate result
      if AddOrDel then begin // true add false del
        RR := trunc(R + SR);
        GR := trunc(G + SG);
        BR := trunc(B + SB);
      end else begin
        RR := trunc(R - SR);
        GR := trunc(G - SG);
        BR := trunc(B - SB);
      end;
      // 2.8 - testing and setting pixels in the numerical limits
      if RR < 0 then begin
        RR := 0;
        bouchR := true;
      end  else if RR > 255 then begin
        RR := 255;
        cramR := true;
      end;
      if GR < 0 then begin
        GR := 0;
        bouchG := true;
      end else if GR > 255 then begin
        GR := 255;
        cramG := true;
      end;
      if BR < 0 then begin
        BR := 0;
        bouchB := true;
      end else if BR > 255 then begin
        BR := 255;
        cramB := true;
      end;
      // 2.9 setting new pixel value
      _img.setPixel(i,j, byte(RR), byte(GR), byte(BR));
    end;
    if (i mod c_refresh = 0) and progress then ProgressWindow.SetProgressInc((i/width)*prgPercent);
  end;
  // Progression bar commiting for continue progression from new position
  if progress then ProgressWindow.InterCommit;
end;

end.

