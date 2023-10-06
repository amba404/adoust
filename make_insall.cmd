set PathScript=c:\PROG\ADOUST\src\
set PathEXE=c:\PROG\ADOUST\rel\
"c:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe_x64.exe" /in %PathScript%ADO_UST.au3 /out %PathEXE%ADO_UST.exe
c:\PROG\upx-3.96-win64\upx.exe --best %PathEXE%ADO_UST.exe
copy /y %PathEXE%ADO_UST.exe %PathScript%ADO_UST.exe
pushd %PathEXE%
del /q ADO_UST.0??
c:\cygwin64\bin\split -b 64K -a 3 -d ADO_UST.exe ADO_UST.
popd