unit W_luminance;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Luminance, Unit3, ProgressWindows,
  Prev, Global, MemoryPix, w_source, Diary, marqueurs, types, saveenv, constantes;

type

  { TW_Lum }

  TW_Lum = class(TForm)
    Button4: TButton;
    Button5: TButton;
    CB_Bleus: TCheckBox;
    CB_Cyans: TCheckBox;
    CB_Jaunes: TCheckBox;
    CB_Magentas: TCheckBox;
    CB_Mono: TCheckBox;
    CB_Rouges: TCheckBox;
    CB_Verts: TCheckBox;
    Chart1: TChart;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Ind_Bouche: TShape;
    Ind_Crame: TShape;
    Label2: TLabel;
    Label6: TLabel;
    lumscale: TLineSeries;
    LumSerieGamma: TLineSeries;
    linegamma: TLineSeries;
    lineantegamma: TLineSeries;
    linemixt: TLineSeries;
    lineref: TLineSeries;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    EDT_gamma: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    RB_G: TRadioButton;
    RB_A: TRadioButton;
    RB_M: TRadioButton;
    Shape1: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    TB_Lum: TTrackBar;
    TB_Max: TTrackBar;
    TB_63: TTrackBar;
    TB_190: TTrackBar;
    TB_Min3: TTrackBar;
    TB_127: TTrackBar;
    TB_Mixe: TTrackBar;
    TB_Min: TTrackBar;
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CB_BleusChange(Sender: TObject);
    procedure CB_CyansChange(Sender: TObject);
    procedure CB_JaunesChange(Sender: TObject);
    procedure CB_MonoChange(Sender: TObject);
    procedure CB_MagentasChange(Sender: TObject);
    procedure CB_RougesChange(Sender: TObject);
    procedure CB_VertsChange(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure RB_AChange(Sender: TObject);
    procedure RB_GChange(Sender: TObject);
    procedure RB_MChange(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure ScrollBar3Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure ScrollBar4Change(Sender: TObject);
    procedure TB_127Change(Sender: TObject);
    procedure TB_127Click(Sender: TObject);
    procedure TB_127KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_127KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_127MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_127MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_127MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_127MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_190Change(Sender: TObject);
    procedure TB_190Click(Sender: TObject);
    procedure TB_190KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_190KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_190MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_190MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_190MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_190MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_63Change(Sender: TObject);
    procedure TB_63Click(Sender: TObject);
    procedure TB_63KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_63KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_63MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_63MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_63MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_63MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_LumClick(Sender: TObject);
    procedure TB_LumKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_LumKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_LumMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_LumMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_LumMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_LumMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_MaxClick(Sender: TObject);
    procedure TB_MaxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_MaxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_MaxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_MaxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_MaxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_MaxMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_MinClick(Sender: TObject);
    procedure TB_MinKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_MinKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_MinMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_MinMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_MinMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_MinMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB_MixeClick(Sender: TObject);
    procedure TB_MixeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure TB_MixeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_MixeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TB_MixeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB_MixeMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_MixeMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { private declarations }
    const _code = 4;
  public
    { public declarations }
    procedure Init;
    procedure setControlEnabled(en:boolean);
  end;

var
  W_Lum: TW_Lum;
  gamma, poids : real;
  Lmin, Lmax : integer;

implementation

{$R *.lfm}
var askRedraw : boolean;
  _init : boolean;

procedure drawLumChange;
var i, width, height : integer;
  lgamma, y : real;
begin
  if not isTransaction then begin
    isTransaction := true;
    while askRedraw do begin
      askRedraw := false;
      createLumScaleCoef(Lmin, Lmax);
      CalcGammaCL (lumGamma, gamma);
      CalcanteGammaCL (lumAnteGamma, gamma);
      CalcMixGammaAnteGamma (lumGanteG, gamma, poids);
      W_Lum.lumscale.clear;
      W_Lum.linegamma.Clear ;
      W_Lum.lineantegamma.Clear;
      W_Lum.linemixt.Clear;
      _lumprev.getImageSize(width, height);
      _calculatedpix.Init(width, height, false);
      for i:=0 to 255 do
        begin
          y := applyLumScaleCoef(i);
          if y > 255 then begin
            y := 255;
          end;
          if y < 0 then begin
            y := 0;
          end;
          W_Lum.lumscale.AddXY(i, round(y));
          W_Lum.linegamma.AddXY(i, lumGamma[i]);
          W_Lum.lineantegamma.AddXY(i, lumAnteGamma[i]);
          W_Lum.linemixt.AddXY(i, lumGanteG[i]);
        end;
      if W_Lum.RB_G.checked then begin
      lgamma := gamma;
      GetCourbeLumiereGAMMA(_lumprev, cGamma, lgamma);
      W_Lum.LumSerieGamma.Clear ;
      bouchee := false;
      cramee := false;
      for i:=0 to 255 do
        begin
          W_Lum.LumSerieGamma.AddXY(i, cGamma[i]);
        end;
      ApplyGAMMA(_lumprev, _calculatedpix, W_Prev.Preview, gamma, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono, false);
      end else if W_Lum.RB_A.Checked then
      begin
        lgamma := gamma;
        GetCourbeLumiereanteGAMMA(_lumprev, cGamma, lgamma);
        W_Lum.LumSerieGamma.Clear ;
        for i:=0 to 255 do
          begin
            W_Lum.LumSerieGamma.AddXY(i, cGamma[i]);
          end;
        ApplyanteGAMMA (_lumprev, _calculatedpix, W_Prev.Preview, gamma, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono, false);
      end else begin
        lgamma := gamma;
        GetCourbeLumiereMixt(_lumprev, cGamma, lgamma, poids);
        W_Lum.LumSerieGamma.Clear ;
        for i:=0 to 255 do
          begin
            W_Lum.LumSerieGamma.AddXY(i, cGamma[i]);
          end;
        poids :=  W_Lum.TB_Mixe.Position / 100;
        ApplyMix (_lumprev, _calculatedpix, W_Prev.Preview, gamma, poids, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono, false);
      end;
      if bouchee then W_Lum.Ind_Bouche.Brush.Color := C_BOUCHE else W_Lum.Ind_Bouche.Brush.Color := C_RIEN;
      if cramee then W_Lum.Ind_Crame.Brush.Color := C_CRAME else W_Lum.Ind_Crame.Brush.Color := C_RIEN;
      Application.ProcessMessages;
    end;
  end;
  isTransaction := false;
end;

{ TW_Lum }
procedure TW_Lum.setControlEnabled(en:boolean);
begin
  Chart1.Enabled := en;
  Panel1.Enabled := en;
  Panel2.Enabled := en;
end;

procedure TW_Lum.Init;
var i : integer;
begin
  _init := true;
  TB_Lum.Position := 100;
  TB_Mixe.Position := 50;
  TB_Min.Position := 127;
  TB_Max.Position := 127;
  TB_63.Position := 250;
  TB_127.Position := 250;
  TB_190.Position := 250;
  gamma := 1;
  poids := 0.50;
  lumScale_a := 255;
  lumScale_b := 0;
  Lmax := 255;
  Lmin := 0;
  c63 := 0;
  c127 := 0;
  c190 := 0;
  Edit1.Caption := '50%';
  Edit2.Caption := '50%';
  Edit3.Caption := '0';
  Edit4.Caption := '255';
  Edit5.Caption := '0';
  Edit6.Caption := '0';
  Edit7.Caption := '0';
  EDT_gamma.Caption := '1';
  RB_G.Checked := true;
  gamma := 1;
  poids := 0.5;
  Lmin := 0;
  Lmax := 255;
  lumScale_a := 1;
  W_Lum.LumSerieGamma.Clear ;
  W_Lum.linegamma.Clear;
  W_Lum.lineantegamma.Clear;
  W_Lum.linemixt.Clear;
  W_Lum.lineref.Clear;
  W_Lum.lumscale.Clear;
  for i:=0 to 255 do
    begin
      W_Lum.LumSerieGamma.AddXY(i, Lumiere[i]);
      W_Lum.linegamma.AddXY(i,i);
      W_Lum.lineantegamma.AddXY(i,i);
      W_Lum.linemixt.AddXY(i,i);
      W_Lum.lineref.AddXY(i,i);
      W_Lum.lumscale.AddXY(i,i);
    end;
  W_Lum.Ind_Crame.Brush.Color := C_RIEN;
  W_Lum.Ind_Bouche.Brush.Color := C_RIEN;
  W_Lum.Edit3.Color := clDefault;
  W_Lum.Edit4.Color := clDefault;
  W_Lum.CB_Rouges.Checked := t_rouge;
  W_Lum.CB_Jaunes.Checked := t_jaune;
  W_Lum.CB_Verts.Checked := t_vert;
  W_Lum.CB_Cyans.Checked := t_cyan;
  W_Lum.CB_Bleus.Checked := t_bleu;
  W_Lum.CB_Magentas.Checked := t_magenta;
  W_Lum.CB_Mono.Checked := t_mono;
  _init := false;
end;

procedure TW_Lum.FormResize(Sender: TObject);
begin
  Chart1.width := W_Lum.width - 5;
  Chart1.height := W_Lum.Height - 260;
end;

procedure TW_Lum.FormShow(Sender: TObject);
var x,y : integer;
begin
  if not _isImg then begin
     _lumprev.getImageSize(x,y);
     _isImg := true;
  end;
end;

procedure TW_Lum.Panel1Click(Sender: TObject);
begin

end;

procedure TW_Lum.RB_AChange(Sender: TObject);
begin
  if _init then exit;
   askRedraw := true;
   drawLumChange;
end;

procedure TW_Lum.RB_GChange(Sender: TObject);
begin
  if _init then exit;
   askRedraw := true;
   drawLumChange;
end;

procedure TW_Lum.RB_MChange(Sender: TObject);
begin
  if _init then exit;
   askRedraw := true;
   drawLumChange;
end;

procedure TW_Lum.ScrollBar1Change(Sender: TObject);
begin

end;

procedure TW_Lum.ScrollBar2Change(Sender: TObject);
begin

end;

procedure TW_Lum.ScrollBar3Change(Sender: TObject);
begin

end;

procedure TW_Lum.ScrollBar3Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin

end;

procedure TW_Lum.ScrollBar4Change(Sender: TObject);
begin

end;

procedure TW_Lum.TB_127Change(Sender: TObject);
begin

end;

procedure TW_Lum.TB_127Click(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_127KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_127KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _txt : string;
begin
  c127 :=  TB_127.Position - 250 ;
  str (c127, _txt);
  Edit7.text := _txt;
  askRedraw := true;
  if not _event then begin
    _event := true;
    CalcMixGammaanteGamma(lumGanteG, gamma, poids);
    drawLumChange;
    _event := false;
  end;
  if _lostfocus then begin
    _lostfocus := false;
    TB_127KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Lum.TB_127KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_127.enabled := false;
  TB_127.enabled := true;
  TB_127.setfocus;
  keypressed := Word(#32);
  TB_127KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_127MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_127.Enabled := false;
    TB_127.Enabled := true;
    TB_127.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_127KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Lum.TB_127MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_127.enabled := false;
  TB_127.enabled := true;
  TB_127.setfocus;
  keypressed := Word(#32);
  TB_127KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_127MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_127Click(Sender);
end;

procedure TW_Lum.TB_127MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_127.enabled := false;
  TB_127.enabled := true;
  TB_127.setfocus;
  keypressed := Word(#32);
  TB_127KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_190Change(Sender: TObject);
begin

end;

procedure TW_Lum.TB_190Click(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_190KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_190KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _txt : string;
begin
  c190 :=  TB_190.Position - 250 ;
  str (c190, _txt);
  Edit6.text := _txt;
  askRedraw := true;
  if not _event then begin
    _event := true;
    CalcMixGammaanteGamma(lumGanteG, gamma, poids);
    drawLumChange;
    _event := false;
  end;
  if _lostfocus then begin
    _lostfocus := false;
    TB_190KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Lum.TB_190KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_190.enabled := false;
  TB_190.enabled := true;
  TB_190.setfocus;
  keypressed := Word(#32);
  TB_190KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_190MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_190.Enabled := false;
    TB_190.Enabled := true;
    TB_190.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_190KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Lum.TB_190MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_190.enabled := false;
  TB_190.enabled := true;
  TB_190.setfocus;
  keypressed := Word(#32);
  TB_190KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_190MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_190Click(Sender);
end;

procedure TW_Lum.TB_190MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_190.enabled := false;
  TB_190.enabled := true;
  TB_190.setfocus;
  keypressed := Word(#32);
  TB_190KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_63Change(Sender: TObject);
begin

end;

procedure TW_Lum.TB_63Click(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_63KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_63KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var _txt : string;
begin
  c63 :=  TB_63.Position - 250 ;
  str (c63, _txt);
  Edit5.text := _txt;
  askRedraw := true;
  if not _event then begin
    _event := true;
    drawLumChange;
    _event := false;
  end;
  if _lostfocus then begin
    _lostfocus := false;
    TB_63KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Lum.TB_63KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_63.enabled := false;
  TB_63.enabled := true;
  TB_63.setfocus;
  keypressed := Word(#32);
  TB_63KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_63MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_63.Enabled := false;
    TB_63.Enabled := true;
    TB_63.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_63KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Lum.TB_63MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_63.enabled := false;
  TB_63.enabled := true;
  TB_63.setfocus;
  keypressed := Word(#32);
  TB_63KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_63MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_63Click(Sender);
end;

procedure TW_Lum.TB_63MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_63.enabled := false;
  TB_63.enabled := true;
  TB_63.setfocus;
  keypressed := Word(#32);
  TB_63KeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_LumClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_LumKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_LumKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  src, src2, txt : string;
  valeur : integer;
begin
  valeur := TB_Lum.Position;
  gamma := valeur / 100 ;
  str(valeur, txt);
  if (valeur < 100) then
  begin
    src := copy('0.',1,2);
    src := concat (src, txt);
  end
  else
  begin
    src := copy(txt,1,1);
    src2 := copy(txt, 2,2);
    src := concat (src, '.');
    src := concat (src, src2);
  end;
  EDT_gamma.text := src;
  askRedraw := true;
  if not _event then begin
    _event := true;
    drawLumChange;
    _event := false;
  end;
  if _lostfocus then begin
    _lostfocus := false;
    TB_LumKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Lum.TB_LumKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Lum.enabled := false;
  TB_Lum.enabled := true;
  TB_Lum.setfocus;
  keypressed := Word(#32);
  TB_LumKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_LumMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_Lum.Enabled := false;
    TB_Lum.Enabled := true;
    _lostfocus := true;
    TB_Lum.SetFocus;
  end else begin
    keypressed := Word(#32);
    TB_LumKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Lum.TB_LumMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Lum.enabled := false;
  TB_Lum.enabled := true;
  TB_Lum.setfocus;
  keypressed := Word(#32);
  TB_LumKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_LumMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_LumClick(Sender);
end;

procedure TW_Lum.TB_LumMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Lum.enabled := false;
  TB_Lum.enabled := true;
  TB_Lum.setfocus;
  keypressed := Word(#32);
  TB_LumKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_MaxClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_MaxKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_MaxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var txt : string;
begin
  Lmax := 127 - TB_Max.Position + 255;
  str(128+ TB_Max.Position, txt);
  Edit4.text := txt;
  askRedraw := true;
  if not _event then begin
    _event := true;
    drawLumChange;
    _event := false;
  end;
  if _lostfocus then begin
    _lostfocus := false;
    TB_MaxKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Lum.TB_MaxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Max.enabled := false;
  TB_Max.enabled := true;
  TB_Max.setfocus;
  keypressed := Word(#32);
  TB_MaxKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_MaxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_Max.Enabled := false;
    TB_Max.Enabled := true;
    TB_Max.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_MaxKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Lum.TB_MaxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Max.enabled := false;
  TB_Max.enabled := true;
  TB_Max.setfocus;
  keypressed := Word(#32);
  TB_MaxKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_MaxMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_MaxClick(Sender);
end;

procedure TW_Lum.TB_MaxMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Max.enabled := false;
  TB_Max.enabled := true;
  TB_Max.setfocus;
  keypressed := Word(#32);
  TB_MaxKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_MinClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_MinKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_MinKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var txt : string;
begin
  Lmin := 127 - TB_Min.Position ;
  str (-Lmin, txt);
  Edit3.text := txt;
  askRedraw := true;
  if not _event then begin
    _event := true;
    drawLumChange;
    _event := false;
  end;
  if _lostfocus then begin
    _lostfocus := false;
    TB_MinKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Lum.TB_MinKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Min.enabled := false;
  TB_Min.enabled := true;
  TB_Min.setfocus;
  keypressed := Word(#32);
  TB_MinKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_MinMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_Min.Enabled := false;
    TB_Min.Enabled := true;
    TB_Min.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_MinKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Lum.TB_MinMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Min.enabled := false;
  TB_Min.enabled := true;
  TB_Min.setfocus;
  keypressed := Word(#32);
  TB_MinKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_MinMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_MinClick(Sender);
end;

procedure TW_Lum.TB_MinMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Min.enabled := false;
  TB_Min.enabled := true;
  TB_Min.setfocus;
  keypressed := Word(#32);
  TB_MinKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_MixeClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
  keypressed := Word(#32);
  TB_MixeKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_MixeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  txt : string;
  valeur : integer;
begin
  valeur := TB_Mixe.Position;
  poids := valeur ;
  str(valeur, txt);
  txt:=concat(txt,'%');
  Edit2.text := txt;
  valeur := (100 - valeur);
  str(valeur, txt);
  txt:=concat(txt, '%');
  Edit1.text := txt;
  poids := poids / 100;
  askRedraw := true;
  if not _event then begin
    _event := true;
    CalcMixGammaanteGamma(lumGanteG, gamma, poids);
    drawLumChange;
    _event := false;
  end;
  if _lostfocus then begin
    _lostfocus := false;
    TB_MixeKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_Lum.TB_MixeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Mixe.enabled := false;
  TB_Mixe.enabled := true;
  TB_Mixe.setfocus;
end;

procedure TW_Lum.TB_MixeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_Mixe.Enabled := false;
    TB_Mixe.Enabled := true;
    TB_Mixe.SetFocus;
    if _event then _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_MixeKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_Lum.TB_MixeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Mixe.enabled := false;
  TB_Mixe.enabled := true;
  TB_Mixe.setfocus;
  keypressed := Word(#32);
  TB_MixeKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.TB_MixeMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_MixeClick(Sender);
end;

procedure TW_Lum.TB_MixeMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var keypressed : Word;
begin
  askRedraw := true;
  _lostfocus := true;
  TB_Mixe.enabled := false;
  TB_Mixe.enabled := true;
  TB_Mixe.setfocus;
  keypressed := Word(#32);
  TB_MixeKeyDown(Sender, keypressed, Shift);
end;

procedure TW_Lum.FormPaint(Sender: TObject);
var txt, src, src2 : string;
  valeur : integer;
begin
  valeur := trunc(gamma * 100);
  TB_Lum.Position := valeur;
  str(valeur, txt);
  if valeur >= 100 then begin
    src := copy(txt,1,1);
    src2 := copy(txt, 2,2);
    src := concat (src, '.');
    src := concat (src, src2);
  end
  else begin
    src := copy('0.',1,2);
    src := concat(src, txt);
  end;
  EDT_gamma.text := src;
end;

procedure TW_Lum.FormCreate(Sender: TObject);
var i : integer;
begin
  gamma := 1;
  poids := 0.5;
  Lmin := 0;
  Lmax := 255;
  lumScale_a := 1;
  W_Lum.Lineref.Clear;
  for i := 0 to 255 do begin
    lumGamma[i] := i;
    lumAnteGamma[i] := i;
    lumGanteG[i] := i;
    W_Lum.Lineref.AddXY(i,i);
    W_Lum.lumscale.AddXY(i,i);
  end;
end;

procedure TW_Lum.FormHide(Sender: TObject);
begin
  _S_Reanalyse := false;
  _LOpen := false;
  _currentWin := nil;
end;

procedure TW_Lum.Button4Click(Sender: TObject);
var x,y : integer;
  _txt : string;
begin
  isTransaction := true;
  _event := true;
  W_Lum.Enabled := false;
  Form3.Show;
  Form3.Enabled := false;
  ProgressWindow.ShowWindow('Traitements...', 'Application des réglages');
  Screen.Cursor := crHourGlass ;
  _finalpix.getImageSize(x,y);
  _calculatedpix.Init(x,y,false);
  if RB_G.Checked then
    ApplyGAMMA (_finalpix, _calculatedpix, Form3.imgres, gamma, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono, true)
  else if RB_A.Checked then
    ApplyanteGAMMA (_finalpix, _calculatedpix, Form3.imgres, gamma, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono, true)
  else ApplyMix (_finalpix, _calculatedpix, Form3.imgres, gamma, poids, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono, true);
  ProgressWindow.SetProgress('Réglages appliqués', 100);
  Form3.Refresh;
  init_param(_params);
  _param := new_param('Coef gamma', EDT_Gamma.Text);
  add_param(_params, _param);
  _param := new_param('Répartition gamma', Edit1.Text);
  add_param(_params, _param);
  _param := new_param('Répartition ante-gamma', Edit2.Text);
  add_param(_params, _param);
  if RB_G.Checked then
    _param := new_param('Fonction', 'gamma')
  else if RB_A.Checked then
    _param := new_param('Fonction', 'ante-gamma')
  else _param := new_param('Fonction', 'mixe');
  add_param(_params, _param);
  _param := new_param('Réglage base gauche histogramme', Edit3.Text);
  add_param(_params, _param);
  _param := new_param('Réglage base droite histogramme', Edit4.Text);
  add_param(_params, _param);
  str (_CTonsSombres, _txt);
  _param := new_param('Limite tons sombres/tons moyens', _txt);
  add_param(_params, _param);
  str (_CTonsMoyens, _txt);
  _param := new_param('Limite tons moyens/tons clairs', _txt);
  add_param(_params, _param);
  _param := new_param('Réglage tons sombres histogramme', Edit5.Text);
  add_param(_params, _param);
  _param := new_param('Réglage tons moyens histogramme', Edit7.Text);
  add_param(_params, _param);
  _param := new_param('Réglage tons clairs histogramme', Edit6.Text);
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
  _command := new_command('Luminance', _params);
  isTransaction := false;
  ProgressWindow.HideWindow;
  setControlEnabled(false);
  W_Lum.Enabled := true;
  Form3.Enabled := true;
  Screen.Cursor := crDefault;
  _event := false;
  Form3.SetFocus;
end;

procedure TW_Lum.Button5Click(Sender: TObject);
begin
  self.Init;
  askRedraw := true;
  drawLumChange;
end;

procedure TW_Lum.CB_BleusChange(Sender: TObject);
begin
  if _init then exit;
  t_bleu := CB_Bleus.Checked;
  askRedraw := true;
  drawLumChange;
end;

procedure TW_Lum.CB_CyansChange(Sender: TObject);
begin
  if _init then exit;
  t_cyan := CB_cyans.Checked;
  askRedraw := true;
  drawLumChange;
end;

procedure TW_Lum.CB_JaunesChange(Sender: TObject);
begin
  if _init then exit;
  t_jaune := CB_Jaunes.Checked;
  askRedraw := true;
  drawLumChange;
end;

procedure TW_Lum.CB_MonoChange(Sender: TObject);
begin
  if _init then exit;
  t_mono := CB_Mono.Checked;
  askRedraw := true;
  drawLumChange;
end;

procedure TW_Lum.CB_MagentasChange(Sender: TObject);
begin
  if _init then exit;
  t_magenta := CB_magentas.Checked;
  askRedraw := true;
  drawLumChange;
end;

procedure TW_Lum.CB_RougesChange(Sender: TObject);
begin
  if _init then exit;
  t_rouge := CB_Rouges.Checked;
  askRedraw := true;
  drawLumChange;
end;

procedure TW_Lum.CB_VertsChange(Sender: TObject);
begin
  if _init then exit;
  t_vert := CB_Verts.Checked;
  askRedraw := true;
  drawLumChange;
end;

procedure TW_Lum.Edit7Change(Sender: TObject);
begin

end;

procedure TW_Lum.FormActivate(Sender: TObject);
begin
  if Form3.isVisible then exit;
  setControlEnabled(true);
  if not isTransaction then begin
    if _S_Reanalyse then begin
      _event := true;
      Init;
      preparePreview(W_SRC.View, W_Prev.Preview);
      // Transformation en TMemoryPix
      if _islumprev then begin
        _lumprev.Clear;
        _islumprev := false;
      end;
      _lumprev.Init(W_Prev.Preview);
      _islumprev := true;
      askRedraw := true;
      drawLumChange;
      GetCourbeLumiereGAMMA(_lumprev, Lumiere, gamma);
      W_Lum.Edit3.Color := clDefault;
      W_Lum.Edit4.Color := clDefault;
      _S_Reanalyse := false;
      _event := false;
    end else if _RefreshRequest then begin
      askRedraw := true;
      if not _event then begin
        _event := true;
        CalcMixGammaanteGamma(lumGanteG, gamma, poids);
        drawLumChange;
        _event := false;
      end;
    end;
  end;
  _RefreshRequest := false;
end;

procedure TW_Lum.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;


begin
  askRedraw := false;
  _init := false;
end.

