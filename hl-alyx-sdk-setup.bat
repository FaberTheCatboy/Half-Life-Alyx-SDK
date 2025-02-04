
@ECHO OFF
ECHO NOTE
ECHO Make sure you have enough space, about double the game size!
ECHO Please follow instructions at the end of script to extract / download additional needed files!
ECHO :::::::::::::::::::::::::::::::::::::::
pause
:: Steam directory check
:: Getting Steam path from registry
for /f "usebackq tokens=1,2,*" %%i in (`reg query "HKCU\Software\Valve\Steam" /v "SteamPath"`) do set "steampath=%%~k"
:: Replacing "/"'s with "\" in some cases
set steampath=%steampath:/=\%
:: Testing common paths
if not exist "%steampath%\steam.exe" (
	if not exist "%ProgramFiles(x86)%\steam\steam.exe" (
		if not exist "%ProgramFiles%\steam\steam.exe" (
			goto DontRun
		) else (
			set "steampath=%ProgramFiles%\steam"
		)
	) else set "steampath=%ProgramFiles(x86)%\steam"
)
IF exist "%steampath%" ( echo Found steam directory, continuing ) ELSE ( GOTO DontRun )

ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Looking for Half life alyx directory
ECHO :::::::::::::::::::::::::::::::::::::::
IF exist "%steampath%/steamapps/common/Half-Life Alyx/" ( SET "alyx_dir=%steampath%/steamapps/common/Half-Life Alyx/" ) ELSE ( SET /P alyx_dir=Couldn't find HL:A, please specify check you have Half-Life Alyx installed or specify the directory now:  )
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Alyx dir is set to %alyx_dir%
ECHO :::::::::::::::::::::::::::::::::::::::


ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Looking for steamvr tools
ECHO :::::::::::::::::::::::::::::::::::::::
IF exist "%steampath%/steamapps/common/SteamVR/" ( SET "steamvr_dir=%steampath%/steamapps/common/SteamVR" ) ELSE ( SET /P steamvr_dir=Couldn't find SteamVR tools, please check you have SteamVR installed or specify the directory now:  )
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO SteamVR dir is set to %steamvr_dir%
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Select destination folder
ECHO :::::::::::::::::::::::::::::::::::::::
set /p mod_dir= Specify the folder you want to place SDK into (warning: DO NOT PLACE IN YOUR HL ALYX DIRECTORY): 
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Final folder will be in %mod_dir%
ECHO :::::::::::::::::::::::::::::::::::::::


ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Copying SteamVR files....
ECHO :::::::::::::::::::::::::::::::::::::::
robocopy "%steamvr_dir%/tools/steamvr_environments/game/bin" "%mod_dir%/game/bin" /s /e /nfl /ndl /njh 
robocopy "%steamvr_dir%/tools/steamvr_environments/game/core" "%mod_dir%/game/core" /s /e /nfl /ndl /njh
robocopy "%steamvr_dir%/tools/steamvr_environments/content/core" "%mod_dir%/content/hlvr" /s /e /nfl /ndl /njh
start /w "" /D "%mod_dir%\/game/core" "%steamvr_dir%/tools/steamvr_environments/game/bin/win64/vpk.exe" pak02.vpk
start /w "" /D "%mod_dir%\/game/core" "%steamvr_dir%/tools/steamvr_environments/game/bin/win64/vpk.exe" pak01.vpk
robocopy "%mod_dir%\/game/core/pak02" "%mod_dir%\/game/core" /s /e /nfl /ndl /njh
robocopy "%mod_dir%\/game/core/pak01" "%mod_dir%\/game/core" /s /e /nfl /ndl /njh
del /s /q "%mod_dir%\pak02*.vpk"
rmdir /s /q "%mod_dir%\/game/core/pak02"
del /s /q "%mod_dir%\pak01*.vpk"
rmdir /s /q "%mod_dir%\/game/core/pak01"
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Done copying Steam VR files.
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Copying Half Life Alyx files...
ECHO :::::::::::::::::::::::::::::::::::::::
robocopy "%alyx_dir%/game/hlvr" "%mod_dir%/game/hlvr" /s /e /nfl /ndl /njh /XD maps /XF pak*
robocopy "%alyx_dir%/game/bin/win64" "%mod_dir%/game/bin/win64" hlvr.exe
robocopy "%alyx_dir%/game/bin/win64" "%mod_dir%/game/bin/win64" hammer.exe
robocopy "%alyx_dir%/game/core" "%mod_dir%/game/core" /s /e /nfl ndl /njh
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Done copying Half Life Alyx files.
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Copying Half Life 2 files...
ECHO :::::::::::::::::::::::::::::::::::::::
robocopy "%alyx_dir%/game/hl2" "%mod_dir%/game/hl2" /s /e /nfl /ndl /njh /XD maps /XF pak*
robocopy "%alyx_dir%/game/bin/win64" "%mod_dir%/game/bin/win64" source2mod.exe
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Done copying Half Life 2 files.
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Replacing Half-Life Alyx dll's
ECHO :::::::::::::::::::::::::::::::::::::::
robocopy "%steamvr_dir%/tools/steamvr_environments/game/steamtours/bin/win64" "%mod_dir%/game/hlvr/bin/win64" /s /e /nfl /ndl /njh
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Done replacing Half-Life Alyx dll's
ECHO :::::::::::::::::::::::::::::::::::::::

robocopy "%~dp0." "%mod_dir%" launch-hl-alyx.bat /nfl /ndl /njh
robocopy "%~dp0./resource" "%mod_dir%/game/hlvr" gameinfo.gi
robocopy "%~dp0./resource" "%mod_dir%/game/core/tools/images/splash_screen" splash_screen.png

ECHO Copied files successfully 
ECHO ::::::::::::::::NOTE:::::::::::::::::::
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO You MUST extract pak01_dir.vpk from %alyx_dir%/game/hlvr into %mod_dir%/game/hlvr/ or you will have NO Alyx assets in Hammer
ECHO You MUST download .FGD files from https://github.com/gvarados1/Half-Life-Alyx-FGD and put them into %mod_dir%/game/hlvr
ECHO Run launch-hl-alyx.bat in %mod_dir% to start it!
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO :::::::::::::::::::::::::::::::::::::::

ECHO DONE... Happy modding.
PAUSE
GOTO:EOF

:DontRun
ECHO :::::::::::::::::::::::::::::::::::::::
ECHO Make sure you have Steam installed to continue
ECHO :::::::::::::::::::::::::::::::::::::::
PAUSE 
