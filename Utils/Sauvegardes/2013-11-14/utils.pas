unit Utils;

{$mode objfpc}{$H+}{$F+}

interface

uses
  Classes, SysUtils;

function _nameFromPath(path : string) : string;

implementation

function _nameFromPath(path : string) : string;
var i, position, taille : integer;
begin
  position := 0;
  taille := Length(path);
  for i:= taille - 1 downto 0 do
    begin
      if path[i] = '\' then begin // Windows
      {if path[i] ='/'then begin // Linux}
        position := i+1;
        break;
      end;
    end;
  _nameFromPath := copy(path, position, taille - position + 1);
end;

end.

