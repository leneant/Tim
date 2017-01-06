unit ProgressWindows;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls;

type

  { TProgressWindow }

  TProgressWindow = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
  private
    progresspos : real; // mise à jour par les SetProgress, mais pas les SetProgressInc
    { private declarations }
  public
    { public declarations }
    procedure ShowWindow(titre, message : string);
    procedure HideWindow;
    procedure SetProgress(percent : real);
    procedure SetProgressInc(percent : real);
    procedure SetMessage(message : string);
    procedure SetProgress(message : string; percent : real);
  end;

var
  ProgressWindow: TProgressWindow;

implementation

{$R *.lfm}

procedure TProgressWindow.ShowWindow(titre, message : string);
begin
  self.Caption := titre;
  self.Label1.Caption := message;
  self.ProgressBar1.Position := 0;
  self.progresspos := 0;
  self.Show;
  self.Refresh;
  Application.ProcessMessages;
end;

procedure TProgressWindow.HideWindow;
begin
  self.Refresh;
  self.Hide;
  self.Refresh;
end;

procedure TProgressWindow.SetProgress(percent : real);
begin
  if (percent <= 100.0) and (percent >= 0) then begin
    self.ProgressBar1.Position := round(percent);
    self.progresspos := percent;
  end else begin
    self.ProgressBar1.Position := 100;
    self.progresspos:=100;;
  end;
  self.Refresh;
  Application.ProcessMessages;
end;

procedure TProgressWindow.SetMessage(message : string);
begin
  self.Label1.Caption := message;
  self.Refresh;
  Application.ProcessMessages;
end;

procedure TProgressWindow.SetProgress(message : string; percent : real);
begin
  if (percent <= 100.0) and (percent >= 0) then begin
    self.ProgressBar1.Position := round(percent);
    self.progresspos := percent;
  end else begin
    self.ProgressBar1.Position := 100;
    self.progresspos := 100;
  end;
  self.Label1.Caption := message;
  self.Refresh;
  Application.ProcessMessages;
end;

procedure TProgressWindow.SetProgressInc(percent : real);
var newpos : real;
begin
  self.refresh;
  newpos := percent * (100 - self.progresspos) / 100 + self.progresspos;
  if (percent < 0) or (newpos > 100) then begin
    self.ProgressBar1.Position := 100;
  end else self.ProgressBar1.Position := round(newpos);
  self.Refresh;
  Application.ProcessMessages;
end;

end.

