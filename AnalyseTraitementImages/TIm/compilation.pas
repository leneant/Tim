unit Compilation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  PLT_WINDOWS = 1;
  PLT_LINUX = 2;
  PLT_MAC = 3;

  ARCH_X86 = 1;
  ARCH_X64 = 2;

  // AJout 1.1.0 a013 c4
  PLT_CANAUX_NORM= 1;
  PLT_CANAUX_INV = 2;
  PLT_CANAUX_LIN = 3;

  // PLT_EXECUTABLE = PLT_WINDOWS;
  PLT_EXECUTABLE = PLT_LINUX;
  // PLT_EXECUTABLE = PLT_MAC;
  // ARCH = ARCH_X86;
  ARCH = ARCH_X64;

  var PLT_CANAUX : integer;

implementation

end.

