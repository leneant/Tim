unit Unit1;

{$mode objfpc}{$H+} {$F+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, W_saturation, Prev, Unit3, Unit5, Global, ProgressWindows,
  MemoryPix, Utils, w_source, Luminance, W_Luminance, TempCouleurs,
  W_AddDelColorSignal, saturationglobale, W_Convolution, Convolution, Convolution_Red, Diary,
  W_ContrasteG, W_MasqueFlou, w_waves, W_RGB_Align, lcltype, constantes, saveenv,
  clipbrd, ComCtrls, lazutf8, TAGraph, TASeries, types, compilation, FilePix,
  BackgroundLum, AdvancedFilters, RotationRBV, Configuration, W_RGBToBN;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    Txt_sombres: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    TFonces: TBarSeries;
    TMoyens: TBarSeries;
    TClairs: TBarSeries;
    Image1: TImage;
    LBL_MemError: TLabel;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    SaveDialog1: TSaveDialog;
    TB1: TTrackBar;
    TB2: TTrackBar;
    Txt_moyens: TLabel;
    _pixsize: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem31Click(Sender: TObject);
    procedure MenuItem32Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem34Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure TB1Change(Sender: TObject);
    procedure TB1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TB2Change(Sender: TObject);
    procedure TB2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TB2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TB2MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure _pixsizeClick(Sender: TObject);
  private
    const _code = 1;
    { private declarations }
  public
    { public declarations }
    procedure setControlEnabled(en:boolean);
  end;

var
  Form1: TForm1;


implementation

{$R *.lfm}

var
  last_s, last_c : integer;

// Hiding all windows
procedure _HideWindows;
begin
  W_Sat.Hide;
  W_SatG.Hide;
  W_Lum.Hide;
  Form3.Hide;
  W_TempCouleurs.Hide;
  W_AddDelColor.Hide;
  W_Filtres.Hide;
  W_ContratsG.Hide;
  W_MF.Hide;
  W_Wavelets.Hide;
  W_BackgroundLum.Hide;
  W_RGBAlign.Hide;
  Form2.Hide;
  W_Configuration.Hide;
  W__RGBToBN.Hide;
end;

procedure _refresh(Sender : TObject);
begin
  last_s := Form1.TB1.Position;
  last_c := Form1.TB2.Position;
  if  W_Lum.IsVisible then W_Lum.FormActivate(Sender)
  else if W_Sat.IsVisible then W_Sat.FormActivate(Sender)
  else if W_SatG.IsVisible then W_SatG.FormActivate(Sender)
  else if W_ContratsG.IsVisible then W_ContratsG.FormActivate(Sender)
  else if W_TempCouleurs.IsVisible then W_TempCouleurs.FormActivate(Sender)
  else if W_AddDelColor.IsVisible then W_AddDelColor.FormActivate(Sender)
  else if W_Filtres.IsVisible then W_Filtres.FormActivate(Sender)
  else if W_MF.IsVisible then W_MF.FormActivate(Sender)
  else if W_Wavelets.IsVisible then W_Wavelets.FormActivate(Sender)
  else if W_RGBAlign.IsVisible then W_RGBAlign.FormActivate(Sender)
  else if W_BackgroundLum.IsVisible then W_BackgroundLum.FormActivate(Sender);
end;

procedure drawEchelleTons;
var i : integer;
begin
  Form1.TFonces.Clear;
  Form1.TMoyens.Clear;
  Form1.TClairs.Clear;
    for i := 0 to 255 do begin
    if i < _CTonsSombres then Form1.TFonces.AddXY(i, i) else
    if i < _CTonsMoyens then Form1.TMoyens.addXY(i,i) else
    Form1.TClairs.addXY(i,i);
  end;
end;

{ TForm1 }

procedure TForm1.setControlEnabled(en:boolean);
begin
  Panel1.Enabled := en;
  Panel2.Enabled := en;
  MenuItem3.Enabled := en;
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem9Click(Sender: TObject);
var
  _width, _height, _mbsize, _mbdec, _mbint : LongInt;
  i, j : integer;
  R, G, B, L : Byte;
  x, y, pix_size, _xtxt : string;
begin
    LBL_MemError.visible := false;
    if _event then exit;
    _event := true;
    Screen.Cursor := crHourGlass;
    try
      ProgressWindow.showWindow('Rotation de l''image','Rotation 90° en cours');
    except
      LBL_MemError.visible := true;
    end;
    Application.ProcessMessages;
    _finalpix.getImageSize(_width, _height);
    _calculatedpix.Init(_height, _width, true);
    for i := 0 to _width - 1 do begin
      for j := 0 to _height - 1 do begin
        _finalpix.getPixel(i, j, R, G, B, L);
        _calculatedpix.setPixel(_height-j-1, i, R, G, B, L);
      end;
      if i mod c_refresh = 0 then ProgressWindow.setProgress(i / (_width-1) * 30);
    end;
    ProgressWindow.InterCommit;
    _calculatedpix.copy(_finalpix, true, 20);
    Image1.Picture.Clear;
    _calculatedpix.copyImageIntoTImage(Image1, true);
    _width := Image1.Picture.Bitmap.Width;
    _height := Image1.Picture.Bitmap.Height;
    _SourcePix.Width := _width;
    _SourcePix.Height := _height;
    _SourcePix.Canvas.Draw(0,0, Image1.Picture.Bitmap);
    W_SRC.View.Picture.Bitmap.Width := _width;
    W_SRC.View.Picture.Bitmap.Height := _height;
    W_SRC.View.Picture.Bitmap.Canvas.Draw(0,0, Image1.Picture.Bitmap);
    ProgressWindow.SetProgress('Rotation achevée', 100);
    str(_width, y);
    str(_height, x);
    pix_size := concat('[',y);
    pix_size := concat(pix_size,',');
    pix_size := concat(pix_size, x);
    pix_size := concat(pix_size, ']');

    //Calcul du nombre de méga pixels
    _mbsize := (_width * _height) div 10000 ; // deux chiffres après la virgule
    _mbdec := _mbsize - ((_mbsize div 100) * 100);
    _mbint := _mbsize - _mbdec;
    pix_size := concat(pix_size, ' (');
    str(_mbint div 100, _xtxt);
    pix_size := concat(pix_size, _xtxt, '.');
    str(_mbdec, _xtxt);
    pix_size := concat(pix_size, _xtxt, ' Mega pixels)');

    _pixsize.Caption := pix_size;
    init_param(_params);
    _param := new_param('Angle', '90°');
    add_param(_params, _param);
    _command := new_command('Rotation image', _params);
    writeCommand(_diaryfilename, _command);
    ProgressWindow.hideWindow;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
    _event := false;
end;

procedure TForm1.TB1Change(Sender: TObject);
var _txt : string;
begin
  if _event or isTransaction then begin
    TB1.Position := last_s;
    exit;
  end;
  if TB1.Position >= TB2.Position then TB1.Position := TB2.Position ;
  _CTonsSombres := TB1.Position;
  str (_CTonsSombres, _txt);
  Txt_sombres.caption := _txt;
  drawEchelleTons;
end;

procedure TForm1.TB1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  _RefreshRequest := true;
  _Refresh(Sender);
end;

procedure TForm1.TB1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _RefreshRequest := true;
  _Refresh(Sender);
end;

procedure TForm1.TB1MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _RefreshRequest := true;
  _Refresh(Sender);
end;

procedure TForm1.TB2Change(Sender: TObject);
var _txt : string;
begin
  if _event or isTransaction then begin
    TB2.Position := last_c;
    exit;
  end;
  if TB2.Position <= TB1.Position then TB2.Position := TB1.Position ;
  _CTonsMoyens := TB2.Position;
  str (_CTonsMoyens, _txt);
  Txt_moyens.caption := _txt;
  drawEchelleTons;
end;

procedure TForm1.TB2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  _RefreshRequest := true;
  _Refresh(Sender);
end;

procedure TForm1.TB2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  _RefreshRequest := true;
  _Refresh(Sender);
end;

procedure TForm1.TB2MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  _RefreshRequest := true;
  _Refresh(Sender);
end;

procedure TForm1._pixsizeClick(Sender: TObject);
begin

end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  if _event then
     MessageDlg ('Avertissement !', 'Attendez la fin des calculs avant de quitter', mtWarning, [mbYes], 0)
  else begin
    screen.Cursor := crHourglass;
    Application.Terminate;
    screen.cursor := crDefault;
  end;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
var
  _width, _height, _mbsize, _mbdec, _mbint : LongInt;
  i, j : integer;
  R, G, B, L : Byte;
  x, y, pix_size, _xtxt : string;
begin
    LBL_MemError.visible := false;
    if _event then exit;
    _event := true;
    Screen.Cursor := crHourGlass;
    try
      ProgressWindow.showWindow('Rotation de l''image','Rotation -90° en cours');
    except
      LBL_MemError.visible := true;
    end;
    Application.ProcessMessages;

    _finalpix.getImageSize(_width, _height);
    _calculatedpix.Init(_height, _width, true);
    for i := 0 to _width - 1 do begin
      for j := 0 to _height - 1 do begin
        _finalpix.getPixel(i, j, R, G, B, L);
        _calculatedpix.setPixel(j, _width-i-1, R, G, B, L);
      end;
      if i mod c_refresh = 0 then ProgressWindow.setProgress(i / (_width-1) * 30);
    end;
    ProgressWindow.InterCommit;
    _calculatedpix.copy(_finalpix, true, 20);
    Image1.Picture.Clear;
    _calculatedpix.copyImageIntoTImage(Image1, true);
    _width := Image1.Picture.Bitmap.Width;
    _height := Image1.Picture.Bitmap.Height;
    _SourcePix.Width := _width;
    _SourcePix.Height := _height;
    _SourcePix.Canvas.Draw(0,0, Image1.Picture.Bitmap);
    W_SRC.View.Picture.Bitmap.Width := _width;
    W_SRC.View.Picture.Bitmap.Height := _height;
    W_SRC.View.Picture.Bitmap.Canvas.Draw(0,0, Image1.Picture.Bitmap);
    ProgressWindow.SetProgress('Rotation achevée', 100);
    str(_width, y);
    str(_height, x);
    pix_size := concat('[',y);
    pix_size := concat(pix_size,',');
    pix_size := concat(pix_size, x);
    pix_size := concat(pix_size, ']');

    //Calcul du nombre de méga pixels
    _mbsize := (_width * _height) div 10000 ; // deux chiffres après la virgule
    _mbdec := _mbsize - ((_mbsize div 100) * 100);
    _mbint := _mbsize - _mbdec;
    pix_size := concat(pix_size, ' (');
    str(_mbint div 100, _xtxt);
    pix_size := concat(pix_size, _xtxt, '.');
    str(_mbdec, _xtxt);
    pix_size := concat(pix_size, _xtxt, ' Mega pixels)');

    _pixsize.Caption := pix_size;
    init_param(_params);
    _param := new_param('Angle', '-90°');
    add_param(_params, _param);
    _command := new_command('Rotation image', _params);
    writeCommand(_diaryfilename, _command);
    ProgressWindow.hideWindow;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
    _event := false;
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
const br=255;
  bg=255;
  bb=255;
var total : LongInt;
  _width, _height, _percent : integer;
begin
  // Windows ID =  2
  LBL_MemError.visible := false;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  screen.cursor := crHourglass;
  _S_Reanalyse := false;
  _HideWindows;
  _LOpen := false;
  MenuItem2.Enabled := false;;
  try
    W_Sat.Show;
    _currentWin := @W_Sat;
  except
    LBL_MemError.visible := true;
  end;
  _SOpen := true;
  // init preview resolution windows
  tx := ResPreview[2];
  ty := ResPreview[2];


  try
    W_Prev.show;
  except
    LBL_MemError.visible := true;
  end;
  ProgressWindow.ShowWindow('Préparation des traitements', 'Analyse colorimétrique');
  W_Prev.Show;
  preparePreview(W_SRC.View, W_Prev.Preview);
  ProgressWindow.setProgress(30);
  if _ismprev then begin
    _mpreview.Destroy();
    _ismprev := false;
  end;
  _mpreview := TListPixels.Create();
  _ismprev := true;
  Application.ProcessMessages;
  try
    _mpreview.getImageFromTImage(W_Prev.Preview);
  except
    LBL_MemError.visible := true;
  end;
  progressWindow.SetProgress('Préparation terminée.', 100);

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

procedure TForm1.MenuItem4Click(Sender: TObject);
// Opening a file
var w_title, _sizetxt, _xtxt, _ytxt: string;
  filename : ansistring;
  _mbpix, _mbsize, _mbint, _mbdec : LongInt;
  _width, _height, _long, ret : integer;
  isNatif : boolean;
begin
  LBL_MemError.visible := false;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  OpenDialog1.Title := 'Chargement d''une image';
  OpenDialog1.DefaultExt := 'jpg';
  OpenDialog1.Filter := 'Tous formats|*.tim;*.TIM;*.jpg;*.JPG;*.jpeg;*.JPEG;*.bmp;*.BMP;*.png;*.PNG;*.tif;*.TIF;*.tiff;*.TIFF|Format natif Tim|*.tim;*.TIM|Image JPEG|*.jpg;*.JPG;*.jpeg;*.JPEG|Image BMP|*.bmp;*.BMP|Image PNG|*.png;*.PNG|Image TIFF|*.tif;*.TIF;*.tiff;*.TIFF';

  if OpenDialog1.Execute then
    begin
      Screen.Cursor := crHourGlass;
      MenuItem1.Enabled := false;
      MenuItem2.Enabled := false;
      MenuItem3.Enabled := false;
      Application.ProcessMessages;
      // Fermeture des fenêtre déjà ouvertes
      _HideWindows;
      filename := OpenDialog1.FileName;
      _long := length(filename);
      // Chargement de l'image
      try
          ProgressWindow.ShowWindow('Ouverture de l''image', 'Lecture du fichier... Veuillez patienter (cela peut être long).')
      except
        LBL_MemError.visible := true;
        _event := false;
      end;
      //Form1.Image1.visible := false;
{
      Form1.Image1.Picture.Bitmap.Width := 0;
      Form1.Image1.Picture.Bitmap.Height := 0;
      Form1.Image1.Picture.Bitmap.Clear;
}
      W_SRC.View.Picture.Bitmap.Width := 0;
      W_SRC.View.Picture.Bitmap.Height := 0;
      W_SRC.View.Picture.Bitmap.Clear;

      try
        ret := 0;
        isNatif :=  compareFileExt(filename, '.tim', false) = 0;
        if not isNatif then begin
          Form1.Image1.Picture.LoadFromFile(filename);
        end else begin
          ret := LoadPix(filename, _finalpix);
          if ret = 0 then
            _finalpix.copyImageIntoTImage(Form1.Image1, false);
            Application.ProcessMessages;
        end;
      except
        try
          _event := false;
          MenuItem1.Enabled := true;
          MessageDlg('Erreur','Impossible de charger l''image (Format non reconnu ou ressources insuffisantes).', mtConfirmation,
                      [mbYes],0);
        except
          LBL_MemError.visible := true;
          ProgressWindow.HideWindow;
          Screen.Cursor := crDefault;
          exit;
        end;
        ProgressWindow.HideWindow;
        _event := false;
        Screen.Cursor := crDefault;
        exit;
      end;
      if isNatif then begin
        _finalpix.getImageSize(_width, _height);
      end else begin
        _width := Form1.Image1.Picture.Bitmap.Width;
        _height := Form1.Image1.Picture.Bitmap.Height;
      end;
      _mbpix := LongInt(_Width) * LongInt(_Height);
      if  (_mbpix > (C_MemoryPix_MaxSize div 3)) or (ret <> 0) then begin
        ProgressWindow.hideWindow;
        Form1.Image1.Picture.Bitmap.Clear;
        MessageDlg ('Avertissement !', 'Taille de l''image trop importante. Tim ne peut pas les traiter pour le moment !', mtWarning, [mbYes], 0);
      end else begin
        if _isImg then begin
//          Img.Clear;
          _isImg := false;
        end;
        if _mbpix >= C_WarningSize then
          MessageDlg ('Avertissement !', 'Avec une machine de moins de 8Go de RAM, les temps de traitement peuvent être extrêmement longs. A tel point que Tim et l''ordinateur peuvent sembler être figés !', mtWarning, [mbYes], 0);
        _diaryfilename := copy(filename,0,_long);
        _diaryfilename := concat(_diaryfilename, '-diary-');
        _diaryfilename := concat(_diaryfilename,FormatDateTime('yyyy-mm-dd-hh-mm-ss',Now));
        _diaryfilename := concat(_diaryfilename,'.txt');
        createCommandFile(_diaryfilename);
        init_param(_params);
        _param := new_param('File name', filename);
        add_param(_params, _param);
        _param := new_param('Largeur',_width);
        add_param(_params, _param);
        _param := new_param('Hauteur',_height);
        add_param(_params,_param);
        _command := new_command('Ouverture image', _params);
        writeCommand(_diaryfilename, _command);

        _SourcePix.Width := _width;
        _SourcePix.Height := _height;
        Application.ProcessMessages;
        _SourcePix.SetSize(_width, _height);
        _SourcePix.PixelFormat := pf24bit;

        _SourcePix.Canvas.Draw(0,0, Image1.Picture.Bitmap);


        W_SRC.View.Picture.Bitmap.Width := _width;
        W_SRC.View.Picture.Bitmap.Height := _height;
        Application.ProcessMessages;
        W_SRC.View.Picture.Bitmap.SetSize(_width, _height);
        W_SRC.View.Picture.Bitmap.PixelFormat := pf24bit;
        W_SRC.Show;
        W_SRC.View.visible := true;

        W_SRC.View.Picture.Bitmap.Canvas.Draw(0,0, Image1.Picture.Bitmap);
        Form1.Image1.visible := true;

        try
          W_SRC.Show;
        except
          LBL_MemError.visible := true;
          _event := false;
          MenuItem1.Enabled := true;
          ProgressWindow.HideWindow;
          Screen.Cursor := crDefault;
          exit;
        end;
        W_Sat.Init;
        W_Lum.Init;
        W_TempCouleurs.Init;
        W_AddDelColor.Init;
        w_title := concat('Tim - [', _nameFromPath(filename));
        w_title := concat(w_title, ']');
        Form1.Caption := w_title;
        // Preparation de l'image de résultat final
        Form3.imgres.Picture.Bitmap.Width := Form1.Image1.Picture.Bitmap.Width;
        Form3.imgres.Picture.Bitmap.Height := Form1.Image1.Picture.Bitmap.Height;
        // Affichage de la taille de l'image
        str(Form1.Image1.Picture.Bitmap.Width, _xtxt);
        str(Form1.Image1.Picture.Bitmap.Height, _ytxt);
        _sizetxt := concat('[', _xtxt);
        _sizetxt := concat(_sizetxt,',');
        _sizetxt := concat(_sizetxt, _ytxt);
        _sizetxt := concat(_sizetxt,']');

        //Calcul du nombre de méga pixels
        _mbsize := _mbpix div 10000 ; // deux chiffres après la virgule
        _mbdec := _mbsize - ((_mbsize div 100) * 100);
        _mbint := _mbsize - _mbdec;
        _sizetxt := concat(_sizetxt, ' (');
        str(_mbint div 100, _xtxt);
        _sizetxt := concat(_sizetxt, _xtxt, '.');
        str(_mbdec, _xtxt);
        _sizetxt := concat(_sizetxt, _xtxt, ' Mega pixels)');

        Form1._pixsize.Caption := _sizetxt;
        // Analyse de l'image
        ProgressWindow.setProgress('Initialisation de la zone de travail...',10);
        if not isNatif then
           _finalpix.getImageFromTImage(W_SRC.View);
        _isfinal := true;
        ProgressWindow.setProgress('Préparation achevée', 100);
        // Accessibilité du menu
        Form1.MenuItem2.enabled := true;
        Form1.MenuItem3.enabled := true;
        // Fermeture de la fenetre de progression
        ProgressWindow.HideWindow;
        MenuItem16.Enabled := true;
        MenuItem15.Enabled := true;
        Screen.cursor := crDefault;
        TB1.Position := 85;
        TB2.Position := 170;
      end;
      MenuItem1.Enabled := true;
      MenuItem2.Enabled := true;
      MenuItem3.Enabled := true;
    end;
  _event := false;
  screen.cursor := crDefault;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  _ismprev := false;
  _isfinal := false;
  _workingdir := _pathFromPath(ParamStr(0));

  try
    // Memory area for final calculated pix. Each functionality post there results into this area
    _finalpix := TMemoryPix.Create(C_MemoryPix_MaxSize);
  Except
    MessageDlg('Erreur','Pas assez de mémoire pour exécuter l''application. L''aplication va être fermée !', mtConfirmation,
    [mbYes],0);
    Application.Terminate;
  end;
  try
    _calculatedpix := TMemoryPix.Create(C_MemoryPix_MaxSize);
  Except
    _finalpix.Destroy;
    MessageDlg('Erreur','Pas assez de mémoire pour exécuter l''application. L''aplication va être fermée !', mtConfirmation,
    [mbYes],0);
    Application.Terminate;
  end;
  _isfinal := true;
  // Memory area for preview pix
  _SourcePix := TBitmap.Create();
  try
    _lumprev := TMemoryPix.Create(max_tx,max_ty,true);
  Except
    _finalpix.Destroy;
    _calculatedpix.Destroy;
    MessageDlg('Erreur','Pas assez de mémoire pour exécuter l''application. L''aplication va être fermée !', mtConfirmation,
    [mbYes],0);
    Application.Terminate;
  end;
  try
    // _interprev := TMemoryPix.Create(max_tx,max_ty,true);
    _interprev := TMemoryPix.Create(C_MemoryPix_MaxSize);
  Except
    _finalpix.Destroy;
    _calculatedpix.Destroy;
    _lumprev.Destroy;
    MessageDlg('Erreur','Pas assez de mémoire pour exécuter l''application. L''aplication va être fermée !', mtConfirmation,
    [mbYes],0);
    Application.Terminate;
  end;
  try
    _focusdrawsrc := TMemoryPix.Create(C_Zoom_Size,C_Zoom_Size,true);
  Except
    _finalpix.Destroy;
    _calculatedpix.Destroy;
    _lumprev.Destroy;
    _interprev.Destroy;
    MessageDlg('Erreur','Pas assez de mémoire pour exécuter l''application. L''aplication va être fermée !', mtConfirmation,
    [mbYes],0);
    Application.Terminate;
  end;
  try
    _focusdrawdst := TMemoryPix.Create(C_Zoom_Size,C_Zoom_Size,true);
  Except
    _finalpix.Destroy;
    _calculatedpix.Destroy;
    _lumprev.Destroy;
    _interprev.Destroy;
    _focusdrawsrc.Destroy;
    MessageDlg('Erreur','Pas assez de mémoire pour exécuter l''application. L''aplication va être fermée !', mtConfirmation,
    [mbYes],0);
    Application.Terminate;
  end;
  MatConv := TMatConv.Create();
  MatConvRed := TMatConvRed.Create();

  drawEchelleTons;
end;

procedure TForm1.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  TB1.Position := last_s;
  TB2.Position := last_c;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if _event or isTransaction then exit;
  _event := true;
  _CTonsSombres := C_Init_S;
  _CTonsMoyens := C_Init_C;
  last_s := C_Init_S;
  last_c := C_Init_C;
  TB1.Position := C_Init_S ;
  TB2.Position := C_Init_C ;
  _event := false;
  drawEchelleTons;
   _RefreshRequest := true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if _ismprev and (_mpreview <> nil) then _mpreview.Destroy();
  try
    _finalpix.Destroy;
  finally
  end;
  try
    _SourcePix.Destroy;
  finally
  end;
  try
    _lumprev.Destroy;
  finally
  end;
  try
    _calculatedpix.Destroy;
  finally
  end;
  try
    MatConv.Destroy;
  finally
  end;
  try
    _focusdrawsrc.Destroy;
  finally
  end;
  try
    _focusdrawdst.Destroy;
  finally
  end;
  inherited;
end;

procedure TForm1.FormHide(Sender: TObject);
begin
  saveConfig(_G_Win_Conf);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
end;

procedure TForm1.FormResize(Sender: TObject);
begin
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  W_SRC.Show;
  W_Prev.Show;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
var
  _width, _height : LongInt;
  i, j : integer;
  R, G, B, L : Byte;
begin
    LBL_MemError.visible := false;
    if _event then exit;
    _event := true;
    Screen.Cursor := crHourGlass;
    try
      ProgressWindow.showWindow('Inversion de l''image','Inversion horizontale en cours');
    except
      LBL_MemError.visible := true;
    end;
    Application.ProcessMessages;
    _finalpix.getImageSize(_width, _height);
    _calculatedpix.Init(_width, _height, true);
    for i := 0 to _width - 1 do begin
      for j := 0 to _height - 1 do begin
        _finalpix.getPixel(i, j, R, G, B, L);
        _calculatedpix.setPixel(_width-i-1, j, R, G, B, L);
      end;
      if i mod c_refresh = 0 then ProgressWindow.setProgress(i / (_width-1) * 30);
    end;
    ProgressWindow.InterCommit;
    _calculatedpix.copy(_finalpix, true, 20);
    Image1.Picture.Clear;
    _calculatedpix.copyImageIntoTImage(Image1, true);
    _width := Image1.Picture.Bitmap.Width;
    _height := Image1.Picture.Bitmap.Height;
    _SourcePix.Width := _width;
    _SourcePix.Height := _height;
    _SourcePix.Canvas.Draw(0,0, Image1.Picture.Bitmap);
    W_SRC.View.Picture.Bitmap.Width := _width;
    W_SRC.View.Picture.Bitmap.Height := _height;
    W_SRC.View.Picture.Bitmap.Canvas.Draw(0,0, Image1.Picture.Bitmap);
    ProgressWindow.SetProgress('Inversion achevée', 100);
    init_param(_params);
    _param := new_param('Sens', 'Horizontal');
    add_param(_params, _param);
    _command := new_command('Inversion image', _params);
    writeCommand(_diaryfilename, _command);
    ProgressWindow.hideWindow;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
    _event := false;
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
var
  _width, _height : LongInt;
  i, j : integer;
  R, G, B, L : Byte;
begin
    LBL_MemError.visible := false;
    if _event then exit;
    _event := true;
    Screen.Cursor := crHourGlass;
    try
      ProgressWindow.showWindow('Inversion de l''image','Inversion verticale en cours');
    except
      LBL_MemError.visible := true;
    end;
    Application.ProcessMessages;
    _finalpix.getImageSize(_width, _height);
    _calculatedpix.init(_width, _height, true);
    for i := 0 to _width - 1 do begin
      for j := 0 to _height - 1 do begin
        _finalpix.getPixel(i, j, R, G, B, L);
        _calculatedpix.setPixel(i, _height-j-1, R, G, B, L);
      end;
      if i mod c_refresh = 0 then ProgressWindow.setProgress(i / (_width-1) * 30);
    end;
    ProgressWindow.InterCommit;
    _calculatedpix.copy(_finalpix, true, 20);
    Image1.Picture.Clear;
    _calculatedpix.copyImageIntoTImage(Image1, true);
    _width := Image1.Picture.Bitmap.Width;
    _height := Image1.Picture.Bitmap.Height;
    _SourcePix.Width := _width;
    _SourcePix.Height := _height;
    _SourcePix.Canvas.Draw(0,0, Image1.Picture.Bitmap);
    W_SRC.View.Picture.Bitmap.Width := _width;
    W_SRC.View.Picture.Bitmap.Height := _height;
    W_SRC.View.Picture.Bitmap.Canvas.Draw(0,0, Image1.Picture.Bitmap);
    ProgressWindow.SetProgress('Inversion achevée', 100);
    init_param(_params);
    _param := new_param('Sens', 'Vertical');
    add_param(_params, _param);
    _command := new_command('Inversion image', _params);
    writeCommand(_diaryfilename, _command);
    ProgressWindow.hideWindow;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
    _event := false;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
    LBL_MemError.visible := false;
    try
      Form5.Show;
    except
      LBL_MemError.visible := true;
    end;
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
var i : integer;
  gamma : real;
begin
  // Window ID = 4
  LBL_MemError.visible := false;
  if form3.isVisible then exit;
  if _event then exit;
   _event := true;
   _S_Reanalyse := false;
   _HideWindows;
   _SOpen := false;
   // init preview resolution windows
   tx := ResPreview[4];
   ty := ResPreview[4];

   gamma:=1;
   try
     ProgressWindow.ShowWindow('Traitements en cours', 'Calcul de la courbe Gamma');
   except
     LBL_MemError.visible := true;
   end;
   ProgressWindow.SetProgress(0);
   Screen.Cursor := crHourGlass;
   MenuItem2.Enabled := false;
   preparePreview(W_SRC.View, W_Prev.Preview);
   // Transformation en TMemoryPix
   if _islumprev then begin
     _lumprev.Clear;
     _islumprev := false;
   end;
   _lumprev.Init(W_Prev.Preview);
   _islumprev := true;
   W_Lum.Init;
   try
     W_Prev.Show;
     W_Lum.Show;
     _currentWin := @W_Lum;
   except
     LBL_MemError.visible := true;
   end;
   _Lopen := true;
   GetCourbeLumiereGAMMA(_lumprev, Lumiere, gamma);
   W_Lum.LumSerieGamma.Clear ;
   W_Lum.linegamma.Clear;
   for i:=0 to 255 do
     begin
       W_Lum.LumSerieGamma.AddXY(i, Lumiere[i]);
       W_Lum.linegamma.AddXY(i,i);
     end;
   ProgressWindow.SetProgress('Courbe calculée', 100);
   ProgressWindow.HideWindow;
   Screen.Cursor := crDefault;
   _event := false;
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem15Click(Sender: TObject);
var _width, _height : integer;
begin
   LBL_MemError.visible := false;
   if form3.isVisible then exit;
   if _event then exit;
   _event := true;
   _S_Reanalyse := false;
   _HideWindows;

   _SOpen := false;
   _LOpen := false;
   Screen.Cursor := crHourGlass;
   Application.ProcessMessages;
   try
     ProgressWindow.showWindow('Remise à zéro', 'Chargement de l''image d''origine...');
   except
     LBL_MemError.visible := true;
   end;
   _width := Image1.Picture.Bitmap.Width;
   _height := Image1.Picture.Bitmap.Height;
   _SourcePix.Width := _width;
   _SourcePix.Height := _height;
   _SourcePix.Canvas.Draw(0,0, Image1.Picture.Bitmap);
   W_SRC.View.Picture.Bitmap.Width := _width;
   W_SRC.View.Picture.Bitmap.Height := _height;
   W_SRC.View.Picture.Bitmap.Canvas.Draw(0,0, Image1.Picture.Bitmap);
   try
     W_SRC.Show;
   except
     LBL_MemError.visible := true;
   end;
   W_Sat.Init;
   // Preparation de l'image de résultat final
   Form3.imgres.Picture.Bitmap.Width := Form1.Image1.Picture.Bitmap.Width;
   Form3.imgres.Picture.Bitmap.Height := Form1.Image1.Picture.Bitmap.Height;
   // Analyse de l'image
   ProgressWindow.setProgress('Initialisation de la zone de travail...',0);
   _finalpix.getImageFromTImage(W_SRC.View);
   _isfinal := true;
   ProgressWindow.setProgress('Préparation achevée', 100);
   Form1.Image1.visible := true;
   // Accessibilité du menu
   Form1.MenuItem2.enabled := true;
   Form1.MenuItem3.enabled := true;
   init_param(_params);
   _command := new_command('Remize à Zéro depuis l''image d''origine');
   writeCommand(_diaryfilename, _command);
   // Fermeture de la fenetre de progression
   ProgressWindow.HideWindow;
   Screen.cursor := crDefault;
   _event := false;
end;

procedure TForm1.MenuItem16Click(Sender: TObject);
var txt, ext : ansistring;
  obmp : TBitmap;
  ret : integer;
begin
   LBL_MemError.Visible := false;
   if form3.isVisible then exit;
   if _event then exit;
   _event := true;
   SaveDialog1.Title := 'Enregistrement au format .BMP, .JPEG ou .PNG';
   SaveDialog1.DefaultExt := 'tim';
   SaveDialog1.Filter := 'Format natif Tim|*.tim;*.TIM|BMP picture|*.bmp;*.BMP|JPEG picture|*.jpg;*.JPG|PNG picture|*.png;*.PNG';
   Screen.Cursor := crHourGlass;
   Savedialog1.FileName := '';
   if SaveDialog1.Execute then
   begin
     txt := SaveDialog1.FileName;
     ext :=  ExtractFileExt(txt);
     try
       ret := 0;
       if comparetext(ext, '.tim') = 0 then begin
         ret := SavePix (txt, _finalpix);
       end else begin
         W_SRC.View.Picture.Jpeg.CompressionQuality := 100;
         W_SRC.View.Picture.SaveToFile(txt, ext);
       end;
       if ret = 0 then begin
         init_param(_params);
         _param := new_param('File name', txt);
         add_param(_params, _param);
         _command := new_command('Enregistrement image', _params);
         writeCommand(_diaryfilename, _command);
       end;
     Except
      MessageDlg('Erreur','Echec de l''enregistrement', mtError,
      [mbYes],0);
       obmp := TBitmap.Create;
       try
         obmp.assign(W_SRC.View.Picture.Graphic);
         try
            obmp.savetofile('save.bmp');
            MessageDlg('Information','La stratégie de contournement à réussie ! Image enregistrée dans le fichier ''save.bmp'' localisé dans le répertoire d''exécution de Tim.', mtInformation,
            [mbYes],0);
         except
          MessageDlg('Erreur','Désolé la stratégie de contournement à échouée ! Impossible d''enregistrer l''image (enregistrement impossible) !', mtConfirmation,
          [mbYes],0);
         end;
       Except
        MessageDlg('Erreur','Désolé la stratégie de contournement à échouée ! Impossible d''enregistrer l''image (affectation impossible) !', mtConfirmation,
        [mbYes],0);
       end;
       obmp.free;
      end;
     if ret <>0 then begin
       MessageDlg('Erreur','Echec de l''enregistrement', mtError,
       [mbYes],0);
     end;
   end;
  Screen.Cursor := crDefault;
  _event := false;
end;

procedure TForm1.MenuItem17Click(Sender: TObject);
begin
  // Window ID = 9
  LBL_MemError.visible := false;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  _S_Reanalyse := false;
  _HideWindows;

  _SOpen := false;
  ProgressWindow.SetProgress(0);
  Screen.Cursor := crHourGlass;
  MenuItem2.Enabled := false;
  // init preview resolution windows
  tx := ResPreview[9];
  ty := ResPreview[9];


  preparePreview(W_SRC.View, W_Prev.Preview);
  // Transformation en TMemoryPix
  if _islumprev then begin
    _lumprev.Clear;
    _islumprev := false;
  end;
  _lumprev.Init(W_Prev.Preview);
  _islumprev := true;
  try
    W_Prev.Show;
  except
    LBL_MemError.visible := true;
  end;
  try
    W_TempCouleurs.Init;
    W_TempCouleurs.Show;
    _currentWin := @W_TempCouleurs;
    _TCCouleur := true;
  except
    LBL_MemError.Visible := true;
  end;
  Screen.Cursor := crDefault;
  _event := false;
end;

procedure TForm1.MenuItem18Click(Sender: TObject);
begin
  // Window ID = 10
  LBL_MemError.visible := false;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  _S_Reanalyse := false;
  _HideWindows;

  _SOpen := false;
  ProgressWindow.SetProgress(0);
  Screen.Cursor := crHourGlass;
  MenuItem2.Enabled := false;
  // init preview resolution windows
  tx := ResPreview[10];
  ty := ResPreview[10];


  preparePreview(W_SRC.View, W_Prev.Preview);
  // Transformation en TMemoryPix
  if _islumprev then begin
    _lumprev.Clear;
    _islumprev := false;
  end;
  _lumprev.Init(W_Prev.Preview);
  _islumprev := true;
  try
    W_Prev.Show;
  except
    LBL_MemError.visible := true;
  end;
  W_AddDelColor.Init;
  try
    W_AddDelColor.Show;
    _currentWin := @W_AddDelColor;
    _ADCouleur := true;
  except
    LBL_MemError.visible := true;
  end;
  Screen.Cursor := crDefault;
  _event := false;
end;

procedure TForm1.MenuItem20Click(Sender: TObject);
begin
  // Window ID =  11
  LBL_MemError.visible := false;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  _S_Reanalyse := false;
  _HideWindows;

  _SOpen := false;
  ProgressWindow.SetProgress(0);
  Screen.Cursor := crHourGlass;
  MenuItem2.Enabled := false;
  // init preview resolution windows
  tx := ResPreview[11];
  ty := ResPreview[11];

  preparePreview(W_SRC.View, W_Prev.Preview);
  // Transformation en TMemoryPix
  if _islumprev then begin
    _lumprev.Clear;
    _islumprev := false;
  end;
  _lumprev.Init(W_Prev.Preview);
  _islumprev := true;
  try
    W_Prev.Show;
  except
    LBL_MemError.visible := true;
  end;
  W_SatG.Init;
  try
    W_SatG.Show;
    _currentWin := @W_SatG;
    _TCCouleur := true;
  except
    LBL_MemError.visible := true;
  end;
  Screen.Cursor := crDefault;
  _event := false;
end;

procedure TForm1.MenuItem21Click(Sender: TObject);
begin
  // Window ID = 12
  LBL_MemError.Visible := false;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  _S_Reanalyse := false;
  _HideWindows;

  _SOpen := false;
  ProgressWindow.SetProgress(0);
  Screen.Cursor := crHourGlass;
  MenuItem2.Enabled := false;
  tx := ResPreview[12];
  ty := ResPreview[12];


  preparePreview2(W_SRC.View, W_Prev.Preview,0,0);
  // Transformation en TMemoryPix
  if _islumprev then begin
    _lumprev.Clear;
    _islumprev := false;
  end;
  _lumprev.Init(W_Prev.Preview);
  _islumprev := true;
  try
    W_Prev.Show;
  except
    LBL_MemError.visible := true;
  end;
  W_Filtres.Init;
  try
    W_Filtres.Show;
    _currentWin := @W_Filtres;
  except
    LBL_MemError.visible := true;
  end;
  Screen.Cursor := crDefault;
  _event := false;
end;

procedure TForm1.MenuItem22Click(Sender: TObject);
var i : integer;
begin
  // Windows ID = 13
   LBL_MemError.Visible := false;
   if form3.isVisible then exit;
   if _event then exit;
   _event := true;
   _S_Reanalyse := false;
   _HideWindows;
   _SOpen := false;
   gamma:=1;
   try
     ProgressWindow.ShowWindow('Traitements en cours', 'Calcul de la courbe de Luminance');
   except
     LBL_MemError.visible := true;
   end;
   // init preview resolution windows
   tx := ResPreview[13];
   ty := ResPreview[13];

   ProgressWindow.SetProgress(0);
   Screen.Cursor := crHourGlass;
   MenuItem2.Enabled := false;
   preparePreview(W_SRC.View, W_Prev.Preview);
   // Transformation en TMemoryPix
   if _islumprev then begin
     _lumprev.Clear;
     _islumprev := false;
   end;
   _lumprev.Init(W_Prev.Preview);
   _islumprev := true;
   W_ContratSG.Init;
   try
     W_Prev.Show;
     W_ContratsG.Show;
     _currentWin := @W_ContratsG;
   except
     LBL_MemError.visible := true;
   end;
   ProgressWindow.InterCommit;
   GetCourbeLumiereGAMMA(_lumprev, Lumiere, 1.0);
   W_ContratsG.lumscale.Clear ;
   for i:=0 to 255 do
     begin
       W_ContratsG.lumscale.AddXY(i, Lumiere[i]);
     end;
   ProgressWindow.SetProgress('Courbe calculée', 100);
   ProgressWindow.HideWindow;
   Screen.Cursor := crDefault;
   _event := false;
end;

procedure TForm1.MenuItem24Click(Sender: TObject);
begin
  // Window ID = 14
   LBL_MemError.Visible := false;
   if form3.isVisible then exit;
   if _event then exit;
   _event := true;
   _S_Reanalyse := false;
   _HideWindows;

   _SOpen := false;
   ProgressWindow.SetProgress(0);
   Screen.Cursor := crHourGlass;
   MenuItem2.Enabled := false;
   tx := ResPreview[14];
   ty := ResPreview[14];


   preparePreview2(W_SRC.View, W_Prev.Preview,0,0);
   // Transformation en TMemoryPix
   if _islumprev then begin
     _lumprev.Clear;
     _islumprev := false;
   end;
   _lumprev.Init(W_Prev.Preview);
   _islumprev := true;
   try
     W_Prev.Show;
   except
     LBL_MemError.visible := true;
   end;
   W_MF.Init;
   try
     W_MF.Show;
     _currentWin := @W_MF;
   except
     LBL_MemError.visible := true;
   end;
   Screen.Cursor := crDefault;
   _event := false;
end;

procedure TForm1.MenuItem25Click(Sender: TObject);
begin
  // Window ID = 15
   LBL_MemError.Visible := false;
   if form3.isVisible then exit;
   if _event then exit;
   _event := true;
   _S_Reanalyse := false;
   _HideWindows;

   _SOpen := false;
   ProgressWindow.SetProgress(0);
   Screen.Cursor := crHourGlass;
   MenuItem2.Enabled := false;
   // Setting preview resolution
   tx := ResPreview[15];
   ty := ResPreview[15];

   preparePreview2(W_SRC.View, W_Prev.Preview,0,0);
   // Transformation en TMemoryPix
   if _islumprev then begin
     _lumprev.Clear;
     _islumprev := false;
   end;
   _lumprev.Init(W_Prev.Preview);
   _islumprev := true;
   try
     W_Prev.Show;
   except
     LBL_MemError.visible := true;
   end;
   W_Wavelets.Init;
   W_Wavelets.RB_Denose1.Checked := true;
   try
     W_Wavelets.Show;
     _currentWin := @W_Wavelets;
   except
     LBL_MemError.visible := true;
   end;
   Screen.Cursor := crDefault;
   _event := false;
end;

procedure TForm1.MenuItem26Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem27Click(Sender: TObject);
begin
  // WIndow ID = 16
  LBL_MemError.Visible := false;;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  _S_Reanalyse := false;
  _HideWindows;
  _SOpen := false;
  ProgressWindow.SetProgress(0);
  Screen.Cursor := crHourGlass;
  MenuItem2.Enabled := false;
  // Setting preview resolution
  tx := ResPreview[16];
  ty := ResPreview[16];


  preparePreview(W_SRC.View, W_Prev.Preview);
  // Transformation en TMemoryPix
  if _islumprev then begin
    _lumprev.Clear;
    _islumprev := false;
  end;
  _lumprev.Init(W_Prev.Preview);
  _islumprev := true;
  try
    W_Prev.Show;
  except
    LBL_MemError.visible := true;
  end;
  W_RGBAlign.Init;
  try
    W_RGBAlign.Show;
    _currentWin := @W_RGBAlign;
  except
    LBL_MemError.visible := true;
  end;
  Screen.Cursor := crDefault;
  _event := false;
end;

procedure TForm1.MenuItem28Click(Sender: TObject);
begin
end;

procedure TForm1.MenuItem29Click(Sender: TObject);
var ret : integer;
begin
end;

procedure TForm1.MenuItem30Click(Sender: TObject);
begin
  LBL_MemError.Visible := false;;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  _S_Reanalyse := false;
  _HideWindows;
  _SOpen := false;
  ProgressWindow.SetProgress(0);
  Screen.Cursor := crHourGlass;
  MenuItem2.Enabled := false;;
  // init preview resolution windows
  tx := ResPreview[21];
  ty := ResPreview[21];

  W_Prev.Preview.visible := false;

  preparePreview(W_SRC.View, W_Prev.Preview);
  // Transformation en TMemoryPix
  if _islumprev then begin
    _lumprev.Clear;
    _islumprev := false;
  end;
  _lumprev.Init(W_Prev.Preview);
  _islumprev := true;
  try
    W_Prev.Show;
  except
    LBL_MemError.visible := true;
  end;

  try
    W__RGBToBN.show;
  except
    LBL_MemError.visible := true;
  end;
  _currentWin := @W__RGBToBN;
  W__RGBToBN.Init;
  W_Prev.Preview.visible := true;

  Screen.Cursor := crDefault;
  _event := false;


end;

procedure TForm1.MenuItem31Click(Sender: TObject);
begin
  LBL_MemError.Visible := false;;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  _S_Reanalyse := false;
  _HideWindows;
  _SOpen := false;
  ProgressWindow.SetProgress(0);
  Screen.Cursor := crHourGlass;
  MenuItem2.Enabled := false;;
  // init preview resolution windows
  tx := ResPreview[18];
  ty := ResPreview[18];

  preparePreview(W_SRC.View, W_Prev.Preview);
  // Transformation en TMemoryPix
  if _islumprev then begin
    _lumprev.Clear;
    _islumprev := false;
  end;
  _lumprev.Init(W_Prev.Preview);
  _islumprev := true;
  try
    W_Prev.Show;
  except
    LBL_MemError.visible := true;
  end;

  W_BackgroundLum.BT_Extract.enabled := false;
  W_BackgroundLum.BT_Preview.enabled := false;
  W_BackgroundLum.BT_Apply.enabled := false;
  W_BackgroundLum.show;
  _currentWin := @W_BackgroundLum;

  // Extract background lights with default parameters value
  W_BackgroundLum.Init;
  W_BackgroundLum.BT_Extract.enabled := true;
  W_BackgroundLum.BT_Preview.enabled := true;
  W_BackgroundLum.BT_Apply.enabled := true;

  Screen.Cursor := crDefault;
  _event := false;
end;

procedure TForm1.MenuItem32Click(Sender: TObject);
begin
  // Window ID = 19
  LBL_MemError.Visible := false;;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  _S_Reanalyse := false;
  _HideWindows;
  _SOpen := false;
  ProgressWindow.SetProgress(0);
  Screen.Cursor := crHourGlass;
  MenuItem2.Enabled := false;
  // Setting preview resolution
  tx := ResPreview[19];
  ty := ResPreview[19];


  preparePreview(W_SRC.View, W_Prev.Preview);
  // Transformation en TMemoryPix
  if _islumprev then begin
    _lumprev.Clear;
    _islumprev := false;
  end;
  _lumprev.Init(W_Prev.Preview);
  _islumprev := true;
  try
    W_Prev.Show;
  except
    LBL_MemError.visible := true;
  end;
  try
    Form2.Show;
    _currentWin := @Form2;
  except
    LBL_MemError.visible := true;
  end;
  Form2.Init;
  Screen.Cursor := crDefault;
  _event := false;
end;

procedure TForm1.MenuItem33Click(Sender: TObject);
begin
  // Window ID = 15
  LBL_MemError.Visible := false;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  _S_Reanalyse := false;
  _HideWindows;

  _SOpen := false;
  ProgressWindow.SetProgress(0);
  Screen.Cursor := crHourGlass;
  MenuItem2.Enabled := false;
  // Setting preview resolution
  tx := ResPreview[15];
  ty := ResPreview[15];


  preparePreview2(W_SRC.View, W_Prev.Preview,0,0);
  // Transformation en TMemoryPix
  if _islumprev then begin
    _lumprev.Clear;
    _islumprev := false;
  end;
  _lumprev.Init(W_Prev.Preview);
  _islumprev := true;
  try
    W_Prev.Show;
  except
    LBL_MemError.visible := true;
  end;
  W_Wavelets.Init;
  W_Wavelets.RB_Denose.Checked := true;
  try
    W_Wavelets.Show;
    _currentWin := @W_Wavelets;
  except
    LBL_MemError.visible := true;
  end;
  Screen.Cursor := crDefault;
  _event := false;
end;

procedure TForm1.MenuItem34Click(Sender: TObject);
begin
  LBL_MemError.Visible := false;
  if form3.isVisible then exit;
  if _event then exit;
  _event := true;
  try
    W_Configuration.Show;
    W_Configuration.Init;
  except
    LBL_MemError.visible := true;
  end;
  _event := false;
end;

begin
  last_s := C_Init_S;
  last_c := C_Init_C;
  _ismprev := false;
end.

