@echo off
setlocal enabledelayedexpansion

REM Frame numbers
set FRAMES=1024

echo Processing all .MOV files in current directory...
echo Extracting last %FRAMES% frames from each video and setting to 480 fps
echo.

REM Counter for processed files
set PROCESSED_COUNT=0
set SUCCESS_COUNT=0
set ERROR_COUNT=0

REM Loop through all .MOV files
for %%f in (*.MOV) do (
    set INPUT_FILE=%%f
    set OUTPUT_FILE=%%~nf_processed.MOV
    
    echo ===========================================
    echo Processing: !INPUT_FILE!
    echo Getting total frame count...
    
    REM Get total frame count using ffprobe
    for /f %%i in ('ffprobe -v quiet -select_streams v:0 -show_entries stream^=nb_frames -of csv^=s^=x:p^=0 "!INPUT_FILE!"') do set TOTAL_FRAMES=%%i
    
    if defined TOTAL_FRAMES (
        if !TOTAL_FRAMES! GTR %FRAMES% (
            echo Total frames in video: !TOTAL_FRAMES!
            
            REM Calculate start frame (take last 1024 frames)
            set /a END_FRAME=!TOTAL_FRAMES!-1
            set /a START_FRAME=!END_FRAME!-%FRAMES%+1
            
            echo Trimming from frame !START_FRAME! to frame !END_FRAME!
            echo Output file: !OUTPUT_FILE!
            echo.
            
            REM Execute ffmpeg command
            ffmpeg -i "!INPUT_FILE!" -vf "select='between(n,!START_FRAME!,!END_FRAME!)',setpts=N/(480*TB)" -an -c:v libx264 -preset veryslow -crf 1 -pix_fmt yuv420p -r 480 "!OUTPUT_FILE!"
            
            if !errorlevel! equ 0 (
                echo SUCCESS: !OUTPUT_FILE! created successfully
                set /a SUCCESS_COUNT+=1
            ) else (
                echo ERROR: Failed to process !INPUT_FILE!
                set /a ERROR_COUNT+=1
            )
        ) else (
            echo SKIPPED: !INPUT_FILE! has only !TOTAL_FRAMES! frames (need at least %FRAMES%^)
        )
    ) else (
        echo ERROR: Could not determine frame count for !INPUT_FILE!
        set /a ERROR_COUNT+=1
    )
    
    set /a PROCESSED_COUNT+=1
    echo.
)

echo ===========================================
echo BATCH PROCESSING COMPLETE
echo Files processed: %PROCESSED_COUNT%
echo Successful: %SUCCESS_COUNT%
echo Errors/Skipped: %ERROR_COUNT%
echo ===========================================

if %SUCCESS_COUNT% GTR 0 (
    echo.
    echo Verifying one output file...
    for %%f in (*_processed.MOV) do (
        echo Checking: %%f
        ffprobe -v quiet -select_streams v:0 -show_entries stream=nb_frames,r_frame_rate -of csv=s=x:p=0 "%%f"
        goto :done_verification
    )
    :done_verification
)

pause