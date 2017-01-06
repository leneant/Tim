unit Marqueurs;


{$mode objfpc}{$H+}

interface

var cramee, bouchee, cramR, bouchR, cramG, bouchG, cramB, bouchB : boolean;
    // Tons sur lesquels s'appliquent les traitements
  _ATonsClairs, _ATonsMoyens, _ATonsSombres : boolean;


implementation

begin
  cramee := false;
  bouchee := false;
  cramR := false;
  bouchR := false;
  cramG := false;
  bouchG := false;
  cramB := false;
  bouchB := false;
  _ATonsClairs := true;
  _ATonsMoyens := true;
  _ATonsSombres := true;
end.

