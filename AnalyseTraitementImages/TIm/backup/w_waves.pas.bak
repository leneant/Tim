unit w_waves;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, global, utils, types, w_source, wavelets, Prev, Unit3,
  ProgressWindows, Diary, marqueurs, saveenv, Constantes;

type

  { TW_Wavelets }

  TW_Wavelets = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CB_Bleus: TCheckBox;
    CB_C: TCheckBox;
    CB_Couleur: TCheckBox;
    CB_Cyans: TCheckBox;
    CB_Jaunes: TCheckBox;
    CB_M: TCheckBox;
    CB_Magentas: TCheckBox;
    CB_Mono: TCheckBox;
    CB_Rouges: TCheckBox;
    CB_S: TCheckBox;
    CB_Denose: TCheckBox;
    CB_Ctrst: TCheckBox;
    CB_Verts: TCheckBox;
    EDT_b: TEdit;
    EDT_d: TEdit;
    EDT_e: TEdit;
    EDT_a: TEdit;
    EDT_c: TEdit;
    EDT_surimp: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    imgfocus: TImage;
    imgsrc: TImage;
    Label1: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    RB_Denose: TRadioButton;
    RB_Denose1: TRadioButton;
    Shape1: TShape;
    Shape44: TShape;
    Shape45: TShape;
    Shape46: TShape;
    Shape47: TShape;
    Shape48: TShape;
    Shape49: TShape;
    TB_b: TTrackBar;
    TB_d: TTrackBar;
    TB_e: TTrackBar;
    TB_a: TTrackBar;
    TB_c: TTrackBar;
    SB_V: TTrackBar;
    SB_H: TTrackBar;
    TB_surimp: TTrackBar;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CB_BleusChange(Sender: TObject);
    procedure CB_CChange(Sender: TObject);
    procedure CB_CouleurChange(Sender: TObject);
    procedure CB_CtrstChange(Sender: TObject);
    procedure CB_CyansChange(Sender: TObject);
    procedure CB_DenoseChange(Sender: TObject);
    procedure CB_JaunesChange(Sender: TObject);
    procedure CB_MagentasChange(Sender: TObject);
    procedure CB_MChange(Sender: TObject);
    procedure CB_MonoChange(Sender: TObject);
    procedure CB_RougesChange(Sender: TObject);
    procedure CB_SChange(Sender: TObject);
    procedure CB_VertsChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure imgsrcMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgsrcMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure imgsrcMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgsrcMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure RB_Denose1Change(Sender: TObject);
    procedure RB_DenoseChange(Sender: TObject);
    procedure SB_H1Change(Sender: TObject);
    procedure SB_HKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SB_HMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SB_V1Change(Sender: TObject);
    procedure SB_VKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SB_VMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_aClick(Sender: TObject);
    procedure TB_aKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure TB_aKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_aMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB_aMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_aMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_aMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_bClick(Sender: TObject);
    procedure TB_bKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_bKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_bMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB_bMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_bMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_bMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_cClick(Sender: TObject);
    procedure TB_cKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_cKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_cMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB_cMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_cMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_cMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_dClick(Sender: TObject);
    procedure TB_dKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_dKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_dMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB_dMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_dMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_dMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_eClick(Sender: TObject);
    procedure TB_eKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_eKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_eMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB_eMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_eMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_eMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_surimpClick(Sender: TObject);
    procedure TB_surimpKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TB_surimpKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure TB_surimpMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TB_surimpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_surimpMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_surimpMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    const _code = 15;
  public
    { public declarations }
    procedure Init;
    procedure setControlEnabled(en:boolean);
  end;

var
  W_Wavelets : TW_Wavelets;
  _a,_b,_c,_d,_e : real;
  _surimp : integer;

implementation

{$R *.lfm}

var _focusredraw_request, _apcolor : boolean;
  _previewon : boolean;

procedure setcoef (var a, b, c, d, e : real ; denose : boolean);
begin
  if W_Wavelets.RB_Denose.Checked then begin
    a := a / 20 ;
    b := b / 10 ;
    c := c / 2 ;
    d := d / 1.5 ;
    e := e ;
  end;

end;

procedure init_focusdraw ;
var x,y,startx,endx,starty,endy : integer;
  R,G,B : Byte;
  maxx, maxy : integer;
  __a,__b,__c,__d,__e : real;
begin
  while _focusredraw_request do begin
    // On traite et on annule l'évènement qui a déclenché le traitement
    _focusredraw_request := false;
    // Action utilisateur => Activation du Timer pour la preview
    W_Wavelets.Timer1.Enabled := true;
    // détermination de la zone de focus
    startx := W_Wavelets.SB_H.Position;
    starty := W_Wavelets.SB_V.Position;
    if startx < 0 then startx := 0;
    if starty < 0 then starty := 0;
    endx := startx+120;
    endy := starty+120;
    _finalpix.GetImageSize(maxx, maxy);
    // Setting focus draw size
    if endx > maxx then endx := maxx;
    if endy > maxy then endy := maxy;
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
    W_Wavelets.imgfocus.Picture.Bitmap.PixelFormat := pf24bit;
    W_Wavelets.imgfocus.Picture.Bitmap.Width := C_Zoom_Size;
    W_Wavelets.imgfocus.Picture.Bitmap.Height := C_Zoom_Size;
    W_Wavelets.imgfocus.Picture.Bitmap.SetSize(C_Zoom_Size, C_Zoom_Size);
    W_Wavelets.imgfocus.Picture.Bitmap.RawImage.CreateData(true);
    // Calcul du masque flou sur la loupe
    __a := _a;
    __b := _b;
    __c := _c;
    __d := _d;
    __e := _e;
    setcoef (__a, __b, __c, __d, __e, W_Wavelets.RB_Denose.Checked);
    Wavelets_ApplyWavelets(_focusdrawsrc, _focusdrawdst, __a,__b,__c,__d,__e, _surimp/100,
                           W_Wavelets.RB_Denose.Checked,
                           W_Wavelets.CB_Denose.Checked, W_Wavelets.CB_Ctrst.Checked,
                           _apcolor, false);
    // Affichage de la loupe
    _focusdrawdst.copyImageIntoTImage(W_Wavelets.imgfocus, false);
  end;
end;

procedure draw_preview;
var
  a,b,c,d,e : real;
  x1,y1 : integer;
begin
  if W_Wavelets.visible = false then begin // Pas de MaJ si la fenêtre est fermée.
    W_Wavelets.Timer1.Enabled := false;
    exit;
  end;
  _previewon := true;
  W_Wavelets.setControlEnabled(false);
  screen.Cursor := crHourGlass;
  // Preparation de la preview
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Wavelets.SB_H.Position,W_Wavelets.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  // Calcul du masque flou sur la preview
  // -Récupération taille image preview
  _lumprev.getImageSize(x1,y1);
  // -Récupération taille image source
  a := _a;
  b := _b;
  c := _c;
  d := _d;
  e := _e;
  setcoef (a, b, c, d, e, W_Wavelets.RB_Denose.Checked);
  Wavelets_ApplyWavelets(_lumprev, _calculatedpix, a,b,c,d,e, _surimp/100, W_Wavelets.RB_Denose.Checked, W_Wavelets.CB_Denose.Checked,
                         W_Wavelets.CB_Ctrst.Checked, _apcolor, false);
  // Affichage de la preview
  _calculatedpix.copyImageIntoTImage(W_Prev.Preview, false);
  W_Wavelets.setControlEnabled(true);
  screen.Cursor := crDefault;
end;


{ TW_Wavelets }
procedure TW_Wavelets.setControlEnabled(en:boolean);
begin
  imgsrc.Enabled := en;
  SB_V.Enabled := en;
  SB_H.Enabled := en;
  GroupBox1.Enabled := en;
  GroupBox2.Enabled := en;
  TB_a.Enabled := en;
  TB_b.Enabled := en;
  TB_c.Enabled := en;
  TB_d.Enabled := en;
  TB_e.Enabled := en;
  TB_surimp.Enabled := en;
  CB_Denose.Enabled := en;
  CB_Ctrst.Enabled := en;
  Button1.Enabled := en;
  Button2.Enabled := en;
  RB_Denose1.Enabled := en;
  RB_Denose.Enabled := en;
end;

procedure TW_Wavelets.Init;
begin
  if not _previewon then begin
    TB_a.Position := 1000;
    TB_b.Position := 1000;
    TB_c.Position := 1000;
    TB_d.Position := 1000;
    TB_e.Position := 1000;
    TB_surimp.Position := 100;
    EDT_a.Text := '1.000';
    EDT_b.Text := '1.000';
    EDT_c.Text := '1.000';
    EDT_d.Text := '1.000';
    EDT_e.Text := '1.000';
    EDT_surimp.Text := '100%';
    _a := 1;
    _b := 1;
    _c := 1;
    _d := 1;
    _e := 1;
    _surimp := 100;
    _reqRedraw := false;
    W_Wavelets.CB_C.Checked := _ATonsClairs;
    W_Wavelets.CB_M.Checked := _ATonsMoyens;
    W_Wavelets.CB_S.Checked := _ATonsSombres;
    W_Wavelets.CB_Couleur.Checked := _apcolor;
    W_Wavelets.CB_Denose.Checked := false;
    W_Wavelets.CB_Ctrst.Checked := false;
    W_Wavelets.CB_Rouges.Checked := t_rouge;
    W_Wavelets.CB_Jaunes.Checked := t_jaune;
    W_Wavelets.CB_Verts.Checked := t_vert;
    W_Wavelets.CB_Cyans.Checked := t_cyan;
    W_Wavelets.CB_Bleus.Checked := t_bleu;
    W_Wavelets.CB_Magentas.Checked := t_magenta;
    W_Wavelets.CB_Mono.Checked := t_Mono;
  end;
end;


procedure TW_Wavelets.TB_aKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  valeur : integer;
begin
  if _event then exit;
  Screen.Cursor := crHourGlass;
  _event := true;
  valeur := TB_a.Position;
  _a := valeur / 1000 ;
  EDT_a.text := _realToString(_a, 3);
  EDT_a.Refresh;
  _focusredraw_request := true;
  Init_focusdraw;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_aKeyDown(Sender, Key, Shift);
  end;
  Screen.Cursor := crDefault;
end;

procedure TW_Wavelets.TB_aKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_aMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_a.Enabled := false;
    TB_a.Enabled := true;
    _lostfocus := true;
    TB_a.SetFocus;
  end else begin
    keypressed := Word(#32);
    TB_aKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Wavelets.TB_aMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_aMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_aClick(Sender);
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_aMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_bClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_bKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Wavelets.TB_aClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_aKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Wavelets.imgsrcMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    imgsrcMouseMove(Sender,Shift,X,Y);
end;

procedure TW_Wavelets.FormShow(Sender: TObject);
var x, y : integer;
begin
  _event := true;
  W_Wavelets.Timer1.Enabled := true;
  x := W_SRC.View.Picture.Bitmap.Width;
  y := W_SRC.View.Picture.Bitmap.Height;
  imgsrc.Picture.Bitmap.Width := 121;
  imgsrc.Picture.Bitmap.Height := 121;
  prepareZoom(W_SRC.View, imgsrc,121,121);
  SB_H.Max := x - 121;
  SB_V.Max := y - 121;
  _focusredraw_request := true;
  Init_focusdraw;
  preparePreview2(W_SRC.View, W_Prev.Preview,SB_H.Position,SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  _reqRedraw := true;
  _event := false;
end;

procedure TW_Wavelets.FormActivate(Sender: TObject);
begin
  if Form3.isVisible then exit;
  setControlEnabled(true);
  try
  if _RefreshRequest and not isTransaction then begin
    Timer1.Enabled := true;
    screen.Cursor := crHourGlass;
    _event := true;
    _focusredraw_request := true;
    Init_focusdraw;
    preparePreview2(W_SRC.View, W_Prev.Preview,SB_H.Position,SB_V.Position);
    _lumprev.Init(W_Prev.Preview);
    _reqRedraw := true;
    _event := false;
    screen.Cursor := crDefault;
  end else
  if not isTransaction then begin
    Timer1.Enabled := true;
    screen.Cursor := crHourGlass;
    if _S_Reanalyse then begin
      W_Wavelets.Init;
      W_Wavelets.FormShow(sender);
    end else if _S_Canceled then begin
      _event := true;
      _finalpix.init(W_SRC.View);
      preparePreview2(W_SRC.View, W_Prev.Preview,SB_H.Position,SB_V.Position);
      _reqRedraw := true;
      _event := false;
    end else begin
      prepareZoom(W_SRC.View, imgsrc, 121, 121);
      _finalpix.init(W_SRC.View);
      _lumprev.Init(W_Prev.Preview);
    end;
    screen.Cursor := crDefault;
  end;

  finally
  end;
  _RefreshRequest := false ;
end;

procedure TW_Wavelets.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TW_Wavelets.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    _previewon := false;
end;

procedure TW_Wavelets.FormDeactivate(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TW_Wavelets.FormHide(Sender: TObject);
begin
    imgsrc.Picture.bitmap.width := 0;
    imgsrc.Picture.bitmap.height := 0;
    imgsrc.Picture.Bitmap.Clear;
    W_Wavelets.Timer1.Enabled := false;
    _currentWin := nil;
end;

procedure TW_Wavelets.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Wavelets.Button1Click(Sender: TObject);
var x, y : integer;
  _txt : string;
  a,b,c,d,e : real;
begin
  isTransaction := true;
  _event := true;
  Timer1.Enabled := false;
  W_Wavelets.enabled := false;
  Form3.Show;
  Form3.Enabled := false;
  ProgressWindow.ShowWindow('Traitements...', 'Calcul des wavelets');
  Screen.Cursor := crHourGlass ;
  _finalpix.getImageSize(x,y);
  _calculatedpix.Init(x,y,false);
  // Calcul des wavelets sur la preview
  a := _a;
  b := _b;
  c := _c;
  d := _d;
  e := _e;
  setcoef (a, b, c, d, e, W_Wavelets.RB_Denose.Checked);

  Wavelets_ApplyWavelets(_finalpix, _calculatedpix, a,b,c,d,e, _surimp/100,
                         W_Wavelets.RB_Denose.Checked,
                         W_Wavelets.CB_Denose.Checked,
                         W_Wavelets.CB_Ctrst.Checked,
                         _apcolor, true);
  // Affichage de la preview
  _calculatedpix.copyImageIntoTImage(Form3.imgres, true);
  ProgressWindow.SetProgress('Wavelets appliquées', 100);
  Form3.Refresh;
  init_param(_params);
  if W_Wavelets.RB_Denose.Checked then
    _param := new_param('Mode', 'Réduction du bruit.')
  else
      _param := new_param('Mode', 'Amélioration de l''image.');
  add_param(_params, _param);
  _param := new_param('a', EDT_a.Text);
  add_param(_params, _param);
  _param := new_param('b', EDT_b.Text);
  add_param(_params, _param);
  _param := new_param('c', EDT_c.Text);
  add_param(_params, _param);
  _param := new_param('d', EDT_d.Text);
  add_param(_params, _param);
  _param := new_param('e', EDT_e.Text);
  add_param(_params, _param);
  _param := new_param('% surimpression', EDT_surimp.Text);
  add_param(_params, _param);
  if CB_Denose.Checked then
    _param := new_param('Anti bruit', 'Activé')
  else
    _param := new_param('Anti bruit', 'Désactivé');
  add_param(_params, _param);
  if CB_Ctrst.Checked then
    _param := new_param('Amélioration du contraste', 'Activé')
  else
    _param := new_param('Amélioration du contraste', 'Désactivé');
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
  if CB_Couleur.Checked then
    _param := new_param('Contraste couleurs', 'Activé')
  else
    _param := new_param('Contraste couleurs', 'Désactivé');
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
  _command := new_command('Wavelets', _params);
  ProgressWindow.HideWindow;
  Screen.Cursor := crDefault;
  _event := false;
  isTransaction := false;
  W_Wavelets.setControlEnabled(false);
  W_Wavelets.enabled := true;
  Form3.Enabled := true;
  Form3.setFocus;
  _previewon := false;
end;

procedure TW_Wavelets.Button2Click(Sender: TObject);
begin
  _previewon := false;
  self.Init;
  self.FormShow(Sender);
end;

procedure TW_Wavelets.CB_BleusChange(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  t_bleu := CB_Bleus.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_CChange(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  _ATonsClairs := CB_C.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_CouleurChange(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  _apcolor := CB_Couleur.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_CtrstChange(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  Screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_CyansChange(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  t_cyan := CB_Cyans.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_DenoseChange(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  Screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_JaunesChange(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  t_jaune := CB_Jaunes.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_MagentasChange(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  t_magenta := CB_Magentas.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_MChange(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  _ATonsMoyens := CB_M.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_MonoChange(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  t_mono := CB_Mono.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_RougesChange(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  t_rouge := CB_Rouges.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_SChange(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  _ATonsSombres := CB_S.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.CB_VertsChange(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  t_vert := CB_Verts.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.imgsrcMouseMove(Sender: TObject; Shift: TShiftState; X,
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

    _coef := max(W_SRC.View.Picture.Bitmap.Width,W_SRC.View.Picture.Bitmap.Height) / W_Wavelets.imgsrc.Width;
    _dh := (max(W_SRC.View.Picture.Bitmap.Width,W_SRC.View.Picture.Bitmap.Height) - W_SRC.View.Picture.Bitmap.Height) / 2;
    _dl := (max(W_SRC.View.Picture.Bitmap.Width,W_SRC.View.Picture.Bitmap.Height) - W_SRC.View.Picture.Bitmap.Width) / 2;
    posx := trunc(((X-16) * _coef - _dl) + ((tx div 2) * (min(_coef, 30)/30)));
    posy := trunc(((Y-16) * _coef - _dh) + ((ty div 2) * (min(_coef, 30)/30)));
    _event := true;
    SB_V.Position := posy;
    _event := _lastevent;
    SB_H.Position := posx;
    _focusredraw_request := true;
    Init_focusdraw;
    preparePreview2(W_SRC.View, W_Prev.Preview,SB_H.Position,SB_V.Position);

    _lumprev.Init(W_Prev.Preview);
    _event := false;

end;

procedure TW_Wavelets.imgsrcMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw := true;
  if _event then exit;
  _event := true;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Wavelets.SB_H.Position,W_Wavelets.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  _event := false;
end;

procedure TW_Wavelets.imgsrcMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
  if _event then exit;
  _event := true;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Wavelets.SB_H.Position,W_Wavelets.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  _event := false;
end;

procedure TW_Wavelets.RB_Denose1Change(Sender: TObject);
begin
  W_Wavelets.Caption := ' Wavelets - Amélioration de l''image';
  screen.Cursor := crHourglass;
  _ATonsClairs := CB_C.Checked;
  _focusredraw_request := true;
  Init_focusdraw;
  _reqRedraw := true;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.RB_DenoseChange(Sender: TObject);
begin
    W_Wavelets.Caption := ' Wavelets - Réduction du bruit';
end;

procedure TW_Wavelets.SB_H1Change(Sender: TObject);
begin
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  _focusredraw_request := true;
  Init_focusdraw;
  preparePreview2(W_SRC.View, W_Prev.Preview,SB_H.Position,SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.SB_HKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _reqRedraw := true;
  if _event then exit;
  _event := true;
  SB_H.enabled := false;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Wavelets.SB_H.Position,W_Wavelets.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  _reqRedraw := true;
  SB_H.Enabled := true;
  _event := false;
end;

procedure TW_Wavelets.SB_HMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.SB_V1Change(Sender: TObject);
begin
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  _focusredraw_request := true;
  Init_focusdraw;
  preparePreview2(W_SRC.View, W_Prev.Preview,SB_H.Position,SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_Wavelets.SB_VKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _reqRedraw := true;
  if _event then exit;
  _event := true;
  SB_V.enabled := false;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Wavelets.SB_H.Position,W_Wavelets.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  SB_V.Enabled := true;
  _event := false;
end;

procedure TW_Wavelets.SB_VMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_bKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  valeur : integer;
begin
  if _event then exit;
  Screen.Cursor := crHourGlass;
  _event := true;
  valeur := TB_b.Position;
  _b := valeur / 1000 ;
  EDT_b.text := _realToString(_b, 3);
  EDT_b.Refresh;

  _focusredraw_request := true;
  Init_focusdraw;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_bKeyDown(Sender, Key, Shift);
  end;
  Screen.Cursor := crDefault;
end;

procedure TW_Wavelets.TB_bKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_bMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_b.Enabled := false;
    TB_b.Enabled := true;
    _lostfocus := true;
    TB_b.SetFocus;
  end else begin
    keypressed := Word(#32);
    TB_bKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Wavelets.TB_bMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_bMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_bClick(Sender);
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_bMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_cClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_cKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Wavelets.TB_cKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  valeur : integer;
begin
  if _event then exit;
  Screen.Cursor := crHourGlass;
  _event := true;
  valeur := TB_c.Position;
  _c := valeur / 1000 ;
  EDT_c.text := _realToString(_c, 3);
  EDT_c.Refresh;

  _focusredraw_request := true;
  Init_focusdraw;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_cKeyDown(Sender, Key, Shift);
  end;
  Screen.Cursor := crDefault;
end;

procedure TW_Wavelets.TB_cKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_cMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_c.Enabled := false;
    TB_c.Enabled := true;
    _lostfocus := true;
    TB_c.SetFocus;
  end else begin
    keypressed := Word(#32);
    TB_cKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Wavelets.TB_cMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_cMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_cClick(Sender);
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_cMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_dClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_dKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Wavelets.TB_dKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  valeur : integer;
begin
  if _event then exit;
  Screen.Cursor := crHourGlass;
  _event := true;
  valeur := TB_d.Position;
  _d := valeur / 1000 ;
  EDT_d.text := _realToString(_d, 3);
  EDT_d.Refresh;


  _focusredraw_request := true;
  Init_focusdraw;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_dKeyDown(Sender, Key, Shift);
  end;
  Screen.Cursor := crDefault;
end;

procedure TW_Wavelets.TB_dKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_dMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_d.Enabled := false;
    TB_d.Enabled := true;
    _lostfocus := true;
    TB_d.SetFocus;
  end else begin
    keypressed := Word(#32);
    TB_dKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Wavelets.TB_dMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_dMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_dClick(Sender);
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_dMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_eClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_eKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Wavelets.TB_eKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  valeur : integer;
begin
  if _event then exit;
  Screen.Cursor := crHourGlass;
  _event := true;
  valeur := TB_e.Position;
  _e := valeur / 1000 ;
  EDT_e.text := _realToString(_e, 3);
  EDT_e.Refresh;

  _focusredraw_request := true;
  Init_focusdraw;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_eKeyDown(Sender, Key, Shift);
  end;
  Screen.Cursor := crDefault;
end;

procedure TW_Wavelets.TB_eKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_eMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_e.Enabled := false;
    TB_e.Enabled := true;
    _lostfocus := true;
    TB_e.SetFocus;
  end else begin
    keypressed := Word(#32);
    TB_eKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Wavelets.TB_eMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_eMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_eClick(Sender);
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_eMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_surimpClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_surimpKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Wavelets.TB_surimpKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _txt : string;
begin
  if _event then exit;
  Screen.Cursor := crHourGlass;
  _event := true;
  _surimp := TB_surimp.Position; ;
  str(_surimp, _txt);
  _txt := concat(_txt, '%');
  EDT_surimp.Text := _txt;
  EDT_surimp.Refresh;
  _focusredraw_request := true;
  Init_focusdraw;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_eKeyDown(Sender, Key, Shift);
  end;
  Screen.Cursor := crDefault;
end;

procedure TW_Wavelets.TB_surimpKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_surimpMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_surimp.Enabled := false;
    TB_surimp.Enabled := true;
    _lostfocus := true;
    TB_surimp.SetFocus;
  end else begin
    keypressed := Word(#32);
    TB_surimpKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Wavelets.TB_surimpMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_surimpMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_surimpClick(Sender);
  _reqRedraw := true;
end;

procedure TW_Wavelets.TB_surimpMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
end;

procedure TW_Wavelets.Timer1Timer(Sender: TObject);
begin
  if W_Wavelets.visible = false then begin // Pas de MaJ si la fenêtre est fermée.
    Timer1.Enabled := false;
    exit;
  end;
  if _event then exit;
  if _RefreshRequest then W_Wavelets.FormActivate(Sender) else begin
    _event := true;
    Screen.Cursor := crHourglass;
    while _reqRedraw do begin
      _reqRedraw := false;
      draw_preview;
    end;
    screen.Cursor := crDefault;
    _event := false;

  end;
end;

begin
  // Initialisation des variables locales.
  _focusredraw_request := false;
  _apcolor := true;
  _surimp := 100;
  _previewon := false;
end.

