unit W_Convolution;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Global, Convolution, Prev, MemoryPix, unit3,
  ProgressWindows, w_source, Diary, types, marqueurs, saveenv, Constantes;

type

  { TW_Filtres }

  TW_Filtres = class(TForm)
    B1: TButton;
    Button1: TButton;
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
    CB_Verts: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    imgsrc: TImage;
    imgfocus: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    RB_1: TRadioButton;
    RB_10: TRadioButton;
    RB_11: TRadioButton;
    RB_12: TRadioButton;
    RB_13: TRadioButton;
    RB_14: TRadioButton;
    RB_2: TRadioButton;
    RB_3: TRadioButton;
    RB_4: TRadioButton;
    RB_5: TRadioButton;
    RB_6: TRadioButton;
    RB_7: TRadioButton;
    RB_8: TRadioButton;
    RB_9: TRadioButton;
    SB_H: TTrackBar;
    SB_V: TTrackBar;
    Shape1: TShape;
    Timer1: TTimer;
    procedure B10Click(Sender: TObject);
    procedure B11Click(Sender: TObject);
    procedure B12Click(Sender: TObject);
    procedure B13Click(Sender: TObject);
    procedure B14Click(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure B2Click(Sender: TObject);
    procedure B3Click(Sender: TObject);
    procedure B4Click(Sender: TObject);
    procedure B5Click(Sender: TObject);
    procedure B6Click(Sender: TObject);
    procedure B7Click(Sender: TObject);
    procedure B8Click(Sender: TObject);
    procedure B9Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure imgsrcMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgsrcMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure imgsrcMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgsrcMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Label2Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Panel3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RadioButton2Change(Sender: TObject);
    procedure RB_10Change(Sender: TObject);
    procedure RB_11Change(Sender: TObject);
    procedure RB_12Change(Sender: TObject);
    procedure RB_13Change(Sender: TObject);
    procedure RB_14Change(Sender: TObject);
    procedure RB_1Change(Sender: TObject);
    procedure RB_2Change(Sender: TObject);
    procedure RB_3Change(Sender: TObject);
    procedure RB_4Change(Sender: TObject);
    procedure RB_5Change(Sender: TObject);
    procedure RB_6Change(Sender: TObject);
    procedure RB_7Change(Sender: TObject);
    procedure RB_8Change(Sender: TObject);
    procedure RB_9Change(Sender: TObject);
    procedure SB_H1Change(Sender: TObject);
    procedure SB_HKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SB_HMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SB_HMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SB_HMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure SB_V1Change(Sender: TObject);
    procedure SB_VKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SB_VMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SB_VMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SB_VMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBar1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    const _code = 12;
  public
    { public declarations }
    procedure Init;
    procedure setControlEnabled(en:boolean);
  end;

var
  W_Filtres: TW_Filtres;

implementation

{$R *.lfm}

var
  _coefred : real;
  _apcolor : boolean;

  // Flou Gaussien doux
  _init1  : TConvMatrice = (_size:(2);_data:(_2:(

                            (00,00,01,00,00),
                            (00,01,02,01,00),
                            (01,02,10,02,01), //-
                            (00,01,02,01,00),
                            (00,00,01,00,00))));

  // Flou Gaussien moyen
  _init2  : TConvMatrice = (_size:(2);_data:(_2:(
                            (000,001,004,001,000),
                            (001,018,036,018,001),
                            (004,036,100,036,004), //-
                            (001,018,036,018,001),
                            (000,001,004,001,000))));

  // Flou Gaussien fort
  _init3  : TConvMatrice = (_size:(2);_data:(_2:(
                            (002,005,010,005,002),
                            (005,030,040,030,005),
                            (010,040,100,040,010), //-
                            (005,030,040,030,005),
                            (002,005,010,005,002))));

  // Flou standard doux
  _init4  : TConvMatrice = (_size:(1);_data:(_1:(
                            (001,001,001),
                            (001,007,001), //-
                            (001,001,001))));

  // Flou standard moyen
  _init5  : TConvMatrice = (_size:(5);_data:(_5:(
                            (000,000,000,000,000,000,000,000,000,000,000),
                            (000,000,000,000,000,000,000,000,000,000,000),
                            (000,000,000,000,000,001,000,000,000,000,000),
                            (000,000,000,000,001,001,001,000,000,000,000),
                            (000,000,000,001,001,001,001,001,000,000,000),
                            (000,000,001,001,001,001,001,001,001,000,000), //-
                            (000,000,000,001,001,001,001,001,000,000,000),
                            (000,000,000,000,001,001,001,000,000,000,000),
                            (000,000,000,000,000,001,000,000,000,000,000),
                            (000,000,000,000,000,000,000,000,000,000,000),
                            (000,000,000,000,000,000,000,000,000,000,000))));


  // Flou standard fort
  _init6  : TConvMatrice = (_size:(5);_data:(_5:(
                            (000,000,000,000,001,001,001,000,000,000,000),
                            (000,000,001,001,001,001,001,001,001,000,000),
                            (000,001,001,001,001,001,001,001,001,001,000),
                            (000,001,001,001,001,001,001,001,001,001,000),
                            (001,001,001,001,001,001,001,001,001,001,001),
                            (001,001,001,001,001,001,001,001,001,001,001), //-
                            (001,001,001,001,001,001,001,001,001,001,001),
                            (000,001,001,001,001,001,001,001,001,001,000),
                            (000,001,001,001,001,001,001,001,001,001,000),
                            (000,000,001,001,001,001,001,001,001,000,000),
                            (000,000,000,000,001,001,001,000,000,000,000))));


  // Filtre passe bas
  _init7  : TConvMatrice = (_size:(1);_data:(_1:(
                            (001,001,001),
                            (001,004,001), //-
                            (001,001,001))));


  // Filtre passe haut
  _init8  : TConvMatrice = (_size:(1);_data:(_1:(
                            (000,-01,000),
                            (-01,005,-01), //-
                            (000,-01,000))));

  // Filtre passe haut doux
  _init9  : TConvMatrice = (_size:(1);_data:(_1:(
                            (-01,001,-01),
                            (001,004,001), //-
                            (-01,001,-01))));

  // Netteté douce
  _init10 : TConvMatrice = (_size:(2);_data:(_2:(
                            (000,000,-02,000,000),
                            (000,-01,-05,-01,000),
                            (-02,-05,050,-05,-02), //-
                            (000,-01,-05,-01,000),
                            (000,000,-02,000,000))));

  // Netteté moyenne
  _init11 : TConvMatrice = (_size:(1);_data:(_1:(
                            (000,-04,000),
                            (-04,018,-04), //-
                            (000,-04,000))));

  // Netteté forte
  _init12 : TConvMatrice = (_size:(2);_data:(_2:(
                            (000,000,-01,000,000),
                            (000,000,-02,000,000),
                            (-01,-02,013,-02,-01), //-
                            (000,000,-02,000,000),
                            (000,000,-01,000,000))));

  // Contraste faible
  _init13 : TConvMatrice = (_size:(2);_data:(_2:(
                            (-1,-1,02,-1,-1),
                            (-1,02,-1,02,-1),
                            (02,-1,14,-1,02), //-
                            (-1,02,-1,02,-1),
                            (-1,-1,02,-1,-1))));

  // Contraste fort
  _init14 : TConvMatrice = (_size:(2);_data:(_2:(
                            (00,00,-3,00,00),
                            (00,-1,-6,-1,00),
                            (-3,-6,55,-6,-3), //-
                            (00,-1,-6,-1,00),
                            (00,00,-3,00,00))));

  // Neutre
  _initNeutral : TConvMatrice = (_size:(1);_data:(_1:(
                                 (00,00,00),
                                 (00,01,00), //-
                                 (00,00,00))));



{ TW_Filtres }

procedure TW_Filtres.setControlEnabled(en:boolean);
begin
  Panel1.Enabled := en;
  Panel2.Enabled := en;
end;

procedure TW_Filtres.Init;
begin
  RB_1.Checked := false;
  RB_2.Checked := false;
  RB_3.Checked := false;
  RB_4.Checked := false;
  RB_5.Checked := false;
  RB_6.Checked := false;
  RB_7.Checked := false;
  RB_8.Checked := false;
  RB_9.Checked := false;
  RB_10.Checked := false;
  RB_11.Checked := false;
  RB_12.Checked := false;
  RB_13.Checked := false;
  W_Filtres.CB_C.Checked := _ATonsClairs;
  W_Filtres.CB_M.Checked := _ATonsMoyens;
  W_Filtres.CB_S.Checked := _ATonsSombres;
  W_Filtres.CB_Rouges.Checked := t_rouge;
  W_Filtres.CB_Jaunes.Checked := t_jaune;
  W_Filtres.CB_Verts.Checked := t_vert;
  W_Filtres.CB_Cyans.Checked := t_cyan;
  W_Filtres.CB_Bleus.Checked := t_bleu;
  W_Filtres.CB_Magentas.Checked := t_magenta;
  W_Filtres.CB_Mono.Checked := t_Mono;


  MatConv.InitValeurs(_initNeutral);
end;

procedure TW_Filtres.Panel1Click(Sender: TObject);
begin

end;

procedure TW_Filtres.Panel3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Filtres.Panel3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
end;

procedure TW_Filtres.Panel3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TW_Filtres.RadioButton2Change(Sender: TObject);
begin

end;

procedure ApplyPrevConv(var _MatConv : TMatConv; var _src, _dst : TMemoryPix; var imgdst : TImage; _color, _progress:boolean);
var _width, _height : integer;
begin
  _src.getImageSize(_width, _height);
  _dst.Init(_width,_height,_progress);
  _MatConv.apply(_src, _dst,
    _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono,
    _color, _progress, 50);
  _dst.copyImageIntoTImage(imgdst, _progress);
end;

procedure draw_Preview;
begin
  if W_Filtres.visible = false then begin // Pas de MaJ si la fenêtre est fermée.
    W_Filtres.Timer1.Enabled := false;
    exit;
  end;
  _event := true;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Filtres.SB_H.Position,W_Filtres.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  ApplyPrevConv(MatConv, _lumprev, _calculatedpix, W_Prev.Preview, _apcolor, false);
  _event := false;
end;

procedure ApplyConv(var _MatConv : TMatConv; var _src, _dst : TMemoryPix; var imgdst : TImage; _progress:boolean);
var x,y : integer;
begin
  _event := true;
  if _progress then ProgressWindow.ShowWindow('Traitements...', 'Application du filtre');
  Screen.Cursor := crHourGlass ;
  _src.getImageSize(x,y);
  _dst.Init(x,y,false);
  _MatConv.apply(_src, _dst,
    _ATonsClairs, _ATonsMoyens, _ATonsSombres, t_rouge, t_jaune, t_vert, t_cyan, t_bleu, t_magenta, t_mono,
    _apcolor, _progress, _Prog_Calc);
  _dst.copyImageIntoTImage(imgdst, _progress);
  if _progress then ProgressWindow.SetProgress('Filtre appliqué', 100);
  if _progress then ProgressWindow.HideWindow;
  Screen.Cursor := crDefault;
  _event := false;
end;

procedure init_focusdraw ;
var x,y,startx,endx,starty,endy : integer;
  R,G,B : Byte;
begin
  // Action utilisateur => Activation du timer pour la preview
  W_Filtres.Timer1.Enabled := true;
  // détermination de la zone de focus
  startx := W_Filtres.SB_H.Position;
  starty := W_Filtres.SB_V.Position;
  endx := startx+120;
  endy := starty+120;
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
  W_Filtres.imgfocus.Picture.Bitmap.Width := 121;
  W_Filtres.imgfocus.Picture.Bitmap.Height := 121;

  // Calcul de la convolution
  ApplyConv(MatConv, _focusdrawsrc, _focusdrawdst, W_Filtres.imgfocus, false);
end;

procedure TW_Filtres.RB_10Change(Sender: TObject);
begin
  // Netteté douce
  MatConv.InitValeurs(_init10);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_11Change(Sender: TObject);
begin
  // Netteté moyenne
  MatConv.InitValeurs(_init11);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_12Change(Sender: TObject);
begin
  // Netteté forte
  MatConv.InitValeurs(_init12);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_13Change(Sender: TObject);
begin
  // Contraste faible
  MatConv.InitValeurs(_init13);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_14Change(Sender: TObject);
begin
  // Contraste fort
  MatConv.InitValeurs(_init14);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_1Change(Sender: TObject);

begin
    // Flou Gaussien doux
    MatConv.InitValeurs(_init1);
    Init_focusdraw;
    _reqRedraw := true;
end;

procedure TW_Filtres.RB_2Change(Sender: TObject);
begin
  // Flou Gaussien moyen
  MatConv.InitValeurs(_init2);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_3Change(Sender: TObject);
begin
  // Flou Gaussien fort
  MatConv.InitValeurs(_init3);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_4Change(Sender: TObject);
begin
  // Flou standard doux
  MatConv.InitValeurs(_init4);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_5Change(Sender: TObject);
begin
  // Flou standard moyen
  MatConv.InitValeurs(_init5);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_6Change(Sender: TObject);
begin
  // Flou standard fort
  MatConv.InitValeurs(_init6);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_7Change(Sender: TObject);
begin
  // Filtre passe bas
  MatConv.InitValeurs(_init7);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_8Change(Sender: TObject);
begin
  // Filtre passe haut
  MatConv.InitValeurs(_init8);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.RB_9Change(Sender: TObject);
begin
  // Filtre passe haut doux
  MatConv.InitValeurs(_init9);
  Init_focusdraw;
  _reqRedraw := true;
end;

procedure TW_Filtres.SB_H1Change(Sender: TObject);
begin
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  Init_focusdraw;
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_Filtres.SB_HKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if _event then exit;
  SB_H.enabled := false;
  screen.Cursor := crHourGlass;
  _event := true;
  _reqRedraw := true;
  _event := false;
  screen.Cursor := crDefault;
  SB_H.enabled := true;
end;

procedure TW_Filtres.SB_HMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw := true;
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Filtres.SB_H.Position,W_Filtres.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  draw_preview;
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_Filtres.SB_HMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
end;

procedure TW_Filtres.SB_HMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Filtres.SB_H.Position,W_Filtres.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  draw_preview;
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_Filtres.SB_V1Change(Sender: TObject);
begin
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  Init_focusdraw;
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_Filtres.SB_VKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if _event then exit;
  SB_V.enabled := false;
  screen.Cursor := crHourGlass;
  _event := true;
  _reqRedraw := true;
  _event := false;
  screen.Cursor := crDefault;
  SB_V.enabled := false;
end;

procedure TW_Filtres.SB_VMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw := true;
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Filtres.SB_H.Position,W_Filtres.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  draw_preview;
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_Filtres.SB_VMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
end;

procedure TW_Filtres.SB_VMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Filtres.SB_H.Position,W_Filtres.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  draw_preview;
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_Filtres.ScrollBar1Change(Sender: TObject);
begin
end;

procedure TW_Filtres.Timer1Timer(Sender: TObject);
begin
  if W_Filtres.visible = false then begin // Pas de MaJ si la fenêtre est fermée.
    Timer1.Enabled := false;
    exit;
  end;
  if _event then exit;
  if _refreshRequest then W_Filtres.FormActivate(Sender) else begin
    _event := true;
    screen.Cursor := crHourGlass;
    while _reqRedraw do begin
      _reqRedraw := false;

      preparePreview2(W_SRC.View, W_Prev.Preview,SB_H.Position,SB_V.Position);
      _lumprev.Init(W_Prev.Preview);

      draw_preview;
    end ;
    screen.Cursor := crDefault;
    _event := false;

  end;
end;

procedure TW_Filtres.Label2Click(Sender: TObject);
begin
end;


procedure TW_Filtres.Label6Click(Sender: TObject);
begin
  RB_1.Checked := true;
end;

procedure TW_Filtres.Label8Click(Sender: TObject);
begin
  RB_2.Checked := true;
end;

procedure TW_Filtres.B14Click(Sender: TObject);
begin
end;

procedure TW_Filtres.B1Click(Sender: TObject);
var _txt : string;
begin
  W_Filtres.Enabled := false;
  isTransaction := true;
  init_param(_params);
  if W_Filtres.RB_1.checked then
  begin
    MatConv.InitValeurs(_init1);
    _param := new_param('Flou gaussien', 'Doux');
    add_param(_params, _param);
  end else if W_Filtres.RB_2.Checked then
  begin
    MatConv.InitValeurs(_init2);
    _param := new_param('Flou gaussien', 'Moyen');
    add_param(_params, _param);
  end else if W_Filtres.RB_3.Checked then
  begin
    MatConv.InitValeurs(_init3);
    _param := new_param('Flou gaussien', 'Fort');
    add_param(_params, _param);
  end else if W_Filtres.RB_4.Checked then
  begin
    MatConv.InitValeurs(_init4);
    _param := new_param('Flou standard', 'Doux');
    add_param(_params, _param);
  end else if W_Filtres.RB_5.Checked then
  begin
    MatConv.InitValeurs(_init5);
    _param := new_param('Flou standard', 'Moyen');
    add_param(_params, _param);
  end else if W_Filtres.RB_6.Checked then
  begin
    MatConv.InitValeurs(_init6);
    _param := new_param('Flou standard', 'Fort');
    add_param(_params, _param);
  end else if W_Filtres.RB_7.Checked then
  begin
    MatConv.InitValeurs(_init7);
    _param := new_param('Filtres passe haut/Passe bas', 'Passe bas');
    add_param(_params, _param);
  end else if W_Filtres.RB_8.Checked then
  begin
    MatConv.InitValeurs(_init8);
    _param := new_param('Filtres passe haut/Passe bas', 'Passe haut');
    add_param(_params, _param);
  end else if W_Filtres.RB_9.Checked then
  begin
    MatConv.InitValeurs(_init9);
    _param := new_param('Filtres passe haut/Passe bas', 'Passe haut doux');
    add_param(_params, _param);
  end else if W_Filtres.RB_10.Checked then
  begin
    MatConv.InitValeurs(_init10);
    _param := new_param('Netteté', 'Douce');
    add_param(_params, _param);
  end else if W_Filtres.RB_11.Checked then
  begin
    MatConv.InitValeurs(_init11);
    _param := new_param('Netteté', 'Moyenne');
    add_param(_params, _param);
  end else if W_Filtres.RB_12.Checked then
  begin
    MatConv.InitValeurs(_init12);
    _param := new_param('Netteté', 'Forte');
    add_param(_params, _param);
  end else if W_Filtres.RB_13.Checked then
  begin
    MatConv.InitValeurs(_init13);
    _param := new_param('Contraste', 'Faible');
    add_param(_params, _param);
  end else if W_Filtres.RB_14.Checked then
  begin
    MatConv.InitValeurs(_init14);
    _param := new_param('Contraste', 'Fort');
    add_param(_params, _param);
  end else begin
    MessageDlg ('Avertissement !', 'Aucun filtre sélectionné !', mtWarning, [mbYes], 0);
    isTransaction := false;
    W_Filtres.Enabled := true;
    exit;
  end;
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
    _param := new_param('Contraste couleurs', 'Désactivé') ;
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
  _command := new_command('Filtre de convolution', _params);
  W_Filtres.Timer1.Enabled := false;
  Form3.show;
  Form3.enabled := false;
  ApplyConv(MatConv, _finalpix, _calculatedpix, Form3.imgres, true);
  isTransaction := false;
  setControlEnabled(false);
  W_Filtres.Enabled := true;
  Form3.Enabled := true;
  Form3.setFocus;
end;

procedure TW_Filtres.B2Click(Sender: TObject);
begin
end;

procedure TW_Filtres.B3Click(Sender: TObject);
begin
end;

procedure TW_Filtres.B4Click(Sender: TObject);
begin
end;

procedure TW_Filtres.B5Click(Sender: TObject);
begin
end;

procedure TW_Filtres.B6Click(Sender: TObject);
begin
end;

procedure TW_Filtres.B7Click(Sender: TObject);
begin
end;

procedure TW_Filtres.B8Click(Sender: TObject);
begin
end;

procedure TW_Filtres.B9Click(Sender: TObject);
begin
end;

procedure TW_Filtres.Button1Click(Sender: TObject);
begin
  _S_Reanalyse := true;
  FormActivate(Sender);
end;

procedure TW_Filtres.CB_BleusChange(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  Init_focusdraw;
  _event := true;
  t_bleu := CB_Bleus.Checked;
  _event := false;
  _reqRedraw := true;
end;

procedure TW_Filtres.CB_CChange(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  Init_focusdraw;
  _event := true;
  _ATonsClairs := CB_C.Checked;
  _event := false;
  _reqRedraw := true;
end;

procedure TW_Filtres.CB_CouleurChange(Sender: TObject);
begin
  Init_focusdraw;
  _apColor := CB_Couleur.Checked ;
  _reqRedraw := true;
end;

procedure TW_Filtres.CB_CyansChange(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  Init_focusdraw;
  _event := true;
  t_cyan := CB_Cyans.Checked;
  _event := false;
  _reqRedraw := true;
end;

procedure TW_Filtres.CB_JaunesChange(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  Init_focusdraw;
  _event := true;
  t_jaune := CB_Jaunes.Checked;
  _event := false;
  _reqRedraw := true;
end;

procedure TW_Filtres.CB_MagentasChange(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  Init_focusdraw;
  _event := true;
  t_magenta := CB_Magentas.Checked;
  _event := false;
  _reqRedraw := true;
end;

procedure TW_Filtres.CB_MChange(Sender: TObject);
begin
  Init_focusdraw;
  _ATonsMoyens := CB_M.Checked;
  _reqRedraw := true;
end;

procedure TW_Filtres.CB_MonoChange(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  Init_focusdraw;
  _event := true;
  t_Mono := CB_Mono.Checked;
  _event := false;
  _reqRedraw := true;
end;

procedure TW_Filtres.CB_RougesChange(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  Init_focusdraw;
  _event := true;
  t_rouge := CB_Rouges.Checked;
  _event := false;
  _reqRedraw := true;
end;

procedure TW_Filtres.CB_SChange(Sender: TObject);
begin
  Init_focusdraw;
  _ATonsSombres := CB_S.Checked;
  _reqRedraw := true;
end;

procedure TW_Filtres.CB_VertsChange(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  Init_focusdraw;
  _event := true;
  t_vert := CB_Verts.Checked;
  _event := false;
  _reqRedraw := true;
end;

procedure TW_Filtres.FormActivate(Sender: TObject);
begin
  if Form3.isVisible then exit;
  setControlEnabled(true);
  try
  if not isTransaction then begin
    if _S_Reanalyse then begin
      Init;
    end;
    Timer1.Enabled := true;
    Init_focusdraw;
    _reqRedraw := false;
    screen.Cursor := crHourGlass;
    prepareZoom(W_SRC.View, imgsrc, 121,121);
    _lumprev.Init(W_Prev.Preview);
    if _RefreshRequest then begin
      _reqRedraw := true;
    end;
    _S_Reanalyse := false;
    screen.Cursor := crDefault;
  end;

  finally
  end;
  _RefreshRequest := false;

end;

procedure TW_Filtres.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TW_Filtres.FormCreate(Sender: TObject);
begin
  MatConv.InitValeurs(_initNeutral);
end;

procedure TW_Filtres.FormDeactivate(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TW_Filtres.FormHide(Sender: TObject);
begin
  imgsrc.Picture.bitmap.width := 0;
  imgsrc.Picture.bitmap.height := 0;
  imgsrc.Picture.Bitmap.Clear;
  W_Filtres.Timer1.Enabled := false;
  _currentWin := nil;
end;

procedure TW_Filtres.FormShow(Sender: TObject);
var x, y : integer;
begin
  W_Filtres.Timer1.Enabled := true;
  _event := true;
  _coefred := (W_SRC.View.Picture.Bitmap.Width / W_Prev.Preview.Picture.Bitmap.Width);
  _coefred := _coefred * _coefred;
  _coefred := _coefred / 8 + 0.875;
  if _coefred < 1 then _coefred := 1;
  x := W_SRC.View.Picture.Bitmap.Width;
  y := W_SRC.View.Picture.Bitmap.Height;
  _finalpix.Init(W_SRC.View);
  imgsrc.Picture.Bitmap.Width := 121;
  imgsrc.Picture.Bitmap.Height := 121;
  SB_H.Max := x - 121;
  SB_V.Max := y - 121;
  Init_focusdraw;
  _reqRedraw := true;
  _event := false;
end;

procedure TW_Filtres.Image3Click(Sender: TObject);
begin

end;

procedure TW_Filtres.imgsrcMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

begin
    imgsrcMouseMove(Sender,Shift,X,Y);
end;

procedure TW_Filtres.imgsrcMouseMove(Sender: TObject; Shift: TShiftState; X,
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

    _coef := max(W_SRC.View.Picture.Bitmap.Width,W_SRC.View.Picture.Bitmap.Height) / W_Filtres.imgsrc.Width;
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

    _event := false;

end;

procedure TW_Filtres.imgsrcMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _reqRedraw := true;
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Filtres.SB_H.Position,W_Filtres.SB_V.Position);
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_Filtres.imgsrcMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _reqRedraw := true;
  if _event then exit;
  screen.Cursor := crHourGlass;
  _event := true;
  preparePreview2(W_SRC.View, W_Prev.Preview,W_Filtres.SB_H.Position,W_Filtres.SB_V.Position);
  _lumprev.Init(W_Prev.Preview);
  _event := false;
  screen.Cursor := crDefault;
end;

procedure TW_Filtres.B13Click(Sender: TObject);
begin
end;

procedure TW_Filtres.B12Click(Sender: TObject);
begin
end;

procedure TW_Filtres.B11Click(Sender: TObject);
begin
end;

procedure TW_Filtres.B10Click(Sender: TObject);
begin
end;

begin
  _apcolor := true;
end.

