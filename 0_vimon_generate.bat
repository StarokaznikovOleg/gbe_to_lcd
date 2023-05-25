set /P var="Select vimon10 GOWIN release(0x09xxxxxx): "
mkdir Z:\Debug\vimon10\vimon10_FW\%var%_fw
copy %~dp0src\*.rao Z:\Debug\vimon10\vimon10_FW\%var%_fw\
copy %~dp0impl\pnr\corund10cpu.bin Z:\Debug\vimon10\vimon103_FW\%var%_fw\vimongw%var%.bin
copy %~dp0impl\pnr\corund10cpu.binx Z:\Debug\vimon10\vimon10_FW\%var%_fw\vimongw%var%.binx
copy %~dp0impl\pnr\corund10cpu.fs Z:\Debug\vimon10\vimon10_FW\%var%_fw\vimongw%var%.fs
copy %~dp0*.pdf Z:\Debug\vimon10\
echo Creating release %var% factory completed
pause
