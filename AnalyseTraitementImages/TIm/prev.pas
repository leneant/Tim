unit Prev;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, TSL, Luminance, Global, saveenv, loupeUtil;

type

  { TW_Prev }

  TW_Prev = class(TForm)
    BL_Lum: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Preview: TImage;
    S1: TShape;
    S2: TShape;
    procedure FormChangeBounds(Sender: TObject);
    procedure PreviewClick(Sender: TObject);
    procedure PreviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PreviewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PreviewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure S2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
    const _code = 6;
  public
    { public declarations }
  end;

var
  W_Prev: TW_Prev;

implementation

{$R *.lfm}
const WinTiTle = 20;
      CursorSize = 8;

procedure drawLoupe(x,y : integer);
var
  posSrc, posDest : TRect;
begin
  if x+122 > W_Prev.Preview.Picture.Width then x := W_Prev.Preview.Picture.Width - 122;
  if y+122 > W_Prev.Preview.Picture.Height then y := W_Prev.Preview.Picture.Height - 122;
  posSrc := Rect(x,y,x+122,y+122);
  posDest := Rect(0,0,122,122);
  // Copie de l'imge aux dimensions de la preview
  Loupe.imgfocus.Picture.Bitmap.Canvas.CopyRect(posDest, W_Prev.Preview.Picture.Bitmap.Canvas, posSrc);
end;

{ TW_Prev }

procedure TW_Prev.PreviewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  cx, cy, co : real;
  dx, dy, posx, posy : LongInt;
  _teinte, _lum : integer;
  R, G, B : Byte;
  _color : TColor;
  _txt : string;
begin
  if not loupe.Visible then loupe.Show;
  // Calcul des échelles en x et y
  cx := W_Prev.Preview.Picture.Width;
  if cx = 0 then exit;
  cy := W_Prev.Preview.Picture.Height;
  cx := cx / W_Prev.Preview.Width;
  cy := cy / W_Prev.Preview.Height;
  if cy < cx then co := cx else co := cy;
  dx := round((W_Prev.Preview.Width * co - (real(W_Prev.Preview.Picture.Width))) / 2) ;
  dy := round((W_Prev.Preview.Height * co - (real(W_Prev.Preview.Picture.Height))) / 2);
  posx := round((X-8)*co-dx);
  posy := round((Y-8)*co-dy);
  if (posx > 0) and (posx < W_Prev.Preview.Picture.Width) and
      (posy > 0) and (posy < W_Prev.Preview.Picture.Height) then begin
      Loupe.Left := W_Prev.Left + X + CursorSize;
      Loupe.Top := W_Prev.Top + Y + WinTitle + CursorSize;
      DrawLoupe(posx,posy);
      _color := W_Prev.Preview.Picture.Bitmap.Canvas.Pixels[posx,posy];
      S2.Brush.Color := _color;
      R := red(_color);
      G := green(_color);
      B := blue(_color);
      // Determination de la teinte
      _teinte := TSL_getTeinteIndex(R,G,B);
      S1.Brush.Color := clBlack;
      case _teinte of
        1 : S1.Brush.Color := RGBToColor(255,0,0);
        2 : S1.Brush.Color := RGBToColor(255,255,0);
        3 : S1.Brush.Color := RGBToColor(0,255,0);
        4 : S1.Brush.Color := RGBToColor(0,255,255);
        5 : S1.Brush.Color := RGBToColor(0,0,255);
        6 : S1.Brush.Color := RGBToColor(255,0,255);
        7 : S1.Brush.Color := RGBToColor(255,255,255);
      end;
      // Determination de la luminance
      _lum := GetLuminance(R,G,B);
      str(_lum, _txt);
      _txt := concat(concat('[', _txt),']');
      BL_Lum.Caption := _txt;
  end;
end;

procedure TW_Prev.PreviewMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  cx, cy, co : real;
  dx, dy, posx, posy : LongInt;
  _teinte, _lum : integer;
  R, G, B : Byte;
  _color : TColor;
  _txt : string;
begin
  if not (ssLeft in Shift) then exit ;
  // Calcul des échelles en x et y
  cx := W_Prev.Preview.Picture.Width;
  if cx = 0 then exit;
  cy := W_Prev.Preview.Picture.Height;
  cx := cx / W_Prev.Preview.Width;
  cy := cy / W_Prev.Preview.Height;
  if cy < cx then co := cx else co := cy;
  dx := round((W_Prev.Preview.Width * co - (real(W_Prev.Preview.Picture.Width))) / 2) ;
  dy := round((W_Prev.Preview.Height * co - (real(W_Prev.Preview.Picture.Height))) / 2);
  posx := round((X-8)*co-dx);
  posy := round((Y-8)*co-dy);
  if (posx > 0) and (posx < W_Prev.Preview.Picture.Width) and
      (posy > 0) and (posy < W_Prev.Preview.Picture.Height) then begin
      Loupe.Left := W_Prev.Left + X + CursorSize;
      Loupe.Top := W_Prev.Top + Y + WinTitle + CursorSize;
      DrawLoupe(posx,posy);
      _color := W_Prev.Preview.Picture.Bitmap.Canvas.Pixels[posx,posy];
      S2.Brush.Color := _color;
      R := red(_color);
      G := green(_color);
      B := blue(_color);
      // Determination de la teinte
      _teinte := TSL_getTeinteIndex(R,G,B);
      S1.Brush.Color := clBlack;
      case _teinte of
        1 : S1.Brush.Color := RGBToColor(255,0,0);
        2 : S1.Brush.Color := RGBToColor(255,255,0);
        3 : S1.Brush.Color := RGBToColor(0,255,0);
        4 : S1.Brush.Color := RGBToColor(0,255,255);
        5 : S1.Brush.Color := RGBToColor(0,0,255);
        6 : S1.Brush.Color := RGBToColor(255,0,255);
        7 : S1.Brush.Color := RGBToColor(255,255,255);
      end;
      // Determination de la luminance
      _lum := GetLuminance(R,G,B);
      str(_lum, _txt);
      _txt := concat(concat('[', _txt),']');
      BL_Lum.Caption := _txt;
  end;
end;

procedure TW_Prev.PreviewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if loupe.Visible then loupe.Hide;
end;

procedure TW_Prev.S2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (SelectedColor^).Color := S2.Brush.Color;
end;

procedure TW_Prev.PreviewClick(Sender: TObject);
begin

end;

procedure TW_Prev.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

end.

