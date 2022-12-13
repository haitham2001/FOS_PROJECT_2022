
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 d2 0a 00 00       	call   800b08 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 f8 25 00 00       	call   802642 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 60 3f 80 00       	push   $0x803f60
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 7c 3f 80 00       	push   $0x803f7c
  8000a7:	e8 98 0b 00 00       	call   800c44 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 ca 1d 00 00       	call   801e80 <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 50 20 00 00       	call   80212d <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 e8 20 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	01 d2                	add    %edx,%edx
  8000ef:	01 d0                	add    %edx,%eax
  8000f1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 83 1d 00 00       	call   801e80 <malloc>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800103:	8b 45 90             	mov    -0x70(%ebp),%eax
  800106:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80010b:	74 14                	je     800121 <_main+0xe9>
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 94 3f 80 00       	push   $0x803f94
  800115:	6a 26                	push   $0x26
  800117:	68 7c 3f 80 00       	push   $0x803f7c
  80011c:	e8 23 0b 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  800121:	e8 a7 20 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800126:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800129:	3d 00 03 00 00       	cmp    $0x300,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 c4 3f 80 00       	push   $0x803fc4
  800138:	6a 28                	push   $0x28
  80013a:	68 7c 3f 80 00       	push   $0x803f7c
  80013f:	e8 00 0b 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800144:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800147:	e8 e1 1f 00 00       	call   80212d <sys_calculate_free_frames>
  80014c:	29 c3                	sub    %eax,%ebx
  80014e:	89 d8                	mov    %ebx,%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 e1 3f 80 00       	push   $0x803fe1
  80015d:	6a 29                	push   $0x29
  80015f:	68 7c 3f 80 00       	push   $0x803f7c
  800164:	e8 db 0a 00 00       	call   800c44 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 bf 1f 00 00       	call   80212d <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 57 20 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	89 c2                	mov    %eax,%edx
  80017e:	01 d2                	add    %edx,%edx
  800180:	01 d0                	add    %edx,%eax
  800182:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 f2 1c 00 00       	call   801e80 <malloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  800194:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800197:	89 c1                	mov    %eax,%ecx
  800199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019c:	89 c2                	mov    %eax,%edx
  80019e:	01 d2                	add    %edx,%edx
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a7:	39 c1                	cmp    %eax,%ecx
  8001a9:	74 14                	je     8001bf <_main+0x187>
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 94 3f 80 00       	push   $0x803f94
  8001b3:	6a 2f                	push   $0x2f
  8001b5:	68 7c 3f 80 00       	push   $0x803f7c
  8001ba:	e8 85 0a 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001bf:	e8 09 20 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8001c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c7:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 c4 3f 80 00       	push   $0x803fc4
  8001d6:	6a 31                	push   $0x31
  8001d8:	68 7c 3f 80 00       	push   $0x803f7c
  8001dd:	e8 62 0a 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e5:	e8 43 1f 00 00       	call   80212d <sys_calculate_free_frames>
  8001ea:	29 c3                	sub    %eax,%ebx
  8001ec:	89 d8                	mov    %ebx,%eax
  8001ee:	83 f8 01             	cmp    $0x1,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 e1 3f 80 00       	push   $0x803fe1
  8001fb:	6a 32                	push   $0x32
  8001fd:	68 7c 3f 80 00       	push   $0x803f7c
  800202:	e8 3d 0a 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800207:	e8 21 1f 00 00       	call   80212d <sys_calculate_free_frames>
  80020c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020f:	e8 b9 1f 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800214:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  800217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	50                   	push   %eax
  800223:	e8 58 1c 00 00       	call   801e80 <malloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80022e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800231:	89 c1                	mov    %eax,%ecx
  800233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800236:	89 d0                	mov    %edx,%eax
  800238:	01 c0                	add    %eax,%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	01 c0                	add    %eax,%eax
  80023e:	05 00 00 00 80       	add    $0x80000000,%eax
  800243:	39 c1                	cmp    %eax,%ecx
  800245:	74 14                	je     80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 94 3f 80 00       	push   $0x803f94
  80024f:	6a 38                	push   $0x38
  800251:	68 7c 3f 80 00       	push   $0x803f7c
  800256:	e8 e9 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  80025b:	e8 6d 1f 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800260:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800263:	3d 00 02 00 00       	cmp    $0x200,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 c4 3f 80 00       	push   $0x803fc4
  800272:	6a 3a                	push   $0x3a
  800274:	68 7c 3f 80 00       	push   $0x803f7c
  800279:	e8 c6 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80027e:	e8 aa 1e 00 00       	call   80212d <sys_calculate_free_frames>
  800283:	89 c2                	mov    %eax,%edx
  800285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 e1 3f 80 00       	push   $0x803fe1
  800294:	6a 3b                	push   $0x3b
  800296:	68 7c 3f 80 00       	push   $0x803f7c
  80029b:	e8 a4 09 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002a0:	e8 88 1e 00 00       	call   80212d <sys_calculate_free_frames>
  8002a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a8:	e8 20 1f 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8002ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  8002b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b3:	01 c0                	add    %eax,%eax
  8002b5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	50                   	push   %eax
  8002bc:	e8 bf 1b 00 00       	call   801e80 <malloc>
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8002c7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ca:	89 c2                	mov    %eax,%edx
  8002cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cf:	c1 e0 03             	shl    $0x3,%eax
  8002d2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 94 3f 80 00       	push   $0x803f94
  8002e3:	6a 41                	push   $0x41
  8002e5:	68 7c 3f 80 00       	push   $0x803f7c
  8002ea:	e8 55 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002ef:	e8 d9 1e 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8002f4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 c4 3f 80 00       	push   $0x803fc4
  800306:	6a 43                	push   $0x43
  800308:	68 7c 3f 80 00       	push   $0x803f7c
  80030d:	e8 32 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800312:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800315:	e8 13 1e 00 00       	call   80212d <sys_calculate_free_frames>
  80031a:	29 c3                	sub    %eax,%ebx
  80031c:	89 d8                	mov    %ebx,%eax
  80031e:	83 f8 01             	cmp    $0x1,%eax
  800321:	74 14                	je     800337 <_main+0x2ff>
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 e1 3f 80 00       	push   $0x803fe1
  80032b:	6a 44                	push   $0x44
  80032d:	68 7c 3f 80 00       	push   $0x803f7c
  800332:	e8 0d 09 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 f1 1d 00 00       	call   80212d <sys_calculate_free_frames>
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80033f:	e8 89 1e 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800344:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	50                   	push   %eax
  800351:	e8 2a 1b 00 00       	call   801e80 <malloc>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) ) panic("Wrong start address for the allocated space... ");
  80035c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80035f:	89 c1                	mov    %eax,%ecx
  800361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	c1 e0 02             	shl    $0x2,%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	05 00 00 00 80       	add    $0x80000000,%eax
  800372:	39 c1                	cmp    %eax,%ecx
  800374:	74 14                	je     80038a <_main+0x352>
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 94 3f 80 00       	push   $0x803f94
  80037e:	6a 4a                	push   $0x4a
  800380:	68 7c 3f 80 00       	push   $0x803f7c
  800385:	e8 ba 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80038a:	e8 3e 1e 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  80038f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800392:	3d 00 01 00 00       	cmp    $0x100,%eax
  800397:	74 14                	je     8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 c4 3f 80 00       	push   $0x803fc4
  8003a1:	6a 4c                	push   $0x4c
  8003a3:	68 7c 3f 80 00       	push   $0x803f7c
  8003a8:	e8 97 08 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003ad:	e8 7b 1d 00 00       	call   80212d <sys_calculate_free_frames>
  8003b2:	89 c2                	mov    %eax,%edx
  8003b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 e1 3f 80 00       	push   $0x803fe1
  8003c3:	6a 4d                	push   $0x4d
  8003c5:	68 7c 3f 80 00       	push   $0x803f7c
  8003ca:	e8 75 08 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 59 1d 00 00       	call   80212d <sys_calculate_free_frames>
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d7:	e8 f1 1d 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  8003df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	50                   	push   %eax
  8003e9:	e8 92 1a 00 00       	call   801e80 <malloc>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) ) panic("Wrong start address for the allocated space... ");
  8003f4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003fc:	89 d0                	mov    %edx,%eax
  8003fe:	c1 e0 02             	shl    $0x2,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	01 c0                	add    %eax,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	05 00 00 00 80       	add    $0x80000000,%eax
  80040c:	39 c1                	cmp    %eax,%ecx
  80040e:	74 14                	je     800424 <_main+0x3ec>
  800410:	83 ec 04             	sub    $0x4,%esp
  800413:	68 94 3f 80 00       	push   $0x803f94
  800418:	6a 53                	push   $0x53
  80041a:	68 7c 3f 80 00       	push   $0x803f7c
  80041f:	e8 20 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800424:	e8 a4 1d 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80042c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 c4 3f 80 00       	push   $0x803fc4
  80043b:	6a 55                	push   $0x55
  80043d:	68 7c 3f 80 00       	push   $0x803f7c
  800442:	e8 fd 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800447:	e8 e1 1c 00 00       	call   80212d <sys_calculate_free_frames>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 e1 3f 80 00       	push   $0x803fe1
  80045d:	6a 56                	push   $0x56
  80045f:	68 7c 3f 80 00       	push   $0x803f7c
  800464:	e8 db 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800469:	e8 bf 1c 00 00       	call   80212d <sys_calculate_free_frames>
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800471:	e8 57 1d 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	50                   	push   %eax
  800483:	e8 f8 19 00 00       	call   801e80 <malloc>
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) ) panic("Wrong start address for the allocated space... ");
  80048e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800491:	89 c1                	mov    %eax,%ecx
  800493:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	c1 e0 02             	shl    $0x2,%eax
  80049f:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a4:	39 c1                	cmp    %eax,%ecx
  8004a6:	74 14                	je     8004bc <_main+0x484>
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	68 94 3f 80 00       	push   $0x803f94
  8004b0:	6a 5c                	push   $0x5c
  8004b2:	68 7c 3f 80 00       	push   $0x803f7c
  8004b7:	e8 88 07 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004bc:	e8 0c 1d 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8004c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 c4 3f 80 00       	push   $0x803fc4
  8004d3:	6a 5e                	push   $0x5e
  8004d5:	68 7c 3f 80 00       	push   $0x803f7c
  8004da:	e8 65 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004e2:	e8 46 1c 00 00       	call   80212d <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	83 f8 01             	cmp    $0x1,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 e1 3f 80 00       	push   $0x803fe1
  8004f8:	6a 5f                	push   $0x5f
  8004fa:	68 7c 3f 80 00       	push   $0x803f7c
  8004ff:	e8 40 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800504:	e8 24 1c 00 00       	call   80212d <sys_calculate_free_frames>
  800509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80050c:	e8 bc 1c 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  800514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800517:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 5d 19 00 00       	call   801e80 <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega)) panic("Wrong start address for the allocated space... ");
  800529:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80052c:	89 c1                	mov    %eax,%ecx
  80052e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800531:	89 d0                	mov    %edx,%eax
  800533:	01 c0                	add    %eax,%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	c1 e0 02             	shl    $0x2,%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	05 00 00 00 80       	add    $0x80000000,%eax
  800541:	39 c1                	cmp    %eax,%ecx
  800543:	74 14                	je     800559 <_main+0x521>
  800545:	83 ec 04             	sub    $0x4,%esp
  800548:	68 94 3f 80 00       	push   $0x803f94
  80054d:	6a 65                	push   $0x65
  80054f:	68 7c 3f 80 00       	push   $0x803f7c
  800554:	e8 eb 06 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800559:	e8 6f 1c 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  80055e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800561:	3d 00 01 00 00       	cmp    $0x100,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 c4 3f 80 00       	push   $0x803fc4
  800570:	6a 67                	push   $0x67
  800572:	68 7c 3f 80 00       	push   $0x803f7c
  800577:	e8 c8 06 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80057c:	e8 ac 1b 00 00       	call   80212d <sys_calculate_free_frames>
  800581:	89 c2                	mov    %eax,%edx
  800583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 e1 3f 80 00       	push   $0x803fe1
  800592:	6a 68                	push   $0x68
  800594:	68 7c 3f 80 00       	push   $0x803f7c
  800599:	e8 a6 06 00 00       	call   800c44 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80059e:	e8 8a 1b 00 00       	call   80212d <sys_calculate_free_frames>
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a6:	e8 22 1c 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	50                   	push   %eax
  8005b5:	e8 f4 18 00 00       	call   801eae <free>
  8005ba:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005bd:	e8 0b 1c 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8005c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 f4 3f 80 00       	push   $0x803ff4
  8005d8:	6a 72                	push   $0x72
  8005da:	68 7c 3f 80 00       	push   $0x803f7c
  8005df:	e8 60 06 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005e4:	e8 44 1b 00 00       	call   80212d <sys_calculate_free_frames>
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 0b 40 80 00       	push   $0x80400b
  8005fa:	6a 73                	push   $0x73
  8005fc:	68 7c 3f 80 00       	push   $0x803f7c
  800601:	e8 3e 06 00 00       	call   800c44 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800606:	e8 22 1b 00 00       	call   80212d <sys_calculate_free_frames>
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060e:	e8 ba 1b 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800616:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	50                   	push   %eax
  80061d:	e8 8c 18 00 00       	call   801eae <free>
  800622:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800625:	e8 a3 1b 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	3d 00 02 00 00       	cmp    $0x200,%eax
  800636:	74 14                	je     80064c <_main+0x614>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 f4 3f 80 00       	push   $0x803ff4
  800640:	6a 7a                	push   $0x7a
  800642:	68 7c 3f 80 00       	push   $0x803f7c
  800647:	e8 f8 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064c:	e8 dc 1a 00 00       	call   80212d <sys_calculate_free_frames>
  800651:	89 c2                	mov    %eax,%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	74 14                	je     80066e <_main+0x636>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 0b 40 80 00       	push   $0x80400b
  800662:	6a 7b                	push   $0x7b
  800664:	68 7c 3f 80 00       	push   $0x803f7c
  800669:	e8 d6 05 00 00       	call   800c44 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 ba 1a 00 00       	call   80212d <sys_calculate_free_frames>
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800676:	e8 52 1b 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80067e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	50                   	push   %eax
  800685:	e8 24 18 00 00       	call   801eae <free>
  80068a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80068d:	e8 3b 1b 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	3d 00 01 00 00       	cmp    $0x100,%eax
  80069e:	74 17                	je     8006b7 <_main+0x67f>
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	68 f4 3f 80 00       	push   $0x803ff4
  8006a8:	68 82 00 00 00       	push   $0x82
  8006ad:	68 7c 3f 80 00       	push   $0x803f7c
  8006b2:	e8 8d 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006b7:	e8 71 1a 00 00       	call   80212d <sys_calculate_free_frames>
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	74 17                	je     8006dc <_main+0x6a4>
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 0b 40 80 00       	push   $0x80400b
  8006cd:	68 83 00 00 00       	push   $0x83
  8006d2:	68 7c 3f 80 00       	push   $0x803f7c
  8006d7:	e8 68 05 00 00       	call   800c44 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006dc:	e8 4c 1a 00 00       	call   80212d <sys_calculate_free_frames>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e4:	e8 e4 1a 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8006e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  8006ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ef:	c1 e0 09             	shl    $0x9,%eax
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	50                   	push   %eax
  8006f6:	e8 85 17 00 00       	call   801e80 <malloc>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  800701:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800704:	89 c1                	mov    %eax,%ecx
  800706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800709:	89 d0                	mov    %edx,%eax
  80070b:	c1 e0 02             	shl    $0x2,%eax
  80070e:	01 d0                	add    %edx,%eax
  800710:	01 c0                	add    %eax,%eax
  800712:	01 d0                	add    %edx,%eax
  800714:	05 00 00 00 80       	add    $0x80000000,%eax
  800719:	39 c1                	cmp    %eax,%ecx
  80071b:	74 17                	je     800734 <_main+0x6fc>
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	68 94 3f 80 00       	push   $0x803f94
  800725:	68 8c 00 00 00       	push   $0x8c
  80072a:	68 7c 3f 80 00       	push   $0x803f7c
  80072f:	e8 10 05 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800734:	e8 94 1a 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800739:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800741:	74 17                	je     80075a <_main+0x722>
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 c4 3f 80 00       	push   $0x803fc4
  80074b:	68 8e 00 00 00       	push   $0x8e
  800750:	68 7c 3f 80 00       	push   $0x803f7c
  800755:	e8 ea 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80075a:	e8 ce 19 00 00       	call   80212d <sys_calculate_free_frames>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 e1 3f 80 00       	push   $0x803fe1
  800770:	68 8f 00 00 00       	push   $0x8f
  800775:	68 7c 3f 80 00       	push   $0x803f7c
  80077a:	e8 c5 04 00 00       	call   800c44 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80077f:	e8 a9 19 00 00       	call   80212d <sys_calculate_free_frames>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800787:	e8 41 1a 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  80078c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80078f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800792:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 e2 16 00 00       	call   801e80 <malloc>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8007a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ac:	c1 e0 03             	shl    $0x3,%eax
  8007af:	05 00 00 00 80       	add    $0x80000000,%eax
  8007b4:	39 c2                	cmp    %eax,%edx
  8007b6:	74 17                	je     8007cf <_main+0x797>
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	68 94 3f 80 00       	push   $0x803f94
  8007c0:	68 95 00 00 00       	push   $0x95
  8007c5:	68 7c 3f 80 00       	push   $0x803f7c
  8007ca:	e8 75 04 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007cf:	e8 f9 19 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8007d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007dc:	74 17                	je     8007f5 <_main+0x7bd>
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	68 c4 3f 80 00       	push   $0x803fc4
  8007e6:	68 97 00 00 00       	push   $0x97
  8007eb:	68 7c 3f 80 00       	push   $0x803f7c
  8007f0:	e8 4f 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007f5:	e8 33 19 00 00       	call   80212d <sys_calculate_free_frames>
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 17                	je     80081a <_main+0x7e2>
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	68 e1 3f 80 00       	push   $0x803fe1
  80080b:	68 98 00 00 00       	push   $0x98
  800810:	68 7c 3f 80 00       	push   $0x803f7c
  800815:	e8 2a 04 00 00       	call   800c44 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80081a:	e8 0e 19 00 00       	call   80212d <sys_calculate_free_frames>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800822:	e8 a6 19 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800827:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  80082a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082d:	89 d0                	mov    %edx,%eax
  80082f:	c1 e0 08             	shl    $0x8,%eax
  800832:	29 d0                	sub    %edx,%eax
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	50                   	push   %eax
  800838:	e8 43 16 00 00       	call   801e80 <malloc>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800843:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800846:	89 c1                	mov    %eax,%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	c1 e0 02             	shl    $0x2,%eax
  800850:	01 d0                	add    %edx,%eax
  800852:	01 c0                	add    %eax,%eax
  800854:	01 d0                	add    %edx,%eax
  800856:	89 c2                	mov    %eax,%edx
  800858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085b:	c1 e0 09             	shl    $0x9,%eax
  80085e:	01 d0                	add    %edx,%eax
  800860:	05 00 00 00 80       	add    $0x80000000,%eax
  800865:	39 c1                	cmp    %eax,%ecx
  800867:	74 17                	je     800880 <_main+0x848>
  800869:	83 ec 04             	sub    $0x4,%esp
  80086c:	68 94 3f 80 00       	push   $0x803f94
  800871:	68 9e 00 00 00       	push   $0x9e
  800876:	68 7c 3f 80 00       	push   $0x803f7c
  80087b:	e8 c4 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800880:	e8 48 19 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800885:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800888:	83 f8 40             	cmp    $0x40,%eax
  80088b:	74 17                	je     8008a4 <_main+0x86c>
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	68 c4 3f 80 00       	push   $0x803fc4
  800895:	68 a0 00 00 00       	push   $0xa0
  80089a:	68 7c 3f 80 00       	push   $0x803f7c
  80089f:	e8 a0 03 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008a4:	e8 84 18 00 00       	call   80212d <sys_calculate_free_frames>
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 e1 3f 80 00       	push   $0x803fe1
  8008ba:	68 a1 00 00 00       	push   $0xa1
  8008bf:	68 7c 3f 80 00       	push   $0x803f7c
  8008c4:	e8 7b 03 00 00       	call   800c44 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 5f 18 00 00       	call   80212d <sys_calculate_free_frames>
  8008ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008d1:	e8 f7 18 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  8008d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dc:	c1 e0 02             	shl    $0x2,%eax
  8008df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008e2:	83 ec 0c             	sub    $0xc,%esp
  8008e5:	50                   	push   %eax
  8008e6:	e8 95 15 00 00       	call   801e80 <malloc>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  8008f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008f4:	89 c1                	mov    %eax,%ecx
  8008f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	05 00 00 00 80       	add    $0x80000000,%eax
  80090a:	39 c1                	cmp    %eax,%ecx
  80090c:	74 17                	je     800925 <_main+0x8ed>
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 94 3f 80 00       	push   $0x803f94
  800916:	68 a7 00 00 00       	push   $0xa7
  80091b:	68 7c 3f 80 00       	push   $0x803f7c
  800920:	e8 1f 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800925:	e8 a3 18 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  80092a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80092d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 c4 3f 80 00       	push   $0x803fc4
  80093c:	68 a9 00 00 00       	push   $0xa9
  800941:	68 7c 3f 80 00       	push   $0x803f7c
  800946:	e8 f9 02 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80094b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80094e:	e8 da 17 00 00       	call   80212d <sys_calculate_free_frames>
  800953:	29 c3                	sub    %eax,%ebx
  800955:	89 d8                	mov    %ebx,%eax
  800957:	83 f8 01             	cmp    $0x1,%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 e1 3f 80 00       	push   $0x803fe1
  800964:	68 aa 00 00 00       	push   $0xaa
  800969:	68 7c 3f 80 00       	push   $0x803f7c
  80096e:	e8 d1 02 00 00       	call   800c44 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800973:	e8 b5 17 00 00       	call   80212d <sys_calculate_free_frames>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80097b:	e8 4d 18 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800983:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	50                   	push   %eax
  80098a:	e8 1f 15 00 00       	call   801eae <free>
  80098f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800992:	e8 36 18 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	29 c2                	sub    %eax,%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 f4 3f 80 00       	push   $0x803ff4
  8009ad:	68 b4 00 00 00       	push   $0xb4
  8009b2:	68 7c 3f 80 00       	push   $0x803f7c
  8009b7:	e8 88 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009bc:	e8 6c 17 00 00       	call   80212d <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 0b 40 80 00       	push   $0x80400b
  8009d2:	68 b5 00 00 00       	push   $0xb5
  8009d7:	68 7c 3f 80 00       	push   $0x803f7c
  8009dc:	e8 63 02 00 00       	call   800c44 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 47 17 00 00       	call   80212d <sys_calculate_free_frames>
  8009e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e9:	e8 df 17 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 b1 14 00 00       	call   801eae <free>
  8009fd:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a00:	e8 c8 17 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a11:	74 17                	je     800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 f4 3f 80 00       	push   $0x803ff4
  800a1b:	68 bc 00 00 00       	push   $0xbc
  800a20:	68 7c 3f 80 00       	push   $0x803f7c
  800a25:	e8 1a 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2a:	e8 fe 16 00 00       	call   80212d <sys_calculate_free_frames>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 0b 40 80 00       	push   $0x80400b
  800a40:	68 bd 00 00 00       	push   $0xbd
  800a45:	68 7c 3f 80 00       	push   $0x803f7c
  800a4a:	e8 f5 01 00 00       	call   800c44 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a4f:	e8 d9 16 00 00       	call   80212d <sys_calculate_free_frames>
  800a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a57:	e8 71 17 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800a5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	01 c0                	add    %eax,%eax
  800a64:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	50                   	push   %eax
  800a6b:	e8 10 14 00 00       	call   801e80 <malloc>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega)) panic("Wrong start address for the allocated space... ");
  800a76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a79:	89 c1                	mov    %eax,%ecx
  800a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	c1 e0 03             	shl    $0x3,%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	05 00 00 00 80       	add    $0x80000000,%eax
  800a8a:	39 c1                	cmp    %eax,%ecx
  800a8c:	74 17                	je     800aa5 <_main+0xa6d>
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	68 94 3f 80 00       	push   $0x803f94
  800a96:	68 c6 00 00 00       	push   $0xc6
  800a9b:	68 7c 3f 80 00       	push   $0x803f7c
  800aa0:	e8 9f 01 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800aa5:	e8 23 17 00 00       	call   8021cd <sys_pf_calculate_allocated_pages>
  800aaa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800aad:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 c4 3f 80 00       	push   $0x803fc4
  800abc:	68 c8 00 00 00       	push   $0xc8
  800ac1:	68 7c 3f 80 00       	push   $0x803f7c
  800ac6:	e8 79 01 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800acb:	e8 5d 16 00 00       	call   80212d <sys_calculate_free_frames>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 17                	je     800af0 <_main+0xab8>
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	68 e1 3f 80 00       	push   $0x803fe1
  800ae1:	68 c9 00 00 00       	push   $0xc9
  800ae6:	68 7c 3f 80 00       	push   $0x803f7c
  800aeb:	e8 54 01 00 00       	call   800c44 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	68 18 40 80 00       	push   $0x804018
  800af8:	e8 fb 03 00 00       	call   800ef8 <cprintf>
  800afd:	83 c4 10             	add    $0x10,%esp

	return;
  800b00:	90                   	nop
}
  800b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b04:	5b                   	pop    %ebx
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b0e:	e8 fa 18 00 00       	call   80240d <sys_getenvindex>
  800b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b19:	89 d0                	mov    %edx,%eax
  800b1b:	c1 e0 03             	shl    $0x3,%eax
  800b1e:	01 d0                	add    %edx,%eax
  800b20:	01 c0                	add    %eax,%eax
  800b22:	01 d0                	add    %edx,%eax
  800b24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2b:	01 d0                	add    %edx,%eax
  800b2d:	c1 e0 04             	shl    $0x4,%eax
  800b30:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b35:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800b3f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	74 0f                	je     800b58 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b49:	a1 20 50 80 00       	mov    0x805020,%eax
  800b4e:	05 5c 05 00 00       	add    $0x55c,%eax
  800b53:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5c:	7e 0a                	jle    800b68 <libmain+0x60>
		binaryname = argv[0];
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 c2 f4 ff ff       	call   800038 <_main>
  800b76:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800b79:	e8 9c 16 00 00       	call   80221a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	68 78 40 80 00       	push   $0x804078
  800b86:	e8 6d 03 00 00       	call   800ef8 <cprintf>
  800b8b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b8e:	a1 20 50 80 00       	mov    0x805020,%eax
  800b93:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800b99:	a1 20 50 80 00       	mov    0x805020,%eax
  800b9e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ba4:	83 ec 04             	sub    $0x4,%esp
  800ba7:	52                   	push   %edx
  800ba8:	50                   	push   %eax
  800ba9:	68 a0 40 80 00       	push   $0x8040a0
  800bae:	e8 45 03 00 00       	call   800ef8 <cprintf>
  800bb3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bb6:	a1 20 50 80 00       	mov    0x805020,%eax
  800bbb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800bc1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bc6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800bcc:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd1:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800bd7:	51                   	push   %ecx
  800bd8:	52                   	push   %edx
  800bd9:	50                   	push   %eax
  800bda:	68 c8 40 80 00       	push   $0x8040c8
  800bdf:	e8 14 03 00 00       	call   800ef8 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800be7:	a1 20 50 80 00       	mov    0x805020,%eax
  800bec:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	68 20 41 80 00       	push   $0x804120
  800bfb:	e8 f8 02 00 00       	call   800ef8 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	68 78 40 80 00       	push   $0x804078
  800c0b:	e8 e8 02 00 00       	call   800ef8 <cprintf>
  800c10:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c13:	e8 1c 16 00 00       	call   802234 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c18:	e8 19 00 00 00       	call   800c36 <exit>
}
  800c1d:	90                   	nop
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	6a 00                	push   $0x0
  800c2b:	e8 a9 17 00 00       	call   8023d9 <sys_destroy_env>
  800c30:	83 c4 10             	add    $0x10,%esp
}
  800c33:	90                   	nop
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <exit>:

void
exit(void)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c3c:	e8 fe 17 00 00       	call   80243f <sys_exit_env>
}
  800c41:	90                   	nop
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c4a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4d:	83 c0 04             	add    $0x4,%eax
  800c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c53:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	74 16                	je     800c72 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c5c:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	50                   	push   %eax
  800c65:	68 34 41 80 00       	push   $0x804134
  800c6a:	e8 89 02 00 00       	call   800ef8 <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c72:	a1 00 50 80 00       	mov    0x805000,%eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	50                   	push   %eax
  800c7e:	68 39 41 80 00       	push   $0x804139
  800c83:	e8 70 02 00 00       	call   800ef8 <cprintf>
  800c88:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 f4             	pushl  -0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	e8 f3 01 00 00       	call   800e8d <vcprintf>
  800c9a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	6a 00                	push   $0x0
  800ca2:	68 55 41 80 00       	push   $0x804155
  800ca7:	e8 e1 01 00 00       	call   800e8d <vcprintf>
  800cac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800caf:	e8 82 ff ff ff       	call   800c36 <exit>

	// should not return here
	while (1) ;
  800cb4:	eb fe                	jmp    800cb4 <_panic+0x70>

00800cb6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cbc:	a1 20 50 80 00       	mov    0x805020,%eax
  800cc1:	8b 50 74             	mov    0x74(%eax),%edx
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	39 c2                	cmp    %eax,%edx
  800cc9:	74 14                	je     800cdf <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	68 58 41 80 00       	push   $0x804158
  800cd3:	6a 26                	push   $0x26
  800cd5:	68 a4 41 80 00       	push   $0x8041a4
  800cda:	e8 65 ff ff ff       	call   800c44 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ce6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ced:	e9 c2 00 00 00       	jmp    800db4 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	01 d0                	add    %edx,%eax
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	85 c0                	test   %eax,%eax
  800d05:	75 08                	jne    800d0f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d07:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d0a:	e9 a2 00 00 00       	jmp    800db1 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d1d:	eb 69                	jmp    800d88 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d1f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d24:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d2d:	89 d0                	mov    %edx,%eax
  800d2f:	01 c0                	add    %eax,%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	c1 e0 03             	shl    $0x3,%eax
  800d36:	01 c8                	add    %ecx,%eax
  800d38:	8a 40 04             	mov    0x4(%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	75 46                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d44:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d4d:	89 d0                	mov    %edx,%eax
  800d4f:	01 c0                	add    %eax,%eax
  800d51:	01 d0                	add    %edx,%eax
  800d53:	c1 e0 03             	shl    $0x3,%eax
  800d56:	01 c8                	add    %ecx,%eax
  800d58:	8b 00                	mov    (%eax),%eax
  800d5a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d65:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d6a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	01 c8                	add    %ecx,%eax
  800d76:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d78:	39 c2                	cmp    %eax,%edx
  800d7a:	75 09                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800d7c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d83:	eb 12                	jmp    800d97 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d85:	ff 45 e8             	incl   -0x18(%ebp)
  800d88:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8d:	8b 50 74             	mov    0x74(%eax),%edx
  800d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d93:	39 c2                	cmp    %eax,%edx
  800d95:	77 88                	ja     800d1f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d9b:	75 14                	jne    800db1 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800d9d:	83 ec 04             	sub    $0x4,%esp
  800da0:	68 b0 41 80 00       	push   $0x8041b0
  800da5:	6a 3a                	push   $0x3a
  800da7:	68 a4 41 80 00       	push   $0x8041a4
  800dac:	e8 93 fe ff ff       	call   800c44 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800db1:	ff 45 f0             	incl   -0x10(%ebp)
  800db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dba:	0f 8c 32 ff ff ff    	jl     800cf2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800dc0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800dce:	eb 26                	jmp    800df6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800dd0:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	01 c0                	add    %eax,%eax
  800de2:	01 d0                	add    %edx,%eax
  800de4:	c1 e0 03             	shl    $0x3,%eax
  800de7:	01 c8                	add    %ecx,%eax
  800de9:	8a 40 04             	mov    0x4(%eax),%al
  800dec:	3c 01                	cmp    $0x1,%al
  800dee:	75 03                	jne    800df3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800df0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800df3:	ff 45 e0             	incl   -0x20(%ebp)
  800df6:	a1 20 50 80 00       	mov    0x805020,%eax
  800dfb:	8b 50 74             	mov    0x74(%eax),%edx
  800dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e01:	39 c2                	cmp    %eax,%edx
  800e03:	77 cb                	ja     800dd0 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e0b:	74 14                	je     800e21 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e0d:	83 ec 04             	sub    $0x4,%esp
  800e10:	68 04 42 80 00       	push   $0x804204
  800e15:	6a 44                	push   $0x44
  800e17:	68 a4 41 80 00       	push   $0x8041a4
  800e1c:	e8 23 fe ff ff       	call   800c44 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e21:	90                   	nop
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8b 00                	mov    (%eax),%eax
  800e2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e35:	89 0a                	mov    %ecx,(%edx)
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	88 d1                	mov    %dl,%cl
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8b 00                	mov    (%eax),%eax
  800e48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e4d:	75 2c                	jne    800e7b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e4f:	a0 24 50 80 00       	mov    0x805024,%al
  800e54:	0f b6 c0             	movzbl %al,%eax
  800e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5a:	8b 12                	mov    (%edx),%edx
  800e5c:	89 d1                	mov    %edx,%ecx
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e61:	83 c2 08             	add    $0x8,%edx
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	50                   	push   %eax
  800e68:	51                   	push   %ecx
  800e69:	52                   	push   %edx
  800e6a:	e8 fd 11 00 00       	call   80206c <sys_cputs>
  800e6f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	8b 40 04             	mov    0x4(%eax),%eax
  800e81:	8d 50 01             	lea    0x1(%eax),%edx
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e8a:	90                   	nop
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e9d:	00 00 00 
	b.cnt = 0;
  800ea0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ea7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	ff 75 08             	pushl  0x8(%ebp)
  800eb0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800eb6:	50                   	push   %eax
  800eb7:	68 24 0e 80 00       	push   $0x800e24
  800ebc:	e8 11 02 00 00       	call   8010d2 <vprintfmt>
  800ec1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ec4:	a0 24 50 80 00       	mov    0x805024,%al
  800ec9:	0f b6 c0             	movzbl %al,%eax
  800ecc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	50                   	push   %eax
  800ed6:	52                   	push   %edx
  800ed7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800edd:	83 c0 08             	add    $0x8,%eax
  800ee0:	50                   	push   %eax
  800ee1:	e8 86 11 00 00       	call   80206c <sys_cputs>
  800ee6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ee9:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800ef0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800efe:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 f4             	pushl  -0xc(%ebp)
  800f14:	50                   	push   %eax
  800f15:	e8 73 ff ff ff       	call   800e8d <vcprintf>
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f2b:	e8 ea 12 00 00       	call   80221a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f30:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3f:	50                   	push   %eax
  800f40:	e8 48 ff ff ff       	call   800e8d <vcprintf>
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f4b:	e8 e4 12 00 00       	call   802234 <sys_enable_interrupt>
	return cnt;
  800f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	53                   	push   %ebx
  800f59:	83 ec 14             	sub    $0x14,%esp
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f62:	8b 45 14             	mov    0x14(%ebp),%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f68:	8b 45 18             	mov    0x18(%ebp),%eax
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f73:	77 55                	ja     800fca <printnum+0x75>
  800f75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f78:	72 05                	jb     800f7f <printnum+0x2a>
  800f7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f7d:	77 4b                	ja     800fca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f85:	8b 45 18             	mov    0x18(%ebp),%eax
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8d:	52                   	push   %edx
  800f8e:	50                   	push   %eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	ff 75 f0             	pushl  -0x10(%ebp)
  800f95:	e8 56 2d 00 00       	call   803cf0 <__udivdi3>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	ff 75 20             	pushl  0x20(%ebp)
  800fa3:	53                   	push   %ebx
  800fa4:	ff 75 18             	pushl  0x18(%ebp)
  800fa7:	52                   	push   %edx
  800fa8:	50                   	push   %eax
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 a1 ff ff ff       	call   800f55 <printnum>
  800fb4:	83 c4 20             	add    $0x20,%esp
  800fb7:	eb 1a                	jmp    800fd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	ff 75 20             	pushl  0x20(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	ff d0                	call   *%eax
  800fc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fca:	ff 4d 1c             	decl   0x1c(%ebp)
  800fcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fd1:	7f e6                	jg     800fb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe1:	53                   	push   %ebx
  800fe2:	51                   	push   %ecx
  800fe3:	52                   	push   %edx
  800fe4:	50                   	push   %eax
  800fe5:	e8 16 2e 00 00       	call   803e00 <__umoddi3>
  800fea:	83 c4 10             	add    $0x10,%esp
  800fed:	05 74 44 80 00       	add    $0x804474,%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f be c0             	movsbl %al,%eax
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
}
  801006:	90                   	nop
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80100f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801013:	7e 1c                	jle    801031 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8b 00                	mov    (%eax),%eax
  80101a:	8d 50 08             	lea    0x8(%eax),%edx
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 10                	mov    %edx,(%eax)
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	83 e8 08             	sub    $0x8,%eax
  80102a:	8b 50 04             	mov    0x4(%eax),%edx
  80102d:	8b 00                	mov    (%eax),%eax
  80102f:	eb 40                	jmp    801071 <getuint+0x65>
	else if (lflag)
  801031:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801035:	74 1e                	je     801055 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8b 00                	mov    (%eax),%eax
  80103c:	8d 50 04             	lea    0x4(%eax),%edx
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 10                	mov    %edx,(%eax)
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8b 00                	mov    (%eax),%eax
  801049:	83 e8 04             	sub    $0x4,%eax
  80104c:	8b 00                	mov    (%eax),%eax
  80104e:	ba 00 00 00 00       	mov    $0x0,%edx
  801053:	eb 1c                	jmp    801071 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8b 00                	mov    (%eax),%eax
  80105a:	8d 50 04             	lea    0x4(%eax),%edx
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 10                	mov    %edx,(%eax)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	83 e8 04             	sub    $0x4,%eax
  80106a:	8b 00                	mov    (%eax),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801076:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80107a:	7e 1c                	jle    801098 <getint+0x25>
		return va_arg(*ap, long long);
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8b 00                	mov    (%eax),%eax
  801081:	8d 50 08             	lea    0x8(%eax),%edx
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	89 10                	mov    %edx,(%eax)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	83 e8 08             	sub    $0x8,%eax
  801091:	8b 50 04             	mov    0x4(%eax),%edx
  801094:	8b 00                	mov    (%eax),%eax
  801096:	eb 38                	jmp    8010d0 <getint+0x5d>
	else if (lflag)
  801098:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109c:	74 1a                	je     8010b8 <getint+0x45>
		return va_arg(*ap, long);
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 50 04             	lea    0x4(%eax),%edx
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	89 10                	mov    %edx,(%eax)
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	83 e8 04             	sub    $0x4,%eax
  8010b3:	8b 00                	mov    (%eax),%eax
  8010b5:	99                   	cltd   
  8010b6:	eb 18                	jmp    8010d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	8d 50 04             	lea    0x4(%eax),%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 10                	mov    %edx,(%eax)
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8b 00                	mov    (%eax),%eax
  8010ca:	83 e8 04             	sub    $0x4,%eax
  8010cd:	8b 00                	mov    (%eax),%eax
  8010cf:	99                   	cltd   
}
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
  8010d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010da:	eb 17                	jmp    8010f3 <vprintfmt+0x21>
			if (ch == '\0')
  8010dc:	85 db                	test   %ebx,%ebx
  8010de:	0f 84 af 03 00 00    	je     801493 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	53                   	push   %ebx
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	ff d0                	call   *%eax
  8010f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	8d 50 01             	lea    0x1(%eax),%edx
  8010f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	0f b6 d8             	movzbl %al,%ebx
  801101:	83 fb 25             	cmp    $0x25,%ebx
  801104:	75 d6                	jne    8010dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801106:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80110a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801111:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801118:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80111f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801126:	8b 45 10             	mov    0x10(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 10             	mov    %edx,0x10(%ebp)
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d8             	movzbl %al,%ebx
  801134:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801137:	83 f8 55             	cmp    $0x55,%eax
  80113a:	0f 87 2b 03 00 00    	ja     80146b <vprintfmt+0x399>
  801140:	8b 04 85 98 44 80 00 	mov    0x804498(,%eax,4),%eax
  801147:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801149:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80114d:	eb d7                	jmp    801126 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80114f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801153:	eb d1                	jmp    801126 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801155:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80115c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80115f:	89 d0                	mov    %edx,%eax
  801161:	c1 e0 02             	shl    $0x2,%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	01 c0                	add    %eax,%eax
  801168:	01 d8                	add    %ebx,%eax
  80116a:	83 e8 30             	sub    $0x30,%eax
  80116d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801178:	83 fb 2f             	cmp    $0x2f,%ebx
  80117b:	7e 3e                	jle    8011bb <vprintfmt+0xe9>
  80117d:	83 fb 39             	cmp    $0x39,%ebx
  801180:	7f 39                	jg     8011bb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801182:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801185:	eb d5                	jmp    80115c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801187:	8b 45 14             	mov    0x14(%ebp),%eax
  80118a:	83 c0 04             	add    $0x4,%eax
  80118d:	89 45 14             	mov    %eax,0x14(%ebp)
  801190:	8b 45 14             	mov    0x14(%ebp),%eax
  801193:	83 e8 04             	sub    $0x4,%eax
  801196:	8b 00                	mov    (%eax),%eax
  801198:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80119b:	eb 1f                	jmp    8011bc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80119d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a1:	79 83                	jns    801126 <vprintfmt+0x54>
				width = 0;
  8011a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011aa:	e9 77 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011b6:	e9 6b ff ff ff       	jmp    801126 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011bb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011c0:	0f 89 60 ff ff ff    	jns    801126 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011d3:	e9 4e ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011d8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011db:	e9 46 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	83 c0 04             	add    $0x4,%eax
  8011e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8011e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ec:	83 e8 04             	sub    $0x4,%eax
  8011ef:	8b 00                	mov    (%eax),%eax
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	50                   	push   %eax
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	ff d0                	call   *%eax
  8011fd:	83 c4 10             	add    $0x10,%esp
			break;
  801200:	e9 89 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801205:	8b 45 14             	mov    0x14(%ebp),%eax
  801208:	83 c0 04             	add    $0x4,%eax
  80120b:	89 45 14             	mov    %eax,0x14(%ebp)
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	83 e8 04             	sub    $0x4,%eax
  801214:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801216:	85 db                	test   %ebx,%ebx
  801218:	79 02                	jns    80121c <vprintfmt+0x14a>
				err = -err;
  80121a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80121c:	83 fb 64             	cmp    $0x64,%ebx
  80121f:	7f 0b                	jg     80122c <vprintfmt+0x15a>
  801221:	8b 34 9d e0 42 80 00 	mov    0x8042e0(,%ebx,4),%esi
  801228:	85 f6                	test   %esi,%esi
  80122a:	75 19                	jne    801245 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80122c:	53                   	push   %ebx
  80122d:	68 85 44 80 00       	push   $0x804485
  801232:	ff 75 0c             	pushl  0xc(%ebp)
  801235:	ff 75 08             	pushl  0x8(%ebp)
  801238:	e8 5e 02 00 00       	call   80149b <printfmt>
  80123d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801240:	e9 49 02 00 00       	jmp    80148e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801245:	56                   	push   %esi
  801246:	68 8e 44 80 00       	push   $0x80448e
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	ff 75 08             	pushl  0x8(%ebp)
  801251:	e8 45 02 00 00       	call   80149b <printfmt>
  801256:	83 c4 10             	add    $0x10,%esp
			break;
  801259:	e9 30 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	83 c0 04             	add    $0x4,%eax
  801264:	89 45 14             	mov    %eax,0x14(%ebp)
  801267:	8b 45 14             	mov    0x14(%ebp),%eax
  80126a:	83 e8 04             	sub    $0x4,%eax
  80126d:	8b 30                	mov    (%eax),%esi
  80126f:	85 f6                	test   %esi,%esi
  801271:	75 05                	jne    801278 <vprintfmt+0x1a6>
				p = "(null)";
  801273:	be 91 44 80 00       	mov    $0x804491,%esi
			if (width > 0 && padc != '-')
  801278:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80127c:	7e 6d                	jle    8012eb <vprintfmt+0x219>
  80127e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801282:	74 67                	je     8012eb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	50                   	push   %eax
  80128b:	56                   	push   %esi
  80128c:	e8 0c 03 00 00       	call   80159d <strnlen>
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801297:	eb 16                	jmp    8012af <vprintfmt+0x1dd>
					putch(padc, putdat);
  801299:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	ff 75 0c             	pushl  0xc(%ebp)
  8012a3:	50                   	push   %eax
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	ff d0                	call   *%eax
  8012a9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8012af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b3:	7f e4                	jg     801299 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012b5:	eb 34                	jmp    8012eb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012bb:	74 1c                	je     8012d9 <vprintfmt+0x207>
  8012bd:	83 fb 1f             	cmp    $0x1f,%ebx
  8012c0:	7e 05                	jle    8012c7 <vprintfmt+0x1f5>
  8012c2:	83 fb 7e             	cmp    $0x7e,%ebx
  8012c5:	7e 12                	jle    8012d9 <vprintfmt+0x207>
					putch('?', putdat);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	6a 3f                	push   $0x3f
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	ff d0                	call   *%eax
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	eb 0f                	jmp    8012e8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	53                   	push   %ebx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	ff d0                	call   *%eax
  8012e5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8012eb:	89 f0                	mov    %esi,%eax
  8012ed:	8d 70 01             	lea    0x1(%eax),%esi
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	0f be d8             	movsbl %al,%ebx
  8012f5:	85 db                	test   %ebx,%ebx
  8012f7:	74 24                	je     80131d <vprintfmt+0x24b>
  8012f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012fd:	78 b8                	js     8012b7 <vprintfmt+0x1e5>
  8012ff:	ff 4d e0             	decl   -0x20(%ebp)
  801302:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801306:	79 af                	jns    8012b7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801308:	eb 13                	jmp    80131d <vprintfmt+0x24b>
				putch(' ', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 20                	push   $0x20
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80131a:	ff 4d e4             	decl   -0x1c(%ebp)
  80131d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801321:	7f e7                	jg     80130a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801323:	e9 66 01 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	ff 75 e8             	pushl  -0x18(%ebp)
  80132e:	8d 45 14             	lea    0x14(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	e8 3c fd ff ff       	call   801073 <getint>
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80133d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801346:	85 d2                	test   %edx,%edx
  801348:	79 23                	jns    80136d <vprintfmt+0x29b>
				putch('-', putdat);
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	6a 2d                	push   $0x2d
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	ff d0                	call   *%eax
  801357:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801360:	f7 d8                	neg    %eax
  801362:	83 d2 00             	adc    $0x0,%edx
  801365:	f7 da                	neg    %edx
  801367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80136a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80136d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801374:	e9 bc 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	ff 75 e8             	pushl  -0x18(%ebp)
  80137f:	8d 45 14             	lea    0x14(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	e8 84 fc ff ff       	call   80100c <getuint>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80138e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801391:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801398:	e9 98 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	6a 58                	push   $0x58
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	ff d0                	call   *%eax
  8013aa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	6a 58                	push   $0x58
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	ff d0                	call   *%eax
  8013ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	6a 58                	push   $0x58
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	ff d0                	call   *%eax
  8013ca:	83 c4 10             	add    $0x10,%esp
			break;
  8013cd:	e9 bc 00 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	6a 30                	push   $0x30
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	ff d0                	call   *%eax
  8013df:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	ff 75 0c             	pushl  0xc(%ebp)
  8013e8:	6a 78                	push   $0x78
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	ff d0                	call   *%eax
  8013ef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f5:	83 c0 04             	add    $0x4,%eax
  8013f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8013fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fe:	83 e8 04             	sub    $0x4,%eax
  801401:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80140d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801414:	eb 1f                	jmp    801435 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	ff 75 e8             	pushl  -0x18(%ebp)
  80141c:	8d 45 14             	lea    0x14(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	e8 e7 fb ff ff       	call   80100c <getuint>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80142e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801435:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	52                   	push   %edx
  801440:	ff 75 e4             	pushl  -0x1c(%ebp)
  801443:	50                   	push   %eax
  801444:	ff 75 f4             	pushl  -0xc(%ebp)
  801447:	ff 75 f0             	pushl  -0x10(%ebp)
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	ff 75 08             	pushl  0x8(%ebp)
  801450:	e8 00 fb ff ff       	call   800f55 <printnum>
  801455:	83 c4 20             	add    $0x20,%esp
			break;
  801458:	eb 34                	jmp    80148e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	53                   	push   %ebx
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	ff d0                	call   *%eax
  801466:	83 c4 10             	add    $0x10,%esp
			break;
  801469:	eb 23                	jmp    80148e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	6a 25                	push   $0x25
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	ff d0                	call   *%eax
  801478:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80147b:	ff 4d 10             	decl   0x10(%ebp)
  80147e:	eb 03                	jmp    801483 <vprintfmt+0x3b1>
  801480:	ff 4d 10             	decl   0x10(%ebp)
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	48                   	dec    %eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 25                	cmp    $0x25,%al
  80148b:	75 f3                	jne    801480 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80148d:	90                   	nop
		}
	}
  80148e:	e9 47 fc ff ff       	jmp    8010da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801493:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801494:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8014a4:	83 c0 04             	add    $0x4,%eax
  8014a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b0:	50                   	push   %eax
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	ff 75 08             	pushl  0x8(%ebp)
  8014b7:	e8 16 fc ff ff       	call   8010d2 <vprintfmt>
  8014bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014bf:	90                   	nop
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 40 08             	mov    0x8(%eax),%eax
  8014cb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	8b 10                	mov    (%eax),%edx
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	8b 40 04             	mov    0x4(%eax),%eax
  8014df:	39 c2                	cmp    %eax,%edx
  8014e1:	73 12                	jae    8014f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	89 0a                	mov    %ecx,(%edx)
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	88 10                	mov    %dl,(%eax)
}
  8014f5:	90                   	nop
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801512:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801519:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151d:	74 06                	je     801525 <vsnprintf+0x2d>
  80151f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801523:	7f 07                	jg     80152c <vsnprintf+0x34>
		return -E_INVAL;
  801525:	b8 03 00 00 00       	mov    $0x3,%eax
  80152a:	eb 20                	jmp    80154c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80152c:	ff 75 14             	pushl  0x14(%ebp)
  80152f:	ff 75 10             	pushl  0x10(%ebp)
  801532:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	68 c2 14 80 00       	push   $0x8014c2
  80153b:	e8 92 fb ff ff       	call   8010d2 <vprintfmt>
  801540:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801546:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801554:	8d 45 10             	lea    0x10(%ebp),%eax
  801557:	83 c0 04             	add    $0x4,%eax
  80155a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	ff 75 f4             	pushl  -0xc(%ebp)
  801563:	50                   	push   %eax
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	ff 75 08             	pushl  0x8(%ebp)
  80156a:	e8 89 ff ff ff       	call   8014f8 <vsnprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801587:	eb 06                	jmp    80158f <strlen+0x15>
		n++;
  801589:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80158c:	ff 45 08             	incl   0x8(%ebp)
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	84 c0                	test   %al,%al
  801596:	75 f1                	jne    801589 <strlen+0xf>
		n++;
	return n;
  801598:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015aa:	eb 09                	jmp    8015b5 <strnlen+0x18>
		n++;
  8015ac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	ff 4d 0c             	decl   0xc(%ebp)
  8015b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b9:	74 09                	je     8015c4 <strnlen+0x27>
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	84 c0                	test   %al,%al
  8015c2:	75 e8                	jne    8015ac <strnlen+0xf>
		n++;
	return n;
  8015c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015d5:	90                   	nop
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8d 50 01             	lea    0x1(%eax),%edx
  8015dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015e8:	8a 12                	mov    (%edx),%dl
  8015ea:	88 10                	mov    %dl,(%eax)
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	84 c0                	test   %al,%al
  8015f0:	75 e4                	jne    8015d6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160a:	eb 1f                	jmp    80162b <strncpy+0x34>
		*dst++ = *src;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8d 50 01             	lea    0x1(%eax),%edx
  801612:	89 55 08             	mov    %edx,0x8(%ebp)
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8a 12                	mov    (%edx),%dl
  80161a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	84 c0                	test   %al,%al
  801623:	74 03                	je     801628 <strncpy+0x31>
			src++;
  801625:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801628:	ff 45 fc             	incl   -0x4(%ebp)
  80162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801631:	72 d9                	jb     80160c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801633:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801644:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801648:	74 30                	je     80167a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80164a:	eb 16                	jmp    801662 <strlcpy+0x2a>
			*dst++ = *src++;
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 08             	mov    %edx,0x8(%ebp)
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801662:	ff 4d 10             	decl   0x10(%ebp)
  801665:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801669:	74 09                	je     801674 <strlcpy+0x3c>
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	84 c0                	test   %al,%al
  801672:	75 d8                	jne    80164c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80167a:	8b 55 08             	mov    0x8(%ebp),%edx
  80167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801680:	29 c2                	sub    %eax,%edx
  801682:	89 d0                	mov    %edx,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801689:	eb 06                	jmp    801691 <strcmp+0xb>
		p++, q++;
  80168b:	ff 45 08             	incl   0x8(%ebp)
  80168e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	84 c0                	test   %al,%al
  801698:	74 0e                	je     8016a8 <strcmp+0x22>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 10                	mov    (%eax),%dl
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	38 c2                	cmp    %al,%dl
  8016a6:	74 e3                	je     80168b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f b6 d0             	movzbl %al,%edx
  8016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	0f b6 c0             	movzbl %al,%eax
  8016b8:	29 c2                	sub    %eax,%edx
  8016ba:	89 d0                	mov    %edx,%eax
}
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016c1:	eb 09                	jmp    8016cc <strncmp+0xe>
		n--, p++, q++;
  8016c3:	ff 4d 10             	decl   0x10(%ebp)
  8016c6:	ff 45 08             	incl   0x8(%ebp)
  8016c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d0:	74 17                	je     8016e9 <strncmp+0x2b>
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	84 c0                	test   %al,%al
  8016d9:	74 0e                	je     8016e9 <strncmp+0x2b>
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 10                	mov    (%eax),%dl
  8016e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	38 c2                	cmp    %al,%dl
  8016e7:	74 da                	je     8016c3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ed:	75 07                	jne    8016f6 <strncmp+0x38>
		return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	eb 14                	jmp    80170a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	0f b6 d0             	movzbl %al,%edx
  8016fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	0f b6 c0             	movzbl %al,%eax
  801706:	29 c2                	sub    %eax,%edx
  801708:	89 d0                	mov    %edx,%eax
}
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	8b 45 0c             	mov    0xc(%ebp),%eax
  801715:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801718:	eb 12                	jmp    80172c <strchr+0x20>
		if (*s == c)
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801722:	75 05                	jne    801729 <strchr+0x1d>
			return (char *) s;
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	eb 11                	jmp    80173a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801729:	ff 45 08             	incl   0x8(%ebp)
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	84 c0                	test   %al,%al
  801733:	75 e5                	jne    80171a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801748:	eb 0d                	jmp    801757 <strfind+0x1b>
		if (*s == c)
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801752:	74 0e                	je     801762 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801754:	ff 45 08             	incl   0x8(%ebp)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	75 ea                	jne    80174a <strfind+0xe>
  801760:	eb 01                	jmp    801763 <strfind+0x27>
		if (*s == c)
			break;
  801762:	90                   	nop
	return (char *) s;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801774:	8b 45 10             	mov    0x10(%ebp),%eax
  801777:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80177a:	eb 0e                	jmp    80178a <memset+0x22>
		*p++ = c;
  80177c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177f:	8d 50 01             	lea    0x1(%eax),%edx
  801782:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80178a:	ff 4d f8             	decl   -0x8(%ebp)
  80178d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801791:	79 e9                	jns    80177c <memset+0x14>
		*p++ = c;

	return v;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80179e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017aa:	eb 16                	jmp    8017c2 <memcpy+0x2a>
		*d++ = *s++;
  8017ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017af:	8d 50 01             	lea    0x1(%eax),%edx
  8017b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017be:	8a 12                	mov    (%edx),%dl
  8017c0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	75 dd                	jne    8017ac <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017ec:	73 50                	jae    80183e <memmove+0x6a>
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	01 d0                	add    %edx,%eax
  8017f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f9:	76 43                	jbe    80183e <memmove+0x6a>
		s += n;
  8017fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801807:	eb 10                	jmp    801819 <memmove+0x45>
			*--d = *--s;
  801809:	ff 4d f8             	decl   -0x8(%ebp)
  80180c:	ff 4d fc             	decl   -0x4(%ebp)
  80180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801812:	8a 10                	mov    (%eax),%dl
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80181f:	89 55 10             	mov    %edx,0x10(%ebp)
  801822:	85 c0                	test   %eax,%eax
  801824:	75 e3                	jne    801809 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801826:	eb 23                	jmp    80184b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801828:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8d 4a 01             	lea    0x1(%edx),%ecx
  801837:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80183a:	8a 12                	mov    (%edx),%dl
  80183c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	8d 50 ff             	lea    -0x1(%eax),%edx
  801844:	89 55 10             	mov    %edx,0x10(%ebp)
  801847:	85 c0                	test   %eax,%eax
  801849:	75 dd                	jne    801828 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801862:	eb 2a                	jmp    80188e <memcmp+0x3e>
		if (*s1 != *s2)
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	8a 10                	mov    (%eax),%dl
  801869:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	38 c2                	cmp    %al,%dl
  801870:	74 16                	je     801888 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	0f b6 d0             	movzbl %al,%edx
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	0f b6 c0             	movzbl %al,%eax
  801882:	29 c2                	sub    %eax,%edx
  801884:	89 d0                	mov    %edx,%eax
  801886:	eb 18                	jmp    8018a0 <memcmp+0x50>
		s1++, s2++;
  801888:	ff 45 fc             	incl   -0x4(%ebp)
  80188b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	8d 50 ff             	lea    -0x1(%eax),%edx
  801894:	89 55 10             	mov    %edx,0x10(%ebp)
  801897:	85 c0                	test   %eax,%eax
  801899:	75 c9                	jne    801864 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018b3:	eb 15                	jmp    8018ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	0f b6 c0             	movzbl %al,%eax
  8018c3:	39 c2                	cmp    %eax,%edx
  8018c5:	74 0d                	je     8018d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018c7:	ff 45 08             	incl   0x8(%ebp)
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018d0:	72 e3                	jb     8018b5 <memfind+0x13>
  8018d2:	eb 01                	jmp    8018d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018d4:	90                   	nop
	return (void *) s;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ee:	eb 03                	jmp    8018f3 <strtol+0x19>
		s++;
  8018f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	3c 20                	cmp    $0x20,%al
  8018fa:	74 f4                	je     8018f0 <strtol+0x16>
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8a 00                	mov    (%eax),%al
  801901:	3c 09                	cmp    $0x9,%al
  801903:	74 eb                	je     8018f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	3c 2b                	cmp    $0x2b,%al
  80190c:	75 05                	jne    801913 <strtol+0x39>
		s++;
  80190e:	ff 45 08             	incl   0x8(%ebp)
  801911:	eb 13                	jmp    801926 <strtol+0x4c>
	else if (*s == '-')
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	3c 2d                	cmp    $0x2d,%al
  80191a:	75 0a                	jne    801926 <strtol+0x4c>
		s++, neg = 1;
  80191c:	ff 45 08             	incl   0x8(%ebp)
  80191f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801926:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192a:	74 06                	je     801932 <strtol+0x58>
  80192c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801930:	75 20                	jne    801952 <strtol+0x78>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	3c 30                	cmp    $0x30,%al
  801939:	75 17                	jne    801952 <strtol+0x78>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	40                   	inc    %eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	3c 78                	cmp    $0x78,%al
  801943:	75 0d                	jne    801952 <strtol+0x78>
		s += 2, base = 16;
  801945:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801949:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801950:	eb 28                	jmp    80197a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801952:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801956:	75 15                	jne    80196d <strtol+0x93>
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	3c 30                	cmp    $0x30,%al
  80195f:	75 0c                	jne    80196d <strtol+0x93>
		s++, base = 8;
  801961:	ff 45 08             	incl   0x8(%ebp)
  801964:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80196b:	eb 0d                	jmp    80197a <strtol+0xa0>
	else if (base == 0)
  80196d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801971:	75 07                	jne    80197a <strtol+0xa0>
		base = 10;
  801973:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	3c 2f                	cmp    $0x2f,%al
  801981:	7e 19                	jle    80199c <strtol+0xc2>
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	3c 39                	cmp    $0x39,%al
  80198a:	7f 10                	jg     80199c <strtol+0xc2>
			dig = *s - '0';
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	0f be c0             	movsbl %al,%eax
  801994:	83 e8 30             	sub    $0x30,%eax
  801997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199a:	eb 42                	jmp    8019de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	3c 60                	cmp    $0x60,%al
  8019a3:	7e 19                	jle    8019be <strtol+0xe4>
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	3c 7a                	cmp    $0x7a,%al
  8019ac:	7f 10                	jg     8019be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8a 00                	mov    (%eax),%al
  8019b3:	0f be c0             	movsbl %al,%eax
  8019b6:	83 e8 57             	sub    $0x57,%eax
  8019b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bc:	eb 20                	jmp    8019de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 40                	cmp    $0x40,%al
  8019c5:	7e 39                	jle    801a00 <strtol+0x126>
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	3c 5a                	cmp    $0x5a,%al
  8019ce:	7f 30                	jg     801a00 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8a 00                	mov    (%eax),%al
  8019d5:	0f be c0             	movsbl %al,%eax
  8019d8:	83 e8 37             	sub    $0x37,%eax
  8019db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e4:	7d 19                	jge    8019ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019e6:	ff 45 08             	incl   0x8(%ebp)
  8019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019fa:	e9 7b ff ff ff       	jmp    80197a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a04:	74 08                	je     801a0e <strtol+0x134>
		*endptr = (char *) s;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a12:	74 07                	je     801a1b <strtol+0x141>
  801a14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a17:	f7 d8                	neg    %eax
  801a19:	eb 03                	jmp    801a1e <strtol+0x144>
  801a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <ltostr>:

void
ltostr(long value, char *str)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a38:	79 13                	jns    801a4d <ltostr+0x2d>
	{
		neg = 1;
  801a3a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a47:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a4a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a55:	99                   	cltd   
  801a56:	f7 f9                	idiv   %ecx
  801a58:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	8d 50 01             	lea    0x1(%eax),%edx
  801a61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a64:	89 c2                	mov    %eax,%edx
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a6e:	83 c2 30             	add    $0x30,%edx
  801a71:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a76:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a7b:	f7 e9                	imul   %ecx
  801a7d:	c1 fa 02             	sar    $0x2,%edx
  801a80:	89 c8                	mov    %ecx,%eax
  801a82:	c1 f8 1f             	sar    $0x1f,%eax
  801a85:	29 c2                	sub    %eax,%edx
  801a87:	89 d0                	mov    %edx,%eax
  801a89:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a94:	f7 e9                	imul   %ecx
  801a96:	c1 fa 02             	sar    $0x2,%edx
  801a99:	89 c8                	mov    %ecx,%eax
  801a9b:	c1 f8 1f             	sar    $0x1f,%eax
  801a9e:	29 c2                	sub    %eax,%edx
  801aa0:	89 d0                	mov    %edx,%eax
  801aa2:	c1 e0 02             	shl    $0x2,%eax
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	01 c0                	add    %eax,%eax
  801aa9:	29 c1                	sub    %eax,%ecx
  801aab:	89 ca                	mov    %ecx,%edx
  801aad:	85 d2                	test   %edx,%edx
  801aaf:	75 9c                	jne    801a4d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ab1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abb:	48                   	dec    %eax
  801abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ac3:	74 3d                	je     801b02 <ltostr+0xe2>
		start = 1 ;
  801ac5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801acc:	eb 34                	jmp    801b02 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	01 d0                	add    %edx,%eax
  801ad6:	8a 00                	mov    (%eax),%al
  801ad8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	01 c2                	add    %eax,%edx
  801ae3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae9:	01 c8                	add    %ecx,%eax
  801aeb:	8a 00                	mov    (%eax),%al
  801aed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801aef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	01 c2                	add    %eax,%edx
  801af7:	8a 45 eb             	mov    -0x15(%ebp),%al
  801afa:	88 02                	mov    %al,(%edx)
		start++ ;
  801afc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801aff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b08:	7c c4                	jl     801ace <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b10:	01 d0                	add    %edx,%eax
  801b12:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	e8 54 fa ff ff       	call   80157a <strlen>
  801b26:	83 c4 04             	add    $0x4,%esp
  801b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	e8 46 fa ff ff       	call   80157a <strlen>
  801b34:	83 c4 04             	add    $0x4,%esp
  801b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b48:	eb 17                	jmp    801b61 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b50:	01 c2                	add    %eax,%edx
  801b52:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	01 c8                	add    %ecx,%eax
  801b5a:	8a 00                	mov    (%eax),%al
  801b5c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b5e:	ff 45 fc             	incl   -0x4(%ebp)
  801b61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b67:	7c e1                	jl     801b4a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b69:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b77:	eb 1f                	jmp    801b98 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b7c:	8d 50 01             	lea    0x1(%eax),%edx
  801b7f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b82:	89 c2                	mov    %eax,%edx
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	01 c2                	add    %eax,%edx
  801b89:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8f:	01 c8                	add    %ecx,%eax
  801b91:	8a 00                	mov    (%eax),%al
  801b93:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b95:	ff 45 f8             	incl   -0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b9e:	7c d9                	jl     801b79 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ba0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	01 d0                	add    %edx,%eax
  801ba8:	c6 00 00             	movb   $0x0,(%eax)
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bba:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	01 d0                	add    %edx,%eax
  801bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bd1:	eb 0c                	jmp    801bdf <strsplit+0x31>
			*string++ = 0;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	8d 50 01             	lea    0x1(%eax),%edx
  801bd9:	89 55 08             	mov    %edx,0x8(%ebp)
  801bdc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	8a 00                	mov    (%eax),%al
  801be4:	84 c0                	test   %al,%al
  801be6:	74 18                	je     801c00 <strsplit+0x52>
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	8a 00                	mov    (%eax),%al
  801bed:	0f be c0             	movsbl %al,%eax
  801bf0:	50                   	push   %eax
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	e8 13 fb ff ff       	call   80170c <strchr>
  801bf9:	83 c4 08             	add    $0x8,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	75 d3                	jne    801bd3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	8a 00                	mov    (%eax),%al
  801c05:	84 c0                	test   %al,%al
  801c07:	74 5a                	je     801c63 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c09:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0c:	8b 00                	mov    (%eax),%eax
  801c0e:	83 f8 0f             	cmp    $0xf,%eax
  801c11:	75 07                	jne    801c1a <strsplit+0x6c>
		{
			return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
  801c18:	eb 66                	jmp    801c80 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	8d 48 01             	lea    0x1(%eax),%ecx
  801c22:	8b 55 14             	mov    0x14(%ebp),%edx
  801c25:	89 0a                	mov    %ecx,(%edx)
  801c27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c31:	01 c2                	add    %eax,%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c38:	eb 03                	jmp    801c3d <strsplit+0x8f>
			string++;
  801c3a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	8a 00                	mov    (%eax),%al
  801c42:	84 c0                	test   %al,%al
  801c44:	74 8b                	je     801bd1 <strsplit+0x23>
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8a 00                	mov    (%eax),%al
  801c4b:	0f be c0             	movsbl %al,%eax
  801c4e:	50                   	push   %eax
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 b5 fa ff ff       	call   80170c <strchr>
  801c57:	83 c4 08             	add    $0x8,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	74 dc                	je     801c3a <strsplit+0x8c>
			string++;
	}
  801c5e:	e9 6e ff ff ff       	jmp    801bd1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c63:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	8b 00                	mov    (%eax),%eax
  801c69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801c88:	a1 04 50 80 00       	mov    0x805004,%eax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	74 1f                	je     801cb0 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801c91:	e8 1d 00 00 00       	call   801cb3 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	68 f0 45 80 00       	push   $0x8045f0
  801c9e:	e8 55 f2 ff ff       	call   800ef8 <cprintf>
  801ca3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ca6:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cad:	00 00 00 
	}
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801cb9:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801cc0:	00 00 00 
  801cc3:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801cca:	00 00 00 
  801ccd:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801cd4:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801cd7:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801cde:	00 00 00 
  801ce1:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801ce8:	00 00 00 
  801ceb:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801cf2:	00 00 00 
	uint32 arr_size = 0;
  801cf5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801cfc:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d0b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d10:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801d15:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d1c:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801d1f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d26:	a1 20 51 80 00       	mov    0x805120,%eax
  801d2b:	c1 e0 04             	shl    $0x4,%eax
  801d2e:	89 c2                	mov    %eax,%edx
  801d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d33:	01 d0                	add    %edx,%eax
  801d35:	48                   	dec    %eax
  801d36:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d41:	f7 75 ec             	divl   -0x14(%ebp)
  801d44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d47:	29 d0                	sub    %edx,%eax
  801d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801d4c:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801d53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d5b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	6a 06                	push   $0x6
  801d65:	ff 75 f4             	pushl  -0xc(%ebp)
  801d68:	50                   	push   %eax
  801d69:	e8 42 04 00 00       	call   8021b0 <sys_allocate_chunk>
  801d6e:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801d71:	a1 20 51 80 00       	mov    0x805120,%eax
  801d76:	83 ec 0c             	sub    $0xc,%esp
  801d79:	50                   	push   %eax
  801d7a:	e8 b7 0a 00 00       	call   802836 <initialize_MemBlocksList>
  801d7f:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801d82:	a1 48 51 80 00       	mov    0x805148,%eax
  801d87:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801d8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d8d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d97:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801d9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801da2:	75 14                	jne    801db8 <initialize_dyn_block_system+0x105>
  801da4:	83 ec 04             	sub    $0x4,%esp
  801da7:	68 15 46 80 00       	push   $0x804615
  801dac:	6a 33                	push   $0x33
  801dae:	68 33 46 80 00       	push   $0x804633
  801db3:	e8 8c ee ff ff       	call   800c44 <_panic>
  801db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dbb:	8b 00                	mov    (%eax),%eax
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	74 10                	je     801dd1 <initialize_dyn_block_system+0x11e>
  801dc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc4:	8b 00                	mov    (%eax),%eax
  801dc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dc9:	8b 52 04             	mov    0x4(%edx),%edx
  801dcc:	89 50 04             	mov    %edx,0x4(%eax)
  801dcf:	eb 0b                	jmp    801ddc <initialize_dyn_block_system+0x129>
  801dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dd4:	8b 40 04             	mov    0x4(%eax),%eax
  801dd7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ddc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ddf:	8b 40 04             	mov    0x4(%eax),%eax
  801de2:	85 c0                	test   %eax,%eax
  801de4:	74 0f                	je     801df5 <initialize_dyn_block_system+0x142>
  801de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de9:	8b 40 04             	mov    0x4(%eax),%eax
  801dec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801def:	8b 12                	mov    (%edx),%edx
  801df1:	89 10                	mov    %edx,(%eax)
  801df3:	eb 0a                	jmp    801dff <initialize_dyn_block_system+0x14c>
  801df5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df8:	8b 00                	mov    (%eax),%eax
  801dfa:	a3 48 51 80 00       	mov    %eax,0x805148
  801dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e12:	a1 54 51 80 00       	mov    0x805154,%eax
  801e17:	48                   	dec    %eax
  801e18:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801e1d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e21:	75 14                	jne    801e37 <initialize_dyn_block_system+0x184>
  801e23:	83 ec 04             	sub    $0x4,%esp
  801e26:	68 40 46 80 00       	push   $0x804640
  801e2b:	6a 34                	push   $0x34
  801e2d:	68 33 46 80 00       	push   $0x804633
  801e32:	e8 0d ee ff ff       	call   800c44 <_panic>
  801e37:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e40:	89 10                	mov    %edx,(%eax)
  801e42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e45:	8b 00                	mov    (%eax),%eax
  801e47:	85 c0                	test   %eax,%eax
  801e49:	74 0d                	je     801e58 <initialize_dyn_block_system+0x1a5>
  801e4b:	a1 38 51 80 00       	mov    0x805138,%eax
  801e50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e53:	89 50 04             	mov    %edx,0x4(%eax)
  801e56:	eb 08                	jmp    801e60 <initialize_dyn_block_system+0x1ad>
  801e58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e63:	a3 38 51 80 00       	mov    %eax,0x805138
  801e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e72:	a1 44 51 80 00       	mov    0x805144,%eax
  801e77:	40                   	inc    %eax
  801e78:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801e7d:	90                   	nop
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e86:	e8 f7 fd ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e8f:	75 07                	jne    801e98 <malloc+0x18>
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	eb 14                	jmp    801eac <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801e98:	83 ec 04             	sub    $0x4,%esp
  801e9b:	68 64 46 80 00       	push   $0x804664
  801ea0:	6a 46                	push   $0x46
  801ea2:	68 33 46 80 00       	push   $0x804633
  801ea7:	e8 98 ed ff ff       	call   800c44 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801eb4:	83 ec 04             	sub    $0x4,%esp
  801eb7:	68 8c 46 80 00       	push   $0x80468c
  801ebc:	6a 61                	push   $0x61
  801ebe:	68 33 46 80 00       	push   $0x804633
  801ec3:	e8 7c ed ff ff       	call   800c44 <_panic>

00801ec8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 38             	sub    $0x38,%esp
  801ece:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed1:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ed4:	e8 a9 fd ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ed9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801edd:	75 0a                	jne    801ee9 <smalloc+0x21>
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee4:	e9 9e 00 00 00       	jmp    801f87 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801ee9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef6:	01 d0                	add    %edx,%eax
  801ef8:	48                   	dec    %eax
  801ef9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eff:	ba 00 00 00 00       	mov    $0x0,%edx
  801f04:	f7 75 f0             	divl   -0x10(%ebp)
  801f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0a:	29 d0                	sub    %edx,%eax
  801f0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801f0f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f16:	e8 63 06 00 00       	call   80257e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	74 11                	je     801f30 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801f1f:	83 ec 0c             	sub    $0xc,%esp
  801f22:	ff 75 e8             	pushl  -0x18(%ebp)
  801f25:	e8 ce 0c 00 00       	call   802bf8 <alloc_block_FF>
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801f30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f34:	74 4c                	je     801f82 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f39:	8b 40 08             	mov    0x8(%eax),%eax
  801f3c:	89 c2                	mov    %eax,%edx
  801f3e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f42:	52                   	push   %edx
  801f43:	50                   	push   %eax
  801f44:	ff 75 0c             	pushl  0xc(%ebp)
  801f47:	ff 75 08             	pushl  0x8(%ebp)
  801f4a:	e8 b4 03 00 00       	call   802303 <sys_createSharedObject>
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801f55:	83 ec 08             	sub    $0x8,%esp
  801f58:	ff 75 e0             	pushl  -0x20(%ebp)
  801f5b:	68 af 46 80 00       	push   $0x8046af
  801f60:	e8 93 ef ff ff       	call   800ef8 <cprintf>
  801f65:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801f68:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801f6c:	74 14                	je     801f82 <smalloc+0xba>
  801f6e:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801f72:	74 0e                	je     801f82 <smalloc+0xba>
  801f74:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801f78:	74 08                	je     801f82 <smalloc+0xba>
			return (void*) mem_block->sva;
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	8b 40 08             	mov    0x8(%eax),%eax
  801f80:	eb 05                	jmp    801f87 <smalloc+0xbf>
	}
	return NULL;
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f8f:	e8 ee fc ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801f94:	83 ec 04             	sub    $0x4,%esp
  801f97:	68 c4 46 80 00       	push   $0x8046c4
  801f9c:	68 ab 00 00 00       	push   $0xab
  801fa1:	68 33 46 80 00       	push   $0x804633
  801fa6:	e8 99 ec ff ff       	call   800c44 <_panic>

00801fab <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fb1:	e8 cc fc ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	68 e8 46 80 00       	push   $0x8046e8
  801fbe:	68 ef 00 00 00       	push   $0xef
  801fc3:	68 33 46 80 00       	push   $0x804633
  801fc8:	e8 77 ec ff ff       	call   800c44 <_panic>

00801fcd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fd3:	83 ec 04             	sub    $0x4,%esp
  801fd6:	68 10 47 80 00       	push   $0x804710
  801fdb:	68 03 01 00 00       	push   $0x103
  801fe0:	68 33 46 80 00       	push   $0x804633
  801fe5:	e8 5a ec ff ff       	call   800c44 <_panic>

00801fea <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	68 34 47 80 00       	push   $0x804734
  801ff8:	68 0e 01 00 00       	push   $0x10e
  801ffd:	68 33 46 80 00       	push   $0x804633
  802002:	e8 3d ec ff ff       	call   800c44 <_panic>

00802007 <shrink>:

}
void shrink(uint32 newSize)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	68 34 47 80 00       	push   $0x804734
  802015:	68 13 01 00 00       	push   $0x113
  80201a:	68 33 46 80 00       	push   $0x804633
  80201f:	e8 20 ec ff ff       	call   800c44 <_panic>

00802024 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 34 47 80 00       	push   $0x804734
  802032:	68 18 01 00 00       	push   $0x118
  802037:	68 33 46 80 00       	push   $0x804633
  80203c:	e8 03 ec ff ff       	call   800c44 <_panic>

00802041 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	57                   	push   %edi
  802045:	56                   	push   %esi
  802046:	53                   	push   %ebx
  802047:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802053:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802056:	8b 7d 18             	mov    0x18(%ebp),%edi
  802059:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80205c:	cd 30                	int    $0x30
  80205e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802061:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    

0080206c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	8b 45 10             	mov    0x10(%ebp),%eax
  802075:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802078:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	52                   	push   %edx
  802084:	ff 75 0c             	pushl  0xc(%ebp)
  802087:	50                   	push   %eax
  802088:	6a 00                	push   $0x0
  80208a:	e8 b2 ff ff ff       	call   802041 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	90                   	nop
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_cgetc>:

int
sys_cgetc(void)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 01                	push   $0x1
  8020a4:	e8 98 ff ff ff       	call   802041 <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	52                   	push   %edx
  8020be:	50                   	push   %eax
  8020bf:	6a 05                	push   $0x5
  8020c1:	e8 7b ff ff ff       	call   802041 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	56                   	push   %esi
  8020cf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020d0:	8b 75 18             	mov    0x18(%ebp),%esi
  8020d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	56                   	push   %esi
  8020e0:	53                   	push   %ebx
  8020e1:	51                   	push   %ecx
  8020e2:	52                   	push   %edx
  8020e3:	50                   	push   %eax
  8020e4:	6a 06                	push   $0x6
  8020e6:	e8 56 ff ff ff       	call   802041 <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
}
  8020ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f1:	5b                   	pop    %ebx
  8020f2:	5e                   	pop    %esi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    

008020f5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	52                   	push   %edx
  802105:	50                   	push   %eax
  802106:	6a 07                	push   $0x7
  802108:	e8 34 ff ff ff       	call   802041 <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	ff 75 0c             	pushl  0xc(%ebp)
  80211e:	ff 75 08             	pushl  0x8(%ebp)
  802121:	6a 08                	push   $0x8
  802123:	e8 19 ff ff ff       	call   802041 <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 09                	push   $0x9
  80213c:	e8 00 ff ff ff       	call   802041 <syscall>
  802141:	83 c4 18             	add    $0x18,%esp
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 0a                	push   $0xa
  802155:	e8 e7 fe ff ff       	call   802041 <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 0b                	push   $0xb
  80216e:	e8 ce fe ff ff       	call   802041 <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	6a 0f                	push   $0xf
  802189:	e8 b3 fe ff ff       	call   802041 <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
	return;
  802191:	90                   	nop
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	ff 75 0c             	pushl  0xc(%ebp)
  8021a0:	ff 75 08             	pushl  0x8(%ebp)
  8021a3:	6a 10                	push   $0x10
  8021a5:	e8 97 fe ff ff       	call   802041 <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ad:	90                   	nop
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	ff 75 10             	pushl  0x10(%ebp)
  8021ba:	ff 75 0c             	pushl  0xc(%ebp)
  8021bd:	ff 75 08             	pushl  0x8(%ebp)
  8021c0:	6a 11                	push   $0x11
  8021c2:	e8 7a fe ff ff       	call   802041 <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ca:	90                   	nop
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 0c                	push   $0xc
  8021dc:	e8 60 fe ff ff       	call   802041 <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	ff 75 08             	pushl  0x8(%ebp)
  8021f4:	6a 0d                	push   $0xd
  8021f6:	e8 46 fe ff ff       	call   802041 <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 0e                	push   $0xe
  80220f:	e8 2d fe ff ff       	call   802041 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	90                   	nop
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 13                	push   $0x13
  802229:	e8 13 fe ff ff       	call   802041 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	90                   	nop
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 14                	push   $0x14
  802243:	e8 f9 fd ff ff       	call   802041 <syscall>
  802248:	83 c4 18             	add    $0x18,%esp
}
  80224b:	90                   	nop
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <sys_cputc>:


void
sys_cputc(const char c)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 04             	sub    $0x4,%esp
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80225a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	50                   	push   %eax
  802267:	6a 15                	push   $0x15
  802269:	e8 d3 fd ff ff       	call   802041 <syscall>
  80226e:	83 c4 18             	add    $0x18,%esp
}
  802271:	90                   	nop
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 16                	push   $0x16
  802283:	e8 b9 fd ff ff       	call   802041 <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	90                   	nop
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	ff 75 0c             	pushl  0xc(%ebp)
  80229d:	50                   	push   %eax
  80229e:	6a 17                	push   $0x17
  8022a0:	e8 9c fd ff ff       	call   802041 <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	52                   	push   %edx
  8022ba:	50                   	push   %eax
  8022bb:	6a 1a                	push   $0x1a
  8022bd:	e8 7f fd ff ff       	call   802041 <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	52                   	push   %edx
  8022d7:	50                   	push   %eax
  8022d8:	6a 18                	push   $0x18
  8022da:	e8 62 fd ff ff       	call   802041 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	90                   	nop
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	52                   	push   %edx
  8022f5:	50                   	push   %eax
  8022f6:	6a 19                	push   $0x19
  8022f8:	e8 44 fd ff ff       	call   802041 <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
}
  802300:	90                   	nop
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	83 ec 04             	sub    $0x4,%esp
  802309:	8b 45 10             	mov    0x10(%ebp),%eax
  80230c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80230f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802312:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	6a 00                	push   $0x0
  80231b:	51                   	push   %ecx
  80231c:	52                   	push   %edx
  80231d:	ff 75 0c             	pushl  0xc(%ebp)
  802320:	50                   	push   %eax
  802321:	6a 1b                	push   $0x1b
  802323:	e8 19 fd ff ff       	call   802041 <syscall>
  802328:	83 c4 18             	add    $0x18,%esp
}
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    

0080232d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802330:	8b 55 0c             	mov    0xc(%ebp),%edx
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	52                   	push   %edx
  80233d:	50                   	push   %eax
  80233e:	6a 1c                	push   $0x1c
  802340:	e8 fc fc ff ff       	call   802041 <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80234d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802350:	8b 55 0c             	mov    0xc(%ebp),%edx
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	51                   	push   %ecx
  80235b:	52                   	push   %edx
  80235c:	50                   	push   %eax
  80235d:	6a 1d                	push   $0x1d
  80235f:	e8 dd fc ff ff       	call   802041 <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80236c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	52                   	push   %edx
  802379:	50                   	push   %eax
  80237a:	6a 1e                	push   $0x1e
  80237c:	e8 c0 fc ff ff       	call   802041 <syscall>
  802381:	83 c4 18             	add    $0x18,%esp
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 1f                	push   $0x1f
  802395:	e8 a7 fc ff ff       	call   802041 <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	6a 00                	push   $0x0
  8023a7:	ff 75 14             	pushl  0x14(%ebp)
  8023aa:	ff 75 10             	pushl  0x10(%ebp)
  8023ad:	ff 75 0c             	pushl  0xc(%ebp)
  8023b0:	50                   	push   %eax
  8023b1:	6a 20                	push   $0x20
  8023b3:	e8 89 fc ff ff       	call   802041 <syscall>
  8023b8:	83 c4 18             	add    $0x18,%esp
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	50                   	push   %eax
  8023cc:	6a 21                	push   $0x21
  8023ce:	e8 6e fc ff ff       	call   802041 <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
}
  8023d6:	90                   	nop
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	50                   	push   %eax
  8023e8:	6a 22                	push   $0x22
  8023ea:	e8 52 fc ff ff       	call   802041 <syscall>
  8023ef:	83 c4 18             	add    $0x18,%esp
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 02                	push   $0x2
  802403:	e8 39 fc ff ff       	call   802041 <syscall>
  802408:	83 c4 18             	add    $0x18,%esp
}
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 03                	push   $0x3
  80241c:	e8 20 fc ff ff       	call   802041 <syscall>
  802421:	83 c4 18             	add    $0x18,%esp
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 04                	push   $0x4
  802435:	e8 07 fc ff ff       	call   802041 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_exit_env>:


void sys_exit_env(void)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 23                	push   $0x23
  80244e:	e8 ee fb ff ff       	call   802041 <syscall>
  802453:	83 c4 18             	add    $0x18,%esp
}
  802456:	90                   	nop
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80245f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802462:	8d 50 04             	lea    0x4(%eax),%edx
  802465:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	52                   	push   %edx
  80246f:	50                   	push   %eax
  802470:	6a 24                	push   $0x24
  802472:	e8 ca fb ff ff       	call   802041 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
	return result;
  80247a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80247d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802480:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802483:	89 01                	mov    %eax,(%ecx)
  802485:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	c9                   	leave  
  80248c:	c2 04 00             	ret    $0x4

0080248f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	ff 75 10             	pushl  0x10(%ebp)
  802499:	ff 75 0c             	pushl  0xc(%ebp)
  80249c:	ff 75 08             	pushl  0x8(%ebp)
  80249f:	6a 12                	push   $0x12
  8024a1:	e8 9b fb ff ff       	call   802041 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a9:	90                   	nop
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_rcr2>:
uint32 sys_rcr2()
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 25                	push   $0x25
  8024bb:	e8 81 fb ff ff       	call   802041 <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
}
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
  8024c8:	83 ec 04             	sub    $0x4,%esp
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024d1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	50                   	push   %eax
  8024de:	6a 26                	push   $0x26
  8024e0:	e8 5c fb ff ff       	call   802041 <syscall>
  8024e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e8:	90                   	nop
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <rsttst>:
void rsttst()
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 28                	push   $0x28
  8024fa:	e8 42 fb ff ff       	call   802041 <syscall>
  8024ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802502:	90                   	nop
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	83 ec 04             	sub    $0x4,%esp
  80250b:	8b 45 14             	mov    0x14(%ebp),%eax
  80250e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802511:	8b 55 18             	mov    0x18(%ebp),%edx
  802514:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802518:	52                   	push   %edx
  802519:	50                   	push   %eax
  80251a:	ff 75 10             	pushl  0x10(%ebp)
  80251d:	ff 75 0c             	pushl  0xc(%ebp)
  802520:	ff 75 08             	pushl  0x8(%ebp)
  802523:	6a 27                	push   $0x27
  802525:	e8 17 fb ff ff       	call   802041 <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
	return ;
  80252d:	90                   	nop
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <chktst>:
void chktst(uint32 n)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	ff 75 08             	pushl  0x8(%ebp)
  80253e:	6a 29                	push   $0x29
  802540:	e8 fc fa ff ff       	call   802041 <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
	return ;
  802548:	90                   	nop
}
  802549:	c9                   	leave  
  80254a:	c3                   	ret    

0080254b <inctst>:

void inctst()
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 2a                	push   $0x2a
  80255a:	e8 e2 fa ff ff       	call   802041 <syscall>
  80255f:	83 c4 18             	add    $0x18,%esp
	return ;
  802562:	90                   	nop
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <gettst>:
uint32 gettst()
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 2b                	push   $0x2b
  802574:	e8 c8 fa ff ff       	call   802041 <syscall>
  802579:	83 c4 18             	add    $0x18,%esp
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
  802581:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 2c                	push   $0x2c
  802590:	e8 ac fa ff ff       	call   802041 <syscall>
  802595:	83 c4 18             	add    $0x18,%esp
  802598:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80259b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80259f:	75 07                	jne    8025a8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a6:	eb 05                	jmp    8025ad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 2c                	push   $0x2c
  8025c1:	e8 7b fa ff ff       	call   802041 <syscall>
  8025c6:	83 c4 18             	add    $0x18,%esp
  8025c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025cc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025d0:	75 07                	jne    8025d9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d7:	eb 05                	jmp    8025de <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025de:	c9                   	leave  
  8025df:	c3                   	ret    

008025e0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 2c                	push   $0x2c
  8025f2:	e8 4a fa ff ff       	call   802041 <syscall>
  8025f7:	83 c4 18             	add    $0x18,%esp
  8025fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025fd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802601:	75 07                	jne    80260a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802603:	b8 01 00 00 00       	mov    $0x1,%eax
  802608:	eb 05                	jmp    80260f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80260a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
  802614:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 2c                	push   $0x2c
  802623:	e8 19 fa ff ff       	call   802041 <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
  80262b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80262e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802632:	75 07                	jne    80263b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802634:	b8 01 00 00 00       	mov    $0x1,%eax
  802639:	eb 05                	jmp    802640 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80263b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	ff 75 08             	pushl  0x8(%ebp)
  802650:	6a 2d                	push   $0x2d
  802652:	e8 ea f9 ff ff       	call   802041 <syscall>
  802657:	83 c4 18             	add    $0x18,%esp
	return ;
  80265a:	90                   	nop
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    

0080265d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
  802660:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802661:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802664:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266a:	8b 45 08             	mov    0x8(%ebp),%eax
  80266d:	6a 00                	push   $0x0
  80266f:	53                   	push   %ebx
  802670:	51                   	push   %ecx
  802671:	52                   	push   %edx
  802672:	50                   	push   %eax
  802673:	6a 2e                	push   $0x2e
  802675:	e8 c7 f9 ff ff       	call   802041 <syscall>
  80267a:	83 c4 18             	add    $0x18,%esp
}
  80267d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802680:	c9                   	leave  
  802681:	c3                   	ret    

00802682 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802685:	8b 55 0c             	mov    0xc(%ebp),%edx
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	52                   	push   %edx
  802692:	50                   	push   %eax
  802693:	6a 2f                	push   $0x2f
  802695:	e8 a7 f9 ff ff       	call   802041 <syscall>
  80269a:	83 c4 18             	add    $0x18,%esp
}
  80269d:	c9                   	leave  
  80269e:	c3                   	ret    

0080269f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026a5:	83 ec 0c             	sub    $0xc,%esp
  8026a8:	68 44 47 80 00       	push   $0x804744
  8026ad:	e8 46 e8 ff ff       	call   800ef8 <cprintf>
  8026b2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026bc:	83 ec 0c             	sub    $0xc,%esp
  8026bf:	68 70 47 80 00       	push   $0x804770
  8026c4:	e8 2f e8 ff ff       	call   800ef8 <cprintf>
  8026c9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026cc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026d0:	a1 38 51 80 00       	mov    0x805138,%eax
  8026d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d8:	eb 56                	jmp    802730 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026de:	74 1c                	je     8026fc <print_mem_block_lists+0x5d>
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 50 08             	mov    0x8(%eax),%edx
  8026e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e9:	8b 48 08             	mov    0x8(%eax),%ecx
  8026ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f2:	01 c8                	add    %ecx,%eax
  8026f4:	39 c2                	cmp    %eax,%edx
  8026f6:	73 04                	jae    8026fc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026f8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 50 08             	mov    0x8(%eax),%edx
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 40 0c             	mov    0xc(%eax),%eax
  802708:	01 c2                	add    %eax,%edx
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 40 08             	mov    0x8(%eax),%eax
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	52                   	push   %edx
  802714:	50                   	push   %eax
  802715:	68 85 47 80 00       	push   $0x804785
  80271a:	e8 d9 e7 ff ff       	call   800ef8 <cprintf>
  80271f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802728:	a1 40 51 80 00       	mov    0x805140,%eax
  80272d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802734:	74 07                	je     80273d <print_mem_block_lists+0x9e>
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	eb 05                	jmp    802742 <print_mem_block_lists+0xa3>
  80273d:	b8 00 00 00 00       	mov    $0x0,%eax
  802742:	a3 40 51 80 00       	mov    %eax,0x805140
  802747:	a1 40 51 80 00       	mov    0x805140,%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	75 8a                	jne    8026da <print_mem_block_lists+0x3b>
  802750:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802754:	75 84                	jne    8026da <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802756:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80275a:	75 10                	jne    80276c <print_mem_block_lists+0xcd>
  80275c:	83 ec 0c             	sub    $0xc,%esp
  80275f:	68 94 47 80 00       	push   $0x804794
  802764:	e8 8f e7 ff ff       	call   800ef8 <cprintf>
  802769:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80276c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802773:	83 ec 0c             	sub    $0xc,%esp
  802776:	68 b8 47 80 00       	push   $0x8047b8
  80277b:	e8 78 e7 ff ff       	call   800ef8 <cprintf>
  802780:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802783:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802787:	a1 40 50 80 00       	mov    0x805040,%eax
  80278c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278f:	eb 56                	jmp    8027e7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802791:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802795:	74 1c                	je     8027b3 <print_mem_block_lists+0x114>
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 50 08             	mov    0x8(%eax),%edx
  80279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a0:	8b 48 08             	mov    0x8(%eax),%ecx
  8027a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a9:	01 c8                	add    %ecx,%eax
  8027ab:	39 c2                	cmp    %eax,%edx
  8027ad:	73 04                	jae    8027b3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027af:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 50 08             	mov    0x8(%eax),%edx
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bf:	01 c2                	add    %eax,%edx
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 08             	mov    0x8(%eax),%eax
  8027c7:	83 ec 04             	sub    $0x4,%esp
  8027ca:	52                   	push   %edx
  8027cb:	50                   	push   %eax
  8027cc:	68 85 47 80 00       	push   $0x804785
  8027d1:	e8 22 e7 ff ff       	call   800ef8 <cprintf>
  8027d6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027df:	a1 48 50 80 00       	mov    0x805048,%eax
  8027e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027eb:	74 07                	je     8027f4 <print_mem_block_lists+0x155>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	eb 05                	jmp    8027f9 <print_mem_block_lists+0x15a>
  8027f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f9:	a3 48 50 80 00       	mov    %eax,0x805048
  8027fe:	a1 48 50 80 00       	mov    0x805048,%eax
  802803:	85 c0                	test   %eax,%eax
  802805:	75 8a                	jne    802791 <print_mem_block_lists+0xf2>
  802807:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280b:	75 84                	jne    802791 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80280d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802811:	75 10                	jne    802823 <print_mem_block_lists+0x184>
  802813:	83 ec 0c             	sub    $0xc,%esp
  802816:	68 d0 47 80 00       	push   $0x8047d0
  80281b:	e8 d8 e6 ff ff       	call   800ef8 <cprintf>
  802820:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802823:	83 ec 0c             	sub    $0xc,%esp
  802826:	68 44 47 80 00       	push   $0x804744
  80282b:	e8 c8 e6 ff ff       	call   800ef8 <cprintf>
  802830:	83 c4 10             	add    $0x10,%esp

}
  802833:	90                   	nop
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80283c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802843:	00 00 00 
  802846:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80284d:	00 00 00 
  802850:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802857:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80285a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802861:	e9 9e 00 00 00       	jmp    802904 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802866:	a1 50 50 80 00       	mov    0x805050,%eax
  80286b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286e:	c1 e2 04             	shl    $0x4,%edx
  802871:	01 d0                	add    %edx,%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	75 14                	jne    80288b <initialize_MemBlocksList+0x55>
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 f8 47 80 00       	push   $0x8047f8
  80287f:	6a 46                	push   $0x46
  802881:	68 1b 48 80 00       	push   $0x80481b
  802886:	e8 b9 e3 ff ff       	call   800c44 <_panic>
  80288b:	a1 50 50 80 00       	mov    0x805050,%eax
  802890:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802893:	c1 e2 04             	shl    $0x4,%edx
  802896:	01 d0                	add    %edx,%eax
  802898:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80289e:	89 10                	mov    %edx,(%eax)
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 18                	je     8028be <initialize_MemBlocksList+0x88>
  8028a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8028ab:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028b1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028b4:	c1 e1 04             	shl    $0x4,%ecx
  8028b7:	01 ca                	add    %ecx,%edx
  8028b9:	89 50 04             	mov    %edx,0x4(%eax)
  8028bc:	eb 12                	jmp    8028d0 <initialize_MemBlocksList+0x9a>
  8028be:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c6:	c1 e2 04             	shl    $0x4,%edx
  8028c9:	01 d0                	add    %edx,%eax
  8028cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028d0:	a1 50 50 80 00       	mov    0x805050,%eax
  8028d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d8:	c1 e2 04             	shl    $0x4,%edx
  8028db:	01 d0                	add    %edx,%eax
  8028dd:	a3 48 51 80 00       	mov    %eax,0x805148
  8028e2:	a1 50 50 80 00       	mov    0x805050,%eax
  8028e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ea:	c1 e2 04             	shl    $0x4,%edx
  8028ed:	01 d0                	add    %edx,%eax
  8028ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f6:	a1 54 51 80 00       	mov    0x805154,%eax
  8028fb:	40                   	inc    %eax
  8028fc:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802901:	ff 45 f4             	incl   -0xc(%ebp)
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290a:	0f 82 56 ff ff ff    	jb     802866 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802910:	90                   	nop
  802911:	c9                   	leave  
  802912:	c3                   	ret    

00802913 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802913:	55                   	push   %ebp
  802914:	89 e5                	mov    %esp,%ebp
  802916:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802921:	eb 19                	jmp    80293c <find_block+0x29>
	{
		if(va==point->sva)
  802923:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802926:	8b 40 08             	mov    0x8(%eax),%eax
  802929:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80292c:	75 05                	jne    802933 <find_block+0x20>
		   return point;
  80292e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802931:	eb 36                	jmp    802969 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802933:	8b 45 08             	mov    0x8(%ebp),%eax
  802936:	8b 40 08             	mov    0x8(%eax),%eax
  802939:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80293c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802940:	74 07                	je     802949 <find_block+0x36>
  802942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802945:	8b 00                	mov    (%eax),%eax
  802947:	eb 05                	jmp    80294e <find_block+0x3b>
  802949:	b8 00 00 00 00       	mov    $0x0,%eax
  80294e:	8b 55 08             	mov    0x8(%ebp),%edx
  802951:	89 42 08             	mov    %eax,0x8(%edx)
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	8b 40 08             	mov    0x8(%eax),%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	75 c5                	jne    802923 <find_block+0x10>
  80295e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802962:	75 bf                	jne    802923 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802964:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
  80296e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802971:	a1 40 50 80 00       	mov    0x805040,%eax
  802976:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802979:	a1 44 50 80 00       	mov    0x805044,%eax
  80297e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802987:	74 24                	je     8029ad <insert_sorted_allocList+0x42>
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	8b 50 08             	mov    0x8(%eax),%edx
  80298f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802992:	8b 40 08             	mov    0x8(%eax),%eax
  802995:	39 c2                	cmp    %eax,%edx
  802997:	76 14                	jbe    8029ad <insert_sorted_allocList+0x42>
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	8b 50 08             	mov    0x8(%eax),%edx
  80299f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a2:	8b 40 08             	mov    0x8(%eax),%eax
  8029a5:	39 c2                	cmp    %eax,%edx
  8029a7:	0f 82 60 01 00 00    	jb     802b0d <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8029ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029b1:	75 65                	jne    802a18 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8029b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b7:	75 14                	jne    8029cd <insert_sorted_allocList+0x62>
  8029b9:	83 ec 04             	sub    $0x4,%esp
  8029bc:	68 f8 47 80 00       	push   $0x8047f8
  8029c1:	6a 6b                	push   $0x6b
  8029c3:	68 1b 48 80 00       	push   $0x80481b
  8029c8:	e8 77 e2 ff ff       	call   800c44 <_panic>
  8029cd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d6:	89 10                	mov    %edx,(%eax)
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	8b 00                	mov    (%eax),%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	74 0d                	je     8029ee <insert_sorted_allocList+0x83>
  8029e1:	a1 40 50 80 00       	mov    0x805040,%eax
  8029e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ec:	eb 08                	jmp    8029f6 <insert_sorted_allocList+0x8b>
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	a3 44 50 80 00       	mov    %eax,0x805044
  8029f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f9:	a3 40 50 80 00       	mov    %eax,0x805040
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a08:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a0d:	40                   	inc    %eax
  802a0e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a13:	e9 dc 01 00 00       	jmp    802bf4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	8b 50 08             	mov    0x8(%eax),%edx
  802a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a21:	8b 40 08             	mov    0x8(%eax),%eax
  802a24:	39 c2                	cmp    %eax,%edx
  802a26:	77 6c                	ja     802a94 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a2c:	74 06                	je     802a34 <insert_sorted_allocList+0xc9>
  802a2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a32:	75 14                	jne    802a48 <insert_sorted_allocList+0xdd>
  802a34:	83 ec 04             	sub    $0x4,%esp
  802a37:	68 34 48 80 00       	push   $0x804834
  802a3c:	6a 6f                	push   $0x6f
  802a3e:	68 1b 48 80 00       	push   $0x80481b
  802a43:	e8 fc e1 ff ff       	call   800c44 <_panic>
  802a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4b:	8b 50 04             	mov    0x4(%eax),%edx
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	89 50 04             	mov    %edx,0x4(%eax)
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5a:	89 10                	mov    %edx,(%eax)
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	8b 40 04             	mov    0x4(%eax),%eax
  802a62:	85 c0                	test   %eax,%eax
  802a64:	74 0d                	je     802a73 <insert_sorted_allocList+0x108>
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 40 04             	mov    0x4(%eax),%eax
  802a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6f:	89 10                	mov    %edx,(%eax)
  802a71:	eb 08                	jmp    802a7b <insert_sorted_allocList+0x110>
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	a3 40 50 80 00       	mov    %eax,0x805040
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a81:	89 50 04             	mov    %edx,0x4(%eax)
  802a84:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a89:	40                   	inc    %eax
  802a8a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a8f:	e9 60 01 00 00       	jmp    802bf4 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	8b 50 08             	mov    0x8(%eax),%edx
  802a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	39 c2                	cmp    %eax,%edx
  802aa2:	0f 82 4c 01 00 00    	jb     802bf4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802aa8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aac:	75 14                	jne    802ac2 <insert_sorted_allocList+0x157>
  802aae:	83 ec 04             	sub    $0x4,%esp
  802ab1:	68 6c 48 80 00       	push   $0x80486c
  802ab6:	6a 73                	push   $0x73
  802ab8:	68 1b 48 80 00       	push   $0x80481b
  802abd:	e8 82 e1 ff ff       	call   800c44 <_panic>
  802ac2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	89 50 04             	mov    %edx,0x4(%eax)
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	8b 40 04             	mov    0x4(%eax),%eax
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	74 0c                	je     802ae4 <insert_sorted_allocList+0x179>
  802ad8:	a1 44 50 80 00       	mov    0x805044,%eax
  802add:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae0:	89 10                	mov    %edx,(%eax)
  802ae2:	eb 08                	jmp    802aec <insert_sorted_allocList+0x181>
  802ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae7:	a3 40 50 80 00       	mov    %eax,0x805040
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	a3 44 50 80 00       	mov    %eax,0x805044
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b02:	40                   	inc    %eax
  802b03:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b08:	e9 e7 00 00 00       	jmp    802bf4 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802b13:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b1a:	a1 40 50 80 00       	mov    0x805040,%eax
  802b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b22:	e9 9d 00 00 00       	jmp    802bc4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 00                	mov    (%eax),%eax
  802b2c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	8b 50 08             	mov    0x8(%eax),%edx
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 40 08             	mov    0x8(%eax),%eax
  802b3b:	39 c2                	cmp    %eax,%edx
  802b3d:	76 7d                	jbe    802bbc <insert_sorted_allocList+0x251>
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	8b 50 08             	mov    0x8(%eax),%edx
  802b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b48:	8b 40 08             	mov    0x8(%eax),%eax
  802b4b:	39 c2                	cmp    %eax,%edx
  802b4d:	73 6d                	jae    802bbc <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802b4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b53:	74 06                	je     802b5b <insert_sorted_allocList+0x1f0>
  802b55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b59:	75 14                	jne    802b6f <insert_sorted_allocList+0x204>
  802b5b:	83 ec 04             	sub    $0x4,%esp
  802b5e:	68 90 48 80 00       	push   $0x804890
  802b63:	6a 7f                	push   $0x7f
  802b65:	68 1b 48 80 00       	push   $0x80481b
  802b6a:	e8 d5 e0 ff ff       	call   800c44 <_panic>
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 10                	mov    (%eax),%edx
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	89 10                	mov    %edx,(%eax)
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	74 0b                	je     802b8d <insert_sorted_allocList+0x222>
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 55 08             	mov    0x8(%ebp),%edx
  802b93:	89 10                	mov    %edx,(%eax)
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9b:	89 50 04             	mov    %edx,0x4(%eax)
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	75 08                	jne    802baf <insert_sorted_allocList+0x244>
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	a3 44 50 80 00       	mov    %eax,0x805044
  802baf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bb4:	40                   	inc    %eax
  802bb5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802bba:	eb 39                	jmp    802bf5 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802bbc:	a1 48 50 80 00       	mov    0x805048,%eax
  802bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc8:	74 07                	je     802bd1 <insert_sorted_allocList+0x266>
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 00                	mov    (%eax),%eax
  802bcf:	eb 05                	jmp    802bd6 <insert_sorted_allocList+0x26b>
  802bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd6:	a3 48 50 80 00       	mov    %eax,0x805048
  802bdb:	a1 48 50 80 00       	mov    0x805048,%eax
  802be0:	85 c0                	test   %eax,%eax
  802be2:	0f 85 3f ff ff ff    	jne    802b27 <insert_sorted_allocList+0x1bc>
  802be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bec:	0f 85 35 ff ff ff    	jne    802b27 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802bf2:	eb 01                	jmp    802bf5 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bf4:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802bf5:	90                   	nop
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
  802bfb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802bfe:	a1 38 51 80 00       	mov    0x805138,%eax
  802c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c06:	e9 85 01 00 00       	jmp    802d90 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c11:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c14:	0f 82 6e 01 00 00    	jb     802d88 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c20:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c23:	0f 85 8a 00 00 00    	jne    802cb3 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2d:	75 17                	jne    802c46 <alloc_block_FF+0x4e>
  802c2f:	83 ec 04             	sub    $0x4,%esp
  802c32:	68 c4 48 80 00       	push   $0x8048c4
  802c37:	68 93 00 00 00       	push   $0x93
  802c3c:	68 1b 48 80 00       	push   $0x80481b
  802c41:	e8 fe df ff ff       	call   800c44 <_panic>
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 00                	mov    (%eax),%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	74 10                	je     802c5f <alloc_block_FF+0x67>
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c57:	8b 52 04             	mov    0x4(%edx),%edx
  802c5a:	89 50 04             	mov    %edx,0x4(%eax)
  802c5d:	eb 0b                	jmp    802c6a <alloc_block_FF+0x72>
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 04             	mov    0x4(%eax),%eax
  802c65:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	8b 40 04             	mov    0x4(%eax),%eax
  802c70:	85 c0                	test   %eax,%eax
  802c72:	74 0f                	je     802c83 <alloc_block_FF+0x8b>
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 40 04             	mov    0x4(%eax),%eax
  802c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7d:	8b 12                	mov    (%edx),%edx
  802c7f:	89 10                	mov    %edx,(%eax)
  802c81:	eb 0a                	jmp    802c8d <alloc_block_FF+0x95>
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 00                	mov    (%eax),%eax
  802c88:	a3 38 51 80 00       	mov    %eax,0x805138
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ca5:	48                   	dec    %eax
  802ca6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	e9 10 01 00 00       	jmp    802dc3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cbc:	0f 86 c6 00 00 00    	jbe    802d88 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cc2:	a1 48 51 80 00       	mov    0x805148,%eax
  802cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 50 08             	mov    0x8(%eax),%edx
  802cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd3:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdc:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce3:	75 17                	jne    802cfc <alloc_block_FF+0x104>
  802ce5:	83 ec 04             	sub    $0x4,%esp
  802ce8:	68 c4 48 80 00       	push   $0x8048c4
  802ced:	68 9b 00 00 00       	push   $0x9b
  802cf2:	68 1b 48 80 00       	push   $0x80481b
  802cf7:	e8 48 df ff ff       	call   800c44 <_panic>
  802cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	74 10                	je     802d15 <alloc_block_FF+0x11d>
  802d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0d:	8b 52 04             	mov    0x4(%edx),%edx
  802d10:	89 50 04             	mov    %edx,0x4(%eax)
  802d13:	eb 0b                	jmp    802d20 <alloc_block_FF+0x128>
  802d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d18:	8b 40 04             	mov    0x4(%eax),%eax
  802d1b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d23:	8b 40 04             	mov    0x4(%eax),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 0f                	je     802d39 <alloc_block_FF+0x141>
  802d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2d:	8b 40 04             	mov    0x4(%eax),%eax
  802d30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d33:	8b 12                	mov    (%edx),%edx
  802d35:	89 10                	mov    %edx,(%eax)
  802d37:	eb 0a                	jmp    802d43 <alloc_block_FF+0x14b>
  802d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	a3 48 51 80 00       	mov    %eax,0x805148
  802d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d56:	a1 54 51 80 00       	mov    0x805154,%eax
  802d5b:	48                   	dec    %eax
  802d5c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 50 08             	mov    0x8(%eax),%edx
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	01 c2                	add    %eax,%edx
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 40 0c             	mov    0xc(%eax),%eax
  802d78:	2b 45 08             	sub    0x8(%ebp),%eax
  802d7b:	89 c2                	mov    %eax,%edx
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d86:	eb 3b                	jmp    802dc3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802d88:	a1 40 51 80 00       	mov    0x805140,%eax
  802d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d94:	74 07                	je     802d9d <alloc_block_FF+0x1a5>
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 00                	mov    (%eax),%eax
  802d9b:	eb 05                	jmp    802da2 <alloc_block_FF+0x1aa>
  802d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802da2:	a3 40 51 80 00       	mov    %eax,0x805140
  802da7:	a1 40 51 80 00       	mov    0x805140,%eax
  802dac:	85 c0                	test   %eax,%eax
  802dae:	0f 85 57 fe ff ff    	jne    802c0b <alloc_block_FF+0x13>
  802db4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db8:	0f 85 4d fe ff ff    	jne    802c0b <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802dbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc3:	c9                   	leave  
  802dc4:	c3                   	ret    

00802dc5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802dc5:	55                   	push   %ebp
  802dc6:	89 e5                	mov    %esp,%ebp
  802dc8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802dcb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802dd2:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dda:	e9 df 00 00 00       	jmp    802ebe <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	8b 40 0c             	mov    0xc(%eax),%eax
  802de5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de8:	0f 82 c8 00 00 00    	jb     802eb6 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 40 0c             	mov    0xc(%eax),%eax
  802df4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802df7:	0f 85 8a 00 00 00    	jne    802e87 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e01:	75 17                	jne    802e1a <alloc_block_BF+0x55>
  802e03:	83 ec 04             	sub    $0x4,%esp
  802e06:	68 c4 48 80 00       	push   $0x8048c4
  802e0b:	68 b7 00 00 00       	push   $0xb7
  802e10:	68 1b 48 80 00       	push   $0x80481b
  802e15:	e8 2a de ff ff       	call   800c44 <_panic>
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 10                	je     802e33 <alloc_block_BF+0x6e>
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2b:	8b 52 04             	mov    0x4(%edx),%edx
  802e2e:	89 50 04             	mov    %edx,0x4(%eax)
  802e31:	eb 0b                	jmp    802e3e <alloc_block_BF+0x79>
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 40 04             	mov    0x4(%eax),%eax
  802e39:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 40 04             	mov    0x4(%eax),%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	74 0f                	je     802e57 <alloc_block_BF+0x92>
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	8b 40 04             	mov    0x4(%eax),%eax
  802e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e51:	8b 12                	mov    (%edx),%edx
  802e53:	89 10                	mov    %edx,(%eax)
  802e55:	eb 0a                	jmp    802e61 <alloc_block_BF+0x9c>
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	a3 38 51 80 00       	mov    %eax,0x805138
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e74:	a1 44 51 80 00       	mov    0x805144,%eax
  802e79:	48                   	dec    %eax
  802e7a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	e9 4d 01 00 00       	jmp    802fd4 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e90:	76 24                	jbe    802eb6 <alloc_block_BF+0xf1>
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 40 0c             	mov    0xc(%eax),%eax
  802e98:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e9b:	73 19                	jae    802eb6 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802e9d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 40 08             	mov    0x8(%eax),%eax
  802eb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802eb6:	a1 40 51 80 00       	mov    0x805140,%eax
  802ebb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec2:	74 07                	je     802ecb <alloc_block_BF+0x106>
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	8b 00                	mov    (%eax),%eax
  802ec9:	eb 05                	jmp    802ed0 <alloc_block_BF+0x10b>
  802ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed0:	a3 40 51 80 00       	mov    %eax,0x805140
  802ed5:	a1 40 51 80 00       	mov    0x805140,%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	0f 85 fd fe ff ff    	jne    802ddf <alloc_block_BF+0x1a>
  802ee2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee6:	0f 85 f3 fe ff ff    	jne    802ddf <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802eec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ef0:	0f 84 d9 00 00 00    	je     802fcf <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ef6:	a1 48 51 80 00       	mov    0x805148,%eax
  802efb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802efe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f01:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f04:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0d:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802f10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f14:	75 17                	jne    802f2d <alloc_block_BF+0x168>
  802f16:	83 ec 04             	sub    $0x4,%esp
  802f19:	68 c4 48 80 00       	push   $0x8048c4
  802f1e:	68 c7 00 00 00       	push   $0xc7
  802f23:	68 1b 48 80 00       	push   $0x80481b
  802f28:	e8 17 dd ff ff       	call   800c44 <_panic>
  802f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f30:	8b 00                	mov    (%eax),%eax
  802f32:	85 c0                	test   %eax,%eax
  802f34:	74 10                	je     802f46 <alloc_block_BF+0x181>
  802f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f39:	8b 00                	mov    (%eax),%eax
  802f3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f3e:	8b 52 04             	mov    0x4(%edx),%edx
  802f41:	89 50 04             	mov    %edx,0x4(%eax)
  802f44:	eb 0b                	jmp    802f51 <alloc_block_BF+0x18c>
  802f46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f49:	8b 40 04             	mov    0x4(%eax),%eax
  802f4c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f54:	8b 40 04             	mov    0x4(%eax),%eax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	74 0f                	je     802f6a <alloc_block_BF+0x1a5>
  802f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f64:	8b 12                	mov    (%edx),%edx
  802f66:	89 10                	mov    %edx,(%eax)
  802f68:	eb 0a                	jmp    802f74 <alloc_block_BF+0x1af>
  802f6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	a3 48 51 80 00       	mov    %eax,0x805148
  802f74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f87:	a1 54 51 80 00       	mov    0x805154,%eax
  802f8c:	48                   	dec    %eax
  802f8d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802f92:	83 ec 08             	sub    $0x8,%esp
  802f95:	ff 75 ec             	pushl  -0x14(%ebp)
  802f98:	68 38 51 80 00       	push   $0x805138
  802f9d:	e8 71 f9 ff ff       	call   802913 <find_block>
  802fa2:	83 c4 10             	add    $0x10,%esp
  802fa5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fab:	8b 50 08             	mov    0x8(%eax),%edx
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	01 c2                	add    %eax,%edx
  802fb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb6:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802fb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbf:	2b 45 08             	sub    0x8(%ebp),%eax
  802fc2:	89 c2                	mov    %eax,%edx
  802fc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802fca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fcd:	eb 05                	jmp    802fd4 <alloc_block_BF+0x20f>
	}
	return NULL;
  802fcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fd4:	c9                   	leave  
  802fd5:	c3                   	ret    

00802fd6 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802fd6:	55                   	push   %ebp
  802fd7:	89 e5                	mov    %esp,%ebp
  802fd9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802fdc:	a1 28 50 80 00       	mov    0x805028,%eax
  802fe1:	85 c0                	test   %eax,%eax
  802fe3:	0f 85 de 01 00 00    	jne    8031c7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802fe9:	a1 38 51 80 00       	mov    0x805138,%eax
  802fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff1:	e9 9e 01 00 00       	jmp    803194 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fff:	0f 82 87 01 00 00    	jb     80318c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 40 0c             	mov    0xc(%eax),%eax
  80300b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300e:	0f 85 95 00 00 00    	jne    8030a9 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803014:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803018:	75 17                	jne    803031 <alloc_block_NF+0x5b>
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	68 c4 48 80 00       	push   $0x8048c4
  803022:	68 e0 00 00 00       	push   $0xe0
  803027:	68 1b 48 80 00       	push   $0x80481b
  80302c:	e8 13 dc ff ff       	call   800c44 <_panic>
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	74 10                	je     80304a <alloc_block_NF+0x74>
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	8b 00                	mov    (%eax),%eax
  80303f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803042:	8b 52 04             	mov    0x4(%edx),%edx
  803045:	89 50 04             	mov    %edx,0x4(%eax)
  803048:	eb 0b                	jmp    803055 <alloc_block_NF+0x7f>
  80304a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304d:	8b 40 04             	mov    0x4(%eax),%eax
  803050:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803058:	8b 40 04             	mov    0x4(%eax),%eax
  80305b:	85 c0                	test   %eax,%eax
  80305d:	74 0f                	je     80306e <alloc_block_NF+0x98>
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	8b 40 04             	mov    0x4(%eax),%eax
  803065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803068:	8b 12                	mov    (%edx),%edx
  80306a:	89 10                	mov    %edx,(%eax)
  80306c:	eb 0a                	jmp    803078 <alloc_block_NF+0xa2>
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	a3 38 51 80 00       	mov    %eax,0x805138
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308b:	a1 44 51 80 00       	mov    0x805144,%eax
  803090:	48                   	dec    %eax
  803091:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 40 08             	mov    0x8(%eax),%eax
  80309c:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	e9 f8 04 00 00       	jmp    8035a1 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8030af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b2:	0f 86 d4 00 00 00    	jbe    80318c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8030bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 50 08             	mov    0x8(%eax),%edx
  8030c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8030cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d2:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030d9:	75 17                	jne    8030f2 <alloc_block_NF+0x11c>
  8030db:	83 ec 04             	sub    $0x4,%esp
  8030de:	68 c4 48 80 00       	push   $0x8048c4
  8030e3:	68 e9 00 00 00       	push   $0xe9
  8030e8:	68 1b 48 80 00       	push   $0x80481b
  8030ed:	e8 52 db ff ff       	call   800c44 <_panic>
  8030f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f5:	8b 00                	mov    (%eax),%eax
  8030f7:	85 c0                	test   %eax,%eax
  8030f9:	74 10                	je     80310b <alloc_block_NF+0x135>
  8030fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fe:	8b 00                	mov    (%eax),%eax
  803100:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803103:	8b 52 04             	mov    0x4(%edx),%edx
  803106:	89 50 04             	mov    %edx,0x4(%eax)
  803109:	eb 0b                	jmp    803116 <alloc_block_NF+0x140>
  80310b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310e:	8b 40 04             	mov    0x4(%eax),%eax
  803111:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803119:	8b 40 04             	mov    0x4(%eax),%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	74 0f                	je     80312f <alloc_block_NF+0x159>
  803120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803123:	8b 40 04             	mov    0x4(%eax),%eax
  803126:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803129:	8b 12                	mov    (%edx),%edx
  80312b:	89 10                	mov    %edx,(%eax)
  80312d:	eb 0a                	jmp    803139 <alloc_block_NF+0x163>
  80312f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803132:	8b 00                	mov    (%eax),%eax
  803134:	a3 48 51 80 00       	mov    %eax,0x805148
  803139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803145:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314c:	a1 54 51 80 00       	mov    0x805154,%eax
  803151:	48                   	dec    %eax
  803152:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315a:	8b 40 08             	mov    0x8(%eax),%eax
  80315d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803165:	8b 50 08             	mov    0x8(%eax),%edx
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	01 c2                	add    %eax,%edx
  80316d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803170:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803176:	8b 40 0c             	mov    0xc(%eax),%eax
  803179:	2b 45 08             	sub    0x8(%ebp),%eax
  80317c:	89 c2                	mov    %eax,%edx
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803187:	e9 15 04 00 00       	jmp    8035a1 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80318c:	a1 40 51 80 00       	mov    0x805140,%eax
  803191:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803194:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803198:	74 07                	je     8031a1 <alloc_block_NF+0x1cb>
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	eb 05                	jmp    8031a6 <alloc_block_NF+0x1d0>
  8031a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a6:	a3 40 51 80 00       	mov    %eax,0x805140
  8031ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8031b0:	85 c0                	test   %eax,%eax
  8031b2:	0f 85 3e fe ff ff    	jne    802ff6 <alloc_block_NF+0x20>
  8031b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031bc:	0f 85 34 fe ff ff    	jne    802ff6 <alloc_block_NF+0x20>
  8031c2:	e9 d5 03 00 00       	jmp    80359c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8031cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031cf:	e9 b1 01 00 00       	jmp    803385 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8031d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d7:	8b 50 08             	mov    0x8(%eax),%edx
  8031da:	a1 28 50 80 00       	mov    0x805028,%eax
  8031df:	39 c2                	cmp    %eax,%edx
  8031e1:	0f 82 96 01 00 00    	jb     80337d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8031e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f0:	0f 82 87 01 00 00    	jb     80337d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8031f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ff:	0f 85 95 00 00 00    	jne    80329a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803209:	75 17                	jne    803222 <alloc_block_NF+0x24c>
  80320b:	83 ec 04             	sub    $0x4,%esp
  80320e:	68 c4 48 80 00       	push   $0x8048c4
  803213:	68 fc 00 00 00       	push   $0xfc
  803218:	68 1b 48 80 00       	push   $0x80481b
  80321d:	e8 22 da ff ff       	call   800c44 <_panic>
  803222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803225:	8b 00                	mov    (%eax),%eax
  803227:	85 c0                	test   %eax,%eax
  803229:	74 10                	je     80323b <alloc_block_NF+0x265>
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	8b 00                	mov    (%eax),%eax
  803230:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803233:	8b 52 04             	mov    0x4(%edx),%edx
  803236:	89 50 04             	mov    %edx,0x4(%eax)
  803239:	eb 0b                	jmp    803246 <alloc_block_NF+0x270>
  80323b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323e:	8b 40 04             	mov    0x4(%eax),%eax
  803241:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	8b 40 04             	mov    0x4(%eax),%eax
  80324c:	85 c0                	test   %eax,%eax
  80324e:	74 0f                	je     80325f <alloc_block_NF+0x289>
  803250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803253:	8b 40 04             	mov    0x4(%eax),%eax
  803256:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803259:	8b 12                	mov    (%edx),%edx
  80325b:	89 10                	mov    %edx,(%eax)
  80325d:	eb 0a                	jmp    803269 <alloc_block_NF+0x293>
  80325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	a3 38 51 80 00       	mov    %eax,0x805138
  803269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803275:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327c:	a1 44 51 80 00       	mov    0x805144,%eax
  803281:	48                   	dec    %eax
  803282:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	8b 40 08             	mov    0x8(%eax),%eax
  80328d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	e9 07 03 00 00       	jmp    8035a1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80329a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329d:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032a3:	0f 86 d4 00 00 00    	jbe    80337d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	8b 50 08             	mov    0x8(%eax),%edx
  8032b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ba:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ca:	75 17                	jne    8032e3 <alloc_block_NF+0x30d>
  8032cc:	83 ec 04             	sub    $0x4,%esp
  8032cf:	68 c4 48 80 00       	push   $0x8048c4
  8032d4:	68 04 01 00 00       	push   $0x104
  8032d9:	68 1b 48 80 00       	push   $0x80481b
  8032de:	e8 61 d9 ff ff       	call   800c44 <_panic>
  8032e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e6:	8b 00                	mov    (%eax),%eax
  8032e8:	85 c0                	test   %eax,%eax
  8032ea:	74 10                	je     8032fc <alloc_block_NF+0x326>
  8032ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ef:	8b 00                	mov    (%eax),%eax
  8032f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f4:	8b 52 04             	mov    0x4(%edx),%edx
  8032f7:	89 50 04             	mov    %edx,0x4(%eax)
  8032fa:	eb 0b                	jmp    803307 <alloc_block_NF+0x331>
  8032fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ff:	8b 40 04             	mov    0x4(%eax),%eax
  803302:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803307:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330a:	8b 40 04             	mov    0x4(%eax),%eax
  80330d:	85 c0                	test   %eax,%eax
  80330f:	74 0f                	je     803320 <alloc_block_NF+0x34a>
  803311:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803314:	8b 40 04             	mov    0x4(%eax),%eax
  803317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331a:	8b 12                	mov    (%edx),%edx
  80331c:	89 10                	mov    %edx,(%eax)
  80331e:	eb 0a                	jmp    80332a <alloc_block_NF+0x354>
  803320:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803323:	8b 00                	mov    (%eax),%eax
  803325:	a3 48 51 80 00       	mov    %eax,0x805148
  80332a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803336:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333d:	a1 54 51 80 00       	mov    0x805154,%eax
  803342:	48                   	dec    %eax
  803343:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334b:	8b 40 08             	mov    0x8(%eax),%eax
  80334e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803356:	8b 50 08             	mov    0x8(%eax),%edx
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	01 c2                	add    %eax,%edx
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803367:	8b 40 0c             	mov    0xc(%eax),%eax
  80336a:	2b 45 08             	sub    0x8(%ebp),%eax
  80336d:	89 c2                	mov    %eax,%edx
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	e9 24 02 00 00       	jmp    8035a1 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80337d:	a1 40 51 80 00       	mov    0x805140,%eax
  803382:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803389:	74 07                	je     803392 <alloc_block_NF+0x3bc>
  80338b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338e:	8b 00                	mov    (%eax),%eax
  803390:	eb 05                	jmp    803397 <alloc_block_NF+0x3c1>
  803392:	b8 00 00 00 00       	mov    $0x0,%eax
  803397:	a3 40 51 80 00       	mov    %eax,0x805140
  80339c:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a1:	85 c0                	test   %eax,%eax
  8033a3:	0f 85 2b fe ff ff    	jne    8031d4 <alloc_block_NF+0x1fe>
  8033a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ad:	0f 85 21 fe ff ff    	jne    8031d4 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8033b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033bb:	e9 ae 01 00 00       	jmp    80356e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c3:	8b 50 08             	mov    0x8(%eax),%edx
  8033c6:	a1 28 50 80 00       	mov    0x805028,%eax
  8033cb:	39 c2                	cmp    %eax,%edx
  8033cd:	0f 83 93 01 00 00    	jae    803566 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033dc:	0f 82 84 01 00 00    	jb     803566 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033eb:	0f 85 95 00 00 00    	jne    803486 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8033f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f5:	75 17                	jne    80340e <alloc_block_NF+0x438>
  8033f7:	83 ec 04             	sub    $0x4,%esp
  8033fa:	68 c4 48 80 00       	push   $0x8048c4
  8033ff:	68 14 01 00 00       	push   $0x114
  803404:	68 1b 48 80 00       	push   $0x80481b
  803409:	e8 36 d8 ff ff       	call   800c44 <_panic>
  80340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803411:	8b 00                	mov    (%eax),%eax
  803413:	85 c0                	test   %eax,%eax
  803415:	74 10                	je     803427 <alloc_block_NF+0x451>
  803417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341a:	8b 00                	mov    (%eax),%eax
  80341c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80341f:	8b 52 04             	mov    0x4(%edx),%edx
  803422:	89 50 04             	mov    %edx,0x4(%eax)
  803425:	eb 0b                	jmp    803432 <alloc_block_NF+0x45c>
  803427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342a:	8b 40 04             	mov    0x4(%eax),%eax
  80342d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803435:	8b 40 04             	mov    0x4(%eax),%eax
  803438:	85 c0                	test   %eax,%eax
  80343a:	74 0f                	je     80344b <alloc_block_NF+0x475>
  80343c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343f:	8b 40 04             	mov    0x4(%eax),%eax
  803442:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803445:	8b 12                	mov    (%edx),%edx
  803447:	89 10                	mov    %edx,(%eax)
  803449:	eb 0a                	jmp    803455 <alloc_block_NF+0x47f>
  80344b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344e:	8b 00                	mov    (%eax),%eax
  803450:	a3 38 51 80 00       	mov    %eax,0x805138
  803455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80345e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803461:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803468:	a1 44 51 80 00       	mov    0x805144,%eax
  80346d:	48                   	dec    %eax
  80346e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	8b 40 08             	mov    0x8(%eax),%eax
  803479:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	e9 1b 01 00 00       	jmp    8035a1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	8b 40 0c             	mov    0xc(%eax),%eax
  80348c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80348f:	0f 86 d1 00 00 00    	jbe    803566 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803495:	a1 48 51 80 00       	mov    0x805148,%eax
  80349a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80349d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a0:	8b 50 08             	mov    0x8(%eax),%edx
  8034a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8034a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8034af:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8034b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034b6:	75 17                	jne    8034cf <alloc_block_NF+0x4f9>
  8034b8:	83 ec 04             	sub    $0x4,%esp
  8034bb:	68 c4 48 80 00       	push   $0x8048c4
  8034c0:	68 1c 01 00 00       	push   $0x11c
  8034c5:	68 1b 48 80 00       	push   $0x80481b
  8034ca:	e8 75 d7 ff ff       	call   800c44 <_panic>
  8034cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d2:	8b 00                	mov    (%eax),%eax
  8034d4:	85 c0                	test   %eax,%eax
  8034d6:	74 10                	je     8034e8 <alloc_block_NF+0x512>
  8034d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034db:	8b 00                	mov    (%eax),%eax
  8034dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034e0:	8b 52 04             	mov    0x4(%edx),%edx
  8034e3:	89 50 04             	mov    %edx,0x4(%eax)
  8034e6:	eb 0b                	jmp    8034f3 <alloc_block_NF+0x51d>
  8034e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034eb:	8b 40 04             	mov    0x4(%eax),%eax
  8034ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f6:	8b 40 04             	mov    0x4(%eax),%eax
  8034f9:	85 c0                	test   %eax,%eax
  8034fb:	74 0f                	je     80350c <alloc_block_NF+0x536>
  8034fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803500:	8b 40 04             	mov    0x4(%eax),%eax
  803503:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803506:	8b 12                	mov    (%edx),%edx
  803508:	89 10                	mov    %edx,(%eax)
  80350a:	eb 0a                	jmp    803516 <alloc_block_NF+0x540>
  80350c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350f:	8b 00                	mov    (%eax),%eax
  803511:	a3 48 51 80 00       	mov    %eax,0x805148
  803516:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80351f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803522:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803529:	a1 54 51 80 00       	mov    0x805154,%eax
  80352e:	48                   	dec    %eax
  80352f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803537:	8b 40 08             	mov    0x8(%eax),%eax
  80353a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80353f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803542:	8b 50 08             	mov    0x8(%eax),%edx
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	01 c2                	add    %eax,%edx
  80354a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803553:	8b 40 0c             	mov    0xc(%eax),%eax
  803556:	2b 45 08             	sub    0x8(%ebp),%eax
  803559:	89 c2                	mov    %eax,%edx
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803561:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803564:	eb 3b                	jmp    8035a1 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803566:	a1 40 51 80 00       	mov    0x805140,%eax
  80356b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80356e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803572:	74 07                	je     80357b <alloc_block_NF+0x5a5>
  803574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803577:	8b 00                	mov    (%eax),%eax
  803579:	eb 05                	jmp    803580 <alloc_block_NF+0x5aa>
  80357b:	b8 00 00 00 00       	mov    $0x0,%eax
  803580:	a3 40 51 80 00       	mov    %eax,0x805140
  803585:	a1 40 51 80 00       	mov    0x805140,%eax
  80358a:	85 c0                	test   %eax,%eax
  80358c:	0f 85 2e fe ff ff    	jne    8033c0 <alloc_block_NF+0x3ea>
  803592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803596:	0f 85 24 fe ff ff    	jne    8033c0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80359c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035a1:	c9                   	leave  
  8035a2:	c3                   	ret    

008035a3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8035a3:	55                   	push   %ebp
  8035a4:	89 e5                	mov    %esp,%ebp
  8035a6:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8035a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8035ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8035b1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035b6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8035b9:	a1 38 51 80 00       	mov    0x805138,%eax
  8035be:	85 c0                	test   %eax,%eax
  8035c0:	74 14                	je     8035d6 <insert_sorted_with_merge_freeList+0x33>
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	8b 50 08             	mov    0x8(%eax),%edx
  8035c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035cb:	8b 40 08             	mov    0x8(%eax),%eax
  8035ce:	39 c2                	cmp    %eax,%edx
  8035d0:	0f 87 9b 01 00 00    	ja     803771 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8035d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035da:	75 17                	jne    8035f3 <insert_sorted_with_merge_freeList+0x50>
  8035dc:	83 ec 04             	sub    $0x4,%esp
  8035df:	68 f8 47 80 00       	push   $0x8047f8
  8035e4:	68 38 01 00 00       	push   $0x138
  8035e9:	68 1b 48 80 00       	push   $0x80481b
  8035ee:	e8 51 d6 ff ff       	call   800c44 <_panic>
  8035f3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	89 10                	mov    %edx,(%eax)
  8035fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803601:	8b 00                	mov    (%eax),%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	74 0d                	je     803614 <insert_sorted_with_merge_freeList+0x71>
  803607:	a1 38 51 80 00       	mov    0x805138,%eax
  80360c:	8b 55 08             	mov    0x8(%ebp),%edx
  80360f:	89 50 04             	mov    %edx,0x4(%eax)
  803612:	eb 08                	jmp    80361c <insert_sorted_with_merge_freeList+0x79>
  803614:	8b 45 08             	mov    0x8(%ebp),%eax
  803617:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	a3 38 51 80 00       	mov    %eax,0x805138
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362e:	a1 44 51 80 00       	mov    0x805144,%eax
  803633:	40                   	inc    %eax
  803634:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803639:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80363d:	0f 84 a8 06 00 00    	je     803ceb <insert_sorted_with_merge_freeList+0x748>
  803643:	8b 45 08             	mov    0x8(%ebp),%eax
  803646:	8b 50 08             	mov    0x8(%eax),%edx
  803649:	8b 45 08             	mov    0x8(%ebp),%eax
  80364c:	8b 40 0c             	mov    0xc(%eax),%eax
  80364f:	01 c2                	add    %eax,%edx
  803651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803654:	8b 40 08             	mov    0x8(%eax),%eax
  803657:	39 c2                	cmp    %eax,%edx
  803659:	0f 85 8c 06 00 00    	jne    803ceb <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	8b 50 0c             	mov    0xc(%eax),%edx
  803665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803668:	8b 40 0c             	mov    0xc(%eax),%eax
  80366b:	01 c2                	add    %eax,%edx
  80366d:	8b 45 08             	mov    0x8(%ebp),%eax
  803670:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803673:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803677:	75 17                	jne    803690 <insert_sorted_with_merge_freeList+0xed>
  803679:	83 ec 04             	sub    $0x4,%esp
  80367c:	68 c4 48 80 00       	push   $0x8048c4
  803681:	68 3c 01 00 00       	push   $0x13c
  803686:	68 1b 48 80 00       	push   $0x80481b
  80368b:	e8 b4 d5 ff ff       	call   800c44 <_panic>
  803690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803693:	8b 00                	mov    (%eax),%eax
  803695:	85 c0                	test   %eax,%eax
  803697:	74 10                	je     8036a9 <insert_sorted_with_merge_freeList+0x106>
  803699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036a1:	8b 52 04             	mov    0x4(%edx),%edx
  8036a4:	89 50 04             	mov    %edx,0x4(%eax)
  8036a7:	eb 0b                	jmp    8036b4 <insert_sorted_with_merge_freeList+0x111>
  8036a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ac:	8b 40 04             	mov    0x4(%eax),%eax
  8036af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b7:	8b 40 04             	mov    0x4(%eax),%eax
  8036ba:	85 c0                	test   %eax,%eax
  8036bc:	74 0f                	je     8036cd <insert_sorted_with_merge_freeList+0x12a>
  8036be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c1:	8b 40 04             	mov    0x4(%eax),%eax
  8036c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036c7:	8b 12                	mov    (%edx),%edx
  8036c9:	89 10                	mov    %edx,(%eax)
  8036cb:	eb 0a                	jmp    8036d7 <insert_sorted_with_merge_freeList+0x134>
  8036cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d0:	8b 00                	mov    (%eax),%eax
  8036d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8036d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8036ef:	48                   	dec    %eax
  8036f0:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8036f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8036ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803702:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803709:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80370d:	75 17                	jne    803726 <insert_sorted_with_merge_freeList+0x183>
  80370f:	83 ec 04             	sub    $0x4,%esp
  803712:	68 f8 47 80 00       	push   $0x8047f8
  803717:	68 3f 01 00 00       	push   $0x13f
  80371c:	68 1b 48 80 00       	push   $0x80481b
  803721:	e8 1e d5 ff ff       	call   800c44 <_panic>
  803726:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80372c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372f:	89 10                	mov    %edx,(%eax)
  803731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803734:	8b 00                	mov    (%eax),%eax
  803736:	85 c0                	test   %eax,%eax
  803738:	74 0d                	je     803747 <insert_sorted_with_merge_freeList+0x1a4>
  80373a:	a1 48 51 80 00       	mov    0x805148,%eax
  80373f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803742:	89 50 04             	mov    %edx,0x4(%eax)
  803745:	eb 08                	jmp    80374f <insert_sorted_with_merge_freeList+0x1ac>
  803747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80374f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803752:	a3 48 51 80 00       	mov    %eax,0x805148
  803757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803761:	a1 54 51 80 00       	mov    0x805154,%eax
  803766:	40                   	inc    %eax
  803767:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80376c:	e9 7a 05 00 00       	jmp    803ceb <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	8b 50 08             	mov    0x8(%eax),%edx
  803777:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377a:	8b 40 08             	mov    0x8(%eax),%eax
  80377d:	39 c2                	cmp    %eax,%edx
  80377f:	0f 82 14 01 00 00    	jb     803899 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803788:	8b 50 08             	mov    0x8(%eax),%edx
  80378b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80378e:	8b 40 0c             	mov    0xc(%eax),%eax
  803791:	01 c2                	add    %eax,%edx
  803793:	8b 45 08             	mov    0x8(%ebp),%eax
  803796:	8b 40 08             	mov    0x8(%eax),%eax
  803799:	39 c2                	cmp    %eax,%edx
  80379b:	0f 85 90 00 00 00    	jne    803831 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8037a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a4:	8b 50 0c             	mov    0xc(%eax),%edx
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ad:	01 c2                	add    %eax,%edx
  8037af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b2:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8037b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8037bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037cd:	75 17                	jne    8037e6 <insert_sorted_with_merge_freeList+0x243>
  8037cf:	83 ec 04             	sub    $0x4,%esp
  8037d2:	68 f8 47 80 00       	push   $0x8047f8
  8037d7:	68 49 01 00 00       	push   $0x149
  8037dc:	68 1b 48 80 00       	push   $0x80481b
  8037e1:	e8 5e d4 ff ff       	call   800c44 <_panic>
  8037e6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ef:	89 10                	mov    %edx,(%eax)
  8037f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f4:	8b 00                	mov    (%eax),%eax
  8037f6:	85 c0                	test   %eax,%eax
  8037f8:	74 0d                	je     803807 <insert_sorted_with_merge_freeList+0x264>
  8037fa:	a1 48 51 80 00       	mov    0x805148,%eax
  8037ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803802:	89 50 04             	mov    %edx,0x4(%eax)
  803805:	eb 08                	jmp    80380f <insert_sorted_with_merge_freeList+0x26c>
  803807:	8b 45 08             	mov    0x8(%ebp),%eax
  80380a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80380f:	8b 45 08             	mov    0x8(%ebp),%eax
  803812:	a3 48 51 80 00       	mov    %eax,0x805148
  803817:	8b 45 08             	mov    0x8(%ebp),%eax
  80381a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803821:	a1 54 51 80 00       	mov    0x805154,%eax
  803826:	40                   	inc    %eax
  803827:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80382c:	e9 bb 04 00 00       	jmp    803cec <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803831:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803835:	75 17                	jne    80384e <insert_sorted_with_merge_freeList+0x2ab>
  803837:	83 ec 04             	sub    $0x4,%esp
  80383a:	68 6c 48 80 00       	push   $0x80486c
  80383f:	68 4c 01 00 00       	push   $0x14c
  803844:	68 1b 48 80 00       	push   $0x80481b
  803849:	e8 f6 d3 ff ff       	call   800c44 <_panic>
  80384e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803854:	8b 45 08             	mov    0x8(%ebp),%eax
  803857:	89 50 04             	mov    %edx,0x4(%eax)
  80385a:	8b 45 08             	mov    0x8(%ebp),%eax
  80385d:	8b 40 04             	mov    0x4(%eax),%eax
  803860:	85 c0                	test   %eax,%eax
  803862:	74 0c                	je     803870 <insert_sorted_with_merge_freeList+0x2cd>
  803864:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803869:	8b 55 08             	mov    0x8(%ebp),%edx
  80386c:	89 10                	mov    %edx,(%eax)
  80386e:	eb 08                	jmp    803878 <insert_sorted_with_merge_freeList+0x2d5>
  803870:	8b 45 08             	mov    0x8(%ebp),%eax
  803873:	a3 38 51 80 00       	mov    %eax,0x805138
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803880:	8b 45 08             	mov    0x8(%ebp),%eax
  803883:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803889:	a1 44 51 80 00       	mov    0x805144,%eax
  80388e:	40                   	inc    %eax
  80388f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803894:	e9 53 04 00 00       	jmp    803cec <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803899:	a1 38 51 80 00       	mov    0x805138,%eax
  80389e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038a1:	e9 15 04 00 00       	jmp    803cbb <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8038a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a9:	8b 00                	mov    (%eax),%eax
  8038ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8038ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b1:	8b 50 08             	mov    0x8(%eax),%edx
  8038b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b7:	8b 40 08             	mov    0x8(%eax),%eax
  8038ba:	39 c2                	cmp    %eax,%edx
  8038bc:	0f 86 f1 03 00 00    	jbe    803cb3 <insert_sorted_with_merge_freeList+0x710>
  8038c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c5:	8b 50 08             	mov    0x8(%eax),%edx
  8038c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038cb:	8b 40 08             	mov    0x8(%eax),%eax
  8038ce:	39 c2                	cmp    %eax,%edx
  8038d0:	0f 83 dd 03 00 00    	jae    803cb3 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8038d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d9:	8b 50 08             	mov    0x8(%eax),%edx
  8038dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038df:	8b 40 0c             	mov    0xc(%eax),%eax
  8038e2:	01 c2                	add    %eax,%edx
  8038e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e7:	8b 40 08             	mov    0x8(%eax),%eax
  8038ea:	39 c2                	cmp    %eax,%edx
  8038ec:	0f 85 b9 01 00 00    	jne    803aab <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f5:	8b 50 08             	mov    0x8(%eax),%edx
  8038f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8038fe:	01 c2                	add    %eax,%edx
  803900:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803903:	8b 40 08             	mov    0x8(%eax),%eax
  803906:	39 c2                	cmp    %eax,%edx
  803908:	0f 85 0d 01 00 00    	jne    803a1b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80390e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803911:	8b 50 0c             	mov    0xc(%eax),%edx
  803914:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803917:	8b 40 0c             	mov    0xc(%eax),%eax
  80391a:	01 c2                	add    %eax,%edx
  80391c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803922:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803926:	75 17                	jne    80393f <insert_sorted_with_merge_freeList+0x39c>
  803928:	83 ec 04             	sub    $0x4,%esp
  80392b:	68 c4 48 80 00       	push   $0x8048c4
  803930:	68 5c 01 00 00       	push   $0x15c
  803935:	68 1b 48 80 00       	push   $0x80481b
  80393a:	e8 05 d3 ff ff       	call   800c44 <_panic>
  80393f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803942:	8b 00                	mov    (%eax),%eax
  803944:	85 c0                	test   %eax,%eax
  803946:	74 10                	je     803958 <insert_sorted_with_merge_freeList+0x3b5>
  803948:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394b:	8b 00                	mov    (%eax),%eax
  80394d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803950:	8b 52 04             	mov    0x4(%edx),%edx
  803953:	89 50 04             	mov    %edx,0x4(%eax)
  803956:	eb 0b                	jmp    803963 <insert_sorted_with_merge_freeList+0x3c0>
  803958:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395b:	8b 40 04             	mov    0x4(%eax),%eax
  80395e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803963:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803966:	8b 40 04             	mov    0x4(%eax),%eax
  803969:	85 c0                	test   %eax,%eax
  80396b:	74 0f                	je     80397c <insert_sorted_with_merge_freeList+0x3d9>
  80396d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803970:	8b 40 04             	mov    0x4(%eax),%eax
  803973:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803976:	8b 12                	mov    (%edx),%edx
  803978:	89 10                	mov    %edx,(%eax)
  80397a:	eb 0a                	jmp    803986 <insert_sorted_with_merge_freeList+0x3e3>
  80397c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397f:	8b 00                	mov    (%eax),%eax
  803981:	a3 38 51 80 00       	mov    %eax,0x805138
  803986:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803989:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80398f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803992:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803999:	a1 44 51 80 00       	mov    0x805144,%eax
  80399e:	48                   	dec    %eax
  80399f:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8039a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8039ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039bc:	75 17                	jne    8039d5 <insert_sorted_with_merge_freeList+0x432>
  8039be:	83 ec 04             	sub    $0x4,%esp
  8039c1:	68 f8 47 80 00       	push   $0x8047f8
  8039c6:	68 5f 01 00 00       	push   $0x15f
  8039cb:	68 1b 48 80 00       	push   $0x80481b
  8039d0:	e8 6f d2 ff ff       	call   800c44 <_panic>
  8039d5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039de:	89 10                	mov    %edx,(%eax)
  8039e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e3:	8b 00                	mov    (%eax),%eax
  8039e5:	85 c0                	test   %eax,%eax
  8039e7:	74 0d                	je     8039f6 <insert_sorted_with_merge_freeList+0x453>
  8039e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8039ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039f1:	89 50 04             	mov    %edx,0x4(%eax)
  8039f4:	eb 08                	jmp    8039fe <insert_sorted_with_merge_freeList+0x45b>
  8039f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a01:	a3 48 51 80 00       	mov    %eax,0x805148
  803a06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a10:	a1 54 51 80 00       	mov    0x805154,%eax
  803a15:	40                   	inc    %eax
  803a16:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1e:	8b 50 0c             	mov    0xc(%eax),%edx
  803a21:	8b 45 08             	mov    0x8(%ebp),%eax
  803a24:	8b 40 0c             	mov    0xc(%eax),%eax
  803a27:	01 c2                	add    %eax,%edx
  803a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a39:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a47:	75 17                	jne    803a60 <insert_sorted_with_merge_freeList+0x4bd>
  803a49:	83 ec 04             	sub    $0x4,%esp
  803a4c:	68 f8 47 80 00       	push   $0x8047f8
  803a51:	68 64 01 00 00       	push   $0x164
  803a56:	68 1b 48 80 00       	push   $0x80481b
  803a5b:	e8 e4 d1 ff ff       	call   800c44 <_panic>
  803a60:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a66:	8b 45 08             	mov    0x8(%ebp),%eax
  803a69:	89 10                	mov    %edx,(%eax)
  803a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6e:	8b 00                	mov    (%eax),%eax
  803a70:	85 c0                	test   %eax,%eax
  803a72:	74 0d                	je     803a81 <insert_sorted_with_merge_freeList+0x4de>
  803a74:	a1 48 51 80 00       	mov    0x805148,%eax
  803a79:	8b 55 08             	mov    0x8(%ebp),%edx
  803a7c:	89 50 04             	mov    %edx,0x4(%eax)
  803a7f:	eb 08                	jmp    803a89 <insert_sorted_with_merge_freeList+0x4e6>
  803a81:	8b 45 08             	mov    0x8(%ebp),%eax
  803a84:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a89:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8c:	a3 48 51 80 00       	mov    %eax,0x805148
  803a91:	8b 45 08             	mov    0x8(%ebp),%eax
  803a94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a9b:	a1 54 51 80 00       	mov    0x805154,%eax
  803aa0:	40                   	inc    %eax
  803aa1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803aa6:	e9 41 02 00 00       	jmp    803cec <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803aab:	8b 45 08             	mov    0x8(%ebp),%eax
  803aae:	8b 50 08             	mov    0x8(%eax),%edx
  803ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab4:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab7:	01 c2                	add    %eax,%edx
  803ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803abc:	8b 40 08             	mov    0x8(%eax),%eax
  803abf:	39 c2                	cmp    %eax,%edx
  803ac1:	0f 85 7c 01 00 00    	jne    803c43 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803ac7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803acb:	74 06                	je     803ad3 <insert_sorted_with_merge_freeList+0x530>
  803acd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ad1:	75 17                	jne    803aea <insert_sorted_with_merge_freeList+0x547>
  803ad3:	83 ec 04             	sub    $0x4,%esp
  803ad6:	68 34 48 80 00       	push   $0x804834
  803adb:	68 69 01 00 00       	push   $0x169
  803ae0:	68 1b 48 80 00       	push   $0x80481b
  803ae5:	e8 5a d1 ff ff       	call   800c44 <_panic>
  803aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aed:	8b 50 04             	mov    0x4(%eax),%edx
  803af0:	8b 45 08             	mov    0x8(%ebp),%eax
  803af3:	89 50 04             	mov    %edx,0x4(%eax)
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803afc:	89 10                	mov    %edx,(%eax)
  803afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b01:	8b 40 04             	mov    0x4(%eax),%eax
  803b04:	85 c0                	test   %eax,%eax
  803b06:	74 0d                	je     803b15 <insert_sorted_with_merge_freeList+0x572>
  803b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0b:	8b 40 04             	mov    0x4(%eax),%eax
  803b0e:	8b 55 08             	mov    0x8(%ebp),%edx
  803b11:	89 10                	mov    %edx,(%eax)
  803b13:	eb 08                	jmp    803b1d <insert_sorted_with_merge_freeList+0x57a>
  803b15:	8b 45 08             	mov    0x8(%ebp),%eax
  803b18:	a3 38 51 80 00       	mov    %eax,0x805138
  803b1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b20:	8b 55 08             	mov    0x8(%ebp),%edx
  803b23:	89 50 04             	mov    %edx,0x4(%eax)
  803b26:	a1 44 51 80 00       	mov    0x805144,%eax
  803b2b:	40                   	inc    %eax
  803b2c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b31:	8b 45 08             	mov    0x8(%ebp),%eax
  803b34:	8b 50 0c             	mov    0xc(%eax),%edx
  803b37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b3a:	8b 40 0c             	mov    0xc(%eax),%eax
  803b3d:	01 c2                	add    %eax,%edx
  803b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b42:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b49:	75 17                	jne    803b62 <insert_sorted_with_merge_freeList+0x5bf>
  803b4b:	83 ec 04             	sub    $0x4,%esp
  803b4e:	68 c4 48 80 00       	push   $0x8048c4
  803b53:	68 6b 01 00 00       	push   $0x16b
  803b58:	68 1b 48 80 00       	push   $0x80481b
  803b5d:	e8 e2 d0 ff ff       	call   800c44 <_panic>
  803b62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b65:	8b 00                	mov    (%eax),%eax
  803b67:	85 c0                	test   %eax,%eax
  803b69:	74 10                	je     803b7b <insert_sorted_with_merge_freeList+0x5d8>
  803b6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6e:	8b 00                	mov    (%eax),%eax
  803b70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b73:	8b 52 04             	mov    0x4(%edx),%edx
  803b76:	89 50 04             	mov    %edx,0x4(%eax)
  803b79:	eb 0b                	jmp    803b86 <insert_sorted_with_merge_freeList+0x5e3>
  803b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7e:	8b 40 04             	mov    0x4(%eax),%eax
  803b81:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b89:	8b 40 04             	mov    0x4(%eax),%eax
  803b8c:	85 c0                	test   %eax,%eax
  803b8e:	74 0f                	je     803b9f <insert_sorted_with_merge_freeList+0x5fc>
  803b90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b93:	8b 40 04             	mov    0x4(%eax),%eax
  803b96:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b99:	8b 12                	mov    (%edx),%edx
  803b9b:	89 10                	mov    %edx,(%eax)
  803b9d:	eb 0a                	jmp    803ba9 <insert_sorted_with_merge_freeList+0x606>
  803b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba2:	8b 00                	mov    (%eax),%eax
  803ba4:	a3 38 51 80 00       	mov    %eax,0x805138
  803ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bbc:	a1 44 51 80 00       	mov    0x805144,%eax
  803bc1:	48                   	dec    %eax
  803bc2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803bdb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bdf:	75 17                	jne    803bf8 <insert_sorted_with_merge_freeList+0x655>
  803be1:	83 ec 04             	sub    $0x4,%esp
  803be4:	68 f8 47 80 00       	push   $0x8047f8
  803be9:	68 6e 01 00 00       	push   $0x16e
  803bee:	68 1b 48 80 00       	push   $0x80481b
  803bf3:	e8 4c d0 ff ff       	call   800c44 <_panic>
  803bf8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c01:	89 10                	mov    %edx,(%eax)
  803c03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c06:	8b 00                	mov    (%eax),%eax
  803c08:	85 c0                	test   %eax,%eax
  803c0a:	74 0d                	je     803c19 <insert_sorted_with_merge_freeList+0x676>
  803c0c:	a1 48 51 80 00       	mov    0x805148,%eax
  803c11:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c14:	89 50 04             	mov    %edx,0x4(%eax)
  803c17:	eb 08                	jmp    803c21 <insert_sorted_with_merge_freeList+0x67e>
  803c19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c1c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c24:	a3 48 51 80 00       	mov    %eax,0x805148
  803c29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c33:	a1 54 51 80 00       	mov    0x805154,%eax
  803c38:	40                   	inc    %eax
  803c39:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c3e:	e9 a9 00 00 00       	jmp    803cec <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c47:	74 06                	je     803c4f <insert_sorted_with_merge_freeList+0x6ac>
  803c49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c4d:	75 17                	jne    803c66 <insert_sorted_with_merge_freeList+0x6c3>
  803c4f:	83 ec 04             	sub    $0x4,%esp
  803c52:	68 90 48 80 00       	push   $0x804890
  803c57:	68 73 01 00 00       	push   $0x173
  803c5c:	68 1b 48 80 00       	push   $0x80481b
  803c61:	e8 de cf ff ff       	call   800c44 <_panic>
  803c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c69:	8b 10                	mov    (%eax),%edx
  803c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6e:	89 10                	mov    %edx,(%eax)
  803c70:	8b 45 08             	mov    0x8(%ebp),%eax
  803c73:	8b 00                	mov    (%eax),%eax
  803c75:	85 c0                	test   %eax,%eax
  803c77:	74 0b                	je     803c84 <insert_sorted_with_merge_freeList+0x6e1>
  803c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7c:	8b 00                	mov    (%eax),%eax
  803c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  803c81:	89 50 04             	mov    %edx,0x4(%eax)
  803c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c87:	8b 55 08             	mov    0x8(%ebp),%edx
  803c8a:	89 10                	mov    %edx,(%eax)
  803c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c92:	89 50 04             	mov    %edx,0x4(%eax)
  803c95:	8b 45 08             	mov    0x8(%ebp),%eax
  803c98:	8b 00                	mov    (%eax),%eax
  803c9a:	85 c0                	test   %eax,%eax
  803c9c:	75 08                	jne    803ca6 <insert_sorted_with_merge_freeList+0x703>
  803c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ca6:	a1 44 51 80 00       	mov    0x805144,%eax
  803cab:	40                   	inc    %eax
  803cac:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803cb1:	eb 39                	jmp    803cec <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803cb3:	a1 40 51 80 00       	mov    0x805140,%eax
  803cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cbf:	74 07                	je     803cc8 <insert_sorted_with_merge_freeList+0x725>
  803cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc4:	8b 00                	mov    (%eax),%eax
  803cc6:	eb 05                	jmp    803ccd <insert_sorted_with_merge_freeList+0x72a>
  803cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ccd:	a3 40 51 80 00       	mov    %eax,0x805140
  803cd2:	a1 40 51 80 00       	mov    0x805140,%eax
  803cd7:	85 c0                	test   %eax,%eax
  803cd9:	0f 85 c7 fb ff ff    	jne    8038a6 <insert_sorted_with_merge_freeList+0x303>
  803cdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ce3:	0f 85 bd fb ff ff    	jne    8038a6 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803ce9:	eb 01                	jmp    803cec <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803ceb:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803cec:	90                   	nop
  803ced:	c9                   	leave  
  803cee:	c3                   	ret    
  803cef:	90                   	nop

00803cf0 <__udivdi3>:
  803cf0:	55                   	push   %ebp
  803cf1:	57                   	push   %edi
  803cf2:	56                   	push   %esi
  803cf3:	53                   	push   %ebx
  803cf4:	83 ec 1c             	sub    $0x1c,%esp
  803cf7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cfb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d07:	89 ca                	mov    %ecx,%edx
  803d09:	89 f8                	mov    %edi,%eax
  803d0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d0f:	85 f6                	test   %esi,%esi
  803d11:	75 2d                	jne    803d40 <__udivdi3+0x50>
  803d13:	39 cf                	cmp    %ecx,%edi
  803d15:	77 65                	ja     803d7c <__udivdi3+0x8c>
  803d17:	89 fd                	mov    %edi,%ebp
  803d19:	85 ff                	test   %edi,%edi
  803d1b:	75 0b                	jne    803d28 <__udivdi3+0x38>
  803d1d:	b8 01 00 00 00       	mov    $0x1,%eax
  803d22:	31 d2                	xor    %edx,%edx
  803d24:	f7 f7                	div    %edi
  803d26:	89 c5                	mov    %eax,%ebp
  803d28:	31 d2                	xor    %edx,%edx
  803d2a:	89 c8                	mov    %ecx,%eax
  803d2c:	f7 f5                	div    %ebp
  803d2e:	89 c1                	mov    %eax,%ecx
  803d30:	89 d8                	mov    %ebx,%eax
  803d32:	f7 f5                	div    %ebp
  803d34:	89 cf                	mov    %ecx,%edi
  803d36:	89 fa                	mov    %edi,%edx
  803d38:	83 c4 1c             	add    $0x1c,%esp
  803d3b:	5b                   	pop    %ebx
  803d3c:	5e                   	pop    %esi
  803d3d:	5f                   	pop    %edi
  803d3e:	5d                   	pop    %ebp
  803d3f:	c3                   	ret    
  803d40:	39 ce                	cmp    %ecx,%esi
  803d42:	77 28                	ja     803d6c <__udivdi3+0x7c>
  803d44:	0f bd fe             	bsr    %esi,%edi
  803d47:	83 f7 1f             	xor    $0x1f,%edi
  803d4a:	75 40                	jne    803d8c <__udivdi3+0x9c>
  803d4c:	39 ce                	cmp    %ecx,%esi
  803d4e:	72 0a                	jb     803d5a <__udivdi3+0x6a>
  803d50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d54:	0f 87 9e 00 00 00    	ja     803df8 <__udivdi3+0x108>
  803d5a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d5f:	89 fa                	mov    %edi,%edx
  803d61:	83 c4 1c             	add    $0x1c,%esp
  803d64:	5b                   	pop    %ebx
  803d65:	5e                   	pop    %esi
  803d66:	5f                   	pop    %edi
  803d67:	5d                   	pop    %ebp
  803d68:	c3                   	ret    
  803d69:	8d 76 00             	lea    0x0(%esi),%esi
  803d6c:	31 ff                	xor    %edi,%edi
  803d6e:	31 c0                	xor    %eax,%eax
  803d70:	89 fa                	mov    %edi,%edx
  803d72:	83 c4 1c             	add    $0x1c,%esp
  803d75:	5b                   	pop    %ebx
  803d76:	5e                   	pop    %esi
  803d77:	5f                   	pop    %edi
  803d78:	5d                   	pop    %ebp
  803d79:	c3                   	ret    
  803d7a:	66 90                	xchg   %ax,%ax
  803d7c:	89 d8                	mov    %ebx,%eax
  803d7e:	f7 f7                	div    %edi
  803d80:	31 ff                	xor    %edi,%edi
  803d82:	89 fa                	mov    %edi,%edx
  803d84:	83 c4 1c             	add    $0x1c,%esp
  803d87:	5b                   	pop    %ebx
  803d88:	5e                   	pop    %esi
  803d89:	5f                   	pop    %edi
  803d8a:	5d                   	pop    %ebp
  803d8b:	c3                   	ret    
  803d8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d91:	89 eb                	mov    %ebp,%ebx
  803d93:	29 fb                	sub    %edi,%ebx
  803d95:	89 f9                	mov    %edi,%ecx
  803d97:	d3 e6                	shl    %cl,%esi
  803d99:	89 c5                	mov    %eax,%ebp
  803d9b:	88 d9                	mov    %bl,%cl
  803d9d:	d3 ed                	shr    %cl,%ebp
  803d9f:	89 e9                	mov    %ebp,%ecx
  803da1:	09 f1                	or     %esi,%ecx
  803da3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803da7:	89 f9                	mov    %edi,%ecx
  803da9:	d3 e0                	shl    %cl,%eax
  803dab:	89 c5                	mov    %eax,%ebp
  803dad:	89 d6                	mov    %edx,%esi
  803daf:	88 d9                	mov    %bl,%cl
  803db1:	d3 ee                	shr    %cl,%esi
  803db3:	89 f9                	mov    %edi,%ecx
  803db5:	d3 e2                	shl    %cl,%edx
  803db7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dbb:	88 d9                	mov    %bl,%cl
  803dbd:	d3 e8                	shr    %cl,%eax
  803dbf:	09 c2                	or     %eax,%edx
  803dc1:	89 d0                	mov    %edx,%eax
  803dc3:	89 f2                	mov    %esi,%edx
  803dc5:	f7 74 24 0c          	divl   0xc(%esp)
  803dc9:	89 d6                	mov    %edx,%esi
  803dcb:	89 c3                	mov    %eax,%ebx
  803dcd:	f7 e5                	mul    %ebp
  803dcf:	39 d6                	cmp    %edx,%esi
  803dd1:	72 19                	jb     803dec <__udivdi3+0xfc>
  803dd3:	74 0b                	je     803de0 <__udivdi3+0xf0>
  803dd5:	89 d8                	mov    %ebx,%eax
  803dd7:	31 ff                	xor    %edi,%edi
  803dd9:	e9 58 ff ff ff       	jmp    803d36 <__udivdi3+0x46>
  803dde:	66 90                	xchg   %ax,%ax
  803de0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803de4:	89 f9                	mov    %edi,%ecx
  803de6:	d3 e2                	shl    %cl,%edx
  803de8:	39 c2                	cmp    %eax,%edx
  803dea:	73 e9                	jae    803dd5 <__udivdi3+0xe5>
  803dec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803def:	31 ff                	xor    %edi,%edi
  803df1:	e9 40 ff ff ff       	jmp    803d36 <__udivdi3+0x46>
  803df6:	66 90                	xchg   %ax,%ax
  803df8:	31 c0                	xor    %eax,%eax
  803dfa:	e9 37 ff ff ff       	jmp    803d36 <__udivdi3+0x46>
  803dff:	90                   	nop

00803e00 <__umoddi3>:
  803e00:	55                   	push   %ebp
  803e01:	57                   	push   %edi
  803e02:	56                   	push   %esi
  803e03:	53                   	push   %ebx
  803e04:	83 ec 1c             	sub    $0x1c,%esp
  803e07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e1f:	89 f3                	mov    %esi,%ebx
  803e21:	89 fa                	mov    %edi,%edx
  803e23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e27:	89 34 24             	mov    %esi,(%esp)
  803e2a:	85 c0                	test   %eax,%eax
  803e2c:	75 1a                	jne    803e48 <__umoddi3+0x48>
  803e2e:	39 f7                	cmp    %esi,%edi
  803e30:	0f 86 a2 00 00 00    	jbe    803ed8 <__umoddi3+0xd8>
  803e36:	89 c8                	mov    %ecx,%eax
  803e38:	89 f2                	mov    %esi,%edx
  803e3a:	f7 f7                	div    %edi
  803e3c:	89 d0                	mov    %edx,%eax
  803e3e:	31 d2                	xor    %edx,%edx
  803e40:	83 c4 1c             	add    $0x1c,%esp
  803e43:	5b                   	pop    %ebx
  803e44:	5e                   	pop    %esi
  803e45:	5f                   	pop    %edi
  803e46:	5d                   	pop    %ebp
  803e47:	c3                   	ret    
  803e48:	39 f0                	cmp    %esi,%eax
  803e4a:	0f 87 ac 00 00 00    	ja     803efc <__umoddi3+0xfc>
  803e50:	0f bd e8             	bsr    %eax,%ebp
  803e53:	83 f5 1f             	xor    $0x1f,%ebp
  803e56:	0f 84 ac 00 00 00    	je     803f08 <__umoddi3+0x108>
  803e5c:	bf 20 00 00 00       	mov    $0x20,%edi
  803e61:	29 ef                	sub    %ebp,%edi
  803e63:	89 fe                	mov    %edi,%esi
  803e65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e69:	89 e9                	mov    %ebp,%ecx
  803e6b:	d3 e0                	shl    %cl,%eax
  803e6d:	89 d7                	mov    %edx,%edi
  803e6f:	89 f1                	mov    %esi,%ecx
  803e71:	d3 ef                	shr    %cl,%edi
  803e73:	09 c7                	or     %eax,%edi
  803e75:	89 e9                	mov    %ebp,%ecx
  803e77:	d3 e2                	shl    %cl,%edx
  803e79:	89 14 24             	mov    %edx,(%esp)
  803e7c:	89 d8                	mov    %ebx,%eax
  803e7e:	d3 e0                	shl    %cl,%eax
  803e80:	89 c2                	mov    %eax,%edx
  803e82:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e86:	d3 e0                	shl    %cl,%eax
  803e88:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e90:	89 f1                	mov    %esi,%ecx
  803e92:	d3 e8                	shr    %cl,%eax
  803e94:	09 d0                	or     %edx,%eax
  803e96:	d3 eb                	shr    %cl,%ebx
  803e98:	89 da                	mov    %ebx,%edx
  803e9a:	f7 f7                	div    %edi
  803e9c:	89 d3                	mov    %edx,%ebx
  803e9e:	f7 24 24             	mull   (%esp)
  803ea1:	89 c6                	mov    %eax,%esi
  803ea3:	89 d1                	mov    %edx,%ecx
  803ea5:	39 d3                	cmp    %edx,%ebx
  803ea7:	0f 82 87 00 00 00    	jb     803f34 <__umoddi3+0x134>
  803ead:	0f 84 91 00 00 00    	je     803f44 <__umoddi3+0x144>
  803eb3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803eb7:	29 f2                	sub    %esi,%edx
  803eb9:	19 cb                	sbb    %ecx,%ebx
  803ebb:	89 d8                	mov    %ebx,%eax
  803ebd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ec1:	d3 e0                	shl    %cl,%eax
  803ec3:	89 e9                	mov    %ebp,%ecx
  803ec5:	d3 ea                	shr    %cl,%edx
  803ec7:	09 d0                	or     %edx,%eax
  803ec9:	89 e9                	mov    %ebp,%ecx
  803ecb:	d3 eb                	shr    %cl,%ebx
  803ecd:	89 da                	mov    %ebx,%edx
  803ecf:	83 c4 1c             	add    $0x1c,%esp
  803ed2:	5b                   	pop    %ebx
  803ed3:	5e                   	pop    %esi
  803ed4:	5f                   	pop    %edi
  803ed5:	5d                   	pop    %ebp
  803ed6:	c3                   	ret    
  803ed7:	90                   	nop
  803ed8:	89 fd                	mov    %edi,%ebp
  803eda:	85 ff                	test   %edi,%edi
  803edc:	75 0b                	jne    803ee9 <__umoddi3+0xe9>
  803ede:	b8 01 00 00 00       	mov    $0x1,%eax
  803ee3:	31 d2                	xor    %edx,%edx
  803ee5:	f7 f7                	div    %edi
  803ee7:	89 c5                	mov    %eax,%ebp
  803ee9:	89 f0                	mov    %esi,%eax
  803eeb:	31 d2                	xor    %edx,%edx
  803eed:	f7 f5                	div    %ebp
  803eef:	89 c8                	mov    %ecx,%eax
  803ef1:	f7 f5                	div    %ebp
  803ef3:	89 d0                	mov    %edx,%eax
  803ef5:	e9 44 ff ff ff       	jmp    803e3e <__umoddi3+0x3e>
  803efa:	66 90                	xchg   %ax,%ax
  803efc:	89 c8                	mov    %ecx,%eax
  803efe:	89 f2                	mov    %esi,%edx
  803f00:	83 c4 1c             	add    $0x1c,%esp
  803f03:	5b                   	pop    %ebx
  803f04:	5e                   	pop    %esi
  803f05:	5f                   	pop    %edi
  803f06:	5d                   	pop    %ebp
  803f07:	c3                   	ret    
  803f08:	3b 04 24             	cmp    (%esp),%eax
  803f0b:	72 06                	jb     803f13 <__umoddi3+0x113>
  803f0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f11:	77 0f                	ja     803f22 <__umoddi3+0x122>
  803f13:	89 f2                	mov    %esi,%edx
  803f15:	29 f9                	sub    %edi,%ecx
  803f17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f1b:	89 14 24             	mov    %edx,(%esp)
  803f1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f22:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f26:	8b 14 24             	mov    (%esp),%edx
  803f29:	83 c4 1c             	add    $0x1c,%esp
  803f2c:	5b                   	pop    %ebx
  803f2d:	5e                   	pop    %esi
  803f2e:	5f                   	pop    %edi
  803f2f:	5d                   	pop    %ebp
  803f30:	c3                   	ret    
  803f31:	8d 76 00             	lea    0x0(%esi),%esi
  803f34:	2b 04 24             	sub    (%esp),%eax
  803f37:	19 fa                	sbb    %edi,%edx
  803f39:	89 d1                	mov    %edx,%ecx
  803f3b:	89 c6                	mov    %eax,%esi
  803f3d:	e9 71 ff ff ff       	jmp    803eb3 <__umoddi3+0xb3>
  803f42:	66 90                	xchg   %ax,%ax
  803f44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f48:	72 ea                	jb     803f34 <__umoddi3+0x134>
  803f4a:	89 d9                	mov    %ebx,%ecx
  803f4c:	e9 62 ff ff ff       	jmp    803eb3 <__umoddi3+0xb3>
