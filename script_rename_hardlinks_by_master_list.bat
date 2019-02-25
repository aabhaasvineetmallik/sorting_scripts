setlocal enabledelayedexpansion
echo.|set /p some=>temp_file_rename_hardlinks_by_master_name_list.bat
for /r %%i in (*.pdf) do (
	for /f "tokens=*" %%a in ('fsutil hardlink list "%%~ni.pdf"') do (
    echo ren "C:%%a" "%%~ni.pdf">>Rename-All-Hardlinks-Everywhere[Temp].bat
	)
)
echo del /f /q temp_file_rename_hardlinks_by_master_name_list.bat >>temp_file_rename_hardlinks_by_master_name_list.bat
temp_file_rename_hardlinks_by_master_name_list.bat


