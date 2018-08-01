@echo off
setlocal enabledelayedexpansion

rem Determine script path
set mydir=%~dp0
set mydir=%mydir:~0,-1%

rem Defaults
set defaultprogfiles=%ProgramFiles(x86)%\Janus Systems
set defaultversion=4.0.47

set progfiles=
set version=

rem Verify command line, first parameter is to check non interactive execution
if /i "%1" == "-NonInteractive" goto silent
goto user

rem Non interactive execution
:silent
goto defaults

rem User input
:user
set /p progfiles=Installation directory for Janus Systems, leave blank for default (%defaultprogfiles%): 
set /p version=Package version, leave blank for default (%defaultversion%): 
goto defaults

rem Set default values when non are provided
:defaults
if "%progfiles%" == "" (
  set "progfiles=%defaultprogfiles%"
)

if "%version%" == "" (
  set "version=%defaultversion%"
)

echo.
echo Using program files directory %progfiles%
echo Using version %version%
echo.

rem Execute nuget packaging
:pack

set "nuspecpath=%mydir%\.nuspec\Janus"
set "libpath=%progfiles%\Controls for Microsoft .NET\Windows Forms Controls v4\Bin\v%version%"

for %%f in ("%nuspecpath%\*.nuspec") do (
  set "nuspec=%%f"
  nuget pack "!nuspec!" -Version "%version%" -OutputDirectory "%mydir%\bin" -BasePath "%libpath%"
)

rem End of file
:eof