for /F "eol=; tokens=1* delims=,. " %%i in (filelist.txt) do (
    call process_laz2las %%i
	
	REM Call process_canopy_surface with the output of process_laz2las
    call process_canopy_surface %%i
	
	REM call process_canopy_height with the output of process_laz2las
	REM call process_canopy_height %%i
	)

REM call processes to create a merged DTM canopy surface, and convert it to a TIFF with world file (tfw)	
call MergeDTM output_canopy_surface\merged.DTM output_canopy_surface\*.DTM
call DTM2TIF output_canopy_surface\merged.DTM output_canopy_surface\merged.tif

REM call processes to create a merged DTM canopy Height model, and convert it to a TIFF with world file (tfw)	
call MergeDTM output_canopy_height\merged_height.DTM output_canopy_height\*.DTM
call DTM2TIF output_canopy_height\merged_height.DTM output_canopy_height\merged_height.tif