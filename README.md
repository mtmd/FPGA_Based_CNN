# README #

* Open DE5Net_Conv_Accelerator/DE5Net_Conv_Accelerator.qsf with *Quartus v16.0.0* on **Computer 1**
    * Generate Qsys System *mem_system*
    * Perform Full Compilation

* Install PCI-Express linux driver on Host PC (**Computer 2**)
    * Install instruction present in README
	
This project is a FPGA based implementation of first Convolutional Layer of AlexNet. The accelerator is developed using Verilog. 

## Citing
Our [research group](http://lepsucd.com) is working on acceleration of deep CNNs. If this project
helped your research, please kindly cite our latest conference paper:
```
Mohammad Motamedi, Philipp Gysel, Venkatesh Akella and Soheil Ghiasi, “Design Space Exploration of FPGA-Based Deep Convolutional Neural Network”, IEEE/ACM Asia-South Pacific Design Automation Conference (ASPDAC), January 2016.
```