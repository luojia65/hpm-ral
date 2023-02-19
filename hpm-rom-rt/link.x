/* Ref: crate riscv-rt */

INCLUDE memory.x;

EXTERN(offset);
ENTRY(_start);

SECTIONS
{
  .nor_cfg_option ORIGIN(REGION_NOR_CFG_OPTION) : {
    KEEP(*(.nor_cfg_option.offset));
    KEEP(*(.nor_cfg_option.firmware_info));
    KEEP(*(.nor_cfg_option.text_dummy));
  } > REGION_NOR_CFG_OPTION

  .text :
  {
    _stext = .;
    KEEP(*(.init));
    KEEP(*(.init.rust));
    *(.text .text.*);
    _etext = .;
  } > REGION_TEXT

  .rodata : ALIGN(4)
  {
    *(.srodata .srodata.*);
    *(.rodata .rodata.*);
    . = ALIGN(4);
  } > REGION_RODATA

  .data : ALIGN(4)
  {
    _sidata = LOADADDR(.data);
    _sdata = .;
    /* Must be called __global_pointer$ for linker relaxations to work. */
    PROVIDE(__global_pointer$ = . + 0x800);
    *(.sdata .sdata.* .sdata2 .sdata2.*);
    *(.data .data.*);
    . = ALIGN(4);
    _edata = .;
  } > REGION_DATA AT > REGION_RODATA

  .bss (NOLOAD) :
  {
    _sbss = .;
    *(.sbss .sbss.* .bss .bss.*);
    . = ALIGN(4);
    _ebss = .;
  } > REGION_BSS

  /* fake output .got section */
  /* Dynamic relocations are unsupported. This section is only used to detect
     relocatable code in the input files and raise an error if relocatable code
     is found */
  .got (INFO) :
  {
    KEEP(*(.got .got.*));
  }

  .eh_frame (INFO) : { KEEP(*(.eh_frame)) }
  .eh_frame_hdr (INFO) : { *(.eh_frame_hdr) }
}
