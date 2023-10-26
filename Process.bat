echo off

REM set .bat processes file pathsto call later.
set "ParentDirectory=%~dp0" 
set "ProcessLaz2LasScript=%ParentDirectory%\process_laz2las.bat"
set "ProcessCanopySurfaceScript=%ParentDirectory%\process_canopy_surface.bat"

REM Iterate over folders in the current directory
for /d %%D in (*) do (
	REM open folder %%D
    	echo Processing folder: %%D
    	pushd "%%D"
	
	REM create filelist.txt with .laz files to process
	DIR /b *.laz > filelist.txt
	echo compiled a list of .laz files to process in %%D
	
	REM create output sub directories
	if not exist output_las mkdir "output_las"
    	if not exist output_canopy_surface mkdir "output_canopy_surface"
    	if not exist output_canopy_height mkdir "output_canopy_height"
	echo "output_las" created in %%D.
	echo "output_canopy_surface" created in %%D.
	echo "output_canopy_height" created in %%D.
	
	REM unpack .laz to .las, and run models. models export to output folders.
	for /F "eol=; tokens=1* delims=,. " %%i in (filelist.txt) do (
		call "%ProcessLaz2LasScript%" %%i
	
		call "%ProcessCanopySurfaceScript%" %%i
	)
	
	REM call processes to create a merged DTM canopy surface, and convert it to a TIFF with world file (tfw)	
	call MergeDTM output_canopy_surface\merged.DTM output_canopy_surface\*.DTM
	call DTM2TIF output_canopy_surface\merged.DTM output_canopy_surface\merged.tif

	popd
)

echo All folders processed.

