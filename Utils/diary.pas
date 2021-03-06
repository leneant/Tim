unit Diary;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Constantes, lazutf8, Dialogs;
const
  C_MaxParam = 50;
Type
  TParam = record
    name : string;
    value : string;
  end;

  TCommandLineParams = record
    _nbParam : integer;
    params : array[1..C_MaxParam] of TParam;
  end;

  TCommandLine = record
    Command : string;
    Params : TCommandLineParams;
  end;

function new_command (commandName : String;
  commandParams : TCommandLineParams) : TCommandLine;
function new_command (commandName : string) : TCommandLine;

function new_param (name : String; value : string) : TParam;
function new_param (name : String; value : integer) : TParam;
function new_param (name : String; value : real) : TParam;

procedure init_param (var params : TCommandLineParams);
procedure add_param (var params : TCommandLineParams; param : TParam);

procedure writeCommandIntoFile (var fileID : TextFile; command : TCommandLine);

procedure writeCommand(fileName : ansistring; command : TCommandLine);
procedure createCommandFile(filename : ansistring);

implementation

var isSave : boolean;


function new_command (commandName : String;
  commandParams : TCommandLineParams) : TCommandLine;
var _ret : TCommandLine;
begin
  _ret.Command := commandName;
  _ret.Params := commandParams;
  new_command := _ret;
end;

function new_command (commandName : string) : TCommandLine;
var _ret : TCommandLine;
begin
  _ret.Command := commandName;
  _ret.Params._nbParam := 0;
  new_command := _ret;
end;


function new_param (name : String; value : string) : TParam;
var _ret : TParam;
begin
  _ret.name := name;
  _ret.value := value;
  new_param := _ret;
end;

function new_param (name : String; value : integer) : TParam;
var _ret : TParam;
begin
  _ret.name := name;
  str (value, _ret.value);
  new_param := _ret;
end;

function new_param (name : String; value : real) : TParam;
var _ret : TParam;
begin
  _ret.name := name;
  str (value, _ret.value);
  new_param := _ret;
end;

procedure init_param (var params : TCommandLineParams);
begin
  params._nbParam := 0;
end;

procedure add_param (var params : TCommandLineParams; param : TParam);
begin
  if params._nbParam < C_MaxParam then begin
    inc(params._nbParam, 1);
    params.params[params._nbParam] := param;
  end;
end;

procedure writeCommandIntoFile (var fileID : TextFile; command : TCommandLine);
var i : integer;
begin
  if isSave then begin
    // Ecriture du séparateur
    writeln(fileID, '-------------------------------');
    // Ecriture de la commande
    write(fileID, 'Commande : ');
    writeln(fileID, command.Command);
    // Verification de l'existance de paramètres
    if (command.Params._nbParam > 0) then begin
      // Séparateurs des paramètres
      writeln(fileID, '-- Param :');
      // Boucle sur les paramètres
      for i := 1 to command.Params._nbParam do begin
        // Nom du paramètre
        write(fileID, '--       ');
        write(fileID, command.Params.Params[i].name);
        // Valeur du paramètre
        write(fileID, ' : ');
        writeln(fileID, command.Params.Params[i].value);
      end;
    end;
    // Flush du buffer
    flush(fileID);
  end;
end;

procedure writeCommand(fileName : ansistring; command : TCommandLine);
var fileID : TextFile;
begin
  if isSave then begin
    AssignFile(fileID, UTF8ToAnsi(filename));
    Append(fileID);
    writeCommandIntoFile (fileID, command);
    Close(fileID);
  end;
end;

procedure createCommandFile(filename : ansistring);
var fileID : TextFile;
begin
  try
    AssignFile(fileID, UTF8ToAnsi(filename));
    Rewrite(fileID);
    isSave := true;
    Write(fileID, '-- Tim-Rapport ');
    Write(fileID, Version);
    Writeln(fileID,' ----------------');
    writeln(fileID,filename);
    Close(fileID);
  except
    MessageDlg ('Avertissement !', 'Ecriture du journal impossible (vérifier vos droits d''écriture sur le volume de l''image). Aucun information ne sera enregistrée.', mtWarning, [mbYes], 0);
    isSave := false;
  end;
end;


end.

