/******************************************************************************
 * @file		niiet_ram.ld
 * @brief		���� ������������� ������ ��� ���������� �� ����������� ������
 * @version		v1.0
 * @date		11 ������� 2015
 *
 * @note
 * ��� "��� ������", ��� ����� ��������. ��� ����: http://motorcontrol.ru
 *
 * @par
 * ��� "��� ������" �������������� ��� ����������� ����������� � ����������������
 * �����, � ��� ����� ���������������� ��������.
 *
 * @par
 * ������ ����������� ����������� ���������������� "��� ����", � ��,
 * ��� ������������, ���������� �� ���� ��� �����, ��������� � ��� ��������������.
 * ��� "��� ������" �� ����� ������� ��������������� �� ��������� ������,
 * ��������� � ��� ��������������.
 *
 ******************************************************************************/

/* Entry Point */
ENTRY(Reset_Handler)


/* Generate a link error if heap and stack don't fit into RAM */
_Stack_Size = 0x1000; /* required amount of stack */

/* Specify the memory areas */
/* ����� � ������� ���������� ��������: ������ �� ������, 
 * ������, ����������, ��������� ������. */
MEMORY
{
  FLASH (rx)      : ORIGIN = 0x00000000, LENGTH = 1024K
  RAM (xrw)       : ORIGIN = 0x20000000, LENGTH = 192K
}
/* ����� ���� �� ������ (� ���������) - ������ ������ ����� ����� ����*/
_estack = ORIGIN(RAM) + LENGTH(RAM) - 4;  


/* Define output sections */
SECTIONS
{
  /* ������� �������� ���������� */  
  .isr_vector :
  {
	. = ALIGN(4); /* ������������ �� 4 ����� */
	__isr_vector_flash_start = LOADADDR (.isr_vector); /* ����� �����, ��� �� ����� ����� ��� ������� */
	__isr_vector_ram_start = .;
	KEEP(*(.isr_vector)) /* Startup code - KEEP ��������� ������� ������ �������� ������ */
	. = ALIGN(4);
	__isr_vector_ram_end = .; /* ����� ����������, ���� ����� ���������� ��� */
  } >RAM AT>RAM

  
  /* ������ ��� ����, ������� ����������� � ����������, � ����� �� �����.
   * � ������ ����� �� ���������� �� ROM � RAM.*/
  .fastcode : {
	  . = ALIGN(4);
	 __fastcode_flash_start = LOADADDR (.fastcode); /* ����� �����, ��� �� ����� ����� ���. */
	 /* ����� - ��� ������ �������� ���������� � ������. �.�. �  
	  * __fastcode_ram_start ����� ������ ����� ����������, ��� ����� ����������� ������������� ���.*/
	 __fastcode_ram_start = .;
	 *(.glue_7t) *(.glue_7)
	*(.fastcode)
	*(.fastcode*)
	. = ALIGN (4);
	__fastcode_ram_end = .; /* ����� ����������, ���� ����� ���������� ��� */
   } >RAM AT>RAM

  /* The program code and other data goes into RAM */
  .text :
  {
    . = ALIGN(4);
    *(.text)           /* .text sections (code) */
    *(.text*)          /* .text* sections (code) */
    *(.rodata)         /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
    *(.glue_7)         /* glue arm to thumb code */
    *(.glue_7t)        /* glue thumb to arm code */
	*(.eh_frame)

    KEEP (*(.init))
    KEEP (*(.fini))

    . = ALIGN(4);
    
    /* define a global symbols at end of code - ��������� �� ����� ����, 
  	  �.�. ����� - ��� ���������� � ������������������ ��������� ������ (�������� � ������)*/
    _etext = .;  
  } >RAM


    /* .preinit_array - ������ ��� ���������� �� ������� ���-�������������,
     *                  ���������� ����� ������ ������� ���������
     *                  ������������� (����� ����������� ���� �� ������
     *                  '.init' � �������� ������� �� ������ '.init_array').
     *
     * ����������� ������ � ������ '.preinit_array' � �������������
     * ����������� ������� � System V gABI. ����� �������, ��������� ��
     * ������� ���������� � ������ '.preinit_array', ����������� �� ����������
     * ������� ���������� (runtime library) -- ��������, �� C runtime. ���� �
     * ���������� �� ������������ ����� �����, �� ������� �� ������
     * '.preinit_array' �� ����� �������.
     *
     * ������ '.preinit_array' ������������� ��� ���-�������������
     * ������������ ����� (executable), ����������� ����� ��������������
     * ����������� �������������� � ��� ����������� �������� (shared objects).
     *
     * ������� __preinit_array_start � __preinit_array_end ������������
     * ����������� C ������� ���������� (newlib, glibc).
     */
  .preinit_array     :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } >RAM
  
    /* .init_array - ������ � ����������� �� ������� �������������,
     *               ������������� ����� ������� ������� ����� ���������, �.�.
     *               ����� ������� ������� main.
     *
     * ����������� ������ � ������ '.init_array' � ������������� �����������
     * ������� � System V gABI. ����� �������, ��������� �� ������� ���������� �
     * ������ '.init_array', ����������� �� ���������� ������� ����������
     * (runtime library) -- ��������, �� C runtime. ���� � ���������� ��
     * ������������ ����� �����, �� ������� �� ������ '.init_array' �� �����
     * �������.
     *
     * GCC ���������� ������ '.init_array' ��� ����������� ������ �����������
     * �������������: �������, ����������� � __attribute__((constructor)).
     *
     * ��� ����������� ������������� � ����������� ����������� PRIORITY,
     * ������������ ������ � ������ '.init_array.PRIORITY'
     *
     * ����� GCC ���������� ������ '.init_array' ��� ������ �������������
     * ����������� �������� C++.
     *
     * ������� __init_array_start � __init_array_end ������������ �����������
     * C ������� ���������� (newlib, glibc).
     */
  .init_array :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
  } >RAM
  /* .fini_array - ������ � ����������� �� ������� ����������,
   *               ������������� �� ���������� ��������� (����� �������� ��
   *               ������� ����� ���������, �.�. �� ������� main).
   *
   * ����������� ������ � ������ '.fini_array' � ������������� �����������
   * ������� � System V gABI. ����� �������, ��������� �� ������� ���������� �
   * ������ '.fini_array', ����������� �� ���������� ������� ����������
   * (runtime library) -- ��������, �� C runtime. ���� � ���������� ��
   * ������������ ����� �����, �� ������� �� ������ '.fini_array' �� �����
   * �������.
   *
   * GCC ���������� ������ '.fini_array' ��� ����������� ������ �����������
   * ������������: �������, ����������� � __attribute__((destructor)).
   *
   * ��� ����������� ������������ � ����������� ����������� PRIORITY,
   * ������������ ������ � ������ '.fini_array.PRIORITY'
   *
   * ������� __fini_array_start � __fini_array_end ������������ �����������
   * C ������� ���������� (newlib, glibc).
   */
  .fini_array :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(.fini_array*))
    KEEP (*(SORT(.fini_array.*)))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } >RAM

  /* used by the startup to initialize data */
  
  . = ALIGN(8);
  _sidata = .;


  /* ��������� _sidata, ������� ������� �� �������� ������ AT, 
   * ���������� ����� �������� ������. �� ���������, ���� �� 
   * �� ������������ �������� ����� AT, ����� �������� ����� ������ �����������. 
   * ��� ��� _sidata �� ����� ���� ����� ����� (��������� �� ������� �����),
   * �� .data ������ ����� ������ ����� ��. ��� �� ������������ �������� �����. 
   * */
  /* Initialized data sections goes into RAM, load LMA copy after code */
  .data : AT ( _sidata )
  {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */

    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */
  } >RAM

  /* Uninitialized data section */
  . = ALIGN(4);
  .bss :
  {
    /* This is used by the startup in order to initialize the .bss secion */
    _sbss = .;         /* define a global symbol at bss start */
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)

    . = ALIGN(4);
    _ebss = .;         /* define a global symbol at bss end */
    __bss_end__ = _ebss;
  } >RAM

  
  /* ������ ���������, ��� ����� ����� ���� �������� ����� ��� ����. 
   * ���� ������ ����� ����������!
   * �� ���������� ���� ������ ����� ���� �������, ������ �����!*/
  ._user_heap_stack :
  {
    . = ALIGN(4);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + _Stack_Size + 4;
    . = ALIGN(4);
  } >RAM
  
  
  /* Remove information from the standard libraries */
  /DISCARD/ :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  /*  ��� �����-�� �������� �� ������������ ����������, ����������� ���� ������������� � �� ��� ���, �������
   * 4.3.6 Build Attributes  http://infocenter.arm.com/help/topic/com.arm.doc.ihi0044e/IHI0044E_aaelf.pdf */
  .ARM.attributes 0 : { *(.ARM.attributes) }
}
