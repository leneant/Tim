@echo off
SET THEFILE=Win-x86-Tim-V1.1.0.a12.exe
echo Linking %THEFILE%
D:\MesApplications\Lazarus1.2.6_x86\fpc\2.6.4\bin\i386-win32\ld.exe -b pei-i386 -m i386pe  --gc-sections  -s --subsystem windows --entry=_WinMainCRTStartup    -o Win-x86-Tim-V1.1.0.a12.exe link.res
if errorlevel 1 goto linkend
D:\MesApplications\Lazarus1.2.6_x86\fpc\2.6.4\bin\i386-win32\postw32.exe --subsystem gui --input Win-x86-Tim-V1.1.0.a12.exe --stack 16777216
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
