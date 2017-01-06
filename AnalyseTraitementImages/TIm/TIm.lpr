program TIm;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, Unit1, ProgressWindows, TSL, MemoryPix, Luminance,
  W_saturation, Global, Utils, Unit3, Unit5, Prev, W_Luminance, w_source, TempCouleurs,
  Constantes, W_AddDelColorSignal, saturationglobale, Convolution,
  W_Convolution, Diary, Marqueurs, W_ContrasteG, W_MasqueFlou, MasqueFlou,
  Wavelets, w_waves, W_RGB_Align, RVB, loupeUtil, TimException, SaveEnv,
  Compilation, FilePix, AdvancedFilters, BackgroundLum, RotationRBV,
Configuration, W_RGBToBN;

var i : integer;
{$R *.res}
begin
  Application.Title:='Tim';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);                      //  1
  Application.CreateForm(TW_Sat, W_Sat);                      //  2
  Application.CreateForm(TProgressWindow, ProgressWindow);    //  3
  Application.CreateForm(TW_Lum, W_Lum);                      //  4
  Application.CreateForm(TForm5, Form5);                      //  5
  Application.CreateForm(TW_Prev, W_Prev);                    //  6
  Application.CreateForm(TForm3, Form3);                      //  7
  Application.CreateForm(TW_SRC, W_SRC);                      //  8
  Application.CreateForm(TW_TempCouleurs, W_TempCouleurs);    //  9
  Application.CreateForm(TW_AddDelColor, W_AddDelColor);      // 10
  Application.CreateForm(TW_SatG, W_SatG);                    // 11
  Application.CreateForm(TW_Filtres, W_Filtres);              // 12
  Application.CreateForm(TW_ContratsG, W_ContratsG);          // 13
  Application.CreateForm(TW_MF, W_MF);                        // 14
  Application.CreateForm(TW_Wavelets, W_Wavelets);            // 15
  Application.CreateForm(TW_RGBAlign, W_RGBAlign);            // 16
  Application.CreateForm(TLoupe, Loupe);                      // 17
  Application.CreateForm(TW_BackgroundLum, W_BackgroundLum);  // 18
  Application.CreateForm(TForm2, Form2);                      // 19
  Application.CreateForm(TW_Configuration, W_Configuration);  // 20
  Application.CreateForm(TW__RGBToBN, W__RGBToBN);            // 21

  // Init par defaut des canaux RGB en mémoire
  PLT_CANAUX := PLT_CANAUX_NORM;

  // par defaut la resolution de la preview est la resolution moyenne
  for i := 1 to _TopOfTOpWin do begin
    ResPreview[i] := avg_tx;
    ResPreview[i] := avg_ty;
  end;

  loadConfig(_G_Win_Conf);
  _env_maj := true;
  if _G_Win_Conf._nb_win > 0 then begin
    Form1.Left := _G_Win_Conf._fenetre[1].x;
    Form1.Top := _G_Win_Conf._fenetre[1].y;
    Form1.Width := _G_Win_Conf._fenetre[1]._width;
    Form1.Height := _G_Win_Conf._Fenetre[1]._height;
    ResPreview[1] := _G_Win_Conf._Preview_size[1];
      if _G_Win_Conf.rgbmode = PLT_CANAUX_NORM then
        begin
          PLT_CANAUX := PLT_CANAUX_NORM;
        end
      else if _G_Win_Conf.rgbmode = PLT_CANAUX_INV then
        begin
            PLT_CANAUX := PLT_CANAUX_INV;
        end
      else PLT_CANAUX := PLT_CANAUX_LIN;
  end else begin
    _G_Win_Conf._fenetre[1].x := Form1.Left;
    _G_Win_Conf._fenetre[1].y := Form1.Top;
    _G_Win_Conf._fenetre[1]._width := Form1.Width;
    _G_Win_Conf._fenetre[1]._height := Form1.Height;
    _G_Win_Conf._Preview_size[1] :=  ResPreview[1] ;
  end;
  if _G_Win_Conf._nb_win > 1 then begin
    W_Sat.Left := _G_Win_Conf._fenetre[2].x;
    W_Sat.Top := _G_Win_Conf._fenetre[2].y;
    W_Sat.Width := _G_Win_Conf._fenetre[2]._width;
    W_Sat.Height := _G_Win_Conf._Fenetre[2]._height;
    ResPreview[2] := _G_Win_Conf._Preview_size[2];
  end else begin
    _G_Win_Conf._fenetre[2].x := W_Sat.Left;
    _G_Win_Conf._fenetre[2].y := W_Sat.Top;
    _G_Win_Conf._fenetre[2]._width := W_Sat.Width;
    _G_Win_Conf._fenetre[2]._height := W_Sat.Height;
    _G_Win_Conf._Preview_size[2] :=  ResPreview[2] ;
  end;
  if _G_Win_Conf._nb_win > 2 then begin
    ProgressWindow.Left := _G_Win_Conf._fenetre[3].x;
    ProgressWindow.Top := _G_Win_Conf._fenetre[3].y;
    ProgressWindow.Width := _G_Win_Conf._fenetre[3]._width;
    ProgressWindow.Height := _G_Win_Conf._Fenetre[3]._height;
    ResPreview[3] := _G_Win_Conf._Preview_size[3];
  end else begin
    _G_Win_Conf._fenetre[3].x := ProgressWindow.Left;
    _G_Win_Conf._fenetre[3].y := ProgressWindow.Top;
    _G_Win_Conf._fenetre[3]._width := ProgressWindow.Width;
    _G_Win_Conf._fenetre[3]._height := ProgressWindow.Height;
    _G_Win_Conf._Preview_size[3] :=  ResPreview[3] ;
  end;
  if _G_Win_Conf._nb_win > 3 then begin
    W_Lum.Left := _G_Win_Conf._fenetre[4].x;
    W_Lum.Top := _G_Win_Conf._fenetre[4].y;
    W_Lum.Width := _G_Win_Conf._fenetre[4]._width;
    W_Lum.Height := _G_Win_Conf._Fenetre[4]._height;
    ResPreview[4] := _G_Win_Conf._Preview_size[4];
  end else begin
    _G_Win_Conf._fenetre[4].x := W_Lum.Left;
    _G_Win_Conf._fenetre[4].y := W_Lum.Top;
    _G_Win_Conf._fenetre[4]._width := W_Lum.Width;
    _G_Win_Conf._fenetre[4]._height := W_Lum.Height;
    _G_Win_Conf._Preview_size[4] :=  ResPreview[4] ;
  end;
  if _G_Win_Conf._nb_win > 4 then begin
    Form5.Left := _G_Win_Conf._fenetre[5].x;
    Form5.Top := _G_Win_Conf._fenetre[5].y;
    Form5.Width := _G_Win_Conf._fenetre[5]._width;
    Form5.Height := _G_Win_Conf._Fenetre[5]._height;
    ResPreview[5] := _G_Win_Conf._Preview_size[5];
  end else begin
    _G_Win_Conf._fenetre[5].x := Form5.Left;
    _G_Win_Conf._fenetre[5].y := Form5.Top;
    _G_Win_Conf._fenetre[5]._width := Form5.Width;
    _G_Win_Conf._fenetre[5]._height := Form5.Height;
    _G_Win_Conf._Preview_size[5] :=  ResPreview[5] ;
  end;
  if _G_Win_Conf._nb_win > 5 then begin
    W_Prev.Left := _G_Win_Conf._fenetre[6].x;
    W_Prev.Top := _G_Win_Conf._fenetre[6].y;
    W_Prev.Width := _G_Win_Conf._fenetre[6]._width;
    W_Prev.Height := _G_Win_Conf._Fenetre[6]._height;
    ResPreview[6] := _G_Win_Conf._Preview_size[6];
  end else begin
    _G_Win_Conf._fenetre[6].x := W_Prev.Left;
    _G_Win_Conf._fenetre[6].y := W_Prev.Top;
    _G_Win_Conf._fenetre[6]._width := W_Prev.Width;
    _G_Win_Conf._fenetre[6]._height := W_Prev.Height;
    _G_Win_Conf._Preview_size[6] :=  ResPreview[6] ;
  end;
  if _G_Win_Conf._nb_win > 6 then begin
    Form3.Left := _G_Win_Conf._fenetre[7].x;
    Form3.Top := _G_Win_Conf._fenetre[7].y;
    Form3.Width := _G_Win_Conf._fenetre[7]._width;
    Form3.Height := _G_Win_Conf._Fenetre[7]._height;
    ResPreview[7] := _G_Win_Conf._Preview_size[7];
  end else begin
    _G_Win_Conf._fenetre[7].x := Form3.Left;
    _G_Win_Conf._fenetre[7].y := Form3.Top;
    _G_Win_Conf._fenetre[7]._width := Form3.Width;
    _G_Win_Conf._fenetre[7]._height := Form3.Height;
    _G_Win_Conf._Preview_size[7] :=  ResPreview[7] ;
  end;
  if _G_Win_Conf._nb_win > 7 then begin
    W_SRC.Left := _G_Win_Conf._fenetre[8].x;
    W_SRC.Top := _G_Win_Conf._fenetre[8].y;
    W_SRC.Width := _G_Win_Conf._fenetre[8]._width;
    W_SRC.Height := _G_Win_Conf._Fenetre[8]._height;
    ResPreview[8] := _G_Win_Conf._Preview_size[8];
  end else begin
    _G_Win_Conf._fenetre[8].x := W_SRC.Left;
    _G_Win_Conf._fenetre[8].y := W_SRC.Top;
    _G_Win_Conf._fenetre[8]._width := W_SRC.Width;
    _G_Win_Conf._fenetre[8]._height := W_SRC.Height;
    _G_Win_Conf._Preview_size[8] :=  ResPreview[8] ;
  end;
  if _G_Win_Conf._nb_win > 8 then begin
    W_TempCouleurs.Left := _G_Win_Conf._fenetre[9].x;
    W_TempCouleurs.Top := _G_Win_Conf._fenetre[9].y;
    W_TempCouleurs.Width := _G_Win_Conf._fenetre[9]._width;
    W_TempCouleurs.Height := _G_Win_Conf._Fenetre[9]._height;
    ResPreview[9] := _G_Win_Conf._Preview_size[9];
  end else begin
    _G_Win_Conf._fenetre[9].x := W_TempCouleurs.Left;
    _G_Win_Conf._fenetre[9].y := W_TempCouleurs.Top;
    _G_Win_Conf._fenetre[9]._width := W_TempCouleurs.Width;
    _G_Win_Conf._fenetre[9]._height := W_TempCouleurs.Height;
    _G_Win_Conf._Preview_size[9] :=  ResPreview[9] ;
  end;
  if _G_Win_Conf._nb_win > 9 then begin
    W_AddDelColor.Left := _G_Win_Conf._fenetre[10].x;
    W_AddDelColor.Top := _G_Win_Conf._fenetre[10].y;
    W_AddDelColor.Width := _G_Win_Conf._fenetre[10]._width;
    W_AddDelColor.Height := _G_Win_Conf._Fenetre[10]._height;
    ResPreview[10] := _G_Win_Conf._Preview_size[10];
  end else begin
    _G_Win_Conf._fenetre[10].x := W_AddDelColor.Left;
    _G_Win_Conf._fenetre[10].y := W_AddDelColor.Top;
    _G_Win_Conf._fenetre[10]._width := W_AddDelColor.Width;
    _G_Win_Conf._fenetre[10]._height := W_AddDelColor.Height;
    _G_Win_Conf._Preview_size[10] :=  ResPreview[10] ;
  end;
  if _G_Win_Conf._nb_win > 10 then begin
    W_SatG.Left := _G_Win_Conf._fenetre[11].x;
    W_SatG.Top := _G_Win_Conf._fenetre[11].y;
    W_SatG.Width := _G_Win_Conf._fenetre[11]._width;
    W_SatG.Height := _G_Win_Conf._Fenetre[11]._height;
    ResPreview[11] := _G_Win_Conf._Preview_size[11];
  end else begin
    _G_Win_Conf._fenetre[11].x := W_SatG.Left;
    _G_Win_Conf._fenetre[11].y := W_SatG.Top;
    _G_Win_Conf._fenetre[11]._width := W_SatG.Width;
    _G_Win_Conf._fenetre[11]._height := W_SatG.Height;
    _G_Win_Conf._Preview_size[11] :=  ResPreview[11] ;
  end;
  if _G_Win_Conf._nb_win > 11 then begin
    W_Filtres.Left := _G_Win_Conf._fenetre[12].x;
    W_Filtres.Top := _G_Win_Conf._fenetre[12].y;
    W_Filtres.Width := _G_Win_Conf._fenetre[12]._width;
    W_Filtres.Height := _G_Win_Conf._Fenetre[12]._height;
    ResPreview[12] := _G_Win_Conf._Preview_size[12];
  end else begin
    _G_Win_Conf._fenetre[12].x := W_Filtres.Left;
    _G_Win_Conf._fenetre[12].y := W_Filtres.Top;
    _G_Win_Conf._fenetre[12]._width := W_Filtres.Width;
    _G_Win_Conf._fenetre[12]._height := W_Filtres.Height;
    _G_Win_Conf._Preview_size[12] :=  ResPreview[12] ;
  end;
  if _G_Win_Conf._nb_win > 12 then begin
    W_ContratsG.Left := _G_Win_Conf._fenetre[13].x;
    W_ContratsG.Top := _G_Win_Conf._fenetre[13].y;
    W_ContratsG.Width := _G_Win_Conf._fenetre[13]._width;
    W_ContratsG.Height := _G_Win_Conf._Fenetre[13]._height;
    ResPreview[13] := _G_Win_Conf._Preview_size[13];
  end else begin
    _G_Win_Conf._fenetre[13].x := W_ContratsG.Left;
    _G_Win_Conf._fenetre[13].y := W_ContratsG.Top;
    _G_Win_Conf._fenetre[13]._width := W_ContratsG.Width;
    _G_Win_Conf._fenetre[13]._height := W_ContratsG.Height;
    _G_Win_Conf._Preview_size[13] :=  ResPreview[13] ;
  end;
  if _G_Win_Conf._nb_win > 13 then begin
    W_MF.Left := _G_Win_Conf._fenetre[14].x;
    W_MF.Top := _G_Win_Conf._fenetre[14].y;
    W_MF.Width := _G_Win_Conf._fenetre[14]._width;
    W_MF.Height := _G_Win_Conf._Fenetre[14]._height;
    ResPreview[14] := _G_Win_Conf._Preview_size[14];
  end else begin
    _G_Win_Conf._fenetre[14].x := W_MF.Left;
    _G_Win_Conf._fenetre[14].y := W_MF.Top;
    _G_Win_Conf._fenetre[14]._width := W_MF.Width;
    _G_Win_Conf._fenetre[14]._height := W_MF.Height;
    _G_Win_Conf._Preview_size[14] :=  ResPreview[14] ;
  end;
  if _G_Win_Conf._nb_win > 14 then begin
    W_Wavelets.Left := _G_Win_Conf._fenetre[15].x;
    W_Wavelets.Top := _G_Win_Conf._fenetre[15].y;
    W_Wavelets.Width := _G_Win_Conf._fenetre[15]._width;
    W_Wavelets.Height := _G_Win_Conf._Fenetre[15]._height;
    ResPreview[15] := _G_Win_Conf._Preview_size[15];
  end else begin
    _G_Win_Conf._fenetre[15].x := W_Wavelets.Left;
    _G_Win_Conf._fenetre[15].y := W_Wavelets.Top;
    _G_Win_Conf._fenetre[15]._width := W_Wavelets.Width;
    _G_Win_Conf._fenetre[15]._height := W_Wavelets.Height;
    _G_Win_Conf._Preview_size[15] :=  ResPreview[15] ;
  end;
  if _G_Win_Conf._nb_win > 15 then begin
    W_RGBAlign.Left := _G_Win_Conf._fenetre[16].x;
    W_RGBAlign.Top := _G_Win_Conf._fenetre[16].y;
    W_RGBAlign.Width := _G_Win_Conf._fenetre[16]._width;
    W_RGBAlign.Height := _G_Win_Conf._Fenetre[16]._height;
    ResPreview[16] := _G_Win_Conf._Preview_size[16];
  end else begin
    _G_Win_Conf._fenetre[16].x := W_RGBAlign.Left;
    _G_Win_Conf._fenetre[16].y := W_RGBAlign.Top;
    _G_Win_Conf._fenetre[16]._width := W_RGBAlign.Width;
    _G_Win_Conf._fenetre[16]._height := W_RGBAlign.Height;
    _G_Win_Conf._Preview_size[16] :=  ResPreview[16] ;
  end;
  if _G_Win_Conf._nb_win > 16 then begin
    Loupe.Left := _G_Win_Conf._fenetre[17].x;
    Loupe.Top := _G_Win_Conf._fenetre[17].y;
    Loupe.Width := _G_Win_Conf._fenetre[17]._width;
    Loupe.Height := _G_Win_Conf._Fenetre[17]._height;
    ResPreview[17] := _G_Win_Conf._Preview_size[17];
  end else begin
    _G_Win_Conf._fenetre[17].x := Loupe.Left;
    _G_Win_Conf._fenetre[17].y := Loupe.Top;
    _G_Win_Conf._fenetre[17]._width := Loupe.Width;
    _G_Win_Conf._fenetre[17]._height := Loupe.Height;
    _G_Win_Conf._Preview_size[17] :=  ResPreview[17] ;
  end;
  if _G_Win_Conf._nb_win > 17 then begin
    W_BackgroundLum.Left := _G_Win_Conf._fenetre[18].x;
    W_BackgroundLum.Top := _G_Win_Conf._fenetre[18].y;
    W_BackgroundLum.Width := _G_Win_Conf._fenetre[18]._width;
    W_BackgroundLum.Height := _G_Win_Conf._Fenetre[18]._height;
    ResPreview[18] := _G_Win_Conf._Preview_size[18];
  end else begin
    _G_Win_Conf._fenetre[18].x := W_BackgroundLum.Left;
    _G_Win_Conf._fenetre[18].y := W_BackgroundLum.Top;
    _G_Win_Conf._fenetre[18]._width := W_BackgroundLum.Width;
    _G_Win_Conf._fenetre[18]._height := W_BackgroundLum.Height;
    _G_Win_Conf._Preview_size[18] :=  ResPreview[18] ;
  end;
  if _G_Win_Conf._nb_win > 18 then begin
    Form2.Left := _G_Win_Conf._fenetre[19].x;
    Form2.Top := _G_Win_Conf._fenetre[19].y;
    Form2.Width := _G_Win_Conf._fenetre[19]._width;
    Form2.Height := _G_Win_Conf._Fenetre[19]._height;
    ResPreview[19] := _G_Win_Conf._Preview_size[19];
  end else begin
    _G_Win_Conf._fenetre[19].x := Form2.Left;
    _G_Win_Conf._fenetre[19].y := Form2.Top;
    _G_Win_Conf._fenetre[19]._width := Form2.Width;
    _G_Win_Conf._fenetre[19]._height := Form2.Height;
    _G_Win_Conf._Preview_size[19] :=  ResPreview[19];
  end;
  if _G_Win_Conf._nb_win > 19 then begin
    W_Configuration.Left := _G_Win_Conf._fenetre[20].x;
    W_Configuration.Top := _G_Win_Conf._fenetre[20].y;
    W_Configuration.Width := _G_Win_Conf._fenetre[20]._width;
    W_Configuration.Height := _G_Win_Conf._Fenetre[20]._height;
    ResPreview[20] := _G_Win_Conf._Preview_size[20];
  end else begin
    _G_Win_Conf._fenetre[20].x := W_Configuration.Left;
    _G_Win_Conf._fenetre[20].y := W_Configuration.Top;
    _G_Win_Conf._fenetre[20]._width := W_Configuration.Width;
    _G_Win_Conf._fenetre[20]._height := W_Configuration.Height;
    _G_Win_Conf._Preview_size[20] :=  ResPreview[20] ;
  end;
  if _G_Win_Conf._nb_win > 20 then begin
    W__RGBToBN.Left := _G_Win_Conf._fenetre[21].x;
    W__RGBToBN.Top := _G_Win_Conf._fenetre[21].y;
    W__RGBToBN.Width := _G_Win_Conf._fenetre[21]._width;
    W__RGBToBN.Height := _G_Win_Conf._Fenetre[21]._height;
    ResPreview[21] := _G_Win_Conf._Preview_size[21];
  end else begin
    _G_Win_Conf._fenetre[21].x := W__RGBToBN.Left;
    _G_Win_Conf._fenetre[21].y := W__RGBToBN.Top;
    _G_Win_Conf._fenetre[21]._width := W__RGBToBN.Width;
    _G_Win_Conf._fenetre[21]._height := W__RGBToBN.Height;
    _G_Win_Conf._Preview_size[21] :=  ResPreview[21] ;
  end;

  _env_maj := false;
  Application.Run;
end.

