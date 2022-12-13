
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 dc 03 00 00       	call   800412 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
#include <user/air.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 07 1b 00 00       	call   801b50 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb a9 38 80 00       	mov    $0x8038a9,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb b3 38 80 00       	mov    $0x8038b3,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb bf 38 80 00       	mov    $0x8038bf,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb ce 38 80 00       	mov    $0x8038ce,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb dd 38 80 00       	mov    $0x8038dd,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb f2 38 80 00       	mov    $0x8038f2,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 07 39 80 00       	mov    $0x803907,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 18 39 80 00       	mov    $0x803918,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 29 39 80 00       	mov    $0x803929,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 3a 39 80 00       	mov    $0x80393a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 43 39 80 00       	mov    $0x803943,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 4d 39 80 00       	mov    $0x80394d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 58 39 80 00       	mov    $0x803958,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb 64 39 80 00       	mov    $0x803964,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb 6e 39 80 00       	mov    $0x80396e,%ebx
  800198:	ba 0a 00 00 00       	mov    $0xa,%edx
  80019d:	89 c7                	mov    %eax,%edi
  80019f:	89 de                	mov    %ebx,%esi
  8001a1:	89 d1                	mov    %edx,%ecx
  8001a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a5:	c7 85 f7 fe ff ff 63 	movl   $0x72656c63,-0x109(%ebp)
  8001ac:	6c 65 72 
  8001af:	66 c7 85 fb fe ff ff 	movw   $0x6b,-0x105(%ebp)
  8001b6:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001b8:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8001be:	bb 78 39 80 00       	mov    $0x803978,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 86 39 80 00       	mov    $0x803986,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 95 39 80 00       	mov    $0x803995,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 9c 39 80 00       	mov    $0x80399c,%ebx
  80020b:	ba 07 00 00 00       	mov    $0x7,%edx
  800210:	89 c7                	mov    %eax,%edi
  800212:	89 de                	mov    %ebx,%esi
  800214:	89 d1                	mov    %edx,%ecx
  800216:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800222:	e8 8c 14 00 00       	call   8016b3 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 77 14 00 00       	call   8016b3 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 5f 14 00 00       	call   8016b3 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 47 14 00 00       	call   8016b3 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	int custId, flightType;
	sys_waitSemaphore(parentenvID, _custCounterCS);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 6d 17 00 00       	call   8019f1 <sys_waitSemaphore>
  800284:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  800287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80028a:	8b 00                	mov    (%eax),%eax
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  80028f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	8d 50 01             	lea    0x1(%eax),%edx
  800297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029a:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custCounterCS);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8002a5:	50                   	push   %eax
  8002a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a9:	e8 61 17 00 00       	call   801a0f <sys_signalSemaphore>
  8002ae:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	sys_waitSemaphore(parentenvID, _clerk);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	e8 2e 17 00 00       	call   8019f1 <sys_waitSemaphore>
  8002c3:	83 c4 10             	add    $0x10,%esp

	//enqueue the request
	flightType = customers[custId].flightType;
  8002c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	sys_waitSemaphore(parentenvID, _custQueueCS);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	e8 05 17 00 00       	call   8019f1 <sys_waitSemaphore>
  8002ec:	83 c4 10             	add    $0x10,%esp
	{
		cust_ready_queue[*queue_in] = custId;
  8002ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002f2:	8b 00                	mov    (%eax),%eax
  8002f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002fe:	01 c2                	add    %eax,%edx
  800300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800303:	89 02                	mov    %eax,(%edx)
		*queue_in = *queue_in +1;
  800305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	8d 50 01             	lea    0x1(%eax),%edx
  80030d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800310:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custQueueCS);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 eb 16 00 00       	call   801a0f <sys_signalSemaphore>
  800324:	83 c4 10             	add    $0x10,%esp

	//signal ready
	sys_signalSemaphore(parentenvID, _cust_ready);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  800330:	50                   	push   %eax
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	e8 d6 16 00 00       	call   801a0f <sys_signalSemaphore>
  800339:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  80033c:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800342:	bb a3 39 80 00       	mov    $0x8039a3,%ebx
  800347:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034c:	89 c7                	mov    %eax,%edi
  80034e:	89 de                	mov    %ebx,%esi
  800350:	89 d1                	mov    %edx,%ecx
  800352:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800354:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  80035a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80035f:	b8 00 00 00 00       	mov    $0x0,%eax
  800364:	89 d7                	mov    %edx,%edi
  800366:	f3 ab                	rep stos %eax,%es:(%edi)
	char id[5]; char sname[50];
	ltostr(custId, id);
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800371:	50                   	push   %eax
  800372:	ff 75 d0             	pushl  -0x30(%ebp)
  800375:	e8 d0 0d 00 00       	call   80114a <ltostr>
  80037a:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800386:	50                   	push   %eax
  800387:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  80038d:	50                   	push   %eax
  80038e:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	e8 a8 0e 00 00       	call   801242 <strcconcat>
  80039a:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(parentenvID, sname);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8003a6:	50                   	push   %eax
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	e8 42 16 00 00       	call   8019f1 <sys_waitSemaphore>
  8003af:	83 c4 10             	add    $0x10,%esp

	//print the customer status
	if(customers[custId].booked == 1)
  8003b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bf:	01 d0                	add    %edx,%eax
  8003c1:	8b 40 04             	mov    0x4(%eax),%eax
  8003c4:	83 f8 01             	cmp    $0x1,%eax
  8003c7:	75 18                	jne    8003e1 <_main+0x3a9>
	{
		cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	ff 75 cc             	pushl  -0x34(%ebp)
  8003cf:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d2:	68 60 38 80 00       	push   $0x803860
  8003d7:	e8 46 02 00 00       	call   800622 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 13                	jmp    8003f4 <_main+0x3bc>
	}
	else
	{
		cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e7:	68 88 38 80 00       	push   $0x803888
  8003ec:	e8 31 02 00 00       	call   800622 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	sys_signalSemaphore(parentenvID, _custTerminated);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800401:	e8 09 16 00 00       	call   801a0f <sys_signalSemaphore>
  800406:	83 c4 10             	add    $0x10,%esp

	return;
  800409:	90                   	nop
}
  80040a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80040d:	5b                   	pop    %ebx
  80040e:	5e                   	pop    %esi
  80040f:	5f                   	pop    %edi
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800418:	e8 1a 17 00 00       	call   801b37 <sys_getenvindex>
  80041d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	c1 e0 03             	shl    $0x3,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800435:	01 d0                	add    %edx,%eax
  800437:	c1 e0 04             	shl    $0x4,%eax
  80043a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800444:	a1 20 50 80 00       	mov    0x805020,%eax
  800449:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044f:	84 c0                	test   %al,%al
  800451:	74 0f                	je     800462 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800453:	a1 20 50 80 00       	mov    0x805020,%eax
  800458:	05 5c 05 00 00       	add    $0x55c,%eax
  80045d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800466:	7e 0a                	jle    800472 <libmain+0x60>
		binaryname = argv[0];
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	ff 75 08             	pushl  0x8(%ebp)
  80047b:	e8 b8 fb ff ff       	call   800038 <_main>
  800480:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800483:	e8 bc 14 00 00       	call   801944 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	68 dc 39 80 00       	push   $0x8039dc
  800490:	e8 8d 01 00 00       	call   800622 <cprintf>
  800495:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800498:	a1 20 50 80 00       	mov    0x805020,%eax
  80049d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8004a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004ae:	83 ec 04             	sub    $0x4,%esp
  8004b1:	52                   	push   %edx
  8004b2:	50                   	push   %eax
  8004b3:	68 04 3a 80 00       	push   $0x803a04
  8004b8:	e8 65 01 00 00       	call   800622 <cprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8004db:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	50                   	push   %eax
  8004e4:	68 2c 3a 80 00       	push   $0x803a2c
  8004e9:	e8 34 01 00 00       	call   800622 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	50                   	push   %eax
  800500:	68 84 3a 80 00       	push   $0x803a84
  800505:	e8 18 01 00 00       	call   800622 <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	68 dc 39 80 00       	push   $0x8039dc
  800515:	e8 08 01 00 00       	call   800622 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80051d:	e8 3c 14 00 00       	call   80195e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800522:	e8 19 00 00 00       	call   800540 <exit>
}
  800527:	90                   	nop
  800528:	c9                   	leave  
  800529:	c3                   	ret    

0080052a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
  80052d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800530:	83 ec 0c             	sub    $0xc,%esp
  800533:	6a 00                	push   $0x0
  800535:	e8 c9 15 00 00       	call   801b03 <sys_destroy_env>
  80053a:	83 c4 10             	add    $0x10,%esp
}
  80053d:	90                   	nop
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <exit>:

void
exit(void)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800546:	e8 1e 16 00 00       	call   801b69 <sys_exit_env>
}
  80054b:	90                   	nop
  80054c:	c9                   	leave  
  80054d:	c3                   	ret    

0080054e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	8d 48 01             	lea    0x1(%eax),%ecx
  80055c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055f:	89 0a                	mov    %ecx,(%edx)
  800561:	8b 55 08             	mov    0x8(%ebp),%edx
  800564:	88 d1                	mov    %dl,%cl
  800566:	8b 55 0c             	mov    0xc(%ebp),%edx
  800569:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800579:	a0 24 50 80 00       	mov    0x805024,%al
  80057e:	0f b6 c0             	movzbl %al,%eax
  800581:	8b 55 0c             	mov    0xc(%ebp),%edx
  800584:	8b 12                	mov    (%edx),%edx
  800586:	89 d1                	mov    %edx,%ecx
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	83 c2 08             	add    $0x8,%edx
  80058e:	83 ec 04             	sub    $0x4,%esp
  800591:	50                   	push   %eax
  800592:	51                   	push   %ecx
  800593:	52                   	push   %edx
  800594:	e8 fd 11 00 00       	call   801796 <sys_cputs>
  800599:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a8:	8b 40 04             	mov    0x4(%eax),%eax
  8005ab:	8d 50 01             	lea    0x1(%eax),%edx
  8005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b4:	90                   	nop
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    

008005b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c7:	00 00 00 
	b.cnt = 0;
  8005ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e0:	50                   	push   %eax
  8005e1:	68 4e 05 80 00       	push   $0x80054e
  8005e6:	e8 11 02 00 00       	call   8007fc <vprintfmt>
  8005eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ee:	a0 24 50 80 00       	mov    0x805024,%al
  8005f3:	0f b6 c0             	movzbl %al,%eax
  8005f6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005fc:	83 ec 04             	sub    $0x4,%esp
  8005ff:	50                   	push   %eax
  800600:	52                   	push   %edx
  800601:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800607:	83 c0 08             	add    $0x8,%eax
  80060a:	50                   	push   %eax
  80060b:	e8 86 11 00 00       	call   801796 <sys_cputs>
  800610:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800613:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80061a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <cprintf>:

int cprintf(const char *fmt, ...) {
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800628:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80062f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800632:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 f4             	pushl  -0xc(%ebp)
  80063e:	50                   	push   %eax
  80063f:	e8 73 ff ff ff       	call   8005b7 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80064a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800655:	e8 ea 12 00 00       	call   801944 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80065a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 f4             	pushl  -0xc(%ebp)
  800669:	50                   	push   %eax
  80066a:	e8 48 ff ff ff       	call   8005b7 <vcprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800675:	e8 e4 12 00 00       	call   80195e <sys_enable_interrupt>
	return cnt;
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 14             	sub    $0x14,%esp
  800686:	8b 45 10             	mov    0x10(%ebp),%eax
  800689:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800692:	8b 45 18             	mov    0x18(%ebp),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069d:	77 55                	ja     8006f4 <printnum+0x75>
  80069f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a2:	72 05                	jb     8006a9 <printnum+0x2a>
  8006a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a7:	77 4b                	ja     8006f4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006af:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bf:	e8 38 2f 00 00       	call   8035fc <__udivdi3>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	ff 75 20             	pushl  0x20(%ebp)
  8006cd:	53                   	push   %ebx
  8006ce:	ff 75 18             	pushl  0x18(%ebp)
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	ff 75 08             	pushl  0x8(%ebp)
  8006d9:	e8 a1 ff ff ff       	call   80067f <printnum>
  8006de:	83 c4 20             	add    $0x20,%esp
  8006e1:	eb 1a                	jmp    8006fd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 20             	pushl  0x20(%ebp)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006fb:	7f e6                	jg     8006e3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800700:	bb 00 00 00 00       	mov    $0x0,%ebx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070b:	53                   	push   %ebx
  80070c:	51                   	push   %ecx
  80070d:	52                   	push   %edx
  80070e:	50                   	push   %eax
  80070f:	e8 f8 2f 00 00       	call   80370c <__umoddi3>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	05 b4 3c 80 00       	add    $0x803cb4,%eax
  80071c:	8a 00                	mov    (%eax),%al
  80071e:	0f be c0             	movsbl %al,%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
}
  800730:	90                   	nop
  800731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800739:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073d:	7e 1c                	jle    80075b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	8d 50 08             	lea    0x8(%eax),%edx
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	89 10                	mov    %edx,(%eax)
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	83 e8 08             	sub    $0x8,%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	eb 40                	jmp    80079b <getuint+0x65>
	else if (lflag)
  80075b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075f:	74 1e                	je     80077f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 04             	lea    0x4(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	eb 1c                	jmp    80079b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 04             	lea    0x4(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 04             	sub    $0x4,%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a4:	7e 1c                	jle    8007c2 <getint+0x25>
		return va_arg(*ap, long long);
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	8d 50 08             	lea    0x8(%eax),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	89 10                	mov    %edx,(%eax)
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	83 e8 08             	sub    $0x8,%eax
  8007bb:	8b 50 04             	mov    0x4(%eax),%edx
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	eb 38                	jmp    8007fa <getint+0x5d>
	else if (lflag)
  8007c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c6:	74 1a                	je     8007e2 <getint+0x45>
		return va_arg(*ap, long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 04             	lea    0x4(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	99                   	cltd   
  8007e0:	eb 18                	jmp    8007fa <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	89 10                	mov    %edx,(%eax)
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	99                   	cltd   
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	56                   	push   %esi
  800800:	53                   	push   %ebx
  800801:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800804:	eb 17                	jmp    80081d <vprintfmt+0x21>
			if (ch == '\0')
  800806:	85 db                	test   %ebx,%ebx
  800808:	0f 84 af 03 00 00    	je     800bbd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	53                   	push   %ebx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	8d 50 01             	lea    0x1(%eax),%edx
  800823:	89 55 10             	mov    %edx,0x10(%ebp)
  800826:	8a 00                	mov    (%eax),%al
  800828:	0f b6 d8             	movzbl %al,%ebx
  80082b:	83 fb 25             	cmp    $0x25,%ebx
  80082e:	75 d6                	jne    800806 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800830:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800834:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80083b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800842:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800849:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800850:	8b 45 10             	mov    0x10(%ebp),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	89 55 10             	mov    %edx,0x10(%ebp)
  800859:	8a 00                	mov    (%eax),%al
  80085b:	0f b6 d8             	movzbl %al,%ebx
  80085e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800861:	83 f8 55             	cmp    $0x55,%eax
  800864:	0f 87 2b 03 00 00    	ja     800b95 <vprintfmt+0x399>
  80086a:	8b 04 85 d8 3c 80 00 	mov    0x803cd8(,%eax,4),%eax
  800871:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800873:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800877:	eb d7                	jmp    800850 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800879:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80087d:	eb d1                	jmp    800850 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800886:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	c1 e0 02             	shl    $0x2,%eax
  80088e:	01 d0                	add    %edx,%eax
  800890:	01 c0                	add    %eax,%eax
  800892:	01 d8                	add    %ebx,%eax
  800894:	83 e8 30             	sub    $0x30,%eax
  800897:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	8a 00                	mov    (%eax),%al
  80089f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a5:	7e 3e                	jle    8008e5 <vprintfmt+0xe9>
  8008a7:	83 fb 39             	cmp    $0x39,%ebx
  8008aa:	7f 39                	jg     8008e5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ac:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008af:	eb d5                	jmp    800886 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c5:	eb 1f                	jmp    8008e6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cb:	79 83                	jns    800850 <vprintfmt+0x54>
				width = 0;
  8008cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d4:	e9 77 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008e0:	e9 6b ff ff ff       	jmp    800850 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	0f 89 60 ff ff ff    	jns    800850 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008fd:	e9 4e ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800902:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800905:	e9 46 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	83 c0 04             	add    $0x4,%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	83 e8 04             	sub    $0x4,%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	50                   	push   %eax
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 89 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800940:	85 db                	test   %ebx,%ebx
  800942:	79 02                	jns    800946 <vprintfmt+0x14a>
				err = -err;
  800944:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800946:	83 fb 64             	cmp    $0x64,%ebx
  800949:	7f 0b                	jg     800956 <vprintfmt+0x15a>
  80094b:	8b 34 9d 20 3b 80 00 	mov    0x803b20(,%ebx,4),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 19                	jne    80096f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800956:	53                   	push   %ebx
  800957:	68 c5 3c 80 00       	push   $0x803cc5
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 5e 02 00 00       	call   800bc5 <printfmt>
  800967:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80096a:	e9 49 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096f:	56                   	push   %esi
  800970:	68 ce 3c 80 00       	push   $0x803cce
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	ff 75 08             	pushl  0x8(%ebp)
  80097b:	e8 45 02 00 00       	call   800bc5 <printfmt>
  800980:	83 c4 10             	add    $0x10,%esp
			break;
  800983:	e9 30 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 c0 04             	add    $0x4,%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 30                	mov    (%eax),%esi
  800999:	85 f6                	test   %esi,%esi
  80099b:	75 05                	jne    8009a2 <vprintfmt+0x1a6>
				p = "(null)";
  80099d:	be d1 3c 80 00       	mov    $0x803cd1,%esi
			if (width > 0 && padc != '-')
  8009a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a6:	7e 6d                	jle    800a15 <vprintfmt+0x219>
  8009a8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ac:	74 67                	je     800a15 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b1:	83 ec 08             	sub    $0x8,%esp
  8009b4:	50                   	push   %eax
  8009b5:	56                   	push   %esi
  8009b6:	e8 0c 03 00 00       	call   800cc7 <strnlen>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009c1:	eb 16                	jmp    8009d9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009c3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	50                   	push   %eax
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7f e4                	jg     8009c3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009df:	eb 34                	jmp    800a15 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e5:	74 1c                	je     800a03 <vprintfmt+0x207>
  8009e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ea:	7e 05                	jle    8009f1 <vprintfmt+0x1f5>
  8009ec:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ef:	7e 12                	jle    800a03 <vprintfmt+0x207>
					putch('?', putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	6a 3f                	push   $0x3f
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
  800a01:	eb 0f                	jmp    800a12 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a12:	ff 4d e4             	decl   -0x1c(%ebp)
  800a15:	89 f0                	mov    %esi,%eax
  800a17:	8d 70 01             	lea    0x1(%eax),%esi
  800a1a:	8a 00                	mov    (%eax),%al
  800a1c:	0f be d8             	movsbl %al,%ebx
  800a1f:	85 db                	test   %ebx,%ebx
  800a21:	74 24                	je     800a47 <vprintfmt+0x24b>
  800a23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a27:	78 b8                	js     8009e1 <vprintfmt+0x1e5>
  800a29:	ff 4d e0             	decl   -0x20(%ebp)
  800a2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a30:	79 af                	jns    8009e1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	eb 13                	jmp    800a47 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	6a 20                	push   $0x20
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a44:	ff 4d e4             	decl   -0x1c(%ebp)
  800a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4b:	7f e7                	jg     800a34 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a4d:	e9 66 01 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 3c fd ff ff       	call   80079d <getint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a70:	85 d2                	test   %edx,%edx
  800a72:	79 23                	jns    800a97 <vprintfmt+0x29b>
				putch('-', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 2d                	push   $0x2d
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8a:	f7 d8                	neg    %eax
  800a8c:	83 d2 00             	adc    $0x0,%edx
  800a8f:	f7 da                	neg    %edx
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 84 fc ff ff       	call   800736 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800abb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac2:	e9 98 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	6a 58                	push   $0x58
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			break;
  800af7:	e9 bc 00 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 30                	push   $0x30
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 78                	push   $0x78
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 c0 04             	add    $0x4,%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	83 e8 04             	sub    $0x4,%eax
  800b2b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b37:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3e:	eb 1f                	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 e8             	pushl  -0x18(%ebp)
  800b46:	8d 45 14             	lea    0x14(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	e8 e7 fb ff ff       	call   800736 <getuint>
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	52                   	push   %edx
  800b6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b71:	ff 75 f0             	pushl  -0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 00 fb ff ff       	call   80067f <printnum>
  800b7f:	83 c4 20             	add    $0x20,%esp
			break;
  800b82:	eb 34                	jmp    800bb8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			break;
  800b93:	eb 23                	jmp    800bb8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 25                	push   $0x25
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba5:	ff 4d 10             	decl   0x10(%ebp)
  800ba8:	eb 03                	jmp    800bad <vprintfmt+0x3b1>
  800baa:	ff 4d 10             	decl   0x10(%ebp)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	48                   	dec    %eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	3c 25                	cmp    $0x25,%al
  800bb5:	75 f3                	jne    800baa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb7:	90                   	nop
		}
	}
  800bb8:	e9 47 fc ff ff       	jmp    800804 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 16 fc ff ff       	call   8007fc <vprintfmt>
  800be6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be9:	90                   	nop
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 08             	mov    0x8(%eax),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8b 10                	mov    (%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8b 40 04             	mov    0x4(%eax),%eax
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	73 12                	jae    800c1f <sprintputch+0x33>
		*b->buf++ = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 10                	mov    %dl,(%eax)
}
  800c1f:	90                   	nop
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	01 d0                	add    %edx,%eax
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c47:	74 06                	je     800c4f <vsnprintf+0x2d>
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	7f 07                	jg     800c56 <vsnprintf+0x34>
		return -E_INVAL;
  800c4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c54:	eb 20                	jmp    800c76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c56:	ff 75 14             	pushl  0x14(%ebp)
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	68 ec 0b 80 00       	push   $0x800bec
  800c65:	e8 92 fb ff ff       	call   8007fc <vprintfmt>
  800c6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 89 ff ff ff       	call   800c22 <vsnprintf>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb1:	eb 06                	jmp    800cb9 <strlen+0x15>
		n++;
  800cb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 f1                	jne    800cb3 <strlen+0xf>
		n++;
	return n;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd4:	eb 09                	jmp    800cdf <strnlen+0x18>
		n++;
  800cd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	ff 4d 0c             	decl   0xc(%ebp)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 09                	je     800cee <strnlen+0x27>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 e8                	jne    800cd6 <strnlen+0xf>
		n++;
	return n;
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cff:	90                   	nop
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 08             	mov    %edx,0x8(%ebp)
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d12:	8a 12                	mov    (%edx),%dl
  800d14:	88 10                	mov    %dl,(%eax)
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 e4                	jne    800d00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1f:	c9                   	leave  
  800d20:	c3                   	ret    

00800d21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 1f                	jmp    800d55 <strncpy+0x34>
		*dst++ = *src;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 03                	je     800d52 <strncpy+0x31>
			src++;
  800d4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d52:	ff 45 fc             	incl   -0x4(%ebp)
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5b:	72 d9                	jb     800d36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 30                	je     800da4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d74:	eb 16                	jmp    800d8c <strlcpy+0x2a>
			*dst++ = *src++;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 09                	je     800d9e <strlcpy+0x3c>
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 d8                	jne    800d76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db3:	eb 06                	jmp    800dbb <strcmp+0xb>
		p++, q++;
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	74 0e                	je     800dd2 <strcmp+0x22>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 10                	mov    (%eax),%dl
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	38 c2                	cmp    %al,%dl
  800dd0:	74 e3                	je     800db5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800deb:	eb 09                	jmp    800df6 <strncmp+0xe>
		n--, p++, q++;
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	ff 45 08             	incl   0x8(%ebp)
  800df3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	74 17                	je     800e13 <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	74 0e                	je     800e13 <strncmp+0x2b>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 10                	mov    (%eax),%dl
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	38 c2                	cmp    %al,%dl
  800e11:	74 da                	je     800ded <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	75 07                	jne    800e20 <strncmp+0x38>
		return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	eb 14                	jmp    800e34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 c0             	movzbl %al,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e42:	eb 12                	jmp    800e56 <strchr+0x20>
		if (*s == c)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4c:	75 05                	jne    800e53 <strchr+0x1d>
			return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	eb 11                	jmp    800e64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e5                	jne    800e44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e72:	eb 0d                	jmp    800e81 <strfind+0x1b>
		if (*s == c)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7c:	74 0e                	je     800e8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	84 c0                	test   %al,%al
  800e88:	75 ea                	jne    800e74 <strfind+0xe>
  800e8a:	eb 01                	jmp    800e8d <strfind+0x27>
		if (*s == c)
			break;
  800e8c:	90                   	nop
	return (char *) s;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea4:	eb 0e                	jmp    800eb4 <memset+0x22>
		*p++ = c;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb4:	ff 4d f8             	decl   -0x8(%ebp)
  800eb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ebb:	79 e9                	jns    800ea6 <memset+0x14>
		*p++ = c;

	return v;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed4:	eb 16                	jmp    800eec <memcpy+0x2a>
		*d++ = *s++;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee8:	8a 12                	mov    (%edx),%dl
  800eea:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 dd                	jne    800ed6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f16:	73 50                	jae    800f68 <memmove+0x6a>
  800f18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f23:	76 43                	jbe    800f68 <memmove+0x6a>
		s += n;
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f31:	eb 10                	jmp    800f43 <memmove+0x45>
			*--d = *--s;
  800f33:	ff 4d f8             	decl   -0x8(%ebp)
  800f36:	ff 4d fc             	decl   -0x4(%ebp)
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	8a 10                	mov    (%eax),%dl
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f49:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 e3                	jne    800f33 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f50:	eb 23                	jmp    800f75 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	75 dd                	jne    800f52 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f8c:	eb 2a                	jmp    800fb8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f91:	8a 10                	mov    (%eax),%dl
  800f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	38 c2                	cmp    %al,%dl
  800f9a:	74 16                	je     800fb2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 d0             	movzbl %al,%edx
  800fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 c0             	movzbl %al,%eax
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	eb 18                	jmp    800fca <memcmp+0x50>
		s1++, s2++;
  800fb2:	ff 45 fc             	incl   -0x4(%ebp)
  800fb5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	75 c9                	jne    800f8e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fdd:	eb 15                	jmp    800ff4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	0f b6 d0             	movzbl %al,%edx
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	0f b6 c0             	movzbl %al,%eax
  800fed:	39 c2                	cmp    %eax,%edx
  800fef:	74 0d                	je     800ffe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff1:	ff 45 08             	incl   0x8(%ebp)
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ffa:	72 e3                	jb     800fdf <memfind+0x13>
  800ffc:	eb 01                	jmp    800fff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffe:	90                   	nop
	return (void *) s;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801011:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801018:	eb 03                	jmp    80101d <strtol+0x19>
		s++;
  80101a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 20                	cmp    $0x20,%al
  801024:	74 f4                	je     80101a <strtol+0x16>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 09                	cmp    $0x9,%al
  80102d:	74 eb                	je     80101a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 2b                	cmp    $0x2b,%al
  801036:	75 05                	jne    80103d <strtol+0x39>
		s++;
  801038:	ff 45 08             	incl   0x8(%ebp)
  80103b:	eb 13                	jmp    801050 <strtol+0x4c>
	else if (*s == '-')
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3c 2d                	cmp    $0x2d,%al
  801044:	75 0a                	jne    801050 <strtol+0x4c>
		s++, neg = 1;
  801046:	ff 45 08             	incl   0x8(%ebp)
  801049:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801054:	74 06                	je     80105c <strtol+0x58>
  801056:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80105a:	75 20                	jne    80107c <strtol+0x78>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 30                	cmp    $0x30,%al
  801063:	75 17                	jne    80107c <strtol+0x78>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	40                   	inc    %eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 78                	cmp    $0x78,%al
  80106d:	75 0d                	jne    80107c <strtol+0x78>
		s += 2, base = 16;
  80106f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801073:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80107a:	eb 28                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80107c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801080:	75 15                	jne    801097 <strtol+0x93>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 30                	cmp    $0x30,%al
  801089:	75 0c                	jne    801097 <strtol+0x93>
		s++, base = 8;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801095:	eb 0d                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0)
  801097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109b:	75 07                	jne    8010a4 <strtol+0xa0>
		base = 10;
  80109d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 2f                	cmp    $0x2f,%al
  8010ab:	7e 19                	jle    8010c6 <strtol+0xc2>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 39                	cmp    $0x39,%al
  8010b4:	7f 10                	jg     8010c6 <strtol+0xc2>
			dig = *s - '0';
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	0f be c0             	movsbl %al,%eax
  8010be:	83 e8 30             	sub    $0x30,%eax
  8010c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c4:	eb 42                	jmp    801108 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 60                	cmp    $0x60,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xe4>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 7a                	cmp    $0x7a,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 57             	sub    $0x57,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 20                	jmp    801108 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 40                	cmp    $0x40,%al
  8010ef:	7e 39                	jle    80112a <strtol+0x126>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 5a                	cmp    $0x5a,%al
  8010f8:	7f 30                	jg     80112a <strtol+0x126>
			dig = *s - 'A' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 37             	sub    $0x37,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110e:	7d 19                	jge    801129 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801110:	ff 45 08             	incl   0x8(%ebp)
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	0f af 45 10          	imul   0x10(%ebp),%eax
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801124:	e9 7b ff ff ff       	jmp    8010a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801129:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80112a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112e:	74 08                	je     801138 <strtol+0x134>
		*endptr = (char *) s;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 07                	je     801145 <strtol+0x141>
  80113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801141:	f7 d8                	neg    %eax
  801143:	eb 03                	jmp    801148 <strtol+0x144>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <ltostr>:

void
ltostr(long value, char *str)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801157:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801162:	79 13                	jns    801177 <ltostr+0x2d>
	{
		neg = 1;
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801171:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801174:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117f:	99                   	cltd   
  801180:	f7 f9                	idiv   %ecx
  801182:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801198:	83 c2 30             	add    $0x30,%edx
  80119b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a5:	f7 e9                	imul   %ecx
  8011a7:	c1 fa 02             	sar    $0x2,%edx
  8011aa:	89 c8                	mov    %ecx,%eax
  8011ac:	c1 f8 1f             	sar    $0x1f,%eax
  8011af:	29 c2                	sub    %eax,%edx
  8011b1:	89 d0                	mov    %edx,%eax
  8011b3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011be:	f7 e9                	imul   %ecx
  8011c0:	c1 fa 02             	sar    $0x2,%edx
  8011c3:	89 c8                	mov    %ecx,%eax
  8011c5:	c1 f8 1f             	sar    $0x1f,%eax
  8011c8:	29 c2                	sub    %eax,%edx
  8011ca:	89 d0                	mov    %edx,%eax
  8011cc:	c1 e0 02             	shl    $0x2,%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	01 c0                	add    %eax,%eax
  8011d3:	29 c1                	sub    %eax,%ecx
  8011d5:	89 ca                	mov    %ecx,%edx
  8011d7:	85 d2                	test   %edx,%edx
  8011d9:	75 9c                	jne    801177 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	48                   	dec    %eax
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ed:	74 3d                	je     80122c <ltostr+0xe2>
		start = 1 ;
  8011ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f6:	eb 34                	jmp    80122c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 c2                	add    %eax,%edx
  80120d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 c8                	add    %ecx,%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	01 c2                	add    %eax,%edx
  801221:	8a 45 eb             	mov    -0x15(%ebp),%al
  801224:	88 02                	mov    %al,(%edx)
		start++ ;
  801226:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801229:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7c c4                	jl     8011f8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801234:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801248:	ff 75 08             	pushl  0x8(%ebp)
  80124b:	e8 54 fa ff ff       	call   800ca4 <strlen>
  801250:	83 c4 04             	add    $0x4,%esp
  801253:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	e8 46 fa ff ff       	call   800ca4 <strlen>
  80125e:	83 c4 04             	add    $0x4,%esp
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 17                	jmp    80128b <strcconcat+0x49>
		final[s] = str1[s] ;
  801274:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	01 c2                	add    %eax,%edx
  80127c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	01 c8                	add    %ecx,%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801288:	ff 45 fc             	incl   -0x4(%ebp)
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801291:	7c e1                	jl     801274 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801293:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80129a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012a1:	eb 1f                	jmp    8012c2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a6:	8d 50 01             	lea    0x1(%eax),%edx
  8012a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ac:	89 c2                	mov    %eax,%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 c8                	add    %ecx,%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bf:	ff 45 f8             	incl   -0x8(%ebp)
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c8:	7c d9                	jl     8012a3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d5:	90                   	nop
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012db:	8b 45 14             	mov    0x14(%ebp),%eax
  8012de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012fb:	eb 0c                	jmp    801309 <strsplit+0x31>
			*string++ = 0;
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8d 50 01             	lea    0x1(%eax),%edx
  801303:	89 55 08             	mov    %edx,0x8(%ebp)
  801306:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	84 c0                	test   %al,%al
  801310:	74 18                	je     80132a <strsplit+0x52>
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	0f be c0             	movsbl %al,%eax
  80131a:	50                   	push   %eax
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	e8 13 fb ff ff       	call   800e36 <strchr>
  801323:	83 c4 08             	add    $0x8,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	75 d3                	jne    8012fd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	84 c0                	test   %al,%al
  801331:	74 5a                	je     80138d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801333:	8b 45 14             	mov    0x14(%ebp),%eax
  801336:	8b 00                	mov    (%eax),%eax
  801338:	83 f8 0f             	cmp    $0xf,%eax
  80133b:	75 07                	jne    801344 <strsplit+0x6c>
		{
			return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	eb 66                	jmp    8013aa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801344:	8b 45 14             	mov    0x14(%ebp),%eax
  801347:	8b 00                	mov    (%eax),%eax
  801349:	8d 48 01             	lea    0x1(%eax),%ecx
  80134c:	8b 55 14             	mov    0x14(%ebp),%edx
  80134f:	89 0a                	mov    %ecx,(%edx)
  801351:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 c2                	add    %eax,%edx
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801362:	eb 03                	jmp    801367 <strsplit+0x8f>
			string++;
  801364:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	84 c0                	test   %al,%al
  80136e:	74 8b                	je     8012fb <strsplit+0x23>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f be c0             	movsbl %al,%eax
  801378:	50                   	push   %eax
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	e8 b5 fa ff ff       	call   800e36 <strchr>
  801381:	83 c4 08             	add    $0x8,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	74 dc                	je     801364 <strsplit+0x8c>
			string++;
	}
  801388:	e9 6e ff ff ff       	jmp    8012fb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80138d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138e:	8b 45 14             	mov    0x14(%ebp),%eax
  801391:	8b 00                	mov    (%eax),%eax
  801393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013b2:	a1 04 50 80 00       	mov    0x805004,%eax
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	74 1f                	je     8013da <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013bb:	e8 1d 00 00 00       	call   8013dd <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	68 30 3e 80 00       	push   $0x803e30
  8013c8:	e8 55 f2 ff ff       	call   800622 <cprintf>
  8013cd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013d0:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8013d7:	00 00 00 
	}
}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8013e3:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8013ea:	00 00 00 
  8013ed:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8013f4:	00 00 00 
  8013f7:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8013fe:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801401:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801408:	00 00 00 
  80140b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801412:	00 00 00 
  801415:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80141c:	00 00 00 
	uint32 arr_size = 0;
  80141f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801426:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80142d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801430:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801435:	2d 00 10 00 00       	sub    $0x1000,%eax
  80143a:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80143f:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801446:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801449:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801450:	a1 20 51 80 00       	mov    0x805120,%eax
  801455:	c1 e0 04             	shl    $0x4,%eax
  801458:	89 c2                	mov    %eax,%edx
  80145a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145d:	01 d0                	add    %edx,%eax
  80145f:	48                   	dec    %eax
  801460:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801463:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801466:	ba 00 00 00 00       	mov    $0x0,%edx
  80146b:	f7 75 ec             	divl   -0x14(%ebp)
  80146e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801471:	29 d0                	sub    %edx,%eax
  801473:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801476:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80147d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801480:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801485:	2d 00 10 00 00       	sub    $0x1000,%eax
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	6a 06                	push   $0x6
  80148f:	ff 75 f4             	pushl  -0xc(%ebp)
  801492:	50                   	push   %eax
  801493:	e8 42 04 00 00       	call   8018da <sys_allocate_chunk>
  801498:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80149b:	a1 20 51 80 00       	mov    0x805120,%eax
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	50                   	push   %eax
  8014a4:	e8 b7 0a 00 00       	call   801f60 <initialize_MemBlocksList>
  8014a9:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8014ac:	a1 48 51 80 00       	mov    0x805148,%eax
  8014b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8014b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8014be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8014c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014cc:	75 14                	jne    8014e2 <initialize_dyn_block_system+0x105>
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	68 55 3e 80 00       	push   $0x803e55
  8014d6:	6a 33                	push   $0x33
  8014d8:	68 73 3e 80 00       	push   $0x803e73
  8014dd:	e8 37 1f 00 00       	call   803419 <_panic>
  8014e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e5:	8b 00                	mov    (%eax),%eax
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	74 10                	je     8014fb <initialize_dyn_block_system+0x11e>
  8014eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ee:	8b 00                	mov    (%eax),%eax
  8014f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014f3:	8b 52 04             	mov    0x4(%edx),%edx
  8014f6:	89 50 04             	mov    %edx,0x4(%eax)
  8014f9:	eb 0b                	jmp    801506 <initialize_dyn_block_system+0x129>
  8014fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014fe:	8b 40 04             	mov    0x4(%eax),%eax
  801501:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801506:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801509:	8b 40 04             	mov    0x4(%eax),%eax
  80150c:	85 c0                	test   %eax,%eax
  80150e:	74 0f                	je     80151f <initialize_dyn_block_system+0x142>
  801510:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801513:	8b 40 04             	mov    0x4(%eax),%eax
  801516:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801519:	8b 12                	mov    (%edx),%edx
  80151b:	89 10                	mov    %edx,(%eax)
  80151d:	eb 0a                	jmp    801529 <initialize_dyn_block_system+0x14c>
  80151f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801522:	8b 00                	mov    (%eax),%eax
  801524:	a3 48 51 80 00       	mov    %eax,0x805148
  801529:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801535:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80153c:	a1 54 51 80 00       	mov    0x805154,%eax
  801541:	48                   	dec    %eax
  801542:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801547:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80154b:	75 14                	jne    801561 <initialize_dyn_block_system+0x184>
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	68 80 3e 80 00       	push   $0x803e80
  801555:	6a 34                	push   $0x34
  801557:	68 73 3e 80 00       	push   $0x803e73
  80155c:	e8 b8 1e 00 00       	call   803419 <_panic>
  801561:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156a:	89 10                	mov    %edx,(%eax)
  80156c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156f:	8b 00                	mov    (%eax),%eax
  801571:	85 c0                	test   %eax,%eax
  801573:	74 0d                	je     801582 <initialize_dyn_block_system+0x1a5>
  801575:	a1 38 51 80 00       	mov    0x805138,%eax
  80157a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80157d:	89 50 04             	mov    %edx,0x4(%eax)
  801580:	eb 08                	jmp    80158a <initialize_dyn_block_system+0x1ad>
  801582:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801585:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80158a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158d:	a3 38 51 80 00       	mov    %eax,0x805138
  801592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801595:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80159c:	a1 44 51 80 00       	mov    0x805144,%eax
  8015a1:	40                   	inc    %eax
  8015a2:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8015a7:	90                   	nop
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b0:	e8 f7 fd ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  8015b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b9:	75 07                	jne    8015c2 <malloc+0x18>
  8015bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c0:	eb 14                	jmp    8015d6 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	68 a4 3e 80 00       	push   $0x803ea4
  8015ca:	6a 46                	push   $0x46
  8015cc:	68 73 3e 80 00       	push   $0x803e73
  8015d1:	e8 43 1e 00 00       	call   803419 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	68 cc 3e 80 00       	push   $0x803ecc
  8015e6:	6a 61                	push   $0x61
  8015e8:	68 73 3e 80 00       	push   $0x803e73
  8015ed:	e8 27 1e 00 00       	call   803419 <_panic>

008015f2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 38             	sub    $0x38,%esp
  8015f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fb:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015fe:	e8 a9 fd ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  801603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801607:	75 0a                	jne    801613 <smalloc+0x21>
  801609:	b8 00 00 00 00       	mov    $0x0,%eax
  80160e:	e9 9e 00 00 00       	jmp    8016b1 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801613:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80161a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801620:	01 d0                	add    %edx,%eax
  801622:	48                   	dec    %eax
  801623:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801629:	ba 00 00 00 00       	mov    $0x0,%edx
  80162e:	f7 75 f0             	divl   -0x10(%ebp)
  801631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801634:	29 d0                	sub    %edx,%eax
  801636:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801639:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801640:	e8 63 06 00 00       	call   801ca8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801645:	85 c0                	test   %eax,%eax
  801647:	74 11                	je     80165a <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801649:	83 ec 0c             	sub    $0xc,%esp
  80164c:	ff 75 e8             	pushl  -0x18(%ebp)
  80164f:	e8 ce 0c 00 00       	call   802322 <alloc_block_FF>
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80165a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80165e:	74 4c                	je     8016ac <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801663:	8b 40 08             	mov    0x8(%eax),%eax
  801666:	89 c2                	mov    %eax,%edx
  801668:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80166c:	52                   	push   %edx
  80166d:	50                   	push   %eax
  80166e:	ff 75 0c             	pushl  0xc(%ebp)
  801671:	ff 75 08             	pushl  0x8(%ebp)
  801674:	e8 b4 03 00 00       	call   801a2d <sys_createSharedObject>
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  80167f:	83 ec 08             	sub    $0x8,%esp
  801682:	ff 75 e0             	pushl  -0x20(%ebp)
  801685:	68 ef 3e 80 00       	push   $0x803eef
  80168a:	e8 93 ef ff ff       	call   800622 <cprintf>
  80168f:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801692:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801696:	74 14                	je     8016ac <smalloc+0xba>
  801698:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80169c:	74 0e                	je     8016ac <smalloc+0xba>
  80169e:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016a2:	74 08                	je     8016ac <smalloc+0xba>
			return (void*) mem_block->sva;
  8016a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a7:	8b 40 08             	mov    0x8(%eax),%eax
  8016aa:	eb 05                	jmp    8016b1 <smalloc+0xbf>
	}
	return NULL;
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b9:	e8 ee fc ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016be:	83 ec 04             	sub    $0x4,%esp
  8016c1:	68 04 3f 80 00       	push   $0x803f04
  8016c6:	68 ab 00 00 00       	push   $0xab
  8016cb:	68 73 3e 80 00       	push   $0x803e73
  8016d0:	e8 44 1d 00 00       	call   803419 <_panic>

008016d5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016db:	e8 cc fc ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016e0:	83 ec 04             	sub    $0x4,%esp
  8016e3:	68 28 3f 80 00       	push   $0x803f28
  8016e8:	68 ef 00 00 00       	push   $0xef
  8016ed:	68 73 3e 80 00       	push   $0x803e73
  8016f2:	e8 22 1d 00 00       	call   803419 <_panic>

008016f7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	68 50 3f 80 00       	push   $0x803f50
  801705:	68 03 01 00 00       	push   $0x103
  80170a:	68 73 3e 80 00       	push   $0x803e73
  80170f:	e8 05 1d 00 00       	call   803419 <_panic>

00801714 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80171a:	83 ec 04             	sub    $0x4,%esp
  80171d:	68 74 3f 80 00       	push   $0x803f74
  801722:	68 0e 01 00 00       	push   $0x10e
  801727:	68 73 3e 80 00       	push   $0x803e73
  80172c:	e8 e8 1c 00 00       	call   803419 <_panic>

00801731 <shrink>:

}
void shrink(uint32 newSize)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801737:	83 ec 04             	sub    $0x4,%esp
  80173a:	68 74 3f 80 00       	push   $0x803f74
  80173f:	68 13 01 00 00       	push   $0x113
  801744:	68 73 3e 80 00       	push   $0x803e73
  801749:	e8 cb 1c 00 00       	call   803419 <_panic>

0080174e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	68 74 3f 80 00       	push   $0x803f74
  80175c:	68 18 01 00 00       	push   $0x118
  801761:	68 73 3e 80 00       	push   $0x803e73
  801766:	e8 ae 1c 00 00       	call   803419 <_panic>

0080176b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	57                   	push   %edi
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
  801771:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801780:	8b 7d 18             	mov    0x18(%ebp),%edi
  801783:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801786:	cd 30                	int    $0x30
  801788:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80178b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80178e:	83 c4 10             	add    $0x10,%esp
  801791:	5b                   	pop    %ebx
  801792:	5e                   	pop    %esi
  801793:	5f                   	pop    %edi
  801794:	5d                   	pop    %ebp
  801795:	c3                   	ret    

00801796 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	8b 45 10             	mov    0x10(%ebp),%eax
  80179f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017a2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	52                   	push   %edx
  8017ae:	ff 75 0c             	pushl  0xc(%ebp)
  8017b1:	50                   	push   %eax
  8017b2:	6a 00                	push   $0x0
  8017b4:	e8 b2 ff ff ff       	call   80176b <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	90                   	nop
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_cgetc>:

int
sys_cgetc(void)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 01                	push   $0x1
  8017ce:	e8 98 ff ff ff       	call   80176b <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	52                   	push   %edx
  8017e8:	50                   	push   %eax
  8017e9:	6a 05                	push   $0x5
  8017eb:	e8 7b ff ff ff       	call   80176b <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	56                   	push   %esi
  8017f9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017fa:	8b 75 18             	mov    0x18(%ebp),%esi
  8017fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801800:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801803:	8b 55 0c             	mov    0xc(%ebp),%edx
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	56                   	push   %esi
  80180a:	53                   	push   %ebx
  80180b:	51                   	push   %ecx
  80180c:	52                   	push   %edx
  80180d:	50                   	push   %eax
  80180e:	6a 06                	push   $0x6
  801810:	e8 56 ff ff ff       	call   80176b <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
}
  801818:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80181b:	5b                   	pop    %ebx
  80181c:	5e                   	pop    %esi
  80181d:	5d                   	pop    %ebp
  80181e:	c3                   	ret    

0080181f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801822:	8b 55 0c             	mov    0xc(%ebp),%edx
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	52                   	push   %edx
  80182f:	50                   	push   %eax
  801830:	6a 07                	push   $0x7
  801832:	e8 34 ff ff ff       	call   80176b <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	ff 75 0c             	pushl  0xc(%ebp)
  801848:	ff 75 08             	pushl  0x8(%ebp)
  80184b:	6a 08                	push   $0x8
  80184d:	e8 19 ff ff ff       	call   80176b <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 09                	push   $0x9
  801866:	e8 00 ff ff ff       	call   80176b <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 0a                	push   $0xa
  80187f:	e8 e7 fe ff ff       	call   80176b <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 0b                	push   $0xb
  801898:	e8 ce fe ff ff       	call   80176b <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	6a 0f                	push   $0xf
  8018b3:	e8 b3 fe ff ff       	call   80176b <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
	return;
  8018bb:	90                   	nop
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	ff 75 08             	pushl  0x8(%ebp)
  8018cd:	6a 10                	push   $0x10
  8018cf:	e8 97 fe ff ff       	call   80176b <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d7:	90                   	nop
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	ff 75 10             	pushl  0x10(%ebp)
  8018e4:	ff 75 0c             	pushl  0xc(%ebp)
  8018e7:	ff 75 08             	pushl  0x8(%ebp)
  8018ea:	6a 11                	push   $0x11
  8018ec:	e8 7a fe ff ff       	call   80176b <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f4:	90                   	nop
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 0c                	push   $0xc
  801906:	e8 60 fe ff ff       	call   80176b <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	ff 75 08             	pushl  0x8(%ebp)
  80191e:	6a 0d                	push   $0xd
  801920:	e8 46 fe ff ff       	call   80176b <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 0e                	push   $0xe
  801939:	e8 2d fe ff ff       	call   80176b <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	90                   	nop
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 13                	push   $0x13
  801953:	e8 13 fe ff ff       	call   80176b <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	90                   	nop
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 14                	push   $0x14
  80196d:	e8 f9 fd ff ff       	call   80176b <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	90                   	nop
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_cputc>:


void
sys_cputc(const char c)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 04             	sub    $0x4,%esp
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801984:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	50                   	push   %eax
  801991:	6a 15                	push   $0x15
  801993:	e8 d3 fd ff ff       	call   80176b <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	90                   	nop
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 16                	push   $0x16
  8019ad:	e8 b9 fd ff ff       	call   80176b <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	90                   	nop
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 0c             	pushl  0xc(%ebp)
  8019c7:	50                   	push   %eax
  8019c8:	6a 17                	push   $0x17
  8019ca:	e8 9c fd ff ff       	call   80176b <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	52                   	push   %edx
  8019e4:	50                   	push   %eax
  8019e5:	6a 1a                	push   $0x1a
  8019e7:	e8 7f fd ff ff       	call   80176b <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	52                   	push   %edx
  801a01:	50                   	push   %eax
  801a02:	6a 18                	push   $0x18
  801a04:	e8 62 fd ff ff       	call   80176b <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	90                   	nop
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	52                   	push   %edx
  801a1f:	50                   	push   %eax
  801a20:	6a 19                	push   $0x19
  801a22:	e8 44 fd ff ff       	call   80176b <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	90                   	nop
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	8b 45 10             	mov    0x10(%ebp),%eax
  801a36:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a39:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a3c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	6a 00                	push   $0x0
  801a45:	51                   	push   %ecx
  801a46:	52                   	push   %edx
  801a47:	ff 75 0c             	pushl  0xc(%ebp)
  801a4a:	50                   	push   %eax
  801a4b:	6a 1b                	push   $0x1b
  801a4d:	e8 19 fd ff ff       	call   80176b <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	52                   	push   %edx
  801a67:	50                   	push   %eax
  801a68:	6a 1c                	push   $0x1c
  801a6a:	e8 fc fc ff ff       	call   80176b <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a77:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	51                   	push   %ecx
  801a85:	52                   	push   %edx
  801a86:	50                   	push   %eax
  801a87:	6a 1d                	push   $0x1d
  801a89:	e8 dd fc ff ff       	call   80176b <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	52                   	push   %edx
  801aa3:	50                   	push   %eax
  801aa4:	6a 1e                	push   $0x1e
  801aa6:	e8 c0 fc ff ff       	call   80176b <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 1f                	push   $0x1f
  801abf:	e8 a7 fc ff ff       	call   80176b <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	6a 00                	push   $0x0
  801ad1:	ff 75 14             	pushl  0x14(%ebp)
  801ad4:	ff 75 10             	pushl  0x10(%ebp)
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	50                   	push   %eax
  801adb:	6a 20                	push   $0x20
  801add:	e8 89 fc ff ff       	call   80176b <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	50                   	push   %eax
  801af6:	6a 21                	push   $0x21
  801af8:	e8 6e fc ff ff       	call   80176b <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	90                   	nop
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	50                   	push   %eax
  801b12:	6a 22                	push   $0x22
  801b14:	e8 52 fc ff ff       	call   80176b <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 02                	push   $0x2
  801b2d:	e8 39 fc ff ff       	call   80176b <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 03                	push   $0x3
  801b46:	e8 20 fc ff ff       	call   80176b <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 04                	push   $0x4
  801b5f:	e8 07 fc ff ff       	call   80176b <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_exit_env>:


void sys_exit_env(void)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 23                	push   $0x23
  801b78:	e8 ee fb ff ff       	call   80176b <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	90                   	nop
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b89:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8c:	8d 50 04             	lea    0x4(%eax),%edx
  801b8f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	52                   	push   %edx
  801b99:	50                   	push   %eax
  801b9a:	6a 24                	push   $0x24
  801b9c:	e8 ca fb ff ff       	call   80176b <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801baa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bad:	89 01                	mov    %eax,(%ecx)
  801baf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	c9                   	leave  
  801bb6:	c2 04 00             	ret    $0x4

00801bb9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	ff 75 10             	pushl  0x10(%ebp)
  801bc3:	ff 75 0c             	pushl  0xc(%ebp)
  801bc6:	ff 75 08             	pushl  0x8(%ebp)
  801bc9:	6a 12                	push   $0x12
  801bcb:	e8 9b fb ff ff       	call   80176b <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd3:	90                   	nop
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 25                	push   $0x25
  801be5:	e8 81 fb ff ff       	call   80176b <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bfb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	50                   	push   %eax
  801c08:	6a 26                	push   $0x26
  801c0a:	e8 5c fb ff ff       	call   80176b <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c12:	90                   	nop
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <rsttst>:
void rsttst()
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 28                	push   $0x28
  801c24:	e8 42 fb ff ff       	call   80176b <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2c:	90                   	nop
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	8b 45 14             	mov    0x14(%ebp),%eax
  801c38:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c3b:	8b 55 18             	mov    0x18(%ebp),%edx
  801c3e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c42:	52                   	push   %edx
  801c43:	50                   	push   %eax
  801c44:	ff 75 10             	pushl  0x10(%ebp)
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	6a 27                	push   $0x27
  801c4f:	e8 17 fb ff ff       	call   80176b <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
	return ;
  801c57:	90                   	nop
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <chktst>:
void chktst(uint32 n)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	6a 29                	push   $0x29
  801c6a:	e8 fc fa ff ff       	call   80176b <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c72:	90                   	nop
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <inctst>:

void inctst()
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 2a                	push   $0x2a
  801c84:	e8 e2 fa ff ff       	call   80176b <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8c:	90                   	nop
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <gettst>:
uint32 gettst()
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 2b                	push   $0x2b
  801c9e:	e8 c8 fa ff ff       	call   80176b <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 2c                	push   $0x2c
  801cba:	e8 ac fa ff ff       	call   80176b <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
  801cc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cc5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cc9:	75 07                	jne    801cd2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ccb:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd0:	eb 05                	jmp    801cd7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 2c                	push   $0x2c
  801ceb:	e8 7b fa ff ff       	call   80176b <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
  801cf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cf6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cfa:	75 07                	jne    801d03 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cfc:	b8 01 00 00 00       	mov    $0x1,%eax
  801d01:	eb 05                	jmp    801d08 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 2c                	push   $0x2c
  801d1c:	e8 4a fa ff ff       	call   80176b <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
  801d24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d27:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d2b:	75 07                	jne    801d34 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d32:	eb 05                	jmp    801d39 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 2c                	push   $0x2c
  801d4d:	e8 19 fa ff ff       	call   80176b <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
  801d55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d58:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d5c:	75 07                	jne    801d65 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	eb 05                	jmp    801d6a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	ff 75 08             	pushl  0x8(%ebp)
  801d7a:	6a 2d                	push   $0x2d
  801d7c:	e8 ea f9 ff ff       	call   80176b <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
	return ;
  801d84:	90                   	nop
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	6a 00                	push   $0x0
  801d99:	53                   	push   %ebx
  801d9a:	51                   	push   %ecx
  801d9b:	52                   	push   %edx
  801d9c:	50                   	push   %eax
  801d9d:	6a 2e                	push   $0x2e
  801d9f:	e8 c7 f9 ff ff       	call   80176b <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	52                   	push   %edx
  801dbc:	50                   	push   %eax
  801dbd:	6a 2f                	push   $0x2f
  801dbf:	e8 a7 f9 ff ff       	call   80176b <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dcf:	83 ec 0c             	sub    $0xc,%esp
  801dd2:	68 84 3f 80 00       	push   $0x803f84
  801dd7:	e8 46 e8 ff ff       	call   800622 <cprintf>
  801ddc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ddf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801de6:	83 ec 0c             	sub    $0xc,%esp
  801de9:	68 b0 3f 80 00       	push   $0x803fb0
  801dee:	e8 2f e8 ff ff       	call   800622 <cprintf>
  801df3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801df6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dfa:	a1 38 51 80 00       	mov    0x805138,%eax
  801dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e02:	eb 56                	jmp    801e5a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e08:	74 1c                	je     801e26 <print_mem_block_lists+0x5d>
  801e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0d:	8b 50 08             	mov    0x8(%eax),%edx
  801e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e13:	8b 48 08             	mov    0x8(%eax),%ecx
  801e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e19:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1c:	01 c8                	add    %ecx,%eax
  801e1e:	39 c2                	cmp    %eax,%edx
  801e20:	73 04                	jae    801e26 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e22:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	8b 50 08             	mov    0x8(%eax),%edx
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e32:	01 c2                	add    %eax,%edx
  801e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e37:	8b 40 08             	mov    0x8(%eax),%eax
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	52                   	push   %edx
  801e3e:	50                   	push   %eax
  801e3f:	68 c5 3f 80 00       	push   $0x803fc5
  801e44:	e8 d9 e7 ff ff       	call   800622 <cprintf>
  801e49:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e52:	a1 40 51 80 00       	mov    0x805140,%eax
  801e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5e:	74 07                	je     801e67 <print_mem_block_lists+0x9e>
  801e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e63:	8b 00                	mov    (%eax),%eax
  801e65:	eb 05                	jmp    801e6c <print_mem_block_lists+0xa3>
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6c:	a3 40 51 80 00       	mov    %eax,0x805140
  801e71:	a1 40 51 80 00       	mov    0x805140,%eax
  801e76:	85 c0                	test   %eax,%eax
  801e78:	75 8a                	jne    801e04 <print_mem_block_lists+0x3b>
  801e7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e7e:	75 84                	jne    801e04 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e80:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e84:	75 10                	jne    801e96 <print_mem_block_lists+0xcd>
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	68 d4 3f 80 00       	push   $0x803fd4
  801e8e:	e8 8f e7 ff ff       	call   800622 <cprintf>
  801e93:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e9d:	83 ec 0c             	sub    $0xc,%esp
  801ea0:	68 f8 3f 80 00       	push   $0x803ff8
  801ea5:	e8 78 e7 ff ff       	call   800622 <cprintf>
  801eaa:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ead:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eb1:	a1 40 50 80 00       	mov    0x805040,%eax
  801eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb9:	eb 56                	jmp    801f11 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ebb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ebf:	74 1c                	je     801edd <print_mem_block_lists+0x114>
  801ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec4:	8b 50 08             	mov    0x8(%eax),%edx
  801ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eca:	8b 48 08             	mov    0x8(%eax),%ecx
  801ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed3:	01 c8                	add    %ecx,%eax
  801ed5:	39 c2                	cmp    %eax,%edx
  801ed7:	73 04                	jae    801edd <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ed9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee0:	8b 50 08             	mov    0x8(%eax),%edx
  801ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee9:	01 c2                	add    %eax,%edx
  801eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eee:	8b 40 08             	mov    0x8(%eax),%eax
  801ef1:	83 ec 04             	sub    $0x4,%esp
  801ef4:	52                   	push   %edx
  801ef5:	50                   	push   %eax
  801ef6:	68 c5 3f 80 00       	push   $0x803fc5
  801efb:	e8 22 e7 ff ff       	call   800622 <cprintf>
  801f00:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f09:	a1 48 50 80 00       	mov    0x805048,%eax
  801f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f15:	74 07                	je     801f1e <print_mem_block_lists+0x155>
  801f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1a:	8b 00                	mov    (%eax),%eax
  801f1c:	eb 05                	jmp    801f23 <print_mem_block_lists+0x15a>
  801f1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f23:	a3 48 50 80 00       	mov    %eax,0x805048
  801f28:	a1 48 50 80 00       	mov    0x805048,%eax
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	75 8a                	jne    801ebb <print_mem_block_lists+0xf2>
  801f31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f35:	75 84                	jne    801ebb <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f37:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f3b:	75 10                	jne    801f4d <print_mem_block_lists+0x184>
  801f3d:	83 ec 0c             	sub    $0xc,%esp
  801f40:	68 10 40 80 00       	push   $0x804010
  801f45:	e8 d8 e6 ff ff       	call   800622 <cprintf>
  801f4a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	68 84 3f 80 00       	push   $0x803f84
  801f55:	e8 c8 e6 ff ff       	call   800622 <cprintf>
  801f5a:	83 c4 10             	add    $0x10,%esp

}
  801f5d:	90                   	nop
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f66:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f6d:	00 00 00 
  801f70:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f77:	00 00 00 
  801f7a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f81:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f8b:	e9 9e 00 00 00       	jmp    80202e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f90:	a1 50 50 80 00       	mov    0x805050,%eax
  801f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f98:	c1 e2 04             	shl    $0x4,%edx
  801f9b:	01 d0                	add    %edx,%eax
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	75 14                	jne    801fb5 <initialize_MemBlocksList+0x55>
  801fa1:	83 ec 04             	sub    $0x4,%esp
  801fa4:	68 38 40 80 00       	push   $0x804038
  801fa9:	6a 46                	push   $0x46
  801fab:	68 5b 40 80 00       	push   $0x80405b
  801fb0:	e8 64 14 00 00       	call   803419 <_panic>
  801fb5:	a1 50 50 80 00       	mov    0x805050,%eax
  801fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbd:	c1 e2 04             	shl    $0x4,%edx
  801fc0:	01 d0                	add    %edx,%eax
  801fc2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fc8:	89 10                	mov    %edx,(%eax)
  801fca:	8b 00                	mov    (%eax),%eax
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	74 18                	je     801fe8 <initialize_MemBlocksList+0x88>
  801fd0:	a1 48 51 80 00       	mov    0x805148,%eax
  801fd5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fdb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fde:	c1 e1 04             	shl    $0x4,%ecx
  801fe1:	01 ca                	add    %ecx,%edx
  801fe3:	89 50 04             	mov    %edx,0x4(%eax)
  801fe6:	eb 12                	jmp    801ffa <initialize_MemBlocksList+0x9a>
  801fe8:	a1 50 50 80 00       	mov    0x805050,%eax
  801fed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff0:	c1 e2 04             	shl    $0x4,%edx
  801ff3:	01 d0                	add    %edx,%eax
  801ff5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ffa:	a1 50 50 80 00       	mov    0x805050,%eax
  801fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802002:	c1 e2 04             	shl    $0x4,%edx
  802005:	01 d0                	add    %edx,%eax
  802007:	a3 48 51 80 00       	mov    %eax,0x805148
  80200c:	a1 50 50 80 00       	mov    0x805050,%eax
  802011:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802014:	c1 e2 04             	shl    $0x4,%edx
  802017:	01 d0                	add    %edx,%eax
  802019:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802020:	a1 54 51 80 00       	mov    0x805154,%eax
  802025:	40                   	inc    %eax
  802026:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80202b:	ff 45 f4             	incl   -0xc(%ebp)
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	3b 45 08             	cmp    0x8(%ebp),%eax
  802034:	0f 82 56 ff ff ff    	jb     801f90 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80203a:	90                   	nop
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	8b 00                	mov    (%eax),%eax
  802048:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80204b:	eb 19                	jmp    802066 <find_block+0x29>
	{
		if(va==point->sva)
  80204d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802050:	8b 40 08             	mov    0x8(%eax),%eax
  802053:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802056:	75 05                	jne    80205d <find_block+0x20>
		   return point;
  802058:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205b:	eb 36                	jmp    802093 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	8b 40 08             	mov    0x8(%eax),%eax
  802063:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802066:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80206a:	74 07                	je     802073 <find_block+0x36>
  80206c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206f:	8b 00                	mov    (%eax),%eax
  802071:	eb 05                	jmp    802078 <find_block+0x3b>
  802073:	b8 00 00 00 00       	mov    $0x0,%eax
  802078:	8b 55 08             	mov    0x8(%ebp),%edx
  80207b:	89 42 08             	mov    %eax,0x8(%edx)
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	8b 40 08             	mov    0x8(%eax),%eax
  802084:	85 c0                	test   %eax,%eax
  802086:	75 c5                	jne    80204d <find_block+0x10>
  802088:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80208c:	75 bf                	jne    80204d <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80209b:	a1 40 50 80 00       	mov    0x805040,%eax
  8020a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020a3:	a1 44 50 80 00       	mov    0x805044,%eax
  8020a8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020b1:	74 24                	je     8020d7 <insert_sorted_allocList+0x42>
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	8b 50 08             	mov    0x8(%eax),%edx
  8020b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bc:	8b 40 08             	mov    0x8(%eax),%eax
  8020bf:	39 c2                	cmp    %eax,%edx
  8020c1:	76 14                	jbe    8020d7 <insert_sorted_allocList+0x42>
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	8b 50 08             	mov    0x8(%eax),%edx
  8020c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020cc:	8b 40 08             	mov    0x8(%eax),%eax
  8020cf:	39 c2                	cmp    %eax,%edx
  8020d1:	0f 82 60 01 00 00    	jb     802237 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020db:	75 65                	jne    802142 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e1:	75 14                	jne    8020f7 <insert_sorted_allocList+0x62>
  8020e3:	83 ec 04             	sub    $0x4,%esp
  8020e6:	68 38 40 80 00       	push   $0x804038
  8020eb:	6a 6b                	push   $0x6b
  8020ed:	68 5b 40 80 00       	push   $0x80405b
  8020f2:	e8 22 13 00 00       	call   803419 <_panic>
  8020f7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	89 10                	mov    %edx,(%eax)
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	85 c0                	test   %eax,%eax
  802109:	74 0d                	je     802118 <insert_sorted_allocList+0x83>
  80210b:	a1 40 50 80 00       	mov    0x805040,%eax
  802110:	8b 55 08             	mov    0x8(%ebp),%edx
  802113:	89 50 04             	mov    %edx,0x4(%eax)
  802116:	eb 08                	jmp    802120 <insert_sorted_allocList+0x8b>
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	a3 44 50 80 00       	mov    %eax,0x805044
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	a3 40 50 80 00       	mov    %eax,0x805040
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802132:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802137:	40                   	inc    %eax
  802138:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80213d:	e9 dc 01 00 00       	jmp    80231e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	8b 50 08             	mov    0x8(%eax),%edx
  802148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214b:	8b 40 08             	mov    0x8(%eax),%eax
  80214e:	39 c2                	cmp    %eax,%edx
  802150:	77 6c                	ja     8021be <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802152:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802156:	74 06                	je     80215e <insert_sorted_allocList+0xc9>
  802158:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80215c:	75 14                	jne    802172 <insert_sorted_allocList+0xdd>
  80215e:	83 ec 04             	sub    $0x4,%esp
  802161:	68 74 40 80 00       	push   $0x804074
  802166:	6a 6f                	push   $0x6f
  802168:	68 5b 40 80 00       	push   $0x80405b
  80216d:	e8 a7 12 00 00       	call   803419 <_panic>
  802172:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802175:	8b 50 04             	mov    0x4(%eax),%edx
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	89 50 04             	mov    %edx,0x4(%eax)
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802184:	89 10                	mov    %edx,(%eax)
  802186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802189:	8b 40 04             	mov    0x4(%eax),%eax
  80218c:	85 c0                	test   %eax,%eax
  80218e:	74 0d                	je     80219d <insert_sorted_allocList+0x108>
  802190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802193:	8b 40 04             	mov    0x4(%eax),%eax
  802196:	8b 55 08             	mov    0x8(%ebp),%edx
  802199:	89 10                	mov    %edx,(%eax)
  80219b:	eb 08                	jmp    8021a5 <insert_sorted_allocList+0x110>
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	a3 40 50 80 00       	mov    %eax,0x805040
  8021a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ab:	89 50 04             	mov    %edx,0x4(%eax)
  8021ae:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021b3:	40                   	inc    %eax
  8021b4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021b9:	e9 60 01 00 00       	jmp    80231e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	8b 50 08             	mov    0x8(%eax),%edx
  8021c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ca:	39 c2                	cmp    %eax,%edx
  8021cc:	0f 82 4c 01 00 00    	jb     80231e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d6:	75 14                	jne    8021ec <insert_sorted_allocList+0x157>
  8021d8:	83 ec 04             	sub    $0x4,%esp
  8021db:	68 ac 40 80 00       	push   $0x8040ac
  8021e0:	6a 73                	push   $0x73
  8021e2:	68 5b 40 80 00       	push   $0x80405b
  8021e7:	e8 2d 12 00 00       	call   803419 <_panic>
  8021ec:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	89 50 04             	mov    %edx,0x4(%eax)
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	8b 40 04             	mov    0x4(%eax),%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	74 0c                	je     80220e <insert_sorted_allocList+0x179>
  802202:	a1 44 50 80 00       	mov    0x805044,%eax
  802207:	8b 55 08             	mov    0x8(%ebp),%edx
  80220a:	89 10                	mov    %edx,(%eax)
  80220c:	eb 08                	jmp    802216 <insert_sorted_allocList+0x181>
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	a3 40 50 80 00       	mov    %eax,0x805040
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	a3 44 50 80 00       	mov    %eax,0x805044
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802227:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80222c:	40                   	inc    %eax
  80222d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802232:	e9 e7 00 00 00       	jmp    80231e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802237:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80223d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802244:	a1 40 50 80 00       	mov    0x805040,%eax
  802249:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224c:	e9 9d 00 00 00       	jmp    8022ee <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	8b 00                	mov    (%eax),%eax
  802256:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	8b 50 08             	mov    0x8(%eax),%edx
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	8b 40 08             	mov    0x8(%eax),%eax
  802265:	39 c2                	cmp    %eax,%edx
  802267:	76 7d                	jbe    8022e6 <insert_sorted_allocList+0x251>
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	8b 50 08             	mov    0x8(%eax),%edx
  80226f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802272:	8b 40 08             	mov    0x8(%eax),%eax
  802275:	39 c2                	cmp    %eax,%edx
  802277:	73 6d                	jae    8022e6 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227d:	74 06                	je     802285 <insert_sorted_allocList+0x1f0>
  80227f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802283:	75 14                	jne    802299 <insert_sorted_allocList+0x204>
  802285:	83 ec 04             	sub    $0x4,%esp
  802288:	68 d0 40 80 00       	push   $0x8040d0
  80228d:	6a 7f                	push   $0x7f
  80228f:	68 5b 40 80 00       	push   $0x80405b
  802294:	e8 80 11 00 00       	call   803419 <_panic>
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 10                	mov    (%eax),%edx
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	89 10                	mov    %edx,(%eax)
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8b 00                	mov    (%eax),%eax
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	74 0b                	je     8022b7 <insert_sorted_allocList+0x222>
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	8b 00                	mov    (%eax),%eax
  8022b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b4:	89 50 04             	mov    %edx,0x4(%eax)
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bd:	89 10                	mov    %edx,(%eax)
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c5:	89 50 04             	mov    %edx,0x4(%eax)
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	8b 00                	mov    (%eax),%eax
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	75 08                	jne    8022d9 <insert_sorted_allocList+0x244>
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022de:	40                   	inc    %eax
  8022df:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022e4:	eb 39                	jmp    80231f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022e6:	a1 48 50 80 00       	mov    0x805048,%eax
  8022eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f2:	74 07                	je     8022fb <insert_sorted_allocList+0x266>
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 00                	mov    (%eax),%eax
  8022f9:	eb 05                	jmp    802300 <insert_sorted_allocList+0x26b>
  8022fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802300:	a3 48 50 80 00       	mov    %eax,0x805048
  802305:	a1 48 50 80 00       	mov    0x805048,%eax
  80230a:	85 c0                	test   %eax,%eax
  80230c:	0f 85 3f ff ff ff    	jne    802251 <insert_sorted_allocList+0x1bc>
  802312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802316:	0f 85 35 ff ff ff    	jne    802251 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80231c:	eb 01                	jmp    80231f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80231e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80231f:	90                   	nop
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802328:	a1 38 51 80 00       	mov    0x805138,%eax
  80232d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802330:	e9 85 01 00 00       	jmp    8024ba <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 40 0c             	mov    0xc(%eax),%eax
  80233b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233e:	0f 82 6e 01 00 00    	jb     8024b2 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 40 0c             	mov    0xc(%eax),%eax
  80234a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80234d:	0f 85 8a 00 00 00    	jne    8023dd <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802357:	75 17                	jne    802370 <alloc_block_FF+0x4e>
  802359:	83 ec 04             	sub    $0x4,%esp
  80235c:	68 04 41 80 00       	push   $0x804104
  802361:	68 93 00 00 00       	push   $0x93
  802366:	68 5b 40 80 00       	push   $0x80405b
  80236b:	e8 a9 10 00 00       	call   803419 <_panic>
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 00                	mov    (%eax),%eax
  802375:	85 c0                	test   %eax,%eax
  802377:	74 10                	je     802389 <alloc_block_FF+0x67>
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 00                	mov    (%eax),%eax
  80237e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802381:	8b 52 04             	mov    0x4(%edx),%edx
  802384:	89 50 04             	mov    %edx,0x4(%eax)
  802387:	eb 0b                	jmp    802394 <alloc_block_FF+0x72>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 40 04             	mov    0x4(%eax),%eax
  80238f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 40 04             	mov    0x4(%eax),%eax
  80239a:	85 c0                	test   %eax,%eax
  80239c:	74 0f                	je     8023ad <alloc_block_FF+0x8b>
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 40 04             	mov    0x4(%eax),%eax
  8023a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a7:	8b 12                	mov    (%edx),%edx
  8023a9:	89 10                	mov    %edx,(%eax)
  8023ab:	eb 0a                	jmp    8023b7 <alloc_block_FF+0x95>
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	a3 38 51 80 00       	mov    %eax,0x805138
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ca:	a1 44 51 80 00       	mov    0x805144,%eax
  8023cf:	48                   	dec    %eax
  8023d0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	e9 10 01 00 00       	jmp    8024ed <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e6:	0f 86 c6 00 00 00    	jbe    8024b2 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8023f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 50 08             	mov    0x8(%eax),%edx
  8023fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fd:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802403:	8b 55 08             	mov    0x8(%ebp),%edx
  802406:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802409:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80240d:	75 17                	jne    802426 <alloc_block_FF+0x104>
  80240f:	83 ec 04             	sub    $0x4,%esp
  802412:	68 04 41 80 00       	push   $0x804104
  802417:	68 9b 00 00 00       	push   $0x9b
  80241c:	68 5b 40 80 00       	push   $0x80405b
  802421:	e8 f3 0f 00 00       	call   803419 <_panic>
  802426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	74 10                	je     80243f <alloc_block_FF+0x11d>
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802437:	8b 52 04             	mov    0x4(%edx),%edx
  80243a:	89 50 04             	mov    %edx,0x4(%eax)
  80243d:	eb 0b                	jmp    80244a <alloc_block_FF+0x128>
  80243f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802442:	8b 40 04             	mov    0x4(%eax),%eax
  802445:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80244a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244d:	8b 40 04             	mov    0x4(%eax),%eax
  802450:	85 c0                	test   %eax,%eax
  802452:	74 0f                	je     802463 <alloc_block_FF+0x141>
  802454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80245d:	8b 12                	mov    (%edx),%edx
  80245f:	89 10                	mov    %edx,(%eax)
  802461:	eb 0a                	jmp    80246d <alloc_block_FF+0x14b>
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	a3 48 51 80 00       	mov    %eax,0x805148
  80246d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802480:	a1 54 51 80 00       	mov    0x805154,%eax
  802485:	48                   	dec    %eax
  802486:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 50 08             	mov    0x8(%eax),%edx
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	01 c2                	add    %eax,%edx
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a2:	2b 45 08             	sub    0x8(%ebp),%eax
  8024a5:	89 c2                	mov    %eax,%edx
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b0:	eb 3b                	jmp    8024ed <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024b2:	a1 40 51 80 00       	mov    0x805140,%eax
  8024b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024be:	74 07                	je     8024c7 <alloc_block_FF+0x1a5>
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	eb 05                	jmp    8024cc <alloc_block_FF+0x1aa>
  8024c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cc:	a3 40 51 80 00       	mov    %eax,0x805140
  8024d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	0f 85 57 fe ff ff    	jne    802335 <alloc_block_FF+0x13>
  8024de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e2:	0f 85 4d fe ff ff    	jne    802335 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ed:	c9                   	leave  
  8024ee:	c3                   	ret    

008024ef <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024fc:	a1 38 51 80 00       	mov    0x805138,%eax
  802501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802504:	e9 df 00 00 00       	jmp    8025e8 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 40 0c             	mov    0xc(%eax),%eax
  80250f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802512:	0f 82 c8 00 00 00    	jb     8025e0 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 40 0c             	mov    0xc(%eax),%eax
  80251e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802521:	0f 85 8a 00 00 00    	jne    8025b1 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802527:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252b:	75 17                	jne    802544 <alloc_block_BF+0x55>
  80252d:	83 ec 04             	sub    $0x4,%esp
  802530:	68 04 41 80 00       	push   $0x804104
  802535:	68 b7 00 00 00       	push   $0xb7
  80253a:	68 5b 40 80 00       	push   $0x80405b
  80253f:	e8 d5 0e 00 00       	call   803419 <_panic>
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 00                	mov    (%eax),%eax
  802549:	85 c0                	test   %eax,%eax
  80254b:	74 10                	je     80255d <alloc_block_BF+0x6e>
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802555:	8b 52 04             	mov    0x4(%edx),%edx
  802558:	89 50 04             	mov    %edx,0x4(%eax)
  80255b:	eb 0b                	jmp    802568 <alloc_block_BF+0x79>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 40 04             	mov    0x4(%eax),%eax
  802563:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 40 04             	mov    0x4(%eax),%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	74 0f                	je     802581 <alloc_block_BF+0x92>
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257b:	8b 12                	mov    (%edx),%edx
  80257d:	89 10                	mov    %edx,(%eax)
  80257f:	eb 0a                	jmp    80258b <alloc_block_BF+0x9c>
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	a3 38 51 80 00       	mov    %eax,0x805138
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259e:	a1 44 51 80 00       	mov    0x805144,%eax
  8025a3:	48                   	dec    %eax
  8025a4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	e9 4d 01 00 00       	jmp    8026fe <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ba:	76 24                	jbe    8025e0 <alloc_block_BF+0xf1>
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c5:	73 19                	jae    8025e0 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025c7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 40 08             	mov    0x8(%eax),%eax
  8025dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025e0:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ec:	74 07                	je     8025f5 <alloc_block_BF+0x106>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	eb 05                	jmp    8025fa <alloc_block_BF+0x10b>
  8025f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fa:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ff:	a1 40 51 80 00       	mov    0x805140,%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	0f 85 fd fe ff ff    	jne    802509 <alloc_block_BF+0x1a>
  80260c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802610:	0f 85 f3 fe ff ff    	jne    802509 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802616:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80261a:	0f 84 d9 00 00 00    	je     8026f9 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802620:	a1 48 51 80 00       	mov    0x805148,%eax
  802625:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80262e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802634:	8b 55 08             	mov    0x8(%ebp),%edx
  802637:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80263a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80263e:	75 17                	jne    802657 <alloc_block_BF+0x168>
  802640:	83 ec 04             	sub    $0x4,%esp
  802643:	68 04 41 80 00       	push   $0x804104
  802648:	68 c7 00 00 00       	push   $0xc7
  80264d:	68 5b 40 80 00       	push   $0x80405b
  802652:	e8 c2 0d 00 00       	call   803419 <_panic>
  802657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265a:	8b 00                	mov    (%eax),%eax
  80265c:	85 c0                	test   %eax,%eax
  80265e:	74 10                	je     802670 <alloc_block_BF+0x181>
  802660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802663:	8b 00                	mov    (%eax),%eax
  802665:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802668:	8b 52 04             	mov    0x4(%edx),%edx
  80266b:	89 50 04             	mov    %edx,0x4(%eax)
  80266e:	eb 0b                	jmp    80267b <alloc_block_BF+0x18c>
  802670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802673:	8b 40 04             	mov    0x4(%eax),%eax
  802676:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80267b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267e:	8b 40 04             	mov    0x4(%eax),%eax
  802681:	85 c0                	test   %eax,%eax
  802683:	74 0f                	je     802694 <alloc_block_BF+0x1a5>
  802685:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802688:	8b 40 04             	mov    0x4(%eax),%eax
  80268b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80268e:	8b 12                	mov    (%edx),%edx
  802690:	89 10                	mov    %edx,(%eax)
  802692:	eb 0a                	jmp    80269e <alloc_block_BF+0x1af>
  802694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802697:	8b 00                	mov    (%eax),%eax
  802699:	a3 48 51 80 00       	mov    %eax,0x805148
  80269e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b1:	a1 54 51 80 00       	mov    0x805154,%eax
  8026b6:	48                   	dec    %eax
  8026b7:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026bc:	83 ec 08             	sub    $0x8,%esp
  8026bf:	ff 75 ec             	pushl  -0x14(%ebp)
  8026c2:	68 38 51 80 00       	push   $0x805138
  8026c7:	e8 71 f9 ff ff       	call   80203d <find_block>
  8026cc:	83 c4 10             	add    $0x10,%esp
  8026cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d5:	8b 50 08             	mov    0x8(%eax),%edx
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	01 c2                	add    %eax,%edx
  8026dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e0:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e9:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ec:	89 c2                	mov    %eax,%edx
  8026ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f1:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f7:	eb 05                	jmp    8026fe <alloc_block_BF+0x20f>
	}
	return NULL;
  8026f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026fe:	c9                   	leave  
  8026ff:	c3                   	ret    

00802700 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
  802703:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802706:	a1 28 50 80 00       	mov    0x805028,%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	0f 85 de 01 00 00    	jne    8028f1 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802713:	a1 38 51 80 00       	mov    0x805138,%eax
  802718:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271b:	e9 9e 01 00 00       	jmp    8028be <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 40 0c             	mov    0xc(%eax),%eax
  802726:	3b 45 08             	cmp    0x8(%ebp),%eax
  802729:	0f 82 87 01 00 00    	jb     8028b6 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 40 0c             	mov    0xc(%eax),%eax
  802735:	3b 45 08             	cmp    0x8(%ebp),%eax
  802738:	0f 85 95 00 00 00    	jne    8027d3 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80273e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802742:	75 17                	jne    80275b <alloc_block_NF+0x5b>
  802744:	83 ec 04             	sub    $0x4,%esp
  802747:	68 04 41 80 00       	push   $0x804104
  80274c:	68 e0 00 00 00       	push   $0xe0
  802751:	68 5b 40 80 00       	push   $0x80405b
  802756:	e8 be 0c 00 00       	call   803419 <_panic>
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 00                	mov    (%eax),%eax
  802760:	85 c0                	test   %eax,%eax
  802762:	74 10                	je     802774 <alloc_block_NF+0x74>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276c:	8b 52 04             	mov    0x4(%edx),%edx
  80276f:	89 50 04             	mov    %edx,0x4(%eax)
  802772:	eb 0b                	jmp    80277f <alloc_block_NF+0x7f>
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 40 04             	mov    0x4(%eax),%eax
  80277a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 40 04             	mov    0x4(%eax),%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	74 0f                	je     802798 <alloc_block_NF+0x98>
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 40 04             	mov    0x4(%eax),%eax
  80278f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802792:	8b 12                	mov    (%edx),%edx
  802794:	89 10                	mov    %edx,(%eax)
  802796:	eb 0a                	jmp    8027a2 <alloc_block_NF+0xa2>
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	a3 38 51 80 00       	mov    %eax,0x805138
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b5:	a1 44 51 80 00       	mov    0x805144,%eax
  8027ba:	48                   	dec    %eax
  8027bb:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 40 08             	mov    0x8(%eax),%eax
  8027c6:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	e9 f8 04 00 00       	jmp    802ccb <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027dc:	0f 86 d4 00 00 00    	jbe    8028b6 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8027e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 50 08             	mov    0x8(%eax),%edx
  8027f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f3:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fc:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802803:	75 17                	jne    80281c <alloc_block_NF+0x11c>
  802805:	83 ec 04             	sub    $0x4,%esp
  802808:	68 04 41 80 00       	push   $0x804104
  80280d:	68 e9 00 00 00       	push   $0xe9
  802812:	68 5b 40 80 00       	push   $0x80405b
  802817:	e8 fd 0b 00 00       	call   803419 <_panic>
  80281c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281f:	8b 00                	mov    (%eax),%eax
  802821:	85 c0                	test   %eax,%eax
  802823:	74 10                	je     802835 <alloc_block_NF+0x135>
  802825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802828:	8b 00                	mov    (%eax),%eax
  80282a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282d:	8b 52 04             	mov    0x4(%edx),%edx
  802830:	89 50 04             	mov    %edx,0x4(%eax)
  802833:	eb 0b                	jmp    802840 <alloc_block_NF+0x140>
  802835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802838:	8b 40 04             	mov    0x4(%eax),%eax
  80283b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802843:	8b 40 04             	mov    0x4(%eax),%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	74 0f                	je     802859 <alloc_block_NF+0x159>
  80284a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284d:	8b 40 04             	mov    0x4(%eax),%eax
  802850:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802853:	8b 12                	mov    (%edx),%edx
  802855:	89 10                	mov    %edx,(%eax)
  802857:	eb 0a                	jmp    802863 <alloc_block_NF+0x163>
  802859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285c:	8b 00                	mov    (%eax),%eax
  80285e:	a3 48 51 80 00       	mov    %eax,0x805148
  802863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802866:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802876:	a1 54 51 80 00       	mov    0x805154,%eax
  80287b:	48                   	dec    %eax
  80287c:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802884:	8b 40 08             	mov    0x8(%eax),%eax
  802887:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 50 08             	mov    0x8(%eax),%edx
  802892:	8b 45 08             	mov    0x8(%ebp),%eax
  802895:	01 c2                	add    %eax,%edx
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a3:	2b 45 08             	sub    0x8(%ebp),%eax
  8028a6:	89 c2                	mov    %eax,%edx
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	e9 15 04 00 00       	jmp    802ccb <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028b6:	a1 40 51 80 00       	mov    0x805140,%eax
  8028bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c2:	74 07                	je     8028cb <alloc_block_NF+0x1cb>
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 00                	mov    (%eax),%eax
  8028c9:	eb 05                	jmp    8028d0 <alloc_block_NF+0x1d0>
  8028cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d0:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d5:	a1 40 51 80 00       	mov    0x805140,%eax
  8028da:	85 c0                	test   %eax,%eax
  8028dc:	0f 85 3e fe ff ff    	jne    802720 <alloc_block_NF+0x20>
  8028e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e6:	0f 85 34 fe ff ff    	jne    802720 <alloc_block_NF+0x20>
  8028ec:	e9 d5 03 00 00       	jmp    802cc6 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028f1:	a1 38 51 80 00       	mov    0x805138,%eax
  8028f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f9:	e9 b1 01 00 00       	jmp    802aaf <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 50 08             	mov    0x8(%eax),%edx
  802904:	a1 28 50 80 00       	mov    0x805028,%eax
  802909:	39 c2                	cmp    %eax,%edx
  80290b:	0f 82 96 01 00 00    	jb     802aa7 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 40 0c             	mov    0xc(%eax),%eax
  802917:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291a:	0f 82 87 01 00 00    	jb     802aa7 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 40 0c             	mov    0xc(%eax),%eax
  802926:	3b 45 08             	cmp    0x8(%ebp),%eax
  802929:	0f 85 95 00 00 00    	jne    8029c4 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80292f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802933:	75 17                	jne    80294c <alloc_block_NF+0x24c>
  802935:	83 ec 04             	sub    $0x4,%esp
  802938:	68 04 41 80 00       	push   $0x804104
  80293d:	68 fc 00 00 00       	push   $0xfc
  802942:	68 5b 40 80 00       	push   $0x80405b
  802947:	e8 cd 0a 00 00       	call   803419 <_panic>
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	85 c0                	test   %eax,%eax
  802953:	74 10                	je     802965 <alloc_block_NF+0x265>
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295d:	8b 52 04             	mov    0x4(%edx),%edx
  802960:	89 50 04             	mov    %edx,0x4(%eax)
  802963:	eb 0b                	jmp    802970 <alloc_block_NF+0x270>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 04             	mov    0x4(%eax),%eax
  802976:	85 c0                	test   %eax,%eax
  802978:	74 0f                	je     802989 <alloc_block_NF+0x289>
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 40 04             	mov    0x4(%eax),%eax
  802980:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802983:	8b 12                	mov    (%edx),%edx
  802985:	89 10                	mov    %edx,(%eax)
  802987:	eb 0a                	jmp    802993 <alloc_block_NF+0x293>
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 00                	mov    (%eax),%eax
  80298e:	a3 38 51 80 00       	mov    %eax,0x805138
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8029ab:	48                   	dec    %eax
  8029ac:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 08             	mov    0x8(%eax),%eax
  8029b7:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	e9 07 03 00 00       	jmp    802ccb <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cd:	0f 86 d4 00 00 00    	jbe    802aa7 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 50 08             	mov    0x8(%eax),%edx
  8029e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ed:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029f4:	75 17                	jne    802a0d <alloc_block_NF+0x30d>
  8029f6:	83 ec 04             	sub    $0x4,%esp
  8029f9:	68 04 41 80 00       	push   $0x804104
  8029fe:	68 04 01 00 00       	push   $0x104
  802a03:	68 5b 40 80 00       	push   $0x80405b
  802a08:	e8 0c 0a 00 00       	call   803419 <_panic>
  802a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	85 c0                	test   %eax,%eax
  802a14:	74 10                	je     802a26 <alloc_block_NF+0x326>
  802a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a1e:	8b 52 04             	mov    0x4(%edx),%edx
  802a21:	89 50 04             	mov    %edx,0x4(%eax)
  802a24:	eb 0b                	jmp    802a31 <alloc_block_NF+0x331>
  802a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a34:	8b 40 04             	mov    0x4(%eax),%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	74 0f                	je     802a4a <alloc_block_NF+0x34a>
  802a3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3e:	8b 40 04             	mov    0x4(%eax),%eax
  802a41:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a44:	8b 12                	mov    (%edx),%edx
  802a46:	89 10                	mov    %edx,(%eax)
  802a48:	eb 0a                	jmp    802a54 <alloc_block_NF+0x354>
  802a4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	a3 48 51 80 00       	mov    %eax,0x805148
  802a54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a67:	a1 54 51 80 00       	mov    0x805154,%eax
  802a6c:	48                   	dec    %eax
  802a6d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a75:	8b 40 08             	mov    0x8(%eax),%eax
  802a78:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 50 08             	mov    0x8(%eax),%edx
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	01 c2                	add    %eax,%edx
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 0c             	mov    0xc(%eax),%eax
  802a94:	2b 45 08             	sub    0x8(%ebp),%eax
  802a97:	89 c2                	mov    %eax,%edx
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa2:	e9 24 02 00 00       	jmp    802ccb <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa7:	a1 40 51 80 00       	mov    0x805140,%eax
  802aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab3:	74 07                	je     802abc <alloc_block_NF+0x3bc>
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	eb 05                	jmp    802ac1 <alloc_block_NF+0x3c1>
  802abc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac1:	a3 40 51 80 00       	mov    %eax,0x805140
  802ac6:	a1 40 51 80 00       	mov    0x805140,%eax
  802acb:	85 c0                	test   %eax,%eax
  802acd:	0f 85 2b fe ff ff    	jne    8028fe <alloc_block_NF+0x1fe>
  802ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad7:	0f 85 21 fe ff ff    	jne    8028fe <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802add:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae5:	e9 ae 01 00 00       	jmp    802c98 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 50 08             	mov    0x8(%eax),%edx
  802af0:	a1 28 50 80 00       	mov    0x805028,%eax
  802af5:	39 c2                	cmp    %eax,%edx
  802af7:	0f 83 93 01 00 00    	jae    802c90 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 40 0c             	mov    0xc(%eax),%eax
  802b03:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b06:	0f 82 84 01 00 00    	jb     802c90 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b12:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b15:	0f 85 95 00 00 00    	jne    802bb0 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1f:	75 17                	jne    802b38 <alloc_block_NF+0x438>
  802b21:	83 ec 04             	sub    $0x4,%esp
  802b24:	68 04 41 80 00       	push   $0x804104
  802b29:	68 14 01 00 00       	push   $0x114
  802b2e:	68 5b 40 80 00       	push   $0x80405b
  802b33:	e8 e1 08 00 00       	call   803419 <_panic>
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 00                	mov    (%eax),%eax
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	74 10                	je     802b51 <alloc_block_NF+0x451>
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 00                	mov    (%eax),%eax
  802b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b49:	8b 52 04             	mov    0x4(%edx),%edx
  802b4c:	89 50 04             	mov    %edx,0x4(%eax)
  802b4f:	eb 0b                	jmp    802b5c <alloc_block_NF+0x45c>
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	8b 40 04             	mov    0x4(%eax),%eax
  802b57:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 40 04             	mov    0x4(%eax),%eax
  802b62:	85 c0                	test   %eax,%eax
  802b64:	74 0f                	je     802b75 <alloc_block_NF+0x475>
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 40 04             	mov    0x4(%eax),%eax
  802b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6f:	8b 12                	mov    (%edx),%edx
  802b71:	89 10                	mov    %edx,(%eax)
  802b73:	eb 0a                	jmp    802b7f <alloc_block_NF+0x47f>
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 00                	mov    (%eax),%eax
  802b7a:	a3 38 51 80 00       	mov    %eax,0x805138
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b92:	a1 44 51 80 00       	mov    0x805144,%eax
  802b97:	48                   	dec    %eax
  802b98:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 40 08             	mov    0x8(%eax),%eax
  802ba3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	e9 1b 01 00 00       	jmp    802ccb <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb9:	0f 86 d1 00 00 00    	jbe    802c90 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bbf:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 50 08             	mov    0x8(%eax),%edx
  802bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bdc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802be0:	75 17                	jne    802bf9 <alloc_block_NF+0x4f9>
  802be2:	83 ec 04             	sub    $0x4,%esp
  802be5:	68 04 41 80 00       	push   $0x804104
  802bea:	68 1c 01 00 00       	push   $0x11c
  802bef:	68 5b 40 80 00       	push   $0x80405b
  802bf4:	e8 20 08 00 00       	call   803419 <_panic>
  802bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	74 10                	je     802c12 <alloc_block_NF+0x512>
  802c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c05:	8b 00                	mov    (%eax),%eax
  802c07:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c0a:	8b 52 04             	mov    0x4(%edx),%edx
  802c0d:	89 50 04             	mov    %edx,0x4(%eax)
  802c10:	eb 0b                	jmp    802c1d <alloc_block_NF+0x51d>
  802c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c15:	8b 40 04             	mov    0x4(%eax),%eax
  802c18:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c20:	8b 40 04             	mov    0x4(%eax),%eax
  802c23:	85 c0                	test   %eax,%eax
  802c25:	74 0f                	je     802c36 <alloc_block_NF+0x536>
  802c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2a:	8b 40 04             	mov    0x4(%eax),%eax
  802c2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c30:	8b 12                	mov    (%edx),%edx
  802c32:	89 10                	mov    %edx,(%eax)
  802c34:	eb 0a                	jmp    802c40 <alloc_block_NF+0x540>
  802c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c39:	8b 00                	mov    (%eax),%eax
  802c3b:	a3 48 51 80 00       	mov    %eax,0x805148
  802c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c53:	a1 54 51 80 00       	mov    0x805154,%eax
  802c58:	48                   	dec    %eax
  802c59:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c61:	8b 40 08             	mov    0x8(%eax),%eax
  802c64:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 50 08             	mov    0x8(%eax),%edx
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	01 c2                	add    %eax,%edx
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c80:	2b 45 08             	sub    0x8(%ebp),%eax
  802c83:	89 c2                	mov    %eax,%edx
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8e:	eb 3b                	jmp    802ccb <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c90:	a1 40 51 80 00       	mov    0x805140,%eax
  802c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9c:	74 07                	je     802ca5 <alloc_block_NF+0x5a5>
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 00                	mov    (%eax),%eax
  802ca3:	eb 05                	jmp    802caa <alloc_block_NF+0x5aa>
  802ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  802caa:	a3 40 51 80 00       	mov    %eax,0x805140
  802caf:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb4:	85 c0                	test   %eax,%eax
  802cb6:	0f 85 2e fe ff ff    	jne    802aea <alloc_block_NF+0x3ea>
  802cbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc0:	0f 85 24 fe ff ff    	jne    802aea <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ccb:	c9                   	leave  
  802ccc:	c3                   	ret    

00802ccd <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ccd:	55                   	push   %ebp
  802cce:	89 e5                	mov    %esp,%ebp
  802cd0:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cd3:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cdb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ce0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ce3:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce8:	85 c0                	test   %eax,%eax
  802cea:	74 14                	je     802d00 <insert_sorted_with_merge_freeList+0x33>
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	8b 50 08             	mov    0x8(%eax),%edx
  802cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf5:	8b 40 08             	mov    0x8(%eax),%eax
  802cf8:	39 c2                	cmp    %eax,%edx
  802cfa:	0f 87 9b 01 00 00    	ja     802e9b <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d04:	75 17                	jne    802d1d <insert_sorted_with_merge_freeList+0x50>
  802d06:	83 ec 04             	sub    $0x4,%esp
  802d09:	68 38 40 80 00       	push   $0x804038
  802d0e:	68 38 01 00 00       	push   $0x138
  802d13:	68 5b 40 80 00       	push   $0x80405b
  802d18:	e8 fc 06 00 00       	call   803419 <_panic>
  802d1d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	89 10                	mov    %edx,(%eax)
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	74 0d                	je     802d3e <insert_sorted_with_merge_freeList+0x71>
  802d31:	a1 38 51 80 00       	mov    0x805138,%eax
  802d36:	8b 55 08             	mov    0x8(%ebp),%edx
  802d39:	89 50 04             	mov    %edx,0x4(%eax)
  802d3c:	eb 08                	jmp    802d46 <insert_sorted_with_merge_freeList+0x79>
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	a3 38 51 80 00       	mov    %eax,0x805138
  802d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d58:	a1 44 51 80 00       	mov    0x805144,%eax
  802d5d:	40                   	inc    %eax
  802d5e:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d67:	0f 84 a8 06 00 00    	je     803415 <insert_sorted_with_merge_freeList+0x748>
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	8b 50 08             	mov    0x8(%eax),%edx
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	8b 40 0c             	mov    0xc(%eax),%eax
  802d79:	01 c2                	add    %eax,%edx
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	8b 40 08             	mov    0x8(%eax),%eax
  802d81:	39 c2                	cmp    %eax,%edx
  802d83:	0f 85 8c 06 00 00    	jne    803415 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d92:	8b 40 0c             	mov    0xc(%eax),%eax
  802d95:	01 c2                	add    %eax,%edx
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da1:	75 17                	jne    802dba <insert_sorted_with_merge_freeList+0xed>
  802da3:	83 ec 04             	sub    $0x4,%esp
  802da6:	68 04 41 80 00       	push   $0x804104
  802dab:	68 3c 01 00 00       	push   $0x13c
  802db0:	68 5b 40 80 00       	push   $0x80405b
  802db5:	e8 5f 06 00 00       	call   803419 <_panic>
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	74 10                	je     802dd3 <insert_sorted_with_merge_freeList+0x106>
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dcb:	8b 52 04             	mov    0x4(%edx),%edx
  802dce:	89 50 04             	mov    %edx,0x4(%eax)
  802dd1:	eb 0b                	jmp    802dde <insert_sorted_with_merge_freeList+0x111>
  802dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd6:	8b 40 04             	mov    0x4(%eax),%eax
  802dd9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	8b 40 04             	mov    0x4(%eax),%eax
  802de4:	85 c0                	test   %eax,%eax
  802de6:	74 0f                	je     802df7 <insert_sorted_with_merge_freeList+0x12a>
  802de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802deb:	8b 40 04             	mov    0x4(%eax),%eax
  802dee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df1:	8b 12                	mov    (%edx),%edx
  802df3:	89 10                	mov    %edx,(%eax)
  802df5:	eb 0a                	jmp    802e01 <insert_sorted_with_merge_freeList+0x134>
  802df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfa:	8b 00                	mov    (%eax),%eax
  802dfc:	a3 38 51 80 00       	mov    %eax,0x805138
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e14:	a1 44 51 80 00       	mov    0x805144,%eax
  802e19:	48                   	dec    %eax
  802e1a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e22:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e37:	75 17                	jne    802e50 <insert_sorted_with_merge_freeList+0x183>
  802e39:	83 ec 04             	sub    $0x4,%esp
  802e3c:	68 38 40 80 00       	push   $0x804038
  802e41:	68 3f 01 00 00       	push   $0x13f
  802e46:	68 5b 40 80 00       	push   $0x80405b
  802e4b:	e8 c9 05 00 00       	call   803419 <_panic>
  802e50:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e59:	89 10                	mov    %edx,(%eax)
  802e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5e:	8b 00                	mov    (%eax),%eax
  802e60:	85 c0                	test   %eax,%eax
  802e62:	74 0d                	je     802e71 <insert_sorted_with_merge_freeList+0x1a4>
  802e64:	a1 48 51 80 00       	mov    0x805148,%eax
  802e69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e6c:	89 50 04             	mov    %edx,0x4(%eax)
  802e6f:	eb 08                	jmp    802e79 <insert_sorted_with_merge_freeList+0x1ac>
  802e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e74:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7c:	a3 48 51 80 00       	mov    %eax,0x805148
  802e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8b:	a1 54 51 80 00       	mov    0x805154,%eax
  802e90:	40                   	inc    %eax
  802e91:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e96:	e9 7a 05 00 00       	jmp    803415 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea4:	8b 40 08             	mov    0x8(%eax),%eax
  802ea7:	39 c2                	cmp    %eax,%edx
  802ea9:	0f 82 14 01 00 00    	jb     802fc3 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb2:	8b 50 08             	mov    0x8(%eax),%edx
  802eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebb:	01 c2                	add    %eax,%edx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 40 08             	mov    0x8(%eax),%eax
  802ec3:	39 c2                	cmp    %eax,%edx
  802ec5:	0f 85 90 00 00 00    	jne    802f5b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ece:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed7:	01 c2                	add    %eax,%edx
  802ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edc:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ef3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef7:	75 17                	jne    802f10 <insert_sorted_with_merge_freeList+0x243>
  802ef9:	83 ec 04             	sub    $0x4,%esp
  802efc:	68 38 40 80 00       	push   $0x804038
  802f01:	68 49 01 00 00       	push   $0x149
  802f06:	68 5b 40 80 00       	push   $0x80405b
  802f0b:	e8 09 05 00 00       	call   803419 <_panic>
  802f10:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	89 10                	mov    %edx,(%eax)
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	85 c0                	test   %eax,%eax
  802f22:	74 0d                	je     802f31 <insert_sorted_with_merge_freeList+0x264>
  802f24:	a1 48 51 80 00       	mov    0x805148,%eax
  802f29:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2c:	89 50 04             	mov    %edx,0x4(%eax)
  802f2f:	eb 08                	jmp    802f39 <insert_sorted_with_merge_freeList+0x26c>
  802f31:	8b 45 08             	mov    0x8(%ebp),%eax
  802f34:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	a3 48 51 80 00       	mov    %eax,0x805148
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4b:	a1 54 51 80 00       	mov    0x805154,%eax
  802f50:	40                   	inc    %eax
  802f51:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f56:	e9 bb 04 00 00       	jmp    803416 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5f:	75 17                	jne    802f78 <insert_sorted_with_merge_freeList+0x2ab>
  802f61:	83 ec 04             	sub    $0x4,%esp
  802f64:	68 ac 40 80 00       	push   $0x8040ac
  802f69:	68 4c 01 00 00       	push   $0x14c
  802f6e:	68 5b 40 80 00       	push   $0x80405b
  802f73:	e8 a1 04 00 00       	call   803419 <_panic>
  802f78:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	89 50 04             	mov    %edx,0x4(%eax)
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	8b 40 04             	mov    0x4(%eax),%eax
  802f8a:	85 c0                	test   %eax,%eax
  802f8c:	74 0c                	je     802f9a <insert_sorted_with_merge_freeList+0x2cd>
  802f8e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f93:	8b 55 08             	mov    0x8(%ebp),%edx
  802f96:	89 10                	mov    %edx,(%eax)
  802f98:	eb 08                	jmp    802fa2 <insert_sorted_with_merge_freeList+0x2d5>
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	a3 38 51 80 00       	mov    %eax,0x805138
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb3:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb8:	40                   	inc    %eax
  802fb9:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fbe:	e9 53 04 00 00       	jmp    803416 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fc3:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcb:	e9 15 04 00 00       	jmp    8033e5 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd3:	8b 00                	mov    (%eax),%eax
  802fd5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	8b 50 08             	mov    0x8(%eax),%edx
  802fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe1:	8b 40 08             	mov    0x8(%eax),%eax
  802fe4:	39 c2                	cmp    %eax,%edx
  802fe6:	0f 86 f1 03 00 00    	jbe    8033dd <insert_sorted_with_merge_freeList+0x710>
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 50 08             	mov    0x8(%eax),%edx
  802ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff5:	8b 40 08             	mov    0x8(%eax),%eax
  802ff8:	39 c2                	cmp    %eax,%edx
  802ffa:	0f 83 dd 03 00 00    	jae    8033dd <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	8b 50 08             	mov    0x8(%eax),%edx
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 40 0c             	mov    0xc(%eax),%eax
  80300c:	01 c2                	add    %eax,%edx
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	8b 40 08             	mov    0x8(%eax),%eax
  803014:	39 c2                	cmp    %eax,%edx
  803016:	0f 85 b9 01 00 00    	jne    8031d5 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	8b 50 08             	mov    0x8(%eax),%edx
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	8b 40 0c             	mov    0xc(%eax),%eax
  803028:	01 c2                	add    %eax,%edx
  80302a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302d:	8b 40 08             	mov    0x8(%eax),%eax
  803030:	39 c2                	cmp    %eax,%edx
  803032:	0f 85 0d 01 00 00    	jne    803145 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 50 0c             	mov    0xc(%eax),%edx
  80303e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803041:	8b 40 0c             	mov    0xc(%eax),%eax
  803044:	01 c2                	add    %eax,%edx
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80304c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803050:	75 17                	jne    803069 <insert_sorted_with_merge_freeList+0x39c>
  803052:	83 ec 04             	sub    $0x4,%esp
  803055:	68 04 41 80 00       	push   $0x804104
  80305a:	68 5c 01 00 00       	push   $0x15c
  80305f:	68 5b 40 80 00       	push   $0x80405b
  803064:	e8 b0 03 00 00       	call   803419 <_panic>
  803069:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306c:	8b 00                	mov    (%eax),%eax
  80306e:	85 c0                	test   %eax,%eax
  803070:	74 10                	je     803082 <insert_sorted_with_merge_freeList+0x3b5>
  803072:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803075:	8b 00                	mov    (%eax),%eax
  803077:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80307a:	8b 52 04             	mov    0x4(%edx),%edx
  80307d:	89 50 04             	mov    %edx,0x4(%eax)
  803080:	eb 0b                	jmp    80308d <insert_sorted_with_merge_freeList+0x3c0>
  803082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803085:	8b 40 04             	mov    0x4(%eax),%eax
  803088:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80308d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803090:	8b 40 04             	mov    0x4(%eax),%eax
  803093:	85 c0                	test   %eax,%eax
  803095:	74 0f                	je     8030a6 <insert_sorted_with_merge_freeList+0x3d9>
  803097:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309a:	8b 40 04             	mov    0x4(%eax),%eax
  80309d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a0:	8b 12                	mov    (%edx),%edx
  8030a2:	89 10                	mov    %edx,(%eax)
  8030a4:	eb 0a                	jmp    8030b0 <insert_sorted_with_merge_freeList+0x3e3>
  8030a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a9:	8b 00                	mov    (%eax),%eax
  8030ab:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c8:	48                   	dec    %eax
  8030c9:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e6:	75 17                	jne    8030ff <insert_sorted_with_merge_freeList+0x432>
  8030e8:	83 ec 04             	sub    $0x4,%esp
  8030eb:	68 38 40 80 00       	push   $0x804038
  8030f0:	68 5f 01 00 00       	push   $0x15f
  8030f5:	68 5b 40 80 00       	push   $0x80405b
  8030fa:	e8 1a 03 00 00       	call   803419 <_panic>
  8030ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803108:	89 10                	mov    %edx,(%eax)
  80310a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310d:	8b 00                	mov    (%eax),%eax
  80310f:	85 c0                	test   %eax,%eax
  803111:	74 0d                	je     803120 <insert_sorted_with_merge_freeList+0x453>
  803113:	a1 48 51 80 00       	mov    0x805148,%eax
  803118:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80311b:	89 50 04             	mov    %edx,0x4(%eax)
  80311e:	eb 08                	jmp    803128 <insert_sorted_with_merge_freeList+0x45b>
  803120:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803123:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803128:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312b:	a3 48 51 80 00       	mov    %eax,0x805148
  803130:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803133:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313a:	a1 54 51 80 00       	mov    0x805154,%eax
  80313f:	40                   	inc    %eax
  803140:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	8b 50 0c             	mov    0xc(%eax),%edx
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	8b 40 0c             	mov    0xc(%eax),%eax
  803151:	01 c2                	add    %eax,%edx
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80316d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803171:	75 17                	jne    80318a <insert_sorted_with_merge_freeList+0x4bd>
  803173:	83 ec 04             	sub    $0x4,%esp
  803176:	68 38 40 80 00       	push   $0x804038
  80317b:	68 64 01 00 00       	push   $0x164
  803180:	68 5b 40 80 00       	push   $0x80405b
  803185:	e8 8f 02 00 00       	call   803419 <_panic>
  80318a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	89 10                	mov    %edx,(%eax)
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	85 c0                	test   %eax,%eax
  80319c:	74 0d                	je     8031ab <insert_sorted_with_merge_freeList+0x4de>
  80319e:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a6:	89 50 04             	mov    %edx,0x4(%eax)
  8031a9:	eb 08                	jmp    8031b3 <insert_sorted_with_merge_freeList+0x4e6>
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ca:	40                   	inc    %eax
  8031cb:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031d0:	e9 41 02 00 00       	jmp    803416 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	8b 50 08             	mov    0x8(%eax),%edx
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e1:	01 c2                	add    %eax,%edx
  8031e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e6:	8b 40 08             	mov    0x8(%eax),%eax
  8031e9:	39 c2                	cmp    %eax,%edx
  8031eb:	0f 85 7c 01 00 00    	jne    80336d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f5:	74 06                	je     8031fd <insert_sorted_with_merge_freeList+0x530>
  8031f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031fb:	75 17                	jne    803214 <insert_sorted_with_merge_freeList+0x547>
  8031fd:	83 ec 04             	sub    $0x4,%esp
  803200:	68 74 40 80 00       	push   $0x804074
  803205:	68 69 01 00 00       	push   $0x169
  80320a:	68 5b 40 80 00       	push   $0x80405b
  80320f:	e8 05 02 00 00       	call   803419 <_panic>
  803214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803217:	8b 50 04             	mov    0x4(%eax),%edx
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	89 50 04             	mov    %edx,0x4(%eax)
  803220:	8b 45 08             	mov    0x8(%ebp),%eax
  803223:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803226:	89 10                	mov    %edx,(%eax)
  803228:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322b:	8b 40 04             	mov    0x4(%eax),%eax
  80322e:	85 c0                	test   %eax,%eax
  803230:	74 0d                	je     80323f <insert_sorted_with_merge_freeList+0x572>
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	8b 40 04             	mov    0x4(%eax),%eax
  803238:	8b 55 08             	mov    0x8(%ebp),%edx
  80323b:	89 10                	mov    %edx,(%eax)
  80323d:	eb 08                	jmp    803247 <insert_sorted_with_merge_freeList+0x57a>
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	a3 38 51 80 00       	mov    %eax,0x805138
  803247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324a:	8b 55 08             	mov    0x8(%ebp),%edx
  80324d:	89 50 04             	mov    %edx,0x4(%eax)
  803250:	a1 44 51 80 00       	mov    0x805144,%eax
  803255:	40                   	inc    %eax
  803256:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	8b 50 0c             	mov    0xc(%eax),%edx
  803261:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803264:	8b 40 0c             	mov    0xc(%eax),%eax
  803267:	01 c2                	add    %eax,%edx
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80326f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803273:	75 17                	jne    80328c <insert_sorted_with_merge_freeList+0x5bf>
  803275:	83 ec 04             	sub    $0x4,%esp
  803278:	68 04 41 80 00       	push   $0x804104
  80327d:	68 6b 01 00 00       	push   $0x16b
  803282:	68 5b 40 80 00       	push   $0x80405b
  803287:	e8 8d 01 00 00       	call   803419 <_panic>
  80328c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328f:	8b 00                	mov    (%eax),%eax
  803291:	85 c0                	test   %eax,%eax
  803293:	74 10                	je     8032a5 <insert_sorted_with_merge_freeList+0x5d8>
  803295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803298:	8b 00                	mov    (%eax),%eax
  80329a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329d:	8b 52 04             	mov    0x4(%edx),%edx
  8032a0:	89 50 04             	mov    %edx,0x4(%eax)
  8032a3:	eb 0b                	jmp    8032b0 <insert_sorted_with_merge_freeList+0x5e3>
  8032a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a8:	8b 40 04             	mov    0x4(%eax),%eax
  8032ab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b3:	8b 40 04             	mov    0x4(%eax),%eax
  8032b6:	85 c0                	test   %eax,%eax
  8032b8:	74 0f                	je     8032c9 <insert_sorted_with_merge_freeList+0x5fc>
  8032ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bd:	8b 40 04             	mov    0x4(%eax),%eax
  8032c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c3:	8b 12                	mov    (%edx),%edx
  8032c5:	89 10                	mov    %edx,(%eax)
  8032c7:	eb 0a                	jmp    8032d3 <insert_sorted_with_merge_freeList+0x606>
  8032c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cc:	8b 00                	mov    (%eax),%eax
  8032ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e6:	a1 44 51 80 00       	mov    0x805144,%eax
  8032eb:	48                   	dec    %eax
  8032ec:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803305:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803309:	75 17                	jne    803322 <insert_sorted_with_merge_freeList+0x655>
  80330b:	83 ec 04             	sub    $0x4,%esp
  80330e:	68 38 40 80 00       	push   $0x804038
  803313:	68 6e 01 00 00       	push   $0x16e
  803318:	68 5b 40 80 00       	push   $0x80405b
  80331d:	e8 f7 00 00 00       	call   803419 <_panic>
  803322:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803328:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332b:	89 10                	mov    %edx,(%eax)
  80332d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	85 c0                	test   %eax,%eax
  803334:	74 0d                	je     803343 <insert_sorted_with_merge_freeList+0x676>
  803336:	a1 48 51 80 00       	mov    0x805148,%eax
  80333b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333e:	89 50 04             	mov    %edx,0x4(%eax)
  803341:	eb 08                	jmp    80334b <insert_sorted_with_merge_freeList+0x67e>
  803343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803346:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334e:	a3 48 51 80 00       	mov    %eax,0x805148
  803353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803356:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335d:	a1 54 51 80 00       	mov    0x805154,%eax
  803362:	40                   	inc    %eax
  803363:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803368:	e9 a9 00 00 00       	jmp    803416 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80336d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803371:	74 06                	je     803379 <insert_sorted_with_merge_freeList+0x6ac>
  803373:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803377:	75 17                	jne    803390 <insert_sorted_with_merge_freeList+0x6c3>
  803379:	83 ec 04             	sub    $0x4,%esp
  80337c:	68 d0 40 80 00       	push   $0x8040d0
  803381:	68 73 01 00 00       	push   $0x173
  803386:	68 5b 40 80 00       	push   $0x80405b
  80338b:	e8 89 00 00 00       	call   803419 <_panic>
  803390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803393:	8b 10                	mov    (%eax),%edx
  803395:	8b 45 08             	mov    0x8(%ebp),%eax
  803398:	89 10                	mov    %edx,(%eax)
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	8b 00                	mov    (%eax),%eax
  80339f:	85 c0                	test   %eax,%eax
  8033a1:	74 0b                	je     8033ae <insert_sorted_with_merge_freeList+0x6e1>
  8033a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a6:	8b 00                	mov    (%eax),%eax
  8033a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ab:	89 50 04             	mov    %edx,0x4(%eax)
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b4:	89 10                	mov    %edx,(%eax)
  8033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033bc:	89 50 04             	mov    %edx,0x4(%eax)
  8033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c2:	8b 00                	mov    (%eax),%eax
  8033c4:	85 c0                	test   %eax,%eax
  8033c6:	75 08                	jne    8033d0 <insert_sorted_with_merge_freeList+0x703>
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d5:	40                   	inc    %eax
  8033d6:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033db:	eb 39                	jmp    803416 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8033e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e9:	74 07                	je     8033f2 <insert_sorted_with_merge_freeList+0x725>
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	8b 00                	mov    (%eax),%eax
  8033f0:	eb 05                	jmp    8033f7 <insert_sorted_with_merge_freeList+0x72a>
  8033f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f7:	a3 40 51 80 00       	mov    %eax,0x805140
  8033fc:	a1 40 51 80 00       	mov    0x805140,%eax
  803401:	85 c0                	test   %eax,%eax
  803403:	0f 85 c7 fb ff ff    	jne    802fd0 <insert_sorted_with_merge_freeList+0x303>
  803409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340d:	0f 85 bd fb ff ff    	jne    802fd0 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803413:	eb 01                	jmp    803416 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803415:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803416:	90                   	nop
  803417:	c9                   	leave  
  803418:	c3                   	ret    

00803419 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803419:	55                   	push   %ebp
  80341a:	89 e5                	mov    %esp,%ebp
  80341c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80341f:	8d 45 10             	lea    0x10(%ebp),%eax
  803422:	83 c0 04             	add    $0x4,%eax
  803425:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803428:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80342d:	85 c0                	test   %eax,%eax
  80342f:	74 16                	je     803447 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803431:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803436:	83 ec 08             	sub    $0x8,%esp
  803439:	50                   	push   %eax
  80343a:	68 24 41 80 00       	push   $0x804124
  80343f:	e8 de d1 ff ff       	call   800622 <cprintf>
  803444:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803447:	a1 00 50 80 00       	mov    0x805000,%eax
  80344c:	ff 75 0c             	pushl  0xc(%ebp)
  80344f:	ff 75 08             	pushl  0x8(%ebp)
  803452:	50                   	push   %eax
  803453:	68 29 41 80 00       	push   $0x804129
  803458:	e8 c5 d1 ff ff       	call   800622 <cprintf>
  80345d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803460:	8b 45 10             	mov    0x10(%ebp),%eax
  803463:	83 ec 08             	sub    $0x8,%esp
  803466:	ff 75 f4             	pushl  -0xc(%ebp)
  803469:	50                   	push   %eax
  80346a:	e8 48 d1 ff ff       	call   8005b7 <vcprintf>
  80346f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803472:	83 ec 08             	sub    $0x8,%esp
  803475:	6a 00                	push   $0x0
  803477:	68 45 41 80 00       	push   $0x804145
  80347c:	e8 36 d1 ff ff       	call   8005b7 <vcprintf>
  803481:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803484:	e8 b7 d0 ff ff       	call   800540 <exit>

	// should not return here
	while (1) ;
  803489:	eb fe                	jmp    803489 <_panic+0x70>

0080348b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80348b:	55                   	push   %ebp
  80348c:	89 e5                	mov    %esp,%ebp
  80348e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803491:	a1 20 50 80 00       	mov    0x805020,%eax
  803496:	8b 50 74             	mov    0x74(%eax),%edx
  803499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349c:	39 c2                	cmp    %eax,%edx
  80349e:	74 14                	je     8034b4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8034a0:	83 ec 04             	sub    $0x4,%esp
  8034a3:	68 48 41 80 00       	push   $0x804148
  8034a8:	6a 26                	push   $0x26
  8034aa:	68 94 41 80 00       	push   $0x804194
  8034af:	e8 65 ff ff ff       	call   803419 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8034b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8034bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8034c2:	e9 c2 00 00 00       	jmp    803589 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8034c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	01 d0                	add    %edx,%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	85 c0                	test   %eax,%eax
  8034da:	75 08                	jne    8034e4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8034dc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8034df:	e9 a2 00 00 00       	jmp    803586 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8034e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034eb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8034f2:	eb 69                	jmp    80355d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8034f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8034f9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8034ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803502:	89 d0                	mov    %edx,%eax
  803504:	01 c0                	add    %eax,%eax
  803506:	01 d0                	add    %edx,%eax
  803508:	c1 e0 03             	shl    $0x3,%eax
  80350b:	01 c8                	add    %ecx,%eax
  80350d:	8a 40 04             	mov    0x4(%eax),%al
  803510:	84 c0                	test   %al,%al
  803512:	75 46                	jne    80355a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803514:	a1 20 50 80 00       	mov    0x805020,%eax
  803519:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80351f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803522:	89 d0                	mov    %edx,%eax
  803524:	01 c0                	add    %eax,%eax
  803526:	01 d0                	add    %edx,%eax
  803528:	c1 e0 03             	shl    $0x3,%eax
  80352b:	01 c8                	add    %ecx,%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803532:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803535:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80353a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80353c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	01 c8                	add    %ecx,%eax
  80354b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80354d:	39 c2                	cmp    %eax,%edx
  80354f:	75 09                	jne    80355a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803551:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803558:	eb 12                	jmp    80356c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80355a:	ff 45 e8             	incl   -0x18(%ebp)
  80355d:	a1 20 50 80 00       	mov    0x805020,%eax
  803562:	8b 50 74             	mov    0x74(%eax),%edx
  803565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803568:	39 c2                	cmp    %eax,%edx
  80356a:	77 88                	ja     8034f4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80356c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803570:	75 14                	jne    803586 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803572:	83 ec 04             	sub    $0x4,%esp
  803575:	68 a0 41 80 00       	push   $0x8041a0
  80357a:	6a 3a                	push   $0x3a
  80357c:	68 94 41 80 00       	push   $0x804194
  803581:	e8 93 fe ff ff       	call   803419 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803586:	ff 45 f0             	incl   -0x10(%ebp)
  803589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80358c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80358f:	0f 8c 32 ff ff ff    	jl     8034c7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803595:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80359c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8035a3:	eb 26                	jmp    8035cb <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8035a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8035aa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8035b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035b3:	89 d0                	mov    %edx,%eax
  8035b5:	01 c0                	add    %eax,%eax
  8035b7:	01 d0                	add    %edx,%eax
  8035b9:	c1 e0 03             	shl    $0x3,%eax
  8035bc:	01 c8                	add    %ecx,%eax
  8035be:	8a 40 04             	mov    0x4(%eax),%al
  8035c1:	3c 01                	cmp    $0x1,%al
  8035c3:	75 03                	jne    8035c8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8035c5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035c8:	ff 45 e0             	incl   -0x20(%ebp)
  8035cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8035d0:	8b 50 74             	mov    0x74(%eax),%edx
  8035d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035d6:	39 c2                	cmp    %eax,%edx
  8035d8:	77 cb                	ja     8035a5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8035e0:	74 14                	je     8035f6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8035e2:	83 ec 04             	sub    $0x4,%esp
  8035e5:	68 f4 41 80 00       	push   $0x8041f4
  8035ea:	6a 44                	push   $0x44
  8035ec:	68 94 41 80 00       	push   $0x804194
  8035f1:	e8 23 fe ff ff       	call   803419 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8035f6:	90                   	nop
  8035f7:	c9                   	leave  
  8035f8:	c3                   	ret    
  8035f9:	66 90                	xchg   %ax,%ax
  8035fb:	90                   	nop

008035fc <__udivdi3>:
  8035fc:	55                   	push   %ebp
  8035fd:	57                   	push   %edi
  8035fe:	56                   	push   %esi
  8035ff:	53                   	push   %ebx
  803600:	83 ec 1c             	sub    $0x1c,%esp
  803603:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803607:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80360b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80360f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803613:	89 ca                	mov    %ecx,%edx
  803615:	89 f8                	mov    %edi,%eax
  803617:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80361b:	85 f6                	test   %esi,%esi
  80361d:	75 2d                	jne    80364c <__udivdi3+0x50>
  80361f:	39 cf                	cmp    %ecx,%edi
  803621:	77 65                	ja     803688 <__udivdi3+0x8c>
  803623:	89 fd                	mov    %edi,%ebp
  803625:	85 ff                	test   %edi,%edi
  803627:	75 0b                	jne    803634 <__udivdi3+0x38>
  803629:	b8 01 00 00 00       	mov    $0x1,%eax
  80362e:	31 d2                	xor    %edx,%edx
  803630:	f7 f7                	div    %edi
  803632:	89 c5                	mov    %eax,%ebp
  803634:	31 d2                	xor    %edx,%edx
  803636:	89 c8                	mov    %ecx,%eax
  803638:	f7 f5                	div    %ebp
  80363a:	89 c1                	mov    %eax,%ecx
  80363c:	89 d8                	mov    %ebx,%eax
  80363e:	f7 f5                	div    %ebp
  803640:	89 cf                	mov    %ecx,%edi
  803642:	89 fa                	mov    %edi,%edx
  803644:	83 c4 1c             	add    $0x1c,%esp
  803647:	5b                   	pop    %ebx
  803648:	5e                   	pop    %esi
  803649:	5f                   	pop    %edi
  80364a:	5d                   	pop    %ebp
  80364b:	c3                   	ret    
  80364c:	39 ce                	cmp    %ecx,%esi
  80364e:	77 28                	ja     803678 <__udivdi3+0x7c>
  803650:	0f bd fe             	bsr    %esi,%edi
  803653:	83 f7 1f             	xor    $0x1f,%edi
  803656:	75 40                	jne    803698 <__udivdi3+0x9c>
  803658:	39 ce                	cmp    %ecx,%esi
  80365a:	72 0a                	jb     803666 <__udivdi3+0x6a>
  80365c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803660:	0f 87 9e 00 00 00    	ja     803704 <__udivdi3+0x108>
  803666:	b8 01 00 00 00       	mov    $0x1,%eax
  80366b:	89 fa                	mov    %edi,%edx
  80366d:	83 c4 1c             	add    $0x1c,%esp
  803670:	5b                   	pop    %ebx
  803671:	5e                   	pop    %esi
  803672:	5f                   	pop    %edi
  803673:	5d                   	pop    %ebp
  803674:	c3                   	ret    
  803675:	8d 76 00             	lea    0x0(%esi),%esi
  803678:	31 ff                	xor    %edi,%edi
  80367a:	31 c0                	xor    %eax,%eax
  80367c:	89 fa                	mov    %edi,%edx
  80367e:	83 c4 1c             	add    $0x1c,%esp
  803681:	5b                   	pop    %ebx
  803682:	5e                   	pop    %esi
  803683:	5f                   	pop    %edi
  803684:	5d                   	pop    %ebp
  803685:	c3                   	ret    
  803686:	66 90                	xchg   %ax,%ax
  803688:	89 d8                	mov    %ebx,%eax
  80368a:	f7 f7                	div    %edi
  80368c:	31 ff                	xor    %edi,%edi
  80368e:	89 fa                	mov    %edi,%edx
  803690:	83 c4 1c             	add    $0x1c,%esp
  803693:	5b                   	pop    %ebx
  803694:	5e                   	pop    %esi
  803695:	5f                   	pop    %edi
  803696:	5d                   	pop    %ebp
  803697:	c3                   	ret    
  803698:	bd 20 00 00 00       	mov    $0x20,%ebp
  80369d:	89 eb                	mov    %ebp,%ebx
  80369f:	29 fb                	sub    %edi,%ebx
  8036a1:	89 f9                	mov    %edi,%ecx
  8036a3:	d3 e6                	shl    %cl,%esi
  8036a5:	89 c5                	mov    %eax,%ebp
  8036a7:	88 d9                	mov    %bl,%cl
  8036a9:	d3 ed                	shr    %cl,%ebp
  8036ab:	89 e9                	mov    %ebp,%ecx
  8036ad:	09 f1                	or     %esi,%ecx
  8036af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036b3:	89 f9                	mov    %edi,%ecx
  8036b5:	d3 e0                	shl    %cl,%eax
  8036b7:	89 c5                	mov    %eax,%ebp
  8036b9:	89 d6                	mov    %edx,%esi
  8036bb:	88 d9                	mov    %bl,%cl
  8036bd:	d3 ee                	shr    %cl,%esi
  8036bf:	89 f9                	mov    %edi,%ecx
  8036c1:	d3 e2                	shl    %cl,%edx
  8036c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036c7:	88 d9                	mov    %bl,%cl
  8036c9:	d3 e8                	shr    %cl,%eax
  8036cb:	09 c2                	or     %eax,%edx
  8036cd:	89 d0                	mov    %edx,%eax
  8036cf:	89 f2                	mov    %esi,%edx
  8036d1:	f7 74 24 0c          	divl   0xc(%esp)
  8036d5:	89 d6                	mov    %edx,%esi
  8036d7:	89 c3                	mov    %eax,%ebx
  8036d9:	f7 e5                	mul    %ebp
  8036db:	39 d6                	cmp    %edx,%esi
  8036dd:	72 19                	jb     8036f8 <__udivdi3+0xfc>
  8036df:	74 0b                	je     8036ec <__udivdi3+0xf0>
  8036e1:	89 d8                	mov    %ebx,%eax
  8036e3:	31 ff                	xor    %edi,%edi
  8036e5:	e9 58 ff ff ff       	jmp    803642 <__udivdi3+0x46>
  8036ea:	66 90                	xchg   %ax,%ax
  8036ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036f0:	89 f9                	mov    %edi,%ecx
  8036f2:	d3 e2                	shl    %cl,%edx
  8036f4:	39 c2                	cmp    %eax,%edx
  8036f6:	73 e9                	jae    8036e1 <__udivdi3+0xe5>
  8036f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036fb:	31 ff                	xor    %edi,%edi
  8036fd:	e9 40 ff ff ff       	jmp    803642 <__udivdi3+0x46>
  803702:	66 90                	xchg   %ax,%ax
  803704:	31 c0                	xor    %eax,%eax
  803706:	e9 37 ff ff ff       	jmp    803642 <__udivdi3+0x46>
  80370b:	90                   	nop

0080370c <__umoddi3>:
  80370c:	55                   	push   %ebp
  80370d:	57                   	push   %edi
  80370e:	56                   	push   %esi
  80370f:	53                   	push   %ebx
  803710:	83 ec 1c             	sub    $0x1c,%esp
  803713:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803717:	8b 74 24 34          	mov    0x34(%esp),%esi
  80371b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80371f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803723:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803727:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80372b:	89 f3                	mov    %esi,%ebx
  80372d:	89 fa                	mov    %edi,%edx
  80372f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803733:	89 34 24             	mov    %esi,(%esp)
  803736:	85 c0                	test   %eax,%eax
  803738:	75 1a                	jne    803754 <__umoddi3+0x48>
  80373a:	39 f7                	cmp    %esi,%edi
  80373c:	0f 86 a2 00 00 00    	jbe    8037e4 <__umoddi3+0xd8>
  803742:	89 c8                	mov    %ecx,%eax
  803744:	89 f2                	mov    %esi,%edx
  803746:	f7 f7                	div    %edi
  803748:	89 d0                	mov    %edx,%eax
  80374a:	31 d2                	xor    %edx,%edx
  80374c:	83 c4 1c             	add    $0x1c,%esp
  80374f:	5b                   	pop    %ebx
  803750:	5e                   	pop    %esi
  803751:	5f                   	pop    %edi
  803752:	5d                   	pop    %ebp
  803753:	c3                   	ret    
  803754:	39 f0                	cmp    %esi,%eax
  803756:	0f 87 ac 00 00 00    	ja     803808 <__umoddi3+0xfc>
  80375c:	0f bd e8             	bsr    %eax,%ebp
  80375f:	83 f5 1f             	xor    $0x1f,%ebp
  803762:	0f 84 ac 00 00 00    	je     803814 <__umoddi3+0x108>
  803768:	bf 20 00 00 00       	mov    $0x20,%edi
  80376d:	29 ef                	sub    %ebp,%edi
  80376f:	89 fe                	mov    %edi,%esi
  803771:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803775:	89 e9                	mov    %ebp,%ecx
  803777:	d3 e0                	shl    %cl,%eax
  803779:	89 d7                	mov    %edx,%edi
  80377b:	89 f1                	mov    %esi,%ecx
  80377d:	d3 ef                	shr    %cl,%edi
  80377f:	09 c7                	or     %eax,%edi
  803781:	89 e9                	mov    %ebp,%ecx
  803783:	d3 e2                	shl    %cl,%edx
  803785:	89 14 24             	mov    %edx,(%esp)
  803788:	89 d8                	mov    %ebx,%eax
  80378a:	d3 e0                	shl    %cl,%eax
  80378c:	89 c2                	mov    %eax,%edx
  80378e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803792:	d3 e0                	shl    %cl,%eax
  803794:	89 44 24 04          	mov    %eax,0x4(%esp)
  803798:	8b 44 24 08          	mov    0x8(%esp),%eax
  80379c:	89 f1                	mov    %esi,%ecx
  80379e:	d3 e8                	shr    %cl,%eax
  8037a0:	09 d0                	or     %edx,%eax
  8037a2:	d3 eb                	shr    %cl,%ebx
  8037a4:	89 da                	mov    %ebx,%edx
  8037a6:	f7 f7                	div    %edi
  8037a8:	89 d3                	mov    %edx,%ebx
  8037aa:	f7 24 24             	mull   (%esp)
  8037ad:	89 c6                	mov    %eax,%esi
  8037af:	89 d1                	mov    %edx,%ecx
  8037b1:	39 d3                	cmp    %edx,%ebx
  8037b3:	0f 82 87 00 00 00    	jb     803840 <__umoddi3+0x134>
  8037b9:	0f 84 91 00 00 00    	je     803850 <__umoddi3+0x144>
  8037bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037c3:	29 f2                	sub    %esi,%edx
  8037c5:	19 cb                	sbb    %ecx,%ebx
  8037c7:	89 d8                	mov    %ebx,%eax
  8037c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037cd:	d3 e0                	shl    %cl,%eax
  8037cf:	89 e9                	mov    %ebp,%ecx
  8037d1:	d3 ea                	shr    %cl,%edx
  8037d3:	09 d0                	or     %edx,%eax
  8037d5:	89 e9                	mov    %ebp,%ecx
  8037d7:	d3 eb                	shr    %cl,%ebx
  8037d9:	89 da                	mov    %ebx,%edx
  8037db:	83 c4 1c             	add    $0x1c,%esp
  8037de:	5b                   	pop    %ebx
  8037df:	5e                   	pop    %esi
  8037e0:	5f                   	pop    %edi
  8037e1:	5d                   	pop    %ebp
  8037e2:	c3                   	ret    
  8037e3:	90                   	nop
  8037e4:	89 fd                	mov    %edi,%ebp
  8037e6:	85 ff                	test   %edi,%edi
  8037e8:	75 0b                	jne    8037f5 <__umoddi3+0xe9>
  8037ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8037ef:	31 d2                	xor    %edx,%edx
  8037f1:	f7 f7                	div    %edi
  8037f3:	89 c5                	mov    %eax,%ebp
  8037f5:	89 f0                	mov    %esi,%eax
  8037f7:	31 d2                	xor    %edx,%edx
  8037f9:	f7 f5                	div    %ebp
  8037fb:	89 c8                	mov    %ecx,%eax
  8037fd:	f7 f5                	div    %ebp
  8037ff:	89 d0                	mov    %edx,%eax
  803801:	e9 44 ff ff ff       	jmp    80374a <__umoddi3+0x3e>
  803806:	66 90                	xchg   %ax,%ax
  803808:	89 c8                	mov    %ecx,%eax
  80380a:	89 f2                	mov    %esi,%edx
  80380c:	83 c4 1c             	add    $0x1c,%esp
  80380f:	5b                   	pop    %ebx
  803810:	5e                   	pop    %esi
  803811:	5f                   	pop    %edi
  803812:	5d                   	pop    %ebp
  803813:	c3                   	ret    
  803814:	3b 04 24             	cmp    (%esp),%eax
  803817:	72 06                	jb     80381f <__umoddi3+0x113>
  803819:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80381d:	77 0f                	ja     80382e <__umoddi3+0x122>
  80381f:	89 f2                	mov    %esi,%edx
  803821:	29 f9                	sub    %edi,%ecx
  803823:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803827:	89 14 24             	mov    %edx,(%esp)
  80382a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80382e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803832:	8b 14 24             	mov    (%esp),%edx
  803835:	83 c4 1c             	add    $0x1c,%esp
  803838:	5b                   	pop    %ebx
  803839:	5e                   	pop    %esi
  80383a:	5f                   	pop    %edi
  80383b:	5d                   	pop    %ebp
  80383c:	c3                   	ret    
  80383d:	8d 76 00             	lea    0x0(%esi),%esi
  803840:	2b 04 24             	sub    (%esp),%eax
  803843:	19 fa                	sbb    %edi,%edx
  803845:	89 d1                	mov    %edx,%ecx
  803847:	89 c6                	mov    %eax,%esi
  803849:	e9 71 ff ff ff       	jmp    8037bf <__umoddi3+0xb3>
  80384e:	66 90                	xchg   %ax,%ax
  803850:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803854:	72 ea                	jb     803840 <__umoddi3+0x134>
  803856:	89 d9                	mov    %ebx,%ecx
  803858:	e9 62 ff ff ff       	jmp    8037bf <__umoddi3+0xb3>
