unit W_AddDelColorSignal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, TSL, MemoryPix, Global, Constantes, Unit3, Prev,
  ProgressWindows, Diary, marqueurs, types, luminance, math, saveenv, w_source;

type

  { TW_AddDelColor }

  TW_AddDelColor = class(TForm)
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
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    RB_Add: TRadioButton;
    RB_Sub: TRadioButton;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Ind_Bouche: TShape;
    Shape46: TShape;
    Ind_Crame: TShape;
    Timer1: TTimer;
    TrackBar4: TTrackBar;
    TXT_Lum: TEdit;
    TXT_Sat: TEdit;
    TXT_Int: TEdit;
    IMG_ColorTSL: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Shape43: TShape;
    Shape44: TShape;
    Shape45: TShape;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TXT_Col: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CB_BleusChange(Sender: TObject);
    procedure CB_CChange(Sender: TObject);
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
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
    procedure IMG_ColorTSLClick(Sender: TObject);
    procedure IMG_ColorTSLMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IMG_ColorTSLMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label4Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel2DblClick(Sender: TObject);
    procedure Panel3DblClick(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel4DblClick(Sender: TObject);
    procedure Panel5DblClick(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure Panel6DblClick(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
    procedure Panel7DblClick(Sender: TObject);
    procedure RB_AddChange(Sender: TObject);
    procedure RB_SubChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Click(Sender: TObject);
    procedure TrackBar1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TrackBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TrackBar1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TrackBar2Click(Sender: TObject);
    procedure TrackBar2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TrackBar2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TrackBar2MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TrackBar3Click(Sender: TObject);
    procedure TrackBar3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TrackBar3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TrackBar3MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TrackBar4Change(Sender: TObject);
    procedure TrackBar4Click(Sender: TObject);
    procedure TrackBar4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TrackBar4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TrackBar4MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { private declarations }
    const _code = 10;
  public
    { public declarations }
    procedure Init;
    procedure setControlEnabled(en:boolean);
  end;

var
  W_AddDelColor: TW_AddDelColor;

implementation

var reqRedraw : boolean;
{$R *.lfm}

procedure ApplyAddCouleurs (var _ImgSrc, _ImgDst : TMemoryPix; var _img : TImage; couleur : TColor ; poids : real; _progress : boolean);
var _width, _height, x, y : integer;
  R,G,B : Byte;
  _couleur : TCouleur;
  _luminance : real;
  _calc : boolean;
  _teinte : integer;
begin
  // Initialisation de l'image de destination
  // Lecture de la taille de l'image source
  _ImgSrc.GetImageSize(_width, _height);
  // Initialisation de l'image de destination
  _ImgDst.Init(_width, _height, false);
  _couleur.R := real(Red(couleur));
  _couleur.V := real(Green(couleur));
  _couleur.B := real(Blue(couleur));
  // Boucle de traitement
  for x := 0 to _width - 1 do begin
      for y :=0 to _height - 1 do begin
          // Lecture du pixel source
          _ImgSrc.getPixel(x,y,R,G,B);
          // Le pixel n'est pas affecté
          couleur := RGBToColor(R,G,B);
          // Détermination de la luminance
          _luminance := GetLuminance (R,G,B);
          // Détermination de la teinte pour s'avoir s'il faut ou non faire les calculs
          _teinte := TSL_getTeinteIndex(R,G,B);
          _calc := (((_luminance < _CTonsSombres) and _ATonsSombres) or
                   ((_luminance < _CTonsMoyens) and _ATonsMoyens and (_luminance >= _CTonsSombres)) or
                   ((_luminance >= _CTonsMoyens) and _ATonsClairs))
                   and
                   ((t_rouge   and (_teinte = 1)) or
                    (t_jaune   and (_teinte = 2)) or
                    (t_vert    and (_teinte = 3)) or
                    (t_cyan    and (_teinte = 4)) or
                    (t_bleu    and (_teinte = 5)) or
                    (t_magenta and (_teinte = 6)) or
                    (t_mono    and (_teinte = 7)));
          // Détermination si le ton est dans le domaine de calcul
          if _calc then begin
            // Calcul de la couleur résultante
            couleur := TSL_ApplyAddColor(_couleur, integer(R),integer(G),integer(B), poids);
          end;
          // Ecriture du pixel de destination
          _ImgDst.setPixel(x,y,couleur);
      end;
      if (x mod c_refresh = 0) and _progress then ProgressWindow.SetProgressInc(x/(_width-1)*_Prog_Calc);
      Application.ProcessMessages;
  end;
  _ImgDst.copyImageIntoTImage(_img, _progress);
  _img.Refresh;
end;

procedure ApplySubCouleurs (var _ImgSrc, _ImgDst : TMemoryPix; var _img : TImage; couleur : TColor ; poids : real; _progress : boolean);
var _width, _height, x, y : integer;
  R,G,B : Byte;
  _couleur : TCouleur;
  _luminance : real;
  _calc : boolean;
  _teinte : integer;
begin
  // Initialisation de l'image de destination
  // Lecture de la taille de l'image source
  _ImgSrc.GetImageSize(_width, _height);
  // Initialisation de l'image de destination
  _ImgDst.Init(_width, _height, false);
  _couleur.R := real(Red(couleur));
  _couleur.V := real(Green(couleur));
  _couleur.B := real(Blue(couleur));
  // Boucle de traitement
  for x := 0 to _width - 1 do begin
      for y :=0 to _height - 1 do begin
          // Lecture du pixel source
          _ImgSrc.getPixel(x,y,R,G,B);
          // Le pixel n'est pas affecté
          couleur := RGBToColor(R,G,B);
          // Détermination de la luminance
          _luminance := GetLuminance (R,G,B);
          // Détermination de la teinte pour s'avoir s'il faut ou non faire les calculs
          _teinte := TSL_getTeinteIndex(R,G,B);
          _calc := (((_luminance < _CTonsSombres) and _ATonsSombres) or
                   ((_luminance < _CTonsMoyens) and _ATonsMoyens and (_luminance >= _CTonsSombres)) or
                   ((_luminance >= _CTonsMoyens) and _ATonsClairs))
                   and
                   ((t_rouge   and (_teinte = 1)) or
                    (t_jaune   and (_teinte = 2)) or
                    (t_vert    and (_teinte = 3)) or
                    (t_cyan    and (_teinte = 4)) or
                    (t_bleu    and (_teinte = 5)) or
                    (t_magenta and (_teinte = 6)) or
                    (t_mono    and (_teinte = 7)));
          if _calc then begin
            // Calcul de la couleur résultante
            couleur := TSL_ApplySubColor(_couleur, integer(R),integer(G),integer(B), poids);
          end;
          // Ecriture du pixel de destination
          _ImgDst.setPixel(x,y,couleur);
      end;
      if (x mod 150 = 0) and _progress then ProgressWindow.SetProgressInc(x/(_width-1)*_Prog_Calc);
      Application.ProcessMessages;
  end;
  ProgressWindow.InterCommit;
  _ImgDst.copyImageIntoTImage(_img, _progress);
  _img.Refresh;
end;

procedure applyColor(var _ImgSrc, _ImgDst : TMemoryPix; var _img : TImage; couleur : TColor ; poids : real; _add,  _progress : boolean);
begin
  bouchee := false;
  cramee := false;
  if _add then ApplyAddCouleurs(_ImgSrc, _ImgDst, _img, couleur, poids, _progress)
  else ApplySubCouleurs(_ImgSrc, _ImgDst, _img, couleur, poids, _progress);
  if cramee then W_AddDelColor.Ind_Crame.Brush.Color := C_CRAME
  else W_AddDelColor.Ind_Crame.Brush.Color := C_RIEN;
  if bouchee then W_AddDelColor.Ind_Bouche.Brush.Color := C_BOUCHE
  else W_AddDelColor.Ind_Bouche.Brush.Color := C_RIEN;
end;

procedure RefreshTargetColor(_pangle, _psat, _plum, _papp : real; var _s, _s1 : TShape);
var _color : TColor;
  _angle, _sat, _lum, _app : real;
  _red, _green, _blue : real;
begin
  if not isTransaction then begin
    isTransaction := true;
    while reqRedraw do begin
      reqRedraw := false;
      if _pangle = 36000 then _angle := 0 else _angle := _pangle / 100;
      _sat := _psat/255;
      _lum := _plum/255;
      _app := _papp/255;
      _color := TSL_getRGBColorFromTSL(_angle,_sat,_lum);
      _red := Red(_color) * _app;
      _green := Green(_color) * _app;
      _blue := Blue(_color) * _app;
      _s.Brush.Color := _color;
      _s1.Brush.Color := RGBToColor(Byte(round(_red)),Byte(round(_green)),Byte(round(_blue)));
      applyColor(_lumprev, _calculatedpix, W_Prev.Preview,_color, _app, W_AddDelColor.RB_Add.Checked, false);
    end;
    isTransaction := false;
  end;
end;


procedure setSelectedColor(_color : TColor);
var R,G,B : Byte;
  TSL : TTSL;
  posit, dec : integer;
  _txt, _txt2 : string;
  _coef : real;
  Teinte : float;
begin
  R := Red(_color);
  G := Green(_color);
  B := Blue(_color);
  if (R = 0) and (G = 0) and (B = 0) then begin
    TSL.T := 0;
    TSL.S := 0;
    TSL.L := 0;
    Teinte := 0;
  end else if (R=1) and (G=0) and (B=0) then begin
    TSL.T := 0;
    TSL.S := 1;
    TSL.L := 0.5;
  end else begin
      try
        TSL := TSL_getTSLFromRGB(R,G,B);
        Teinte := TSL.T;
        Teinte := Teinte * 36000;
      Except
        TSL.T := 0;
        TSL.S := 1;
        TSL.L := 0.5;
        Teinte := 0;
      end;
  end;
  if TSL.T >= 1 then W_AddDelColor.TrackBar1.Position := 36000
  else if TSL.T <0 then W_AddDelColor.TrackBar1.Position := 0
  else
    W_AddDelColor.TrackBar1.Position := round(TSL.T*36000);
  dec := W_AddDelColor.TrackBar1.Position - (W_AddDelColor.TrackBar1.Position div 100) * 100;
  posit := (W_AddDelColor.TrackBar1.Position - dec) div 100;
  str(posit, _txt);
  _txt := concat(_txt,'.');
  str(dec, _txt2);
  _txt := concat(_txt, _txt2);
  W_AddDelColor.TXT_Col.Caption := _txt;
  str (trunc(TSL.S*255), _txt);
  W_AddDelColor.TXT_Sat.text := _txt;
  W_AddDelColor.TrackBar2.Position := trunc(TSL.S*255);
  str (trunc(TSL.L*255), _txt);
  W_AddDelColor.TXT_Lum.text := _txt;
  W_AddDelColor.TrackBar4.Position := trunc(TSL.L*255);
  W_AddDelColor.Shape1.Brush.Color := _color;
  _coef := W_AddDelColor.TrackBar3.Position / 255;
  W_AddDelColor.Shape2.Brush.Color := RGBToColor(Byte(round(R * _coef)),Byte(round(G * _coef)),Byte(round(B * _coef)));
  reqRedraw := true;
  RefreshTargetColor(W_AddDelColor.TrackBar1.Position, W_AddDelColor.TrackBar2.Position, W_AddDelColor.TrackBar4.Position, W_AddDelColor.TrackBar3.Position, W_AddDelColor.Shape1, W_AddDelColor.Shape2);
end;


{ TW_AddDelColor }

procedure TW_AddDelColor.setControlEnabled(en:boolean);
begin
  Panel1.Enabled := en;
  Panel2.Enabled := en;
  Panel3.Enabled := en;
  Panel4.Enabled := en;
  Panel5.Enabled := en;
  Panel6.Enabled := en;
  Panel7.Enabled := en;
  TrackBar1.Enabled := en;
  TrackBar2.Enabled := en;
  TrackBar3.Enabled := en;
  TrackBar4.Enabled := en;
  RB_Add.Enabled := en;
  RB_Sub.Enabled := en;
  GroupBox1.Enabled := en;
  GroupBox2.Enabled := en;
  Button1.Enabled := en;
  Button2.Enabled := en;
end;

procedure TW_AddDelColor.Init;
begin
  TrackBar1.Position := 0;
  TrackBar2.Position := 0;
  TrackBar3.Position := 0;
  TrackBar4.Position := 0;
  Shape1.Brush.Color := RGBToColor(0,0,0);
  Shape2.Brush.Color := RGBToColor(0,0,0);
  TXT_Col.Text := '0.0';
  TXT_Sat.Text := '0';
  TXT_Lum.Text := '0';
  TXT_Int.Text := '0';
  W_AddDelColor.CB_C.Checked := _ATonsClairs;
  W_AddDelColor.CB_M.Checked := _ATonsMoyens;
  W_AddDelColor.CB_S.Checked := _ATonsSombres;
  W_AddDelColor.CB_Rouges.Checked := t_rouge ;
  W_AddDelColor.CB_Jaunes.Checked := t_jaune ;
  W_AddDelColor.CB_Verts.Checked := t_vert ;
  W_AddDelColor.CB_Cyans.Checked := t_cyan ;
  W_AddDelColor.CB_Bleus.Checked := t_bleu ;
  W_AddDelColor.CB_Magentas.Checked := t_magenta ;
  W_AddDelColor.CB_Mono.Checked := t_mono ;
  W_AddDelColor.Ind_Crame.Brush.Color := C_RIEN;
  W_AddDelColor.Ind_Bouche.Brush.Color := C_RIEN;
  RB_Add.Checked := true;
end;

procedure TW_AddDelColor.FormCreate(Sender: TObject);
var i, _width, _height : integer;
  _color : TColor;
begin
  SelectedColor := @Panel7;
  _width := IMG_ColorTSL.width;
  _height := IMG_ColorTSL.height;
  IMG_ColorTSL.Picture.Bitmap.Height := _height;
  IMG_ColorTSL.Picture.Bitmap.Width := _width;
  for i := 0 to 36000 do begin
    _color := TSL_getRGBColorFromTSL(i/100);
    IMG_ColorTSL.Picture.Bitmap.Canvas.Brush.Color := _color;
    IMG_ColorTSL.Picture.Bitmap.Canvas.FillRect(round(i/36000*_width),0,_width,_height);
  end;
end;

procedure TW_AddDelColor.FormHide(Sender: TObject);
begin
  _currentWin := nil;
  Timer1.enabled := false;
end;

procedure TW_AddDelColor.FormShow(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TW_AddDelColor.GroupBox2Click(Sender: TObject);
begin

end;

procedure TW_AddDelColor.IMG_ColorTSLClick(Sender: TObject);
begin

end;

procedure TW_AddDelColor.IMG_ColorTSLMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var _color : TColor;
begin
  _color := W_AddDelColor.IMG_ColorTSL.Picture.Bitmap.Canvas.Pixels[X,Y];
  setSelectedColor(_color);
end;

procedure TW_AddDelColor.IMG_ColorTSLMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var _color : TColor;
begin
  if not (ssLeft in Shift) then exit ;
    if (X >= 0) and (X < W_AddDelColor.IMG_ColorTSL.width) then begin
      _color := W_AddDelColor.IMG_ColorTSL.Picture.Bitmap.Canvas.Pixels[X,Y];
      setSelectedColor(_color);
    end;
end;

procedure TW_AddDelColor.Button1Click(Sender: TObject);
var x,y : integer;
  couleur : TColor;
  poids : real;
  _txt : string;
begin
  isTransaction := true;
  _event := true;
  W_AddDelColor.Enabled := false;
  Form3.Show;
  Form3.Enabled := false;
  ProgressWindow.ShowWindow('Traitements...', 'Application des réglages');
  Screen.Cursor := crHourGlass ;
  _finalpix.getImageSize(x,y);
  _calculatedpix.Init(x,y,false);
  couleur := W_AddDelColor.Shape1.Brush.Color;
  poids := W_AddDelColor.TrackBar3.Position / 255;
  if  W_AddDelColor.RB_Add.Checked then ApplyAddCouleurs(_finalpix, _calculatedpix, Form3.imgres, couleur, poids, true)
  else ApplySubCouleurs(_finalpix, _calculatedpix, Form3.imgres, couleur, poids, true);
  ProgressWindow.SetProgress('Réglages appliqués', 100);
  Form3.Refresh;
  init_param(_params);
  if RB_Add.Checked then
    _param := new_param('Fonction', 'Addition')
  else _param := new_param('Fonction', 'Soustraction');
  add_param(_params, _param);
  _param := new_param('Angle de couleur', TXT_Col.Text);
  add_param(_params, _param);
  _param := new_param('Coef saturation', TXT_Sat.Text);
  add_param(_params, _param);
  _param := new_param('Coef lumière', TXT_Lum.Text);
  add_param(_params, _param);
  _param := new_param('Intensité d''application', TXT_Int.Text);
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
  _command := new_command('Ajout/Suppression signal couleur', _params);
  isTransaction := false;
  ProgressWindow.HideWindow;
  setControlEnabled(false);
  W_AddDelColor.Enabled := true;
  Form3.Enabled := true;
  Screen.Cursor := crDefault;
  _event := false;
  Form3.setFocus;
end;

procedure TW_AddDelColor.Button2Click(Sender: TObject);
begin
  self.Init;
  applyColor(_lumprev, _calculatedpix, W_Prev.Preview,rgbtocolor(0,0,0), 0, W_AddDelColor.RB_Add.Checked, false);
end;

procedure TW_AddDelColor.CB_BleusChange(Sender: TObject);
begin
  t_bleu := CB_Bleus.Checked;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.CB_CChange(Sender: TObject);
begin
  _ATonsClairs := CB_C.Checked;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.CB_CyansChange(Sender: TObject);
begin
  t_cyan := CB_Cyans.Checked;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.CB_JaunesChange(Sender: TObject);
begin
  t_jaune := CB_Jaunes.Checked;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.CB_MagentasChange(Sender: TObject);
begin
  t_magenta := CB_Magentas.Checked;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.CB_MChange(Sender: TObject);
begin
  _ATonsMoyens := CB_M.Checked;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.CB_MonoChange(Sender: TObject);
begin
  t_mono := CB_Mono.Checked;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.CB_RougesChange(Sender: TObject);
begin
  t_rouge := CB_Rouges.Checked;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.CB_SChange(Sender: TObject);
begin
  _ATonsSombres := CB_S.Checked;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.CB_VertsChange(Sender: TObject);
begin
  t_vert := CB_Verts.Checked;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.FormActivate(Sender: TObject);
begin
  if Form3.isVisible then exit;
  setControlEnabled(true);
  try
  if not isTransaction then begin
    if _S_Reanalyse or _RefreshRequest then begin
      _event := true;
      if _S_Reanalyse then W_AddDelColor.Init;
      preparePreview(W_SRC.View, W_Prev.Preview);
      _lumprev.Init(W_Prev.Preview);
      reqRedraw := true;
      RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
      _S_Reanalyse := false;
      _event := false;
    end;
  end;
  finally
    _event := false;
  end;
  _RefreshRequest := false;
end;

procedure TW_AddDelColor.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TW_AddDelColor.Label4Click(Sender: TObject);
begin

end;

procedure TW_AddDelColor.Panel1Click(Sender: TObject);
var _color : TColor;
begin
  _color := Panel1.Color;
  setSelectedColor(_color);
end;

procedure TW_AddDelColor.Panel2DblClick(Sender: TObject);
var _color : TColor;
begin
  _color := Panel2.Color;
  setSelectedColor(_color);
end;

procedure TW_AddDelColor.Panel3DblClick(Sender: TObject);
var _color : TColor;
begin
  _color := Panel3.Color;
  setSelectedColor(_color);
end;

procedure TW_AddDelColor.Panel4Click(Sender: TObject);
begin

end;

procedure TW_AddDelColor.Panel4DblClick(Sender: TObject);
var  _color : TColor;
begin
  _color := Panel4.Color;
  setSelectedColor(_color);
end;

procedure TW_AddDelColor.Panel5DblClick(Sender: TObject);
var _color : TColor;
begin
  _color := Panel5.Color;
  setSelectedColor(_color);
end;

procedure TW_AddDelColor.Panel6Click(Sender: TObject);
begin

end;

procedure TW_AddDelColor.Panel6DblClick(Sender: TObject);
var
  _color : TColor;
begin
  _color := Panel6.Color;
  setSelectedColor(_color);
end;

procedure TW_AddDelColor.Panel7Click(Sender: TObject);
begin
end;

procedure TW_AddDelColor.Panel7DblClick(Sender: TObject);
var _color : TColor;
begin
  _color := Panel7.Color;
  setSelectedColor(_color);
end;

procedure TW_AddDelColor.RB_AddChange(Sender: TObject);
begin
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.RB_SubChange(Sender: TObject);
begin
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
end;

procedure TW_AddDelColor.Timer1Timer(Sender: TObject);
begin
  if W_AddDelColor.IsVisible = false then begin // Pas de MaJ si la fenêtre est fermée.
    Timer1.Enabled := false;
    exit;
  end;
  if _refreshRequest then W_AddDelColor.FormActivate(Sender);
end;

procedure TW_AddDelColor.TrackBar1Click(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TrackBar1KeyDown(Sender, keypressed, Shift);
end;

procedure TW_AddDelColor.TrackBar1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _txt, _txt2 : string;
  posit, dec : integer;
begin
  // Do something
  if _event then exit;
  _event := true;
  dec := TrackBar1.Position - (TrackBar1.Position div 100) * 100;
  posit := (TrackBar1.Position - dec) div 100;
  str(posit, _txt);
  _txt := concat(_txt,'.');
  str(dec, _txt2);
  if dec < 10 then _txt := concat(_txt, '0');
  _txt := concat(_txt, _txt2);
  TXT_Col.Caption := _txt;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TrackBar1KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_AddDelColor.TrackBar1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TrackBar1.Enabled := false;
    TrackBar1.Enabled := true;
    TrackBar1.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TrackBar1KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_AddDelColor.TrackBar1MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  TrackBar1Click(Sender);
end;

procedure TW_AddDelColor.TrackBar2Click(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TrackBar2KeyDown(Sender, keypressed, Shift);
end;

procedure TW_AddDelColor.TrackBar2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _txt : string;
begin
  // Do Something
  if _event then exit;
  _event := true;
  str (TrackBar2.Position, _txt);
  TXT_Sat.text := _txt;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TrackBar2KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_AddDelColor.TrackBar2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TrackBar2.Enabled := false;
    TrackBar2.Enabled := true;
    TrackBar2.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TrackBar2KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_AddDelColor.TrackBar2MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  TrackBar2Click(Sender);
end;

procedure TW_AddDelColor.TrackBar3Click(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TrackBar3KeyDown(Sender, keypressed, Shift);
end;

procedure TW_AddDelColor.TrackBar3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _txt : string;
begin
  // Do Something
  if _event then exit;
  _event := true;
  str (TrackBar3.Position, _txt);
  TXT_Int.text := _txt;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TrackBar3KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_AddDelColor.TrackBar3MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TrackBar3.Enabled := false;
    TrackBar3.Enabled := true;
    TrackBar3.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TrackBar3KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_AddDelColor.TrackBar3MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  TrackBar3Click(Sender);
end;

procedure TW_AddDelColor.TrackBar4Change(Sender: TObject);
begin

end;

procedure TW_AddDelColor.TrackBar4Click(Sender: TObject);
var keypressed : Word;
  Shift: TShiftState;
begin
    keypressed := Word(#32);
    TrackBar4KeyDown(Sender, keypressed, Shift);
end;

procedure TW_AddDelColor.TrackBar4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _txt : string;
begin
  // Do Something
  if _event then exit;
  _event := true;
  str (TrackBar4.Position, _txt);
  TXT_Lum.text := _txt;
  reqRedraw := true;
  RefreshTargetColor(TrackBar1.Position, TrackBar2.Position, TrackBar4.Position, TrackBar3.Position, Shape1, Shape2);
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TrackBar4KeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_AddDelColor.TrackBar4MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TrackBar4.Enabled := false;
    TrackBar4.Enabled := true;
    TrackBar4.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TrackBar4KeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_AddDelColor.TrackBar4MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  TrackBar4Click(Sender);
end;


begin
  reqRedraw := false;
end.

