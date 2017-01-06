unit MemoryPix;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Graphics;

type
  TMemoryPix = class(TObject)
    private
      isData : boolean;
      memoryBuff : TMemoryStream;
      pwidth, pheight : LongInt;
      function memorysize(width, height : LongInt) : LongInt;
      function getPixelPos(x, y : LongInt) : PByte;
    public
      constructor Create();
      constructor Create(width, height : LongInt; zeroinit : boolean);
      constructor Create(width, height : LongInt; color : TColor);
      constructor Create(width, height : LongInt; R,G,B,L : Byte);
      constructor Create(var Image : TImage);
      destructor Destroy; override;
      procedure getImageSize (var width, height : LongInt);
      procedure setPixel(x, y : LongInt; R, G, B : Byte);
      procedure setPixel(x, y : LongInt; R, G, B, L : Byte);
      procedure setPixel(x, y : LongInt; color : TColor);
      procedure setPixel(x, y : LongInt; color : TColor; L : Byte);
      procedure getPixel(x, y : LongInt; var R, G, B : Byte);
      procedure getPixel(x, y : LongInt; var R, G, B, L : Byte);
      procedure getPixel(x, y : LongInt; var color : TColor);
      procedure getPixel(x, y : LongInt; var color : TColor; var L : Byte);
      procedure copyImageIntoTImage (var Image : TImage);
      procedure getImageFromTImage (var Image : TImage);

  end ;

  T_SatCoefs = record
    _r_coef, _g_coef, _b_coef : real;
  end;

  T_PixelColors = record
    R,G,B,L : Byte
  end;

implementation

constructor TMemoryPix.Create();
begin
  isData := false;
  pwidth := 0;
  pheight := 0;
end;

constructor TMemoryPix.Create(width, height : LongInt; zeroinit : boolean);
var MySize, i : LongInt;
  buff : PByte;
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

constructor TMemoryPix.Create(width, height : LongInt; color : TColor);
var MySize, i : LongInt;
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

constructor TMemoryPix.Create(width, height : LongInt; R,G,B,L : Byte);
var MySize, i : LongInt;
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
  SourcePixelWidth, SourceLineWidth : integer;
  ScanLine, Dest : PByte;
  MySize : LongInt;
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
  for i := 0 to PixHeight - 1 do
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
end;

destructor TMemoryPix.Destroy;
begin
  if isData then memoryBuff.Destroy;
  isData := false;
  inherited;
end;

function TMemoryPix.memorysize(width, height : LongInt) : LongInt;
begin
  memorysize := width * 4 * height;
end;

procedure TMemoryPix.getImageSize(var width, height : LongInt);
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

procedure TMemoryPix.getPixel(x, y : LongInt; var R, G, B : Byte);
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

procedure TMemoryPix.getPixel(x, y : LongInt; var R, G, B, L : Byte);
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


procedure TMemoryPix.getPixel(x, y : LongInt; var color : TColor);
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

procedure TMemoryPix.getPixel(x, y : LongInt; var color : TColor; var L : Byte);
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

procedure TMemoryPix.setPixel(x, y : LongInt; R, G, B : Byte);
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

procedure TMemoryPix.setPixel(x, y : LongInt; R, G, B, L : Byte);
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

procedure TMemoryPix.setPixel(x, y : LongInt; color : TColor);
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

procedure TMemoryPix.setPixel(x, y : LongInt; color : TColor; L : Byte);
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

function TMemoryPix.getPixelPos(x, y : LongInt) : PByte;
begin
  if not isData then getPixelPos := nil else
    getPixelPos := memoryBuff.Memory + (pwidth * 4 * y) + 4 * x;
end;

procedure TMemoryPix.copyImageIntoTImage (var Image : TImage);
var
  Dest, ScanLine : PByte;
  R, G, B, L : Byte;
  i,j : LongInt;
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
   for i := 0 to pheight - 1 do
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
end;

procedure TMemoryPix.getImageFromTImage(var Image : TImage);
var
  PixHeight, PixWidth,i, j : integer;
  SourcePixelWidth, SourceLineWidth : integer;
  ScanLine, Dest : PByte;
  MySize : LongInt;
  R, G, B, L : Byte;
begin
  if isData then begin
    memoryBuff.Destroy;
    memoryBuff := nil;
  end;
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
  for i := 0 to PixHeight - 1 do
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
          R := integer(ScanLine^);
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
end;

end.

