@echo off
TITLE Video to ASCII Converter

REM Version 1.0.1
REM video2chars is not owned by me and the original creator of this program can be found here: https://github.com/ryan4yin/video2chars

REM Known Issues:
REM Character input (previously option 5) has been removed until further notice

REM ============================
REM ======= Introduction =======
REM ============================

goto welcome

:update
pip install video2chars
exit /b

:welcome
echo Welcome to my Video file to ASCII character converter.
echo The purpose of this program is to allow for the simplistic conversion of a .mp4 file to the ADCII character set.
echo I claim zero ownership of the software used in this batch file, my only involvement was the creation of this tool.
echo.
echo This program ONLY supports using .mp4 file formats.
echo All setting changes made will only remain in the same terminal session and will not persist once this program is closed.
echo.

echo *Once you proceed past this page the required software (video2chars) and its dependancies will be installed/updated.*
echo You will be notified of its completion.
echo.
echo If you encounter a WARNING error at the completion of the program use option 8 to change the default directory.

echo.
set /p=Press the ENTER key to continue...
echo Please wait...
call :update


REM =============================
REM ======= Program Start =======
REM =============================


:defaults
set file_path=%UserProfile%\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.8_qbz5n2kfra8p0\LocalCache\local-packages\Python38\Scripts
set file_name=output.mp4
set fps=30
set video_width=
set start=
set end=
set text=
goto begin


:begin
cls
echo The program video2chars was successfully installed/updated and you are free to continue.
echo. 
echo Welcome, please enter the number corresponding to the selections below.
echo *For the default settings or to continue press and enter the 7 key and select which file to convert.*
echo.
echo 1.Converted file name
echo 2.Video FPS (Default 30 fps)
echo 3.Video width (Default 80, change only if needed will add dramatically increase render times)
echo 4.Video length
REM echo 5.Characters used for the conversion (Optional)
echo 5.Text color
echo 6.Finalize
echo 7.Only use this option if you encountered the WARNING error mentioned in the previous screen.

set /p input0=Response: 

if %input0% equ 1 goto file_name
if %input0% equ 2 goto fps 
if %input0% equ 3 goto width 
if %input0% equ 4 goto clipping 
REM if %input0% equ 5 goto text 
if %input0% equ 5 goto color 
if %input0% equ 6 goto file_select 
if %input0% equ 7 goto file_path 
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
        echo "Please enter a valid input." && pause >nul && clr
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
        echo "Please enter a valid input." && pause >nul && clr
        goto clipping1
    )
	
:clipping2
set /p "end=Ending time of video in seconds: " || goto defaults
setlocal enabledelayedexpansion 
for /f "delims=0123456789" %%a in ("!end!") do set "end="
endlocal & set "end=%end%"
if not defined end (
        echo "Please enter a valid input." && pause >nul && clr
        goto clipping2
    )


if %start% lss %end% echo. && echo The inputs have been saved and you can enter any key to continue. && pause >nul && goto begin
echo "Please make sure that the start time is less than the end time. Press any key to continue. . ." && pause >nul && goto clipping

goto begin

REM The reasoning for this selections removal can be found in the top of the program

REM :text
REM cls
REM echo Please ONLY enter numbers and symbols for the character that will comprise the render.
REM set /p text=(Optional and not recommended): 
REM goto begin

:color 
cls
Echo Choose Your Background color from the selection below.
echo This selection has no effect on the output file and serves only as this tools color scheme.
Echo.
echo 1. Whilte/Black
echo 2. Black/Blue
echo 3. Black/Red
echo 4. Black/Yellow

set /p "cl=Enter the numbered color here: " || goto begin

if %cl% equ 1 color 70 goto begin
if %cl% equ 2 color 01 goto begin
if %cl% equ 3 color 04 goto begin
if %cl% equ 4 color 06 goto begin
echo Invalid selection!
echo.
echo Press any key to try again.
pause >nul
cls
goto color


:file_select
cls
echo Please enter the file directory below of the file you wish to convert.
echo Be mindful that the formatting is correct or the command will not work.
echo.
echo Hint: Press and hold the shift key while selecting the file and choose "Copy file path".
echo Hint: Then right-click in the command line window to paste.
echo.
set /p file=Copy paste the files location here: 
goto :confirmation


:file_path
cls
set file_path=
goto begin


:confirmation
cls
echo %start%|findstr /x "[0123456789]*" && set "start=%start%" || set "start=not configured"
echo %end%|findstr /x "[0123456789]*" && set "end=%end%" || set "end=not configured"
echo %video_width%|findstr /x "[0123456789]*" && set "video_width=%video_width%" || set "video_width=not configured"
echo %text%|findstr /x "[0123456789~!@#$%^&*()_+}|{":>?<|/\[]';.,=-]*" && set "text=%text%" || set "text=not configured"
goto confirmation2

:confirmation2
cls
echo Are you sure that you wish to save this file with the name of %file_name% and the fps set to %fps%? 
echo The files starting time in seconds is %start%. The ending time in seconds for this video is %end%. 
echo The videos characters width is %video_width%.
echo The custom added charactrs to use for this render are %text%.
echo.

set /p=Press the ENTER key to continue...
echo %start%|findstr /x "[0123456789]*" && set "start=--t_start %start%" || set "start="
echo %end%|findstr /x "[0123456789]*" && set "end=--t_end %end%" || set "end="
echo %video_width%|findstr /x "[0123456789]*" && set "video_width=--chars_width %video_width%" || set "video_width="
echo %text%|findstr /x "[0123456789~!@#$%^&*()_+}|{":>?<|]*" && set "text=--pixel %text%" || set "text="

goto finished

:activate
cls
cd %file_path%
video2chars %video_width% --fps %fps% %start% %end% --output %file_name% %file%
Exit /B

:finished
call :activate || echo. && echo Please Re-enter the file path and try again. && echo. && echo Press the ENTER key to continue... && pause >nul && goto file_select

echo The program has finished the installation. Do you want to navigate to the destination folder?
echo If you select no the program will exit.

set /p check=Enter Y for yes or N for no: 

if %check%==Y (explorer "%file_path%") else (exit)
pause