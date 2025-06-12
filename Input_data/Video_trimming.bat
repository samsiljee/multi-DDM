@echo off
setlocal enabledelayedexpansion
for %%f in (*.MOV) do (
    echo Processing %%f...
    
    REM Get total frame count
    for /f "tokens=*" %%i in ('ffprobe -v quiet -select_streams v:0 -count_frames -show_entries stream^=nb_frames -of csv^=p^=0 "%%f"') do set framecount=%%i
    
    REM Calculate start frame (total - 1024)
    set /a startframe=!framecount!-1024
    
    REM Process video starting from calculated frame
    ffmpeg -i "%%f" -vf "select='gte(n,!startframe!)'" -r 480 -c:v libx264 -crf 0 -preset slow -an -avoid_negative_ts make_zero "%%~nf_trimmed.MOV"
)
echo All files processed!
pause