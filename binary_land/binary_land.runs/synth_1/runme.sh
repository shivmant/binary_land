#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
# 

echo "This script was generated under a different operating system."
echo "Please update the PATH and LD_LIBRARY_PATH variables below, before executing this script"
exit

if [ -z "$PATH" ]; then
  PATH=D:/programy/Xilinx_Vivado/SDK/2017.3/bin;D:/programy/Xilinx_Vivado/Vivado/2017.3/ids_lite/ISE/bin/nt64;D:/programy/Xilinx_Vivado/Vivado/2017.3/ids_lite/ISE/lib/nt64:D:/programy/Xilinx_Vivado/Vivado/2017.3/bin
else
  PATH=D:/programy/Xilinx_Vivado/SDK/2017.3/bin;D:/programy/Xilinx_Vivado/Vivado/2017.3/ids_lite/ISE/bin/nt64;D:/programy/Xilinx_Vivado/Vivado/2017.3/ids_lite/ISE/lib/nt64:D:/programy/Xilinx_Vivado/Vivado/2017.3/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='D:/STUDIA/IV_semestr/Uklady_elektroniki_cyfrowej_II/Projekt_binary_land/binary_land/binary_land.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log main.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source main.tcl
