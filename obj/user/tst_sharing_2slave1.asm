
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 1e 02 00 00       	call   800254 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 30 80 00       	mov    0x803020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 e0 1d 80 00       	push   $0x801de0
  800092:	6a 13                	push   $0x13
  800094:	68 fc 1d 80 00       	push   $0x801dfc
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 4d 18 00 00       	call   8018f0 <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 39 16 00 00       	call   8016e4 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 47 15 00 00       	call   8015f7 <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 17 1e 80 00       	push   $0x801e17
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 a0 13 00 00       	call   801463 <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 1c 1e 80 00       	push   $0x801e1c
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 fc 1d 80 00       	push   $0x801dfc
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 09 15 00 00       	call   8015f7 <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 7c 1e 80 00       	push   $0x801e7c
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 fc 1d 80 00       	push   $0x801dfc
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 ee 15 00 00       	call   8016fe <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 cf 15 00 00       	call   8016e4 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 dd 14 00 00       	call   8015f7 <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 0d 1f 80 00       	push   $0x801f0d
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 36 13 00 00       	call   801463 <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 1c 1e 80 00       	push   $0x801e1c
  800144:	6a 23                	push   $0x23
  800146:	68 fc 1d 80 00       	push   $0x801dfc
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 a2 14 00 00       	call   8015f7 <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 7c 1e 80 00       	push   $0x801e7c
  800166:	6a 24                	push   $0x24
  800168:	68 fc 1d 80 00       	push   $0x801dfc
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 87 15 00 00       	call   8016fe <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 10 1f 80 00       	push   $0x801f10
  800189:	6a 27                	push   $0x27
  80018b:	68 fc 1d 80 00       	push   $0x801dfc
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 4a 15 00 00       	call   8016e4 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 58 14 00 00       	call   8015f7 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 47 1f 80 00       	push   $0x801f47
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 b1 12 00 00       	call   801463 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 1c 1e 80 00       	push   $0x801e1c
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 fc 1d 80 00       	push   $0x801dfc
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 1d 14 00 00       	call   8015f7 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 7c 1e 80 00       	push   $0x801e7c
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 fc 1d 80 00       	push   $0x801dfc
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 02 15 00 00       	call   8016fe <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 10 1f 80 00       	push   $0x801f10
  80020e:	6a 30                	push   $0x30
  800210:	68 fc 1d 80 00       	push   $0x801dfc
  800215:	e8 76 01 00 00       	call   800390 <_panic>

	*z = *x + *y ;
  80021a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021d:	8b 10                	mov    (%eax),%edx
  80021f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	01 c2                	add    %eax,%edx
  800226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800229:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80022b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022e:	8b 00                	mov    (%eax),%eax
  800230:	83 f8 1e             	cmp    $0x1e,%eax
  800233:	74 14                	je     800249 <_main+0x211>
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 10 1f 80 00       	push   $0x801f10
  80023d:	6a 33                	push   $0x33
  80023f:	68 fc 1d 80 00       	push   $0x801dfc
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 c7 17 00 00       	call   801a15 <inctst>

	return;
  80024e:	90                   	nop
}
  80024f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80025a:	e8 78 16 00 00       	call   8018d7 <sys_getenvindex>
  80025f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800265:	89 d0                	mov    %edx,%eax
  800267:	c1 e0 03             	shl    $0x3,%eax
  80026a:	01 d0                	add    %edx,%eax
  80026c:	01 c0                	add    %eax,%eax
  80026e:	01 d0                	add    %edx,%eax
  800270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800277:	01 d0                	add    %edx,%eax
  800279:	c1 e0 04             	shl    $0x4,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800286:	a1 20 30 80 00       	mov    0x803020,%eax
  80028b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800291:	84 c0                	test   %al,%al
  800293:	74 0f                	je     8002a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800295:	a1 20 30 80 00       	mov    0x803020,%eax
  80029a:	05 5c 05 00 00       	add    $0x55c,%eax
  80029f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a8:	7e 0a                	jle    8002b4 <libmain+0x60>
		binaryname = argv[0];
  8002aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ad:	8b 00                	mov    (%eax),%eax
  8002af:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	e8 76 fd ff ff       	call   800038 <_main>
  8002c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002c5:	e8 1a 14 00 00       	call   8016e4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 64 1f 80 00       	push   $0x801f64
  8002d2:	e8 6d 03 00 00       	call   800644 <cprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002da:	a1 20 30 80 00       	mov    0x803020,%eax
  8002df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 8c 1f 80 00       	push   $0x801f8c
  8002fa:	e8 45 03 00 00       	call   800644 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800302:	a1 20 30 80 00       	mov    0x803020,%eax
  800307:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80030d:	a1 20 30 80 00       	mov    0x803020,%eax
  800312:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800318:	a1 20 30 80 00       	mov    0x803020,%eax
  80031d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800323:	51                   	push   %ecx
  800324:	52                   	push   %edx
  800325:	50                   	push   %eax
  800326:	68 b4 1f 80 00       	push   $0x801fb4
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 30 80 00       	mov    0x803020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 0c 20 80 00       	push   $0x80200c
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 64 1f 80 00       	push   $0x801f64
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 9a 13 00 00       	call   8016fe <sys_enable_interrupt>

	// exit gracefully
	exit();
  800364:	e8 19 00 00 00       	call   800382 <exit>
}
  800369:	90                   	nop
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	6a 00                	push   $0x0
  800377:	e8 27 15 00 00       	call   8018a3 <sys_destroy_env>
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <exit>:

void
exit(void)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800388:	e8 7c 15 00 00       	call   801909 <sys_exit_env>
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800396:	8d 45 10             	lea    0x10(%ebp),%eax
  800399:	83 c0 04             	add    $0x4,%eax
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039f:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8003a4:	85 c0                	test   %eax,%eax
  8003a6:	74 16                	je     8003be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a8:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	50                   	push   %eax
  8003b1:	68 20 20 80 00       	push   $0x802020
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 30 80 00       	mov    0x803000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 25 20 80 00       	push   $0x802025
  8003cf:	e8 70 02 00 00       	call   800644 <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e0:	50                   	push   %eax
  8003e1:	e8 f3 01 00 00       	call   8005d9 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	6a 00                	push   $0x0
  8003ee:	68 41 20 80 00       	push   $0x802041
  8003f3:	e8 e1 01 00 00       	call   8005d9 <vcprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fb:	e8 82 ff ff ff       	call   800382 <exit>

	// should not return here
	while (1) ;
  800400:	eb fe                	jmp    800400 <_panic+0x70>

00800402 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800408:	a1 20 30 80 00       	mov    0x803020,%eax
  80040d:	8b 50 74             	mov    0x74(%eax),%edx
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	39 c2                	cmp    %eax,%edx
  800415:	74 14                	je     80042b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	68 44 20 80 00       	push   $0x802044
  80041f:	6a 26                	push   $0x26
  800421:	68 90 20 80 00       	push   $0x802090
  800426:	e8 65 ff ff ff       	call   800390 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800439:	e9 c2 00 00 00       	jmp    800500 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	75 08                	jne    80045b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800453:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800456:	e9 a2 00 00 00       	jmp    8004fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80045b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800469:	eb 69                	jmp    8004d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046b:	a1 20 30 80 00       	mov    0x803020,%eax
  800470:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800479:	89 d0                	mov    %edx,%eax
  80047b:	01 c0                	add    %eax,%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	c1 e0 03             	shl    $0x3,%eax
  800482:	01 c8                	add    %ecx,%eax
  800484:	8a 40 04             	mov    0x4(%eax),%al
  800487:	84 c0                	test   %al,%al
  800489:	75 46                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048b:	a1 20 30 80 00       	mov    0x803020,%eax
  800490:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800496:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	c1 e0 03             	shl    $0x3,%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c4:	39 c2                	cmp    %eax,%edx
  8004c6:	75 09                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004cf:	eb 12                	jmp    8004e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d1:	ff 45 e8             	incl   -0x18(%ebp)
  8004d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d9:	8b 50 74             	mov    0x74(%eax),%edx
  8004dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004df:	39 c2                	cmp    %eax,%edx
  8004e1:	77 88                	ja     80046b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e7:	75 14                	jne    8004fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 9c 20 80 00       	push   $0x80209c
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 90 20 80 00       	push   $0x802090
  8004f8:	e8 93 fe ff ff       	call   800390 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004fd:	ff 45 f0             	incl   -0x10(%ebp)
  800500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800503:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800506:	0f 8c 32 ff ff ff    	jl     80043e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800513:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80051a:	eb 26                	jmp    800542 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051c:	a1 20 30 80 00       	mov    0x803020,%eax
  800521:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800527:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	01 c0                	add    %eax,%eax
  80052e:	01 d0                	add    %edx,%eax
  800530:	c1 e0 03             	shl    $0x3,%eax
  800533:	01 c8                	add    %ecx,%eax
  800535:	8a 40 04             	mov    0x4(%eax),%al
  800538:	3c 01                	cmp    $0x1,%al
  80053a:	75 03                	jne    80053f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80053c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053f:	ff 45 e0             	incl   -0x20(%ebp)
  800542:	a1 20 30 80 00       	mov    0x803020,%eax
  800547:	8b 50 74             	mov    0x74(%eax),%edx
  80054a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054d:	39 c2                	cmp    %eax,%edx
  80054f:	77 cb                	ja     80051c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800557:	74 14                	je     80056d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800559:	83 ec 04             	sub    $0x4,%esp
  80055c:	68 f0 20 80 00       	push   $0x8020f0
  800561:	6a 44                	push   $0x44
  800563:	68 90 20 80 00       	push   $0x802090
  800568:	e8 23 fe ff ff       	call   800390 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80056d:	90                   	nop
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	8d 48 01             	lea    0x1(%eax),%ecx
  80057e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800581:	89 0a                	mov    %ecx,(%edx)
  800583:	8b 55 08             	mov    0x8(%ebp),%edx
  800586:	88 d1                	mov    %dl,%cl
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	3d ff 00 00 00       	cmp    $0xff,%eax
  800599:	75 2c                	jne    8005c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80059b:	a0 24 30 80 00       	mov    0x803024,%al
  8005a0:	0f b6 c0             	movzbl %al,%eax
  8005a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a6:	8b 12                	mov    (%edx),%edx
  8005a8:	89 d1                	mov    %edx,%ecx
  8005aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ad:	83 c2 08             	add    $0x8,%edx
  8005b0:	83 ec 04             	sub    $0x4,%esp
  8005b3:	50                   	push   %eax
  8005b4:	51                   	push   %ecx
  8005b5:	52                   	push   %edx
  8005b6:	e8 7b 0f 00 00       	call   801536 <sys_cputs>
  8005bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ca:	8b 40 04             	mov    0x4(%eax),%eax
  8005cd:	8d 50 01             	lea    0x1(%eax),%edx
  8005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005d6:	90                   	nop
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e9:	00 00 00 
	b.cnt = 0;
  8005ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	68 70 05 80 00       	push   $0x800570
  800608:	e8 11 02 00 00       	call   80081e <vprintfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800610:	a0 24 30 80 00       	mov    0x803024,%al
  800615:	0f b6 c0             	movzbl %al,%eax
  800618:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80061e:	83 ec 04             	sub    $0x4,%esp
  800621:	50                   	push   %eax
  800622:	52                   	push   %edx
  800623:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800629:	83 c0 08             	add    $0x8,%eax
  80062c:	50                   	push   %eax
  80062d:	e8 04 0f 00 00       	call   801536 <sys_cputs>
  800632:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800635:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80063c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <cprintf>:

int cprintf(const char *fmt, ...) {
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80064a:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800651:	8d 45 0c             	lea    0xc(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 f4             	pushl  -0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	e8 73 ff ff ff       	call   8005d9 <vcprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800677:	e8 68 10 00 00       	call   8016e4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80067c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 48 ff ff ff       	call   8005d9 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800697:	e8 62 10 00 00       	call   8016fe <sys_enable_interrupt>
	return cnt;
  80069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    

008006a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	53                   	push   %ebx
  8006a5:	83 ec 14             	sub    $0x14,%esp
  8006a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bf:	77 55                	ja     800716 <printnum+0x75>
  8006c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006c4:	72 05                	jb     8006cb <printnum+0x2a>
  8006c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c9:	77 4b                	ja     800716 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	52                   	push   %edx
  8006da:	50                   	push   %eax
  8006db:	ff 75 f4             	pushl  -0xc(%ebp)
  8006de:	ff 75 f0             	pushl  -0x10(%ebp)
  8006e1:	e8 86 14 00 00       	call   801b6c <__udivdi3>
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	ff 75 20             	pushl  0x20(%ebp)
  8006ef:	53                   	push   %ebx
  8006f0:	ff 75 18             	pushl  0x18(%ebp)
  8006f3:	52                   	push   %edx
  8006f4:	50                   	push   %eax
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	e8 a1 ff ff ff       	call   8006a1 <printnum>
  800700:	83 c4 20             	add    $0x20,%esp
  800703:	eb 1a                	jmp    80071f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	ff 75 20             	pushl  0x20(%ebp)
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800716:	ff 4d 1c             	decl   0x1c(%ebp)
  800719:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80071d:	7f e6                	jg     800705 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800722:	bb 00 00 00 00       	mov    $0x0,%ebx
  800727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072d:	53                   	push   %ebx
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	e8 46 15 00 00       	call   801c7c <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 54 23 80 00       	add    $0x802354,%eax
  80073e:	8a 00                	mov    (%eax),%al
  800740:	0f be c0             	movsbl %al,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	50                   	push   %eax
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	ff d0                	call   *%eax
  80074f:	83 c4 10             	add    $0x10,%esp
}
  800752:	90                   	nop
  800753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80075b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075f:	7e 1c                	jle    80077d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 08             	lea    0x8(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 08             	sub    $0x8,%eax
  800776:	8b 50 04             	mov    0x4(%eax),%edx
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	eb 40                	jmp    8007bd <getuint+0x65>
	else if (lflag)
  80077d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800781:	74 1e                	je     8007a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	8d 50 04             	lea    0x4(%eax),%edx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 10                	mov    %edx,(%eax)
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	83 e8 04             	sub    $0x4,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	ba 00 00 00 00       	mov    $0x0,%edx
  80079f:	eb 1c                	jmp    8007bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    

008007bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c6:	7e 1c                	jle    8007e4 <getint+0x25>
		return va_arg(*ap, long long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 08             	lea    0x8(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 08             	sub    $0x8,%eax
  8007dd:	8b 50 04             	mov    0x4(%eax),%edx
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	eb 38                	jmp    80081c <getint+0x5d>
	else if (lflag)
  8007e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e8:	74 1a                	je     800804 <getint+0x45>
		return va_arg(*ap, long);
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	8d 50 04             	lea    0x4(%eax),%edx
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	89 10                	mov    %edx,(%eax)
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	99                   	cltd   
  800802:	eb 18                	jmp    80081c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	8d 50 04             	lea    0x4(%eax),%edx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	89 10                	mov    %edx,(%eax)
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	83 e8 04             	sub    $0x4,%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	99                   	cltd   
}
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800826:	eb 17                	jmp    80083f <vprintfmt+0x21>
			if (ch == '\0')
  800828:	85 db                	test   %ebx,%ebx
  80082a:	0f 84 af 03 00 00    	je     800bdf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	53                   	push   %ebx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083f:	8b 45 10             	mov    0x10(%ebp),%eax
  800842:	8d 50 01             	lea    0x1(%eax),%edx
  800845:	89 55 10             	mov    %edx,0x10(%ebp)
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f b6 d8             	movzbl %al,%ebx
  80084d:	83 fb 25             	cmp    $0x25,%ebx
  800850:	75 d6                	jne    800828 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800852:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800856:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80085d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800864:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80086b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800872:	8b 45 10             	mov    0x10(%ebp),%eax
  800875:	8d 50 01             	lea    0x1(%eax),%edx
  800878:	89 55 10             	mov    %edx,0x10(%ebp)
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	0f b6 d8             	movzbl %al,%ebx
  800880:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800883:	83 f8 55             	cmp    $0x55,%eax
  800886:	0f 87 2b 03 00 00    	ja     800bb7 <vprintfmt+0x399>
  80088c:	8b 04 85 78 23 80 00 	mov    0x802378(,%eax,4),%eax
  800893:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800895:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800899:	eb d7                	jmp    800872 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80089b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80089f:	eb d1                	jmp    800872 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ab:	89 d0                	mov    %edx,%eax
  8008ad:	c1 e0 02             	shl    $0x2,%eax
  8008b0:	01 d0                	add    %edx,%eax
  8008b2:	01 c0                	add    %eax,%eax
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	83 e8 30             	sub    $0x30,%eax
  8008b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bf:	8a 00                	mov    (%eax),%al
  8008c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c7:	7e 3e                	jle    800907 <vprintfmt+0xe9>
  8008c9:	83 fb 39             	cmp    $0x39,%ebx
  8008cc:	7f 39                	jg     800907 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d1:	eb d5                	jmp    8008a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	83 c0 04             	add    $0x4,%eax
  8008d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	83 e8 04             	sub    $0x4,%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e7:	eb 1f                	jmp    800908 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	79 83                	jns    800872 <vprintfmt+0x54>
				width = 0;
  8008ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f6:	e9 77 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800902:	e9 6b ff ff ff       	jmp    800872 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800907:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090c:	0f 89 60 ff ff ff    	jns    800872 <vprintfmt+0x54>
				width = precision, precision = -1;
  800912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800915:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800918:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80091f:	e9 4e ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800924:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800927:	e9 46 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 c0 04             	add    $0x4,%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			break;
  80094c:	e9 89 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 e8 04             	sub    $0x4,%eax
  800960:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800962:	85 db                	test   %ebx,%ebx
  800964:	79 02                	jns    800968 <vprintfmt+0x14a>
				err = -err;
  800966:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800968:	83 fb 64             	cmp    $0x64,%ebx
  80096b:	7f 0b                	jg     800978 <vprintfmt+0x15a>
  80096d:	8b 34 9d c0 21 80 00 	mov    0x8021c0(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 65 23 80 00       	push   $0x802365
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	ff 75 08             	pushl  0x8(%ebp)
  800984:	e8 5e 02 00 00       	call   800be7 <printfmt>
  800989:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80098c:	e9 49 02 00 00       	jmp    800bda <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800991:	56                   	push   %esi
  800992:	68 6e 23 80 00       	push   $0x80236e
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 45 02 00 00       	call   800be7 <printfmt>
  8009a2:	83 c4 10             	add    $0x10,%esp
			break;
  8009a5:	e9 30 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	83 c0 04             	add    $0x4,%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 30                	mov    (%eax),%esi
  8009bb:	85 f6                	test   %esi,%esi
  8009bd:	75 05                	jne    8009c4 <vprintfmt+0x1a6>
				p = "(null)";
  8009bf:	be 71 23 80 00       	mov    $0x802371,%esi
			if (width > 0 && padc != '-')
  8009c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c8:	7e 6d                	jle    800a37 <vprintfmt+0x219>
  8009ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ce:	74 67                	je     800a37 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	50                   	push   %eax
  8009d7:	56                   	push   %esi
  8009d8:	e8 0c 03 00 00       	call   800ce9 <strnlen>
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009e3:	eb 16                	jmp    8009fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	50                   	push   %eax
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ff:	7f e4                	jg     8009e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a01:	eb 34                	jmp    800a37 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a07:	74 1c                	je     800a25 <vprintfmt+0x207>
  800a09:	83 fb 1f             	cmp    $0x1f,%ebx
  800a0c:	7e 05                	jle    800a13 <vprintfmt+0x1f5>
  800a0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a11:	7e 12                	jle    800a25 <vprintfmt+0x207>
					putch('?', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 3f                	push   $0x3f
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	eb 0f                	jmp    800a34 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a34:	ff 4d e4             	decl   -0x1c(%ebp)
  800a37:	89 f0                	mov    %esi,%eax
  800a39:	8d 70 01             	lea    0x1(%eax),%esi
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	0f be d8             	movsbl %al,%ebx
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	74 24                	je     800a69 <vprintfmt+0x24b>
  800a45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a49:	78 b8                	js     800a03 <vprintfmt+0x1e5>
  800a4b:	ff 4d e0             	decl   -0x20(%ebp)
  800a4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a52:	79 af                	jns    800a03 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	eb 13                	jmp    800a69 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	6a 20                	push   $0x20
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	ff d0                	call   *%eax
  800a63:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a66:	ff 4d e4             	decl   -0x1c(%ebp)
  800a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6d:	7f e7                	jg     800a56 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a6f:	e9 66 01 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7d:	50                   	push   %eax
  800a7e:	e8 3c fd ff ff       	call   8007bf <getint>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a92:	85 d2                	test   %edx,%edx
  800a94:	79 23                	jns    800ab9 <vprintfmt+0x29b>
				putch('-', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 2d                	push   $0x2d
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aac:	f7 d8                	neg    %eax
  800aae:	83 d2 00             	adc    $0x0,%edx
  800ab1:	f7 da                	neg    %edx
  800ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac0:	e9 bc 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 e8             	pushl  -0x18(%ebp)
  800acb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ace:	50                   	push   %eax
  800acf:	e8 84 fc ff ff       	call   800758 <getuint>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800add:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ae4:	e9 98 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 58                	push   $0x58
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	6a 58                	push   $0x58
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	ff d0                	call   *%eax
  800b06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	6a 58                	push   $0x58
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
			break;
  800b19:	e9 bc 00 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	6a 30                	push   $0x30
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 78                	push   $0x78
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	83 c0 04             	add    $0x4,%eax
  800b44:	89 45 14             	mov    %eax,0x14(%ebp)
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	83 e8 04             	sub    $0x4,%eax
  800b4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b60:	eb 1f                	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 e8             	pushl  -0x18(%ebp)
  800b68:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6b:	50                   	push   %eax
  800b6c:	e8 e7 fb ff ff       	call   800758 <getuint>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	52                   	push   %edx
  800b8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8f:	50                   	push   %eax
  800b90:	ff 75 f4             	pushl  -0xc(%ebp)
  800b93:	ff 75 f0             	pushl  -0x10(%ebp)
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 08             	pushl  0x8(%ebp)
  800b9c:	e8 00 fb ff ff       	call   8006a1 <printnum>
  800ba1:	83 c4 20             	add    $0x20,%esp
			break;
  800ba4:	eb 34                	jmp    800bda <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			break;
  800bb5:	eb 23                	jmp    800bda <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 25                	push   $0x25
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc7:	ff 4d 10             	decl   0x10(%ebp)
  800bca:	eb 03                	jmp    800bcf <vprintfmt+0x3b1>
  800bcc:	ff 4d 10             	decl   0x10(%ebp)
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	48                   	dec    %eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	3c 25                	cmp    $0x25,%al
  800bd7:	75 f3                	jne    800bcc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bd9:	90                   	nop
		}
	}
  800bda:	e9 47 fc ff ff       	jmp    800826 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bdf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bed:	8d 45 10             	lea    0x10(%ebp),%eax
  800bf0:	83 c0 04             	add    $0x4,%eax
  800bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 08             	pushl  0x8(%ebp)
  800c03:	e8 16 fc ff ff       	call   80081e <vprintfmt>
  800c08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c0b:	90                   	nop
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8b 40 08             	mov    0x8(%eax),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 10                	mov    (%eax),%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8b 40 04             	mov    0x4(%eax),%eax
  800c2b:	39 c2                	cmp    %eax,%edx
  800c2d:	73 12                	jae    800c41 <sprintputch+0x33>
		*b->buf++ = ch;
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	8d 48 01             	lea    0x1(%eax),%ecx
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	89 0a                	mov    %ecx,(%edx)
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	88 10                	mov    %dl,(%eax)
}
  800c41:	90                   	nop
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c69:	74 06                	je     800c71 <vsnprintf+0x2d>
  800c6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6f:	7f 07                	jg     800c78 <vsnprintf+0x34>
		return -E_INVAL;
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	eb 20                	jmp    800c98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c78:	ff 75 14             	pushl  0x14(%ebp)
  800c7b:	ff 75 10             	pushl  0x10(%ebp)
  800c7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c81:	50                   	push   %eax
  800c82:	68 0e 0c 80 00       	push   $0x800c0e
  800c87:	e8 92 fb ff ff       	call   80081e <vprintfmt>
  800c8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	ff 75 f4             	pushl  -0xc(%ebp)
  800caf:	50                   	push   %eax
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	ff 75 08             	pushl  0x8(%ebp)
  800cb6:	e8 89 ff ff ff       	call   800c44 <vsnprintf>
  800cbb:	83 c4 10             	add    $0x10,%esp
  800cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd3:	eb 06                	jmp    800cdb <strlen+0x15>
		n++;
  800cd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	84 c0                	test   %al,%al
  800ce2:	75 f1                	jne    800cd5 <strlen+0xf>
		n++;
	return n;
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf6:	eb 09                	jmp    800d01 <strnlen+0x18>
		n++;
  800cf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	ff 4d 0c             	decl   0xc(%ebp)
  800d01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d05:	74 09                	je     800d10 <strnlen+0x27>
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	75 e8                	jne    800cf8 <strnlen+0xf>
		n++;
	return n;
  800d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d21:	90                   	nop
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d34:	8a 12                	mov    (%edx),%dl
  800d36:	88 10                	mov    %dl,(%eax)
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	75 e4                	jne    800d22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 1f                	jmp    800d77 <strncpy+0x34>
		*dst++ = *src;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d64:	8a 12                	mov    (%edx),%dl
  800d66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 03                	je     800d74 <strncpy+0x31>
			src++;
  800d71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d74:	ff 45 fc             	incl   -0x4(%ebp)
  800d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d7d:	72 d9                	jb     800d58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d94:	74 30                	je     800dc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d96:	eb 16                	jmp    800dae <strlcpy+0x2a>
			*dst++ = *src++;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8d 50 01             	lea    0x1(%eax),%edx
  800d9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800daa:	8a 12                	mov    (%edx),%dl
  800dac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dae:	ff 4d 10             	decl   0x10(%ebp)
  800db1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db5:	74 09                	je     800dc0 <strlcpy+0x3c>
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 d8                	jne    800d98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcc:	29 c2                	sub    %eax,%edx
  800dce:	89 d0                	mov    %edx,%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0xb>
		p++, q++;
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	74 0e                	je     800df4 <strcmp+0x22>
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 10                	mov    (%eax),%dl
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	38 c2                	cmp    %al,%dl
  800df2:	74 e3                	je     800dd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d0             	movzbl %al,%edx
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	29 c2                	sub    %eax,%edx
  800e06:	89 d0                	mov    %edx,%eax
}
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e0d:	eb 09                	jmp    800e18 <strncmp+0xe>
		n--, p++, q++;
  800e0f:	ff 4d 10             	decl   0x10(%ebp)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1c:	74 17                	je     800e35 <strncmp+0x2b>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	74 0e                	je     800e35 <strncmp+0x2b>
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 10                	mov    (%eax),%dl
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	38 c2                	cmp    %al,%dl
  800e33:	74 da                	je     800e0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e39:	75 07                	jne    800e42 <strncmp+0x38>
		return 0;
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e40:	eb 14                	jmp    800e56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	0f b6 d0             	movzbl %al,%edx
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	0f b6 c0             	movzbl %al,%eax
  800e52:	29 c2                	sub    %eax,%edx
  800e54:	89 d0                	mov    %edx,%eax
}
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e64:	eb 12                	jmp    800e78 <strchr+0x20>
		if (*s == c)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6e:	75 05                	jne    800e75 <strchr+0x1d>
			return (char *) s;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	eb 11                	jmp    800e86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 e5                	jne    800e66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e94:	eb 0d                	jmp    800ea3 <strfind+0x1b>
		if (*s == c)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e9e:	74 0e                	je     800eae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ea0:	ff 45 08             	incl   0x8(%ebp)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	84 c0                	test   %al,%al
  800eaa:	75 ea                	jne    800e96 <strfind+0xe>
  800eac:	eb 01                	jmp    800eaf <strfind+0x27>
		if (*s == c)
			break;
  800eae:	90                   	nop
	return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ec6:	eb 0e                	jmp    800ed6 <memset+0x22>
		*p++ = c;
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	8d 50 01             	lea    0x1(%eax),%edx
  800ece:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ed6:	ff 4d f8             	decl   -0x8(%ebp)
  800ed9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800edd:	79 e9                	jns    800ec8 <memset+0x14>
		*p++ = c;

	return v;
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ef6:	eb 16                	jmp    800f0e <memcpy+0x2a>
		*d++ = *s++;
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0a:	8a 12                	mov    (%edx),%dl
  800f0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f14:	89 55 10             	mov    %edx,0x10(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 dd                	jne    800ef8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f38:	73 50                	jae    800f8a <memmove+0x6a>
  800f3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	76 43                	jbe    800f8a <memmove+0x6a>
		s += n;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f53:	eb 10                	jmp    800f65 <memmove+0x45>
			*--d = *--s;
  800f55:	ff 4d f8             	decl   -0x8(%ebp)
  800f58:	ff 4d fc             	decl   -0x4(%ebp)
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	75 e3                	jne    800f55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f72:	eb 23                	jmp    800f97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	8d 50 01             	lea    0x1(%eax),%edx
  800f7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f86:	8a 12                	mov    (%edx),%dl
  800f88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f90:	89 55 10             	mov    %edx,0x10(%ebp)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 dd                	jne    800f74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fae:	eb 2a                	jmp    800fda <memcmp+0x3e>
		if (*s1 != *s2)
  800fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb3:	8a 10                	mov    (%eax),%dl
  800fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	38 c2                	cmp    %al,%dl
  800fbc:	74 16                	je     800fd4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 d0             	movzbl %al,%edx
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f b6 c0             	movzbl %al,%eax
  800fce:	29 c2                	sub    %eax,%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	eb 18                	jmp    800fec <memcmp+0x50>
		s1++, s2++;
  800fd4:	ff 45 fc             	incl   -0x4(%ebp)
  800fd7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	75 c9                	jne    800fb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	01 d0                	add    %edx,%eax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fff:	eb 15                	jmp    801016 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f b6 d0             	movzbl %al,%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	0f b6 c0             	movzbl %al,%eax
  80100f:	39 c2                	cmp    %eax,%edx
  801011:	74 0d                	je     801020 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80101c:	72 e3                	jb     801001 <memfind+0x13>
  80101e:	eb 01                	jmp    801021 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801020:	90                   	nop
	return (void *) s;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80102c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801033:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103a:	eb 03                	jmp    80103f <strtol+0x19>
		s++;
  80103c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 20                	cmp    $0x20,%al
  801046:	74 f4                	je     80103c <strtol+0x16>
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 09                	cmp    $0x9,%al
  80104f:	74 eb                	je     80103c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 2b                	cmp    $0x2b,%al
  801058:	75 05                	jne    80105f <strtol+0x39>
		s++;
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	eb 13                	jmp    801072 <strtol+0x4c>
	else if (*s == '-')
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 2d                	cmp    $0x2d,%al
  801066:	75 0a                	jne    801072 <strtol+0x4c>
		s++, neg = 1;
  801068:	ff 45 08             	incl   0x8(%ebp)
  80106b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801076:	74 06                	je     80107e <strtol+0x58>
  801078:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80107c:	75 20                	jne    80109e <strtol+0x78>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 17                	jne    80109e <strtol+0x78>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	40                   	inc    %eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 78                	cmp    $0x78,%al
  80108f:	75 0d                	jne    80109e <strtol+0x78>
		s += 2, base = 16;
  801091:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801095:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80109c:	eb 28                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 15                	jne    8010b9 <strtol+0x93>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 30                	cmp    $0x30,%al
  8010ab:	75 0c                	jne    8010b9 <strtol+0x93>
		s++, base = 8;
  8010ad:	ff 45 08             	incl   0x8(%ebp)
  8010b0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b7:	eb 0d                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0)
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	75 07                	jne    8010c6 <strtol+0xa0>
		base = 10;
  8010bf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 2f                	cmp    $0x2f,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xc2>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 39                	cmp    $0x39,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xc2>
			dig = *s - '0';
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 30             	sub    $0x30,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 42                	jmp    80112a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 60                	cmp    $0x60,%al
  8010ef:	7e 19                	jle    80110a <strtol+0xe4>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 7a                	cmp    $0x7a,%al
  8010f8:	7f 10                	jg     80110a <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 57             	sub    $0x57,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801108:	eb 20                	jmp    80112a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 40                	cmp    $0x40,%al
  801111:	7e 39                	jle    80114c <strtol+0x126>
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	3c 5a                	cmp    $0x5a,%al
  80111a:	7f 30                	jg     80114c <strtol+0x126>
			dig = *s - 'A' + 10;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	0f be c0             	movsbl %al,%eax
  801124:	83 e8 37             	sub    $0x37,%eax
  801127:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801130:	7d 19                	jge    80114b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801132:	ff 45 08             	incl   0x8(%ebp)
  801135:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801138:	0f af 45 10          	imul   0x10(%ebp),%eax
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801141:	01 d0                	add    %edx,%eax
  801143:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801146:	e9 7b ff ff ff       	jmp    8010c6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80114b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80114c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801150:	74 08                	je     80115a <strtol+0x134>
		*endptr = (char *) s;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80115a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80115e:	74 07                	je     801167 <strtol+0x141>
  801160:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801163:	f7 d8                	neg    %eax
  801165:	eb 03                	jmp    80116a <strtol+0x144>
  801167:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <ltostr>:

void
ltostr(long value, char *str)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801180:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801184:	79 13                	jns    801199 <ltostr+0x2d>
	{
		neg = 1;
  801186:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801193:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801196:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011a1:	99                   	cltd   
  8011a2:	f7 f9                	idiv   %ecx
  8011a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	8d 50 01             	lea    0x1(%eax),%edx
  8011ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ba:	83 c2 30             	add    $0x30,%edx
  8011bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c7:	f7 e9                	imul   %ecx
  8011c9:	c1 fa 02             	sar    $0x2,%edx
  8011cc:	89 c8                	mov    %ecx,%eax
  8011ce:	c1 f8 1f             	sar    $0x1f,%eax
  8011d1:	29 c2                	sub    %eax,%edx
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e0:	f7 e9                	imul   %ecx
  8011e2:	c1 fa 02             	sar    $0x2,%edx
  8011e5:	89 c8                	mov    %ecx,%eax
  8011e7:	c1 f8 1f             	sar    $0x1f,%eax
  8011ea:	29 c2                	sub    %eax,%edx
  8011ec:	89 d0                	mov    %edx,%eax
  8011ee:	c1 e0 02             	shl    $0x2,%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	01 c0                	add    %eax,%eax
  8011f5:	29 c1                	sub    %eax,%ecx
  8011f7:	89 ca                	mov    %ecx,%edx
  8011f9:	85 d2                	test   %edx,%edx
  8011fb:	75 9c                	jne    801199 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801207:	48                   	dec    %eax
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80120b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120f:	74 3d                	je     80124e <ltostr+0xe2>
		start = 1 ;
  801211:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801218:	eb 34                	jmp    80124e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 c2                	add    %eax,%edx
  80122f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	01 c8                	add    %ecx,%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80123b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8a 45 eb             	mov    -0x15(%ebp),%al
  801246:	88 02                	mov    %al,(%edx)
		start++ ;
  801248:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80124b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80124e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801251:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801254:	7c c4                	jl     80121a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801256:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80126a:	ff 75 08             	pushl  0x8(%ebp)
  80126d:	e8 54 fa ff ff       	call   800cc6 <strlen>
  801272:	83 c4 04             	add    $0x4,%esp
  801275:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	e8 46 fa ff ff       	call   800cc6 <strlen>
  801280:	83 c4 04             	add    $0x4,%esp
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80128d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801294:	eb 17                	jmp    8012ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801296:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	01 c2                	add    %eax,%edx
  80129e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	01 c8                	add    %ecx,%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012aa:	ff 45 fc             	incl   -0x4(%ebp)
  8012ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b3:	7c e1                	jl     801296 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c3:	eb 1f                	jmp    8012e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ce:	89 c2                	mov    %eax,%edx
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 c2                	add    %eax,%edx
  8012d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	01 c8                	add    %ecx,%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e1:	ff 45 f8             	incl   -0x8(%ebp)
  8012e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ea:	7c d9                	jl     8012c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f7:	90                   	nop
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801306:	8b 45 14             	mov    0x14(%ebp),%eax
  801309:	8b 00                	mov    (%eax),%eax
  80130b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131d:	eb 0c                	jmp    80132b <strsplit+0x31>
			*string++ = 0;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8d 50 01             	lea    0x1(%eax),%edx
  801325:	89 55 08             	mov    %edx,0x8(%ebp)
  801328:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	74 18                	je     80134c <strsplit+0x52>
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	0f be c0             	movsbl %al,%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 0c             	pushl  0xc(%ebp)
  801340:	e8 13 fb ff ff       	call   800e58 <strchr>
  801345:	83 c4 08             	add    $0x8,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	75 d3                	jne    80131f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	84 c0                	test   %al,%al
  801353:	74 5a                	je     8013af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	83 f8 0f             	cmp    $0xf,%eax
  80135d:	75 07                	jne    801366 <strsplit+0x6c>
		{
			return 0;
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
  801364:	eb 66                	jmp    8013cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801366:	8b 45 14             	mov    0x14(%ebp),%eax
  801369:	8b 00                	mov    (%eax),%eax
  80136b:	8d 48 01             	lea    0x1(%eax),%ecx
  80136e:	8b 55 14             	mov    0x14(%ebp),%edx
  801371:	89 0a                	mov    %ecx,(%edx)
  801373:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
  80137d:	01 c2                	add    %eax,%edx
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801384:	eb 03                	jmp    801389 <strsplit+0x8f>
			string++;
  801386:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	84 c0                	test   %al,%al
  801390:	74 8b                	je     80131d <strsplit+0x23>
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	0f be c0             	movsbl %al,%eax
  80139a:	50                   	push   %eax
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	e8 b5 fa ff ff       	call   800e58 <strchr>
  8013a3:	83 c4 08             	add    $0x8,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	74 dc                	je     801386 <strsplit+0x8c>
			string++;
	}
  8013aa:	e9 6e ff ff ff       	jmp    80131d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b3:	8b 00                	mov    (%eax),%eax
  8013b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bf:	01 d0                	add    %edx,%eax
  8013c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	68 d0 24 80 00       	push   $0x8024d0
  8013dc:	6a 0e                	push   $0xe
  8013de:	68 0a 25 80 00       	push   $0x80250a
  8013e3:	e8 a8 ef ff ff       	call   800390 <_panic>

008013e8 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8013ee:	a1 04 30 80 00       	mov    0x803004,%eax
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	74 0f                	je     801406 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8013f7:	e8 d2 ff ff ff       	call   8013ce <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013fc:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801403:	00 00 00 
	}
	if (size == 0) return NULL ;
  801406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80140a:	75 07                	jne    801413 <malloc+0x2b>
  80140c:	b8 00 00 00 00       	mov    $0x0,%eax
  801411:	eb 14                	jmp    801427 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801413:	83 ec 04             	sub    $0x4,%esp
  801416:	68 18 25 80 00       	push   $0x802518
  80141b:	6a 2e                	push   $0x2e
  80141d:	68 0a 25 80 00       	push   $0x80250a
  801422:	e8 69 ef ff ff       	call   800390 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80142f:	83 ec 04             	sub    $0x4,%esp
  801432:	68 40 25 80 00       	push   $0x802540
  801437:	6a 49                	push   $0x49
  801439:	68 0a 25 80 00       	push   $0x80250a
  80143e:	e8 4d ef ff ff       	call   800390 <_panic>

00801443 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	83 ec 18             	sub    $0x18,%esp
  801449:	8b 45 10             	mov    0x10(%ebp),%eax
  80144c:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	68 64 25 80 00       	push   $0x802564
  801457:	6a 57                	push   $0x57
  801459:	68 0a 25 80 00       	push   $0x80250a
  80145e:	e8 2d ef ff ff       	call   800390 <_panic>

00801463 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	68 8c 25 80 00       	push   $0x80258c
  801471:	6a 60                	push   $0x60
  801473:	68 0a 25 80 00       	push   $0x80250a
  801478:	e8 13 ef ff ff       	call   800390 <_panic>

0080147d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801483:	83 ec 04             	sub    $0x4,%esp
  801486:	68 b0 25 80 00       	push   $0x8025b0
  80148b:	6a 7c                	push   $0x7c
  80148d:	68 0a 25 80 00       	push   $0x80250a
  801492:	e8 f9 ee ff ff       	call   800390 <_panic>

00801497 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	68 d8 25 80 00       	push   $0x8025d8
  8014a5:	68 86 00 00 00       	push   $0x86
  8014aa:	68 0a 25 80 00       	push   $0x80250a
  8014af:	e8 dc ee ff ff       	call   800390 <_panic>

008014b4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	68 fc 25 80 00       	push   $0x8025fc
  8014c2:	68 91 00 00 00       	push   $0x91
  8014c7:	68 0a 25 80 00       	push   $0x80250a
  8014cc:	e8 bf ee ff ff       	call   800390 <_panic>

008014d1 <shrink>:

}
void shrink(uint32 newSize)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014d7:	83 ec 04             	sub    $0x4,%esp
  8014da:	68 fc 25 80 00       	push   $0x8025fc
  8014df:	68 96 00 00 00       	push   $0x96
  8014e4:	68 0a 25 80 00       	push   $0x80250a
  8014e9:	e8 a2 ee ff ff       	call   800390 <_panic>

008014ee <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014f4:	83 ec 04             	sub    $0x4,%esp
  8014f7:	68 fc 25 80 00       	push   $0x8025fc
  8014fc:	68 9b 00 00 00       	push   $0x9b
  801501:	68 0a 25 80 00       	push   $0x80250a
  801506:	e8 85 ee ff ff       	call   800390 <_panic>

0080150b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	57                   	push   %edi
  80150f:	56                   	push   %esi
  801510:	53                   	push   %ebx
  801511:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80151d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801520:	8b 7d 18             	mov    0x18(%ebp),%edi
  801523:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801526:	cd 30                	int    $0x30
  801528:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80152b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	5b                   	pop    %ebx
  801532:	5e                   	pop    %esi
  801533:	5f                   	pop    %edi
  801534:	5d                   	pop    %ebp
  801535:	c3                   	ret    

00801536 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	83 ec 04             	sub    $0x4,%esp
  80153c:	8b 45 10             	mov    0x10(%ebp),%eax
  80153f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801542:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	52                   	push   %edx
  80154e:	ff 75 0c             	pushl  0xc(%ebp)
  801551:	50                   	push   %eax
  801552:	6a 00                	push   $0x0
  801554:	e8 b2 ff ff ff       	call   80150b <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	90                   	nop
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sys_cgetc>:

int
sys_cgetc(void)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 01                	push   $0x1
  80156e:	e8 98 ff ff ff       	call   80150b <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	52                   	push   %edx
  801588:	50                   	push   %eax
  801589:	6a 05                	push   $0x5
  80158b:	e8 7b ff ff ff       	call   80150b <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	56                   	push   %esi
  801599:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80159a:	8b 75 18             	mov    0x18(%ebp),%esi
  80159d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	56                   	push   %esi
  8015aa:	53                   	push   %ebx
  8015ab:	51                   	push   %ecx
  8015ac:	52                   	push   %edx
  8015ad:	50                   	push   %eax
  8015ae:	6a 06                	push   $0x6
  8015b0:	e8 56 ff ff ff       	call   80150b <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
}
  8015b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5e                   	pop    %esi
  8015bd:	5d                   	pop    %ebp
  8015be:	c3                   	ret    

008015bf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	52                   	push   %edx
  8015cf:	50                   	push   %eax
  8015d0:	6a 07                	push   $0x7
  8015d2:	e8 34 ff ff ff       	call   80150b <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	ff 75 0c             	pushl  0xc(%ebp)
  8015e8:	ff 75 08             	pushl  0x8(%ebp)
  8015eb:	6a 08                	push   $0x8
  8015ed:	e8 19 ff ff ff       	call   80150b <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 09                	push   $0x9
  801606:	e8 00 ff ff ff       	call   80150b <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 0a                	push   $0xa
  80161f:	e8 e7 fe ff ff       	call   80150b <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 0b                	push   $0xb
  801638:	e8 ce fe ff ff       	call   80150b <syscall>
  80163d:	83 c4 18             	add    $0x18,%esp
}
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	ff 75 0c             	pushl  0xc(%ebp)
  80164e:	ff 75 08             	pushl  0x8(%ebp)
  801651:	6a 0f                	push   $0xf
  801653:	e8 b3 fe ff ff       	call   80150b <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
	return;
  80165b:	90                   	nop
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	ff 75 0c             	pushl  0xc(%ebp)
  80166a:	ff 75 08             	pushl  0x8(%ebp)
  80166d:	6a 10                	push   $0x10
  80166f:	e8 97 fe ff ff       	call   80150b <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
	return ;
  801677:	90                   	nop
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	ff 75 10             	pushl  0x10(%ebp)
  801684:	ff 75 0c             	pushl  0xc(%ebp)
  801687:	ff 75 08             	pushl  0x8(%ebp)
  80168a:	6a 11                	push   $0x11
  80168c:	e8 7a fe ff ff       	call   80150b <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
	return ;
  801694:	90                   	nop
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 0c                	push   $0xc
  8016a6:	e8 60 fe ff ff       	call   80150b <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	6a 0d                	push   $0xd
  8016c0:	e8 46 fe ff ff       	call   80150b <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 0e                	push   $0xe
  8016d9:	e8 2d fe ff ff       	call   80150b <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
}
  8016e1:	90                   	nop
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 13                	push   $0x13
  8016f3:	e8 13 fe ff ff       	call   80150b <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	90                   	nop
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 14                	push   $0x14
  80170d:	e8 f9 fd ff ff       	call   80150b <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	90                   	nop
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_cputc>:


void
sys_cputc(const char c)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801724:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	50                   	push   %eax
  801731:	6a 15                	push   $0x15
  801733:	e8 d3 fd ff ff       	call   80150b <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 16                	push   $0x16
  80174d:	e8 b9 fd ff ff       	call   80150b <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	90                   	nop
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	50                   	push   %eax
  801768:	6a 17                	push   $0x17
  80176a:	e8 9c fd ff ff       	call   80150b <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801777:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	52                   	push   %edx
  801784:	50                   	push   %eax
  801785:	6a 1a                	push   $0x1a
  801787:	e8 7f fd ff ff       	call   80150b <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801794:	8b 55 0c             	mov    0xc(%ebp),%edx
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	52                   	push   %edx
  8017a1:	50                   	push   %eax
  8017a2:	6a 18                	push   $0x18
  8017a4:	e8 62 fd ff ff       	call   80150b <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	90                   	nop
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	52                   	push   %edx
  8017bf:	50                   	push   %eax
  8017c0:	6a 19                	push   $0x19
  8017c2:	e8 44 fd ff ff       	call   80150b <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
}
  8017ca:	90                   	nop
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017d9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	6a 00                	push   $0x0
  8017e5:	51                   	push   %ecx
  8017e6:	52                   	push   %edx
  8017e7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ea:	50                   	push   %eax
  8017eb:	6a 1b                	push   $0x1b
  8017ed:	e8 19 fd ff ff       	call   80150b <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	52                   	push   %edx
  801807:	50                   	push   %eax
  801808:	6a 1c                	push   $0x1c
  80180a:	e8 fc fc ff ff       	call   80150b <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801817:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	51                   	push   %ecx
  801825:	52                   	push   %edx
  801826:	50                   	push   %eax
  801827:	6a 1d                	push   $0x1d
  801829:	e8 dd fc ff ff       	call   80150b <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801836:	8b 55 0c             	mov    0xc(%ebp),%edx
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	52                   	push   %edx
  801843:	50                   	push   %eax
  801844:	6a 1e                	push   $0x1e
  801846:	e8 c0 fc ff ff       	call   80150b <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 1f                	push   $0x1f
  80185f:	e8 a7 fc ff ff       	call   80150b <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	6a 00                	push   $0x0
  801871:	ff 75 14             	pushl  0x14(%ebp)
  801874:	ff 75 10             	pushl  0x10(%ebp)
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	50                   	push   %eax
  80187b:	6a 20                	push   $0x20
  80187d:	e8 89 fc ff ff       	call   80150b <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	50                   	push   %eax
  801896:	6a 21                	push   $0x21
  801898:	e8 6e fc ff ff       	call   80150b <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	90                   	nop
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	50                   	push   %eax
  8018b2:	6a 22                	push   $0x22
  8018b4:	e8 52 fc ff ff       	call   80150b <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 02                	push   $0x2
  8018cd:	e8 39 fc ff ff       	call   80150b <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 03                	push   $0x3
  8018e6:	e8 20 fc ff ff       	call   80150b <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 04                	push   $0x4
  8018ff:	e8 07 fc ff ff       	call   80150b <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_exit_env>:


void sys_exit_env(void)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 23                	push   $0x23
  801918:	e8 ee fb ff ff       	call   80150b <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	90                   	nop
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801929:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80192c:	8d 50 04             	lea    0x4(%eax),%edx
  80192f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	52                   	push   %edx
  801939:	50                   	push   %eax
  80193a:	6a 24                	push   $0x24
  80193c:	e8 ca fb ff ff       	call   80150b <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
	return result;
  801944:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801947:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80194a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80194d:	89 01                	mov    %eax,(%ecx)
  80194f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	c9                   	leave  
  801956:	c2 04 00             	ret    $0x4

00801959 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	ff 75 10             	pushl  0x10(%ebp)
  801963:	ff 75 0c             	pushl  0xc(%ebp)
  801966:	ff 75 08             	pushl  0x8(%ebp)
  801969:	6a 12                	push   $0x12
  80196b:	e8 9b fb ff ff       	call   80150b <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
	return ;
  801973:	90                   	nop
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_rcr2>:
uint32 sys_rcr2()
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 25                	push   $0x25
  801985:	e8 81 fb ff ff       	call   80150b <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80199b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	50                   	push   %eax
  8019a8:	6a 26                	push   $0x26
  8019aa:	e8 5c fb ff ff       	call   80150b <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b2:	90                   	nop
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <rsttst>:
void rsttst()
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 28                	push   $0x28
  8019c4:	e8 42 fb ff ff       	call   80150b <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cc:	90                   	nop
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019db:	8b 55 18             	mov    0x18(%ebp),%edx
  8019de:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019e2:	52                   	push   %edx
  8019e3:	50                   	push   %eax
  8019e4:	ff 75 10             	pushl  0x10(%ebp)
  8019e7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ea:	ff 75 08             	pushl  0x8(%ebp)
  8019ed:	6a 27                	push   $0x27
  8019ef:	e8 17 fb ff ff       	call   80150b <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f7:	90                   	nop
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <chktst>:
void chktst(uint32 n)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	ff 75 08             	pushl  0x8(%ebp)
  801a08:	6a 29                	push   $0x29
  801a0a:	e8 fc fa ff ff       	call   80150b <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a12:	90                   	nop
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <inctst>:

void inctst()
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 2a                	push   $0x2a
  801a24:	e8 e2 fa ff ff       	call   80150b <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2c:	90                   	nop
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <gettst>:
uint32 gettst()
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 2b                	push   $0x2b
  801a3e:	e8 c8 fa ff ff       	call   80150b <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 2c                	push   $0x2c
  801a5a:	e8 ac fa ff ff       	call   80150b <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
  801a62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a65:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a69:	75 07                	jne    801a72 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a70:	eb 05                	jmp    801a77 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 2c                	push   $0x2c
  801a8b:	e8 7b fa ff ff       	call   80150b <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
  801a93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a96:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a9a:	75 07                	jne    801aa3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa1:	eb 05                	jmp    801aa8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 2c                	push   $0x2c
  801abc:	e8 4a fa ff ff       	call   80150b <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
  801ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ac7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801acb:	75 07                	jne    801ad4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801acd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad2:	eb 05                	jmp    801ad9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 2c                	push   $0x2c
  801aed:	e8 19 fa ff ff       	call   80150b <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
  801af5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801af8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801afc:	75 07                	jne    801b05 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801afe:	b8 01 00 00 00       	mov    $0x1,%eax
  801b03:	eb 05                	jmp    801b0a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	ff 75 08             	pushl  0x8(%ebp)
  801b1a:	6a 2d                	push   $0x2d
  801b1c:	e8 ea f9 ff ff       	call   80150b <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
	return ;
  801b24:	90                   	nop
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b2b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	6a 00                	push   $0x0
  801b39:	53                   	push   %ebx
  801b3a:	51                   	push   %ecx
  801b3b:	52                   	push   %edx
  801b3c:	50                   	push   %eax
  801b3d:	6a 2e                	push   $0x2e
  801b3f:	e8 c7 f9 ff ff       	call   80150b <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	52                   	push   %edx
  801b5c:	50                   	push   %eax
  801b5d:	6a 2f                	push   $0x2f
  801b5f:	e8 a7 f9 ff ff       	call   80150b <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    
  801b69:	66 90                	xchg   %ax,%ax
  801b6b:	90                   	nop

00801b6c <__udivdi3>:
  801b6c:	55                   	push   %ebp
  801b6d:	57                   	push   %edi
  801b6e:	56                   	push   %esi
  801b6f:	53                   	push   %ebx
  801b70:	83 ec 1c             	sub    $0x1c,%esp
  801b73:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b77:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b83:	89 ca                	mov    %ecx,%edx
  801b85:	89 f8                	mov    %edi,%eax
  801b87:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b8b:	85 f6                	test   %esi,%esi
  801b8d:	75 2d                	jne    801bbc <__udivdi3+0x50>
  801b8f:	39 cf                	cmp    %ecx,%edi
  801b91:	77 65                	ja     801bf8 <__udivdi3+0x8c>
  801b93:	89 fd                	mov    %edi,%ebp
  801b95:	85 ff                	test   %edi,%edi
  801b97:	75 0b                	jne    801ba4 <__udivdi3+0x38>
  801b99:	b8 01 00 00 00       	mov    $0x1,%eax
  801b9e:	31 d2                	xor    %edx,%edx
  801ba0:	f7 f7                	div    %edi
  801ba2:	89 c5                	mov    %eax,%ebp
  801ba4:	31 d2                	xor    %edx,%edx
  801ba6:	89 c8                	mov    %ecx,%eax
  801ba8:	f7 f5                	div    %ebp
  801baa:	89 c1                	mov    %eax,%ecx
  801bac:	89 d8                	mov    %ebx,%eax
  801bae:	f7 f5                	div    %ebp
  801bb0:	89 cf                	mov    %ecx,%edi
  801bb2:	89 fa                	mov    %edi,%edx
  801bb4:	83 c4 1c             	add    $0x1c,%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5f                   	pop    %edi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
  801bbc:	39 ce                	cmp    %ecx,%esi
  801bbe:	77 28                	ja     801be8 <__udivdi3+0x7c>
  801bc0:	0f bd fe             	bsr    %esi,%edi
  801bc3:	83 f7 1f             	xor    $0x1f,%edi
  801bc6:	75 40                	jne    801c08 <__udivdi3+0x9c>
  801bc8:	39 ce                	cmp    %ecx,%esi
  801bca:	72 0a                	jb     801bd6 <__udivdi3+0x6a>
  801bcc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bd0:	0f 87 9e 00 00 00    	ja     801c74 <__udivdi3+0x108>
  801bd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdb:	89 fa                	mov    %edi,%edx
  801bdd:	83 c4 1c             	add    $0x1c,%esp
  801be0:	5b                   	pop    %ebx
  801be1:	5e                   	pop    %esi
  801be2:	5f                   	pop    %edi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    
  801be5:	8d 76 00             	lea    0x0(%esi),%esi
  801be8:	31 ff                	xor    %edi,%edi
  801bea:	31 c0                	xor    %eax,%eax
  801bec:	89 fa                	mov    %edi,%edx
  801bee:	83 c4 1c             	add    $0x1c,%esp
  801bf1:	5b                   	pop    %ebx
  801bf2:	5e                   	pop    %esi
  801bf3:	5f                   	pop    %edi
  801bf4:	5d                   	pop    %ebp
  801bf5:	c3                   	ret    
  801bf6:	66 90                	xchg   %ax,%ax
  801bf8:	89 d8                	mov    %ebx,%eax
  801bfa:	f7 f7                	div    %edi
  801bfc:	31 ff                	xor    %edi,%edi
  801bfe:	89 fa                	mov    %edi,%edx
  801c00:	83 c4 1c             	add    $0x1c,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    
  801c08:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c0d:	89 eb                	mov    %ebp,%ebx
  801c0f:	29 fb                	sub    %edi,%ebx
  801c11:	89 f9                	mov    %edi,%ecx
  801c13:	d3 e6                	shl    %cl,%esi
  801c15:	89 c5                	mov    %eax,%ebp
  801c17:	88 d9                	mov    %bl,%cl
  801c19:	d3 ed                	shr    %cl,%ebp
  801c1b:	89 e9                	mov    %ebp,%ecx
  801c1d:	09 f1                	or     %esi,%ecx
  801c1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c23:	89 f9                	mov    %edi,%ecx
  801c25:	d3 e0                	shl    %cl,%eax
  801c27:	89 c5                	mov    %eax,%ebp
  801c29:	89 d6                	mov    %edx,%esi
  801c2b:	88 d9                	mov    %bl,%cl
  801c2d:	d3 ee                	shr    %cl,%esi
  801c2f:	89 f9                	mov    %edi,%ecx
  801c31:	d3 e2                	shl    %cl,%edx
  801c33:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c37:	88 d9                	mov    %bl,%cl
  801c39:	d3 e8                	shr    %cl,%eax
  801c3b:	09 c2                	or     %eax,%edx
  801c3d:	89 d0                	mov    %edx,%eax
  801c3f:	89 f2                	mov    %esi,%edx
  801c41:	f7 74 24 0c          	divl   0xc(%esp)
  801c45:	89 d6                	mov    %edx,%esi
  801c47:	89 c3                	mov    %eax,%ebx
  801c49:	f7 e5                	mul    %ebp
  801c4b:	39 d6                	cmp    %edx,%esi
  801c4d:	72 19                	jb     801c68 <__udivdi3+0xfc>
  801c4f:	74 0b                	je     801c5c <__udivdi3+0xf0>
  801c51:	89 d8                	mov    %ebx,%eax
  801c53:	31 ff                	xor    %edi,%edi
  801c55:	e9 58 ff ff ff       	jmp    801bb2 <__udivdi3+0x46>
  801c5a:	66 90                	xchg   %ax,%ax
  801c5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c60:	89 f9                	mov    %edi,%ecx
  801c62:	d3 e2                	shl    %cl,%edx
  801c64:	39 c2                	cmp    %eax,%edx
  801c66:	73 e9                	jae    801c51 <__udivdi3+0xe5>
  801c68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c6b:	31 ff                	xor    %edi,%edi
  801c6d:	e9 40 ff ff ff       	jmp    801bb2 <__udivdi3+0x46>
  801c72:	66 90                	xchg   %ax,%ax
  801c74:	31 c0                	xor    %eax,%eax
  801c76:	e9 37 ff ff ff       	jmp    801bb2 <__udivdi3+0x46>
  801c7b:	90                   	nop

00801c7c <__umoddi3>:
  801c7c:	55                   	push   %ebp
  801c7d:	57                   	push   %edi
  801c7e:	56                   	push   %esi
  801c7f:	53                   	push   %ebx
  801c80:	83 ec 1c             	sub    $0x1c,%esp
  801c83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c87:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c9b:	89 f3                	mov    %esi,%ebx
  801c9d:	89 fa                	mov    %edi,%edx
  801c9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca3:	89 34 24             	mov    %esi,(%esp)
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	75 1a                	jne    801cc4 <__umoddi3+0x48>
  801caa:	39 f7                	cmp    %esi,%edi
  801cac:	0f 86 a2 00 00 00    	jbe    801d54 <__umoddi3+0xd8>
  801cb2:	89 c8                	mov    %ecx,%eax
  801cb4:	89 f2                	mov    %esi,%edx
  801cb6:	f7 f7                	div    %edi
  801cb8:	89 d0                	mov    %edx,%eax
  801cba:	31 d2                	xor    %edx,%edx
  801cbc:	83 c4 1c             	add    $0x1c,%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5f                   	pop    %edi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    
  801cc4:	39 f0                	cmp    %esi,%eax
  801cc6:	0f 87 ac 00 00 00    	ja     801d78 <__umoddi3+0xfc>
  801ccc:	0f bd e8             	bsr    %eax,%ebp
  801ccf:	83 f5 1f             	xor    $0x1f,%ebp
  801cd2:	0f 84 ac 00 00 00    	je     801d84 <__umoddi3+0x108>
  801cd8:	bf 20 00 00 00       	mov    $0x20,%edi
  801cdd:	29 ef                	sub    %ebp,%edi
  801cdf:	89 fe                	mov    %edi,%esi
  801ce1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ce5:	89 e9                	mov    %ebp,%ecx
  801ce7:	d3 e0                	shl    %cl,%eax
  801ce9:	89 d7                	mov    %edx,%edi
  801ceb:	89 f1                	mov    %esi,%ecx
  801ced:	d3 ef                	shr    %cl,%edi
  801cef:	09 c7                	or     %eax,%edi
  801cf1:	89 e9                	mov    %ebp,%ecx
  801cf3:	d3 e2                	shl    %cl,%edx
  801cf5:	89 14 24             	mov    %edx,(%esp)
  801cf8:	89 d8                	mov    %ebx,%eax
  801cfa:	d3 e0                	shl    %cl,%eax
  801cfc:	89 c2                	mov    %eax,%edx
  801cfe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d02:	d3 e0                	shl    %cl,%eax
  801d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d08:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0c:	89 f1                	mov    %esi,%ecx
  801d0e:	d3 e8                	shr    %cl,%eax
  801d10:	09 d0                	or     %edx,%eax
  801d12:	d3 eb                	shr    %cl,%ebx
  801d14:	89 da                	mov    %ebx,%edx
  801d16:	f7 f7                	div    %edi
  801d18:	89 d3                	mov    %edx,%ebx
  801d1a:	f7 24 24             	mull   (%esp)
  801d1d:	89 c6                	mov    %eax,%esi
  801d1f:	89 d1                	mov    %edx,%ecx
  801d21:	39 d3                	cmp    %edx,%ebx
  801d23:	0f 82 87 00 00 00    	jb     801db0 <__umoddi3+0x134>
  801d29:	0f 84 91 00 00 00    	je     801dc0 <__umoddi3+0x144>
  801d2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d33:	29 f2                	sub    %esi,%edx
  801d35:	19 cb                	sbb    %ecx,%ebx
  801d37:	89 d8                	mov    %ebx,%eax
  801d39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d3d:	d3 e0                	shl    %cl,%eax
  801d3f:	89 e9                	mov    %ebp,%ecx
  801d41:	d3 ea                	shr    %cl,%edx
  801d43:	09 d0                	or     %edx,%eax
  801d45:	89 e9                	mov    %ebp,%ecx
  801d47:	d3 eb                	shr    %cl,%ebx
  801d49:	89 da                	mov    %ebx,%edx
  801d4b:	83 c4 1c             	add    $0x1c,%esp
  801d4e:	5b                   	pop    %ebx
  801d4f:	5e                   	pop    %esi
  801d50:	5f                   	pop    %edi
  801d51:	5d                   	pop    %ebp
  801d52:	c3                   	ret    
  801d53:	90                   	nop
  801d54:	89 fd                	mov    %edi,%ebp
  801d56:	85 ff                	test   %edi,%edi
  801d58:	75 0b                	jne    801d65 <__umoddi3+0xe9>
  801d5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5f:	31 d2                	xor    %edx,%edx
  801d61:	f7 f7                	div    %edi
  801d63:	89 c5                	mov    %eax,%ebp
  801d65:	89 f0                	mov    %esi,%eax
  801d67:	31 d2                	xor    %edx,%edx
  801d69:	f7 f5                	div    %ebp
  801d6b:	89 c8                	mov    %ecx,%eax
  801d6d:	f7 f5                	div    %ebp
  801d6f:	89 d0                	mov    %edx,%eax
  801d71:	e9 44 ff ff ff       	jmp    801cba <__umoddi3+0x3e>
  801d76:	66 90                	xchg   %ax,%ax
  801d78:	89 c8                	mov    %ecx,%eax
  801d7a:	89 f2                	mov    %esi,%edx
  801d7c:	83 c4 1c             	add    $0x1c,%esp
  801d7f:	5b                   	pop    %ebx
  801d80:	5e                   	pop    %esi
  801d81:	5f                   	pop    %edi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    
  801d84:	3b 04 24             	cmp    (%esp),%eax
  801d87:	72 06                	jb     801d8f <__umoddi3+0x113>
  801d89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d8d:	77 0f                	ja     801d9e <__umoddi3+0x122>
  801d8f:	89 f2                	mov    %esi,%edx
  801d91:	29 f9                	sub    %edi,%ecx
  801d93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d97:	89 14 24             	mov    %edx,(%esp)
  801d9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801da2:	8b 14 24             	mov    (%esp),%edx
  801da5:	83 c4 1c             	add    $0x1c,%esp
  801da8:	5b                   	pop    %ebx
  801da9:	5e                   	pop    %esi
  801daa:	5f                   	pop    %edi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    
  801dad:	8d 76 00             	lea    0x0(%esi),%esi
  801db0:	2b 04 24             	sub    (%esp),%eax
  801db3:	19 fa                	sbb    %edi,%edx
  801db5:	89 d1                	mov    %edx,%ecx
  801db7:	89 c6                	mov    %eax,%esi
  801db9:	e9 71 ff ff ff       	jmp    801d2f <__umoddi3+0xb3>
  801dbe:	66 90                	xchg   %ax,%ax
  801dc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dc4:	72 ea                	jb     801db0 <__umoddi3+0x134>
  801dc6:	89 d9                	mov    %ebx,%ecx
  801dc8:	e9 62 ff ff ff       	jmp    801d2f <__umoddi3+0xb3>
