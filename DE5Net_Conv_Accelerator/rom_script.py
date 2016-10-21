# -*- coding: utf-8 -*-
w = 11
h = 11
H = 227
S = 4
addr = 0
comment = "    -- memory address : data"

with open("mem_init.mif", "w") as fp:
    # Header
    fp.write("--Expected values of OFMs\n\n")
    fp.write("DEPTH = 290400;                            -- The size of memory in words\n")
    fp.write("WIDTH = 16;                                -- The size of data in bits\n")
    fp.write("ADDRESS_RADIX = DEC;                       -- The radix for address values\n")
    fp.write("DATA_RADIX = DEC;                          -- The radix for data values\n")
    fp.write("CONTENT                                    -- start of (address : data pairs)\n")
    fp.write("BEGIN\n\n")

    for k in xrange(96):
	    for i in xrange(55):
		    for j in xrange(55):
			    xij = S * (H * i + j)
			    total = w * h * (w * H + h) + (2 * xij - H - 1) * h * w
			    total = total/2 * 3 + 363 + k
			    total_str = '{0:064b}'.format(total)
			    total_16b = total_str[-16:]
			    addr_19b = '{0:019b}'.format(addr)
			    fp.write(str(int(addr_19b,2)) + ' : ' + str(int(total_16b,2)) + ';' + comment + '\n')
			    comment = ''
			    addr = addr + 1
			
    fp.write("\nEND;\n")
