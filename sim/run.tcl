open_vcd dump.vcd
log_vcd -level 0 [get_objects -r /rv64_single_cycle_tb_legacy/*]
run all
flush_vcd
close_vcd
quit