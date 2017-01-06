unit loupeUtil;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, saveenv;

type

  { TLoupe }

  TLoupe = class(TForm)
    imgfocus: TImage;
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgfocusClick(Sender: TObject);
  private
    { private declarations }
    const _code = 17;
  public
    { public declarations }
  end;

var
  Loupe: TLoupe;

implementation

{$R *.lfm}

{ TLoupe }

procedure TLoupe.FormCreate(Sender: TObject);
begin
  Loupe.imgfocus.Picture.Bitmap.Width := 120;
  Loupe.imgfocus.Picture.Bitmap.Height := 120;
end;

procedure TLoupe.imgfocusClick(Sender: TObject);
begin

end;

procedure TLoupe.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

end.

