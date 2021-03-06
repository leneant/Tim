unit W_saturation;

{$mode objfpc}{$H+} {$F+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Global, MemoryPix, unit3, ProgressWindows, TSL, Prev,
  Diary, marqueurs, types, w_source, saveenv, constantes;

type

  { TW_Sat }

  TW_Sat = class(TForm)
    BtnApply: TButton;
    BtnApply2: TButton;
    CB_C: TCheckBox;
    CB_M: TCheckBox;
    CB_S: TCheckBox;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RB1: TCheckBox;
    Image1: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    JL: TLabel;
    RB2: TCheckBox;
    RB3: TCheckBox;
    RB4: TCheckBox;
    RB5: TCheckBox;
    RB6: TCheckBox;
    RB7: TCheckBox;
    RS1: TLabel;
    RS2: TLabel;
    RS3: TLabel;
    RS7: TLabel;
    RS8: TLabel;
    RS9: TLabel;
    Shape36: TShape;
    Shape37: TShape;
    Shape38: TShape;
    Shape39: TShape;
    Shape40: TShape;
    Shape41: TShape;
    Shape42: TShape;
    Shape43: TShape;
    Shape44: TShape;
    Shape45: TShape;
    Shape47: TShape;
    Shape48: TShape;
    Shape50: TShape;
    Shape51: TShape;
    Shape53: TShape;
    Shape54: TShape;
    Shape56: TShape;
    Shape57: TShape;
    Shape59: TShape;
    Shape60: TShape;
    Shape61: TShape;
    Shape62: TShape;
    Shape63: TShape;
    Shape64: TShape;
    Shape65: TShape;
    Shape66: TShape;
    Shape9: TShape;
    TB1: TTrackBar;
    TB2: TTrackBar;
    TB3: TTrackBar;
    TB4: TTrackBar;
    TB5: TTrackBar;
    TB6: TTrackBar;
    VL: TLabel;
    CL: TLabel;
    RL4: TLabel;
    RL5: TLabel;
    RL6: TLabel;
    RS: TLabel;
    Lum1: TScrollBar;
    Lum2: TScrollBar;
    Lum3: TScrollBar;
    Lum4: TScrollBar;
    Lum5: TScrollBar;
    Lum6: TScrollBar;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    PerRouge: TImage;
    Panel1: TPanel;
    PerJaune: TImage;
    PerVert: TImage;
    PerCyan: TImage;
    PerBleu: TImage;
    PerViolet: TImage;
    PerBlanc: TImage;
    RL: TLabel;
    JS: TLabel;
    VS: TLabel;
    CS: TLabel;
    RS4: TLabel;
    RS5: TLabel;
    RS6: TLabel;
    Sat: TScrollBar;
    Lum: TScrollBar;
    Sat1: TScrollBar;
    Sat2: TScrollBar;
    Sat3: TScrollBar;
    Sat4: TScrollBar;
    Sat5: TScrollBar;
    Sat6: TScrollBar;
    Shape1: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    Shape2: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    Shape29: TShape;
    Shape3: TShape;
    Shape30: TShape;
    Shape31: TShape;
    Shape32: TShape;
    Shape33: TShape;
    Shape34: TShape;
    Shape35: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    procedure BtnApply2Click(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure CB_CChange(Sender: TObject);
    procedure CB_MChange(Sender: TObject);
    procedure CB_SChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Lum1Change(Sender: TObject);
    procedure Lum2Change(Sender: TObject);
    procedure Lum3Change(Sender: TObject);
    procedure Lum4Change(Sender: TObject);
    procedure Lum5Change(Sender: TObject);
    procedure Lum6Change(Sender: TObject);
    procedure LumChange(Sender: TObject);
    procedure PreviewClick(Sender: TObject);
    procedure PreviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RB1Change(Sender: TObject);
    procedure RB2Change(Sender: TObject);
    procedure RB3Change(Sender: TObject);
    procedure RB4Change(Sender: TObject);
    procedure RB5Change(Sender: TObject);
    procedure RB6Change(Sender: TObject);
    procedure RB7Change(Sender: TObject);
    procedure RBT1Change(Sender: TObject);
    procedure RBT1Click(Sender: TObject);
    procedure RBT1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RBT1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RS3Click(Sender: TObject);
    procedure S2ChangeBounds(Sender: TObject);
    procedure Sat1Change(Sender: TObject);
    procedure Sat2Change(Sender: TObject);
    procedure Sat3Change(Sender: TObject);
    procedure Sat4Change(Sender: TObject);
    procedure Sat5Change(Sender: TObject);
    procedure Sat6Change(Sender: TObject);
    procedure SatChange(Sender: TObject);
    procedure Shape9ChangeBounds(Sender: TObject);
    procedure TB1Change(Sender: TObject);
    procedure TB1Click(Sender: TObject);
    procedure TB1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB1KeyPress(Sender: TObject; var Key: char);
    procedure TB1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB2Change(Sender: TObject);
    procedure TB2Click(Sender: TObject);
    procedure TB2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB2MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB3Change(Sender: TObject);
    procedure TB3Click(Sender: TObject);
    procedure TB3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB3MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB3MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB4Change(Sender: TObject);
    procedure TB4Click(Sender: TObject);
    procedure TB4KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB4MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB5Change(Sender: TObject);
    procedure TB5Click(Sender: TObject);
    procedure TB5KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB5MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB6Change(Sender: TObject);
    procedure TB6Click(Sender: TObject);
    procedure TB6KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB6MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB6MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB6MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { private declarations }
    const _code = 2;
    procedure Reinit;
  public
    { public declarations }
    procedure Init;
    procedure setControlEnabled(en:boolean);
  end;

var
  W_Sat: TW_Sat;
  _init : boolean;

implementation

{$R *.lfm}
// Variables de modification de la saturation et de la lumière des différentes teintes.
var _rsat, _rlum, _jsat, _jlum, _vsat, _vlum, _csat, _clum, _bsat, _blum, _viosat, _violum, _blancsat, _blanclum : integer;

Procedure reanalyse;
const br=255;
  bg=255;
  bb=255;
var nbpix, total : LongInt;
  _width, _height, _percent : integer;
begin
  if _event then exit;
  _event := true;
  screen.cursor := crHourglass;
  W_Sat.Show;
  ProgressWindow.ShowWindow('Initialisation', 'Analyse colorimétrique');
  ProgressWindow.setProgress(30);
  if _ismprev then begin
    _mpreview.Destroy();
    _ismprev := false;
  end;
  _mpreview := TListPixels.Create();
  _ismprev := true;
  Application.ProcessMessages;
  _mpreview.getImageFromTImage(W_Prev.Preview);
  W_Sat.Init;

  progressWindow.SetProgress('Reprise terminée.', 100);

  // Calcul du nombre de pixel par teinte
  // #1 nb total de pixels
  total :=  _mpreview.IOO.nbPixels;
  total := total + _mpreview.IIO.nbPixels;
  total := total + _mpreview.OIO.nbPixels;
  total := total + _mpreview.OII.nbPixels;
  total := total + _mpreview.OOI.nbPixels;
  total := total + _mpreview.IOI.nbPixels;
  total := total + _mpreview.III.nbPixels;
  _height := W_Sat.PerRouge.Height;
  _width := W_Sat.PerRouge.Width;
  if total = 0 then total := 1;
  //PerRouge
  W_Sat.PerRouge.Picture.Bitmap.Width := _width;
  W_Sat.PerRouge.Picture.Bitmap.Height := _height;
  W_Sat.PerRouge.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerRouge.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.IOO.nbPixels/total*_width);
  W_Sat.PerRouge.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerRouge.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerJaune
  W_Sat.PerJaune.Picture.Bitmap.Width := _width;
  W_Sat.PerJaune.Picture.Bitmap.Height := _height;
  W_Sat.PerJaune.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerJaune.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.IIO.nbPixels/total*_width);
  W_Sat.PerJaune.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerJaune.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerVert
  W_Sat.PerVert.Picture.Bitmap.Width := _width;
  W_Sat.PerVert.Picture.Bitmap.Height := _height;
  W_Sat.PerVert.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerVert.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.OIO.nbPixels/total*_width);
  W_Sat.PerVert.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerVert.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerCyan
  W_Sat.PerCyan.Picture.Bitmap.Width := _width;
  W_Sat.PerCyan.Picture.Bitmap.Height := _height;
  W_Sat.PerCyan.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerCyan.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.OII.nbPixels/total*_width);
  W_Sat.PerCyan.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerCyan.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerBleu
  W_Sat.PerBleu.Picture.Bitmap.Width := _width;
  W_Sat.PerBleu.Picture.Bitmap.Height := _height;
  W_Sat.PerBleu.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerBleu.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.OOI.nbPixels/total*_width);
  W_Sat.PerBleu.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerBleu.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerViolet
  W_Sat.PerViolet.Picture.Bitmap.Width := _width;
  W_Sat.PerViolet.Picture.Bitmap.Height := _height;
  W_Sat.PerViolet.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerViolet.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.IOI.nbPixels/total*_width);
  W_Sat.PerViolet.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerViolet.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerBlanc
  W_Sat.PerBlanc.Picture.Bitmap.Width := _width;
  W_Sat.PerBlanc.Picture.Bitmap.Height := _height;
  W_Sat.PerBlanc.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerBlanc.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.III.nbPixels/total*_width);
  W_Sat.PerBlanc.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerBlanc.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);

  progressWindow.hideWindow;
  screen.cursor := crDefault;
  _event := false;
end;


{ TW_Sat }
procedure TW_Sat.Reinit;
var _interImg : TImage;
begin
  if _event then exit;
  _event := true;
  screen.cursor := crHourglass;
  ProgressWindow.ShowWindow('Recalcul', 'Prise en compte des nouveaux paramètres.');
  _interImg := TImage.Create(W_Sat);
  _interImg.Picture.Bitmap := _SourcePix;
  preparePreview(_interImg, W_Prev.Preview);
  _interImg.Destroy;
  ProgressWindow.setProgress(30);
  if _ismprev then begin
    _mpreview.Destroy();
    _ismprev := false;
  end;
  _mpreview := TListPixels.Create();
  _ismprev := true;
  Application.ProcessMessages;
  _mpreview.getImageFromTImage(W_Prev.Preview);
  progressWindow.SetProgress('Reprise terminée.', 100);

  progressWindow.hideWindow;
  screen.cursor := crDefault;
  _event := false;
end;

procedure TW_Sat.setControlEnabled(en:boolean);
begin
  TB1.Enabled := en;
  TB2.Enabled := en;
  TB3.Enabled := en;
  TB4.Enabled := en;
  TB5.Enabled := en;
  TB6.Enabled := en;
  Sat.Enabled := en;
  Lum.Enabled := en;
  Sat1.Enabled := en;
  Lum1.Enabled := en;
  Sat2.Enabled := en;
  Lum2.Enabled := en;
  Sat3.Enabled := en;
  Lum3.Enabled := en;
  Sat4.Enabled := en;
  Lum4.Enabled := en;
  Sat5.Enabled := en;
  Lum5.Enabled := en;
  Sat6.Enabled := en;
  Lum6.Enabled := en;
  RB1.Enabled := en;
  RB2.Enabled := en;
  RB3.Enabled := en;
  RB4.Enabled := en;
  RB5.Enabled := en;
  RB6.Enabled := en;
  RB7.Enabled := en;
  BtnApply.Enabled := en;
  BtnApply2.Enabled := en;
  GroupBox1.enabled := en;
end;

procedure TW_Sat.Init;
begin
  _init := true;
  W_Sat.perRouge.Picture.Bitmap.Clear;
  W_Sat.perJaune.Picture.Bitmap.Clear;
  W_Sat.perVert.Picture.Bitmap.Clear;
  W_Sat.perCyan.Picture.Bitmap.Clear;
  W_Sat.perBleu.Picture.Bitmap.Clear;
  W_Sat.perViolet.Picture.Bitmap.Clear;
  W_Sat.perBlanc.Picture.Bitmap.Clear;
  TB1.Position := 255;
  TB2.Position := 255;
  TB3.Position := 255;
  TB4.Position := 255;
  TB5.Position := 255;
  TB6.Position := 255;
  Sat.Position := 500;
  Lum.Position := 500;
  Sat1.Position := 500;
  Lum1.Position := 500;
  Sat2.Position := 500;
  Lum2.Position := 500;
  Sat3.Position := 500;
  Lum3.Position := 500;
  Sat4.Position := 500;
  Lum4.Position := 500;
  Sat5.Position := 500;
  Lum5.Position := 500;
  Sat6.Position := 500;
  Lum6.Position := 500;
  RS.Caption := '0';
  RL.Caption := '0';
  RS1.Caption := '0';
  JS.Caption := '0';
  JL.Caption := '0';
  VS.Caption := '0';
  VL.Caption := '0';
  CS.Caption := '0';
  CL.Caption := '0';
  RS2.Caption := '0';
  RS3.Caption := '0';
  RS4.Caption := '0';
  RL4.Caption := '0';
  RS5.Caption := '0';
  RL5.Caption := '0';
  RS6.Caption := '0';
  RS7.Caption := '0';
  RS8.Caption := '0';
  RS9.Caption := '0';
  RL6.Caption := '0';
  RB1.Checked := true;
  RB2.Checked := true;
  RB3.Checked := true;
  RB4.Checked := true;
  RB5.Checked := true;
  RB6.Checked := true;
  RB7.Checked := true;
  CB_C.Checked := _ATonsClairs;
  CB_M.Checked := _ATonsMoyens;
  CB_S.Checked := _ATonsSombres;
  _init := false;
end;

procedure TW_Sat.Shape9ChangeBounds(Sender: TObject);
begin

end;

procedure TW_Sat.TB1Change(Sender: TObject);
begin

end;

procedure TW_Sat.TB1Click(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TB1KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Sat.TB1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var ccor : TColorAdapt;
  _R,_G,_B : integer;
  _valeur : integer;
  _txt : string;
begin
  if _event or _init then exit;
  _event := true;
  _rsat := 500 - Sat.Position;
  _rlum := 500 - Lum.Position;
  _valeur := TB1.Position - 255;
  str(_valeur, _txt);
  RS1.Caption := _txt;
  ccor := TSL_DecalTeinte(1, TB1.Position);
  with ccor do begin
    _R := 255 + R;
    _G := G;
    _B := B;
  end;
  if _R < 0 then _R := 0 else if _R > 255 then _R := 255;
  if _G < 0 then _G := 0 else if _G > 255 then _G := 255;
  if _R < 0 then _B := 0 else if _B > 255 then _B := 255;
  Shape61.Brush.Color := RGBToColor(_R, _G, _B);
  _mpreview.drawTeinteIntoTImage(1,W_Prev.Preview,RB1.checked, _rsat, _rlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB1KeyDown(Sender, Key, Shift);
  end;

end;

procedure TW_Sat.TB1KeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TW_Sat.TB1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB1.Enabled := false;
    TB1.Enabled := true;
    TB1.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB1KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Sat.TB1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Sat.TB1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB1Click(Sender);
end;

procedure TW_Sat.TB2Change(Sender: TObject);
begin
end;

procedure TW_Sat.TB2Click(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TB2KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Sat.TB2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var ccor : TColorAdapt;
  _R,_G,_B : integer;
  _txt : string;
  _valeur : integer;
begin
  if _event or _init then exit;
  _event := true;
  _jsat := 500 - Sat1.Position;
  _jlum := 500 - Lum1.Position;
  ccor := TSL_DecalTeinte(2, TB2.Position);
  _valeur := TB2.Position - 255;
  str(_valeur, _txt);
  RS2.Caption := _txt;
  with ccor do begin
    _R := 255 + R;
    _G := 255 + G;
    _B := B;
  end;
  if _R < 0 then _R := 0 else if _R > 255 then _R := 255;
  if _G < 0 then _G := 0 else if _G > 255 then _G := 255;
  if _R < 0 then _B := 0 else if _B > 255 then _B := 255;
  Shape62.Brush.Color := RGBToColor(_R, _G, _B);
  _mpreview.drawTeinteIntoTImage(2,W_Prev.Preview,RB2.checked, _jsat, _jlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB2KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Sat.TB2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB2.Enabled := false;
    TB2.Enabled := true;
    TB2.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB2KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Sat.TB2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Sat.TB2MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB2Click(Sender);
end;

procedure TW_Sat.TB3Change(Sender: TObject);
begin

end;

procedure TW_Sat.TB3Click(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TB3KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Sat.TB3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var ccor : TColorAdapt;
  _R,_G,_B : integer;
  _valeur : integer;
  _txt : string;
begin
  if _event or _init then exit;
  _event := true;
  _vsat := 500 - Sat2.Position;
  _vlum := 500 - Lum2.Position;
  ccor := TSL_DecalTeinte(3, TB3.Position);
  _valeur := TB3.Position - 255;
  str(_valeur, _txt);
  RS3.Caption := _txt;
  with ccor do begin
    _R := R;
    _G := 255 + G;
    _B := B;
  end;
  if _R < 0 then _R := 0 else if _R > 255 then _R := 255;
  if _G < 0 then _G := 0 else if _G > 255 then _G := 255;
  if _R < 0 then _B := 0 else if _B > 255 then _B := 255;
  Shape63.Brush.Color := RGBToColor(_R, _G, _B);
  _mpreview.drawTeinteIntoTImage(3,W_Prev.Preview,RB3.checked, _vsat, _vlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB3KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Sat.TB3MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB3.Enabled := false;
    TB3.Enabled := true;
    TB3.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB3KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Sat.TB3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Sat.TB3MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB3Click(Sender);
end;

procedure TW_Sat.TB4Change(Sender: TObject);
begin

end;

procedure TW_Sat.TB4Click(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TB4KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Sat.TB4KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var ccor : TColorAdapt;
  _R,_G,_B : integer;
  _txt : string;
  _valeur : integer;
begin
  if _event or _init then exit;
  _event := true;
  _csat := 500 - Sat3.Position;
  _clum := 500 - Lum3.Position;
  ccor := TSL_DecalTeinte(4, TB4.Position);
  _valeur := TB4.Position - 255;
  str(_valeur, _txt);
  RS7.Caption := _txt;
  with ccor do begin
    _R := R;
    _G := 255 + G;
    _B := 255 + B;
  end;
  if _R < 0 then _R := 0 else if _R > 255 then _R := 255;
  if _G < 0 then _G := 0 else if _G > 255 then _G := 255;
  if _R < 0 then _B := 0 else if _B > 255 then _B := 255;
  Shape64.Brush.Color := RGBToColor(_R, _G, _B);
  _mpreview.drawTeinteIntoTImage(4,W_Prev.Preview,RB4.checked, _csat, _clum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB4KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Sat.TB4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB4.Enabled := false;
    TB4.Enabled := true;
    TB4.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB4KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Sat.TB4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Sat.TB4MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB4Click(Sender);
end;

procedure TW_Sat.TB5Change(Sender: TObject);
begin

end;

procedure TW_Sat.TB5Click(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TB5KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Sat.TB5KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var ccor : TColorAdapt;
  _R,_G,_B : integer;
  _txt : string;
  _valeur : integer;
begin
  if _event or _init then exit;
  _event := true;
  _bsat := 500 - Sat4.Position;
  _blum := 500 - Lum4.Position;
  ccor := TSL_DecalTeinte(5, TB5.Position);
  _valeur := TB5.Position - 255;
  str(_valeur, _txt);
  RS8.Caption := _txt;
  with ccor do begin
    _R := R;
    _G := G;
    _B := 255 + B;
  end;
  if _R < 0 then _R := 0 else if _R > 255 then _R := 255;
  if _G < 0 then _G := 0 else if _G > 255 then _G := 255;
  if _R < 0 then _B := 0 else if _B > 255 then _B := 255;
  Shape65.Brush.Color := RGBToColor(_R, _G, _B);
  _mpreview.drawTeinteIntoTImage(5,W_Prev.Preview,RB5.checked, _bsat, _blum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB5KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Sat.TB5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB5.Enabled := false;
    TB5.Enabled := true;
    TB5.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB5KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Sat.TB5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Sat.TB5MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB5Click(Sender);
end;

procedure TW_Sat.TB6Change(Sender: TObject);
begin

end;

procedure TW_Sat.TB6Click(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TB6KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Sat.TB6KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var ccor : TColorAdapt;
  _R,_G,_B : integer;
  _txt : string;
  _valeur : integer;
begin
  if _event or _init then exit;
  _event := true;
  _viosat := 500 - Sat5.Position;
  _violum := 500 - Lum5.Position;
  ccor := TSL_DecalTeinte(6, TB6.Position);
  _valeur := TB6.Position - 255;
  str(_valeur, _txt);
  RS9.Caption := _txt;
  with ccor do begin
    _R := 255 + R;
    _G := G;
    _B := 255 + B;
  end;
  if _R < 0 then _R := 0 else if _R > 255 then _R := 255;
  if _G < 0 then _G := 0 else if _G > 255 then _G := 255;
  if _R < 0 then _B := 0 else if _B > 255 then _B := 255;
  Shape66.Brush.Color := RGBToColor(_R, _G, _B);
  _mpreview.drawTeinteIntoTImage(6,W_Prev.Preview,RB6.checked, _viosat, _violum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB6KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Sat.TB6MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB6.Enabled := false;
    TB6.Enabled := true;
    TB6.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB6KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Sat.TB6MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Sat.TB6MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB6Click(Sender);
end;

procedure TW_Sat.Label5Click(Sender: TObject);
begin

end;

procedure TW_Sat.FormCreate(Sender: TObject);
begin
  _rsat := 0;
  _rlum := 0;
  _jsat := 0;
  _jlum := 0;
  _vsat := 0;
  _vlum := 0;
  _csat := 0;
  _clum := 0;
  _bsat := 0;
  _blum := 0;
  _viosat := 0;
  _violum := 0;
  _blancsat := 0;
  _blanclum := 0;
end;

procedure TW_Sat.FormDestroy(Sender: TObject);
begin
end;

procedure TW_Sat.FormHide(Sender: TObject);
begin
  _S_Reanalyse := false;
  _SOpen := false;
  _currentWin := nil;
end;

procedure TW_Sat.FormShow(Sender: TObject);
begin
   Init;
end;

procedure TW_Sat.BtnApplyClick(Sender: TObject);
var _reg : TReglages;
  x,y : integer;
  _txt : string;
begin
  isTransaction := true;
  _event := true;
  W_Sat.Enabled := false;
  Form3.Show;
  Form3.Enabled := false;
  Screen.Cursor := crHourglass;
  with _reg do begin
    rsat := (500 - sat.Position) / 500;
    if rsat < 0 then
        rsat := -(rsat * rsat) * 255
    else rsat := (rsat * rsat) * 255;
    rlum := (500 - lum.Position) / 500;
    if rlum < 0 then
        rlum := -(rlum * rlum) * 255
    else rlum := (rlum * rlum) * 255;
    jsat := (500 - sat1.Position) / 500;
    if jsat < 0 then
        jsat := -(jsat * jsat) * 255
    else jsat := (jsat * jsat) * 255;
    jlum := (500 - lum1.Position) / 500;
    if jlum < 0 then
        jlum := -(jlum * jlum) * 255
    else jlum := (jlum * jlum) * 255;
    vsat := (500 - sat2.Position) / 500;
    if vsat < 0 then
        vsat := -(vsat * vsat) * 255
    else vsat := (vsat * vsat) * 255;
    vlum := (500 - lum2.Position) / 500;
    if vlum < 0 then
        vlum := -(vlum * vlum) * 255
    else vlum := (vlum * vlum) * 255;
    csat := (500 - sat3.Position) / 500;
    if csat < 0 then
        csat := -(csat * csat) * 255
    else csat := (csat * csat) * 255;
    clum := (500 - lum3.Position) / 500;
    if clum < 0 then
        clum := -(clum * clum) * 255
    else clum := (clum * clum) * 255;
    bsat := (500 - sat4.Position) / 500;
    if bsat < 0 then
        bsat := -(bsat * bsat) * 255
    else bsat := (bsat * bsat) * 255;
    blum := (500 - lum4.Position) / 500;
    if blum < 0 then
        blum := -(blum * blum) * 255
    else blum := (blum * blum) * 255;
    violsat := (500 - sat5.Position) / 500;
    if violsat < 0 then
        violsat := -(violsat * violsat) * 255
    else violsat := (violsat * violsat) * 255;
    viollum := (500 - lum5.Position) / 500;
    if viollum < 0 then
        viollum := -(viollum * viollum) * 255
    else viollum := (viollum * viollum) * 255;
    blancsat := (500 - sat6.Position) / 500;
    if blancsat < 0 then
        blancsat := -(blancsat * blancsat) * 255
    else blancsat := (blancsat * blancsat) * 255;
    blanclum := (500 - lum6.Position) / 500;
    if blanclum < 0 then
        blanclum := -(blanclum * blanclum) * 255
    else blanclum := (blanclum * blanclum) * 255;
    rcor := TSL_DecalTeinte(1, TB1.Position);
    jcor := TSL_DecalTeinte(2, TB2.Position);
    vcor := TSL_DecalTeinte(3, TB3.Position);
    ccor := TSL_DecalTeinte(4, TB4.Position);
    bcor := TSL_DecalTeinte(5, TB5.Position);
    violcor := TSL_DecalTeinte(6, TB6.Position);
  end;
  ProgressWindow.ShowWindow('Calcul de l''image', 'Application des correctifs de teintes');
  _finalpix.getImageSize(x,y);
  Form3.imgres.Picture.Bitmap.width := x;
  Form3.imgres.Picture.Bitmap.height := y;
  _calculatedpix.Init(x,y,false);
  _finalpix.copy(_calculatedpix, false, 0);
  _calculatedpix.drawTeintesIntoTImage(form3.imgres, _reg, CB_C.Checked, CB_M.Checked, CB_S.Checked);
  ProgressWindow.setProgress('Traitements terminés', 100);
  init_param(_params);
  _param := new_param('Décalage rouge', RS1.Caption);
  add_param(_params, _param);
  _param := new_param('Décalage jaune', RS2.Caption);
  add_param(_params, _param);
  _param := new_param('Décalage vert', RS3.Caption);
  add_param(_params, _param);
  _param := new_param('Décalage cyan', RS7.Caption);
  add_param(_params, _param);
  _param := new_param('Décalage bleu', RS8.Caption);
  add_param(_params, _param);
  _param := new_param('Décalage magenta', RS9.Caption);
  add_param(_params, _param);
  _param := new_param('Saturation rouge', RS.Caption);
  add_param(_params, _param);
  _param := new_param('Lumière rouge', RL.Caption);
  add_param(_params, _param);
  _param := new_param('Saturation jaune', JS.Caption);
  add_param(_params, _param);
  _param := new_param('Lumière jaune', JL.Caption);
  add_param(_params, _param);
  _param := new_param('Saturation vert', VS.Caption);
  add_param(_params, _param);
  _param := new_param('Lumière vert', VL.Caption);
  add_param(_params, _param);
  _param := new_param('Saturation cyan', CS.Caption);
  add_param(_params, _param);
  _param := new_param('Lumière cyan', CL.Caption);
  add_param(_params, _param);
  _param := new_param('Saturation bleu', RS4.Caption);
  add_param(_params, _param);
  _param := new_param('Lumière bleu', RL4.Caption);
  add_param(_params, _param);
  _param := new_param('Saturation magenta', RS5.Caption);
  add_param(_params, _param);
  _param := new_param('Lumière magenta', RS1.Caption);
  add_param(_params, _param);
  _param := new_param('Saturation monochromatique', RS6.Caption);
  add_param(_params, _param);
  _param := new_param('Lumière monochromatique', RL6.Caption);
  add_param(_params, _param);
  if RB1.Checked then
    _param := new_param('Affichage rouge', 'Oui')
  else _param := new_param('Affichage rouge', 'Non');
  add_param(_params, _param);
  if RB2.Checked then
    _param := new_param('Affichage jaune', 'Oui')
  else _param := new_param('Affichage jaune', 'Non');
  add_param(_params, _param);
  if RB3.Checked then
    _param := new_param('Affichage vert', 'Oui')
  else _param := new_param('Affichage vert', 'Non');
  add_param(_params, _param);
  if RB4.Checked then
    _param := new_param('Affichage cyan', 'Oui')
  else _param := new_param('Affichage cyan', 'Non');
  add_param(_params, _param);
  if RB5.Checked then
    _param := new_param('Affichage bleu', 'Oui')
  else _param := new_param('Affichage bleu', 'Non');
  add_param(_params, _param);
  if RB6.Checked then
    _param := new_param('Affichage magenta', 'Oui')
  else _param := new_param('Affichage magenta', 'Non');
  add_param(_params, _param);
  if RB7.Checked then
    _param := new_param('Affichage monochromatique', 'Oui')
  else _param := new_param('Affichage monochromatique', 'Non');
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
  _command := new_command('Saturation de chaque teinte', _params);
  Screen.Cursor := crDefault;
  isTransaction := false;
  ProgressWindow.HideWindow;
  _event := false;
  setControlEnabled(false);
  W_Sat.Enabled := true;
  Form3.Enabled := true;
  Form3.setFocus;
end;

procedure TW_Sat.CB_CChange(Sender: TObject);
var ccor : TColorAdapt ;
begin
  if _init then exit;
  Reinit;
  Screen.Cursor := crHourglass;
  _ATonsClairs := CB_C.Checked ;
  ccor.R := 0;
  ccor.G := 0;
  ccor.B := 0;

  _mpreview.drawTeinteIntoTImage(1,W_Prev.Preview,RB1.checked, _rsat, _rlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(2,W_Prev.Preview,RB2.checked, _jsat, _jlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(3,W_Prev.Preview,RB3.checked, _vsat, _vlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(4,W_Prev.Preview,RB4.checked, _csat, _clum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(5,W_Prev.Preview,RB5.checked, _bsat, _blum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(6,W_Prev.Preview,RB6.checked, _viosat, _violum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);

  _mpreview.drawTeinteIntoTImage(7,W_Prev.Preview,RB7.checked, _blancsat, _blanclum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  Screen.Cursor := crDefault;
end;

procedure TW_Sat.CB_MChange(Sender: TObject);
var ccor : TColorAdapt ;
begin
  if _init then exit;
  Reinit;
  Screen.Cursor := crHourglass;
  _ATonsMoyens := CB_M.Checked ;
  ccor.R := 0;
  ccor.G := 0;
  ccor.B := 0;

  _mpreview.drawTeinteIntoTImage(1,W_Prev.Preview,RB1.checked, _rsat, _rlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(2,W_Prev.Preview,RB2.checked, _jsat, _jlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(3,W_Prev.Preview,RB3.checked, _vsat, _vlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(4,W_Prev.Preview,RB4.checked, _csat, _clum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(5,W_Prev.Preview,RB5.checked, _bsat, _blum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(6,W_Prev.Preview,RB6.checked, _viosat, _violum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);

  _mpreview.drawTeinteIntoTImage(7,W_Prev.Preview,RB7.checked, _blancsat, _blanclum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);

  Screen.Cursor := crDefault;
end;

procedure TW_Sat.CB_SChange(Sender: TObject);
var ccor : TColorAdapt ;
begin
  if _init then exit;
  Reinit;
  Screen.Cursor := crHourglass;

  _ATonsSombres := CB_S.Checked ;
  ccor.R := 0;
  ccor.G := 0;
  ccor.B := 0;

  _mpreview.drawTeinteIntoTImage(1,W_Prev.Preview,RB1.checked, _rsat, _rlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(2,W_Prev.Preview,RB2.checked, _jsat, _jlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(3,W_Prev.Preview,RB3.checked, _vsat, _vlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(4,W_Prev.Preview,RB4.checked, _csat, _clum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(5,W_Prev.Preview,RB5.checked, _bsat, _blum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _mpreview.drawTeinteIntoTImage(6,W_Prev.Preview,RB6.checked, _viosat, _violum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);

  _mpreview.drawTeinteIntoTImage(7,W_Prev.Preview,RB7.checked, _blancsat, _blanclum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  Screen.Cursor := crDefault;
end;

procedure TW_Sat.FormActivate(Sender: TObject);
var ccor : TColorAdapt;
begin
  if Form3.IsVisible then exit;
  setControlEnabled(true);
  if not isTransaction then begin
    if _S_Reanalyse then begin
      _event := true;
      Init;
      preparePreview(W_SRC.View, W_Prev.Preview);
      _event := false;
      reanalyse;
      _S_Reanalyse := false;
    end else if _RefreshRequest then begin
      Reinit;
      Screen.Cursor := crHourglass;

      ccor.R := 0;
      ccor.G := 0;
      ccor.B := 0;

      _mpreview.drawTeinteIntoTImage(1,W_Prev.Preview,RB1.checked, _rsat, _rlum, ccor,
        CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
      _mpreview.drawTeinteIntoTImage(2,W_Prev.Preview,RB2.checked, _jsat, _jlum, ccor,
        CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
      _mpreview.drawTeinteIntoTImage(3,W_Prev.Preview,RB3.checked, _vsat, _vlum, ccor,
        CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
      _mpreview.drawTeinteIntoTImage(4,W_Prev.Preview,RB4.checked, _csat, _clum, ccor,
        CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
      _mpreview.drawTeinteIntoTImage(5,W_Prev.Preview,RB5.checked, _bsat, _blum, ccor,
        CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
      _mpreview.drawTeinteIntoTImage(6,W_Prev.Preview,RB6.checked, _viosat, _violum, ccor,
        CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);

      _mpreview.drawTeinteIntoTImage(7,W_Prev.Preview,RB7.checked, _blancsat, _blanclum, ccor,
        CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
      Screen.Cursor := crDefault;
    end;
  end;
  _RefreshRequest := false;
end;

procedure TW_Sat.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TW_Sat.BtnApply2Click(Sender: TObject);
const br=255;
  bg=255;
  bb=255;
var total : LongInt;
  _width, _height, _percent : integer;
  _interImg : TImage;
begin
  if _event then exit;
  _event := true;
  screen.cursor := crHourglass;
  W_Sat.Init;
  W_Sat.Show;
  ProgressWindow.ShowWindow('Reprise de l''image d''origine', 'Analyse colorimétrique');
  _interImg := TImage.Create(W_Sat);
  _interImg.Picture.Bitmap := _SourcePix;
  preparePreview(_interImg, W_Prev.Preview);
  _interImg.Destroy;
  ProgressWindow.setProgress(30);
  if _ismprev then begin
    _mpreview.Destroy();
    _ismprev := false;
  end;
  _mpreview := TListPixels.Create();
  _ismprev := true;
  Application.ProcessMessages;
  _mpreview.getImageFromTImage(W_Prev.Preview);
  progressWindow.SetProgress('Reprise terminée.', 100);

  // Calcul du nombre de pixel par teinte
  // #1 nb total de pixels
  total :=  _mpreview.IOO.nbPixels;
  total := total + _mpreview.IIO.nbPixels;
  total := total + _mpreview.OIO.nbPixels;
  total := total + _mpreview.OII.nbPixels;
  total := total + _mpreview.OOI.nbPixels;
  total := total + _mpreview.IOI.nbPixels;
  total := total + _mpreview.III.nbPixels;
  _height := W_Sat.PerRouge.Height;
  _width := W_Sat.PerRouge.Width;
  if total = 0 then total := 1;
  //PerRouge
  W_Sat.PerRouge.Picture.Bitmap.Width := _width;
  W_Sat.PerRouge.Picture.Bitmap.Height := _height;
  W_Sat.PerRouge.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerRouge.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.IOO.nbPixels/total*_width);
  W_Sat.PerRouge.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerRouge.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerJaune
  W_Sat.PerJaune.Picture.Bitmap.Width := _width;
  W_Sat.PerJaune.Picture.Bitmap.Height := _height;
  W_Sat.PerJaune.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerJaune.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.IIO.nbPixels/total*_width);
  W_Sat.PerJaune.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerJaune.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerVert
  W_Sat.PerVert.Picture.Bitmap.Width := _width;
  W_Sat.PerVert.Picture.Bitmap.Height := _height;
  W_Sat.PerVert.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerVert.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.OIO.nbPixels/total*_width);
  W_Sat.PerVert.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerVert.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerCyan
  W_Sat.PerCyan.Picture.Bitmap.Width := _width;
  W_Sat.PerCyan.Picture.Bitmap.Height := _height;
  W_Sat.PerCyan.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerCyan.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.OII.nbPixels/total*_width);
  W_Sat.PerCyan.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerCyan.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerBleu
  W_Sat.PerBleu.Picture.Bitmap.Width := _width;
  W_Sat.PerBleu.Picture.Bitmap.Height := _height;
  W_Sat.PerBleu.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerBleu.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.OOI.nbPixels/total*_width);
  W_Sat.PerBleu.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerBleu.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerViolet
  W_Sat.PerViolet.Picture.Bitmap.Width := _width;
  W_Sat.PerViolet.Picture.Bitmap.Height := _height;
  W_Sat.PerViolet.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerViolet.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.IOI.nbPixels/total*_width);
  W_Sat.PerViolet.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerViolet.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);
  //PerBlanc
  W_Sat.PerBlanc.Picture.Bitmap.Width := _width;
  W_Sat.PerBlanc.Picture.Bitmap.Height := _height;
  W_Sat.PerBlanc.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(br,bg,bb);
  W_Sat.PerBlanc.Picture.Bitmap.Canvas.FillRect(0,0,_width,_height);
  _percent := round(_mpreview.III.nbPixels/total*_width);
  W_Sat.PerBlanc.Picture.Bitmap.Canvas.Brush.Color := RGBToColor(0,68,198);
  W_Sat.PerBlanc.Picture.Bitmap.Canvas.FillRect(0,0,_percent,_height);

  progressWindow.hideWindow;
  screen.cursor := crDefault;
  _event := false;
end;


procedure TW_Sat.Label7Click(Sender: TObject);
begin

end;

procedure TW_Sat.Lum1Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _jlum := 500 - Lum1.Position;
  str(_jlum, txt);
  JL.Caption := txt;
  ccor := TSL_DecalTeinte(2, TB2.Position);
  _mpreview.drawTeinteIntoTImage(2,W_Prev.Preview,RB2.checked, _jsat, _jlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.Lum2Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _vlum := 500 - Lum2.Position;
  str(_vlum,txt);
  VL.Caption := txt;
  ccor := TSL_DecalTeinte(3, TB3.Position);
  _mpreview.drawTeinteIntoTImage(3,W_Prev.Preview,RB3.checked, _vsat, _vlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.Lum3Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _clum := 500 - Lum3.Position;
  str(_clum,txt);
  CL.Caption := txt;
  ccor := TSL_DecalTeinte(4, TB4.Position);
  _mpreview.drawTeinteIntoTImage(4,W_Prev.Preview,RB4.checked, _csat, _clum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.Lum4Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _blum := 500 - Lum4.Position;
  str(_blum,txt);
  RL4.Caption := txt;
  ccor := TSL_DecalTeinte(5, TB5.Position);
  _mpreview.drawTeinteIntoTImage(5,W_Prev.Preview,RB5.checked, _bsat, _blum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.Lum5Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _violum := 500 - Lum5.Position;
  str(_violum,txt);
  RL5.Caption := txt;
  ccor := TSL_DecalTeinte(6, TB6.Position);
  _mpreview.drawTeinteIntoTImage(6,W_Prev.Preview,RB6.checked, _viosat, _violum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.Lum6Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _blanclum := 500 - Lum6.Position;
  str(_blanclum,txt);
  RL6.Caption := txt;
  ccor.R := 0;
  ccor.G := 0;
  ccor.B := 0;
  _mpreview.drawTeinteIntoTImage(7,W_Prev.Preview,RB7.checked, _blancsat, _blanclum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.LumChange(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _rlum := 500 - Lum.Position;
  str(_rlum,txt);
  RL.Caption := txt;
  ccor := TSL_DecalTeinte(1, TB1.Position);
  _mpreview.drawTeinteIntoTImage(1,W_Prev.Preview,RB1.checked, _rsat, _rlum, ccor, CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.PreviewClick(Sender: TObject);
begin

end;

procedure TW_Sat.PreviewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Sat.RB1Change(Sender: TObject);
var ccor : TColorAdapt;
begin
  if _init then exit;
  W_Sat.TB1Click(Sender);
end;

procedure TW_Sat.RB2Change(Sender: TObject);
var ccor : TColorAdapt;
begin
  if _init then exit;
  W_Sat.TB2Click(Sender);
end;

procedure TW_Sat.RB3Change(Sender: TObject);
var ccor : TColorAdapt;
begin
  if _init then exit;
  W_Sat.TB3Click(Sender);
end;

procedure TW_Sat.RB4Change(Sender: TObject);
var ccor : TColorAdapt;
begin
  if _init then exit;
  W_Sat.TB4Click(Sender) ;
end;

procedure TW_Sat.RB5Change(Sender: TObject);
var ccor : TColorAdapt;
begin
  if _init then exit;
  W_Sat.TB5Click(Sender);
end;

procedure TW_Sat.RB6Change(Sender: TObject);
var ccor : TColorAdapt;
begin
  if _init then exit;
  W_Sat.TB6Click(Sender);
end;

procedure TW_Sat.RB7Change(Sender: TObject);
var ccor : TColorAdapt;
begin
  if _init then exit;
  if _event then exit;
  _event := true;
  Sat6.enabled := RB7.checked;
  Lum6.enabled := RB7.checked;
  with ccor do begin
    R := 0;
    G := 0;
    B := 0;
  end;
  _mpreview.drawTeinteIntoTImage(7,W_Prev.Preview,RB7.checked, _blancsat, _blanclum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.RBT1Change(Sender: TObject);
begin
end;

procedure TW_Sat.RBT1Click(Sender: TObject);
begin
end;

procedure TW_Sat.RBT1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Sat.RBT1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Sat.RS3Click(Sender: TObject);
begin

end;

procedure TW_Sat.S2ChangeBounds(Sender: TObject);
begin

end;

procedure TW_Sat.Sat1Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _jsat := 500 - Sat1.Position;
  str(_jsat, txt);
  JS.Caption := txt;
  ccor := TSL_DecalTeinte(2, TB2.Position);
  _mpreview.drawTeinteIntoTImage(2,W_Prev.Preview,RB2.checked, _jsat, _jlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.Sat2Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _vsat := 500 - Sat2.Position;
  str(_vsat,txt);
  VS.Caption := txt;
  ccor := TSL_DecalTeinte(3, TB3.Position);
  _mpreview.drawTeinteIntoTImage(3,W_Prev.Preview,RB3.checked, _vsat, _vlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.Sat3Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _csat := 500 - Sat3.Position;
  str(_csat,txt);
  CS.Caption := txt;
  ccor := TSL_DecalTeinte(4, TB4.Position);
  _mpreview.drawTeinteIntoTImage(4,W_Prev.Preview,RB4.checked, _csat, _clum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.Sat4Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event then exit;
  _event := true;
  _bsat := 500 - Sat4.Position;
  str(_bsat,txt);
  RS4.Caption := txt;
  ccor := TSL_DecalTeinte(5, TB5.Position);
  _mpreview.drawTeinteIntoTImage(5,W_Prev.Preview,RB5.checked, _bsat, _blum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.Sat5Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _viosat := 500 - Sat5.Position;
  str(_viosat,txt);
  RS5.Caption := txt;
  ccor := TSL_DecalTeinte(6, TB6.Position);
  _mpreview.drawTeinteIntoTImage(6,W_Prev.Preview,RB6.checked, _viosat, _violum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.Sat6Change(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _blancsat := 500 - Sat6.Position;
  str(_blancsat,txt);
  RS6.Caption := txt;
  ccor.R := 0;
  ccor.G := 0;
  ccor.B := 0;
  _mpreview.drawTeinteIntoTImage(7,W_Prev.Preview,RB7.checked, _blancsat, _blanclum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

procedure TW_Sat.SatChange(Sender: TObject);
var txt : string;
  ccor : TColorAdapt;
begin
  if _event or _init then exit;
  _event := true;
  _rsat := 500 - Sat.Position;
  str (_rsat, txt);
  RS.Caption := txt;
  ccor := TSL_DecalTeinte(1, TB1.Position);
  _mpreview.drawTeinteIntoTImage(1,W_Prev.Preview,RB1.checked, _rsat, _rlum, ccor,
    CB_C.Checked, CB_M.Checked, CB_S.Checked, false, 100);
  _event := false;
end;

begin
  _init := false;
end.

