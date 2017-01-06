unit SaveEnv;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  _TopOfTopWin = 50; // nombre maximum de fenêtre pour la compatibilité ascendante.
  _maxwin = 21; // A partir de la V1.1.0.a13


type
  TConfig = record
            // prefered preview resolution
            _Preview_size : array[1.._TopOfTopWin] of integer;
            // Size and windows locations
             _fenetre : Array[1.._TopOfTopWin] of record
                          x,y, _width, _height : integer;
                        end;
             _nb_win : integer;
             // RGB memory mode
             // 0 RGB
             // 1 BGR
             rgbmode : integer;
  end;

var
  // Configuration des fenêtres (tailles et positions)
  _G_Win_Conf : TConfig;
  _env_maj : boolean;

procedure saveConfig(var _config : TConfig);
procedure loadConfig(var _config : TConfig);

implementation

procedure saveConfig(var _config : TConfig);
var _id : File of TConfig;
  filename : ansistring;
begin
  filename := concat(UTF8ToAnsi(ParamStr(0)),'.cfg');
  assign (_id, filename);
  try
    rewrite(_id);
    _config._nb_win := _maxwin;
    write(_id,_config);
  except
    _config._nb_win := 0;
  end;
  try
    close (_id);
  Except
      ;
  end;
end;

procedure loadConfig(var _config : TConfig);
var _id : file of TConfig;
  filename : ansistring;
begin
  filename := concat(UTF8ToAnsi(ParamStr(0)),'.cfg');
  if fileexists(filename) then begin
    assign (_id, filename);
    try
      reset(_id);
      read(_id,_config);
    except
      _config._nb_win := 0;
    end;
    try
      close(_id);
    except
      _config._nb_win := 0;
    end;
  end else _config._nb_win := 0;
end;


end.

