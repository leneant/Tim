unit Unit5;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, saveenv, constantes;

type

  { TForm5 }

  TForm5 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    { private declarations }
    const _code = 5;
  public
    { public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.lfm}

{ TForm5 }

procedure TForm5.Button1Click(Sender: TObject);
begin
  Form5.Close;
end;

procedure TForm5.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  self.Memo1.Lines.Clear;
  self.Memo1.Lines.Add(C_ID_Tim);
end;

procedure TForm5.Label1Click(Sender: TObject);
begin

end;

procedure TForm5.Label2Click(Sender: TObject);
begin

end;

procedure TForm5.Memo1Change(Sender: TObject);
begin

end;

end.

