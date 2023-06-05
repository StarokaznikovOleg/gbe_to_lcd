set /P var="Select vimon10 GOWIN release(0x09xxxxxx): "
mkdir Z:\Debug\VIMON\vimon10_FW\%var%_fw
copy %~dp0src\*.rao Z:\Debug\VIMON\vimon10_FW\%var%_fw\
copy %~dp0impl\pnr\vimon10.bin Z:\Debug\VIMON\vimon10_FW\%var%_fw\vimongw%var%.bin
copy %~dp0impl\pnr\vimon10.binx Z:\Debug\VIMON\vimon10_FW\%var%_fw\vimongw%var%.binx
copy %~dp0impl\pnr\vimon10.fs Z:\Debug\VIMON\vimon10_FW\%var%_fw\vimongw%var%.fs
copy %~dp0*.pdf Z:\Debug\VIMON\
echo Creating release %var% factory completed
pause
