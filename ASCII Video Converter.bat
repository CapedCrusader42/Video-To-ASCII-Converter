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
echo *Python 3 or greater must be installed to use this program.*
echo Do you want to be redirected to the Microsoft Store to install Python?
echo You can install python yourself, but I cannot guarantee the program working.
echo If you chose to install Python on your own please make sure to add it to the system path.
echo.
echo Selecting Yes or No will close the program regardless, after installing, reopen the file.
choice /m "Do you wish to continue to the Microsoft Store?"
if %errorlevel% neq 2 python && exit
if %errorlevel% neq 1 exit
exit /b

:update
python --version 3>NUL
if errorlevel 1 call :redirect

pip install video2chars
pip install --upgrade pip

REM new versions break python and needs to downgrade
pip install pillow==9.5.0 


REM Adds python to system PATH while also allowing future proof for folder name changes due to version updates.
for /f "delims=" %%a in ('dir /b /ad /on "%UserProfile%\AppData\Local\Packages\PythonSoftwareFoundation.Python*"') do set name1=%%a
set "exec=%UserProfile%\AppData\Local\Packages\%name1%\LocalCache\local-packages"
for /f "delims=" %%a in ('dir /b /ad /on "%exec%\Python3*"') do set name2=%%a
set "exec=%UserProfile%\AppData\Local\Packages\%name1%\LocalCache\local-packages\%name2%\Scripts"
PATH %PATH%;%exec%

for /f "delims=" %%a in ('dir /b /ad /on "%UserProfile%\AppData\Local\Microsoft\WindowsApps\PythonSoftwareFoundation.Python*"') do set name3=%%a
set "exec2=%UserProfile%\AppData\Local\Microsoft\WindowsApps\%name3%"
PATH %PATH%;%exec2%

exit /b

:welcome
echo Welcome to CapedCrusader42's ACII Video Converter.
echo The purpose of this program is to allow for the simplistic conversion of a .mp4 file to the ASCII characters.
echo I claim zero ownership of the software converting the file (video2chars), which belongs to ryan4vin.
echo My only involvement was the creation of this interface.
echo.
echo If you encounter an error at any time please feel free to submit an anonymous bug report here: 
echo https://forms.gle/hTXMjCSnfYXcVyw29
echo The preferred method would be through posting an issue request in GitHub.
echo *Please be as detailed as possible with a means of contact if further questions are required.*
echo.
echo This program ONLY supports using the .mp4 file format.
echo All settings changed or configured will NOT persist after this program is closed.
echo.
echo If python version 3.0 or greater is not installed you will be redirected to the Microsoft Store.
echo.
echo *Once you proceed past this page the required software (video2chars) and its dependancies will be installed/updated.*
echo This installation process for video2chars and Python is removable once the program finishes.
echo You will be notified of its completion.
echo.
echo.
echo Press any key if you understand the terms above . . . && pause >nul
echo.
echo Please wait...
echo.
call :update || echo. && echo Update failed, please contact me at https://forms.gle/hTXMjCSnfYXcVyw29 with an explanation of the error that was provided. && echo. && Continuing will exit the program. && pause >nul && exit


REM =============================
REM ======= Program Start =======
REM =============================

:defaults
set file_name=output.mp4
REM Programs default FPS is 10 and just makes it look bad.
set fps=24
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
echo Be careful that the formatting is correct or the command will not work.
echo.
echo Hint1: Press and hold the SHIFT key while right-clicking the file and select the option "Copy as path".
echo Hint2: Then right-click in the command line window to paste.
echo.
set /p file=Copy and paste the files' location here: 

:view
echo.
dir %file% /A /Q || echo. && echo ERROR, this is not a valid file structure. Please press any key to retry. && pause >nul && goto file_select
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
echo 2.Video FPS (Default 24 fps, will slightly impact render times if changed)
echo 3.Video character width (Default 80, will dramatically impact render times if changed)
echo 4.Video length (Default, full video)
echo 5.Converted file location (Where to put the finished product, default is Desktop)
echo 6.CMD text color (No real purpose, changes cli color)
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

:file_name
cls
echo Make sure that the file name includes the .mp4 extension in the name you provide below.
echo Also use an underscore in the place of a space where needed.
echo.
set /p file_name=Please enter the new file name: 
goto begin

:fps
cls
set /p fps=Enter the fps that you wish to render the file: 
echo Changes saved, press any key to continue. && pause >nul && goto begin

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

echo Changes saved, press any key to continue. && pause >nul && goto begin

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

:file_location
cls
echo *Don't include Quotation marks ("") in the path if there are spaces, it will still work without them.*
echo Enter the full location path to put the file,
set /p "file_location=leave empty for default (user desktop): "
echo .
echo Changes saved, press any key to continue. && pause >nul && goto begin

:color 
cls
echo Choose Your Background/Text color from the selection below.
echo This selection has no effect on the output file and serves only as this tools color scheme.
echo.
echo 1. Black/Blue (Best)
echo 2. White/Black
echo 3. Black/Red
echo 4. Black/Yellow
echo.
set /p "cl=Enter the numbered color here: " || goto begin

if %cl% equ 1 color 01 && goto begin
if %cl% equ 2 color 70 && goto begin
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
echo Start time (in seconds): %start%
echo End time (in seconds): %end%
echo Characters width: %video_width%
echo Save location: %file_location%
REM echo The custom added charactrs to use for this render are %text%.
echo.


echo Press any key to continue... && pause >nul
IF EXIST "%file_location%\%file_name%" (
    goto rename
) ELSE (
    goto areusure
)


:areusure
echo.
echo Enter Y to continue and N to start over from the beginning.
choice /m "Are you sure that you wish to convert and save the file with the above settings?"
if %errorlevel% neq 2 goto overview2
if %errorlevel% neq 1 goto defaults
goto overview2

:file_name_2
cls
echo Make sure that the file name includes the .mp4 extension in the name you provide below.
echo Use a underscore in the places of a space where needed.
echo.
set /p file_name=Please enter the new file name: 
goto overview

:rename
cls
echo A file has been found with the same name in the destination folder.
echo.
echo File that you are trying to create: %file_name%
echo Existing file path: %file_location%\%file_name%
echo.
choice /m "Would you like to change the file name? Proceeding will overwrite the previous file."
if %errorlevel% neq 2 goto file_name_2
if %errorlevel% neq 1 goto areusure

:overview2
REM This is the viewable descriptors section
echo %start%|findstr /x "[0123456789]*" && set "start_des=%start%" || set "start_des=not configured"
echo %end%|findstr /x "[0123456789]*" && set "end_des=%end%" || set "end_des=not configured"

echo %video_width%|findstr /x "[0123456789]*" && set "video_width_des=%video_width%" || set "video_width_des=Default (80)"
echo %file_location%|findstr /x ".*" && set "file_location_des=%file_location%" || set "file_location_des=Default (%file_location%)"

REM Used for the actual command outputs
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
echo *Please keep this window in focus as the program may stop until you click back and press the ENTER key*
echo Please wait as the program may appear inactive, but will begin momentarily.
echo.
cd %file_location%

video2chars%video_width% --fps %fps%%start%%end% --output %file_name% %file%
Exit /B

:finished
call :activate || echo. && echo Please Re-enter the required information as according to the directions. && echo. && echo Press any key to retry... && pause >nul && goto defaults

:end
REM remove installed files
cls

cd C:\Users\%username%\AppData\Local\Microsoft\WindowsApps
for /f "delims=" %%a in ('dir /b /ad /on "%UserProfile%\AppData\Local\Microsoft\WindowsApps\PythonSoftwareFoundation.Python.*"') do set name5=%%a

echo If you choose not to remove both or would only like to remove Video2chars select "No" and continue.
choice /m "Would you like to remove all installed applications (Python and video2chars)?"
if %errorlevel% neq 2 pip uninstall video2chars && rmdir /s %name5% && del python.exe && del python3*.exe && goto open

choice /m "Would you like to remove ONLY Video2Chars?"
if %errorlevel% neq 2 pip uninstall video2chars && goto open

:open
echo.
choice /m "Installation complete! Do you want to navigate to the files' (%file_name%) destination folder?"
if %errorlevel% neq 2 start "" explorer "%file_location%" && echo. && echo Press any key to exit the program. && pause >nul