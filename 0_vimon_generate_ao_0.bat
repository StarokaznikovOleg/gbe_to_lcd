set /P var="Select VIMON10 GOWIN release(0x09xxxxxx): "
mkdir Z:\Debug\vimon\vimon10_FW\%var%_fw
copy %~dp0src\*.rao Z:\Debug\vimon\vimon10_FW\%var%_fw\
copy %~dp0impl\pnr\ao_0.bin Z:\Debug\vimon\vimon10_FW\%var%_fw\vimongw%var%.bin
copy %~dp0impl\pnr\ao_0.binx Z:\Debug\vimon\vimon10_FW\%var%_fw\vimongw%var%.binx
copy %~dp0impl\pnr\ao_0.fs Z:\Debug\vimon\vimon10_FW\%var%_fw\vimongw%var%.fs
copy %~dp0*.pdf Z:\Debug\vimon\
echo Creating release %var% factory completed
pause
