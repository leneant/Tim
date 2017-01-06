unit w_source;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Luminance, TSL, global, loupeUtil, saveenv;

type

  { TW_SRC }

  TW_SRC = class(TForm)
    BL_Lum: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    S2: TShape;
    View: TImage;
    S1: TShape;
    procedure S2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ViewChangeBounds(Sender: TObject);
    procedure ViewClick(Sender: TObject);
    procedure ViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ViewPictureChanged(Sender: TObject);
  private
    { private declarations }
    const _code = 8;
  public
    { public declarations }
  end;

var
  W_SRC : TW_SRC;

implementation

const WinTiTle = 20;
      CursorSize = 8;
{$R *.lfm}

procedure drawLoupe(x,y : integer);
var
  posSrc, posDest : TRect;
begin
  if x+122 > W_SRC.View.Picture.Width then x := W_SRC.View.Picture.Width - 122;
  if y+122 > W_SRC.View.Picture.Height then y := W_SRC.View.Picture.Height - 122;
  posSrc := Rect(x,y,x+122,y+122);
  posDest := Rect(0,0,122,122);
  // Copie de l'imge aux dimensions de la preview
  Loupe.imgfocus.Picture.Bitmap.Canvas.CopyRect(posDest, W_SRC.View.Picture.Bitmap.Canvas, posSrc);
end;

{ TW_SRC }

procedure TW_SRC.ViewMouseDown(Sender: TObject; Button: TMouseButton;
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
  cx := W_SRC.View.Picture.Width;
  if cx = 0 then exit;
  cy := W_SRC.View.Picture.Height;
  cx := cx / W_SRC.View.Width;
  cy := cy / W_SRC.View.Height;
  if cy < cx then co := cx else co := cy;
  dx := round((W_SRC.View.Width * co - (real(W_SRC.View.Picture.Width))) / 2) ;
  dy := round((W_SRC.View.Height * co - (real(W_SRC.View.Picture.Height))) / 2);
  posx := round((X-8)*co-dx);
  posy := round((Y-8)*co-dy);
  if (posx > 0) and (posx < W_SRC.View.Picture.Width) and
      (posy > 0) and (posy < W_SRC.View.Picture.Height) then begin
      _color := W_SRC.View.Picture.Bitmap.Canvas.Pixels[posx,posy];
      Loupe.Left := W_SRC.Left + X + CursorSize;
      Loupe.Top := W_SRC.Top + Y + WinTitle + CursorSize;
      DrawLoupe(posx,posy);
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

procedure TW_SRC.ViewMouseMove(Sender: TObject; Shift: TShiftState; X,
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
  cx := W_SRC.View.Picture.Width;
  if cx = 0 then exit;
  cy := W_SRC.View.Picture.Height;
  cx := cx / W_SRC.View.Width;
  cy := cy / W_SRC.View.Height;
  if cy < cx then co := cx else co := cy;
  dx := round((W_SRC.View.Width * co - (real(W_SRC.View.Picture.Width))) / 2) ;
  dy := round((W_SRC.View.Height * co - (real(W_SRC.View.Picture.Height))) / 2);
  posx := round((X-8)*co-dx);
  posy := round((Y-8)*co-dy);
  if (posx > 0) and (posx < W_SRC.View.Picture.Width) and
      (posy > 0) and (posy < W_SRC.View.Picture.Height) then begin
      _color := W_SRC.View.Picture.Bitmap.Canvas.Pixels[posx,posy];
      Loupe.Left := W_SRC.Left + X + CursorSize;
      Loupe.Top := W_SRC.Top + Y + WinTitle + CursorSize;
      DrawLoupe(posx,posy);
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
procedure TW_SRC.ViewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if loupe.Visible then loupe.Hide;
end;

procedure TW_SRC.ViewPictureChanged(Sender: TObject);
begin
end;

procedure TW_SRC.ViewClick(Sender: TObject);
begin
end;

procedure TW_SRC.S2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (SelectedColor^).Color := S2.Brush.Color;
end;

procedure TW_SRC.ViewChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

end.

