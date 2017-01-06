unit BackgroundLum;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, Diary, AdvancedFilters, saveenv, types, global, progresswindows,
  memorypix, Prev, Unit3, FilePix, Marqueurs;

type

  { TW_BackgroundLum }

  TW_BackgroundLum = class(TForm)
    BT_Extract: TButton;
    BT_Apply: TButton;
    BT_Preview: TButton;
    CB_Invert: TCheckBox;
    Img1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    RadioButton1: TRadioButton;
    RB_Add: TRadioButton;
    RB_Lum: TRadioButton;
    RB_Color: TRadioButton;
    R_Ind_Bouche: TShape;
    B_Ind_Bouche: TShape;
    B_Ind_Crame: TShape;
    Shape4: TShape;
    Shape46: TShape;
    Shape47: TShape;
    Shape48: TShape;
    Shape6: TShape;
    TB_Dynamic: TTrackBar;
    TB_Signal: TTrackBar;
    TB_SignalLow: TTrackBar;
    TXT_Dynamic: TEdit;
    TXT_Radius2: TEdit;
    TXT_Signal: TEdit;
    TXT_SignalLow: TEdit;
    V_Ind_Bouche: TShape;
    R_Ind_Crame: TShape;
    V_Ind_Crame: TShape;
    Shape43: TShape;
    Shape44: TShape;
    Shape45: TShape;
    Shape5: TShape;
    TB_Delta: TTrackBar;
    TB_Intensity: TTrackBar;
    TB_Radius: TTrackBar;
    TXT_Radius: TEdit;
    TXT_Radius1: TEdit;
    TXT_Delta: TEdit;
    TXT_Intensity: TEdit;
    procedure BT_ApplyClick(Sender: TObject);
    procedure BT_ExtractClick(Sender: TObject);
    procedure BT_PreviewClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure RB_ColorChange(Sender: TObject);
    procedure RB_LumChange(Sender: TObject);
    procedure R_Ind_BoucheChangeBounds(Sender: TObject);
    procedure Shape46ChangeBounds(Sender: TObject);
    procedure StaticText5Click(Sender: TObject);
    procedure TB_DeltaClick(Sender: TObject);
    procedure TB_DeltaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure TB_DeltaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TB_DeltaMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_DynamicClick(Sender: TObject);
    procedure TB_DynamicKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TB_DynamicMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TB_DynamicMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_IntensityClick(Sender: TObject);
    procedure TB_IntensityKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TB_IntensityMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TB_IntensityMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_RadiusClick(Sender: TObject);
    procedure TB_RadiusKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TB_RadiusMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TB_RadiusMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);

    procedure Init;
    procedure TB_SignalChange(Sender: TObject);
    procedure TB_SignalClick(Sender: TObject);
    procedure TB_SignalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TB_SignalLowChange(Sender: TObject);
    procedure TB_SignalLowClick(Sender: TObject);
    procedure TB_SignalLowKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TB_SignalLowMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TB_SignalLowMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TB_SignalMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TB_SignalMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TXT_IntensityChange(Sender: TObject);
    procedure TXT_Radius1Change(Sender: TObject);
    procedure TXT_RadiusChange(Sender: TObject);
    procedure setEnabled(ena:boolean);
  private
    { private declarations }
    const _code = 18;
  public
    { public declarations }
  end;

var
  W_BackgroundLum: TW_BackgroundLum;

implementation

{$R *.lfm}

{ TW_BackgroundLum }
const //_coefradius = 11250;
  _coefradius = 10125;
  _CDefradius = 250;
  _CTXTradius = '25.0';
  _CLimsig = 255;
  _CLimLowsig = 0 ;
  _CTXTsignal = '255';
  _CTXTsignalLow = '0';
  _CColor = true;
  _CDyn = 0;
  _CTXTDyn = '0';
  _CDelta = 255;
  _CTXTDelta = '255';
  _CInt = 70;
  _CTXTInt = '70%';
  _CAdd = false;
  _CInv = false;
var
      callradius : real;
      average : real;
      woorkoncolor : boolean;

procedure TW_BackgroundLum.setEnabled(ena:boolean);
begin
  Panel1.enabled := ena;
  Panel2.enabled := ena;
  BT_Apply.enabled := ena;
end;

procedure TW_BackgroundLum.Init;
var _radius : real;
    prev_width, prev_height : integer;
begin

  // Extract background signal
  ProgressWindow.ShowWindow('Luminance de l''arrière plan','Extraction du signal');
  TB_Radius.Position := _CDefradius;
  TB_Signal.Position := _CLimSig;
  TB_SignalLow.Position := _CLimLowSig;
  CB_Invert.Checked := _CInv;
  TB_Dynamic.Position := _CDyn;
  TXT_Dynamic.Text := _CTXTDyn;
  TB_Delta.Position := _CDelta;
  TXT_Delta.Text := _CTXTDelta;
  TB_Intensity.Position := _CInt;
  TXT_Intensity.Text := _CTXTInt;

  TXT_Radius.Text := _CTXTradius;
  TXT_signal.text := _CTXTsignal;
  TXT_signalLow.Text := _CTXTsignalLow;

  R_Ind_Bouche.Brush.Color := C_RIEN;
  R_Ind_Crame.Brush.Color := C_RIEN;
  V_Ind_Bouche.Brush.Color := C_RIEN;
  V_Ind_Crame.Brush.Color := C_RIEN;
  B_Ind_Bouche.Brush.Color := C_RIEN;
  B_Ind_Crame.Brush.Color := C_RIEN;


  if _CColor then RB_Color.Checked := true else RB_Lum.Checked := true;
  if _CAdd then RB_Add.Checked := true else RadioButton1.Checked := true;
  _lumprev.getImageSize(prev_width, prev_height);
  callradius := TB_Radius.Position / _coefradius;

  _radius := callradius * prev_width;

  average := CalcBakgroundLum(_lumprev, _interprev, TB_SignalLow.Position, TB_Signal.Position, round(_radius), RB_Color.Checked, true, 90);
  // Copy signal into window bitmap
  _interprev.copyImageIntoTImage(Img1, true);
  ProgressWindow.Hide;

end;

procedure TW_BackgroundLum.TB_SignalChange(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.TB_SignalClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_SignalKeyDown(Sender, keypressed, Shift);
end;

procedure TW_BackgroundLum.TB_SignalKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _radiusunites : string;
  unites : integer;
  _valeur : integer;
begin
  unites := TB_Signal.Position;
  str(unites, _radiusunites);
  TXT_Signal.Text := _radiusunites;
end;

procedure TW_BackgroundLum.TB_SignalLowChange(Sender: TObject);
begin

end;



procedure TW_BackgroundLum.TB_SignalLowKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _radiusunites : string;
  unites : integer;
  _valeur : integer;
begin
  unites := TB_SignalLow.Position;
  str(unites, _radiusunites);
  TXT_SignalLow.Text := _radiusunites;
end;

procedure TW_BackgroundLum.TB_SignalLowMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if (ssleft in Shift) then begin
    keypressed := Word(#32);
    TB_SignalLowKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_BackgroundLum.TB_SignalLowMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  TB_SignalLowClick(Sender);
end;

procedure TW_BackgroundLum.TB_SignalMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if (ssleft in Shift) then begin
    keypressed := Word(#32);
    TB_SignalKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_BackgroundLum.TB_SignalMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  TB_SignalClick(Sender);
end;

procedure TW_BackgroundLum.TB_SignalLowClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_SignalLowKeyDown(Sender, keypressed, Shift);
end;



procedure TW_BackgroundLum.TXT_IntensityChange(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.TXT_Radius1Change(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.TXT_RadiusChange(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.Panel1Click(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.RB_ColorChange(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.RB_LumChange(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.R_Ind_BoucheChangeBounds(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.Shape46ChangeBounds(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.StaticText5Click(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.TB_DeltaClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_DeltaKeyDown(Sender, keypressed, Shift);
end;

procedure TW_BackgroundLum.TB_DeltaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _delta : string;
begin
    str(TB_Delta.Position, _delta);
    TXT_Delta.Text := _delta;
end;

procedure TW_BackgroundLum.TB_DeltaMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if (ssleft in Shift) then begin
    keypressed := Word(#32);
    TB_DeltaKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_BackgroundLum.TB_DeltaMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  TB_DeltaClick(Sender)
end;

procedure TW_BackgroundLum.TB_DynamicClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_DynamicKeyDown(Sender, keypressed, Shift);
end;

procedure TW_BackgroundLum.TB_DynamicKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _delta : string;
begin
    str(TB_Dynamic.Position, _delta);
    TXT_Dynamic.Text := _delta;
end;

procedure TW_BackgroundLum.TB_DynamicMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if (ssleft in Shift) then begin
    keypressed := Word(#32);
    TB_DynamicKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_BackgroundLum.TB_DynamicMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  TB_DynamicClick(Sender)
end;

procedure TW_BackgroundLum.TB_IntensityClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_IntensityKeyDown(Sender, keypressed, Shift);
end;

procedure TW_BackgroundLum.TB_IntensityKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _intensity : string;
begin
    str(TB_Intensity.Position, _intensity);
    _intensity := concat(_intensity, '%');
    TXT_intensity.Text := _intensity;
end;

procedure TW_BackgroundLum.TB_IntensityMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if (ssleft in Shift) then begin
    keypressed := Word(#32);
    TB_IntensityKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_BackgroundLum.TB_IntensityMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
    TB_IntensityClick(Sender);
end;

procedure TW_BackgroundLum.TB_RadiusClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_RadiusKeyDown(Sender, keypressed, Shift);
end;

procedure TW_BackgroundLum.TB_RadiusKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _radiusunites, _radiusdecimales : string;
  unites, decimales : integer;
  _valeur : integer;
begin
  _valeur := TB_Radius.Position;
  unites := _valeur div 10;
  decimales := _valeur - (unites * 10) ;
  str(unites, _radiusunites);
  str(decimales, _radiusdecimales);
  _radiusunites := concat(_radiusunites,'.');
  if decimales > 0 then _radiusunites := concat(_radiusunites, _radiusdecimales)
  else _radiusunites := concat(_radiusunites,'0');
  TXT_Radius.Text := _radiusunites;
end;

procedure TW_BackgroundLum.TB_RadiusMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if (ssleft in Shift) then begin
    keypressed := Word(#32);
    TB_RadiusKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_BackgroundLum.TB_RadiusMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  TB_RadiusClick(Sender);
end;

procedure TW_BackgroundLum.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TW_BackgroundLum.FormCreate(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.Label3Click(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.Label6Click(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.Label7Click(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.Label9Click(Sender: TObject);
begin

end;

procedure TW_BackgroundLum.FormActivate(Sender: TObject);
begin
  if isTransaction then exit;
  if not form3.IsVisible then begin
    setEnabled(true);
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

procedure TW_BackgroundLum.BT_ExtractClick(Sender: TObject);
var _radius : real;
  prev_height, prev_width, source_height, source_width : integer;
begin
  woorkoncolor := RB_color.Checked;
  W_BackgroundLum.BT_Extract.enabled := false;
  W_BackgroundLum.BT_Preview.enabled := false;
  W_BackgroundLum.BT_Apply.enabled := false;

  screen.Cursor := crHourglass;
  // Extract background signal
  ProgressWindow.ShowWindow('Luminance de l''arrière plan','Extraction du signal');
  // Calculating _radius at the preview scale
  // getting size of pictures
  _lumprev.getImageSize(source_width, source_height);
  _interprev.Init(source_width, source_height, false);
  //_lumprev.getImageSize(prev_width, prev_height);
  prev_width := source_width;
  prev_height := source_height;
  callradius := TB_Radius.Position / _coefradius;
  _radius := callradius * prev_width;
  average := CalcBakgroundLum(_lumprev, _interprev, TB_SignalLow.Position, TB_Signal.Position, round(_radius), RB_Color.Checked, true, 100);
  // Copy signal into window bitmap
  _interprev.copyImageIntoTImage(Img1, true);
  TXT_Radius1.text := TXT_Radius.Text;
  TXT_Radius2.text := TXT_Signal.Text;
  ProgressWindow.Hide;

  W_BackgroundLum.BT_Extract.enabled := true;
  W_BackgroundLum.BT_Preview.enabled := true;
  W_BackgroundLum.BT_Apply.enabled := true;

  screen.Cursor := crDefault;
end;

procedure TW_BackgroundLum.BT_ApplyClick(Sender: TObject);
var ret : integer;
  _radius, _average : real;
  _width, _height : integer ;
begin
    setEnabled(false);
    W_BackgroundLum.enabled := false;

    Form3.Enabled := false;

    try
       Form3.Show;
    except
      MessageDlg('Erreur','Pas assez de mémoire !. Libérer des ressources et ré essayer !', mtConfirmation,
      [mbYes],0);
      W_BackgroundLum.Enabled := true;
      exit;
    end;
    screen.cursor := crHourglass;
    ProgressWindow.ShowWindow('Luminance de l''arrière plan','Extraction de l''arrière plan.');


    // save original source pix
    ret := savepix(concat(_workingdir, 'finalpix.tim'),_finalpix);

    // Extract background light
    _finalpix.getImageSize(_width, _height);
    _radius := callradius * _width ;
    _average := CalcBakgroundLum(_finalpix, _calculatedpix, TB_SignalLow.Position, TB_Signal.Position, round(_radius), RB_Color.Checked, true, 99);


    // apply on copy of source pix
    ProgressWindow.setMessage('Application sur l''image.');
// Commented for debugging
    ApplyBackGroundLum(_finalpix, _calculatedpix, RB_Add.Checked, CB_Invert.Checked, TB_Delta.Position, TB_Dynamic.Position, TB_Intensity.Position, _average, true, 50);
    // Show result in preview window
// Commented for debugging
    _finalpix.copy(_calculatedpix, false, 0);
    _finalpix.copyImageIntoTImage(form3.imgres, true);
// Created for debugging
//    _calculatedpix.copyImageIntoTImage(form3.imgres, true);

    // restauring source pix
    ret := loadpix(concat(_workingdir, 'finalpix.tim'),_finalpix);

    ProgressWindow.setProgress('Calculs terminés.',100);


    init_param(_params);
    _param := new_param('Inertie', TXT_Radius1.Text);
    add_param(_params, _param);
    _param := new_param('Limite supérieure signal', TXT_Signal.Text);
    add_param(_params, _param);
    _param := new_param('Limite inférieure signal', TXT_SignalLow.Text);
    add_param(_params, _param);
    if woorkoncolor then
      _param := new_param('Travail colorimétrique', 'couleur')
    else
      _param := new_param('Travail colorimétrique', 'luminance');
    add_param(_params, _param);
    _param := new_param('Ajustement dynamique', TXT_Dynamic.Text);
    add_param(_params, _param);
    _param := new_param('Delta', TXT_Delta.Text);
    add_param(_params, _param);
    _param := new_param('Intensité d''application', TXT_Intensity.Text);
    add_param(_params, _param);
    if RB_Add.Checked then
      _param := new_param('Opération', 'Addition')
    else
      _param := new_param('Opération', 'Soustraction');
    add_param(_params, _param);
    if CB_Invert.Checked then
      _param := new_param('Inversion du signal', 'Oui')
    else
      _param := new_param('Inversion du signal', 'Non');
    add_param(_params, _param);

    _command := new_command('Luminance de l''arrière plan', _params);

    form3.enabled := true;

    W_BackgroundLum.enabled := true;
    ProgressWindow.Hide;

    screen.cursor := crDefault;
    form3.setfocus;


end;

procedure TW_BackgroundLum.BT_PreviewClick(Sender: TObject);
var ret : integer;
begin
  if isTransaction then exit;
  isTransaction := true;

  W_BackgroundLum.BT_Extract.enabled := false;
  W_BackgroundLum.BT_Preview.enabled := false;
  W_BackgroundLum.BT_Apply.enabled := false;

  screen.cursor := crHourglass;
  ProgressWindow.ShowWindow('Luminance de l''arrière plan','Application sur la preview.');


  // save original preview pix
  ret := savepix(concat(_workingdir, 'lumprev.tim'),_lumprev);
  // apply on copy of source pix
  try
    ApplyBackGroundLum(_lumprev, _interprev, RB_Add.Checked, CB_Invert.Checked, TB_Delta.Position, TB_Dynamic.Position, TB_Intensity.Position, average, true, 100);
    // Show result in preview window
    _lumprev.copyImageIntoTImage(W_Prev.Preview, true);
  except
    MessageDlg('Erreur','L''extraction du signal de fond ne correspond pas à l''image. L''extraction a t-elle été faite ?', mtConfirmation,
    [mbYes],0);
  end;
  // restoring original preview pix
  ret := loadpix(concat(_workingdir,'lumprev.tim'),_lumprev);

  if cramR then W_BackgroundLum.R_Ind_Crame.Brush.Color := C_CRAME
  else W_BackgroundLum.R_Ind_Crame.Brush.Color := C_RIEN;
  if bouchR then W_BackgroundLum.R_Ind_Bouche.Brush.Color := C_BOUCHE
  else W_BackgroundLum.R_Ind_Bouche.Brush.Color := C_RIEN;

  if cramG then W_BackgroundLum.V_Ind_Crame.Brush.Color := C_CRAME
  else W_BackgroundLum.V_Ind_Crame.Brush.Color := C_RIEN;
  if bouchG then W_BackgroundLum.V_Ind_Bouche.Brush.Color := C_BOUCHE
  else W_BackgroundLum.V_Ind_Bouche.Brush.Color := C_RIEN;

  if cramB then W_BackgroundLum.B_Ind_Crame.Brush.Color := C_CRAME
  else W_BackgroundLum.B_Ind_Crame.Brush.Color := C_RIEN;
  if bouchB then W_BackgroundLum.B_Ind_Bouche.Brush.Color := C_BOUCHE
  else W_BackgroundLum.B_Ind_Bouche.Brush.Color := C_RIEN;

  ProgressWindow.Hide;

  screen.cursor := crDefault;

  W_BackgroundLum.BT_Extract.enabled := true;
  W_BackgroundLum.BT_Preview.enabled := true;
  W_BackgroundLum.BT_Apply.enabled := true;

  isTransaction := false;
end;

end.

