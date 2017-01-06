unit W_RGB_Align;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, RVB, global, types, Prev, marqueurs,
  unit3, ProgressWindows, Diary, saveenv, w_source;

type

  { TW_RGBAlign }

  TW_RGBAlign = class(TForm)
    BtnApply: TButton;
    BtnApply1: TButton;
    Chart1: TChart;
    G_scale: TLineSeries;
    B_scale: TLineSeries;
    R_Ind_Bouche: TShape;
    V_Ind_Bouche: TShape;
    B_Ind_Bouche: TShape;
    R_Ind_Crame: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EDT_RB: TLabel;
    EDT_RP: TLabel;
    EDT_VB: TLabel;
    EDT_VP: TLabel;
    EDT_BB: TLabel;
    EDT_BP: TLabel;
    V_Ind_Crame: TShape;
    B_Ind_Crame: TShape;
    R_scale: TLineSeries;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape43: TShape;
    Shape44: TShape;
    Shape45: TShape;
    Shape46: TShape;
    Shape47: TShape;
    Shape48: TShape;
    Shape5: TShape;
    Shape6: TShape;
    TB_RB: TTrackBar;
    TB_VB: TTrackBar;
    TB_BB: TTrackBar;
    TB_RP: TTrackBar;
    TB_VP: TTrackBar;
    TB_BP: TTrackBar;
    procedure BtnApply1Click(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure TB_BBClick(Sender: TObject);
    procedure TB_BBKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_BBMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_BPClick(Sender: TObject);
    procedure TB_BPKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_BPMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_BPMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_RBChange(Sender: TObject);
    procedure TB_RBClick(Sender: TObject);
    procedure TB_RBKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_RBMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_RBMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_RPClick(Sender: TObject);
    procedure TB_RPKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_RPMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_RPMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_VBClick(Sender: TObject);
    procedure TB_VBKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_VBMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_VPClick(Sender: TObject);
    procedure TB_VPKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_VPMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_VPMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { private declarations }
    const _code = 16;
  public
    { public declarations }
    procedure Init;
    procedure setControlEnabled(en:boolean);
  end;

var
  W_RGBAlign: TW_RGBAlign;

implementation

{$R *.lfm}
var _courbeR, _courbeV, _courbeB : MyTCourbe;
  reqRedraw : boolean;

procedure Draw_preview;
var BR,BG,BB,PR,PG,PB : real;
  i : integer;
begin
  if not isTransaction then begin
    isTransaction := true;
    while reqRedraw do begin
      reqRedraw := false;
      // Signal Rouge
      BR := W_RGBAlign.TB_RB.Position; // Decalage
      PR := 1.0 + (W_RGBAlign.TB_RP.Position / 100); // Reduction/extention plage
      // Signal Vert
      BG := W_RGBAlign.TB_VB.Position; // Decalage
      PG := 1.0 + (W_RGBAlign.TB_VP.Position / 100); // Reduction/extention plage
      // Signal Vert
      BB := W_RGBAlign.TB_BB.Position; // Decalage
      PB := 1.0 + (W_RGBAlign.TB_BP.Position / 100); // Reduction/extention plage
      // Calcul du rendu
      cramR := false;
      bouchR := false;
      cramG := false;
      bouchG := false;
      cramB := false;
      bouchB := false;
      ApplyRVBAlign(_lumprev, _calculatedpix, W_Prev.Preview,BR,BG,BB,PR,PG,PB, false);
      // Recalcul des courbes
      GetCourbesRVB (_calculatedpix, _courbeR, _courbeV, _courbeB);
      W_RGBAlign.R_scale.Clear ;
      W_RGBAlign.G_scale.Clear ;
      W_RGBAlign.B_scale.Clear ;
      for i:=0 to 255 do
        begin
          W_RGBAlign.R_scale.AddXY(i, _courbeR[i]);
          W_RGBAlign.G_scale.AddXY(i, _courbeV[i]);
          W_RGBAlign.B_scale.AddXY(i, _courbeB[i]);
        end;
      // Affichage des cramés et / ou bouchés
      if cramR then W_RGBAlign.R_Ind_Crame.Brush.Color := C_CRAME
      else W_RGBAlign.R_Ind_Crame.Brush.Color := C_RIEN;
      if bouchR then W_RGBAlign.R_Ind_Bouche.Brush.Color := C_BOUCHE
      else W_RGBAlign.R_Ind_Bouche.Brush.Color := C_RIEN;

      if cramG then W_RGBAlign.V_Ind_Crame.Brush.Color := C_CRAME
      else W_RGBAlign.V_Ind_Crame.Brush.Color := C_RIEN;
      if bouchG then W_RGBAlign.V_Ind_Bouche.Brush.Color := C_BOUCHE
      else W_RGBAlign.V_Ind_Bouche.Brush.Color := C_RIEN;

      if cramB then W_RGBAlign.B_Ind_Crame.Brush.Color := C_CRAME
      else W_RGBAlign.B_Ind_Crame.Brush.Color := C_RIEN;
      if bouchB then W_RGBAlign.B_Ind_Bouche.Brush.Color := C_BOUCHE
      else W_RGBAlign.B_Ind_Bouche.Brush.Color := C_RIEN;
    end;
    isTransaction := false;
  end;
end;

{ TW_RGBAlign }
procedure TW_RGBAlign.setControlEnabled(en:boolean);
begin
  Chart1.Enabled := en;
  TB_RB.Enabled := en;
  TB_VB.Enabled := en;
  TB_BB.Enabled := en;
  TB_RP.Enabled := en;
  TB_VP.Enabled := en;
  TB_BP.Enabled := en;
  BtnApply.Enabled := en;
  BtnApply1.Enabled := en;
end;

procedure TW_RGBAlign.FormActivate(Sender: TObject);
var i : integer;
begin
  if Form3.isVisible then exit;
  setControlEnabled(true);
  _RefreshRequest := false ;
  if not isTransaction then begin
    if _S_Reanalyse then begin
      _event := true;
      Init;
      preparePreview(W_SRC.View, W_Prev.Preview);
      _lumprev.Init(W_Prev.preview);
      GetCourbesRVB (_lumprev, _courbeR, _courbeV, _courbeB);
      W_RGBAlign.R_scale.Clear ;
      W_RGBAlign.G_scale.Clear ;
      W_RGBAlign.B_scale.Clear ;
      for i:=0 to 255 do
        begin
          W_RGBAlign.R_scale.AddXY(i, _courbeR[i]);
          W_RGBAlign.G_scale.AddXY(i, _courbeV[i]);
          W_RGBAlign.B_scale.AddXY(i, _courbeB[i]);
        end;
      _S_Reanalyse := false;
      _event := false;
    end;
  end;
end;

procedure TW_RGBAlign.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TW_RGBAlign.FormCreate(Sender: TObject);
begin

end;

procedure TW_RGBAlign.FormDeactivate(Sender: TObject);
begin
end;

procedure TW_RGBAlign.FormHide(Sender: TObject);
begin
  _currentWin := nil;
end;

procedure TW_RGBAlign.FormShow(Sender: TObject);
var i : integer;
begin
  _event := true;
  Init;
  preparePreview(W_SRC.View, W_Prev.Preview);
  GetCourbesRVB (_lumprev, _courbeR, _courbeV, _courbeB);
  W_RGBAlign.R_scale.Clear ;
  W_RGBAlign.G_scale.Clear ;
  W_RGBAlign.B_scale.Clear ;
  for i:=0 to 255 do
    begin
      W_RGBAlign.R_scale.AddXY(i, _courbeR[i]);
      W_RGBAlign.G_scale.AddXY(i, _courbeV[i]);
      W_RGBAlign.B_scale.AddXY(i, _courbeB[i]);
    end;
  _S_Reanalyse := false;
  _event := false;
end;

procedure TW_RGBAlign.BtnApplyClick(Sender: TObject);
var x, y : integer;
  BR,BG,BB,PR,PG,PB : real;
begin
  isTransaction := true;
  _event := true;
  W_RGBAlign.Enabled := false;
  try
     Form3.Show;
  except
    MessageDlg('Erreur','Pas assez de mémoire !. Libérer des ressources et ré essayer !', mtConfirmation,
    [mbYes],0);
    isTransaction := false;
    _event := false;
    W_RGBAlign.Enabled := true;
    exit;
  end;
  Form3.Enabled := false;
  ProgressWindow.ShowWindow('Traitements...', 'Application des réglages');
  Screen.Cursor := crHourGlass ;
  _finalpix.getImageSize(x,y);
  _calculatedpix.Init(x,y,false);
  // Signal Rouge
  BR := W_RGBAlign.TB_RB.Position; // Decalage
  PR := 1.0 + (W_RGBAlign.TB_RP.Position / 100); // Reduction/extention plage
  // Signal Vert
  BG := W_RGBAlign.TB_VB.Position; // Decalage
  PG := 1.0 + (W_RGBAlign.TB_VP.Position / 100); // Reduction/extention plage
  // Signal Vert
  BB := W_RGBAlign.TB_BB.Position; // Decalage
  PB := 1.0 + (W_RGBAlign.TB_BP.Position / 100); // Reduction/extention plage
  // Calcul du rendu
  ApplyRVBAlign(_finalpix, _calculatedpix, Form3.imgres,BR,BG,BB,PR,PG,PB, true);
  ProgressWindow.SetProgress('Réglages appliqués', 100);
  Form3.Refresh;
  init_param(_params);
  _param := new_param('Décalage base rouge', EDT_RB.Caption);
  add_param(_params, _param);
  _param := new_param('Réduction / Extension plage rouge', EDT_RP.Caption);
  add_param(_params, _param);

  _param := new_param('Décalage base vert', EDT_VB.Caption);
  add_param(_params, _param);
  _param := new_param('Réduction / Extension plage vert', EDT_VP.Caption);
  add_param(_params, _param);

  _param := new_param('Décalage base bleu', EDT_BB.Caption);
  add_param(_params, _param);
  _param := new_param('Réduction / Extension plage bleu', EDT_BP.Caption);
  add_param(_params, _param);

  _command := new_command('Alignement RVB', _params);

  isTransaction := false;

  ProgressWindow.HideWindow;
  setControlEnabled(false);
  W_RGBAlign.Enabled := true;
  Form3.Enabled := true;
  Screen.Cursor := crDefault;
  _event := false;
  Form3.setFocus;
end;

procedure TW_RGBAlign.BtnApply1Click(Sender: TObject);
begin
  self.Init;
  reqRedraw := true;
  Draw_preview;
end;

procedure TW_RGBAlign.Label3Click(Sender: TObject);
begin

end;

procedure TW_RGBAlign.TB_BBClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_BBKeyDown(Sender, keypressed, Shift);
end;

procedure TW_RGBAlign.TB_BBKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var valeur : integer;
  txt : string;
begin
  if _event then exit;
  _event := true;
  valeur := TB_BB.Position;
  str(valeur, txt);
  EDT_BB.caption := txt;
  reqRedraw := true;
  Draw_preview;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_BBKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_RGBAlign.TB_BBMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_BB.Enabled := false;
    TB_BB.Enabled := true;
    TB_BB.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_BBKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_RGBAlign.TB_BPClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_BPKeyDown(Sender, keypressed, Shift);
end;

procedure TW_RGBAlign.TB_BPKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var valeur : integer;
  txt : string;
begin
  if _event then exit;
  _event := true;
  valeur := TB_BP.Position;
  str(valeur, txt);
  txt := concat(txt,'%');
  EDT_BP.caption := txt;
  reqRedraw := true;
  Draw_preview;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_BPKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_RGBAlign.TB_BPMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_BP.Enabled := false;
    TB_BP.Enabled := true;
    TB_BP.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_BPKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_RGBAlign.TB_BPMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_BPClick(Sender);
end;

procedure TW_RGBAlign.TB_RBChange(Sender: TObject);
begin

end;

procedure TW_RGBAlign.TB_RBClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_RBKeyDown(Sender, keypressed, Shift);
end;

procedure TW_RGBAlign.TB_RBKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var valeur : integer;
  txt : string;
begin
  if _event then exit;
  _event := true;
  valeur := TB_RB.Position;
  str(valeur, txt);
  EDT_RB.caption := txt;
  reqRedraw := true;
  Draw_preview;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_RBKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_RGBAlign.TB_RBMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_RB.Enabled := false;
    TB_RB.Enabled := true;
    TB_RB.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_RBKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_RGBAlign.TB_RBMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_RBClick(Sender);
end;

procedure TW_RGBAlign.TB_RPClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_RPKeyDown(Sender, keypressed, Shift);
end;

procedure TW_RGBAlign.TB_RPKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var valeur : integer;
  txt : string;
begin
  if _event then exit;
  _event := true;
  valeur := TB_RP.Position;
  str(valeur, txt);
  txt := concat(txt, '%');
  EDT_RP.caption := txt;
  reqRedraw := true;
  Draw_preview;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_RPKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_RGBAlign.TB_RPMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_RP.Enabled := false;
    TB_RP.Enabled := true;
    TB_RP.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_RPKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_RGBAlign.TB_RPMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_RPClick(Sender);
end;

procedure TW_RGBAlign.TB_VBClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_VBKeyDown(Sender, keypressed, Shift);
end;

procedure TW_RGBAlign.TB_VBKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var valeur : integer;
  txt : string;
begin
  if _event then exit;
  _event := true;
  valeur := TB_VB.Position;
  str(valeur, txt);
  EDT_VB.caption := txt;
  reqRedraw := true;
  Draw_preview;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_VBKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_RGBAlign.TB_VBMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_VB.Enabled := false;
    TB_VB.Enabled := true;
    TB_VB.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_VBKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_RGBAlign.TB_VPClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_VPKeyDown(Sender, keypressed, Shift);
end;

procedure TW_RGBAlign.TB_VPKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var valeur : integer;
  txt : string;
begin
  if _event then exit;
  _event := true;
  valeur := TB_VP.Position;
  str(valeur, txt);
  txt := concat(txt,'%');
  EDT_VP.caption := txt;
  reqRedraw := true;
  Draw_preview;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_VPKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_RGBAlign.TB_VPMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_VP.Enabled := false;
    TB_VP.Enabled := true;
    TB_VP.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_VPKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_RGBAlign.TB_VPMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_VPClick(Sender);
end;

procedure TW_RGBAlign.Init;
begin
  R_scale.Clear;
  G_scale.Clear;
  B_scale.Clear;
  TB_RB.Position := 0;
  TB_VB.Position := 0;
  TB_BB.Position := 0;
  TB_RP.Position := 0;
  TB_VP.Position := 0;
  TB_BP.Position := 0;
  EDT_RB.Caption:='0';
  EDT_VB.Caption:='0';
  EDT_BB.Caption :='0';
  EDT_RP.Caption :='0%';
  EDT_VP.Caption := '0%';
  EDT_BP.Caption := '0%';

  EDT_RB.Color:=clNone;
  EDT_VB.Color:=clNone;
  EDT_BB.Color:=clNone;
  EDT_RP.Color:=clNone;
  EDT_VP.Color:=clNone;
  EDT_BP.Color:=clNone;
  R_Ind_Bouche.Brush.Color := C_RIEN;
  R_Ind_Crame.Brush.Color := C_RIEN;
  V_Ind_Bouche.Brush.Color := C_RIEN;
  V_Ind_Crame.Brush.Color := C_RIEN;
  B_Ind_Bouche.Brush.Color := C_RIEN;
  B_Ind_Crame.Brush.Color := C_RIEN;
end;

begin
  reqRedraw := false;
end.

