unit MemoryPix;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Graphics, ProgressWindows;

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

  T_SatCoefs = record
    _r_coef, _g_coef, _b_coef : real;
  end;

  T_PixelColor = record
    _R,_G,_B,_L : Byte
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
      _satcoef : T_SatCoefs;
      _x,_y : integer;
    public
      // Constructeurs des maillons
      constructor Create();
      constructor Create(x,y : integer; R,G,B,L : Byte);
      constructor Create(x,y : integer; R,G,B,L : Byte; cr,cg,cb : real);
      constructor Create(x,y : integer; R,G,B,L : Byte; prev,next : PTDynPix);
      constructor Create(x,y : integer; R,G,B,L : Byte; cr,cg,cb : real; prev,next : PTDynPix);
      // Destructeur du mayon courant
      destructor Destroy ; override;
      // getter et setter
      procedure getPix(var x,y : integer; var R,G,B,L : Byte);
      procedure setPix(var x,y : integer; var R,G,B,L : Byte);
      procedure getCoef(var cr,cg,cb : real);
      procedure setCoef(var cr,cg,cb : real);
      procedure getCoord(var x,y : integer);
      procedure setCoord(var x,y : integer);
      procedure getValues(var x,y : integer; var R,G,B,L : Byte; cr,cg,cb:real);
      procedure setValues(var x,y : integer; var R,G,B,L : Byte; cr,cg,cb:real);
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
      procedure _add(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure _setPixel(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte);
      procedure _setCoefs(var _current : TAncrePixels; var cr,cg,cb : real);
      procedure _set(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure _getPixel(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte);
      procedure _get(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure _getCoefs(var _current : TAncrePixels; var cr,cg,cb : real);
      procedure _create(var _current : TAncrePixels);
      procedure _clearall(var _current : TAncrePixels);
      procedure _next(var _current : TAncrePixels);
      procedure _previous(var _current : TAncrePixels);
      function _isEnd(var _current : TAncrePixels) : boolean;
    public
      width, height : integer; // Taille de l'image
      IOO : TAncrePixels; // Teinte [R:255,G:0,B:0]
      IIO : TAncrePixels; // Teinte [R:255,G:255,B:0]
      OIO : TAncrePixels; // Teinte [R:0,G:255,B:0]
      OII : TAncrePixels; // Teinte [R:0,G:255,B:255]
      OOI : TAncrePixels; // Teinte [R:0,G:0,B:255]
      IOI : TAncrePixels; // Teinte [R:255,G:0,B:255]
      III : TAncrePixels; // Teinte Blanc, gris, noir (achromatique)
      _nbPix : integer;   // Nombre total de pixels constituants l'image (pour la barre de progression des traitements)
      //constructor Create(var Img : TImage);
      constructor Create();
      destructor Destroy;
      procedure IOO_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure IOO_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure IOO_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure IOO_SetCoefs(var cr,cg,cb : real);
      procedure IOO_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure IOO_MoveNext;
      procedure IOO_MovePrevious;
      function IOO_isEnd() : boolean;
      procedure IIO_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure IIO_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure IIO_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure IIO_SetCoefs(var cr,cg,cb : real);
      procedure IIO_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure IIO_MoveNext;
      procedure IIO_MovePrevious;
      function IIO_isEnd() : boolean;
      procedure OIO_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure OIO_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure OIO_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure OIO_SetCoefs(var cr,cg,cb : real);
      procedure OIO_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure OIO_MoveNext;
      procedure OIO_MovePrevious;
      function OIO_isEnd() : boolean;
      procedure OII_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure OII_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure OII_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure OII_SetCoefs(var cr,cg,cb : real);
      procedure OII_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure OII_MoveNext;
      procedure OII_MovePrevious;
      function OII_isEnd() : boolean;
      procedure OOI_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure OOI_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure OOI_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure OOI_SetCoefs(var cr,cg,cb : real);
      procedure OOI_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure OOI_MoveNext;
      procedure OOI_MovePrevious;
      function OOI_isEnd() : boolean;
      procedure IOI_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure IOI_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure IOI_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure IOI_SetCoefs(var cr,cg,cb : real);
      procedure IOI_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure IOI_MoveNext;
      procedure IOI_MovePrevious;
      function IOI_isEnd() : boolean;
      procedure III_Add(var x,y : integer; var R,G,B,L : Byte);
      procedure III_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure III_SetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure III_SetCoefs(var cr,cg,cb : real);
      procedure III_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure III_MoveNext;
      procedure III_MovePrevious;
      function III_isEnd() : boolean;
      procedure IOO_GetPixels(var x,y : integer; var R,G,B,L : Byte);
      procedure IOO_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure IOO_GetCoefs(var cr,cg,cb : real);
      procedure IIO_GetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure IIO_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure IIO_GetCoefs(var cr,cg,cb : real);
      procedure OIO_GetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure OIO_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure OIO_GetCoefs(var cr,cg,cb : real);
      procedure OII_GetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure OII_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure OII_GetCoefs(var cr,cg,cb : real);
      procedure OOI_GetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure OOI_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure OOI_GetCoefs(var cr,cg,cb : real);
      procedure IOI_GetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure IOI_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure IOI_GetCoefs(var cr,cg,cb : real);
      procedure III_GetPixel(var x,y : integer; var R,G,B,L : Byte);
      procedure III_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
      procedure III_GetCoefs(var cr,cg,cb : real);
  end;

implementation

// TListPixels
// Private methods
procedure TListPixels._setPixel(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte);
begin
  if _current._current <> nil then
    _current._current^.setPix(x,y,R,G,B,L);
end;

procedure TListPixels._setCoefs(var _current : TAncrePixels; var cr,cg,cb : real);
begin
  if _current._current <> nil then
    _current._current^.setCoef(cr,cg,cb);
end;

procedure TListPixels._set(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  if _current._current <> nil then
    _current._current^.setValues(x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels._getPixel(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte);
begin
  if _current._current <> nil then
    _current._current^.getPix(x,y,R,G,B,L);
end;

procedure TListPixels._getCoefs(var _current : TAncrePixels; var cr,cg,cb : real);
begin
  if _current._current <> nil then
    _current._current^.getCoef(cr,cg,cb);
end;

procedure TListPixels._get(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  if _current._current <> nil then
    _current._current^.getValues(x,y,R,G,B,L,cr,cg,cb);
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
  if @_current <> nil then
    if _current.List <> nil then begin
      _current.List^.DestroyAllNext;
      _current.List^.Destroy;
    end;
    _current.List := nil;
    _current._current := nil;
    _current.nbPixels := 0;
end;

procedure TListPixels._add(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte);
var _pt, __next, __prev : PTDynPix ;
begin
  _pt := nil;
  // Creation du nouveau maillon
  new(_pt);
  if _pt = nil then exit;
  _pt^ := TDynPix.Create(x,y,R,G,B,L);
  // Récupération du chaînage du maillon en tête de liste
  _current.List^.getNearDynPix(__prev,__next);
  // Mise à jour du chaînage arriere pour ce maillon
  _current.List^.setNearDynPix(_pt,__next);
  // Affectation du chainage du nouveau maillon
  _pt^.setNearDynPix(nil,_current.List);
  // Positionnement du nouveau maillon en tête de liste
  _current.List := _pt;
  inc(_current.nbPixels);
end;

procedure TListPixels._add(var _current : TAncrePixels; var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
var _pt, __next, __prev : PTDynPix ;
begin
  _pt := nil;
  // Creation du nouveau maillon
  new(_pt);
  if _pt = nil then exit;
  _pt^ := TDynPix.Create(x,y,R,G,B,L,cr,cg,cb);
  // Récupération du chaînage du maillon en tête de liste
  _current.List^.getNearDynPix(__prev,__next);
  // Mise à jour du chaînage arriere pour ce maillon
  _current.List^.setNearDynPix(_pt,__next);
  // Affectation du chainage du nouveau maillon
  _pt^.setNearDynPix(nil,_current.List);
  // Positionnement du nouveau maillon en tête de liste
  _current.List := _pt;
  inc(_current.nbPixels);
end;

// Public methods.
constructor TListPixels.Create();
begin
  _create(IOO);
  _create(IIO);
  _create(OIO);
  _create(OII);
  _create(OOI);
  _create(IOI);
  _create(III);
  _nbPix := 0;
end;

destructor TListPixels.Destroy;
begin
  _clearall(IOO);
  _clearall(IIO);
  _clearall(OIO);
  _clearall(OII);
  _clearall(OOI);
  _clearall(IOI);
  _clearall(III);
  _nbPix := 0;
  inherited;
end;

procedure TListPixels.IOO_Add(var x,y : integer; var R,G,B,L : Byte);
begin
  _add(IOO, x,y,R,G,B,L);
end;

procedure TListPixels.IOO_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _add(IOO,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.IOO_SetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _setPixel(IOO,x,y,R,G,B,L);
end;

procedure TListPixels.IOO_SetCoefs(var cr,cg,cb : real);
begin
  _setCoefs(IOO,cr,cg,cb);
end;

procedure TListPixels.IOO_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _set(IOO,x,y,R,G,B,L,cr,cg,cb);
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
end;

procedure TListPixels.IIO_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _add(IIO,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.IIO_SetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _setPixel(IIO,x,y,R,G,B,L);
end;

procedure TListPixels.IIO_SetCoefs(var cr,cg,cb : real);
begin
  _setCoefs(IIO,cr,cg,cb);
end;

procedure TListPixels.IIO_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _set(IIO,x,y,R,G,B,L,cr,cg,cb);
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
end;

procedure TListPixels.OIO_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _add(OIO,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.OIO_SetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _setPixel(IOI,x,y,R,G,B,L);
end;

procedure TListPixels.OIO_SetCoefs(var cr,cg,cb : real);
begin
  _setCoefs(OIO,cr,cg,cb);
end;

procedure TListPixels.OIO_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _set(OIO,x,y,R,G,B,L,cr,cg,cb);
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
end;

procedure TListPixels.OII_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _add(OII,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.OII_SetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _setPixel(OII,x,y,R,G,B,L);
end;

procedure TListPixels.OII_SetCoefs(var cr,cg,cb : real);
begin
  _setCoefs(OII,cr,cg,cb);
end;

procedure TListPixels.OII_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _set(OII,x,y,R,G,B,L,cr,cg,cb);
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
end;

procedure TListPixels.OOI_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _add(OOI,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.OOI_SetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _setPixel(OOI,x,y,R,G,B,L);
end;

procedure TListPixels.OOI_SetCoefs(var cr,cg,cb : real);
begin
  _setCoefs(OOI,cr,cg,cb);
end;

procedure TListPixels.OOI_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _set(OOI,x,y,R,G,B,L,cr,cg,cb);
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
end;

procedure TListPixels.IOI_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _add(IOI,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.IOI_SetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _setPixel(IOI,x,y,R,G,B,L);
end;

procedure TListPixels.IOI_SetCoefs(var cr,cg,cb : real);
begin
  _setCoefs(IOI,cr,cg,cb);
end;

procedure TListPixels.IOI_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _set(IOI,x,y,R,G,B,L,cr,cg,cb);
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
end;

procedure TListPixels.III_Add(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _add(III,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.III_SetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _setPixel(III,x,y,R,G,B,L);
end;

procedure TListPixels.III_SetCoefs(var cr,cg,cb : real);
begin
  _setCoefs(III,cr,cg,cb);
end;

procedure TListPixels.III_Set(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _set(III,x,y,R,G,B,L,cr,cg,cb);
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

procedure TListPixels.IOO_GetPixels(var x,y : integer; var R,G,B,L : Byte);
begin
  _getPixel(IOO,x,y,R,G,B,L);
end;

procedure TListPixels.IOO_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _get(IOO,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.IOO_GetCoefs(var cr,cg,cb : real);
begin
  _getCoefs(IOO,cr,cg,cb);
end;

procedure TListPixels.IIO_GetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _getPixel(IIO,x,y,R,G,B,L);
end;

procedure TListPixels.IIO_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _get(IIO,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.IIO_GetCoefs(var cr,cg,cb : real);
begin
  _getCoefs(IIO,cr,cg,cb);
end;

procedure TListPixels.OIO_GetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _getPixel(OIO,x,y,R,G,B,L);
end;

procedure TListPixels.OIO_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _get(OIO,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.OIO_GetCoefs(var cr,cg,cb : real);
begin
  _getCoefs(OIO,cr,cg,cb);
end;

procedure TListPixels.OII_GetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _getPixel(OII,x,y,R,G,B,L);
end;

procedure TListPixels.OII_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _get(OII,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.OII_GetCoefs(var cr,cg,cb : real);
begin
  _getCoefs(OII,cr,cg,cb);
end;

procedure TListPixels.OOI_GetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _getPixel(OOI,x,y,R,G,B,L);
end;

procedure TListPixels.OOI_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _get(OOI,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.OOI_GetCoefs(var cr,cg,cb : real);
begin
  _getCoefs(OOI,cr,cg,cb);
end;

procedure TListPixels.IOI_GetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _getPixel(IOI,x,y,R,G,B,L);
end;

procedure TListPixels.IOI_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _get(IOI,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.IOI_GetCoefs(var cr,cg,cb : real);
begin
  _getCoefs(IOI,cr,cg,cb);
end;

procedure TListPixels.III_GetPixel(var x,y : integer; var R,G,B,L : Byte);
begin
  _getPixel(III,x,y,R,G,B,L);
end;

procedure TListPixels.III_Get(var x,y : integer; var R,G,B,L : Byte; var cr,cg,cb : real);
begin
  _get(III,x,y,R,G,B,L,cr,cg,cb);
end;

procedure TListPixels.III_GetCoefs(var cr,cg,cb : real);
begin
  _getCoefs(III,cr,cg,cb);
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
      _r_coef := 0;
      _g_coef := 0;
      _b_coef := 0;
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
  end;
  with _satcoef do begin
      _r_coef := 0;
      _g_coef := 0;
      _b_coef := 0;
  end;
end;

constructor TDynPix.Create(x,y : integer; R,G,B,L : Byte; cr,cg,cb : real);
begin
  _next := nil;
  _previous := nil;
  with _pixel do begin
      _R:=R;
      _G:=G;
      _B:=B;
      _L:=L;
  end;
  with _satcoef do begin
      _r_coef := cr;
      _g_coef := cg;
      _b_coef := cb;
  end;
end;

constructor TDynPix.Create(x,y : integer; R,G,B,L : Byte; prev,next : PTDynPix);
begin
  _next := next;
  _previous := prev;
  with _pixel do begin
      _R:=R;
      _G:=G;
      _B:=B;
      _L:=L;
  end;
  with _satcoef do begin
      _r_coef := 0;
      _g_coef := 0;
      _b_coef := 0;
  end;
end;

constructor TDynPix.Create(x,y : integer; R,G,B,L : Byte; cr,cg,cb : real; prev,next : PTDynPix);
begin
  _next := next;
  _previous := prev;
  with _pixel do begin
      _R:=R;
      _G:=G;
      _B:=B;
      _L:=L;
  end;
  with _satcoef do begin
      _r_coef := cr;
      _g_coef := cg;
      _b_coef := cb;
  end;
end;

destructor TDynPix.Destroy;
begin
  if self._previous <> nil then
     self._previous^._next := self._next;
  inherited;
end;

procedure TDynPix.getPix(var x,y : integer; var R,G,B,L : Byte);
begin
  with _pixel do begin
      x := _x;
      y := _y;
      R := _R;
      G := _G;
      B := _B;
      L := _L;
  end;
end;

procedure TDynPix.setPix(var x,y : integer; var R,G,B,L : Byte);
begin
  with _pixel do begin
      _x := x;
      _y := y;
      _R := R;
      _G := G;
      _B := B;
      _L := L;
  end;
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

procedure TDynPix.getCoef(var cr,cg,cb : real);
begin
  with _satcoef do begin
      cr := _r_coef ;
      cg := _g_coef ;
      cb := _b_coef ;
  end;
end;

procedure TDynPix.setCoef(var cr,cg,cb : real);
begin
  with _satcoef do begin
      _r_coef := cr ;
      _g_coef := cg ;
      _b_coef := cb ;
  end;
end;

procedure TDynPix.getValues(var x,y : integer; var R,G,B,L : Byte; cr,cg,cb:real);
begin
  self.getPix(x,y,R,G,B,L);
  self.getCoef(cr,cg,cb);
end;

procedure TDynPix.setValues(var x,y : integer; var R,G,B,L : Byte; cr,cg,cb:real);
begin
  self.setPix(x,y,R,G,B,L);
  self.setCoef(cr,cg,cb);
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
begin
  // Appel récursif pour aller au fond de la liste et remonter en supprimant
  //  les maillons par la fin
  if self._next <> nil then begin
    // Appel récursif à partir du mayon suivant
    self._next^.DestroyAllNext;
    // Destruction du mayon suivant
    self._next^.Destroy;
    dispose(self._next);
    // Initialisation du pointeur sur le maillon suivant
    self._next := nil;
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
begin
  isData := false;
  // Reading source width and height
  PixHeight := Image.Picture.Height;
  PixWidth := Image.Picture.Width;
  // Reading source Pixel width and source line width
  SourceLineWidth := Image.Picture.Bitmap.RawImage.Description.BytesPerLine ;
  SourcePixelWidth := Image.Picture.Bitmap.RawImage.Description.BitsPerPixel div 8;
  // Calc of buffer size for 32bits per pixels sRGB
  MySize := self.memorysize(PixWidth, PixHeight);
  // Create buffer for internal picture
  memoryBuff := TMemoryStream.Create();
  memoryBuff.setSize(MySize);
  isData := true;
  pwidth := PixWidth;
  pheight := PixHeight;
  // Pointer on picture data
  ScanLine := Image.Picture.Bitmap.RawImage.Data-1;
  // Pointer to the memorystring area
  Dest := PByte(memoryBuff.Memory)-1;
  // Copy source into internal pix
  for i := 0 to PixHeight - 1 do begin
    for j := 0 to PixWidth - 1 do
      begin
          //Read Source
          // Blue
          inc(ScanLine);
          B := ScanLine^;
          // Green
          inc(ScanLine);
          G := ScanLine^;
          // Red
          inc(ScanLine);
          R := ScanLine^;
          // Luminance if exists
          if SourcePixelWidth > 3 then begin
            inc(ScanLine);
            L := ScanLine^;
          end else L := 255;
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
    ProgressWindow.SetProgressInc(i/(PixHeight-1)*100);
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
  Dest, ScanLine : PByte;
  R, G, B, L : Byte;
  i,j : integer;
begin
  if not isData then exit;
  // Copy internal pix into Dest pix
  // Set the destination size
  Image.Picture.Bitmap.Height := pheight;
  Image.Picture.Bitmap.Width := pwidth;
  Image.Picture.Bitmap.PixelFormat := pf32bit;
  Image.Picture.Bitmap.RawImage.CreateData(true);

  // Pointer on picture data
  ScanLine := PByte(Image.Picture.Bitmap.RawImage.Data)-1;
  // Pointer to the memorystring area
  Dest := PByte(memoryBuff.Memory)-1;
   for i := 0 to pheight - 1 do begin
    for j := 0 to pwidth - 1 do
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
          // Blue
          inc(ScanLine);
          ScanLine^ := B;
          // Green
          inc(ScanLine);
          ScanLine^ := G;
          // Red
          inc(ScanLine);
          ScanLine^ := R;
          // Luminance
          inc(ScanLine);
          ScanLine^ := L;

      end;
     ProgressWindow.SetProgressInc(i/(pheight-1)*100);
   end;
end;

procedure TMemoryPix.getImageFromTImage(var Image : TImage);
type
  TIndexCouleur = 0..65535;
var
  PixHeight, PixWidth,i, j : integer;
  SourcePixelWidth : integer;
  ScanLine, Dest, CouleurTable : PByte;
  SourceLineWidth : integer;
  MySize : integer;
  R, G, B, L : Byte;
  color : TColor;
  indexCouleur : TIndexCouleur;
  paletteSize : PtrUInt;
begin
  if isData then begin
    memoryBuff.Destroy;
    memoryBuff := nil;
  end;
  PixHeight := Image.Picture.Height;
  PixWidth := Image.Picture.Width;
  // Pour les image avec palettes de couleurs
  CouleurTable := Image.Picture.Bitmap.RawImage.Palette;
  paletteSize := Image.Picture.Bitmap.RawImage.PaletteSize;
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
  // Reading source Pixel width and source line width
  SourceLineWidth := Image.Picture.Bitmap.RawImage.Description.BytesPerLine ;
  SourcePixelWidth := Image.Picture.Bitmap.RawImage.Description.BitsPerPixel div 8;
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
    ProgressWindow.SetProgressInc(i/(PixHeight-1)*100);
  end;
end;

end.

