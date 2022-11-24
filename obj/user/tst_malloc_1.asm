
obj/user/tst_malloc_1:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 ac 05 00 00       	call   8005e2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800040:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800044:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004b:	eb 29                	jmp    800076 <_main+0x3e>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004d:	a1 20 30 80 00       	mov    0x803020,%eax
  800052:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800058:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005b:	89 d0                	mov    %edx,%eax
  80005d:	01 c0                	add    %eax,%eax
  80005f:	01 d0                	add    %edx,%eax
  800061:	c1 e0 03             	shl    $0x3,%eax
  800064:	01 c8                	add    %ecx,%eax
  800066:	8a 40 04             	mov    0x4(%eax),%al
  800069:	84 c0                	test   %al,%al
  80006b:	74 06                	je     800073 <_main+0x3b>
			{
				fullWS = 0;
  80006d:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800071:	eb 12                	jmp    800085 <_main+0x4d>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800073:	ff 45 f0             	incl   -0x10(%ebp)
  800076:	a1 20 30 80 00       	mov    0x803020,%eax
  80007b:	8b 50 74             	mov    0x74(%eax),%edx
  80007e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800081:	39 c2                	cmp    %eax,%edx
  800083:	77 c8                	ja     80004d <_main+0x15>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800085:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800089:	74 14                	je     80009f <_main+0x67>
  80008b:	83 ec 04             	sub    $0x4,%esp
  80008e:	68 60 21 80 00       	push   $0x802160
  800093:	6a 14                	push   $0x14
  800095:	68 7c 21 80 00       	push   $0x80217c
  80009a:	e8 7f 06 00 00       	call   80071e <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	6a 00                	push   $0x0
  8000a4:	e8 cd 16 00 00       	call   801776 <malloc>
  8000a9:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ac:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b3:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	//int sizeOfMemBlocksArray = ROUNDUP(((USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE) * sizeof(struct MemBlock), PAGE_SIZE) ;
	void* ptr_allocations[20] = {0};
  8000ba:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000bd:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c7:	89 d7                	mov    %edx,%edi
  8000c9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000cb:	e8 b5 18 00 00       	call   801985 <sys_calculate_free_frames>
  8000d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d3:	e8 4d 19 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  8000d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000de:	01 c0                	add    %eax,%eax
  8000e0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	50                   	push   %eax
  8000e7:	e8 8a 16 00 00       	call   801776 <malloc>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000f2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	79 0a                	jns    800103 <_main+0xcb>
  8000f9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000fc:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800101:	76 14                	jbe    800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 90 21 80 00       	push   $0x802190
  80010b:	6a 23                	push   $0x23
  80010d:	68 7c 21 80 00       	push   $0x80217c
  800112:	e8 07 06 00 00       	call   80071e <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800117:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80011a:	e8 66 18 00 00       	call   801985 <sys_calculate_free_frames>
  80011f:	29 c3                	sub    %eax,%ebx
  800121:	89 d8                	mov    %ebx,%eax
  800123:	83 f8 01             	cmp    $0x1,%eax
  800126:	74 14                	je     80013c <_main+0x104>
  800128:	83 ec 04             	sub    $0x4,%esp
  80012b:	68 c0 21 80 00       	push   $0x8021c0
  800130:	6a 27                	push   $0x27
  800132:	68 7c 21 80 00       	push   $0x80217c
  800137:	e8 e2 05 00 00       	call   80071e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80013c:	e8 e4 18 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  800141:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800144:	3d 00 02 00 00       	cmp    $0x200,%eax
  800149:	74 14                	je     80015f <_main+0x127>
  80014b:	83 ec 04             	sub    $0x4,%esp
  80014e:	68 2c 22 80 00       	push   $0x80222c
  800153:	6a 28                	push   $0x28
  800155:	68 7c 21 80 00       	push   $0x80217c
  80015a:	e8 bf 05 00 00       	call   80071e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80015f:	e8 21 18 00 00       	call   801985 <sys_calculate_free_frames>
  800164:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800167:	e8 b9 18 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  80016c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80016f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800172:	01 c0                	add    %eax,%eax
  800174:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	50                   	push   %eax
  80017b:	e8 f6 15 00 00       	call   801776 <malloc>
  800180:	83 c4 10             	add    $0x10,%esp
  800183:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800186:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800189:	89 c2                	mov    %eax,%edx
  80018b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018e:	01 c0                	add    %eax,%eax
  800190:	05 00 00 00 80       	add    $0x80000000,%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	72 13                	jb     8001ac <_main+0x174>
  800199:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80019c:	89 c2                	mov    %eax,%edx
  80019e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a1:	01 c0                	add    %eax,%eax
  8001a3:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8001a8:	39 c2                	cmp    %eax,%edx
  8001aa:	76 14                	jbe    8001c0 <_main+0x188>
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 90 21 80 00       	push   $0x802190
  8001b4:	6a 2d                	push   $0x2d
  8001b6:	68 7c 21 80 00       	push   $0x80217c
  8001bb:	e8 5e 05 00 00       	call   80071e <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001c0:	e8 c0 17 00 00       	call   801985 <sys_calculate_free_frames>
  8001c5:	89 c2                	mov    %eax,%edx
  8001c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ca:	39 c2                	cmp    %eax,%edx
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 c0 21 80 00       	push   $0x8021c0
  8001d6:	6a 2f                	push   $0x2f
  8001d8:	68 7c 21 80 00       	push   $0x80217c
  8001dd:	e8 3c 05 00 00       	call   80071e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8001e2:	e8 3e 18 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  8001e7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001ea:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001ef:	74 14                	je     800205 <_main+0x1cd>
  8001f1:	83 ec 04             	sub    $0x4,%esp
  8001f4:	68 2c 22 80 00       	push   $0x80222c
  8001f9:	6a 30                	push   $0x30
  8001fb:	68 7c 21 80 00       	push   $0x80217c
  800200:	e8 19 05 00 00       	call   80071e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800205:	e8 7b 17 00 00       	call   801985 <sys_calculate_free_frames>
  80020a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80020d:	e8 13 18 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  800212:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800218:	89 c2                	mov    %eax,%edx
  80021a:	01 d2                	add    %edx,%edx
  80021c:	01 d0                	add    %edx,%eax
  80021e:	83 ec 0c             	sub    $0xc,%esp
  800221:	50                   	push   %eax
  800222:	e8 4f 15 00 00       	call   801776 <malloc>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80022d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800230:	89 c2                	mov    %eax,%edx
  800232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800235:	c1 e0 02             	shl    $0x2,%eax
  800238:	05 00 00 00 80       	add    $0x80000000,%eax
  80023d:	39 c2                	cmp    %eax,%edx
  80023f:	72 14                	jb     800255 <_main+0x21d>
  800241:	8b 45 98             	mov    -0x68(%ebp),%eax
  800244:	89 c2                	mov    %eax,%edx
  800246:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800249:	c1 e0 02             	shl    $0x2,%eax
  80024c:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800251:	39 c2                	cmp    %eax,%edx
  800253:	76 14                	jbe    800269 <_main+0x231>
  800255:	83 ec 04             	sub    $0x4,%esp
  800258:	68 90 21 80 00       	push   $0x802190
  80025d:	6a 35                	push   $0x35
  80025f:	68 7c 21 80 00       	push   $0x80217c
  800264:	e8 b5 04 00 00       	call   80071e <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800269:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80026c:	e8 14 17 00 00       	call   801985 <sys_calculate_free_frames>
  800271:	29 c3                	sub    %eax,%ebx
  800273:	89 d8                	mov    %ebx,%eax
  800275:	83 f8 01             	cmp    $0x1,%eax
  800278:	74 14                	je     80028e <_main+0x256>
  80027a:	83 ec 04             	sub    $0x4,%esp
  80027d:	68 c0 21 80 00       	push   $0x8021c0
  800282:	6a 37                	push   $0x37
  800284:	68 7c 21 80 00       	push   $0x80217c
  800289:	e8 90 04 00 00       	call   80071e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  80028e:	e8 92 17 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  800293:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800296:	83 f8 01             	cmp    $0x1,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 2c 22 80 00       	push   $0x80222c
  8002a3:	6a 38                	push   $0x38
  8002a5:	68 7c 21 80 00       	push   $0x80217c
  8002aa:	e8 6f 04 00 00       	call   80071e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 d1 16 00 00       	call   801985 <sys_calculate_free_frames>
  8002b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 69 17 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  8002bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8002bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c2:	89 c2                	mov    %eax,%edx
  8002c4:	01 d2                	add    %edx,%edx
  8002c6:	01 d0                	add    %edx,%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 a5 14 00 00       	call   801776 <malloc>
  8002d1:	83 c4 10             	add    $0x10,%esp
  8002d4:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002d7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002da:	89 c2                	mov    %eax,%edx
  8002dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002df:	c1 e0 02             	shl    $0x2,%eax
  8002e2:	89 c1                	mov    %eax,%ecx
  8002e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002e7:	c1 e0 02             	shl    $0x2,%eax
  8002ea:	01 c8                	add    %ecx,%eax
  8002ec:	05 00 00 00 80       	add    $0x80000000,%eax
  8002f1:	39 c2                	cmp    %eax,%edx
  8002f3:	72 1e                	jb     800313 <_main+0x2db>
  8002f5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002f8:	89 c2                	mov    %eax,%edx
  8002fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002fd:	c1 e0 02             	shl    $0x2,%eax
  800300:	89 c1                	mov    %eax,%ecx
  800302:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800305:	c1 e0 02             	shl    $0x2,%eax
  800308:	01 c8                	add    %ecx,%eax
  80030a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80030f:	39 c2                	cmp    %eax,%edx
  800311:	76 14                	jbe    800327 <_main+0x2ef>
  800313:	83 ec 04             	sub    $0x4,%esp
  800316:	68 90 21 80 00       	push   $0x802190
  80031b:	6a 3d                	push   $0x3d
  80031d:	68 7c 21 80 00       	push   $0x80217c
  800322:	e8 f7 03 00 00       	call   80071e <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800327:	e8 59 16 00 00       	call   801985 <sys_calculate_free_frames>
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	74 14                	je     800349 <_main+0x311>
  800335:	83 ec 04             	sub    $0x4,%esp
  800338:	68 c0 21 80 00       	push   $0x8021c0
  80033d:	6a 3f                	push   $0x3f
  80033f:	68 7c 21 80 00       	push   $0x80217c
  800344:	e8 d5 03 00 00       	call   80071e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800349:	e8 d7 16 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  80034e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800351:	83 f8 01             	cmp    $0x1,%eax
  800354:	74 14                	je     80036a <_main+0x332>
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	68 2c 22 80 00       	push   $0x80222c
  80035e:	6a 40                	push   $0x40
  800360:	68 7c 21 80 00       	push   $0x80217c
  800365:	e8 b4 03 00 00       	call   80071e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80036a:	e8 16 16 00 00       	call   801985 <sys_calculate_free_frames>
  80036f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800372:	e8 ae 16 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  800377:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80037a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037d:	89 d0                	mov    %edx,%eax
  80037f:	01 c0                	add    %eax,%eax
  800381:	01 d0                	add    %edx,%eax
  800383:	01 c0                	add    %eax,%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 e6 13 00 00       	call   801776 <malloc>
  800390:	83 c4 10             	add    $0x10,%esp
  800393:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800396:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800399:	89 c2                	mov    %eax,%edx
  80039b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80039e:	c1 e0 02             	shl    $0x2,%eax
  8003a1:	89 c1                	mov    %eax,%ecx
  8003a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a6:	c1 e0 03             	shl    $0x3,%eax
  8003a9:	01 c8                	add    %ecx,%eax
  8003ab:	05 00 00 00 80       	add    $0x80000000,%eax
  8003b0:	39 c2                	cmp    %eax,%edx
  8003b2:	72 1e                	jb     8003d2 <_main+0x39a>
  8003b4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003b7:	89 c2                	mov    %eax,%edx
  8003b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003bc:	c1 e0 02             	shl    $0x2,%eax
  8003bf:	89 c1                	mov    %eax,%ecx
  8003c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c4:	c1 e0 03             	shl    $0x3,%eax
  8003c7:	01 c8                	add    %ecx,%eax
  8003c9:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003ce:	39 c2                	cmp    %eax,%edx
  8003d0:	76 14                	jbe    8003e6 <_main+0x3ae>
  8003d2:	83 ec 04             	sub    $0x4,%esp
  8003d5:	68 90 21 80 00       	push   $0x802190
  8003da:	6a 45                	push   $0x45
  8003dc:	68 7c 21 80 00       	push   $0x80217c
  8003e1:	e8 38 03 00 00       	call   80071e <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003e6:	e8 9a 15 00 00       	call   801985 <sys_calculate_free_frames>
  8003eb:	89 c2                	mov    %eax,%edx
  8003ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003f0:	39 c2                	cmp    %eax,%edx
  8003f2:	74 14                	je     800408 <_main+0x3d0>
  8003f4:	83 ec 04             	sub    $0x4,%esp
  8003f7:	68 c0 21 80 00       	push   $0x8021c0
  8003fc:	6a 47                	push   $0x47
  8003fe:	68 7c 21 80 00       	push   $0x80217c
  800403:	e8 16 03 00 00       	call   80071e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800408:	e8 18 16 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  80040d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800410:	83 f8 02             	cmp    $0x2,%eax
  800413:	74 14                	je     800429 <_main+0x3f1>
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 2c 22 80 00       	push   $0x80222c
  80041d:	6a 48                	push   $0x48
  80041f:	68 7c 21 80 00       	push   $0x80217c
  800424:	e8 f5 02 00 00       	call   80071e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800429:	e8 57 15 00 00       	call   801985 <sys_calculate_free_frames>
  80042e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800431:	e8 ef 15 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  800436:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80043c:	89 c2                	mov    %eax,%edx
  80043e:	01 d2                	add    %edx,%edx
  800440:	01 d0                	add    %edx,%eax
  800442:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800445:	83 ec 0c             	sub    $0xc,%esp
  800448:	50                   	push   %eax
  800449:	e8 28 13 00 00       	call   801776 <malloc>
  80044e:	83 c4 10             	add    $0x10,%esp
  800451:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800454:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800457:	89 c2                	mov    %eax,%edx
  800459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045c:	c1 e0 02             	shl    $0x2,%eax
  80045f:	89 c1                	mov    %eax,%ecx
  800461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800464:	c1 e0 04             	shl    $0x4,%eax
  800467:	01 c8                	add    %ecx,%eax
  800469:	05 00 00 00 80       	add    $0x80000000,%eax
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	72 1e                	jb     800490 <_main+0x458>
  800472:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800475:	89 c2                	mov    %eax,%edx
  800477:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047a:	c1 e0 02             	shl    $0x2,%eax
  80047d:	89 c1                	mov    %eax,%ecx
  80047f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800482:	c1 e0 04             	shl    $0x4,%eax
  800485:	01 c8                	add    %ecx,%eax
  800487:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80048c:	39 c2                	cmp    %eax,%edx
  80048e:	76 14                	jbe    8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 90 21 80 00       	push   $0x802190
  800498:	6a 4d                	push   $0x4d
  80049a:	68 7c 21 80 00       	push   $0x80217c
  80049f:	e8 7a 02 00 00       	call   80071e <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8004a4:	e8 dc 14 00 00       	call   801985 <sys_calculate_free_frames>
  8004a9:	89 c2                	mov    %eax,%edx
  8004ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ae:	39 c2                	cmp    %eax,%edx
  8004b0:	74 14                	je     8004c6 <_main+0x48e>
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 5a 22 80 00       	push   $0x80225a
  8004ba:	6a 4e                	push   $0x4e
  8004bc:	68 7c 21 80 00       	push   $0x80217c
  8004c1:	e8 58 02 00 00       	call   80071e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8004c6:	e8 5a 15 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  8004cb:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004ce:	89 c2                	mov    %eax,%edx
  8004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004d3:	89 c1                	mov    %eax,%ecx
  8004d5:	01 c9                	add    %ecx,%ecx
  8004d7:	01 c8                	add    %ecx,%eax
  8004d9:	85 c0                	test   %eax,%eax
  8004db:	79 05                	jns    8004e2 <_main+0x4aa>
  8004dd:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004e2:	c1 f8 0c             	sar    $0xc,%eax
  8004e5:	39 c2                	cmp    %eax,%edx
  8004e7:	74 14                	je     8004fd <_main+0x4c5>
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 2c 22 80 00       	push   $0x80222c
  8004f1:	6a 4f                	push   $0x4f
  8004f3:	68 7c 21 80 00       	push   $0x80217c
  8004f8:	e8 21 02 00 00       	call   80071e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004fd:	e8 83 14 00 00       	call   801985 <sys_calculate_free_frames>
  800502:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800505:	e8 1b 15 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  80050a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  80050d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800510:	01 c0                	add    %eax,%eax
  800512:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800515:	83 ec 0c             	sub    $0xc,%esp
  800518:	50                   	push   %eax
  800519:	e8 58 12 00 00       	call   801776 <malloc>
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  800524:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800527:	89 c1                	mov    %eax,%ecx
  800529:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80052c:	89 d0                	mov    %edx,%eax
  80052e:	01 c0                	add    %eax,%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	89 c2                	mov    %eax,%edx
  800538:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80053b:	c1 e0 04             	shl    $0x4,%eax
  80053e:	01 d0                	add    %edx,%eax
  800540:	05 00 00 00 80       	add    $0x80000000,%eax
  800545:	39 c1                	cmp    %eax,%ecx
  800547:	72 25                	jb     80056e <_main+0x536>
  800549:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80054c:	89 c1                	mov    %eax,%ecx
  80054e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800551:	89 d0                	mov    %edx,%eax
  800553:	01 c0                	add    %eax,%eax
  800555:	01 d0                	add    %edx,%eax
  800557:	01 c0                	add    %eax,%eax
  800559:	01 d0                	add    %edx,%eax
  80055b:	89 c2                	mov    %eax,%edx
  80055d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800560:	c1 e0 04             	shl    $0x4,%eax
  800563:	01 d0                	add    %edx,%eax
  800565:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80056a:	39 c1                	cmp    %eax,%ecx
  80056c:	76 14                	jbe    800582 <_main+0x54a>
  80056e:	83 ec 04             	sub    $0x4,%esp
  800571:	68 90 21 80 00       	push   $0x802190
  800576:	6a 54                	push   $0x54
  800578:	68 7c 21 80 00       	push   $0x80217c
  80057d:	e8 9c 01 00 00       	call   80071e <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800582:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800585:	e8 fb 13 00 00       	call   801985 <sys_calculate_free_frames>
  80058a:	29 c3                	sub    %eax,%ebx
  80058c:	89 d8                	mov    %ebx,%eax
  80058e:	83 f8 01             	cmp    $0x1,%eax
  800591:	74 14                	je     8005a7 <_main+0x56f>
  800593:	83 ec 04             	sub    $0x4,%esp
  800596:	68 5a 22 80 00       	push   $0x80225a
  80059b:	6a 55                	push   $0x55
  80059d:	68 7c 21 80 00       	push   $0x80217c
  8005a2:	e8 77 01 00 00       	call   80071e <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8005a7:	e8 79 14 00 00       	call   801a25 <sys_pf_calculate_allocated_pages>
  8005ac:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8005af:	3d 00 02 00 00       	cmp    $0x200,%eax
  8005b4:	74 14                	je     8005ca <_main+0x592>
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	68 2c 22 80 00       	push   $0x80222c
  8005be:	6a 56                	push   $0x56
  8005c0:	68 7c 21 80 00       	push   $0x80217c
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 70 22 80 00       	push   $0x802270
  8005d2:	e8 fb 03 00 00       	call   8009d2 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp

	return;
  8005da:	90                   	nop
}
  8005db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005de:	5b                   	pop    %ebx
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    

008005e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005e8:	e8 78 16 00 00       	call   801c65 <sys_getenvindex>
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	c1 e0 03             	shl    $0x3,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	01 c0                	add    %eax,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800605:	01 d0                	add    %edx,%eax
  800607:	c1 e0 04             	shl    $0x4,%eax
  80060a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800614:	a1 20 30 80 00       	mov    0x803020,%eax
  800619:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80061f:	84 c0                	test   %al,%al
  800621:	74 0f                	je     800632 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800623:	a1 20 30 80 00       	mov    0x803020,%eax
  800628:	05 5c 05 00 00       	add    $0x55c,%eax
  80062d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800632:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800636:	7e 0a                	jle    800642 <libmain+0x60>
		binaryname = argv[0];
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	ff 75 08             	pushl  0x8(%ebp)
  80064b:	e8 e8 f9 ff ff       	call   800038 <_main>
  800650:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800653:	e8 1a 14 00 00       	call   801a72 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 c4 22 80 00       	push   $0x8022c4
  800660:	e8 6d 03 00 00       	call   8009d2 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800668:	a1 20 30 80 00       	mov    0x803020,%eax
  80066d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800673:	a1 20 30 80 00       	mov    0x803020,%eax
  800678:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	52                   	push   %edx
  800682:	50                   	push   %eax
  800683:	68 ec 22 80 00       	push   $0x8022ec
  800688:	e8 45 03 00 00       	call   8009d2 <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800690:	a1 20 30 80 00       	mov    0x803020,%eax
  800695:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80069b:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ab:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b1:	51                   	push   %ecx
  8006b2:	52                   	push   %edx
  8006b3:	50                   	push   %eax
  8006b4:	68 14 23 80 00       	push   $0x802314
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 6c 23 80 00       	push   $0x80236c
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 c4 22 80 00       	push   $0x8022c4
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 9a 13 00 00       	call   801a8c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006f2:	e8 19 00 00 00       	call   800710 <exit>
}
  8006f7:	90                   	nop
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800700:	83 ec 0c             	sub    $0xc,%esp
  800703:	6a 00                	push   $0x0
  800705:	e8 27 15 00 00       	call   801c31 <sys_destroy_env>
  80070a:	83 c4 10             	add    $0x10,%esp
}
  80070d:	90                   	nop
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <exit>:

void
exit(void)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800716:	e8 7c 15 00 00       	call   801c97 <sys_exit_env>
}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800724:	8d 45 10             	lea    0x10(%ebp),%eax
  800727:	83 c0 04             	add    $0x4,%eax
  80072a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80072d:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800732:	85 c0                	test   %eax,%eax
  800734:	74 16                	je     80074c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800736:	a1 5c 31 80 00       	mov    0x80315c,%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	50                   	push   %eax
  80073f:	68 80 23 80 00       	push   $0x802380
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 30 80 00       	mov    0x803000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 85 23 80 00       	push   $0x802385
  80075d:	e8 70 02 00 00       	call   8009d2 <cprintf>
  800762:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	ff 75 f4             	pushl  -0xc(%ebp)
  80076e:	50                   	push   %eax
  80076f:	e8 f3 01 00 00       	call   800967 <vcprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	6a 00                	push   $0x0
  80077c:	68 a1 23 80 00       	push   $0x8023a1
  800781:	e8 e1 01 00 00       	call   800967 <vcprintf>
  800786:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800789:	e8 82 ff ff ff       	call   800710 <exit>

	// should not return here
	while (1) ;
  80078e:	eb fe                	jmp    80078e <_panic+0x70>

00800790 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800796:	a1 20 30 80 00       	mov    0x803020,%eax
  80079b:	8b 50 74             	mov    0x74(%eax),%edx
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	39 c2                	cmp    %eax,%edx
  8007a3:	74 14                	je     8007b9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	68 a4 23 80 00       	push   $0x8023a4
  8007ad:	6a 26                	push   $0x26
  8007af:	68 f0 23 80 00       	push   $0x8023f0
  8007b4:	e8 65 ff ff ff       	call   80071e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007c7:	e9 c2 00 00 00       	jmp    80088e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	75 08                	jne    8007e9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007e4:	e9 a2 00 00 00       	jmp    80088b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007f7:	eb 69                	jmp    800862 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8007fe:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800804:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800807:	89 d0                	mov    %edx,%eax
  800809:	01 c0                	add    %eax,%eax
  80080b:	01 d0                	add    %edx,%eax
  80080d:	c1 e0 03             	shl    $0x3,%eax
  800810:	01 c8                	add    %ecx,%eax
  800812:	8a 40 04             	mov    0x4(%eax),%al
  800815:	84 c0                	test   %al,%al
  800817:	75 46                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800819:	a1 20 30 80 00       	mov    0x803020,%eax
  80081e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800824:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800827:	89 d0                	mov    %edx,%eax
  800829:	01 c0                	add    %eax,%eax
  80082b:	01 d0                	add    %edx,%eax
  80082d:	c1 e0 03             	shl    $0x3,%eax
  800830:	01 c8                	add    %ecx,%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80083a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80083f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800844:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	01 c8                	add    %ecx,%eax
  800850:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800852:	39 c2                	cmp    %eax,%edx
  800854:	75 09                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800856:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80085d:	eb 12                	jmp    800871 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085f:	ff 45 e8             	incl   -0x18(%ebp)
  800862:	a1 20 30 80 00       	mov    0x803020,%eax
  800867:	8b 50 74             	mov    0x74(%eax),%edx
  80086a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80086d:	39 c2                	cmp    %eax,%edx
  80086f:	77 88                	ja     8007f9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800871:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800875:	75 14                	jne    80088b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 fc 23 80 00       	push   $0x8023fc
  80087f:	6a 3a                	push   $0x3a
  800881:	68 f0 23 80 00       	push   $0x8023f0
  800886:	e8 93 fe ff ff       	call   80071e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80088b:	ff 45 f0             	incl   -0x10(%ebp)
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800894:	0f 8c 32 ff ff ff    	jl     8007cc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80089a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008a8:	eb 26                	jmp    8008d0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8008af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	01 c0                	add    %eax,%eax
  8008bc:	01 d0                	add    %edx,%eax
  8008be:	c1 e0 03             	shl    $0x3,%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8a 40 04             	mov    0x4(%eax),%al
  8008c6:	3c 01                	cmp    $0x1,%al
  8008c8:	75 03                	jne    8008cd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008ca:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cd:	ff 45 e0             	incl   -0x20(%ebp)
  8008d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8008d5:	8b 50 74             	mov    0x74(%eax),%edx
  8008d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008db:	39 c2                	cmp    %eax,%edx
  8008dd:	77 cb                	ja     8008aa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008e5:	74 14                	je     8008fb <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008e7:	83 ec 04             	sub    $0x4,%esp
  8008ea:	68 50 24 80 00       	push   $0x802450
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 f0 23 80 00       	push   $0x8023f0
  8008f6:	e8 23 fe ff ff       	call   80071e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800904:	8b 45 0c             	mov    0xc(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	8d 48 01             	lea    0x1(%eax),%ecx
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	89 0a                	mov    %ecx,(%edx)
  800911:	8b 55 08             	mov    0x8(%ebp),%edx
  800914:	88 d1                	mov    %dl,%cl
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
  800919:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	3d ff 00 00 00       	cmp    $0xff,%eax
  800927:	75 2c                	jne    800955 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800929:	a0 24 30 80 00       	mov    0x803024,%al
  80092e:	0f b6 c0             	movzbl %al,%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	8b 12                	mov    (%edx),%edx
  800936:	89 d1                	mov    %edx,%ecx
  800938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093b:	83 c2 08             	add    $0x8,%edx
  80093e:	83 ec 04             	sub    $0x4,%esp
  800941:	50                   	push   %eax
  800942:	51                   	push   %ecx
  800943:	52                   	push   %edx
  800944:	e8 7b 0f 00 00       	call   8018c4 <sys_cputs>
  800949:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	8b 40 04             	mov    0x4(%eax),%eax
  80095b:	8d 50 01             	lea    0x1(%eax),%edx
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	89 50 04             	mov    %edx,0x4(%eax)
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800970:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800977:	00 00 00 
	b.cnt = 0;
  80097a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800981:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800990:	50                   	push   %eax
  800991:	68 fe 08 80 00       	push   $0x8008fe
  800996:	e8 11 02 00 00       	call   800bac <vprintfmt>
  80099b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80099e:	a0 24 30 80 00       	mov    0x803024,%al
  8009a3:	0f b6 c0             	movzbl %al,%eax
  8009a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	50                   	push   %eax
  8009b0:	52                   	push   %edx
  8009b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	50                   	push   %eax
  8009bb:	e8 04 0f 00 00       	call   8018c4 <sys_cputs>
  8009c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009c3:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009d8:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	e8 73 ff ff ff       	call   800967 <vcprintf>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a05:	e8 68 10 00 00       	call   801a72 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a0a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 f4             	pushl  -0xc(%ebp)
  800a19:	50                   	push   %eax
  800a1a:	e8 48 ff ff ff       	call   800967 <vcprintf>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a25:	e8 62 10 00 00       	call   801a8c <sys_enable_interrupt>
	return cnt;
  800a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	53                   	push   %ebx
  800a33:	83 ec 14             	sub    $0x14,%esp
  800a36:	8b 45 10             	mov    0x10(%ebp),%eax
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a42:	8b 45 18             	mov    0x18(%ebp),%eax
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4d:	77 55                	ja     800aa4 <printnum+0x75>
  800a4f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a52:	72 05                	jb     800a59 <printnum+0x2a>
  800a54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a57:	77 4b                	ja     800aa4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a59:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a5c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a5f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	52                   	push   %edx
  800a68:	50                   	push   %eax
  800a69:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6f:	e8 84 14 00 00       	call   801ef8 <__udivdi3>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	ff 75 20             	pushl  0x20(%ebp)
  800a7d:	53                   	push   %ebx
  800a7e:	ff 75 18             	pushl  0x18(%ebp)
  800a81:	52                   	push   %edx
  800a82:	50                   	push   %eax
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 a1 ff ff ff       	call   800a2f <printnum>
  800a8e:	83 c4 20             	add    $0x20,%esp
  800a91:	eb 1a                	jmp    800aad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 20             	pushl  0x20(%ebp)
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa4:	ff 4d 1c             	decl   0x1c(%ebp)
  800aa7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aab:	7f e6                	jg     800a93 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abb:	53                   	push   %ebx
  800abc:	51                   	push   %ecx
  800abd:	52                   	push   %edx
  800abe:	50                   	push   %eax
  800abf:	e8 44 15 00 00       	call   802008 <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 b4 26 80 00       	add    $0x8026b4,%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	0f be c0             	movsbl %al,%eax
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
}
  800ae0:	90                   	nop
  800ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aed:	7e 1c                	jle    800b0b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	8d 50 08             	lea    0x8(%eax),%edx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	89 10                	mov    %edx,(%eax)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	83 e8 08             	sub    $0x8,%eax
  800b04:	8b 50 04             	mov    0x4(%eax),%edx
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	eb 40                	jmp    800b4b <getuint+0x65>
	else if (lflag)
  800b0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0f:	74 1e                	je     800b2f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8d 50 04             	lea    0x4(%eax),%edx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	89 10                	mov    %edx,(%eax)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	83 e8 04             	sub    $0x4,%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2d:	eb 1c                	jmp    800b4b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 50 04             	lea    0x4(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 10                	mov    %edx,(%eax)
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	83 e8 04             	sub    $0x4,%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b50:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b54:	7e 1c                	jle    800b72 <getint+0x25>
		return va_arg(*ap, long long);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	8d 50 08             	lea    0x8(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 10                	mov    %edx,(%eax)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	83 e8 08             	sub    $0x8,%eax
  800b6b:	8b 50 04             	mov    0x4(%eax),%edx
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	eb 38                	jmp    800baa <getint+0x5d>
	else if (lflag)
  800b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b76:	74 1a                	je     800b92 <getint+0x45>
		return va_arg(*ap, long);
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	8d 50 04             	lea    0x4(%eax),%edx
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 10                	mov    %edx,(%eax)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	83 e8 04             	sub    $0x4,%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	99                   	cltd   
  800b90:	eb 18                	jmp    800baa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	8d 50 04             	lea    0x4(%eax),%edx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 10                	mov    %edx,(%eax)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	83 e8 04             	sub    $0x4,%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	99                   	cltd   
}
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb4:	eb 17                	jmp    800bcd <vprintfmt+0x21>
			if (ch == '\0')
  800bb6:	85 db                	test   %ebx,%ebx
  800bb8:	0f 84 af 03 00 00    	je     800f6d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	53                   	push   %ebx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	8d 50 01             	lea    0x1(%eax),%edx
  800bd3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 d8             	movzbl %al,%ebx
  800bdb:	83 fb 25             	cmp    $0x25,%ebx
  800bde:	75 d6                	jne    800bb6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800be4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800beb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bf2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 10             	mov    %edx,0x10(%ebp)
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 d8             	movzbl %al,%ebx
  800c0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c11:	83 f8 55             	cmp    $0x55,%eax
  800c14:	0f 87 2b 03 00 00    	ja     800f45 <vprintfmt+0x399>
  800c1a:	8b 04 85 d8 26 80 00 	mov    0x8026d8(,%eax,4),%eax
  800c21:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c27:	eb d7                	jmp    800c00 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c2d:	eb d1                	jmp    800c00 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c39:	89 d0                	mov    %edx,%eax
  800c3b:	c1 e0 02             	shl    $0x2,%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	01 c0                	add    %eax,%eax
  800c42:	01 d8                	add    %ebx,%eax
  800c44:	83 e8 30             	sub    $0x30,%eax
  800c47:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c52:	83 fb 2f             	cmp    $0x2f,%ebx
  800c55:	7e 3e                	jle    800c95 <vprintfmt+0xe9>
  800c57:	83 fb 39             	cmp    $0x39,%ebx
  800c5a:	7f 39                	jg     800c95 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c5f:	eb d5                	jmp    800c36 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 e8 04             	sub    $0x4,%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c75:	eb 1f                	jmp    800c96 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7b:	79 83                	jns    800c00 <vprintfmt+0x54>
				width = 0;
  800c7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c84:	e9 77 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c89:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c90:	e9 6b ff ff ff       	jmp    800c00 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c95:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9a:	0f 89 60 ff ff ff    	jns    800c00 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ca6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cad:	e9 4e ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cb2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cb5:	e9 46 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	83 c0 04             	add    $0x4,%eax
  800cc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 e8 04             	sub    $0x4,%eax
  800cc9:	8b 00                	mov    (%eax),%eax
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 0c             	pushl  0xc(%ebp)
  800cd1:	50                   	push   %eax
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	ff d0                	call   *%eax
  800cd7:	83 c4 10             	add    $0x10,%esp
			break;
  800cda:	e9 89 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 e8 04             	sub    $0x4,%eax
  800cee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf0:	85 db                	test   %ebx,%ebx
  800cf2:	79 02                	jns    800cf6 <vprintfmt+0x14a>
				err = -err;
  800cf4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cf6:	83 fb 64             	cmp    $0x64,%ebx
  800cf9:	7f 0b                	jg     800d06 <vprintfmt+0x15a>
  800cfb:	8b 34 9d 20 25 80 00 	mov    0x802520(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 c5 26 80 00       	push   $0x8026c5
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 5e 02 00 00       	call   800f75 <printfmt>
  800d17:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d1a:	e9 49 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d1f:	56                   	push   %esi
  800d20:	68 ce 26 80 00       	push   $0x8026ce
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	ff 75 08             	pushl  0x8(%ebp)
  800d2b:	e8 45 02 00 00       	call   800f75 <printfmt>
  800d30:	83 c4 10             	add    $0x10,%esp
			break;
  800d33:	e9 30 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	83 c0 04             	add    $0x4,%eax
  800d3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 e8 04             	sub    $0x4,%eax
  800d47:	8b 30                	mov    (%eax),%esi
  800d49:	85 f6                	test   %esi,%esi
  800d4b:	75 05                	jne    800d52 <vprintfmt+0x1a6>
				p = "(null)";
  800d4d:	be d1 26 80 00       	mov    $0x8026d1,%esi
			if (width > 0 && padc != '-')
  800d52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d56:	7e 6d                	jle    800dc5 <vprintfmt+0x219>
  800d58:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d5c:	74 67                	je     800dc5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d61:	83 ec 08             	sub    $0x8,%esp
  800d64:	50                   	push   %eax
  800d65:	56                   	push   %esi
  800d66:	e8 0c 03 00 00       	call   801077 <strnlen>
  800d6b:	83 c4 10             	add    $0x10,%esp
  800d6e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d71:	eb 16                	jmp    800d89 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d73:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	50                   	push   %eax
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d86:	ff 4d e4             	decl   -0x1c(%ebp)
  800d89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8d:	7f e4                	jg     800d73 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8f:	eb 34                	jmp    800dc5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d95:	74 1c                	je     800db3 <vprintfmt+0x207>
  800d97:	83 fb 1f             	cmp    $0x1f,%ebx
  800d9a:	7e 05                	jle    800da1 <vprintfmt+0x1f5>
  800d9c:	83 fb 7e             	cmp    $0x7e,%ebx
  800d9f:	7e 12                	jle    800db3 <vprintfmt+0x207>
					putch('?', putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	6a 3f                	push   $0x3f
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	ff d0                	call   *%eax
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	eb 0f                	jmp    800dc2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	53                   	push   %ebx
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	ff d0                	call   *%eax
  800dbf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc2:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc5:	89 f0                	mov    %esi,%eax
  800dc7:	8d 70 01             	lea    0x1(%eax),%esi
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f be d8             	movsbl %al,%ebx
  800dcf:	85 db                	test   %ebx,%ebx
  800dd1:	74 24                	je     800df7 <vprintfmt+0x24b>
  800dd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd7:	78 b8                	js     800d91 <vprintfmt+0x1e5>
  800dd9:	ff 4d e0             	decl   -0x20(%ebp)
  800ddc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de0:	79 af                	jns    800d91 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de2:	eb 13                	jmp    800df7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	6a 20                	push   $0x20
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	ff d0                	call   *%eax
  800df1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df4:	ff 4d e4             	decl   -0x1c(%ebp)
  800df7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfb:	7f e7                	jg     800de4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dfd:	e9 66 01 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 e8             	pushl  -0x18(%ebp)
  800e08:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0b:	50                   	push   %eax
  800e0c:	e8 3c fd ff ff       	call   800b4d <getint>
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	85 d2                	test   %edx,%edx
  800e22:	79 23                	jns    800e47 <vprintfmt+0x29b>
				putch('-', putdat);
  800e24:	83 ec 08             	sub    $0x8,%esp
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	6a 2d                	push   $0x2d
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	ff d0                	call   *%eax
  800e31:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3a:	f7 d8                	neg    %eax
  800e3c:	83 d2 00             	adc    $0x0,%edx
  800e3f:	f7 da                	neg    %edx
  800e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e4e:	e9 bc 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e53:	83 ec 08             	sub    $0x8,%esp
  800e56:	ff 75 e8             	pushl  -0x18(%ebp)
  800e59:	8d 45 14             	lea    0x14(%ebp),%eax
  800e5c:	50                   	push   %eax
  800e5d:	e8 84 fc ff ff       	call   800ae6 <getuint>
  800e62:	83 c4 10             	add    $0x10,%esp
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e72:	e9 98 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	6a 58                	push   $0x58
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	ff 75 0c             	pushl  0xc(%ebp)
  800e8d:	6a 58                	push   $0x58
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	ff d0                	call   *%eax
  800e94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 58                	push   $0x58
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			break;
  800ea7:	e9 bc 00 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	6a 30                	push   $0x30
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	ff d0                	call   *%eax
  800eb9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	6a 78                	push   $0x78
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	83 c0 04             	add    $0x4,%eax
  800ed2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ee7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eee:	eb 1f                	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	e8 e7 fb ff ff       	call   800ae6 <getuint>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f0f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	52                   	push   %edx
  800f1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1d:	50                   	push   %eax
  800f1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f21:	ff 75 f0             	pushl  -0x10(%ebp)
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	ff 75 08             	pushl  0x8(%ebp)
  800f2a:	e8 00 fb ff ff       	call   800a2f <printnum>
  800f2f:	83 c4 20             	add    $0x20,%esp
			break;
  800f32:	eb 34                	jmp    800f68 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	53                   	push   %ebx
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	ff d0                	call   *%eax
  800f40:	83 c4 10             	add    $0x10,%esp
			break;
  800f43:	eb 23                	jmp    800f68 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	6a 25                	push   $0x25
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	ff d0                	call   *%eax
  800f52:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	eb 03                	jmp    800f5d <vprintfmt+0x3b1>
  800f5a:	ff 4d 10             	decl   0x10(%ebp)
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	48                   	dec    %eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 25                	cmp    $0x25,%al
  800f65:	75 f3                	jne    800f5a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f67:	90                   	nop
		}
	}
  800f68:	e9 47 fc ff ff       	jmp    800bb4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f6d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800f7e:	83 c0 04             	add    $0x4,%eax
  800f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8a:	50                   	push   %eax
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	ff 75 08             	pushl  0x8(%ebp)
  800f91:	e8 16 fc ff ff       	call   800bac <vprintfmt>
  800f96:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	8b 40 08             	mov    0x8(%eax),%eax
  800fa5:	8d 50 01             	lea    0x1(%eax),%edx
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8b 10                	mov    (%eax),%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8b 40 04             	mov    0x4(%eax),%eax
  800fb9:	39 c2                	cmp    %eax,%edx
  800fbb:	73 12                	jae    800fcf <sprintputch+0x33>
		*b->buf++ = ch;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8b 00                	mov    (%eax),%eax
  800fc2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc8:	89 0a                	mov    %ecx,(%edx)
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
}
  800fcf:	90                   	nop
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	01 d0                	add    %edx,%eax
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ff3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff7:	74 06                	je     800fff <vsnprintf+0x2d>
  800ff9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffd:	7f 07                	jg     801006 <vsnprintf+0x34>
		return -E_INVAL;
  800fff:	b8 03 00 00 00       	mov    $0x3,%eax
  801004:	eb 20                	jmp    801026 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801006:	ff 75 14             	pushl  0x14(%ebp)
  801009:	ff 75 10             	pushl  0x10(%ebp)
  80100c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80100f:	50                   	push   %eax
  801010:	68 9c 0f 80 00       	push   $0x800f9c
  801015:	e8 92 fb ff ff       	call   800bac <vprintfmt>
  80101a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80101d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801020:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801023:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80102e:	8d 45 10             	lea    0x10(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	ff 75 f4             	pushl  -0xc(%ebp)
  80103d:	50                   	push   %eax
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 89 ff ff ff       	call   800fd2 <vsnprintf>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80105a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801061:	eb 06                	jmp    801069 <strlen+0x15>
		n++;
  801063:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801066:	ff 45 08             	incl   0x8(%ebp)
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 f1                	jne    801063 <strlen+0xf>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801084:	eb 09                	jmp    80108f <strnlen+0x18>
		n++;
  801086:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801089:	ff 45 08             	incl   0x8(%ebp)
  80108c:	ff 4d 0c             	decl   0xc(%ebp)
  80108f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801093:	74 09                	je     80109e <strnlen+0x27>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	84 c0                	test   %al,%al
  80109c:	75 e8                	jne    801086 <strnlen+0xf>
		n++;
	return n;
  80109e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010af:	90                   	nop
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c2:	8a 12                	mov    (%edx),%dl
  8010c4:	88 10                	mov    %dl,(%eax)
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	84 c0                	test   %al,%al
  8010ca:	75 e4                	jne    8010b0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e4:	eb 1f                	jmp    801105 <strncpy+0x34>
		*dst++ = *src;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f2:	8a 12                	mov    (%edx),%dl
  8010f4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 03                	je     801102 <strncpy+0x31>
			src++;
  8010ff:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801102:	ff 45 fc             	incl   -0x4(%ebp)
  801105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801108:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110b:	72 d9                	jb     8010e6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80111e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801122:	74 30                	je     801154 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801124:	eb 16                	jmp    80113c <strlcpy+0x2a>
			*dst++ = *src++;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 08             	mov    %edx,0x8(%ebp)
  80112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801132:	8d 4a 01             	lea    0x1(%edx),%ecx
  801135:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801138:	8a 12                	mov    (%edx),%dl
  80113a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80113c:	ff 4d 10             	decl   0x10(%ebp)
  80113f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801143:	74 09                	je     80114e <strlcpy+0x3c>
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	75 d8                	jne    801126 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	29 c2                	sub    %eax,%edx
  80115c:	89 d0                	mov    %edx,%eax
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801163:	eb 06                	jmp    80116b <strcmp+0xb>
		p++, q++;
  801165:	ff 45 08             	incl   0x8(%ebp)
  801168:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	84 c0                	test   %al,%al
  801172:	74 0e                	je     801182 <strcmp+0x22>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 10                	mov    (%eax),%dl
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	38 c2                	cmp    %al,%dl
  801180:	74 e3                	je     801165 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d0             	movzbl %al,%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	0f b6 c0             	movzbl %al,%eax
  801192:	29 c2                	sub    %eax,%edx
  801194:	89 d0                	mov    %edx,%eax
}
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80119b:	eb 09                	jmp    8011a6 <strncmp+0xe>
		n--, p++, q++;
  80119d:	ff 4d 10             	decl   0x10(%ebp)
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011aa:	74 17                	je     8011c3 <strncmp+0x2b>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	84 c0                	test   %al,%al
  8011b3:	74 0e                	je     8011c3 <strncmp+0x2b>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 10                	mov    (%eax),%dl
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	38 c2                	cmp    %al,%dl
  8011c1:	74 da                	je     80119d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c7:	75 07                	jne    8011d0 <strncmp+0x38>
		return 0;
  8011c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ce:	eb 14                	jmp    8011e4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	29 c2                	sub    %eax,%edx
  8011e2:	89 d0                	mov    %edx,%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f2:	eb 12                	jmp    801206 <strchr+0x20>
		if (*s == c)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011fc:	75 05                	jne    801203 <strchr+0x1d>
			return (char *) s;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	eb 11                	jmp    801214 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	84 c0                	test   %al,%al
  80120d:	75 e5                	jne    8011f4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801222:	eb 0d                	jmp    801231 <strfind+0x1b>
		if (*s == c)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122c:	74 0e                	je     80123c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	84 c0                	test   %al,%al
  801238:	75 ea                	jne    801224 <strfind+0xe>
  80123a:	eb 01                	jmp    80123d <strfind+0x27>
		if (*s == c)
			break;
  80123c:	90                   	nop
	return (char *) s;
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801254:	eb 0e                	jmp    801264 <memset+0x22>
		*p++ = c;
  801256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801264:	ff 4d f8             	decl   -0x8(%ebp)
  801267:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80126b:	79 e9                	jns    801256 <memset+0x14>
		*p++ = c;

	return v;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801284:	eb 16                	jmp    80129c <memcpy+0x2a>
		*d++ = *s++;
  801286:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801289:	8d 50 01             	lea    0x1(%eax),%edx
  80128c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80128f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801292:	8d 4a 01             	lea    0x1(%edx),%ecx
  801295:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801298:	8a 12                	mov    (%edx),%dl
  80129a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	75 dd                	jne    801286 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c6:	73 50                	jae    801318 <memmove+0x6a>
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d3:	76 43                	jbe    801318 <memmove+0x6a>
		s += n;
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012e1:	eb 10                	jmp    8012f3 <memmove+0x45>
			*--d = *--s;
  8012e3:	ff 4d f8             	decl   -0x8(%ebp)
  8012e6:	ff 4d fc             	decl   -0x4(%ebp)
  8012e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ec:	8a 10                	mov    (%eax),%dl
  8012ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	75 e3                	jne    8012e3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801300:	eb 23                	jmp    801325 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	8d 50 01             	lea    0x1(%eax),%edx
  801308:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801311:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801314:	8a 12                	mov    (%edx),%dl
  801316:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131e:	89 55 10             	mov    %edx,0x10(%ebp)
  801321:	85 c0                	test   %eax,%eax
  801323:	75 dd                	jne    801302 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80133c:	eb 2a                	jmp    801368 <memcmp+0x3e>
		if (*s1 != *s2)
  80133e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801341:	8a 10                	mov    (%eax),%dl
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	38 c2                	cmp    %al,%dl
  80134a:	74 16                	je     801362 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80134c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	0f b6 d0             	movzbl %al,%edx
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	29 c2                	sub    %eax,%edx
  80135e:	89 d0                	mov    %edx,%eax
  801360:	eb 18                	jmp    80137a <memcmp+0x50>
		s1++, s2++;
  801362:	ff 45 fc             	incl   -0x4(%ebp)
  801365:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136e:	89 55 10             	mov    %edx,0x10(%ebp)
  801371:	85 c0                	test   %eax,%eax
  801373:	75 c9                	jne    80133e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	8b 45 10             	mov    0x10(%ebp),%eax
  801388:	01 d0                	add    %edx,%eax
  80138a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80138d:	eb 15                	jmp    8013a4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 d0             	movzbl %al,%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	0f b6 c0             	movzbl %al,%eax
  80139d:	39 c2                	cmp    %eax,%edx
  80139f:	74 0d                	je     8013ae <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a1:	ff 45 08             	incl   0x8(%ebp)
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013aa:	72 e3                	jb     80138f <memfind+0x13>
  8013ac:	eb 01                	jmp    8013af <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013ae:	90                   	nop
	return (void *) s;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c8:	eb 03                	jmp    8013cd <strtol+0x19>
		s++;
  8013ca:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 20                	cmp    $0x20,%al
  8013d4:	74 f4                	je     8013ca <strtol+0x16>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	3c 09                	cmp    $0x9,%al
  8013dd:	74 eb                	je     8013ca <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	3c 2b                	cmp    $0x2b,%al
  8013e6:	75 05                	jne    8013ed <strtol+0x39>
		s++;
  8013e8:	ff 45 08             	incl   0x8(%ebp)
  8013eb:	eb 13                	jmp    801400 <strtol+0x4c>
	else if (*s == '-')
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	3c 2d                	cmp    $0x2d,%al
  8013f4:	75 0a                	jne    801400 <strtol+0x4c>
		s++, neg = 1;
  8013f6:	ff 45 08             	incl   0x8(%ebp)
  8013f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801404:	74 06                	je     80140c <strtol+0x58>
  801406:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80140a:	75 20                	jne    80142c <strtol+0x78>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3c 30                	cmp    $0x30,%al
  801413:	75 17                	jne    80142c <strtol+0x78>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	40                   	inc    %eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 78                	cmp    $0x78,%al
  80141d:	75 0d                	jne    80142c <strtol+0x78>
		s += 2, base = 16;
  80141f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801423:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80142a:	eb 28                	jmp    801454 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80142c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801430:	75 15                	jne    801447 <strtol+0x93>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3c 30                	cmp    $0x30,%al
  801439:	75 0c                	jne    801447 <strtol+0x93>
		s++, base = 8;
  80143b:	ff 45 08             	incl   0x8(%ebp)
  80143e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801445:	eb 0d                	jmp    801454 <strtol+0xa0>
	else if (base == 0)
  801447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144b:	75 07                	jne    801454 <strtol+0xa0>
		base = 10;
  80144d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 2f                	cmp    $0x2f,%al
  80145b:	7e 19                	jle    801476 <strtol+0xc2>
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 39                	cmp    $0x39,%al
  801464:	7f 10                	jg     801476 <strtol+0xc2>
			dig = *s - '0';
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	0f be c0             	movsbl %al,%eax
  80146e:	83 e8 30             	sub    $0x30,%eax
  801471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801474:	eb 42                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	3c 60                	cmp    $0x60,%al
  80147d:	7e 19                	jle    801498 <strtol+0xe4>
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 7a                	cmp    $0x7a,%al
  801486:	7f 10                	jg     801498 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	0f be c0             	movsbl %al,%eax
  801490:	83 e8 57             	sub    $0x57,%eax
  801493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801496:	eb 20                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 40                	cmp    $0x40,%al
  80149f:	7e 39                	jle    8014da <strtol+0x126>
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3c 5a                	cmp    $0x5a,%al
  8014a8:	7f 30                	jg     8014da <strtol+0x126>
			dig = *s - 'A' + 10;
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	0f be c0             	movsbl %al,%eax
  8014b2:	83 e8 37             	sub    $0x37,%eax
  8014b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014be:	7d 19                	jge    8014d9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014c0:	ff 45 08             	incl   0x8(%ebp)
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ca:	89 c2                	mov    %eax,%edx
  8014cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d4:	e9 7b ff ff ff       	jmp    801454 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014d9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014de:	74 08                	je     8014e8 <strtol+0x134>
		*endptr = (char *) s;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ec:	74 07                	je     8014f5 <strtol+0x141>
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	f7 d8                	neg    %eax
  8014f3:	eb 03                	jmp    8014f8 <strtol+0x144>
  8014f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <ltostr>:

void
ltostr(long value, char *str)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801507:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80150e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801512:	79 13                	jns    801527 <ltostr+0x2d>
	{
		neg = 1;
  801514:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801521:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801524:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80152f:	99                   	cltd   
  801530:	f7 f9                	idiv   %ecx
  801532:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801538:	8d 50 01             	lea    0x1(%eax),%edx
  80153b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153e:	89 c2                	mov    %eax,%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801548:	83 c2 30             	add    $0x30,%edx
  80154b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80154d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801550:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801555:	f7 e9                	imul   %ecx
  801557:	c1 fa 02             	sar    $0x2,%edx
  80155a:	89 c8                	mov    %ecx,%eax
  80155c:	c1 f8 1f             	sar    $0x1f,%eax
  80155f:	29 c2                	sub    %eax,%edx
  801561:	89 d0                	mov    %edx,%eax
  801563:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801569:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80156e:	f7 e9                	imul   %ecx
  801570:	c1 fa 02             	sar    $0x2,%edx
  801573:	89 c8                	mov    %ecx,%eax
  801575:	c1 f8 1f             	sar    $0x1f,%eax
  801578:	29 c2                	sub    %eax,%edx
  80157a:	89 d0                	mov    %edx,%eax
  80157c:	c1 e0 02             	shl    $0x2,%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	01 c0                	add    %eax,%eax
  801583:	29 c1                	sub    %eax,%ecx
  801585:	89 ca                	mov    %ecx,%edx
  801587:	85 d2                	test   %edx,%edx
  801589:	75 9c                	jne    801527 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80158b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801592:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801595:	48                   	dec    %eax
  801596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801599:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80159d:	74 3d                	je     8015dc <ltostr+0xe2>
		start = 1 ;
  80159f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015a6:	eb 34                	jmp    8015dc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	01 d0                	add    %edx,%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 c2                	add    %eax,%edx
  8015bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 c8                	add    %ecx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 c2                	add    %eax,%edx
  8015d1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015d4:	88 02                	mov    %al,(%edx)
		start++ ;
  8015d6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015d9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e2:	7c c4                	jl     8015a8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	e8 54 fa ff ff       	call   801054 <strlen>
  801600:	83 c4 04             	add    $0x4,%esp
  801603:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	e8 46 fa ff ff       	call   801054 <strlen>
  80160e:	83 c4 04             	add    $0x4,%esp
  801611:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801614:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80161b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801622:	eb 17                	jmp    80163b <strcconcat+0x49>
		final[s] = str1[s] ;
  801624:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	01 c2                	add    %eax,%edx
  80162c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	01 c8                	add    %ecx,%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801638:	ff 45 fc             	incl   -0x4(%ebp)
  80163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801641:	7c e1                	jl     801624 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801643:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80164a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801651:	eb 1f                	jmp    801672 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801656:	8d 50 01             	lea    0x1(%eax),%edx
  801659:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80165c:	89 c2                	mov    %eax,%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 c2                	add    %eax,%edx
  801663:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 c8                	add    %ecx,%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80166f:	ff 45 f8             	incl   -0x8(%ebp)
  801672:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801675:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801678:	7c d9                	jl     801653 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80167a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	c6 00 00             	movb   $0x0,(%eax)
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80168b:	8b 45 14             	mov    0x14(%ebp),%eax
  80168e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	01 d0                	add    %edx,%eax
  8016a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ab:	eb 0c                	jmp    8016b9 <strsplit+0x31>
			*string++ = 0;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8d 50 01             	lea    0x1(%eax),%edx
  8016b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	84 c0                	test   %al,%al
  8016c0:	74 18                	je     8016da <strsplit+0x52>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	e8 13 fb ff ff       	call   8011e6 <strchr>
  8016d3:	83 c4 08             	add    $0x8,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	75 d3                	jne    8016ad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 5a                	je     80173d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	83 f8 0f             	cmp    $0xf,%eax
  8016eb:	75 07                	jne    8016f4 <strsplit+0x6c>
		{
			return 0;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 66                	jmp    80175a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8016fc:	8b 55 14             	mov    0x14(%ebp),%edx
  8016ff:	89 0a                	mov    %ecx,(%edx)
  801701:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	01 c2                	add    %eax,%edx
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801712:	eb 03                	jmp    801717 <strsplit+0x8f>
			string++;
  801714:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	84 c0                	test   %al,%al
  80171e:	74 8b                	je     8016ab <strsplit+0x23>
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	0f be c0             	movsbl %al,%eax
  801728:	50                   	push   %eax
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	e8 b5 fa ff ff       	call   8011e6 <strchr>
  801731:	83 c4 08             	add    $0x8,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	74 dc                	je     801714 <strsplit+0x8c>
			string++;
	}
  801738:	e9 6e ff ff ff       	jmp    8016ab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80173d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80173e:	8b 45 14             	mov    0x14(%ebp),%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80174a:	8b 45 10             	mov    0x10(%ebp),%eax
  80174d:	01 d0                	add    %edx,%eax
  80174f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801755:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	68 30 28 80 00       	push   $0x802830
  80176a:	6a 0e                	push   $0xe
  80176c:	68 6a 28 80 00       	push   $0x80286a
  801771:	e8 a8 ef ff ff       	call   80071e <_panic>

00801776 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80177c:	a1 04 30 80 00       	mov    0x803004,%eax
  801781:	85 c0                	test   %eax,%eax
  801783:	74 0f                	je     801794 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801785:	e8 d2 ff ff ff       	call   80175c <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80178a:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801791:	00 00 00 
	}
	if (size == 0) return NULL ;
  801794:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801798:	75 07                	jne    8017a1 <malloc+0x2b>
  80179a:	b8 00 00 00 00       	mov    $0x0,%eax
  80179f:	eb 14                	jmp    8017b5 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8017a1:	83 ec 04             	sub    $0x4,%esp
  8017a4:	68 78 28 80 00       	push   $0x802878
  8017a9:	6a 2e                	push   $0x2e
  8017ab:	68 6a 28 80 00       	push   $0x80286a
  8017b0:	e8 69 ef ff ff       	call   80071e <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	68 a0 28 80 00       	push   $0x8028a0
  8017c5:	6a 49                	push   $0x49
  8017c7:	68 6a 28 80 00       	push   $0x80286a
  8017cc:	e8 4d ef ff ff       	call   80071e <_panic>

008017d1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	83 ec 18             	sub    $0x18,%esp
  8017d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017da:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8017dd:	83 ec 04             	sub    $0x4,%esp
  8017e0:	68 c4 28 80 00       	push   $0x8028c4
  8017e5:	6a 57                	push   $0x57
  8017e7:	68 6a 28 80 00       	push   $0x80286a
  8017ec:	e8 2d ef ff ff       	call   80071e <_panic>

008017f1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	68 ec 28 80 00       	push   $0x8028ec
  8017ff:	6a 60                	push   $0x60
  801801:	68 6a 28 80 00       	push   $0x80286a
  801806:	e8 13 ef ff ff       	call   80071e <_panic>

0080180b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	68 10 29 80 00       	push   $0x802910
  801819:	6a 7c                	push   $0x7c
  80181b:	68 6a 28 80 00       	push   $0x80286a
  801820:	e8 f9 ee ff ff       	call   80071e <_panic>

00801825 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	68 38 29 80 00       	push   $0x802938
  801833:	68 86 00 00 00       	push   $0x86
  801838:	68 6a 28 80 00       	push   $0x80286a
  80183d:	e8 dc ee ff ff       	call   80071e <_panic>

00801842 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	68 5c 29 80 00       	push   $0x80295c
  801850:	68 91 00 00 00       	push   $0x91
  801855:	68 6a 28 80 00       	push   $0x80286a
  80185a:	e8 bf ee ff ff       	call   80071e <_panic>

0080185f <shrink>:

}
void shrink(uint32 newSize)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	68 5c 29 80 00       	push   $0x80295c
  80186d:	68 96 00 00 00       	push   $0x96
  801872:	68 6a 28 80 00       	push   $0x80286a
  801877:	e8 a2 ee ff ff       	call   80071e <_panic>

0080187c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	68 5c 29 80 00       	push   $0x80295c
  80188a:	68 9b 00 00 00       	push   $0x9b
  80188f:	68 6a 28 80 00       	push   $0x80286a
  801894:	e8 85 ee ff ff       	call   80071e <_panic>

00801899 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	57                   	push   %edi
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ae:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018b1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018b4:	cd 30                	int    $0x30
  8018b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5f                   	pop    %edi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    

008018c4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 04             	sub    $0x4,%esp
  8018ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	52                   	push   %edx
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	50                   	push   %eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	e8 b2 ff ff ff       	call   801899 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	90                   	nop
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_cgetc>:

int
sys_cgetc(void)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 01                	push   $0x1
  8018fc:	e8 98 ff ff ff       	call   801899 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	52                   	push   %edx
  801916:	50                   	push   %eax
  801917:	6a 05                	push   $0x5
  801919:	e8 7b ff ff ff       	call   801899 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	56                   	push   %esi
  801927:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801928:	8b 75 18             	mov    0x18(%ebp),%esi
  80192b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80192e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801931:	8b 55 0c             	mov    0xc(%ebp),%edx
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	56                   	push   %esi
  801938:	53                   	push   %ebx
  801939:	51                   	push   %ecx
  80193a:	52                   	push   %edx
  80193b:	50                   	push   %eax
  80193c:	6a 06                	push   $0x6
  80193e:	e8 56 ff ff ff       	call   801899 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    

0080194d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801950:	8b 55 0c             	mov    0xc(%ebp),%edx
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	52                   	push   %edx
  80195d:	50                   	push   %eax
  80195e:	6a 07                	push   $0x7
  801960:	e8 34 ff ff ff       	call   801899 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	ff 75 08             	pushl  0x8(%ebp)
  801979:	6a 08                	push   $0x8
  80197b:	e8 19 ff ff ff       	call   801899 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 09                	push   $0x9
  801994:	e8 00 ff ff ff       	call   801899 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 0a                	push   $0xa
  8019ad:	e8 e7 fe ff ff       	call   801899 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 0b                	push   $0xb
  8019c6:	e8 ce fe ff ff       	call   801899 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	ff 75 08             	pushl  0x8(%ebp)
  8019df:	6a 0f                	push   $0xf
  8019e1:	e8 b3 fe ff ff       	call   801899 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
	return;
  8019e9:	90                   	nop
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	6a 10                	push   $0x10
  8019fd:	e8 97 fe ff ff       	call   801899 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
	return ;
  801a05:	90                   	nop
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	ff 75 10             	pushl  0x10(%ebp)
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	ff 75 08             	pushl  0x8(%ebp)
  801a18:	6a 11                	push   $0x11
  801a1a:	e8 7a fe ff ff       	call   801899 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a22:	90                   	nop
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 0c                	push   $0xc
  801a34:	e8 60 fe ff ff       	call   801899 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	ff 75 08             	pushl  0x8(%ebp)
  801a4c:	6a 0d                	push   $0xd
  801a4e:	e8 46 fe ff ff       	call   801899 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 0e                	push   $0xe
  801a67:	e8 2d fe ff ff       	call   801899 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	90                   	nop
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 13                	push   $0x13
  801a81:	e8 13 fe ff ff       	call   801899 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	90                   	nop
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 14                	push   $0x14
  801a9b:	e8 f9 fd ff ff       	call   801899 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	90                   	nop
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_cputc>:


void
sys_cputc(const char c)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ab2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	50                   	push   %eax
  801abf:	6a 15                	push   $0x15
  801ac1:	e8 d3 fd ff ff       	call   801899 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	90                   	nop
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 16                	push   $0x16
  801adb:	e8 b9 fd ff ff       	call   801899 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	90                   	nop
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	50                   	push   %eax
  801af6:	6a 17                	push   $0x17
  801af8:	e8 9c fd ff ff       	call   801899 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	52                   	push   %edx
  801b12:	50                   	push   %eax
  801b13:	6a 1a                	push   $0x1a
  801b15:	e8 7f fd ff ff       	call   801899 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	52                   	push   %edx
  801b2f:	50                   	push   %eax
  801b30:	6a 18                	push   $0x18
  801b32:	e8 62 fd ff ff       	call   801899 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	90                   	nop
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	52                   	push   %edx
  801b4d:	50                   	push   %eax
  801b4e:	6a 19                	push   $0x19
  801b50:	e8 44 fd ff ff       	call   801899 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 04             	sub    $0x4,%esp
  801b61:	8b 45 10             	mov    0x10(%ebp),%eax
  801b64:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b67:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b6a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	6a 00                	push   $0x0
  801b73:	51                   	push   %ecx
  801b74:	52                   	push   %edx
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	50                   	push   %eax
  801b79:	6a 1b                	push   $0x1b
  801b7b:	e8 19 fd ff ff       	call   801899 <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	52                   	push   %edx
  801b95:	50                   	push   %eax
  801b96:	6a 1c                	push   $0x1c
  801b98:	e8 fc fc ff ff       	call   801899 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ba5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	51                   	push   %ecx
  801bb3:	52                   	push   %edx
  801bb4:	50                   	push   %eax
  801bb5:	6a 1d                	push   $0x1d
  801bb7:	e8 dd fc ff ff       	call   801899 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	52                   	push   %edx
  801bd1:	50                   	push   %eax
  801bd2:	6a 1e                	push   $0x1e
  801bd4:	e8 c0 fc ff ff       	call   801899 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 1f                	push   $0x1f
  801bed:	e8 a7 fc ff ff       	call   801899 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	6a 00                	push   $0x0
  801bff:	ff 75 14             	pushl  0x14(%ebp)
  801c02:	ff 75 10             	pushl  0x10(%ebp)
  801c05:	ff 75 0c             	pushl  0xc(%ebp)
  801c08:	50                   	push   %eax
  801c09:	6a 20                	push   $0x20
  801c0b:	e8 89 fc ff ff       	call   801899 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	50                   	push   %eax
  801c24:	6a 21                	push   $0x21
  801c26:	e8 6e fc ff ff       	call   801899 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	90                   	nop
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	50                   	push   %eax
  801c40:	6a 22                	push   $0x22
  801c42:	e8 52 fc ff ff       	call   801899 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 02                	push   $0x2
  801c5b:	e8 39 fc ff ff       	call   801899 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 03                	push   $0x3
  801c74:	e8 20 fc ff ff       	call   801899 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 04                	push   $0x4
  801c8d:	e8 07 fc ff ff       	call   801899 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_exit_env>:


void sys_exit_env(void)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 23                	push   $0x23
  801ca6:	e8 ee fb ff ff       	call   801899 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	90                   	nop
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cb7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cba:	8d 50 04             	lea    0x4(%eax),%edx
  801cbd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	52                   	push   %edx
  801cc7:	50                   	push   %eax
  801cc8:	6a 24                	push   $0x24
  801cca:	e8 ca fb ff ff       	call   801899 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
	return result;
  801cd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cdb:	89 01                	mov    %eax,(%ecx)
  801cdd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	c9                   	leave  
  801ce4:	c2 04 00             	ret    $0x4

00801ce7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	ff 75 10             	pushl  0x10(%ebp)
  801cf1:	ff 75 0c             	pushl  0xc(%ebp)
  801cf4:	ff 75 08             	pushl  0x8(%ebp)
  801cf7:	6a 12                	push   $0x12
  801cf9:	e8 9b fb ff ff       	call   801899 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801d01:	90                   	nop
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 25                	push   $0x25
  801d13:	e8 81 fb ff ff       	call   801899 <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 04             	sub    $0x4,%esp
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d29:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	50                   	push   %eax
  801d36:	6a 26                	push   $0x26
  801d38:	e8 5c fb ff ff       	call   801899 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d40:	90                   	nop
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <rsttst>:
void rsttst()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 28                	push   $0x28
  801d52:	e8 42 fb ff ff       	call   801899 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5a:	90                   	nop
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	8b 45 14             	mov    0x14(%ebp),%eax
  801d66:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d69:	8b 55 18             	mov    0x18(%ebp),%edx
  801d6c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d70:	52                   	push   %edx
  801d71:	50                   	push   %eax
  801d72:	ff 75 10             	pushl  0x10(%ebp)
  801d75:	ff 75 0c             	pushl  0xc(%ebp)
  801d78:	ff 75 08             	pushl  0x8(%ebp)
  801d7b:	6a 27                	push   $0x27
  801d7d:	e8 17 fb ff ff       	call   801899 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
	return ;
  801d85:	90                   	nop
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <chktst>:
void chktst(uint32 n)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	ff 75 08             	pushl  0x8(%ebp)
  801d96:	6a 29                	push   $0x29
  801d98:	e8 fc fa ff ff       	call   801899 <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801da0:	90                   	nop
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <inctst>:

void inctst()
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 2a                	push   $0x2a
  801db2:	e8 e2 fa ff ff       	call   801899 <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dba:	90                   	nop
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <gettst>:
uint32 gettst()
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 2b                	push   $0x2b
  801dcc:	e8 c8 fa ff ff       	call   801899 <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 2c                	push   $0x2c
  801de8:	e8 ac fa ff ff       	call   801899 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
  801df0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801df3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801df7:	75 07                	jne    801e00 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801df9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfe:	eb 05                	jmp    801e05 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 2c                	push   $0x2c
  801e19:	e8 7b fa ff ff       	call   801899 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
  801e21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e24:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e28:	75 07                	jne    801e31 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2f:	eb 05                	jmp    801e36 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 2c                	push   $0x2c
  801e4a:	e8 4a fa ff ff       	call   801899 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
  801e52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e55:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e59:	75 07                	jne    801e62 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e60:	eb 05                	jmp    801e67 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 2c                	push   $0x2c
  801e7b:	e8 19 fa ff ff       	call   801899 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
  801e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e86:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e8a:	75 07                	jne    801e93 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e91:	eb 05                	jmp    801e98 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	ff 75 08             	pushl  0x8(%ebp)
  801ea8:	6a 2d                	push   $0x2d
  801eaa:	e8 ea f9 ff ff       	call   801899 <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb2:	90                   	nop
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ebc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	6a 00                	push   $0x0
  801ec7:	53                   	push   %ebx
  801ec8:	51                   	push   %ecx
  801ec9:	52                   	push   %edx
  801eca:	50                   	push   %eax
  801ecb:	6a 2e                	push   $0x2e
  801ecd:	e8 c7 f9 ff ff       	call   801899 <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801edd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	52                   	push   %edx
  801eea:	50                   	push   %eax
  801eeb:	6a 2f                	push   $0x2f
  801eed:	e8 a7 f9 ff ff       	call   801899 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    
  801ef7:	90                   	nop

00801ef8 <__udivdi3>:
  801ef8:	55                   	push   %ebp
  801ef9:	57                   	push   %edi
  801efa:	56                   	push   %esi
  801efb:	53                   	push   %ebx
  801efc:	83 ec 1c             	sub    $0x1c,%esp
  801eff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f0f:	89 ca                	mov    %ecx,%edx
  801f11:	89 f8                	mov    %edi,%eax
  801f13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f17:	85 f6                	test   %esi,%esi
  801f19:	75 2d                	jne    801f48 <__udivdi3+0x50>
  801f1b:	39 cf                	cmp    %ecx,%edi
  801f1d:	77 65                	ja     801f84 <__udivdi3+0x8c>
  801f1f:	89 fd                	mov    %edi,%ebp
  801f21:	85 ff                	test   %edi,%edi
  801f23:	75 0b                	jne    801f30 <__udivdi3+0x38>
  801f25:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2a:	31 d2                	xor    %edx,%edx
  801f2c:	f7 f7                	div    %edi
  801f2e:	89 c5                	mov    %eax,%ebp
  801f30:	31 d2                	xor    %edx,%edx
  801f32:	89 c8                	mov    %ecx,%eax
  801f34:	f7 f5                	div    %ebp
  801f36:	89 c1                	mov    %eax,%ecx
  801f38:	89 d8                	mov    %ebx,%eax
  801f3a:	f7 f5                	div    %ebp
  801f3c:	89 cf                	mov    %ecx,%edi
  801f3e:	89 fa                	mov    %edi,%edx
  801f40:	83 c4 1c             	add    $0x1c,%esp
  801f43:	5b                   	pop    %ebx
  801f44:	5e                   	pop    %esi
  801f45:	5f                   	pop    %edi
  801f46:	5d                   	pop    %ebp
  801f47:	c3                   	ret    
  801f48:	39 ce                	cmp    %ecx,%esi
  801f4a:	77 28                	ja     801f74 <__udivdi3+0x7c>
  801f4c:	0f bd fe             	bsr    %esi,%edi
  801f4f:	83 f7 1f             	xor    $0x1f,%edi
  801f52:	75 40                	jne    801f94 <__udivdi3+0x9c>
  801f54:	39 ce                	cmp    %ecx,%esi
  801f56:	72 0a                	jb     801f62 <__udivdi3+0x6a>
  801f58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f5c:	0f 87 9e 00 00 00    	ja     802000 <__udivdi3+0x108>
  801f62:	b8 01 00 00 00       	mov    $0x1,%eax
  801f67:	89 fa                	mov    %edi,%edx
  801f69:	83 c4 1c             	add    $0x1c,%esp
  801f6c:	5b                   	pop    %ebx
  801f6d:	5e                   	pop    %esi
  801f6e:	5f                   	pop    %edi
  801f6f:	5d                   	pop    %ebp
  801f70:	c3                   	ret    
  801f71:	8d 76 00             	lea    0x0(%esi),%esi
  801f74:	31 ff                	xor    %edi,%edi
  801f76:	31 c0                	xor    %eax,%eax
  801f78:	89 fa                	mov    %edi,%edx
  801f7a:	83 c4 1c             	add    $0x1c,%esp
  801f7d:	5b                   	pop    %ebx
  801f7e:	5e                   	pop    %esi
  801f7f:	5f                   	pop    %edi
  801f80:	5d                   	pop    %ebp
  801f81:	c3                   	ret    
  801f82:	66 90                	xchg   %ax,%ax
  801f84:	89 d8                	mov    %ebx,%eax
  801f86:	f7 f7                	div    %edi
  801f88:	31 ff                	xor    %edi,%edi
  801f8a:	89 fa                	mov    %edi,%edx
  801f8c:	83 c4 1c             	add    $0x1c,%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5f                   	pop    %edi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    
  801f94:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f99:	89 eb                	mov    %ebp,%ebx
  801f9b:	29 fb                	sub    %edi,%ebx
  801f9d:	89 f9                	mov    %edi,%ecx
  801f9f:	d3 e6                	shl    %cl,%esi
  801fa1:	89 c5                	mov    %eax,%ebp
  801fa3:	88 d9                	mov    %bl,%cl
  801fa5:	d3 ed                	shr    %cl,%ebp
  801fa7:	89 e9                	mov    %ebp,%ecx
  801fa9:	09 f1                	or     %esi,%ecx
  801fab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801faf:	89 f9                	mov    %edi,%ecx
  801fb1:	d3 e0                	shl    %cl,%eax
  801fb3:	89 c5                	mov    %eax,%ebp
  801fb5:	89 d6                	mov    %edx,%esi
  801fb7:	88 d9                	mov    %bl,%cl
  801fb9:	d3 ee                	shr    %cl,%esi
  801fbb:	89 f9                	mov    %edi,%ecx
  801fbd:	d3 e2                	shl    %cl,%edx
  801fbf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fc3:	88 d9                	mov    %bl,%cl
  801fc5:	d3 e8                	shr    %cl,%eax
  801fc7:	09 c2                	or     %eax,%edx
  801fc9:	89 d0                	mov    %edx,%eax
  801fcb:	89 f2                	mov    %esi,%edx
  801fcd:	f7 74 24 0c          	divl   0xc(%esp)
  801fd1:	89 d6                	mov    %edx,%esi
  801fd3:	89 c3                	mov    %eax,%ebx
  801fd5:	f7 e5                	mul    %ebp
  801fd7:	39 d6                	cmp    %edx,%esi
  801fd9:	72 19                	jb     801ff4 <__udivdi3+0xfc>
  801fdb:	74 0b                	je     801fe8 <__udivdi3+0xf0>
  801fdd:	89 d8                	mov    %ebx,%eax
  801fdf:	31 ff                	xor    %edi,%edi
  801fe1:	e9 58 ff ff ff       	jmp    801f3e <__udivdi3+0x46>
  801fe6:	66 90                	xchg   %ax,%ax
  801fe8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fec:	89 f9                	mov    %edi,%ecx
  801fee:	d3 e2                	shl    %cl,%edx
  801ff0:	39 c2                	cmp    %eax,%edx
  801ff2:	73 e9                	jae    801fdd <__udivdi3+0xe5>
  801ff4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ff7:	31 ff                	xor    %edi,%edi
  801ff9:	e9 40 ff ff ff       	jmp    801f3e <__udivdi3+0x46>
  801ffe:	66 90                	xchg   %ax,%ax
  802000:	31 c0                	xor    %eax,%eax
  802002:	e9 37 ff ff ff       	jmp    801f3e <__udivdi3+0x46>
  802007:	90                   	nop

00802008 <__umoddi3>:
  802008:	55                   	push   %ebp
  802009:	57                   	push   %edi
  80200a:	56                   	push   %esi
  80200b:	53                   	push   %ebx
  80200c:	83 ec 1c             	sub    $0x1c,%esp
  80200f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802013:	8b 74 24 34          	mov    0x34(%esp),%esi
  802017:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80201b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80201f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802023:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802027:	89 f3                	mov    %esi,%ebx
  802029:	89 fa                	mov    %edi,%edx
  80202b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80202f:	89 34 24             	mov    %esi,(%esp)
  802032:	85 c0                	test   %eax,%eax
  802034:	75 1a                	jne    802050 <__umoddi3+0x48>
  802036:	39 f7                	cmp    %esi,%edi
  802038:	0f 86 a2 00 00 00    	jbe    8020e0 <__umoddi3+0xd8>
  80203e:	89 c8                	mov    %ecx,%eax
  802040:	89 f2                	mov    %esi,%edx
  802042:	f7 f7                	div    %edi
  802044:	89 d0                	mov    %edx,%eax
  802046:	31 d2                	xor    %edx,%edx
  802048:	83 c4 1c             	add    $0x1c,%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5f                   	pop    %edi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    
  802050:	39 f0                	cmp    %esi,%eax
  802052:	0f 87 ac 00 00 00    	ja     802104 <__umoddi3+0xfc>
  802058:	0f bd e8             	bsr    %eax,%ebp
  80205b:	83 f5 1f             	xor    $0x1f,%ebp
  80205e:	0f 84 ac 00 00 00    	je     802110 <__umoddi3+0x108>
  802064:	bf 20 00 00 00       	mov    $0x20,%edi
  802069:	29 ef                	sub    %ebp,%edi
  80206b:	89 fe                	mov    %edi,%esi
  80206d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802071:	89 e9                	mov    %ebp,%ecx
  802073:	d3 e0                	shl    %cl,%eax
  802075:	89 d7                	mov    %edx,%edi
  802077:	89 f1                	mov    %esi,%ecx
  802079:	d3 ef                	shr    %cl,%edi
  80207b:	09 c7                	or     %eax,%edi
  80207d:	89 e9                	mov    %ebp,%ecx
  80207f:	d3 e2                	shl    %cl,%edx
  802081:	89 14 24             	mov    %edx,(%esp)
  802084:	89 d8                	mov    %ebx,%eax
  802086:	d3 e0                	shl    %cl,%eax
  802088:	89 c2                	mov    %eax,%edx
  80208a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80208e:	d3 e0                	shl    %cl,%eax
  802090:	89 44 24 04          	mov    %eax,0x4(%esp)
  802094:	8b 44 24 08          	mov    0x8(%esp),%eax
  802098:	89 f1                	mov    %esi,%ecx
  80209a:	d3 e8                	shr    %cl,%eax
  80209c:	09 d0                	or     %edx,%eax
  80209e:	d3 eb                	shr    %cl,%ebx
  8020a0:	89 da                	mov    %ebx,%edx
  8020a2:	f7 f7                	div    %edi
  8020a4:	89 d3                	mov    %edx,%ebx
  8020a6:	f7 24 24             	mull   (%esp)
  8020a9:	89 c6                	mov    %eax,%esi
  8020ab:	89 d1                	mov    %edx,%ecx
  8020ad:	39 d3                	cmp    %edx,%ebx
  8020af:	0f 82 87 00 00 00    	jb     80213c <__umoddi3+0x134>
  8020b5:	0f 84 91 00 00 00    	je     80214c <__umoddi3+0x144>
  8020bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020bf:	29 f2                	sub    %esi,%edx
  8020c1:	19 cb                	sbb    %ecx,%ebx
  8020c3:	89 d8                	mov    %ebx,%eax
  8020c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020c9:	d3 e0                	shl    %cl,%eax
  8020cb:	89 e9                	mov    %ebp,%ecx
  8020cd:	d3 ea                	shr    %cl,%edx
  8020cf:	09 d0                	or     %edx,%eax
  8020d1:	89 e9                	mov    %ebp,%ecx
  8020d3:	d3 eb                	shr    %cl,%ebx
  8020d5:	89 da                	mov    %ebx,%edx
  8020d7:	83 c4 1c             	add    $0x1c,%esp
  8020da:	5b                   	pop    %ebx
  8020db:	5e                   	pop    %esi
  8020dc:	5f                   	pop    %edi
  8020dd:	5d                   	pop    %ebp
  8020de:	c3                   	ret    
  8020df:	90                   	nop
  8020e0:	89 fd                	mov    %edi,%ebp
  8020e2:	85 ff                	test   %edi,%edi
  8020e4:	75 0b                	jne    8020f1 <__umoddi3+0xe9>
  8020e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020eb:	31 d2                	xor    %edx,%edx
  8020ed:	f7 f7                	div    %edi
  8020ef:	89 c5                	mov    %eax,%ebp
  8020f1:	89 f0                	mov    %esi,%eax
  8020f3:	31 d2                	xor    %edx,%edx
  8020f5:	f7 f5                	div    %ebp
  8020f7:	89 c8                	mov    %ecx,%eax
  8020f9:	f7 f5                	div    %ebp
  8020fb:	89 d0                	mov    %edx,%eax
  8020fd:	e9 44 ff ff ff       	jmp    802046 <__umoddi3+0x3e>
  802102:	66 90                	xchg   %ax,%ax
  802104:	89 c8                	mov    %ecx,%eax
  802106:	89 f2                	mov    %esi,%edx
  802108:	83 c4 1c             	add    $0x1c,%esp
  80210b:	5b                   	pop    %ebx
  80210c:	5e                   	pop    %esi
  80210d:	5f                   	pop    %edi
  80210e:	5d                   	pop    %ebp
  80210f:	c3                   	ret    
  802110:	3b 04 24             	cmp    (%esp),%eax
  802113:	72 06                	jb     80211b <__umoddi3+0x113>
  802115:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802119:	77 0f                	ja     80212a <__umoddi3+0x122>
  80211b:	89 f2                	mov    %esi,%edx
  80211d:	29 f9                	sub    %edi,%ecx
  80211f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802123:	89 14 24             	mov    %edx,(%esp)
  802126:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80212a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80212e:	8b 14 24             	mov    (%esp),%edx
  802131:	83 c4 1c             	add    $0x1c,%esp
  802134:	5b                   	pop    %ebx
  802135:	5e                   	pop    %esi
  802136:	5f                   	pop    %edi
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    
  802139:	8d 76 00             	lea    0x0(%esi),%esi
  80213c:	2b 04 24             	sub    (%esp),%eax
  80213f:	19 fa                	sbb    %edi,%edx
  802141:	89 d1                	mov    %edx,%ecx
  802143:	89 c6                	mov    %eax,%esi
  802145:	e9 71 ff ff ff       	jmp    8020bb <__umoddi3+0xb3>
  80214a:	66 90                	xchg   %ax,%ax
  80214c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802150:	72 ea                	jb     80213c <__umoddi3+0x134>
  802152:	89 d9                	mov    %ebx,%ecx
  802154:	e9 62 ff ff ff       	jmp    8020bb <__umoddi3+0xb3>
