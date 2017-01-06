unit saturationglobale;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, MemoryPix, constantes, global, TSL, Prev, ProgressWindows,
  unit3, Diary, types,Luminance, marqueurs, saveenv, w_source;

type

  { TW_SatG }

  TW_SatG = class(TForm)
    Button1: TButton;
    CB_C: TCheckBox;
    CB_Rouges: TCheckBox;
    CB_M: TCheckBox;
    CB_Jaunes: TCheckBox;
    CB_S: TCheckBox;
    CB_Verts: TCheckBox;
    CB_Cyans: TCheckBox;
    CB_Bleus: TCheckBox;
    CB_Magentas: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    RB_Lineaire: TRadioButton;
    RB_Synchro: TRadioButton;
    Timer1: TTimer;
    TXT_Sat: TEdit;
    Shape43: TShape;
    TB_Sat: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure CB_BleusChange(Sender: TObject);
    procedure CB_CChange(Sender: TObject);
    procedure CB_CyansChange(Sender: TObject);
    procedure CB_JaunesChange(Sender: TObject);
    procedure CB_MagentasChange(Sender: TObject);
    procedure CB_MChange(Sender: TObject);
    procedure CB_RougesChange(Sender: TObject);
    procedure CB_SChange(Sender: TObject);
    procedure CB_VertsChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
    procedure RB_LineaireChange(Sender: TObject);
    procedure RB_SynchroChange(Sender: TObject);
    procedure TB_SatChange(Sender: TObject);
    procedure TB_SatClick(Sender: TObject);
    procedure TB_SatKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB_SatMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure TB_SatMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    const _code = 11;
  public
    { public declarations }
    procedure Init;
    procedure _Refresh(Sender : TObject);
    procedure setControlEnabled(en:boolean);
  end;

var
  W_SatG: TW_SatG;

implementation

{$R *.lfm}

var askRedraw : boolean;

// Internal
procedure applySaturation(var _ImgSrc, _ImgDst : TMemoryPix ; var _img : TImage ; deltaS : integer; synchro : boolean ; _progress : boolean);
var _width, _height, x, y : integer;
  R,G,B : Byte;
  couleur : TColor;
  _luminance : real;
  _teinte : integer;
begin
  if not isTransaction then begin
    isTransaction := true;
    while askRedraw do begin
      askRedraw := false;
      // taille de l'image
      _ImgSrc.getImageSize(_width, _height);
      // Init de l'image de destination
      _ImgDst.Init(_width, _height, false);
      // Boucle de traitement
      for x := 0 to _width - 1 do begin
        for y :=0 to _height - 1 do begin
          // Lecture du pixel source
          _ImgSrc.getPixel(x,y,R,G,B);
          // Determination de la teinte
          _teinte := TSL_getTeinteIndex(R,G,B);
          //Calcul couleur destination
          couleur := RGBToColor(R,G,B);
          // La teinte est-elle dans le domaine de calcul
          if (t_rouge   and (_teinte = 1)) or
             (t_jaune   and (_teinte = 2)) or
             (t_vert    and (_teinte = 3)) or
             (t_cyan    and (_teinte = 4)) or
             (t_bleu    and (_teinte = 5)) or
             (t_magenta and (_teinte = 6)) then begin
            // Calcul de la couleur résultante
            _luminance := GetLuminance (R,G,B);
            // Détermination si le ton est dans le domaine de calcul
            if ((_luminance < _CTonsSombres) and _ATonsSombres) then
              // Calcul de la couleur résultante
              couleur := TSL_modifSat(R,G,B, deltaS, synchro)
            else if ((_luminance < _CTonsMoyens) and _ATonsMoyens and (_luminance >= _CTonsSombres)) then
              // Calcul de la couleur résultante
              couleur := TSL_modifSat(R,G,B, deltaS, synchro)
            else if (_luminance >= _CTonsMoyens) and _ATonsClairs then
              // Calcul de la couleur résultante
              couleur := TSL_modifSat(R,G,B, deltaS, synchro);
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
    isTransaction := false;
  end;
end;

{ TW_SatG }

procedure TW_SatG.setControlEnabled(en:boolean);
begin
  TB_Sat.Enabled := en;
  GroupBox1.Enabled := en;
  GroupBox2.Enabled := en;
  GroupBox3.Enabled := en;
  Button1.Enabled := en;
end;

procedure TW_SatG.Init;
begin
  TB_Sat.Position := 500;
  TXT_Sat.Text := '0';
  W_SatG.CB_C.Checked := _ATonsClairs;
  W_SatG.CB_M.Checked := _ATonsMoyens;
  W_SatG.CB_S.Checked := _ATonsSombres;
  W_SatG.CB_Rouges.Checked := t_rouge;
  W_SatG.CB_Jaunes.Checked := t_jaune;
  W_SatG.CB_Verts.Checked := t_vert;
  W_SatG.CB_Cyans.Checked := t_cyan;
  W_SatG.CB_Bleus.Checked := t_bleu;
  W_SatG.CB_Magentas.Checked := t_magenta;

end;

procedure TW_SatG.Button1Click(Sender: TObject);
var x, y : integer;
  _txt : string;
begin
  askRedraw := true;
  _event := true;
  W_SatG.Enabled := false;
  Form3.Show;
  W_SatG.Enabled := false;
  ProgressWindow.ShowWindow('Traitements...', 'Application des réglages');
  Screen.Cursor := crHourGlass ;
  _finalpix.getImageSize(x,y);
  _calculatedpix.Init(x,y,false);
  ApplySaturation(_finalpix, _calculatedpix, Form3.imgres, round(((TB_Sat.Position - 500)/500)*256), RB_Synchro.Checked, true);
  ProgressWindow.SetProgress('Réglages appliqués', 100);
  Form3.Refresh;
  init_param(_params);
  _param := new_param('Coef saturation', TXT_Sat.Text);
  add_param(_params, _param);
  if RB_Lineaire.Checked then
    _param := new_param('Mode de calcul de la saturation', 'Linéaire')
  else
    _param := new_param('Mode de calcul de la saturation', 'Synchronisé');
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
  _command := new_command('Saturation globale', _params);
  ProgressWindow.HideWindow;
  setControlEnabled(false);
  W_SatG.Enabled := true;
  Form3.Enabled := true;
  Screen.Cursor := crDefault;
  _event := false;
  Form3.setFocus;
end;

procedure TW_SatG.CB_BleusChange(Sender: TObject);
begin
  t_bleu := CB_Bleus.Checked;
  askRedraw := true;
  ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500) / 500) * 255), RB_Synchro.Checked, false);
end;

procedure TW_SatG.CB_CChange(Sender: TObject);
begin
  _ATonsClairs := CB_C.Checked;
  askRedraw := true;
  ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500) / 500) * 255), RB_Synchro.Checked, false);
end;

procedure TW_SatG.CB_CyansChange(Sender: TObject);
begin
  t_cyan := CB_Cyans.Checked;
  askRedraw := true;
  ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500) / 500) * 255),  RB_Synchro.Checked, false);
end;

procedure TW_SatG.CB_JaunesChange(Sender: TObject);
begin
  t_jaune := CB_Jaunes.Checked;
  askRedraw := true;
  ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500) / 500) * 255), RB_Synchro.Checked, false);
end;

procedure TW_SatG.CB_MagentasChange(Sender: TObject);
begin
  t_magenta := CB_Magentas.Checked;
  askRedraw := true;
  ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500) / 500) * 255), RB_Synchro.Checked, false);
end;

procedure TW_SatG.CB_MChange(Sender: TObject);
begin
  _ATonsMoyens := CB_M.Checked;
  askRedraw := true;
  ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500) / 500) * 255), RB_Synchro.Checked, false);
end;

procedure TW_SatG.CB_RougesChange(Sender: TObject);
begin
  t_rouge := CB_Rouges.Checked;
  askRedraw := true;
  ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500) / 500) * 255), RB_Synchro.Checked, false);
end;

procedure TW_SatG.CB_SChange(Sender: TObject);
begin
  _ATonsSombres := CB_S.Checked;
  askRedraw := true;
  ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500) / 500) * 255), RB_Synchro.Checked, false);
end;

procedure TW_SatG.CB_VertsChange(Sender: TObject);
begin
  t_vert := CB_Verts.Checked;
  askRedraw := true;
  ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500) / 500) * 255), RB_Synchro.Checked, false);
end;

procedure TW_SatG.FormActivate(Sender: TObject);
var
  _width, _height : integer;
begin
  if Form3.isVisible then exit;
  setControlEnabled(true);
  try
  if not isTransaction then begin
    if _S_Reanalyse then begin
      _event := true;
      Init;
      preparePreview(W_SRC.View, W_Prev.Preview);
      _lumprev.Init(W_Prev.Preview);
      _S_Reanalyse := false;
      _event := false;
    end else if _RefreshRequest then begin
      screen.Cursor := crHourglass;
      _event := true;
      _lumprev.getImageSize(_width, _height);
      _calculatedpix.Init(_width, _height, false);
      askRedraw := true;
      ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500) / 500) * 255), RB_Synchro.Checked, false);
      _event := false;
      screen.Cursor := crDefault;
    end;
  end;
  finally
  end;
  _RefreshRequest := false;
end;

procedure TW_SatG.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TW_SatG.FormCreate(Sender: TObject);
begin

end;

procedure TW_SatG.FormHide(Sender: TObject);
begin
  Timer1.enabled := false;
  _currentWin := nil;
end;

procedure TW_SatG.FormShow(Sender: TObject);
begin
  Timer1.enabled := true;
end;

procedure TW_SatG.GroupBox2Click(Sender: TObject);
begin

end;

procedure TW_SatG.RB_LineaireChange(Sender: TObject);
begin
  askRedraw := true;
  ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500) / 500) * 255), RB_Synchro.Checked, false);
end;

procedure TW_SatG.RB_SynchroChange(Sender: TObject);
begin

end;

procedure TW_SatG.TB_SatChange(Sender: TObject);
begin

end;

procedure TW_SatG.TB_SatClick(Sender: TObject);
var keypressed : Word;
  Shift : TShiftState;
begin
    keypressed := Word(#32);
    TB_SatKeyDown(Sender, keypressed, Shift);
end;

procedure TW_SatG.TB_SatKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var _width, _height : integer;
  _txt : string;
begin
  if _event then exit;
  _event := true;
  _lumprev.getImageSize(_width, _height);
  _calculatedpix.Init(_width, _height, false);
  askRedraw := true;
  ApplySaturation (_lumprev, _calculatedpix, W_Prev.Preview, round(((TB_Sat.Position - 500)/500)*256), RB_Synchro.Checked, false);
  str (TB_Sat.Position - 500, _txt);
  TXT_Sat.Text := _txt;
  _event := false;
  if _lostfocus then begin
    _lostfocus := false;
    TB_SatKeyDown(Sender, Key, Shift);
  end;
end;

procedure TW_SatG.TB_SatMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var keypressed : Word;
begin
  if not(ssleft in Shift) then begin
    TB_Sat.Enabled := false;
    TB_Sat.Enabled := true;
    TB_Sat.SetFocus;
    _lostfocus := true;
  end else begin
    keypressed := Word(#32);
    TB_SatKeyDown(Sender, keypressed, Shift);
  end;
end;

procedure TW_SatG.TB_SatMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  TB_SatClick(Sender);
end;

procedure TW_SatG.Timer1Timer(Sender: TObject);
begin
  if W_SatG.visible = false then begin // Pas de MaJ si la fenêtre est fermée.
    Timer1.Enabled := false;
    exit;
  end;
  if _refreshRequest then W_SatG.FormActivate(Sender);
end;

procedure TW_SatG._Refresh(Sender : TObject);
begin
  FormActivate(Sender);
end;

begin
  askRedraw := false;
end.

