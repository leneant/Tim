unit W_RGBToBN;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, global, timexception, types, RVB, MemoryPix, Prev,
  constantes, unit3, saveenv, progresswindows, diary;

type

  { TW__RGBToBN }

  TW__RGBToBN = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Shape47: TShape;
    Shape48: TShape;
    Shape49: TShape;
    TB_R: TTrackBar;
    TB_B: TTrackBar;
    TB_V: TTrackBar;
    TXT_R: TEdit;
    TXT_B: TEdit;
    TXT_V: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure StaticText6Click(Sender: TObject);
    procedure TB_BClick(Sender: TObject);
    procedure TB_BKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_BMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB_BMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_RClick(Sender: TObject);
    procedure TB_RKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_RMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB_RMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_VClick(Sender: TObject);
    procedure TB_VKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_VMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TB_VMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure RefreshCaption();
  private
    { private declarations }
    const _code = 21;
    var R_Value, G_Value, B_Value : integer;

    procedure new_bleuval(b : integer);
    procedure new_greenval (g : integer);
    procedure new_redval (r : integer);
    procedure previewRedraw;
    procedure setControlEnabled(en : boolean);

  public
    { public declarations }
    Procedure Init;
  end;

var
  W__RGBToBN: TW__RGBToBN;
  _updatePreview : boolean;

implementation

{$R *.lfm}

procedure TW__RGBToBN.setControlEnabled(en : boolean);
begin
  TB_R.enabled := en;
  TB_V.enabled := en;
  TB_B.enabled := en;
  Button1.enabled := en;
  Button2.enabled := en;
end;

procedure TW__RGBToBN.Init;
var delta : integer;
begin
  R_Value := trunc(_C_LR * 10000);
  G_Value := trunc(_C_LV * 10000);
  B_Value := trunc(_C_LB * 10000);
  delta := 10000 - B_Value - R_Value - G_Value;
  if delta > 0 then begin
    if (R_Value < G_Value) and (R_Value < B_Value) then R_Value := R_Value + delta
    else if (B_Value < R_Value) and (B_Value < G_Value) then B_Value := B_Value + delta
    else G_Value := G_Value + delta;
  end else begin
    if (R_Value > G_Value) and (R_Value > B_Value) then R_Value := R_Value + delta
    else if (B_Value > R_Value) and (B_Value > G_Value) then B_Value := B_Value + delta
    else G_Value := G_Value + delta;
  end;
  TB_R.Position := R_Value;
  TB_V.Position := G_Value;
  TB_B.Position := B_Value;
  RefreshCaption();
  previewRedraw;
end;

procedure TW__RGBToBN.previewRedraw;
begin
  RGBToLuminance(_lumprev, _calculatedpix, W_Prev.Preview, R_Value, G_Value, B_Value, false);
end;

procedure TW__RGBToBN.RefreshCaption();
var _txt : string;
begin
  str (R_Value, _txt);
  TXT_R.Text := _txt;
  str (G_Value, _txt);
  TXT_V.Text := _txt;
  str (B_Value, _txt);
  TXT_B.Text := _txt;
end;

procedure TW__RGBToBN.TB_RKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if _event then exit;
  _event := true;
  new_redval(TB_R.Position);
  previewRedraw;
  _event := false;
end;

procedure TW__RGBToBN.TB_RMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_R.Enabled := false;
    TB_R.Enabled := true;
    TB_R.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_RKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW__RGBToBN.TB_RMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_RClick(Sender);
end;

procedure TW__RGBToBN.TB_VClick(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TB_VKeyDown(Sender, keypressed, Shift);
end;

procedure TW__RGBToBN.TB_BKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if _event then exit;
  _event := true;
  new_bleuval(TB_B.Position);
  previewRedraw;
  _event := false;
end;

procedure TW__RGBToBN.TB_BMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_B.Enabled := false;
    TB_B.Enabled := true;
    TB_B.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_BKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW__RGBToBN.TB_BMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_BClick(Sender);

end;

procedure TW__RGBToBN.TB_BClick(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TB_BKeyDown(Sender, keypressed, Shift);
end;

procedure TW__RGBToBN.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TW__RGBToBN.StaticText6Click(Sender: TObject);
begin

end;

procedure TW__RGBToBN.FormActivate(Sender: TObject);
begin
  if isTransaction then exit;
  if not form3.IsVisible then begin
    setControlEnabled(true);
    if _S_Reanalyse then begin
      // Transformation en TMemoryPix
      if _islumprev then begin
        _lumprev.Clear;
        _islumprev := false;
      end;
      _lumprev.Init(W_Prev.Preview);
      _islumprev := true;
      Init;
    end;
    _S_Reanalyse := false;
  end;

end;

procedure TW__RGBToBN.Button2Click(Sender: TObject);
begin
  Init;
end;

procedure TW__RGBToBN.Button1Click(Sender: TObject);
begin
  screen.Cursor := crHourglass;
  isTransaction := true;
  _event := true;
  self.Enabled := false;
  Form3.Show;
  Form3.Enabled := false;
  ProgressWindow.ShowWindow('Traitements...', 'Conversion RGB -> N&&B');
  RGBToLuminance(_finalpix, _calculatedpix, Form3.imgres, R_Value, G_Value, B_Value, true);
  ProgressWindow.SetProgress('Réglages appliqués', 100);
  Form3.Refresh;
  init_param(_params);
  _param := new_param('Luminance rouge', TXT_R.Text);
  add_param(_params, _param);
  _param := new_param('Luminance vert', TXT_V.Text);
  add_param(_params, _param);
  _Param := new_param('Luminance bleu', TXT_B.Text);
  add_param(_params, _param);
  _command := new_command('Conversion RVB -> N&B', _params);
  isTransaction := false;
  ProgressWindow.HideWindow;
  setControlEnabled(false);
  self.Enabled := true;
  Form3.Enabled := true;
  Screen.Cursor := crDefault;
  _event := false;
  screen.Cursor := crDefault;
  Form3.setFocus;
end;

procedure TW__RGBToBN.TB_RClick(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TB_RKeyDown(Sender, keypressed, Shift);
end;

procedure TW__RGBToBN.TB_VKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if _event then exit;
  _event := true;
  G_Value := TB_V.Position ;
  new_greenval(G_Value);
  previewRedraw;
  _event := false;
end;

procedure TW__RGBToBN.TB_VMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_V.Enabled := false;
    TB_V.Enabled := true;
    TB_V.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_VKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW__RGBToBN.TB_VMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_VClick(Sender);

end;

procedure TW__RGBToBN.new_bleuval(b : integer);
var coef, reste, divide : real;
  delta : integer;
begin
  _updatePreview := false;
  B_Value := b;
  reste := 10000 - B_Value;
  divide := TB_R.Position + TB_V.Position;
  if divide <> 0 then coef := reste / divide else coef := 0;
  R_Value := trunc(TB_R.Position * coef);
  G_Value := trunc(TB_V.Position * coef);
  delta := 10000 - B_Value - R_Value - G_Value;
  if delta > 0 then begin
    if R_Value < G_Value then R_Value := R_Value + delta else G_Value := G_Value + delta;
  end else begin
    if R_Value > G_Value then R_Value := R_Value + delta else G_Value := G_Value + delta;
  end;
  TB_R.Position := trunc(R_Value);
  TB_V.Position := trunc(G_Value);
  RefreshCaption();
  _updatePreview := true;
end;

procedure TW__RGBToBN.new_greenval(g : integer);
var coef, reste, divide : real;
  delta : integer;
begin
  _updatePreview := false;
  G_Value := g;
  reste := 10000 - G_Value;
  divide := TB_R.Position + TB_B.Position;
  if divide <> 0 then coef := reste / divide else coef := 0;
  R_Value := trunc(TB_R.Position * coef);
  B_Value := trunc(TB_B.Position * coef);
  delta := 10000 - B_Value - R_Value - G_Value;
  if delta > 0 then begin
    if R_Value < B_Value then R_Value := R_Value + delta else B_Value := B_Value + delta;
  end else begin
    if R_Value > B_Value then R_Value := R_Value + delta else B_Value := B_Value + delta;
  end;
  TB_R.Position := trunc(R_Value);
  TB_B.Position := trunc(B_Value);
  RefreshCaption();
  _updatePreview := true;
end;

procedure TW__RGBToBN.new_redval(r : integer);
var coef, reste, divide : real;
  delta : integer;
begin
  _updatePreview := false;
  R_Value := r;
  reste := 10000 - R_Value;
  divide := TB_B.Position + TB_V.Position;
  if divide <> 0 then coef := reste / divide else coef := 0;
  B_Value := trunc(TB_B.Position * coef);
  G_Value := trunc(TB_V.Position * coef);
  delta := 10000 - B_Value - R_Value - G_Value;
  if delta > 0 then begin
    if G_Value < B_Value then G_Value := G_Value + delta else B_Value := B_Value + delta;
  end else begin
    if G_Value > B_Value then G_Value := G_Value + delta else B_Value := B_Value + delta;
  end;

  TB_B.Position := trunc(B_Value);
  TB_V.Position := trunc(G_Value);
  RefreshCaption();
  _updatePreview := true;
end;

begin
  _updatePreview := true;
end.

