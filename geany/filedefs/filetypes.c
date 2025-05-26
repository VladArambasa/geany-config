[build-menu]
FT_00_LB=Compile
FT_00_CM=( [ -f compile.sh ] || cp ~/.config/geany/compile.sh . ) && chmod +x compile.sh && ./compile.sh
FT_00_WD=
FT_01_LB=Build
FT_01_CM=( [ -f build.sh ] || cp ~/.config/geany/build.sh . ) && chmod +x build.sh && ./build.sh
FT_01_WD=
FT_02_LB=Run
FT_02_CM=./release/program
FT_02_WD=
EX_00_LB=_Execute
EX_00_CM=./release/program
EX_00_WD=
