unit MemoryPix;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Graphics, ProgressWindows, GraphType, TSL, forms,
  constantes, marqueurs, TimException, dialogs, compilation;

type

  TReglages = record
    rsat, rlum, jsat, jlum, vsat, vlum, csat, clum, bsat, blum, violsat, viollum, blancsat, blanclum : real;
    rcor, jcor, vcor, ccor, bcor, violcor : TColorAdapt;
  end;

  TMemoryPix = class(TObject)
    private
      function getPixelPos(x, y : integer) : PByte;
    public
      // V1.1.0.a01 : moved from private declaration for saving memory in files
      isData : boolean;
      memoryBuff : TMemoryStream;
      pwidth, pheight : integer;
      //
      function memorysize(width, height : integer) : integer;
      constructor Create();
      constructor Create(_size : longint);

      constructor Create(width, height : integer; zeroinit : boolean);
      constructor Create(width, height : integer; color : TColor);
      constructor Create(width, height : integer; R,G,B,L : Byte);
      constructor Create(var Image : TImage);

      procedure Init(width, height : integer; zeroinit : boolean);
      procedure Init(width, height : integer; color : TColor);
      procedure Init(width, height : integer; R,G,B,L : Byte);
      Procedure Init(var Image : TImage);

      destructor Destroy; override;

      procedure Clear;

      procedure getImageSize (var width, height : integer);
      procedure setPixel(x, y : integer; R, G, B : Byte);
      procedure setPixel(x, y : integer; R, G, B, L : Byte);
      procedure setPixel(x, y : integer; color : TColor);
      procedure setPixel(x, y : integer; color : TColor; L : Byte);
      procedure getPixel(x, y : integer; var R, G, B : Byte);
      procedure getPixel(x, y : integer; var R, G, B, L : Byte);
      procedure getPixel(x, y : integer; var color : TColor);
      procedure getPixel(x, y : integer; var color : TColor; var L : Byte);
      procedure copyImageIntoTImage (var Image : TImage ; _progress : boolean);
      procedure getImageFromTImage (var Image : TImage);
      procedure drawTeintesIntoTImage(var Image : TImage; _reg : TReglages ;
          _ATonsClairs, _ATonsMoyens, _ATonsSombres : boolean);
      procedure copy(var _destimg : TMemoryPix ; _progress : boolean ; _percent : integer);
  end ;

  T_PixelColor = packed record
    _R,_G,_B : Byte
  end;

  T_SumRGB = packed record  // Somme la valeur des cannaux RGB pour les pixels classés
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
      function getNext() : PTDynPix;
      function getPrevious() : PTDynPix;
      procedure setNearDynPix (prev,next : PTDynPix);
      // Suppression du reste des maillons chaînée à partir du mayon courrant
      procedure DestroyAllNext;
  end;

  TAncrePixels = packed record
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
      procedure drawTeinteIntoTImage(TeinteIndex : integer ; var Image : TImage; _draw : boolean; sat, lum : integer; ccor : TColorAdapt;
         _ATonsClairs, _ATonsMoyens, _ATonsSombres : boolean ;
         waitingbox : boolean; wboxpercent : integer);
  end;

implementation

// Duplicated from unit luminance for excluding loop in units references
function GetLuminance (R,G,B : Byte) : integer;
begin
  GetLuminance := round(R*0.2126 + G*0.7152 + B*0.0722);
end;


// Bitmap encoding and decoding according to OS
Procedure setBmpPixel(PixelPtr: PByte; color: TColor);
var Pt : PByte;
begin
  try
    if PLT_CANAUX = PLT_CANAUX_NORM then begin
      Pt := PByte(PixelPtr);
      Pt^ := Blue(color);
      (Pt+1)^ := Green(color);
      (Pt+2)^ := Red(color);
    end else if PLT_CANAUX = PLT_CANAUX_INV then begin
      Pt := PByte(PixelPtr);
      Pt^ := Red(color);
      (Pt+1)^ := Green(color);
      (Pt+2)^ := Blue(color);
    end else PInteger(PixelPtr)^ := color;
  finally
  end;
end;

function getBmpPixel(PixelPtr: PByte) : TColor;
var R,G,B : Byte;
  Pt : PByte;
  ret : TColor;
begin
  try
    if PLT_CANAUX = PLT_CANAUX_NORM then begin
      Pt := PByte(PixelPtr);
      try
        B :=  Pt^;

      Except
        B := 0;
      end;
      try
        G := (Pt+1)^;

      Except
        G := 0;
      end;
      try
        R := (Pt+2)^;

      Except
        R := 0;
      end;
      ret := RGBToColor(R,G,B);
    end else if PLT_CANAUX = PLT_CANAUX_INV then begin
      Pt := PByte(PixelPtr);
      try
        R :=  Pt^;

      Except
        R := 0;
      end;
      try
        G := (Pt+1)^;

      Except
        G := 0;
      end;
      try
        B := (Pt+2)^;

      Except
        B := 0;
      end;
      ret := RGBToColor(R,G,B);
    end else
      ret := PInteger(PixelPtr)^;
  except
  end;
  getBmpPixel := ret;
end;


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
var _pt : PTDynPix ;
begin
  _pt := nil;
  // Creation du nouveau maillon
  new(_pt);
  if _pt = nil then raise E_AllocatedFault.Create('memory fault');
  _pt^ := TDynPix.Create(x,y,R,G,B,L);
  _pt^.setNearDynPix(nil, _current.List);
  // Mise à jour des pointeurs de l'ancien maillon
  if (_current.List <> nil) then
    _current.List^.setNearDynPix(_pt,_current.List^.getNext());
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

procedure TListPixels.drawTeinteIntoTImage(TeinteIndex : integer; var Image : TImage; _draw : boolean; sat, lum : integer; ccor : TColorAdapt;
    _ATonsClairs, _ATonsMoyens, _ATonsSombres : boolean ;
    waitingbox : boolean; wboxpercent : integer);
{
  Pour des problèmes de gestion mémoire des methode strechDraw et Draw
  la méthode est splittée en deux partie.
  La première travaille directement sur l'image de sortie => Lente. Impossible pour la preview
  La deuxième travaille avec une copie mémoire => Rapide, mais limité à de petites images.
}

var i : LongInt ; // pour la barre de progression
  _x, _y : integer;
  _R,_G,_B,_L : Byte;
  _RC,_GC,_BC : real;
  _RL, csat, clum,_sr,_sg,_sb, _cr,_cg,_cb : real;
  _coefs : TCoefSatDSat;
  _color : TColor;
  Bmp : TBitmap;
  _current : PTDynPix;
  _nbpixels : LongInt;

  PixelPtr: PByte;
  PixelRowPtr: PByte;
  RawImage: TRawImage;
  BytePerPixel: integer;
  BytesPerLine: integer;

  _luminance : integer;
  _calc : boolean;

  begin
    // Création de l'image interne de traitement (performance de l'ecriture)
    {
    Bmp := TBitmap.Create();
    Bmp.PixelFormat := pf24bit;
    Bmp.Width := Image.Picture.Bitmap.Width;
    Bmp.Height := Image.Picture.Bitmap.Height;
    Bmp.SetSize(sizex, sizey);
    Bmp.RawImage.CreateData(true);

    Bmp.Canvas.Draw(0,0,Image.Picture.Bitmap);

    Bmp.BeginUpdate(False);
    RawImage := Bmp.RawImage ;
    }
    Image.Picture.Bitmap.BeginUpdate(false);
    RawImage := Image.Picture.Bitmap.RawImage;
    BytePerPixel := RawImage.Description.BitsPerPixel div 8;
    BytesPerLine := RawImage.Description.BytesPerLine;
    PixelRowPtr := PByte(RawImage.Data);


    // Initialisation du pointeur courant sur le premier maillon de la liste
    case TeinteIndex of
      1 : begin _current := IOO.List; _nbpixels := IOO.nbPixels; end;
      2 : begin _current := IIO.List; _nbpixels := IIO.nbPixels; end;
      3 : begin _current := OIO.List; _nbpixels := OIO.nbPixels; end;
      4 : begin _current := OII.List; _nbpixels := OII.nbPixels; end;
      5 : begin _current := OOI.List; _nbpixels := OOI.nbPixels; end;
      6 : begin _current := IOI.List; _nbpixels := IOI.nbPixels; end;
      7 : begin _current := III.List; _nbpixels := III.nbPixels; end;
    end;
    i := 0;
    // Test sur le type de dessin (noir ou avec la couleur du pixel (param _draw = true couleur sinon noir)
    // On fait deux boucles afin de ne faire le test qu'une fois et pas à chaque itération
    if _draw then begin
      // boucle de couleur
      csat := sat / 500;
      csat := (csat * csat) * 255;
      clum := lum / 500;
      clum := (clum * clum) * 255;
      if lum < 1 then clum := -clum;
      while _current <> nil do begin
          _current^.getPix(_x,_y,_R,_G,_B,_L,_coefs);
          _RL := _L/255.0;
          // Détermination de la luminance et s'il faut ou non faire les calculs
          _luminance := GetLuminance (_R,_G,_B);
          // Détermination de la teinte pour s'avoir s'il faut ou non faire les calculs
          _calc := (((_luminance < _CTonsSombres) and _ATonsSombres) or
                   ((_luminance < _CTonsMoyens) and _ATonsMoyens and (_luminance >= _CTonsSombres)) or
                   ((_luminance >= _CTonsMoyens) and _ATonsClairs));
          if _calc then begin
            if TeinteIndex = 1 then begin
                        if sat < 0 then begin
                           _cr := -1 + _coefs.r;
                           _cg := 1 + _coefs.g;
                           _cb := 1 + _coefs.b ;
                        end else begin
                          _cr := _coefs.r;
                          _cg := _coefs.g;
                          _cb := _coefs.b;
                        end;
            end else if TeinteIndex = 2 then begin
                        if sat < 0 then begin
                           _cr := -1 + _coefs.r;
                           _cg := -1 + _coefs.g;
                           _cb := 1 + _coefs.b ;
                        end else begin
                          _cr := _coefs.r;
                          _cg := _coefs.g;
                          _cb := _coefs.b;
                        end;
            end else if TeinteIndex = 3 then begin
                            if sat < 0 then begin
                               _cr := 1 + _coefs.r;
                               _cg := -1 + _coefs.g;
                               _cb := 1 + _coefs.b ;
                            end else begin
                              _cr := _coefs.r;
                              _cg := _coefs.g;
                              _cb := _coefs.b;
                            end;
            end else if TeinteIndex = 4 then begin
                                if sat < 0 then begin
                                   _cr := 1 + _coefs.r;
                                   _cg := -1 + _coefs.g;
                                   _cb := -1 + _coefs.b ;
                                end else begin
                                  _cr := _coefs.r;
                                  _cg := _coefs.g;
                                  _cb := _coefs.b;
                                end;
            end else if TeinteIndex = 5 then begin
                                    if sat < 0 then begin
                                       _cr := 1 + _coefs.r;
                                       _cg := 1 + _coefs.g;
                                       _cb := -1 + _coefs.b ;
                                    end else begin
                                      _cr := _coefs.r;
                                      _cg := _coefs.g;
                                      _cb := _coefs.b;
                                    end;
            end else if TeinteIndex = 6 then begin
                                        if sat < 0 then begin
                                           _cr := -1 + _coefs.r;
                                           _cg := 1 + _coefs.g;
                                           _cb := -1 + _coefs.b ;
                                        end else begin
                                          _cr := _coefs.r;
                                          _cg := _coefs.g;
                                          _cb := _coefs.b;
                                        end;
            end;
            if csat < 0 then csat := -csat;
            _sr := _cr*csat;
            _sg := _cg*csat;
            _sb := _cb*csat;
            _RC := _R*_RL+_sr+clum + ccor.R ;
            _GC := _G*_RL+_sg+clum + ccor.G ;
            _BC := _B*_RL+_sb+clum + ccor.B ;
            bouchee := false;
            cramee := false;
            if _RC < 0 then begin
              _RC := 0;
              bouchee := true;
            end else if _RC > 255 then begin
              _RC := 255;
              cramee := true;
            end;
            if _GC < 0 then begin
              _GC := 0 ;
              bouchee := true;
            end else if _GC > 255 then begin
              _GC := 255;
              cramee := true;
            end;
            if _BC < 0 then begin
              _BC := 0;
              bouchee := true;
            end else if _BC > 255 then begin
              _BC := 255;
              cramee := true;
            end;
            PixelPtr := PixelRowPtr + (_y * BytesPerLine) + (_x * BytePerPixel);
            setBmpPixel(PixelPtr,RGBToColor(round(_RC),round(_GC),round(_BC)));
          end;
        // Chaînage
        _current := _current^.getNext();
        inc (i);
        if (i mod (c_refresh * 10) = 0) and waitingbox then ProgressWindow.setProgressInc(round(i/_nbpixels*wboxpercent));
      end;
    end else begin
     // boucle pour effacer les pixels
      _color := RGBToColor(0,0,0); // noir
      while _current <> nil do begin
          _current^.getCoord(_x,_y);

          PixelPtr := PixelRowPtr + (_y * BytesPerLine) + (_x * BytePerPixel);
          setBmpPixel(PixelPtr,_color);


          // Chaînage
          _current := _current^.getNext();
          inc (i);
          if (i mod (c_refresh * 10) = 0)and waitingbox then ProgressWindow.setProgressInc(round(i/_nbpixels*wboxpercent));
     end;
    end;
    {
    Bmp.EndUpdate(false);
    // Recopie dans l'image source (affichée)
    Image.Picture.Bitmap.Canvas.Draw(0,0,Bmp);
    // Destruction de l'image interne de traitement
    Bmp.Destroy;
    }
    Image.Picture.Bitmap.EndUpdate(false);
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

  PixelPtr: PByte;
  PixelRowPtr: PByte;
  RawImage: TRawImage;
  BytePerPixel: integer;
  BytesPerLine: integer;


begin
  // Initialisation de la bitmap de sortie
  // Création de l'image de travail
  Bmp := TBitmap.Create();
  Bmp.Width := self._width;
  Bmp.Height := self._height;
  Bmp.PixelFormat := pf24bit;
  Bmp.RawImage.CreateData(true);

  Bmp.BeginUpdate(False);
  RawImage := Bmp.RawImage ;
  BytePerPixel := RawImage.Description.BitsPerPixel div 8;
  BytesPerLine := RawImage.Description.BytesPerLine;
  PixelRowPtr := PByte(RawImage.Data);


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

      PixelPtr := PixelRowPtr + (y * BytesPerLine) + (x * BytePerPixel);
      setBmpPixel(PixelPtr,color);

      // Enchaînement sur le pixel suivant
      IOO_MoveNext;
      // progression
      inc(compteur);
      if (compteur mod (c_refresh * 10) = 0)then
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

      PixelPtr := PixelRowPtr + (y * BytesPerLine) + (x * BytePerPixel);
      setBmpPixel(PixelPtr,color);


      // Enchaînement sur le pixel suivant
      IIO_MoveNext;
      inc(compteur);
      if (compteur mod (c_refresh *10) = 0)then
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

      PixelPtr := PixelRowPtr + (y * BytesPerLine) + (x * BytePerPixel);
      setBmpPixel(PixelPtr,color);

      // Enchaînement sur le pixel suivant
      OIO_MoveNext;
      inc(compteur);
      if (compteur mod (c_refresh * 10) = 0)then
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

      PixelPtr := PixelRowPtr + (y * BytesPerLine) + (x * BytePerPixel);
      setBmpPixel(PixelPtr,color);

      // Enchaînement sur le pixel suivant
      OII_MoveNext;
      inc(compteur);
      if (compteur mod (c_refresh * 10) = 0)then
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

      PixelPtr := PixelRowPtr + (y * BytesPerLine) + (x * BytePerPixel);
      setBmpPixel(PixelPtr,color);

      // Enchaînement sur le pixel suivant
      OOI_MoveNext;
      inc(compteur);
      if (compteur mod (c_refresh * 10) = 0)then
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

      PixelPtr := PixelRowPtr + (y * BytesPerLine) + (x * BytePerPixel);
      setBmpPixel(PixelPtr,color);

      // Enchaînement sur le pixel suivant
      IOI_MoveNext;
      inc(compteur);
      if (compteur mod (c_refresh * 10) = 0)then
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

      PixelPtr := PixelRowPtr + (y * BytesPerLine) + (x * BytePerPixel);
      setBmpPixel(PixelPtr,color);

      // Enchaînement sur le pixel suivant
      III_MoveNext;
      inc(compteur);
      if (compteur mod (c_refresh * 10) = 0)then
        ProgressWindow.setProgressInc(((compteur/III.nbPixels/7)+6/7)*100);
    end;
  end;
  Bmp.EndUpdate(false);
  ProgressWindow.SetProgressInc(100);
  // Recopie de la Bitmap temporaire dans la bitmap affichée
  Image.Picture.Bitmap.Canvas.Draw(0,0,Bmp);

  // Destruction de la bitmpa de travail
  Bmp.Destroy;

end;

procedure TListPixels.getImageFromTImage (var Image : TImage);
var i, j, x, y, indexTeinte : integer;
  color : TColor;
  R,G,B,L : Byte;

  PixelPtr: PByte;
  PixelRowPtr: PByte;
  RawImage: TRawImage;
  BytePerPixel: integer;
  BytesPerLine: integer;


begin
  // Suppression de la précédente image si elle existait
  self.Clear;
  // Initialisation
  // - Taille de l'image
  self._width := Image.Picture.Bitmap.Width;
  self._height := Image.Picture.Bitmap.Height;
  L:=255;

  Image.Picture.Bitmap.BeginUpdate(False);
  RawImage := Image.Picture.Bitmap.RawImage ;
  BytePerPixel := RawImage.Description.BitsPerPixel div 8;
  BytesPerLine := RawImage.Description.BytesPerLine;
  PixelRowPtr := PByte(RawImage.Data);

  // Boucle de lecture de l'image source
  // - Il est nécessaire re recopier les valeurs de i et de j dans des
  //   variables locales, car les paramètres sont passés par adresses aux procédures
  //   et aux fonctions.
  try
    for i := 0 to self._height - 1 do begin
      y := i;
      for j := 0 to self._width - 1 do begin
          x := j;
          // Lecture du pixel de l'image
          // color := Image.Picture.Bitmap.Canvas.Pixels[j,i];
          PixelPtr := PixelRowPtr + (i * BytesPerLine) + (j * BytePerPixel);
          color := getBmpPixel(PixelPtr);
          // Modified V1.0-RC6
          // Avec Linux il faut inverser les canaux Rouge et Bleu
          if PLT_CANAUX = PLT_CANAUX_INV then begin
            R := Blue(color);
            G := Green(color);
            B := Red(color);
          end else begin
            R := Red(color);
            G := Green(color);
            B := Blue(color);
          end;
          // /Modified V1.0-RC6
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
      if (y mod c_pixrefresh = 0) then ProgressWindow.setProgressInc(y/self._height*70);
    end;
    Image.Picture.Bitmap.EndUpdate(False);
  Except
    try
      Image.Picture.Bitmap.EndUpdate(False);
      Clear;
    Except
      MessageDlg('Erreur','Mémoire insuffisante pour réaliser le traitement.', mtConfirmation,
      [mbYes],0);
    end;
    raise E_AllocatedFault.Create('memory fault');
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
  end;
  with _satcoef do begin
      r := 0;
      g := 0;
      b := 0;
  end;
end;

constructor TDynPix.Create(x,y : integer; R,G,B,L : Byte);
begin
  _next := nil;
  _previous := nil;
  with _pixel do begin
      _R:=Byte((R*L)div 255);
      _G:=Byte((G*L)div 255);
      _B:=Byte((B*L)div 255);;
      _x := x;
      _y := y;
  end;
  _satcoef := TSL_getSATCoef(R,G,B);
end;

destructor TDynPix.Destroy;
begin
  // suppression du maillon de la chaîne
  // 1- Reconstitution du chainage avant
  if self._previous <> nil then
    self._previous^._next := self._next;
  // 2- Reconstitution du chainage arrière
  if self._next <> nil then
    self._next^._previous := self._previous;
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
      L := 255;
      with _satcoef do
      begin
          coefs.r := r ;
          coefs.g := g ;
          coefs.b := b ;
      end;
  end;
end;


procedure TDynPix.setPix(var x,y : integer; var R,G,B,L : Byte); // modif des sat et dsat
begin
  with _pixel do begin
      _x := x;
      _y := y;
      _R := Byte((R*L)div 255);
      _G := byte((G*L)div 255);
      _B := byte((B*L)div 255);
  end;
  _satcoef := TSL_getSATcoef(R,G,B);
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
      r := _satcoef.r ;
      g := _satcoef.g ;
      b := _satcoef.b ;
  end;
end;

procedure TDynPix.setColor(var R,G,B,L : Byte) ; // sans maj des coef sat et dsat
begin
  with _pixel do
  begin
    _R := byte((R*L)div 255);
    _G := byte((G*L)div 255);
    _B := byte((B*L)div 255);
  end;
end;

procedure TDynPix.getColor(var R,G,B,L : Byte) ;
begin
  with _pixel do
  begin
    R := _R;
    G := _G;
    B := _B;
    L := 255;
  end;
end;

procedure TDynPix.getNearDynPix (var prev,next : PTDynPix);
begin
  prev := self._previous;
  next := self._next;
end;

function TDynPix.getNext() : PTDynPix;
begin
  getNext := self._next;
end;

function TDynPix.getPrevious() : PTDynPix;
begin
  getPrevious := self._previous;
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
  self.pwidth := 0;
  self.pheight := 0;
  // Allocation de la mémoire dynamique
  memoryBuff := TMemoryStream.Create();
  memoryBuff.SetSize(C_MemoryPix_MaxSize);
  if memoryBuff.Size <> C_MemoryPix_MaxSize then begin
    memoryBuff.SetSize(0);
    memoryBuff.Destroy;
    memoryBuff := nil;
    raise E_AllocatedFault.Create('memory fault');
  end;
end;

constructor TMemoryPix.Create(_size : longint);
begin
  isData := false;
  self.pwidth := 0;
  self.pheight := 0;
  // Allocation de la mémoire dynamique
  memoryBuff := TMemoryStream.Create();
  memoryBuff.SetSize(_size);
  if memoryBuff.Size <> _size then begin
    memoryBuff.SetSize(0);
    memoryBuff.Destroy;
    memoryBuff := nil;
    raise E_AllocatedFault.Create('memory fault');
  end;
end;


constructor TMemoryPix.Create(width, height : integer; zeroinit : boolean);
var MySize : longint;
  x, y : integer;
begin
  isData := false;
  // Calcul de la taille mémoire nécessire
  MySize := self.memorysize(width, height);
  // Allocation de la mémoire dynamique
  memoryBuff := TMemoryStream.Create();
  //memoryBuff.SetSize(C_MemoryPix_MaxSize);
  memoryBuff.SetSize(MySize);
  if memoryBuff.Size <> MySize then begin
    memoryBuff.SetSize(0);
    memoryBuff.Destroy;
    memoryBuff := nil;
    raise E_AllocatedFault.Create('memory fault');
  end;
  isData := true;
  self.pwidth := width;
  self.pheight := height;
  // Init de la mémoire
  if zeroinit then begin
    for x:=0 to width - 1 do begin
      for y:=0 to height - 1 do begin
        setPixel(x,y,0,0,0);
      end;
      if x mod c_refresh = 0 then Application.ProcessMessages;
    end;
  end;
end;

procedure TMemoryPix.Init(width, height : integer; zeroinit : boolean);
var x, y : integer;
begin
  isData := false;
  isData := true;
  // Affectation de la taille de l'image dans les propriétés de l'objet
  self.pwidth := width;
  self.pheight := height;
  // Init de la mémoire
  if zeroinit then begin
    for x:=0 to width - 1 do begin
      for y := 0 to height - 1 do begin
        setPixel(x, y, 0,0,0);
      end;
      if x mod c_refresh = 0 then Application.ProcessMessages;
    end;
  end;
end;

constructor TMemoryPix.Create(width, height : integer; color : TColor);
var MySize : longint;
  x, y : integer;
  vred, vgreen, vblue : Byte;
begin
  isData := false;
  // Calcul de la taille mémoire nécessire
  MySize := self.memorysize(width, height);
  // Allocation de la mémoire dynamique
  memoryBuff := TMemoryStream.Create();
  //memoryBuff.SetSize(C_MemoryPix_MaxSize);
  memoryBuff.SetSize(MySize);
  if memoryBuff.Size <> MySize then begin
    memoryBuff.SetSize(0);
    memoryBuff.Destroy;
    memoryBuff := nil;
    raise E_AllocatedFault.Create('memory fault');;
  end;
  isData := true;
  self.pwidth := width;
  self.pheight := height;
  // Init de la mémoire
  // Optention des valeurs RGB de la couleur d'initialisation
  vred:=red(color);
  vblue:=blue(color);
  vgreen:=green(color);
  for x:=0 to width - 1 do begin
    for y := 0 to height - 1 do begin
      setPixel(x,y, vRed, vGreen, vBlue);
    end;
    if x mod c_refresh = 0 then Application.ProcessMessages;
  end;
end;

procedure TMemoryPix.Init(width, height : integer; color : TColor);
var x, y : integer;
  vred, vgreen, vblue : Byte;
begin
  isData := false;
  // Calcul de la taille mémoire nécessire
  //MySize := self.memorysize(width, height);
  isData := true;
  // Affectation de la taille de l'image aux propriétés de l'objet
  self.pwidth := width;
  self.pheight := height;
  // Init de la mémoire
  // Optention des valeurs RGB de la couleur d'initialisation
  vred:=red(color);
  vblue:=blue(color);
  vgreen:=green(color);
  for x:= 0 to width - 1 do begin
      for y := 0 to height - 1 do begin
        self.setPixel(x,y, vred, vblue, vgreen);
      end;
    if x mod c_refresh = 0 then Application.ProcessMessages;
  end;
end;

constructor TMemoryPix.Create(width, height : integer; R,G,B,L : Byte);
var MySize : longint;
  x, y : integer;
begin
  isData := false;
  // Calcul de la taille mémoire nécessire
  MySize := self.memorysize(width, height);
  // Allocation de la mémoire dynamique
  memoryBuff := TMemoryStream.Create();
  //memoryBuff.SetSize(C_MemoryPix_MaxSize);
  memoryBuff.SetSize(MySize);
  if memoryBuff.Size <> MySize then begin
    memoryBuff.SetSize(0);
    memoryBuff.Destroy;
    memoryBuff := nil;
    raise E_AllocatedFault.Create('memory fault');
  end;
  isData := true;
  self.pwidth := width;
  self.pheight := height;
  // Init de la mémoire
  for x:=0 to width - 1 do begin
    for y := 0 to height - 1 do begin
      setPixel(x,y,R,G,B,L);
    end;
    if x mod c_refresh = 0 then Application.ProcessMessages;
  end;
end;

Procedure TMemoryPix.Init(width, height : integer; R,G,B,L : Byte);
var x, y : integer;
begin
  isData := false;
  // Calcul de la taille mémoire nécessire
  //MySize := self.memorysize(width, height);
  isData := true;
  // Affectation de la taille de l'image aux propriétés de l'objet
  self.pwidth := width;
  self.pheight := height;
  // Init de la mémoire
  for x:=0 to width - 1 do begin
    for y := 0 to height - 1 do begin
      setPixel(x, y, R,G,B,L);
    end;
    if x mod c_refresh = 0 then Application.ProcessMessages;
  end;
end;


constructor TMemoryPix.Create(var Image : TImage) ;
var
  PixHeight, PixWidth,i, j : integer;
  Dest : PByte;
  MySize : longint;
  R, G, B : Byte;
  color : TColor;

  PixelPtr: PByte;
  PixelRowPtr: PByte;
  RawImage: TRawImage;
  BytePerPixel: integer;
  BytesPerLine: integer;


begin
  isData := false;
  // Reading source width and height
  PixHeight := Image.Picture.Height;
  PixWidth := Image.Picture.Width;

  Image.Picture.Bitmap.BeginUpdate(False);
  RawImage := Image.Picture.Bitmap.RawImage ;
  BytePerPixel := RawImage.Description.BitsPerPixel div 8;
  BytesPerLine := RawImage.Description.BytesPerLine;
  PixelRowPtr := PByte(RawImage.Data);

  // Reading source Pixel width and source line width
  // Calc of buffer size for 32bits per pixels sRGB
  MySize := self.memorysize(PixWidth, PixHeight);
  // Create buffer for internal picture
  memoryBuff := TMemoryStream.Create();
  memoryBuff.SetSize(MySize);
  if memoryBuff.Size <> MySize then begin
    memoryBuff.SetSize(0);
    memoryBuff.Destroy;
    memoryBuff := nil;
    Image.Picture.Bitmap.EndUpdate(False);
    raise E_AllocatedFault.Create('memory fault');
  end;
  isData := true;
  self.pwidth := PixWidth;
  self.pheight := PixHeight;
  // Pointer to the memorystring area
  Dest := PByte(memoryBuff.Memory)-1;
  // Copy source into internal pix
  for i := 0 to PixHeight - 1 do begin
    for j := 0 to PixWidth - 1 do
      begin
          PixelPtr := PixelRowPtr + (i * BytesPerLine) + (j * BytePerPixel);
          color := getBmpPixel(PixelPtr);
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
          //inc (Dest);
          //Dest^ := L;
      end;
    if i mod c_refresh = 0 then ProgressWindow.SetProgressInc(i/(PixHeight-1)*100);
  end;
  Image.Picture.Bitmap.EndUpdate(False);
end;

procedure TMemoryPix.Init(var Image : TImage) ;
var
  PixHeight, PixWidth,i, j : integer;
  Dest : PByte;
  R, G, B : Byte;
  color : TColor;

  PixelPtr: PByte;
  PixelRowPtr: PByte;
  RawImage: TRawImage;
  BytePerPixel: integer;
  BytesPerLine: integer;


begin
  isData := false;
  // Reading source width and height
  PixHeight := Image.Picture.Height;
  PixWidth := Image.Picture.Width;
  // Calc of buffer size for 32bits per pixels sRGB

  Image.Picture.Bitmap.BeginUpdate(False);
  RawImage := Image.Picture.Bitmap.RawImage ;
  BytePerPixel := RawImage.Description.BitsPerPixel div 8;
  BytesPerLine := RawImage.Description.BytesPerLine;
  PixelRowPtr := PByte(RawImage.Data);

  isData := true;
  // Affectation de la taille de l'image aux propriétés de l'objet
  self.pwidth := PixWidth;
  self.pheight := PixHeight;
  // Pointer on picture data
  // Pointer to the memorystring area
  Dest := PByte(memoryBuff.Memory)-1;
  // Copy source into internal pix
  for i := 0 to PixHeight - 1 do begin
    for j := 0 to PixWidth - 1 do
      begin
          PixelPtr := PixelRowPtr + (i * BytesPerLine) + (j * BytePerPixel);
          color := getBmpPixel(PixelPtr);
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
      end;
    if i mod c_refresh = 0 then ProgressWindow.SetProgressInc(i/(PixHeight-1)*100);
  end;
  Image.Picture.Bitmap.EndUpdate(False);
end;


destructor TMemoryPix.Destroy;
begin
  if memoryBuff <> nil then
    memoryBuff.Destroy;
  isData := false;
  inherited;
end;

procedure TMemoryPix.Clear;
begin
  isData := false;
  self.pwidth := 0;
  self.pheight := 0;
  inherited;
end;


function TMemoryPix.memorysize(width, height : integer) : integer;
begin
  memorysize := width * 3 * height;
end;

procedure TMemoryPix.getImageSize(var width, height : integer);
begin
  if isData then
  begin
    width := self.pwidth;
    height := self.pheight;
  end else
  begin
      width := 0;
      height := 0;
  end;
end;

procedure TMemoryPix.getPixel(x, y : integer; var R, G, B : Byte);
var R1, G1, B1 : integer;
  pixel : PByte;
begin
  if not isData then begin
    R := 0; G := 0; B := 0;
    exit;
  end;
  if (x<0) or (x>self.pwidth) or (y<0) or (y>self.pheight) then begin
    R := 0; G := 0; B := 0;
    exit;
  end;
  pixel := getPixelPos(x,y);
  B1 := integer(pixel^);
  inc(pixel);
  G1 := integer(pixel^);
  inc(pixel);
  R1 := integer(pixel^);
  R := Byte(R1);
  G := Byte(G1);
  B := Byte(B1);
end;

procedure TMemoryPix.getPixel(x, y : integer; var R, G, B, L : Byte);
var pixel : PByte;
begin
  if not isData then begin
    R := 0;
    G := 0;
    B := 0;
    L := 255;
    exit;
  end;
  if (x<0) or (x>self.pwidth) or (y<0) or (y>self.pheight) then begin
    R := 0; G := 0; B := 0; L := 0;
    exit;
  end;
  pixel := getPixelPos(x,y);
  B := pixel^;
  inc(pixel);
  G := pixel^;
  inc(pixel);
  R := pixel^;
  L := 255;
end;

 procedure TMemoryPix.getPixel(x, y : integer; var color : TColor);
var R, G, B : Byte;
begin
   if not isData then begin
     color := RGBToColor(0,0,0);
     exit;
   end;
   if (x<0) or (x>self.pwidth) or (y<0) or (y>self.pheight) then begin
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
  if (x<0) or (x>self.pwidth) or (y<0) or (y>self.pheight) then begin
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
    if (x<0) or (x>self.pwidth) or (y<0) or (y>self.pheight) then exit;
    pixel := getPixelPos(x,y);
    pixel^ := B ;
    inc(pixel);
    pixel^ := G ;
    inc(pixel);
    pixel^ := R;
  end;
end;

procedure TMemoryPix.setPixel(x, y : integer; R, G, B, L : Byte);
var
  pixel : PByte;
begin
  if isData then begin
    if (x<0) or (x>self.pwidth) or (y<0) or (y>self.pheight) then exit;
    pixel := getPixelPos(x,y);
    pixel^ := Byte((B * L) div 255) ;
    inc(pixel);
    pixel^ := Byte((G * L) div 255) ;
    inc(pixel);
    pixel^ := Byte((R * L) div 255) ;
  end;
end;

procedure TMemoryPix.setPixel(x, y : integer; color : TColor);
var
  pixel : PByte;
begin
  if isData then begin
    if (x<0) or (x>self.pwidth) or (y<0) or (y>self.pheight) then exit;
    pixel := getPixelPos(x,y);
    pixel^ := Byte(blue(color));
    inc(pixel);
    pixel^ := Byte(green(color));
    inc(pixel);
    pixel^ := Byte(red(color));
  end;
end;

procedure TMemoryPix.setPixel(x, y : integer; color : TColor; L : Byte);
var
  pixel : PByte;
begin
  if isData then begin
    if (x<0) or (x>self.pwidth) or (y<0) or (y>self.pheight) then exit;
    pixel := getPixelPos(x,y);
    pixel^ := Byte((blue(color) * L) div 255);
    inc(pixel);
    pixel^ := Byte((green(color) * L) div 255);
    inc(pixel);
    pixel^ := Byte((red(color) * L) div 255);
  end;
end;

function TMemoryPix.getPixelPos(x, y : integer) : PByte;
begin
  if not isData then getPixelPos := nil else
    getPixelPos := memoryBuff.Memory + 3 * ((self.pwidth * y) +  x);
end;

procedure TMemoryPix.copyImageIntoTImage (var Image : TImage ; _progress : boolean);
var
  Dest : PByte;
  R, G, B : Byte;
  i,j : integer;
  xend, yend : integer;
  // Utilisation d'une bitmap intermédiaire non affichée.
  // Travailler directement sur l'image affichée est exponentiel
  // en temps de traitement. Travailler sur une bitmpa non affichée
  // rend les temps de traitements acceptables même pour des images
  // de 20 Méga Pixels en 32bits.

  PixelPtr: PByte;
  PixelRowPtr: PByte;
  RawImage: TRawImage;
  BytePerPixel: integer;
  BytesPerLine: integer;


begin
  if not isData then exit;
  // Copy internal pix into Dest pix
  // Set the destination size
  yend := self.pheight;
  xend := self.pwidth;
  // Création de l'image de travail
  Image.Picture.Bitmap.BeginUpdate(False);
  Image.Picture.Bitmap.PixelFormat := pf24bit;
  Image.Picture.Bitmap.Width := xend;
  Image.Picture.Bitmap.Height := yend;
  Image.Picture.Bitmap.RawImage.CreateData(true);
  RawImage := Image.Picture.Bitmap.RawImage ;
  BytePerPixel := RawImage.Description.BitsPerPixel div 8;
  BytesPerLine := RawImage.Description.BytesPerLine;
  PixelRowPtr := PByte(RawImage.Data);

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
          // Copy into destination pix
          PixelPtr := PixelRowPtr + (i * BytesPerLine) + (j * BytePerPixel);
          setBmpPixel(PixelPtr, RGBtoColor(trunc(R),trunc(G),trunc(B)));
     end;
     if (i mod c_pixrefresh = 0) and _progress then begin
       ProgressWindow.SetProgressInc((i/(pheight-1))*_Prog_Copy+_Prog_Calc);
     end;
   end;
   // Recopie dans l'image affichée
   Image.Picture.Bitmap.EndUpdate(False);
   // Libération des ressources de l'image de travail
end;

procedure TMemoryPix.getImageFromTImage(var Image : TImage);
var
  PixHeight, PixWidth,i, j : integer;
  Dest : PByte;
  R, G, B : Byte;
  color : TColor;
  PixelPtr: PByte;
  PixelRowPtr: PByte;
  RawImage: TRawImage;
  BytePerPixel: integer;
  BytesPerLine: integer;
begin
  PixHeight := Image.Picture.Height;
  PixWidth := Image.Picture.Width;

  Image.Picture.Bitmap.BeginUpdate(False);
  RawImage := Image.Picture.Bitmap.RawImage ;
  BytePerPixel := RawImage.Description.BitsPerPixel div 8;
  BytesPerLine := RawImage.Description.BytesPerLine;
  PixelRowPtr := PByte(RawImage.Data);

  self.isData := true;
  self.pwidth := PixWidth;
  self.pheight := PixHeight;
  // Pointer to the memorystring area
  Dest := PByte(memoryBuff.Memory)-1;
  // Copy source into internal pix
  for i := 0 to PixHeight - 1 do begin
    for j := 0 to PixWidth - 1 do
      begin
            // Copy into memorystream
            PixelPtr := PixelRowPtr + (i * BytesPerLine) + (j * BytePerPixel);
            color := getBmpPixel(PixelPtr);
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
      end;
    if i mod c_refresh = 0 then ProgressWindow.SetProgressInc(i/(PixHeight-1)*100);
  end;
  Image.Picture.Bitmap.EndUpdate(False);
  isData := true;
end;

procedure TMemoryPix.drawTeintesIntoTImage(var Image : TImage; _reg : TReglages ;
    _ATonsClairs, _ATonsMoyens, _ATonsSombres : boolean);
var coefs : TCoefSatDSat;
  R,G,B : Byte;
  _R,_G,_B : integer;
  x, y, _t : integer;
  Bmp : TBitmap;
  _cr, _cg, _cb : real;
  sat : real;
  PixelPtr: PByte;
  PixelRowPtr: PByte;
  RawImage: TRawImage;
  BytePerPixel: integer;
  BytesPerLine: integer;
  _calc : boolean;
  _luminance : integer;
begin
  Bmp := TBitmap.Create();
  Bmp.Width := pwidth;
  Bmp.Height := pheight;
  Bmp.PixelFormat := pf24bit;
  Bmp.RawImage.CreateData(true);
  Bmp.BeginUpdate(False);
  RawImage := Bmp.RawImage ;
  BytePerPixel := RawImage.Description.BitsPerPixel div 8;
  BytesPerLine := RawImage.Description.BytesPerLine;
  PixelRowPtr := PByte(RawImage.Data);
  for x := 0 to pwidth - 1 do begin // boucle sur les x
    for y := 0 to pheight - 1 do begin // boucle sur les y
      // Lecture du pixel
      // Modified V1.0-RC6
      // Sous Linux il faut inverser les canaux rouge et bleu
      if PLT_CANAUX = PLT_CANAUX_INV then
        getPixel(x,y,B,G,R)
      else
        getPixel(x,y,R,G,B);
      // /Modified V1.0-RC6
      // Détermination de la luminance et s'il faut ou non faire les calculs
      _luminance := GetLuminance (_R,_G,_B);
      _calc := (((_luminance < _CTonsSombres) and _ATonsSombres) or
               ((_luminance < _CTonsMoyens) and _ATonsMoyens and (_luminance >= _CTonsSombres)) or
               ((_luminance >= _CTonsMoyens) and _ATonsClairs));

      if _calc then begin
{
        // Calcul des couleurs (application de la luminance)
        R := R;
        G := G;
        B := B;
}
        // Determination de la teinte d'appartenance
        _t := TSL_getTeinteIndex(R,G,B);
        // Determination des coefs de saturation
        coefs := TSL_getSATcoef(R,G,B);
        // Application des réglages selon la teinte
        if _t = 1 then begin // Rouge
          if _reg.rsat < 0 then begin
            _cr := -1 + coefs.r;
            _cg := 1 + coefs.g;
            _cb := 1 + coefs.b ;
            sat := - _reg.rsat;
          end else begin
            _cr := coefs.r;
            _cg := coefs.g;
            _cb := coefs.b;
            sat := _reg.rsat;
          end;
          _R := R+round((_cr * sat) + _reg.rlum) + _reg.rcor.R;
          _G := G+round((_cg * sat) + _reg.rlum) + _reg.rcor.G;
          _B := B+round((_cb * sat) + _reg.rlum) + _reg.rcor.B;
        end else if _t = 2 then begin  // Jaune
          if _reg.jsat < 0 then begin
            _cr := -1 + coefs.r;
            _cg := -1 + coefs.g;
            _cb := 1 + coefs.b ;
            sat := -_reg.jsat;
          end else begin
            _cr := coefs.r;
            _cg := coefs.g;
            _cb := coefs.b;
            sat := _reg.jsat;
          end;
          _R := R+round((_cr * sat) + _reg.jlum) + _reg.jcor.R;
          _G := G+round((_cg * sat) + _reg.jlum) + _reg.jcor.G;
          _B := B+round((_cb * sat) + _reg.jlum) + _reg.jcor.B;
        end else if _t = 3 then begin  // Vert
            if _reg.vsat < 0 then begin
              _cr := 1 + coefs.r;
              _cg := -1 + coefs.g;
              _cb := 1 + coefs.b ;
              sat := -_reg.vsat;
            end else begin
              _cr := coefs.r;
              _cg := coefs.g;
              _cb := coefs.b;
              sat := _reg.vsat;
            end;
          _R := R+round((_cr * sat) + _reg.vlum) + _reg.vcor.R;
          _G := G+round((_cg * sat) + _reg.vlum) + _reg.vcor.G;
          _B := B+round((_cb * sat) + _reg.vlum) + _reg.vcor.B;
        end else if _t = 4 then begin  // Cyan
              if _reg.csat < 0 then begin
                _cr := 1 + coefs.r;
                _cg := -1 + coefs.g;
                _cb := -1 + coefs.b ;
                sat := -_reg.csat;
              end else begin
                _cr := coefs.r;
                _cg := coefs.g;
                _cb := coefs.b;
                sat := _reg.csat;
              end;
          _R := R+round((_cr * sat) + _reg.clum) + _reg.ccor.R;
          _G := G+round((_cg * sat) + _reg.clum) + _reg.ccor.G;
          _B := B+round((_cb * sat) + _reg.clum) + _reg.ccor.B;
        end else if _t = 5 then begin  // Bleu
                if _reg.bsat < 0 then begin
                  _cr := 1 + coefs.r;
                  _cg := 1 + coefs.g;
                  _cb := -1 + coefs.b ;
                  sat := -_reg.bsat;
                end else begin
                  _cr := coefs.r;
                  _cg := coefs.g;
                  _cb := coefs.b;
                  sat := _reg.csat;
                end;
          _R := R+round((_cr * sat) + _reg.blum) + _reg.bcor.R;
          _G := G+round((_cg * sat) + _reg.blum) + _reg.bcor.G;
          _B := B+round((_cb * sat) + _reg.blum) + _reg.bcor.B;
        end else if _t = 6 then begin  // Violet
                  if _reg.violsat < 0 then begin
                    _cr := -1 + coefs.r;
                    _cg := 1 + coefs.g;
                    _cb := -1 + coefs.b ;
                    sat := -_reg.violsat;
                  end else begin
                    _cr := coefs.r;
                    _cg := coefs.g;
                    _cb := coefs.b;
                    sat := _reg.violsat;
                  end;
          _R := R+round((_cr * sat) + _reg.viollum) + _reg.violcor.R;
          _G := G+round((_cg * sat) + _reg.viollum) + _reg.violcor.G;
          _B := B+round((_cb * sat) + _reg.viollum) + _reg.violcor.B;
        end else if _t = 7 then begin  // Achromatique
          _R := R+round((coefs.r * _reg.blancsat) + _reg.blanclum);
          _G := G+round((coefs.g * _reg.blancsat) + _reg.blanclum);
          _B := B+round((coefs.b * _reg.blancsat) + _reg.blanclum);
        end ;
        if _R < 0 then _R := 0 else if _R > 255 then _R := 255;
        if _G < 0 then _G := 0 else if _G > 255 then _G := 255;
        if _B < 0 then _B := 0 else if _B > 255 then _B := 255;
        PixelPtr := PixelRowPtr + (y * BytesPerLine) + (x * BytePerPixel);
        // Sous Linux il faut rétablir l'inversion des canaux rouge et bleu
        // Modified V1.0-RC6
      end else begin
        _R := R;
        _G := G;
        _B := B;
      end;
      if PLT_CANAUX = PLT_CANAUX_INV then begin
        setBmpPixel(PixelPtr, RGBtoColor(_B,_G,_R));
        setPixel(x,y,_B,_G,_R);
      end
      else begin
        setBmpPixel(PixelPtr, RGBtoColor(_R,_G,_B)) ;
        setPixel(x,y,_R,_G,_B);
      end;
    // /Modified V1.0-RC6
    end;
    if x mod c_pixrefresh = 0 then ProgressWindow.setProgressInc(x/pwidth*100);
  end;
  Bmp.EndUpdate(False);
  Image.Picture.Bitmap.Canvas.Draw(0,0,Bmp);
  Bmp.Destroy;
end;

procedure TMemoryPix.copy(var _destimg : TMemoryPix ; _progress : boolean ; _percent : integer);
var x, y, loopl, loopg : LongInt;
  R,G,B : Byte;
begin
  _destimg.pwidth := self.pwidth;
  _destimg.pheight := self.pheight;
  loopl := self.pwidth - 1;
  loopg := self.pheight - 1;
  for x := 0 to loopl do begin
    for y := 0 to loopg do begin
      self.getPixel(x,y,R,G,B);
      _destimg.setPixel(x,y,R,G,B);
    end;
    if x mod c_pixrefresh = 0 then begin
      if not _progress then Application.ProcessMessages else
        ProgressWindow.setProgressInc(x/loopl*_percent);
    end;
  end;
end;


end.

