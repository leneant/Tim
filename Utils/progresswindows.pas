unit ProgressWindows;

{$mode objfpc}{$H+} {$F+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, saveenv;

const _deltamin = 15;
  nb_moy = 30;
  _adaptcountdown = 3500; // L'estimation se trompe généralement d'une à 5 secondes

type

  { TProgressWindow }

  TProgressWindow = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormChangeBounds(Sender: TObject);
  private
    { private declarations }
    const
      _code = 3;
    var
      progresspos : real; // mise à jour par les SetProgress, mais pas les SetProgressInc
      _title, _info : string;
      p1, p2, t1, t2 : double;
      coefs : array[1..nb_moy] of double;
      _cidx : integer;
    procedure getLeftEstimatedTime(var _hh,_mm,_ss : word);
  public
    { public declarations }
    procedure ShowWindow(titre, message : string);
    procedure HideWindow;
    procedure SetProgress(percent : real);
    procedure SetProgressInc(percent : real);
    procedure SetMessage(message : string);
    procedure SetProgress(message : string; percent : real);
    procedure InterCommit;
  end;

var
  ProgressWindow: TProgressWindow;

implementation
{$R *.lfm}

procedure getHMS(_deltaT : double; var HH,MM,SS : word);
var MS : word;
begin
  decodetime(_deltaT,HH,MM,SS,MS);
end;

procedure TProgressWindow.FormChangeBounds(Sender: TObject);
begin
  if _env_maj then exit;
  _G_Win_Conf._fenetre[self._code].x := self.Left;
  _G_Win_Conf._fenetre[self._code].y := self.Top;
  _G_Win_Conf._fenetre[self._code]._width := self.Width;
  _G_Win_Conf._fenetre[self._code]._height := self.Height;
end;

procedure TProgressWindow.getLeftEstimatedTime(var _hh,_mm,_ss : word);
var _coef,_scoef : double;
  _lefttime : double;
  divi,i : integer;
begin
  if self.p2 = self.p1 then begin
    _hh := 0;
    _mm := 0;
    _ss := 0;
  end else begin
    divi := 1;
    _coef := (self.t2 - self.t1) / (self.p2 - self.p1);
    _scoef := 0.0;
    for i := 1 to nb_moy do begin
        if self.coefs[i] > 0 then begin
          _scoef := _scoef + self.coefs[i];
          inc(divi);
        end else break;
    end;

    _coef := (_coef + (_scoef / divi) * 5) / 6; // Pour limiter les pics
    _lefttime := (100 - self.p2) * _coef + _adaptcountdown;
    if self._cidx < nb_moy then
      inc(self._cidx)
    else self._cidx := 1;
    self.coefs[self._cidx] := _coef;
    getHMS(_lefttime,_hh,_mm,_ss);
  end;
end;

procedure TProgressWindow.ShowWindow(titre, message : string);
var i :integer;
begin
  self._title := titre;
  self._info := message;
  self.Caption := self._title;
  self.p1 := 0;
  self.p2 := 0;
  self.t1 := now;
  self.t2 := self.t1;
  self.progresspos := 0;
  for i :=1 to nb_moy do
    self.coefs[i] := 0;
  self._cidx := 0;
  self.Label1.Caption := concat(self._info, ' (0%)');
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
end;

procedure TProgressWindow.SetProgress(percent : real);
var _txtper, _hhtxt, _caption : string;
  _hh,_mm,_ss : word;
  _tt : real;
begin
  _tt := now;
    self.t2 := _tt;
    self.p2 := percent;
  if (percent <= 100.0) and (percent >= 0) then begin
    self.ProgressBar1.Position := round(percent);
    self.progresspos := percent;
    str(round(percent), _txtper);
    _caption := concat(self._info, ' (', _txtper, '%)');
    // Calcul du temps restant estimé par rapport au temps écoulé
    getLeftEstimatedTime(_hh,_mm,_ss);
    if (_hh = _mm) and (_mm = _ss) and (_ss = 0) then begin
      self.Label1.Caption := _caption;
    end else begin
        _caption := concat(_caption, ' Reste : ');
        if _hh > 0 then begin
          str(trunc(_hh), _hhtxt);
          _caption := concat(_caption, _hhtxt, 'h');
        end;
        if _mm > 0 then begin
          str(trunc(_mm), _hhtxt);
          _caption := concat(_caption, _hhtxt, 'mn');
        end;
        str(round(_ss), _hhtxt);
        _caption := concat(_caption, _hhtxt, 's.');
        self.Label1.Caption := _caption;
    end;
  end else begin
    self.ProgressBar1.Position := 100;
    self.progresspos:=100;
    self.Label1.Caption := concat(self._info, ' (100%');
  end;
    if self.p2 - self.p1 >= _deltamin then begin
      self.t1 := self.t2;
      self.p1 := self.p2;
    end;
  self.Refresh;
  Application.ProcessMessages;
end;

procedure TProgressWindow.SetMessage(message : string);
var _txtper, _hhtxt, _caption : string;
  _hh,_mm,_ss : word;
begin
  self._info := message;
  str(self.ProgressBar1.Position, _txtper);
  _caption := concat(self._info, ' (', _txtper, '%)');
  // Calcul du temps restant estimé par rapport au temps écoulé
  getLeftEstimatedTime(_hh,_mm,_ss);
  if (_hh = _mm) and (_mm = _ss) and (_ss = 0) then begin
    self.Label1.Caption := _caption;
  end else begin
      _caption := concat(_caption, ' Reste : ');
      if _hh > 0 then begin
        str(trunc(_hh), _hhtxt);
        _caption := concat(_caption, _hhtxt, 'h');
      end;
      if _mm > 0 then begin
        str(trunc(_mm), _hhtxt);
        _caption := concat(_caption, _hhtxt, 'mn');
      end;
      str(round(_ss), _hhtxt);
      _caption := concat(_caption, _hhtxt, 's.');
      self.Label1.Caption := _caption;
  end;
  self.Refresh;
  Application.ProcessMessages;
end;

procedure TProgressWindow.SetProgress(message : string; percent : real);
var _txtper, _hhtxt, _caption : string;
  _hh,_mm,_ss : word;
  _tt : real;
begin
  _tt := now;
    self.t2 := _tt;
    self.p2 := percent;
  self._info := message;
  if (percent <= 100.0) and (percent >= 0) then begin
    self.ProgressBar1.Position := round(percent);
    self.progresspos := percent;
    str(round(percent), _txtper);
    _caption := concat(self._info, ' (', _txtper, '%)');
    // Calcul du temps restant estimé par rapport au temps écoulé
    getLeftEstimatedTime(_hh,_mm,_ss);
    if (_hh = _mm) and (_mm = _ss) and (_ss = 0) then begin
      self.Label1.Caption := _caption;
    end else begin
        _caption := concat(_caption, ' Reste : ');
        if _hh > 0 then begin
          str(trunc(_hh), _hhtxt);
          _caption := concat(_caption, _hhtxt, 'h');
        end;
        if _mm > 0 then begin
          str(trunc(_mm), _hhtxt);
          _caption := concat(_caption, _hhtxt, 'mn');
        end;
        str(round(_ss), _hhtxt);
        _caption := concat(_caption, _hhtxt, 's.');
        self.Label1.Caption := _caption;
    end;
  end else begin
    self.ProgressBar1.Position := 100;
    self.progresspos := 100;
    self.Label1.Caption := concat(self._info, ' (100%)');
  end;
    if self.p2 - self.p1 >= _deltamin then begin
      self.t1 := self.t2;
      self.p1 := self.p2;
    end;
  self.Refresh;
  Application.ProcessMessages;
end;

procedure TProgressWindow.SetProgressInc(percent : real);
var newpos : real;
var _txtper, _hhtxt, _caption : string;
  _hh,_mm,_ss : word;
  _tt : real;
begin
  self.refresh;
  newpos := percent + self.progresspos;
  _tt := now;
    self.t2 := _tt;
    self.p2 := newpos;
  if (newpos < 0) or (newpos > 100) then begin
    self.ProgressBar1.Position := 100;
    self.Label1.Caption := concat(self._info, ' (100%)');
  end else begin
    self.ProgressBar1.Position := round(newpos);
    str(round(newpos), _txtper);
    _caption := concat(self._info, ' (', _txtper, '%)');
    // Calcul du temps restant estimé par rapport au temps écoulé
    getLeftEstimatedTime(_hh,_mm,_ss);
    if (_hh = _mm) and (_mm = _ss) and (_ss = 0) then begin
      self.Label1.Caption := _caption;
    end else begin
        _caption := concat(_caption, ' Reste : ');
        if _hh > 0 then begin
          str(trunc(_hh), _hhtxt);
          _caption := concat(_caption, _hhtxt, 'h');
        end;
        if _mm > 0 then begin
          str(trunc(_mm), _hhtxt);
          _caption := concat(_caption, _hhtxt, 'mn');
        end;
        str(round(_ss), _hhtxt);
        _caption := concat(_caption, _hhtxt, 's.');
        self.Label1.Caption := _caption;
    end;
  end;
    if self.p2 - self.p1 >= _deltamin then begin
      self.t1 := self.t2;
      self.p1 := self.p2;
    end;
  self.Refresh;
  Application.ProcessMessages;
end;

procedure TProgressWindow.InterCommit;
begin
  self.progresspos := self.ProgressBar1.Position;
end;

end.

