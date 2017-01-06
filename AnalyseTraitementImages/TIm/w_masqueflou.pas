unit W_MasqueFlou;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Global, Convolution, Prev, unit3,
  ProgressWindows, w_source, Diary, MasqueFlou, utils, types, marqueurs,
  saveenv, Constantes;

type

  { TW_MF }

  TW_MF = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CB_Bleus: TCheckBox;
    CB_C: TCheckBox;
    CB_Cyans: TCheckBox;
    CB_Jaunes: TCheckBox;
    CB_M: TCheckBox;
    CB_Magentas: TCheckBox;
    CB_Mono: TCheckBox;
    CB_Rouges: TCheckBox;
    CB_S: TCheckBox;
    CB_Verts: TCheckBox;
    EDT_Sigma: TEdit;
    EDT_k: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    imgfocus: TImage;
    imgsrc: TImage;
    Label1: TLabel;
    Label2: TLabel;
    SB_H: TTrackBar;
    SB_V: TTrackBar;
    Shape1: TShape;
    Shape44: TShape;
    Shape45: TShape;
    TB_Sigma: TTrackBar;
    TB_k: TTrackBar;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CB_BleusChange(Sender: TObject);
    procedure CB_CChange(Sender: TObject);
    procedure CB_CouleurChange(Sender: TObject);
    procedure CB_CyansChange(Sender: TObject);
    procedure CB_JaunesChange(Sender: TObject);
    procedure CB_MagentasChange(Sender: TObject);
    procedure CB_MChange(Sender: TObject);
    procedure CB_MonoChange(Sender: TObject);
    procedure CB_RougesChange(Sender: TObject);
    procedure CB_SChange(Sender: TObject);
    procedure CB_VertsChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
    procedure imgsrcClick(Sender: TObject);
    procedure imgsrcMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgsrcMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure imgsrcMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgsrcMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure SB_H1Change(Sender: TObject);
    procedure SB_HKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SB_HMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SB_V1Change(Sender: TObject);
    procedure SB_VKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SB_VMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_kClick(Sender: TObject);
    procedure TB_kKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_kKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_kMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB_kMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_kMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_kMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_SigmaClick(Sender: TObject);
    procedure TB_SigmaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure TB_SigmaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_SigmaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TB_SigmaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_SigmaMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_SigmaMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    const _code = 14;
  public
    { public declarations }
    procedure Init;
    procedure setControlEnabled(en:boolean);
  end;

var
  W_MF: TW_MF;
  sigma, k : real;


implementation

{$R *.lfm}

procedure init_focusdraw ;
var x,y,startx,endx,starty,endy : integer;
  R,G,B : Byte;
  maxx,maxy : integer;
begin
  // Action utilisateur => Activation du Timer pour la preview
  W_MF.Timer1.Enabled := true;
  // détermination de la zone de focus
  startx := W_MF.SB_H.Position;
  starty := W_MF.SB_V.Position;
  endx := startx+120;
  endy := starty+120;
  if startx < 0 then startx := 0;
  if starty < 0 then starty := 0;
  _finalpix.GetImageSize(maxx, maxy);
  if endx > maxx then endx:=maxx;
  if endy > maxy then endy:=maxy;
  // copie de la zone
  for x := startx to endx do begin
    for y := starty to endy do begin
      // get pixel from source
      _finalpix.getPixel(x,y,R,G,B);
      // set dest pixel
      if (x-startx >= 0) and (y-starty >= 0) and (x-startx < C_Zoom_Size) and (y-starty < C_Zoom_Size) then
        _focusdrawsrc.setPixel(x-startx, y-starty, R,G,B);
    end;
  end;
  // Definition de la taille de la bitmap de focus
  W_MF.imgfocus.Picture.Bitmap.Width := 121;
  W_MF.imgfocus.Picture.Bitmap.Height := 121;
  // Calcul du masque flou sur la loupe
  MasqueFlou_ApplyMasqueFlou(_focusdrawsrc, _focusdrawdst, sigma, k,
    t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono,
    false, false);
  // Affichage de la loupe
  _focusdrawdst.copyImageIntoTImage(W_MF.imgfocus, false);
end;

procedure draw_preview;
var k1, sigma1 : real;
  x,y,x1,y1 : integer;
begin
  if W_MF.visible = false then begin // Pas de MaJ si la fenêtre est fermée.
    W_MF.Timer1.Enabled := false;
    exit;
  end;
  screen.Cursor := crHourGlass;
  // Calcul du masque flou sur la preview
  // -Récupération taille image preview
  _lumprev.getImageSize(x1,y1);
  // -Récupération taille image source
  _finalpix.getImageSize(x,y);
  // Mise à l'echelle des coef pour un rendu realiste sur la preview
  // -Calcul du dividende
  // -Modification des parametres pour la preview
  sigma1 := sigma;
  k1 := k;
  MasqueFlou_ApplyMasqueFlou(_lumprev, _calculatedpix, sigma1, k1,
    t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono,
    false, false);
  // Affichage de la preview
  _calculatedpix.copyImageIntoTImage(W_Prev.Preview, false);
  screen.Cursor := crDefault;
end;

procedure TW_MF.setControlEnabled(en:boolean);
begin
  imgsrc.Enabled := en;
  SB_V.Enabled := en;
  SB_H.Enabled := en;
  TB_sigma.Enabled := en;
  TB_k.Enabled := en;
  Button1.Enabled := en;
  Button2.Enabled := en;
  GroupBox1.Enabled := en;
  GroupBox2.Enabled := en;
end;

procedure TW_MF.SB_V1Change(Sender: TObject);
begin
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  Init_focusdraw;
  preparePreview2(W_SRC.View, W_Prev.Preview,SB_H.Position,SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_MF.SB_VKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if _event then exit;
  _event := true;
  SB_V.enabled := false;
  _reqRedraw := true;
  draw_preview;
  SB_V.enabled := true;
  _event := false;
end;

procedure TW_MF.SB_VMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
 _reqRedraw := true;
end;

procedure TW_MF.TB_kClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_kKeyDown(Sender, keypressed, Shift);
end;

procedure TW_MF.FormShow(Sender: TObject);
var x, y : integer;
begin
  _reqRedraw := false;
  W_MF.Timer1.Enabled := true;
  _event := true;
  x := W_SRC.View.Picture.Bitmap.Width;
  y := W_SRC.View.Picture.Bitmap.Height;
  imgsrc.Picture.Bitmap.Width := x;
  imgsrc.Picture.Bitmap.Height := y;
  imgsrc.Picture.Bitmap.Canvas.Draw(0,0,W_SRC.View.Picture.Bitmap);
  SB_H.Max := x - 121;
  SB_V.Max := y - 121;
  Init_focusdraw;
  _reqRedraw := true;
  _event := false;
end;

procedure TW_MF.GroupBox2Click(Sender: TObject);
begin

end;

procedure TW_MF.imgsrcClick(Sender: TObject);
begin

end;

procedure TW_MF.imgsrcMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgsrcMouseMove(Sender,Shift,X,Y);

end;

procedure TW_MF.imgsrcMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  posx, posy : integer;
  _lastevent : boolean;
  _coef : real;
  _dh, _dl : real;
begin
  if _event then exit;
  if not (ssLeft in Shift) then exit ;
  _event := true;

  _coef := max(W_SRC.View.Picture.Bitmap.Width,W_SRC.View.Picture.Bitmap.Height) / W_MF.imgsrc.Width;
  _dh := (max(W_SRC.View.Picture.Bitmap.Width,W_SRC.View.Picture.Bitmap.Height) - W_SRC.View.Picture.Bitmap.Height) / 2;
  _dl := (max(W_SRC.View.Picture.Bitmap.Width,W_SRC.View.Picture.Bitmap.Height) - W_SRC.View.Picture.Bitmap.Width) / 2;
  posx := trunc(((X-16) * _coef - _dl) + ((tx div 2) * (min(_coef, 30)/30)));
  posy := trunc(((Y-16) * _coef - _dh) + ((ty div 2) * (min(_coef, 30)/30)));
  _lastevent := _event ;
  _event := true;
  SB_V.Position := posy;
  _event := _lastevent;
  SB_H.Position := posx;
  Init_focusdraw;
  preparePreview2(W_SRC.View, W_Prev.Preview,SB_H.Position,SB_V.Position);


  _lumprev.Init(W_Prev.Preview);
  _event := false;
end;

procedure TW_MF.imgsrcMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw:=true;
  if _event then exit;
  _event := true;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_MF.SB_H.Position,W_MF.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  _event := false;
end;

procedure TW_MF.imgsrcMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
  if _event then exit;
  _event := true;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_MF.SB_H.Position,W_MF.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  draw_preview;
  _event := false;
end;

procedure TW_MF.SB_H1Change(Sender: TObject);
begin
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  Init_focusdraw;
  preparePreview2(W_SRC.View, W_Prev.Preview,SB_H.Position,SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_MF.SB_HKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if _event then exit;
  _event := true;
  SB_H.enabled := false;
  _reqRedraw := true;
  draw_preview;
  SB_H.enabled := true;
  _event := false;
end;

procedure TW_MF.SB_HMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
 _reqRedraw := true;
end;

procedure TW_MF.FormActivate(Sender: TObject);
begin
 if Form3.isVisible then exit;
 setControlEnabled(true);
 try
  if not isTransaction then begin
    screen.Cursor := crHourGlass;
    isTransaction := true;
    if _S_Reanalyse then begin
      Init;
      _S_Reanalyse := false;
    end else
    if _S_Canceled or _RefreshRequest then begin
      _event := true;
      Init_focusdraw;
      preparePreview2(W_SRC.View, W_Prev.Preview,SB_H.Position,SB_V.Position);
      _lumprev.Init(W_Prev.Preview);
      _reqRedraw := true;
      _event := false;
    end;

    prepareZoom(W_SRC.View, imgsrc, 121, 121);
    _finalpix.init(W_SRC.View);
    _RefreshRequest := false;
    screen.Cursor := crDefault;
    isTransaction := false;
  end;

 finally
   _event := false;
   isTransaction := false;
 end;
 _S_Canceled := false ;
 _RefreshRequest := false;
end;

procedure TW_MF.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
 _G_Win_Conf._fenetre[self._code].x := self.Left;
 _G_Win_Conf._fenetre[self._code].y := self.Top;
 _G_Win_Conf._fenetre[self._code]._width := self.Width;
 _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TW_MF.FormDeactivate(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TW_MF.FormHide(Sender: TObject);
begin
 imgsrc.Picture.bitmap.width := 0;
 imgsrc.Picture.bitmap.height := 0;
 imgsrc.Picture.Bitmap.Clear;
 W_MF.Timer1.Enabled := true;
 _currentWin := nil;
end;

procedure TW_MF.Button1Click(Sender: TObject);
var x, y : integer;
  _txt : string;
begin
 isTransaction := true;
 _event := true;
  Timer1.Enabled := false;
  W_MF.Enabled := false;
  Form3.Show;
  Form3.Enabled := false;
  ProgressWindow.ShowWindow('Traitements...', 'Calcul du masque flou');
  Screen.Cursor := crHourGlass ;
  _finalpix.getImageSize(x,y);
  _calculatedpix.Init(x,y,false);
  // Calcul du masque flou sur la preview
  MasqueFlou_ApplyMasqueFlou(_finalpix, _calculatedpix, sigma, k,
    t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono, false, true);
  // Affichage de la preview
  _calculatedpix.copyImageIntoTImage(Form3.imgres, true);
  ProgressWindow.SetProgress('Masque flou appliqué', 100);
  Form3.Refresh;
  init_param(_params);
  _param := new_param('Sigma', EDT_Sigma.Text);
  add_param(_params, _param);
  _param := new_param('k', EDT_k.Text);
  add_param(_params, _param);
  str (_CTonsSombres, _txt);
  _param := new_param('Limite tons sombres/tons moyens', _txt);
  add_param(_params, _param);
  str (_CTonsMoyens, _txt);
  _param := new_param('Limite tons moyens/tons clairs', _txt);
  add_param(_params, _param);
  if CB_C.Checked then
    _param := new_param('Application sur tons clairs', 'Oui')
  else
    _param := new_param('Application sur tons clairs', 'Non') ;
  add_param(_params, _param);
  if CB_M.Checked then
    _param := new_param('Application sur tons moyens', 'Oui')
  else
    _param := new_param('Application sur tons moyens', 'Non') ;
  add_param(_params, _param);
  if CB_S.Checked then
    _param := new_param('Application sur tons sombres', 'Oui')
  else
    _param := new_param('Application sur tons sombres', 'Non') ;
  add_param(_params, _param);
  if CB_Rouges.Checked then
    _param := new_param('Application sur teintes rouges', 'Oui')
  else
    _param := new_param('Application sur teintes rouges', 'Non') ;
  add_param(_params, _param);
  if CB_Jaunes.Checked then
    _param := new_param('Application sur teintes jaunes', 'Oui')
  else
    _param := new_param('Application sur teintes jaunes', 'Non') ;
  add_param(_params, _param);
  if CB_Verts.Checked then
    _param := new_param('Application sur teintes vertes', 'Oui')
  else
    _param := new_param('Application sur teintes vertes', 'Non') ;
  add_param(_params, _param);
  if CB_Cyans.Checked then
    _param := new_param('Application sur teintes cyans', 'Oui')
  else
    _param := new_param('Application sur teintes cyans', 'Non') ;
  add_param(_params, _param);
  if CB_Bleus.Checked then
    _param := new_param('Application sur teintes bleues', 'Oui')
  else
    _param := new_param('Application sur teintes bleues', 'Non') ;
  add_param(_params, _param);
  if CB_Magentas.Checked then
    _param := new_param('Application sur teintes magentas', 'Oui')
  else
    _param := new_param('Application sur teintes magentas', 'Non') ;
  add_param(_params, _param);
  if CB_Mono.Checked then
    _param := new_param('Application sur l''achromatisme', 'Oui')
  else
    _param := new_param('Application sur l''achromatisme', 'Non') ;
  add_param(_params, _param);
  _command := new_command('Masque flou', _params);
  ProgressWindow.HideWindow;
  Screen.Cursor := crDefault;
  _event := false;
  isTransaction := false;
  setControlEnabled(false);
  W_MF.Enabled := true;
  Form3.Enabled := true;
  Form3.setFocus;
end;

procedure TW_MF.Button2Click(Sender: TObject);
begin
  self.Init;
  self.FormShow(Sender);
end;

procedure TW_MF.CB_BleusChange(Sender: TObject);
begin
 screen.Cursor := crHourglass;
 t_bleu := CB_Bleus.Checked;
 Init_focusdraw;
 _reqRedraw := true;
 screen.Cursor := crDefault;
end;

procedure TW_MF.CB_CChange(Sender: TObject);
begin
 screen.Cursor := crHourglass;
 _ATonsClairs := CB_C.Checked;
 Init_focusdraw;
 _reqRedraw := true;
 screen.Cursor := crDefault;
end;

procedure TW_MF.CB_CouleurChange(Sender: TObject);
begin
end;

procedure TW_MF.CB_CyansChange(Sender: TObject);
begin
 screen.Cursor := crHourglass;
 t_cyan := CB_Cyans.Checked;
 Init_focusdraw;
 _reqRedraw := true;
 screen.Cursor := crDefault;
end;

procedure TW_MF.CB_JaunesChange(Sender: TObject);
begin
 screen.Cursor := crHourglass;
 t_jaune := CB_Jaunes.Checked;
 Init_focusdraw;
 _reqRedraw := true;
 screen.Cursor := crDefault;
end;

procedure TW_MF.CB_MagentasChange(Sender: TObject);
begin
 screen.Cursor := crHourglass;
 t_magenta := CB_Magentas.Checked;
 Init_focusdraw;
 _reqRedraw := true;
 screen.Cursor := crDefault;
end;

procedure TW_MF.CB_MChange(Sender: TObject);
begin
 screen.Cursor := crHourglass;
 _ATonsMoyens := CB_M.Checked;
 Init_focusdraw;
 _reqRedraw := true;
 screen.Cursor := crDefault;
end;

procedure TW_MF.CB_MonoChange(Sender: TObject);
begin
 screen.Cursor := crHourglass;
 t_mono := CB_Mono.Checked;
 Init_focusdraw;
 _reqRedraw := true;
 screen.Cursor := crDefault;
end;

procedure TW_MF.CB_RougesChange(Sender: TObject);
begin
 screen.Cursor := crHourglass;
 t_rouge := CB_Rouges.Checked;
 Init_focusdraw;
 _reqRedraw := true;
 screen.Cursor := crDefault;
end;

procedure TW_MF.CB_SChange(Sender: TObject);
begin
 screen.Cursor := crHourglass;
 _ATonsSombres := CB_S.Checked;
 Init_focusdraw;
 _reqRedraw := true;
 screen.Cursor := crDefault;
end;

procedure TW_MF.CB_VertsChange(Sender: TObject);
begin
 screen.Cursor := crHourglass;
 t_vert := CB_Verts.Checked;
 Init_focusdraw;
 _reqRedraw := true;
 screen.Cursor := crDefault;
end;

procedure TW_MF.TB_kKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  valeur : integer;
begin
  if _event then exit;
  Screen.Cursor := crHourGlass;
  _event := true;
 valeur := TB_k.Position;
 k := valeur / 100 ;
 EDT_k.text := _realToString(k, 2);
 EDT_k.Refresh;
 Init_focusdraw;
 _event := false;
 if _lostfocus then begin
   _lostfocus := false;
   TB_kKeyDown(Sender, Key, Shift);
 end;
 Screen.Cursor := crDefault;
end;

procedure TW_MF.TB_kKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 _reqRedraw := true;
end;

procedure TW_MF.TB_kMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_k.Enabled := false;
    TB_k.Enabled := true;
    _lostfocus := true;
    TB_k.SetFocus;
  end else begin
    keypressed := Word(#32);
    TB_kKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_MF.TB_kMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 _reqRedraw := true;
end;

procedure TW_MF.TB_kMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
    TB_kClick(Sender);
end;

procedure TW_MF.TB_kMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
end;

procedure TW_MF.TB_SigmaClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_SigmaKeyDown(Sender, keypressed, Shift);
end;

procedure TW_MF.TB_SigmaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  valeur : integer;
begin
  if _event then exit;
  Screen.Cursor := crHourGlass;
  _event := true;
 valeur := TB_Sigma.Position;
 sigma := valeur / 1000 ;
 EDT_Sigma.text := _realToString(sigma, 3);
 EDT_Sigma.Refresh;
 Init_focusdraw;
 _event := false;
 if _lostfocus then begin
   _lostfocus := false;
   TB_SigmaKeyDown(Sender, Key, Shift);
 end;
 Screen.Cursor := crDefault;
end;

procedure TW_MF.TB_SigmaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  _reqRedraw := true;
end;

procedure TW_MF.TB_SigmaMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_Sigma.Enabled := false;
    TB_Sigma.Enabled := true;
    _lostfocus := true;
    TB_Sigma.SetFocus;
  end else begin
    keypressed := Word(#32);
    TB_SigmaKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_MF.TB_SigmaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw := true;
end;

procedure TW_MF.TB_SigmaMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
    TB_SigmaClick(Sender);
    _reqRedraw := true;
end;

procedure TW_MF.TB_SigmaMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;;
end;

procedure TW_MF.Timer1Timer(Sender: TObject);
begin
  if W_MF.visible = false then begin // Pas de MaJ si la fenêtre est fermée.
    Timer1.Enabled := false;
    exit;
  end;
  if _event then exit;
  if _refreshRequest then W_MF.FormActivate(Sender) else begin
    _event := true;
    screen.Cursor := crHourglass;
    while _reqRedraw do begin
      _reqRedraw := false;
      draw_preview;
    end;
    screen.Cursor := crDefault;
    _event := false;
  end;
end;

procedure TW_MF.Init;
begin
 sigma := 0;
 k := 0;
 TB_sigma.Position := 0;
 TB_k.Position := 0;
 EDT_sigma.Text := '0.000';
 EDT_k.Text := '0.00';
 _reqRedraw := false;
 W_MF.CB_C.Checked := _ATonsClairs;
 W_MF.CB_M.Checked := _ATonsMoyens;
 W_MF.CB_S.Checked := _ATonsSombres;
 W_MF.CB_Rouges.Checked := t_rouge;
 W_MF.CB_Jaunes.Checked := t_jaune;
 W_MF.CB_Verts.Checked := t_vert;
 W_MF.CB_Cyans.Checked := t_cyan;
 W_MF.CB_Bleus.Checked := t_bleu;
 W_MF.CB_Magentas.Checked := t_magenta;
 W_MF.CB_Mono.Checked := t_Mono;

end;


end.

