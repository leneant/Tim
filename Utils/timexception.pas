unit TimException;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  E_AllocatedFault = class(Exception);   // Memory allocation failed
  E_PictureSizeFault = class(Exception); // Picture size not the same but must do
  E_LuminanceFault = class(Exception);   // Red luminance + Green luminance + Blue luminance <> 100%

implementation

end.

