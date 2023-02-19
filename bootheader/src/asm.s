    .extern __entry
    
    .section .nor_cfg_option, "ax"
    .global __fw_info__
__fw_info__:
    .long __entry;
    .long 0xfcf90001;
    .long 0x00000007;
    .long 0x0;
    .long 0x0;
    .end    
