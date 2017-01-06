unit FilePix;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MemoryPix, lazutf8, utils, Constantes;

function SavePix (var pix : TMemoryPix) : integer ; // Return error code 0 if succeed
// File is saved in default file 'Temp.tim' located in Tim execution directory
// This function create the name of the default file and call the SavePix (filename : ansistring, ...) for saving file

function LoadPix (var pix : TMemoryPix) : integer ; // Return error code 0 if succed
// File is loaded from default file 'Temp.tim' located in Tim execution directory
// This function create the name of the default file and call the SavePix (filename : ansistring, ...) for saving file

function SavePix (filename : ansistring; var pix : TMemoryPix) : integer ; // Return error code 0 if succeed

function LoadPix (filename : ansistring; var pix : TMemoryPix) : integer ; // Return error code 0 if succeed

implementation
const
  TimSign = '##/TIM/##';
  SignLenght = 9;

function SavePix (var pix : TMemoryPix) : integer ; // Return error code 0 if succeed
var  filename, path : ansistring;
begin
  filename := concat(_pathFromPath(ParamStr(0)),'Temp.tim');
  SavePix := SavePix(filename, pix); // Calling method
end;

function SavePix (filename : ansistring; var pix : TMemoryPix) : integer ; // Return error code 0 if succeed
var
  FileStream : TFileStream;
  BytesToSave : Int64;
  ret : integer;
  _file : TFileStream;
  _addr : PByte;
begin
  ret := 0 ; // no error
  // create empty file for write
  _file := TFileStream.Create(UTF8ToAnsi(filename), fmCreate);
  _addr := pix.memorybuff.memory;
  with _file do
  try
    // Writing file sign
    writebuffer(TimSign, SignLenght);
    // Writing x and y size
    writebuffer(pix.pwidth, sizeof(pix.pwidth));
    writebuffer(pix.pheight, sizeof(pix.pheight));
    // Compute pix size
    BytesToSave := pix.memorysize(pix.pwidth, pix.pheight);
    writebuffer(_addr^, BytesToSave);
  Except
    ret := -1 ; // error
  end;
  try
    _file.Free;
  finally
    ;
  end;
  SavePix := ret;
end;

function LoadPix (var pix : TMemoryPix) : integer ; // Return error code 0 if succed
var  filename, path : ansistring;
begin
  filename := concat(_pathFromPath(ParamStr(0)),'Temp.tim');
  LoadPix := LoadPix(filename, pix); // Calling method
end;

function LoadPix (filename : ansistring; var pix : TMemoryPix) : integer ; // Return error code 0 if succeed
var
  FileStream : TFileStream;
  BytesToSave : Int64;
  ret, i : integer;
  _file : TFileStream;
  _addr : PByte;
  _sign : string;
  _readsign : array [1..SignLenght] of byte;
begin
  ret := 0 ; // no error
  _addr := pix.memorybuff.memory;
  // create empty file for write
  _file := TFileStream.Create(UTF8ToAnsi(filename), fmOpenRead);
  with _file do
  try
    // Reading Tim file Sign
    // Loop for initializing str lenght ...
    readbuffer(_readsign, SignLenght);
    _sign := ''; // initializing string
    for i := 1 to SignLenght do
      _sign := concat(_sign, char(_readsign[i]));
    if compareStr(_sign, TimSign) <> 0 then
      ret := -1 else
    begin
      // Reading x and y size
      readbuffer(pix.pwidth, sizeof(pix.pwidth));
      readbuffer(pix.pheight, sizeof(pix.pheight));
      // Compute pix size
      BytesToSave := pix.memorysize(pix.pwidth, pix.pheight);
      if BytesToSave <= C_MemoryPix_MaxSize then begin
        readbuffer(_addr^, BytesToSave);
        pix.isData := true;
      end
      else ret := -1;
    end;
  Except
    ret := -1 ; // error
  end;
  try
    _file.Free;
  finally
    ;
  end;
  LoadPix := ret;
end;

end.

