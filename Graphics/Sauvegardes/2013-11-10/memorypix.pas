unit MemoryPix;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Graphics, ProgressWindows, GraphType, TSL;

type
  TMemoryPix = class(TObject)
    private
      isData : boolean;
      memoryBuff : TMemoryStream;
      pwidth, pheight : integer;
      function memorysize(width, height : integer) : integer;
      function getPixelPos(x, y : integer) : PByte;
    public
      constructor Create();
      constructor Create(width, height : integer; zeroinit : boolean);
      constructor Create(width, height : integer; color : TColor);
      constructor Create(width, height : integer; R,G,B,L : Byte);
      constructor Create(var Image : TImage);
      destructor Destroy; override;
      procedure getImageSize (var width, height : integer);
      procedure setPixel(x, y : integer; R, G, B : Byte);
      procedure setPixel(x, y : integer; R, G, B, L : Byte);
      procedure setPixel(x, y : integer; color : TColor);
      procedure setPixel(x, y : integer; color : TColor; L : Byte);
      procedure getPixel(x, y : integer; var R, G, B : Byte);
      procedure getPixel(x, y : integer; var R, G, B, L : Byte);
      procedure getPixel(x, y : integer; var color : TColor);
      procedure getPixel(x, y : integer; var color : TColor; var L : Byte);
      procedure copyImageIntoTImage (var Image : TImage);
      procedure getImageFromTImage (var Image : TImage);
  end ;

  T_PixelColor = record
    _R,_G,_B,_L : Byte
  end;

  T_SumRGB = record  // Somme la valeur des cannaux RGB pour les pixels classés
                     // dans une même teinte pour déterminer la teinte moyenne.
                     // Cette valeur moyenne permettant de déterminer la valeur
                     // initiale de la saturation pour une teinte donnée.
                     // Cette valeur étant une des composante de la courbe de saturation
                     // des teintes
    _SR, _SG, _SB : LongInt;
    _nbPix : LongInt;
  end;

  // Prédéclaration du pointeur sur la classe d'un maillon d'une liste doublement chaînée
  //   de pixels (RGB + coef fonction de saturation
  PTDynPix = ^TDynPix;
  // Définition de la classe
  TDynPix = class(TObject)
    private
      // Chaînage avant et arrière
      _next, _previous : PTDynPix;
      // Pixel du mayon en RGBL
      _pixel : T_PixelColor;
      // Coef des équations ax = b (b étant l'intensité de départ de la couleur
      //  Permet de calculer les coef une fois pour toute et de ne pas les recalculer
      //  à chaque modification du coef de saturation
      _satcoef : TCoefSatDSat;
      _x,_y : integer;
    public
      constructor Create();
      constructor Create(x,y : integer; R,G,B,L : Byte);
      // Destructeur du mayon courant
      destructor Destroy ; override;
      // getter et setter
      procedure getPix(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
      procedure setPix(var x,y : integer; var R,G,B,L : Byte); // Calcul des coefs sat et dsat
      procedure getCoef(var coefs : TCoefSatDSat);
      procedure setColor (var R,G,B,L : Byte); // Pour changer la couleur d'un pixel (pas ses coordonnées et sans recalcul des coefs sat et dsat)
      procedure getColor (var R,G,B,L : Byte); // Pour ne récupérer que la couleur (utile ?)
      procedure getCoord(var x,y : integer); // Utile ?
      procedure setCoord(var x,y : integer); // Pour les rotations et les permutations de l'image
      procedure getNearDynPix (var prev,next : PTDynPix);
      procedure setNearDynPix (prev,next : PTDynPix);
      // Suppression du reste des maillons chaînée à partir du mayon courrant
      procedure DestroyAllNext;
  end;

  TAncrePixels = record
    nbPixels : integer;  // Nombre de pixels dans la liste (pour la barre de progression des traitements)
    List : PTDynPix;     // La liste elle même
    _current : PTDynPix; // Le maillon courant de la liste
  end;

  TListPixels = class(TObject)
    private
      procedure _add(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte);
      procedure _setPixel(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte); // recalcul des sat et dsat
      procedure _setColor(var _current : TAncrePixels; var R,G,B,L : Byte);
      procedure _setCoord(var _current : TAncrePixels; var x,y : integer);
      procedure _getPixel(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte);
      procedure _get(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
      procedure _getCoefs(var _current : TAncrePixels; var coefs : TCoefSatDSat);
      procedure _create(var _current : TAncrePixels);
      procedure _clearall(var _current : TAncrePixels);
      procedure _next(var _current : TAncrePixels);
      procedure _previous(var _current : TAncrePixels);
      function _isEnd(var _current : TAncrePixels) : boolean;
    public
      _width, _height : integer; // Taille de l'image
      IOO : TAncrePixels; // Teinte [R:255,G:0,B:0]
      IOORGB : T_SumRGB;  // Teinte moyenne;
      IIO : TAncrePixels; // Teinte [R:255,G:255,B:0]
      IIORGB : T_SumRGB;  // Teinte moyenne;
      OIO : TAncrePixels; // Teinte [R:0,G:255,B:0]
      OIORGB : T_SumRGB;  // Teinte moyenne;
      OII : TAncrePixels; // Teinte [R:0,G:255,B:255]
      OIIRGB : T_SumRGB;  // Teinte moyenne;
      OOI : TAncrePixels; // Teinte [R:0,G:0,B:255]
      OOIRGB : T_SumRGB;  // Teinte moyenne;
      IOI : TAncrePixels; // Teinte [R:255,G:0,B:255]
      IOIRGB : T_SumRGB;  // Teinte moyenne;
      III : TAncrePixels; // Teinte Blanc, gris, noir (achromatique)
      IIIRGB : T_SumRGB;  // Teinte moyenne;
      _nbPix : LongInt;   // Nombre total de pixels constituants l'image (pour la barre de progression des traitements)
      constructor Create();
      destructor Destroy;
      procedure Clear;
      procedure IOO_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure IOO_SetPixel(var x,y : integer; var R,G,B,L : Byte); // Recalcul es coefs de sat et dsat
      procedure IOO_SetCoord(var x,y : integer); // Pour rotations et permutations
      procedure IOO_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
      procedure IOO_MoveNext;
      procedure IOO_MovePrevious;
      function IOO_isEnd() : boolean;
      procedure IIO_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure IIO_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure IIO_SetCoord(var x,y : integer); // Pour rotations et permutations
      procedure IIO_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
      procedure IIO_MoveNext;
      procedure IIO_MovePrevious;
      function IIO_isEnd() : boolean;
      procedure OIO_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure OIO_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure OIO_SetCoord(var x,y : integer); // Pour rotations et permutations
      procedure OIO_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
      procedure OIO_MoveNext;
      procedure OIO_MovePrevious;
      function OIO_isEnd() : boolean;
      procedure OII_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure OII_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure OII_SetCoord(var x,y : integer); // Pour rotations et permutations
      procedure OII_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
      procedure OII_MoveNext;
      procedure OII_MovePrevious;
      function OII_isEnd() : boolean;
      procedure OOI_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure OOI_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure OOI_SetCoord(var x,y : integer); // Pour rotations et permutations
      procedure OOI_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
      procedure OOI_MoveNext;
      procedure OOI_MovePrevious;
      function OOI_isEnd() : boolean;
      procedure IOI_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure IOI_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure IOI_SetCoord(var x,y : integer); // Pour rotations et permutations
      procedure IOI_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
      procedure IOI_MoveNext;
      procedure IOI_MovePrevious;
      function IOI_isEnd() : boolean;
      procedure III_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure III_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure III_SetCoord(var x,y : integer); // Pour rotations et permutations
      procedure III_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
      procedure III_MoveNext;
      procedure III_MovePrevious;
      function III_isEnd() : boolean;
      procedure IOO_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
      procedure IIO_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
      procedure OIO_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
      procedure OII_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
      procedure OOI_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
      procedure IOI_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
      procedure III_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
      procedure copyImageIntoTImage (var Image : TImage; _ioo,_iio,_oio,_oii,_ooi,_ioi,_iii : boolean);
      procedure getImageFromTImage (var Image : TImage);
  end;

implementation

// TListPixels
// Private methods
procedure TListPixels._setPixel(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte); // modif des sat et dsat
begin
  if _current._current <> nil then begin
    _current._current^.setPix(x,y,R,G,B,L);
  end;
end;

procedure TListPixels._setColor(var _current : TAncrePixels; var R,G,B,L : Byte); // sans modif des sat et dsat
begin
  if _current._current <> nil then
    _current._current^.setColor(R,G,B,L);
end;

procedure TListPixels._setCoord(var _current : TAncrePixels; var x,y : integer);
begin
  if _current._current <> nil then
    _current._current^.setCoord(x,y);
end;


procedure TListPixels._getPixel(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte);
var coefs : TCoefSatDSat;
begin
  if _current._current <> nil then
    _current._current^.getPix(x,y,R,G,B,L,coefs);
end;

procedure TListPixels._getCoefs(var _current : TAncrePixels; var coefs : TCoefSatDSat);
begin
  if _current._current <> nil then
    _current._current^.getCoef(coefs);
end;

procedure TListPixels._get(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
begin
  if _current._current <> nil then
    _current._current^.getPix(x,y,R,G,B,L,coefs);
end;

procedure TListPixels._next(var _current : TAncrePixels);
begin
  if _current._current <> nil then
    _current._current := _current._current^._next;
end;

procedure TListPixels._previous(var _current : TAncrePixels);
begin
  if _current._current <> nil then
    _current._current := _current._current^._previous;
end;

function TListPixels._isEnd(var _current : TAncrePixels) : boolean;
begin
  if _current._current <> nil then
    _isEnd := _current._current^._next = nil
  else _isEnd := true;
end;

procedure TListPixels._create(var _current : TAncrePixels);
begin
  with _current do begin
      nbPixels := 0;
      List := nil;
      _current := nil;
  end;
end;

procedure TListPixels._clearall(var _current : TAncrePixels);
begin
  if _current.List <> nil then begin
    _current.List^.DestroyAllNext;
    _current.List^.Destroy;
    dispose(_current.List);
  end;
  _current.List := nil;
  _current._current := nil;
  _current.nbPixels := 0;
end;

procedure TListPixels._add(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte);
var _pt, __next, __prev, _lprev, _lnext : PTDynPix ;
begin
  _pt := nil;
  // Creation du nouveau maillon
  new(_pt);
  if _pt = nil then exit;
  _pt^ := TDynPix.Create(x,y,R,G,B,L);
  _pt^.setNearDynPix(nil, _current.List);
  // Mise à jour de l'ancre (pointeur sur le premier maillon de la liste)
  _current.List := _pt;
  // Mise à jour du pointeur courant (celui qui navigue de maillon en maillon)
  _current._current := _current.List;
  inc(_current.nbPixels);
end;


// Public methods.
constructor TListPixels.Create();
begin
  _create(IOO);
  with IOORGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _create(IIO);
  with IIORGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _create(OIO);
  with OIORGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _create(OII);
  with OIIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _create(OOI);
  with OOIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _create(IOI);
  with IOIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _create(III);
  with IIIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _nbPix := 0;
end;

destructor TListPixels.Destroy;
begin
  _clearall(IOO);
  with IOORGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _clearall(IIO);
  with IIORGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _clearall(OIO);
  with OIORGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _clearall(OII);
  with OIIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _clearall(OOI);
  with OOIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _clearall(IOI);
  with IOIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _clearall(III);
  with IIIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  _nbPix := 0;
  inherited;
end;

procedure TListPixels.Clear;
begin
  _clearall(IOO);
  _clearall(IIO);
  _clearall(OIO);
  _clearall(OII);
  _clearall(OOI);
  _clearall(IOI);
  _clearall(III);
  _nbPix := 0;
  with IOORGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  with IIORGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  with OIORGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  with OIIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  with OOIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  with IOIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
  with IIIRGB do
  begin
      _SR := 0;
      _SG := 0;
      _SB := 0;
      _nbPix := 0;
  end;
end;

procedure TListPixels.IOO_Add(var x,y : integer; var R,G,B,L : Byte);
begin
  _add(IOO, x,y,R,G,B,L);
  with IOORGB do
  begin
      _SR := _SR + R;
      _SG := _SG + G;
      _SB := _SB + B;
      _nbPix := _nbPix +1;
  end;
end;


procedure TListPixels.IOO_SetPixel(var x,y : integer; var R,G,B,L : Byte);
var _R, _G, _B, _L : Byte;
  _x, _y : integer;
begin
  _getPixel(IOO,_x, _y, _R,_G,_B,_L);
  _setPixel(IOO,x,y,R,G,B,L);
  with IOORGB do
  begin
      // On remplace l'ancienne valeur du pixel par la nouvelle
      _SR := _SR - _R + R;
      _SG := _SG - _G + G;
      _SB := _SB - _B + B;
  end;
end;


procedure TListPixels.IOO_SetCoord(var x,y : integer); // Pour rotations et permutations
begin
  _setCoord(IOO,x,y);
end;

procedure TListPixels.IOO_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
begin
   _setColor(IOO,R,G,B,L);
end;


procedure TListPixels.IOO_MoveNext;
begin
  _next(IOO);
end;

procedure TListPixels.IOO_MovePrevious;
begin
  _previous(IOO);
end;

function TListPixels.IOO_isEnd() : boolean;
begin
  IOO_isEnd := _isEnd(IOO);
end;

procedure TListPixels.IIO_Add(var x,y : integer; var R,G,B,L : Byte);
begin
  _add(IIO,x,y,R,G,B,L);
  with IIORGB do
  begin
      _SR := _SR + R;
      _SG := _SG + G;
      _SB := _SB + B;
      _nbPix := _nbPix +1;
  end;
end;


procedure TListPixels.IIO_SetPixel(var x,y : integer; var R,G,B,L : Byte);
var _R,_G,_B,_L : Byte;
  _x,_y : integer;
begin
  _getPixel(IIO,_x, _y, _R,_G,_B,_L);
  _setPixel(IIO,x,y,R,G,B,L);
  with IIORGB do
  begin
      // On remplace l'ancienne valeur du pixel par la nouvelle
      _SR := _SR - _R + R;
      _SG := _SG - _G + G;
      _SB := _SB - _B + B;
  end;
end;

procedure TListPixels.IIO_SetCoord(var x,y : integer); // Pour rotations et permutations
begin
  _setCoord(IIO,x,y);
end;

procedure TListPixels.IIO_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
begin
   _setColor(IIO,R,G,B,L);
end;


procedure TListPixels.IIO_MoveNext;
begin
  _next(IIO);
end;

procedure TListPixels.IIO_MovePrevious;
begin
  _previous(IIO);
end;

function TListPixels.IIO_isEnd() : boolean;
begin
  IIO_isEnd := _isEnd(IIO);
end;

procedure TListPixels.OIO_Add(var x,y : integer; var R,G,B,L : Byte);
begin
  _add(OIO,x,y,R,G,B,L);
  with OIORGB do
  begin
      _SR := _SR + R;
      _SG := _SG + G;
      _SB := _SB + B;
      _nbPix := _nbPix +1;
  end;
end;


procedure TListPixels.OIO_SetPixel(var x,y : integer; var R,G,B,L : Byte);
var _R,_G,_B,_L : Byte;
  _x,_y : integer;
begin
  _getPixel(IOI,_x, _y, _R,_G,_B,_L);
  _setPixel(IOI,x,y,R,G,B,L);
  with IOIRGB do
  begin
      // On remplace l'ancienne valeur du pixel par la nouvelle
      _SR := _SR - _R + R;
      _SG := _SG - _G + G;
      _SB := _SB - _B + B;
  end;
end;

procedure TListPixels.OIO_SetCoord(var x,y : integer); // Pour rotations et permutations
begin
  _setCoord(OIO,x,y);
end;

procedure TListPixels.OIO_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
begin
   _setColor(OIO,R,G,B,L);
end;


procedure TListPixels.OIO_MoveNext;
begin
  _next(OIO);
end;

procedure TListPixels.OIO_MovePrevious;
begin
  _previous(OIO);
end;

function TListPixels.OIO_isEnd() : boolean;
begin
  OIO_isEnd := _isEnd(OIO);
end;

procedure TListPixels.OII_Add(var x,y : integer; var R,G,B,L : Byte);
begin
  _add(OII,x,y,R,G,B,L);
  with OIIRGB do
  begin
      _SR := _SR + R;
      _SG := _SG + G;
      _SB := _SB + B;
      _nbPix := _nbPix +1;
  end;
end;

procedure TListPixels.OII_SetPixel(var x,y : integer; var R,G,B,L : Byte);
var _R,_G,_B,_L : Byte;
  _x,_y : integer;
begin
  _getPixel(OII,_x, _y, _R,_G,_B,_L);
  _setPixel(OII,x,y,R,G,B,L);
  with OIIRGB do
  begin
      // On remplace l'ancienne valeur du pixel par la nouvelle
      _SR := _SR - _R + R;
      _SG := _SG - _G + G;
      _SB := _SB - _B + B;
  end;
end;

procedure TListPixels.OII_SetCoord(var x,y : integer); // Pour rotations et permutations
begin
  _setCoord(OII,x,y);
end;

procedure TListPixels.OII_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
begin
   _setColor(OII,R,G,B,L);
end;

procedure TListPixels.OII_MoveNext;
begin
  _next(OII);
end;

procedure TListPixels.OII_MovePrevious;
begin
  _previous(OII);
end;

function TListPixels.OII_isEnd() : boolean;
begin
  OII_isEnd := _isEnd(OII);
end;

procedure TListPixels.OOI_Add(var x,y : integer; var R,G,B,L : Byte);
begin
  _add(OOI,x,y,R,G,B,L);
  with OOIRGB do
  begin
      _SR := _SR + R;
      _SG := _SG + G;
      _SB := _SB + B;
      _nbPix := _nbPix +1;
  end;
end;


procedure TListPixels.OOI_SetPixel(var x,y : integer; var R,G,B,L : Byte);
var _R,_G,_B,_L : Byte;
  _x,_y : integer;
begin
  _getPixel(OOI,_x, _y, _R,_G,_B,_L);
  _setPixel(OOI,x,y,R,G,B,L);
  with OOIRGB do
  begin
      // On remplace l'ancienne valeur du pixel par la nouvelle
      _SR := _SR - _R + R;
      _SG := _SG - _G + G;
      _SB := _SB - _B + B;
  end;
end;

procedure TListPixels.OOI_SetCoord(var x,y : integer); // Pour rotations et permutations
begin
  _setCoord(OOI,x,y);
end;

procedure TListPixels.OOI_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
begin
   _setColor(OOI,R,G,B,L);
end;

procedure TListPixels.OOI_MoveNext;
begin
  _next(OOI);
end;

procedure TListPixels.OOI_MovePrevious;
begin
  _previous(OOI);
end;

function TListPixels.OOI_isEnd() : boolean;
begin
  OOI_isEnd := _isEnd(OOI);
end;

procedure TListPixels.IOI_Add(var x,y : integer; var R,G,B,L : Byte);
begin
  _add(IOI,x,y,R,G,B,L);
  with IOIRGB do
  begin
      _SR := _SR + R;
      _SG := _SG + G;
      _SB := _SB + B;
      _nbPix := _nbPix +1;
  end;
end;

procedure TListPixels.IOI_SetPixel(var x,y : integer; var R,G,B,L : Byte);
var _R,_G,_B,_L : Byte;
  _x,_y : integer;
begin
  _getPixel(IOI,_x, _y, _R,_G,_B,_L);
  _setPixel(IOI,x,y,R,G,B,L);
  with IOIRGB do
  begin
      // On remplace l'ancienne valeur du pixel par la nouvelle
      _SR := _SR - _R + R;
      _SG := _SG - _G + G;
      _SB := _SB - _B + B;
  end;
end;

procedure TListPixels.IOI_SetCoord(var x,y : integer); // Pour rotations et permutations
begin
  _setCoord(IOI,x,y);
end;

procedure TListPixels.IOI_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
begin
   _setColor(IOI,R,G,B,L);
end;

procedure TListPixels.IOI_MoveNext;
begin
  _next(IOI);
end;

procedure TListPixels.IOI_MovePrevious;
begin
  _previous(IOI);
end;

function TListPixels.IOI_isEnd() : boolean;
begin
  IOI_isEnd := _isEnd(IOI);
end;

procedure TListPixels.III_Add(var x,y : integer; var R,G,B,L : Byte);
begin
  _add(III,x,y,R,G,B,L);
  with IIIRGB do
  begin
      _SR := _SR + R;
      _SG := _SG + G;
      _SB := _SB + B;
      _nbPix := _nbPix +1;
  end;
end;

procedure TListPixels.III_SetPixel(var x,y : integer; var R,G,B,L : Byte);
var _R,_G,_B,_L : Byte;
  _x,_y : integer;
begin
  _getPixel(III,_x, _y, _R,_G,_B,_L);
  _setPixel(III,x,y,R,G,B,L);
  with IIIRGB do
  begin
      // On remplace l'ancienne valeur du pixel par la nouvelle
      _SR := _SR - _R + R;
      _SG := _SG - _G + G;
      _SB := _SB - _B + B;
  end;
end;

procedure TListPixels.III_SetCoord(var x,y : integer); // Pour rotations et permutations
begin
  _setCoord(III,x,y);
end;

procedure TListPixels.III_SetColor(var R,G,B,L : Byte); // Ne recalcul pas les coefs de sat et dsat
begin
   _setColor(III,R,G,B,L);
end;

procedure TListPixels.III_MoveNext;
begin
  _next(III);
end;

procedure TListPixels.III_MovePrevious;
begin
  _previous(III);
end;

function TListPixels.III_isEnd() : boolean;
begin
  III_isEnd := _isEnd(III);
end;

procedure TListPixels.IOO_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
begin
  _get(IOO,x,y,R,G,B,L,coefs);
end;

procedure TListPixels.IIO_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
begin
  _get(IIO,x,y,R,G,B,L,coefs);
end;

procedure TListPixels.OIO_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
begin
  _get(OIO,x,y,R,G,B,L,coefs);
end;

procedure TListPixels.OII_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
begin
  _get(OII,x,y,R,G,B,L,coefs);
end;


procedure TListPixels.OOI_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
begin
  _get(OOI,x,y,R,G,B,L,coefs);
end;

procedure TListPixels.IOI_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
begin
  _get(IOI,x,y,R,G,B,L,coefs);
end;

procedure TListPixels.III_Get(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
begin
  _get(III,x,y,R,G,B,L,coefs);
end;

procedure TListPixels.copyImageIntoTImage (var Image : TImage; _ioo,_iio,_oio,_oii,_ooi,_ioi,_iii : boolean);
var
  Bmp : TBitmap; // Utile pour travailler sur une image non affichée. Gains en tems de traitement
  x, y : integer;
  R,G,B,L : Byte;
  coefs : TCoefSatDSat;
  color : TColor;
  compteur : LongInt;
begin
  // Initialisation de la bitmap de sortie
  // Création de l'image de travail
  Bmp := TBitmap.Create();
  Bmp.Width := self._width;
  Bmp.Height := self._height;
  Bmp.RawImage.CreateData(true);

  // La lecture de l'image en mémoire s'effectue via 7 listes chaînées.
  // 1 Traitement des pixels de teinte IOO
  // - Initialisation du pointeur de maillon avec le pointeur de l'ancre
  if _ioo then begin
    compteur := 0;
    IOO._current := IOO.List;
    while (IOO._current <> nil) do begin
      // Lecture du pixel
      IOO_Get(x,y, R,G,B,L,coefs);
      // Application de la luminance (normalement 255)
      R := (R*L) div 255;
      G := (G*L) div 255;
      B := (B*L) div 255;
      // Transformation en TColor
      color := RGBToColor(R,G,B);
      // Ecriture du pixel dans la bitmap
      Bmp.Canvas.Pixels[x,y] := color;
      // Enchaînement sur le pixel suivant
      IOO_MoveNext;
      // progression
      inc(compteur);
      if (compteur mod 1500 = 0)then
        ProgressWindow.setProgressInc(compteur/IOO.nbPixels/7*100);
    end;
  end;
  ProgressWindow.SetProgressInc(1/7*100);
  // 2 Traitement des pixels de teinte IIO
  // - Initialisation du pointeur de maillon avec le pointeur de l'ancre
  if _iio then begin
    compteur := 0;
    IIO._current := IIO.List;
    while (IIO._current <> nil) do begin
      // Lecture du pixel
      IIO_Get(x,y, R,G,B,L,coefs);
      // Application de la luminance (normalement 255)
      R := (R*L) div 255;
      G := (G*L) div 255;
      B := (B*L) div 255;
      // Transformation en TColor
      color := RGBToColor(R,G,B);
      // Ecriture du pixel dans la bitmap
      Bmp.Canvas.Pixels[x,y] := color;
      // Enchaînement sur le pixel suivant
      IIO_MoveNext;
      inc(compteur);
      if (compteur mod 1500 = 0)then
        ProgressWindow.setProgressInc(((compteur/IIO.nbPixels/7)+1/7)*100);
    end;
  end;
  ProgressWindow.SetProgressInc(2/7*100);
  // 3 Traitement des pixels de teinte OIO
  // - Initialisation du pointeur de maillon avec le pointeur de l'ancre
  if _oio then begin
    compteur := 0;
    OIO._current := OIO.List;
    while (OIO._current <> nil) do begin
      // Lecture du pixel
      OIO_Get(x,y, R,G,B,L,coefs);
      // Application de la luminance (normalement 255)
      R := (R*L) div 255;
      G := (G*L) div 255;
      B := (B*L) div 255;
      // Transformation en TColor
      color := RGBToColor(R,G,B);
      // Ecriture du pixel dans la bitmap
      Bmp.Canvas.Pixels[x,y] := color;
      // Enchaînement sur le pixel suivant
      OIO_MoveNext;
      inc(compteur);
      if (compteur mod 1500 = 0)then
        ProgressWindow.setProgressInc(((compteur/OIO.nbPixels/7)+2/7)*100);
   end;
  end;
  ProgressWindow.SetProgressInc(3/7*100);
  // 4 Traitement des pixels de teinte OII
  // - Initialisation du pointeur de maillon avec le pointeur de l'ancre
  if _oii then begin
    compteur := 0;
    OII._current := OII.List;
    while (OII._current <> nil) do begin
      // Lecture du pixel
      OII_Get(x,y,R,G,B,L,coefs);
      // Application de la luminance (normalement 255)
      R := (R*L) div 255;
      G := (G*L) div 255;
      B := (B*L) div 255;
      // Transformation en TColor
      color := RGBToColor(R,G,B);
      // Ecriture du pixel dans la bitmap
      Bmp.Canvas.Pixels[x,y] := color;
      // Enchaînement sur le pixel suivant
      OII_MoveNext;
      inc(compteur);
      if (compteur mod 1500 = 0)then
        ProgressWindow.setProgressInc(((compteur/OII.nbPixels/7)+3/7)*100);
    end;
  end;
  ProgressWindow.SetProgressInc(4/7*100);
  // 5 Traitement des pixels de teinte OOI
  // - Initialisation du pointeur de maillon avec le pointeur de l'ancre
  if _ooi then begin
    compteur := 0;
    OOI._current := OOI.List;
    while (OOI._current <> nil) do begin
      // Lecture du pixel
      OOI_Get(x,y, R,G,B,L,coefs);
      // Application de la luminance (normalement 255)
      R := (R*L) div 255;
      G := (G*L) div 255;
      B := (B*L) div 255;
      // Transformation en TColor
      color := RGBToColor(R,G,B);
      // Ecriture du pixel dans la bitmap
      Bmp.Canvas.Pixels[x,y] := color;
      // Enchaînement sur le pixel suivant
      OOI_MoveNext;
      inc(compteur);
      if (compteur mod 1500 = 0)then
        ProgressWindow.setProgressInc(((compteur/OOI.nbPixels/7)+4/7)*100);
    end;
  end;
  ProgressWindow.SetProgressInc(5/7*100);
  // 6 Traitement des pixels de teinte IOI
  // - Initialisation du pointeur de maillon avec le pointeur de l'ancre
  if _ioi then begin
    compteur := 0;
    IOI._current := IOI.List;
    while (IOI._current <> nil) do begin
      // Lecture du pixel
      IOI_Get(x,y, R,G,B,L,coefs);
      // Application de la luminance (normalement 255)
      R := (R*L) div 255;
      G := (G*L) div 255;
      B := (B*L) div 255;
      // Transformation en TColor
      color := RGBToColor(R,G,B);
      // Ecriture du pixel dans la bitmap
      Bmp.Canvas.Pixels[x,y] := color;
      // Enchaînement sur le pixel suivant
      IOI_MoveNext;
      inc(compteur);
      if (compteur mod 1500 = 0)then
        ProgressWindow.setProgressInc(((compteur/IOI.nbPixels/7)+5/7)*100);
    end;
  end;
  ProgressWindow.SetProgressInc(6/7*100);
  // 7 Traitement des pixels de teinte III
  // - Initialisation du pointeur de maillon avec le pointeur de l'ancre
  if _iii then begin
    compteur :=0;
    III._current := III.List;
    while (III._current <> nil) do begin
      // Lecture du pixel
      III_Get(x,y, R,G,B,L,coefs);
      // Application de la luminance (normalement 255)
      R := (R*L) div 255;
      G := (G*L) div 255;
      B := (B*L) div 255;
      // Transformation en TColor
      color := RGBToColor(R,G,B);
      // Ecriture du pixel dans la bitmap
      Bmp.Canvas.Pixels[x,y] := color;
      // Enchaînement sur le pixel suivant
      III_MoveNext;
      inc(compteur);
      if (compteur mod 1500 = 0)then
        ProgressWindow.setProgressInc(((compteur/III.nbPixels/7)+6/7)*100);
    end;
  end;
  ProgressWindow.SetProgressInc(100);
  // Recopie de la Bitmap temporaire dans la bitmap affichée
  Image.Picture.Bitmap := Bmp;

  // Destruction de la bitmpa de travail
  Bmp.Destroy;

end;

procedure TListPixels.getImageFromTImage (var Image : TImage);
var i, j, x, y, indexTeinte : integer;
  color : TColor;
  R,G,B,L : Byte;
begin
  // Suppression de la précédente image si elle existait
  self.Clear;
  // Initialisation
  // - Taille de l'image
  self._width := Image.Picture.Bitmap.Width;
  self._height := Image.Picture.Bitmap.Height;
  L:=255;
  // Boucle de lecture de l'image source
  // - Il est nécessaire re recopier les valeurs de i et de j dans des
  //   variables locales, car les paramètres sont passés par adresses aux procédures
  //   et aux fonctions.
  for i := 0 to self._height - 1 do begin
      y := i;
      for j := 0 to self._width - 1 do begin
          x := j;
          // Lecture du pixel de l'image
          color := Image.Picture.Bitmap.Canvas.Pixels[j,i];
          R := Red(color);
          G := Green(color);
          B := Blue(color);
          // Détection de la teinte
          indexTeinte := TSL_getTeinteIndex(R,G,B);
          case indexTeinte of
            1 : self.IOO_Add(x,y,R,G,B,L);
            2 : self.IIO_Add(x,y,R,G,B,L);
            3 : self.OIO_Add(x,y,R,G,B,L);
            4 : self.OII_Add(x,y,R,G,B,L);
            5 : self.OOI_Add(x,y,R,G,B,L);
            6 : self.IOI_Add(x,y,R,G,B,L);
            7 : self.III_Add(x,y,R,G,B,L);
          end;
          inc(self._nbPix);
      end;
      if (y mod 10 = 0) then ProgressWindow.setProgressInc(i/self._height*100);
  end;
end;

// TDynPix
constructor TDynPix.Create();
begin
  _next := nil;
  _previous := nil;
  with _pixel do begin
      _R:=0;
      _G:=0;
      _B:=0;
      _L:=0;
  end;
  with _satcoef do begin
      sat.r := 0;
      sat.g := 0;
      sat.b := 0;
{
      dsat.r := 0;
      dsat.g := 0;
      dsat.b := 0;
}
  end;
end;

constructor TDynPix.Create(x,y : integer; R,G,B,L : Byte);
begin
  _next := nil;
  _previous := nil;
  with _pixel do begin
      _R:=R;
      _G:=G;
      _B:=B;
      _L:=L;
      _x := x;
      _y := y;
  end;
  _satcoef := TSL_getSATCoef((R*L)div 255,(G*L)div 255, (B*L) div 255);
end;

destructor TDynPix.Destroy;
begin
  inherited;
end;


procedure TDynPix.getPix(var x,y : integer; var R,G,B,L : Byte; var coefs : TCoefSatDSat);
begin
  with _pixel do begin
      x := _x;
      y := _y;
      R := _R;
      G := _G;
      B := _B;
      L := _L;
      with _satcoef do
      begin
          coefs.sat.r := sat.r ;
          coefs.sat.g := sat.g ;
          coefs.sat.b := sat.b ;
{
          coefs.dsat.r := dsat.r ;
          coefs.dsat.g := dsat.g ;
          coefs.dsat.b := dsat.b ;
}
      end;
  end;
end;


procedure TDynPix.setPix(var x,y : integer; var R,G,B,L : Byte); // modif des sat et dsat
begin
  with _pixel do begin
      _x := x;
      _y := y;
      _R := R;
      _G := G;
      _B := B;
      _L := L;
  end;
  _satcoef := TSL_getSATcoef((R*L) div 255,(G*L) div 255,(B*L) div 255);
end;

procedure TDynPix.setCoord(var x,y : integer);
begin
  with _pixel do begin
      _x := x;
      _y := y;
  end;
end;

procedure TDynPix.getCoord(var x,y : integer);
begin
  with _pixel do begin
      x := _x;
      y := _y;
  end;
end;

procedure TDynPix.getCoef(var coefs : TCoefSatDSat);
begin
  with coefs do begin
      sat.r := _satcoef.sat.r ;
      sat.g := _satcoef.sat.g ;
      sat.b := _satcoef.sat.b ;
{
      dsat.r := _satcoef.dsat.r ;
      dsat.g := _satcoef.dsat.g ;
      dsat.b := _satcoef.dsat.b;
}
  end;
end;

procedure TDynPix.setColor(var R,G,B,L : Byte) ; // sans maj des coef sat et dsat
begin
  with _pixel do
  begin
    _R := R;
    _G := G;
    _B := B;
    _L := L;
  end;
end;

procedure TDynPix.getColor(var R,G,B,L : Byte) ;
begin
  with _pixel do
  begin
    R := _R;
    G := _G;
    B := _B;
    L := _L;
  end;
end;

procedure TDynPix.getNearDynPix (var prev,next : PTDynPix);
begin
  prev := self._previous;
  next := self._next;
end;

procedure TDynPix.setNearDynPix (prev,next : PTDynPix);
begin
  self._previous := prev ;
  self._next := next;
end;

procedure TDynPix.DestroyAllNext;
var _pt, _ptnext : PTDynPix;
begin
  // Boucle pour supprimer tous les maillons
  //  Initialisation de la boucle
  _pt := self._next;
  // boucle sur _pt
  while _pt <> nil do begin
    _ptnext := _pt^._next;
    _pt^.Destroy;
    dispose(_pt);
    _pt := _ptnext;
  end;
end;


// TMemoryPix
constructor TMemoryPix.Create();
begin
  isData := false;
  pwidth := 0;
  pheight := 0;
end;

constructor TMemoryPix.Create(width, height : integer; zeroinit : boolean);
var MySize, i : integer;
  buff : PByte;
begin
  isData := false;
  // Calcul de la taille mémoire nécessaire
  MySize := self.memorysize(width, height);
  // Allocation de la mémoire dynamique
  memoryBuff := TMemoryStream.Create();
  memoryBuff.SetSize(MySize);
  isData := true;
  pwidth := width;
  pheight := height;
  // Init de la mémoire
  if zeroinit then begin
    buff := PByte(memoryBuff.Memory)-1;
    for i:=0 to MySize div 4 do
    begin
      inc(buff);
      buff^:=Byte(0);   // Blue
      inc(buff);
      buff^:=Byte(0);   // Red
      inc(buff);
      buff^:=Byte(0);   // Green
      inc(buff);
      buff^:=Byte(255); // Luminance
    end;
  end;
end;

constructor TMemoryPix.Create(width, height : integer; color : TColor);
var MySize, i : integer;
  buff : PByte;
  vred, vgreen, vblue : Byte;
begin
  isData := false;
  // Calcul de la taille mémoire nécessire
  MySize := self.memorysize(width, height);
  // Allocation de la mémoire dynamique
  memoryBuff := TMemoryStream.Create();
  memoryBuff.SetSize(MySize);
  isData := true;
  pwidth := width;
  pheight := height;
  // Init de la mémoire
  buff := PByte(memoryBuff.Memory)-1;
  // Optention des valeurs RGB de la couleur d'initialisation
  vred:=red(color);
  vblue:=blue(color);
  vgreen:=green(color);
  for i:=0 to MySize div 4 do
    begin
      inc(buff);
      buff^:=vblue;         // Blue
      inc(buff);
      buff^:=vGreen;        // Green
      inc(buff);
      buff^:=vred;          // Red
      inc(buff);
      buff^:=Byte(255);     // Luminance
    end;
end;

constructor TMemoryPix.Create(width, height : integer; R,G,B,L : Byte);
var MySize, i : integer;
  buff : PByte;
  vred, vgreen, vblue : Byte;
begin
  isData := false;
  // Calcul de la taille mémoire nécessire
  MySize := self.memorysize(width, height);
  // Allocation de la mémoire dynamique
  memoryBuff := TMemoryStream.Create();
  memoryBuff.SetSize(MySize);
  isData := true;
  pwidth := width;
  pheight := height;
  // Init de la mémoire
  buff := PByte(memoryBuff.Memory)-1;
  for i:=0 to MySize div 4 do
    begin
      inc(buff);
      buff^:=B;     // Blue
      inc(buff);
      buff^:=G;     // Green
      inc(buff);
      buff^:=R;     // Red
      inc(buff);
      buff^:=L;     // Luminance
    end;
end;

constructor TMemoryPix.Create(var Image : TImage) ;
var
  PixHeight, PixWidth,i, j : integer;
  SourcePixelWidth : integer;
  ScanLine, Dest : PByte;
  SourceLineWidth : integer;
  MySize : integer;
  R, G, B, L : Byte;
  color : TColor;
begin
  isData := false;
  // Reading source width and height
  PixHeight := Image.Picture.Height;
  PixWidth := Image.Picture.Width;
  // Reading source Pixel width and source line width
  //SourceLineWidth := Image.Picture.Bitmap.RawImage.Description.BytesPerLine ;
  //SourcePixelWidth := Image.Picture.Bitmap.RawImage.Description.BitsPerPixel div 8;
  // Calc of buffer size for 32bits per pixels sRGB
  MySize := self.memorysize(PixWidth, PixHeight);
  // Create buffer for internal picture
  memoryBuff := TMemoryStream.Create();
  memoryBuff.setSize(MySize);
  isData := true;
  pwidth := PixWidth;
  pheight := PixHeight;
  // Pointer on picture data
  //ScanLine := Image.Picture.Bitmap.RawImage.Data-1;
  // Pointer to the memorystring area
  Dest := PByte(memoryBuff.Memory)-1;
  // Copy source into internal pix
  for i := 0 to PixHeight - 1 do begin
    for j := 0 to PixWidth - 1 do
      begin
          L := 255;
          color := Image.Picture.Bitmap.Canvas.Pixels[j,i];
          B := Blue(color);
          R := Red(color);
          G := Green(color);
          // Copy into memorystream
          // Blue
          inc(Dest);
          Dest^ := B;
          // Green
          inc (Dest);
          Dest^ := G;
          // Red
          inc (Dest);
          Dest^ := R;
          // Luminance (in all cases)
          inc (Dest);
          Dest^ := L;
      end;
    if i mod 150 = 0 then ProgressWindow.SetProgressInc(i/(PixHeight-1)*100);
  end;
end;

destructor TMemoryPix.Destroy;
begin
  if isData then memoryBuff.Destroy;
  isData := false;
  inherited;
end;

function TMemoryPix.memorysize(width, height : integer) : integer;
begin
  memorysize := width * 4 * height;
end;

procedure TMemoryPix.getImageSize(var width, height : integer);
begin
  if isData then
  begin
    width := pwidth;
    height := pheight;
  end else
  begin
      width := 0;
      height := 0;
  end;
end;

procedure TMemoryPix.getPixel(x, y : integer; var R, G, B : Byte);
var R1, G1, B1, L : integer;
  pixel : PByte;
begin
  if not isData then begin
    R := 0; G := 0; B := 0;
    exit;
  end;
  if (x<0) or (x>pwidth) or (y<0) or (y>pheight) then begin
    R := 0; G := 0; B := 0;
    exit;
  end;
  pixel := getPixelPos(x,y);
  B1 := integer(pixel^);
  inc(pixel);
  G1 := integer(pixel^);
  inc(pixel);
  R1 := integer(pixel^);
  inc(pixel);
  // Il faut tenir compte de la luminance
  L := integer(pixel^) div 255;
  R := Byte(R1 * L);
  G := Byte(G1 * L);
  B := Byte(B1 * L);
end;

procedure TMemoryPix.getPixel(x, y : integer; var R, G, B, L : Byte);
var pixel : PByte;
begin
  if not isData then begin
    R := 0;
    G := 0;
    B := 0;
    L := 0;
    exit;
  end;
  if (x<0) or (x>pwidth) or (y<0) or (y>pheight) then begin
    R := 0; G := 0; B := 0; L := 0;
    exit;
  end;
  pixel := getPixelPos(x,y);
  B := pixel^;
  inc(pixel);
  G := pixel^;
  inc(pixel);
  R := pixel^;
  inc(pixel);
  L := pixel^
end;

 procedure TMemoryPix.getPixel(x, y : integer; var color : TColor);
var R, G, B : Byte;
begin
   if not isData then begin
     color := RGBToColor(0,0,0);
     exit;
   end;
   if (x<0) or (x>pwidth) or (y<0) or (y>pheight) then begin
     color := RGBToColor(0,0,0);
     exit;
   end;

   getPixel(x,y,R,G,B);
   color := RGBToColor(R,G,B);
end;

procedure TMemoryPix.getPixel(x, y : integer; var color : TColor; var L : Byte);
var R, G, B : Byte;
begin
  if not isData then begin
    L := 0;
    color := RGBToColor(0,0,0);
    exit;
  end;
  if (x<0) or (x>pwidth) or (y<0) or (y>pheight) then begin
    color := RGBToColor(0,0,0);
    L:=0;
    exit;
  end;
  getPixel(x,y,R,G,B,L);
  color := RGBToColor(R,G,B);
end;

procedure TMemoryPix.setPixel(x, y : integer; R, G, B : Byte);
var
  pixel : PByte;
begin
  if isData then begin
    if (x<0) or (x>pwidth) or (y<0) or (y>pheight) then exit;
    pixel := getPixelPos(x,y);
    pixel^ := B ;
    inc(pixel);
    pixel^ := G ;
    inc(pixel);
    pixel^ := R;
    inc(pixel);
    pixel^ := 255; // Initialisation de la luminance
  end;
end;

procedure TMemoryPix.setPixel(x, y : integer; R, G, B, L : Byte);
var
  pixel : PByte;
begin
  if isData then begin
    if (x<0) or (x>pwidth) or (y<0) or (y>pheight) then exit;
    pixel := getPixelPos(x,y);
    pixel^ := B;
    inc(pixel);
    pixel^ := G;
    inc(pixel);
    pixel^ := R;
    inc(pixel);
    pixel^ := L;
  end;
end;

procedure TMemoryPix.setPixel(x, y : integer; color : TColor);
var
  pixel : PByte;
begin
  if isData then begin
    if (x<0) or (x>pwidth) or (y<0) or (y>pheight) then exit;
    pixel := getPixelPos(x,y);
    pixel^ := Byte(blue(color));
    inc(pixel);
    pixel^ := Byte(green(color));
    inc(pixel);
    pixel^ := Byte(red(color));
    inc(pixel);
    pixel^ := Byte(255);
  end;
end;

procedure TMemoryPix.setPixel(x, y : integer; color : TColor; L : Byte);
var
  pixel : PByte;
begin
  if isData then begin
    if (x<0) or (x>pwidth) or (y<0) or (y>pheight) then exit;
    pixel := getPixelPos(x,y);
    pixel^ := Byte(blue(color));
    inc(pixel);
    pixel^ := Byte(green(color));
    inc(pixel);
    pixel^ := Byte(red(color));
    inc(pixel);
    pixel^ := L;
  end;
end;

function TMemoryPix.getPixelPos(x, y : integer) : PByte;
begin
  if not isData then getPixelPos := nil else
    getPixelPos := memoryBuff.Memory + (pwidth * 4 * y) + 4 * x;
end;

procedure TMemoryPix.copyImageIntoTImage (var Image : TImage);
var
  Dest : PByte;
  R, G, B, L : Byte;
  i,j : integer;
  xend, yend : integer;
  // Utilisation d'une bitmap intermédiaire non affichée.
  // Travailler directement sur l'image affichée est exponentiel
  // en temps de traitement. Travailler sur une bitmpa non affichée
  // rend les temps de traitements acceptables même pour des images
  // de 20 Méga Pixels en 32bits.
  Bmp : TBitmap;
begin
  if not isData then exit;
  // Copy internal pix into Dest pix
  // Set the destination size
  yend := self.pheight;
  xend := self.pwidth;
  // Création de l'image de travail
  Bmp := TBitmap.Create();
  Bmp.Width := xend;
  Bmp.Height := yend;
  //Bmp.PixelFormat := pf32bit;
  Bmp.RawImage.CreateData(true);
  Dest := PByte(memoryBuff.Memory)-1;
  // Copie des traitements dans l'image de travail
   for i := 0 to yend - 1 do begin
    for j := 0 to xend - 1 do
      begin
          // Blue
          inc(Dest);
          B := Dest^;
          // Green
          inc(Dest);
          G := Dest^;
          // Red
          inc(Dest);
          R := Dest^;
          // Luminance
          inc(Dest);
          L := Dest^;
          // Copy into destination pix
          Bmp.Canvas.Pixels[j,i] := RGBToColor(trunc(R*L/255),trunc(G*L/255),trunc(B*L/255));
      end;
     if i mod 50 = 0 then begin
       ProgressWindow.SetProgress(i/(pheight-1)*50 + 50);
     end;
   end;
   // Recopie dans l'image affichée
   Image.Picture.Bitmap := Bmp;
   // Libération des ressources de l'image de travail
   Bmp.Destroy;
end;

procedure TMemoryPix.getImageFromTImage(var Image : TImage);
//type
//  TIndexCouleur = 0..65535;
var
  PixHeight, PixWidth,i, j : integer;
  //SourcePixelWidth : integer;
  ScanLine, Dest : PByte;
  //SourceLineWidth : integer;
  MySize : integer;
  R, G, B, L : Byte;
  color : TColor;
begin
  if isData then begin
    memoryBuff.Destroy;
    memoryBuff := nil;
  end;
  PixHeight := Image.Picture.Height;
  PixWidth := Image.Picture.Width;
  // Calc of buffer size for 32bits per pixels sRGB
  MySize := self.memorysize(PixWidth, PixHeight);
  // Create buffer for internal picture
  memoryBuff := TMemoryStream.Create();
  memoryBuff.setSize(MySize);
  self.isData := true;
  self.pwidth := PixWidth;
  self.pheight := PixHeight;
  // Pointer on picture data
  ScanLine := Image.Picture.Bitmap.RawImage.Data-1;
  // Pointer to the memorystring area
  Dest := PByte(memoryBuff.Memory)-1;
  // Copy source into internal pix
  L := 255;
  for i := 0 to PixHeight - 1 do begin
    for j := 0 to PixWidth - 1 do
      begin
            // Copy into memorystream
            color := Image.Picture.Bitmap.Canvas.Pixels[j,i];
            B := Blue(color);
            R := Red(color);
            G := Green(color);
            // Blue
            inc(Dest);
            Dest^ := B;
            // Green
            inc (Dest);
            Dest^ := G;
            // Red
            inc (Dest);
            Dest^ := R;
            // Luminance (in all cases)
            inc (Dest);
            Dest^ := L;

      end;
    if i mod 150 = 0 then ProgressWindow.SetProgressInc(i/(PixHeight-1)*100);
  end;
end;



end.

