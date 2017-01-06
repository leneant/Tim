unit Utils;

{$mode objfpc}{$H+}{$F+}

interface

uses
  Classes, SysUtils, math, global, compilation;

function _nameFromPath(path : string) : string;

function _pathFromPath(path : string) : string;

function _realToString(x : real; nbdecimal : integer) : string;

function Approx(courbeIn : MyTCourbe; x, a, b : integer) : integer;


implementation

function _nameFromPath(path : string) : string;
var i, position, taille : integer;
  car : char;
begin
  if PLT_EXECUTABLE = PLT_WINDOWS then car := '\' else car :='/';
  position := 0;
  taille := Length(path);
  for i:= taille - 1 downto 0 do
    begin
        if path[i] = car then begin
          position := i+1;
          break;
        end
    end;
  _nameFromPath := copy(path, position, taille - position + 1);
end;

function _pathFromPath(path : string) : string;
var i, position, taille : integer;
  car : char;
begin
  if PLT_EXECUTABLE = PLT_WINDOWS then car := '\' else car :='/';
  position := 0;
  taille := Length(path);
  for i:= taille - 1 downto 0 do
    begin
        if path[i] = car then begin
          position := i;
          break;
        end
    end;
  _pathFromPath := copy(path, 1, position);
end;


function _realToString(x : real; nbdecimal : integer) : string;
var entier, dec,i : integer;
  decimal : real;
  ret, ret2 : string;
  neg : boolean;
begin
  if x < 0 then begin
    x := -x;
    neg := true;
  end else neg := false;
  entier := trunc(x);
  decimal := x - entier;
  dec := round(decimal * power(10, nbdecimal));
  str(entier, ret);
  str(dec, ret2);
  for i := length(ret2) to nbdecimal - 1 do
    ret2 := concat('0',ret2);
  ret := concat(ret, '.');
  ret := concat(ret, ret2);
  if neg then ret := concat('-', ret);
  _realToString := ret;

end;

function Approx(courbeIn : MyTCourbe; x, a, b : integer) : integer;
var
  i, j : integer;
  r, d ,diviseur : real;
begin
    j := round(x * a / b);
    r := 0;
    d := 0;
    for i:=j to j + b - a do begin
      diviseur := 0.2 * abs(i-x)+1;
      r := r + (courbeIn[i] / diviseur);
      d := d + (1 / diviseur);
    end;
    Approx := round (r/d);
end;


end.

