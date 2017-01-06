unit Unit3;

{$mode objfpc}{$H+} {$F+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, global, W_source, ProgressWindows, Diary, saveenv, loupeutil;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    imgres: TImage;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgresClick(Sender: TObject);
    procedure imgresMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgresMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure imgresMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1Click(Sender: TObject);
  private
    { private declarations }
    const _code = 7;
  public
    { public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

const WinTiTle = 20;
      CursorSize = 8;

procedure drawLoupe(x,y : integer);
var
  posSrc, posDest : TRect;
begin
  if x+122 > Form3.imgres.Picture.Width then x := Form3.imgres.Picture.Width - 122;
  if y+122 > Form3.imgres.Picture.Height then y := Form3.imgres.Picture.Height - 122;
  posSrc := Rect(x,y,x+122,y+122);
  posDest := Rect(0,0,122,122);
  // Copie de l'imge aux dimensions de la preview
  Loupe.imgfocus.Picture.Bitmap.Canvas.CopyRect(posDest, Form3.imgres.Picture.Bitmap.Canvas, posSrc);
end;


{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
var txt, ext : ansistring;
  _locparam : TParam;
  _locparams : TCommandLineParams;
  _loccommand : TCommandLine;
begin
  if _event then exit;
  _event := true;
  SaveDialog1.Title := 'Enregistrement au format .BMP';
  SaveDialog1.DefaultExt := 'bmp';
  SaveDialog1.Filter := 'BMP picture|*.bmp;*.BMP';
  Screen.Cursor := crHourGlass;
  Savedialog1.FileName := '';
  if SaveDialog1.Execute then begin
    form3.enabled := false;
    txt := SaveDialog1.FileName;
    ext :=  ExtractFileExt(txt);
    try
       Form3.imgres.Picture.SaveToFile(txt, ext);
       init_param(_locparams);
       _locparam := new_param('File name', txt);
       add_param(_locparams, _locparam);
       _loccommand := new_command('Enregistrement intermédiaire de l''image', _locparams);
       writeCommand(_diaryfilename, _loccommand);
    Except
      MessageDlg('Erreur','Echec de l''enregistrement', mtConfirmation,
      [mbYes],0);
    end;
    form3.enabled := true;
  end;
  Screen.Cursor := crDefault;
  _event := false;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  if _event then exit;
  if not isTransaction then begin
    _event := true;
    Screen.Cursor := crHourGlass;
    _SourcePix.Width:= imgres.Picture.Bitmap.Width;
    _SourcePix.Height:= imgres.Picture.Bitmap.Height;
    _SourcePix.SetSize(imgres.Picture.Bitmap.Width, imgres.Picture.Bitmap.Height);
    _SourcePix.PixelFormat := pf24bit;
    _SourcePix.Canvas.Draw(0,0, imgres.Picture.Bitmap);
    W_SRC.View.Picture.Bitmap.Width:= imgres.Picture.Bitmap.Width;
    W_SRC.View.Picture.Bitmap.Height:= imgres.Picture.Bitmap.Height;
    W_SRC.View.Picture.Bitmap.SetSize(imgres.Picture.Bitmap.Width, imgres.Picture.Bitmap.Height);
    W_SRC.View.Picture.Bitmap.PixelFormat := pf24bit;
    W_SRC.View.Picture.Bitmap.Canvas.Draw(0,0, imgres.Picture.Bitmap);
    //preparePreview(imgres, W_Prev.Preview);
    // Analyse de l'image
    ProgressWindow.showWindow('Validation des traitements', 'Affectation dans la zone de travail...');
    _calculatedpix.copy(_finalpix, true, 100);
    _isfinal := true;
    ProgressWindow.setProgress('Préparation achevée', 100);
    _S_Reanalyse := true;
    _S_Canceled := false;
    writeCommand(_diaryfilename, _command);
    _event:= false;
    ProgressWindow.hideWindow;
    isTransaction := false;
    Form3.Hide;
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  _S_Reanalyse := false;
  _S_Canceled := true;
  Form3.Hide;
end;

procedure TForm3.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TForm3.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
end;

procedure TForm3.FormCreate(Sender: TObject);
begin

end;

procedure TForm3.FormHide(Sender: TObject);
begin
  imgres.Picture.bitmap.width := 0;
  imgres.Picture.bitmap.height := 0;
  imgres.Picture.Bitmap.Clear;
  if _currentWin <> nil then
    (_currentWin^).setFocus;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  _S_Canceled := true;
end;

procedure TForm3.imgresClick(Sender: TObject);
begin

end;

procedure TForm3.imgresMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  cx, cy, co : real;
  dx, dy, posx, posy : LongInt;
begin
  if not loupe.Visible then loupe.Show;
  // Calcul des échelles en x et y
  cx := Form3.imgres.Picture.Width;
  if cx = 0 then exit;
  cy := Form3.imgres.Picture.Height;
  cx := cx / Form3.imgres.Width;
  cy := cy / Form3.imgres.Height;
  if cy < cx then co := cx else co := cy;
  dx := round((Form3.imgres.Width * co - (real(Form3.imgres.Picture.Width))) / 2) ;
  dy := round((Form3.imgres.Height * co - (real(Form3.imgres.Picture.Height))) / 2);
  posx := round((X-8)*co-dx);
  posy := round((Y-8)*co-dy);
  if (posx > 0) and (posx < Form3.imgres.Picture.Width) and
      (posy > 0) and (posy < Form3.imgres.Picture.Height) then begin
      Loupe.Left := Form3.Left + X + CursorSize;
      Loupe.Top := Form3.Top + Y + WinTitle + CursorSize;
      DrawLoupe(posx,posy);
  end;
end;

procedure TForm3.imgresMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  cx, cy, co : real;
  dx, dy, posx, posy : LongInt;
begin
  if not (ssLeft in Shift) then exit ;
  // Calcul des échelles en x et y
  cx := Form3.imgres.Picture.Width;
  if cx = 0 then exit;
  cy := Form3.imgres.Picture.Height;
  cx := cx / Form3.imgres.Width;
  cy := cy / Form3.imgres.Height;
  if cy < cx then co := cx else co := cy;
  dx := round((Form3.imgres.Width * co - (real(Form3.imgres.Picture.Width))) / 2) ;
  dy := round((Form3.imgres.Height * co - (real(Form3.imgres.Picture.Height))) / 2);
  posx := round((X-8)*co-dx);
  posy := round((Y-8)*co-dy);
  if (posx > 0) and (posx < Form3.imgres.Picture.Width) and
      (posy > 0) and (posy < Form3.imgres.Picture.Height) then begin
      Loupe.Left := Form3.Left + X + CursorSize;
      Loupe.Top := Form3.Top + Y + WinTitle + CursorSize;
      DrawLoupe(posx,posy);
  end;
end;

procedure TForm3.imgresMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if loupe.Visible then loupe.Hide;
end;

procedure TForm3.Panel1Click(Sender: TObject);
begin

end;

end.

