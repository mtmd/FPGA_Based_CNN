# README #

* Open DE5Net_Conv_Accelerator/DE5Net_Conv_Accelerator.qsf with *Quartus v16.0.0* on **Computer 1**
    * Generate Qsys System *mem_system*
    * Perform Full Compilation
    * Use computer 1 to program the FPGA device installed on HOST Computer (**Computer 2**). NOTE: This will cause the host computer Kernel to reset and it will automatically reboot. Please save all you work before proceeding with this.
    * Reboot the host computer to train the PCIe link with FPGA board.

* Install PCI-Express linux driver on Host PC (**Computer 2**)
    * Install instructions present in README
    * Refer to *Using the User Application* pdf for instructions on data transfer.
	
This project is a FPGA based implementation of first Convolutional Layer of AlexNet. The accelerator is developed using Verilog. 
## Contact
Currently Mr. Sachin Kumawat is developing this project. If you have question or need further information, please contact him.
Email: skumawat@ucdavis.edu 
## Citing
Our [research group](http://lepsucd.com) is working on acceleration of deep CNNs. If this project
helped your research, please kindly cite our latest conference paper:
```
Mohammad Motamedi, Philipp Gysel, Venkatesh Akella and Soheil Ghiasi, “Design Space Exploration of FPGA-Based Deep Convolutional Neural Network”, IEEE/ACM Asia-South Pacific Design Automation Conference (ASPDAC), January 2016.
```
