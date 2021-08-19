@echo off
TITLE Video to ASCII Converter

REM ONLY COMPATABLE TO PYTHON VERSION 3

REM video2chars is not owned by me and the original creator of this program can be found here: https://github.com/ryan4yin/video2chars

REM Known Issues:
REM Character input (previously option 5) has been removed until further notice

REM ============================
REM ======= Introduction =======
REM ============================

goto welcome

:redirect
cls
echo *Python 3.x must be installed to use this program.*
echo Do you wish to be redirected to the Microsoft Store to install Python?
echo You can of course install python yourself, but I cannot guarantee the program working.
choice /m "Selecting Yes or No will exit the instant regardless, after installing, reopen this program."
if %errorlevel% neq 2 python && exit
if %errorlevel% neq 1 exit
exit /b

:update
PATH %PATH%;%UserProfile%\AppData\Local\Microsoft\WindowsApps\PythonSoftwareFoundation.Python.3.9_qbz5n2kfra8p0
PATH %PATH%;%UserProfile%\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.9_qbz5n2kfra8p0\LocalCache\local-packages\Python39\Scripts
python --version 3>NUL
if errorlevel 1 call :redirect
pip install video2chars
pip install --upgrade pip
exit /b

:welcome
echo Welcome to the CapedCrusader42's Video file to ASCII character converter.
echo The purpose of this program is to allow for the simplistic conversion of a .mp4 file to the ASCII character set.
echo I claim zero ownership of the software converting the file (video2chars).
echo My only involvement was the creation of this tool.
echo.
echo If you encounter an error at any time please feel free to submit an anonymous bug report here: 
echo https://forms.gle/hTXMjCSnfYXcVyw29
echo.
echo This program ONLY supports using the .mp4 file format.
echo All settings changed configured will NOT persist after this program is closed.
echo Python version 3.x must be installed, if python is not installed you will be redirected to the Microsoft Store.
echo.

echo *Once you proceed past this page the required software (video2chars) and its dependancies will be installed/updated.*
echo You will be notified of its completion.
echo.

echo.
set /p=Press any key if you understand the terms above . . .
echo.
echo Please wait...
echo.
call :update || echo. && echo Update failed, please contact me at https://forms.gle/hTXMjCSnfYXcVyw29 with an explanation of the error that was provided. && pause >nul && exit


REM =============================
REM ======= Program Start =======
REM =============================


:defaults
set file_path=%UserProfile%\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.8_qbz5n2kfra8p0\LocalCache\local-packages\Python38\Scripts
set file_name=output.mp4
set fps=24
REM Programs default FPS is 10 and just makes it look not that great.
set video_width=
set start=
set end=
set text=
set file_location=%userprofile%\Desktop
set file_location_des=
set video_width_des=
set start_des=
set end_des=

goto file_select


:file_select
cls
echo *The program video2chars has successfully been installed or updated*
echo.
echo Please enter the file directory below of the file you wish to convert.
echo Be mindful that the formatting is correct or the command will not work.
echo.
echo Hint1: Press and hold the shift key while right-clicking the file and select the option "Copy as path".
echo Hint2: Then right-click in the command line window to paste.
echo.
set /p file=Copy and paste the files location here: 

:view
echo.
dir %file% /A /Q || echo ERROR, this is not a valid file structure please press any key to retry. && pause >nul && goto file_select
echo.

choice /m "Is this the correct file?"
if %errorlevel% neq 2 goto begin
if %errorlevel% neq 1 goto file_select && echo The entered file path does not exist. && echo. && echo Please view the hints to make sure that the formatting is correct. Press any key to continue. && pause >nul


:begin
cls

echo Please enter the number corresponding to the selections below.
echo *For the default settings or to continue press and enter the 7 key.*
echo.
echo 1.Converted file name (Default name "output.mp4")
echo 2.Video FPS (Default 24 fps, will slightly increase render times)
echo 3.Video character width (Default 80, will dramatically increase render times)
echo 4.Video length (Default, full video)
echo 5.Converted file location (Where to put the finished product, default Desktop)
echo 6.CMD text color (No real purpose)
echo 7.Finalize
echo.
set /p input0=Response: 

if %input0% equ 1 goto file_name
if %input0% equ 2 goto fps 
if %input0% equ 3 goto width 
if %input0% equ 4 goto clipping 
if %input0% equ 5 goto file_location 
if %input0% equ 6 goto color 
if %input0% equ 7 goto confirmation 
echo Invalid selection!
echo.
echo Press any key to try again.
pause >nul
cls
goto begin


goto file_select


:file_name
cls
echo Make sure that the file name includes the .mp4 extension in the name you provide below.
echo Also use a underscore in the places of a space where needed.
echo.
set /p file_name=Please enter the new file name: 
goto begin

:fps
cls
set /p fps=Enter the fps that you wish to render the file: 
goto begin

:width
cls
set /p "video_width=Enter new video width (leave default for fastest render): " || goto width
setlocal enabledelayedexpansion 
for /f "delims=0123456789" %%a in ("!video_width!") do set "video_width="
endlocal & set "video_width=%video_width%"
if not defined video_width (
        echo "Please enter a valid input." && pause >nul && cls
        goto width
    )

goto begin

:clipping
cls
echo You can alter where the program begins and ends using the prompts below.
echo It is important to notice that the program only accepts INTERGERS and must be formatted using ONLY seconds.
echo Leave a selection blank for leaving that variable default (starting at the beginning/end of the selected file).
echo.
goto clipping1

:clipping1
set /p "start=Starting time of video in seconds: " || goto clipping2
setlocal enabledelayedexpansion 
for /f "delims=0123456789" %%a in ("!start!") do set "start="
endlocal & set "start=%start%"
if not defined start (
        echo "Please enter a valid input." && pause >nul && cls
        goto clipping1
    )
	
:clipping2
set /p "end=Ending time of video in seconds: " || goto defaults
setlocal enabledelayedexpansion 
for /f "delims=0123456789" %%a in ("!end!") do set "end="
endlocal & set "end=%end%"
if not defined end (
        echo "Please enter a valid input." && pause >nul && cls
        goto clipping2
    )


if %start% lss %end% echo. && echo The inputs have been saved and you can enter any key to continue. && pause >nul && goto begin
echo "Please make sure that the start time is less than the end time. Press any key to continue. . ." && pause >nul && goto clipping

goto begin

:file_location
cls
set /p "file_location=Enter the full location path to put the file, leave empty for default (user desktop): "
goto begin

:color 
cls
Echo Choose Your Background color from the selection below.
echo This selection has no effect on the output file and serves only as this tools color scheme.
Echo.
echo 1. Whilte/Black
echo 2. Black/Blue
echo 3. Black/Red
echo 4. Black/Yellow
echo.
set /p "cl=Enter the numbered color here: " || goto begin

if %cl% equ 1 color 70 && goto begin
if %cl% equ 2 color 01 && goto begin
if %cl% equ 3 color 04 && goto begin
if %cl% equ 4 color 06 && goto begin
echo Invalid selection!
echo.
echo Press any key to try again.
pause >nul
cls
goto color

:confirmation
cls
echo %start%|findstr /x "[0123456789]*" && set "start=%start%" || set "start=not configured"
echo %end%|findstr /x "[0123456789]*" && set "end=%end%" || set "end=not configured"
echo %video_width%|findstr /x "[0123456789]*" && set "video_width=%video_width%" || set "video_width=not configured"
REM echo %text%|findstr /x "[0123456789~!@#$%^&*()_+}|{":>?<|/\[]';.,=-]*" && set "text=%text%" || set "text=not configured"
cls
goto overview

:overview
cls
echo Overview
echo.
echo name: %file_name% 
echo fps: %fps%
echo Start time (in seconds): %start%. 
echo End time (in seconds): %end%. 
echo Characters width: %video_width%.
echo Save location: %file_location%
REM echo The custom added charactrs to use for this render are %text%.
echo.

echo Press any key to continue... && pause >nul
if exist %file_location%\%file_name% goto rename

:areusure
echo Enter Y to continue and N to start over from the beginning.
choice /m "Are you sure that you wish to convert and save the file with the above settings?"
if %errorlevel% neq 2 goto overview2
if %errorlevel% neq 1 goto defaults
goto overview2

:file_name_2
cls
echo Make sure that the file name includes the .mp4 extension in the name you provide below.
echo Also use a underscore in the places of a space where needed.
echo.
set /p file_name=Please enter the new file name: 
goto overview

:rename
cls
echo A file has been found with the same name as a different file in the destination folder.
choice /m "Would you like to change it, proceeding will overwrite the previous file."
if %errorlevel% neq 2 goto file_name_2
if %errorlevel% neq 1 goto areusure

:overview2
REM This is the descriptors section
echo %start%|findstr /x "[0123456789]*" && set "start_des=%start%" || set "start_des=not configured"
echo %end%|findstr /x "[0123456789]*" && set "end_des=%end%" || set "end_des=not configured"
echo %video_width%|findstr /x "[0123456789]*" && set "video_width_des=%video_width%" || set "video_width_des=Default (80)"
echo %file_location%|findstr /x ".*" && set "file_location_des=%file_location%" || set "file_location_des=Default (%file_location%)"

REM Used for the actual outputs
echo %start%|findstr /x "[0123456789]*" && set "start= --t_start %start%" || set "start="
echo %end%|findstr /x "[0123456789]*" && set "end= --t_end %end%" || set "end="
echo %video_width%|findstr /x "[0123456789]*" && set "video_width= --chars_width %video_width%" || set "video_width="
REM echo %text%|findstr /x "[0123456789]*" && set "text=--pixel %text%" || set "text="
cls
goto finished

:activate
cls
echo Current Render Settings:
echo.
echo name: %file_name% 
echo fps: %fps%
echo Start time (in seconds): %start_des%
echo End time (in seconds): %end_des%
echo Characters width: %video_width_des%
echo Save location: %file_location_des%
echo.
echo *Please make sure to keep this window is focused as the program will stop working until you click back and press ENTER.*
echo The program may appear to not be inactive at first. Please wait and the program will start momentarily.
echo.
cd %file_location%
video2chars%video_width% --fps %fps%%start%%end% --output %file_name% %file%
Exit /B

:finished
call :activate || echo. && echo Please Re-enter the required information as according to the directions. && echo. && echo Press any key to retry... && pause >nul && goto defaults

:end
choice /m "Installation complete! Do you want to navigate to the %file_name% destination folder?"
if %errorlevel% neq 2 start "" explorer "%file_location%" && echo. && echo Press any key to exit the program. && pause >nul

