
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 80 03 00 00       	call   8003b6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 50 80 00       	mov    0x805020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 50 80 00       	mov    0x805020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 80 37 80 00       	push   $0x803780
  800095:	6a 1a                	push   $0x1a
  800097:	68 9c 37 80 00       	push   $0x80379c
  80009c:	e8 51 04 00 00       	call   8004f2 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 83 16 00 00       	call   80172e <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ae:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  8000bc:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  8000c0:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  8000c4:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  8000ca:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  8000d0:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d7:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  8000de:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000e4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	89 d7                	mov    %edx,%edi
  8000f0:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f5:	01 c0                	add    %eax,%eax
  8000f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 2b 16 00 00       	call   80172e <malloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  80010c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800112:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800118:	01 c0                	add    %eax,%eax
  80011a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011d:	48                   	dec    %eax
  80011e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  800121:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800124:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800127:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800129:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80012c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012f:	01 c2                	add    %eax,%edx
  800131:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800134:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	01 c0                	add    %eax,%eax
  80013b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	50                   	push   %eax
  800142:	e8 e7 15 00 00       	call   80172e <malloc>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800150:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800156:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015c:	01 c0                	add    %eax,%eax
  80015e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800161:	d1 e8                	shr    %eax
  800163:	48                   	dec    %eax
  800164:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800167:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80016a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016d:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800170:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800173:	01 c0                	add    %eax,%eax
  800175:	89 c2                	mov    %eax,%edx
  800177:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80017a:	01 c2                	add    %eax,%edx
  80017c:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800180:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(3*kilo);
  800183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800186:	89 c2                	mov    %eax,%edx
  800188:	01 d2                	add    %edx,%edx
  80018a:	01 d0                	add    %edx,%eax
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	e8 99 15 00 00       	call   80172e <malloc>
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  80019e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8001a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8001a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	c1 e8 02             	shr    $0x2,%eax
  8001af:	48                   	dec    %eax
  8001b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  8001b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001b9:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c8:	01 c2                	add    %eax,%edx
  8001ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001cd:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001d2:	89 d0                	mov    %edx,%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	01 d0                	add    %edx,%eax
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	50                   	push   %eax
  8001e0:	e8 49 15 00 00       	call   80172e <malloc>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001fa:	89 d0                	mov    %edx,%eax
  8001fc:	01 c0                	add    %eax,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	01 c0                	add    %eax,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	c1 e8 03             	shr    $0x3,%eax
  800207:	48                   	dec    %eax
  800208:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80020b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020e:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800211:	88 10                	mov    %dl,(%eax)
  800213:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800219:	66 89 42 02          	mov    %ax,0x2(%edx)
  80021d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800220:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800223:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800226:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800229:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800230:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800233:	01 c2                	add    %eax,%edx
  800235:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800238:	88 02                	mov    %al,(%edx)
  80023a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800244:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800247:	01 c2                	add    %eax,%edx
  800249:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80024d:	66 89 42 02          	mov    %ax,0x2(%edx)
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80025b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80025e:	01 c2                	add    %eax,%edx
  800260:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800263:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800269:	8a 00                	mov    (%eax),%al
  80026b:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80026e:	75 0f                	jne    80027f <_main+0x247>
  800270:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800273:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8a 00                	mov    (%eax),%al
  80027a:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80027d:	74 14                	je     800293 <_main+0x25b>
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	68 b0 37 80 00       	push   $0x8037b0
  800287:	6a 45                	push   $0x45
  800289:	68 9c 37 80 00       	push   $0x80379c
  80028e:	e8 5f 02 00 00       	call   8004f2 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800296:	66 8b 00             	mov    (%eax),%ax
  800299:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80029d:	75 15                	jne    8002b4 <_main+0x27c>
  80029f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	66 8b 00             	mov    (%eax),%ax
  8002ae:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  8002b2:	74 14                	je     8002c8 <_main+0x290>
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	68 b0 37 80 00       	push   $0x8037b0
  8002bc:	6a 46                	push   $0x46
  8002be:	68 9c 37 80 00       	push   $0x80379c
  8002c3:	e8 2a 02 00 00       	call   8004f2 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d0:	75 16                	jne    8002e8 <_main+0x2b0>
  8002d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8b 00                	mov    (%eax),%eax
  8002e3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 b0 37 80 00       	push   $0x8037b0
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 9c 37 80 00       	push   $0x80379c
  8002f7:	e8 f6 01 00 00       	call   8004f2 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ff:	8a 00                	mov    (%eax),%al
  800301:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800304:	75 16                	jne    80031c <_main+0x2e4>
  800306:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800309:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800310:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	8a 00                	mov    (%eax),%al
  800317:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80031a:	74 14                	je     800330 <_main+0x2f8>
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	68 b0 37 80 00       	push   $0x8037b0
  800324:	6a 49                	push   $0x49
  800326:	68 9c 37 80 00       	push   $0x80379c
  80032b:	e8 c2 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800330:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800333:	66 8b 40 02          	mov    0x2(%eax),%ax
  800337:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80033b:	75 19                	jne    800356 <_main+0x31e>
  80033d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800340:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800347:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034a:	01 d0                	add    %edx,%eax
  80034c:	66 8b 40 02          	mov    0x2(%eax),%ax
  800350:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800354:	74 14                	je     80036a <_main+0x332>
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	68 b0 37 80 00       	push   $0x8037b0
  80035e:	6a 4a                	push   $0x4a
  800360:	68 9c 37 80 00       	push   $0x80379c
  800365:	e8 88 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  80036a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036d:	8b 40 04             	mov    0x4(%eax),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	75 17                	jne    80038c <_main+0x354>
  800375:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800378:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80037f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	8b 40 04             	mov    0x4(%eax),%eax
  800387:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80038a:	74 14                	je     8003a0 <_main+0x368>
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 b0 37 80 00       	push   $0x8037b0
  800394:	6a 4b                	push   $0x4b
  800396:	68 9c 37 80 00       	push   $0x80379c
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 e8 37 80 00       	push   $0x8037e8
  8003a8:	e8 f9 03 00 00       	call   8007a6 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp

	return;
  8003b0:	90                   	nop
}
  8003b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003bc:	e8 6d 18 00 00       	call   801c2e <sys_getenvindex>
  8003c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	c1 e0 03             	shl    $0x3,%eax
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	c1 e0 04             	shl    $0x4,%eax
  8003de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ed:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003f3:	84 c0                	test   %al,%al
  8003f5:	74 0f                	je     800406 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fc:	05 5c 05 00 00       	add    $0x55c,%eax
  800401:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80040a:	7e 0a                	jle    800416 <libmain+0x60>
		binaryname = argv[0];
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	ff 75 0c             	pushl  0xc(%ebp)
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 14 fc ff ff       	call   800038 <_main>
  800424:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800427:	e8 0f 16 00 00       	call   801a3b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 3c 38 80 00       	push   $0x80383c
  800434:	e8 6d 03 00 00       	call   8007a6 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80043c:	a1 20 50 80 00       	mov    0x805020,%eax
  800441:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800447:	a1 20 50 80 00       	mov    0x805020,%eax
  80044c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	68 64 38 80 00       	push   $0x803864
  80045c:	e8 45 03 00 00       	call   8007a6 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800464:	a1 20 50 80 00       	mov    0x805020,%eax
  800469:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80046f:	a1 20 50 80 00       	mov    0x805020,%eax
  800474:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80047a:	a1 20 50 80 00       	mov    0x805020,%eax
  80047f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800485:	51                   	push   %ecx
  800486:	52                   	push   %edx
  800487:	50                   	push   %eax
  800488:	68 8c 38 80 00       	push   $0x80388c
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 50 80 00       	mov    0x805020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 e4 38 80 00       	push   $0x8038e4
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 3c 38 80 00       	push   $0x80383c
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 8f 15 00 00       	call   801a55 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004c6:	e8 19 00 00 00       	call   8004e4 <exit>
}
  8004cb:	90                   	nop
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	6a 00                	push   $0x0
  8004d9:	e8 1c 17 00 00       	call   801bfa <sys_destroy_env>
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	90                   	nop
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <exit>:

void
exit(void)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ea:	e8 71 17 00 00       	call   801c60 <sys_exit_env>
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8004fb:	83 c0 04             	add    $0x4,%eax
  8004fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800501:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	74 16                	je     800520 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80050a:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	50                   	push   %eax
  800513:	68 f8 38 80 00       	push   $0x8038f8
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 50 80 00       	mov    0x805000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 fd 38 80 00       	push   $0x8038fd
  800531:	e8 70 02 00 00       	call   8007a6 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800539:	8b 45 10             	mov    0x10(%ebp),%eax
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 f4             	pushl  -0xc(%ebp)
  800542:	50                   	push   %eax
  800543:	e8 f3 01 00 00       	call   80073b <vcprintf>
  800548:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	6a 00                	push   $0x0
  800550:	68 19 39 80 00       	push   $0x803919
  800555:	e8 e1 01 00 00       	call   80073b <vcprintf>
  80055a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80055d:	e8 82 ff ff ff       	call   8004e4 <exit>

	// should not return here
	while (1) ;
  800562:	eb fe                	jmp    800562 <_panic+0x70>

00800564 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80056a:	a1 20 50 80 00       	mov    0x805020,%eax
  80056f:	8b 50 74             	mov    0x74(%eax),%edx
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	74 14                	je     80058d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 1c 39 80 00       	push   $0x80391c
  800581:	6a 26                	push   $0x26
  800583:	68 68 39 80 00       	push   $0x803968
  800588:	e8 65 ff ff ff       	call   8004f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80058d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059b:	e9 c2 00 00 00       	jmp    800662 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	85 c0                	test   %eax,%eax
  8005b3:	75 08                	jne    8005bd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005b5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005b8:	e9 a2 00 00 00       	jmp    80065f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005cb:	eb 69                	jmp    800636 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005db:	89 d0                	mov    %edx,%eax
  8005dd:	01 c0                	add    %eax,%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	c1 e0 03             	shl    $0x3,%eax
  8005e4:	01 c8                	add    %ecx,%eax
  8005e6:	8a 40 04             	mov    0x4(%eax),%al
  8005e9:	84 c0                	test   %al,%al
  8005eb:	75 46                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	01 c0                	add    %eax,%eax
  8005ff:	01 d0                	add    %edx,%eax
  800601:	c1 e0 03             	shl    $0x3,%eax
  800604:	01 c8                	add    %ecx,%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800613:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800618:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800626:	39 c2                	cmp    %eax,%edx
  800628:	75 09                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80062a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800631:	eb 12                	jmp    800645 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800633:	ff 45 e8             	incl   -0x18(%ebp)
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 50 74             	mov    0x74(%eax),%edx
  80063e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800641:	39 c2                	cmp    %eax,%edx
  800643:	77 88                	ja     8005cd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800649:	75 14                	jne    80065f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	68 74 39 80 00       	push   $0x803974
  800653:	6a 3a                	push   $0x3a
  800655:	68 68 39 80 00       	push   $0x803968
  80065a:	e8 93 fe ff ff       	call   8004f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80065f:	ff 45 f0             	incl   -0x10(%ebp)
  800662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800665:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800668:	0f 8c 32 ff ff ff    	jl     8005a0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800675:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80067c:	eb 26                	jmp    8006a4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80067e:	a1 20 50 80 00       	mov    0x805020,%eax
  800683:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068c:	89 d0                	mov    %edx,%eax
  80068e:	01 c0                	add    %eax,%eax
  800690:	01 d0                	add    %edx,%eax
  800692:	c1 e0 03             	shl    $0x3,%eax
  800695:	01 c8                	add    %ecx,%eax
  800697:	8a 40 04             	mov    0x4(%eax),%al
  80069a:	3c 01                	cmp    $0x1,%al
  80069c:	75 03                	jne    8006a1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80069e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a1:	ff 45 e0             	incl   -0x20(%ebp)
  8006a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a9:	8b 50 74             	mov    0x74(%eax),%edx
  8006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006af:	39 c2                	cmp    %eax,%edx
  8006b1:	77 cb                	ja     80067e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b9:	74 14                	je     8006cf <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006bb:	83 ec 04             	sub    $0x4,%esp
  8006be:	68 c8 39 80 00       	push   $0x8039c8
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 68 39 80 00       	push   $0x803968
  8006ca:	e8 23 fe ff ff       	call   8004f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8006e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e3:	89 0a                	mov    %ecx,(%edx)
  8006e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8006e8:	88 d1                	mov    %dl,%cl
  8006ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006fb:	75 2c                	jne    800729 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006fd:	a0 24 50 80 00       	mov    0x805024,%al
  800702:	0f b6 c0             	movzbl %al,%eax
  800705:	8b 55 0c             	mov    0xc(%ebp),%edx
  800708:	8b 12                	mov    (%edx),%edx
  80070a:	89 d1                	mov    %edx,%ecx
  80070c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070f:	83 c2 08             	add    $0x8,%edx
  800712:	83 ec 04             	sub    $0x4,%esp
  800715:	50                   	push   %eax
  800716:	51                   	push   %ecx
  800717:	52                   	push   %edx
  800718:	e8 70 11 00 00       	call   80188d <sys_cputs>
  80071d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	8b 40 04             	mov    0x4(%eax),%eax
  80072f:	8d 50 01             	lea    0x1(%eax),%edx
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	89 50 04             	mov    %edx,0x4(%eax)
}
  800738:	90                   	nop
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800744:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80074b:	00 00 00 
	b.cnt = 0;
  80074e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800755:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	ff 75 08             	pushl  0x8(%ebp)
  80075e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	68 d2 06 80 00       	push   $0x8006d2
  80076a:	e8 11 02 00 00       	call   800980 <vprintfmt>
  80076f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800772:	a0 24 50 80 00       	mov    0x805024,%al
  800777:	0f b6 c0             	movzbl %al,%eax
  80077a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800780:	83 ec 04             	sub    $0x4,%esp
  800783:	50                   	push   %eax
  800784:	52                   	push   %edx
  800785:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80078b:	83 c0 08             	add    $0x8,%eax
  80078e:	50                   	push   %eax
  80078f:	e8 f9 10 00 00       	call   80188d <sys_cputs>
  800794:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800797:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80079e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007ac:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8007b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 73 ff ff ff       	call   80073b <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d9:	e8 5d 12 00 00       	call   801a3b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	e8 48 ff ff ff       	call   80073b <vcprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f9:	e8 57 12 00 00       	call   801a55 <sys_enable_interrupt>
	return cnt;
  8007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 14             	sub    $0x14,%esp
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	77 55                	ja     800878 <printnum+0x75>
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	72 05                	jb     80082d <printnum+0x2a>
  800828:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082b:	77 4b                	ja     800878 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800830:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	e8 c8 2c 00 00       	call   803510 <__udivdi3>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	ff 75 20             	pushl  0x20(%ebp)
  800851:	53                   	push   %ebx
  800852:	ff 75 18             	pushl  0x18(%ebp)
  800855:	52                   	push   %edx
  800856:	50                   	push   %eax
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 a1 ff ff ff       	call   800803 <printnum>
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	eb 1a                	jmp    800881 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 20             	pushl  0x20(%ebp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800878:	ff 4d 1c             	decl   0x1c(%ebp)
  80087b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087f:	7f e6                	jg     800867 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800881:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800884:	bb 00 00 00 00       	mov    $0x0,%ebx
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	53                   	push   %ebx
  800890:	51                   	push   %ecx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	e8 88 2d 00 00       	call   803620 <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 34 3c 80 00       	add    $0x803c34,%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	90                   	nop
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 40                	jmp    80091f <getuint+0x65>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1e                	je     800903 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	eb 1c                	jmp    80091f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800924:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800928:	7e 1c                	jle    800946 <getint+0x25>
		return va_arg(*ap, long long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 08             	lea    0x8(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 08             	sub    $0x8,%eax
  80093f:	8b 50 04             	mov    0x4(%eax),%edx
  800942:	8b 00                	mov    (%eax),%eax
  800944:	eb 38                	jmp    80097e <getint+0x5d>
	else if (lflag)
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	74 1a                	je     800966 <getint+0x45>
		return va_arg(*ap, long);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
  800964:	eb 18                	jmp    80097e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	99                   	cltd   
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	eb 17                	jmp    8009a1 <vprintfmt+0x21>
			if (ch == '\0')
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	0f 84 af 03 00 00    	je     800d41 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8d 50 01             	lea    0x1(%eax),%edx
  8009a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 d6                	jne    80098a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e5:	83 f8 55             	cmp    $0x55,%eax
  8009e8:	0f 87 2b 03 00 00    	ja     800d19 <vprintfmt+0x399>
  8009ee:	8b 04 85 58 3c 80 00 	mov    0x803c58(,%eax,4),%eax
  8009f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fb:	eb d7                	jmp    8009d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a01:	eb d1                	jmp    8009d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 02             	shl    $0x2,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d8                	add    %ebx,%eax
  800a18:	83 e8 30             	sub    $0x30,%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a26:	83 fb 2f             	cmp    $0x2f,%ebx
  800a29:	7e 3e                	jle    800a69 <vprintfmt+0xe9>
  800a2b:	83 fb 39             	cmp    $0x39,%ebx
  800a2e:	7f 39                	jg     800a69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a33:	eb d5                	jmp    800a0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	79 83                	jns    8009d4 <vprintfmt+0x54>
				width = 0;
  800a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a58:	e9 77 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a64:	e9 6b ff ff ff       	jmp    8009d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	0f 89 60 ff ff ff    	jns    8009d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a81:	e9 4e ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a89:	e9 46 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 89 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	79 02                	jns    800aca <vprintfmt+0x14a>
				err = -err;
  800ac8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aca:	83 fb 64             	cmp    $0x64,%ebx
  800acd:	7f 0b                	jg     800ada <vprintfmt+0x15a>
  800acf:	8b 34 9d a0 3a 80 00 	mov    0x803aa0(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 45 3c 80 00       	push   $0x803c45
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 5e 02 00 00       	call   800d49 <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aee:	e9 49 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af3:	56                   	push   %esi
  800af4:	68 4e 3c 80 00       	push   $0x803c4e
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 45 02 00 00       	call   800d49 <printfmt>
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 30 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 30                	mov    (%eax),%esi
  800b1d:	85 f6                	test   %esi,%esi
  800b1f:	75 05                	jne    800b26 <vprintfmt+0x1a6>
				p = "(null)";
  800b21:	be 51 3c 80 00       	mov    $0x803c51,%esi
			if (width > 0 && padc != '-')
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7e 6d                	jle    800b99 <vprintfmt+0x219>
  800b2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b30:	74 67                	je     800b99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	50                   	push   %eax
  800b39:	56                   	push   %esi
  800b3a:	e8 0c 03 00 00       	call   800e4b <strnlen>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	50                   	push   %eax
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 34                	jmp    800b99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	74 1c                	je     800b87 <vprintfmt+0x207>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x1f5>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 12                	jle    800b87 <vprintfmt+0x207>
					putch('?', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 3f                	push   $0x3f
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	89 f0                	mov    %esi,%eax
  800b9b:	8d 70 01             	lea    0x1(%eax),%esi
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be d8             	movsbl %al,%ebx
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	74 24                	je     800bcb <vprintfmt+0x24b>
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	78 b8                	js     800b65 <vprintfmt+0x1e5>
  800bad:	ff 4d e0             	decl   -0x20(%ebp)
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	79 af                	jns    800b65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 13                	jmp    800bcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 20                	push   $0x20
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcf:	7f e7                	jg     800bb8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd1:	e9 66 01 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 3c fd ff ff       	call   800921 <getint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	85 d2                	test   %edx,%edx
  800bf6:	79 23                	jns    800c1b <vprintfmt+0x29b>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 2d                	push   $0x2d
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	e8 84 fc ff ff       	call   8008ba <getuint>
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c46:	e9 98 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			break;
  800c7b:	e9 bc 00 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 30                	push   $0x30
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 78                	push   $0x78
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc2:	eb 1f                	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	e8 e7 fb ff ff       	call   8008ba <getuint>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	52                   	push   %edx
  800cee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 00 fb ff ff       	call   800803 <printnum>
  800d03:	83 c4 20             	add    $0x20,%esp
			break;
  800d06:	eb 34                	jmp    800d3c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	53                   	push   %ebx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	ff d0                	call   *%eax
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 25                	push   $0x25
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	ff 4d 10             	decl   0x10(%ebp)
  800d2c:	eb 03                	jmp    800d31 <vprintfmt+0x3b1>
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	48                   	dec    %eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 25                	cmp    $0x25,%al
  800d39:	75 f3                	jne    800d2e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d3b:	90                   	nop
		}
	}
  800d3c:	e9 47 fc ff ff       	jmp    800988 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 16 fc ff ff       	call   800980 <vprintfmt>
  800d6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6d:	90                   	nop
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 40 08             	mov    0x8(%eax),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 10                	mov    (%eax),%edx
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 40 04             	mov    0x4(%eax),%eax
  800d8d:	39 c2                	cmp    %eax,%edx
  800d8f:	73 12                	jae    800da3 <sprintputch+0x33>
		*b->buf++ = ch;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	8d 48 01             	lea    0x1(%eax),%ecx
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	89 0a                	mov    %ecx,(%edx)
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	88 10                	mov    %dl,(%eax)
}
  800da3:	90                   	nop
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	01 d0                	add    %edx,%eax
  800dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	74 06                	je     800dd3 <vsnprintf+0x2d>
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	7f 07                	jg     800dda <vsnprintf+0x34>
		return -E_INVAL;
  800dd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd8:	eb 20                	jmp    800dfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dda:	ff 75 14             	pushl  0x14(%ebp)
  800ddd:	ff 75 10             	pushl  0x10(%ebp)
  800de0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 70 0d 80 00       	push   $0x800d70
  800de9:	e8 92 fb ff ff       	call   800980 <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e02:	8d 45 10             	lea    0x10(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e11:	50                   	push   %eax
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 89 ff ff ff       	call   800da6 <vsnprintf>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e35:	eb 06                	jmp    800e3d <strlen+0x15>
		n++;
  800e37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3a:	ff 45 08             	incl   0x8(%ebp)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	75 f1                	jne    800e37 <strlen+0xf>
		n++;
	return n;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 09                	jmp    800e63 <strnlen+0x18>
		n++;
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	ff 4d 0c             	decl   0xc(%ebp)
  800e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e67:	74 09                	je     800e72 <strnlen+0x27>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e8                	jne    800e5a <strnlen+0xf>
		n++;
	return n;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e83:	90                   	nop
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e96:	8a 12                	mov    (%edx),%dl
  800e98:	88 10                	mov    %dl,(%eax)
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	84 c0                	test   %al,%al
  800e9e:	75 e4                	jne    800e84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb8:	eb 1f                	jmp    800ed9 <strncpy+0x34>
		*dst++ = *src;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	74 03                	je     800ed6 <strncpy+0x31>
			src++;
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	ff 45 fc             	incl   -0x4(%ebp)
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edf:	72 d9                	jb     800eba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 30                	je     800f28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef8:	eb 16                	jmp    800f10 <strlcpy+0x2a>
			*dst++ = *src++;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0c:	8a 12                	mov    (%edx),%dl
  800f0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f10:	ff 4d 10             	decl   0x10(%ebp)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 09                	je     800f22 <strlcpy+0x3c>
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 d8                	jne    800efa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2e:	29 c2                	sub    %eax,%edx
  800f30:	89 d0                	mov    %edx,%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f37:	eb 06                	jmp    800f3f <strcmp+0xb>
		p++, q++;
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	74 0e                	je     800f56 <strcmp+0x22>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 e3                	je     800f39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
}
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6f:	eb 09                	jmp    800f7a <strncmp+0xe>
		n--, p++, q++;
  800f71:	ff 4d 10             	decl   0x10(%ebp)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 17                	je     800f97 <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	74 0e                	je     800f97 <strncmp+0x2b>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 10                	mov    (%eax),%dl
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	38 c2                	cmp    %al,%dl
  800f95:	74 da                	je     800f71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strncmp+0x38>
		return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	eb 14                	jmp    800fb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc6:	eb 12                	jmp    800fda <strchr+0x20>
		if (*s == c)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd0:	75 05                	jne    800fd7 <strchr+0x1d>
			return (char *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	eb 11                	jmp    800fe8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 e5                	jne    800fc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff6:	eb 0d                	jmp    801005 <strfind+0x1b>
		if (*s == c)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801000:	74 0e                	je     801010 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801002:	ff 45 08             	incl   0x8(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ea                	jne    800ff8 <strfind+0xe>
  80100e:	eb 01                	jmp    801011 <strfind+0x27>
		if (*s == c)
			break;
  801010:	90                   	nop
	return (char *) s;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801028:	eb 0e                	jmp    801038 <memset+0x22>
		*p++ = c;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8d 50 01             	lea    0x1(%eax),%edx
  801030:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801033:	8b 55 0c             	mov    0xc(%ebp),%edx
  801036:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801038:	ff 4d f8             	decl   -0x8(%ebp)
  80103b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80103f:	79 e9                	jns    80102a <memset+0x14>
		*p++ = c;

	return v;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801058:	eb 16                	jmp    801070 <memcpy+0x2a>
		*d++ = *s++;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8d 4a 01             	lea    0x1(%edx),%ecx
  801069:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106c:	8a 12                	mov    (%edx),%dl
  80106e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 dd                	jne    80105a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109a:	73 50                	jae    8010ec <memmove+0x6a>
  80109c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a7:	76 43                	jbe    8010ec <memmove+0x6a>
		s += n;
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b5:	eb 10                	jmp    8010c7 <memmove+0x45>
			*--d = *--s;
  8010b7:	ff 4d f8             	decl   -0x8(%ebp)
  8010ba:	ff 4d fc             	decl   -0x4(%ebp)
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c0:	8a 10                	mov    (%eax),%dl
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	75 e3                	jne    8010b7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d4:	eb 23                	jmp    8010f9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e8:	8a 12                	mov    (%edx),%dl
  8010ea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	75 dd                	jne    8010d6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801110:	eb 2a                	jmp    80113c <memcmp+0x3e>
		if (*s1 != *s2)
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801115:	8a 10                	mov    (%eax),%dl
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	38 c2                	cmp    %al,%dl
  80111e:	74 16                	je     801136 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f b6 d0             	movzbl %al,%edx
  801128:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	0f b6 c0             	movzbl %al,%eax
  801130:	29 c2                	sub    %eax,%edx
  801132:	89 d0                	mov    %edx,%eax
  801134:	eb 18                	jmp    80114e <memcmp+0x50>
		s1++, s2++;
  801136:	ff 45 fc             	incl   -0x4(%ebp)
  801139:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801142:	89 55 10             	mov    %edx,0x10(%ebp)
  801145:	85 c0                	test   %eax,%eax
  801147:	75 c9                	jne    801112 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801149:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801161:	eb 15                	jmp    801178 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f b6 d0             	movzbl %al,%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	0f b6 c0             	movzbl %al,%eax
  801171:	39 c2                	cmp    %eax,%edx
  801173:	74 0d                	je     801182 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801175:	ff 45 08             	incl   0x8(%ebp)
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80117e:	72 e3                	jb     801163 <memfind+0x13>
  801180:	eb 01                	jmp    801183 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801182:	90                   	nop
	return (void *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80118e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80119c:	eb 03                	jmp    8011a1 <strtol+0x19>
		s++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 20                	cmp    $0x20,%al
  8011a8:	74 f4                	je     80119e <strtol+0x16>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 09                	cmp    $0x9,%al
  8011b1:	74 eb                	je     80119e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 2b                	cmp    $0x2b,%al
  8011ba:	75 05                	jne    8011c1 <strtol+0x39>
		s++;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	eb 13                	jmp    8011d4 <strtol+0x4c>
	else if (*s == '-')
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 2d                	cmp    $0x2d,%al
  8011c8:	75 0a                	jne    8011d4 <strtol+0x4c>
		s++, neg = 1;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d8:	74 06                	je     8011e0 <strtol+0x58>
  8011da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011de:	75 20                	jne    801200 <strtol+0x78>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 30                	cmp    $0x30,%al
  8011e7:	75 17                	jne    801200 <strtol+0x78>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	40                   	inc    %eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 78                	cmp    $0x78,%al
  8011f1:	75 0d                	jne    801200 <strtol+0x78>
		s += 2, base = 16;
  8011f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011fe:	eb 28                	jmp    801228 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801204:	75 15                	jne    80121b <strtol+0x93>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 30                	cmp    $0x30,%al
  80120d:	75 0c                	jne    80121b <strtol+0x93>
		s++, base = 8;
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801219:	eb 0d                	jmp    801228 <strtol+0xa0>
	else if (base == 0)
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	75 07                	jne    801228 <strtol+0xa0>
		base = 10;
  801221:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 2f                	cmp    $0x2f,%al
  80122f:	7e 19                	jle    80124a <strtol+0xc2>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 39                	cmp    $0x39,%al
  801238:	7f 10                	jg     80124a <strtol+0xc2>
			dig = *s - '0';
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	0f be c0             	movsbl %al,%eax
  801242:	83 e8 30             	sub    $0x30,%eax
  801245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801248:	eb 42                	jmp    80128c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 60                	cmp    $0x60,%al
  801251:	7e 19                	jle    80126c <strtol+0xe4>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3c 7a                	cmp    $0x7a,%al
  80125a:	7f 10                	jg     80126c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	0f be c0             	movsbl %al,%eax
  801264:	83 e8 57             	sub    $0x57,%eax
  801267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126a:	eb 20                	jmp    80128c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 40                	cmp    $0x40,%al
  801273:	7e 39                	jle    8012ae <strtol+0x126>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 30                	jg     8012ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	83 e8 37             	sub    $0x37,%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801292:	7d 19                	jge    8012ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80129e:	89 c2                	mov    %eax,%edx
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012a8:	e9 7b ff ff ff       	jmp    801228 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b2:	74 08                	je     8012bc <strtol+0x134>
		*endptr = (char *) s;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c0:	74 07                	je     8012c9 <strtol+0x141>
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	f7 d8                	neg    %eax
  8012c7:	eb 03                	jmp    8012cc <strtol+0x144>
  8012c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <ltostr>:

void
ltostr(long value, char *str)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e6:	79 13                	jns    8012fb <ltostr+0x2d>
	{
		neg = 1;
  8012e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801303:	99                   	cltd   
  801304:	f7 f9                	idiv   %ecx
  801306:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	01 d0                	add    %edx,%eax
  801319:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80131c:	83 c2 30             	add    $0x30,%edx
  80131f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801321:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801324:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801329:	f7 e9                	imul   %ecx
  80132b:	c1 fa 02             	sar    $0x2,%edx
  80132e:	89 c8                	mov    %ecx,%eax
  801330:	c1 f8 1f             	sar    $0x1f,%eax
  801333:	29 c2                	sub    %eax,%edx
  801335:	89 d0                	mov    %edx,%eax
  801337:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80133a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801342:	f7 e9                	imul   %ecx
  801344:	c1 fa 02             	sar    $0x2,%edx
  801347:	89 c8                	mov    %ecx,%eax
  801349:	c1 f8 1f             	sar    $0x1f,%eax
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	c1 e0 02             	shl    $0x2,%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	01 c0                	add    %eax,%eax
  801357:	29 c1                	sub    %eax,%ecx
  801359:	89 ca                	mov    %ecx,%edx
  80135b:	85 d2                	test   %edx,%edx
  80135d:	75 9c                	jne    8012fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801371:	74 3d                	je     8013b0 <ltostr+0xe2>
		start = 1 ;
  801373:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80137a:	eb 34                	jmp    8013b0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 c8                	add    %ecx,%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	7c c4                	jl     80137c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 54 fa ff ff       	call   800e28 <strlen>
  8013d4:	83 c4 04             	add    $0x4,%esp
  8013d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 46 fa ff ff       	call   800e28 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 17                	jmp    80140f <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7c e1                	jl     8013f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801417:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801425:	eb 1f                	jmp    801446 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8d 50 01             	lea    0x1(%eax),%edx
  80142d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801430:	89 c2                	mov    %eax,%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c d9                	jl     801427 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147f:	eb 0c                	jmp    80148d <strsplit+0x31>
			*string++ = 0;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 18                	je     8014ae <strsplit+0x52>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f be c0             	movsbl %al,%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	e8 13 fb ff ff       	call   800fba <strchr>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 d3                	jne    801481 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 5a                	je     801511 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	83 f8 0f             	cmp    $0xf,%eax
  8014bf:	75 07                	jne    8014c8 <strsplit+0x6c>
		{
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 66                	jmp    80152e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d3:	89 0a                	mov    %ecx,(%edx)
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 c2                	add    %eax,%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e6:	eb 03                	jmp    8014eb <strsplit+0x8f>
			string++;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	74 8b                	je     80147f <strsplit+0x23>
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	e8 b5 fa ff ff       	call   800fba <strchr>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 dc                	je     8014e8 <strsplit+0x8c>
			string++;
	}
  80150c:	e9 6e ff ff ff       	jmp    80147f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801511:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801536:	a1 04 50 80 00       	mov    0x805004,%eax
  80153b:	85 c0                	test   %eax,%eax
  80153d:	74 1f                	je     80155e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80153f:	e8 1d 00 00 00       	call   801561 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	68 b0 3d 80 00       	push   $0x803db0
  80154c:	e8 55 f2 ff ff       	call   8007a6 <cprintf>
  801551:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801554:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80155b:	00 00 00 
	}
}
  80155e:	90                   	nop
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801567:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80156e:	00 00 00 
  801571:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801578:	00 00 00 
  80157b:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801582:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801585:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80158c:	00 00 00 
  80158f:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801596:	00 00 00 
  801599:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8015a0:	00 00 00 
	uint32 arr_size = 0;
  8015a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8015aa:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8015b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015b9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015be:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8015c3:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8015ca:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8015cd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8015d4:	a1 20 51 80 00       	mov    0x805120,%eax
  8015d9:	c1 e0 04             	shl    $0x4,%eax
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	48                   	dec    %eax
  8015e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ef:	f7 75 ec             	divl   -0x14(%ebp)
  8015f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f5:	29 d0                	sub    %edx,%eax
  8015f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8015fa:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801604:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801609:	2d 00 10 00 00       	sub    $0x1000,%eax
  80160e:	83 ec 04             	sub    $0x4,%esp
  801611:	6a 06                	push   $0x6
  801613:	ff 75 f4             	pushl  -0xc(%ebp)
  801616:	50                   	push   %eax
  801617:	e8 b5 03 00 00       	call   8019d1 <sys_allocate_chunk>
  80161c:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80161f:	a1 20 51 80 00       	mov    0x805120,%eax
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	50                   	push   %eax
  801628:	e8 2a 0a 00 00       	call   802057 <initialize_MemBlocksList>
  80162d:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801630:	a1 48 51 80 00       	mov    0x805148,%eax
  801635:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801638:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801645:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  80164c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801650:	75 14                	jne    801666 <initialize_dyn_block_system+0x105>
  801652:	83 ec 04             	sub    $0x4,%esp
  801655:	68 d5 3d 80 00       	push   $0x803dd5
  80165a:	6a 33                	push   $0x33
  80165c:	68 f3 3d 80 00       	push   $0x803df3
  801661:	e8 8c ee ff ff       	call   8004f2 <_panic>
  801666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801669:	8b 00                	mov    (%eax),%eax
  80166b:	85 c0                	test   %eax,%eax
  80166d:	74 10                	je     80167f <initialize_dyn_block_system+0x11e>
  80166f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801672:	8b 00                	mov    (%eax),%eax
  801674:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801677:	8b 52 04             	mov    0x4(%edx),%edx
  80167a:	89 50 04             	mov    %edx,0x4(%eax)
  80167d:	eb 0b                	jmp    80168a <initialize_dyn_block_system+0x129>
  80167f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801682:	8b 40 04             	mov    0x4(%eax),%eax
  801685:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80168a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80168d:	8b 40 04             	mov    0x4(%eax),%eax
  801690:	85 c0                	test   %eax,%eax
  801692:	74 0f                	je     8016a3 <initialize_dyn_block_system+0x142>
  801694:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801697:	8b 40 04             	mov    0x4(%eax),%eax
  80169a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80169d:	8b 12                	mov    (%edx),%edx
  80169f:	89 10                	mov    %edx,(%eax)
  8016a1:	eb 0a                	jmp    8016ad <initialize_dyn_block_system+0x14c>
  8016a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a6:	8b 00                	mov    (%eax),%eax
  8016a8:	a3 48 51 80 00       	mov    %eax,0x805148
  8016ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8016c5:	48                   	dec    %eax
  8016c6:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8016cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016cf:	75 14                	jne    8016e5 <initialize_dyn_block_system+0x184>
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	68 00 3e 80 00       	push   $0x803e00
  8016d9:	6a 34                	push   $0x34
  8016db:	68 f3 3d 80 00       	push   $0x803df3
  8016e0:	e8 0d ee ff ff       	call   8004f2 <_panic>
  8016e5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8016eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ee:	89 10                	mov    %edx,(%eax)
  8016f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016f3:	8b 00                	mov    (%eax),%eax
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	74 0d                	je     801706 <initialize_dyn_block_system+0x1a5>
  8016f9:	a1 38 51 80 00       	mov    0x805138,%eax
  8016fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801701:	89 50 04             	mov    %edx,0x4(%eax)
  801704:	eb 08                	jmp    80170e <initialize_dyn_block_system+0x1ad>
  801706:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801709:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80170e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801711:	a3 38 51 80 00       	mov    %eax,0x805138
  801716:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801719:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801720:	a1 44 51 80 00       	mov    0x805144,%eax
  801725:	40                   	inc    %eax
  801726:	a3 44 51 80 00       	mov    %eax,0x805144
}
  80172b:	90                   	nop
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801734:	e8 f7 fd ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  801739:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80173d:	75 07                	jne    801746 <malloc+0x18>
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
  801744:	eb 14                	jmp    80175a <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 24 3e 80 00       	push   $0x803e24
  80174e:	6a 46                	push   $0x46
  801750:	68 f3 3d 80 00       	push   $0x803df3
  801755:	e8 98 ed ff ff       	call   8004f2 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	68 4c 3e 80 00       	push   $0x803e4c
  80176a:	6a 61                	push   $0x61
  80176c:	68 f3 3d 80 00       	push   $0x803df3
  801771:	e8 7c ed ff ff       	call   8004f2 <_panic>

00801776 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 18             	sub    $0x18,%esp
  80177c:	8b 45 10             	mov    0x10(%ebp),%eax
  80177f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801782:	e8 a9 fd ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  801787:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178b:	75 07                	jne    801794 <smalloc+0x1e>
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
  801792:	eb 14                	jmp    8017a8 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	68 70 3e 80 00       	push   $0x803e70
  80179c:	6a 76                	push   $0x76
  80179e:	68 f3 3d 80 00       	push   $0x803df3
  8017a3:	e8 4a ed ff ff       	call   8004f2 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017b0:	e8 7b fd ff ff       	call   801530 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	68 98 3e 80 00       	push   $0x803e98
  8017bd:	68 93 00 00 00       	push   $0x93
  8017c2:	68 f3 3d 80 00       	push   $0x803df3
  8017c7:	e8 26 ed ff ff       	call   8004f2 <_panic>

008017cc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017d2:	e8 59 fd ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	68 bc 3e 80 00       	push   $0x803ebc
  8017df:	68 c5 00 00 00       	push   $0xc5
  8017e4:	68 f3 3d 80 00       	push   $0x803df3
  8017e9:	e8 04 ed ff ff       	call   8004f2 <_panic>

008017ee <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	68 e4 3e 80 00       	push   $0x803ee4
  8017fc:	68 d9 00 00 00       	push   $0xd9
  801801:	68 f3 3d 80 00       	push   $0x803df3
  801806:	e8 e7 ec ff ff       	call   8004f2 <_panic>

0080180b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	68 08 3f 80 00       	push   $0x803f08
  801819:	68 e4 00 00 00       	push   $0xe4
  80181e:	68 f3 3d 80 00       	push   $0x803df3
  801823:	e8 ca ec ff ff       	call   8004f2 <_panic>

00801828 <shrink>:

}
void shrink(uint32 newSize)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182e:	83 ec 04             	sub    $0x4,%esp
  801831:	68 08 3f 80 00       	push   $0x803f08
  801836:	68 e9 00 00 00       	push   $0xe9
  80183b:	68 f3 3d 80 00       	push   $0x803df3
  801840:	e8 ad ec ff ff       	call   8004f2 <_panic>

00801845 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	68 08 3f 80 00       	push   $0x803f08
  801853:	68 ee 00 00 00       	push   $0xee
  801858:	68 f3 3d 80 00       	push   $0x803df3
  80185d:	e8 90 ec ff ff       	call   8004f2 <_panic>

00801862 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	57                   	push   %edi
  801866:	56                   	push   %esi
  801867:	53                   	push   %ebx
  801868:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801871:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801874:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801877:	8b 7d 18             	mov    0x18(%ebp),%edi
  80187a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80187d:	cd 30                	int    $0x30
  80187f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801882:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	5b                   	pop    %ebx
  801889:	5e                   	pop    %esi
  80188a:	5f                   	pop    %edi
  80188b:	5d                   	pop    %ebp
  80188c:	c3                   	ret    

0080188d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	8b 45 10             	mov    0x10(%ebp),%eax
  801896:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801899:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	52                   	push   %edx
  8018a5:	ff 75 0c             	pushl  0xc(%ebp)
  8018a8:	50                   	push   %eax
  8018a9:	6a 00                	push   $0x0
  8018ab:	e8 b2 ff ff ff       	call   801862 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	90                   	nop
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 01                	push   $0x1
  8018c5:	e8 98 ff ff ff       	call   801862 <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	52                   	push   %edx
  8018df:	50                   	push   %eax
  8018e0:	6a 05                	push   $0x5
  8018e2:	e8 7b ff ff ff       	call   801862 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	56                   	push   %esi
  8018f0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8018f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	56                   	push   %esi
  801901:	53                   	push   %ebx
  801902:	51                   	push   %ecx
  801903:	52                   	push   %edx
  801904:	50                   	push   %eax
  801905:	6a 06                	push   $0x6
  801907:	e8 56 ff ff ff       	call   801862 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801912:	5b                   	pop    %ebx
  801913:	5e                   	pop    %esi
  801914:	5d                   	pop    %ebp
  801915:	c3                   	ret    

00801916 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	52                   	push   %edx
  801926:	50                   	push   %eax
  801927:	6a 07                	push   $0x7
  801929:	e8 34 ff ff ff       	call   801862 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	ff 75 0c             	pushl  0xc(%ebp)
  80193f:	ff 75 08             	pushl  0x8(%ebp)
  801942:	6a 08                	push   $0x8
  801944:	e8 19 ff ff ff       	call   801862 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 09                	push   $0x9
  80195d:	e8 00 ff ff ff       	call   801862 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 0a                	push   $0xa
  801976:	e8 e7 fe ff ff       	call   801862 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 0b                	push   $0xb
  80198f:	e8 ce fe ff ff       	call   801862 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	ff 75 08             	pushl  0x8(%ebp)
  8019a8:	6a 0f                	push   $0xf
  8019aa:	e8 b3 fe ff ff       	call   801862 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
	return;
  8019b2:	90                   	nop
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	ff 75 08             	pushl  0x8(%ebp)
  8019c4:	6a 10                	push   $0x10
  8019c6:	e8 97 fe ff ff       	call   801862 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ce:	90                   	nop
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	ff 75 10             	pushl  0x10(%ebp)
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	6a 11                	push   $0x11
  8019e3:	e8 7a fe ff ff       	call   801862 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019eb:	90                   	nop
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 0c                	push   $0xc
  8019fd:	e8 60 fe ff ff       	call   801862 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	ff 75 08             	pushl  0x8(%ebp)
  801a15:	6a 0d                	push   $0xd
  801a17:	e8 46 fe ff ff       	call   801862 <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 0e                	push   $0xe
  801a30:	e8 2d fe ff ff       	call   801862 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	90                   	nop
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 13                	push   $0x13
  801a4a:	e8 13 fe ff ff       	call   801862 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	90                   	nop
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 14                	push   $0x14
  801a64:	e8 f9 fd ff ff       	call   801862 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	90                   	nop
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_cputc>:


void
sys_cputc(const char c)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a7b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	50                   	push   %eax
  801a88:	6a 15                	push   $0x15
  801a8a:	e8 d3 fd ff ff       	call   801862 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	90                   	nop
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 16                	push   $0x16
  801aa4:	e8 b9 fd ff ff       	call   801862 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	ff 75 0c             	pushl  0xc(%ebp)
  801abe:	50                   	push   %eax
  801abf:	6a 17                	push   $0x17
  801ac1:	e8 9c fd ff ff       	call   801862 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ace:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	52                   	push   %edx
  801adb:	50                   	push   %eax
  801adc:	6a 1a                	push   $0x1a
  801ade:	e8 7f fd ff ff       	call   801862 <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	52                   	push   %edx
  801af8:	50                   	push   %eax
  801af9:	6a 18                	push   $0x18
  801afb:	e8 62 fd ff ff       	call   801862 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	90                   	nop
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	6a 19                	push   $0x19
  801b19:	e8 44 fd ff ff       	call   801862 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 04             	sub    $0x4,%esp
  801b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b30:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b33:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	51                   	push   %ecx
  801b3d:	52                   	push   %edx
  801b3e:	ff 75 0c             	pushl  0xc(%ebp)
  801b41:	50                   	push   %eax
  801b42:	6a 1b                	push   $0x1b
  801b44:	e8 19 fd ff ff       	call   801862 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	52                   	push   %edx
  801b5e:	50                   	push   %eax
  801b5f:	6a 1c                	push   $0x1c
  801b61:	e8 fc fc ff ff       	call   801862 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	51                   	push   %ecx
  801b7c:	52                   	push   %edx
  801b7d:	50                   	push   %eax
  801b7e:	6a 1d                	push   $0x1d
  801b80:	e8 dd fc ff ff       	call   801862 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	52                   	push   %edx
  801b9a:	50                   	push   %eax
  801b9b:	6a 1e                	push   $0x1e
  801b9d:	e8 c0 fc ff ff       	call   801862 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 1f                	push   $0x1f
  801bb6:	e8 a7 fc ff ff       	call   801862 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	ff 75 14             	pushl  0x14(%ebp)
  801bcb:	ff 75 10             	pushl  0x10(%ebp)
  801bce:	ff 75 0c             	pushl  0xc(%ebp)
  801bd1:	50                   	push   %eax
  801bd2:	6a 20                	push   $0x20
  801bd4:	e8 89 fc ff ff       	call   801862 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	50                   	push   %eax
  801bed:	6a 21                	push   $0x21
  801bef:	e8 6e fc ff ff       	call   801862 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	90                   	nop
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	50                   	push   %eax
  801c09:	6a 22                	push   $0x22
  801c0b:	e8 52 fc ff ff       	call   801862 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 02                	push   $0x2
  801c24:	e8 39 fc ff ff       	call   801862 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 03                	push   $0x3
  801c3d:	e8 20 fc ff ff       	call   801862 <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 04                	push   $0x4
  801c56:	e8 07 fc ff ff       	call   801862 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_exit_env>:


void sys_exit_env(void)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 23                	push   $0x23
  801c6f:	e8 ee fb ff ff       	call   801862 <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
}
  801c77:	90                   	nop
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c80:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c83:	8d 50 04             	lea    0x4(%eax),%edx
  801c86:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	52                   	push   %edx
  801c90:	50                   	push   %eax
  801c91:	6a 24                	push   $0x24
  801c93:	e8 ca fb ff ff       	call   801862 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
	return result;
  801c9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca4:	89 01                	mov    %eax,(%ecx)
  801ca6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	c9                   	leave  
  801cad:	c2 04 00             	ret    $0x4

00801cb0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	ff 75 10             	pushl  0x10(%ebp)
  801cba:	ff 75 0c             	pushl  0xc(%ebp)
  801cbd:	ff 75 08             	pushl  0x8(%ebp)
  801cc0:	6a 12                	push   $0x12
  801cc2:	e8 9b fb ff ff       	call   801862 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cca:	90                   	nop
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_rcr2>:
uint32 sys_rcr2()
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 25                	push   $0x25
  801cdc:	e8 81 fb ff ff       	call   801862 <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 04             	sub    $0x4,%esp
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cf2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	50                   	push   %eax
  801cff:	6a 26                	push   $0x26
  801d01:	e8 5c fb ff ff       	call   801862 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
	return ;
  801d09:	90                   	nop
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <rsttst>:
void rsttst()
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 28                	push   $0x28
  801d1b:	e8 42 fb ff ff       	call   801862 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return ;
  801d23:	90                   	nop
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d32:	8b 55 18             	mov    0x18(%ebp),%edx
  801d35:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d39:	52                   	push   %edx
  801d3a:	50                   	push   %eax
  801d3b:	ff 75 10             	pushl  0x10(%ebp)
  801d3e:	ff 75 0c             	pushl  0xc(%ebp)
  801d41:	ff 75 08             	pushl  0x8(%ebp)
  801d44:	6a 27                	push   $0x27
  801d46:	e8 17 fb ff ff       	call   801862 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4e:	90                   	nop
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <chktst>:
void chktst(uint32 n)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	ff 75 08             	pushl  0x8(%ebp)
  801d5f:	6a 29                	push   $0x29
  801d61:	e8 fc fa ff ff       	call   801862 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
	return ;
  801d69:	90                   	nop
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <inctst>:

void inctst()
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 2a                	push   $0x2a
  801d7b:	e8 e2 fa ff ff       	call   801862 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
	return ;
  801d83:	90                   	nop
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <gettst>:
uint32 gettst()
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 2b                	push   $0x2b
  801d95:	e8 c8 fa ff ff       	call   801862 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 2c                	push   $0x2c
  801db1:	e8 ac fa ff ff       	call   801862 <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
  801db9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dbc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dc0:	75 07                	jne    801dc9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc7:	eb 05                	jmp    801dce <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 2c                	push   $0x2c
  801de2:	e8 7b fa ff ff       	call   801862 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
  801dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ded:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801df1:	75 07                	jne    801dfa <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801df3:	b8 01 00 00 00       	mov    $0x1,%eax
  801df8:	eb 05                	jmp    801dff <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 2c                	push   $0x2c
  801e13:	e8 4a fa ff ff       	call   801862 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
  801e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e1e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e22:	75 07                	jne    801e2b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e24:	b8 01 00 00 00       	mov    $0x1,%eax
  801e29:	eb 05                	jmp    801e30 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 2c                	push   $0x2c
  801e44:	e8 19 fa ff ff       	call   801862 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
  801e4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e4f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e53:	75 07                	jne    801e5c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e55:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5a:	eb 05                	jmp    801e61 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	ff 75 08             	pushl  0x8(%ebp)
  801e71:	6a 2d                	push   $0x2d
  801e73:	e8 ea f9 ff ff       	call   801862 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7b:	90                   	nop
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e82:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e85:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	6a 00                	push   $0x0
  801e90:	53                   	push   %ebx
  801e91:	51                   	push   %ecx
  801e92:	52                   	push   %edx
  801e93:	50                   	push   %eax
  801e94:	6a 2e                	push   $0x2e
  801e96:	e8 c7 f9 ff ff       	call   801862 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
}
  801e9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ea6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	52                   	push   %edx
  801eb3:	50                   	push   %eax
  801eb4:	6a 2f                	push   $0x2f
  801eb6:	e8 a7 f9 ff ff       	call   801862 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ec6:	83 ec 0c             	sub    $0xc,%esp
  801ec9:	68 18 3f 80 00       	push   $0x803f18
  801ece:	e8 d3 e8 ff ff       	call   8007a6 <cprintf>
  801ed3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ed6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	68 44 3f 80 00       	push   $0x803f44
  801ee5:	e8 bc e8 ff ff       	call   8007a6 <cprintf>
  801eea:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eed:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ef1:	a1 38 51 80 00       	mov    0x805138,%eax
  801ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef9:	eb 56                	jmp    801f51 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801efb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eff:	74 1c                	je     801f1d <print_mem_block_lists+0x5d>
  801f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f04:	8b 50 08             	mov    0x8(%eax),%edx
  801f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f10:	8b 40 0c             	mov    0xc(%eax),%eax
  801f13:	01 c8                	add    %ecx,%eax
  801f15:	39 c2                	cmp    %eax,%edx
  801f17:	73 04                	jae    801f1d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f19:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f20:	8b 50 08             	mov    0x8(%eax),%edx
  801f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f26:	8b 40 0c             	mov    0xc(%eax),%eax
  801f29:	01 c2                	add    %eax,%edx
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	8b 40 08             	mov    0x8(%eax),%eax
  801f31:	83 ec 04             	sub    $0x4,%esp
  801f34:	52                   	push   %edx
  801f35:	50                   	push   %eax
  801f36:	68 59 3f 80 00       	push   $0x803f59
  801f3b:	e8 66 e8 ff ff       	call   8007a6 <cprintf>
  801f40:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f46:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f49:	a1 40 51 80 00       	mov    0x805140,%eax
  801f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f55:	74 07                	je     801f5e <print_mem_block_lists+0x9e>
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	8b 00                	mov    (%eax),%eax
  801f5c:	eb 05                	jmp    801f63 <print_mem_block_lists+0xa3>
  801f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f63:	a3 40 51 80 00       	mov    %eax,0x805140
  801f68:	a1 40 51 80 00       	mov    0x805140,%eax
  801f6d:	85 c0                	test   %eax,%eax
  801f6f:	75 8a                	jne    801efb <print_mem_block_lists+0x3b>
  801f71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f75:	75 84                	jne    801efb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f77:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f7b:	75 10                	jne    801f8d <print_mem_block_lists+0xcd>
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	68 68 3f 80 00       	push   $0x803f68
  801f85:	e8 1c e8 ff ff       	call   8007a6 <cprintf>
  801f8a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f8d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f94:	83 ec 0c             	sub    $0xc,%esp
  801f97:	68 8c 3f 80 00       	push   $0x803f8c
  801f9c:	e8 05 e8 ff ff       	call   8007a6 <cprintf>
  801fa1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fa4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fa8:	a1 40 50 80 00       	mov    0x805040,%eax
  801fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb0:	eb 56                	jmp    802008 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb6:	74 1c                	je     801fd4 <print_mem_block_lists+0x114>
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	8b 50 08             	mov    0x8(%eax),%edx
  801fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc1:	8b 48 08             	mov    0x8(%eax),%ecx
  801fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc7:	8b 40 0c             	mov    0xc(%eax),%eax
  801fca:	01 c8                	add    %ecx,%eax
  801fcc:	39 c2                	cmp    %eax,%edx
  801fce:	73 04                	jae    801fd4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fd0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd7:	8b 50 08             	mov    0x8(%eax),%edx
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe0:	01 c2                	add    %eax,%edx
  801fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe5:	8b 40 08             	mov    0x8(%eax),%eax
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	52                   	push   %edx
  801fec:	50                   	push   %eax
  801fed:	68 59 3f 80 00       	push   $0x803f59
  801ff2:	e8 af e7 ff ff       	call   8007a6 <cprintf>
  801ff7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802000:	a1 48 50 80 00       	mov    0x805048,%eax
  802005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802008:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200c:	74 07                	je     802015 <print_mem_block_lists+0x155>
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	8b 00                	mov    (%eax),%eax
  802013:	eb 05                	jmp    80201a <print_mem_block_lists+0x15a>
  802015:	b8 00 00 00 00       	mov    $0x0,%eax
  80201a:	a3 48 50 80 00       	mov    %eax,0x805048
  80201f:	a1 48 50 80 00       	mov    0x805048,%eax
  802024:	85 c0                	test   %eax,%eax
  802026:	75 8a                	jne    801fb2 <print_mem_block_lists+0xf2>
  802028:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202c:	75 84                	jne    801fb2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80202e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802032:	75 10                	jne    802044 <print_mem_block_lists+0x184>
  802034:	83 ec 0c             	sub    $0xc,%esp
  802037:	68 a4 3f 80 00       	push   $0x803fa4
  80203c:	e8 65 e7 ff ff       	call   8007a6 <cprintf>
  802041:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802044:	83 ec 0c             	sub    $0xc,%esp
  802047:	68 18 3f 80 00       	push   $0x803f18
  80204c:	e8 55 e7 ff ff       	call   8007a6 <cprintf>
  802051:	83 c4 10             	add    $0x10,%esp

}
  802054:	90                   	nop
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80205d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802064:	00 00 00 
  802067:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80206e:	00 00 00 
  802071:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802078:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80207b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802082:	e9 9e 00 00 00       	jmp    802125 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802087:	a1 50 50 80 00       	mov    0x805050,%eax
  80208c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208f:	c1 e2 04             	shl    $0x4,%edx
  802092:	01 d0                	add    %edx,%eax
  802094:	85 c0                	test   %eax,%eax
  802096:	75 14                	jne    8020ac <initialize_MemBlocksList+0x55>
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	68 cc 3f 80 00       	push   $0x803fcc
  8020a0:	6a 46                	push   $0x46
  8020a2:	68 ef 3f 80 00       	push   $0x803fef
  8020a7:	e8 46 e4 ff ff       	call   8004f2 <_panic>
  8020ac:	a1 50 50 80 00       	mov    0x805050,%eax
  8020b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b4:	c1 e2 04             	shl    $0x4,%edx
  8020b7:	01 d0                	add    %edx,%eax
  8020b9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020bf:	89 10                	mov    %edx,(%eax)
  8020c1:	8b 00                	mov    (%eax),%eax
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	74 18                	je     8020df <initialize_MemBlocksList+0x88>
  8020c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8020cc:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020d2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020d5:	c1 e1 04             	shl    $0x4,%ecx
  8020d8:	01 ca                	add    %ecx,%edx
  8020da:	89 50 04             	mov    %edx,0x4(%eax)
  8020dd:	eb 12                	jmp    8020f1 <initialize_MemBlocksList+0x9a>
  8020df:	a1 50 50 80 00       	mov    0x805050,%eax
  8020e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e7:	c1 e2 04             	shl    $0x4,%edx
  8020ea:	01 d0                	add    %edx,%eax
  8020ec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020f1:	a1 50 50 80 00       	mov    0x805050,%eax
  8020f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f9:	c1 e2 04             	shl    $0x4,%edx
  8020fc:	01 d0                	add    %edx,%eax
  8020fe:	a3 48 51 80 00       	mov    %eax,0x805148
  802103:	a1 50 50 80 00       	mov    0x805050,%eax
  802108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210b:	c1 e2 04             	shl    $0x4,%edx
  80210e:	01 d0                	add    %edx,%eax
  802110:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802117:	a1 54 51 80 00       	mov    0x805154,%eax
  80211c:	40                   	inc    %eax
  80211d:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802122:	ff 45 f4             	incl   -0xc(%ebp)
  802125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802128:	3b 45 08             	cmp    0x8(%ebp),%eax
  80212b:	0f 82 56 ff ff ff    	jb     802087 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802131:	90                   	nop
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802142:	eb 19                	jmp    80215d <find_block+0x29>
	{
		if(va==point->sva)
  802144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802147:	8b 40 08             	mov    0x8(%eax),%eax
  80214a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80214d:	75 05                	jne    802154 <find_block+0x20>
		   return point;
  80214f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802152:	eb 36                	jmp    80218a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	8b 40 08             	mov    0x8(%eax),%eax
  80215a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80215d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802161:	74 07                	je     80216a <find_block+0x36>
  802163:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802166:	8b 00                	mov    (%eax),%eax
  802168:	eb 05                	jmp    80216f <find_block+0x3b>
  80216a:	b8 00 00 00 00       	mov    $0x0,%eax
  80216f:	8b 55 08             	mov    0x8(%ebp),%edx
  802172:	89 42 08             	mov    %eax,0x8(%edx)
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	8b 40 08             	mov    0x8(%eax),%eax
  80217b:	85 c0                	test   %eax,%eax
  80217d:	75 c5                	jne    802144 <find_block+0x10>
  80217f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802183:	75 bf                	jne    802144 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802185:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802192:	a1 40 50 80 00       	mov    0x805040,%eax
  802197:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80219a:	a1 44 50 80 00       	mov    0x805044,%eax
  80219f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021a8:	74 24                	je     8021ce <insert_sorted_allocList+0x42>
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	8b 50 08             	mov    0x8(%eax),%edx
  8021b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b3:	8b 40 08             	mov    0x8(%eax),%eax
  8021b6:	39 c2                	cmp    %eax,%edx
  8021b8:	76 14                	jbe    8021ce <insert_sorted_allocList+0x42>
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	8b 50 08             	mov    0x8(%eax),%edx
  8021c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c3:	8b 40 08             	mov    0x8(%eax),%eax
  8021c6:	39 c2                	cmp    %eax,%edx
  8021c8:	0f 82 60 01 00 00    	jb     80232e <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021d2:	75 65                	jne    802239 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d8:	75 14                	jne    8021ee <insert_sorted_allocList+0x62>
  8021da:	83 ec 04             	sub    $0x4,%esp
  8021dd:	68 cc 3f 80 00       	push   $0x803fcc
  8021e2:	6a 6b                	push   $0x6b
  8021e4:	68 ef 3f 80 00       	push   $0x803fef
  8021e9:	e8 04 e3 ff ff       	call   8004f2 <_panic>
  8021ee:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	89 10                	mov    %edx,(%eax)
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	8b 00                	mov    (%eax),%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	74 0d                	je     80220f <insert_sorted_allocList+0x83>
  802202:	a1 40 50 80 00       	mov    0x805040,%eax
  802207:	8b 55 08             	mov    0x8(%ebp),%edx
  80220a:	89 50 04             	mov    %edx,0x4(%eax)
  80220d:	eb 08                	jmp    802217 <insert_sorted_allocList+0x8b>
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	a3 44 50 80 00       	mov    %eax,0x805044
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	a3 40 50 80 00       	mov    %eax,0x805040
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802229:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80222e:	40                   	inc    %eax
  80222f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802234:	e9 dc 01 00 00       	jmp    802415 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8b 50 08             	mov    0x8(%eax),%edx
  80223f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802242:	8b 40 08             	mov    0x8(%eax),%eax
  802245:	39 c2                	cmp    %eax,%edx
  802247:	77 6c                	ja     8022b5 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802249:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80224d:	74 06                	je     802255 <insert_sorted_allocList+0xc9>
  80224f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802253:	75 14                	jne    802269 <insert_sorted_allocList+0xdd>
  802255:	83 ec 04             	sub    $0x4,%esp
  802258:	68 08 40 80 00       	push   $0x804008
  80225d:	6a 6f                	push   $0x6f
  80225f:	68 ef 3f 80 00       	push   $0x803fef
  802264:	e8 89 e2 ff ff       	call   8004f2 <_panic>
  802269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226c:	8b 50 04             	mov    0x4(%eax),%edx
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	89 50 04             	mov    %edx,0x4(%eax)
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80227b:	89 10                	mov    %edx,(%eax)
  80227d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802280:	8b 40 04             	mov    0x4(%eax),%eax
  802283:	85 c0                	test   %eax,%eax
  802285:	74 0d                	je     802294 <insert_sorted_allocList+0x108>
  802287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228a:	8b 40 04             	mov    0x4(%eax),%eax
  80228d:	8b 55 08             	mov    0x8(%ebp),%edx
  802290:	89 10                	mov    %edx,(%eax)
  802292:	eb 08                	jmp    80229c <insert_sorted_allocList+0x110>
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	a3 40 50 80 00       	mov    %eax,0x805040
  80229c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229f:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a2:	89 50 04             	mov    %edx,0x4(%eax)
  8022a5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022aa:	40                   	inc    %eax
  8022ab:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022b0:	e9 60 01 00 00       	jmp    802415 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	8b 50 08             	mov    0x8(%eax),%edx
  8022bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022be:	8b 40 08             	mov    0x8(%eax),%eax
  8022c1:	39 c2                	cmp    %eax,%edx
  8022c3:	0f 82 4c 01 00 00    	jb     802415 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022cd:	75 14                	jne    8022e3 <insert_sorted_allocList+0x157>
  8022cf:	83 ec 04             	sub    $0x4,%esp
  8022d2:	68 40 40 80 00       	push   $0x804040
  8022d7:	6a 73                	push   $0x73
  8022d9:	68 ef 3f 80 00       	push   $0x803fef
  8022de:	e8 0f e2 ff ff       	call   8004f2 <_panic>
  8022e3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	89 50 04             	mov    %edx,0x4(%eax)
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	8b 40 04             	mov    0x4(%eax),%eax
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	74 0c                	je     802305 <insert_sorted_allocList+0x179>
  8022f9:	a1 44 50 80 00       	mov    0x805044,%eax
  8022fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802301:	89 10                	mov    %edx,(%eax)
  802303:	eb 08                	jmp    80230d <insert_sorted_allocList+0x181>
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	a3 40 50 80 00       	mov    %eax,0x805040
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	a3 44 50 80 00       	mov    %eax,0x805044
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80231e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802323:	40                   	inc    %eax
  802324:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802329:	e9 e7 00 00 00       	jmp    802415 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80232e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802331:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802334:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80233b:	a1 40 50 80 00       	mov    0x805040,%eax
  802340:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802343:	e9 9d 00 00 00       	jmp    8023e5 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	8b 50 08             	mov    0x8(%eax),%edx
  802356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802359:	8b 40 08             	mov    0x8(%eax),%eax
  80235c:	39 c2                	cmp    %eax,%edx
  80235e:	76 7d                	jbe    8023dd <insert_sorted_allocList+0x251>
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	8b 50 08             	mov    0x8(%eax),%edx
  802366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802369:	8b 40 08             	mov    0x8(%eax),%eax
  80236c:	39 c2                	cmp    %eax,%edx
  80236e:	73 6d                	jae    8023dd <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802370:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802374:	74 06                	je     80237c <insert_sorted_allocList+0x1f0>
  802376:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80237a:	75 14                	jne    802390 <insert_sorted_allocList+0x204>
  80237c:	83 ec 04             	sub    $0x4,%esp
  80237f:	68 64 40 80 00       	push   $0x804064
  802384:	6a 7f                	push   $0x7f
  802386:	68 ef 3f 80 00       	push   $0x803fef
  80238b:	e8 62 e1 ff ff       	call   8004f2 <_panic>
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	8b 10                	mov    (%eax),%edx
  802395:	8b 45 08             	mov    0x8(%ebp),%eax
  802398:	89 10                	mov    %edx,(%eax)
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	8b 00                	mov    (%eax),%eax
  80239f:	85 c0                	test   %eax,%eax
  8023a1:	74 0b                	je     8023ae <insert_sorted_allocList+0x222>
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	8b 00                	mov    (%eax),%eax
  8023a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ab:	89 50 04             	mov    %edx,0x4(%eax)
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b4:	89 10                	mov    %edx,(%eax)
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bc:	89 50 04             	mov    %edx,0x4(%eax)
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	75 08                	jne    8023d0 <insert_sorted_allocList+0x244>
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	a3 44 50 80 00       	mov    %eax,0x805044
  8023d0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023d5:	40                   	inc    %eax
  8023d6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023db:	eb 39                	jmp    802416 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023dd:	a1 48 50 80 00       	mov    0x805048,%eax
  8023e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	74 07                	je     8023f2 <insert_sorted_allocList+0x266>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	eb 05                	jmp    8023f7 <insert_sorted_allocList+0x26b>
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f7:	a3 48 50 80 00       	mov    %eax,0x805048
  8023fc:	a1 48 50 80 00       	mov    0x805048,%eax
  802401:	85 c0                	test   %eax,%eax
  802403:	0f 85 3f ff ff ff    	jne    802348 <insert_sorted_allocList+0x1bc>
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	0f 85 35 ff ff ff    	jne    802348 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802413:	eb 01                	jmp    802416 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802415:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802416:	90                   	nop
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
  80241c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80241f:	a1 38 51 80 00       	mov    0x805138,%eax
  802424:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802427:	e9 85 01 00 00       	jmp    8025b1 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	8b 40 0c             	mov    0xc(%eax),%eax
  802432:	3b 45 08             	cmp    0x8(%ebp),%eax
  802435:	0f 82 6e 01 00 00    	jb     8025a9 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 40 0c             	mov    0xc(%eax),%eax
  802441:	3b 45 08             	cmp    0x8(%ebp),%eax
  802444:	0f 85 8a 00 00 00    	jne    8024d4 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80244a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244e:	75 17                	jne    802467 <alloc_block_FF+0x4e>
  802450:	83 ec 04             	sub    $0x4,%esp
  802453:	68 98 40 80 00       	push   $0x804098
  802458:	68 93 00 00 00       	push   $0x93
  80245d:	68 ef 3f 80 00       	push   $0x803fef
  802462:	e8 8b e0 ff ff       	call   8004f2 <_panic>
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	85 c0                	test   %eax,%eax
  80246e:	74 10                	je     802480 <alloc_block_FF+0x67>
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	8b 00                	mov    (%eax),%eax
  802475:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802478:	8b 52 04             	mov    0x4(%edx),%edx
  80247b:	89 50 04             	mov    %edx,0x4(%eax)
  80247e:	eb 0b                	jmp    80248b <alloc_block_FF+0x72>
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 40 04             	mov    0x4(%eax),%eax
  802486:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 40 04             	mov    0x4(%eax),%eax
  802491:	85 c0                	test   %eax,%eax
  802493:	74 0f                	je     8024a4 <alloc_block_FF+0x8b>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 40 04             	mov    0x4(%eax),%eax
  80249b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249e:	8b 12                	mov    (%edx),%edx
  8024a0:	89 10                	mov    %edx,(%eax)
  8024a2:	eb 0a                	jmp    8024ae <alloc_block_FF+0x95>
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 00                	mov    (%eax),%eax
  8024a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8024c6:	48                   	dec    %eax
  8024c7:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	e9 10 01 00 00       	jmp    8025e4 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024dd:	0f 86 c6 00 00 00    	jbe    8025a9 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024e3:	a1 48 51 80 00       	mov    0x805148,%eax
  8024e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 50 08             	mov    0x8(%eax),%edx
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fd:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802500:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802504:	75 17                	jne    80251d <alloc_block_FF+0x104>
  802506:	83 ec 04             	sub    $0x4,%esp
  802509:	68 98 40 80 00       	push   $0x804098
  80250e:	68 9b 00 00 00       	push   $0x9b
  802513:	68 ef 3f 80 00       	push   $0x803fef
  802518:	e8 d5 df ff ff       	call   8004f2 <_panic>
  80251d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	85 c0                	test   %eax,%eax
  802524:	74 10                	je     802536 <alloc_block_FF+0x11d>
  802526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802529:	8b 00                	mov    (%eax),%eax
  80252b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252e:	8b 52 04             	mov    0x4(%edx),%edx
  802531:	89 50 04             	mov    %edx,0x4(%eax)
  802534:	eb 0b                	jmp    802541 <alloc_block_FF+0x128>
  802536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802539:	8b 40 04             	mov    0x4(%eax),%eax
  80253c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802544:	8b 40 04             	mov    0x4(%eax),%eax
  802547:	85 c0                	test   %eax,%eax
  802549:	74 0f                	je     80255a <alloc_block_FF+0x141>
  80254b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254e:	8b 40 04             	mov    0x4(%eax),%eax
  802551:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802554:	8b 12                	mov    (%edx),%edx
  802556:	89 10                	mov    %edx,(%eax)
  802558:	eb 0a                	jmp    802564 <alloc_block_FF+0x14b>
  80255a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255d:	8b 00                	mov    (%eax),%eax
  80255f:	a3 48 51 80 00       	mov    %eax,0x805148
  802564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802567:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802570:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802577:	a1 54 51 80 00       	mov    0x805154,%eax
  80257c:	48                   	dec    %eax
  80257d:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 50 08             	mov    0x8(%eax),%edx
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	01 c2                	add    %eax,%edx
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 40 0c             	mov    0xc(%eax),%eax
  802599:	2b 45 08             	sub    0x8(%ebp),%eax
  80259c:	89 c2                	mov    %eax,%edx
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a7:	eb 3b                	jmp    8025e4 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025a9:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b5:	74 07                	je     8025be <alloc_block_FF+0x1a5>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	eb 05                	jmp    8025c3 <alloc_block_FF+0x1aa>
  8025be:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c3:	a3 40 51 80 00       	mov    %eax,0x805140
  8025c8:	a1 40 51 80 00       	mov    0x805140,%eax
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	0f 85 57 fe ff ff    	jne    80242c <alloc_block_FF+0x13>
  8025d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d9:	0f 85 4d fe ff ff    	jne    80242c <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e4:	c9                   	leave  
  8025e5:	c3                   	ret    

008025e6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025f3:	a1 38 51 80 00       	mov    0x805138,%eax
  8025f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fb:	e9 df 00 00 00       	jmp    8026df <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	8b 40 0c             	mov    0xc(%eax),%eax
  802606:	3b 45 08             	cmp    0x8(%ebp),%eax
  802609:	0f 82 c8 00 00 00    	jb     8026d7 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 40 0c             	mov    0xc(%eax),%eax
  802615:	3b 45 08             	cmp    0x8(%ebp),%eax
  802618:	0f 85 8a 00 00 00    	jne    8026a8 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80261e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802622:	75 17                	jne    80263b <alloc_block_BF+0x55>
  802624:	83 ec 04             	sub    $0x4,%esp
  802627:	68 98 40 80 00       	push   $0x804098
  80262c:	68 b7 00 00 00       	push   $0xb7
  802631:	68 ef 3f 80 00       	push   $0x803fef
  802636:	e8 b7 de ff ff       	call   8004f2 <_panic>
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 00                	mov    (%eax),%eax
  802640:	85 c0                	test   %eax,%eax
  802642:	74 10                	je     802654 <alloc_block_BF+0x6e>
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 00                	mov    (%eax),%eax
  802649:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264c:	8b 52 04             	mov    0x4(%edx),%edx
  80264f:	89 50 04             	mov    %edx,0x4(%eax)
  802652:	eb 0b                	jmp    80265f <alloc_block_BF+0x79>
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 40 04             	mov    0x4(%eax),%eax
  80265a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 40 04             	mov    0x4(%eax),%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	74 0f                	je     802678 <alloc_block_BF+0x92>
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 04             	mov    0x4(%eax),%eax
  80266f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802672:	8b 12                	mov    (%edx),%edx
  802674:	89 10                	mov    %edx,(%eax)
  802676:	eb 0a                	jmp    802682 <alloc_block_BF+0x9c>
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 00                	mov    (%eax),%eax
  80267d:	a3 38 51 80 00       	mov    %eax,0x805138
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802695:	a1 44 51 80 00       	mov    0x805144,%eax
  80269a:	48                   	dec    %eax
  80269b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	e9 4d 01 00 00       	jmp    8027f5 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b1:	76 24                	jbe    8026d7 <alloc_block_BF+0xf1>
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026bc:	73 19                	jae    8026d7 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026be:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 40 08             	mov    0x8(%eax),%eax
  8026d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026d7:	a1 40 51 80 00       	mov    0x805140,%eax
  8026dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e3:	74 07                	je     8026ec <alloc_block_BF+0x106>
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 00                	mov    (%eax),%eax
  8026ea:	eb 05                	jmp    8026f1 <alloc_block_BF+0x10b>
  8026ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f1:	a3 40 51 80 00       	mov    %eax,0x805140
  8026f6:	a1 40 51 80 00       	mov    0x805140,%eax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	0f 85 fd fe ff ff    	jne    802600 <alloc_block_BF+0x1a>
  802703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802707:	0f 85 f3 fe ff ff    	jne    802600 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80270d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802711:	0f 84 d9 00 00 00    	je     8027f0 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802717:	a1 48 51 80 00       	mov    0x805148,%eax
  80271c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80271f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802722:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802725:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272b:	8b 55 08             	mov    0x8(%ebp),%edx
  80272e:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802731:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802735:	75 17                	jne    80274e <alloc_block_BF+0x168>
  802737:	83 ec 04             	sub    $0x4,%esp
  80273a:	68 98 40 80 00       	push   $0x804098
  80273f:	68 c7 00 00 00       	push   $0xc7
  802744:	68 ef 3f 80 00       	push   $0x803fef
  802749:	e8 a4 dd ff ff       	call   8004f2 <_panic>
  80274e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	74 10                	je     802767 <alloc_block_BF+0x181>
  802757:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80275f:	8b 52 04             	mov    0x4(%edx),%edx
  802762:	89 50 04             	mov    %edx,0x4(%eax)
  802765:	eb 0b                	jmp    802772 <alloc_block_BF+0x18c>
  802767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802775:	8b 40 04             	mov    0x4(%eax),%eax
  802778:	85 c0                	test   %eax,%eax
  80277a:	74 0f                	je     80278b <alloc_block_BF+0x1a5>
  80277c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277f:	8b 40 04             	mov    0x4(%eax),%eax
  802782:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802785:	8b 12                	mov    (%edx),%edx
  802787:	89 10                	mov    %edx,(%eax)
  802789:	eb 0a                	jmp    802795 <alloc_block_BF+0x1af>
  80278b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	a3 48 51 80 00       	mov    %eax,0x805148
  802795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802798:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8027ad:	48                   	dec    %eax
  8027ae:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027b3:	83 ec 08             	sub    $0x8,%esp
  8027b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8027b9:	68 38 51 80 00       	push   $0x805138
  8027be:	e8 71 f9 ff ff       	call   802134 <find_block>
  8027c3:	83 c4 10             	add    $0x10,%esp
  8027c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027cc:	8b 50 08             	mov    0x8(%eax),%edx
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	01 c2                	add    %eax,%edx
  8027d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d7:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e0:	2b 45 08             	sub    0x8(%ebp),%eax
  8027e3:	89 c2                	mov    %eax,%edx
  8027e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e8:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ee:	eb 05                	jmp    8027f5 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f5:	c9                   	leave  
  8027f6:	c3                   	ret    

008027f7 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027f7:	55                   	push   %ebp
  8027f8:	89 e5                	mov    %esp,%ebp
  8027fa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027fd:	a1 28 50 80 00       	mov    0x805028,%eax
  802802:	85 c0                	test   %eax,%eax
  802804:	0f 85 de 01 00 00    	jne    8029e8 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80280a:	a1 38 51 80 00       	mov    0x805138,%eax
  80280f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802812:	e9 9e 01 00 00       	jmp    8029b5 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 40 0c             	mov    0xc(%eax),%eax
  80281d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802820:	0f 82 87 01 00 00    	jb     8029ad <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 40 0c             	mov    0xc(%eax),%eax
  80282c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282f:	0f 85 95 00 00 00    	jne    8028ca <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802839:	75 17                	jne    802852 <alloc_block_NF+0x5b>
  80283b:	83 ec 04             	sub    $0x4,%esp
  80283e:	68 98 40 80 00       	push   $0x804098
  802843:	68 e0 00 00 00       	push   $0xe0
  802848:	68 ef 3f 80 00       	push   $0x803fef
  80284d:	e8 a0 dc ff ff       	call   8004f2 <_panic>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	85 c0                	test   %eax,%eax
  802859:	74 10                	je     80286b <alloc_block_NF+0x74>
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802863:	8b 52 04             	mov    0x4(%edx),%edx
  802866:	89 50 04             	mov    %edx,0x4(%eax)
  802869:	eb 0b                	jmp    802876 <alloc_block_NF+0x7f>
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 40 04             	mov    0x4(%eax),%eax
  802871:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 40 04             	mov    0x4(%eax),%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	74 0f                	je     80288f <alloc_block_NF+0x98>
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 40 04             	mov    0x4(%eax),%eax
  802886:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802889:	8b 12                	mov    (%edx),%edx
  80288b:	89 10                	mov    %edx,(%eax)
  80288d:	eb 0a                	jmp    802899 <alloc_block_NF+0xa2>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	a3 38 51 80 00       	mov    %eax,0x805138
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8028b1:	48                   	dec    %eax
  8028b2:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 08             	mov    0x8(%eax),%eax
  8028bd:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	e9 f8 04 00 00       	jmp    802dc2 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d3:	0f 86 d4 00 00 00    	jbe    8029ad <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8028de:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 50 08             	mov    0x8(%eax),%edx
  8028e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ea:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f3:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028fa:	75 17                	jne    802913 <alloc_block_NF+0x11c>
  8028fc:	83 ec 04             	sub    $0x4,%esp
  8028ff:	68 98 40 80 00       	push   $0x804098
  802904:	68 e9 00 00 00       	push   $0xe9
  802909:	68 ef 3f 80 00       	push   $0x803fef
  80290e:	e8 df db ff ff       	call   8004f2 <_panic>
  802913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	85 c0                	test   %eax,%eax
  80291a:	74 10                	je     80292c <alloc_block_NF+0x135>
  80291c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291f:	8b 00                	mov    (%eax),%eax
  802921:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802924:	8b 52 04             	mov    0x4(%edx),%edx
  802927:	89 50 04             	mov    %edx,0x4(%eax)
  80292a:	eb 0b                	jmp    802937 <alloc_block_NF+0x140>
  80292c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292f:	8b 40 04             	mov    0x4(%eax),%eax
  802932:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	74 0f                	je     802950 <alloc_block_NF+0x159>
  802941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802944:	8b 40 04             	mov    0x4(%eax),%eax
  802947:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294a:	8b 12                	mov    (%edx),%edx
  80294c:	89 10                	mov    %edx,(%eax)
  80294e:	eb 0a                	jmp    80295a <alloc_block_NF+0x163>
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	8b 00                	mov    (%eax),%eax
  802955:	a3 48 51 80 00       	mov    %eax,0x805148
  80295a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802966:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296d:	a1 54 51 80 00       	mov    0x805154,%eax
  802972:	48                   	dec    %eax
  802973:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297b:	8b 40 08             	mov    0x8(%eax),%eax
  80297e:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 50 08             	mov    0x8(%eax),%edx
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	01 c2                	add    %eax,%edx
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 0c             	mov    0xc(%eax),%eax
  80299a:	2b 45 08             	sub    0x8(%ebp),%eax
  80299d:	89 c2                	mov    %eax,%edx
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a8:	e9 15 04 00 00       	jmp    802dc2 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8029b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b9:	74 07                	je     8029c2 <alloc_block_NF+0x1cb>
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 00                	mov    (%eax),%eax
  8029c0:	eb 05                	jmp    8029c7 <alloc_block_NF+0x1d0>
  8029c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c7:	a3 40 51 80 00       	mov    %eax,0x805140
  8029cc:	a1 40 51 80 00       	mov    0x805140,%eax
  8029d1:	85 c0                	test   %eax,%eax
  8029d3:	0f 85 3e fe ff ff    	jne    802817 <alloc_block_NF+0x20>
  8029d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029dd:	0f 85 34 fe ff ff    	jne    802817 <alloc_block_NF+0x20>
  8029e3:	e9 d5 03 00 00       	jmp    802dbd <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8029ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f0:	e9 b1 01 00 00       	jmp    802ba6 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f8:	8b 50 08             	mov    0x8(%eax),%edx
  8029fb:	a1 28 50 80 00       	mov    0x805028,%eax
  802a00:	39 c2                	cmp    %eax,%edx
  802a02:	0f 82 96 01 00 00    	jb     802b9e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a11:	0f 82 87 01 00 00    	jb     802b9e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a20:	0f 85 95 00 00 00    	jne    802abb <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2a:	75 17                	jne    802a43 <alloc_block_NF+0x24c>
  802a2c:	83 ec 04             	sub    $0x4,%esp
  802a2f:	68 98 40 80 00       	push   $0x804098
  802a34:	68 fc 00 00 00       	push   $0xfc
  802a39:	68 ef 3f 80 00       	push   $0x803fef
  802a3e:	e8 af da ff ff       	call   8004f2 <_panic>
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	74 10                	je     802a5c <alloc_block_NF+0x265>
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a54:	8b 52 04             	mov    0x4(%edx),%edx
  802a57:	89 50 04             	mov    %edx,0x4(%eax)
  802a5a:	eb 0b                	jmp    802a67 <alloc_block_NF+0x270>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 40 04             	mov    0x4(%eax),%eax
  802a62:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 40 04             	mov    0x4(%eax),%eax
  802a6d:	85 c0                	test   %eax,%eax
  802a6f:	74 0f                	je     802a80 <alloc_block_NF+0x289>
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 40 04             	mov    0x4(%eax),%eax
  802a77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7a:	8b 12                	mov    (%edx),%edx
  802a7c:	89 10                	mov    %edx,(%eax)
  802a7e:	eb 0a                	jmp    802a8a <alloc_block_NF+0x293>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	a3 38 51 80 00       	mov    %eax,0x805138
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9d:	a1 44 51 80 00       	mov    0x805144,%eax
  802aa2:	48                   	dec    %eax
  802aa3:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 40 08             	mov    0x8(%eax),%eax
  802aae:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	e9 07 03 00 00       	jmp    802dc2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac4:	0f 86 d4 00 00 00    	jbe    802b9e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aca:	a1 48 51 80 00       	mov    0x805148,%eax
  802acf:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 50 08             	mov    0x8(%eax),%edx
  802ad8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802adb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ae7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aeb:	75 17                	jne    802b04 <alloc_block_NF+0x30d>
  802aed:	83 ec 04             	sub    $0x4,%esp
  802af0:	68 98 40 80 00       	push   $0x804098
  802af5:	68 04 01 00 00       	push   $0x104
  802afa:	68 ef 3f 80 00       	push   $0x803fef
  802aff:	e8 ee d9 ff ff       	call   8004f2 <_panic>
  802b04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	74 10                	je     802b1d <alloc_block_NF+0x326>
  802b0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b15:	8b 52 04             	mov    0x4(%edx),%edx
  802b18:	89 50 04             	mov    %edx,0x4(%eax)
  802b1b:	eb 0b                	jmp    802b28 <alloc_block_NF+0x331>
  802b1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b20:	8b 40 04             	mov    0x4(%eax),%eax
  802b23:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2b:	8b 40 04             	mov    0x4(%eax),%eax
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	74 0f                	je     802b41 <alloc_block_NF+0x34a>
  802b32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b35:	8b 40 04             	mov    0x4(%eax),%eax
  802b38:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b3b:	8b 12                	mov    (%edx),%edx
  802b3d:	89 10                	mov    %edx,(%eax)
  802b3f:	eb 0a                	jmp    802b4b <alloc_block_NF+0x354>
  802b41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b44:	8b 00                	mov    (%eax),%eax
  802b46:	a3 48 51 80 00       	mov    %eax,0x805148
  802b4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5e:	a1 54 51 80 00       	mov    0x805154,%eax
  802b63:	48                   	dec    %eax
  802b64:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6c:	8b 40 08             	mov    0x8(%eax),%eax
  802b6f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 50 08             	mov    0x8(%eax),%edx
  802b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7d:	01 c2                	add    %eax,%edx
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8b:	2b 45 08             	sub    0x8(%ebp),%eax
  802b8e:	89 c2                	mov    %eax,%edx
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b99:	e9 24 02 00 00       	jmp    802dc2 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b9e:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802baa:	74 07                	je     802bb3 <alloc_block_NF+0x3bc>
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	eb 05                	jmp    802bb8 <alloc_block_NF+0x3c1>
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb8:	a3 40 51 80 00       	mov    %eax,0x805140
  802bbd:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	0f 85 2b fe ff ff    	jne    8029f5 <alloc_block_NF+0x1fe>
  802bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bce:	0f 85 21 fe ff ff    	jne    8029f5 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bd4:	a1 38 51 80 00       	mov    0x805138,%eax
  802bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bdc:	e9 ae 01 00 00       	jmp    802d8f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 50 08             	mov    0x8(%eax),%edx
  802be7:	a1 28 50 80 00       	mov    0x805028,%eax
  802bec:	39 c2                	cmp    %eax,%edx
  802bee:	0f 83 93 01 00 00    	jae    802d87 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bfd:	0f 82 84 01 00 00    	jb     802d87 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 40 0c             	mov    0xc(%eax),%eax
  802c09:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0c:	0f 85 95 00 00 00    	jne    802ca7 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c16:	75 17                	jne    802c2f <alloc_block_NF+0x438>
  802c18:	83 ec 04             	sub    $0x4,%esp
  802c1b:	68 98 40 80 00       	push   $0x804098
  802c20:	68 14 01 00 00       	push   $0x114
  802c25:	68 ef 3f 80 00       	push   $0x803fef
  802c2a:	e8 c3 d8 ff ff       	call   8004f2 <_panic>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	85 c0                	test   %eax,%eax
  802c36:	74 10                	je     802c48 <alloc_block_NF+0x451>
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c40:	8b 52 04             	mov    0x4(%edx),%edx
  802c43:	89 50 04             	mov    %edx,0x4(%eax)
  802c46:	eb 0b                	jmp    802c53 <alloc_block_NF+0x45c>
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 40 04             	mov    0x4(%eax),%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	74 0f                	je     802c6c <alloc_block_NF+0x475>
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 04             	mov    0x4(%eax),%eax
  802c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c66:	8b 12                	mov    (%edx),%edx
  802c68:	89 10                	mov    %edx,(%eax)
  802c6a:	eb 0a                	jmp    802c76 <alloc_block_NF+0x47f>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	a3 38 51 80 00       	mov    %eax,0x805138
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c89:	a1 44 51 80 00       	mov    0x805144,%eax
  802c8e:	48                   	dec    %eax
  802c8f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 08             	mov    0x8(%eax),%eax
  802c9a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	e9 1b 01 00 00       	jmp    802dc2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 40 0c             	mov    0xc(%eax),%eax
  802cad:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb0:	0f 86 d1 00 00 00    	jbe    802d87 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cb6:	a1 48 51 80 00       	mov    0x805148,%eax
  802cbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 50 08             	mov    0x8(%eax),%edx
  802cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccd:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cd7:	75 17                	jne    802cf0 <alloc_block_NF+0x4f9>
  802cd9:	83 ec 04             	sub    $0x4,%esp
  802cdc:	68 98 40 80 00       	push   $0x804098
  802ce1:	68 1c 01 00 00       	push   $0x11c
  802ce6:	68 ef 3f 80 00       	push   $0x803fef
  802ceb:	e8 02 d8 ff ff       	call   8004f2 <_panic>
  802cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf3:	8b 00                	mov    (%eax),%eax
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	74 10                	je     802d09 <alloc_block_NF+0x512>
  802cf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfc:	8b 00                	mov    (%eax),%eax
  802cfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d01:	8b 52 04             	mov    0x4(%edx),%edx
  802d04:	89 50 04             	mov    %edx,0x4(%eax)
  802d07:	eb 0b                	jmp    802d14 <alloc_block_NF+0x51d>
  802d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d17:	8b 40 04             	mov    0x4(%eax),%eax
  802d1a:	85 c0                	test   %eax,%eax
  802d1c:	74 0f                	je     802d2d <alloc_block_NF+0x536>
  802d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d21:	8b 40 04             	mov    0x4(%eax),%eax
  802d24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d27:	8b 12                	mov    (%edx),%edx
  802d29:	89 10                	mov    %edx,(%eax)
  802d2b:	eb 0a                	jmp    802d37 <alloc_block_NF+0x540>
  802d2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	a3 48 51 80 00       	mov    %eax,0x805148
  802d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4a:	a1 54 51 80 00       	mov    0x805154,%eax
  802d4f:	48                   	dec    %eax
  802d50:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d58:	8b 40 08             	mov    0x8(%eax),%eax
  802d5b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 50 08             	mov    0x8(%eax),%edx
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	01 c2                	add    %eax,%edx
  802d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 40 0c             	mov    0xc(%eax),%eax
  802d77:	2b 45 08             	sub    0x8(%ebp),%eax
  802d7a:	89 c2                	mov    %eax,%edx
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d85:	eb 3b                	jmp    802dc2 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d87:	a1 40 51 80 00       	mov    0x805140,%eax
  802d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d93:	74 07                	je     802d9c <alloc_block_NF+0x5a5>
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	eb 05                	jmp    802da1 <alloc_block_NF+0x5aa>
  802d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802da1:	a3 40 51 80 00       	mov    %eax,0x805140
  802da6:	a1 40 51 80 00       	mov    0x805140,%eax
  802dab:	85 c0                	test   %eax,%eax
  802dad:	0f 85 2e fe ff ff    	jne    802be1 <alloc_block_NF+0x3ea>
  802db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db7:	0f 85 24 fe ff ff    	jne    802be1 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802dbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc2:	c9                   	leave  
  802dc3:	c3                   	ret    

00802dc4 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802dc4:	55                   	push   %ebp
  802dc5:	89 e5                	mov    %esp,%ebp
  802dc7:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802dca:	a1 38 51 80 00       	mov    0x805138,%eax
  802dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802dd2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dd7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802dda:	a1 38 51 80 00       	mov    0x805138,%eax
  802ddf:	85 c0                	test   %eax,%eax
  802de1:	74 14                	je     802df7 <insert_sorted_with_merge_freeList+0x33>
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	8b 50 08             	mov    0x8(%eax),%edx
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	8b 40 08             	mov    0x8(%eax),%eax
  802def:	39 c2                	cmp    %eax,%edx
  802df1:	0f 87 9b 01 00 00    	ja     802f92 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802df7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfb:	75 17                	jne    802e14 <insert_sorted_with_merge_freeList+0x50>
  802dfd:	83 ec 04             	sub    $0x4,%esp
  802e00:	68 cc 3f 80 00       	push   $0x803fcc
  802e05:	68 38 01 00 00       	push   $0x138
  802e0a:	68 ef 3f 80 00       	push   $0x803fef
  802e0f:	e8 de d6 ff ff       	call   8004f2 <_panic>
  802e14:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	89 10                	mov    %edx,(%eax)
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	8b 00                	mov    (%eax),%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	74 0d                	je     802e35 <insert_sorted_with_merge_freeList+0x71>
  802e28:	a1 38 51 80 00       	mov    0x805138,%eax
  802e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e30:	89 50 04             	mov    %edx,0x4(%eax)
  802e33:	eb 08                	jmp    802e3d <insert_sorted_with_merge_freeList+0x79>
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	a3 38 51 80 00       	mov    %eax,0x805138
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4f:	a1 44 51 80 00       	mov    0x805144,%eax
  802e54:	40                   	inc    %eax
  802e55:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e5e:	0f 84 a8 06 00 00    	je     80350c <insert_sorted_with_merge_freeList+0x748>
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	8b 50 08             	mov    0x8(%eax),%edx
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e70:	01 c2                	add    %eax,%edx
  802e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e75:	8b 40 08             	mov    0x8(%eax),%eax
  802e78:	39 c2                	cmp    %eax,%edx
  802e7a:	0f 85 8c 06 00 00    	jne    80350c <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	8b 50 0c             	mov    0xc(%eax),%edx
  802e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e89:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8c:	01 c2                	add    %eax,%edx
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e98:	75 17                	jne    802eb1 <insert_sorted_with_merge_freeList+0xed>
  802e9a:	83 ec 04             	sub    $0x4,%esp
  802e9d:	68 98 40 80 00       	push   $0x804098
  802ea2:	68 3c 01 00 00       	push   $0x13c
  802ea7:	68 ef 3f 80 00       	push   $0x803fef
  802eac:	e8 41 d6 ff ff       	call   8004f2 <_panic>
  802eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb4:	8b 00                	mov    (%eax),%eax
  802eb6:	85 c0                	test   %eax,%eax
  802eb8:	74 10                	je     802eca <insert_sorted_with_merge_freeList+0x106>
  802eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec2:	8b 52 04             	mov    0x4(%edx),%edx
  802ec5:	89 50 04             	mov    %edx,0x4(%eax)
  802ec8:	eb 0b                	jmp    802ed5 <insert_sorted_with_merge_freeList+0x111>
  802eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecd:	8b 40 04             	mov    0x4(%eax),%eax
  802ed0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	85 c0                	test   %eax,%eax
  802edd:	74 0f                	je     802eee <insert_sorted_with_merge_freeList+0x12a>
  802edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee2:	8b 40 04             	mov    0x4(%eax),%eax
  802ee5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee8:	8b 12                	mov    (%edx),%edx
  802eea:	89 10                	mov    %edx,(%eax)
  802eec:	eb 0a                	jmp    802ef8 <insert_sorted_with_merge_freeList+0x134>
  802eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef1:	8b 00                	mov    (%eax),%eax
  802ef3:	a3 38 51 80 00       	mov    %eax,0x805138
  802ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0b:	a1 44 51 80 00       	mov    0x805144,%eax
  802f10:	48                   	dec    %eax
  802f11:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f19:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f2e:	75 17                	jne    802f47 <insert_sorted_with_merge_freeList+0x183>
  802f30:	83 ec 04             	sub    $0x4,%esp
  802f33:	68 cc 3f 80 00       	push   $0x803fcc
  802f38:	68 3f 01 00 00       	push   $0x13f
  802f3d:	68 ef 3f 80 00       	push   $0x803fef
  802f42:	e8 ab d5 ff ff       	call   8004f2 <_panic>
  802f47:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f50:	89 10                	mov    %edx,(%eax)
  802f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	74 0d                	je     802f68 <insert_sorted_with_merge_freeList+0x1a4>
  802f5b:	a1 48 51 80 00       	mov    0x805148,%eax
  802f60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f63:	89 50 04             	mov    %edx,0x4(%eax)
  802f66:	eb 08                	jmp    802f70 <insert_sorted_with_merge_freeList+0x1ac>
  802f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f73:	a3 48 51 80 00       	mov    %eax,0x805148
  802f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f82:	a1 54 51 80 00       	mov    0x805154,%eax
  802f87:	40                   	inc    %eax
  802f88:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f8d:	e9 7a 05 00 00       	jmp    80350c <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	8b 50 08             	mov    0x8(%eax),%edx
  802f98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9b:	8b 40 08             	mov    0x8(%eax),%eax
  802f9e:	39 c2                	cmp    %eax,%edx
  802fa0:	0f 82 14 01 00 00    	jb     8030ba <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa9:	8b 50 08             	mov    0x8(%eax),%edx
  802fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb2:	01 c2                	add    %eax,%edx
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	8b 40 08             	mov    0x8(%eax),%eax
  802fba:	39 c2                	cmp    %eax,%edx
  802fbc:	0f 85 90 00 00 00    	jne    803052 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc5:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fce:	01 c2                	add    %eax,%edx
  802fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd3:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fee:	75 17                	jne    803007 <insert_sorted_with_merge_freeList+0x243>
  802ff0:	83 ec 04             	sub    $0x4,%esp
  802ff3:	68 cc 3f 80 00       	push   $0x803fcc
  802ff8:	68 49 01 00 00       	push   $0x149
  802ffd:	68 ef 3f 80 00       	push   $0x803fef
  803002:	e8 eb d4 ff ff       	call   8004f2 <_panic>
  803007:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	89 10                	mov    %edx,(%eax)
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	85 c0                	test   %eax,%eax
  803019:	74 0d                	je     803028 <insert_sorted_with_merge_freeList+0x264>
  80301b:	a1 48 51 80 00       	mov    0x805148,%eax
  803020:	8b 55 08             	mov    0x8(%ebp),%edx
  803023:	89 50 04             	mov    %edx,0x4(%eax)
  803026:	eb 08                	jmp    803030 <insert_sorted_with_merge_freeList+0x26c>
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	a3 48 51 80 00       	mov    %eax,0x805148
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803042:	a1 54 51 80 00       	mov    0x805154,%eax
  803047:	40                   	inc    %eax
  803048:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80304d:	e9 bb 04 00 00       	jmp    80350d <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803052:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803056:	75 17                	jne    80306f <insert_sorted_with_merge_freeList+0x2ab>
  803058:	83 ec 04             	sub    $0x4,%esp
  80305b:	68 40 40 80 00       	push   $0x804040
  803060:	68 4c 01 00 00       	push   $0x14c
  803065:	68 ef 3f 80 00       	push   $0x803fef
  80306a:	e8 83 d4 ff ff       	call   8004f2 <_panic>
  80306f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	89 50 04             	mov    %edx,0x4(%eax)
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	8b 40 04             	mov    0x4(%eax),%eax
  803081:	85 c0                	test   %eax,%eax
  803083:	74 0c                	je     803091 <insert_sorted_with_merge_freeList+0x2cd>
  803085:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80308a:	8b 55 08             	mov    0x8(%ebp),%edx
  80308d:	89 10                	mov    %edx,(%eax)
  80308f:	eb 08                	jmp    803099 <insert_sorted_with_merge_freeList+0x2d5>
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	a3 38 51 80 00       	mov    %eax,0x805138
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8030af:	40                   	inc    %eax
  8030b0:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030b5:	e9 53 04 00 00       	jmp    80350d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8030bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030c2:	e9 15 04 00 00       	jmp    8034dc <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	8b 00                	mov    (%eax),%eax
  8030cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	8b 50 08             	mov    0x8(%eax),%edx
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	8b 40 08             	mov    0x8(%eax),%eax
  8030db:	39 c2                	cmp    %eax,%edx
  8030dd:	0f 86 f1 03 00 00    	jbe    8034d4 <insert_sorted_with_merge_freeList+0x710>
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	8b 50 08             	mov    0x8(%eax),%edx
  8030e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ec:	8b 40 08             	mov    0x8(%eax),%eax
  8030ef:	39 c2                	cmp    %eax,%edx
  8030f1:	0f 83 dd 03 00 00    	jae    8034d4 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	8b 50 08             	mov    0x8(%eax),%edx
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 40 0c             	mov    0xc(%eax),%eax
  803103:	01 c2                	add    %eax,%edx
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	8b 40 08             	mov    0x8(%eax),%eax
  80310b:	39 c2                	cmp    %eax,%edx
  80310d:	0f 85 b9 01 00 00    	jne    8032cc <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	8b 50 08             	mov    0x8(%eax),%edx
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	8b 40 0c             	mov    0xc(%eax),%eax
  80311f:	01 c2                	add    %eax,%edx
  803121:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803124:	8b 40 08             	mov    0x8(%eax),%eax
  803127:	39 c2                	cmp    %eax,%edx
  803129:	0f 85 0d 01 00 00    	jne    80323c <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	8b 50 0c             	mov    0xc(%eax),%edx
  803135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803138:	8b 40 0c             	mov    0xc(%eax),%eax
  80313b:	01 c2                	add    %eax,%edx
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803143:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803147:	75 17                	jne    803160 <insert_sorted_with_merge_freeList+0x39c>
  803149:	83 ec 04             	sub    $0x4,%esp
  80314c:	68 98 40 80 00       	push   $0x804098
  803151:	68 5c 01 00 00       	push   $0x15c
  803156:	68 ef 3f 80 00       	push   $0x803fef
  80315b:	e8 92 d3 ff ff       	call   8004f2 <_panic>
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	85 c0                	test   %eax,%eax
  803167:	74 10                	je     803179 <insert_sorted_with_merge_freeList+0x3b5>
  803169:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316c:	8b 00                	mov    (%eax),%eax
  80316e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803171:	8b 52 04             	mov    0x4(%edx),%edx
  803174:	89 50 04             	mov    %edx,0x4(%eax)
  803177:	eb 0b                	jmp    803184 <insert_sorted_with_merge_freeList+0x3c0>
  803179:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317c:	8b 40 04             	mov    0x4(%eax),%eax
  80317f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803187:	8b 40 04             	mov    0x4(%eax),%eax
  80318a:	85 c0                	test   %eax,%eax
  80318c:	74 0f                	je     80319d <insert_sorted_with_merge_freeList+0x3d9>
  80318e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803191:	8b 40 04             	mov    0x4(%eax),%eax
  803194:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803197:	8b 12                	mov    (%edx),%edx
  803199:	89 10                	mov    %edx,(%eax)
  80319b:	eb 0a                	jmp    8031a7 <insert_sorted_with_merge_freeList+0x3e3>
  80319d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a0:	8b 00                	mov    (%eax),%eax
  8031a2:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ba:	a1 44 51 80 00       	mov    0x805144,%eax
  8031bf:	48                   	dec    %eax
  8031c0:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031dd:	75 17                	jne    8031f6 <insert_sorted_with_merge_freeList+0x432>
  8031df:	83 ec 04             	sub    $0x4,%esp
  8031e2:	68 cc 3f 80 00       	push   $0x803fcc
  8031e7:	68 5f 01 00 00       	push   $0x15f
  8031ec:	68 ef 3f 80 00       	push   $0x803fef
  8031f1:	e8 fc d2 ff ff       	call   8004f2 <_panic>
  8031f6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803204:	8b 00                	mov    (%eax),%eax
  803206:	85 c0                	test   %eax,%eax
  803208:	74 0d                	je     803217 <insert_sorted_with_merge_freeList+0x453>
  80320a:	a1 48 51 80 00       	mov    0x805148,%eax
  80320f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803212:	89 50 04             	mov    %edx,0x4(%eax)
  803215:	eb 08                	jmp    80321f <insert_sorted_with_merge_freeList+0x45b>
  803217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80321f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803222:	a3 48 51 80 00       	mov    %eax,0x805148
  803227:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803231:	a1 54 51 80 00       	mov    0x805154,%eax
  803236:	40                   	inc    %eax
  803237:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80323c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323f:	8b 50 0c             	mov    0xc(%eax),%edx
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	8b 40 0c             	mov    0xc(%eax),%eax
  803248:	01 c2                	add    %eax,%edx
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803264:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803268:	75 17                	jne    803281 <insert_sorted_with_merge_freeList+0x4bd>
  80326a:	83 ec 04             	sub    $0x4,%esp
  80326d:	68 cc 3f 80 00       	push   $0x803fcc
  803272:	68 64 01 00 00       	push   $0x164
  803277:	68 ef 3f 80 00       	push   $0x803fef
  80327c:	e8 71 d2 ff ff       	call   8004f2 <_panic>
  803281:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	89 10                	mov    %edx,(%eax)
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	8b 00                	mov    (%eax),%eax
  803291:	85 c0                	test   %eax,%eax
  803293:	74 0d                	je     8032a2 <insert_sorted_with_merge_freeList+0x4de>
  803295:	a1 48 51 80 00       	mov    0x805148,%eax
  80329a:	8b 55 08             	mov    0x8(%ebp),%edx
  80329d:	89 50 04             	mov    %edx,0x4(%eax)
  8032a0:	eb 08                	jmp    8032aa <insert_sorted_with_merge_freeList+0x4e6>
  8032a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	a3 48 51 80 00       	mov    %eax,0x805148
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032bc:	a1 54 51 80 00       	mov    0x805154,%eax
  8032c1:	40                   	inc    %eax
  8032c2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032c7:	e9 41 02 00 00       	jmp    80350d <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	8b 50 08             	mov    0x8(%eax),%edx
  8032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d8:	01 c2                	add    %eax,%edx
  8032da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032dd:	8b 40 08             	mov    0x8(%eax),%eax
  8032e0:	39 c2                	cmp    %eax,%edx
  8032e2:	0f 85 7c 01 00 00    	jne    803464 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ec:	74 06                	je     8032f4 <insert_sorted_with_merge_freeList+0x530>
  8032ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f2:	75 17                	jne    80330b <insert_sorted_with_merge_freeList+0x547>
  8032f4:	83 ec 04             	sub    $0x4,%esp
  8032f7:	68 08 40 80 00       	push   $0x804008
  8032fc:	68 69 01 00 00       	push   $0x169
  803301:	68 ef 3f 80 00       	push   $0x803fef
  803306:	e8 e7 d1 ff ff       	call   8004f2 <_panic>
  80330b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330e:	8b 50 04             	mov    0x4(%eax),%edx
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	89 50 04             	mov    %edx,0x4(%eax)
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331d:	89 10                	mov    %edx,(%eax)
  80331f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803322:	8b 40 04             	mov    0x4(%eax),%eax
  803325:	85 c0                	test   %eax,%eax
  803327:	74 0d                	je     803336 <insert_sorted_with_merge_freeList+0x572>
  803329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332c:	8b 40 04             	mov    0x4(%eax),%eax
  80332f:	8b 55 08             	mov    0x8(%ebp),%edx
  803332:	89 10                	mov    %edx,(%eax)
  803334:	eb 08                	jmp    80333e <insert_sorted_with_merge_freeList+0x57a>
  803336:	8b 45 08             	mov    0x8(%ebp),%eax
  803339:	a3 38 51 80 00       	mov    %eax,0x805138
  80333e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803341:	8b 55 08             	mov    0x8(%ebp),%edx
  803344:	89 50 04             	mov    %edx,0x4(%eax)
  803347:	a1 44 51 80 00       	mov    0x805144,%eax
  80334c:	40                   	inc    %eax
  80334d:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	8b 50 0c             	mov    0xc(%eax),%edx
  803358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335b:	8b 40 0c             	mov    0xc(%eax),%eax
  80335e:	01 c2                	add    %eax,%edx
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803366:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80336a:	75 17                	jne    803383 <insert_sorted_with_merge_freeList+0x5bf>
  80336c:	83 ec 04             	sub    $0x4,%esp
  80336f:	68 98 40 80 00       	push   $0x804098
  803374:	68 6b 01 00 00       	push   $0x16b
  803379:	68 ef 3f 80 00       	push   $0x803fef
  80337e:	e8 6f d1 ff ff       	call   8004f2 <_panic>
  803383:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803386:	8b 00                	mov    (%eax),%eax
  803388:	85 c0                	test   %eax,%eax
  80338a:	74 10                	je     80339c <insert_sorted_with_merge_freeList+0x5d8>
  80338c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338f:	8b 00                	mov    (%eax),%eax
  803391:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803394:	8b 52 04             	mov    0x4(%edx),%edx
  803397:	89 50 04             	mov    %edx,0x4(%eax)
  80339a:	eb 0b                	jmp    8033a7 <insert_sorted_with_merge_freeList+0x5e3>
  80339c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339f:	8b 40 04             	mov    0x4(%eax),%eax
  8033a2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033aa:	8b 40 04             	mov    0x4(%eax),%eax
  8033ad:	85 c0                	test   %eax,%eax
  8033af:	74 0f                	je     8033c0 <insert_sorted_with_merge_freeList+0x5fc>
  8033b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b4:	8b 40 04             	mov    0x4(%eax),%eax
  8033b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ba:	8b 12                	mov    (%edx),%edx
  8033bc:	89 10                	mov    %edx,(%eax)
  8033be:	eb 0a                	jmp    8033ca <insert_sorted_with_merge_freeList+0x606>
  8033c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	a3 38 51 80 00       	mov    %eax,0x805138
  8033ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e2:	48                   	dec    %eax
  8033e3:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803400:	75 17                	jne    803419 <insert_sorted_with_merge_freeList+0x655>
  803402:	83 ec 04             	sub    $0x4,%esp
  803405:	68 cc 3f 80 00       	push   $0x803fcc
  80340a:	68 6e 01 00 00       	push   $0x16e
  80340f:	68 ef 3f 80 00       	push   $0x803fef
  803414:	e8 d9 d0 ff ff       	call   8004f2 <_panic>
  803419:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80341f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803422:	89 10                	mov    %edx,(%eax)
  803424:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803427:	8b 00                	mov    (%eax),%eax
  803429:	85 c0                	test   %eax,%eax
  80342b:	74 0d                	je     80343a <insert_sorted_with_merge_freeList+0x676>
  80342d:	a1 48 51 80 00       	mov    0x805148,%eax
  803432:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803435:	89 50 04             	mov    %edx,0x4(%eax)
  803438:	eb 08                	jmp    803442 <insert_sorted_with_merge_freeList+0x67e>
  80343a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803442:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803445:	a3 48 51 80 00       	mov    %eax,0x805148
  80344a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803454:	a1 54 51 80 00       	mov    0x805154,%eax
  803459:	40                   	inc    %eax
  80345a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80345f:	e9 a9 00 00 00       	jmp    80350d <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803468:	74 06                	je     803470 <insert_sorted_with_merge_freeList+0x6ac>
  80346a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80346e:	75 17                	jne    803487 <insert_sorted_with_merge_freeList+0x6c3>
  803470:	83 ec 04             	sub    $0x4,%esp
  803473:	68 64 40 80 00       	push   $0x804064
  803478:	68 73 01 00 00       	push   $0x173
  80347d:	68 ef 3f 80 00       	push   $0x803fef
  803482:	e8 6b d0 ff ff       	call   8004f2 <_panic>
  803487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348a:	8b 10                	mov    (%eax),%edx
  80348c:	8b 45 08             	mov    0x8(%ebp),%eax
  80348f:	89 10                	mov    %edx,(%eax)
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	8b 00                	mov    (%eax),%eax
  803496:	85 c0                	test   %eax,%eax
  803498:	74 0b                	je     8034a5 <insert_sorted_with_merge_freeList+0x6e1>
  80349a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349d:	8b 00                	mov    (%eax),%eax
  80349f:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a2:	89 50 04             	mov    %edx,0x4(%eax)
  8034a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ab:	89 10                	mov    %edx,(%eax)
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b3:	89 50 04             	mov    %edx,0x4(%eax)
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	8b 00                	mov    (%eax),%eax
  8034bb:	85 c0                	test   %eax,%eax
  8034bd:	75 08                	jne    8034c7 <insert_sorted_with_merge_freeList+0x703>
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8034cc:	40                   	inc    %eax
  8034cd:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034d2:	eb 39                	jmp    80350d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8034d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e0:	74 07                	je     8034e9 <insert_sorted_with_merge_freeList+0x725>
  8034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e5:	8b 00                	mov    (%eax),%eax
  8034e7:	eb 05                	jmp    8034ee <insert_sorted_with_merge_freeList+0x72a>
  8034e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ee:	a3 40 51 80 00       	mov    %eax,0x805140
  8034f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8034f8:	85 c0                	test   %eax,%eax
  8034fa:	0f 85 c7 fb ff ff    	jne    8030c7 <insert_sorted_with_merge_freeList+0x303>
  803500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803504:	0f 85 bd fb ff ff    	jne    8030c7 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80350a:	eb 01                	jmp    80350d <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80350c:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80350d:	90                   	nop
  80350e:	c9                   	leave  
  80350f:	c3                   	ret    

00803510 <__udivdi3>:
  803510:	55                   	push   %ebp
  803511:	57                   	push   %edi
  803512:	56                   	push   %esi
  803513:	53                   	push   %ebx
  803514:	83 ec 1c             	sub    $0x1c,%esp
  803517:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80351b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80351f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803523:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803527:	89 ca                	mov    %ecx,%edx
  803529:	89 f8                	mov    %edi,%eax
  80352b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80352f:	85 f6                	test   %esi,%esi
  803531:	75 2d                	jne    803560 <__udivdi3+0x50>
  803533:	39 cf                	cmp    %ecx,%edi
  803535:	77 65                	ja     80359c <__udivdi3+0x8c>
  803537:	89 fd                	mov    %edi,%ebp
  803539:	85 ff                	test   %edi,%edi
  80353b:	75 0b                	jne    803548 <__udivdi3+0x38>
  80353d:	b8 01 00 00 00       	mov    $0x1,%eax
  803542:	31 d2                	xor    %edx,%edx
  803544:	f7 f7                	div    %edi
  803546:	89 c5                	mov    %eax,%ebp
  803548:	31 d2                	xor    %edx,%edx
  80354a:	89 c8                	mov    %ecx,%eax
  80354c:	f7 f5                	div    %ebp
  80354e:	89 c1                	mov    %eax,%ecx
  803550:	89 d8                	mov    %ebx,%eax
  803552:	f7 f5                	div    %ebp
  803554:	89 cf                	mov    %ecx,%edi
  803556:	89 fa                	mov    %edi,%edx
  803558:	83 c4 1c             	add    $0x1c,%esp
  80355b:	5b                   	pop    %ebx
  80355c:	5e                   	pop    %esi
  80355d:	5f                   	pop    %edi
  80355e:	5d                   	pop    %ebp
  80355f:	c3                   	ret    
  803560:	39 ce                	cmp    %ecx,%esi
  803562:	77 28                	ja     80358c <__udivdi3+0x7c>
  803564:	0f bd fe             	bsr    %esi,%edi
  803567:	83 f7 1f             	xor    $0x1f,%edi
  80356a:	75 40                	jne    8035ac <__udivdi3+0x9c>
  80356c:	39 ce                	cmp    %ecx,%esi
  80356e:	72 0a                	jb     80357a <__udivdi3+0x6a>
  803570:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803574:	0f 87 9e 00 00 00    	ja     803618 <__udivdi3+0x108>
  80357a:	b8 01 00 00 00       	mov    $0x1,%eax
  80357f:	89 fa                	mov    %edi,%edx
  803581:	83 c4 1c             	add    $0x1c,%esp
  803584:	5b                   	pop    %ebx
  803585:	5e                   	pop    %esi
  803586:	5f                   	pop    %edi
  803587:	5d                   	pop    %ebp
  803588:	c3                   	ret    
  803589:	8d 76 00             	lea    0x0(%esi),%esi
  80358c:	31 ff                	xor    %edi,%edi
  80358e:	31 c0                	xor    %eax,%eax
  803590:	89 fa                	mov    %edi,%edx
  803592:	83 c4 1c             	add    $0x1c,%esp
  803595:	5b                   	pop    %ebx
  803596:	5e                   	pop    %esi
  803597:	5f                   	pop    %edi
  803598:	5d                   	pop    %ebp
  803599:	c3                   	ret    
  80359a:	66 90                	xchg   %ax,%ax
  80359c:	89 d8                	mov    %ebx,%eax
  80359e:	f7 f7                	div    %edi
  8035a0:	31 ff                	xor    %edi,%edi
  8035a2:	89 fa                	mov    %edi,%edx
  8035a4:	83 c4 1c             	add    $0x1c,%esp
  8035a7:	5b                   	pop    %ebx
  8035a8:	5e                   	pop    %esi
  8035a9:	5f                   	pop    %edi
  8035aa:	5d                   	pop    %ebp
  8035ab:	c3                   	ret    
  8035ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035b1:	89 eb                	mov    %ebp,%ebx
  8035b3:	29 fb                	sub    %edi,%ebx
  8035b5:	89 f9                	mov    %edi,%ecx
  8035b7:	d3 e6                	shl    %cl,%esi
  8035b9:	89 c5                	mov    %eax,%ebp
  8035bb:	88 d9                	mov    %bl,%cl
  8035bd:	d3 ed                	shr    %cl,%ebp
  8035bf:	89 e9                	mov    %ebp,%ecx
  8035c1:	09 f1                	or     %esi,%ecx
  8035c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035c7:	89 f9                	mov    %edi,%ecx
  8035c9:	d3 e0                	shl    %cl,%eax
  8035cb:	89 c5                	mov    %eax,%ebp
  8035cd:	89 d6                	mov    %edx,%esi
  8035cf:	88 d9                	mov    %bl,%cl
  8035d1:	d3 ee                	shr    %cl,%esi
  8035d3:	89 f9                	mov    %edi,%ecx
  8035d5:	d3 e2                	shl    %cl,%edx
  8035d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035db:	88 d9                	mov    %bl,%cl
  8035dd:	d3 e8                	shr    %cl,%eax
  8035df:	09 c2                	or     %eax,%edx
  8035e1:	89 d0                	mov    %edx,%eax
  8035e3:	89 f2                	mov    %esi,%edx
  8035e5:	f7 74 24 0c          	divl   0xc(%esp)
  8035e9:	89 d6                	mov    %edx,%esi
  8035eb:	89 c3                	mov    %eax,%ebx
  8035ed:	f7 e5                	mul    %ebp
  8035ef:	39 d6                	cmp    %edx,%esi
  8035f1:	72 19                	jb     80360c <__udivdi3+0xfc>
  8035f3:	74 0b                	je     803600 <__udivdi3+0xf0>
  8035f5:	89 d8                	mov    %ebx,%eax
  8035f7:	31 ff                	xor    %edi,%edi
  8035f9:	e9 58 ff ff ff       	jmp    803556 <__udivdi3+0x46>
  8035fe:	66 90                	xchg   %ax,%ax
  803600:	8b 54 24 08          	mov    0x8(%esp),%edx
  803604:	89 f9                	mov    %edi,%ecx
  803606:	d3 e2                	shl    %cl,%edx
  803608:	39 c2                	cmp    %eax,%edx
  80360a:	73 e9                	jae    8035f5 <__udivdi3+0xe5>
  80360c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80360f:	31 ff                	xor    %edi,%edi
  803611:	e9 40 ff ff ff       	jmp    803556 <__udivdi3+0x46>
  803616:	66 90                	xchg   %ax,%ax
  803618:	31 c0                	xor    %eax,%eax
  80361a:	e9 37 ff ff ff       	jmp    803556 <__udivdi3+0x46>
  80361f:	90                   	nop

00803620 <__umoddi3>:
  803620:	55                   	push   %ebp
  803621:	57                   	push   %edi
  803622:	56                   	push   %esi
  803623:	53                   	push   %ebx
  803624:	83 ec 1c             	sub    $0x1c,%esp
  803627:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80362b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80362f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803633:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803637:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80363b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80363f:	89 f3                	mov    %esi,%ebx
  803641:	89 fa                	mov    %edi,%edx
  803643:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803647:	89 34 24             	mov    %esi,(%esp)
  80364a:	85 c0                	test   %eax,%eax
  80364c:	75 1a                	jne    803668 <__umoddi3+0x48>
  80364e:	39 f7                	cmp    %esi,%edi
  803650:	0f 86 a2 00 00 00    	jbe    8036f8 <__umoddi3+0xd8>
  803656:	89 c8                	mov    %ecx,%eax
  803658:	89 f2                	mov    %esi,%edx
  80365a:	f7 f7                	div    %edi
  80365c:	89 d0                	mov    %edx,%eax
  80365e:	31 d2                	xor    %edx,%edx
  803660:	83 c4 1c             	add    $0x1c,%esp
  803663:	5b                   	pop    %ebx
  803664:	5e                   	pop    %esi
  803665:	5f                   	pop    %edi
  803666:	5d                   	pop    %ebp
  803667:	c3                   	ret    
  803668:	39 f0                	cmp    %esi,%eax
  80366a:	0f 87 ac 00 00 00    	ja     80371c <__umoddi3+0xfc>
  803670:	0f bd e8             	bsr    %eax,%ebp
  803673:	83 f5 1f             	xor    $0x1f,%ebp
  803676:	0f 84 ac 00 00 00    	je     803728 <__umoddi3+0x108>
  80367c:	bf 20 00 00 00       	mov    $0x20,%edi
  803681:	29 ef                	sub    %ebp,%edi
  803683:	89 fe                	mov    %edi,%esi
  803685:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803689:	89 e9                	mov    %ebp,%ecx
  80368b:	d3 e0                	shl    %cl,%eax
  80368d:	89 d7                	mov    %edx,%edi
  80368f:	89 f1                	mov    %esi,%ecx
  803691:	d3 ef                	shr    %cl,%edi
  803693:	09 c7                	or     %eax,%edi
  803695:	89 e9                	mov    %ebp,%ecx
  803697:	d3 e2                	shl    %cl,%edx
  803699:	89 14 24             	mov    %edx,(%esp)
  80369c:	89 d8                	mov    %ebx,%eax
  80369e:	d3 e0                	shl    %cl,%eax
  8036a0:	89 c2                	mov    %eax,%edx
  8036a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036a6:	d3 e0                	shl    %cl,%eax
  8036a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036b0:	89 f1                	mov    %esi,%ecx
  8036b2:	d3 e8                	shr    %cl,%eax
  8036b4:	09 d0                	or     %edx,%eax
  8036b6:	d3 eb                	shr    %cl,%ebx
  8036b8:	89 da                	mov    %ebx,%edx
  8036ba:	f7 f7                	div    %edi
  8036bc:	89 d3                	mov    %edx,%ebx
  8036be:	f7 24 24             	mull   (%esp)
  8036c1:	89 c6                	mov    %eax,%esi
  8036c3:	89 d1                	mov    %edx,%ecx
  8036c5:	39 d3                	cmp    %edx,%ebx
  8036c7:	0f 82 87 00 00 00    	jb     803754 <__umoddi3+0x134>
  8036cd:	0f 84 91 00 00 00    	je     803764 <__umoddi3+0x144>
  8036d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036d7:	29 f2                	sub    %esi,%edx
  8036d9:	19 cb                	sbb    %ecx,%ebx
  8036db:	89 d8                	mov    %ebx,%eax
  8036dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036e1:	d3 e0                	shl    %cl,%eax
  8036e3:	89 e9                	mov    %ebp,%ecx
  8036e5:	d3 ea                	shr    %cl,%edx
  8036e7:	09 d0                	or     %edx,%eax
  8036e9:	89 e9                	mov    %ebp,%ecx
  8036eb:	d3 eb                	shr    %cl,%ebx
  8036ed:	89 da                	mov    %ebx,%edx
  8036ef:	83 c4 1c             	add    $0x1c,%esp
  8036f2:	5b                   	pop    %ebx
  8036f3:	5e                   	pop    %esi
  8036f4:	5f                   	pop    %edi
  8036f5:	5d                   	pop    %ebp
  8036f6:	c3                   	ret    
  8036f7:	90                   	nop
  8036f8:	89 fd                	mov    %edi,%ebp
  8036fa:	85 ff                	test   %edi,%edi
  8036fc:	75 0b                	jne    803709 <__umoddi3+0xe9>
  8036fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803703:	31 d2                	xor    %edx,%edx
  803705:	f7 f7                	div    %edi
  803707:	89 c5                	mov    %eax,%ebp
  803709:	89 f0                	mov    %esi,%eax
  80370b:	31 d2                	xor    %edx,%edx
  80370d:	f7 f5                	div    %ebp
  80370f:	89 c8                	mov    %ecx,%eax
  803711:	f7 f5                	div    %ebp
  803713:	89 d0                	mov    %edx,%eax
  803715:	e9 44 ff ff ff       	jmp    80365e <__umoddi3+0x3e>
  80371a:	66 90                	xchg   %ax,%ax
  80371c:	89 c8                	mov    %ecx,%eax
  80371e:	89 f2                	mov    %esi,%edx
  803720:	83 c4 1c             	add    $0x1c,%esp
  803723:	5b                   	pop    %ebx
  803724:	5e                   	pop    %esi
  803725:	5f                   	pop    %edi
  803726:	5d                   	pop    %ebp
  803727:	c3                   	ret    
  803728:	3b 04 24             	cmp    (%esp),%eax
  80372b:	72 06                	jb     803733 <__umoddi3+0x113>
  80372d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803731:	77 0f                	ja     803742 <__umoddi3+0x122>
  803733:	89 f2                	mov    %esi,%edx
  803735:	29 f9                	sub    %edi,%ecx
  803737:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80373b:	89 14 24             	mov    %edx,(%esp)
  80373e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803742:	8b 44 24 04          	mov    0x4(%esp),%eax
  803746:	8b 14 24             	mov    (%esp),%edx
  803749:	83 c4 1c             	add    $0x1c,%esp
  80374c:	5b                   	pop    %ebx
  80374d:	5e                   	pop    %esi
  80374e:	5f                   	pop    %edi
  80374f:	5d                   	pop    %ebp
  803750:	c3                   	ret    
  803751:	8d 76 00             	lea    0x0(%esi),%esi
  803754:	2b 04 24             	sub    (%esp),%eax
  803757:	19 fa                	sbb    %edi,%edx
  803759:	89 d1                	mov    %edx,%ecx
  80375b:	89 c6                	mov    %eax,%esi
  80375d:	e9 71 ff ff ff       	jmp    8036d3 <__umoddi3+0xb3>
  803762:	66 90                	xchg   %ax,%ax
  803764:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803768:	72 ea                	jb     803754 <__umoddi3+0x134>
  80376a:	89 d9                	mov    %ebx,%ecx
  80376c:	e9 62 ff ff ff       	jmp    8036d3 <__umoddi3+0xb3>
