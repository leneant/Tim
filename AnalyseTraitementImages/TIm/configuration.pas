unit Configuration;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Global, saveenv, constantes, compilation;

type

  { TW_Configuration }

  TW_Configuration = class(TForm)
    LINUX: TRadioButton;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label21: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel15: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    RB_13_4: TRadioButton;
    RB_13_5: TRadioButton;
    RB_13_6: TRadioButton;
    RB_13_1: TRadioButton;
    RB_13_2: TRadioButton;
    RB_13_3: TRadioButton;
    RB_12_4: TRadioButton;
    RB_12_5: TRadioButton;
    RB_12_6: TRadioButton;
    RB_12_1: TRadioButton;
    RB_12_2: TRadioButton;
    RB_12_3: TRadioButton;
    RB_1_1: TRadioButton;
    RB_2_4: TRadioButton;
    RB_2_5: TRadioButton;
    RB_2_6: TRadioButton;
    RB_3_1: TRadioButton;
    RB_3_2: TRadioButton;
    RB_3_3: TRadioButton;
    RB_3_4: TRadioButton;
    RB_3_5: TRadioButton;
    RB_3_6: TRadioButton;
    RB_4_1: TRadioButton;
    RB_1_2: TRadioButton;
    RB_4_2: TRadioButton;
    RB_4_3: TRadioButton;
    RB_4_4: TRadioButton;
    RB_4_5: TRadioButton;
    RB_4_6: TRadioButton;
    RB_5_1: TRadioButton;
    RB_5_2: TRadioButton;
    RB_5_3: TRadioButton;
    RB_5_4: TRadioButton;
    RB_5_5: TRadioButton;
    RB_1_3: TRadioButton;
    RB_5_6: TRadioButton;
    RB_6_1: TRadioButton;
    RB_6_2: TRadioButton;
    RB_6_3: TRadioButton;
    RB_6_4: TRadioButton;
    RB_6_5: TRadioButton;
    RB_6_6: TRadioButton;
    RB_7_1: TRadioButton;
    RB_7_2: TRadioButton;
    RB_7_3: TRadioButton;
    RB_1_4: TRadioButton;
    RB_7_4: TRadioButton;
    RB_7_5: TRadioButton;
    RB_7_6: TRadioButton;
    RB_8_1: TRadioButton;
    RB_8_2: TRadioButton;
    RB_8_3: TRadioButton;
    RB_8_4: TRadioButton;
    RB_8_5: TRadioButton;
    RB_8_6: TRadioButton;
    RB_9_1: TRadioButton;
    RB_1_5: TRadioButton;
    RB_9_2: TRadioButton;
    RB_9_3: TRadioButton;
    RB_9_4: TRadioButton;
    RB_9_5: TRadioButton;
    RB_9_6: TRadioButton;
    RB_10_1: TRadioButton;
    RB_10_2: TRadioButton;
    RB_10_3: TRadioButton;
    RB_10_4: TRadioButton;
    RB_10_5: TRadioButton;
    RB_1_6: TRadioButton;
    RB_10_6: TRadioButton;
    RB_11_1: TRadioButton;
    RB_11_2: TRadioButton;
    RB_11_3: TRadioButton;
    RB_11_4: TRadioButton;
    RB_11_5: TRadioButton;
    RB_11_6: TRadioButton;
    RB_2_1: TRadioButton;
    RB_2_2: TRadioButton;
    RB_2_3: TRadioButton;
    RGB: TRadioButton;
    BGR: TRadioButton;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    procedure BGRChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure LINUXChange(Sender: TObject);
    procedure Panel15Click(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
    procedure RB_10_1Change(Sender: TObject);
    procedure RB_10_2Change(Sender: TObject);
    procedure RB_10_3Change(Sender: TObject);
    procedure RB_10_4Change(Sender: TObject);
    procedure RB_10_5Change(Sender: TObject);
    procedure RB_10_6Change(Sender: TObject);
    procedure RB_11_1Change(Sender: TObject);
    procedure RB_11_2Change(Sender: TObject);
    procedure RB_11_3Change(Sender: TObject);
    procedure RB_11_4Change(Sender: TObject);
    procedure RB_11_5Change(Sender: TObject);
    procedure RB_11_6Change(Sender: TObject);
    procedure RB_12_1Change(Sender: TObject);
    procedure RB_12_2Change(Sender: TObject);
    procedure RB_12_3Change(Sender: TObject);
    procedure RB_12_4Change(Sender: TObject);
    procedure RB_12_5Change(Sender: TObject);
    procedure RB_12_6Change(Sender: TObject);
    procedure RB_13_1Change(Sender: TObject);
    procedure RB_13_2Change(Sender: TObject);
    procedure RB_13_3Change(Sender: TObject);
    procedure RB_13_4Change(Sender: TObject);
    procedure RB_13_5Change(Sender: TObject);
    procedure RB_13_6Change(Sender: TObject);
    procedure RB_1_1Change(Sender: TObject);
    procedure RB_1_2Change(Sender: TObject);
    procedure RB_1_3Change(Sender: TObject);
    procedure RB_1_4Change(Sender: TObject);
    procedure RB_1_5Change(Sender: TObject);
    procedure RB_1_6Change(Sender: TObject);
    procedure RB_2_1Change(Sender: TObject);
    procedure RB_2_2Change(Sender: TObject);
    procedure RB_2_3Change(Sender: TObject);
    procedure RB_2_4Change(Sender: TObject);
    procedure RB_2_6Change(Sender: TObject);
    procedure RB_3_1Change(Sender: TObject);
    procedure RB_3_2Change(Sender: TObject);
    procedure RB_3_3Change(Sender: TObject);
    procedure RB_3_4Change(Sender: TObject);
    procedure RB_3_5Change(Sender: TObject);
    procedure RB_3_6Change(Sender: TObject);
    procedure RB_4_1Change(Sender: TObject);
    procedure RB_4_2Change(Sender: TObject);
    procedure RB_4_3Change(Sender: TObject);
    procedure RB_4_4Change(Sender: TObject);
    procedure RB_4_5Change(Sender: TObject);
    procedure RB_4_6Change(Sender: TObject);
    procedure RB_5_1Change(Sender: TObject);
    procedure RB_5_2Change(Sender: TObject);
    procedure RB_5_3Change(Sender: TObject);
    procedure RB_5_4Change(Sender: TObject);
    procedure RB_5_5Change(Sender: TObject);
    procedure RB_5_6Change(Sender: TObject);
    procedure RB_6_1Change(Sender: TObject);
    procedure RB_6_2Change(Sender: TObject);
    procedure RB_6_3Change(Sender: TObject);
    procedure RB_6_4Change(Sender: TObject);
    procedure RB_6_5Change(Sender: TObject);
    procedure RB_6_6Change(Sender: TObject);
    procedure RB_7_1Change(Sender: TObject);
    procedure RB_7_2Change(Sender: TObject);
    procedure RB_7_3Change(Sender: TObject);
    procedure RB_7_4Change(Sender: TObject);
    procedure RB_7_5Change(Sender: TObject);
    procedure RB_7_6Change(Sender: TObject);
    procedure RB_8_1Change(Sender: TObject);
    procedure RB_8_2Change(Sender: TObject);
    procedure RB_8_3Change(Sender: TObject);
    procedure RB_8_4Change(Sender: TObject);
    procedure RB_8_5Change(Sender: TObject);
    procedure RB_8_6Change(Sender: TObject);
    procedure RB_9_1Change(Sender: TObject);
    procedure RB_9_2Change(Sender: TObject);
    procedure RB_9_3Change(Sender: TObject);
    procedure RB_9_4Change(Sender: TObject);
    procedure RB_9_5Change(Sender: TObject);
    procedure RB_2_5Change(Sender: TObject);
    procedure RB_9_6Change(Sender: TObject);
    procedure RGBChange(Sender: TObject);
  private
    { private declarations }
    const _code = 20;
  public
    { public declarations }
    procedure Init;
  end;

var
  W_Configuration: TW_Configuration;

implementation

{$R *.lfm}

{ TW_Configuration }

var
  _isbusy : boolean;
  ptx, pty : integer;
  LocalResSetting : array[1.._TopOfTopWin] of integer;
  LocalRGB : integer;

  // ID fenetre
  // Tim ID = 1
  // Sat teinte = 2
  // Progress = 3
  // Luminance = 4
  // Form 5 (A propos) = 5
  // Preview = 6
  // Calculé = 7
  // Source = 8
  // Temps Couleur = 9
  // Add Del couleur = 10
  // Sat G = 11
  // Filtre Conv = 12
  // Contraste G = 13
  // Masque flou = 14
  // Wavelets = 15
  // RGB Align = 16
  // Loupe = 17
  // Background lum = 18
  // form2 (rotation RVB) = 19
  // Configuration = 20

  // Lines
  //  1 : Luminance
  //  2 : Contraste global
  //  3 : Sat teinte
  //  4 : Sat G
  //  5 : Temp couleurs
  //  6 : Add/Del couleur
  //  7 : Filtre conv
  //  8 : Masque flou
  //  9 : Wavelets
  // 12 : Luminère du fond
  // 10 : Alignement RVB
  // 11 : Rotation RVB
  // 13 : Conversion RGB -> N&B


procedure TW_Configuration.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TW_Configuration.FormCreate(Sender: TObject);
begin

end;

procedure TW_Configuration.GroupBox1Click(Sender: TObject);
begin

end;

procedure TW_Configuration.LINUXChange(Sender: TObject);
begin
  if _isBusy then exit;
  LocalRGB := PLT_CANAUX_LIN ;
end;

procedure TW_Configuration.Panel15Click(Sender: TObject);
begin

end;

procedure TW_Configuration.Panel7Click(Sender: TObject);
begin

end;

procedure TW_Configuration.RB_10_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[16] := min_tx;
end;

procedure TW_Configuration.RB_10_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[16] := avg_tx;
end;

procedure TW_Configuration.RB_10_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[16] := avg1_tx;
end;

procedure TW_Configuration.RB_10_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[16] := avg2_tx;
end;

procedure TW_Configuration.RB_10_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[16] := avg3_tx;
end;

procedure TW_Configuration.RB_10_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[16] := max_tx;
end;

procedure TW_Configuration.RB_11_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[19] := min_tx;
end;

procedure TW_Configuration.RB_11_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[19] := avg_tx;
end;

procedure TW_Configuration.RB_11_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[19] := avg1_tx;
end;

procedure TW_Configuration.RB_11_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[19] := avg2_tx;
end;

procedure TW_Configuration.RB_11_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[19] := avg3_tx;
end;

procedure TW_Configuration.RB_11_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[19] := max_tx;
end;

procedure TW_Configuration.RB_1_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[4] := min_tx;
end;

procedure TW_Configuration.RB_1_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[4] := avg_tx;
end;

procedure TW_Configuration.RB_1_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[4] := avg1_tx;
end;

procedure TW_Configuration.RB_1_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[4] := avg2_tx;
end;

procedure TW_Configuration.RB_1_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[4] := avg3_tx;
end;

procedure TW_Configuration.RB_1_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[4] := max_tx;
end;

procedure TW_Configuration.RB_2_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[13] := min_tx;
end;

procedure TW_Configuration.RB_2_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[13] := avg_tx;
end;

procedure TW_Configuration.RB_2_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[13] := avg1_tx;
end;

procedure TW_Configuration.RB_2_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[13] := avg2_tx;
end;

procedure TW_Configuration.RB_2_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[13] := max_tx;
end;

procedure TW_Configuration.RB_2_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[13] := avg3_tx;
end;

procedure TW_Configuration.RB_3_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[2] := min_tx;
end;

procedure TW_Configuration.RB_3_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[2] := avg_tx;
end;

procedure TW_Configuration.RB_3_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[2] := avg1_tx;
end;

procedure TW_Configuration.RB_3_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[2] := avg2_tx;
end;

procedure TW_Configuration.RB_3_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[2] := avg3_tx;
end;

procedure TW_Configuration.RB_3_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[2] := max_tx;
end;

procedure TW_Configuration.RB_4_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[11] := min_tx;
end;

procedure TW_Configuration.RB_4_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[11] := avg_tx;
end;

procedure TW_Configuration.RB_4_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[11] := avg1_tx;
end;

procedure TW_Configuration.RB_4_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[11] := avg2_tx;
end;

procedure TW_Configuration.RB_4_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[11] := avg3_tx;
end;

procedure TW_Configuration.RB_4_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[11] := max_tx;
end;

procedure TW_Configuration.RB_5_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[9] := min_tx;
end;

procedure TW_Configuration.RB_5_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[9] := avg_tx;
end;

procedure TW_Configuration.RB_5_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[9] := avg1_tx;
end;

procedure TW_Configuration.RB_5_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[9] := avg2_tx;
end;

procedure TW_Configuration.RB_5_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[9] := avg3_tx;
end;

procedure TW_Configuration.RB_5_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[9] := max_tx;
end;

procedure TW_Configuration.RB_6_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[10] := min_tx;
end;

procedure TW_Configuration.RB_6_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[10] := avg_tx;
end;

procedure TW_Configuration.RB_6_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[10] := avg1_tx;
end;

procedure TW_Configuration.RB_6_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[10] := avg2_tx;
end;

procedure TW_Configuration.RB_6_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[10] := avg3_tx;
end;

procedure TW_Configuration.RB_6_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[10] := max_tx;
end;

procedure TW_Configuration.RB_7_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[12] := min_tx;
end;

procedure TW_Configuration.RB_7_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[12] := avg_tx;
end;

procedure TW_Configuration.RB_7_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[12] := avg1_tx;
end;

procedure TW_Configuration.RB_7_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[12] := avg2_tx;
end;

procedure TW_Configuration.RB_7_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[12] := avg3_tx;
end;

procedure TW_Configuration.RB_7_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[12] := max_tx;
end;

procedure TW_Configuration.RB_8_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[14] := min_tx;
end;

procedure TW_Configuration.RB_8_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[14] := avg_tx;
end;

procedure TW_Configuration.RB_8_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[14] := avg1_tx;
end;

procedure TW_Configuration.RB_8_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[14] := avg2_tx;
end;

procedure TW_Configuration.RB_8_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[14] := avg3_tx;
end;

procedure TW_Configuration.RB_8_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[14] := max_tx;
end;

procedure TW_Configuration.RB_9_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[15] := min_tx;
end;

procedure TW_Configuration.RB_9_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[15] := avg_tx;
end;

procedure TW_Configuration.RB_9_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[15] := avg1_tx;
end;

procedure TW_Configuration.RB_9_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[15] := avg2_tx;
end;

procedure TW_Configuration.RB_9_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[15] := avg3_tx;
end;

procedure TW_Configuration.RB_9_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[15] := max_tx;
end;

procedure TW_Configuration.RGBChange(Sender: TObject);
begin
  if _isBusy then exit;
  LocalRGB := PLT_CANAUX_NORM ;
end;

procedure TW_Configuration.Button1Click(Sender: TObject);
begin
  ResPreview := LocalResSetting;
  _G_Win_Conf._Preview_size := ResPreview;
  _G_Win_Conf.rgbmode := LocalRGB;
  PLT_CANAUX := LocalRGB;
  W_Configuration.Hide;
end;

procedure TW_Configuration.BGRChange(Sender: TObject);
begin
  if _isBusy then exit;
  LocalRGB := PLT_CANAUX_INV ;
end;

procedure TW_Configuration.RB_12_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[18] := min_tx;
end;

procedure TW_Configuration.RB_12_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[18] := avg_tx;
end;

procedure TW_Configuration.RB_12_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[18] := avg1_tx;
end;

procedure TW_Configuration.RB_12_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[18] := avg2_tx;
end;

procedure TW_Configuration.RB_12_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[18] := avg3_tx;
end;

procedure TW_Configuration.RB_12_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[18] := max_tx;
end;

procedure TW_Configuration.RB_13_1Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[21] := min_tx;
end;

procedure TW_Configuration.RB_13_2Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[21] := avg_tx;
end;

procedure TW_Configuration.RB_13_3Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[21] := avg1_tx;
end;

procedure TW_Configuration.RB_13_4Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[21] := avg2_tx;
end;

procedure TW_Configuration.RB_13_5Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[21] := avg3_tx;
end;

procedure TW_Configuration.RB_13_6Change(Sender: TObject);
begin
  if _isBusy then exit;
  LocalResSetting[21] := max_tx;
end;


procedure TW_Configuration.Init;
begin
  if _isBusy then exit;
  _isBusy := true;
  // 1- Luminance
  if ResPreview[4] = min_tx then
     RB_1_1.Checked := true
  else if ResPreview[4] = avg_tx then
     RB_1_2.Checked := true
  else if ResPreview[4] = avg1_tx then
     RB_1_3.Checked := true
  else if ResPreview[4] = avg2_tx then
     RB_1_4.Checked := true
  else if ResPreview[4] = avg3_tx then
     RB_1_5.Checked := true
  else if ResPreview[4] = max_tx then
     RB_1_6.Checked := true
  else RB_1_2.Checked := true;
  LocalResSetting[4] := ResPreview[4];

  // 2- Contrate globale
  if ResPreview[13] = min_tx then
     RB_2_1.Checked := true
  else if ResPreview[13] = avg_tx then
     RB_2_2.Checked := true
  else if ResPreview[13] = avg1_tx then
     RB_2_3.Checked := true
  else if ResPreview[13] = avg2_tx then
     RB_2_4.Checked := true
  else if ResPreview[13] = avg3_tx then
     RB_2_5.Checked := true
  else if ResPreview[13] = max_tx then
     RB_2_6.Checked := true
  else RB_2_2.Checked := true;
  LocalResSetting[13] := ResPreview[13];

  // 3- Sat teinte
  if ResPreview[2] = min_tx then
     RB_3_1.Checked := true
  else if ResPreview[2] = avg_tx then
     RB_3_2.Checked := true
  else if ResPreview[2] = avg1_tx then
     RB_3_3.Checked := true
  else if ResPreview[2] = avg2_tx then
     RB_3_4.Checked := true
  else if ResPreview[2] = avg3_tx then
     RB_3_5.Checked := true
  else if ResPreview[2] = max_tx then
     RB_3_6.Checked := true
  else RB_3_2.Checked := true;
  LocalResSetting[2] := ResPreview[2];

  // 4- Sat G
  if ResPreview[11] = min_tx then
     RB_4_1.Checked := true
  else if ResPreview[11] = avg_tx then
     RB_4_2.Checked := true
  else if ResPreview[11] = avg1_tx then
     RB_4_3.Checked := true
  else if ResPreview[11] = avg2_tx then
     RB_4_4.Checked := true
  else if ResPreview[11] = avg3_tx then
     RB_4_5.Checked := true
  else if ResPreview[11] = max_tx then
     RB_4_6.Checked := true
  else RB_4_2.Checked := true;
  LocalResSetting[11] := ResPreview[11];

  // 5- Temp couleur
  if ResPreview[9] = min_tx then
     RB_5_1.Checked := true
  else if ResPreview[9] = avg_tx then
     RB_5_2.Checked := true
  else if ResPreview[9] = avg1_tx then
     RB_5_3.Checked := true
  else if ResPreview[9] = avg2_tx then
     RB_5_4.Checked := true
  else if ResPreview[9] = avg3_tx then
     RB_5_5.Checked := true
  else if ResPreview[9] = max_tx then
     RB_5_6.Checked := true
  else RB_5_2.Checked := true;
  LocalResSetting[9] := ResPreview[9];

  // 6- ADD/Del Signal couleur
  if ResPreview[10] = min_tx then
     RB_6_1.Checked := true
  else if ResPreview[10] = avg_tx then
     RB_6_2.Checked := true
  else if ResPreview[10] = avg1_tx then
     RB_6_3.Checked := true
  else if ResPreview[10] = avg2_tx then
     RB_6_4.Checked := true
  else if ResPreview[10] = avg3_tx then
     RB_6_5.Checked := true
  else if ResPreview[10] = max_tx then
     RB_6_6.Checked := true
  else RB_6_2.Checked := true;
  LocalResSetting[10] := ResPreview[10];

  // 7- Filtre convolution
  if ResPreview[12] = min_tx then
     RB_7_1.Checked := true
  else if ResPreview[12] = avg_tx then
     RB_7_2.Checked := true
  else if ResPreview[12] = avg1_tx then
     RB_7_3.Checked := true
  else if ResPreview[12] = avg2_tx then
     RB_7_4.Checked := true
  else if ResPreview[12] = avg3_tx then
     RB_7_5.Checked := true
  else if ResPreview[12] = max_tx then
     RB_7_6.Checked := true
  else RB_7_2.Checked := true;
  LocalResSetting[12] := ResPreview[12];

  // 8- Masque flou
  if ResPreview[14] = min_tx then
     RB_8_1.Checked := true
  else if ResPreview[14] = avg_tx then
     RB_8_2.Checked := true
  else if ResPreview[14] = avg1_tx then
     RB_8_3.Checked := true
  else if ResPreview[14] = avg2_tx then
     RB_8_4.Checked := true
  else if ResPreview[14] = avg3_tx then
     RB_8_5.Checked := true
  else if ResPreview[14] = max_tx then
     RB_8_6.Checked := true
  else RB_8_2.Checked := true;
  LocalResSetting[14] := ResPreview[14];

  // 9- Wavelets
  if ResPreview[15] = min_tx then
     RB_9_1.Checked := true
  else if ResPreview[15] = avg_tx then
     RB_9_2.Checked := true
  else if ResPreview[15] = avg1_tx then
     RB_9_3.Checked := true
  else if ResPreview[15] = avg2_tx then
     RB_9_4.Checked := true
  else if ResPreview[15] = avg3_tx then
     RB_9_5.Checked := true
  else if ResPreview[15] = max_tx then
     RB_9_6.Checked := true
  else RB_9_2.Checked := true;
  LocalResSetting[15] := ResPreview[15];

  // 10- Alignement RVB
  if ResPreview[16] = min_tx then
     RB_10_1.Checked := true
  else if ResPreview[16] = avg_tx then
     RB_10_2.Checked := true
  else if ResPreview[16] = avg1_tx then
     RB_10_3.Checked := true
  else if ResPreview[16] = avg2_tx then
     RB_10_4.Checked := true
  else if ResPreview[16] = avg3_tx then
     RB_10_5.Checked := true
  else if ResPreview[16] = max_tx then
     RB_10_6.Checked := true
  else RB_10_2.Checked := true;
  LocalResSetting[16] := ResPreview[16];

  // 11- Rotation RVB
  if ResPreview[19] = min_tx then
     RB_11_1.Checked := true
  else if ResPreview[19] = avg_tx then
     RB_11_2.Checked := true
  else if ResPreview[19] = avg1_tx then
     RB_11_3.Checked := true
  else if ResPreview[19] = avg2_tx then
     RB_11_4.Checked := true
  else if ResPreview[19] = avg3_tx then
     RB_11_5.Checked := true
  else if ResPreview[19] = max_tx then
     RB_11_6.Checked := true
  else RB_11_2.Checked := true;
  LocalResSetting[19] := ResPreview[19];

  // 12- Luminance du fond
  if ResPreview[18] = min_tx then
     RB_12_1.Checked := true
  else if ResPreview[18] = avg_tx then
     RB_12_2.Checked := true
  else if ResPreview[18] = avg1_tx then
     RB_12_3.Checked := true
  else if ResPreview[18] = avg2_tx then
     RB_12_4.Checked := true
  else if ResPreview[18] = avg3_tx then
     RB_12_5.Checked := true
  else if ResPreview[18] = max_tx then
     RB_12_6.Checked := true
  else RB_12_2.Checked := true;
  LocalResSetting[18] := ResPreview[18];

  // 13- Conversion RVB -> N&B
  if ResPreview[21] = min_tx then
     RB_13_1.Checked := true
  else if ResPreview[21] = avg_tx then
     RB_13_2.Checked := true
  else if ResPreview[21] = avg1_tx then
     RB_13_3.Checked := true
  else if ResPreview[21] = avg2_tx then
     RB_13_4.Checked := true
  else if ResPreview[21] = avg3_tx then
     RB_13_5.Checked := true
  else if ResPreview[21] = max_tx then
     RB_13_6.Checked := true
  else RB_13_2.Checked := true;
  LocalResSetting[21] := ResPreview[21];

  // 14 - Canaux couleurs
  LocalRGB := PLT_CANAUX;
  if PLT_CANAUX = PLT_CANAUX_NORM then
     RGB.checked := true
  else if PLT_CANAUX = PLT_CANAUX_INV then BGR.checked := true
  else LINUX.checked := true;

  _isBusy := false;
end;

begin
  _isBusy := false;
end.

