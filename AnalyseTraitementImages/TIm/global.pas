unit Global;

{$mode objfpc}{$H+} {$F+}

interface

uses
  Classes, SysUtils, ExtCtrls, Forms, Graphics, MemoryPix, TSL, Convolution, Convolution_Red, Diary, constantes,
  lazutf8, saveenv;

type
    MyTCourbe = Array[0..256] of longint;


var
  _mpreview : TListPixels;
  _finalpix : TMemoryPix;
  _lumprev : TMemoryPix;
  _interprev : TMemoryPix;
  _calculatedpix : TMemoryPix;
  _islumprev : boolean;
  _ismprev, _isfinal : boolean;
  _SourcePix : TBitmap;
  _tempPix : TBitmap;
  _S_Reanalyse : boolean;
  _S_Canceled : boolean;
  _LOpen : boolean;
  _SOpen : boolean;
  _event : boolean;
  _reqRedraw : boolean;
  _TCCouleur : boolean;
  Image : TMemoryPix;
  _lostfocus : boolean;
  _ADCouleur : boolean;
  _diaryFileName : ansistring;
  _filepath : ansistring;
  _workingDir : ansistring;
  // Selected hue
  t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono : boolean;


  // Delencheur du rafraichissement suite à la modification des zones
  //  de tons sombres, moyens et clairs.
  //  le rafraichissement doit se déclencher lorsque la fenêtre de paramétrage
  //  de la fonctionnalité récupère le focus (onActivate).
  _RefreshRequest : boolean;



  // Zone de focus
  _focusdrawsrc, _focusdrawdst : TMemoryPix;

  // Fenêtre de contrôle active => Pour leur redonner e focus après les traitements
  _currentWin : ^TForm;


  MatConv : TMatConv;
  MatConvRed : TMatConvRed;

  // Pointeur sur les objets partagés.
  SelectedColor : ^TPanel;

  // diary - journal des opérations de TIm
  _command : TCommandLine;
  _param : TParam;
  _params : TCommandLineParams;

  //
  isTransaction : boolean ; // Indique qu'un calcul est en cours.
                            // Les timers ne peuvent être réactivés
                            // tant qu'une transaction est en cours.

  // Couleurs indicateurs pixels bouchés et cramés
  C_CRAME, C_BOUCHE, C_RIEN : TColor;

  // Résolution de la preview
  ResPreview : array [1.._TopOfTopWin] of integer;

  // Applicated preview resolution
  tx, ty : integer;



procedure preparePreview(var source, dest : TImage);
procedure preparePreview2(var source, dest : TImage; x,y : integer);
procedure prepareZoom(var source, dest : TImage; x,y : integer);

function max(a,b : real) : real;
function min(a,b : real) : real;


implementation

function max(a,b : real):real;
begin
  if a > b then max := a else max := b;
end;

function min(a,b : real) : real;
begin
  if a > b then min := b else min := a;
end;

procedure preparePreview2(var source, dest : TImage; x,y : integer);
var sizex, sizey, _x, _y, _tx, _ty : integer;
  posDest, posSrc  : TRect;
begin
  if x < 0 then x := 0;
  if y < 0 then y := 0;

  sizex := _SourcePix.Width;
  sizey := _SourcePix.Height;
  if tx > sizex then _tx := sizex else _tx := tx;
  if ty > sizey then _ty := sizey else _ty := ty;
  if x + _tx > sizex then _x := sizex - _tx else _x := x;
  if y + _ty > sizey then _y := sizey - _ty else _y := y;
  // Copie
  posSrc := Rect(_x,_y,_x+_tx,_y+_ty);
  posDest := Rect(0,0,_tx,_ty);
  // Copie de l'imge aux dimensions de la preview
  dest.Picture.Bitmap.PixelFormat := pf24bit;
  dest.Picture.Bitmap.Width := _tx;
  dest.Picture.Bitmap.Height := _ty;
  Application.ProcessMessages;
  dest.Picture.Bitmap.SetSize(_tx, _ty);
  dest.Picture.Bitmap.RawImage.CreateData(true);

  dest.Picture.Bitmap.Canvas.CopyRect(posDest, source.Picture.Bitmap.Canvas, posSrc);
end;


procedure preparePreview(var source, dest : TImage);
var sizex, sizey, _x, _y : integer;
  coefproportions : real;
  position : TRect;
begin
  _y := _SourcePix.Height;
  _x := _SourcePix.Width;
  if (_y = 0) or (_x = 0) then exit;
  // Calcul des proportions pour l'image de destination
  coefproportions := _x / _y;
  if coefproportions > 1 then begin
    sizex := tx;
    sizey := round(sizex / coefproportions);
  end else begin
    sizey := ty;
    sizex := round(sizey * coefproportions);
  end;
  // Copie
  position := Rect(0,0,sizex,sizey);
  // Copie de l'imge aux dimensions de la preview
  dest.Picture.Bitmap.PixelFormat := pf24bit;
  dest.Picture.Bitmap.Width := sizex;
  dest.Picture.Bitmap.Height := sizey;
  Application.ProcessMessages;
  dest.Picture.Bitmap.SetSize(sizex, sizey);
  dest.Picture.Bitmap.RawImage.CreateData(true);

  dest.Picture.Bitmap.Canvas.StretchDraw(position, source.Picture.Bitmap);
end;

procedure prepareZoom(var source, dest : TImage; x,y : integer);
var _x, _y : integer;
  coefproportions : real;
  position : TRect;
begin
  _y := source.Picture.Bitmap.Height;
  _x := source.Picture.Bitmap.Width;
  if (_y = 0) or (_x = 0) then exit;
  // Calcul des proportions pour l'image de destination
  coefproportions := _x / _y;
  if coefproportions > 1.0 then
    y := round(x / coefproportions)
  else
    x := round(y * coefproportions);
  // Copie
  position := Rect(0,0,x,y);
  // Copie de l'imge aux dimensions de la preview
  dest.Picture.Bitmap.PixelFormat := pf24bit;
  dest.Picture.Bitmap.Width := x;
  dest.Picture.Bitmap.Height := y;
  dest.Picture.Bitmap.SetSize(x, y);
  dest.Picture.Bitmap.RawImage.CreateData(true);

  dest.Picture.Bitmap.Canvas.StretchDraw(position, source.Picture.Bitmap);
end;


begin
  _RefreshRequest := false;
  _S_Reanalyse := false;
  _islumprev := false;
  _LOpen := false;
  _SOpen := false;
  _event := false;
  _reqRedraw := false;
  _TCCouleur := false;
  _lostfocus := false;
  _ADCouleur := false;
  isTransaction := false;
  SelectedColor := nil;
  _currentWin := nil;
  C_CRAME := rgbtocolor(byte($FF),byte($00),byte($00));
  C_BOUCHE := rgbtocolor(byte($59),byte($00),byte($59));
  C_RIEN := rgbtocolor(byte($99),byte($99),byte($99));
  t_rouge := true;
  t_jaune := true;
  t_vert := true;
  t_cyan := true;
  t_bleu := true;
  t_magenta := true;
  t_mono := true;

end.

