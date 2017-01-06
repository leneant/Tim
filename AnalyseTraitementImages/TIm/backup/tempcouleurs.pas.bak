unit TempCouleurs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, global, TSL, MemoryPix, ProgressWindows, Prev, Unit3,
  Diary, marqueurs, types, saveenv, w_source, constantes;

type

  { TW_TempCouleurs }

  TW_TempCouleurs = class(TForm)
    Button1: TButton;
    Button2: TButton;
    EDT_TMP: TEdit;
    EDT_Int: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Mire: TImage;
    Label1: TLabel;
    Shape43: TShape;
    Shape44: TShape;
    TB_TmpCouleur: TTrackBar;
    TB_TmpCouleur1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure EDT_TMPChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure TB_TmpCouleur1Change(Sender: TObject);
    procedure TB_TmpCouleur1Click(Sender: TObject);
    procedure TB_TmpCouleur1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TB_TmpCouleur1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TB_TmpCouleur1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_TmpCouleurChange(Sender: TObject);
    procedure TB_TmpCouleurClick(Sender: TObject);
    procedure TB_TmpCouleurKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TB_TmpCouleurMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TB_TmpCouleurMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { private declarations }
    const _code = 9;
  public
    { public declarations }
    procedure Init;
    procedure setControlEnabled(en:boolean);
  end;

var
  W_TempCouleurs: TW_TempCouleurs;

implementation

{$R *.lfm}

var reqRedraw : boolean;

procedure ApplyTempCouleurs (var _ImgSrc, _ImgDst : TMemoryPix; _img : TImage; _Temp : integer ; poids : real; _progress : boolean);
var _width, _height, x, y : integer;
  R,G,B : Byte;
  tempsC : TCouleur;
  couleur : TColor;
begin
  if not isTransaction then begin
    isTransaction := true;
    while reqRedraw do begin
      reqRedraw := false;
      cramee := false;
      bouchee := false;
      // Initialisation de l'image de destination
      // Lecture de la taille de l'image source
      _ImgSrc.GetImageSize(_width, _height);
      // Initialisation de l'image de destination
      _ImgDst.Init(_width, _height, false);
      // Récupération de la couleur de la température
      tempsC := TSL_TempColor(_Temp / 676);
      // Boucle de traitement
      for x := 0 to _width - 1 do begin
        for y :=0 to _height - 1 do begin
          // Lecture du pixel source
          _ImgSrc.getPixel(x,y,R,G,B);
          // Calcul de la couleur résultante
          couleur := TSL_ApplyAddColor(tempsC, integer(R),integer(G),integer(B), poids);
          // Ecriture du pixel de destination
          _ImgDst.setPixel(x,y,couleur);
        end;
        if (x mod c_refresh = 0) and _progress then ProgressWindow.SetProgressInc(x/(_width-1)*_Prog_Calc);
        Application.ProcessMessages;
      end;
      _ImgDst.copyImageIntoTImage(_img, _progress);
      if cramee then  W_TempCouleurs.EDT_Int.color := clRed
      else if bouchee then W_TempCouleurs.EDT_Int.color := clBlue
      else W_TempCouleurs.EDT_Int.color := clDefault;
      _img.Refresh;
    end;
    isTransaction := false;
  end;
end;

{ TW_TempCouleurs }

procedure TW_TempCouleurs.setControlEnabled(en:boolean);
begin
  TB_TmpCouleur.Enabled := en;
  TB_TmpCouleur1.Enabled := en;
  Button1.Enabled := en;
  Button2.Enabled := en;
end;

procedure TW_TempCouleurs.Init;
begin
  TB_TmpCouleur.Position := 450;
  TB_TmpCouleur1.Position:= 0;
  W_TempCouleurs.EDT_Int.color := clDefault
end;

procedure TW_TempCouleurs.FormCreate(Sender: TObject);
var i : integer;
  _temp, cx, cy : real;
  _tempcolor : TCouleur;
  _color : TColor;
begin
  cx := Mire.Width/676;
  cy := Mire.Height;
  Mire.Picture.Bitmap.Width := Mire.Width;
  Mire.Picture.Bitmap.Height := Mire.Height;
  for i := 0 to 675 do begin
      _temp := i / 675;
      _tempcolor := TSL_TempColor(_temp);
      _color := RGBToCOlor(round(_tempcolor.R), round(_tempcolor.V), round(_tempcolor.B));
      Mire.Picture.Bitmap.Canvas.Brush.Color := _color;
      Mire.Picture.Bitmap.Canvas.FillRect(round(i*cx),0,round((i+1)*cx),Mire.Height);
  end;
end;

procedure TW_TempCouleurs.FormHide(Sender: TObject);
begin
  _currentWin := nil;
end;

procedure TW_TempCouleurs.Button1Click(Sender: TObject);
var x,y : integer;
begin
  W_TempCouleurs.Enabled := true;
  _event := true;
  reqRedraw := true;
  Form3.Show;
  Form3.Enabled := true;
  ProgressWindow.ShowWindow('Traitements...', 'Application des réglages');
  Screen.Cursor := crHourGlass ;
  _finalpix.getImageSize(x,y);
  _calculatedpix.Init(x,y,false);
  ApplyTempCouleurs (_finalpix, _calculatedpix, Form3.imgres, TB_TmpCouleur.Position, TB_TmpCouleur1.Position / 255, true);
  ProgressWindow.SetProgress('Réglages appliqués', 100);
  Form3.Refresh;
  init_param(_params);
  _param := new_param('Coef de température', EDT_TMP.Text);
  add_param(_params, _param);
  _param := new_param('Intensité d''application', EDT_Int.Text);
  add_param(_params, _param);
  _command := new_command('Température des couleurs', _params);
  isTransaction := false;
  ProgressWindow.HideWindow;
  setControlEnabled(false);
  W_TempCouleurs.Enabled := true;
  Form3.Enabled := true;
  Screen.Cursor := crDefault;
  _event := false;
  Form3.setFocus;
end;

procedure TW_TempCouleurs.Button2Click(Sender: TObject);
begin
  self.Init;
  reqRedraw := true;
  ApplyTempCouleurs (_lumprev, _calculatedpix, W_Prev.Preview, TB_TmpCouleur.Position, TB_TmpCouleur1.Position / 255, false);
end;

procedure TW_TempCouleurs.EDT_TMPChange(Sender: TObject);
begin

end;

procedure TW_TempCouleurs.FormActivate(Sender: TObject);
begin
  if Form3.isVisible then exit;
  setControlEnabled(true);
  _RefreshRequest := false;
  if not isTransaction then begin
    if _S_Reanalyse then begin
     _event := true;
     preparePreview(W_SRC.View, W_Prev.Preview);
     _lumprev.Init(W_Prev.Preview);
     TB_TmpCouleur.Position := 450;
     TB_TmpCouleur1.Position := 0;
     _S_Reanalyse := false;
     _event := false;
    end;
  end;
end;

procedure TW_TempCouleurs.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TW_TempCouleurs.Label4Click(Sender: TObject);
begin

end;

procedure TW_TempCouleurs.TB_TmpCouleur1Change(Sender: TObject);
begin
end;

procedure TW_TempCouleurs.TB_TmpCouleur1Click(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_TmpCouleur1KeyDown(Sender, keypressed, Shift);
end;

procedure TW_TempCouleurs.TB_TmpCouleur1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _width, _height : integer;
  _tempval, _intval : string;
begin
  if _event then exit;
  _event := true;
  _lumprev.getImageSize(_width, _height);
  str(TB_TmpCouleur.Position - 450, _tempval);
  str(TB_TmpCouleur1.Position, _intval);
  EDT_TMP.Text := _tempval;
  EDT_Int.Text := _intval;
  _calculatedpix.Init(_width, _height, false);
  reqRedraw := true;
  ApplyTempCouleurs (_lumprev, _calculatedpix, W_Prev.Preview, TB_TmpCouleur.Position, TB_TmpCouleur1.Position / 255, false);
  _event := false;
end;

procedure TW_TempCouleurs.TB_TmpCouleur1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_TmpCouleur1.Enabled := false;
    TB_TmpCouleur1.Enabled := true;
    TB_TmpCouleur1.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_TmpCouleur1KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_TempCouleurs.TB_TmpCouleur1MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  TB_TmpCouleur1Click(Sender);
end;

procedure TW_TempCouleurs.TB_TmpCouleurChange(Sender: TObject);
begin
end;

procedure TW_TempCouleurs.TB_TmpCouleurClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_TmpCouleurKeyDown(Sender, keypressed, Shift);
end;

procedure TW_TempCouleurs.TB_TmpCouleurKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _width, _height : integer;
  _tempval, _intval : string;
begin
  if _event then exit;
  _event := true;
  _lumprev.getImageSize(_width, _height);
  _calculatedpix.Init(_width, _height, false);
  reqRedraw := true;
  ApplyTempCouleurs (_lumprev, _calculatedpix, W_Prev.Preview, TB_TmpCouleur.Position, TB_TmpCouleur1.Position / 255, false);
  str(TB_TmpCouleur.Position - 450, _tempval);
  str(TB_TmpCouleur1.Position, _intval);
  EDT_TMP.Text := _tempval;
  EDT_Int.Text := _intval;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_TmpCouleurKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_TempCouleurs.TB_TmpCouleurMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_TmpCouleur.Enabled := false;
    TB_TmpCouleur.Enabled := true;
    TB_TmpCouleur.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_TmpCouleurKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_TempCouleurs.TB_TmpCouleurMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  TB_TmpCouleurClick(Sender);
end;

begin
  reqRedraw := false;

end.

