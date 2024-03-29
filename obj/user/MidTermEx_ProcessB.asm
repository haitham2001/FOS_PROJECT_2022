
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 35 01 00 00       	call   80016b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 d6 19 00 00       	call   801a19 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 e0 37 80 00       	push   $0x8037e0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 a6 14 00 00       	call   8014fc <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e2 37 80 00       	push   $0x8037e2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 90 14 00 00       	call   8014fc <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e9 37 80 00       	push   $0x8037e9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 7a 14 00 00       	call   8014fc <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 13                	jne    8000a5 <_main+0x6d>
	{
		sys_waitSemaphore(parentenvID, "T") ;
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	68 f7 37 80 00       	push   $0x8037f7
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 18 18 00 00       	call   8018ba <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 9b 19 00 00       	call   801a4c <sys_get_virtual_time>
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000b7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	f7 f1                	div    %ecx
  8000c3:	89 d0                	mov    %edx,%eax
  8000c5:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 09 32 00 00       	call   8032e2 <env_sleep>
  8000d9:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000df:	8b 00                	mov    (%eax),%eax
  8000e1:	40                   	inc    %eax
  8000e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	e8 5b 19 00 00       	call   801a4c <sys_get_virtual_time>
  8000f1:	83 c4 0c             	add    $0xc,%esp
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800101:	f7 f1                	div    %ecx
  800103:	89 d0                	mov    %edx,%eax
  800105:	05 d0 07 00 00       	add    $0x7d0,%eax
  80010a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 c9 31 00 00       	call   8032e2 <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80011c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80011f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800122:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800124:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	e8 1c 19 00 00       	call   801a4c <sys_get_virtual_time>
  800130:	83 c4 0c             	add    $0xc,%esp
  800133:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800136:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	f7 f1                	div    %ecx
  800142:	89 d0                	mov    %edx,%eax
  800144:	05 d0 07 00 00       	add    $0x7d0,%eax
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	50                   	push   %eax
  800153:	e8 8a 31 00 00       	call   8032e2 <env_sleep>
  800158:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	8d 50 01             	lea    0x1(%eax),%edx
  800163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800166:	89 10                	mov    %edx,(%eax)

}
  800168:	90                   	nop
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800171:	e8 8a 18 00 00       	call   801a00 <sys_getenvindex>
  800176:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017c:	89 d0                	mov    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	01 d0                	add    %edx,%eax
  800183:	01 c0                	add    %eax,%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018e:	01 d0                	add    %edx,%eax
  800190:	c1 e0 04             	shl    $0x4,%eax
  800193:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800198:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019d:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 0f                	je     8001bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001bf:	7e 0a                	jle    8001cb <libmain+0x60>
		binaryname = argv[0];
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	8b 00                	mov    (%eax),%eax
  8001c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	ff 75 0c             	pushl  0xc(%ebp)
  8001d1:	ff 75 08             	pushl  0x8(%ebp)
  8001d4:	e8 5f fe ff ff       	call   800038 <_main>
  8001d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dc:	e8 2c 16 00 00       	call   80180d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 14 38 80 00       	push   $0x803814
  8001e9:	e8 8d 01 00 00       	call   80037b <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	52                   	push   %edx
  80020b:	50                   	push   %eax
  80020c:	68 3c 38 80 00       	push   $0x80383c
  800211:	e8 65 01 00 00       	call   80037b <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800219:	a1 20 40 80 00       	mov    0x804020,%eax
  80021e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023a:	51                   	push   %ecx
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 64 38 80 00       	push   $0x803864
  800242:	e8 34 01 00 00       	call   80037b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 40 80 00       	mov    0x804020,%eax
  80024f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 bc 38 80 00       	push   $0x8038bc
  80025e:	e8 18 01 00 00       	call   80037b <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 14 38 80 00       	push   $0x803814
  80026e:	e8 08 01 00 00       	call   80037b <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800276:	e8 ac 15 00 00       	call   801827 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027b:	e8 19 00 00 00       	call   800299 <exit>
}
  800280:	90                   	nop
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	6a 00                	push   $0x0
  80028e:	e8 39 17 00 00       	call   8019cc <sys_destroy_env>
  800293:	83 c4 10             	add    $0x10,%esp
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <exit>:

void
exit(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029f:	e8 8e 17 00 00       	call   801a32 <sys_exit_env>
}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b0:	8b 00                	mov    (%eax),%eax
  8002b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b8:	89 0a                	mov    %ecx,(%edx)
  8002ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bd:	88 d1                	mov    %dl,%cl
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 00                	mov    (%eax),%eax
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	75 2c                	jne    8002fe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d2:	a0 24 40 80 00       	mov    0x804024,%al
  8002d7:	0f b6 c0             	movzbl %al,%eax
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	8b 12                	mov    (%edx),%edx
  8002df:	89 d1                	mov    %edx,%ecx
  8002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e4:	83 c2 08             	add    $0x8,%edx
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	50                   	push   %eax
  8002eb:	51                   	push   %ecx
  8002ec:	52                   	push   %edx
  8002ed:	e8 6d 13 00 00       	call   80165f <sys_cputs>
  8002f2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 40 04             	mov    0x4(%eax),%eax
  800304:	8d 50 01             	lea    0x1(%eax),%edx
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030d:	90                   	nop
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800319:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800320:	00 00 00 
	b.cnt = 0;
  800323:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032d:	ff 75 0c             	pushl  0xc(%ebp)
  800330:	ff 75 08             	pushl  0x8(%ebp)
  800333:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800339:	50                   	push   %eax
  80033a:	68 a7 02 80 00       	push   $0x8002a7
  80033f:	e8 11 02 00 00       	call   800555 <vprintfmt>
  800344:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800347:	a0 24 40 80 00       	mov    0x804024,%al
  80034c:	0f b6 c0             	movzbl %al,%eax
  80034f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	50                   	push   %eax
  800359:	52                   	push   %edx
  80035a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800360:	83 c0 08             	add    $0x8,%eax
  800363:	50                   	push   %eax
  800364:	e8 f6 12 00 00       	call   80165f <sys_cputs>
  800369:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800373:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <cprintf>:

int cprintf(const char *fmt, ...) {
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800381:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800388:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	ff 75 f4             	pushl  -0xc(%ebp)
  800397:	50                   	push   %eax
  800398:	e8 73 ff ff ff       	call   800310 <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
  8003a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003ae:	e8 5a 14 00 00       	call   80180d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	50                   	push   %eax
  8003c3:	e8 48 ff ff ff       	call   800310 <vcprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003ce:	e8 54 14 00 00       	call   801827 <sys_enable_interrupt>
	return cnt;
  8003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	53                   	push   %ebx
  8003dc:	83 ec 14             	sub    $0x14,%esp
  8003df:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f6:	77 55                	ja     80044d <printnum+0x75>
  8003f8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fb:	72 05                	jb     800402 <printnum+0x2a>
  8003fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800400:	77 4b                	ja     80044d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800402:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800405:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800408:	8b 45 18             	mov    0x18(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	ff 75 f4             	pushl  -0xc(%ebp)
  800415:	ff 75 f0             	pushl  -0x10(%ebp)
  800418:	e8 5b 31 00 00       	call   803578 <__udivdi3>
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	ff 75 20             	pushl  0x20(%ebp)
  800426:	53                   	push   %ebx
  800427:	ff 75 18             	pushl  0x18(%ebp)
  80042a:	52                   	push   %edx
  80042b:	50                   	push   %eax
  80042c:	ff 75 0c             	pushl  0xc(%ebp)
  80042f:	ff 75 08             	pushl  0x8(%ebp)
  800432:	e8 a1 ff ff ff       	call   8003d8 <printnum>
  800437:	83 c4 20             	add    $0x20,%esp
  80043a:	eb 1a                	jmp    800456 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 20             	pushl  0x20(%ebp)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	ff d0                	call   *%eax
  80044a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044d:	ff 4d 1c             	decl   0x1c(%ebp)
  800450:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800454:	7f e6                	jg     80043c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800456:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800459:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800464:	53                   	push   %ebx
  800465:	51                   	push   %ecx
  800466:	52                   	push   %edx
  800467:	50                   	push   %eax
  800468:	e8 1b 32 00 00       	call   803688 <__umoddi3>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	05 f4 3a 80 00       	add    $0x803af4,%eax
  800475:	8a 00                	mov    (%eax),%al
  800477:	0f be c0             	movsbl %al,%eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 0c             	pushl  0xc(%ebp)
  800480:	50                   	push   %eax
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	ff d0                	call   *%eax
  800486:	83 c4 10             	add    $0x10,%esp
}
  800489:	90                   	nop
  80048a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800496:	7e 1c                	jle    8004b4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 08             	lea    0x8(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 08             	sub    $0x8,%eax
  8004ad:	8b 50 04             	mov    0x4(%eax),%edx
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	eb 40                	jmp    8004f4 <getuint+0x65>
	else if (lflag)
  8004b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b8:	74 1e                	je     8004d8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	8d 50 04             	lea    0x4(%eax),%edx
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	89 10                	mov    %edx,(%eax)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	83 e8 04             	sub    $0x4,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	eb 1c                	jmp    8004f4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 04             	sub    $0x4,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f4:	5d                   	pop    %ebp
  8004f5:	c3                   	ret    

008004f6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fd:	7e 1c                	jle    80051b <getint+0x25>
		return va_arg(*ap, long long);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 50 08             	lea    0x8(%eax),%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	83 e8 08             	sub    $0x8,%eax
  800514:	8b 50 04             	mov    0x4(%eax),%edx
  800517:	8b 00                	mov    (%eax),%eax
  800519:	eb 38                	jmp    800553 <getint+0x5d>
	else if (lflag)
  80051b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80051f:	74 1a                	je     80053b <getint+0x45>
		return va_arg(*ap, long);
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	8d 50 04             	lea    0x4(%eax),%edx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	83 e8 04             	sub    $0x4,%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	99                   	cltd   
  800539:	eb 18                	jmp    800553 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 50 04             	lea    0x4(%eax),%edx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 10                	mov    %edx,(%eax)
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	83 e8 04             	sub    $0x4,%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	99                   	cltd   
}
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	56                   	push   %esi
  800559:	53                   	push   %ebx
  80055a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055d:	eb 17                	jmp    800576 <vprintfmt+0x21>
			if (ch == '\0')
  80055f:	85 db                	test   %ebx,%ebx
  800561:	0f 84 af 03 00 00    	je     800916 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 0c             	pushl  0xc(%ebp)
  80056d:	53                   	push   %ebx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	ff d0                	call   *%eax
  800573:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	83 fb 25             	cmp    $0x25,%ebx
  800587:	75 d6                	jne    80055f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800589:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800594:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ac:	8d 50 01             	lea    0x1(%eax),%edx
  8005af:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b2:	8a 00                	mov    (%eax),%al
  8005b4:	0f b6 d8             	movzbl %al,%ebx
  8005b7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005ba:	83 f8 55             	cmp    $0x55,%eax
  8005bd:	0f 87 2b 03 00 00    	ja     8008ee <vprintfmt+0x399>
  8005c3:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
  8005ca:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d0:	eb d7                	jmp    8005a9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d6:	eb d1                	jmp    8005a9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e2:	89 d0                	mov    %edx,%eax
  8005e4:	c1 e0 02             	shl    $0x2,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	01 c0                	add    %eax,%eax
  8005eb:	01 d8                	add    %ebx,%eax
  8005ed:	83 e8 30             	sub    $0x30,%eax
  8005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	8a 00                	mov    (%eax),%al
  8005f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8005fe:	7e 3e                	jle    80063e <vprintfmt+0xe9>
  800600:	83 fb 39             	cmp    $0x39,%ebx
  800603:	7f 39                	jg     80063e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800605:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800608:	eb d5                	jmp    8005df <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 c0 04             	add    $0x4,%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 e8 04             	sub    $0x4,%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061e:	eb 1f                	jmp    80063f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800620:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800624:	79 83                	jns    8005a9 <vprintfmt+0x54>
				width = 0;
  800626:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062d:	e9 77 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800632:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800639:	e9 6b ff ff ff       	jmp    8005a9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80063f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800643:	0f 89 60 ff ff ff    	jns    8005a9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800656:	e9 4e ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065e:	e9 46 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	83 c0 04             	add    $0x4,%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	83 e8 04             	sub    $0x4,%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	50                   	push   %eax
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	ff d0                	call   *%eax
  800680:	83 c4 10             	add    $0x10,%esp
			break;
  800683:	e9 89 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800699:	85 db                	test   %ebx,%ebx
  80069b:	79 02                	jns    80069f <vprintfmt+0x14a>
				err = -err;
  80069d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80069f:	83 fb 64             	cmp    $0x64,%ebx
  8006a2:	7f 0b                	jg     8006af <vprintfmt+0x15a>
  8006a4:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  8006ab:	85 f6                	test   %esi,%esi
  8006ad:	75 19                	jne    8006c8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006af:	53                   	push   %ebx
  8006b0:	68 05 3b 80 00       	push   $0x803b05
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	e8 5e 02 00 00       	call   80091e <printfmt>
  8006c0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c3:	e9 49 02 00 00       	jmp    800911 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c8:	56                   	push   %esi
  8006c9:	68 0e 3b 80 00       	push   $0x803b0e
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	e8 45 02 00 00       	call   80091e <printfmt>
  8006d9:	83 c4 10             	add    $0x10,%esp
			break;
  8006dc:	e9 30 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	83 c0 04             	add    $0x4,%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 30                	mov    (%eax),%esi
  8006f2:	85 f6                	test   %esi,%esi
  8006f4:	75 05                	jne    8006fb <vprintfmt+0x1a6>
				p = "(null)";
  8006f6:	be 11 3b 80 00       	mov    $0x803b11,%esi
			if (width > 0 && padc != '-')
  8006fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ff:	7e 6d                	jle    80076e <vprintfmt+0x219>
  800701:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800705:	74 67                	je     80076e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	50                   	push   %eax
  80070e:	56                   	push   %esi
  80070f:	e8 0c 03 00 00       	call   800a20 <strnlen>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071a:	eb 16                	jmp    800732 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	50                   	push   %eax
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80072f:	ff 4d e4             	decl   -0x1c(%ebp)
  800732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800736:	7f e4                	jg     80071c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	eb 34                	jmp    80076e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073e:	74 1c                	je     80075c <vprintfmt+0x207>
  800740:	83 fb 1f             	cmp    $0x1f,%ebx
  800743:	7e 05                	jle    80074a <vprintfmt+0x1f5>
  800745:	83 fb 7e             	cmp    $0x7e,%ebx
  800748:	7e 12                	jle    80075c <vprintfmt+0x207>
					putch('?', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	6a 3f                	push   $0x3f
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	eb 0f                	jmp    80076b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	53                   	push   %ebx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076b:	ff 4d e4             	decl   -0x1c(%ebp)
  80076e:	89 f0                	mov    %esi,%eax
  800770:	8d 70 01             	lea    0x1(%eax),%esi
  800773:	8a 00                	mov    (%eax),%al
  800775:	0f be d8             	movsbl %al,%ebx
  800778:	85 db                	test   %ebx,%ebx
  80077a:	74 24                	je     8007a0 <vprintfmt+0x24b>
  80077c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800780:	78 b8                	js     80073a <vprintfmt+0x1e5>
  800782:	ff 4d e0             	decl   -0x20(%ebp)
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	79 af                	jns    80073a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078b:	eb 13                	jmp    8007a0 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 20                	push   $0x20
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079d:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a4:	7f e7                	jg     80078d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a6:	e9 66 01 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	e8 3c fd ff ff       	call   8004f6 <getint>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	79 23                	jns    8007f0 <vprintfmt+0x29b>
				putch('-', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 2d                	push   $0x2d
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e3:	f7 d8                	neg    %eax
  8007e5:	83 d2 00             	adc    $0x0,%edx
  8007e8:	f7 da                	neg    %edx
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f7:	e9 bc 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 e8             	pushl  -0x18(%ebp)
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
  800805:	50                   	push   %eax
  800806:	e8 84 fc ff ff       	call   80048f <getuint>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800811:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800814:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081b:	e9 98 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 58                	push   $0x58
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	6a 58                	push   $0x58
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	ff d0                	call   *%eax
  80083d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	6a 58                	push   $0x58
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			break;
  800850:	e9 bc 00 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 30                	push   $0x30
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	6a 78                	push   $0x78
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800886:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800890:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800897:	eb 1f                	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 e8             	pushl  -0x18(%ebp)
  80089f:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a2:	50                   	push   %eax
  8008a3:	e8 e7 fb ff ff       	call   80048f <getuint>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	52                   	push   %edx
  8008c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 00 fb ff ff       	call   8003d8 <printnum>
  8008d8:	83 c4 20             	add    $0x20,%esp
			break;
  8008db:	eb 34                	jmp    800911 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	53                   	push   %ebx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
			break;
  8008ec:	eb 23                	jmp    800911 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	6a 25                	push   $0x25
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fe:	ff 4d 10             	decl   0x10(%ebp)
  800901:	eb 03                	jmp    800906 <vprintfmt+0x3b1>
  800903:	ff 4d 10             	decl   0x10(%ebp)
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	48                   	dec    %eax
  80090a:	8a 00                	mov    (%eax),%al
  80090c:	3c 25                	cmp    $0x25,%al
  80090e:	75 f3                	jne    800903 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800910:	90                   	nop
		}
	}
  800911:	e9 47 fc ff ff       	jmp    80055d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800916:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800917:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800924:	8d 45 10             	lea    0x10(%ebp),%eax
  800927:	83 c0 04             	add    $0x4,%eax
  80092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	ff 75 f4             	pushl  -0xc(%ebp)
  800933:	50                   	push   %eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	e8 16 fc ff ff       	call   800555 <vprintfmt>
  80093f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800942:	90                   	nop
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	8b 40 08             	mov    0x8(%eax),%eax
  80094e:	8d 50 01             	lea    0x1(%eax),%edx
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	8b 10                	mov    (%eax),%edx
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095f:	8b 40 04             	mov    0x4(%eax),%eax
  800962:	39 c2                	cmp    %eax,%edx
  800964:	73 12                	jae    800978 <sprintputch+0x33>
		*b->buf++ = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 10                	mov    %dl,(%eax)
}
  800978:	90                   	nop
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	01 d0                	add    %edx,%eax
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a0:	74 06                	je     8009a8 <vsnprintf+0x2d>
  8009a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a6:	7f 07                	jg     8009af <vsnprintf+0x34>
		return -E_INVAL;
  8009a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ad:	eb 20                	jmp    8009cf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009af:	ff 75 14             	pushl  0x14(%ebp)
  8009b2:	ff 75 10             	pushl  0x10(%ebp)
  8009b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b8:	50                   	push   %eax
  8009b9:	68 45 09 80 00       	push   $0x800945
  8009be:	e8 92 fb ff ff       	call   800555 <vprintfmt>
  8009c3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8009da:	83 c0 04             	add    $0x4,%eax
  8009dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	e8 89 ff ff ff       	call   80097b <vsnprintf>
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0a:	eb 06                	jmp    800a12 <strlen+0x15>
		n++;
  800a0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0f:	ff 45 08             	incl   0x8(%ebp)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	84 c0                	test   %al,%al
  800a19:	75 f1                	jne    800a0c <strlen+0xf>
		n++;
	return n;
  800a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2d:	eb 09                	jmp    800a38 <strnlen+0x18>
		n++;
  800a2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a32:	ff 45 08             	incl   0x8(%ebp)
  800a35:	ff 4d 0c             	decl   0xc(%ebp)
  800a38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3c:	74 09                	je     800a47 <strnlen+0x27>
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8a 00                	mov    (%eax),%al
  800a43:	84 c0                	test   %al,%al
  800a45:	75 e8                	jne    800a2f <strnlen+0xf>
		n++;
	return n;
  800a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a58:	90                   	nop
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8d 50 01             	lea    0x1(%eax),%edx
  800a5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6b:	8a 12                	mov    (%edx),%dl
  800a6d:	88 10                	mov    %dl,(%eax)
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	75 e4                	jne    800a59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8d:	eb 1f                	jmp    800aae <strncpy+0x34>
		*dst++ = *src;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	89 55 08             	mov    %edx,0x8(%ebp)
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8a 12                	mov    (%edx),%dl
  800a9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa2:	8a 00                	mov    (%eax),%al
  800aa4:	84 c0                	test   %al,%al
  800aa6:	74 03                	je     800aab <strncpy+0x31>
			src++;
  800aa8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aab:	ff 45 fc             	incl   -0x4(%ebp)
  800aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab4:	72 d9                	jb     800a8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acb:	74 30                	je     800afd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800acd:	eb 16                	jmp    800ae5 <strlcpy+0x2a>
			*dst++ = *src++;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8d 50 01             	lea    0x1(%eax),%edx
  800ad5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ade:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae1:	8a 12                	mov    (%edx),%dl
  800ae3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae5:	ff 4d 10             	decl   0x10(%ebp)
  800ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aec:	74 09                	je     800af7 <strlcpy+0x3c>
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	75 d8                	jne    800acf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afd:	8b 55 08             	mov    0x8(%ebp),%edx
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b03:	29 c2                	sub    %eax,%edx
  800b05:	89 d0                	mov    %edx,%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0c:	eb 06                	jmp    800b14 <strcmp+0xb>
		p++, q++;
  800b0e:	ff 45 08             	incl   0x8(%ebp)
  800b11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	74 0e                	je     800b2b <strcmp+0x22>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 10                	mov    (%eax),%dl
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	38 c2                	cmp    %al,%dl
  800b29:	74 e3                	je     800b0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f b6 d0             	movzbl %al,%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	0f b6 c0             	movzbl %al,%eax
  800b3b:	29 c2                	sub    %eax,%edx
  800b3d:	89 d0                	mov    %edx,%eax
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b44:	eb 09                	jmp    800b4f <strncmp+0xe>
		n--, p++, q++;
  800b46:	ff 4d 10             	decl   0x10(%ebp)
  800b49:	ff 45 08             	incl   0x8(%ebp)
  800b4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b53:	74 17                	je     800b6c <strncmp+0x2b>
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	84 c0                	test   %al,%al
  800b5c:	74 0e                	je     800b6c <strncmp+0x2b>
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8a 10                	mov    (%eax),%dl
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	38 c2                	cmp    %al,%dl
  800b6a:	74 da                	je     800b46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b70:	75 07                	jne    800b79 <strncmp+0x38>
		return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	eb 14                	jmp    800b8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d0             	movzbl %al,%edx
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	29 c2                	sub    %eax,%edx
  800b8b:	89 d0                	mov    %edx,%eax
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 04             	sub    $0x4,%esp
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9b:	eb 12                	jmp    800baf <strchr+0x20>
		if (*s == c)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba5:	75 05                	jne    800bac <strchr+0x1d>
			return (char *) s;
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	eb 11                	jmp    800bbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bac:	ff 45 08             	incl   0x8(%ebp)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	84 c0                	test   %al,%al
  800bb6:	75 e5                	jne    800b9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcb:	eb 0d                	jmp    800bda <strfind+0x1b>
		if (*s == c)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd5:	74 0e                	je     800be5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 ea                	jne    800bcd <strfind+0xe>
  800be3:	eb 01                	jmp    800be6 <strfind+0x27>
		if (*s == c)
			break;
  800be5:	90                   	nop
	return (char *) s;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfd:	eb 0e                	jmp    800c0d <memset+0x22>
		*p++ = c;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0d:	ff 4d f8             	decl   -0x8(%ebp)
  800c10:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c14:	79 e9                	jns    800bff <memset+0x14>
		*p++ = c;

	return v;
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2d:	eb 16                	jmp    800c45 <memcpy+0x2a>
		*d++ = *s++;
  800c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	75 dd                	jne    800c2f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c6f:	73 50                	jae    800cc1 <memmove+0x6a>
  800c71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7c:	76 43                	jbe    800cc1 <memmove+0x6a>
		s += n;
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8a:	eb 10                	jmp    800c9c <memmove+0x45>
			*--d = *--s;
  800c8c:	ff 4d f8             	decl   -0x8(%ebp)
  800c8f:	ff 4d fc             	decl   -0x4(%ebp)
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c95:	8a 10                	mov    (%eax),%dl
  800c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	75 e3                	jne    800c8c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca9:	eb 23                	jmp    800cce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	75 dd                	jne    800cab <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce5:	eb 2a                	jmp    800d11 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cea:	8a 10                	mov    (%eax),%dl
  800cec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	38 c2                	cmp    %al,%dl
  800cf3:	74 16                	je     800d0b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d0             	movzbl %al,%edx
  800cfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f b6 c0             	movzbl %al,%eax
  800d05:	29 c2                	sub    %eax,%edx
  800d07:	89 d0                	mov    %edx,%eax
  800d09:	eb 18                	jmp    800d23 <memcmp+0x50>
		s1++, s2++;
  800d0b:	ff 45 fc             	incl   -0x4(%ebp)
  800d0e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d17:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	75 c9                	jne    800ce7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d36:	eb 15                	jmp    800d4d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f b6 d0             	movzbl %al,%edx
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	0f b6 c0             	movzbl %al,%eax
  800d46:	39 c2                	cmp    %eax,%edx
  800d48:	74 0d                	je     800d57 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d53:	72 e3                	jb     800d38 <memfind+0x13>
  800d55:	eb 01                	jmp    800d58 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d57:	90                   	nop
	return (void *) s;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d71:	eb 03                	jmp    800d76 <strtol+0x19>
		s++;
  800d73:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3c 20                	cmp    $0x20,%al
  800d7d:	74 f4                	je     800d73 <strtol+0x16>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 09                	cmp    $0x9,%al
  800d86:	74 eb                	je     800d73 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 2b                	cmp    $0x2b,%al
  800d8f:	75 05                	jne    800d96 <strtol+0x39>
		s++;
  800d91:	ff 45 08             	incl   0x8(%ebp)
  800d94:	eb 13                	jmp    800da9 <strtol+0x4c>
	else if (*s == '-')
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 2d                	cmp    $0x2d,%al
  800d9d:	75 0a                	jne    800da9 <strtol+0x4c>
		s++, neg = 1;
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dad:	74 06                	je     800db5 <strtol+0x58>
  800daf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db3:	75 20                	jne    800dd5 <strtol+0x78>
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 30                	cmp    $0x30,%al
  800dbc:	75 17                	jne    800dd5 <strtol+0x78>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	40                   	inc    %eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3c 78                	cmp    $0x78,%al
  800dc6:	75 0d                	jne    800dd5 <strtol+0x78>
		s += 2, base = 16;
  800dc8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd3:	eb 28                	jmp    800dfd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	75 15                	jne    800df0 <strtol+0x93>
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	3c 30                	cmp    $0x30,%al
  800de2:	75 0c                	jne    800df0 <strtol+0x93>
		s++, base = 8;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dee:	eb 0d                	jmp    800dfd <strtol+0xa0>
	else if (base == 0)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	75 07                	jne    800dfd <strtol+0xa0>
		base = 10;
  800df6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	3c 2f                	cmp    $0x2f,%al
  800e04:	7e 19                	jle    800e1f <strtol+0xc2>
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	3c 39                	cmp    $0x39,%al
  800e0d:	7f 10                	jg     800e1f <strtol+0xc2>
			dig = *s - '0';
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f be c0             	movsbl %al,%eax
  800e17:	83 e8 30             	sub    $0x30,%eax
  800e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1d:	eb 42                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 60                	cmp    $0x60,%al
  800e26:	7e 19                	jle    800e41 <strtol+0xe4>
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 7a                	cmp    $0x7a,%al
  800e2f:	7f 10                	jg     800e41 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f be c0             	movsbl %al,%eax
  800e39:	83 e8 57             	sub    $0x57,%eax
  800e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e3f:	eb 20                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	3c 40                	cmp    $0x40,%al
  800e48:	7e 39                	jle    800e83 <strtol+0x126>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 5a                	cmp    $0x5a,%al
  800e51:	7f 30                	jg     800e83 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	0f be c0             	movsbl %al,%eax
  800e5b:	83 e8 37             	sub    $0x37,%eax
  800e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e67:	7d 19                	jge    800e82 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e73:	89 c2                	mov    %eax,%edx
  800e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7d:	e9 7b ff ff ff       	jmp    800dfd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e82:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e87:	74 08                	je     800e91 <strtol+0x134>
		*endptr = (char *) s;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e95:	74 07                	je     800e9e <strtol+0x141>
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	f7 d8                	neg    %eax
  800e9c:	eb 03                	jmp    800ea1 <strtol+0x144>
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebb:	79 13                	jns    800ed0 <ltostr+0x2d>
	{
		neg = 1;
  800ebd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ecd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed8:	99                   	cltd   
  800ed9:	f7 f9                	idiv   %ecx
  800edb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee7:	89 c2                	mov    %eax,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef1:	83 c2 30             	add    $0x30,%edx
  800ef4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800efe:	f7 e9                	imul   %ecx
  800f00:	c1 fa 02             	sar    $0x2,%edx
  800f03:	89 c8                	mov    %ecx,%eax
  800f05:	c1 f8 1f             	sar    $0x1f,%eax
  800f08:	29 c2                	sub    %eax,%edx
  800f0a:	89 d0                	mov    %edx,%eax
  800f0c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f12:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f17:	f7 e9                	imul   %ecx
  800f19:	c1 fa 02             	sar    $0x2,%edx
  800f1c:	89 c8                	mov    %ecx,%eax
  800f1e:	c1 f8 1f             	sar    $0x1f,%eax
  800f21:	29 c2                	sub    %eax,%edx
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e0 02             	shl    $0x2,%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	01 c0                	add    %eax,%eax
  800f2c:	29 c1                	sub    %eax,%ecx
  800f2e:	89 ca                	mov    %ecx,%edx
  800f30:	85 d2                	test   %edx,%edx
  800f32:	75 9c                	jne    800ed0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	48                   	dec    %eax
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f46:	74 3d                	je     800f85 <ltostr+0xe2>
		start = 1 ;
  800f48:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f4f:	eb 34                	jmp    800f85 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	01 c2                	add    %eax,%edx
  800f66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	01 c8                	add    %ecx,%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	01 c2                	add    %eax,%edx
  800f7a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7d:	88 02                	mov    %al,(%edx)
		start++ ;
  800f7f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f82:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8b:	7c c4                	jl     800f51 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	01 d0                	add    %edx,%eax
  800f95:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa1:	ff 75 08             	pushl  0x8(%ebp)
  800fa4:	e8 54 fa ff ff       	call   8009fd <strlen>
  800fa9:	83 c4 04             	add    $0x4,%esp
  800fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	e8 46 fa ff ff       	call   8009fd <strlen>
  800fb7:	83 c4 04             	add    $0x4,%esp
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcb:	eb 17                	jmp    800fe4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 c2                	add    %eax,%edx
  800fd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	01 c8                	add    %ecx,%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fea:	7c e1                	jl     800fcd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffa:	eb 1f                	jmp    80101b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8d 50 01             	lea    0x1(%eax),%edx
  801002:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801005:	89 c2                	mov    %eax,%edx
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	01 c2                	add    %eax,%edx
  80100c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	01 c8                	add    %ecx,%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801018:	ff 45 f8             	incl   -0x8(%ebp)
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801021:	7c d9                	jl     800ffc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801023:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	c6 00 00             	movb   $0x0,(%eax)
}
  80102e:	90                   	nop
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	8b 00                	mov    (%eax),%eax
  801042:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801054:	eb 0c                	jmp    801062 <strsplit+0x31>
			*string++ = 0;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 08             	mov    %edx,0x8(%ebp)
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	84 c0                	test   %al,%al
  801069:	74 18                	je     801083 <strsplit+0x52>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f be c0             	movsbl %al,%eax
  801073:	50                   	push   %eax
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	e8 13 fb ff ff       	call   800b8f <strchr>
  80107c:	83 c4 08             	add    $0x8,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 d3                	jne    801056 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	74 5a                	je     8010e6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	83 f8 0f             	cmp    $0xf,%eax
  801094:	75 07                	jne    80109d <strsplit+0x6c>
		{
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 66                	jmp    801103 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a5:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a8:	89 0a                	mov    %ecx,(%edx)
  8010aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 c2                	add    %eax,%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bb:	eb 03                	jmp    8010c0 <strsplit+0x8f>
			string++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 8b                	je     801054 <strsplit+0x23>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f be c0             	movsbl %al,%eax
  8010d1:	50                   	push   %eax
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	e8 b5 fa ff ff       	call   800b8f <strchr>
  8010da:	83 c4 08             	add    $0x8,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 dc                	je     8010bd <strsplit+0x8c>
			string++;
	}
  8010e1:	e9 6e ff ff ff       	jmp    801054 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110b:	a1 04 40 80 00       	mov    0x804004,%eax
  801110:	85 c0                	test   %eax,%eax
  801112:	74 1f                	je     801133 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801114:	e8 1d 00 00 00       	call   801136 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	68 70 3c 80 00       	push   $0x803c70
  801121:	e8 55 f2 ff ff       	call   80037b <cprintf>
  801126:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801129:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801130:	00 00 00 
	}
}
  801133:	90                   	nop
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80113c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801143:	00 00 00 
  801146:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80114d:	00 00 00 
  801150:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801157:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80115a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801161:	00 00 00 
  801164:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80116b:	00 00 00 
  80116e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801175:	00 00 00 
	uint32 arr_size = 0;
  801178:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80117f:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801189:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80118e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801193:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801198:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80119f:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8011a2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8011a9:	a1 20 41 80 00       	mov    0x804120,%eax
  8011ae:	c1 e0 04             	shl    $0x4,%eax
  8011b1:	89 c2                	mov    %eax,%edx
  8011b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	48                   	dec    %eax
  8011b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8011bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c4:	f7 75 ec             	divl   -0x14(%ebp)
  8011c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011ca:	29 d0                	sub    %edx,%eax
  8011cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8011cf:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8011d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011e3:	83 ec 04             	sub    $0x4,%esp
  8011e6:	6a 06                	push   $0x6
  8011e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8011eb:	50                   	push   %eax
  8011ec:	e8 b2 05 00 00       	call   8017a3 <sys_allocate_chunk>
  8011f1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011f4:	a1 20 41 80 00       	mov    0x804120,%eax
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	50                   	push   %eax
  8011fd:	e8 27 0c 00 00       	call   801e29 <initialize_MemBlocksList>
  801202:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801205:	a1 48 41 80 00       	mov    0x804148,%eax
  80120a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  80120d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801210:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801217:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801221:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801225:	75 14                	jne    80123b <initialize_dyn_block_system+0x105>
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	68 95 3c 80 00       	push   $0x803c95
  80122f:	6a 33                	push   $0x33
  801231:	68 b3 3c 80 00       	push   $0x803cb3
  801236:	e8 5b 21 00 00       	call   803396 <_panic>
  80123b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80123e:	8b 00                	mov    (%eax),%eax
  801240:	85 c0                	test   %eax,%eax
  801242:	74 10                	je     801254 <initialize_dyn_block_system+0x11e>
  801244:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80124c:	8b 52 04             	mov    0x4(%edx),%edx
  80124f:	89 50 04             	mov    %edx,0x4(%eax)
  801252:	eb 0b                	jmp    80125f <initialize_dyn_block_system+0x129>
  801254:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801257:	8b 40 04             	mov    0x4(%eax),%eax
  80125a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80125f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801262:	8b 40 04             	mov    0x4(%eax),%eax
  801265:	85 c0                	test   %eax,%eax
  801267:	74 0f                	je     801278 <initialize_dyn_block_system+0x142>
  801269:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126c:	8b 40 04             	mov    0x4(%eax),%eax
  80126f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801272:	8b 12                	mov    (%edx),%edx
  801274:	89 10                	mov    %edx,(%eax)
  801276:	eb 0a                	jmp    801282 <initialize_dyn_block_system+0x14c>
  801278:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80127b:	8b 00                	mov    (%eax),%eax
  80127d:	a3 48 41 80 00       	mov    %eax,0x804148
  801282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80128b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80128e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801295:	a1 54 41 80 00       	mov    0x804154,%eax
  80129a:	48                   	dec    %eax
  80129b:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8012a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012a4:	75 14                	jne    8012ba <initialize_dyn_block_system+0x184>
  8012a6:	83 ec 04             	sub    $0x4,%esp
  8012a9:	68 c0 3c 80 00       	push   $0x803cc0
  8012ae:	6a 34                	push   $0x34
  8012b0:	68 b3 3c 80 00       	push   $0x803cb3
  8012b5:	e8 dc 20 00 00       	call   803396 <_panic>
  8012ba:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8012c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c3:	89 10                	mov    %edx,(%eax)
  8012c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c8:	8b 00                	mov    (%eax),%eax
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	74 0d                	je     8012db <initialize_dyn_block_system+0x1a5>
  8012ce:	a1 38 41 80 00       	mov    0x804138,%eax
  8012d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8012d6:	89 50 04             	mov    %edx,0x4(%eax)
  8012d9:	eb 08                	jmp    8012e3 <initialize_dyn_block_system+0x1ad>
  8012db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012de:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012e6:	a3 38 41 80 00       	mov    %eax,0x804138
  8012eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8012f5:	a1 44 41 80 00       	mov    0x804144,%eax
  8012fa:	40                   	inc    %eax
  8012fb:	a3 44 41 80 00       	mov    %eax,0x804144
}
  801300:	90                   	nop
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801309:	e8 f7 fd ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  80130e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801312:	75 07                	jne    80131b <malloc+0x18>
  801314:	b8 00 00 00 00       	mov    $0x0,%eax
  801319:	eb 61                	jmp    80137c <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  80131b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801322:	8b 55 08             	mov    0x8(%ebp),%edx
  801325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801328:	01 d0                	add    %edx,%eax
  80132a:	48                   	dec    %eax
  80132b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80132e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801331:	ba 00 00 00 00       	mov    $0x0,%edx
  801336:	f7 75 f0             	divl   -0x10(%ebp)
  801339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80133c:	29 d0                	sub    %edx,%eax
  80133e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801341:	e8 2b 08 00 00       	call   801b71 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801346:	85 c0                	test   %eax,%eax
  801348:	74 11                	je     80135b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80134a:	83 ec 0c             	sub    $0xc,%esp
  80134d:	ff 75 e8             	pushl  -0x18(%ebp)
  801350:	e8 96 0e 00 00       	call   8021eb <alloc_block_FF>
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80135b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80135f:	74 16                	je     801377 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801361:	83 ec 0c             	sub    $0xc,%esp
  801364:	ff 75 f4             	pushl  -0xc(%ebp)
  801367:	e8 f2 0b 00 00       	call   801f5e <insert_sorted_allocList>
  80136c:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80136f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801372:	8b 40 08             	mov    0x8(%eax),%eax
  801375:	eb 05                	jmp    80137c <malloc+0x79>
	}

    return NULL;
  801377:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	50                   	push   %eax
  80138b:	68 40 40 80 00       	push   $0x804040
  801390:	e8 71 0b 00 00       	call   801f06 <find_block>
  801395:	83 c4 10             	add    $0x10,%esp
  801398:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80139b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80139f:	0f 84 a6 00 00 00    	je     80144b <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8013a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8013ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ae:	8b 40 08             	mov    0x8(%eax),%eax
  8013b1:	83 ec 08             	sub    $0x8,%esp
  8013b4:	52                   	push   %edx
  8013b5:	50                   	push   %eax
  8013b6:	e8 b0 03 00 00       	call   80176b <sys_free_user_mem>
  8013bb:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8013be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013c2:	75 14                	jne    8013d8 <free+0x5a>
  8013c4:	83 ec 04             	sub    $0x4,%esp
  8013c7:	68 95 3c 80 00       	push   $0x803c95
  8013cc:	6a 74                	push   $0x74
  8013ce:	68 b3 3c 80 00       	push   $0x803cb3
  8013d3:	e8 be 1f 00 00       	call   803396 <_panic>
  8013d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013db:	8b 00                	mov    (%eax),%eax
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	74 10                	je     8013f1 <free+0x73>
  8013e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e4:	8b 00                	mov    (%eax),%eax
  8013e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e9:	8b 52 04             	mov    0x4(%edx),%edx
  8013ec:	89 50 04             	mov    %edx,0x4(%eax)
  8013ef:	eb 0b                	jmp    8013fc <free+0x7e>
  8013f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f4:	8b 40 04             	mov    0x4(%eax),%eax
  8013f7:	a3 44 40 80 00       	mov    %eax,0x804044
  8013fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ff:	8b 40 04             	mov    0x4(%eax),%eax
  801402:	85 c0                	test   %eax,%eax
  801404:	74 0f                	je     801415 <free+0x97>
  801406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801409:	8b 40 04             	mov    0x4(%eax),%eax
  80140c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140f:	8b 12                	mov    (%edx),%edx
  801411:	89 10                	mov    %edx,(%eax)
  801413:	eb 0a                	jmp    80141f <free+0xa1>
  801415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801418:	8b 00                	mov    (%eax),%eax
  80141a:	a3 40 40 80 00       	mov    %eax,0x804040
  80141f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801422:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801432:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801437:	48                   	dec    %eax
  801438:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(free_block);
  80143d:	83 ec 0c             	sub    $0xc,%esp
  801440:	ff 75 f4             	pushl  -0xc(%ebp)
  801443:	e8 4e 17 00 00       	call   802b96 <insert_sorted_with_merge_freeList>
  801448:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80144b:	90                   	nop
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 38             	sub    $0x38,%esp
  801454:	8b 45 10             	mov    0x10(%ebp),%eax
  801457:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80145a:	e8 a6 fc ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  80145f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801463:	75 0a                	jne    80146f <smalloc+0x21>
  801465:	b8 00 00 00 00       	mov    $0x0,%eax
  80146a:	e9 8b 00 00 00       	jmp    8014fa <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80146f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801476:	8b 55 0c             	mov    0xc(%ebp),%edx
  801479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147c:	01 d0                	add    %edx,%eax
  80147e:	48                   	dec    %eax
  80147f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801482:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801485:	ba 00 00 00 00       	mov    $0x0,%edx
  80148a:	f7 75 f0             	divl   -0x10(%ebp)
  80148d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801490:	29 d0                	sub    %edx,%eax
  801492:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801495:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80149c:	e8 d0 06 00 00       	call   801b71 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	74 11                	je     8014b6 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8014a5:	83 ec 0c             	sub    $0xc,%esp
  8014a8:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ab:	e8 3b 0d 00 00       	call   8021eb <alloc_block_FF>
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8014b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014ba:	74 39                	je     8014f5 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8014bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bf:	8b 40 08             	mov    0x8(%eax),%eax
  8014c2:	89 c2                	mov    %eax,%edx
  8014c4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8014c8:	52                   	push   %edx
  8014c9:	50                   	push   %eax
  8014ca:	ff 75 0c             	pushl  0xc(%ebp)
  8014cd:	ff 75 08             	pushl  0x8(%ebp)
  8014d0:	e8 21 04 00 00       	call   8018f6 <sys_createSharedObject>
  8014d5:	83 c4 10             	add    $0x10,%esp
  8014d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8014db:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8014df:	74 14                	je     8014f5 <smalloc+0xa7>
  8014e1:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8014e5:	74 0e                	je     8014f5 <smalloc+0xa7>
  8014e7:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8014eb:	74 08                	je     8014f5 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8014ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f0:	8b 40 08             	mov    0x8(%eax),%eax
  8014f3:	eb 05                	jmp    8014fa <smalloc+0xac>
	}
	return NULL;
  8014f5:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801502:	e8 fe fb ff ff       	call   801105 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801507:	83 ec 08             	sub    $0x8,%esp
  80150a:	ff 75 0c             	pushl  0xc(%ebp)
  80150d:	ff 75 08             	pushl  0x8(%ebp)
  801510:	e8 0b 04 00 00       	call   801920 <sys_getSizeOfSharedObject>
  801515:	83 c4 10             	add    $0x10,%esp
  801518:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80151b:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80151f:	74 76                	je     801597 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801521:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801528:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80152b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152e:	01 d0                	add    %edx,%eax
  801530:	48                   	dec    %eax
  801531:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801534:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801537:	ba 00 00 00 00       	mov    $0x0,%edx
  80153c:	f7 75 ec             	divl   -0x14(%ebp)
  80153f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801542:	29 d0                	sub    %edx,%eax
  801544:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801547:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80154e:	e8 1e 06 00 00       	call   801b71 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801553:	85 c0                	test   %eax,%eax
  801555:	74 11                	je     801568 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801557:	83 ec 0c             	sub    $0xc,%esp
  80155a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80155d:	e8 89 0c 00 00       	call   8021eb <alloc_block_FF>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80156c:	74 29                	je     801597 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80156e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801571:	8b 40 08             	mov    0x8(%eax),%eax
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	50                   	push   %eax
  801578:	ff 75 0c             	pushl  0xc(%ebp)
  80157b:	ff 75 08             	pushl  0x8(%ebp)
  80157e:	e8 ba 03 00 00       	call   80193d <sys_getSharedObject>
  801583:	83 c4 10             	add    $0x10,%esp
  801586:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801589:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80158d:	74 08                	je     801597 <sget+0x9b>
				return (void *)mem_block->sva;
  80158f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801592:	8b 40 08             	mov    0x8(%eax),%eax
  801595:	eb 05                	jmp    80159c <sget+0xa0>
		}
	}
	return NULL;
  801597:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a4:	e8 5c fb ff ff       	call   801105 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015a9:	83 ec 04             	sub    $0x4,%esp
  8015ac:	68 e4 3c 80 00       	push   $0x803ce4
  8015b1:	68 f7 00 00 00       	push   $0xf7
  8015b6:	68 b3 3c 80 00       	push   $0x803cb3
  8015bb:	e8 d6 1d 00 00       	call   803396 <_panic>

008015c0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015c6:	83 ec 04             	sub    $0x4,%esp
  8015c9:	68 0c 3d 80 00       	push   $0x803d0c
  8015ce:	68 0c 01 00 00       	push   $0x10c
  8015d3:	68 b3 3c 80 00       	push   $0x803cb3
  8015d8:	e8 b9 1d 00 00       	call   803396 <_panic>

008015dd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	68 30 3d 80 00       	push   $0x803d30
  8015eb:	68 44 01 00 00       	push   $0x144
  8015f0:	68 b3 3c 80 00       	push   $0x803cb3
  8015f5:	e8 9c 1d 00 00       	call   803396 <_panic>

008015fa <shrink>:

}
void shrink(uint32 newSize)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	68 30 3d 80 00       	push   $0x803d30
  801608:	68 49 01 00 00       	push   $0x149
  80160d:	68 b3 3c 80 00       	push   $0x803cb3
  801612:	e8 7f 1d 00 00       	call   803396 <_panic>

00801617 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80161d:	83 ec 04             	sub    $0x4,%esp
  801620:	68 30 3d 80 00       	push   $0x803d30
  801625:	68 4e 01 00 00       	push   $0x14e
  80162a:	68 b3 3c 80 00       	push   $0x803cb3
  80162f:	e8 62 1d 00 00       	call   803396 <_panic>

00801634 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	57                   	push   %edi
  801638:	56                   	push   %esi
  801639:	53                   	push   %ebx
  80163a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	8b 55 0c             	mov    0xc(%ebp),%edx
  801643:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801646:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801649:	8b 7d 18             	mov    0x18(%ebp),%edi
  80164c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80164f:	cd 30                	int    $0x30
  801651:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801654:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801657:	83 c4 10             	add    $0x10,%esp
  80165a:	5b                   	pop    %ebx
  80165b:	5e                   	pop    %esi
  80165c:	5f                   	pop    %edi
  80165d:	5d                   	pop    %ebp
  80165e:	c3                   	ret    

0080165f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 04             	sub    $0x4,%esp
  801665:	8b 45 10             	mov    0x10(%ebp),%eax
  801668:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80166b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	52                   	push   %edx
  801677:	ff 75 0c             	pushl  0xc(%ebp)
  80167a:	50                   	push   %eax
  80167b:	6a 00                	push   $0x0
  80167d:	e8 b2 ff ff ff       	call   801634 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_cgetc>:

int
sys_cgetc(void)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 01                	push   $0x1
  801697:	e8 98 ff ff ff       	call   801634 <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	52                   	push   %edx
  8016b1:	50                   	push   %eax
  8016b2:	6a 05                	push   $0x5
  8016b4:	e8 7b ff ff ff       	call   801634 <syscall>
  8016b9:	83 c4 18             	add    $0x18,%esp
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	56                   	push   %esi
  8016c2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8016c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	56                   	push   %esi
  8016d3:	53                   	push   %ebx
  8016d4:	51                   	push   %ecx
  8016d5:	52                   	push   %edx
  8016d6:	50                   	push   %eax
  8016d7:	6a 06                	push   $0x6
  8016d9:	e8 56 ff ff ff       	call   801634 <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
}
  8016e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e4:	5b                   	pop    %ebx
  8016e5:	5e                   	pop    %esi
  8016e6:	5d                   	pop    %ebp
  8016e7:	c3                   	ret    

008016e8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	52                   	push   %edx
  8016f8:	50                   	push   %eax
  8016f9:	6a 07                	push   $0x7
  8016fb:	e8 34 ff ff ff       	call   801634 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	ff 75 08             	pushl  0x8(%ebp)
  801714:	6a 08                	push   $0x8
  801716:	e8 19 ff ff ff       	call   801634 <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 09                	push   $0x9
  80172f:	e8 00 ff ff ff       	call   801634 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 0a                	push   $0xa
  801748:	e8 e7 fe ff ff       	call   801634 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 0b                	push   $0xb
  801761:	e8 ce fe ff ff       	call   801634 <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	ff 75 0c             	pushl  0xc(%ebp)
  801777:	ff 75 08             	pushl  0x8(%ebp)
  80177a:	6a 0f                	push   $0xf
  80177c:	e8 b3 fe ff ff       	call   801634 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
	return;
  801784:	90                   	nop
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	ff 75 0c             	pushl  0xc(%ebp)
  801793:	ff 75 08             	pushl  0x8(%ebp)
  801796:	6a 10                	push   $0x10
  801798:	e8 97 fe ff ff       	call   801634 <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a0:	90                   	nop
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	ff 75 10             	pushl  0x10(%ebp)
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	ff 75 08             	pushl  0x8(%ebp)
  8017b3:	6a 11                	push   $0x11
  8017b5:	e8 7a fe ff ff       	call   801634 <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bd:	90                   	nop
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 0c                	push   $0xc
  8017cf:	e8 60 fe ff ff       	call   801634 <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	ff 75 08             	pushl  0x8(%ebp)
  8017e7:	6a 0d                	push   $0xd
  8017e9:	e8 46 fe ff ff       	call   801634 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 0e                	push   $0xe
  801802:	e8 2d fe ff ff       	call   801634 <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	90                   	nop
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 13                	push   $0x13
  80181c:	e8 13 fe ff ff       	call   801634 <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
}
  801824:	90                   	nop
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 14                	push   $0x14
  801836:	e8 f9 fd ff ff       	call   801634 <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	90                   	nop
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_cputc>:


void
sys_cputc(const char c)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80184d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	50                   	push   %eax
  80185a:	6a 15                	push   $0x15
  80185c:	e8 d3 fd ff ff       	call   801634 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	90                   	nop
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 16                	push   $0x16
  801876:	e8 b9 fd ff ff       	call   801634 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	90                   	nop
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	ff 75 0c             	pushl  0xc(%ebp)
  801890:	50                   	push   %eax
  801891:	6a 17                	push   $0x17
  801893:	e8 9c fd ff ff       	call   801634 <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	52                   	push   %edx
  8018ad:	50                   	push   %eax
  8018ae:	6a 1a                	push   $0x1a
  8018b0:	e8 7f fd ff ff       	call   801634 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	52                   	push   %edx
  8018ca:	50                   	push   %eax
  8018cb:	6a 18                	push   $0x18
  8018cd:	e8 62 fd ff ff       	call   801634 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	90                   	nop
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	52                   	push   %edx
  8018e8:	50                   	push   %eax
  8018e9:	6a 19                	push   $0x19
  8018eb:	e8 44 fd ff ff       	call   801634 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	90                   	nop
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	83 ec 04             	sub    $0x4,%esp
  8018fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801902:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801905:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	51                   	push   %ecx
  80190f:	52                   	push   %edx
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	50                   	push   %eax
  801914:	6a 1b                	push   $0x1b
  801916:	e8 19 fd ff ff       	call   801634 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801923:	8b 55 0c             	mov    0xc(%ebp),%edx
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	52                   	push   %edx
  801930:	50                   	push   %eax
  801931:	6a 1c                	push   $0x1c
  801933:	e8 fc fc ff ff       	call   801634 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801940:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	51                   	push   %ecx
  80194e:	52                   	push   %edx
  80194f:	50                   	push   %eax
  801950:	6a 1d                	push   $0x1d
  801952:	e8 dd fc ff ff       	call   801634 <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80195f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	52                   	push   %edx
  80196c:	50                   	push   %eax
  80196d:	6a 1e                	push   $0x1e
  80196f:	e8 c0 fc ff ff       	call   801634 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 1f                	push   $0x1f
  801988:	e8 a7 fc ff ff       	call   801634 <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	ff 75 14             	pushl  0x14(%ebp)
  80199d:	ff 75 10             	pushl  0x10(%ebp)
  8019a0:	ff 75 0c             	pushl  0xc(%ebp)
  8019a3:	50                   	push   %eax
  8019a4:	6a 20                	push   $0x20
  8019a6:	e8 89 fc ff ff       	call   801634 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	50                   	push   %eax
  8019bf:	6a 21                	push   $0x21
  8019c1:	e8 6e fc ff ff       	call   801634 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	90                   	nop
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	50                   	push   %eax
  8019db:	6a 22                	push   $0x22
  8019dd:	e8 52 fc ff ff       	call   801634 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 02                	push   $0x2
  8019f6:	e8 39 fc ff ff       	call   801634 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 03                	push   $0x3
  801a0f:	e8 20 fc ff ff       	call   801634 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 04                	push   $0x4
  801a28:	e8 07 fc ff ff       	call   801634 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_exit_env>:


void sys_exit_env(void)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 23                	push   $0x23
  801a41:	e8 ee fb ff ff       	call   801634 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	90                   	nop
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a52:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a55:	8d 50 04             	lea    0x4(%eax),%edx
  801a58:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	52                   	push   %edx
  801a62:	50                   	push   %eax
  801a63:	6a 24                	push   $0x24
  801a65:	e8 ca fb ff ff       	call   801634 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
	return result;
  801a6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a76:	89 01                	mov    %eax,(%ecx)
  801a78:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	c9                   	leave  
  801a7f:	c2 04 00             	ret    $0x4

00801a82 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	ff 75 10             	pushl  0x10(%ebp)
  801a8c:	ff 75 0c             	pushl  0xc(%ebp)
  801a8f:	ff 75 08             	pushl  0x8(%ebp)
  801a92:	6a 12                	push   $0x12
  801a94:	e8 9b fb ff ff       	call   801634 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9c:	90                   	nop
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_rcr2>:
uint32 sys_rcr2()
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 25                	push   $0x25
  801aae:	e8 81 fb ff ff       	call   801634 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 04             	sub    $0x4,%esp
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ac4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	50                   	push   %eax
  801ad1:	6a 26                	push   $0x26
  801ad3:	e8 5c fb ff ff       	call   801634 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
	return ;
  801adb:	90                   	nop
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <rsttst>:
void rsttst()
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 28                	push   $0x28
  801aed:	e8 42 fb ff ff       	call   801634 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
	return ;
  801af5:	90                   	nop
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 04             	sub    $0x4,%esp
  801afe:	8b 45 14             	mov    0x14(%ebp),%eax
  801b01:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b04:	8b 55 18             	mov    0x18(%ebp),%edx
  801b07:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b0b:	52                   	push   %edx
  801b0c:	50                   	push   %eax
  801b0d:	ff 75 10             	pushl  0x10(%ebp)
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	ff 75 08             	pushl  0x8(%ebp)
  801b16:	6a 27                	push   $0x27
  801b18:	e8 17 fb ff ff       	call   801634 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b20:	90                   	nop
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <chktst>:
void chktst(uint32 n)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	ff 75 08             	pushl  0x8(%ebp)
  801b31:	6a 29                	push   $0x29
  801b33:	e8 fc fa ff ff       	call   801634 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3b:	90                   	nop
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <inctst>:

void inctst()
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 2a                	push   $0x2a
  801b4d:	e8 e2 fa ff ff       	call   801634 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
	return ;
  801b55:	90                   	nop
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <gettst>:
uint32 gettst()
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 2b                	push   $0x2b
  801b67:	e8 c8 fa ff ff       	call   801634 <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 2c                	push   $0x2c
  801b83:	e8 ac fa ff ff       	call   801634 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
  801b8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b8e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b92:	75 07                	jne    801b9b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b94:	b8 01 00 00 00       	mov    $0x1,%eax
  801b99:	eb 05                	jmp    801ba0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 2c                	push   $0x2c
  801bb4:	e8 7b fa ff ff       	call   801634 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
  801bbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bbf:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bc3:	75 07                	jne    801bcc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bca:	eb 05                	jmp    801bd1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 2c                	push   $0x2c
  801be5:	e8 4a fa ff ff       	call   801634 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
  801bed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bf0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bf4:	75 07                	jne    801bfd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfb:	eb 05                	jmp    801c02 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 2c                	push   $0x2c
  801c16:	e8 19 fa ff ff       	call   801634 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
  801c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c21:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c25:	75 07                	jne    801c2e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c27:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2c:	eb 05                	jmp    801c33 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	ff 75 08             	pushl  0x8(%ebp)
  801c43:	6a 2d                	push   $0x2d
  801c45:	e8 ea f9 ff ff       	call   801634 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4d:	90                   	nop
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c54:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	6a 00                	push   $0x0
  801c62:	53                   	push   %ebx
  801c63:	51                   	push   %ecx
  801c64:	52                   	push   %edx
  801c65:	50                   	push   %eax
  801c66:	6a 2e                	push   $0x2e
  801c68:	e8 c7 f9 ff ff       	call   801634 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	52                   	push   %edx
  801c85:	50                   	push   %eax
  801c86:	6a 2f                	push   $0x2f
  801c88:	e8 a7 f9 ff ff       	call   801634 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c98:	83 ec 0c             	sub    $0xc,%esp
  801c9b:	68 40 3d 80 00       	push   $0x803d40
  801ca0:	e8 d6 e6 ff ff       	call   80037b <cprintf>
  801ca5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ca8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801caf:	83 ec 0c             	sub    $0xc,%esp
  801cb2:	68 6c 3d 80 00       	push   $0x803d6c
  801cb7:	e8 bf e6 ff ff       	call   80037b <cprintf>
  801cbc:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cbf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cc3:	a1 38 41 80 00       	mov    0x804138,%eax
  801cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ccb:	eb 56                	jmp    801d23 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ccd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cd1:	74 1c                	je     801cef <print_mem_block_lists+0x5d>
  801cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd6:	8b 50 08             	mov    0x8(%eax),%edx
  801cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdc:	8b 48 08             	mov    0x8(%eax),%ecx
  801cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce5:	01 c8                	add    %ecx,%eax
  801ce7:	39 c2                	cmp    %eax,%edx
  801ce9:	73 04                	jae    801cef <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ceb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf2:	8b 50 08             	mov    0x8(%eax),%edx
  801cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf8:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfb:	01 c2                	add    %eax,%edx
  801cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d00:	8b 40 08             	mov    0x8(%eax),%eax
  801d03:	83 ec 04             	sub    $0x4,%esp
  801d06:	52                   	push   %edx
  801d07:	50                   	push   %eax
  801d08:	68 81 3d 80 00       	push   $0x803d81
  801d0d:	e8 69 e6 ff ff       	call   80037b <cprintf>
  801d12:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d1b:	a1 40 41 80 00       	mov    0x804140,%eax
  801d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d27:	74 07                	je     801d30 <print_mem_block_lists+0x9e>
  801d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2c:	8b 00                	mov    (%eax),%eax
  801d2e:	eb 05                	jmp    801d35 <print_mem_block_lists+0xa3>
  801d30:	b8 00 00 00 00       	mov    $0x0,%eax
  801d35:	a3 40 41 80 00       	mov    %eax,0x804140
  801d3a:	a1 40 41 80 00       	mov    0x804140,%eax
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	75 8a                	jne    801ccd <print_mem_block_lists+0x3b>
  801d43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d47:	75 84                	jne    801ccd <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d49:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d4d:	75 10                	jne    801d5f <print_mem_block_lists+0xcd>
  801d4f:	83 ec 0c             	sub    $0xc,%esp
  801d52:	68 90 3d 80 00       	push   $0x803d90
  801d57:	e8 1f e6 ff ff       	call   80037b <cprintf>
  801d5c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d66:	83 ec 0c             	sub    $0xc,%esp
  801d69:	68 b4 3d 80 00       	push   $0x803db4
  801d6e:	e8 08 e6 ff ff       	call   80037b <cprintf>
  801d73:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d76:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d7a:	a1 40 40 80 00       	mov    0x804040,%eax
  801d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d82:	eb 56                	jmp    801dda <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d88:	74 1c                	je     801da6 <print_mem_block_lists+0x114>
  801d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8d:	8b 50 08             	mov    0x8(%eax),%edx
  801d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d93:	8b 48 08             	mov    0x8(%eax),%ecx
  801d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d99:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9c:	01 c8                	add    %ecx,%eax
  801d9e:	39 c2                	cmp    %eax,%edx
  801da0:	73 04                	jae    801da6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801da2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da9:	8b 50 08             	mov    0x8(%eax),%edx
  801dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daf:	8b 40 0c             	mov    0xc(%eax),%eax
  801db2:	01 c2                	add    %eax,%edx
  801db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db7:	8b 40 08             	mov    0x8(%eax),%eax
  801dba:	83 ec 04             	sub    $0x4,%esp
  801dbd:	52                   	push   %edx
  801dbe:	50                   	push   %eax
  801dbf:	68 81 3d 80 00       	push   $0x803d81
  801dc4:	e8 b2 e5 ff ff       	call   80037b <cprintf>
  801dc9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dd2:	a1 48 40 80 00       	mov    0x804048,%eax
  801dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dde:	74 07                	je     801de7 <print_mem_block_lists+0x155>
  801de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de3:	8b 00                	mov    (%eax),%eax
  801de5:	eb 05                	jmp    801dec <print_mem_block_lists+0x15a>
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dec:	a3 48 40 80 00       	mov    %eax,0x804048
  801df1:	a1 48 40 80 00       	mov    0x804048,%eax
  801df6:	85 c0                	test   %eax,%eax
  801df8:	75 8a                	jne    801d84 <print_mem_block_lists+0xf2>
  801dfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dfe:	75 84                	jne    801d84 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e00:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e04:	75 10                	jne    801e16 <print_mem_block_lists+0x184>
  801e06:	83 ec 0c             	sub    $0xc,%esp
  801e09:	68 cc 3d 80 00       	push   $0x803dcc
  801e0e:	e8 68 e5 ff ff       	call   80037b <cprintf>
  801e13:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e16:	83 ec 0c             	sub    $0xc,%esp
  801e19:	68 40 3d 80 00       	push   $0x803d40
  801e1e:	e8 58 e5 ff ff       	call   80037b <cprintf>
  801e23:	83 c4 10             	add    $0x10,%esp

}
  801e26:	90                   	nop
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e2f:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e36:	00 00 00 
  801e39:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e40:	00 00 00 
  801e43:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e4a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e54:	e9 9e 00 00 00       	jmp    801ef7 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e59:	a1 50 40 80 00       	mov    0x804050,%eax
  801e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e61:	c1 e2 04             	shl    $0x4,%edx
  801e64:	01 d0                	add    %edx,%eax
  801e66:	85 c0                	test   %eax,%eax
  801e68:	75 14                	jne    801e7e <initialize_MemBlocksList+0x55>
  801e6a:	83 ec 04             	sub    $0x4,%esp
  801e6d:	68 f4 3d 80 00       	push   $0x803df4
  801e72:	6a 46                	push   $0x46
  801e74:	68 17 3e 80 00       	push   $0x803e17
  801e79:	e8 18 15 00 00       	call   803396 <_panic>
  801e7e:	a1 50 40 80 00       	mov    0x804050,%eax
  801e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e86:	c1 e2 04             	shl    $0x4,%edx
  801e89:	01 d0                	add    %edx,%eax
  801e8b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e91:	89 10                	mov    %edx,(%eax)
  801e93:	8b 00                	mov    (%eax),%eax
  801e95:	85 c0                	test   %eax,%eax
  801e97:	74 18                	je     801eb1 <initialize_MemBlocksList+0x88>
  801e99:	a1 48 41 80 00       	mov    0x804148,%eax
  801e9e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ea4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ea7:	c1 e1 04             	shl    $0x4,%ecx
  801eaa:	01 ca                	add    %ecx,%edx
  801eac:	89 50 04             	mov    %edx,0x4(%eax)
  801eaf:	eb 12                	jmp    801ec3 <initialize_MemBlocksList+0x9a>
  801eb1:	a1 50 40 80 00       	mov    0x804050,%eax
  801eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb9:	c1 e2 04             	shl    $0x4,%edx
  801ebc:	01 d0                	add    %edx,%eax
  801ebe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ec3:	a1 50 40 80 00       	mov    0x804050,%eax
  801ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ecb:	c1 e2 04             	shl    $0x4,%edx
  801ece:	01 d0                	add    %edx,%eax
  801ed0:	a3 48 41 80 00       	mov    %eax,0x804148
  801ed5:	a1 50 40 80 00       	mov    0x804050,%eax
  801eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edd:	c1 e2 04             	shl    $0x4,%edx
  801ee0:	01 d0                	add    %edx,%eax
  801ee2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ee9:	a1 54 41 80 00       	mov    0x804154,%eax
  801eee:	40                   	inc    %eax
  801eef:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ef4:	ff 45 f4             	incl   -0xc(%ebp)
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	3b 45 08             	cmp    0x8(%ebp),%eax
  801efd:	0f 82 56 ff ff ff    	jb     801e59 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f03:	90                   	nop
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8b 00                	mov    (%eax),%eax
  801f11:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f14:	eb 19                	jmp    801f2f <find_block+0x29>
	{
		if(va==point->sva)
  801f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f19:	8b 40 08             	mov    0x8(%eax),%eax
  801f1c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f1f:	75 05                	jne    801f26 <find_block+0x20>
		   return point;
  801f21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f24:	eb 36                	jmp    801f5c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	8b 40 08             	mov    0x8(%eax),%eax
  801f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f33:	74 07                	je     801f3c <find_block+0x36>
  801f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f38:	8b 00                	mov    (%eax),%eax
  801f3a:	eb 05                	jmp    801f41 <find_block+0x3b>
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f41:	8b 55 08             	mov    0x8(%ebp),%edx
  801f44:	89 42 08             	mov    %eax,0x8(%edx)
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	8b 40 08             	mov    0x8(%eax),%eax
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	75 c5                	jne    801f16 <find_block+0x10>
  801f51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f55:	75 bf                	jne    801f16 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f64:	a1 40 40 80 00       	mov    0x804040,%eax
  801f69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f6c:	a1 44 40 80 00       	mov    0x804044,%eax
  801f71:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f7a:	74 24                	je     801fa0 <insert_sorted_allocList+0x42>
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	8b 50 08             	mov    0x8(%eax),%edx
  801f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f85:	8b 40 08             	mov    0x8(%eax),%eax
  801f88:	39 c2                	cmp    %eax,%edx
  801f8a:	76 14                	jbe    801fa0 <insert_sorted_allocList+0x42>
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	8b 50 08             	mov    0x8(%eax),%edx
  801f92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f95:	8b 40 08             	mov    0x8(%eax),%eax
  801f98:	39 c2                	cmp    %eax,%edx
  801f9a:	0f 82 60 01 00 00    	jb     802100 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fa0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa4:	75 65                	jne    80200b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fa6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801faa:	75 14                	jne    801fc0 <insert_sorted_allocList+0x62>
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	68 f4 3d 80 00       	push   $0x803df4
  801fb4:	6a 6b                	push   $0x6b
  801fb6:	68 17 3e 80 00       	push   $0x803e17
  801fbb:	e8 d6 13 00 00       	call   803396 <_panic>
  801fc0:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	89 10                	mov    %edx,(%eax)
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	8b 00                	mov    (%eax),%eax
  801fd0:	85 c0                	test   %eax,%eax
  801fd2:	74 0d                	je     801fe1 <insert_sorted_allocList+0x83>
  801fd4:	a1 40 40 80 00       	mov    0x804040,%eax
  801fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  801fdc:	89 50 04             	mov    %edx,0x4(%eax)
  801fdf:	eb 08                	jmp    801fe9 <insert_sorted_allocList+0x8b>
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	a3 44 40 80 00       	mov    %eax,0x804044
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	a3 40 40 80 00       	mov    %eax,0x804040
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ffb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802000:	40                   	inc    %eax
  802001:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802006:	e9 dc 01 00 00       	jmp    8021e7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8b 50 08             	mov    0x8(%eax),%edx
  802011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802014:	8b 40 08             	mov    0x8(%eax),%eax
  802017:	39 c2                	cmp    %eax,%edx
  802019:	77 6c                	ja     802087 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80201b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80201f:	74 06                	je     802027 <insert_sorted_allocList+0xc9>
  802021:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802025:	75 14                	jne    80203b <insert_sorted_allocList+0xdd>
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	68 30 3e 80 00       	push   $0x803e30
  80202f:	6a 6f                	push   $0x6f
  802031:	68 17 3e 80 00       	push   $0x803e17
  802036:	e8 5b 13 00 00       	call   803396 <_panic>
  80203b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203e:	8b 50 04             	mov    0x4(%eax),%edx
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	89 50 04             	mov    %edx,0x4(%eax)
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80204d:	89 10                	mov    %edx,(%eax)
  80204f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802052:	8b 40 04             	mov    0x4(%eax),%eax
  802055:	85 c0                	test   %eax,%eax
  802057:	74 0d                	je     802066 <insert_sorted_allocList+0x108>
  802059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205c:	8b 40 04             	mov    0x4(%eax),%eax
  80205f:	8b 55 08             	mov    0x8(%ebp),%edx
  802062:	89 10                	mov    %edx,(%eax)
  802064:	eb 08                	jmp    80206e <insert_sorted_allocList+0x110>
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	a3 40 40 80 00       	mov    %eax,0x804040
  80206e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802071:	8b 55 08             	mov    0x8(%ebp),%edx
  802074:	89 50 04             	mov    %edx,0x4(%eax)
  802077:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80207c:	40                   	inc    %eax
  80207d:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802082:	e9 60 01 00 00       	jmp    8021e7 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	8b 50 08             	mov    0x8(%eax),%edx
  80208d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802090:	8b 40 08             	mov    0x8(%eax),%eax
  802093:	39 c2                	cmp    %eax,%edx
  802095:	0f 82 4c 01 00 00    	jb     8021e7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80209b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80209f:	75 14                	jne    8020b5 <insert_sorted_allocList+0x157>
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	68 68 3e 80 00       	push   $0x803e68
  8020a9:	6a 73                	push   $0x73
  8020ab:	68 17 3e 80 00       	push   $0x803e17
  8020b0:	e8 e1 12 00 00       	call   803396 <_panic>
  8020b5:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	89 50 04             	mov    %edx,0x4(%eax)
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	8b 40 04             	mov    0x4(%eax),%eax
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	74 0c                	je     8020d7 <insert_sorted_allocList+0x179>
  8020cb:	a1 44 40 80 00       	mov    0x804044,%eax
  8020d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d3:	89 10                	mov    %edx,(%eax)
  8020d5:	eb 08                	jmp    8020df <insert_sorted_allocList+0x181>
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	a3 40 40 80 00       	mov    %eax,0x804040
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	a3 44 40 80 00       	mov    %eax,0x804044
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020f0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020f5:	40                   	inc    %eax
  8020f6:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020fb:	e9 e7 00 00 00       	jmp    8021e7 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802103:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802106:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80210d:	a1 40 40 80 00       	mov    0x804040,%eax
  802112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802115:	e9 9d 00 00 00       	jmp    8021b7 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	8b 00                	mov    (%eax),%eax
  80211f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	8b 50 08             	mov    0x8(%eax),%edx
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	8b 40 08             	mov    0x8(%eax),%eax
  80212e:	39 c2                	cmp    %eax,%edx
  802130:	76 7d                	jbe    8021af <insert_sorted_allocList+0x251>
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	8b 50 08             	mov    0x8(%eax),%edx
  802138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80213b:	8b 40 08             	mov    0x8(%eax),%eax
  80213e:	39 c2                	cmp    %eax,%edx
  802140:	73 6d                	jae    8021af <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802142:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802146:	74 06                	je     80214e <insert_sorted_allocList+0x1f0>
  802148:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214c:	75 14                	jne    802162 <insert_sorted_allocList+0x204>
  80214e:	83 ec 04             	sub    $0x4,%esp
  802151:	68 8c 3e 80 00       	push   $0x803e8c
  802156:	6a 7f                	push   $0x7f
  802158:	68 17 3e 80 00       	push   $0x803e17
  80215d:	e8 34 12 00 00       	call   803396 <_panic>
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	8b 10                	mov    (%eax),%edx
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	89 10                	mov    %edx,(%eax)
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	8b 00                	mov    (%eax),%eax
  802171:	85 c0                	test   %eax,%eax
  802173:	74 0b                	je     802180 <insert_sorted_allocList+0x222>
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 00                	mov    (%eax),%eax
  80217a:	8b 55 08             	mov    0x8(%ebp),%edx
  80217d:	89 50 04             	mov    %edx,0x4(%eax)
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 55 08             	mov    0x8(%ebp),%edx
  802186:	89 10                	mov    %edx,(%eax)
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218e:	89 50 04             	mov    %edx,0x4(%eax)
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	8b 00                	mov    (%eax),%eax
  802196:	85 c0                	test   %eax,%eax
  802198:	75 08                	jne    8021a2 <insert_sorted_allocList+0x244>
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	a3 44 40 80 00       	mov    %eax,0x804044
  8021a2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021a7:	40                   	inc    %eax
  8021a8:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021ad:	eb 39                	jmp    8021e8 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021af:	a1 48 40 80 00       	mov    0x804048,%eax
  8021b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bb:	74 07                	je     8021c4 <insert_sorted_allocList+0x266>
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	8b 00                	mov    (%eax),%eax
  8021c2:	eb 05                	jmp    8021c9 <insert_sorted_allocList+0x26b>
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c9:	a3 48 40 80 00       	mov    %eax,0x804048
  8021ce:	a1 48 40 80 00       	mov    0x804048,%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	0f 85 3f ff ff ff    	jne    80211a <insert_sorted_allocList+0x1bc>
  8021db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021df:	0f 85 35 ff ff ff    	jne    80211a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021e5:	eb 01                	jmp    8021e8 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021e7:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021e8:	90                   	nop
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021f1:	a1 38 41 80 00       	mov    0x804138,%eax
  8021f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f9:	e9 85 01 00 00       	jmp    802383 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802201:	8b 40 0c             	mov    0xc(%eax),%eax
  802204:	3b 45 08             	cmp    0x8(%ebp),%eax
  802207:	0f 82 6e 01 00 00    	jb     80237b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80220d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802210:	8b 40 0c             	mov    0xc(%eax),%eax
  802213:	3b 45 08             	cmp    0x8(%ebp),%eax
  802216:	0f 85 8a 00 00 00    	jne    8022a6 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80221c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802220:	75 17                	jne    802239 <alloc_block_FF+0x4e>
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	68 c0 3e 80 00       	push   $0x803ec0
  80222a:	68 93 00 00 00       	push   $0x93
  80222f:	68 17 3e 80 00       	push   $0x803e17
  802234:	e8 5d 11 00 00       	call   803396 <_panic>
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	8b 00                	mov    (%eax),%eax
  80223e:	85 c0                	test   %eax,%eax
  802240:	74 10                	je     802252 <alloc_block_FF+0x67>
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 00                	mov    (%eax),%eax
  802247:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224a:	8b 52 04             	mov    0x4(%edx),%edx
  80224d:	89 50 04             	mov    %edx,0x4(%eax)
  802250:	eb 0b                	jmp    80225d <alloc_block_FF+0x72>
  802252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802255:	8b 40 04             	mov    0x4(%eax),%eax
  802258:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80225d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802260:	8b 40 04             	mov    0x4(%eax),%eax
  802263:	85 c0                	test   %eax,%eax
  802265:	74 0f                	je     802276 <alloc_block_FF+0x8b>
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	8b 40 04             	mov    0x4(%eax),%eax
  80226d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802270:	8b 12                	mov    (%edx),%edx
  802272:	89 10                	mov    %edx,(%eax)
  802274:	eb 0a                	jmp    802280 <alloc_block_FF+0x95>
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	a3 38 41 80 00       	mov    %eax,0x804138
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802293:	a1 44 41 80 00       	mov    0x804144,%eax
  802298:	48                   	dec    %eax
  802299:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	e9 10 01 00 00       	jmp    8023b6 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022af:	0f 86 c6 00 00 00    	jbe    80237b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022b5:	a1 48 41 80 00       	mov    0x804148,%eax
  8022ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 50 08             	mov    0x8(%eax),%edx
  8022c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c6:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022cf:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d6:	75 17                	jne    8022ef <alloc_block_FF+0x104>
  8022d8:	83 ec 04             	sub    $0x4,%esp
  8022db:	68 c0 3e 80 00       	push   $0x803ec0
  8022e0:	68 9b 00 00 00       	push   $0x9b
  8022e5:	68 17 3e 80 00       	push   $0x803e17
  8022ea:	e8 a7 10 00 00       	call   803396 <_panic>
  8022ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f2:	8b 00                	mov    (%eax),%eax
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	74 10                	je     802308 <alloc_block_FF+0x11d>
  8022f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fb:	8b 00                	mov    (%eax),%eax
  8022fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802300:	8b 52 04             	mov    0x4(%edx),%edx
  802303:	89 50 04             	mov    %edx,0x4(%eax)
  802306:	eb 0b                	jmp    802313 <alloc_block_FF+0x128>
  802308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230b:	8b 40 04             	mov    0x4(%eax),%eax
  80230e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802316:	8b 40 04             	mov    0x4(%eax),%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	74 0f                	je     80232c <alloc_block_FF+0x141>
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802320:	8b 40 04             	mov    0x4(%eax),%eax
  802323:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802326:	8b 12                	mov    (%edx),%edx
  802328:	89 10                	mov    %edx,(%eax)
  80232a:	eb 0a                	jmp    802336 <alloc_block_FF+0x14b>
  80232c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	a3 48 41 80 00       	mov    %eax,0x804148
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802342:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802349:	a1 54 41 80 00       	mov    0x804154,%eax
  80234e:	48                   	dec    %eax
  80234f:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 50 08             	mov    0x8(%eax),%edx
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	01 c2                	add    %eax,%edx
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 40 0c             	mov    0xc(%eax),%eax
  80236b:	2b 45 08             	sub    0x8(%ebp),%eax
  80236e:	89 c2                	mov    %eax,%edx
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802379:	eb 3b                	jmp    8023b6 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80237b:	a1 40 41 80 00       	mov    0x804140,%eax
  802380:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802383:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802387:	74 07                	je     802390 <alloc_block_FF+0x1a5>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 00                	mov    (%eax),%eax
  80238e:	eb 05                	jmp    802395 <alloc_block_FF+0x1aa>
  802390:	b8 00 00 00 00       	mov    $0x0,%eax
  802395:	a3 40 41 80 00       	mov    %eax,0x804140
  80239a:	a1 40 41 80 00       	mov    0x804140,%eax
  80239f:	85 c0                	test   %eax,%eax
  8023a1:	0f 85 57 fe ff ff    	jne    8021fe <alloc_block_FF+0x13>
  8023a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ab:	0f 85 4d fe ff ff    	jne    8021fe <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023c5:	a1 38 41 80 00       	mov    0x804138,%eax
  8023ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cd:	e9 df 00 00 00       	jmp    8024b1 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023db:	0f 82 c8 00 00 00    	jb     8024a9 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ea:	0f 85 8a 00 00 00    	jne    80247a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f4:	75 17                	jne    80240d <alloc_block_BF+0x55>
  8023f6:	83 ec 04             	sub    $0x4,%esp
  8023f9:	68 c0 3e 80 00       	push   $0x803ec0
  8023fe:	68 b7 00 00 00       	push   $0xb7
  802403:	68 17 3e 80 00       	push   $0x803e17
  802408:	e8 89 0f 00 00       	call   803396 <_panic>
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 00                	mov    (%eax),%eax
  802412:	85 c0                	test   %eax,%eax
  802414:	74 10                	je     802426 <alloc_block_BF+0x6e>
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 00                	mov    (%eax),%eax
  80241b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241e:	8b 52 04             	mov    0x4(%edx),%edx
  802421:	89 50 04             	mov    %edx,0x4(%eax)
  802424:	eb 0b                	jmp    802431 <alloc_block_BF+0x79>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 40 04             	mov    0x4(%eax),%eax
  80242c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 40 04             	mov    0x4(%eax),%eax
  802437:	85 c0                	test   %eax,%eax
  802439:	74 0f                	je     80244a <alloc_block_BF+0x92>
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 40 04             	mov    0x4(%eax),%eax
  802441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802444:	8b 12                	mov    (%edx),%edx
  802446:	89 10                	mov    %edx,(%eax)
  802448:	eb 0a                	jmp    802454 <alloc_block_BF+0x9c>
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 00                	mov    (%eax),%eax
  80244f:	a3 38 41 80 00       	mov    %eax,0x804138
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802467:	a1 44 41 80 00       	mov    0x804144,%eax
  80246c:	48                   	dec    %eax
  80246d:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	e9 4d 01 00 00       	jmp    8025c7 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 40 0c             	mov    0xc(%eax),%eax
  802480:	3b 45 08             	cmp    0x8(%ebp),%eax
  802483:	76 24                	jbe    8024a9 <alloc_block_BF+0xf1>
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 40 0c             	mov    0xc(%eax),%eax
  80248b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80248e:	73 19                	jae    8024a9 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802490:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 40 0c             	mov    0xc(%eax),%eax
  80249d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 08             	mov    0x8(%eax),%eax
  8024a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024a9:	a1 40 41 80 00       	mov    0x804140,%eax
  8024ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b5:	74 07                	je     8024be <alloc_block_BF+0x106>
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	8b 00                	mov    (%eax),%eax
  8024bc:	eb 05                	jmp    8024c3 <alloc_block_BF+0x10b>
  8024be:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c3:	a3 40 41 80 00       	mov    %eax,0x804140
  8024c8:	a1 40 41 80 00       	mov    0x804140,%eax
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	0f 85 fd fe ff ff    	jne    8023d2 <alloc_block_BF+0x1a>
  8024d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d9:	0f 85 f3 fe ff ff    	jne    8023d2 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024e3:	0f 84 d9 00 00 00    	je     8025c2 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024e9:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024f7:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802500:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802503:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802507:	75 17                	jne    802520 <alloc_block_BF+0x168>
  802509:	83 ec 04             	sub    $0x4,%esp
  80250c:	68 c0 3e 80 00       	push   $0x803ec0
  802511:	68 c7 00 00 00       	push   $0xc7
  802516:	68 17 3e 80 00       	push   $0x803e17
  80251b:	e8 76 0e 00 00       	call   803396 <_panic>
  802520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802523:	8b 00                	mov    (%eax),%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	74 10                	je     802539 <alloc_block_BF+0x181>
  802529:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802531:	8b 52 04             	mov    0x4(%edx),%edx
  802534:	89 50 04             	mov    %edx,0x4(%eax)
  802537:	eb 0b                	jmp    802544 <alloc_block_BF+0x18c>
  802539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253c:	8b 40 04             	mov    0x4(%eax),%eax
  80253f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802547:	8b 40 04             	mov    0x4(%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 0f                	je     80255d <alloc_block_BF+0x1a5>
  80254e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802551:	8b 40 04             	mov    0x4(%eax),%eax
  802554:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802557:	8b 12                	mov    (%edx),%edx
  802559:	89 10                	mov    %edx,(%eax)
  80255b:	eb 0a                	jmp    802567 <alloc_block_BF+0x1af>
  80255d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	a3 48 41 80 00       	mov    %eax,0x804148
  802567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802573:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257a:	a1 54 41 80 00       	mov    0x804154,%eax
  80257f:	48                   	dec    %eax
  802580:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802585:	83 ec 08             	sub    $0x8,%esp
  802588:	ff 75 ec             	pushl  -0x14(%ebp)
  80258b:	68 38 41 80 00       	push   $0x804138
  802590:	e8 71 f9 ff ff       	call   801f06 <find_block>
  802595:	83 c4 10             	add    $0x10,%esp
  802598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80259b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259e:	8b 50 08             	mov    0x8(%eax),%edx
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	01 c2                	add    %eax,%edx
  8025a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a9:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025af:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b2:	2b 45 08             	sub    0x8(%ebp),%eax
  8025b5:	89 c2                	mov    %eax,%edx
  8025b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ba:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c0:	eb 05                	jmp    8025c7 <alloc_block_BF+0x20f>
	}
	return NULL;
  8025c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
  8025cc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025cf:	a1 28 40 80 00       	mov    0x804028,%eax
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	0f 85 de 01 00 00    	jne    8027ba <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025dc:	a1 38 41 80 00       	mov    0x804138,%eax
  8025e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e4:	e9 9e 01 00 00       	jmp    802787 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f2:	0f 82 87 01 00 00    	jb     80277f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802601:	0f 85 95 00 00 00    	jne    80269c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260b:	75 17                	jne    802624 <alloc_block_NF+0x5b>
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	68 c0 3e 80 00       	push   $0x803ec0
  802615:	68 e0 00 00 00       	push   $0xe0
  80261a:	68 17 3e 80 00       	push   $0x803e17
  80261f:	e8 72 0d 00 00       	call   803396 <_panic>
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 00                	mov    (%eax),%eax
  802629:	85 c0                	test   %eax,%eax
  80262b:	74 10                	je     80263d <alloc_block_NF+0x74>
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802635:	8b 52 04             	mov    0x4(%edx),%edx
  802638:	89 50 04             	mov    %edx,0x4(%eax)
  80263b:	eb 0b                	jmp    802648 <alloc_block_NF+0x7f>
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 40 04             	mov    0x4(%eax),%eax
  802643:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 40 04             	mov    0x4(%eax),%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	74 0f                	je     802661 <alloc_block_NF+0x98>
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 40 04             	mov    0x4(%eax),%eax
  802658:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265b:	8b 12                	mov    (%edx),%edx
  80265d:	89 10                	mov    %edx,(%eax)
  80265f:	eb 0a                	jmp    80266b <alloc_block_NF+0xa2>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	a3 38 41 80 00       	mov    %eax,0x804138
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267e:	a1 44 41 80 00       	mov    0x804144,%eax
  802683:	48                   	dec    %eax
  802684:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 40 08             	mov    0x8(%eax),%eax
  80268f:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	e9 f8 04 00 00       	jmp    802b94 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a5:	0f 86 d4 00 00 00    	jbe    80277f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026ab:	a1 48 41 80 00       	mov    0x804148,%eax
  8026b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 50 08             	mov    0x8(%eax),%edx
  8026b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bc:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c5:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026cc:	75 17                	jne    8026e5 <alloc_block_NF+0x11c>
  8026ce:	83 ec 04             	sub    $0x4,%esp
  8026d1:	68 c0 3e 80 00       	push   $0x803ec0
  8026d6:	68 e9 00 00 00       	push   $0xe9
  8026db:	68 17 3e 80 00       	push   $0x803e17
  8026e0:	e8 b1 0c 00 00       	call   803396 <_panic>
  8026e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e8:	8b 00                	mov    (%eax),%eax
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	74 10                	je     8026fe <alloc_block_NF+0x135>
  8026ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f6:	8b 52 04             	mov    0x4(%edx),%edx
  8026f9:	89 50 04             	mov    %edx,0x4(%eax)
  8026fc:	eb 0b                	jmp    802709 <alloc_block_NF+0x140>
  8026fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802701:	8b 40 04             	mov    0x4(%eax),%eax
  802704:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270c:	8b 40 04             	mov    0x4(%eax),%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	74 0f                	je     802722 <alloc_block_NF+0x159>
  802713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802716:	8b 40 04             	mov    0x4(%eax),%eax
  802719:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271c:	8b 12                	mov    (%edx),%edx
  80271e:	89 10                	mov    %edx,(%eax)
  802720:	eb 0a                	jmp    80272c <alloc_block_NF+0x163>
  802722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	a3 48 41 80 00       	mov    %eax,0x804148
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802738:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273f:	a1 54 41 80 00       	mov    0x804154,%eax
  802744:	48                   	dec    %eax
  802745:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  80274a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274d:	8b 40 08             	mov    0x8(%eax),%eax
  802750:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 50 08             	mov    0x8(%eax),%edx
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	01 c2                	add    %eax,%edx
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 40 0c             	mov    0xc(%eax),%eax
  80276c:	2b 45 08             	sub    0x8(%ebp),%eax
  80276f:	89 c2                	mov    %eax,%edx
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277a:	e9 15 04 00 00       	jmp    802b94 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80277f:	a1 40 41 80 00       	mov    0x804140,%eax
  802784:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278b:	74 07                	je     802794 <alloc_block_NF+0x1cb>
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 00                	mov    (%eax),%eax
  802792:	eb 05                	jmp    802799 <alloc_block_NF+0x1d0>
  802794:	b8 00 00 00 00       	mov    $0x0,%eax
  802799:	a3 40 41 80 00       	mov    %eax,0x804140
  80279e:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	0f 85 3e fe ff ff    	jne    8025e9 <alloc_block_NF+0x20>
  8027ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027af:	0f 85 34 fe ff ff    	jne    8025e9 <alloc_block_NF+0x20>
  8027b5:	e9 d5 03 00 00       	jmp    802b8f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027ba:	a1 38 41 80 00       	mov    0x804138,%eax
  8027bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c2:	e9 b1 01 00 00       	jmp    802978 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 50 08             	mov    0x8(%eax),%edx
  8027cd:	a1 28 40 80 00       	mov    0x804028,%eax
  8027d2:	39 c2                	cmp    %eax,%edx
  8027d4:	0f 82 96 01 00 00    	jb     802970 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e3:	0f 82 87 01 00 00    	jb     802970 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f2:	0f 85 95 00 00 00    	jne    80288d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fc:	75 17                	jne    802815 <alloc_block_NF+0x24c>
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	68 c0 3e 80 00       	push   $0x803ec0
  802806:	68 fc 00 00 00       	push   $0xfc
  80280b:	68 17 3e 80 00       	push   $0x803e17
  802810:	e8 81 0b 00 00       	call   803396 <_panic>
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 10                	je     80282e <alloc_block_NF+0x265>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802826:	8b 52 04             	mov    0x4(%edx),%edx
  802829:	89 50 04             	mov    %edx,0x4(%eax)
  80282c:	eb 0b                	jmp    802839 <alloc_block_NF+0x270>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	74 0f                	je     802852 <alloc_block_NF+0x289>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284c:	8b 12                	mov    (%edx),%edx
  80284e:	89 10                	mov    %edx,(%eax)
  802850:	eb 0a                	jmp    80285c <alloc_block_NF+0x293>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	a3 38 41 80 00       	mov    %eax,0x804138
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286f:	a1 44 41 80 00       	mov    0x804144,%eax
  802874:	48                   	dec    %eax
  802875:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 40 08             	mov    0x8(%eax),%eax
  802880:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	e9 07 03 00 00       	jmp    802b94 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 40 0c             	mov    0xc(%eax),%eax
  802893:	3b 45 08             	cmp    0x8(%ebp),%eax
  802896:	0f 86 d4 00 00 00    	jbe    802970 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80289c:	a1 48 41 80 00       	mov    0x804148,%eax
  8028a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 50 08             	mov    0x8(%eax),%edx
  8028aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ad:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028bd:	75 17                	jne    8028d6 <alloc_block_NF+0x30d>
  8028bf:	83 ec 04             	sub    $0x4,%esp
  8028c2:	68 c0 3e 80 00       	push   $0x803ec0
  8028c7:	68 04 01 00 00       	push   $0x104
  8028cc:	68 17 3e 80 00       	push   $0x803e17
  8028d1:	e8 c0 0a 00 00       	call   803396 <_panic>
  8028d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d9:	8b 00                	mov    (%eax),%eax
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	74 10                	je     8028ef <alloc_block_NF+0x326>
  8028df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028e7:	8b 52 04             	mov    0x4(%edx),%edx
  8028ea:	89 50 04             	mov    %edx,0x4(%eax)
  8028ed:	eb 0b                	jmp    8028fa <alloc_block_NF+0x331>
  8028ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fd:	8b 40 04             	mov    0x4(%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0f                	je     802913 <alloc_block_NF+0x34a>
  802904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80290d:	8b 12                	mov    (%edx),%edx
  80290f:	89 10                	mov    %edx,(%eax)
  802911:	eb 0a                	jmp    80291d <alloc_block_NF+0x354>
  802913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	a3 48 41 80 00       	mov    %eax,0x804148
  80291d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802926:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802929:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802930:	a1 54 41 80 00       	mov    0x804154,%eax
  802935:	48                   	dec    %eax
  802936:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80293b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293e:	8b 40 08             	mov    0x8(%eax),%eax
  802941:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 50 08             	mov    0x8(%eax),%edx
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	01 c2                	add    %eax,%edx
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 0c             	mov    0xc(%eax),%eax
  80295d:	2b 45 08             	sub    0x8(%ebp),%eax
  802960:	89 c2                	mov    %eax,%edx
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802968:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296b:	e9 24 02 00 00       	jmp    802b94 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802970:	a1 40 41 80 00       	mov    0x804140,%eax
  802975:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297c:	74 07                	je     802985 <alloc_block_NF+0x3bc>
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	eb 05                	jmp    80298a <alloc_block_NF+0x3c1>
  802985:	b8 00 00 00 00       	mov    $0x0,%eax
  80298a:	a3 40 41 80 00       	mov    %eax,0x804140
  80298f:	a1 40 41 80 00       	mov    0x804140,%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	0f 85 2b fe ff ff    	jne    8027c7 <alloc_block_NF+0x1fe>
  80299c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a0:	0f 85 21 fe ff ff    	jne    8027c7 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029a6:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ae:	e9 ae 01 00 00       	jmp    802b61 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 50 08             	mov    0x8(%eax),%edx
  8029b9:	a1 28 40 80 00       	mov    0x804028,%eax
  8029be:	39 c2                	cmp    %eax,%edx
  8029c0:	0f 83 93 01 00 00    	jae    802b59 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cf:	0f 82 84 01 00 00    	jb     802b59 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029de:	0f 85 95 00 00 00    	jne    802a79 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e8:	75 17                	jne    802a01 <alloc_block_NF+0x438>
  8029ea:	83 ec 04             	sub    $0x4,%esp
  8029ed:	68 c0 3e 80 00       	push   $0x803ec0
  8029f2:	68 14 01 00 00       	push   $0x114
  8029f7:	68 17 3e 80 00       	push   $0x803e17
  8029fc:	e8 95 09 00 00       	call   803396 <_panic>
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	85 c0                	test   %eax,%eax
  802a08:	74 10                	je     802a1a <alloc_block_NF+0x451>
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 00                	mov    (%eax),%eax
  802a0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a12:	8b 52 04             	mov    0x4(%edx),%edx
  802a15:	89 50 04             	mov    %edx,0x4(%eax)
  802a18:	eb 0b                	jmp    802a25 <alloc_block_NF+0x45c>
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 40 04             	mov    0x4(%eax),%eax
  802a20:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	74 0f                	je     802a3e <alloc_block_NF+0x475>
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 40 04             	mov    0x4(%eax),%eax
  802a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a38:	8b 12                	mov    (%edx),%edx
  802a3a:	89 10                	mov    %edx,(%eax)
  802a3c:	eb 0a                	jmp    802a48 <alloc_block_NF+0x47f>
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	a3 38 41 80 00       	mov    %eax,0x804138
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a60:	48                   	dec    %eax
  802a61:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 40 08             	mov    0x8(%eax),%eax
  802a6c:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	e9 1b 01 00 00       	jmp    802b94 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a82:	0f 86 d1 00 00 00    	jbe    802b59 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a88:	a1 48 41 80 00       	mov    0x804148,%eax
  802a8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 50 08             	mov    0x8(%eax),%edx
  802a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a99:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aa5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aa9:	75 17                	jne    802ac2 <alloc_block_NF+0x4f9>
  802aab:	83 ec 04             	sub    $0x4,%esp
  802aae:	68 c0 3e 80 00       	push   $0x803ec0
  802ab3:	68 1c 01 00 00       	push   $0x11c
  802ab8:	68 17 3e 80 00       	push   $0x803e17
  802abd:	e8 d4 08 00 00       	call   803396 <_panic>
  802ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	74 10                	je     802adb <alloc_block_NF+0x512>
  802acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad3:	8b 52 04             	mov    0x4(%edx),%edx
  802ad6:	89 50 04             	mov    %edx,0x4(%eax)
  802ad9:	eb 0b                	jmp    802ae6 <alloc_block_NF+0x51d>
  802adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ade:	8b 40 04             	mov    0x4(%eax),%eax
  802ae1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae9:	8b 40 04             	mov    0x4(%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	74 0f                	je     802aff <alloc_block_NF+0x536>
  802af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af3:	8b 40 04             	mov    0x4(%eax),%eax
  802af6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af9:	8b 12                	mov    (%edx),%edx
  802afb:	89 10                	mov    %edx,(%eax)
  802afd:	eb 0a                	jmp    802b09 <alloc_block_NF+0x540>
  802aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	a3 48 41 80 00       	mov    %eax,0x804148
  802b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1c:	a1 54 41 80 00       	mov    0x804154,%eax
  802b21:	48                   	dec    %eax
  802b22:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2a:	8b 40 08             	mov    0x8(%eax),%eax
  802b2d:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 50 08             	mov    0x8(%eax),%edx
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	01 c2                	add    %eax,%edx
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 40 0c             	mov    0xc(%eax),%eax
  802b49:	2b 45 08             	sub    0x8(%ebp),%eax
  802b4c:	89 c2                	mov    %eax,%edx
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b57:	eb 3b                	jmp    802b94 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b59:	a1 40 41 80 00       	mov    0x804140,%eax
  802b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b65:	74 07                	je     802b6e <alloc_block_NF+0x5a5>
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 00                	mov    (%eax),%eax
  802b6c:	eb 05                	jmp    802b73 <alloc_block_NF+0x5aa>
  802b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b73:	a3 40 41 80 00       	mov    %eax,0x804140
  802b78:	a1 40 41 80 00       	mov    0x804140,%eax
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	0f 85 2e fe ff ff    	jne    8029b3 <alloc_block_NF+0x3ea>
  802b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b89:	0f 85 24 fe ff ff    	jne    8029b3 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b94:	c9                   	leave  
  802b95:	c3                   	ret    

00802b96 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b96:	55                   	push   %ebp
  802b97:	89 e5                	mov    %esp,%ebp
  802b99:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b9c:	a1 38 41 80 00       	mov    0x804138,%eax
  802ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ba4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ba9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bac:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	74 14                	je     802bc9 <insert_sorted_with_merge_freeList+0x33>
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	8b 50 08             	mov    0x8(%eax),%edx
  802bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbe:	8b 40 08             	mov    0x8(%eax),%eax
  802bc1:	39 c2                	cmp    %eax,%edx
  802bc3:	0f 87 9b 01 00 00    	ja     802d64 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bcd:	75 17                	jne    802be6 <insert_sorted_with_merge_freeList+0x50>
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	68 f4 3d 80 00       	push   $0x803df4
  802bd7:	68 38 01 00 00       	push   $0x138
  802bdc:	68 17 3e 80 00       	push   $0x803e17
  802be1:	e8 b0 07 00 00       	call   803396 <_panic>
  802be6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	89 10                	mov    %edx,(%eax)
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	8b 00                	mov    (%eax),%eax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	74 0d                	je     802c07 <insert_sorted_with_merge_freeList+0x71>
  802bfa:	a1 38 41 80 00       	mov    0x804138,%eax
  802bff:	8b 55 08             	mov    0x8(%ebp),%edx
  802c02:	89 50 04             	mov    %edx,0x4(%eax)
  802c05:	eb 08                	jmp    802c0f <insert_sorted_with_merge_freeList+0x79>
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	a3 38 41 80 00       	mov    %eax,0x804138
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c21:	a1 44 41 80 00       	mov    0x804144,%eax
  802c26:	40                   	inc    %eax
  802c27:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c30:	0f 84 a8 06 00 00    	je     8032de <insert_sorted_with_merge_freeList+0x748>
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	8b 50 08             	mov    0x8(%eax),%edx
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c42:	01 c2                	add    %eax,%edx
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	8b 40 08             	mov    0x8(%eax),%eax
  802c4a:	39 c2                	cmp    %eax,%edx
  802c4c:	0f 85 8c 06 00 00    	jne    8032de <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	8b 50 0c             	mov    0xc(%eax),%edx
  802c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5e:	01 c2                	add    %eax,%edx
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c6a:	75 17                	jne    802c83 <insert_sorted_with_merge_freeList+0xed>
  802c6c:	83 ec 04             	sub    $0x4,%esp
  802c6f:	68 c0 3e 80 00       	push   $0x803ec0
  802c74:	68 3c 01 00 00       	push   $0x13c
  802c79:	68 17 3e 80 00       	push   $0x803e17
  802c7e:	e8 13 07 00 00       	call   803396 <_panic>
  802c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c86:	8b 00                	mov    (%eax),%eax
  802c88:	85 c0                	test   %eax,%eax
  802c8a:	74 10                	je     802c9c <insert_sorted_with_merge_freeList+0x106>
  802c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8f:	8b 00                	mov    (%eax),%eax
  802c91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c94:	8b 52 04             	mov    0x4(%edx),%edx
  802c97:	89 50 04             	mov    %edx,0x4(%eax)
  802c9a:	eb 0b                	jmp    802ca7 <insert_sorted_with_merge_freeList+0x111>
  802c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ca2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caa:	8b 40 04             	mov    0x4(%eax),%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	74 0f                	je     802cc0 <insert_sorted_with_merge_freeList+0x12a>
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cba:	8b 12                	mov    (%edx),%edx
  802cbc:	89 10                	mov    %edx,(%eax)
  802cbe:	eb 0a                	jmp    802cca <insert_sorted_with_merge_freeList+0x134>
  802cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	a3 38 41 80 00       	mov    %eax,0x804138
  802cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cdd:	a1 44 41 80 00       	mov    0x804144,%eax
  802ce2:	48                   	dec    %eax
  802ce3:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ceb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802cfc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d00:	75 17                	jne    802d19 <insert_sorted_with_merge_freeList+0x183>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 f4 3d 80 00       	push   $0x803df4
  802d0a:	68 3f 01 00 00       	push   $0x13f
  802d0f:	68 17 3e 80 00       	push   $0x803e17
  802d14:	e8 7d 06 00 00       	call   803396 <_panic>
  802d19:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d22:	89 10                	mov    %edx,(%eax)
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 0d                	je     802d3a <insert_sorted_with_merge_freeList+0x1a4>
  802d2d:	a1 48 41 80 00       	mov    0x804148,%eax
  802d32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	eb 08                	jmp    802d42 <insert_sorted_with_merge_freeList+0x1ac>
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	a3 48 41 80 00       	mov    %eax,0x804148
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d54:	a1 54 41 80 00       	mov    0x804154,%eax
  802d59:	40                   	inc    %eax
  802d5a:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d5f:	e9 7a 05 00 00       	jmp    8032de <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	8b 50 08             	mov    0x8(%eax),%edx
  802d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6d:	8b 40 08             	mov    0x8(%eax),%eax
  802d70:	39 c2                	cmp    %eax,%edx
  802d72:	0f 82 14 01 00 00    	jb     802e8c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7b:	8b 50 08             	mov    0x8(%eax),%edx
  802d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d81:	8b 40 0c             	mov    0xc(%eax),%eax
  802d84:	01 c2                	add    %eax,%edx
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	8b 40 08             	mov    0x8(%eax),%eax
  802d8c:	39 c2                	cmp    %eax,%edx
  802d8e:	0f 85 90 00 00 00    	jne    802e24 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d97:	8b 50 0c             	mov    0xc(%eax),%edx
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802da0:	01 c2                	add    %eax,%edx
  802da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da5:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc0:	75 17                	jne    802dd9 <insert_sorted_with_merge_freeList+0x243>
  802dc2:	83 ec 04             	sub    $0x4,%esp
  802dc5:	68 f4 3d 80 00       	push   $0x803df4
  802dca:	68 49 01 00 00       	push   $0x149
  802dcf:	68 17 3e 80 00       	push   $0x803e17
  802dd4:	e8 bd 05 00 00       	call   803396 <_panic>
  802dd9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	89 10                	mov    %edx,(%eax)
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	8b 00                	mov    (%eax),%eax
  802de9:	85 c0                	test   %eax,%eax
  802deb:	74 0d                	je     802dfa <insert_sorted_with_merge_freeList+0x264>
  802ded:	a1 48 41 80 00       	mov    0x804148,%eax
  802df2:	8b 55 08             	mov    0x8(%ebp),%edx
  802df5:	89 50 04             	mov    %edx,0x4(%eax)
  802df8:	eb 08                	jmp    802e02 <insert_sorted_with_merge_freeList+0x26c>
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	a3 48 41 80 00       	mov    %eax,0x804148
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e14:	a1 54 41 80 00       	mov    0x804154,%eax
  802e19:	40                   	inc    %eax
  802e1a:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e1f:	e9 bb 04 00 00       	jmp    8032df <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e28:	75 17                	jne    802e41 <insert_sorted_with_merge_freeList+0x2ab>
  802e2a:	83 ec 04             	sub    $0x4,%esp
  802e2d:	68 68 3e 80 00       	push   $0x803e68
  802e32:	68 4c 01 00 00       	push   $0x14c
  802e37:	68 17 3e 80 00       	push   $0x803e17
  802e3c:	e8 55 05 00 00       	call   803396 <_panic>
  802e41:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	89 50 04             	mov    %edx,0x4(%eax)
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	8b 40 04             	mov    0x4(%eax),%eax
  802e53:	85 c0                	test   %eax,%eax
  802e55:	74 0c                	je     802e63 <insert_sorted_with_merge_freeList+0x2cd>
  802e57:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5f:	89 10                	mov    %edx,(%eax)
  802e61:	eb 08                	jmp    802e6b <insert_sorted_with_merge_freeList+0x2d5>
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	a3 38 41 80 00       	mov    %eax,0x804138
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7c:	a1 44 41 80 00       	mov    0x804144,%eax
  802e81:	40                   	inc    %eax
  802e82:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e87:	e9 53 04 00 00       	jmp    8032df <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e8c:	a1 38 41 80 00       	mov    0x804138,%eax
  802e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e94:	e9 15 04 00 00       	jmp    8032ae <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	8b 00                	mov    (%eax),%eax
  802e9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	8b 50 08             	mov    0x8(%eax),%edx
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 40 08             	mov    0x8(%eax),%eax
  802ead:	39 c2                	cmp    %eax,%edx
  802eaf:	0f 86 f1 03 00 00    	jbe    8032a6 <insert_sorted_with_merge_freeList+0x710>
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	8b 50 08             	mov    0x8(%eax),%edx
  802ebb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebe:	8b 40 08             	mov    0x8(%eax),%eax
  802ec1:	39 c2                	cmp    %eax,%edx
  802ec3:	0f 83 dd 03 00 00    	jae    8032a6 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 50 08             	mov    0x8(%eax),%edx
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed5:	01 c2                	add    %eax,%edx
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	8b 40 08             	mov    0x8(%eax),%eax
  802edd:	39 c2                	cmp    %eax,%edx
  802edf:	0f 85 b9 01 00 00    	jne    80309e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	8b 50 08             	mov    0x8(%eax),%edx
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef1:	01 c2                	add    %eax,%edx
  802ef3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef6:	8b 40 08             	mov    0x8(%eax),%eax
  802ef9:	39 c2                	cmp    %eax,%edx
  802efb:	0f 85 0d 01 00 00    	jne    80300e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 50 0c             	mov    0xc(%eax),%edx
  802f07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0d:	01 c2                	add    %eax,%edx
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f15:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f19:	75 17                	jne    802f32 <insert_sorted_with_merge_freeList+0x39c>
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	68 c0 3e 80 00       	push   $0x803ec0
  802f23:	68 5c 01 00 00       	push   $0x15c
  802f28:	68 17 3e 80 00       	push   $0x803e17
  802f2d:	e8 64 04 00 00       	call   803396 <_panic>
  802f32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f35:	8b 00                	mov    (%eax),%eax
  802f37:	85 c0                	test   %eax,%eax
  802f39:	74 10                	je     802f4b <insert_sorted_with_merge_freeList+0x3b5>
  802f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f43:	8b 52 04             	mov    0x4(%edx),%edx
  802f46:	89 50 04             	mov    %edx,0x4(%eax)
  802f49:	eb 0b                	jmp    802f56 <insert_sorted_with_merge_freeList+0x3c0>
  802f4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4e:	8b 40 04             	mov    0x4(%eax),%eax
  802f51:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f59:	8b 40 04             	mov    0x4(%eax),%eax
  802f5c:	85 c0                	test   %eax,%eax
  802f5e:	74 0f                	je     802f6f <insert_sorted_with_merge_freeList+0x3d9>
  802f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f63:	8b 40 04             	mov    0x4(%eax),%eax
  802f66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f69:	8b 12                	mov    (%edx),%edx
  802f6b:	89 10                	mov    %edx,(%eax)
  802f6d:	eb 0a                	jmp    802f79 <insert_sorted_with_merge_freeList+0x3e3>
  802f6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	a3 38 41 80 00       	mov    %eax,0x804138
  802f79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8c:	a1 44 41 80 00       	mov    0x804144,%eax
  802f91:	48                   	dec    %eax
  802f92:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802f97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802faf:	75 17                	jne    802fc8 <insert_sorted_with_merge_freeList+0x432>
  802fb1:	83 ec 04             	sub    $0x4,%esp
  802fb4:	68 f4 3d 80 00       	push   $0x803df4
  802fb9:	68 5f 01 00 00       	push   $0x15f
  802fbe:	68 17 3e 80 00       	push   $0x803e17
  802fc3:	e8 ce 03 00 00       	call   803396 <_panic>
  802fc8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd1:	89 10                	mov    %edx,(%eax)
  802fd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 0d                	je     802fe9 <insert_sorted_with_merge_freeList+0x453>
  802fdc:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe4:	89 50 04             	mov    %edx,0x4(%eax)
  802fe7:	eb 08                	jmp    802ff1 <insert_sorted_with_merge_freeList+0x45b>
  802fe9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff4:	a3 48 41 80 00       	mov    %eax,0x804148
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803003:	a1 54 41 80 00       	mov    0x804154,%eax
  803008:	40                   	inc    %eax
  803009:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 50 0c             	mov    0xc(%eax),%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	8b 40 0c             	mov    0xc(%eax),%eax
  80301a:	01 c2                	add    %eax,%edx
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803036:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303a:	75 17                	jne    803053 <insert_sorted_with_merge_freeList+0x4bd>
  80303c:	83 ec 04             	sub    $0x4,%esp
  80303f:	68 f4 3d 80 00       	push   $0x803df4
  803044:	68 64 01 00 00       	push   $0x164
  803049:	68 17 3e 80 00       	push   $0x803e17
  80304e:	e8 43 03 00 00       	call   803396 <_panic>
  803053:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	89 10                	mov    %edx,(%eax)
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	85 c0                	test   %eax,%eax
  803065:	74 0d                	je     803074 <insert_sorted_with_merge_freeList+0x4de>
  803067:	a1 48 41 80 00       	mov    0x804148,%eax
  80306c:	8b 55 08             	mov    0x8(%ebp),%edx
  80306f:	89 50 04             	mov    %edx,0x4(%eax)
  803072:	eb 08                	jmp    80307c <insert_sorted_with_merge_freeList+0x4e6>
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	a3 48 41 80 00       	mov    %eax,0x804148
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308e:	a1 54 41 80 00       	mov    0x804154,%eax
  803093:	40                   	inc    %eax
  803094:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803099:	e9 41 02 00 00       	jmp    8032df <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	8b 50 08             	mov    0x8(%eax),%edx
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030aa:	01 c2                	add    %eax,%edx
  8030ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030af:	8b 40 08             	mov    0x8(%eax),%eax
  8030b2:	39 c2                	cmp    %eax,%edx
  8030b4:	0f 85 7c 01 00 00    	jne    803236 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030be:	74 06                	je     8030c6 <insert_sorted_with_merge_freeList+0x530>
  8030c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c4:	75 17                	jne    8030dd <insert_sorted_with_merge_freeList+0x547>
  8030c6:	83 ec 04             	sub    $0x4,%esp
  8030c9:	68 30 3e 80 00       	push   $0x803e30
  8030ce:	68 69 01 00 00       	push   $0x169
  8030d3:	68 17 3e 80 00       	push   $0x803e17
  8030d8:	e8 b9 02 00 00       	call   803396 <_panic>
  8030dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e0:	8b 50 04             	mov    0x4(%eax),%edx
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	89 50 04             	mov    %edx,0x4(%eax)
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ef:	89 10                	mov    %edx,(%eax)
  8030f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f4:	8b 40 04             	mov    0x4(%eax),%eax
  8030f7:	85 c0                	test   %eax,%eax
  8030f9:	74 0d                	je     803108 <insert_sorted_with_merge_freeList+0x572>
  8030fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fe:	8b 40 04             	mov    0x4(%eax),%eax
  803101:	8b 55 08             	mov    0x8(%ebp),%edx
  803104:	89 10                	mov    %edx,(%eax)
  803106:	eb 08                	jmp    803110 <insert_sorted_with_merge_freeList+0x57a>
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	a3 38 41 80 00       	mov    %eax,0x804138
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	8b 55 08             	mov    0x8(%ebp),%edx
  803116:	89 50 04             	mov    %edx,0x4(%eax)
  803119:	a1 44 41 80 00       	mov    0x804144,%eax
  80311e:	40                   	inc    %eax
  80311f:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	8b 50 0c             	mov    0xc(%eax),%edx
  80312a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312d:	8b 40 0c             	mov    0xc(%eax),%eax
  803130:	01 c2                	add    %eax,%edx
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803138:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80313c:	75 17                	jne    803155 <insert_sorted_with_merge_freeList+0x5bf>
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	68 c0 3e 80 00       	push   $0x803ec0
  803146:	68 6b 01 00 00       	push   $0x16b
  80314b:	68 17 3e 80 00       	push   $0x803e17
  803150:	e8 41 02 00 00       	call   803396 <_panic>
  803155:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	85 c0                	test   %eax,%eax
  80315c:	74 10                	je     80316e <insert_sorted_with_merge_freeList+0x5d8>
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803166:	8b 52 04             	mov    0x4(%edx),%edx
  803169:	89 50 04             	mov    %edx,0x4(%eax)
  80316c:	eb 0b                	jmp    803179 <insert_sorted_with_merge_freeList+0x5e3>
  80316e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803171:	8b 40 04             	mov    0x4(%eax),%eax
  803174:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803179:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317c:	8b 40 04             	mov    0x4(%eax),%eax
  80317f:	85 c0                	test   %eax,%eax
  803181:	74 0f                	je     803192 <insert_sorted_with_merge_freeList+0x5fc>
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	8b 40 04             	mov    0x4(%eax),%eax
  803189:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318c:	8b 12                	mov    (%edx),%edx
  80318e:	89 10                	mov    %edx,(%eax)
  803190:	eb 0a                	jmp    80319c <insert_sorted_with_merge_freeList+0x606>
  803192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	a3 38 41 80 00       	mov    %eax,0x804138
  80319c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031af:	a1 44 41 80 00       	mov    0x804144,%eax
  8031b4:	48                   	dec    %eax
  8031b5:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8031ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031d2:	75 17                	jne    8031eb <insert_sorted_with_merge_freeList+0x655>
  8031d4:	83 ec 04             	sub    $0x4,%esp
  8031d7:	68 f4 3d 80 00       	push   $0x803df4
  8031dc:	68 6e 01 00 00       	push   $0x16e
  8031e1:	68 17 3e 80 00       	push   $0x803e17
  8031e6:	e8 ab 01 00 00       	call   803396 <_panic>
  8031eb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f4:	89 10                	mov    %edx,(%eax)
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	85 c0                	test   %eax,%eax
  8031fd:	74 0d                	je     80320c <insert_sorted_with_merge_freeList+0x676>
  8031ff:	a1 48 41 80 00       	mov    0x804148,%eax
  803204:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803207:	89 50 04             	mov    %edx,0x4(%eax)
  80320a:	eb 08                	jmp    803214 <insert_sorted_with_merge_freeList+0x67e>
  80320c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803217:	a3 48 41 80 00       	mov    %eax,0x804148
  80321c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803226:	a1 54 41 80 00       	mov    0x804154,%eax
  80322b:	40                   	inc    %eax
  80322c:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803231:	e9 a9 00 00 00       	jmp    8032df <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323a:	74 06                	je     803242 <insert_sorted_with_merge_freeList+0x6ac>
  80323c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803240:	75 17                	jne    803259 <insert_sorted_with_merge_freeList+0x6c3>
  803242:	83 ec 04             	sub    $0x4,%esp
  803245:	68 8c 3e 80 00       	push   $0x803e8c
  80324a:	68 73 01 00 00       	push   $0x173
  80324f:	68 17 3e 80 00       	push   $0x803e17
  803254:	e8 3d 01 00 00       	call   803396 <_panic>
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	8b 10                	mov    (%eax),%edx
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	89 10                	mov    %edx,(%eax)
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	8b 00                	mov    (%eax),%eax
  803268:	85 c0                	test   %eax,%eax
  80326a:	74 0b                	je     803277 <insert_sorted_with_merge_freeList+0x6e1>
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	8b 00                	mov    (%eax),%eax
  803271:	8b 55 08             	mov    0x8(%ebp),%edx
  803274:	89 50 04             	mov    %edx,0x4(%eax)
  803277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327a:	8b 55 08             	mov    0x8(%ebp),%edx
  80327d:	89 10                	mov    %edx,(%eax)
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803285:	89 50 04             	mov    %edx,0x4(%eax)
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	75 08                	jne    803299 <insert_sorted_with_merge_freeList+0x703>
  803291:	8b 45 08             	mov    0x8(%ebp),%eax
  803294:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803299:	a1 44 41 80 00       	mov    0x804144,%eax
  80329e:	40                   	inc    %eax
  80329f:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032a4:	eb 39                	jmp    8032df <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032a6:	a1 40 41 80 00       	mov    0x804140,%eax
  8032ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b2:	74 07                	je     8032bb <insert_sorted_with_merge_freeList+0x725>
  8032b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	eb 05                	jmp    8032c0 <insert_sorted_with_merge_freeList+0x72a>
  8032bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c0:	a3 40 41 80 00       	mov    %eax,0x804140
  8032c5:	a1 40 41 80 00       	mov    0x804140,%eax
  8032ca:	85 c0                	test   %eax,%eax
  8032cc:	0f 85 c7 fb ff ff    	jne    802e99 <insert_sorted_with_merge_freeList+0x303>
  8032d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d6:	0f 85 bd fb ff ff    	jne    802e99 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032dc:	eb 01                	jmp    8032df <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032de:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032df:	90                   	nop
  8032e0:	c9                   	leave  
  8032e1:	c3                   	ret    

008032e2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032e2:	55                   	push   %ebp
  8032e3:	89 e5                	mov    %esp,%ebp
  8032e5:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032eb:	89 d0                	mov    %edx,%eax
  8032ed:	c1 e0 02             	shl    $0x2,%eax
  8032f0:	01 d0                	add    %edx,%eax
  8032f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032f9:	01 d0                	add    %edx,%eax
  8032fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803302:	01 d0                	add    %edx,%eax
  803304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80330b:	01 d0                	add    %edx,%eax
  80330d:	c1 e0 04             	shl    $0x4,%eax
  803310:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803313:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80331a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80331d:	83 ec 0c             	sub    $0xc,%esp
  803320:	50                   	push   %eax
  803321:	e8 26 e7 ff ff       	call   801a4c <sys_get_virtual_time>
  803326:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803329:	eb 41                	jmp    80336c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80332b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80332e:	83 ec 0c             	sub    $0xc,%esp
  803331:	50                   	push   %eax
  803332:	e8 15 e7 ff ff       	call   801a4c <sys_get_virtual_time>
  803337:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80333a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80333d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803340:	29 c2                	sub    %eax,%edx
  803342:	89 d0                	mov    %edx,%eax
  803344:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803347:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80334a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334d:	89 d1                	mov    %edx,%ecx
  80334f:	29 c1                	sub    %eax,%ecx
  803351:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803354:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803357:	39 c2                	cmp    %eax,%edx
  803359:	0f 97 c0             	seta   %al
  80335c:	0f b6 c0             	movzbl %al,%eax
  80335f:	29 c1                	sub    %eax,%ecx
  803361:	89 c8                	mov    %ecx,%eax
  803363:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803366:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803369:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803372:	72 b7                	jb     80332b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803374:	90                   	nop
  803375:	c9                   	leave  
  803376:	c3                   	ret    

00803377 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803377:	55                   	push   %ebp
  803378:	89 e5                	mov    %esp,%ebp
  80337a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80337d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803384:	eb 03                	jmp    803389 <busy_wait+0x12>
  803386:	ff 45 fc             	incl   -0x4(%ebp)
  803389:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80338c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80338f:	72 f5                	jb     803386 <busy_wait+0xf>
	return i;
  803391:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803394:	c9                   	leave  
  803395:	c3                   	ret    

00803396 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803396:	55                   	push   %ebp
  803397:	89 e5                	mov    %esp,%ebp
  803399:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80339c:	8d 45 10             	lea    0x10(%ebp),%eax
  80339f:	83 c0 04             	add    $0x4,%eax
  8033a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8033a5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8033aa:	85 c0                	test   %eax,%eax
  8033ac:	74 16                	je     8033c4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8033ae:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8033b3:	83 ec 08             	sub    $0x8,%esp
  8033b6:	50                   	push   %eax
  8033b7:	68 e0 3e 80 00       	push   $0x803ee0
  8033bc:	e8 ba cf ff ff       	call   80037b <cprintf>
  8033c1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8033c4:	a1 00 40 80 00       	mov    0x804000,%eax
  8033c9:	ff 75 0c             	pushl  0xc(%ebp)
  8033cc:	ff 75 08             	pushl  0x8(%ebp)
  8033cf:	50                   	push   %eax
  8033d0:	68 e5 3e 80 00       	push   $0x803ee5
  8033d5:	e8 a1 cf ff ff       	call   80037b <cprintf>
  8033da:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8033dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8033e0:	83 ec 08             	sub    $0x8,%esp
  8033e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8033e6:	50                   	push   %eax
  8033e7:	e8 24 cf ff ff       	call   800310 <vcprintf>
  8033ec:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8033ef:	83 ec 08             	sub    $0x8,%esp
  8033f2:	6a 00                	push   $0x0
  8033f4:	68 01 3f 80 00       	push   $0x803f01
  8033f9:	e8 12 cf ff ff       	call   800310 <vcprintf>
  8033fe:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803401:	e8 93 ce ff ff       	call   800299 <exit>

	// should not return here
	while (1) ;
  803406:	eb fe                	jmp    803406 <_panic+0x70>

00803408 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803408:	55                   	push   %ebp
  803409:	89 e5                	mov    %esp,%ebp
  80340b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80340e:	a1 20 40 80 00       	mov    0x804020,%eax
  803413:	8b 50 74             	mov    0x74(%eax),%edx
  803416:	8b 45 0c             	mov    0xc(%ebp),%eax
  803419:	39 c2                	cmp    %eax,%edx
  80341b:	74 14                	je     803431 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80341d:	83 ec 04             	sub    $0x4,%esp
  803420:	68 04 3f 80 00       	push   $0x803f04
  803425:	6a 26                	push   $0x26
  803427:	68 50 3f 80 00       	push   $0x803f50
  80342c:	e8 65 ff ff ff       	call   803396 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803431:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803438:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80343f:	e9 c2 00 00 00       	jmp    803506 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	01 d0                	add    %edx,%eax
  803453:	8b 00                	mov    (%eax),%eax
  803455:	85 c0                	test   %eax,%eax
  803457:	75 08                	jne    803461 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803459:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80345c:	e9 a2 00 00 00       	jmp    803503 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803461:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803468:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80346f:	eb 69                	jmp    8034da <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803471:	a1 20 40 80 00       	mov    0x804020,%eax
  803476:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80347c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80347f:	89 d0                	mov    %edx,%eax
  803481:	01 c0                	add    %eax,%eax
  803483:	01 d0                	add    %edx,%eax
  803485:	c1 e0 03             	shl    $0x3,%eax
  803488:	01 c8                	add    %ecx,%eax
  80348a:	8a 40 04             	mov    0x4(%eax),%al
  80348d:	84 c0                	test   %al,%al
  80348f:	75 46                	jne    8034d7 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803491:	a1 20 40 80 00       	mov    0x804020,%eax
  803496:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80349c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80349f:	89 d0                	mov    %edx,%eax
  8034a1:	01 c0                	add    %eax,%eax
  8034a3:	01 d0                	add    %edx,%eax
  8034a5:	c1 e0 03             	shl    $0x3,%eax
  8034a8:	01 c8                	add    %ecx,%eax
  8034aa:	8b 00                	mov    (%eax),%eax
  8034ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8034af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8034b7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8034b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8034c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c6:	01 c8                	add    %ecx,%eax
  8034c8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8034ca:	39 c2                	cmp    %eax,%edx
  8034cc:	75 09                	jne    8034d7 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8034ce:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8034d5:	eb 12                	jmp    8034e9 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034d7:	ff 45 e8             	incl   -0x18(%ebp)
  8034da:	a1 20 40 80 00       	mov    0x804020,%eax
  8034df:	8b 50 74             	mov    0x74(%eax),%edx
  8034e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e5:	39 c2                	cmp    %eax,%edx
  8034e7:	77 88                	ja     803471 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8034e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034ed:	75 14                	jne    803503 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8034ef:	83 ec 04             	sub    $0x4,%esp
  8034f2:	68 5c 3f 80 00       	push   $0x803f5c
  8034f7:	6a 3a                	push   $0x3a
  8034f9:	68 50 3f 80 00       	push   $0x803f50
  8034fe:	e8 93 fe ff ff       	call   803396 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803503:	ff 45 f0             	incl   -0x10(%ebp)
  803506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803509:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80350c:	0f 8c 32 ff ff ff    	jl     803444 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803512:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803519:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803520:	eb 26                	jmp    803548 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803522:	a1 20 40 80 00       	mov    0x804020,%eax
  803527:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80352d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803530:	89 d0                	mov    %edx,%eax
  803532:	01 c0                	add    %eax,%eax
  803534:	01 d0                	add    %edx,%eax
  803536:	c1 e0 03             	shl    $0x3,%eax
  803539:	01 c8                	add    %ecx,%eax
  80353b:	8a 40 04             	mov    0x4(%eax),%al
  80353e:	3c 01                	cmp    $0x1,%al
  803540:	75 03                	jne    803545 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803542:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803545:	ff 45 e0             	incl   -0x20(%ebp)
  803548:	a1 20 40 80 00       	mov    0x804020,%eax
  80354d:	8b 50 74             	mov    0x74(%eax),%edx
  803550:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803553:	39 c2                	cmp    %eax,%edx
  803555:	77 cb                	ja     803522 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80355d:	74 14                	je     803573 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80355f:	83 ec 04             	sub    $0x4,%esp
  803562:	68 b0 3f 80 00       	push   $0x803fb0
  803567:	6a 44                	push   $0x44
  803569:	68 50 3f 80 00       	push   $0x803f50
  80356e:	e8 23 fe ff ff       	call   803396 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803573:	90                   	nop
  803574:	c9                   	leave  
  803575:	c3                   	ret    
  803576:	66 90                	xchg   %ax,%ax

00803578 <__udivdi3>:
  803578:	55                   	push   %ebp
  803579:	57                   	push   %edi
  80357a:	56                   	push   %esi
  80357b:	53                   	push   %ebx
  80357c:	83 ec 1c             	sub    $0x1c,%esp
  80357f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803583:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803587:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80358b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80358f:	89 ca                	mov    %ecx,%edx
  803591:	89 f8                	mov    %edi,%eax
  803593:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803597:	85 f6                	test   %esi,%esi
  803599:	75 2d                	jne    8035c8 <__udivdi3+0x50>
  80359b:	39 cf                	cmp    %ecx,%edi
  80359d:	77 65                	ja     803604 <__udivdi3+0x8c>
  80359f:	89 fd                	mov    %edi,%ebp
  8035a1:	85 ff                	test   %edi,%edi
  8035a3:	75 0b                	jne    8035b0 <__udivdi3+0x38>
  8035a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8035aa:	31 d2                	xor    %edx,%edx
  8035ac:	f7 f7                	div    %edi
  8035ae:	89 c5                	mov    %eax,%ebp
  8035b0:	31 d2                	xor    %edx,%edx
  8035b2:	89 c8                	mov    %ecx,%eax
  8035b4:	f7 f5                	div    %ebp
  8035b6:	89 c1                	mov    %eax,%ecx
  8035b8:	89 d8                	mov    %ebx,%eax
  8035ba:	f7 f5                	div    %ebp
  8035bc:	89 cf                	mov    %ecx,%edi
  8035be:	89 fa                	mov    %edi,%edx
  8035c0:	83 c4 1c             	add    $0x1c,%esp
  8035c3:	5b                   	pop    %ebx
  8035c4:	5e                   	pop    %esi
  8035c5:	5f                   	pop    %edi
  8035c6:	5d                   	pop    %ebp
  8035c7:	c3                   	ret    
  8035c8:	39 ce                	cmp    %ecx,%esi
  8035ca:	77 28                	ja     8035f4 <__udivdi3+0x7c>
  8035cc:	0f bd fe             	bsr    %esi,%edi
  8035cf:	83 f7 1f             	xor    $0x1f,%edi
  8035d2:	75 40                	jne    803614 <__udivdi3+0x9c>
  8035d4:	39 ce                	cmp    %ecx,%esi
  8035d6:	72 0a                	jb     8035e2 <__udivdi3+0x6a>
  8035d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035dc:	0f 87 9e 00 00 00    	ja     803680 <__udivdi3+0x108>
  8035e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035e7:	89 fa                	mov    %edi,%edx
  8035e9:	83 c4 1c             	add    $0x1c,%esp
  8035ec:	5b                   	pop    %ebx
  8035ed:	5e                   	pop    %esi
  8035ee:	5f                   	pop    %edi
  8035ef:	5d                   	pop    %ebp
  8035f0:	c3                   	ret    
  8035f1:	8d 76 00             	lea    0x0(%esi),%esi
  8035f4:	31 ff                	xor    %edi,%edi
  8035f6:	31 c0                	xor    %eax,%eax
  8035f8:	89 fa                	mov    %edi,%edx
  8035fa:	83 c4 1c             	add    $0x1c,%esp
  8035fd:	5b                   	pop    %ebx
  8035fe:	5e                   	pop    %esi
  8035ff:	5f                   	pop    %edi
  803600:	5d                   	pop    %ebp
  803601:	c3                   	ret    
  803602:	66 90                	xchg   %ax,%ax
  803604:	89 d8                	mov    %ebx,%eax
  803606:	f7 f7                	div    %edi
  803608:	31 ff                	xor    %edi,%edi
  80360a:	89 fa                	mov    %edi,%edx
  80360c:	83 c4 1c             	add    $0x1c,%esp
  80360f:	5b                   	pop    %ebx
  803610:	5e                   	pop    %esi
  803611:	5f                   	pop    %edi
  803612:	5d                   	pop    %ebp
  803613:	c3                   	ret    
  803614:	bd 20 00 00 00       	mov    $0x20,%ebp
  803619:	89 eb                	mov    %ebp,%ebx
  80361b:	29 fb                	sub    %edi,%ebx
  80361d:	89 f9                	mov    %edi,%ecx
  80361f:	d3 e6                	shl    %cl,%esi
  803621:	89 c5                	mov    %eax,%ebp
  803623:	88 d9                	mov    %bl,%cl
  803625:	d3 ed                	shr    %cl,%ebp
  803627:	89 e9                	mov    %ebp,%ecx
  803629:	09 f1                	or     %esi,%ecx
  80362b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80362f:	89 f9                	mov    %edi,%ecx
  803631:	d3 e0                	shl    %cl,%eax
  803633:	89 c5                	mov    %eax,%ebp
  803635:	89 d6                	mov    %edx,%esi
  803637:	88 d9                	mov    %bl,%cl
  803639:	d3 ee                	shr    %cl,%esi
  80363b:	89 f9                	mov    %edi,%ecx
  80363d:	d3 e2                	shl    %cl,%edx
  80363f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803643:	88 d9                	mov    %bl,%cl
  803645:	d3 e8                	shr    %cl,%eax
  803647:	09 c2                	or     %eax,%edx
  803649:	89 d0                	mov    %edx,%eax
  80364b:	89 f2                	mov    %esi,%edx
  80364d:	f7 74 24 0c          	divl   0xc(%esp)
  803651:	89 d6                	mov    %edx,%esi
  803653:	89 c3                	mov    %eax,%ebx
  803655:	f7 e5                	mul    %ebp
  803657:	39 d6                	cmp    %edx,%esi
  803659:	72 19                	jb     803674 <__udivdi3+0xfc>
  80365b:	74 0b                	je     803668 <__udivdi3+0xf0>
  80365d:	89 d8                	mov    %ebx,%eax
  80365f:	31 ff                	xor    %edi,%edi
  803661:	e9 58 ff ff ff       	jmp    8035be <__udivdi3+0x46>
  803666:	66 90                	xchg   %ax,%ax
  803668:	8b 54 24 08          	mov    0x8(%esp),%edx
  80366c:	89 f9                	mov    %edi,%ecx
  80366e:	d3 e2                	shl    %cl,%edx
  803670:	39 c2                	cmp    %eax,%edx
  803672:	73 e9                	jae    80365d <__udivdi3+0xe5>
  803674:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803677:	31 ff                	xor    %edi,%edi
  803679:	e9 40 ff ff ff       	jmp    8035be <__udivdi3+0x46>
  80367e:	66 90                	xchg   %ax,%ax
  803680:	31 c0                	xor    %eax,%eax
  803682:	e9 37 ff ff ff       	jmp    8035be <__udivdi3+0x46>
  803687:	90                   	nop

00803688 <__umoddi3>:
  803688:	55                   	push   %ebp
  803689:	57                   	push   %edi
  80368a:	56                   	push   %esi
  80368b:	53                   	push   %ebx
  80368c:	83 ec 1c             	sub    $0x1c,%esp
  80368f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803693:	8b 74 24 34          	mov    0x34(%esp),%esi
  803697:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80369b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80369f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036a7:	89 f3                	mov    %esi,%ebx
  8036a9:	89 fa                	mov    %edi,%edx
  8036ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036af:	89 34 24             	mov    %esi,(%esp)
  8036b2:	85 c0                	test   %eax,%eax
  8036b4:	75 1a                	jne    8036d0 <__umoddi3+0x48>
  8036b6:	39 f7                	cmp    %esi,%edi
  8036b8:	0f 86 a2 00 00 00    	jbe    803760 <__umoddi3+0xd8>
  8036be:	89 c8                	mov    %ecx,%eax
  8036c0:	89 f2                	mov    %esi,%edx
  8036c2:	f7 f7                	div    %edi
  8036c4:	89 d0                	mov    %edx,%eax
  8036c6:	31 d2                	xor    %edx,%edx
  8036c8:	83 c4 1c             	add    $0x1c,%esp
  8036cb:	5b                   	pop    %ebx
  8036cc:	5e                   	pop    %esi
  8036cd:	5f                   	pop    %edi
  8036ce:	5d                   	pop    %ebp
  8036cf:	c3                   	ret    
  8036d0:	39 f0                	cmp    %esi,%eax
  8036d2:	0f 87 ac 00 00 00    	ja     803784 <__umoddi3+0xfc>
  8036d8:	0f bd e8             	bsr    %eax,%ebp
  8036db:	83 f5 1f             	xor    $0x1f,%ebp
  8036de:	0f 84 ac 00 00 00    	je     803790 <__umoddi3+0x108>
  8036e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8036e9:	29 ef                	sub    %ebp,%edi
  8036eb:	89 fe                	mov    %edi,%esi
  8036ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036f1:	89 e9                	mov    %ebp,%ecx
  8036f3:	d3 e0                	shl    %cl,%eax
  8036f5:	89 d7                	mov    %edx,%edi
  8036f7:	89 f1                	mov    %esi,%ecx
  8036f9:	d3 ef                	shr    %cl,%edi
  8036fb:	09 c7                	or     %eax,%edi
  8036fd:	89 e9                	mov    %ebp,%ecx
  8036ff:	d3 e2                	shl    %cl,%edx
  803701:	89 14 24             	mov    %edx,(%esp)
  803704:	89 d8                	mov    %ebx,%eax
  803706:	d3 e0                	shl    %cl,%eax
  803708:	89 c2                	mov    %eax,%edx
  80370a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80370e:	d3 e0                	shl    %cl,%eax
  803710:	89 44 24 04          	mov    %eax,0x4(%esp)
  803714:	8b 44 24 08          	mov    0x8(%esp),%eax
  803718:	89 f1                	mov    %esi,%ecx
  80371a:	d3 e8                	shr    %cl,%eax
  80371c:	09 d0                	or     %edx,%eax
  80371e:	d3 eb                	shr    %cl,%ebx
  803720:	89 da                	mov    %ebx,%edx
  803722:	f7 f7                	div    %edi
  803724:	89 d3                	mov    %edx,%ebx
  803726:	f7 24 24             	mull   (%esp)
  803729:	89 c6                	mov    %eax,%esi
  80372b:	89 d1                	mov    %edx,%ecx
  80372d:	39 d3                	cmp    %edx,%ebx
  80372f:	0f 82 87 00 00 00    	jb     8037bc <__umoddi3+0x134>
  803735:	0f 84 91 00 00 00    	je     8037cc <__umoddi3+0x144>
  80373b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80373f:	29 f2                	sub    %esi,%edx
  803741:	19 cb                	sbb    %ecx,%ebx
  803743:	89 d8                	mov    %ebx,%eax
  803745:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803749:	d3 e0                	shl    %cl,%eax
  80374b:	89 e9                	mov    %ebp,%ecx
  80374d:	d3 ea                	shr    %cl,%edx
  80374f:	09 d0                	or     %edx,%eax
  803751:	89 e9                	mov    %ebp,%ecx
  803753:	d3 eb                	shr    %cl,%ebx
  803755:	89 da                	mov    %ebx,%edx
  803757:	83 c4 1c             	add    $0x1c,%esp
  80375a:	5b                   	pop    %ebx
  80375b:	5e                   	pop    %esi
  80375c:	5f                   	pop    %edi
  80375d:	5d                   	pop    %ebp
  80375e:	c3                   	ret    
  80375f:	90                   	nop
  803760:	89 fd                	mov    %edi,%ebp
  803762:	85 ff                	test   %edi,%edi
  803764:	75 0b                	jne    803771 <__umoddi3+0xe9>
  803766:	b8 01 00 00 00       	mov    $0x1,%eax
  80376b:	31 d2                	xor    %edx,%edx
  80376d:	f7 f7                	div    %edi
  80376f:	89 c5                	mov    %eax,%ebp
  803771:	89 f0                	mov    %esi,%eax
  803773:	31 d2                	xor    %edx,%edx
  803775:	f7 f5                	div    %ebp
  803777:	89 c8                	mov    %ecx,%eax
  803779:	f7 f5                	div    %ebp
  80377b:	89 d0                	mov    %edx,%eax
  80377d:	e9 44 ff ff ff       	jmp    8036c6 <__umoddi3+0x3e>
  803782:	66 90                	xchg   %ax,%ax
  803784:	89 c8                	mov    %ecx,%eax
  803786:	89 f2                	mov    %esi,%edx
  803788:	83 c4 1c             	add    $0x1c,%esp
  80378b:	5b                   	pop    %ebx
  80378c:	5e                   	pop    %esi
  80378d:	5f                   	pop    %edi
  80378e:	5d                   	pop    %ebp
  80378f:	c3                   	ret    
  803790:	3b 04 24             	cmp    (%esp),%eax
  803793:	72 06                	jb     80379b <__umoddi3+0x113>
  803795:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803799:	77 0f                	ja     8037aa <__umoddi3+0x122>
  80379b:	89 f2                	mov    %esi,%edx
  80379d:	29 f9                	sub    %edi,%ecx
  80379f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037a3:	89 14 24             	mov    %edx,(%esp)
  8037a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037ae:	8b 14 24             	mov    (%esp),%edx
  8037b1:	83 c4 1c             	add    $0x1c,%esp
  8037b4:	5b                   	pop    %ebx
  8037b5:	5e                   	pop    %esi
  8037b6:	5f                   	pop    %edi
  8037b7:	5d                   	pop    %ebp
  8037b8:	c3                   	ret    
  8037b9:	8d 76 00             	lea    0x0(%esi),%esi
  8037bc:	2b 04 24             	sub    (%esp),%eax
  8037bf:	19 fa                	sbb    %edi,%edx
  8037c1:	89 d1                	mov    %edx,%ecx
  8037c3:	89 c6                	mov    %eax,%esi
  8037c5:	e9 71 ff ff ff       	jmp    80373b <__umoddi3+0xb3>
  8037ca:	66 90                	xchg   %ax,%ax
  8037cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037d0:	72 ea                	jb     8037bc <__umoddi3+0x134>
  8037d2:	89 d9                	mov    %ebx,%ecx
  8037d4:	e9 62 ff ff ff       	jmp    80373b <__umoddi3+0xb3>
