
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 77 01 00 00       	call   8001ad <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 e0 1d 80 00       	push   $0x801de0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 1d 80 00       	push   $0x801dfc
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 a7 17 00 00       	call   801849 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 1c 1e 80 00       	push   $0x801e1c
  8000aa:	50                   	push   %eax
  8000ab:	e8 0c 13 00 00       	call   8013bc <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 20 1e 80 00       	push   $0x801e20
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 48 1e 80 00       	push   $0x801e48
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 df 19 00 00       	call   801ac2 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 65 14 00 00       	call   801550 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 f7 12 00 00       	call   8013f0 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 68 1e 80 00       	push   $0x801e68
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 3f 14 00 00       	call   801550 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 80 1e 80 00       	push   $0x801e80
  800127:	6a 20                	push   $0x20
  800129:	68 fc 1d 80 00       	push   $0x801dfc
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 50 18 00 00       	call   801988 <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 20 1f 80 00       	push   $0x801f20
  800145:	6a 23                	push   $0x23
  800147:	68 fc 1d 80 00       	push   $0x801dfc
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 2c 1f 80 00       	push   $0x801f2c
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 50 1f 80 00       	push   $0x801f50
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 d3 16 00 00       	call   801849 <sys_getparentenvid>
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80017d:	7e 2b                	jle    8001aa <_main+0x172>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  80017f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	68 9c 1f 80 00       	push   $0x801f9c
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 26 12 00 00       	call   8013bc <sget>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	8d 50 01             	lea    0x1(%eax),%edx
  8001a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a7:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a9:	90                   	nop
  8001aa:	90                   	nop
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001b3:	e8 78 16 00 00       	call   801830 <sys_getenvindex>
  8001b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001be:	89 d0                	mov    %edx,%eax
  8001c0:	c1 e0 03             	shl    $0x3,%eax
  8001c3:	01 d0                	add    %edx,%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	01 d0                	add    %edx,%eax
  8001c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	c1 e0 04             	shl    $0x4,%eax
  8001d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001da:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001df:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e4:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001ea:	84 c0                	test   %al,%al
  8001ec:	74 0f                	je     8001fd <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f3:	05 5c 05 00 00       	add    $0x55c,%eax
  8001f8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800201:	7e 0a                	jle    80020d <libmain+0x60>
		binaryname = argv[0];
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	8b 00                	mov    (%eax),%eax
  800208:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	ff 75 08             	pushl  0x8(%ebp)
  800216:	e8 1d fe ff ff       	call   800038 <_main>
  80021b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80021e:	e8 1a 14 00 00       	call   80163d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 c4 1f 80 00       	push   $0x801fc4
  80022b:	e8 6d 03 00 00       	call   80059d <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800233:	a1 20 30 80 00       	mov    0x803020,%eax
  800238:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80023e:	a1 20 30 80 00       	mov    0x803020,%eax
  800243:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800249:	83 ec 04             	sub    $0x4,%esp
  80024c:	52                   	push   %edx
  80024d:	50                   	push   %eax
  80024e:	68 ec 1f 80 00       	push   $0x801fec
  800253:	e8 45 03 00 00       	call   80059d <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025b:	a1 20 30 80 00       	mov    0x803020,%eax
  800260:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800266:	a1 20 30 80 00       	mov    0x803020,%eax
  80026b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800271:	a1 20 30 80 00       	mov    0x803020,%eax
  800276:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80027c:	51                   	push   %ecx
  80027d:	52                   	push   %edx
  80027e:	50                   	push   %eax
  80027f:	68 14 20 80 00       	push   $0x802014
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 30 80 00       	mov    0x803020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 6c 20 80 00       	push   $0x80206c
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 c4 1f 80 00       	push   $0x801fc4
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 9a 13 00 00       	call   801657 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002bd:	e8 19 00 00 00       	call   8002db <exit>
}
  8002c2:	90                   	nop
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	6a 00                	push   $0x0
  8002d0:	e8 27 15 00 00       	call   8017fc <sys_destroy_env>
  8002d5:	83 c4 10             	add    $0x10,%esp
}
  8002d8:	90                   	nop
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <exit>:

void
exit(void)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e1:	e8 7c 15 00 00       	call   801862 <sys_exit_env>
}
  8002e6:	90                   	nop
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f2:	83 c0 04             	add    $0x4,%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f8:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	74 16                	je     800317 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800301:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	68 80 20 80 00       	push   $0x802080
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 30 80 00       	mov    0x803000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 85 20 80 00       	push   $0x802085
  800328:	e8 70 02 00 00       	call   80059d <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800330:	8b 45 10             	mov    0x10(%ebp),%eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 f4             	pushl  -0xc(%ebp)
  800339:	50                   	push   %eax
  80033a:	e8 f3 01 00 00       	call   800532 <vcprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	6a 00                	push   $0x0
  800347:	68 a1 20 80 00       	push   $0x8020a1
  80034c:	e8 e1 01 00 00       	call   800532 <vcprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800354:	e8 82 ff ff ff       	call   8002db <exit>

	// should not return here
	while (1) ;
  800359:	eb fe                	jmp    800359 <_panic+0x70>

0080035b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800361:	a1 20 30 80 00       	mov    0x803020,%eax
  800366:	8b 50 74             	mov    0x74(%eax),%edx
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	74 14                	je     800384 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 a4 20 80 00       	push   $0x8020a4
  800378:	6a 26                	push   $0x26
  80037a:	68 f0 20 80 00       	push   $0x8020f0
  80037f:	e8 65 ff ff ff       	call   8002e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800392:	e9 c2 00 00 00       	jmp    800459 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	75 08                	jne    8003b4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003af:	e9 a2 00 00 00       	jmp    800456 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c2:	eb 69                	jmp    80042d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	c1 e0 03             	shl    $0x3,%eax
  8003db:	01 c8                	add    %ecx,%eax
  8003dd:	8a 40 04             	mov    0x4(%eax),%al
  8003e0:	84 c0                	test   %al,%al
  8003e2:	75 46                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f2:	89 d0                	mov    %edx,%eax
  8003f4:	01 c0                	add    %eax,%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	c1 e0 03             	shl    $0x3,%eax
  8003fb:	01 c8                	add    %ecx,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	01 c8                	add    %ecx,%eax
  80041b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	75 09                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800421:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800428:	eb 12                	jmp    80043c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	ff 45 e8             	incl   -0x18(%ebp)
  80042d:	a1 20 30 80 00       	mov    0x803020,%eax
  800432:	8b 50 74             	mov    0x74(%eax),%edx
  800435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800438:	39 c2                	cmp    %eax,%edx
  80043a:	77 88                	ja     8003c4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80043c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800440:	75 14                	jne    800456 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 fc 20 80 00       	push   $0x8020fc
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 f0 20 80 00       	push   $0x8020f0
  800451:	e8 93 fe ff ff       	call   8002e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800456:	ff 45 f0             	incl   -0x10(%ebp)
  800459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80045f:	0f 8c 32 ff ff ff    	jl     800397 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800465:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800473:	eb 26                	jmp    80049b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800475:	a1 20 30 80 00       	mov    0x803020,%eax
  80047a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800483:	89 d0                	mov    %edx,%eax
  800485:	01 c0                	add    %eax,%eax
  800487:	01 d0                	add    %edx,%eax
  800489:	c1 e0 03             	shl    $0x3,%eax
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	8a 40 04             	mov    0x4(%eax),%al
  800491:	3c 01                	cmp    $0x1,%al
  800493:	75 03                	jne    800498 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800495:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	ff 45 e0             	incl   -0x20(%ebp)
  80049b:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a0:	8b 50 74             	mov    0x74(%eax),%edx
  8004a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a6:	39 c2                	cmp    %eax,%edx
  8004a8:	77 cb                	ja     800475 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b0:	74 14                	je     8004c6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 50 21 80 00       	push   $0x802150
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 f0 20 80 00       	push   $0x8020f0
  8004c1:	e8 23 fe ff ff       	call   8002e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004c6:	90                   	nop
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	89 0a                	mov    %ecx,(%edx)
  8004dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8004df:	88 d1                	mov    %dl,%cl
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f2:	75 2c                	jne    800520 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004f4:	a0 24 30 80 00       	mov    0x803024,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ff:	8b 12                	mov    (%edx),%edx
  800501:	89 d1                	mov    %edx,%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	83 c2 08             	add    $0x8,%edx
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	50                   	push   %eax
  80050d:	51                   	push   %ecx
  80050e:	52                   	push   %edx
  80050f:	e8 7b 0f 00 00       	call   80148f <sys_cputs>
  800514:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	8b 40 04             	mov    0x4(%eax),%eax
  800526:	8d 50 01             	lea    0x1(%eax),%edx
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052f:	90                   	nop
  800530:	c9                   	leave  
  800531:	c3                   	ret    

00800532 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800542:	00 00 00 
	b.cnt = 0;
  800545:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	ff 75 08             	pushl  0x8(%ebp)
  800555:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055b:	50                   	push   %eax
  80055c:	68 c9 04 80 00       	push   $0x8004c9
  800561:	e8 11 02 00 00       	call   800777 <vprintfmt>
  800566:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800569:	a0 24 30 80 00       	mov    0x803024,%al
  80056e:	0f b6 c0             	movzbl %al,%eax
  800571:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	50                   	push   %eax
  80057b:	52                   	push   %edx
  80057c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800582:	83 c0 08             	add    $0x8,%eax
  800585:	50                   	push   %eax
  800586:	e8 04 0f 00 00       	call   80148f <sys_cputs>
  80058b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80058e:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800595:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80059b:	c9                   	leave  
  80059c:	c3                   	ret    

0080059d <cprintf>:

int cprintf(const char *fmt, ...) {
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a3:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	e8 73 ff ff ff       	call   800532 <vcprintf>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005d0:	e8 68 10 00 00       	call   80163d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e4:	50                   	push   %eax
  8005e5:	e8 48 ff ff ff       	call   800532 <vcprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005f0:	e8 62 10 00 00       	call   801657 <sys_enable_interrupt>
	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	53                   	push   %ebx
  8005fe:	83 ec 14             	sub    $0x14,%esp
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80060d:	8b 45 18             	mov    0x18(%ebp),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800618:	77 55                	ja     80066f <printnum+0x75>
  80061a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061d:	72 05                	jb     800624 <printnum+0x2a>
  80061f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800622:	77 4b                	ja     80066f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800624:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800627:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80062a:	8b 45 18             	mov    0x18(%ebp),%eax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	ff 75 f0             	pushl  -0x10(%ebp)
  80063a:	e8 39 15 00 00       	call   801b78 <__udivdi3>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	ff 75 20             	pushl  0x20(%ebp)
  800648:	53                   	push   %ebx
  800649:	ff 75 18             	pushl  0x18(%ebp)
  80064c:	52                   	push   %edx
  80064d:	50                   	push   %eax
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	ff 75 08             	pushl  0x8(%ebp)
  800654:	e8 a1 ff ff ff       	call   8005fa <printnum>
  800659:	83 c4 20             	add    $0x20,%esp
  80065c:	eb 1a                	jmp    800678 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	ff 75 20             	pushl  0x20(%ebp)
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	ff d0                	call   *%eax
  80066c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066f:	ff 4d 1c             	decl   0x1c(%ebp)
  800672:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800676:	7f e6                	jg     80065e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800678:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800686:	53                   	push   %ebx
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	e8 f9 15 00 00       	call   801c88 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 b4 23 80 00       	add    $0x8023b4,%eax
  800697:	8a 00                	mov    (%eax),%al
  800699:	0f be c0             	movsbl %al,%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006af:	c9                   	leave  
  8006b0:	c3                   	ret    

008006b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 40                	jmp    800716 <getuint+0x65>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1e                	je     8006fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	eb 1c                	jmp    800716 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071f:	7e 1c                	jle    80073d <getint+0x25>
		return va_arg(*ap, long long);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 08             	lea    0x8(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 08             	sub    $0x8,%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	eb 38                	jmp    800775 <getint+0x5d>
	else if (lflag)
  80073d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800741:	74 1a                	je     80075d <getint+0x45>
		return va_arg(*ap, long);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	8d 50 04             	lea    0x4(%eax),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 10                	mov    %edx,(%eax)
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	99                   	cltd   
  80075b:	eb 18                	jmp    800775 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	99                   	cltd   
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	56                   	push   %esi
  80077b:	53                   	push   %ebx
  80077c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x21>
			if (ch == '\0')
  800781:	85 db                	test   %ebx,%ebx
  800783:	0f 84 af 03 00 00    	je     800b38 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	53                   	push   %ebx
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	83 fb 25             	cmp    $0x25,%ebx
  8007a9:	75 d6                	jne    800781 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	8d 50 01             	lea    0x1(%eax),%edx
  8007d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d4:	8a 00                	mov    (%eax),%al
  8007d6:	0f b6 d8             	movzbl %al,%ebx
  8007d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007dc:	83 f8 55             	cmp    $0x55,%eax
  8007df:	0f 87 2b 03 00 00    	ja     800b10 <vprintfmt+0x399>
  8007e5:	8b 04 85 d8 23 80 00 	mov    0x8023d8(,%eax,4),%eax
  8007ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f2:	eb d7                	jmp    8007cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007f8:	eb d1                	jmp    8007cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800801:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800804:	89 d0                	mov    %edx,%eax
  800806:	c1 e0 02             	shl    $0x2,%eax
  800809:	01 d0                	add    %edx,%eax
  80080b:	01 c0                	add    %eax,%eax
  80080d:	01 d8                	add    %ebx,%eax
  80080f:	83 e8 30             	sub    $0x30,%eax
  800812:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8a 00                	mov    (%eax),%al
  80081a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80081d:	83 fb 2f             	cmp    $0x2f,%ebx
  800820:	7e 3e                	jle    800860 <vprintfmt+0xe9>
  800822:	83 fb 39             	cmp    $0x39,%ebx
  800825:	7f 39                	jg     800860 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800827:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80082a:	eb d5                	jmp    800801 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800840:	eb 1f                	jmp    800861 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	79 83                	jns    8007cb <vprintfmt+0x54>
				width = 0;
  800848:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80084f:	e9 77 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800854:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80085b:	e9 6b ff ff ff       	jmp    8007cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800860:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800865:	0f 89 60 ff ff ff    	jns    8007cb <vprintfmt+0x54>
				width = precision, precision = -1;
  80086b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80086e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800871:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800878:	e9 4e ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80087d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800880:	e9 46 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	50                   	push   %eax
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	ff d0                	call   *%eax
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 89 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008bb:	85 db                	test   %ebx,%ebx
  8008bd:	79 02                	jns    8008c1 <vprintfmt+0x14a>
				err = -err;
  8008bf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c1:	83 fb 64             	cmp    $0x64,%ebx
  8008c4:	7f 0b                	jg     8008d1 <vprintfmt+0x15a>
  8008c6:	8b 34 9d 20 22 80 00 	mov    0x802220(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 c5 23 80 00       	push   $0x8023c5
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 5e 02 00 00       	call   800b40 <printfmt>
  8008e2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e5:	e9 49 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ea:	56                   	push   %esi
  8008eb:	68 ce 23 80 00       	push   $0x8023ce
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 45 02 00 00       	call   800b40 <printfmt>
  8008fb:	83 c4 10             	add    $0x10,%esp
			break;
  8008fe:	e9 30 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 30                	mov    (%eax),%esi
  800914:	85 f6                	test   %esi,%esi
  800916:	75 05                	jne    80091d <vprintfmt+0x1a6>
				p = "(null)";
  800918:	be d1 23 80 00       	mov    $0x8023d1,%esi
			if (width > 0 && padc != '-')
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7e 6d                	jle    800990 <vprintfmt+0x219>
  800923:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800927:	74 67                	je     800990 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	50                   	push   %eax
  800930:	56                   	push   %esi
  800931:	e8 0c 03 00 00       	call   800c42 <strnlen>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80093c:	eb 16                	jmp    800954 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80093e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	50                   	push   %eax
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800951:	ff 4d e4             	decl   -0x1c(%ebp)
  800954:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800958:	7f e4                	jg     80093e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	eb 34                	jmp    800990 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	74 1c                	je     80097e <vprintfmt+0x207>
  800962:	83 fb 1f             	cmp    $0x1f,%ebx
  800965:	7e 05                	jle    80096c <vprintfmt+0x1f5>
  800967:	83 fb 7e             	cmp    $0x7e,%ebx
  80096a:	7e 12                	jle    80097e <vprintfmt+0x207>
					putch('?', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 3f                	push   $0x3f
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	eb 0f                	jmp    80098d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098d:	ff 4d e4             	decl   -0x1c(%ebp)
  800990:	89 f0                	mov    %esi,%eax
  800992:	8d 70 01             	lea    0x1(%eax),%esi
  800995:	8a 00                	mov    (%eax),%al
  800997:	0f be d8             	movsbl %al,%ebx
  80099a:	85 db                	test   %ebx,%ebx
  80099c:	74 24                	je     8009c2 <vprintfmt+0x24b>
  80099e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a2:	78 b8                	js     80095c <vprintfmt+0x1e5>
  8009a4:	ff 4d e0             	decl   -0x20(%ebp)
  8009a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ab:	79 af                	jns    80095c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ad:	eb 13                	jmp    8009c2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 20                	push   $0x20
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c6:	7f e7                	jg     8009af <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009c8:	e9 66 01 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d6:	50                   	push   %eax
  8009d7:	e8 3c fd ff ff       	call   800718 <getint>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009eb:	85 d2                	test   %edx,%edx
  8009ed:	79 23                	jns    800a12 <vprintfmt+0x29b>
				putch('-', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 2d                	push   $0x2d
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a05:	f7 d8                	neg    %eax
  800a07:	83 d2 00             	adc    $0x0,%edx
  800a0a:	f7 da                	neg    %edx
  800a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 e8             	pushl  -0x18(%ebp)
  800a24:	8d 45 14             	lea    0x14(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	e8 84 fc ff ff       	call   8006b1 <getuint>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3d:	e9 98 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 58                	push   $0x58
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 58                	push   $0x58
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 58                	push   $0x58
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
			break;
  800a72:	e9 bc 00 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 30                	push   $0x30
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 78                	push   $0x78
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab9:	eb 1f                	jmp    800ada <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac4:	50                   	push   %eax
  800ac5:	e8 e7 fb ff ff       	call   8006b1 <getuint>
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ada:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae1:	83 ec 04             	sub    $0x4,%esp
  800ae4:	52                   	push   %edx
  800ae5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  800aec:	ff 75 f0             	pushl  -0x10(%ebp)
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 00 fb ff ff       	call   8005fa <printnum>
  800afa:	83 c4 20             	add    $0x20,%esp
			break;
  800afd:	eb 34                	jmp    800b33 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
			break;
  800b0e:	eb 23                	jmp    800b33 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 25                	push   $0x25
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b20:	ff 4d 10             	decl   0x10(%ebp)
  800b23:	eb 03                	jmp    800b28 <vprintfmt+0x3b1>
  800b25:	ff 4d 10             	decl   0x10(%ebp)
  800b28:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2b:	48                   	dec    %eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	3c 25                	cmp    $0x25,%al
  800b30:	75 f3                	jne    800b25 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b32:	90                   	nop
		}
	}
  800b33:	e9 47 fc ff ff       	jmp    80077f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b38:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b46:	8d 45 10             	lea    0x10(%ebp),%eax
  800b49:	83 c0 04             	add    $0x4,%eax
  800b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	ff 75 f4             	pushl  -0xc(%ebp)
  800b55:	50                   	push   %eax
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 16 fc ff ff       	call   800777 <vprintfmt>
  800b61:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b64:	90                   	nop
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 40 08             	mov    0x8(%eax),%eax
  800b70:	8d 50 01             	lea    0x1(%eax),%edx
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 10                	mov    (%eax),%edx
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8b 40 04             	mov    0x4(%eax),%eax
  800b84:	39 c2                	cmp    %eax,%edx
  800b86:	73 12                	jae    800b9a <sprintputch+0x33>
		*b->buf++ = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 10                	mov    %dl,(%eax)
}
  800b9a:	90                   	nop
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	01 d0                	add    %edx,%eax
  800bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	74 06                	je     800bca <vsnprintf+0x2d>
  800bc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc8:	7f 07                	jg     800bd1 <vsnprintf+0x34>
		return -E_INVAL;
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	eb 20                	jmp    800bf1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd1:	ff 75 14             	pushl  0x14(%ebp)
  800bd4:	ff 75 10             	pushl  0x10(%ebp)
  800bd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bda:	50                   	push   %eax
  800bdb:	68 67 0b 80 00       	push   $0x800b67
  800be0:	e8 92 fb ff ff       	call   800777 <vprintfmt>
  800be5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800beb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf9:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfc:	83 c0 04             	add    $0x4,%eax
  800bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	ff 75 f4             	pushl  -0xc(%ebp)
  800c08:	50                   	push   %eax
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	ff 75 08             	pushl  0x8(%ebp)
  800c0f:	e8 89 ff ff ff       	call   800b9d <vsnprintf>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 06                	jmp    800c34 <strlen+0x15>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 f1                	jne    800c2e <strlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4f:	eb 09                	jmp    800c5a <strnlen+0x18>
		n++;
  800c51:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c54:	ff 45 08             	incl   0x8(%ebp)
  800c57:	ff 4d 0c             	decl   0xc(%ebp)
  800c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5e:	74 09                	je     800c69 <strnlen+0x27>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 e8                	jne    800c51 <strnlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c7a:	90                   	nop
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8d:	8a 12                	mov    (%edx),%dl
  800c8f:	88 10                	mov    %dl,(%eax)
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e4                	jne    800c7b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800caf:	eb 1f                	jmp    800cd0 <strncpy+0x34>
		*dst++ = *src;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8d 50 01             	lea    0x1(%eax),%edx
  800cb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	84 c0                	test   %al,%al
  800cc8:	74 03                	je     800ccd <strncpy+0x31>
			src++;
  800cca:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ccd:	ff 45 fc             	incl   -0x4(%ebp)
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd6:	72 d9                	jb     800cb1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ced:	74 30                	je     800d1f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cef:	eb 16                	jmp    800d07 <strlcpy+0x2a>
			*dst++ = *src++;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8d 50 01             	lea    0x1(%eax),%edx
  800cf7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d03:	8a 12                	mov    (%edx),%dl
  800d05:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d07:	ff 4d 10             	decl   0x10(%ebp)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 09                	je     800d19 <strlcpy+0x3c>
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	75 d8                	jne    800cf1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d25:	29 c2                	sub    %eax,%edx
  800d27:	89 d0                	mov    %edx,%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d2e:	eb 06                	jmp    800d36 <strcmp+0xb>
		p++, q++;
  800d30:	ff 45 08             	incl   0x8(%ebp)
  800d33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 0e                	je     800d4d <strcmp+0x22>
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 10                	mov    (%eax),%dl
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	38 c2                	cmp    %al,%dl
  800d4b:	74 e3                	je     800d30 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 d0             	movzbl %al,%edx
  800d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	0f b6 c0             	movzbl %al,%eax
  800d5d:	29 c2                	sub    %eax,%edx
  800d5f:	89 d0                	mov    %edx,%eax
}
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d66:	eb 09                	jmp    800d71 <strncmp+0xe>
		n--, p++, q++;
  800d68:	ff 4d 10             	decl   0x10(%ebp)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	74 17                	je     800d8e <strncmp+0x2b>
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	74 0e                	je     800d8e <strncmp+0x2b>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 10                	mov    (%eax),%dl
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	38 c2                	cmp    %al,%dl
  800d8c:	74 da                	je     800d68 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d92:	75 07                	jne    800d9b <strncmp+0x38>
		return 0;
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	eb 14                	jmp    800daf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	0f b6 d0             	movzbl %al,%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	0f b6 c0             	movzbl %al,%eax
  800dab:	29 c2                	sub    %eax,%edx
  800dad:	89 d0                	mov    %edx,%eax
}
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 04             	sub    $0x4,%esp
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbd:	eb 12                	jmp    800dd1 <strchr+0x20>
		if (*s == c)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc7:	75 05                	jne    800dce <strchr+0x1d>
			return (char *) s;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	eb 11                	jmp    800ddf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dce:	ff 45 08             	incl   0x8(%ebp)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	84 c0                	test   %al,%al
  800dd8:	75 e5                	jne    800dbf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ded:	eb 0d                	jmp    800dfc <strfind+0x1b>
		if (*s == c)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df7:	74 0e                	je     800e07 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	75 ea                	jne    800def <strfind+0xe>
  800e05:	eb 01                	jmp    800e08 <strfind+0x27>
		if (*s == c)
			break;
  800e07:	90                   	nop
	return (char *) s;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1f:	eb 0e                	jmp    800e2f <memset+0x22>
		*p++ = c;
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	8d 50 01             	lea    0x1(%eax),%edx
  800e27:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2f:	ff 4d f8             	decl   -0x8(%ebp)
  800e32:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e36:	79 e9                	jns    800e21 <memset+0x14>
		*p++ = c;

	return v;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4f:	eb 16                	jmp    800e67 <memcpy+0x2a>
		*d++ = *s++;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e60:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e63:	8a 12                	mov    (%edx),%dl
  800e65:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	75 dd                	jne    800e51 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e91:	73 50                	jae    800ee3 <memmove+0x6a>
  800e93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9e:	76 43                	jbe    800ee3 <memmove+0x6a>
		s += n;
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eac:	eb 10                	jmp    800ebe <memmove+0x45>
			*--d = *--s;
  800eae:	ff 4d f8             	decl   -0x8(%ebp)
  800eb1:	ff 4d fc             	decl   -0x4(%ebp)
  800eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb7:	8a 10                	mov    (%eax),%dl
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	75 e3                	jne    800eae <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ecb:	eb 23                	jmp    800ef0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed0:	8d 50 01             	lea    0x1(%eax),%edx
  800ed3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edf:	8a 12                	mov    (%edx),%dl
  800ee1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	75 dd                	jne    800ecd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f07:	eb 2a                	jmp    800f33 <memcmp+0x3e>
		if (*s1 != *s2)
  800f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0c:	8a 10                	mov    (%eax),%dl
  800f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	38 c2                	cmp    %al,%dl
  800f15:	74 16                	je     800f2d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	0f b6 d0             	movzbl %al,%edx
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 c0             	movzbl %al,%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 d0                	mov    %edx,%eax
  800f2b:	eb 18                	jmp    800f45 <memcmp+0x50>
		s1++, s2++;
  800f2d:	ff 45 fc             	incl   -0x4(%ebp)
  800f30:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f39:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	75 c9                	jne    800f09 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 45 10             	mov    0x10(%ebp),%eax
  800f53:	01 d0                	add    %edx,%eax
  800f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f58:	eb 15                	jmp    800f6f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	0f b6 d0             	movzbl %al,%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	0f b6 c0             	movzbl %al,%eax
  800f68:	39 c2                	cmp    %eax,%edx
  800f6a:	74 0d                	je     800f79 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f6c:	ff 45 08             	incl   0x8(%ebp)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f75:	72 e3                	jb     800f5a <memfind+0x13>
  800f77:	eb 01                	jmp    800f7a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f79:	90                   	nop
	return (void *) s;
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f93:	eb 03                	jmp    800f98 <strtol+0x19>
		s++;
  800f95:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3c 20                	cmp    $0x20,%al
  800f9f:	74 f4                	je     800f95 <strtol+0x16>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 09                	cmp    $0x9,%al
  800fa8:	74 eb                	je     800f95 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 2b                	cmp    $0x2b,%al
  800fb1:	75 05                	jne    800fb8 <strtol+0x39>
		s++;
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	eb 13                	jmp    800fcb <strtol+0x4c>
	else if (*s == '-')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2d                	cmp    $0x2d,%al
  800fbf:	75 0a                	jne    800fcb <strtol+0x4c>
		s++, neg = 1;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
  800fc4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	74 06                	je     800fd7 <strtol+0x58>
  800fd1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd5:	75 20                	jne    800ff7 <strtol+0x78>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 30                	cmp    $0x30,%al
  800fde:	75 17                	jne    800ff7 <strtol+0x78>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	40                   	inc    %eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 78                	cmp    $0x78,%al
  800fe8:	75 0d                	jne    800ff7 <strtol+0x78>
		s += 2, base = 16;
  800fea:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fee:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff5:	eb 28                	jmp    80101f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 15                	jne    801012 <strtol+0x93>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 30                	cmp    $0x30,%al
  801004:	75 0c                	jne    801012 <strtol+0x93>
		s++, base = 8;
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801010:	eb 0d                	jmp    80101f <strtol+0xa0>
	else if (base == 0)
  801012:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801016:	75 07                	jne    80101f <strtol+0xa0>
		base = 10;
  801018:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3c 2f                	cmp    $0x2f,%al
  801026:	7e 19                	jle    801041 <strtol+0xc2>
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 39                	cmp    $0x39,%al
  80102f:	7f 10                	jg     801041 <strtol+0xc2>
			dig = *s - '0';
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	0f be c0             	movsbl %al,%eax
  801039:	83 e8 30             	sub    $0x30,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103f:	eb 42                	jmp    801083 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	3c 60                	cmp    $0x60,%al
  801048:	7e 19                	jle    801063 <strtol+0xe4>
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3c 7a                	cmp    $0x7a,%al
  801051:	7f 10                	jg     801063 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f be c0             	movsbl %al,%eax
  80105b:	83 e8 57             	sub    $0x57,%eax
  80105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801061:	eb 20                	jmp    801083 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 40                	cmp    $0x40,%al
  80106a:	7e 39                	jle    8010a5 <strtol+0x126>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 5a                	cmp    $0x5a,%al
  801073:	7f 30                	jg     8010a5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f be c0             	movsbl %al,%eax
  80107d:	83 e8 37             	sub    $0x37,%eax
  801080:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 10             	cmp    0x10(%ebp),%eax
  801089:	7d 19                	jge    8010a4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	0f af 45 10          	imul   0x10(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109a:	01 d0                	add    %edx,%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109f:	e9 7b ff ff ff       	jmp    80101f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010a4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a9:	74 08                	je     8010b3 <strtol+0x134>
		*endptr = (char *) s;
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b7:	74 07                	je     8010c0 <strtol+0x141>
  8010b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bc:	f7 d8                	neg    %eax
  8010be:	eb 03                	jmp    8010c3 <strtol+0x144>
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dd:	79 13                	jns    8010f2 <ltostr+0x2d>
	{
		neg = 1;
  8010df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ec:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ef:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010fa:	99                   	cltd   
  8010fb:	f7 f9                	idiv   %ecx
  8010fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801103:	8d 50 01             	lea    0x1(%eax),%edx
  801106:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801109:	89 c2                	mov    %eax,%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801113:	83 c2 30             	add    $0x30,%edx
  801116:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801120:	f7 e9                	imul   %ecx
  801122:	c1 fa 02             	sar    $0x2,%edx
  801125:	89 c8                	mov    %ecx,%eax
  801127:	c1 f8 1f             	sar    $0x1f,%eax
  80112a:	29 c2                	sub    %eax,%edx
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801134:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801139:	f7 e9                	imul   %ecx
  80113b:	c1 fa 02             	sar    $0x2,%edx
  80113e:	89 c8                	mov    %ecx,%eax
  801140:	c1 f8 1f             	sar    $0x1f,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
  801147:	c1 e0 02             	shl    $0x2,%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	01 c0                	add    %eax,%eax
  80114e:	29 c1                	sub    %eax,%ecx
  801150:	89 ca                	mov    %ecx,%edx
  801152:	85 d2                	test   %edx,%edx
  801154:	75 9c                	jne    8010f2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80115d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801160:	48                   	dec    %eax
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801164:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801168:	74 3d                	je     8011a7 <ltostr+0xe2>
		start = 1 ;
  80116a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801171:	eb 34                	jmp    8011a7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	01 d0                	add    %edx,%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	01 c8                	add    %ecx,%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801194:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 c2                	add    %eax,%edx
  80119c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80119f:	88 02                	mov    %al,(%edx)
		start++ ;
  8011a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ad:	7c c4                	jl     801173 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ba:	90                   	nop
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011c3:	ff 75 08             	pushl  0x8(%ebp)
  8011c6:	e8 54 fa ff ff       	call   800c1f <strlen>
  8011cb:	83 c4 04             	add    $0x4,%esp
  8011ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	e8 46 fa ff ff       	call   800c1f <strlen>
  8011d9:	83 c4 04             	add    $0x4,%esp
  8011dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ed:	eb 17                	jmp    801206 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801203:	ff 45 fc             	incl   -0x4(%ebp)
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80120c:	7c e1                	jl     8011ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80120e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801215:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80121c:	eb 1f                	jmp    80123d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80121e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801221:	8d 50 01             	lea    0x1(%eax),%edx
  801224:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801227:	89 c2                	mov    %eax,%edx
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	01 c2                	add    %eax,%edx
  80122e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	01 c8                	add    %ecx,%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80123a:	ff 45 f8             	incl   -0x8(%ebp)
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801240:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801243:	7c d9                	jl     80121e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801245:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	c6 00 00             	movb   $0x0,(%eax)
}
  801250:	90                   	nop
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801256:	8b 45 14             	mov    0x14(%ebp),%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80125f:	8b 45 14             	mov    0x14(%ebp),%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801276:	eb 0c                	jmp    801284 <strsplit+0x31>
			*string++ = 0;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 08             	mov    %edx,0x8(%ebp)
  801281:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	84 c0                	test   %al,%al
  80128b:	74 18                	je     8012a5 <strsplit+0x52>
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	0f be c0             	movsbl %al,%eax
  801295:	50                   	push   %eax
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 13 fb ff ff       	call   800db1 <strchr>
  80129e:	83 c4 08             	add    $0x8,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	75 d3                	jne    801278 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	84 c0                	test   %al,%al
  8012ac:	74 5a                	je     801308 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b1:	8b 00                	mov    (%eax),%eax
  8012b3:	83 f8 0f             	cmp    $0xf,%eax
  8012b6:	75 07                	jne    8012bf <strsplit+0x6c>
		{
			return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bd:	eb 66                	jmp    801325 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c2:	8b 00                	mov    (%eax),%eax
  8012c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012ca:	89 0a                	mov    %ecx,(%edx)
  8012cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d6:	01 c2                	add    %eax,%edx
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012dd:	eb 03                	jmp    8012e2 <strsplit+0x8f>
			string++;
  8012df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 8b                	je     801276 <strsplit+0x23>
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	0f be c0             	movsbl %al,%eax
  8012f3:	50                   	push   %eax
  8012f4:	ff 75 0c             	pushl  0xc(%ebp)
  8012f7:	e8 b5 fa ff ff       	call   800db1 <strchr>
  8012fc:	83 c4 08             	add    $0x8,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 dc                	je     8012df <strsplit+0x8c>
			string++;
	}
  801303:	e9 6e ff ff ff       	jmp    801276 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801308:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801309:	8b 45 14             	mov    0x14(%ebp),%eax
  80130c:	8b 00                	mov    (%eax),%eax
  80130e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801320:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  80132d:	83 ec 04             	sub    $0x4,%esp
  801330:	68 30 25 80 00       	push   $0x802530
  801335:	6a 0e                	push   $0xe
  801337:	68 6a 25 80 00       	push   $0x80256a
  80133c:	e8 a8 ef ff ff       	call   8002e9 <_panic>

00801341 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801347:	a1 04 30 80 00       	mov    0x803004,%eax
  80134c:	85 c0                	test   %eax,%eax
  80134e:	74 0f                	je     80135f <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801350:	e8 d2 ff ff ff       	call   801327 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801355:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  80135c:	00 00 00 
	}
	if (size == 0) return NULL ;
  80135f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801363:	75 07                	jne    80136c <malloc+0x2b>
  801365:	b8 00 00 00 00       	mov    $0x0,%eax
  80136a:	eb 14                	jmp    801380 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	68 78 25 80 00       	push   $0x802578
  801374:	6a 2e                	push   $0x2e
  801376:	68 6a 25 80 00       	push   $0x80256a
  80137b:	e8 69 ef ff ff       	call   8002e9 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801380:	c9                   	leave  
  801381:	c3                   	ret    

00801382 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801388:	83 ec 04             	sub    $0x4,%esp
  80138b:	68 a0 25 80 00       	push   $0x8025a0
  801390:	6a 49                	push   $0x49
  801392:	68 6a 25 80 00       	push   $0x80256a
  801397:	e8 4d ef ff ff       	call   8002e9 <_panic>

0080139c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	83 ec 18             	sub    $0x18,%esp
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	68 c4 25 80 00       	push   $0x8025c4
  8013b0:	6a 57                	push   $0x57
  8013b2:	68 6a 25 80 00       	push   $0x80256a
  8013b7:	e8 2d ef ff ff       	call   8002e9 <_panic>

008013bc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013c2:	83 ec 04             	sub    $0x4,%esp
  8013c5:	68 ec 25 80 00       	push   $0x8025ec
  8013ca:	6a 60                	push   $0x60
  8013cc:	68 6a 25 80 00       	push   $0x80256a
  8013d1:	e8 13 ef ff ff       	call   8002e9 <_panic>

008013d6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013dc:	83 ec 04             	sub    $0x4,%esp
  8013df:	68 10 26 80 00       	push   $0x802610
  8013e4:	6a 7c                	push   $0x7c
  8013e6:	68 6a 25 80 00       	push   $0x80256a
  8013eb:	e8 f9 ee ff ff       	call   8002e9 <_panic>

008013f0 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	68 38 26 80 00       	push   $0x802638
  8013fe:	68 86 00 00 00       	push   $0x86
  801403:	68 6a 25 80 00       	push   $0x80256a
  801408:	e8 dc ee ff ff       	call   8002e9 <_panic>

0080140d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801413:	83 ec 04             	sub    $0x4,%esp
  801416:	68 5c 26 80 00       	push   $0x80265c
  80141b:	68 91 00 00 00       	push   $0x91
  801420:	68 6a 25 80 00       	push   $0x80256a
  801425:	e8 bf ee ff ff       	call   8002e9 <_panic>

0080142a <shrink>:

}
void shrink(uint32 newSize)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801430:	83 ec 04             	sub    $0x4,%esp
  801433:	68 5c 26 80 00       	push   $0x80265c
  801438:	68 96 00 00 00       	push   $0x96
  80143d:	68 6a 25 80 00       	push   $0x80256a
  801442:	e8 a2 ee ff ff       	call   8002e9 <_panic>

00801447 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80144d:	83 ec 04             	sub    $0x4,%esp
  801450:	68 5c 26 80 00       	push   $0x80265c
  801455:	68 9b 00 00 00       	push   $0x9b
  80145a:	68 6a 25 80 00       	push   $0x80256a
  80145f:	e8 85 ee ff ff       	call   8002e9 <_panic>

00801464 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	57                   	push   %edi
  801468:	56                   	push   %esi
  801469:	53                   	push   %ebx
  80146a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8b 55 0c             	mov    0xc(%ebp),%edx
  801473:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801476:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801479:	8b 7d 18             	mov    0x18(%ebp),%edi
  80147c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80147f:	cd 30                	int    $0x30
  801481:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801484:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	5b                   	pop    %ebx
  80148b:	5e                   	pop    %esi
  80148c:	5f                   	pop    %edi
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    

0080148f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 45 10             	mov    0x10(%ebp),%eax
  801498:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80149b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	52                   	push   %edx
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	50                   	push   %eax
  8014ab:	6a 00                	push   $0x0
  8014ad:	e8 b2 ff ff ff       	call   801464 <syscall>
  8014b2:	83 c4 18             	add    $0x18,%esp
}
  8014b5:	90                   	nop
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 01                	push   $0x1
  8014c7:	e8 98 ff ff ff       	call   801464 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	52                   	push   %edx
  8014e1:	50                   	push   %eax
  8014e2:	6a 05                	push   $0x5
  8014e4:	e8 7b ff ff ff       	call   801464 <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	56                   	push   %esi
  8014f2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014f3:	8b 75 18             	mov    0x18(%ebp),%esi
  8014f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	56                   	push   %esi
  801503:	53                   	push   %ebx
  801504:	51                   	push   %ecx
  801505:	52                   	push   %edx
  801506:	50                   	push   %eax
  801507:	6a 06                	push   $0x6
  801509:	e8 56 ff ff ff       	call   801464 <syscall>
  80150e:	83 c4 18             	add    $0x18,%esp
}
  801511:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801514:	5b                   	pop    %ebx
  801515:	5e                   	pop    %esi
  801516:	5d                   	pop    %ebp
  801517:	c3                   	ret    

00801518 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80151b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	52                   	push   %edx
  801528:	50                   	push   %eax
  801529:	6a 07                	push   $0x7
  80152b:	e8 34 ff ff ff       	call   801464 <syscall>
  801530:	83 c4 18             	add    $0x18,%esp
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	ff 75 0c             	pushl  0xc(%ebp)
  801541:	ff 75 08             	pushl  0x8(%ebp)
  801544:	6a 08                	push   $0x8
  801546:	e8 19 ff ff ff       	call   801464 <syscall>
  80154b:	83 c4 18             	add    $0x18,%esp
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 09                	push   $0x9
  80155f:	e8 00 ff ff ff       	call   801464 <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 0a                	push   $0xa
  801578:	e8 e7 fe ff ff       	call   801464 <syscall>
  80157d:	83 c4 18             	add    $0x18,%esp
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 0b                	push   $0xb
  801591:	e8 ce fe ff ff       	call   801464 <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	ff 75 0c             	pushl  0xc(%ebp)
  8015a7:	ff 75 08             	pushl  0x8(%ebp)
  8015aa:	6a 0f                	push   $0xf
  8015ac:	e8 b3 fe ff ff       	call   801464 <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
	return;
  8015b4:	90                   	nop
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	ff 75 0c             	pushl  0xc(%ebp)
  8015c3:	ff 75 08             	pushl  0x8(%ebp)
  8015c6:	6a 10                	push   $0x10
  8015c8:	e8 97 fe ff ff       	call   801464 <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d0:	90                   	nop
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	ff 75 10             	pushl  0x10(%ebp)
  8015dd:	ff 75 0c             	pushl  0xc(%ebp)
  8015e0:	ff 75 08             	pushl  0x8(%ebp)
  8015e3:	6a 11                	push   $0x11
  8015e5:	e8 7a fe ff ff       	call   801464 <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ed:	90                   	nop
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 0c                	push   $0xc
  8015ff:	e8 60 fe ff ff       	call   801464 <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	ff 75 08             	pushl  0x8(%ebp)
  801617:	6a 0d                	push   $0xd
  801619:	e8 46 fe ff ff       	call   801464 <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 0e                	push   $0xe
  801632:	e8 2d fe ff ff       	call   801464 <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	90                   	nop
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 13                	push   $0x13
  80164c:	e8 13 fe ff ff       	call   801464 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
}
  801654:	90                   	nop
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 14                	push   $0x14
  801666:	e8 f9 fd ff ff       	call   801464 <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
}
  80166e:	90                   	nop
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sys_cputc>:


void
sys_cputc(const char c)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 04             	sub    $0x4,%esp
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80167d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	50                   	push   %eax
  80168a:	6a 15                	push   $0x15
  80168c:	e8 d3 fd ff ff       	call   801464 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	90                   	nop
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 16                	push   $0x16
  8016a6:	e8 b9 fd ff ff       	call   801464 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	90                   	nop
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	ff 75 0c             	pushl  0xc(%ebp)
  8016c0:	50                   	push   %eax
  8016c1:	6a 17                	push   $0x17
  8016c3:	e8 9c fd ff ff       	call   801464 <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	52                   	push   %edx
  8016dd:	50                   	push   %eax
  8016de:	6a 1a                	push   $0x1a
  8016e0:	e8 7f fd ff ff       	call   801464 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	52                   	push   %edx
  8016fa:	50                   	push   %eax
  8016fb:	6a 18                	push   $0x18
  8016fd:	e8 62 fd ff ff       	call   801464 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	90                   	nop
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80170b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	52                   	push   %edx
  801718:	50                   	push   %eax
  801719:	6a 19                	push   $0x19
  80171b:	e8 44 fd ff ff       	call   801464 <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	90                   	nop
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	8b 45 10             	mov    0x10(%ebp),%eax
  80172f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801732:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801735:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	51                   	push   %ecx
  80173f:	52                   	push   %edx
  801740:	ff 75 0c             	pushl  0xc(%ebp)
  801743:	50                   	push   %eax
  801744:	6a 1b                	push   $0x1b
  801746:	e8 19 fd ff ff       	call   801464 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801753:	8b 55 0c             	mov    0xc(%ebp),%edx
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	52                   	push   %edx
  801760:	50                   	push   %eax
  801761:	6a 1c                	push   $0x1c
  801763:	e8 fc fc ff ff       	call   801464 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801770:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801773:	8b 55 0c             	mov    0xc(%ebp),%edx
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	51                   	push   %ecx
  80177e:	52                   	push   %edx
  80177f:	50                   	push   %eax
  801780:	6a 1d                	push   $0x1d
  801782:	e8 dd fc ff ff       	call   801464 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80178f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	52                   	push   %edx
  80179c:	50                   	push   %eax
  80179d:	6a 1e                	push   $0x1e
  80179f:	e8 c0 fc ff ff       	call   801464 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 1f                	push   $0x1f
  8017b8:	e8 a7 fc ff ff       	call   801464 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	6a 00                	push   $0x0
  8017ca:	ff 75 14             	pushl  0x14(%ebp)
  8017cd:	ff 75 10             	pushl  0x10(%ebp)
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	50                   	push   %eax
  8017d4:	6a 20                	push   $0x20
  8017d6:	e8 89 fc ff ff       	call   801464 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	50                   	push   %eax
  8017ef:	6a 21                	push   $0x21
  8017f1:	e8 6e fc ff ff       	call   801464 <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
}
  8017f9:	90                   	nop
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	50                   	push   %eax
  80180b:	6a 22                	push   $0x22
  80180d:	e8 52 fc ff ff       	call   801464 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 02                	push   $0x2
  801826:	e8 39 fc ff ff       	call   801464 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 03                	push   $0x3
  80183f:	e8 20 fc ff ff       	call   801464 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 04                	push   $0x4
  801858:	e8 07 fc ff ff       	call   801464 <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_exit_env>:


void sys_exit_env(void)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 23                	push   $0x23
  801871:	e8 ee fb ff ff       	call   801464 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	90                   	nop
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801882:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801885:	8d 50 04             	lea    0x4(%eax),%edx
  801888:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	52                   	push   %edx
  801892:	50                   	push   %eax
  801893:	6a 24                	push   $0x24
  801895:	e8 ca fb ff ff       	call   801464 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
	return result;
  80189d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a6:	89 01                	mov    %eax,(%ecx)
  8018a8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	c9                   	leave  
  8018af:	c2 04 00             	ret    $0x4

008018b2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	ff 75 10             	pushl  0x10(%ebp)
  8018bc:	ff 75 0c             	pushl  0xc(%ebp)
  8018bf:	ff 75 08             	pushl  0x8(%ebp)
  8018c2:	6a 12                	push   $0x12
  8018c4:	e8 9b fb ff ff       	call   801464 <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018cc:	90                   	nop
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_rcr2>:
uint32 sys_rcr2()
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 25                	push   $0x25
  8018de:	e8 81 fb ff ff       	call   801464 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018f4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	50                   	push   %eax
  801901:	6a 26                	push   $0x26
  801903:	e8 5c fb ff ff       	call   801464 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
	return ;
  80190b:	90                   	nop
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <rsttst>:
void rsttst()
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 28                	push   $0x28
  80191d:	e8 42 fb ff ff       	call   801464 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
	return ;
  801925:	90                   	nop
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	8b 45 14             	mov    0x14(%ebp),%eax
  801931:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801934:	8b 55 18             	mov    0x18(%ebp),%edx
  801937:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80193b:	52                   	push   %edx
  80193c:	50                   	push   %eax
  80193d:	ff 75 10             	pushl  0x10(%ebp)
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	ff 75 08             	pushl  0x8(%ebp)
  801946:	6a 27                	push   $0x27
  801948:	e8 17 fb ff ff       	call   801464 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
	return ;
  801950:	90                   	nop
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <chktst>:
void chktst(uint32 n)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	ff 75 08             	pushl  0x8(%ebp)
  801961:	6a 29                	push   $0x29
  801963:	e8 fc fa ff ff       	call   801464 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
	return ;
  80196b:	90                   	nop
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <inctst>:

void inctst()
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 2a                	push   $0x2a
  80197d:	e8 e2 fa ff ff       	call   801464 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
	return ;
  801985:	90                   	nop
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <gettst>:
uint32 gettst()
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 2b                	push   $0x2b
  801997:	e8 c8 fa ff ff       	call   801464 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 2c                	push   $0x2c
  8019b3:	e8 ac fa ff ff       	call   801464 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
  8019bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019be:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019c2:	75 07                	jne    8019cb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c9:	eb 05                	jmp    8019d0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 2c                	push   $0x2c
  8019e4:	e8 7b fa ff ff       	call   801464 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
  8019ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019ef:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019f3:	75 07                	jne    8019fc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fa:	eb 05                	jmp    801a01 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 2c                	push   $0x2c
  801a15:	e8 4a fa ff ff       	call   801464 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
  801a1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a20:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a24:	75 07                	jne    801a2d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a26:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2b:	eb 05                	jmp    801a32 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 2c                	push   $0x2c
  801a46:	e8 19 fa ff ff       	call   801464 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
  801a4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a51:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a55:	75 07                	jne    801a5e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a57:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5c:	eb 05                	jmp    801a63 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	6a 2d                	push   $0x2d
  801a75:	e8 ea f9 ff ff       	call   801464 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7d:	90                   	nop
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a84:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	6a 00                	push   $0x0
  801a92:	53                   	push   %ebx
  801a93:	51                   	push   %ecx
  801a94:	52                   	push   %edx
  801a95:	50                   	push   %eax
  801a96:	6a 2e                	push   $0x2e
  801a98:	e8 c7 f9 ff ff       	call   801464 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801aa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	52                   	push   %edx
  801ab5:	50                   	push   %eax
  801ab6:	6a 2f                	push   $0x2f
  801ab8:	e8 a7 f9 ff ff       	call   801464 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ac8:	8b 55 08             	mov    0x8(%ebp),%edx
  801acb:	89 d0                	mov    %edx,%eax
  801acd:	c1 e0 02             	shl    $0x2,%eax
  801ad0:	01 d0                	add    %edx,%eax
  801ad2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae2:	01 d0                	add    %edx,%eax
  801ae4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aeb:	01 d0                	add    %edx,%eax
  801aed:	c1 e0 04             	shl    $0x4,%eax
  801af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801af3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801afa:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801afd:	83 ec 0c             	sub    $0xc,%esp
  801b00:	50                   	push   %eax
  801b01:	e8 76 fd ff ff       	call   80187c <sys_get_virtual_time>
  801b06:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801b09:	eb 41                	jmp    801b4c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801b0b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b0e:	83 ec 0c             	sub    $0xc,%esp
  801b11:	50                   	push   %eax
  801b12:	e8 65 fd ff ff       	call   80187c <sys_get_virtual_time>
  801b17:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b20:	29 c2                	sub    %eax,%edx
  801b22:	89 d0                	mov    %edx,%eax
  801b24:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b2d:	89 d1                	mov    %edx,%ecx
  801b2f:	29 c1                	sub    %eax,%ecx
  801b31:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b37:	39 c2                	cmp    %eax,%edx
  801b39:	0f 97 c0             	seta   %al
  801b3c:	0f b6 c0             	movzbl %al,%eax
  801b3f:	29 c1                	sub    %eax,%ecx
  801b41:	89 c8                	mov    %ecx,%eax
  801b43:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b46:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b49:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b52:	72 b7                	jb     801b0b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b54:	90                   	nop
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801b5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b64:	eb 03                	jmp    801b69 <busy_wait+0x12>
  801b66:	ff 45 fc             	incl   -0x4(%ebp)
  801b69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b6f:	72 f5                	jb     801b66 <busy_wait+0xf>
	return i;
  801b71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    
  801b76:	66 90                	xchg   %ax,%ax

00801b78 <__udivdi3>:
  801b78:	55                   	push   %ebp
  801b79:	57                   	push   %edi
  801b7a:	56                   	push   %esi
  801b7b:	53                   	push   %ebx
  801b7c:	83 ec 1c             	sub    $0x1c,%esp
  801b7f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b83:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b8f:	89 ca                	mov    %ecx,%edx
  801b91:	89 f8                	mov    %edi,%eax
  801b93:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b97:	85 f6                	test   %esi,%esi
  801b99:	75 2d                	jne    801bc8 <__udivdi3+0x50>
  801b9b:	39 cf                	cmp    %ecx,%edi
  801b9d:	77 65                	ja     801c04 <__udivdi3+0x8c>
  801b9f:	89 fd                	mov    %edi,%ebp
  801ba1:	85 ff                	test   %edi,%edi
  801ba3:	75 0b                	jne    801bb0 <__udivdi3+0x38>
  801ba5:	b8 01 00 00 00       	mov    $0x1,%eax
  801baa:	31 d2                	xor    %edx,%edx
  801bac:	f7 f7                	div    %edi
  801bae:	89 c5                	mov    %eax,%ebp
  801bb0:	31 d2                	xor    %edx,%edx
  801bb2:	89 c8                	mov    %ecx,%eax
  801bb4:	f7 f5                	div    %ebp
  801bb6:	89 c1                	mov    %eax,%ecx
  801bb8:	89 d8                	mov    %ebx,%eax
  801bba:	f7 f5                	div    %ebp
  801bbc:	89 cf                	mov    %ecx,%edi
  801bbe:	89 fa                	mov    %edi,%edx
  801bc0:	83 c4 1c             	add    $0x1c,%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5f                   	pop    %edi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    
  801bc8:	39 ce                	cmp    %ecx,%esi
  801bca:	77 28                	ja     801bf4 <__udivdi3+0x7c>
  801bcc:	0f bd fe             	bsr    %esi,%edi
  801bcf:	83 f7 1f             	xor    $0x1f,%edi
  801bd2:	75 40                	jne    801c14 <__udivdi3+0x9c>
  801bd4:	39 ce                	cmp    %ecx,%esi
  801bd6:	72 0a                	jb     801be2 <__udivdi3+0x6a>
  801bd8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bdc:	0f 87 9e 00 00 00    	ja     801c80 <__udivdi3+0x108>
  801be2:	b8 01 00 00 00       	mov    $0x1,%eax
  801be7:	89 fa                	mov    %edi,%edx
  801be9:	83 c4 1c             	add    $0x1c,%esp
  801bec:	5b                   	pop    %ebx
  801bed:	5e                   	pop    %esi
  801bee:	5f                   	pop    %edi
  801bef:	5d                   	pop    %ebp
  801bf0:	c3                   	ret    
  801bf1:	8d 76 00             	lea    0x0(%esi),%esi
  801bf4:	31 ff                	xor    %edi,%edi
  801bf6:	31 c0                	xor    %eax,%eax
  801bf8:	89 fa                	mov    %edi,%edx
  801bfa:	83 c4 1c             	add    $0x1c,%esp
  801bfd:	5b                   	pop    %ebx
  801bfe:	5e                   	pop    %esi
  801bff:	5f                   	pop    %edi
  801c00:	5d                   	pop    %ebp
  801c01:	c3                   	ret    
  801c02:	66 90                	xchg   %ax,%ax
  801c04:	89 d8                	mov    %ebx,%eax
  801c06:	f7 f7                	div    %edi
  801c08:	31 ff                	xor    %edi,%edi
  801c0a:	89 fa                	mov    %edi,%edx
  801c0c:	83 c4 1c             	add    $0x1c,%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5f                   	pop    %edi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    
  801c14:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c19:	89 eb                	mov    %ebp,%ebx
  801c1b:	29 fb                	sub    %edi,%ebx
  801c1d:	89 f9                	mov    %edi,%ecx
  801c1f:	d3 e6                	shl    %cl,%esi
  801c21:	89 c5                	mov    %eax,%ebp
  801c23:	88 d9                	mov    %bl,%cl
  801c25:	d3 ed                	shr    %cl,%ebp
  801c27:	89 e9                	mov    %ebp,%ecx
  801c29:	09 f1                	or     %esi,%ecx
  801c2b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c2f:	89 f9                	mov    %edi,%ecx
  801c31:	d3 e0                	shl    %cl,%eax
  801c33:	89 c5                	mov    %eax,%ebp
  801c35:	89 d6                	mov    %edx,%esi
  801c37:	88 d9                	mov    %bl,%cl
  801c39:	d3 ee                	shr    %cl,%esi
  801c3b:	89 f9                	mov    %edi,%ecx
  801c3d:	d3 e2                	shl    %cl,%edx
  801c3f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c43:	88 d9                	mov    %bl,%cl
  801c45:	d3 e8                	shr    %cl,%eax
  801c47:	09 c2                	or     %eax,%edx
  801c49:	89 d0                	mov    %edx,%eax
  801c4b:	89 f2                	mov    %esi,%edx
  801c4d:	f7 74 24 0c          	divl   0xc(%esp)
  801c51:	89 d6                	mov    %edx,%esi
  801c53:	89 c3                	mov    %eax,%ebx
  801c55:	f7 e5                	mul    %ebp
  801c57:	39 d6                	cmp    %edx,%esi
  801c59:	72 19                	jb     801c74 <__udivdi3+0xfc>
  801c5b:	74 0b                	je     801c68 <__udivdi3+0xf0>
  801c5d:	89 d8                	mov    %ebx,%eax
  801c5f:	31 ff                	xor    %edi,%edi
  801c61:	e9 58 ff ff ff       	jmp    801bbe <__udivdi3+0x46>
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c6c:	89 f9                	mov    %edi,%ecx
  801c6e:	d3 e2                	shl    %cl,%edx
  801c70:	39 c2                	cmp    %eax,%edx
  801c72:	73 e9                	jae    801c5d <__udivdi3+0xe5>
  801c74:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c77:	31 ff                	xor    %edi,%edi
  801c79:	e9 40 ff ff ff       	jmp    801bbe <__udivdi3+0x46>
  801c7e:	66 90                	xchg   %ax,%ax
  801c80:	31 c0                	xor    %eax,%eax
  801c82:	e9 37 ff ff ff       	jmp    801bbe <__udivdi3+0x46>
  801c87:	90                   	nop

00801c88 <__umoddi3>:
  801c88:	55                   	push   %ebp
  801c89:	57                   	push   %edi
  801c8a:	56                   	push   %esi
  801c8b:	53                   	push   %ebx
  801c8c:	83 ec 1c             	sub    $0x1c,%esp
  801c8f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c93:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ca3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ca7:	89 f3                	mov    %esi,%ebx
  801ca9:	89 fa                	mov    %edi,%edx
  801cab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801caf:	89 34 24             	mov    %esi,(%esp)
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	75 1a                	jne    801cd0 <__umoddi3+0x48>
  801cb6:	39 f7                	cmp    %esi,%edi
  801cb8:	0f 86 a2 00 00 00    	jbe    801d60 <__umoddi3+0xd8>
  801cbe:	89 c8                	mov    %ecx,%eax
  801cc0:	89 f2                	mov    %esi,%edx
  801cc2:	f7 f7                	div    %edi
  801cc4:	89 d0                	mov    %edx,%eax
  801cc6:	31 d2                	xor    %edx,%edx
  801cc8:	83 c4 1c             	add    $0x1c,%esp
  801ccb:	5b                   	pop    %ebx
  801ccc:	5e                   	pop    %esi
  801ccd:	5f                   	pop    %edi
  801cce:	5d                   	pop    %ebp
  801ccf:	c3                   	ret    
  801cd0:	39 f0                	cmp    %esi,%eax
  801cd2:	0f 87 ac 00 00 00    	ja     801d84 <__umoddi3+0xfc>
  801cd8:	0f bd e8             	bsr    %eax,%ebp
  801cdb:	83 f5 1f             	xor    $0x1f,%ebp
  801cde:	0f 84 ac 00 00 00    	je     801d90 <__umoddi3+0x108>
  801ce4:	bf 20 00 00 00       	mov    $0x20,%edi
  801ce9:	29 ef                	sub    %ebp,%edi
  801ceb:	89 fe                	mov    %edi,%esi
  801ced:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cf1:	89 e9                	mov    %ebp,%ecx
  801cf3:	d3 e0                	shl    %cl,%eax
  801cf5:	89 d7                	mov    %edx,%edi
  801cf7:	89 f1                	mov    %esi,%ecx
  801cf9:	d3 ef                	shr    %cl,%edi
  801cfb:	09 c7                	or     %eax,%edi
  801cfd:	89 e9                	mov    %ebp,%ecx
  801cff:	d3 e2                	shl    %cl,%edx
  801d01:	89 14 24             	mov    %edx,(%esp)
  801d04:	89 d8                	mov    %ebx,%eax
  801d06:	d3 e0                	shl    %cl,%eax
  801d08:	89 c2                	mov    %eax,%edx
  801d0a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0e:	d3 e0                	shl    %cl,%eax
  801d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d14:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d18:	89 f1                	mov    %esi,%ecx
  801d1a:	d3 e8                	shr    %cl,%eax
  801d1c:	09 d0                	or     %edx,%eax
  801d1e:	d3 eb                	shr    %cl,%ebx
  801d20:	89 da                	mov    %ebx,%edx
  801d22:	f7 f7                	div    %edi
  801d24:	89 d3                	mov    %edx,%ebx
  801d26:	f7 24 24             	mull   (%esp)
  801d29:	89 c6                	mov    %eax,%esi
  801d2b:	89 d1                	mov    %edx,%ecx
  801d2d:	39 d3                	cmp    %edx,%ebx
  801d2f:	0f 82 87 00 00 00    	jb     801dbc <__umoddi3+0x134>
  801d35:	0f 84 91 00 00 00    	je     801dcc <__umoddi3+0x144>
  801d3b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d3f:	29 f2                	sub    %esi,%edx
  801d41:	19 cb                	sbb    %ecx,%ebx
  801d43:	89 d8                	mov    %ebx,%eax
  801d45:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d49:	d3 e0                	shl    %cl,%eax
  801d4b:	89 e9                	mov    %ebp,%ecx
  801d4d:	d3 ea                	shr    %cl,%edx
  801d4f:	09 d0                	or     %edx,%eax
  801d51:	89 e9                	mov    %ebp,%ecx
  801d53:	d3 eb                	shr    %cl,%ebx
  801d55:	89 da                	mov    %ebx,%edx
  801d57:	83 c4 1c             	add    $0x1c,%esp
  801d5a:	5b                   	pop    %ebx
  801d5b:	5e                   	pop    %esi
  801d5c:	5f                   	pop    %edi
  801d5d:	5d                   	pop    %ebp
  801d5e:	c3                   	ret    
  801d5f:	90                   	nop
  801d60:	89 fd                	mov    %edi,%ebp
  801d62:	85 ff                	test   %edi,%edi
  801d64:	75 0b                	jne    801d71 <__umoddi3+0xe9>
  801d66:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6b:	31 d2                	xor    %edx,%edx
  801d6d:	f7 f7                	div    %edi
  801d6f:	89 c5                	mov    %eax,%ebp
  801d71:	89 f0                	mov    %esi,%eax
  801d73:	31 d2                	xor    %edx,%edx
  801d75:	f7 f5                	div    %ebp
  801d77:	89 c8                	mov    %ecx,%eax
  801d79:	f7 f5                	div    %ebp
  801d7b:	89 d0                	mov    %edx,%eax
  801d7d:	e9 44 ff ff ff       	jmp    801cc6 <__umoddi3+0x3e>
  801d82:	66 90                	xchg   %ax,%ax
  801d84:	89 c8                	mov    %ecx,%eax
  801d86:	89 f2                	mov    %esi,%edx
  801d88:	83 c4 1c             	add    $0x1c,%esp
  801d8b:	5b                   	pop    %ebx
  801d8c:	5e                   	pop    %esi
  801d8d:	5f                   	pop    %edi
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    
  801d90:	3b 04 24             	cmp    (%esp),%eax
  801d93:	72 06                	jb     801d9b <__umoddi3+0x113>
  801d95:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d99:	77 0f                	ja     801daa <__umoddi3+0x122>
  801d9b:	89 f2                	mov    %esi,%edx
  801d9d:	29 f9                	sub    %edi,%ecx
  801d9f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801da3:	89 14 24             	mov    %edx,(%esp)
  801da6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801daa:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dae:	8b 14 24             	mov    (%esp),%edx
  801db1:	83 c4 1c             	add    $0x1c,%esp
  801db4:	5b                   	pop    %ebx
  801db5:	5e                   	pop    %esi
  801db6:	5f                   	pop    %edi
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    
  801db9:	8d 76 00             	lea    0x0(%esi),%esi
  801dbc:	2b 04 24             	sub    (%esp),%eax
  801dbf:	19 fa                	sbb    %edi,%edx
  801dc1:	89 d1                	mov    %edx,%ecx
  801dc3:	89 c6                	mov    %eax,%esi
  801dc5:	e9 71 ff ff ff       	jmp    801d3b <__umoddi3+0xb3>
  801dca:	66 90                	xchg   %ax,%ax
  801dcc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dd0:	72 ea                	jb     801dbc <__umoddi3+0x134>
  801dd2:	89 d9                	mov    %ebx,%ecx
  801dd4:	e9 62 ff ff ff       	jmp    801d3b <__umoddi3+0xb3>
