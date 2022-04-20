
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 d6 10 80       	mov    $0x8010d650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 0d 3a 10 80       	mov    $0x80103a0d,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	f3 0f 1e fb          	endbr32 
80100038:	55                   	push   %ebp
80100039:	89 e5                	mov    %esp,%ebp
8010003b:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003e:	83 ec 08             	sub    $0x8,%esp
80100041:	68 30 8f 10 80       	push   $0x80108f30
80100046:	68 60 d6 10 80       	push   $0x8010d660
8010004b:	e8 70 51 00 00       	call   801051c0 <initlock>
80100050:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100053:	c7 05 ac 1d 11 80 5c 	movl   $0x80111d5c,0x80111dac
8010005a:	1d 11 80 
  bcache.head.next = &bcache.head;
8010005d:	c7 05 b0 1d 11 80 5c 	movl   $0x80111d5c,0x80111db0
80100064:	1d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100067:	c7 45 f4 94 d6 10 80 	movl   $0x8010d694,-0xc(%ebp)
8010006e:	eb 47                	jmp    801000b7 <binit+0x83>
    b->next = bcache.head.next;
80100070:	8b 15 b0 1d 11 80    	mov    0x80111db0,%edx
80100076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100079:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
8010007c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007f:	c7 40 50 5c 1d 11 80 	movl   $0x80111d5c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100089:	83 c0 0c             	add    $0xc,%eax
8010008c:	83 ec 08             	sub    $0x8,%esp
8010008f:	68 37 8f 10 80       	push   $0x80108f37
80100094:	50                   	push   %eax
80100095:	e8 93 4f 00 00       	call   8010502d <initsleeplock>
8010009a:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
8010009d:	a1 b0 1d 11 80       	mov    0x80111db0,%eax
801000a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a5:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ab:	a3 b0 1d 11 80       	mov    %eax,0x80111db0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b0:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b7:	b8 5c 1d 11 80       	mov    $0x80111d5c,%eax
801000bc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000bf:	72 af                	jb     80100070 <binit+0x3c>
  }
}
801000c1:	90                   	nop
801000c2:	90                   	nop
801000c3:	c9                   	leave  
801000c4:	c3                   	ret    

801000c5 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000c5:	f3 0f 1e fb          	endbr32 
801000c9:	55                   	push   %ebp
801000ca:	89 e5                	mov    %esp,%ebp
801000cc:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000cf:	83 ec 0c             	sub    $0xc,%esp
801000d2:	68 60 d6 10 80       	push   $0x8010d660
801000d7:	e8 0a 51 00 00       	call   801051e6 <acquire>
801000dc:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000df:	a1 b0 1d 11 80       	mov    0x80111db0,%eax
801000e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000e7:	eb 58                	jmp    80100141 <bget+0x7c>
    if(b->dev == dev && b->blockno == blockno){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 40 04             	mov    0x4(%eax),%eax
801000ef:	39 45 08             	cmp    %eax,0x8(%ebp)
801000f2:	75 44                	jne    80100138 <bget+0x73>
801000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f7:	8b 40 08             	mov    0x8(%eax),%eax
801000fa:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000fd:	75 39                	jne    80100138 <bget+0x73>
      b->refcnt++;
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	8b 40 4c             	mov    0x4c(%eax),%eax
80100105:	8d 50 01             	lea    0x1(%eax),%edx
80100108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010b:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
8010010e:	83 ec 0c             	sub    $0xc,%esp
80100111:	68 60 d6 10 80       	push   $0x8010d660
80100116:	e8 3d 51 00 00       	call   80105258 <release>
8010011b:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
8010011e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100121:	83 c0 0c             	add    $0xc,%eax
80100124:	83 ec 0c             	sub    $0xc,%esp
80100127:	50                   	push   %eax
80100128:	e8 40 4f 00 00       	call   8010506d <acquiresleep>
8010012d:	83 c4 10             	add    $0x10,%esp
      return b;
80100130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100133:	e9 9d 00 00 00       	jmp    801001d5 <bget+0x110>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013b:	8b 40 54             	mov    0x54(%eax),%eax
8010013e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100141:	81 7d f4 5c 1d 11 80 	cmpl   $0x80111d5c,-0xc(%ebp)
80100148:	75 9f                	jne    801000e9 <bget+0x24>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010014a:	a1 ac 1d 11 80       	mov    0x80111dac,%eax
8010014f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100152:	eb 6b                	jmp    801001bf <bget+0xfa>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100154:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100157:	8b 40 4c             	mov    0x4c(%eax),%eax
8010015a:	85 c0                	test   %eax,%eax
8010015c:	75 58                	jne    801001b6 <bget+0xf1>
8010015e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100161:	8b 00                	mov    (%eax),%eax
80100163:	83 e0 04             	and    $0x4,%eax
80100166:	85 c0                	test   %eax,%eax
80100168:	75 4c                	jne    801001b6 <bget+0xf1>
      b->dev = dev;
8010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016d:	8b 55 08             	mov    0x8(%ebp),%edx
80100170:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
80100173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100176:	8b 55 0c             	mov    0xc(%ebp),%edx
80100179:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
8010017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
80100185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100188:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
8010018f:	83 ec 0c             	sub    $0xc,%esp
80100192:	68 60 d6 10 80       	push   $0x8010d660
80100197:	e8 bc 50 00 00       	call   80105258 <release>
8010019c:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
8010019f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a2:	83 c0 0c             	add    $0xc,%eax
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	50                   	push   %eax
801001a9:	e8 bf 4e 00 00       	call   8010506d <acquiresleep>
801001ae:	83 c4 10             	add    $0x10,%esp
      return b;
801001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b4:	eb 1f                	jmp    801001d5 <bget+0x110>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b9:	8b 40 50             	mov    0x50(%eax),%eax
801001bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001bf:	81 7d f4 5c 1d 11 80 	cmpl   $0x80111d5c,-0xc(%ebp)
801001c6:	75 8c                	jne    80100154 <bget+0x8f>
    }
  }
  panic("bget: no buffers");
801001c8:	83 ec 0c             	sub    $0xc,%esp
801001cb:	68 3e 8f 10 80       	push   $0x80108f3e
801001d0:	e8 33 04 00 00       	call   80100608 <panic>
}
801001d5:	c9                   	leave  
801001d6:	c3                   	ret    

801001d7 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001d7:	f3 0f 1e fb          	endbr32 
801001db:	55                   	push   %ebp
801001dc:	89 e5                	mov    %esp,%ebp
801001de:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001e1:	83 ec 08             	sub    $0x8,%esp
801001e4:	ff 75 0c             	pushl  0xc(%ebp)
801001e7:	ff 75 08             	pushl  0x8(%ebp)
801001ea:	e8 d6 fe ff ff       	call   801000c5 <bget>
801001ef:	83 c4 10             	add    $0x10,%esp
801001f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 02             	and    $0x2,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0e                	jne    8010020f <bread+0x38>
    iderw(b);
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	ff 75 f4             	pushl  -0xc(%ebp)
80100207:	e8 60 28 00 00       	call   80102a6c <iderw>
8010020c:	83 c4 10             	add    $0x10,%esp
  }
  return b;
8010020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100212:	c9                   	leave  
80100213:	c3                   	ret    

80100214 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100214:	f3 0f 1e fb          	endbr32 
80100218:	55                   	push   %ebp
80100219:	89 e5                	mov    %esp,%ebp
8010021b:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010021e:	8b 45 08             	mov    0x8(%ebp),%eax
80100221:	83 c0 0c             	add    $0xc,%eax
80100224:	83 ec 0c             	sub    $0xc,%esp
80100227:	50                   	push   %eax
80100228:	e8 fa 4e 00 00       	call   80105127 <holdingsleep>
8010022d:	83 c4 10             	add    $0x10,%esp
80100230:	85 c0                	test   %eax,%eax
80100232:	75 0d                	jne    80100241 <bwrite+0x2d>
    panic("bwrite");
80100234:	83 ec 0c             	sub    $0xc,%esp
80100237:	68 4f 8f 10 80       	push   $0x80108f4f
8010023c:	e8 c7 03 00 00       	call   80100608 <panic>
  b->flags |= B_DIRTY;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 00                	mov    (%eax),%eax
80100246:	83 c8 04             	or     $0x4,%eax
80100249:	89 c2                	mov    %eax,%edx
8010024b:	8b 45 08             	mov    0x8(%ebp),%eax
8010024e:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100250:	83 ec 0c             	sub    $0xc,%esp
80100253:	ff 75 08             	pushl  0x8(%ebp)
80100256:	e8 11 28 00 00       	call   80102a6c <iderw>
8010025b:	83 c4 10             	add    $0x10,%esp
}
8010025e:	90                   	nop
8010025f:	c9                   	leave  
80100260:	c3                   	ret    

80100261 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100261:	f3 0f 1e fb          	endbr32 
80100265:	55                   	push   %ebp
80100266:	89 e5                	mov    %esp,%ebp
80100268:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	83 c0 0c             	add    $0xc,%eax
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	50                   	push   %eax
80100275:	e8 ad 4e 00 00       	call   80105127 <holdingsleep>
8010027a:	83 c4 10             	add    $0x10,%esp
8010027d:	85 c0                	test   %eax,%eax
8010027f:	75 0d                	jne    8010028e <brelse+0x2d>
    panic("brelse");
80100281:	83 ec 0c             	sub    $0xc,%esp
80100284:	68 56 8f 10 80       	push   $0x80108f56
80100289:	e8 7a 03 00 00       	call   80100608 <panic>

  releasesleep(&b->lock);
8010028e:	8b 45 08             	mov    0x8(%ebp),%eax
80100291:	83 c0 0c             	add    $0xc,%eax
80100294:	83 ec 0c             	sub    $0xc,%esp
80100297:	50                   	push   %eax
80100298:	e8 38 4e 00 00       	call   801050d5 <releasesleep>
8010029d:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002a0:	83 ec 0c             	sub    $0xc,%esp
801002a3:	68 60 d6 10 80       	push   $0x8010d660
801002a8:	e8 39 4f 00 00       	call   801051e6 <acquire>
801002ad:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
801002b0:	8b 45 08             	mov    0x8(%ebp),%eax
801002b3:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b6:	8d 50 ff             	lea    -0x1(%eax),%edx
801002b9:	8b 45 08             	mov    0x8(%ebp),%eax
801002bc:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002bf:	8b 45 08             	mov    0x8(%ebp),%eax
801002c2:	8b 40 4c             	mov    0x4c(%eax),%eax
801002c5:	85 c0                	test   %eax,%eax
801002c7:	75 47                	jne    80100310 <brelse+0xaf>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002c9:	8b 45 08             	mov    0x8(%ebp),%eax
801002cc:	8b 40 54             	mov    0x54(%eax),%eax
801002cf:	8b 55 08             	mov    0x8(%ebp),%edx
801002d2:	8b 52 50             	mov    0x50(%edx),%edx
801002d5:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002d8:	8b 45 08             	mov    0x8(%ebp),%eax
801002db:	8b 40 50             	mov    0x50(%eax),%eax
801002de:	8b 55 08             	mov    0x8(%ebp),%edx
801002e1:	8b 52 54             	mov    0x54(%edx),%edx
801002e4:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002e7:	8b 15 b0 1d 11 80    	mov    0x80111db0,%edx
801002ed:	8b 45 08             	mov    0x8(%ebp),%eax
801002f0:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002f3:	8b 45 08             	mov    0x8(%ebp),%eax
801002f6:	c7 40 50 5c 1d 11 80 	movl   $0x80111d5c,0x50(%eax)
    bcache.head.next->prev = b;
801002fd:	a1 b0 1d 11 80       	mov    0x80111db0,%eax
80100302:	8b 55 08             	mov    0x8(%ebp),%edx
80100305:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
80100308:	8b 45 08             	mov    0x8(%ebp),%eax
8010030b:	a3 b0 1d 11 80       	mov    %eax,0x80111db0
  }
  
  release(&bcache.lock);
80100310:	83 ec 0c             	sub    $0xc,%esp
80100313:	68 60 d6 10 80       	push   $0x8010d660
80100318:	e8 3b 4f 00 00       	call   80105258 <release>
8010031d:	83 c4 10             	add    $0x10,%esp
}
80100320:	90                   	nop
80100321:	c9                   	leave  
80100322:	c3                   	ret    

80100323 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80100323:	55                   	push   %ebp
80100324:	89 e5                	mov    %esp,%ebp
80100326:	83 ec 14             	sub    $0x14,%esp
80100329:	8b 45 08             	mov    0x8(%ebp),%eax
8010032c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100330:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80100334:	89 c2                	mov    %eax,%edx
80100336:	ec                   	in     (%dx),%al
80100337:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010033a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010033e:	c9                   	leave  
8010033f:	c3                   	ret    

80100340 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80100340:	55                   	push   %ebp
80100341:	89 e5                	mov    %esp,%ebp
80100343:	83 ec 08             	sub    $0x8,%esp
80100346:	8b 45 08             	mov    0x8(%ebp),%eax
80100349:	8b 55 0c             	mov    0xc(%ebp),%edx
8010034c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100350:	89 d0                	mov    %edx,%eax
80100352:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100355:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100359:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010035d:	ee                   	out    %al,(%dx)
}
8010035e:	90                   	nop
8010035f:	c9                   	leave  
80100360:	c3                   	ret    

80100361 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100361:	55                   	push   %ebp
80100362:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100364:	fa                   	cli    
}
80100365:	90                   	nop
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    

80100368 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100368:	f3 0f 1e fb          	endbr32 
8010036c:	55                   	push   %ebp
8010036d:	89 e5                	mov    %esp,%ebp
8010036f:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100372:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100376:	74 1c                	je     80100394 <printint+0x2c>
80100378:	8b 45 08             	mov    0x8(%ebp),%eax
8010037b:	c1 e8 1f             	shr    $0x1f,%eax
8010037e:	0f b6 c0             	movzbl %al,%eax
80100381:	89 45 10             	mov    %eax,0x10(%ebp)
80100384:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100388:	74 0a                	je     80100394 <printint+0x2c>
    x = -xx;
8010038a:	8b 45 08             	mov    0x8(%ebp),%eax
8010038d:	f7 d8                	neg    %eax
8010038f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100392:	eb 06                	jmp    8010039a <printint+0x32>
  else
    x = xx;
80100394:	8b 45 08             	mov    0x8(%ebp),%eax
80100397:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010039a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
801003a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003a7:	ba 00 00 00 00       	mov    $0x0,%edx
801003ac:	f7 f1                	div    %ecx
801003ae:	89 d1                	mov    %edx,%ecx
801003b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003b3:	8d 50 01             	lea    0x1(%eax),%edx
801003b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003b9:	0f b6 91 04 a0 10 80 	movzbl -0x7fef5ffc(%ecx),%edx
801003c0:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003ca:	ba 00 00 00 00       	mov    $0x0,%edx
801003cf:	f7 f1                	div    %ecx
801003d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003d8:	75 c7                	jne    801003a1 <printint+0x39>

  if(sign)
801003da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003de:	74 2a                	je     8010040a <printint+0xa2>
    buf[i++] = '-';
801003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003e3:	8d 50 01             	lea    0x1(%eax),%edx
801003e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003e9:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003ee:	eb 1a                	jmp    8010040a <printint+0xa2>
    consputc(buf[i]);
801003f0:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003f6:	01 d0                	add    %edx,%eax
801003f8:	0f b6 00             	movzbl (%eax),%eax
801003fb:	0f be c0             	movsbl %al,%eax
801003fe:	83 ec 0c             	sub    $0xc,%esp
80100401:	50                   	push   %eax
80100402:	e8 36 04 00 00       	call   8010083d <consputc>
80100407:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
8010040a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010040e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100412:	79 dc                	jns    801003f0 <printint+0x88>
}
80100414:	90                   	nop
80100415:	90                   	nop
80100416:	c9                   	leave  
80100417:	c3                   	ret    

80100418 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100418:	f3 0f 1e fb          	endbr32 
8010041c:	55                   	push   %ebp
8010041d:	89 e5                	mov    %esp,%ebp
8010041f:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100422:	a1 f4 c5 10 80       	mov    0x8010c5f4,%eax
80100427:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //changed: added holding check
  if(locking && !holding(&cons.lock))
8010042a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010042e:	74 24                	je     80100454 <cprintf+0x3c>
80100430:	83 ec 0c             	sub    $0xc,%esp
80100433:	68 c0 c5 10 80       	push   $0x8010c5c0
80100438:	e8 f0 4e 00 00       	call   8010532d <holding>
8010043d:	83 c4 10             	add    $0x10,%esp
80100440:	85 c0                	test   %eax,%eax
80100442:	75 10                	jne    80100454 <cprintf+0x3c>
    acquire(&cons.lock);
80100444:	83 ec 0c             	sub    $0xc,%esp
80100447:	68 c0 c5 10 80       	push   $0x8010c5c0
8010044c:	e8 95 4d 00 00       	call   801051e6 <acquire>
80100451:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100454:	8b 45 08             	mov    0x8(%ebp),%eax
80100457:	85 c0                	test   %eax,%eax
80100459:	75 0d                	jne    80100468 <cprintf+0x50>
    panic("null fmt");
8010045b:	83 ec 0c             	sub    $0xc,%esp
8010045e:	68 60 8f 10 80       	push   $0x80108f60
80100463:	e8 a0 01 00 00       	call   80100608 <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100468:	8d 45 0c             	lea    0xc(%ebp),%eax
8010046b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010046e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100475:	e9 52 01 00 00       	jmp    801005cc <cprintf+0x1b4>
    if(c != '%'){
8010047a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010047e:	74 13                	je     80100493 <cprintf+0x7b>
      consputc(c);
80100480:	83 ec 0c             	sub    $0xc,%esp
80100483:	ff 75 e4             	pushl  -0x1c(%ebp)
80100486:	e8 b2 03 00 00       	call   8010083d <consputc>
8010048b:	83 c4 10             	add    $0x10,%esp
      continue;
8010048e:	e9 35 01 00 00       	jmp    801005c8 <cprintf+0x1b0>
    }
    c = fmt[++i] & 0xff;
80100493:	8b 55 08             	mov    0x8(%ebp),%edx
80100496:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010049a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010049d:	01 d0                	add    %edx,%eax
8010049f:	0f b6 00             	movzbl (%eax),%eax
801004a2:	0f be c0             	movsbl %al,%eax
801004a5:	25 ff 00 00 00       	and    $0xff,%eax
801004aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
801004ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801004b1:	0f 84 37 01 00 00    	je     801005ee <cprintf+0x1d6>
      break;
    switch(c){
801004b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004bb:	0f 84 dc 00 00 00    	je     8010059d <cprintf+0x185>
801004c1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004c5:	0f 8c e1 00 00 00    	jl     801005ac <cprintf+0x194>
801004cb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
801004cf:	0f 8f d7 00 00 00    	jg     801005ac <cprintf+0x194>
801004d5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
801004d9:	0f 8c cd 00 00 00    	jl     801005ac <cprintf+0x194>
801004df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004e2:	83 e8 63             	sub    $0x63,%eax
801004e5:	83 f8 15             	cmp    $0x15,%eax
801004e8:	0f 87 be 00 00 00    	ja     801005ac <cprintf+0x194>
801004ee:	8b 04 85 70 8f 10 80 	mov    -0x7fef7090(,%eax,4),%eax
801004f5:	3e ff e0             	notrack jmp *%eax
    case 'd':
      printint(*argp++, 10, 1);
801004f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004fb:	8d 50 04             	lea    0x4(%eax),%edx
801004fe:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100501:	8b 00                	mov    (%eax),%eax
80100503:	83 ec 04             	sub    $0x4,%esp
80100506:	6a 01                	push   $0x1
80100508:	6a 0a                	push   $0xa
8010050a:	50                   	push   %eax
8010050b:	e8 58 fe ff ff       	call   80100368 <printint>
80100510:	83 c4 10             	add    $0x10,%esp
      break;
80100513:	e9 b0 00 00 00       	jmp    801005c8 <cprintf+0x1b0>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100518:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010051b:	8d 50 04             	lea    0x4(%eax),%edx
8010051e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100521:	8b 00                	mov    (%eax),%eax
80100523:	83 ec 04             	sub    $0x4,%esp
80100526:	6a 00                	push   $0x0
80100528:	6a 10                	push   $0x10
8010052a:	50                   	push   %eax
8010052b:	e8 38 fe ff ff       	call   80100368 <printint>
80100530:	83 c4 10             	add    $0x10,%esp
      break;
80100533:	e9 90 00 00 00       	jmp    801005c8 <cprintf+0x1b0>
    case 's':
      if((s = (char*)*argp++) == 0)
80100538:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010053b:	8d 50 04             	lea    0x4(%eax),%edx
8010053e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100541:	8b 00                	mov    (%eax),%eax
80100543:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100546:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010054a:	75 22                	jne    8010056e <cprintf+0x156>
        s = "(null)";
8010054c:	c7 45 ec 69 8f 10 80 	movl   $0x80108f69,-0x14(%ebp)
      for(; *s; s++)
80100553:	eb 19                	jmp    8010056e <cprintf+0x156>
        consputc(*s);
80100555:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100558:	0f b6 00             	movzbl (%eax),%eax
8010055b:	0f be c0             	movsbl %al,%eax
8010055e:	83 ec 0c             	sub    $0xc,%esp
80100561:	50                   	push   %eax
80100562:	e8 d6 02 00 00       	call   8010083d <consputc>
80100567:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
8010056a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010056e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100571:	0f b6 00             	movzbl (%eax),%eax
80100574:	84 c0                	test   %al,%al
80100576:	75 dd                	jne    80100555 <cprintf+0x13d>
      break;
80100578:	eb 4e                	jmp    801005c8 <cprintf+0x1b0>
    case 'c':
      s = (char*)argp++;
8010057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010057d:	8d 50 04             	lea    0x4(%eax),%edx
80100580:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100583:	89 45 ec             	mov    %eax,-0x14(%ebp)
      consputc(*(s));
80100586:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100589:	0f b6 00             	movzbl (%eax),%eax
8010058c:	0f be c0             	movsbl %al,%eax
8010058f:	83 ec 0c             	sub    $0xc,%esp
80100592:	50                   	push   %eax
80100593:	e8 a5 02 00 00       	call   8010083d <consputc>
80100598:	83 c4 10             	add    $0x10,%esp
      break;
8010059b:	eb 2b                	jmp    801005c8 <cprintf+0x1b0>
    case '%':
      consputc('%');
8010059d:	83 ec 0c             	sub    $0xc,%esp
801005a0:	6a 25                	push   $0x25
801005a2:	e8 96 02 00 00       	call   8010083d <consputc>
801005a7:	83 c4 10             	add    $0x10,%esp
      break;
801005aa:	eb 1c                	jmp    801005c8 <cprintf+0x1b0>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801005ac:	83 ec 0c             	sub    $0xc,%esp
801005af:	6a 25                	push   $0x25
801005b1:	e8 87 02 00 00       	call   8010083d <consputc>
801005b6:	83 c4 10             	add    $0x10,%esp
      consputc(c);
801005b9:	83 ec 0c             	sub    $0xc,%esp
801005bc:	ff 75 e4             	pushl  -0x1c(%ebp)
801005bf:	e8 79 02 00 00       	call   8010083d <consputc>
801005c4:	83 c4 10             	add    $0x10,%esp
      break;
801005c7:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005cc:	8b 55 08             	mov    0x8(%ebp),%edx
801005cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d2:	01 d0                	add    %edx,%eax
801005d4:	0f b6 00             	movzbl (%eax),%eax
801005d7:	0f be c0             	movsbl %al,%eax
801005da:	25 ff 00 00 00       	and    $0xff,%eax
801005df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801005e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801005e6:	0f 85 8e fe ff ff    	jne    8010047a <cprintf+0x62>
801005ec:	eb 01                	jmp    801005ef <cprintf+0x1d7>
      break;
801005ee:	90                   	nop
    }
  }

  if(locking)
801005ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801005f3:	74 10                	je     80100605 <cprintf+0x1ed>
    release(&cons.lock);
801005f5:	83 ec 0c             	sub    $0xc,%esp
801005f8:	68 c0 c5 10 80       	push   $0x8010c5c0
801005fd:	e8 56 4c 00 00       	call   80105258 <release>
80100602:	83 c4 10             	add    $0x10,%esp
}
80100605:	90                   	nop
80100606:	c9                   	leave  
80100607:	c3                   	ret    

80100608 <panic>:

void
panic(char *s)
{
80100608:	f3 0f 1e fb          	endbr32 
8010060c:	55                   	push   %ebp
8010060d:	89 e5                	mov    %esp,%ebp
8010060f:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
80100612:	e8 4a fd ff ff       	call   80100361 <cli>
  cons.locking = 0;
80100617:	c7 05 f4 c5 10 80 00 	movl   $0x0,0x8010c5f4
8010061e:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100621:	e8 38 2b 00 00       	call   8010315e <lapicid>
80100626:	83 ec 08             	sub    $0x8,%esp
80100629:	50                   	push   %eax
8010062a:	68 c8 8f 10 80       	push   $0x80108fc8
8010062f:	e8 e4 fd ff ff       	call   80100418 <cprintf>
80100634:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100637:	8b 45 08             	mov    0x8(%ebp),%eax
8010063a:	83 ec 0c             	sub    $0xc,%esp
8010063d:	50                   	push   %eax
8010063e:	e8 d5 fd ff ff       	call   80100418 <cprintf>
80100643:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80100646:	83 ec 0c             	sub    $0xc,%esp
80100649:	68 dc 8f 10 80       	push   $0x80108fdc
8010064e:	e8 c5 fd ff ff       	call   80100418 <cprintf>
80100653:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
80100656:	83 ec 08             	sub    $0x8,%esp
80100659:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010065c:	50                   	push   %eax
8010065d:	8d 45 08             	lea    0x8(%ebp),%eax
80100660:	50                   	push   %eax
80100661:	e8 48 4c 00 00       	call   801052ae <getcallerpcs>
80100666:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100669:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100670:	eb 1c                	jmp    8010068e <panic+0x86>
    cprintf(" %p", pcs[i]);
80100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100675:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100679:	83 ec 08             	sub    $0x8,%esp
8010067c:	50                   	push   %eax
8010067d:	68 de 8f 10 80       	push   $0x80108fde
80100682:	e8 91 fd ff ff       	call   80100418 <cprintf>
80100687:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
8010068a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010068e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100692:	7e de                	jle    80100672 <panic+0x6a>
  panicked = 1; // freeze other CPU
80100694:	c7 05 a0 c5 10 80 01 	movl   $0x1,0x8010c5a0
8010069b:	00 00 00 
  for(;;)
8010069e:	eb fe                	jmp    8010069e <panic+0x96>

801006a0 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801006a0:	f3 0f 1e fb          	endbr32 
801006a4:	55                   	push   %ebp
801006a5:	89 e5                	mov    %esp,%ebp
801006a7:	53                   	push   %ebx
801006a8:	83 ec 14             	sub    $0x14,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801006ab:	6a 0e                	push   $0xe
801006ad:	68 d4 03 00 00       	push   $0x3d4
801006b2:	e8 89 fc ff ff       	call   80100340 <outb>
801006b7:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
801006ba:	68 d5 03 00 00       	push   $0x3d5
801006bf:	e8 5f fc ff ff       	call   80100323 <inb>
801006c4:	83 c4 04             	add    $0x4,%esp
801006c7:	0f b6 c0             	movzbl %al,%eax
801006ca:	c1 e0 08             	shl    $0x8,%eax
801006cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801006d0:	6a 0f                	push   $0xf
801006d2:	68 d4 03 00 00       	push   $0x3d4
801006d7:	e8 64 fc ff ff       	call   80100340 <outb>
801006dc:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
801006df:	68 d5 03 00 00       	push   $0x3d5
801006e4:	e8 3a fc ff ff       	call   80100323 <inb>
801006e9:	83 c4 04             	add    $0x4,%esp
801006ec:	0f b6 c0             	movzbl %al,%eax
801006ef:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
801006f2:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
801006f6:	75 30                	jne    80100728 <cgaputc+0x88>
    pos += 80 - pos%80;
801006f8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006fb:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100700:	89 c8                	mov    %ecx,%eax
80100702:	f7 ea                	imul   %edx
80100704:	c1 fa 05             	sar    $0x5,%edx
80100707:	89 c8                	mov    %ecx,%eax
80100709:	c1 f8 1f             	sar    $0x1f,%eax
8010070c:	29 c2                	sub    %eax,%edx
8010070e:	89 d0                	mov    %edx,%eax
80100710:	c1 e0 02             	shl    $0x2,%eax
80100713:	01 d0                	add    %edx,%eax
80100715:	c1 e0 04             	shl    $0x4,%eax
80100718:	29 c1                	sub    %eax,%ecx
8010071a:	89 ca                	mov    %ecx,%edx
8010071c:	b8 50 00 00 00       	mov    $0x50,%eax
80100721:	29 d0                	sub    %edx,%eax
80100723:	01 45 f4             	add    %eax,-0xc(%ebp)
80100726:	eb 38                	jmp    80100760 <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100728:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010072f:	75 0c                	jne    8010073d <cgaputc+0x9d>
    if(pos > 0) --pos;
80100731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100735:	7e 29                	jle    80100760 <cgaputc+0xc0>
80100737:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010073b:	eb 23                	jmp    80100760 <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010073d:	8b 45 08             	mov    0x8(%ebp),%eax
80100740:	0f b6 c0             	movzbl %al,%eax
80100743:	80 cc 07             	or     $0x7,%ah
80100746:	89 c3                	mov    %eax,%ebx
80100748:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100751:	8d 50 01             	lea    0x1(%eax),%edx
80100754:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100757:	01 c0                	add    %eax,%eax
80100759:	01 c8                	add    %ecx,%eax
8010075b:	89 da                	mov    %ebx,%edx
8010075d:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
80100760:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100764:	78 09                	js     8010076f <cgaputc+0xcf>
80100766:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
8010076d:	7e 0d                	jle    8010077c <cgaputc+0xdc>
    panic("pos under/overflow");
8010076f:	83 ec 0c             	sub    $0xc,%esp
80100772:	68 e2 8f 10 80       	push   $0x80108fe2
80100777:	e8 8c fe ff ff       	call   80100608 <panic>

  if((pos/80) >= 24){  // Scroll up.
8010077c:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100783:	7e 4c                	jle    801007d1 <cgaputc+0x131>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100785:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010078a:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100790:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100795:	83 ec 04             	sub    $0x4,%esp
80100798:	68 60 0e 00 00       	push   $0xe60
8010079d:	52                   	push   %edx
8010079e:	50                   	push   %eax
8010079f:	e8 a8 4d 00 00       	call   8010554c <memmove>
801007a4:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801007a7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801007ab:	b8 80 07 00 00       	mov    $0x780,%eax
801007b0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801007b3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801007b6:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801007bb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801007be:	01 c9                	add    %ecx,%ecx
801007c0:	01 c8                	add    %ecx,%eax
801007c2:	83 ec 04             	sub    $0x4,%esp
801007c5:	52                   	push   %edx
801007c6:	6a 00                	push   $0x0
801007c8:	50                   	push   %eax
801007c9:	e8 b7 4c 00 00       	call   80105485 <memset>
801007ce:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
801007d1:	83 ec 08             	sub    $0x8,%esp
801007d4:	6a 0e                	push   $0xe
801007d6:	68 d4 03 00 00       	push   $0x3d4
801007db:	e8 60 fb ff ff       	call   80100340 <outb>
801007e0:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
801007e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007e6:	c1 f8 08             	sar    $0x8,%eax
801007e9:	0f b6 c0             	movzbl %al,%eax
801007ec:	83 ec 08             	sub    $0x8,%esp
801007ef:	50                   	push   %eax
801007f0:	68 d5 03 00 00       	push   $0x3d5
801007f5:	e8 46 fb ff ff       	call   80100340 <outb>
801007fa:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
801007fd:	83 ec 08             	sub    $0x8,%esp
80100800:	6a 0f                	push   $0xf
80100802:	68 d4 03 00 00       	push   $0x3d4
80100807:	e8 34 fb ff ff       	call   80100340 <outb>
8010080c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100812:	0f b6 c0             	movzbl %al,%eax
80100815:	83 ec 08             	sub    $0x8,%esp
80100818:	50                   	push   %eax
80100819:	68 d5 03 00 00       	push   $0x3d5
8010081e:	e8 1d fb ff ff       	call   80100340 <outb>
80100823:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100826:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010082b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010082e:	01 d2                	add    %edx,%edx
80100830:	01 d0                	add    %edx,%eax
80100832:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100837:	90                   	nop
80100838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010083b:	c9                   	leave  
8010083c:	c3                   	ret    

8010083d <consputc>:

void
consputc(int c)
{
8010083d:	f3 0f 1e fb          	endbr32 
80100841:	55                   	push   %ebp
80100842:	89 e5                	mov    %esp,%ebp
80100844:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100847:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
8010084c:	85 c0                	test   %eax,%eax
8010084e:	74 07                	je     80100857 <consputc+0x1a>
    cli();
80100850:	e8 0c fb ff ff       	call   80100361 <cli>
    for(;;)
80100855:	eb fe                	jmp    80100855 <consputc+0x18>
      ;
  }

  if(c == BACKSPACE){
80100857:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010085e:	75 29                	jne    80100889 <consputc+0x4c>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	6a 08                	push   $0x8
80100865:	e8 2d 67 00 00       	call   80106f97 <uartputc>
8010086a:	83 c4 10             	add    $0x10,%esp
8010086d:	83 ec 0c             	sub    $0xc,%esp
80100870:	6a 20                	push   $0x20
80100872:	e8 20 67 00 00       	call   80106f97 <uartputc>
80100877:	83 c4 10             	add    $0x10,%esp
8010087a:	83 ec 0c             	sub    $0xc,%esp
8010087d:	6a 08                	push   $0x8
8010087f:	e8 13 67 00 00       	call   80106f97 <uartputc>
80100884:	83 c4 10             	add    $0x10,%esp
80100887:	eb 0e                	jmp    80100897 <consputc+0x5a>
  } else
    uartputc(c);
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	ff 75 08             	pushl  0x8(%ebp)
8010088f:	e8 03 67 00 00       	call   80106f97 <uartputc>
80100894:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100897:	83 ec 0c             	sub    $0xc,%esp
8010089a:	ff 75 08             	pushl  0x8(%ebp)
8010089d:	e8 fe fd ff ff       	call   801006a0 <cgaputc>
801008a2:	83 c4 10             	add    $0x10,%esp
}
801008a5:	90                   	nop
801008a6:	c9                   	leave  
801008a7:	c3                   	ret    

801008a8 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801008a8:	f3 0f 1e fb          	endbr32 
801008ac:	55                   	push   %ebp
801008ad:	89 e5                	mov    %esp,%ebp
801008af:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801008b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801008b9:	83 ec 0c             	sub    $0xc,%esp
801008bc:	68 c0 c5 10 80       	push   $0x8010c5c0
801008c1:	e8 20 49 00 00       	call   801051e6 <acquire>
801008c6:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801008c9:	e9 52 01 00 00       	jmp    80100a20 <consoleintr+0x178>
    switch(c){
801008ce:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801008d2:	0f 84 81 00 00 00    	je     80100959 <consoleintr+0xb1>
801008d8:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801008dc:	0f 8f ac 00 00 00    	jg     8010098e <consoleintr+0xe6>
801008e2:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
801008e6:	74 43                	je     8010092b <consoleintr+0x83>
801008e8:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
801008ec:	0f 8f 9c 00 00 00    	jg     8010098e <consoleintr+0xe6>
801008f2:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
801008f6:	74 61                	je     80100959 <consoleintr+0xb1>
801008f8:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
801008fc:	0f 85 8c 00 00 00    	jne    8010098e <consoleintr+0xe6>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100902:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100909:	e9 12 01 00 00       	jmp    80100a20 <consoleintr+0x178>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010090e:	a1 48 20 11 80       	mov    0x80112048,%eax
80100913:	83 e8 01             	sub    $0x1,%eax
80100916:	a3 48 20 11 80       	mov    %eax,0x80112048
        consputc(BACKSPACE);
8010091b:	83 ec 0c             	sub    $0xc,%esp
8010091e:	68 00 01 00 00       	push   $0x100
80100923:	e8 15 ff ff ff       	call   8010083d <consputc>
80100928:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
8010092b:	8b 15 48 20 11 80    	mov    0x80112048,%edx
80100931:	a1 44 20 11 80       	mov    0x80112044,%eax
80100936:	39 c2                	cmp    %eax,%edx
80100938:	0f 84 e2 00 00 00    	je     80100a20 <consoleintr+0x178>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010093e:	a1 48 20 11 80       	mov    0x80112048,%eax
80100943:	83 e8 01             	sub    $0x1,%eax
80100946:	83 e0 7f             	and    $0x7f,%eax
80100949:	0f b6 80 c0 1f 11 80 	movzbl -0x7feee040(%eax),%eax
      while(input.e != input.w &&
80100950:	3c 0a                	cmp    $0xa,%al
80100952:	75 ba                	jne    8010090e <consoleintr+0x66>
      }
      break;
80100954:	e9 c7 00 00 00       	jmp    80100a20 <consoleintr+0x178>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100959:	8b 15 48 20 11 80    	mov    0x80112048,%edx
8010095f:	a1 44 20 11 80       	mov    0x80112044,%eax
80100964:	39 c2                	cmp    %eax,%edx
80100966:	0f 84 b4 00 00 00    	je     80100a20 <consoleintr+0x178>
        input.e--;
8010096c:	a1 48 20 11 80       	mov    0x80112048,%eax
80100971:	83 e8 01             	sub    $0x1,%eax
80100974:	a3 48 20 11 80       	mov    %eax,0x80112048
        consputc(BACKSPACE);
80100979:	83 ec 0c             	sub    $0xc,%esp
8010097c:	68 00 01 00 00       	push   $0x100
80100981:	e8 b7 fe ff ff       	call   8010083d <consputc>
80100986:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100989:	e9 92 00 00 00       	jmp    80100a20 <consoleintr+0x178>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010098e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100992:	0f 84 87 00 00 00    	je     80100a1f <consoleintr+0x177>
80100998:	8b 15 48 20 11 80    	mov    0x80112048,%edx
8010099e:	a1 40 20 11 80       	mov    0x80112040,%eax
801009a3:	29 c2                	sub    %eax,%edx
801009a5:	89 d0                	mov    %edx,%eax
801009a7:	83 f8 7f             	cmp    $0x7f,%eax
801009aa:	77 73                	ja     80100a1f <consoleintr+0x177>
        c = (c == '\r') ? '\n' : c;
801009ac:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801009b0:	74 05                	je     801009b7 <consoleintr+0x10f>
801009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009b5:	eb 05                	jmp    801009bc <consoleintr+0x114>
801009b7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801009bf:	a1 48 20 11 80       	mov    0x80112048,%eax
801009c4:	8d 50 01             	lea    0x1(%eax),%edx
801009c7:	89 15 48 20 11 80    	mov    %edx,0x80112048
801009cd:	83 e0 7f             	and    $0x7f,%eax
801009d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009d3:	88 90 c0 1f 11 80    	mov    %dl,-0x7feee040(%eax)
        consputc(c);
801009d9:	83 ec 0c             	sub    $0xc,%esp
801009dc:	ff 75 f0             	pushl  -0x10(%ebp)
801009df:	e8 59 fe ff ff       	call   8010083d <consputc>
801009e4:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009e7:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009eb:	74 18                	je     80100a05 <consoleintr+0x15d>
801009ed:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009f1:	74 12                	je     80100a05 <consoleintr+0x15d>
801009f3:	a1 48 20 11 80       	mov    0x80112048,%eax
801009f8:	8b 15 40 20 11 80    	mov    0x80112040,%edx
801009fe:	83 ea 80             	sub    $0xffffff80,%edx
80100a01:	39 d0                	cmp    %edx,%eax
80100a03:	75 1a                	jne    80100a1f <consoleintr+0x177>
          input.w = input.e;
80100a05:	a1 48 20 11 80       	mov    0x80112048,%eax
80100a0a:	a3 44 20 11 80       	mov    %eax,0x80112044
          wakeup(&input.r);
80100a0f:	83 ec 0c             	sub    $0xc,%esp
80100a12:	68 40 20 11 80       	push   $0x80112040
80100a17:	e8 4a 44 00 00       	call   80104e66 <wakeup>
80100a1c:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100a1f:	90                   	nop
  while((c = getc()) >= 0){
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	ff d0                	call   *%eax
80100a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100a28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a2c:	0f 89 9c fe ff ff    	jns    801008ce <consoleintr+0x26>
    }
  }
  release(&cons.lock);
80100a32:	83 ec 0c             	sub    $0xc,%esp
80100a35:	68 c0 c5 10 80       	push   $0x8010c5c0
80100a3a:	e8 19 48 00 00       	call   80105258 <release>
80100a3f:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a46:	74 05                	je     80100a4d <consoleintr+0x1a5>
    procdump();  // now call procdump() wo. cons.lock held
80100a48:	e8 df 44 00 00       	call   80104f2c <procdump>
  }
}
80100a4d:	90                   	nop
80100a4e:	c9                   	leave  
80100a4f:	c3                   	ret    

80100a50 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a50:	f3 0f 1e fb          	endbr32 
80100a54:	55                   	push   %ebp
80100a55:	89 e5                	mov    %esp,%ebp
80100a57:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a5a:	83 ec 0c             	sub    $0xc,%esp
80100a5d:	ff 75 08             	pushl  0x8(%ebp)
80100a60:	e8 8d 11 00 00       	call   80101bf2 <iunlock>
80100a65:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a68:	8b 45 10             	mov    0x10(%ebp),%eax
80100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a6e:	83 ec 0c             	sub    $0xc,%esp
80100a71:	68 c0 c5 10 80       	push   $0x8010c5c0
80100a76:	e8 6b 47 00 00       	call   801051e6 <acquire>
80100a7b:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a7e:	e9 ab 00 00 00       	jmp    80100b2e <consoleread+0xde>
    while(input.r == input.w){
      if(myproc()->killed){
80100a83:	e8 07 3a 00 00       	call   8010448f <myproc>
80100a88:	8b 40 24             	mov    0x24(%eax),%eax
80100a8b:	85 c0                	test   %eax,%eax
80100a8d:	74 28                	je     80100ab7 <consoleread+0x67>
        release(&cons.lock);
80100a8f:	83 ec 0c             	sub    $0xc,%esp
80100a92:	68 c0 c5 10 80       	push   $0x8010c5c0
80100a97:	e8 bc 47 00 00       	call   80105258 <release>
80100a9c:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a9f:	83 ec 0c             	sub    $0xc,%esp
80100aa2:	ff 75 08             	pushl  0x8(%ebp)
80100aa5:	e8 31 10 00 00       	call   80101adb <ilock>
80100aaa:	83 c4 10             	add    $0x10,%esp
        return -1;
80100aad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ab2:	e9 ab 00 00 00       	jmp    80100b62 <consoleread+0x112>
      }
      sleep(&input.r, &cons.lock);
80100ab7:	83 ec 08             	sub    $0x8,%esp
80100aba:	68 c0 c5 10 80       	push   $0x8010c5c0
80100abf:	68 40 20 11 80       	push   $0x80112040
80100ac4:	e8 ab 42 00 00       	call   80104d74 <sleep>
80100ac9:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100acc:	8b 15 40 20 11 80    	mov    0x80112040,%edx
80100ad2:	a1 44 20 11 80       	mov    0x80112044,%eax
80100ad7:	39 c2                	cmp    %eax,%edx
80100ad9:	74 a8                	je     80100a83 <consoleread+0x33>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100adb:	a1 40 20 11 80       	mov    0x80112040,%eax
80100ae0:	8d 50 01             	lea    0x1(%eax),%edx
80100ae3:	89 15 40 20 11 80    	mov    %edx,0x80112040
80100ae9:	83 e0 7f             	and    $0x7f,%eax
80100aec:	0f b6 80 c0 1f 11 80 	movzbl -0x7feee040(%eax),%eax
80100af3:	0f be c0             	movsbl %al,%eax
80100af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100af9:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100afd:	75 17                	jne    80100b16 <consoleread+0xc6>
      if(n < target){
80100aff:	8b 45 10             	mov    0x10(%ebp),%eax
80100b02:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100b05:	76 2f                	jbe    80100b36 <consoleread+0xe6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100b07:	a1 40 20 11 80       	mov    0x80112040,%eax
80100b0c:	83 e8 01             	sub    $0x1,%eax
80100b0f:	a3 40 20 11 80       	mov    %eax,0x80112040
      }
      break;
80100b14:	eb 20                	jmp    80100b36 <consoleread+0xe6>
    }
    *dst++ = c;
80100b16:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b19:	8d 50 01             	lea    0x1(%eax),%edx
80100b1c:	89 55 0c             	mov    %edx,0xc(%ebp)
80100b1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b22:	88 10                	mov    %dl,(%eax)
    --n;
80100b24:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b28:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b2c:	74 0b                	je     80100b39 <consoleread+0xe9>
  while(n > 0){
80100b2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b32:	7f 98                	jg     80100acc <consoleread+0x7c>
80100b34:	eb 04                	jmp    80100b3a <consoleread+0xea>
      break;
80100b36:	90                   	nop
80100b37:	eb 01                	jmp    80100b3a <consoleread+0xea>
      break;
80100b39:	90                   	nop
  }
  release(&cons.lock);
80100b3a:	83 ec 0c             	sub    $0xc,%esp
80100b3d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100b42:	e8 11 47 00 00       	call   80105258 <release>
80100b47:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b4a:	83 ec 0c             	sub    $0xc,%esp
80100b4d:	ff 75 08             	pushl  0x8(%ebp)
80100b50:	e8 86 0f 00 00       	call   80101adb <ilock>
80100b55:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b58:	8b 45 10             	mov    0x10(%ebp),%eax
80100b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b5e:	29 c2                	sub    %eax,%edx
80100b60:	89 d0                	mov    %edx,%eax
}
80100b62:	c9                   	leave  
80100b63:	c3                   	ret    

80100b64 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b64:	f3 0f 1e fb          	endbr32 
80100b68:	55                   	push   %ebp
80100b69:	89 e5                	mov    %esp,%ebp
80100b6b:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b6e:	83 ec 0c             	sub    $0xc,%esp
80100b71:	ff 75 08             	pushl  0x8(%ebp)
80100b74:	e8 79 10 00 00       	call   80101bf2 <iunlock>
80100b79:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b7c:	83 ec 0c             	sub    $0xc,%esp
80100b7f:	68 c0 c5 10 80       	push   $0x8010c5c0
80100b84:	e8 5d 46 00 00       	call   801051e6 <acquire>
80100b89:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b93:	eb 21                	jmp    80100bb6 <consolewrite+0x52>
    consputc(buf[i] & 0xff);
80100b95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b98:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b9b:	01 d0                	add    %edx,%eax
80100b9d:	0f b6 00             	movzbl (%eax),%eax
80100ba0:	0f be c0             	movsbl %al,%eax
80100ba3:	0f b6 c0             	movzbl %al,%eax
80100ba6:	83 ec 0c             	sub    $0xc,%esp
80100ba9:	50                   	push   %eax
80100baa:	e8 8e fc ff ff       	call   8010083d <consputc>
80100baf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100bb2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100bb9:	3b 45 10             	cmp    0x10(%ebp),%eax
80100bbc:	7c d7                	jl     80100b95 <consolewrite+0x31>
  release(&cons.lock);
80100bbe:	83 ec 0c             	sub    $0xc,%esp
80100bc1:	68 c0 c5 10 80       	push   $0x8010c5c0
80100bc6:	e8 8d 46 00 00       	call   80105258 <release>
80100bcb:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bce:	83 ec 0c             	sub    $0xc,%esp
80100bd1:	ff 75 08             	pushl  0x8(%ebp)
80100bd4:	e8 02 0f 00 00       	call   80101adb <ilock>
80100bd9:	83 c4 10             	add    $0x10,%esp

  return n;
80100bdc:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bdf:	c9                   	leave  
80100be0:	c3                   	ret    

80100be1 <consoleinit>:

void
consoleinit(void)
{
80100be1:	f3 0f 1e fb          	endbr32 
80100be5:	55                   	push   %ebp
80100be6:	89 e5                	mov    %esp,%ebp
80100be8:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100beb:	83 ec 08             	sub    $0x8,%esp
80100bee:	68 f5 8f 10 80       	push   $0x80108ff5
80100bf3:	68 c0 c5 10 80       	push   $0x8010c5c0
80100bf8:	e8 c3 45 00 00       	call   801051c0 <initlock>
80100bfd:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100c00:	c7 05 0c 2a 11 80 64 	movl   $0x80100b64,0x80112a0c
80100c07:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100c0a:	c7 05 08 2a 11 80 50 	movl   $0x80100a50,0x80112a08
80100c11:	0a 10 80 
  cons.locking = 1;
80100c14:	c7 05 f4 c5 10 80 01 	movl   $0x1,0x8010c5f4
80100c1b:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100c1e:	83 ec 08             	sub    $0x8,%esp
80100c21:	6a 00                	push   $0x0
80100c23:	6a 01                	push   $0x1
80100c25:	e8 1b 20 00 00       	call   80102c45 <ioapicenable>
80100c2a:	83 c4 10             	add    $0x10,%esp
}
80100c2d:	90                   	nop
80100c2e:	c9                   	leave  
80100c2f:	c3                   	ret    

80100c30 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100c30:	f3 0f 1e fb          	endbr32 
80100c34:	55                   	push   %ebp
80100c35:	89 e5                	mov    %esp,%ebp
80100c37:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100c3d:	e8 4d 38 00 00       	call   8010448f <myproc>
80100c42:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100c45:	e8 86 2a 00 00       	call   801036d0 <begin_op>

  if((ip = namei(path)) == 0){
80100c4a:	83 ec 0c             	sub    $0xc,%esp
80100c4d:	ff 75 08             	pushl  0x8(%ebp)
80100c50:	e8 f1 19 00 00       	call   80102646 <namei>
80100c55:	83 c4 10             	add    $0x10,%esp
80100c58:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c5b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c5f:	75 1f                	jne    80100c80 <exec+0x50>
    end_op();
80100c61:	e8 fa 2a 00 00       	call   80103760 <end_op>
    cprintf("exec: fail\n");
80100c66:	83 ec 0c             	sub    $0xc,%esp
80100c69:	68 fd 8f 10 80       	push   $0x80108ffd
80100c6e:	e8 a5 f7 ff ff       	call   80100418 <cprintf>
80100c73:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c7b:	e9 f1 03 00 00       	jmp    80101071 <exec+0x441>
  }
  ilock(ip);
80100c80:	83 ec 0c             	sub    $0xc,%esp
80100c83:	ff 75 d8             	pushl  -0x28(%ebp)
80100c86:	e8 50 0e 00 00       	call   80101adb <ilock>
80100c8b:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c8e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c95:	6a 34                	push   $0x34
80100c97:	6a 00                	push   $0x0
80100c99:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c9f:	50                   	push   %eax
80100ca0:	ff 75 d8             	pushl  -0x28(%ebp)
80100ca3:	e8 3b 13 00 00       	call   80101fe3 <readi>
80100ca8:	83 c4 10             	add    $0x10,%esp
80100cab:	83 f8 34             	cmp    $0x34,%eax
80100cae:	0f 85 66 03 00 00    	jne    8010101a <exec+0x3ea>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100cb4:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100cba:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100cbf:	0f 85 58 03 00 00    	jne    8010101d <exec+0x3ed>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100cc5:	e8 04 73 00 00       	call   80107fce <setupkvm>
80100cca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100ccd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100cd1:	0f 84 49 03 00 00    	je     80101020 <exec+0x3f0>
    goto bad;

  // Load program into memory.
  sz = 0;
80100cd7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cde:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100ce5:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100ceb:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cee:	e9 de 00 00 00       	jmp    80100dd1 <exec+0x1a1>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cf6:	6a 20                	push   $0x20
80100cf8:	50                   	push   %eax
80100cf9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100cff:	50                   	push   %eax
80100d00:	ff 75 d8             	pushl  -0x28(%ebp)
80100d03:	e8 db 12 00 00       	call   80101fe3 <readi>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	83 f8 20             	cmp    $0x20,%eax
80100d0e:	0f 85 0f 03 00 00    	jne    80101023 <exec+0x3f3>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100d14:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100d1a:	83 f8 01             	cmp    $0x1,%eax
80100d1d:	0f 85 a0 00 00 00    	jne    80100dc3 <exec+0x193>
      continue;
    if(ph.memsz < ph.filesz)
80100d23:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d29:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100d2f:	39 c2                	cmp    %eax,%edx
80100d31:	0f 82 ef 02 00 00    	jb     80101026 <exec+0x3f6>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100d37:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d3d:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d43:	01 c2                	add    %eax,%edx
80100d45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d4b:	39 c2                	cmp    %eax,%edx
80100d4d:	0f 82 d6 02 00 00    	jb     80101029 <exec+0x3f9>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d53:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d59:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d5f:	01 d0                	add    %edx,%eax
80100d61:	83 ec 04             	sub    $0x4,%esp
80100d64:	50                   	push   %eax
80100d65:	ff 75 e0             	pushl  -0x20(%ebp)
80100d68:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d6b:	e8 1c 76 00 00       	call   8010838c <allocuvm>
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d7a:	0f 84 ac 02 00 00    	je     8010102c <exec+0x3fc>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100d80:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d86:	25 ff 0f 00 00       	and    $0xfff,%eax
80100d8b:	85 c0                	test   %eax,%eax
80100d8d:	0f 85 9c 02 00 00    	jne    8010102f <exec+0x3ff>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d93:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100d99:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d9f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100da5:	83 ec 0c             	sub    $0xc,%esp
80100da8:	52                   	push   %edx
80100da9:	50                   	push   %eax
80100daa:	ff 75 d8             	pushl  -0x28(%ebp)
80100dad:	51                   	push   %ecx
80100dae:	ff 75 d4             	pushl  -0x2c(%ebp)
80100db1:	e8 05 75 00 00       	call   801082bb <loaduvm>
80100db6:	83 c4 20             	add    $0x20,%esp
80100db9:	85 c0                	test   %eax,%eax
80100dbb:	0f 88 71 02 00 00    	js     80101032 <exec+0x402>
80100dc1:	eb 01                	jmp    80100dc4 <exec+0x194>
      continue;
80100dc3:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dc4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100dcb:	83 c0 20             	add    $0x20,%eax
80100dce:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100dd1:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100dd8:	0f b7 c0             	movzwl %ax,%eax
80100ddb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100dde:	0f 8c 0f ff ff ff    	jl     80100cf3 <exec+0xc3>
      goto bad;
  }
  iunlockput(ip);
80100de4:	83 ec 0c             	sub    $0xc,%esp
80100de7:	ff 75 d8             	pushl  -0x28(%ebp)
80100dea:	e8 29 0f 00 00       	call   80101d18 <iunlockput>
80100def:	83 c4 10             	add    $0x10,%esp
  end_op();
80100df2:	e8 69 29 00 00       	call   80103760 <end_op>
  ip = 0;
80100df7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e01:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e11:	05 00 20 00 00       	add    $0x2000,%eax
80100e16:	83 ec 04             	sub    $0x4,%esp
80100e19:	50                   	push   %eax
80100e1a:	ff 75 e0             	pushl  -0x20(%ebp)
80100e1d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e20:	e8 67 75 00 00       	call   8010838c <allocuvm>
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e2b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e2f:	0f 84 00 02 00 00    	je     80101035 <exec+0x405>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e38:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e3d:	83 ec 08             	sub    $0x8,%esp
80100e40:	50                   	push   %eax
80100e41:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e44:	e8 b5 77 00 00       	call   801085fe <clearpteu>
80100e49:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e4f:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e59:	e9 96 00 00 00       	jmp    80100ef4 <exec+0x2c4>
    if(argc >= MAXARG)
80100e5e:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e62:	0f 87 d0 01 00 00    	ja     80101038 <exec+0x408>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e72:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e75:	01 d0                	add    %edx,%eax
80100e77:	8b 00                	mov    (%eax),%eax
80100e79:	83 ec 0c             	sub    $0xc,%esp
80100e7c:	50                   	push   %eax
80100e7d:	e8 6c 48 00 00       	call   801056ee <strlen>
80100e82:	83 c4 10             	add    $0x10,%esp
80100e85:	89 c2                	mov    %eax,%edx
80100e87:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e8a:	29 d0                	sub    %edx,%eax
80100e8c:	83 e8 01             	sub    $0x1,%eax
80100e8f:	83 e0 fc             	and    $0xfffffffc,%eax
80100e92:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ea2:	01 d0                	add    %edx,%eax
80100ea4:	8b 00                	mov    (%eax),%eax
80100ea6:	83 ec 0c             	sub    $0xc,%esp
80100ea9:	50                   	push   %eax
80100eaa:	e8 3f 48 00 00       	call   801056ee <strlen>
80100eaf:	83 c4 10             	add    $0x10,%esp
80100eb2:	83 c0 01             	add    $0x1,%eax
80100eb5:	89 c1                	mov    %eax,%ecx
80100eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ec4:	01 d0                	add    %edx,%eax
80100ec6:	8b 00                	mov    (%eax),%eax
80100ec8:	51                   	push   %ecx
80100ec9:	50                   	push   %eax
80100eca:	ff 75 dc             	pushl  -0x24(%ebp)
80100ecd:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ed0:	e8 e5 78 00 00       	call   801087ba <copyout>
80100ed5:	83 c4 10             	add    $0x10,%esp
80100ed8:	85 c0                	test   %eax,%eax
80100eda:	0f 88 5b 01 00 00    	js     8010103b <exec+0x40b>
      goto bad;
    ustack[3+argc] = sp;
80100ee0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee3:	8d 50 03             	lea    0x3(%eax),%edx
80100ee6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ee9:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100ef0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100ef4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ef7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100efe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f01:	01 d0                	add    %edx,%eax
80100f03:	8b 00                	mov    (%eax),%eax
80100f05:	85 c0                	test   %eax,%eax
80100f07:	0f 85 51 ff ff ff    	jne    80100e5e <exec+0x22e>
  }
  ustack[3+argc] = 0;
80100f0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f10:	83 c0 03             	add    $0x3,%eax
80100f13:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100f1a:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f1e:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100f25:	ff ff ff 
  ustack[1] = argc;
80100f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f2b:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f34:	83 c0 01             	add    $0x1,%eax
80100f37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f41:	29 d0                	sub    %edx,%eax
80100f43:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f4c:	83 c0 04             	add    $0x4,%eax
80100f4f:	c1 e0 02             	shl    $0x2,%eax
80100f52:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f58:	83 c0 04             	add    $0x4,%eax
80100f5b:	c1 e0 02             	shl    $0x2,%eax
80100f5e:	50                   	push   %eax
80100f5f:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100f65:	50                   	push   %eax
80100f66:	ff 75 dc             	pushl  -0x24(%ebp)
80100f69:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f6c:	e8 49 78 00 00       	call   801087ba <copyout>
80100f71:	83 c4 10             	add    $0x10,%esp
80100f74:	85 c0                	test   %eax,%eax
80100f76:	0f 88 c2 00 00 00    	js     8010103e <exec+0x40e>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80100f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f85:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f88:	eb 17                	jmp    80100fa1 <exec+0x371>
    if(*s == '/')
80100f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f8d:	0f b6 00             	movzbl (%eax),%eax
80100f90:	3c 2f                	cmp    $0x2f,%al
80100f92:	75 09                	jne    80100f9d <exec+0x36d>
      last = s+1;
80100f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f97:	83 c0 01             	add    $0x1,%eax
80100f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100f9d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa4:	0f b6 00             	movzbl (%eax),%eax
80100fa7:	84 c0                	test   %al,%al
80100fa9:	75 df                	jne    80100f8a <exec+0x35a>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100fab:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fae:	83 c0 6c             	add    $0x6c,%eax
80100fb1:	83 ec 04             	sub    $0x4,%esp
80100fb4:	6a 10                	push   $0x10
80100fb6:	ff 75 f0             	pushl  -0x10(%ebp)
80100fb9:	50                   	push   %eax
80100fba:	e8 e1 46 00 00       	call   801056a0 <safestrcpy>
80100fbf:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100fc2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fc5:	8b 40 04             	mov    0x4(%eax),%eax
80100fc8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100fcb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100fd1:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100fd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100fda:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100fdc:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fdf:	8b 40 18             	mov    0x18(%eax),%eax
80100fe2:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100fe8:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100feb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fee:	8b 40 18             	mov    0x18(%eax),%eax
80100ff1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ff4:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100ff7:	83 ec 0c             	sub    $0xc,%esp
80100ffa:	ff 75 d0             	pushl  -0x30(%ebp)
80100ffd:	e8 a2 70 00 00       	call   801080a4 <switchuvm>
80101002:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	ff 75 cc             	pushl  -0x34(%ebp)
8010100b:	e8 4f 75 00 00       	call   8010855f <freevm>
80101010:	83 c4 10             	add    $0x10,%esp
  return 0;
80101013:	b8 00 00 00 00       	mov    $0x0,%eax
80101018:	eb 57                	jmp    80101071 <exec+0x441>
    goto bad;
8010101a:	90                   	nop
8010101b:	eb 22                	jmp    8010103f <exec+0x40f>
    goto bad;
8010101d:	90                   	nop
8010101e:	eb 1f                	jmp    8010103f <exec+0x40f>
    goto bad;
80101020:	90                   	nop
80101021:	eb 1c                	jmp    8010103f <exec+0x40f>
      goto bad;
80101023:	90                   	nop
80101024:	eb 19                	jmp    8010103f <exec+0x40f>
      goto bad;
80101026:	90                   	nop
80101027:	eb 16                	jmp    8010103f <exec+0x40f>
      goto bad;
80101029:	90                   	nop
8010102a:	eb 13                	jmp    8010103f <exec+0x40f>
      goto bad;
8010102c:	90                   	nop
8010102d:	eb 10                	jmp    8010103f <exec+0x40f>
      goto bad;
8010102f:	90                   	nop
80101030:	eb 0d                	jmp    8010103f <exec+0x40f>
      goto bad;
80101032:	90                   	nop
80101033:	eb 0a                	jmp    8010103f <exec+0x40f>
    goto bad;
80101035:	90                   	nop
80101036:	eb 07                	jmp    8010103f <exec+0x40f>
      goto bad;
80101038:	90                   	nop
80101039:	eb 04                	jmp    8010103f <exec+0x40f>
      goto bad;
8010103b:	90                   	nop
8010103c:	eb 01                	jmp    8010103f <exec+0x40f>
    goto bad;
8010103e:	90                   	nop

 bad:
  if(pgdir)
8010103f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101043:	74 0e                	je     80101053 <exec+0x423>
    freevm(pgdir);
80101045:	83 ec 0c             	sub    $0xc,%esp
80101048:	ff 75 d4             	pushl  -0x2c(%ebp)
8010104b:	e8 0f 75 00 00       	call   8010855f <freevm>
80101050:	83 c4 10             	add    $0x10,%esp
  if(ip){
80101053:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101057:	74 13                	je     8010106c <exec+0x43c>
    iunlockput(ip);
80101059:	83 ec 0c             	sub    $0xc,%esp
8010105c:	ff 75 d8             	pushl  -0x28(%ebp)
8010105f:	e8 b4 0c 00 00       	call   80101d18 <iunlockput>
80101064:	83 c4 10             	add    $0x10,%esp
    end_op();
80101067:	e8 f4 26 00 00       	call   80103760 <end_op>
  }
  return -1;
8010106c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101071:	c9                   	leave  
80101072:	c3                   	ret    

80101073 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101073:	f3 0f 1e fb          	endbr32 
80101077:	55                   	push   %ebp
80101078:	89 e5                	mov    %esp,%ebp
8010107a:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
8010107d:	83 ec 08             	sub    $0x8,%esp
80101080:	68 09 90 10 80       	push   $0x80109009
80101085:	68 60 20 11 80       	push   $0x80112060
8010108a:	e8 31 41 00 00       	call   801051c0 <initlock>
8010108f:	83 c4 10             	add    $0x10,%esp
}
80101092:	90                   	nop
80101093:	c9                   	leave  
80101094:	c3                   	ret    

80101095 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101095:	f3 0f 1e fb          	endbr32 
80101099:	55                   	push   %ebp
8010109a:	89 e5                	mov    %esp,%ebp
8010109c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 60 20 11 80       	push   $0x80112060
801010a7:	e8 3a 41 00 00       	call   801051e6 <acquire>
801010ac:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010af:	c7 45 f4 94 20 11 80 	movl   $0x80112094,-0xc(%ebp)
801010b6:	eb 2d                	jmp    801010e5 <filealloc+0x50>
    if(f->ref == 0){
801010b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010bb:	8b 40 04             	mov    0x4(%eax),%eax
801010be:	85 c0                	test   %eax,%eax
801010c0:	75 1f                	jne    801010e1 <filealloc+0x4c>
      f->ref = 1;
801010c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010c5:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
801010cc:	83 ec 0c             	sub    $0xc,%esp
801010cf:	68 60 20 11 80       	push   $0x80112060
801010d4:	e8 7f 41 00 00       	call   80105258 <release>
801010d9:	83 c4 10             	add    $0x10,%esp
      return f;
801010dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010df:	eb 23                	jmp    80101104 <filealloc+0x6f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010e1:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
801010e5:	b8 f4 29 11 80       	mov    $0x801129f4,%eax
801010ea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801010ed:	72 c9                	jb     801010b8 <filealloc+0x23>
    }
  }
  release(&ftable.lock);
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 60 20 11 80       	push   $0x80112060
801010f7:	e8 5c 41 00 00       	call   80105258 <release>
801010fc:	83 c4 10             	add    $0x10,%esp
  return 0;
801010ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101104:	c9                   	leave  
80101105:	c3                   	ret    

80101106 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101106:	f3 0f 1e fb          	endbr32 
8010110a:	55                   	push   %ebp
8010110b:	89 e5                	mov    %esp,%ebp
8010110d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101110:	83 ec 0c             	sub    $0xc,%esp
80101113:	68 60 20 11 80       	push   $0x80112060
80101118:	e8 c9 40 00 00       	call   801051e6 <acquire>
8010111d:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101120:	8b 45 08             	mov    0x8(%ebp),%eax
80101123:	8b 40 04             	mov    0x4(%eax),%eax
80101126:	85 c0                	test   %eax,%eax
80101128:	7f 0d                	jg     80101137 <filedup+0x31>
    panic("filedup");
8010112a:	83 ec 0c             	sub    $0xc,%esp
8010112d:	68 10 90 10 80       	push   $0x80109010
80101132:	e8 d1 f4 ff ff       	call   80100608 <panic>
  f->ref++;
80101137:	8b 45 08             	mov    0x8(%ebp),%eax
8010113a:	8b 40 04             	mov    0x4(%eax),%eax
8010113d:	8d 50 01             	lea    0x1(%eax),%edx
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101146:	83 ec 0c             	sub    $0xc,%esp
80101149:	68 60 20 11 80       	push   $0x80112060
8010114e:	e8 05 41 00 00       	call   80105258 <release>
80101153:	83 c4 10             	add    $0x10,%esp
  return f;
80101156:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101159:	c9                   	leave  
8010115a:	c3                   	ret    

8010115b <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010115b:	f3 0f 1e fb          	endbr32 
8010115f:	55                   	push   %ebp
80101160:	89 e5                	mov    %esp,%ebp
80101162:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101165:	83 ec 0c             	sub    $0xc,%esp
80101168:	68 60 20 11 80       	push   $0x80112060
8010116d:	e8 74 40 00 00       	call   801051e6 <acquire>
80101172:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101175:	8b 45 08             	mov    0x8(%ebp),%eax
80101178:	8b 40 04             	mov    0x4(%eax),%eax
8010117b:	85 c0                	test   %eax,%eax
8010117d:	7f 0d                	jg     8010118c <fileclose+0x31>
    panic("fileclose");
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	68 18 90 10 80       	push   $0x80109018
80101187:	e8 7c f4 ff ff       	call   80100608 <panic>
  if(--f->ref > 0){
8010118c:	8b 45 08             	mov    0x8(%ebp),%eax
8010118f:	8b 40 04             	mov    0x4(%eax),%eax
80101192:	8d 50 ff             	lea    -0x1(%eax),%edx
80101195:	8b 45 08             	mov    0x8(%ebp),%eax
80101198:	89 50 04             	mov    %edx,0x4(%eax)
8010119b:	8b 45 08             	mov    0x8(%ebp),%eax
8010119e:	8b 40 04             	mov    0x4(%eax),%eax
801011a1:	85 c0                	test   %eax,%eax
801011a3:	7e 15                	jle    801011ba <fileclose+0x5f>
    release(&ftable.lock);
801011a5:	83 ec 0c             	sub    $0xc,%esp
801011a8:	68 60 20 11 80       	push   $0x80112060
801011ad:	e8 a6 40 00 00       	call   80105258 <release>
801011b2:	83 c4 10             	add    $0x10,%esp
801011b5:	e9 8b 00 00 00       	jmp    80101245 <fileclose+0xea>
    return;
  }
  ff = *f;
801011ba:	8b 45 08             	mov    0x8(%ebp),%eax
801011bd:	8b 10                	mov    (%eax),%edx
801011bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
801011c2:	8b 50 04             	mov    0x4(%eax),%edx
801011c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801011c8:	8b 50 08             	mov    0x8(%eax),%edx
801011cb:	89 55 e8             	mov    %edx,-0x18(%ebp)
801011ce:	8b 50 0c             	mov    0xc(%eax),%edx
801011d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
801011d4:	8b 50 10             	mov    0x10(%eax),%edx
801011d7:	89 55 f0             	mov    %edx,-0x10(%ebp)
801011da:	8b 40 14             	mov    0x14(%eax),%eax
801011dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801011e0:	8b 45 08             	mov    0x8(%ebp),%eax
801011e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801011ea:	8b 45 08             	mov    0x8(%ebp),%eax
801011ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801011f3:	83 ec 0c             	sub    $0xc,%esp
801011f6:	68 60 20 11 80       	push   $0x80112060
801011fb:	e8 58 40 00 00       	call   80105258 <release>
80101200:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101203:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101206:	83 f8 01             	cmp    $0x1,%eax
80101209:	75 19                	jne    80101224 <fileclose+0xc9>
    pipeclose(ff.pipe, ff.writable);
8010120b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010120f:	0f be d0             	movsbl %al,%edx
80101212:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101215:	83 ec 08             	sub    $0x8,%esp
80101218:	52                   	push   %edx
80101219:	50                   	push   %eax
8010121a:	e8 e7 2e 00 00       	call   80104106 <pipeclose>
8010121f:	83 c4 10             	add    $0x10,%esp
80101222:	eb 21                	jmp    80101245 <fileclose+0xea>
  else if(ff.type == FD_INODE){
80101224:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101227:	83 f8 02             	cmp    $0x2,%eax
8010122a:	75 19                	jne    80101245 <fileclose+0xea>
    begin_op();
8010122c:	e8 9f 24 00 00       	call   801036d0 <begin_op>
    iput(ff.ip);
80101231:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	50                   	push   %eax
80101238:	e8 07 0a 00 00       	call   80101c44 <iput>
8010123d:	83 c4 10             	add    $0x10,%esp
    end_op();
80101240:	e8 1b 25 00 00       	call   80103760 <end_op>
  }
}
80101245:	c9                   	leave  
80101246:	c3                   	ret    

80101247 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101247:	f3 0f 1e fb          	endbr32 
8010124b:	55                   	push   %ebp
8010124c:	89 e5                	mov    %esp,%ebp
8010124e:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101251:	8b 45 08             	mov    0x8(%ebp),%eax
80101254:	8b 00                	mov    (%eax),%eax
80101256:	83 f8 02             	cmp    $0x2,%eax
80101259:	75 40                	jne    8010129b <filestat+0x54>
    ilock(f->ip);
8010125b:	8b 45 08             	mov    0x8(%ebp),%eax
8010125e:	8b 40 10             	mov    0x10(%eax),%eax
80101261:	83 ec 0c             	sub    $0xc,%esp
80101264:	50                   	push   %eax
80101265:	e8 71 08 00 00       	call   80101adb <ilock>
8010126a:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010126d:	8b 45 08             	mov    0x8(%ebp),%eax
80101270:	8b 40 10             	mov    0x10(%eax),%eax
80101273:	83 ec 08             	sub    $0x8,%esp
80101276:	ff 75 0c             	pushl  0xc(%ebp)
80101279:	50                   	push   %eax
8010127a:	e8 1a 0d 00 00       	call   80101f99 <stati>
8010127f:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101282:	8b 45 08             	mov    0x8(%ebp),%eax
80101285:	8b 40 10             	mov    0x10(%eax),%eax
80101288:	83 ec 0c             	sub    $0xc,%esp
8010128b:	50                   	push   %eax
8010128c:	e8 61 09 00 00       	call   80101bf2 <iunlock>
80101291:	83 c4 10             	add    $0x10,%esp
    return 0;
80101294:	b8 00 00 00 00       	mov    $0x0,%eax
80101299:	eb 05                	jmp    801012a0 <filestat+0x59>
  }
  return -1;
8010129b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012a0:	c9                   	leave  
801012a1:	c3                   	ret    

801012a2 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012a2:	f3 0f 1e fb          	endbr32 
801012a6:	55                   	push   %ebp
801012a7:	89 e5                	mov    %esp,%ebp
801012a9:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801012ac:	8b 45 08             	mov    0x8(%ebp),%eax
801012af:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801012b3:	84 c0                	test   %al,%al
801012b5:	75 0a                	jne    801012c1 <fileread+0x1f>
    return -1;
801012b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012bc:	e9 9b 00 00 00       	jmp    8010135c <fileread+0xba>
  if(f->type == FD_PIPE)
801012c1:	8b 45 08             	mov    0x8(%ebp),%eax
801012c4:	8b 00                	mov    (%eax),%eax
801012c6:	83 f8 01             	cmp    $0x1,%eax
801012c9:	75 1a                	jne    801012e5 <fileread+0x43>
    return piperead(f->pipe, addr, n);
801012cb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ce:	8b 40 0c             	mov    0xc(%eax),%eax
801012d1:	83 ec 04             	sub    $0x4,%esp
801012d4:	ff 75 10             	pushl  0x10(%ebp)
801012d7:	ff 75 0c             	pushl  0xc(%ebp)
801012da:	50                   	push   %eax
801012db:	e8 db 2f 00 00       	call   801042bb <piperead>
801012e0:	83 c4 10             	add    $0x10,%esp
801012e3:	eb 77                	jmp    8010135c <fileread+0xba>
  if(f->type == FD_INODE){
801012e5:	8b 45 08             	mov    0x8(%ebp),%eax
801012e8:	8b 00                	mov    (%eax),%eax
801012ea:	83 f8 02             	cmp    $0x2,%eax
801012ed:	75 60                	jne    8010134f <fileread+0xad>
    ilock(f->ip);
801012ef:	8b 45 08             	mov    0x8(%ebp),%eax
801012f2:	8b 40 10             	mov    0x10(%eax),%eax
801012f5:	83 ec 0c             	sub    $0xc,%esp
801012f8:	50                   	push   %eax
801012f9:	e8 dd 07 00 00       	call   80101adb <ilock>
801012fe:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101301:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101304:	8b 45 08             	mov    0x8(%ebp),%eax
80101307:	8b 50 14             	mov    0x14(%eax),%edx
8010130a:	8b 45 08             	mov    0x8(%ebp),%eax
8010130d:	8b 40 10             	mov    0x10(%eax),%eax
80101310:	51                   	push   %ecx
80101311:	52                   	push   %edx
80101312:	ff 75 0c             	pushl  0xc(%ebp)
80101315:	50                   	push   %eax
80101316:	e8 c8 0c 00 00       	call   80101fe3 <readi>
8010131b:	83 c4 10             	add    $0x10,%esp
8010131e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101321:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101325:	7e 11                	jle    80101338 <fileread+0x96>
      f->off += r;
80101327:	8b 45 08             	mov    0x8(%ebp),%eax
8010132a:	8b 50 14             	mov    0x14(%eax),%edx
8010132d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101330:	01 c2                	add    %eax,%edx
80101332:	8b 45 08             	mov    0x8(%ebp),%eax
80101335:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101338:	8b 45 08             	mov    0x8(%ebp),%eax
8010133b:	8b 40 10             	mov    0x10(%eax),%eax
8010133e:	83 ec 0c             	sub    $0xc,%esp
80101341:	50                   	push   %eax
80101342:	e8 ab 08 00 00       	call   80101bf2 <iunlock>
80101347:	83 c4 10             	add    $0x10,%esp
    return r;
8010134a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010134d:	eb 0d                	jmp    8010135c <fileread+0xba>
  }
  panic("fileread");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 22 90 10 80       	push   $0x80109022
80101357:	e8 ac f2 ff ff       	call   80100608 <panic>
}
8010135c:	c9                   	leave  
8010135d:	c3                   	ret    

8010135e <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010135e:	f3 0f 1e fb          	endbr32 
80101362:	55                   	push   %ebp
80101363:	89 e5                	mov    %esp,%ebp
80101365:	53                   	push   %ebx
80101366:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101369:	8b 45 08             	mov    0x8(%ebp),%eax
8010136c:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101370:	84 c0                	test   %al,%al
80101372:	75 0a                	jne    8010137e <filewrite+0x20>
    return -1;
80101374:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101379:	e9 1b 01 00 00       	jmp    80101499 <filewrite+0x13b>
  if(f->type == FD_PIPE)
8010137e:	8b 45 08             	mov    0x8(%ebp),%eax
80101381:	8b 00                	mov    (%eax),%eax
80101383:	83 f8 01             	cmp    $0x1,%eax
80101386:	75 1d                	jne    801013a5 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
80101388:	8b 45 08             	mov    0x8(%ebp),%eax
8010138b:	8b 40 0c             	mov    0xc(%eax),%eax
8010138e:	83 ec 04             	sub    $0x4,%esp
80101391:	ff 75 10             	pushl  0x10(%ebp)
80101394:	ff 75 0c             	pushl  0xc(%ebp)
80101397:	50                   	push   %eax
80101398:	e8 18 2e 00 00       	call   801041b5 <pipewrite>
8010139d:	83 c4 10             	add    $0x10,%esp
801013a0:	e9 f4 00 00 00       	jmp    80101499 <filewrite+0x13b>
  if(f->type == FD_INODE){
801013a5:	8b 45 08             	mov    0x8(%ebp),%eax
801013a8:	8b 00                	mov    (%eax),%eax
801013aa:	83 f8 02             	cmp    $0x2,%eax
801013ad:	0f 85 d9 00 00 00    	jne    8010148c <filewrite+0x12e>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
801013b3:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801013ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801013c1:	e9 a3 00 00 00       	jmp    80101469 <filewrite+0x10b>
      int n1 = n - i;
801013c6:	8b 45 10             	mov    0x10(%ebp),%eax
801013c9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801013cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801013cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013d2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801013d5:	7e 06                	jle    801013dd <filewrite+0x7f>
        n1 = max;
801013d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801013da:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801013dd:	e8 ee 22 00 00       	call   801036d0 <begin_op>
      ilock(f->ip);
801013e2:	8b 45 08             	mov    0x8(%ebp),%eax
801013e5:	8b 40 10             	mov    0x10(%eax),%eax
801013e8:	83 ec 0c             	sub    $0xc,%esp
801013eb:	50                   	push   %eax
801013ec:	e8 ea 06 00 00       	call   80101adb <ilock>
801013f1:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801013f4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801013f7:	8b 45 08             	mov    0x8(%ebp),%eax
801013fa:	8b 50 14             	mov    0x14(%eax),%edx
801013fd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101400:	8b 45 0c             	mov    0xc(%ebp),%eax
80101403:	01 c3                	add    %eax,%ebx
80101405:	8b 45 08             	mov    0x8(%ebp),%eax
80101408:	8b 40 10             	mov    0x10(%eax),%eax
8010140b:	51                   	push   %ecx
8010140c:	52                   	push   %edx
8010140d:	53                   	push   %ebx
8010140e:	50                   	push   %eax
8010140f:	e8 28 0d 00 00       	call   8010213c <writei>
80101414:	83 c4 10             	add    $0x10,%esp
80101417:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010141a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010141e:	7e 11                	jle    80101431 <filewrite+0xd3>
        f->off += r;
80101420:	8b 45 08             	mov    0x8(%ebp),%eax
80101423:	8b 50 14             	mov    0x14(%eax),%edx
80101426:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101429:	01 c2                	add    %eax,%edx
8010142b:	8b 45 08             	mov    0x8(%ebp),%eax
8010142e:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101431:	8b 45 08             	mov    0x8(%ebp),%eax
80101434:	8b 40 10             	mov    0x10(%eax),%eax
80101437:	83 ec 0c             	sub    $0xc,%esp
8010143a:	50                   	push   %eax
8010143b:	e8 b2 07 00 00       	call   80101bf2 <iunlock>
80101440:	83 c4 10             	add    $0x10,%esp
      end_op();
80101443:	e8 18 23 00 00       	call   80103760 <end_op>

      if(r < 0)
80101448:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010144c:	78 29                	js     80101477 <filewrite+0x119>
        break;
      if(r != n1)
8010144e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101451:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101454:	74 0d                	je     80101463 <filewrite+0x105>
        panic("short filewrite");
80101456:	83 ec 0c             	sub    $0xc,%esp
80101459:	68 2b 90 10 80       	push   $0x8010902b
8010145e:	e8 a5 f1 ff ff       	call   80100608 <panic>
      i += r;
80101463:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101466:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
80101469:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010146c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010146f:	0f 8c 51 ff ff ff    	jl     801013c6 <filewrite+0x68>
80101475:	eb 01                	jmp    80101478 <filewrite+0x11a>
        break;
80101477:	90                   	nop
    }
    return i == n ? n : -1;
80101478:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010147b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010147e:	75 05                	jne    80101485 <filewrite+0x127>
80101480:	8b 45 10             	mov    0x10(%ebp),%eax
80101483:	eb 14                	jmp    80101499 <filewrite+0x13b>
80101485:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010148a:	eb 0d                	jmp    80101499 <filewrite+0x13b>
  }
  panic("filewrite");
8010148c:	83 ec 0c             	sub    $0xc,%esp
8010148f:	68 3b 90 10 80       	push   $0x8010903b
80101494:	e8 6f f1 ff ff       	call   80100608 <panic>
}
80101499:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010149c:	c9                   	leave  
8010149d:	c3                   	ret    

8010149e <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010149e:	f3 0f 1e fb          	endbr32 
801014a2:	55                   	push   %ebp
801014a3:	89 e5                	mov    %esp,%ebp
801014a5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801014a8:	8b 45 08             	mov    0x8(%ebp),%eax
801014ab:	83 ec 08             	sub    $0x8,%esp
801014ae:	6a 01                	push   $0x1
801014b0:	50                   	push   %eax
801014b1:	e8 21 ed ff ff       	call   801001d7 <bread>
801014b6:	83 c4 10             	add    $0x10,%esp
801014b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801014bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014bf:	83 c0 5c             	add    $0x5c,%eax
801014c2:	83 ec 04             	sub    $0x4,%esp
801014c5:	6a 1c                	push   $0x1c
801014c7:	50                   	push   %eax
801014c8:	ff 75 0c             	pushl  0xc(%ebp)
801014cb:	e8 7c 40 00 00       	call   8010554c <memmove>
801014d0:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014d3:	83 ec 0c             	sub    $0xc,%esp
801014d6:	ff 75 f4             	pushl  -0xc(%ebp)
801014d9:	e8 83 ed ff ff       	call   80100261 <brelse>
801014de:	83 c4 10             	add    $0x10,%esp
}
801014e1:	90                   	nop
801014e2:	c9                   	leave  
801014e3:	c3                   	ret    

801014e4 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801014e4:	f3 0f 1e fb          	endbr32 
801014e8:	55                   	push   %ebp
801014e9:	89 e5                	mov    %esp,%ebp
801014eb:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
801014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
801014f1:	8b 45 08             	mov    0x8(%ebp),%eax
801014f4:	83 ec 08             	sub    $0x8,%esp
801014f7:	52                   	push   %edx
801014f8:	50                   	push   %eax
801014f9:	e8 d9 ec ff ff       	call   801001d7 <bread>
801014fe:	83 c4 10             	add    $0x10,%esp
80101501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101507:	83 c0 5c             	add    $0x5c,%eax
8010150a:	83 ec 04             	sub    $0x4,%esp
8010150d:	68 00 02 00 00       	push   $0x200
80101512:	6a 00                	push   $0x0
80101514:	50                   	push   %eax
80101515:	e8 6b 3f 00 00       	call   80105485 <memset>
8010151a:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010151d:	83 ec 0c             	sub    $0xc,%esp
80101520:	ff 75 f4             	pushl  -0xc(%ebp)
80101523:	e8 f1 23 00 00       	call   80103919 <log_write>
80101528:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010152b:	83 ec 0c             	sub    $0xc,%esp
8010152e:	ff 75 f4             	pushl  -0xc(%ebp)
80101531:	e8 2b ed ff ff       	call   80100261 <brelse>
80101536:	83 c4 10             	add    $0x10,%esp
}
80101539:	90                   	nop
8010153a:	c9                   	leave  
8010153b:	c3                   	ret    

8010153c <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010153c:	f3 0f 1e fb          	endbr32 
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101546:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010154d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101554:	e9 13 01 00 00       	jmp    8010166c <balloc+0x130>
    bp = bread(dev, BBLOCK(b, sb));
80101559:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010155c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101562:	85 c0                	test   %eax,%eax
80101564:	0f 48 c2             	cmovs  %edx,%eax
80101567:	c1 f8 0c             	sar    $0xc,%eax
8010156a:	89 c2                	mov    %eax,%edx
8010156c:	a1 78 2a 11 80       	mov    0x80112a78,%eax
80101571:	01 d0                	add    %edx,%eax
80101573:	83 ec 08             	sub    $0x8,%esp
80101576:	50                   	push   %eax
80101577:	ff 75 08             	pushl  0x8(%ebp)
8010157a:	e8 58 ec ff ff       	call   801001d7 <bread>
8010157f:	83 c4 10             	add    $0x10,%esp
80101582:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101585:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010158c:	e9 a6 00 00 00       	jmp    80101637 <balloc+0xfb>
      m = 1 << (bi % 8);
80101591:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101594:	99                   	cltd   
80101595:	c1 ea 1d             	shr    $0x1d,%edx
80101598:	01 d0                	add    %edx,%eax
8010159a:	83 e0 07             	and    $0x7,%eax
8010159d:	29 d0                	sub    %edx,%eax
8010159f:	ba 01 00 00 00       	mov    $0x1,%edx
801015a4:	89 c1                	mov    %eax,%ecx
801015a6:	d3 e2                	shl    %cl,%edx
801015a8:	89 d0                	mov    %edx,%eax
801015aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b0:	8d 50 07             	lea    0x7(%eax),%edx
801015b3:	85 c0                	test   %eax,%eax
801015b5:	0f 48 c2             	cmovs  %edx,%eax
801015b8:	c1 f8 03             	sar    $0x3,%eax
801015bb:	89 c2                	mov    %eax,%edx
801015bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015c0:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801015c5:	0f b6 c0             	movzbl %al,%eax
801015c8:	23 45 e8             	and    -0x18(%ebp),%eax
801015cb:	85 c0                	test   %eax,%eax
801015cd:	75 64                	jne    80101633 <balloc+0xf7>
        bp->data[bi/8] |= m;  // Mark block in use.
801015cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015d2:	8d 50 07             	lea    0x7(%eax),%edx
801015d5:	85 c0                	test   %eax,%eax
801015d7:	0f 48 c2             	cmovs  %edx,%eax
801015da:	c1 f8 03             	sar    $0x3,%eax
801015dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
801015e0:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
801015e5:	89 d1                	mov    %edx,%ecx
801015e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
801015ea:	09 ca                	or     %ecx,%edx
801015ec:	89 d1                	mov    %edx,%ecx
801015ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
801015f1:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
801015f5:	83 ec 0c             	sub    $0xc,%esp
801015f8:	ff 75 ec             	pushl  -0x14(%ebp)
801015fb:	e8 19 23 00 00       	call   80103919 <log_write>
80101600:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101603:	83 ec 0c             	sub    $0xc,%esp
80101606:	ff 75 ec             	pushl  -0x14(%ebp)
80101609:	e8 53 ec ff ff       	call   80100261 <brelse>
8010160e:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101611:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101614:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101617:	01 c2                	add    %eax,%edx
80101619:	8b 45 08             	mov    0x8(%ebp),%eax
8010161c:	83 ec 08             	sub    $0x8,%esp
8010161f:	52                   	push   %edx
80101620:	50                   	push   %eax
80101621:	e8 be fe ff ff       	call   801014e4 <bzero>
80101626:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101629:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010162c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010162f:	01 d0                	add    %edx,%eax
80101631:	eb 57                	jmp    8010168a <balloc+0x14e>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101633:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101637:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010163e:	7f 17                	jg     80101657 <balloc+0x11b>
80101640:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101643:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101646:	01 d0                	add    %edx,%eax
80101648:	89 c2                	mov    %eax,%edx
8010164a:	a1 60 2a 11 80       	mov    0x80112a60,%eax
8010164f:	39 c2                	cmp    %eax,%edx
80101651:	0f 82 3a ff ff ff    	jb     80101591 <balloc+0x55>
      }
    }
    brelse(bp);
80101657:	83 ec 0c             	sub    $0xc,%esp
8010165a:	ff 75 ec             	pushl  -0x14(%ebp)
8010165d:	e8 ff eb ff ff       	call   80100261 <brelse>
80101662:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
80101665:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010166c:	8b 15 60 2a 11 80    	mov    0x80112a60,%edx
80101672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101675:	39 c2                	cmp    %eax,%edx
80101677:	0f 87 dc fe ff ff    	ja     80101559 <balloc+0x1d>
  }
  panic("balloc: out of blocks");
8010167d:	83 ec 0c             	sub    $0xc,%esp
80101680:	68 48 90 10 80       	push   $0x80109048
80101685:	e8 7e ef ff ff       	call   80100608 <panic>
}
8010168a:	c9                   	leave  
8010168b:	c3                   	ret    

8010168c <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010168c:	f3 0f 1e fb          	endbr32 
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101696:	8b 45 0c             	mov    0xc(%ebp),%eax
80101699:	c1 e8 0c             	shr    $0xc,%eax
8010169c:	89 c2                	mov    %eax,%edx
8010169e:	a1 78 2a 11 80       	mov    0x80112a78,%eax
801016a3:	01 c2                	add    %eax,%edx
801016a5:	8b 45 08             	mov    0x8(%ebp),%eax
801016a8:	83 ec 08             	sub    $0x8,%esp
801016ab:	52                   	push   %edx
801016ac:	50                   	push   %eax
801016ad:	e8 25 eb ff ff       	call   801001d7 <bread>
801016b2:	83 c4 10             	add    $0x10,%esp
801016b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801016b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801016bb:	25 ff 0f 00 00       	and    $0xfff,%eax
801016c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801016c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016c6:	99                   	cltd   
801016c7:	c1 ea 1d             	shr    $0x1d,%edx
801016ca:	01 d0                	add    %edx,%eax
801016cc:	83 e0 07             	and    $0x7,%eax
801016cf:	29 d0                	sub    %edx,%eax
801016d1:	ba 01 00 00 00       	mov    $0x1,%edx
801016d6:	89 c1                	mov    %eax,%ecx
801016d8:	d3 e2                	shl    %cl,%edx
801016da:	89 d0                	mov    %edx,%eax
801016dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016e2:	8d 50 07             	lea    0x7(%eax),%edx
801016e5:	85 c0                	test   %eax,%eax
801016e7:	0f 48 c2             	cmovs  %edx,%eax
801016ea:	c1 f8 03             	sar    $0x3,%eax
801016ed:	89 c2                	mov    %eax,%edx
801016ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f2:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801016f7:	0f b6 c0             	movzbl %al,%eax
801016fa:	23 45 ec             	and    -0x14(%ebp),%eax
801016fd:	85 c0                	test   %eax,%eax
801016ff:	75 0d                	jne    8010170e <bfree+0x82>
    panic("freeing free block");
80101701:	83 ec 0c             	sub    $0xc,%esp
80101704:	68 5e 90 10 80       	push   $0x8010905e
80101709:	e8 fa ee ff ff       	call   80100608 <panic>
  bp->data[bi/8] &= ~m;
8010170e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101711:	8d 50 07             	lea    0x7(%eax),%edx
80101714:	85 c0                	test   %eax,%eax
80101716:	0f 48 c2             	cmovs  %edx,%eax
80101719:	c1 f8 03             	sar    $0x3,%eax
8010171c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010171f:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101724:	89 d1                	mov    %edx,%ecx
80101726:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101729:	f7 d2                	not    %edx
8010172b:	21 ca                	and    %ecx,%edx
8010172d:	89 d1                	mov    %edx,%ecx
8010172f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101732:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101736:	83 ec 0c             	sub    $0xc,%esp
80101739:	ff 75 f4             	pushl  -0xc(%ebp)
8010173c:	e8 d8 21 00 00       	call   80103919 <log_write>
80101741:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101744:	83 ec 0c             	sub    $0xc,%esp
80101747:	ff 75 f4             	pushl  -0xc(%ebp)
8010174a:	e8 12 eb ff ff       	call   80100261 <brelse>
8010174f:	83 c4 10             	add    $0x10,%esp
}
80101752:	90                   	nop
80101753:	c9                   	leave  
80101754:	c3                   	ret    

80101755 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101755:	f3 0f 1e fb          	endbr32 
80101759:	55                   	push   %ebp
8010175a:	89 e5                	mov    %esp,%ebp
8010175c:	57                   	push   %edi
8010175d:	56                   	push   %esi
8010175e:	53                   	push   %ebx
8010175f:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
80101762:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
80101769:	83 ec 08             	sub    $0x8,%esp
8010176c:	68 71 90 10 80       	push   $0x80109071
80101771:	68 80 2a 11 80       	push   $0x80112a80
80101776:	e8 45 3a 00 00       	call   801051c0 <initlock>
8010177b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
8010177e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101785:	eb 2d                	jmp    801017b4 <iinit+0x5f>
    initsleeplock(&icache.inode[i].lock, "inode");
80101787:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010178a:	89 d0                	mov    %edx,%eax
8010178c:	c1 e0 03             	shl    $0x3,%eax
8010178f:	01 d0                	add    %edx,%eax
80101791:	c1 e0 04             	shl    $0x4,%eax
80101794:	83 c0 30             	add    $0x30,%eax
80101797:	05 80 2a 11 80       	add    $0x80112a80,%eax
8010179c:	83 c0 10             	add    $0x10,%eax
8010179f:	83 ec 08             	sub    $0x8,%esp
801017a2:	68 78 90 10 80       	push   $0x80109078
801017a7:	50                   	push   %eax
801017a8:	e8 80 38 00 00       	call   8010502d <initsleeplock>
801017ad:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801017b0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801017b4:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801017b8:	7e cd                	jle    80101787 <iinit+0x32>
  }

  readsb(dev, &sb);
801017ba:	83 ec 08             	sub    $0x8,%esp
801017bd:	68 60 2a 11 80       	push   $0x80112a60
801017c2:	ff 75 08             	pushl  0x8(%ebp)
801017c5:	e8 d4 fc ff ff       	call   8010149e <readsb>
801017ca:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801017cd:	a1 78 2a 11 80       	mov    0x80112a78,%eax
801017d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801017d5:	8b 3d 74 2a 11 80    	mov    0x80112a74,%edi
801017db:	8b 35 70 2a 11 80    	mov    0x80112a70,%esi
801017e1:	8b 1d 6c 2a 11 80    	mov    0x80112a6c,%ebx
801017e7:	8b 0d 68 2a 11 80    	mov    0x80112a68,%ecx
801017ed:	8b 15 64 2a 11 80    	mov    0x80112a64,%edx
801017f3:	a1 60 2a 11 80       	mov    0x80112a60,%eax
801017f8:	ff 75 d4             	pushl  -0x2c(%ebp)
801017fb:	57                   	push   %edi
801017fc:	56                   	push   %esi
801017fd:	53                   	push   %ebx
801017fe:	51                   	push   %ecx
801017ff:	52                   	push   %edx
80101800:	50                   	push   %eax
80101801:	68 80 90 10 80       	push   $0x80109080
80101806:	e8 0d ec ff ff       	call   80100418 <cprintf>
8010180b:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010180e:	90                   	nop
8010180f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101812:	5b                   	pop    %ebx
80101813:	5e                   	pop    %esi
80101814:	5f                   	pop    %edi
80101815:	5d                   	pop    %ebp
80101816:	c3                   	ret    

80101817 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101817:	f3 0f 1e fb          	endbr32 
8010181b:	55                   	push   %ebp
8010181c:	89 e5                	mov    %esp,%ebp
8010181e:	83 ec 28             	sub    $0x28,%esp
80101821:	8b 45 0c             	mov    0xc(%ebp),%eax
80101824:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101828:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010182f:	e9 9e 00 00 00       	jmp    801018d2 <ialloc+0xbb>
    bp = bread(dev, IBLOCK(inum, sb));
80101834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101837:	c1 e8 03             	shr    $0x3,%eax
8010183a:	89 c2                	mov    %eax,%edx
8010183c:	a1 74 2a 11 80       	mov    0x80112a74,%eax
80101841:	01 d0                	add    %edx,%eax
80101843:	83 ec 08             	sub    $0x8,%esp
80101846:	50                   	push   %eax
80101847:	ff 75 08             	pushl  0x8(%ebp)
8010184a:	e8 88 e9 ff ff       	call   801001d7 <bread>
8010184f:	83 c4 10             	add    $0x10,%esp
80101852:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101855:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101858:	8d 50 5c             	lea    0x5c(%eax),%edx
8010185b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185e:	83 e0 07             	and    $0x7,%eax
80101861:	c1 e0 06             	shl    $0x6,%eax
80101864:	01 d0                	add    %edx,%eax
80101866:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101869:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010186c:	0f b7 00             	movzwl (%eax),%eax
8010186f:	66 85 c0             	test   %ax,%ax
80101872:	75 4c                	jne    801018c0 <ialloc+0xa9>
      memset(dip, 0, sizeof(*dip));
80101874:	83 ec 04             	sub    $0x4,%esp
80101877:	6a 40                	push   $0x40
80101879:	6a 00                	push   $0x0
8010187b:	ff 75 ec             	pushl  -0x14(%ebp)
8010187e:	e8 02 3c 00 00       	call   80105485 <memset>
80101883:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101886:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101889:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010188d:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101890:	83 ec 0c             	sub    $0xc,%esp
80101893:	ff 75 f0             	pushl  -0x10(%ebp)
80101896:	e8 7e 20 00 00       	call   80103919 <log_write>
8010189b:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010189e:	83 ec 0c             	sub    $0xc,%esp
801018a1:	ff 75 f0             	pushl  -0x10(%ebp)
801018a4:	e8 b8 e9 ff ff       	call   80100261 <brelse>
801018a9:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018af:	83 ec 08             	sub    $0x8,%esp
801018b2:	50                   	push   %eax
801018b3:	ff 75 08             	pushl  0x8(%ebp)
801018b6:	e8 fc 00 00 00       	call   801019b7 <iget>
801018bb:	83 c4 10             	add    $0x10,%esp
801018be:	eb 30                	jmp    801018f0 <ialloc+0xd9>
    }
    brelse(bp);
801018c0:	83 ec 0c             	sub    $0xc,%esp
801018c3:	ff 75 f0             	pushl  -0x10(%ebp)
801018c6:	e8 96 e9 ff ff       	call   80100261 <brelse>
801018cb:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801018ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801018d2:	8b 15 68 2a 11 80    	mov    0x80112a68,%edx
801018d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018db:	39 c2                	cmp    %eax,%edx
801018dd:	0f 87 51 ff ff ff    	ja     80101834 <ialloc+0x1d>
  }
  panic("ialloc: no inodes");
801018e3:	83 ec 0c             	sub    $0xc,%esp
801018e6:	68 d3 90 10 80       	push   $0x801090d3
801018eb:	e8 18 ed ff ff       	call   80100608 <panic>
}
801018f0:	c9                   	leave  
801018f1:	c3                   	ret    

801018f2 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801018f2:	f3 0f 1e fb          	endbr32 
801018f6:	55                   	push   %ebp
801018f7:	89 e5                	mov    %esp,%ebp
801018f9:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018fc:	8b 45 08             	mov    0x8(%ebp),%eax
801018ff:	8b 40 04             	mov    0x4(%eax),%eax
80101902:	c1 e8 03             	shr    $0x3,%eax
80101905:	89 c2                	mov    %eax,%edx
80101907:	a1 74 2a 11 80       	mov    0x80112a74,%eax
8010190c:	01 c2                	add    %eax,%edx
8010190e:	8b 45 08             	mov    0x8(%ebp),%eax
80101911:	8b 00                	mov    (%eax),%eax
80101913:	83 ec 08             	sub    $0x8,%esp
80101916:	52                   	push   %edx
80101917:	50                   	push   %eax
80101918:	e8 ba e8 ff ff       	call   801001d7 <bread>
8010191d:	83 c4 10             	add    $0x10,%esp
80101920:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101926:	8d 50 5c             	lea    0x5c(%eax),%edx
80101929:	8b 45 08             	mov    0x8(%ebp),%eax
8010192c:	8b 40 04             	mov    0x4(%eax),%eax
8010192f:	83 e0 07             	and    $0x7,%eax
80101932:	c1 e0 06             	shl    $0x6,%eax
80101935:	01 d0                	add    %edx,%eax
80101937:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010193a:	8b 45 08             	mov    0x8(%ebp),%eax
8010193d:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101941:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101944:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101947:	8b 45 08             	mov    0x8(%ebp),%eax
8010194a:	0f b7 50 52          	movzwl 0x52(%eax),%edx
8010194e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101951:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101955:	8b 45 08             	mov    0x8(%ebp),%eax
80101958:	0f b7 50 54          	movzwl 0x54(%eax),%edx
8010195c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010195f:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101963:	8b 45 08             	mov    0x8(%ebp),%eax
80101966:	0f b7 50 56          	movzwl 0x56(%eax),%edx
8010196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010196d:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101971:	8b 45 08             	mov    0x8(%ebp),%eax
80101974:	8b 50 58             	mov    0x58(%eax),%edx
80101977:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010197a:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010197d:	8b 45 08             	mov    0x8(%ebp),%eax
80101980:	8d 50 5c             	lea    0x5c(%eax),%edx
80101983:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101986:	83 c0 0c             	add    $0xc,%eax
80101989:	83 ec 04             	sub    $0x4,%esp
8010198c:	6a 34                	push   $0x34
8010198e:	52                   	push   %edx
8010198f:	50                   	push   %eax
80101990:	e8 b7 3b 00 00       	call   8010554c <memmove>
80101995:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101998:	83 ec 0c             	sub    $0xc,%esp
8010199b:	ff 75 f4             	pushl  -0xc(%ebp)
8010199e:	e8 76 1f 00 00       	call   80103919 <log_write>
801019a3:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801019a6:	83 ec 0c             	sub    $0xc,%esp
801019a9:	ff 75 f4             	pushl  -0xc(%ebp)
801019ac:	e8 b0 e8 ff ff       	call   80100261 <brelse>
801019b1:	83 c4 10             	add    $0x10,%esp
}
801019b4:	90                   	nop
801019b5:	c9                   	leave  
801019b6:	c3                   	ret    

801019b7 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019b7:	f3 0f 1e fb          	endbr32 
801019bb:	55                   	push   %ebp
801019bc:	89 e5                	mov    %esp,%ebp
801019be:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801019c1:	83 ec 0c             	sub    $0xc,%esp
801019c4:	68 80 2a 11 80       	push   $0x80112a80
801019c9:	e8 18 38 00 00       	call   801051e6 <acquire>
801019ce:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801019d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019d8:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
801019df:	eb 60                	jmp    80101a41 <iget+0x8a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801019e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019e4:	8b 40 08             	mov    0x8(%eax),%eax
801019e7:	85 c0                	test   %eax,%eax
801019e9:	7e 39                	jle    80101a24 <iget+0x6d>
801019eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ee:	8b 00                	mov    (%eax),%eax
801019f0:	39 45 08             	cmp    %eax,0x8(%ebp)
801019f3:	75 2f                	jne    80101a24 <iget+0x6d>
801019f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019f8:	8b 40 04             	mov    0x4(%eax),%eax
801019fb:	39 45 0c             	cmp    %eax,0xc(%ebp)
801019fe:	75 24                	jne    80101a24 <iget+0x6d>
      ip->ref++;
80101a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a03:	8b 40 08             	mov    0x8(%eax),%eax
80101a06:	8d 50 01             	lea    0x1(%eax),%edx
80101a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a0c:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101a0f:	83 ec 0c             	sub    $0xc,%esp
80101a12:	68 80 2a 11 80       	push   $0x80112a80
80101a17:	e8 3c 38 00 00       	call   80105258 <release>
80101a1c:	83 c4 10             	add    $0x10,%esp
      return ip;
80101a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a22:	eb 77                	jmp    80101a9b <iget+0xe4>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a28:	75 10                	jne    80101a3a <iget+0x83>
80101a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a2d:	8b 40 08             	mov    0x8(%eax),%eax
80101a30:	85 c0                	test   %eax,%eax
80101a32:	75 06                	jne    80101a3a <iget+0x83>
      empty = ip;
80101a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a3a:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101a41:	81 7d f4 d4 46 11 80 	cmpl   $0x801146d4,-0xc(%ebp)
80101a48:	72 97                	jb     801019e1 <iget+0x2a>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a4e:	75 0d                	jne    80101a5d <iget+0xa6>
    panic("iget: no inodes");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 e5 90 10 80       	push   $0x801090e5
80101a58:	e8 ab eb ff ff       	call   80100608 <panic>

  ip = empty;
80101a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a66:	8b 55 08             	mov    0x8(%ebp),%edx
80101a69:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a6e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101a71:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a77:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a81:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101a88:	83 ec 0c             	sub    $0xc,%esp
80101a8b:	68 80 2a 11 80       	push   $0x80112a80
80101a90:	e8 c3 37 00 00       	call   80105258 <release>
80101a95:	83 c4 10             	add    $0x10,%esp

  return ip;
80101a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101a9b:	c9                   	leave  
80101a9c:	c3                   	ret    

80101a9d <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101a9d:	f3 0f 1e fb          	endbr32 
80101aa1:	55                   	push   %ebp
80101aa2:	89 e5                	mov    %esp,%ebp
80101aa4:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101aa7:	83 ec 0c             	sub    $0xc,%esp
80101aaa:	68 80 2a 11 80       	push   $0x80112a80
80101aaf:	e8 32 37 00 00       	call   801051e6 <acquire>
80101ab4:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aba:	8b 40 08             	mov    0x8(%eax),%eax
80101abd:	8d 50 01             	lea    0x1(%eax),%edx
80101ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac3:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ac6:	83 ec 0c             	sub    $0xc,%esp
80101ac9:	68 80 2a 11 80       	push   $0x80112a80
80101ace:	e8 85 37 00 00       	call   80105258 <release>
80101ad3:	83 c4 10             	add    $0x10,%esp
  return ip;
80101ad6:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ad9:	c9                   	leave  
80101ada:	c3                   	ret    

80101adb <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101adb:	f3 0f 1e fb          	endbr32 
80101adf:	55                   	push   %ebp
80101ae0:	89 e5                	mov    %esp,%ebp
80101ae2:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101ae5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101ae9:	74 0a                	je     80101af5 <ilock+0x1a>
80101aeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101aee:	8b 40 08             	mov    0x8(%eax),%eax
80101af1:	85 c0                	test   %eax,%eax
80101af3:	7f 0d                	jg     80101b02 <ilock+0x27>
    panic("ilock");
80101af5:	83 ec 0c             	sub    $0xc,%esp
80101af8:	68 f5 90 10 80       	push   $0x801090f5
80101afd:	e8 06 eb ff ff       	call   80100608 <panic>

  acquiresleep(&ip->lock);
80101b02:	8b 45 08             	mov    0x8(%ebp),%eax
80101b05:	83 c0 0c             	add    $0xc,%eax
80101b08:	83 ec 0c             	sub    $0xc,%esp
80101b0b:	50                   	push   %eax
80101b0c:	e8 5c 35 00 00       	call   8010506d <acquiresleep>
80101b11:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101b14:	8b 45 08             	mov    0x8(%ebp),%eax
80101b17:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b1a:	85 c0                	test   %eax,%eax
80101b1c:	0f 85 cd 00 00 00    	jne    80101bef <ilock+0x114>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b22:	8b 45 08             	mov    0x8(%ebp),%eax
80101b25:	8b 40 04             	mov    0x4(%eax),%eax
80101b28:	c1 e8 03             	shr    $0x3,%eax
80101b2b:	89 c2                	mov    %eax,%edx
80101b2d:	a1 74 2a 11 80       	mov    0x80112a74,%eax
80101b32:	01 c2                	add    %eax,%edx
80101b34:	8b 45 08             	mov    0x8(%ebp),%eax
80101b37:	8b 00                	mov    (%eax),%eax
80101b39:	83 ec 08             	sub    $0x8,%esp
80101b3c:	52                   	push   %edx
80101b3d:	50                   	push   %eax
80101b3e:	e8 94 e6 ff ff       	call   801001d7 <bread>
80101b43:	83 c4 10             	add    $0x10,%esp
80101b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b4c:	8d 50 5c             	lea    0x5c(%eax),%edx
80101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b52:	8b 40 04             	mov    0x4(%eax),%eax
80101b55:	83 e0 07             	and    $0x7,%eax
80101b58:	c1 e0 06             	shl    $0x6,%eax
80101b5b:	01 d0                	add    %edx,%eax
80101b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b63:	0f b7 10             	movzwl (%eax),%edx
80101b66:	8b 45 08             	mov    0x8(%ebp),%eax
80101b69:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b70:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101b74:	8b 45 08             	mov    0x8(%ebp),%eax
80101b77:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b7e:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101b82:	8b 45 08             	mov    0x8(%ebp),%eax
80101b85:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b8c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101b90:	8b 45 08             	mov    0x8(%ebp),%eax
80101b93:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b9a:	8b 50 08             	mov    0x8(%eax),%edx
80101b9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba0:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ba6:	8d 50 0c             	lea    0xc(%eax),%edx
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	83 c0 5c             	add    $0x5c,%eax
80101baf:	83 ec 04             	sub    $0x4,%esp
80101bb2:	6a 34                	push   $0x34
80101bb4:	52                   	push   %edx
80101bb5:	50                   	push   %eax
80101bb6:	e8 91 39 00 00       	call   8010554c <memmove>
80101bbb:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101bbe:	83 ec 0c             	sub    $0xc,%esp
80101bc1:	ff 75 f4             	pushl  -0xc(%ebp)
80101bc4:	e8 98 e6 ff ff       	call   80100261 <brelse>
80101bc9:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcf:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd9:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101bdd:	66 85 c0             	test   %ax,%ax
80101be0:	75 0d                	jne    80101bef <ilock+0x114>
      panic("ilock: no type");
80101be2:	83 ec 0c             	sub    $0xc,%esp
80101be5:	68 fb 90 10 80       	push   $0x801090fb
80101bea:	e8 19 ea ff ff       	call   80100608 <panic>
  }
}
80101bef:	90                   	nop
80101bf0:	c9                   	leave  
80101bf1:	c3                   	ret    

80101bf2 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101bf2:	f3 0f 1e fb          	endbr32 
80101bf6:	55                   	push   %ebp
80101bf7:	89 e5                	mov    %esp,%ebp
80101bf9:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101bfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c00:	74 20                	je     80101c22 <iunlock+0x30>
80101c02:	8b 45 08             	mov    0x8(%ebp),%eax
80101c05:	83 c0 0c             	add    $0xc,%eax
80101c08:	83 ec 0c             	sub    $0xc,%esp
80101c0b:	50                   	push   %eax
80101c0c:	e8 16 35 00 00       	call   80105127 <holdingsleep>
80101c11:	83 c4 10             	add    $0x10,%esp
80101c14:	85 c0                	test   %eax,%eax
80101c16:	74 0a                	je     80101c22 <iunlock+0x30>
80101c18:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1b:	8b 40 08             	mov    0x8(%eax),%eax
80101c1e:	85 c0                	test   %eax,%eax
80101c20:	7f 0d                	jg     80101c2f <iunlock+0x3d>
    panic("iunlock");
80101c22:	83 ec 0c             	sub    $0xc,%esp
80101c25:	68 0a 91 10 80       	push   $0x8010910a
80101c2a:	e8 d9 e9 ff ff       	call   80100608 <panic>

  releasesleep(&ip->lock);
80101c2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c32:	83 c0 0c             	add    $0xc,%eax
80101c35:	83 ec 0c             	sub    $0xc,%esp
80101c38:	50                   	push   %eax
80101c39:	e8 97 34 00 00       	call   801050d5 <releasesleep>
80101c3e:	83 c4 10             	add    $0x10,%esp
}
80101c41:	90                   	nop
80101c42:	c9                   	leave  
80101c43:	c3                   	ret    

80101c44 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101c44:	f3 0f 1e fb          	endbr32 
80101c48:	55                   	push   %ebp
80101c49:	89 e5                	mov    %esp,%ebp
80101c4b:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c51:	83 c0 0c             	add    $0xc,%eax
80101c54:	83 ec 0c             	sub    $0xc,%esp
80101c57:	50                   	push   %eax
80101c58:	e8 10 34 00 00       	call   8010506d <acquiresleep>
80101c5d:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101c60:	8b 45 08             	mov    0x8(%ebp),%eax
80101c63:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c66:	85 c0                	test   %eax,%eax
80101c68:	74 6a                	je     80101cd4 <iput+0x90>
80101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101c71:	66 85 c0             	test   %ax,%ax
80101c74:	75 5e                	jne    80101cd4 <iput+0x90>
    acquire(&icache.lock);
80101c76:	83 ec 0c             	sub    $0xc,%esp
80101c79:	68 80 2a 11 80       	push   $0x80112a80
80101c7e:	e8 63 35 00 00       	call   801051e6 <acquire>
80101c83:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101c86:	8b 45 08             	mov    0x8(%ebp),%eax
80101c89:	8b 40 08             	mov    0x8(%eax),%eax
80101c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101c8f:	83 ec 0c             	sub    $0xc,%esp
80101c92:	68 80 2a 11 80       	push   $0x80112a80
80101c97:	e8 bc 35 00 00       	call   80105258 <release>
80101c9c:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101c9f:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101ca3:	75 2f                	jne    80101cd4 <iput+0x90>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101ca5:	83 ec 0c             	sub    $0xc,%esp
80101ca8:	ff 75 08             	pushl  0x8(%ebp)
80101cab:	e8 b5 01 00 00       	call   80101e65 <itrunc>
80101cb0:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb6:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101cbc:	83 ec 0c             	sub    $0xc,%esp
80101cbf:	ff 75 08             	pushl  0x8(%ebp)
80101cc2:	e8 2b fc ff ff       	call   801018f2 <iupdate>
80101cc7:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101cca:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccd:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd7:	83 c0 0c             	add    $0xc,%eax
80101cda:	83 ec 0c             	sub    $0xc,%esp
80101cdd:	50                   	push   %eax
80101cde:	e8 f2 33 00 00       	call   801050d5 <releasesleep>
80101ce3:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101ce6:	83 ec 0c             	sub    $0xc,%esp
80101ce9:	68 80 2a 11 80       	push   $0x80112a80
80101cee:	e8 f3 34 00 00       	call   801051e6 <acquire>
80101cf3:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf9:	8b 40 08             	mov    0x8(%eax),%eax
80101cfc:	8d 50 ff             	lea    -0x1(%eax),%edx
80101cff:	8b 45 08             	mov    0x8(%ebp),%eax
80101d02:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101d05:	83 ec 0c             	sub    $0xc,%esp
80101d08:	68 80 2a 11 80       	push   $0x80112a80
80101d0d:	e8 46 35 00 00       	call   80105258 <release>
80101d12:	83 c4 10             	add    $0x10,%esp
}
80101d15:	90                   	nop
80101d16:	c9                   	leave  
80101d17:	c3                   	ret    

80101d18 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101d18:	f3 0f 1e fb          	endbr32 
80101d1c:	55                   	push   %ebp
80101d1d:	89 e5                	mov    %esp,%ebp
80101d1f:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101d22:	83 ec 0c             	sub    $0xc,%esp
80101d25:	ff 75 08             	pushl  0x8(%ebp)
80101d28:	e8 c5 fe ff ff       	call   80101bf2 <iunlock>
80101d2d:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101d30:	83 ec 0c             	sub    $0xc,%esp
80101d33:	ff 75 08             	pushl  0x8(%ebp)
80101d36:	e8 09 ff ff ff       	call   80101c44 <iput>
80101d3b:	83 c4 10             	add    $0x10,%esp
}
80101d3e:	90                   	nop
80101d3f:	c9                   	leave  
80101d40:	c3                   	ret    

80101d41 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d41:	f3 0f 1e fb          	endbr32 
80101d45:	55                   	push   %ebp
80101d46:	89 e5                	mov    %esp,%ebp
80101d48:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d4b:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101d4f:	77 42                	ja     80101d93 <bmap+0x52>
    if((addr = ip->addrs[bn]) == 0)
80101d51:	8b 45 08             	mov    0x8(%ebp),%eax
80101d54:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d57:	83 c2 14             	add    $0x14,%edx
80101d5a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d65:	75 24                	jne    80101d8b <bmap+0x4a>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d67:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6a:	8b 00                	mov    (%eax),%eax
80101d6c:	83 ec 0c             	sub    $0xc,%esp
80101d6f:	50                   	push   %eax
80101d70:	e8 c7 f7 ff ff       	call   8010153c <balloc>
80101d75:	83 c4 10             	add    $0x10,%esp
80101d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d81:	8d 4a 14             	lea    0x14(%edx),%ecx
80101d84:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d87:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d8e:	e9 d0 00 00 00       	jmp    80101e63 <bmap+0x122>
  }
  bn -= NDIRECT;
80101d93:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d97:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d9b:	0f 87 b5 00 00 00    	ja     80101e56 <bmap+0x115>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101da1:	8b 45 08             	mov    0x8(%ebp),%eax
80101da4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101daa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101db1:	75 20                	jne    80101dd3 <bmap+0x92>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101db3:	8b 45 08             	mov    0x8(%ebp),%eax
80101db6:	8b 00                	mov    (%eax),%eax
80101db8:	83 ec 0c             	sub    $0xc,%esp
80101dbb:	50                   	push   %eax
80101dbc:	e8 7b f7 ff ff       	call   8010153c <balloc>
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dca:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dcd:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101dd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd6:	8b 00                	mov    (%eax),%eax
80101dd8:	83 ec 08             	sub    $0x8,%esp
80101ddb:	ff 75 f4             	pushl  -0xc(%ebp)
80101dde:	50                   	push   %eax
80101ddf:	e8 f3 e3 ff ff       	call   801001d7 <bread>
80101de4:	83 c4 10             	add    $0x10,%esp
80101de7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ded:	83 c0 5c             	add    $0x5c,%eax
80101df0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101df3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101df6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e00:	01 d0                	add    %edx,%eax
80101e02:	8b 00                	mov    (%eax),%eax
80101e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e0b:	75 36                	jne    80101e43 <bmap+0x102>
      a[bn] = addr = balloc(ip->dev);
80101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e10:	8b 00                	mov    (%eax),%eax
80101e12:	83 ec 0c             	sub    $0xc,%esp
80101e15:	50                   	push   %eax
80101e16:	e8 21 f7 ff ff       	call   8010153c <balloc>
80101e1b:	83 c4 10             	add    $0x10,%esp
80101e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e21:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e2e:	01 c2                	add    %eax,%edx
80101e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e33:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101e35:	83 ec 0c             	sub    $0xc,%esp
80101e38:	ff 75 f0             	pushl  -0x10(%ebp)
80101e3b:	e8 d9 1a 00 00       	call   80103919 <log_write>
80101e40:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101e43:	83 ec 0c             	sub    $0xc,%esp
80101e46:	ff 75 f0             	pushl  -0x10(%ebp)
80101e49:	e8 13 e4 ff ff       	call   80100261 <brelse>
80101e4e:	83 c4 10             	add    $0x10,%esp
    return addr;
80101e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e54:	eb 0d                	jmp    80101e63 <bmap+0x122>
  }

  panic("bmap: out of range");
80101e56:	83 ec 0c             	sub    $0xc,%esp
80101e59:	68 12 91 10 80       	push   $0x80109112
80101e5e:	e8 a5 e7 ff ff       	call   80100608 <panic>
}
80101e63:	c9                   	leave  
80101e64:	c3                   	ret    

80101e65 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e65:	f3 0f 1e fb          	endbr32 
80101e69:	55                   	push   %ebp
80101e6a:	89 e5                	mov    %esp,%ebp
80101e6c:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e76:	eb 45                	jmp    80101ebd <itrunc+0x58>
    if(ip->addrs[i]){
80101e78:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e7e:	83 c2 14             	add    $0x14,%edx
80101e81:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e85:	85 c0                	test   %eax,%eax
80101e87:	74 30                	je     80101eb9 <itrunc+0x54>
      bfree(ip->dev, ip->addrs[i]);
80101e89:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e8f:	83 c2 14             	add    $0x14,%edx
80101e92:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e96:	8b 55 08             	mov    0x8(%ebp),%edx
80101e99:	8b 12                	mov    (%edx),%edx
80101e9b:	83 ec 08             	sub    $0x8,%esp
80101e9e:	50                   	push   %eax
80101e9f:	52                   	push   %edx
80101ea0:	e8 e7 f7 ff ff       	call   8010168c <bfree>
80101ea5:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eab:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101eae:	83 c2 14             	add    $0x14,%edx
80101eb1:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101eb8:	00 
  for(i = 0; i < NDIRECT; i++){
80101eb9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101ebd:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101ec1:	7e b5                	jle    80101e78 <itrunc+0x13>
    }
  }

  if(ip->addrs[NDIRECT]){
80101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec6:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ecc:	85 c0                	test   %eax,%eax
80101ece:	0f 84 aa 00 00 00    	je     80101f7e <itrunc+0x119>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ed4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed7:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101edd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee0:	8b 00                	mov    (%eax),%eax
80101ee2:	83 ec 08             	sub    $0x8,%esp
80101ee5:	52                   	push   %edx
80101ee6:	50                   	push   %eax
80101ee7:	e8 eb e2 ff ff       	call   801001d7 <bread>
80101eec:	83 c4 10             	add    $0x10,%esp
80101eef:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ef5:	83 c0 5c             	add    $0x5c,%eax
80101ef8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101efb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101f02:	eb 3c                	jmp    80101f40 <itrunc+0xdb>
      if(a[j])
80101f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f07:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f11:	01 d0                	add    %edx,%eax
80101f13:	8b 00                	mov    (%eax),%eax
80101f15:	85 c0                	test   %eax,%eax
80101f17:	74 23                	je     80101f3c <itrunc+0xd7>
        bfree(ip->dev, a[j]);
80101f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f23:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f26:	01 d0                	add    %edx,%eax
80101f28:	8b 00                	mov    (%eax),%eax
80101f2a:	8b 55 08             	mov    0x8(%ebp),%edx
80101f2d:	8b 12                	mov    (%edx),%edx
80101f2f:	83 ec 08             	sub    $0x8,%esp
80101f32:	50                   	push   %eax
80101f33:	52                   	push   %edx
80101f34:	e8 53 f7 ff ff       	call   8010168c <bfree>
80101f39:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101f3c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f43:	83 f8 7f             	cmp    $0x7f,%eax
80101f46:	76 bc                	jbe    80101f04 <itrunc+0x9f>
    }
    brelse(bp);
80101f48:	83 ec 0c             	sub    $0xc,%esp
80101f4b:	ff 75 ec             	pushl  -0x14(%ebp)
80101f4e:	e8 0e e3 ff ff       	call   80100261 <brelse>
80101f53:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f56:	8b 45 08             	mov    0x8(%ebp),%eax
80101f59:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101f5f:	8b 55 08             	mov    0x8(%ebp),%edx
80101f62:	8b 12                	mov    (%edx),%edx
80101f64:	83 ec 08             	sub    $0x8,%esp
80101f67:	50                   	push   %eax
80101f68:	52                   	push   %edx
80101f69:	e8 1e f7 ff ff       	call   8010168c <bfree>
80101f6e:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101f71:	8b 45 08             	mov    0x8(%ebp),%eax
80101f74:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101f7b:	00 00 00 
  }

  ip->size = 0;
80101f7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f81:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	ff 75 08             	pushl  0x8(%ebp)
80101f8e:	e8 5f f9 ff ff       	call   801018f2 <iupdate>
80101f93:	83 c4 10             	add    $0x10,%esp
}
80101f96:	90                   	nop
80101f97:	c9                   	leave  
80101f98:	c3                   	ret    

80101f99 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f99:	f3 0f 1e fb          	endbr32 
80101f9d:	55                   	push   %ebp
80101f9e:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101fa0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa3:	8b 00                	mov    (%eax),%eax
80101fa5:	89 c2                	mov    %eax,%edx
80101fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101faa:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101fad:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb0:	8b 50 04             	mov    0x4(%eax),%edx
80101fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fb6:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbc:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fc3:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101fc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc9:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fd0:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101fd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd7:	8b 50 58             	mov    0x58(%eax),%edx
80101fda:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fdd:	89 50 10             	mov    %edx,0x10(%eax)
}
80101fe0:	90                   	nop
80101fe1:	5d                   	pop    %ebp
80101fe2:	c3                   	ret    

80101fe3 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101fe3:	f3 0f 1e fb          	endbr32 
80101fe7:	55                   	push   %ebp
80101fe8:	89 e5                	mov    %esp,%ebp
80101fea:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fed:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff0:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101ff4:	66 83 f8 03          	cmp    $0x3,%ax
80101ff8:	75 5c                	jne    80102056 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ffa:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffd:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102001:	66 85 c0             	test   %ax,%ax
80102004:	78 20                	js     80102026 <readi+0x43>
80102006:	8b 45 08             	mov    0x8(%ebp),%eax
80102009:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010200d:	66 83 f8 09          	cmp    $0x9,%ax
80102011:	7f 13                	jg     80102026 <readi+0x43>
80102013:	8b 45 08             	mov    0x8(%ebp),%eax
80102016:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010201a:	98                   	cwtl   
8010201b:	8b 04 c5 00 2a 11 80 	mov    -0x7feed600(,%eax,8),%eax
80102022:	85 c0                	test   %eax,%eax
80102024:	75 0a                	jne    80102030 <readi+0x4d>
      return -1;
80102026:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010202b:	e9 0a 01 00 00       	jmp    8010213a <readi+0x157>
    return devsw[ip->major].read(ip, dst, n);
80102030:	8b 45 08             	mov    0x8(%ebp),%eax
80102033:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102037:	98                   	cwtl   
80102038:	8b 04 c5 00 2a 11 80 	mov    -0x7feed600(,%eax,8),%eax
8010203f:	8b 55 14             	mov    0x14(%ebp),%edx
80102042:	83 ec 04             	sub    $0x4,%esp
80102045:	52                   	push   %edx
80102046:	ff 75 0c             	pushl  0xc(%ebp)
80102049:	ff 75 08             	pushl  0x8(%ebp)
8010204c:	ff d0                	call   *%eax
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	e9 e4 00 00 00       	jmp    8010213a <readi+0x157>
  }

  if(off > ip->size || off + n < off)
80102056:	8b 45 08             	mov    0x8(%ebp),%eax
80102059:	8b 40 58             	mov    0x58(%eax),%eax
8010205c:	39 45 10             	cmp    %eax,0x10(%ebp)
8010205f:	77 0d                	ja     8010206e <readi+0x8b>
80102061:	8b 55 10             	mov    0x10(%ebp),%edx
80102064:	8b 45 14             	mov    0x14(%ebp),%eax
80102067:	01 d0                	add    %edx,%eax
80102069:	39 45 10             	cmp    %eax,0x10(%ebp)
8010206c:	76 0a                	jbe    80102078 <readi+0x95>
    return -1;
8010206e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102073:	e9 c2 00 00 00       	jmp    8010213a <readi+0x157>
  if(off + n > ip->size)
80102078:	8b 55 10             	mov    0x10(%ebp),%edx
8010207b:	8b 45 14             	mov    0x14(%ebp),%eax
8010207e:	01 c2                	add    %eax,%edx
80102080:	8b 45 08             	mov    0x8(%ebp),%eax
80102083:	8b 40 58             	mov    0x58(%eax),%eax
80102086:	39 c2                	cmp    %eax,%edx
80102088:	76 0c                	jbe    80102096 <readi+0xb3>
    n = ip->size - off;
8010208a:	8b 45 08             	mov    0x8(%ebp),%eax
8010208d:	8b 40 58             	mov    0x58(%eax),%eax
80102090:	2b 45 10             	sub    0x10(%ebp),%eax
80102093:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102096:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010209d:	e9 89 00 00 00       	jmp    8010212b <readi+0x148>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020a2:	8b 45 10             	mov    0x10(%ebp),%eax
801020a5:	c1 e8 09             	shr    $0x9,%eax
801020a8:	83 ec 08             	sub    $0x8,%esp
801020ab:	50                   	push   %eax
801020ac:	ff 75 08             	pushl  0x8(%ebp)
801020af:	e8 8d fc ff ff       	call   80101d41 <bmap>
801020b4:	83 c4 10             	add    $0x10,%esp
801020b7:	8b 55 08             	mov    0x8(%ebp),%edx
801020ba:	8b 12                	mov    (%edx),%edx
801020bc:	83 ec 08             	sub    $0x8,%esp
801020bf:	50                   	push   %eax
801020c0:	52                   	push   %edx
801020c1:	e8 11 e1 ff ff       	call   801001d7 <bread>
801020c6:	83 c4 10             	add    $0x10,%esp
801020c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020cc:	8b 45 10             	mov    0x10(%ebp),%eax
801020cf:	25 ff 01 00 00       	and    $0x1ff,%eax
801020d4:	ba 00 02 00 00       	mov    $0x200,%edx
801020d9:	29 c2                	sub    %eax,%edx
801020db:	8b 45 14             	mov    0x14(%ebp),%eax
801020de:	2b 45 f4             	sub    -0xc(%ebp),%eax
801020e1:	39 c2                	cmp    %eax,%edx
801020e3:	0f 46 c2             	cmovbe %edx,%eax
801020e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
801020e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020ec:	8d 50 5c             	lea    0x5c(%eax),%edx
801020ef:	8b 45 10             	mov    0x10(%ebp),%eax
801020f2:	25 ff 01 00 00       	and    $0x1ff,%eax
801020f7:	01 d0                	add    %edx,%eax
801020f9:	83 ec 04             	sub    $0x4,%esp
801020fc:	ff 75 ec             	pushl  -0x14(%ebp)
801020ff:	50                   	push   %eax
80102100:	ff 75 0c             	pushl  0xc(%ebp)
80102103:	e8 44 34 00 00       	call   8010554c <memmove>
80102108:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010210b:	83 ec 0c             	sub    $0xc,%esp
8010210e:	ff 75 f0             	pushl  -0x10(%ebp)
80102111:	e8 4b e1 ff ff       	call   80100261 <brelse>
80102116:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102119:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010211c:	01 45 f4             	add    %eax,-0xc(%ebp)
8010211f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102122:	01 45 10             	add    %eax,0x10(%ebp)
80102125:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102128:	01 45 0c             	add    %eax,0xc(%ebp)
8010212b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010212e:	3b 45 14             	cmp    0x14(%ebp),%eax
80102131:	0f 82 6b ff ff ff    	jb     801020a2 <readi+0xbf>
  }
  return n;
80102137:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010213a:	c9                   	leave  
8010213b:	c3                   	ret    

8010213c <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010213c:	f3 0f 1e fb          	endbr32 
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102146:	8b 45 08             	mov    0x8(%ebp),%eax
80102149:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010214d:	66 83 f8 03          	cmp    $0x3,%ax
80102151:	75 5c                	jne    801021af <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102153:	8b 45 08             	mov    0x8(%ebp),%eax
80102156:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010215a:	66 85 c0             	test   %ax,%ax
8010215d:	78 20                	js     8010217f <writei+0x43>
8010215f:	8b 45 08             	mov    0x8(%ebp),%eax
80102162:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102166:	66 83 f8 09          	cmp    $0x9,%ax
8010216a:	7f 13                	jg     8010217f <writei+0x43>
8010216c:	8b 45 08             	mov    0x8(%ebp),%eax
8010216f:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102173:	98                   	cwtl   
80102174:	8b 04 c5 04 2a 11 80 	mov    -0x7feed5fc(,%eax,8),%eax
8010217b:	85 c0                	test   %eax,%eax
8010217d:	75 0a                	jne    80102189 <writei+0x4d>
      return -1;
8010217f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102184:	e9 3b 01 00 00       	jmp    801022c4 <writei+0x188>
    return devsw[ip->major].write(ip, src, n);
80102189:	8b 45 08             	mov    0x8(%ebp),%eax
8010218c:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102190:	98                   	cwtl   
80102191:	8b 04 c5 04 2a 11 80 	mov    -0x7feed5fc(,%eax,8),%eax
80102198:	8b 55 14             	mov    0x14(%ebp),%edx
8010219b:	83 ec 04             	sub    $0x4,%esp
8010219e:	52                   	push   %edx
8010219f:	ff 75 0c             	pushl  0xc(%ebp)
801021a2:	ff 75 08             	pushl  0x8(%ebp)
801021a5:	ff d0                	call   *%eax
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	e9 15 01 00 00       	jmp    801022c4 <writei+0x188>
  }

  if(off > ip->size || off + n < off)
801021af:	8b 45 08             	mov    0x8(%ebp),%eax
801021b2:	8b 40 58             	mov    0x58(%eax),%eax
801021b5:	39 45 10             	cmp    %eax,0x10(%ebp)
801021b8:	77 0d                	ja     801021c7 <writei+0x8b>
801021ba:	8b 55 10             	mov    0x10(%ebp),%edx
801021bd:	8b 45 14             	mov    0x14(%ebp),%eax
801021c0:	01 d0                	add    %edx,%eax
801021c2:	39 45 10             	cmp    %eax,0x10(%ebp)
801021c5:	76 0a                	jbe    801021d1 <writei+0x95>
    return -1;
801021c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021cc:	e9 f3 00 00 00       	jmp    801022c4 <writei+0x188>
  if(off + n > MAXFILE*BSIZE)
801021d1:	8b 55 10             	mov    0x10(%ebp),%edx
801021d4:	8b 45 14             	mov    0x14(%ebp),%eax
801021d7:	01 d0                	add    %edx,%eax
801021d9:	3d 00 18 01 00       	cmp    $0x11800,%eax
801021de:	76 0a                	jbe    801021ea <writei+0xae>
    return -1;
801021e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021e5:	e9 da 00 00 00       	jmp    801022c4 <writei+0x188>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021f1:	e9 97 00 00 00       	jmp    8010228d <writei+0x151>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021f6:	8b 45 10             	mov    0x10(%ebp),%eax
801021f9:	c1 e8 09             	shr    $0x9,%eax
801021fc:	83 ec 08             	sub    $0x8,%esp
801021ff:	50                   	push   %eax
80102200:	ff 75 08             	pushl  0x8(%ebp)
80102203:	e8 39 fb ff ff       	call   80101d41 <bmap>
80102208:	83 c4 10             	add    $0x10,%esp
8010220b:	8b 55 08             	mov    0x8(%ebp),%edx
8010220e:	8b 12                	mov    (%edx),%edx
80102210:	83 ec 08             	sub    $0x8,%esp
80102213:	50                   	push   %eax
80102214:	52                   	push   %edx
80102215:	e8 bd df ff ff       	call   801001d7 <bread>
8010221a:	83 c4 10             	add    $0x10,%esp
8010221d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102220:	8b 45 10             	mov    0x10(%ebp),%eax
80102223:	25 ff 01 00 00       	and    $0x1ff,%eax
80102228:	ba 00 02 00 00       	mov    $0x200,%edx
8010222d:	29 c2                	sub    %eax,%edx
8010222f:	8b 45 14             	mov    0x14(%ebp),%eax
80102232:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102235:	39 c2                	cmp    %eax,%edx
80102237:	0f 46 c2             	cmovbe %edx,%eax
8010223a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010223d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102240:	8d 50 5c             	lea    0x5c(%eax),%edx
80102243:	8b 45 10             	mov    0x10(%ebp),%eax
80102246:	25 ff 01 00 00       	and    $0x1ff,%eax
8010224b:	01 d0                	add    %edx,%eax
8010224d:	83 ec 04             	sub    $0x4,%esp
80102250:	ff 75 ec             	pushl  -0x14(%ebp)
80102253:	ff 75 0c             	pushl  0xc(%ebp)
80102256:	50                   	push   %eax
80102257:	e8 f0 32 00 00       	call   8010554c <memmove>
8010225c:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010225f:	83 ec 0c             	sub    $0xc,%esp
80102262:	ff 75 f0             	pushl  -0x10(%ebp)
80102265:	e8 af 16 00 00       	call   80103919 <log_write>
8010226a:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010226d:	83 ec 0c             	sub    $0xc,%esp
80102270:	ff 75 f0             	pushl  -0x10(%ebp)
80102273:	e8 e9 df ff ff       	call   80100261 <brelse>
80102278:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010227b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010227e:	01 45 f4             	add    %eax,-0xc(%ebp)
80102281:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102284:	01 45 10             	add    %eax,0x10(%ebp)
80102287:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010228a:	01 45 0c             	add    %eax,0xc(%ebp)
8010228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102290:	3b 45 14             	cmp    0x14(%ebp),%eax
80102293:	0f 82 5d ff ff ff    	jb     801021f6 <writei+0xba>
  }

  if(n > 0 && off > ip->size){
80102299:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010229d:	74 22                	je     801022c1 <writei+0x185>
8010229f:	8b 45 08             	mov    0x8(%ebp),%eax
801022a2:	8b 40 58             	mov    0x58(%eax),%eax
801022a5:	39 45 10             	cmp    %eax,0x10(%ebp)
801022a8:	76 17                	jbe    801022c1 <writei+0x185>
    ip->size = off;
801022aa:	8b 45 08             	mov    0x8(%ebp),%eax
801022ad:	8b 55 10             	mov    0x10(%ebp),%edx
801022b0:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801022b3:	83 ec 0c             	sub    $0xc,%esp
801022b6:	ff 75 08             	pushl  0x8(%ebp)
801022b9:	e8 34 f6 ff ff       	call   801018f2 <iupdate>
801022be:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801022c1:	8b 45 14             	mov    0x14(%ebp),%eax
}
801022c4:	c9                   	leave  
801022c5:	c3                   	ret    

801022c6 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801022c6:	f3 0f 1e fb          	endbr32 
801022ca:	55                   	push   %ebp
801022cb:	89 e5                	mov    %esp,%ebp
801022cd:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801022d0:	83 ec 04             	sub    $0x4,%esp
801022d3:	6a 0e                	push   $0xe
801022d5:	ff 75 0c             	pushl  0xc(%ebp)
801022d8:	ff 75 08             	pushl  0x8(%ebp)
801022db:	e8 0a 33 00 00       	call   801055ea <strncmp>
801022e0:	83 c4 10             	add    $0x10,%esp
}
801022e3:	c9                   	leave  
801022e4:	c3                   	ret    

801022e5 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801022e5:	f3 0f 1e fb          	endbr32 
801022e9:	55                   	push   %ebp
801022ea:	89 e5                	mov    %esp,%ebp
801022ec:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801022ef:	8b 45 08             	mov    0x8(%ebp),%eax
801022f2:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801022f6:	66 83 f8 01          	cmp    $0x1,%ax
801022fa:	74 0d                	je     80102309 <dirlookup+0x24>
    panic("dirlookup not DIR");
801022fc:	83 ec 0c             	sub    $0xc,%esp
801022ff:	68 25 91 10 80       	push   $0x80109125
80102304:	e8 ff e2 ff ff       	call   80100608 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102309:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102310:	eb 7b                	jmp    8010238d <dirlookup+0xa8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102312:	6a 10                	push   $0x10
80102314:	ff 75 f4             	pushl  -0xc(%ebp)
80102317:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010231a:	50                   	push   %eax
8010231b:	ff 75 08             	pushl  0x8(%ebp)
8010231e:	e8 c0 fc ff ff       	call   80101fe3 <readi>
80102323:	83 c4 10             	add    $0x10,%esp
80102326:	83 f8 10             	cmp    $0x10,%eax
80102329:	74 0d                	je     80102338 <dirlookup+0x53>
      panic("dirlookup read");
8010232b:	83 ec 0c             	sub    $0xc,%esp
8010232e:	68 37 91 10 80       	push   $0x80109137
80102333:	e8 d0 e2 ff ff       	call   80100608 <panic>
    if(de.inum == 0)
80102338:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010233c:	66 85 c0             	test   %ax,%ax
8010233f:	74 47                	je     80102388 <dirlookup+0xa3>
      continue;
    if(namecmp(name, de.name) == 0){
80102341:	83 ec 08             	sub    $0x8,%esp
80102344:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102347:	83 c0 02             	add    $0x2,%eax
8010234a:	50                   	push   %eax
8010234b:	ff 75 0c             	pushl  0xc(%ebp)
8010234e:	e8 73 ff ff ff       	call   801022c6 <namecmp>
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	85 c0                	test   %eax,%eax
80102358:	75 2f                	jne    80102389 <dirlookup+0xa4>
      // entry matches path element
      if(poff)
8010235a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010235e:	74 08                	je     80102368 <dirlookup+0x83>
        *poff = off;
80102360:	8b 45 10             	mov    0x10(%ebp),%eax
80102363:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102366:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102368:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010236c:	0f b7 c0             	movzwl %ax,%eax
8010236f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102372:	8b 45 08             	mov    0x8(%ebp),%eax
80102375:	8b 00                	mov    (%eax),%eax
80102377:	83 ec 08             	sub    $0x8,%esp
8010237a:	ff 75 f0             	pushl  -0x10(%ebp)
8010237d:	50                   	push   %eax
8010237e:	e8 34 f6 ff ff       	call   801019b7 <iget>
80102383:	83 c4 10             	add    $0x10,%esp
80102386:	eb 19                	jmp    801023a1 <dirlookup+0xbc>
      continue;
80102388:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
80102389:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010238d:	8b 45 08             	mov    0x8(%ebp),%eax
80102390:	8b 40 58             	mov    0x58(%eax),%eax
80102393:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102396:	0f 82 76 ff ff ff    	jb     80102312 <dirlookup+0x2d>
    }
  }

  return 0;
8010239c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023a1:	c9                   	leave  
801023a2:	c3                   	ret    

801023a3 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801023a3:	f3 0f 1e fb          	endbr32 
801023a7:	55                   	push   %ebp
801023a8:	89 e5                	mov    %esp,%ebp
801023aa:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801023ad:	83 ec 04             	sub    $0x4,%esp
801023b0:	6a 00                	push   $0x0
801023b2:	ff 75 0c             	pushl  0xc(%ebp)
801023b5:	ff 75 08             	pushl  0x8(%ebp)
801023b8:	e8 28 ff ff ff       	call   801022e5 <dirlookup>
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023c7:	74 18                	je     801023e1 <dirlink+0x3e>
    iput(ip);
801023c9:	83 ec 0c             	sub    $0xc,%esp
801023cc:	ff 75 f0             	pushl  -0x10(%ebp)
801023cf:	e8 70 f8 ff ff       	call   80101c44 <iput>
801023d4:	83 c4 10             	add    $0x10,%esp
    return -1;
801023d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023dc:	e9 9c 00 00 00       	jmp    8010247d <dirlink+0xda>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801023e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801023e8:	eb 39                	jmp    80102423 <dirlink+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ed:	6a 10                	push   $0x10
801023ef:	50                   	push   %eax
801023f0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023f3:	50                   	push   %eax
801023f4:	ff 75 08             	pushl  0x8(%ebp)
801023f7:	e8 e7 fb ff ff       	call   80101fe3 <readi>
801023fc:	83 c4 10             	add    $0x10,%esp
801023ff:	83 f8 10             	cmp    $0x10,%eax
80102402:	74 0d                	je     80102411 <dirlink+0x6e>
      panic("dirlink read");
80102404:	83 ec 0c             	sub    $0xc,%esp
80102407:	68 46 91 10 80       	push   $0x80109146
8010240c:	e8 f7 e1 ff ff       	call   80100608 <panic>
    if(de.inum == 0)
80102411:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102415:	66 85 c0             	test   %ax,%ax
80102418:	74 18                	je     80102432 <dirlink+0x8f>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010241d:	83 c0 10             	add    $0x10,%eax
80102420:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102423:	8b 45 08             	mov    0x8(%ebp),%eax
80102426:	8b 50 58             	mov    0x58(%eax),%edx
80102429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010242c:	39 c2                	cmp    %eax,%edx
8010242e:	77 ba                	ja     801023ea <dirlink+0x47>
80102430:	eb 01                	jmp    80102433 <dirlink+0x90>
      break;
80102432:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102433:	83 ec 04             	sub    $0x4,%esp
80102436:	6a 0e                	push   $0xe
80102438:	ff 75 0c             	pushl  0xc(%ebp)
8010243b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010243e:	83 c0 02             	add    $0x2,%eax
80102441:	50                   	push   %eax
80102442:	e8 fd 31 00 00       	call   80105644 <strncpy>
80102447:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010244a:	8b 45 10             	mov    0x10(%ebp),%eax
8010244d:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102451:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102454:	6a 10                	push   $0x10
80102456:	50                   	push   %eax
80102457:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010245a:	50                   	push   %eax
8010245b:	ff 75 08             	pushl  0x8(%ebp)
8010245e:	e8 d9 fc ff ff       	call   8010213c <writei>
80102463:	83 c4 10             	add    $0x10,%esp
80102466:	83 f8 10             	cmp    $0x10,%eax
80102469:	74 0d                	je     80102478 <dirlink+0xd5>
    panic("dirlink");
8010246b:	83 ec 0c             	sub    $0xc,%esp
8010246e:	68 53 91 10 80       	push   $0x80109153
80102473:	e8 90 e1 ff ff       	call   80100608 <panic>

  return 0;
80102478:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010247d:	c9                   	leave  
8010247e:	c3                   	ret    

8010247f <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010247f:	f3 0f 1e fb          	endbr32 
80102483:	55                   	push   %ebp
80102484:	89 e5                	mov    %esp,%ebp
80102486:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102489:	eb 04                	jmp    8010248f <skipelem+0x10>
    path++;
8010248b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
8010248f:	8b 45 08             	mov    0x8(%ebp),%eax
80102492:	0f b6 00             	movzbl (%eax),%eax
80102495:	3c 2f                	cmp    $0x2f,%al
80102497:	74 f2                	je     8010248b <skipelem+0xc>
  if(*path == 0)
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
8010249c:	0f b6 00             	movzbl (%eax),%eax
8010249f:	84 c0                	test   %al,%al
801024a1:	75 07                	jne    801024aa <skipelem+0x2b>
    return 0;
801024a3:	b8 00 00 00 00       	mov    $0x0,%eax
801024a8:	eb 77                	jmp    80102521 <skipelem+0xa2>
  s = path;
801024aa:	8b 45 08             	mov    0x8(%ebp),%eax
801024ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801024b0:	eb 04                	jmp    801024b6 <skipelem+0x37>
    path++;
801024b2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
801024b6:	8b 45 08             	mov    0x8(%ebp),%eax
801024b9:	0f b6 00             	movzbl (%eax),%eax
801024bc:	3c 2f                	cmp    $0x2f,%al
801024be:	74 0a                	je     801024ca <skipelem+0x4b>
801024c0:	8b 45 08             	mov    0x8(%ebp),%eax
801024c3:	0f b6 00             	movzbl (%eax),%eax
801024c6:	84 c0                	test   %al,%al
801024c8:	75 e8                	jne    801024b2 <skipelem+0x33>
  len = path - s;
801024ca:	8b 45 08             	mov    0x8(%ebp),%eax
801024cd:	2b 45 f4             	sub    -0xc(%ebp),%eax
801024d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801024d3:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801024d7:	7e 15                	jle    801024ee <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801024d9:	83 ec 04             	sub    $0x4,%esp
801024dc:	6a 0e                	push   $0xe
801024de:	ff 75 f4             	pushl  -0xc(%ebp)
801024e1:	ff 75 0c             	pushl  0xc(%ebp)
801024e4:	e8 63 30 00 00       	call   8010554c <memmove>
801024e9:	83 c4 10             	add    $0x10,%esp
801024ec:	eb 26                	jmp    80102514 <skipelem+0x95>
  else {
    memmove(name, s, len);
801024ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024f1:	83 ec 04             	sub    $0x4,%esp
801024f4:	50                   	push   %eax
801024f5:	ff 75 f4             	pushl  -0xc(%ebp)
801024f8:	ff 75 0c             	pushl  0xc(%ebp)
801024fb:	e8 4c 30 00 00       	call   8010554c <memmove>
80102500:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102503:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102506:	8b 45 0c             	mov    0xc(%ebp),%eax
80102509:	01 d0                	add    %edx,%eax
8010250b:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010250e:	eb 04                	jmp    80102514 <skipelem+0x95>
    path++;
80102510:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102514:	8b 45 08             	mov    0x8(%ebp),%eax
80102517:	0f b6 00             	movzbl (%eax),%eax
8010251a:	3c 2f                	cmp    $0x2f,%al
8010251c:	74 f2                	je     80102510 <skipelem+0x91>
  return path;
8010251e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102521:	c9                   	leave  
80102522:	c3                   	ret    

80102523 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102523:	f3 0f 1e fb          	endbr32 
80102527:	55                   	push   %ebp
80102528:	89 e5                	mov    %esp,%ebp
8010252a:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010252d:	8b 45 08             	mov    0x8(%ebp),%eax
80102530:	0f b6 00             	movzbl (%eax),%eax
80102533:	3c 2f                	cmp    $0x2f,%al
80102535:	75 17                	jne    8010254e <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
80102537:	83 ec 08             	sub    $0x8,%esp
8010253a:	6a 01                	push   $0x1
8010253c:	6a 01                	push   $0x1
8010253e:	e8 74 f4 ff ff       	call   801019b7 <iget>
80102543:	83 c4 10             	add    $0x10,%esp
80102546:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102549:	e9 ba 00 00 00       	jmp    80102608 <namex+0xe5>
  else
    ip = idup(myproc()->cwd);
8010254e:	e8 3c 1f 00 00       	call   8010448f <myproc>
80102553:	8b 40 68             	mov    0x68(%eax),%eax
80102556:	83 ec 0c             	sub    $0xc,%esp
80102559:	50                   	push   %eax
8010255a:	e8 3e f5 ff ff       	call   80101a9d <idup>
8010255f:	83 c4 10             	add    $0x10,%esp
80102562:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102565:	e9 9e 00 00 00       	jmp    80102608 <namex+0xe5>
    ilock(ip);
8010256a:	83 ec 0c             	sub    $0xc,%esp
8010256d:	ff 75 f4             	pushl  -0xc(%ebp)
80102570:	e8 66 f5 ff ff       	call   80101adb <ilock>
80102575:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102578:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010257b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010257f:	66 83 f8 01          	cmp    $0x1,%ax
80102583:	74 18                	je     8010259d <namex+0x7a>
      iunlockput(ip);
80102585:	83 ec 0c             	sub    $0xc,%esp
80102588:	ff 75 f4             	pushl  -0xc(%ebp)
8010258b:	e8 88 f7 ff ff       	call   80101d18 <iunlockput>
80102590:	83 c4 10             	add    $0x10,%esp
      return 0;
80102593:	b8 00 00 00 00       	mov    $0x0,%eax
80102598:	e9 a7 00 00 00       	jmp    80102644 <namex+0x121>
    }
    if(nameiparent && *path == '\0'){
8010259d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025a1:	74 20                	je     801025c3 <namex+0xa0>
801025a3:	8b 45 08             	mov    0x8(%ebp),%eax
801025a6:	0f b6 00             	movzbl (%eax),%eax
801025a9:	84 c0                	test   %al,%al
801025ab:	75 16                	jne    801025c3 <namex+0xa0>
      // Stop one level early.
      iunlock(ip);
801025ad:	83 ec 0c             	sub    $0xc,%esp
801025b0:	ff 75 f4             	pushl  -0xc(%ebp)
801025b3:	e8 3a f6 ff ff       	call   80101bf2 <iunlock>
801025b8:	83 c4 10             	add    $0x10,%esp
      return ip;
801025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025be:	e9 81 00 00 00       	jmp    80102644 <namex+0x121>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801025c3:	83 ec 04             	sub    $0x4,%esp
801025c6:	6a 00                	push   $0x0
801025c8:	ff 75 10             	pushl  0x10(%ebp)
801025cb:	ff 75 f4             	pushl  -0xc(%ebp)
801025ce:	e8 12 fd ff ff       	call   801022e5 <dirlookup>
801025d3:	83 c4 10             	add    $0x10,%esp
801025d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801025d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801025dd:	75 15                	jne    801025f4 <namex+0xd1>
      iunlockput(ip);
801025df:	83 ec 0c             	sub    $0xc,%esp
801025e2:	ff 75 f4             	pushl  -0xc(%ebp)
801025e5:	e8 2e f7 ff ff       	call   80101d18 <iunlockput>
801025ea:	83 c4 10             	add    $0x10,%esp
      return 0;
801025ed:	b8 00 00 00 00       	mov    $0x0,%eax
801025f2:	eb 50                	jmp    80102644 <namex+0x121>
    }
    iunlockput(ip);
801025f4:	83 ec 0c             	sub    $0xc,%esp
801025f7:	ff 75 f4             	pushl  -0xc(%ebp)
801025fa:	e8 19 f7 ff ff       	call   80101d18 <iunlockput>
801025ff:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102602:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102605:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
80102608:	83 ec 08             	sub    $0x8,%esp
8010260b:	ff 75 10             	pushl  0x10(%ebp)
8010260e:	ff 75 08             	pushl  0x8(%ebp)
80102611:	e8 69 fe ff ff       	call   8010247f <skipelem>
80102616:	83 c4 10             	add    $0x10,%esp
80102619:	89 45 08             	mov    %eax,0x8(%ebp)
8010261c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102620:	0f 85 44 ff ff ff    	jne    8010256a <namex+0x47>
  }
  if(nameiparent){
80102626:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010262a:	74 15                	je     80102641 <namex+0x11e>
    iput(ip);
8010262c:	83 ec 0c             	sub    $0xc,%esp
8010262f:	ff 75 f4             	pushl  -0xc(%ebp)
80102632:	e8 0d f6 ff ff       	call   80101c44 <iput>
80102637:	83 c4 10             	add    $0x10,%esp
    return 0;
8010263a:	b8 00 00 00 00       	mov    $0x0,%eax
8010263f:	eb 03                	jmp    80102644 <namex+0x121>
  }
  return ip;
80102641:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102644:	c9                   	leave  
80102645:	c3                   	ret    

80102646 <namei>:

struct inode*
namei(char *path)
{
80102646:	f3 0f 1e fb          	endbr32 
8010264a:	55                   	push   %ebp
8010264b:	89 e5                	mov    %esp,%ebp
8010264d:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102650:	83 ec 04             	sub    $0x4,%esp
80102653:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102656:	50                   	push   %eax
80102657:	6a 00                	push   $0x0
80102659:	ff 75 08             	pushl  0x8(%ebp)
8010265c:	e8 c2 fe ff ff       	call   80102523 <namex>
80102661:	83 c4 10             	add    $0x10,%esp
}
80102664:	c9                   	leave  
80102665:	c3                   	ret    

80102666 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102666:	f3 0f 1e fb          	endbr32 
8010266a:	55                   	push   %ebp
8010266b:	89 e5                	mov    %esp,%ebp
8010266d:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102670:	83 ec 04             	sub    $0x4,%esp
80102673:	ff 75 0c             	pushl  0xc(%ebp)
80102676:	6a 01                	push   $0x1
80102678:	ff 75 08             	pushl  0x8(%ebp)
8010267b:	e8 a3 fe ff ff       	call   80102523 <namex>
80102680:	83 c4 10             	add    $0x10,%esp
}
80102683:	c9                   	leave  
80102684:	c3                   	ret    

80102685 <inb>:
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
80102688:	83 ec 14             	sub    $0x14,%esp
8010268b:	8b 45 08             	mov    0x8(%ebp),%eax
8010268e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102692:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102696:	89 c2                	mov    %eax,%edx
80102698:	ec                   	in     (%dx),%al
80102699:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010269c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801026a0:	c9                   	leave  
801026a1:	c3                   	ret    

801026a2 <insl>:
{
801026a2:	55                   	push   %ebp
801026a3:	89 e5                	mov    %esp,%ebp
801026a5:	57                   	push   %edi
801026a6:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801026a7:	8b 55 08             	mov    0x8(%ebp),%edx
801026aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026ad:	8b 45 10             	mov    0x10(%ebp),%eax
801026b0:	89 cb                	mov    %ecx,%ebx
801026b2:	89 df                	mov    %ebx,%edi
801026b4:	89 c1                	mov    %eax,%ecx
801026b6:	fc                   	cld    
801026b7:	f3 6d                	rep insl (%dx),%es:(%edi)
801026b9:	89 c8                	mov    %ecx,%eax
801026bb:	89 fb                	mov    %edi,%ebx
801026bd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801026c0:	89 45 10             	mov    %eax,0x10(%ebp)
}
801026c3:	90                   	nop
801026c4:	5b                   	pop    %ebx
801026c5:	5f                   	pop    %edi
801026c6:	5d                   	pop    %ebp
801026c7:	c3                   	ret    

801026c8 <outb>:
{
801026c8:	55                   	push   %ebp
801026c9:	89 e5                	mov    %esp,%ebp
801026cb:	83 ec 08             	sub    $0x8,%esp
801026ce:	8b 45 08             	mov    0x8(%ebp),%eax
801026d1:	8b 55 0c             	mov    0xc(%ebp),%edx
801026d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801026d8:	89 d0                	mov    %edx,%eax
801026da:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026dd:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801026e1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801026e5:	ee                   	out    %al,(%dx)
}
801026e6:	90                   	nop
801026e7:	c9                   	leave  
801026e8:	c3                   	ret    

801026e9 <outsl>:
{
801026e9:	55                   	push   %ebp
801026ea:	89 e5                	mov    %esp,%ebp
801026ec:	56                   	push   %esi
801026ed:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801026ee:	8b 55 08             	mov    0x8(%ebp),%edx
801026f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026f4:	8b 45 10             	mov    0x10(%ebp),%eax
801026f7:	89 cb                	mov    %ecx,%ebx
801026f9:	89 de                	mov    %ebx,%esi
801026fb:	89 c1                	mov    %eax,%ecx
801026fd:	fc                   	cld    
801026fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102700:	89 c8                	mov    %ecx,%eax
80102702:	89 f3                	mov    %esi,%ebx
80102704:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102707:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010270a:	90                   	nop
8010270b:	5b                   	pop    %ebx
8010270c:	5e                   	pop    %esi
8010270d:	5d                   	pop    %ebp
8010270e:	c3                   	ret    

8010270f <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010270f:	f3 0f 1e fb          	endbr32 
80102713:	55                   	push   %ebp
80102714:	89 e5                	mov    %esp,%ebp
80102716:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102719:	90                   	nop
8010271a:	68 f7 01 00 00       	push   $0x1f7
8010271f:	e8 61 ff ff ff       	call   80102685 <inb>
80102724:	83 c4 04             	add    $0x4,%esp
80102727:	0f b6 c0             	movzbl %al,%eax
8010272a:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010272d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102730:	25 c0 00 00 00       	and    $0xc0,%eax
80102735:	83 f8 40             	cmp    $0x40,%eax
80102738:	75 e0                	jne    8010271a <idewait+0xb>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010273a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010273e:	74 11                	je     80102751 <idewait+0x42>
80102740:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102743:	83 e0 21             	and    $0x21,%eax
80102746:	85 c0                	test   %eax,%eax
80102748:	74 07                	je     80102751 <idewait+0x42>
    return -1;
8010274a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010274f:	eb 05                	jmp    80102756 <idewait+0x47>
  return 0;
80102751:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102756:	c9                   	leave  
80102757:	c3                   	ret    

80102758 <ideinit>:

void
ideinit(void)
{
80102758:	f3 0f 1e fb          	endbr32 
8010275c:	55                   	push   %ebp
8010275d:	89 e5                	mov    %esp,%ebp
8010275f:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102762:	83 ec 08             	sub    $0x8,%esp
80102765:	68 5b 91 10 80       	push   $0x8010915b
8010276a:	68 00 c6 10 80       	push   $0x8010c600
8010276f:	e8 4c 2a 00 00       	call   801051c0 <initlock>
80102774:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102777:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
8010277c:	83 e8 01             	sub    $0x1,%eax
8010277f:	83 ec 08             	sub    $0x8,%esp
80102782:	50                   	push   %eax
80102783:	6a 0e                	push   $0xe
80102785:	e8 bb 04 00 00       	call   80102c45 <ioapicenable>
8010278a:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010278d:	83 ec 0c             	sub    $0xc,%esp
80102790:	6a 00                	push   $0x0
80102792:	e8 78 ff ff ff       	call   8010270f <idewait>
80102797:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010279a:	83 ec 08             	sub    $0x8,%esp
8010279d:	68 f0 00 00 00       	push   $0xf0
801027a2:	68 f6 01 00 00       	push   $0x1f6
801027a7:	e8 1c ff ff ff       	call   801026c8 <outb>
801027ac:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801027af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801027b6:	eb 24                	jmp    801027dc <ideinit+0x84>
    if(inb(0x1f7) != 0){
801027b8:	83 ec 0c             	sub    $0xc,%esp
801027bb:	68 f7 01 00 00       	push   $0x1f7
801027c0:	e8 c0 fe ff ff       	call   80102685 <inb>
801027c5:	83 c4 10             	add    $0x10,%esp
801027c8:	84 c0                	test   %al,%al
801027ca:	74 0c                	je     801027d8 <ideinit+0x80>
      havedisk1 = 1;
801027cc:	c7 05 38 c6 10 80 01 	movl   $0x1,0x8010c638
801027d3:	00 00 00 
      break;
801027d6:	eb 0d                	jmp    801027e5 <ideinit+0x8d>
  for(i=0; i<1000; i++){
801027d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801027dc:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801027e3:	7e d3                	jle    801027b8 <ideinit+0x60>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801027e5:	83 ec 08             	sub    $0x8,%esp
801027e8:	68 e0 00 00 00       	push   $0xe0
801027ed:	68 f6 01 00 00       	push   $0x1f6
801027f2:	e8 d1 fe ff ff       	call   801026c8 <outb>
801027f7:	83 c4 10             	add    $0x10,%esp
}
801027fa:	90                   	nop
801027fb:	c9                   	leave  
801027fc:	c3                   	ret    

801027fd <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801027fd:	f3 0f 1e fb          	endbr32 
80102801:	55                   	push   %ebp
80102802:	89 e5                	mov    %esp,%ebp
80102804:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102807:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010280b:	75 0d                	jne    8010281a <idestart+0x1d>
    panic("idestart");
8010280d:	83 ec 0c             	sub    $0xc,%esp
80102810:	68 5f 91 10 80       	push   $0x8010915f
80102815:	e8 ee dd ff ff       	call   80100608 <panic>
  if(b->blockno >= FSSIZE)
8010281a:	8b 45 08             	mov    0x8(%ebp),%eax
8010281d:	8b 40 08             	mov    0x8(%eax),%eax
80102820:	3d 9f 0f 00 00       	cmp    $0xf9f,%eax
80102825:	76 0d                	jbe    80102834 <idestart+0x37>
    panic("incorrect blockno");
80102827:	83 ec 0c             	sub    $0xc,%esp
8010282a:	68 68 91 10 80       	push   $0x80109168
8010282f:	e8 d4 dd ff ff       	call   80100608 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102834:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010283b:	8b 45 08             	mov    0x8(%ebp),%eax
8010283e:	8b 50 08             	mov    0x8(%eax),%edx
80102841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102844:	0f af c2             	imul   %edx,%eax
80102847:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010284a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010284e:	75 07                	jne    80102857 <idestart+0x5a>
80102850:	b8 20 00 00 00       	mov    $0x20,%eax
80102855:	eb 05                	jmp    8010285c <idestart+0x5f>
80102857:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010285c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
8010285f:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102863:	75 07                	jne    8010286c <idestart+0x6f>
80102865:	b8 30 00 00 00       	mov    $0x30,%eax
8010286a:	eb 05                	jmp    80102871 <idestart+0x74>
8010286c:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102871:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102874:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102878:	7e 0d                	jle    80102887 <idestart+0x8a>
8010287a:	83 ec 0c             	sub    $0xc,%esp
8010287d:	68 5f 91 10 80       	push   $0x8010915f
80102882:	e8 81 dd ff ff       	call   80100608 <panic>

  idewait(0);
80102887:	83 ec 0c             	sub    $0xc,%esp
8010288a:	6a 00                	push   $0x0
8010288c:	e8 7e fe ff ff       	call   8010270f <idewait>
80102891:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102894:	83 ec 08             	sub    $0x8,%esp
80102897:	6a 00                	push   $0x0
80102899:	68 f6 03 00 00       	push   $0x3f6
8010289e:	e8 25 fe ff ff       	call   801026c8 <outb>
801028a3:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028a9:	0f b6 c0             	movzbl %al,%eax
801028ac:	83 ec 08             	sub    $0x8,%esp
801028af:	50                   	push   %eax
801028b0:	68 f2 01 00 00       	push   $0x1f2
801028b5:	e8 0e fe ff ff       	call   801026c8 <outb>
801028ba:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028c0:	0f b6 c0             	movzbl %al,%eax
801028c3:	83 ec 08             	sub    $0x8,%esp
801028c6:	50                   	push   %eax
801028c7:	68 f3 01 00 00       	push   $0x1f3
801028cc:	e8 f7 fd ff ff       	call   801026c8 <outb>
801028d1:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028d7:	c1 f8 08             	sar    $0x8,%eax
801028da:	0f b6 c0             	movzbl %al,%eax
801028dd:	83 ec 08             	sub    $0x8,%esp
801028e0:	50                   	push   %eax
801028e1:	68 f4 01 00 00       	push   $0x1f4
801028e6:	e8 dd fd ff ff       	call   801026c8 <outb>
801028eb:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801028ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028f1:	c1 f8 10             	sar    $0x10,%eax
801028f4:	0f b6 c0             	movzbl %al,%eax
801028f7:	83 ec 08             	sub    $0x8,%esp
801028fa:	50                   	push   %eax
801028fb:	68 f5 01 00 00       	push   $0x1f5
80102900:	e8 c3 fd ff ff       	call   801026c8 <outb>
80102905:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102908:	8b 45 08             	mov    0x8(%ebp),%eax
8010290b:	8b 40 04             	mov    0x4(%eax),%eax
8010290e:	c1 e0 04             	shl    $0x4,%eax
80102911:	83 e0 10             	and    $0x10,%eax
80102914:	89 c2                	mov    %eax,%edx
80102916:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102919:	c1 f8 18             	sar    $0x18,%eax
8010291c:	83 e0 0f             	and    $0xf,%eax
8010291f:	09 d0                	or     %edx,%eax
80102921:	83 c8 e0             	or     $0xffffffe0,%eax
80102924:	0f b6 c0             	movzbl %al,%eax
80102927:	83 ec 08             	sub    $0x8,%esp
8010292a:	50                   	push   %eax
8010292b:	68 f6 01 00 00       	push   $0x1f6
80102930:	e8 93 fd ff ff       	call   801026c8 <outb>
80102935:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102938:	8b 45 08             	mov    0x8(%ebp),%eax
8010293b:	8b 00                	mov    (%eax),%eax
8010293d:	83 e0 04             	and    $0x4,%eax
80102940:	85 c0                	test   %eax,%eax
80102942:	74 35                	je     80102979 <idestart+0x17c>
    outb(0x1f7, write_cmd);
80102944:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102947:	0f b6 c0             	movzbl %al,%eax
8010294a:	83 ec 08             	sub    $0x8,%esp
8010294d:	50                   	push   %eax
8010294e:	68 f7 01 00 00       	push   $0x1f7
80102953:	e8 70 fd ff ff       	call   801026c8 <outb>
80102958:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010295b:	8b 45 08             	mov    0x8(%ebp),%eax
8010295e:	83 c0 5c             	add    $0x5c,%eax
80102961:	83 ec 04             	sub    $0x4,%esp
80102964:	68 80 00 00 00       	push   $0x80
80102969:	50                   	push   %eax
8010296a:	68 f0 01 00 00       	push   $0x1f0
8010296f:	e8 75 fd ff ff       	call   801026e9 <outsl>
80102974:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102977:	eb 17                	jmp    80102990 <idestart+0x193>
    outb(0x1f7, read_cmd);
80102979:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010297c:	0f b6 c0             	movzbl %al,%eax
8010297f:	83 ec 08             	sub    $0x8,%esp
80102982:	50                   	push   %eax
80102983:	68 f7 01 00 00       	push   $0x1f7
80102988:	e8 3b fd ff ff       	call   801026c8 <outb>
8010298d:	83 c4 10             	add    $0x10,%esp
}
80102990:	90                   	nop
80102991:	c9                   	leave  
80102992:	c3                   	ret    

80102993 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102993:	f3 0f 1e fb          	endbr32 
80102997:	55                   	push   %ebp
80102998:	89 e5                	mov    %esp,%ebp
8010299a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010299d:	83 ec 0c             	sub    $0xc,%esp
801029a0:	68 00 c6 10 80       	push   $0x8010c600
801029a5:	e8 3c 28 00 00       	call   801051e6 <acquire>
801029aa:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
801029ad:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801029b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801029b9:	75 15                	jne    801029d0 <ideintr+0x3d>
    release(&idelock);
801029bb:	83 ec 0c             	sub    $0xc,%esp
801029be:	68 00 c6 10 80       	push   $0x8010c600
801029c3:	e8 90 28 00 00       	call   80105258 <release>
801029c8:	83 c4 10             	add    $0x10,%esp
    return;
801029cb:	e9 9a 00 00 00       	jmp    80102a6a <ideintr+0xd7>
  }
  idequeue = b->qnext;
801029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029d3:	8b 40 58             	mov    0x58(%eax),%eax
801029d6:	a3 34 c6 10 80       	mov    %eax,0x8010c634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029de:	8b 00                	mov    (%eax),%eax
801029e0:	83 e0 04             	and    $0x4,%eax
801029e3:	85 c0                	test   %eax,%eax
801029e5:	75 2d                	jne    80102a14 <ideintr+0x81>
801029e7:	83 ec 0c             	sub    $0xc,%esp
801029ea:	6a 01                	push   $0x1
801029ec:	e8 1e fd ff ff       	call   8010270f <idewait>
801029f1:	83 c4 10             	add    $0x10,%esp
801029f4:	85 c0                	test   %eax,%eax
801029f6:	78 1c                	js     80102a14 <ideintr+0x81>
    insl(0x1f0, b->data, BSIZE/4);
801029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029fb:	83 c0 5c             	add    $0x5c,%eax
801029fe:	83 ec 04             	sub    $0x4,%esp
80102a01:	68 80 00 00 00       	push   $0x80
80102a06:	50                   	push   %eax
80102a07:	68 f0 01 00 00       	push   $0x1f0
80102a0c:	e8 91 fc ff ff       	call   801026a2 <insl>
80102a11:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a17:	8b 00                	mov    (%eax),%eax
80102a19:	83 c8 02             	or     $0x2,%eax
80102a1c:	89 c2                	mov    %eax,%edx
80102a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a21:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a26:	8b 00                	mov    (%eax),%eax
80102a28:	83 e0 fb             	and    $0xfffffffb,%eax
80102a2b:	89 c2                	mov    %eax,%edx
80102a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a30:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102a32:	83 ec 0c             	sub    $0xc,%esp
80102a35:	ff 75 f4             	pushl  -0xc(%ebp)
80102a38:	e8 29 24 00 00       	call   80104e66 <wakeup>
80102a3d:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102a40:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102a45:	85 c0                	test   %eax,%eax
80102a47:	74 11                	je     80102a5a <ideintr+0xc7>
    idestart(idequeue);
80102a49:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102a4e:	83 ec 0c             	sub    $0xc,%esp
80102a51:	50                   	push   %eax
80102a52:	e8 a6 fd ff ff       	call   801027fd <idestart>
80102a57:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102a5a:	83 ec 0c             	sub    $0xc,%esp
80102a5d:	68 00 c6 10 80       	push   $0x8010c600
80102a62:	e8 f1 27 00 00       	call   80105258 <release>
80102a67:	83 c4 10             	add    $0x10,%esp
}
80102a6a:	c9                   	leave  
80102a6b:	c3                   	ret    

80102a6c <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102a6c:	f3 0f 1e fb          	endbr32 
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102a76:	8b 45 08             	mov    0x8(%ebp),%eax
80102a79:	83 c0 0c             	add    $0xc,%eax
80102a7c:	83 ec 0c             	sub    $0xc,%esp
80102a7f:	50                   	push   %eax
80102a80:	e8 a2 26 00 00       	call   80105127 <holdingsleep>
80102a85:	83 c4 10             	add    $0x10,%esp
80102a88:	85 c0                	test   %eax,%eax
80102a8a:	75 0d                	jne    80102a99 <iderw+0x2d>
    panic("iderw: buf not locked");
80102a8c:	83 ec 0c             	sub    $0xc,%esp
80102a8f:	68 7a 91 10 80       	push   $0x8010917a
80102a94:	e8 6f db ff ff       	call   80100608 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102a99:	8b 45 08             	mov    0x8(%ebp),%eax
80102a9c:	8b 00                	mov    (%eax),%eax
80102a9e:	83 e0 06             	and    $0x6,%eax
80102aa1:	83 f8 02             	cmp    $0x2,%eax
80102aa4:	75 0d                	jne    80102ab3 <iderw+0x47>
    panic("iderw: nothing to do");
80102aa6:	83 ec 0c             	sub    $0xc,%esp
80102aa9:	68 90 91 10 80       	push   $0x80109190
80102aae:	e8 55 db ff ff       	call   80100608 <panic>
  if(b->dev != 0 && !havedisk1)
80102ab3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab6:	8b 40 04             	mov    0x4(%eax),%eax
80102ab9:	85 c0                	test   %eax,%eax
80102abb:	74 16                	je     80102ad3 <iderw+0x67>
80102abd:	a1 38 c6 10 80       	mov    0x8010c638,%eax
80102ac2:	85 c0                	test   %eax,%eax
80102ac4:	75 0d                	jne    80102ad3 <iderw+0x67>
    panic("iderw: ide disk 1 not present");
80102ac6:	83 ec 0c             	sub    $0xc,%esp
80102ac9:	68 a5 91 10 80       	push   $0x801091a5
80102ace:	e8 35 db ff ff       	call   80100608 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102ad3:	83 ec 0c             	sub    $0xc,%esp
80102ad6:	68 00 c6 10 80       	push   $0x8010c600
80102adb:	e8 06 27 00 00       	call   801051e6 <acquire>
80102ae0:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae6:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102aed:	c7 45 f4 34 c6 10 80 	movl   $0x8010c634,-0xc(%ebp)
80102af4:	eb 0b                	jmp    80102b01 <iderw+0x95>
80102af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102af9:	8b 00                	mov    (%eax),%eax
80102afb:	83 c0 58             	add    $0x58,%eax
80102afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b04:	8b 00                	mov    (%eax),%eax
80102b06:	85 c0                	test   %eax,%eax
80102b08:	75 ec                	jne    80102af6 <iderw+0x8a>
    ;
  *pp = b;
80102b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b0d:	8b 55 08             	mov    0x8(%ebp),%edx
80102b10:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102b12:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102b17:	39 45 08             	cmp    %eax,0x8(%ebp)
80102b1a:	75 23                	jne    80102b3f <iderw+0xd3>
    idestart(b);
80102b1c:	83 ec 0c             	sub    $0xc,%esp
80102b1f:	ff 75 08             	pushl  0x8(%ebp)
80102b22:	e8 d6 fc ff ff       	call   801027fd <idestart>
80102b27:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b2a:	eb 13                	jmp    80102b3f <iderw+0xd3>
    sleep(b, &idelock);
80102b2c:	83 ec 08             	sub    $0x8,%esp
80102b2f:	68 00 c6 10 80       	push   $0x8010c600
80102b34:	ff 75 08             	pushl  0x8(%ebp)
80102b37:	e8 38 22 00 00       	call   80104d74 <sleep>
80102b3c:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b3f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b42:	8b 00                	mov    (%eax),%eax
80102b44:	83 e0 06             	and    $0x6,%eax
80102b47:	83 f8 02             	cmp    $0x2,%eax
80102b4a:	75 e0                	jne    80102b2c <iderw+0xc0>
  }


  release(&idelock);
80102b4c:	83 ec 0c             	sub    $0xc,%esp
80102b4f:	68 00 c6 10 80       	push   $0x8010c600
80102b54:	e8 ff 26 00 00       	call   80105258 <release>
80102b59:	83 c4 10             	add    $0x10,%esp
}
80102b5c:	90                   	nop
80102b5d:	c9                   	leave  
80102b5e:	c3                   	ret    

80102b5f <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102b5f:	f3 0f 1e fb          	endbr32 
80102b63:	55                   	push   %ebp
80102b64:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b66:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102b6b:	8b 55 08             	mov    0x8(%ebp),%edx
80102b6e:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102b70:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102b75:	8b 40 10             	mov    0x10(%eax),%eax
}
80102b78:	5d                   	pop    %ebp
80102b79:	c3                   	ret    

80102b7a <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102b7a:	f3 0f 1e fb          	endbr32 
80102b7e:	55                   	push   %ebp
80102b7f:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b81:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102b86:	8b 55 08             	mov    0x8(%ebp),%edx
80102b89:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102b8b:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102b90:	8b 55 0c             	mov    0xc(%ebp),%edx
80102b93:	89 50 10             	mov    %edx,0x10(%eax)
}
80102b96:	90                   	nop
80102b97:	5d                   	pop    %ebp
80102b98:	c3                   	ret    

80102b99 <ioapicinit>:

void
ioapicinit(void)
{
80102b99:	f3 0f 1e fb          	endbr32 
80102b9d:	55                   	push   %ebp
80102b9e:	89 e5                	mov    %esp,%ebp
80102ba0:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102ba3:	c7 05 d4 46 11 80 00 	movl   $0xfec00000,0x801146d4
80102baa:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102bad:	6a 01                	push   $0x1
80102baf:	e8 ab ff ff ff       	call   80102b5f <ioapicread>
80102bb4:	83 c4 04             	add    $0x4,%esp
80102bb7:	c1 e8 10             	shr    $0x10,%eax
80102bba:	25 ff 00 00 00       	and    $0xff,%eax
80102bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102bc2:	6a 00                	push   $0x0
80102bc4:	e8 96 ff ff ff       	call   80102b5f <ioapicread>
80102bc9:	83 c4 04             	add    $0x4,%esp
80102bcc:	c1 e8 18             	shr    $0x18,%eax
80102bcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102bd2:	0f b6 05 00 48 11 80 	movzbl 0x80114800,%eax
80102bd9:	0f b6 c0             	movzbl %al,%eax
80102bdc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102bdf:	74 10                	je     80102bf1 <ioapicinit+0x58>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102be1:	83 ec 0c             	sub    $0xc,%esp
80102be4:	68 c4 91 10 80       	push   $0x801091c4
80102be9:	e8 2a d8 ff ff       	call   80100418 <cprintf>
80102bee:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102bf1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102bf8:	eb 3f                	jmp    80102c39 <ioapicinit+0xa0>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bfd:	83 c0 20             	add    $0x20,%eax
80102c00:	0d 00 00 01 00       	or     $0x10000,%eax
80102c05:	89 c2                	mov    %eax,%edx
80102c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c0a:	83 c0 08             	add    $0x8,%eax
80102c0d:	01 c0                	add    %eax,%eax
80102c0f:	83 ec 08             	sub    $0x8,%esp
80102c12:	52                   	push   %edx
80102c13:	50                   	push   %eax
80102c14:	e8 61 ff ff ff       	call   80102b7a <ioapicwrite>
80102c19:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c1f:	83 c0 08             	add    $0x8,%eax
80102c22:	01 c0                	add    %eax,%eax
80102c24:	83 c0 01             	add    $0x1,%eax
80102c27:	83 ec 08             	sub    $0x8,%esp
80102c2a:	6a 00                	push   $0x0
80102c2c:	50                   	push   %eax
80102c2d:	e8 48 ff ff ff       	call   80102b7a <ioapicwrite>
80102c32:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102c35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102c3f:	7e b9                	jle    80102bfa <ioapicinit+0x61>
  }
}
80102c41:	90                   	nop
80102c42:	90                   	nop
80102c43:	c9                   	leave  
80102c44:	c3                   	ret    

80102c45 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102c45:	f3 0f 1e fb          	endbr32 
80102c49:	55                   	push   %ebp
80102c4a:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80102c4f:	83 c0 20             	add    $0x20,%eax
80102c52:	89 c2                	mov    %eax,%edx
80102c54:	8b 45 08             	mov    0x8(%ebp),%eax
80102c57:	83 c0 08             	add    $0x8,%eax
80102c5a:	01 c0                	add    %eax,%eax
80102c5c:	52                   	push   %edx
80102c5d:	50                   	push   %eax
80102c5e:	e8 17 ff ff ff       	call   80102b7a <ioapicwrite>
80102c63:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102c66:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c69:	c1 e0 18             	shl    $0x18,%eax
80102c6c:	89 c2                	mov    %eax,%edx
80102c6e:	8b 45 08             	mov    0x8(%ebp),%eax
80102c71:	83 c0 08             	add    $0x8,%eax
80102c74:	01 c0                	add    %eax,%eax
80102c76:	83 c0 01             	add    $0x1,%eax
80102c79:	52                   	push   %edx
80102c7a:	50                   	push   %eax
80102c7b:	e8 fa fe ff ff       	call   80102b7a <ioapicwrite>
80102c80:	83 c4 08             	add    $0x8,%esp
}
80102c83:	90                   	nop
80102c84:	c9                   	leave  
80102c85:	c3                   	ret    

80102c86 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102c86:	f3 0f 1e fb          	endbr32 
80102c8a:	55                   	push   %ebp
80102c8b:	89 e5                	mov    %esp,%ebp
80102c8d:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102c90:	83 ec 08             	sub    $0x8,%esp
80102c93:	68 f8 91 10 80       	push   $0x801091f8
80102c98:	68 e0 46 11 80       	push   $0x801146e0
80102c9d:	e8 1e 25 00 00       	call   801051c0 <initlock>
80102ca2:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ca5:	c7 05 14 47 11 80 00 	movl   $0x0,0x80114714
80102cac:	00 00 00 
  freerange(vstart, vend);
80102caf:	83 ec 08             	sub    $0x8,%esp
80102cb2:	ff 75 0c             	pushl  0xc(%ebp)
80102cb5:	ff 75 08             	pushl  0x8(%ebp)
80102cb8:	e8 2e 00 00 00       	call   80102ceb <freerange>
80102cbd:	83 c4 10             	add    $0x10,%esp
}
80102cc0:	90                   	nop
80102cc1:	c9                   	leave  
80102cc2:	c3                   	ret    

80102cc3 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102cc3:	f3 0f 1e fb          	endbr32 
80102cc7:	55                   	push   %ebp
80102cc8:	89 e5                	mov    %esp,%ebp
80102cca:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102ccd:	83 ec 08             	sub    $0x8,%esp
80102cd0:	ff 75 0c             	pushl  0xc(%ebp)
80102cd3:	ff 75 08             	pushl  0x8(%ebp)
80102cd6:	e8 10 00 00 00       	call   80102ceb <freerange>
80102cdb:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102cde:	c7 05 14 47 11 80 01 	movl   $0x1,0x80114714
80102ce5:	00 00 00 
}
80102ce8:	90                   	nop
80102ce9:	c9                   	leave  
80102cea:	c3                   	ret    

80102ceb <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ceb:	f3 0f 1e fb          	endbr32 
80102cef:	55                   	push   %ebp
80102cf0:	89 e5                	mov    %esp,%ebp
80102cf2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf8:	05 ff 0f 00 00       	add    $0xfff,%eax
80102cfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d05:	eb 15                	jmp    80102d1c <freerange+0x31>
    kfree(p);
80102d07:	83 ec 0c             	sub    $0xc,%esp
80102d0a:	ff 75 f4             	pushl  -0xc(%ebp)
80102d0d:	e8 1b 00 00 00       	call   80102d2d <kfree>
80102d12:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d15:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d1f:	05 00 10 00 00       	add    $0x1000,%eax
80102d24:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102d27:	73 de                	jae    80102d07 <freerange+0x1c>
}
80102d29:	90                   	nop
80102d2a:	90                   	nop
80102d2b:	c9                   	leave  
80102d2c:	c3                   	ret    

80102d2d <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102d2d:	f3 0f 1e fb          	endbr32 
80102d31:	55                   	push   %ebp
80102d32:	89 e5                	mov    %esp,%ebp
80102d34:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102d37:	8b 45 08             	mov    0x8(%ebp),%eax
80102d3a:	25 ff 0f 00 00       	and    $0xfff,%eax
80102d3f:	85 c0                	test   %eax,%eax
80102d41:	75 18                	jne    80102d5b <kfree+0x2e>
80102d43:	81 7d 08 48 79 11 80 	cmpl   $0x80117948,0x8(%ebp)
80102d4a:	72 0f                	jb     80102d5b <kfree+0x2e>
80102d4c:	8b 45 08             	mov    0x8(%ebp),%eax
80102d4f:	05 00 00 00 80       	add    $0x80000000,%eax
80102d54:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102d59:	76 0d                	jbe    80102d68 <kfree+0x3b>
    panic("kfree");
80102d5b:	83 ec 0c             	sub    $0xc,%esp
80102d5e:	68 fd 91 10 80       	push   $0x801091fd
80102d63:	e8 a0 d8 ff ff       	call   80100608 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102d68:	83 ec 04             	sub    $0x4,%esp
80102d6b:	68 00 10 00 00       	push   $0x1000
80102d70:	6a 01                	push   $0x1
80102d72:	ff 75 08             	pushl  0x8(%ebp)
80102d75:	e8 0b 27 00 00       	call   80105485 <memset>
80102d7a:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102d7d:	a1 14 47 11 80       	mov    0x80114714,%eax
80102d82:	85 c0                	test   %eax,%eax
80102d84:	74 10                	je     80102d96 <kfree+0x69>
    acquire(&kmem.lock);
80102d86:	83 ec 0c             	sub    $0xc,%esp
80102d89:	68 e0 46 11 80       	push   $0x801146e0
80102d8e:	e8 53 24 00 00       	call   801051e6 <acquire>
80102d93:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102d96:	8b 45 08             	mov    0x8(%ebp),%eax
80102d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102d9c:	8b 15 18 47 11 80    	mov    0x80114718,%edx
80102da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102da5:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102daa:	a3 18 47 11 80       	mov    %eax,0x80114718
  if(kmem.use_lock)
80102daf:	a1 14 47 11 80       	mov    0x80114714,%eax
80102db4:	85 c0                	test   %eax,%eax
80102db6:	74 10                	je     80102dc8 <kfree+0x9b>
    release(&kmem.lock);
80102db8:	83 ec 0c             	sub    $0xc,%esp
80102dbb:	68 e0 46 11 80       	push   $0x801146e0
80102dc0:	e8 93 24 00 00       	call   80105258 <release>
80102dc5:	83 c4 10             	add    $0x10,%esp
}
80102dc8:	90                   	nop
80102dc9:	c9                   	leave  
80102dca:	c3                   	ret    

80102dcb <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102dcb:	f3 0f 1e fb          	endbr32 
80102dcf:	55                   	push   %ebp
80102dd0:	89 e5                	mov    %esp,%ebp
80102dd2:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102dd5:	a1 14 47 11 80       	mov    0x80114714,%eax
80102dda:	85 c0                	test   %eax,%eax
80102ddc:	74 10                	je     80102dee <kalloc+0x23>
    acquire(&kmem.lock);
80102dde:	83 ec 0c             	sub    $0xc,%esp
80102de1:	68 e0 46 11 80       	push   $0x801146e0
80102de6:	e8 fb 23 00 00       	call   801051e6 <acquire>
80102deb:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102dee:	a1 18 47 11 80       	mov    0x80114718,%eax
80102df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102df6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102dfa:	74 0a                	je     80102e06 <kalloc+0x3b>
    kmem.freelist = r->next;
80102dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dff:	8b 00                	mov    (%eax),%eax
80102e01:	a3 18 47 11 80       	mov    %eax,0x80114718
  if(kmem.use_lock)
80102e06:	a1 14 47 11 80       	mov    0x80114714,%eax
80102e0b:	85 c0                	test   %eax,%eax
80102e0d:	74 10                	je     80102e1f <kalloc+0x54>
    release(&kmem.lock);
80102e0f:	83 ec 0c             	sub    $0xc,%esp
80102e12:	68 e0 46 11 80       	push   $0x801146e0
80102e17:	e8 3c 24 00 00       	call   80105258 <release>
80102e1c:	83 c4 10             	add    $0x10,%esp
  cprintf("p4Debug : kalloc returns %d %x\n", PPN(V2P(r)), V2P(r));
80102e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e22:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80102e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e2b:	05 00 00 00 80       	add    $0x80000000,%eax
80102e30:	c1 e8 0c             	shr    $0xc,%eax
80102e33:	83 ec 04             	sub    $0x4,%esp
80102e36:	52                   	push   %edx
80102e37:	50                   	push   %eax
80102e38:	68 04 92 10 80       	push   $0x80109204
80102e3d:	e8 d6 d5 ff ff       	call   80100418 <cprintf>
80102e42:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102e48:	c9                   	leave  
80102e49:	c3                   	ret    

80102e4a <inb>:
{
80102e4a:	55                   	push   %ebp
80102e4b:	89 e5                	mov    %esp,%ebp
80102e4d:	83 ec 14             	sub    $0x14,%esp
80102e50:	8b 45 08             	mov    0x8(%ebp),%eax
80102e53:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e57:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e5b:	89 c2                	mov    %eax,%edx
80102e5d:	ec                   	in     (%dx),%al
80102e5e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e61:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e65:	c9                   	leave  
80102e66:	c3                   	ret    

80102e67 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102e67:	f3 0f 1e fb          	endbr32 
80102e6b:	55                   	push   %ebp
80102e6c:	89 e5                	mov    %esp,%ebp
80102e6e:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102e71:	6a 64                	push   $0x64
80102e73:	e8 d2 ff ff ff       	call   80102e4a <inb>
80102e78:	83 c4 04             	add    $0x4,%esp
80102e7b:	0f b6 c0             	movzbl %al,%eax
80102e7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e84:	83 e0 01             	and    $0x1,%eax
80102e87:	85 c0                	test   %eax,%eax
80102e89:	75 0a                	jne    80102e95 <kbdgetc+0x2e>
    return -1;
80102e8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e90:	e9 23 01 00 00       	jmp    80102fb8 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102e95:	6a 60                	push   $0x60
80102e97:	e8 ae ff ff ff       	call   80102e4a <inb>
80102e9c:	83 c4 04             	add    $0x4,%esp
80102e9f:	0f b6 c0             	movzbl %al,%eax
80102ea2:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102ea5:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102eac:	75 17                	jne    80102ec5 <kbdgetc+0x5e>
    shift |= E0ESC;
80102eae:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102eb3:	83 c8 40             	or     $0x40,%eax
80102eb6:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80102ebb:	b8 00 00 00 00       	mov    $0x0,%eax
80102ec0:	e9 f3 00 00 00       	jmp    80102fb8 <kbdgetc+0x151>
  } else if(data & 0x80){
80102ec5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ec8:	25 80 00 00 00       	and    $0x80,%eax
80102ecd:	85 c0                	test   %eax,%eax
80102ecf:	74 45                	je     80102f16 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ed1:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102ed6:	83 e0 40             	and    $0x40,%eax
80102ed9:	85 c0                	test   %eax,%eax
80102edb:	75 08                	jne    80102ee5 <kbdgetc+0x7e>
80102edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ee0:	83 e0 7f             	and    $0x7f,%eax
80102ee3:	eb 03                	jmp    80102ee8 <kbdgetc+0x81>
80102ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ee8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102eee:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102ef3:	0f b6 00             	movzbl (%eax),%eax
80102ef6:	83 c8 40             	or     $0x40,%eax
80102ef9:	0f b6 c0             	movzbl %al,%eax
80102efc:	f7 d0                	not    %eax
80102efe:	89 c2                	mov    %eax,%edx
80102f00:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f05:	21 d0                	and    %edx,%eax
80102f07:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80102f0c:	b8 00 00 00 00       	mov    $0x0,%eax
80102f11:	e9 a2 00 00 00       	jmp    80102fb8 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102f16:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f1b:	83 e0 40             	and    $0x40,%eax
80102f1e:	85 c0                	test   %eax,%eax
80102f20:	74 14                	je     80102f36 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f22:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102f29:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f2e:	83 e0 bf             	and    $0xffffffbf,%eax
80102f31:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  }

  shift |= shiftcode[data];
80102f36:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f39:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102f3e:	0f b6 00             	movzbl (%eax),%eax
80102f41:	0f b6 d0             	movzbl %al,%edx
80102f44:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f49:	09 d0                	or     %edx,%eax
80102f4b:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  shift ^= togglecode[data];
80102f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f53:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102f58:	0f b6 00             	movzbl (%eax),%eax
80102f5b:	0f b6 d0             	movzbl %al,%edx
80102f5e:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f63:	31 d0                	xor    %edx,%eax
80102f65:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102f6a:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f6f:	83 e0 03             	and    $0x3,%eax
80102f72:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f7c:	01 d0                	add    %edx,%eax
80102f7e:	0f b6 00             	movzbl (%eax),%eax
80102f81:	0f b6 c0             	movzbl %al,%eax
80102f84:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102f87:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f8c:	83 e0 08             	and    $0x8,%eax
80102f8f:	85 c0                	test   %eax,%eax
80102f91:	74 22                	je     80102fb5 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102f93:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102f97:	76 0c                	jbe    80102fa5 <kbdgetc+0x13e>
80102f99:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102f9d:	77 06                	ja     80102fa5 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102f9f:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102fa3:	eb 10                	jmp    80102fb5 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102fa5:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102fa9:	76 0a                	jbe    80102fb5 <kbdgetc+0x14e>
80102fab:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102faf:	77 04                	ja     80102fb5 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102fb1:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102fb8:	c9                   	leave  
80102fb9:	c3                   	ret    

80102fba <kbdintr>:

void
kbdintr(void)
{
80102fba:	f3 0f 1e fb          	endbr32 
80102fbe:	55                   	push   %ebp
80102fbf:	89 e5                	mov    %esp,%ebp
80102fc1:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102fc4:	83 ec 0c             	sub    $0xc,%esp
80102fc7:	68 67 2e 10 80       	push   $0x80102e67
80102fcc:	e8 d7 d8 ff ff       	call   801008a8 <consoleintr>
80102fd1:	83 c4 10             	add    $0x10,%esp
}
80102fd4:	90                   	nop
80102fd5:	c9                   	leave  
80102fd6:	c3                   	ret    

80102fd7 <inb>:
{
80102fd7:	55                   	push   %ebp
80102fd8:	89 e5                	mov    %esp,%ebp
80102fda:	83 ec 14             	sub    $0x14,%esp
80102fdd:	8b 45 08             	mov    0x8(%ebp),%eax
80102fe0:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fe4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102fe8:	89 c2                	mov    %eax,%edx
80102fea:	ec                   	in     (%dx),%al
80102feb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102fee:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ff2:	c9                   	leave  
80102ff3:	c3                   	ret    

80102ff4 <outb>:
{
80102ff4:	55                   	push   %ebp
80102ff5:	89 e5                	mov    %esp,%ebp
80102ff7:	83 ec 08             	sub    $0x8,%esp
80102ffa:	8b 45 08             	mov    0x8(%ebp),%eax
80102ffd:	8b 55 0c             	mov    0xc(%ebp),%edx
80103000:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103004:	89 d0                	mov    %edx,%eax
80103006:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103009:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010300d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103011:	ee                   	out    %al,(%dx)
}
80103012:	90                   	nop
80103013:	c9                   	leave  
80103014:	c3                   	ret    

80103015 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80103015:	f3 0f 1e fb          	endbr32 
80103019:	55                   	push   %ebp
8010301a:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
8010301c:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80103021:	8b 55 08             	mov    0x8(%ebp),%edx
80103024:	c1 e2 02             	shl    $0x2,%edx
80103027:	01 c2                	add    %eax,%edx
80103029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010302c:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
8010302e:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80103033:	83 c0 20             	add    $0x20,%eax
80103036:	8b 00                	mov    (%eax),%eax
}
80103038:	90                   	nop
80103039:	5d                   	pop    %ebp
8010303a:	c3                   	ret    

8010303b <lapicinit>:

void
lapicinit(void)
{
8010303b:	f3 0f 1e fb          	endbr32 
8010303f:	55                   	push   %ebp
80103040:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80103042:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80103047:	85 c0                	test   %eax,%eax
80103049:	0f 84 0c 01 00 00    	je     8010315b <lapicinit+0x120>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010304f:	68 3f 01 00 00       	push   $0x13f
80103054:	6a 3c                	push   $0x3c
80103056:	e8 ba ff ff ff       	call   80103015 <lapicw>
8010305b:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
8010305e:	6a 0b                	push   $0xb
80103060:	68 f8 00 00 00       	push   $0xf8
80103065:	e8 ab ff ff ff       	call   80103015 <lapicw>
8010306a:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010306d:	68 20 00 02 00       	push   $0x20020
80103072:	68 c8 00 00 00       	push   $0xc8
80103077:	e8 99 ff ff ff       	call   80103015 <lapicw>
8010307c:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
8010307f:	68 80 96 98 00       	push   $0x989680
80103084:	68 e0 00 00 00       	push   $0xe0
80103089:	e8 87 ff ff ff       	call   80103015 <lapicw>
8010308e:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80103091:	68 00 00 01 00       	push   $0x10000
80103096:	68 d4 00 00 00       	push   $0xd4
8010309b:	e8 75 ff ff ff       	call   80103015 <lapicw>
801030a0:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
801030a3:	68 00 00 01 00       	push   $0x10000
801030a8:	68 d8 00 00 00       	push   $0xd8
801030ad:	e8 63 ff ff ff       	call   80103015 <lapicw>
801030b2:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801030b5:	a1 1c 47 11 80       	mov    0x8011471c,%eax
801030ba:	83 c0 30             	add    $0x30,%eax
801030bd:	8b 00                	mov    (%eax),%eax
801030bf:	c1 e8 10             	shr    $0x10,%eax
801030c2:	25 fc 00 00 00       	and    $0xfc,%eax
801030c7:	85 c0                	test   %eax,%eax
801030c9:	74 12                	je     801030dd <lapicinit+0xa2>
    lapicw(PCINT, MASKED);
801030cb:	68 00 00 01 00       	push   $0x10000
801030d0:	68 d0 00 00 00       	push   $0xd0
801030d5:	e8 3b ff ff ff       	call   80103015 <lapicw>
801030da:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801030dd:	6a 33                	push   $0x33
801030df:	68 dc 00 00 00       	push   $0xdc
801030e4:	e8 2c ff ff ff       	call   80103015 <lapicw>
801030e9:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
801030ec:	6a 00                	push   $0x0
801030ee:	68 a0 00 00 00       	push   $0xa0
801030f3:	e8 1d ff ff ff       	call   80103015 <lapicw>
801030f8:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
801030fb:	6a 00                	push   $0x0
801030fd:	68 a0 00 00 00       	push   $0xa0
80103102:	e8 0e ff ff ff       	call   80103015 <lapicw>
80103107:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
8010310a:	6a 00                	push   $0x0
8010310c:	6a 2c                	push   $0x2c
8010310e:	e8 02 ff ff ff       	call   80103015 <lapicw>
80103113:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103116:	6a 00                	push   $0x0
80103118:	68 c4 00 00 00       	push   $0xc4
8010311d:	e8 f3 fe ff ff       	call   80103015 <lapicw>
80103122:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103125:	68 00 85 08 00       	push   $0x88500
8010312a:	68 c0 00 00 00       	push   $0xc0
8010312f:	e8 e1 fe ff ff       	call   80103015 <lapicw>
80103134:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103137:	90                   	nop
80103138:	a1 1c 47 11 80       	mov    0x8011471c,%eax
8010313d:	05 00 03 00 00       	add    $0x300,%eax
80103142:	8b 00                	mov    (%eax),%eax
80103144:	25 00 10 00 00       	and    $0x1000,%eax
80103149:	85 c0                	test   %eax,%eax
8010314b:	75 eb                	jne    80103138 <lapicinit+0xfd>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
8010314d:	6a 00                	push   $0x0
8010314f:	6a 20                	push   $0x20
80103151:	e8 bf fe ff ff       	call   80103015 <lapicw>
80103156:	83 c4 08             	add    $0x8,%esp
80103159:	eb 01                	jmp    8010315c <lapicinit+0x121>
    return;
8010315b:	90                   	nop
}
8010315c:	c9                   	leave  
8010315d:	c3                   	ret    

8010315e <lapicid>:

int
lapicid(void)
{
8010315e:	f3 0f 1e fb          	endbr32 
80103162:	55                   	push   %ebp
80103163:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80103165:	a1 1c 47 11 80       	mov    0x8011471c,%eax
8010316a:	85 c0                	test   %eax,%eax
8010316c:	75 07                	jne    80103175 <lapicid+0x17>
    return 0;
8010316e:	b8 00 00 00 00       	mov    $0x0,%eax
80103173:	eb 0d                	jmp    80103182 <lapicid+0x24>
  return lapic[ID] >> 24;
80103175:	a1 1c 47 11 80       	mov    0x8011471c,%eax
8010317a:	83 c0 20             	add    $0x20,%eax
8010317d:	8b 00                	mov    (%eax),%eax
8010317f:	c1 e8 18             	shr    $0x18,%eax
}
80103182:	5d                   	pop    %ebp
80103183:	c3                   	ret    

80103184 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103184:	f3 0f 1e fb          	endbr32 
80103188:	55                   	push   %ebp
80103189:	89 e5                	mov    %esp,%ebp
  if(lapic)
8010318b:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80103190:	85 c0                	test   %eax,%eax
80103192:	74 0c                	je     801031a0 <lapiceoi+0x1c>
    lapicw(EOI, 0);
80103194:	6a 00                	push   $0x0
80103196:	6a 2c                	push   $0x2c
80103198:	e8 78 fe ff ff       	call   80103015 <lapicw>
8010319d:	83 c4 08             	add    $0x8,%esp
}
801031a0:	90                   	nop
801031a1:	c9                   	leave  
801031a2:	c3                   	ret    

801031a3 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801031a3:	f3 0f 1e fb          	endbr32 
801031a7:	55                   	push   %ebp
801031a8:	89 e5                	mov    %esp,%ebp
}
801031aa:	90                   	nop
801031ab:	5d                   	pop    %ebp
801031ac:	c3                   	ret    

801031ad <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801031ad:	f3 0f 1e fb          	endbr32 
801031b1:	55                   	push   %ebp
801031b2:	89 e5                	mov    %esp,%ebp
801031b4:	83 ec 14             	sub    $0x14,%esp
801031b7:	8b 45 08             	mov    0x8(%ebp),%eax
801031ba:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801031bd:	6a 0f                	push   $0xf
801031bf:	6a 70                	push   $0x70
801031c1:	e8 2e fe ff ff       	call   80102ff4 <outb>
801031c6:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801031c9:	6a 0a                	push   $0xa
801031cb:	6a 71                	push   $0x71
801031cd:	e8 22 fe ff ff       	call   80102ff4 <outb>
801031d2:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801031d5:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801031dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
801031df:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801031e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801031e7:	c1 e8 04             	shr    $0x4,%eax
801031ea:	89 c2                	mov    %eax,%edx
801031ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
801031ef:	83 c0 02             	add    $0x2,%eax
801031f2:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801031f5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801031f9:	c1 e0 18             	shl    $0x18,%eax
801031fc:	50                   	push   %eax
801031fd:	68 c4 00 00 00       	push   $0xc4
80103202:	e8 0e fe ff ff       	call   80103015 <lapicw>
80103207:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010320a:	68 00 c5 00 00       	push   $0xc500
8010320f:	68 c0 00 00 00       	push   $0xc0
80103214:	e8 fc fd ff ff       	call   80103015 <lapicw>
80103219:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010321c:	68 c8 00 00 00       	push   $0xc8
80103221:	e8 7d ff ff ff       	call   801031a3 <microdelay>
80103226:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103229:	68 00 85 00 00       	push   $0x8500
8010322e:	68 c0 00 00 00       	push   $0xc0
80103233:	e8 dd fd ff ff       	call   80103015 <lapicw>
80103238:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010323b:	6a 64                	push   $0x64
8010323d:	e8 61 ff ff ff       	call   801031a3 <microdelay>
80103242:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010324c:	eb 3d                	jmp    8010328b <lapicstartap+0xde>
    lapicw(ICRHI, apicid<<24);
8010324e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103252:	c1 e0 18             	shl    $0x18,%eax
80103255:	50                   	push   %eax
80103256:	68 c4 00 00 00       	push   $0xc4
8010325b:	e8 b5 fd ff ff       	call   80103015 <lapicw>
80103260:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103263:	8b 45 0c             	mov    0xc(%ebp),%eax
80103266:	c1 e8 0c             	shr    $0xc,%eax
80103269:	80 cc 06             	or     $0x6,%ah
8010326c:	50                   	push   %eax
8010326d:	68 c0 00 00 00       	push   $0xc0
80103272:	e8 9e fd ff ff       	call   80103015 <lapicw>
80103277:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010327a:	68 c8 00 00 00       	push   $0xc8
8010327f:	e8 1f ff ff ff       	call   801031a3 <microdelay>
80103284:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80103287:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010328b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010328f:	7e bd                	jle    8010324e <lapicstartap+0xa1>
  }
}
80103291:	90                   	nop
80103292:	90                   	nop
80103293:	c9                   	leave  
80103294:	c3                   	ret    

80103295 <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
80103295:	f3 0f 1e fb          	endbr32 
80103299:	55                   	push   %ebp
8010329a:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010329c:	8b 45 08             	mov    0x8(%ebp),%eax
8010329f:	0f b6 c0             	movzbl %al,%eax
801032a2:	50                   	push   %eax
801032a3:	6a 70                	push   $0x70
801032a5:	e8 4a fd ff ff       	call   80102ff4 <outb>
801032aa:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801032ad:	68 c8 00 00 00       	push   $0xc8
801032b2:	e8 ec fe ff ff       	call   801031a3 <microdelay>
801032b7:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801032ba:	6a 71                	push   $0x71
801032bc:	e8 16 fd ff ff       	call   80102fd7 <inb>
801032c1:	83 c4 04             	add    $0x4,%esp
801032c4:	0f b6 c0             	movzbl %al,%eax
}
801032c7:	c9                   	leave  
801032c8:	c3                   	ret    

801032c9 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801032c9:	f3 0f 1e fb          	endbr32 
801032cd:	55                   	push   %ebp
801032ce:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801032d0:	6a 00                	push   $0x0
801032d2:	e8 be ff ff ff       	call   80103295 <cmos_read>
801032d7:	83 c4 04             	add    $0x4,%esp
801032da:	8b 55 08             	mov    0x8(%ebp),%edx
801032dd:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801032df:	6a 02                	push   $0x2
801032e1:	e8 af ff ff ff       	call   80103295 <cmos_read>
801032e6:	83 c4 04             	add    $0x4,%esp
801032e9:	8b 55 08             	mov    0x8(%ebp),%edx
801032ec:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801032ef:	6a 04                	push   $0x4
801032f1:	e8 9f ff ff ff       	call   80103295 <cmos_read>
801032f6:	83 c4 04             	add    $0x4,%esp
801032f9:	8b 55 08             	mov    0x8(%ebp),%edx
801032fc:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801032ff:	6a 07                	push   $0x7
80103301:	e8 8f ff ff ff       	call   80103295 <cmos_read>
80103306:	83 c4 04             	add    $0x4,%esp
80103309:	8b 55 08             	mov    0x8(%ebp),%edx
8010330c:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010330f:	6a 08                	push   $0x8
80103311:	e8 7f ff ff ff       	call   80103295 <cmos_read>
80103316:	83 c4 04             	add    $0x4,%esp
80103319:	8b 55 08             	mov    0x8(%ebp),%edx
8010331c:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010331f:	6a 09                	push   $0x9
80103321:	e8 6f ff ff ff       	call   80103295 <cmos_read>
80103326:	83 c4 04             	add    $0x4,%esp
80103329:	8b 55 08             	mov    0x8(%ebp),%edx
8010332c:	89 42 14             	mov    %eax,0x14(%edx)
}
8010332f:	90                   	nop
80103330:	c9                   	leave  
80103331:	c3                   	ret    

80103332 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103332:	f3 0f 1e fb          	endbr32 
80103336:	55                   	push   %ebp
80103337:	89 e5                	mov    %esp,%ebp
80103339:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010333c:	6a 0b                	push   $0xb
8010333e:	e8 52 ff ff ff       	call   80103295 <cmos_read>
80103343:	83 c4 04             	add    $0x4,%esp
80103346:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010334c:	83 e0 04             	and    $0x4,%eax
8010334f:	85 c0                	test   %eax,%eax
80103351:	0f 94 c0             	sete   %al
80103354:	0f b6 c0             	movzbl %al,%eax
80103357:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010335a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010335d:	50                   	push   %eax
8010335e:	e8 66 ff ff ff       	call   801032c9 <fill_rtcdate>
80103363:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103366:	6a 0a                	push   $0xa
80103368:	e8 28 ff ff ff       	call   80103295 <cmos_read>
8010336d:	83 c4 04             	add    $0x4,%esp
80103370:	25 80 00 00 00       	and    $0x80,%eax
80103375:	85 c0                	test   %eax,%eax
80103377:	75 27                	jne    801033a0 <cmostime+0x6e>
        continue;
    fill_rtcdate(&t2);
80103379:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010337c:	50                   	push   %eax
8010337d:	e8 47 ff ff ff       	call   801032c9 <fill_rtcdate>
80103382:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103385:	83 ec 04             	sub    $0x4,%esp
80103388:	6a 18                	push   $0x18
8010338a:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010338d:	50                   	push   %eax
8010338e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103391:	50                   	push   %eax
80103392:	e8 59 21 00 00       	call   801054f0 <memcmp>
80103397:	83 c4 10             	add    $0x10,%esp
8010339a:	85 c0                	test   %eax,%eax
8010339c:	74 05                	je     801033a3 <cmostime+0x71>
8010339e:	eb ba                	jmp    8010335a <cmostime+0x28>
        continue;
801033a0:	90                   	nop
    fill_rtcdate(&t1);
801033a1:	eb b7                	jmp    8010335a <cmostime+0x28>
      break;
801033a3:	90                   	nop
  }

  // convert
  if(bcd) {
801033a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801033a8:	0f 84 b4 00 00 00    	je     80103462 <cmostime+0x130>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801033ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033b1:	c1 e8 04             	shr    $0x4,%eax
801033b4:	89 c2                	mov    %eax,%edx
801033b6:	89 d0                	mov    %edx,%eax
801033b8:	c1 e0 02             	shl    $0x2,%eax
801033bb:	01 d0                	add    %edx,%eax
801033bd:	01 c0                	add    %eax,%eax
801033bf:	89 c2                	mov    %eax,%edx
801033c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033c4:	83 e0 0f             	and    $0xf,%eax
801033c7:	01 d0                	add    %edx,%eax
801033c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801033cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801033cf:	c1 e8 04             	shr    $0x4,%eax
801033d2:	89 c2                	mov    %eax,%edx
801033d4:	89 d0                	mov    %edx,%eax
801033d6:	c1 e0 02             	shl    $0x2,%eax
801033d9:	01 d0                	add    %edx,%eax
801033db:	01 c0                	add    %eax,%eax
801033dd:	89 c2                	mov    %eax,%edx
801033df:	8b 45 dc             	mov    -0x24(%ebp),%eax
801033e2:	83 e0 0f             	and    $0xf,%eax
801033e5:	01 d0                	add    %edx,%eax
801033e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801033ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
801033ed:	c1 e8 04             	shr    $0x4,%eax
801033f0:	89 c2                	mov    %eax,%edx
801033f2:	89 d0                	mov    %edx,%eax
801033f4:	c1 e0 02             	shl    $0x2,%eax
801033f7:	01 d0                	add    %edx,%eax
801033f9:	01 c0                	add    %eax,%eax
801033fb:	89 c2                	mov    %eax,%edx
801033fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103400:	83 e0 0f             	and    $0xf,%eax
80103403:	01 d0                	add    %edx,%eax
80103405:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010340b:	c1 e8 04             	shr    $0x4,%eax
8010340e:	89 c2                	mov    %eax,%edx
80103410:	89 d0                	mov    %edx,%eax
80103412:	c1 e0 02             	shl    $0x2,%eax
80103415:	01 d0                	add    %edx,%eax
80103417:	01 c0                	add    %eax,%eax
80103419:	89 c2                	mov    %eax,%edx
8010341b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010341e:	83 e0 0f             	and    $0xf,%eax
80103421:	01 d0                	add    %edx,%eax
80103423:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103426:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103429:	c1 e8 04             	shr    $0x4,%eax
8010342c:	89 c2                	mov    %eax,%edx
8010342e:	89 d0                	mov    %edx,%eax
80103430:	c1 e0 02             	shl    $0x2,%eax
80103433:	01 d0                	add    %edx,%eax
80103435:	01 c0                	add    %eax,%eax
80103437:	89 c2                	mov    %eax,%edx
80103439:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010343c:	83 e0 0f             	and    $0xf,%eax
8010343f:	01 d0                	add    %edx,%eax
80103441:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103444:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103447:	c1 e8 04             	shr    $0x4,%eax
8010344a:	89 c2                	mov    %eax,%edx
8010344c:	89 d0                	mov    %edx,%eax
8010344e:	c1 e0 02             	shl    $0x2,%eax
80103451:	01 d0                	add    %edx,%eax
80103453:	01 c0                	add    %eax,%eax
80103455:	89 c2                	mov    %eax,%edx
80103457:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010345a:	83 e0 0f             	and    $0xf,%eax
8010345d:	01 d0                	add    %edx,%eax
8010345f:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103462:	8b 45 08             	mov    0x8(%ebp),%eax
80103465:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103468:	89 10                	mov    %edx,(%eax)
8010346a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010346d:	89 50 04             	mov    %edx,0x4(%eax)
80103470:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103473:	89 50 08             	mov    %edx,0x8(%eax)
80103476:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103479:	89 50 0c             	mov    %edx,0xc(%eax)
8010347c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010347f:	89 50 10             	mov    %edx,0x10(%eax)
80103482:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103485:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103488:	8b 45 08             	mov    0x8(%ebp),%eax
8010348b:	8b 40 14             	mov    0x14(%eax),%eax
8010348e:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103494:	8b 45 08             	mov    0x8(%ebp),%eax
80103497:	89 50 14             	mov    %edx,0x14(%eax)
}
8010349a:	90                   	nop
8010349b:	c9                   	leave  
8010349c:	c3                   	ret    

8010349d <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010349d:	f3 0f 1e fb          	endbr32 
801034a1:	55                   	push   %ebp
801034a2:	89 e5                	mov    %esp,%ebp
801034a4:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801034a7:	83 ec 08             	sub    $0x8,%esp
801034aa:	68 24 92 10 80       	push   $0x80109224
801034af:	68 20 47 11 80       	push   $0x80114720
801034b4:	e8 07 1d 00 00       	call   801051c0 <initlock>
801034b9:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801034bc:	83 ec 08             	sub    $0x8,%esp
801034bf:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034c2:	50                   	push   %eax
801034c3:	ff 75 08             	pushl  0x8(%ebp)
801034c6:	e8 d3 df ff ff       	call   8010149e <readsb>
801034cb:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801034ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034d1:	a3 54 47 11 80       	mov    %eax,0x80114754
  log.size = sb.nlog;
801034d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801034d9:	a3 58 47 11 80       	mov    %eax,0x80114758
  log.dev = dev;
801034de:	8b 45 08             	mov    0x8(%ebp),%eax
801034e1:	a3 64 47 11 80       	mov    %eax,0x80114764
  recover_from_log();
801034e6:	e8 bf 01 00 00       	call   801036aa <recover_from_log>
}
801034eb:	90                   	nop
801034ec:	c9                   	leave  
801034ed:	c3                   	ret    

801034ee <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801034ee:	f3 0f 1e fb          	endbr32 
801034f2:	55                   	push   %ebp
801034f3:	89 e5                	mov    %esp,%ebp
801034f5:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034ff:	e9 95 00 00 00       	jmp    80103599 <install_trans+0xab>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103504:	8b 15 54 47 11 80    	mov    0x80114754,%edx
8010350a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010350d:	01 d0                	add    %edx,%eax
8010350f:	83 c0 01             	add    $0x1,%eax
80103512:	89 c2                	mov    %eax,%edx
80103514:	a1 64 47 11 80       	mov    0x80114764,%eax
80103519:	83 ec 08             	sub    $0x8,%esp
8010351c:	52                   	push   %edx
8010351d:	50                   	push   %eax
8010351e:	e8 b4 cc ff ff       	call   801001d7 <bread>
80103523:	83 c4 10             	add    $0x10,%esp
80103526:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103529:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010352c:	83 c0 10             	add    $0x10,%eax
8010352f:	8b 04 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%eax
80103536:	89 c2                	mov    %eax,%edx
80103538:	a1 64 47 11 80       	mov    0x80114764,%eax
8010353d:	83 ec 08             	sub    $0x8,%esp
80103540:	52                   	push   %edx
80103541:	50                   	push   %eax
80103542:	e8 90 cc ff ff       	call   801001d7 <bread>
80103547:	83 c4 10             	add    $0x10,%esp
8010354a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010354d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103550:	8d 50 5c             	lea    0x5c(%eax),%edx
80103553:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103556:	83 c0 5c             	add    $0x5c,%eax
80103559:	83 ec 04             	sub    $0x4,%esp
8010355c:	68 00 02 00 00       	push   $0x200
80103561:	52                   	push   %edx
80103562:	50                   	push   %eax
80103563:	e8 e4 1f 00 00       	call   8010554c <memmove>
80103568:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010356b:	83 ec 0c             	sub    $0xc,%esp
8010356e:	ff 75 ec             	pushl  -0x14(%ebp)
80103571:	e8 9e cc ff ff       	call   80100214 <bwrite>
80103576:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
80103579:	83 ec 0c             	sub    $0xc,%esp
8010357c:	ff 75 f0             	pushl  -0x10(%ebp)
8010357f:	e8 dd cc ff ff       	call   80100261 <brelse>
80103584:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103587:	83 ec 0c             	sub    $0xc,%esp
8010358a:	ff 75 ec             	pushl  -0x14(%ebp)
8010358d:	e8 cf cc ff ff       	call   80100261 <brelse>
80103592:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103595:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103599:	a1 68 47 11 80       	mov    0x80114768,%eax
8010359e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801035a1:	0f 8c 5d ff ff ff    	jl     80103504 <install_trans+0x16>
  }
}
801035a7:	90                   	nop
801035a8:	90                   	nop
801035a9:	c9                   	leave  
801035aa:	c3                   	ret    

801035ab <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801035ab:	f3 0f 1e fb          	endbr32 
801035af:	55                   	push   %ebp
801035b0:	89 e5                	mov    %esp,%ebp
801035b2:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801035b5:	a1 54 47 11 80       	mov    0x80114754,%eax
801035ba:	89 c2                	mov    %eax,%edx
801035bc:	a1 64 47 11 80       	mov    0x80114764,%eax
801035c1:	83 ec 08             	sub    $0x8,%esp
801035c4:	52                   	push   %edx
801035c5:	50                   	push   %eax
801035c6:	e8 0c cc ff ff       	call   801001d7 <bread>
801035cb:	83 c4 10             	add    $0x10,%esp
801035ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801035d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035d4:	83 c0 5c             	add    $0x5c,%eax
801035d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801035da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035dd:	8b 00                	mov    (%eax),%eax
801035df:	a3 68 47 11 80       	mov    %eax,0x80114768
  for (i = 0; i < log.lh.n; i++) {
801035e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035eb:	eb 1b                	jmp    80103608 <read_head+0x5d>
    log.lh.block[i] = lh->block[i];
801035ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035f3:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801035f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035fa:	83 c2 10             	add    $0x10,%edx
801035fd:	89 04 95 2c 47 11 80 	mov    %eax,-0x7feeb8d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103604:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103608:	a1 68 47 11 80       	mov    0x80114768,%eax
8010360d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103610:	7c db                	jl     801035ed <read_head+0x42>
  }
  brelse(buf);
80103612:	83 ec 0c             	sub    $0xc,%esp
80103615:	ff 75 f0             	pushl  -0x10(%ebp)
80103618:	e8 44 cc ff ff       	call   80100261 <brelse>
8010361d:	83 c4 10             	add    $0x10,%esp
}
80103620:	90                   	nop
80103621:	c9                   	leave  
80103622:	c3                   	ret    

80103623 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103623:	f3 0f 1e fb          	endbr32 
80103627:	55                   	push   %ebp
80103628:	89 e5                	mov    %esp,%ebp
8010362a:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010362d:	a1 54 47 11 80       	mov    0x80114754,%eax
80103632:	89 c2                	mov    %eax,%edx
80103634:	a1 64 47 11 80       	mov    0x80114764,%eax
80103639:	83 ec 08             	sub    $0x8,%esp
8010363c:	52                   	push   %edx
8010363d:	50                   	push   %eax
8010363e:	e8 94 cb ff ff       	call   801001d7 <bread>
80103643:	83 c4 10             	add    $0x10,%esp
80103646:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103649:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010364c:	83 c0 5c             	add    $0x5c,%eax
8010364f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103652:	8b 15 68 47 11 80    	mov    0x80114768,%edx
80103658:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010365b:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010365d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103664:	eb 1b                	jmp    80103681 <write_head+0x5e>
    hb->block[i] = log.lh.block[i];
80103666:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103669:	83 c0 10             	add    $0x10,%eax
8010366c:	8b 0c 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%ecx
80103673:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103676:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103679:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010367d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103681:	a1 68 47 11 80       	mov    0x80114768,%eax
80103686:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103689:	7c db                	jl     80103666 <write_head+0x43>
  }
  bwrite(buf);
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	ff 75 f0             	pushl  -0x10(%ebp)
80103691:	e8 7e cb ff ff       	call   80100214 <bwrite>
80103696:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103699:	83 ec 0c             	sub    $0xc,%esp
8010369c:	ff 75 f0             	pushl  -0x10(%ebp)
8010369f:	e8 bd cb ff ff       	call   80100261 <brelse>
801036a4:	83 c4 10             	add    $0x10,%esp
}
801036a7:	90                   	nop
801036a8:	c9                   	leave  
801036a9:	c3                   	ret    

801036aa <recover_from_log>:

static void
recover_from_log(void)
{
801036aa:	f3 0f 1e fb          	endbr32 
801036ae:	55                   	push   %ebp
801036af:	89 e5                	mov    %esp,%ebp
801036b1:	83 ec 08             	sub    $0x8,%esp
  read_head();
801036b4:	e8 f2 fe ff ff       	call   801035ab <read_head>
  install_trans(); // if committed, copy from log to disk
801036b9:	e8 30 fe ff ff       	call   801034ee <install_trans>
  log.lh.n = 0;
801036be:	c7 05 68 47 11 80 00 	movl   $0x0,0x80114768
801036c5:	00 00 00 
  write_head(); // clear the log
801036c8:	e8 56 ff ff ff       	call   80103623 <write_head>
}
801036cd:	90                   	nop
801036ce:	c9                   	leave  
801036cf:	c3                   	ret    

801036d0 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801036d0:	f3 0f 1e fb          	endbr32 
801036d4:	55                   	push   %ebp
801036d5:	89 e5                	mov    %esp,%ebp
801036d7:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801036da:	83 ec 0c             	sub    $0xc,%esp
801036dd:	68 20 47 11 80       	push   $0x80114720
801036e2:	e8 ff 1a 00 00       	call   801051e6 <acquire>
801036e7:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801036ea:	a1 60 47 11 80       	mov    0x80114760,%eax
801036ef:	85 c0                	test   %eax,%eax
801036f1:	74 17                	je     8010370a <begin_op+0x3a>
      sleep(&log, &log.lock);
801036f3:	83 ec 08             	sub    $0x8,%esp
801036f6:	68 20 47 11 80       	push   $0x80114720
801036fb:	68 20 47 11 80       	push   $0x80114720
80103700:	e8 6f 16 00 00       	call   80104d74 <sleep>
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	eb e0                	jmp    801036ea <begin_op+0x1a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010370a:	8b 0d 68 47 11 80    	mov    0x80114768,%ecx
80103710:	a1 5c 47 11 80       	mov    0x8011475c,%eax
80103715:	8d 50 01             	lea    0x1(%eax),%edx
80103718:	89 d0                	mov    %edx,%eax
8010371a:	c1 e0 02             	shl    $0x2,%eax
8010371d:	01 d0                	add    %edx,%eax
8010371f:	01 c0                	add    %eax,%eax
80103721:	01 c8                	add    %ecx,%eax
80103723:	83 f8 1e             	cmp    $0x1e,%eax
80103726:	7e 17                	jle    8010373f <begin_op+0x6f>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103728:	83 ec 08             	sub    $0x8,%esp
8010372b:	68 20 47 11 80       	push   $0x80114720
80103730:	68 20 47 11 80       	push   $0x80114720
80103735:	e8 3a 16 00 00       	call   80104d74 <sleep>
8010373a:	83 c4 10             	add    $0x10,%esp
8010373d:	eb ab                	jmp    801036ea <begin_op+0x1a>
    } else {
      log.outstanding += 1;
8010373f:	a1 5c 47 11 80       	mov    0x8011475c,%eax
80103744:	83 c0 01             	add    $0x1,%eax
80103747:	a3 5c 47 11 80       	mov    %eax,0x8011475c
      release(&log.lock);
8010374c:	83 ec 0c             	sub    $0xc,%esp
8010374f:	68 20 47 11 80       	push   $0x80114720
80103754:	e8 ff 1a 00 00       	call   80105258 <release>
80103759:	83 c4 10             	add    $0x10,%esp
      break;
8010375c:	90                   	nop
    }
  }
}
8010375d:	90                   	nop
8010375e:	c9                   	leave  
8010375f:	c3                   	ret    

80103760 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103760:	f3 0f 1e fb          	endbr32 
80103764:	55                   	push   %ebp
80103765:	89 e5                	mov    %esp,%ebp
80103767:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
8010376a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103771:	83 ec 0c             	sub    $0xc,%esp
80103774:	68 20 47 11 80       	push   $0x80114720
80103779:	e8 68 1a 00 00       	call   801051e6 <acquire>
8010377e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103781:	a1 5c 47 11 80       	mov    0x8011475c,%eax
80103786:	83 e8 01             	sub    $0x1,%eax
80103789:	a3 5c 47 11 80       	mov    %eax,0x8011475c
  if(log.committing)
8010378e:	a1 60 47 11 80       	mov    0x80114760,%eax
80103793:	85 c0                	test   %eax,%eax
80103795:	74 0d                	je     801037a4 <end_op+0x44>
    panic("log.committing");
80103797:	83 ec 0c             	sub    $0xc,%esp
8010379a:	68 28 92 10 80       	push   $0x80109228
8010379f:	e8 64 ce ff ff       	call   80100608 <panic>
  if(log.outstanding == 0){
801037a4:	a1 5c 47 11 80       	mov    0x8011475c,%eax
801037a9:	85 c0                	test   %eax,%eax
801037ab:	75 13                	jne    801037c0 <end_op+0x60>
    do_commit = 1;
801037ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801037b4:	c7 05 60 47 11 80 01 	movl   $0x1,0x80114760
801037bb:	00 00 00 
801037be:	eb 10                	jmp    801037d0 <end_op+0x70>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	68 20 47 11 80       	push   $0x80114720
801037c8:	e8 99 16 00 00       	call   80104e66 <wakeup>
801037cd:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	68 20 47 11 80       	push   $0x80114720
801037d8:	e8 7b 1a 00 00       	call   80105258 <release>
801037dd:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801037e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037e4:	74 3f                	je     80103825 <end_op+0xc5>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801037e6:	e8 fa 00 00 00       	call   801038e5 <commit>
    acquire(&log.lock);
801037eb:	83 ec 0c             	sub    $0xc,%esp
801037ee:	68 20 47 11 80       	push   $0x80114720
801037f3:	e8 ee 19 00 00       	call   801051e6 <acquire>
801037f8:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801037fb:	c7 05 60 47 11 80 00 	movl   $0x0,0x80114760
80103802:	00 00 00 
    wakeup(&log);
80103805:	83 ec 0c             	sub    $0xc,%esp
80103808:	68 20 47 11 80       	push   $0x80114720
8010380d:	e8 54 16 00 00       	call   80104e66 <wakeup>
80103812:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103815:	83 ec 0c             	sub    $0xc,%esp
80103818:	68 20 47 11 80       	push   $0x80114720
8010381d:	e8 36 1a 00 00       	call   80105258 <release>
80103822:	83 c4 10             	add    $0x10,%esp
  }
}
80103825:	90                   	nop
80103826:	c9                   	leave  
80103827:	c3                   	ret    

80103828 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103828:	f3 0f 1e fb          	endbr32 
8010382c:	55                   	push   %ebp
8010382d:	89 e5                	mov    %esp,%ebp
8010382f:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103832:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103839:	e9 95 00 00 00       	jmp    801038d3 <write_log+0xab>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010383e:	8b 15 54 47 11 80    	mov    0x80114754,%edx
80103844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103847:	01 d0                	add    %edx,%eax
80103849:	83 c0 01             	add    $0x1,%eax
8010384c:	89 c2                	mov    %eax,%edx
8010384e:	a1 64 47 11 80       	mov    0x80114764,%eax
80103853:	83 ec 08             	sub    $0x8,%esp
80103856:	52                   	push   %edx
80103857:	50                   	push   %eax
80103858:	e8 7a c9 ff ff       	call   801001d7 <bread>
8010385d:	83 c4 10             	add    $0x10,%esp
80103860:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103866:	83 c0 10             	add    $0x10,%eax
80103869:	8b 04 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%eax
80103870:	89 c2                	mov    %eax,%edx
80103872:	a1 64 47 11 80       	mov    0x80114764,%eax
80103877:	83 ec 08             	sub    $0x8,%esp
8010387a:	52                   	push   %edx
8010387b:	50                   	push   %eax
8010387c:	e8 56 c9 ff ff       	call   801001d7 <bread>
80103881:	83 c4 10             	add    $0x10,%esp
80103884:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103887:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010388a:	8d 50 5c             	lea    0x5c(%eax),%edx
8010388d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103890:	83 c0 5c             	add    $0x5c,%eax
80103893:	83 ec 04             	sub    $0x4,%esp
80103896:	68 00 02 00 00       	push   $0x200
8010389b:	52                   	push   %edx
8010389c:	50                   	push   %eax
8010389d:	e8 aa 1c 00 00       	call   8010554c <memmove>
801038a2:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801038a5:	83 ec 0c             	sub    $0xc,%esp
801038a8:	ff 75 f0             	pushl  -0x10(%ebp)
801038ab:	e8 64 c9 ff ff       	call   80100214 <bwrite>
801038b0:	83 c4 10             	add    $0x10,%esp
    brelse(from);
801038b3:	83 ec 0c             	sub    $0xc,%esp
801038b6:	ff 75 ec             	pushl  -0x14(%ebp)
801038b9:	e8 a3 c9 ff ff       	call   80100261 <brelse>
801038be:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801038c1:	83 ec 0c             	sub    $0xc,%esp
801038c4:	ff 75 f0             	pushl  -0x10(%ebp)
801038c7:	e8 95 c9 ff ff       	call   80100261 <brelse>
801038cc:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801038cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038d3:	a1 68 47 11 80       	mov    0x80114768,%eax
801038d8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801038db:	0f 8c 5d ff ff ff    	jl     8010383e <write_log+0x16>
  }
}
801038e1:	90                   	nop
801038e2:	90                   	nop
801038e3:	c9                   	leave  
801038e4:	c3                   	ret    

801038e5 <commit>:

static void
commit()
{
801038e5:	f3 0f 1e fb          	endbr32 
801038e9:	55                   	push   %ebp
801038ea:	89 e5                	mov    %esp,%ebp
801038ec:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801038ef:	a1 68 47 11 80       	mov    0x80114768,%eax
801038f4:	85 c0                	test   %eax,%eax
801038f6:	7e 1e                	jle    80103916 <commit+0x31>
    write_log();     // Write modified blocks from cache to log
801038f8:	e8 2b ff ff ff       	call   80103828 <write_log>
    write_head();    // Write header to disk -- the real commit
801038fd:	e8 21 fd ff ff       	call   80103623 <write_head>
    install_trans(); // Now install writes to home locations
80103902:	e8 e7 fb ff ff       	call   801034ee <install_trans>
    log.lh.n = 0;
80103907:	c7 05 68 47 11 80 00 	movl   $0x0,0x80114768
8010390e:	00 00 00 
    write_head();    // Erase the transaction from the log
80103911:	e8 0d fd ff ff       	call   80103623 <write_head>
  }
}
80103916:	90                   	nop
80103917:	c9                   	leave  
80103918:	c3                   	ret    

80103919 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103919:	f3 0f 1e fb          	endbr32 
8010391d:	55                   	push   %ebp
8010391e:	89 e5                	mov    %esp,%ebp
80103920:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103923:	a1 68 47 11 80       	mov    0x80114768,%eax
80103928:	83 f8 1d             	cmp    $0x1d,%eax
8010392b:	7f 12                	jg     8010393f <log_write+0x26>
8010392d:	a1 68 47 11 80       	mov    0x80114768,%eax
80103932:	8b 15 58 47 11 80    	mov    0x80114758,%edx
80103938:	83 ea 01             	sub    $0x1,%edx
8010393b:	39 d0                	cmp    %edx,%eax
8010393d:	7c 0d                	jl     8010394c <log_write+0x33>
    panic("too big a transaction");
8010393f:	83 ec 0c             	sub    $0xc,%esp
80103942:	68 37 92 10 80       	push   $0x80109237
80103947:	e8 bc cc ff ff       	call   80100608 <panic>
  if (log.outstanding < 1)
8010394c:	a1 5c 47 11 80       	mov    0x8011475c,%eax
80103951:	85 c0                	test   %eax,%eax
80103953:	7f 0d                	jg     80103962 <log_write+0x49>
    panic("log_write outside of trans");
80103955:	83 ec 0c             	sub    $0xc,%esp
80103958:	68 4d 92 10 80       	push   $0x8010924d
8010395d:	e8 a6 cc ff ff       	call   80100608 <panic>

  acquire(&log.lock);
80103962:	83 ec 0c             	sub    $0xc,%esp
80103965:	68 20 47 11 80       	push   $0x80114720
8010396a:	e8 77 18 00 00       	call   801051e6 <acquire>
8010396f:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103979:	eb 1d                	jmp    80103998 <log_write+0x7f>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010397b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010397e:	83 c0 10             	add    $0x10,%eax
80103981:	8b 04 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%eax
80103988:	89 c2                	mov    %eax,%edx
8010398a:	8b 45 08             	mov    0x8(%ebp),%eax
8010398d:	8b 40 08             	mov    0x8(%eax),%eax
80103990:	39 c2                	cmp    %eax,%edx
80103992:	74 10                	je     801039a4 <log_write+0x8b>
  for (i = 0; i < log.lh.n; i++) {
80103994:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103998:	a1 68 47 11 80       	mov    0x80114768,%eax
8010399d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801039a0:	7c d9                	jl     8010397b <log_write+0x62>
801039a2:	eb 01                	jmp    801039a5 <log_write+0x8c>
      break;
801039a4:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801039a5:	8b 45 08             	mov    0x8(%ebp),%eax
801039a8:	8b 40 08             	mov    0x8(%eax),%eax
801039ab:	89 c2                	mov    %eax,%edx
801039ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039b0:	83 c0 10             	add    $0x10,%eax
801039b3:	89 14 85 2c 47 11 80 	mov    %edx,-0x7feeb8d4(,%eax,4)
  if (i == log.lh.n)
801039ba:	a1 68 47 11 80       	mov    0x80114768,%eax
801039bf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801039c2:	75 0d                	jne    801039d1 <log_write+0xb8>
    log.lh.n++;
801039c4:	a1 68 47 11 80       	mov    0x80114768,%eax
801039c9:	83 c0 01             	add    $0x1,%eax
801039cc:	a3 68 47 11 80       	mov    %eax,0x80114768
  b->flags |= B_DIRTY; // prevent eviction
801039d1:	8b 45 08             	mov    0x8(%ebp),%eax
801039d4:	8b 00                	mov    (%eax),%eax
801039d6:	83 c8 04             	or     $0x4,%eax
801039d9:	89 c2                	mov    %eax,%edx
801039db:	8b 45 08             	mov    0x8(%ebp),%eax
801039de:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801039e0:	83 ec 0c             	sub    $0xc,%esp
801039e3:	68 20 47 11 80       	push   $0x80114720
801039e8:	e8 6b 18 00 00       	call   80105258 <release>
801039ed:	83 c4 10             	add    $0x10,%esp
}
801039f0:	90                   	nop
801039f1:	c9                   	leave  
801039f2:	c3                   	ret    

801039f3 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801039f3:	55                   	push   %ebp
801039f4:	89 e5                	mov    %esp,%ebp
801039f6:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801039f9:	8b 55 08             	mov    0x8(%ebp),%edx
801039fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801039ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103a02:	f0 87 02             	lock xchg %eax,(%edx)
80103a05:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103a08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103a0b:	c9                   	leave  
80103a0c:	c3                   	ret    

80103a0d <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103a0d:	f3 0f 1e fb          	endbr32 
80103a11:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103a15:	83 e4 f0             	and    $0xfffffff0,%esp
80103a18:	ff 71 fc             	pushl  -0x4(%ecx)
80103a1b:	55                   	push   %ebp
80103a1c:	89 e5                	mov    %esp,%ebp
80103a1e:	51                   	push   %ecx
80103a1f:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103a22:	83 ec 08             	sub    $0x8,%esp
80103a25:	68 00 00 40 80       	push   $0x80400000
80103a2a:	68 48 79 11 80       	push   $0x80117948
80103a2f:	e8 52 f2 ff ff       	call   80102c86 <kinit1>
80103a34:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103a37:	e8 2f 46 00 00       	call   8010806b <kvmalloc>
  mpinit();        // detect other processors
80103a3c:	e8 d9 03 00 00       	call   80103e1a <mpinit>
  lapicinit();     // interrupt controller
80103a41:	e8 f5 f5 ff ff       	call   8010303b <lapicinit>
  seginit();       // segment descriptors
80103a46:	e8 d8 40 00 00       	call   80107b23 <seginit>
  picinit();       // disable pic
80103a4b:	e8 35 05 00 00       	call   80103f85 <picinit>
  ioapicinit();    // another interrupt controller
80103a50:	e8 44 f1 ff ff       	call   80102b99 <ioapicinit>
  consoleinit();   // console hardware
80103a55:	e8 87 d1 ff ff       	call   80100be1 <consoleinit>
  uartinit();      // serial port
80103a5a:	e8 4d 34 00 00       	call   80106eac <uartinit>
  pinit();         // process table
80103a5f:	e8 6e 09 00 00       	call   801043d2 <pinit>
  tvinit();        // trap vectors
80103a64:	e8 d8 2f 00 00       	call   80106a41 <tvinit>
  binit();         // buffer cache
80103a69:	e8 c6 c5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103a6e:	e8 00 d6 ff ff       	call   80101073 <fileinit>
  ideinit();       // disk 
80103a73:	e8 e0 ec ff ff       	call   80102758 <ideinit>
  startothers();   // start other processors
80103a78:	e8 88 00 00 00       	call   80103b05 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103a7d:	83 ec 08             	sub    $0x8,%esp
80103a80:	68 00 00 00 8e       	push   $0x8e000000
80103a85:	68 00 00 40 80       	push   $0x80400000
80103a8a:	e8 34 f2 ff ff       	call   80102cc3 <kinit2>
80103a8f:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103a92:	e8 34 0b 00 00       	call   801045cb <userinit>
  mpmain();        // finish this processor's setup
80103a97:	e8 1e 00 00 00       	call   80103aba <mpmain>

80103a9c <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103a9c:	f3 0f 1e fb          	endbr32 
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103aa6:	e8 dc 45 00 00       	call   80108087 <switchkvm>
  seginit();
80103aab:	e8 73 40 00 00       	call   80107b23 <seginit>
  lapicinit();
80103ab0:	e8 86 f5 ff ff       	call   8010303b <lapicinit>
  mpmain();
80103ab5:	e8 00 00 00 00       	call   80103aba <mpmain>

80103aba <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103aba:	f3 0f 1e fb          	endbr32 
80103abe:	55                   	push   %ebp
80103abf:	89 e5                	mov    %esp,%ebp
80103ac1:	53                   	push   %ebx
80103ac2:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103ac5:	e8 2a 09 00 00       	call   801043f4 <cpuid>
80103aca:	89 c3                	mov    %eax,%ebx
80103acc:	e8 23 09 00 00       	call   801043f4 <cpuid>
80103ad1:	83 ec 04             	sub    $0x4,%esp
80103ad4:	53                   	push   %ebx
80103ad5:	50                   	push   %eax
80103ad6:	68 68 92 10 80       	push   $0x80109268
80103adb:	e8 38 c9 ff ff       	call   80100418 <cprintf>
80103ae0:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103ae3:	e8 d3 30 00 00       	call   80106bbb <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103ae8:	e8 26 09 00 00       	call   80104413 <mycpu>
80103aed:	05 a0 00 00 00       	add    $0xa0,%eax
80103af2:	83 ec 08             	sub    $0x8,%esp
80103af5:	6a 01                	push   $0x1
80103af7:	50                   	push   %eax
80103af8:	e8 f6 fe ff ff       	call   801039f3 <xchg>
80103afd:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103b00:	e8 6b 10 00 00       	call   80104b70 <scheduler>

80103b05 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103b05:	f3 0f 1e fb          	endbr32 
80103b09:	55                   	push   %ebp
80103b0a:	89 e5                	mov    %esp,%ebp
80103b0c:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103b0f:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b16:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103b1b:	83 ec 04             	sub    $0x4,%esp
80103b1e:	50                   	push   %eax
80103b1f:	68 0c c5 10 80       	push   $0x8010c50c
80103b24:	ff 75 f0             	pushl  -0x10(%ebp)
80103b27:	e8 20 1a 00 00       	call   8010554c <memmove>
80103b2c:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103b2f:	c7 45 f4 20 48 11 80 	movl   $0x80114820,-0xc(%ebp)
80103b36:	eb 79                	jmp    80103bb1 <startothers+0xac>
    if(c == mycpu())  // We've started already.
80103b38:	e8 d6 08 00 00       	call   80104413 <mycpu>
80103b3d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103b40:	74 67                	je     80103ba9 <startothers+0xa4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103b42:	e8 84 f2 ff ff       	call   80102dcb <kalloc>
80103b47:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b4d:	83 e8 04             	sub    $0x4,%eax
80103b50:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b53:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103b59:	89 10                	mov    %edx,(%eax)
    *(void(**)(void))(code-8) = mpenter;
80103b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b5e:	83 e8 08             	sub    $0x8,%eax
80103b61:	c7 00 9c 3a 10 80    	movl   $0x80103a9c,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103b67:	b8 00 b0 10 80       	mov    $0x8010b000,%eax
80103b6c:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b75:	83 e8 0c             	sub    $0xc,%eax
80103b78:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
80103b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b7d:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b86:	0f b6 00             	movzbl (%eax),%eax
80103b89:	0f b6 c0             	movzbl %al,%eax
80103b8c:	83 ec 08             	sub    $0x8,%esp
80103b8f:	52                   	push   %edx
80103b90:	50                   	push   %eax
80103b91:	e8 17 f6 ff ff       	call   801031ad <lapicstartap>
80103b96:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103b99:	90                   	nop
80103b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b9d:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103ba3:	85 c0                	test   %eax,%eax
80103ba5:	74 f3                	je     80103b9a <startothers+0x95>
80103ba7:	eb 01                	jmp    80103baa <startothers+0xa5>
      continue;
80103ba9:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103baa:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103bb1:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
80103bb6:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103bbc:	05 20 48 11 80       	add    $0x80114820,%eax
80103bc1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103bc4:	0f 82 6e ff ff ff    	jb     80103b38 <startothers+0x33>
      ;
  }
}
80103bca:	90                   	nop
80103bcb:	90                   	nop
80103bcc:	c9                   	leave  
80103bcd:	c3                   	ret    

80103bce <inb>:
{
80103bce:	55                   	push   %ebp
80103bcf:	89 e5                	mov    %esp,%ebp
80103bd1:	83 ec 14             	sub    $0x14,%esp
80103bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80103bd7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103bdb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103bdf:	89 c2                	mov    %eax,%edx
80103be1:	ec                   	in     (%dx),%al
80103be2:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103be5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103be9:	c9                   	leave  
80103bea:	c3                   	ret    

80103beb <outb>:
{
80103beb:	55                   	push   %ebp
80103bec:	89 e5                	mov    %esp,%ebp
80103bee:	83 ec 08             	sub    $0x8,%esp
80103bf1:	8b 45 08             	mov    0x8(%ebp),%eax
80103bf4:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bf7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103bfb:	89 d0                	mov    %edx,%eax
80103bfd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c00:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c04:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c08:	ee                   	out    %al,(%dx)
}
80103c09:	90                   	nop
80103c0a:	c9                   	leave  
80103c0b:	c3                   	ret    

80103c0c <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103c0c:	f3 0f 1e fb          	endbr32 
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103c16:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103c24:	eb 15                	jmp    80103c3b <sum+0x2f>
    sum += addr[i];
80103c26:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103c29:	8b 45 08             	mov    0x8(%ebp),%eax
80103c2c:	01 d0                	add    %edx,%eax
80103c2e:	0f b6 00             	movzbl (%eax),%eax
80103c31:	0f b6 c0             	movzbl %al,%eax
80103c34:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c37:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103c3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103c3e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103c41:	7c e3                	jl     80103c26 <sum+0x1a>
  return sum;
80103c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103c46:	c9                   	leave  
80103c47:	c3                   	ret    

80103c48 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103c48:	f3 0f 1e fb          	endbr32 
80103c4c:	55                   	push   %ebp
80103c4d:	89 e5                	mov    %esp,%ebp
80103c4f:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103c52:	8b 45 08             	mov    0x8(%ebp),%eax
80103c55:	05 00 00 00 80       	add    $0x80000000,%eax
80103c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103c5d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c63:	01 d0                	add    %edx,%eax
80103c65:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c6e:	eb 36                	jmp    80103ca6 <mpsearch1+0x5e>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c70:	83 ec 04             	sub    $0x4,%esp
80103c73:	6a 04                	push   $0x4
80103c75:	68 7c 92 10 80       	push   $0x8010927c
80103c7a:	ff 75 f4             	pushl  -0xc(%ebp)
80103c7d:	e8 6e 18 00 00       	call   801054f0 <memcmp>
80103c82:	83 c4 10             	add    $0x10,%esp
80103c85:	85 c0                	test   %eax,%eax
80103c87:	75 19                	jne    80103ca2 <mpsearch1+0x5a>
80103c89:	83 ec 08             	sub    $0x8,%esp
80103c8c:	6a 10                	push   $0x10
80103c8e:	ff 75 f4             	pushl  -0xc(%ebp)
80103c91:	e8 76 ff ff ff       	call   80103c0c <sum>
80103c96:	83 c4 10             	add    $0x10,%esp
80103c99:	84 c0                	test   %al,%al
80103c9b:	75 05                	jne    80103ca2 <mpsearch1+0x5a>
      return (struct mp*)p;
80103c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca0:	eb 11                	jmp    80103cb3 <mpsearch1+0x6b>
  for(p = addr; p < e; p += sizeof(struct mp))
80103ca2:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cac:	72 c2                	jb     80103c70 <mpsearch1+0x28>
  return 0;
80103cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103cb3:	c9                   	leave  
80103cb4:	c3                   	ret    

80103cb5 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103cb5:	f3 0f 1e fb          	endbr32 
80103cb9:	55                   	push   %ebp
80103cba:	89 e5                	mov    %esp,%ebp
80103cbc:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103cbf:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc9:	83 c0 0f             	add    $0xf,%eax
80103ccc:	0f b6 00             	movzbl (%eax),%eax
80103ccf:	0f b6 c0             	movzbl %al,%eax
80103cd2:	c1 e0 08             	shl    $0x8,%eax
80103cd5:	89 c2                	mov    %eax,%edx
80103cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cda:	83 c0 0e             	add    $0xe,%eax
80103cdd:	0f b6 00             	movzbl (%eax),%eax
80103ce0:	0f b6 c0             	movzbl %al,%eax
80103ce3:	09 d0                	or     %edx,%eax
80103ce5:	c1 e0 04             	shl    $0x4,%eax
80103ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ceb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103cef:	74 21                	je     80103d12 <mpsearch+0x5d>
    if((mp = mpsearch1(p, 1024)))
80103cf1:	83 ec 08             	sub    $0x8,%esp
80103cf4:	68 00 04 00 00       	push   $0x400
80103cf9:	ff 75 f0             	pushl  -0x10(%ebp)
80103cfc:	e8 47 ff ff ff       	call   80103c48 <mpsearch1>
80103d01:	83 c4 10             	add    $0x10,%esp
80103d04:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d07:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d0b:	74 51                	je     80103d5e <mpsearch+0xa9>
      return mp;
80103d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d10:	eb 61                	jmp    80103d73 <mpsearch+0xbe>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d15:	83 c0 14             	add    $0x14,%eax
80103d18:	0f b6 00             	movzbl (%eax),%eax
80103d1b:	0f b6 c0             	movzbl %al,%eax
80103d1e:	c1 e0 08             	shl    $0x8,%eax
80103d21:	89 c2                	mov    %eax,%edx
80103d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d26:	83 c0 13             	add    $0x13,%eax
80103d29:	0f b6 00             	movzbl (%eax),%eax
80103d2c:	0f b6 c0             	movzbl %al,%eax
80103d2f:	09 d0                	or     %edx,%eax
80103d31:	c1 e0 0a             	shl    $0xa,%eax
80103d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d3a:	2d 00 04 00 00       	sub    $0x400,%eax
80103d3f:	83 ec 08             	sub    $0x8,%esp
80103d42:	68 00 04 00 00       	push   $0x400
80103d47:	50                   	push   %eax
80103d48:	e8 fb fe ff ff       	call   80103c48 <mpsearch1>
80103d4d:	83 c4 10             	add    $0x10,%esp
80103d50:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d57:	74 05                	je     80103d5e <mpsearch+0xa9>
      return mp;
80103d59:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d5c:	eb 15                	jmp    80103d73 <mpsearch+0xbe>
  }
  return mpsearch1(0xF0000, 0x10000);
80103d5e:	83 ec 08             	sub    $0x8,%esp
80103d61:	68 00 00 01 00       	push   $0x10000
80103d66:	68 00 00 0f 00       	push   $0xf0000
80103d6b:	e8 d8 fe ff ff       	call   80103c48 <mpsearch1>
80103d70:	83 c4 10             	add    $0x10,%esp
}
80103d73:	c9                   	leave  
80103d74:	c3                   	ret    

80103d75 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103d75:	f3 0f 1e fb          	endbr32 
80103d79:	55                   	push   %ebp
80103d7a:	89 e5                	mov    %esp,%ebp
80103d7c:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d7f:	e8 31 ff ff ff       	call   80103cb5 <mpsearch>
80103d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d8b:	74 0a                	je     80103d97 <mpconfig+0x22>
80103d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d90:	8b 40 04             	mov    0x4(%eax),%eax
80103d93:	85 c0                	test   %eax,%eax
80103d95:	75 07                	jne    80103d9e <mpconfig+0x29>
    return 0;
80103d97:	b8 00 00 00 00       	mov    $0x0,%eax
80103d9c:	eb 7a                	jmp    80103e18 <mpconfig+0xa3>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103da1:	8b 40 04             	mov    0x4(%eax),%eax
80103da4:	05 00 00 00 80       	add    $0x80000000,%eax
80103da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103dac:	83 ec 04             	sub    $0x4,%esp
80103daf:	6a 04                	push   $0x4
80103db1:	68 81 92 10 80       	push   $0x80109281
80103db6:	ff 75 f0             	pushl  -0x10(%ebp)
80103db9:	e8 32 17 00 00       	call   801054f0 <memcmp>
80103dbe:	83 c4 10             	add    $0x10,%esp
80103dc1:	85 c0                	test   %eax,%eax
80103dc3:	74 07                	je     80103dcc <mpconfig+0x57>
    return 0;
80103dc5:	b8 00 00 00 00       	mov    $0x0,%eax
80103dca:	eb 4c                	jmp    80103e18 <mpconfig+0xa3>
  if(conf->version != 1 && conf->version != 4)
80103dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dcf:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103dd3:	3c 01                	cmp    $0x1,%al
80103dd5:	74 12                	je     80103de9 <mpconfig+0x74>
80103dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dda:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103dde:	3c 04                	cmp    $0x4,%al
80103de0:	74 07                	je     80103de9 <mpconfig+0x74>
    return 0;
80103de2:	b8 00 00 00 00       	mov    $0x0,%eax
80103de7:	eb 2f                	jmp    80103e18 <mpconfig+0xa3>
  if(sum((uchar*)conf, conf->length) != 0)
80103de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dec:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103df0:	0f b7 c0             	movzwl %ax,%eax
80103df3:	83 ec 08             	sub    $0x8,%esp
80103df6:	50                   	push   %eax
80103df7:	ff 75 f0             	pushl  -0x10(%ebp)
80103dfa:	e8 0d fe ff ff       	call   80103c0c <sum>
80103dff:	83 c4 10             	add    $0x10,%esp
80103e02:	84 c0                	test   %al,%al
80103e04:	74 07                	je     80103e0d <mpconfig+0x98>
    return 0;
80103e06:	b8 00 00 00 00       	mov    $0x0,%eax
80103e0b:	eb 0b                	jmp    80103e18 <mpconfig+0xa3>
  *pmp = mp;
80103e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e10:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e13:	89 10                	mov    %edx,(%eax)
  return conf;
80103e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103e18:	c9                   	leave  
80103e19:	c3                   	ret    

80103e1a <mpinit>:

void
mpinit(void)
{
80103e1a:	f3 0f 1e fb          	endbr32 
80103e1e:	55                   	push   %ebp
80103e1f:	89 e5                	mov    %esp,%ebp
80103e21:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103e24:	83 ec 0c             	sub    $0xc,%esp
80103e27:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103e2a:	50                   	push   %eax
80103e2b:	e8 45 ff ff ff       	call   80103d75 <mpconfig>
80103e30:	83 c4 10             	add    $0x10,%esp
80103e33:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e36:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103e3a:	75 0d                	jne    80103e49 <mpinit+0x2f>
    panic("Expect to run on an SMP");
80103e3c:	83 ec 0c             	sub    $0xc,%esp
80103e3f:	68 86 92 10 80       	push   $0x80109286
80103e44:	e8 bf c7 ff ff       	call   80100608 <panic>
  ismp = 1;
80103e49:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e53:	8b 40 24             	mov    0x24(%eax),%eax
80103e56:	a3 1c 47 11 80       	mov    %eax,0x8011471c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e5e:	83 c0 2c             	add    $0x2c,%eax
80103e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e64:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e67:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e6b:	0f b7 d0             	movzwl %ax,%edx
80103e6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e71:	01 d0                	add    %edx,%eax
80103e73:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103e76:	e9 8c 00 00 00       	jmp    80103f07 <mpinit+0xed>
    switch(*p){
80103e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e7e:	0f b6 00             	movzbl (%eax),%eax
80103e81:	0f b6 c0             	movzbl %al,%eax
80103e84:	83 f8 04             	cmp    $0x4,%eax
80103e87:	7f 76                	jg     80103eff <mpinit+0xe5>
80103e89:	83 f8 03             	cmp    $0x3,%eax
80103e8c:	7d 6b                	jge    80103ef9 <mpinit+0xdf>
80103e8e:	83 f8 02             	cmp    $0x2,%eax
80103e91:	74 4e                	je     80103ee1 <mpinit+0xc7>
80103e93:	83 f8 02             	cmp    $0x2,%eax
80103e96:	7f 67                	jg     80103eff <mpinit+0xe5>
80103e98:	85 c0                	test   %eax,%eax
80103e9a:	74 07                	je     80103ea3 <mpinit+0x89>
80103e9c:	83 f8 01             	cmp    $0x1,%eax
80103e9f:	74 58                	je     80103ef9 <mpinit+0xdf>
80103ea1:	eb 5c                	jmp    80103eff <mpinit+0xe5>
    case MPPROC:
      proc = (struct mpproc*)p;
80103ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ea6:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
80103ea9:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
80103eae:	83 f8 07             	cmp    $0x7,%eax
80103eb1:	7f 28                	jg     80103edb <mpinit+0xc1>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103eb3:	8b 15 a0 4d 11 80    	mov    0x80114da0,%edx
80103eb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ebc:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ec0:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103ec6:	81 c2 20 48 11 80    	add    $0x80114820,%edx
80103ecc:	88 02                	mov    %al,(%edx)
        ncpu++;
80103ece:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
80103ed3:	83 c0 01             	add    $0x1,%eax
80103ed6:	a3 a0 4d 11 80       	mov    %eax,0x80114da0
      }
      p += sizeof(struct mpproc);
80103edb:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103edf:	eb 26                	jmp    80103f07 <mpinit+0xed>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ee4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103ee7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103eea:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103eee:	a2 00 48 11 80       	mov    %al,0x80114800
      p += sizeof(struct mpioapic);
80103ef3:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ef7:	eb 0e                	jmp    80103f07 <mpinit+0xed>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ef9:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103efd:	eb 08                	jmp    80103f07 <mpinit+0xed>
    default:
      ismp = 0;
80103eff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103f06:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f0a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103f0d:	0f 82 68 ff ff ff    	jb     80103e7b <mpinit+0x61>
    }
  }
  if(!ismp)
80103f13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103f17:	75 0d                	jne    80103f26 <mpinit+0x10c>
    panic("Didn't find a suitable machine");
80103f19:	83 ec 0c             	sub    $0xc,%esp
80103f1c:	68 a0 92 10 80       	push   $0x801092a0
80103f21:	e8 e2 c6 ff ff       	call   80100608 <panic>

  if(mp->imcrp){
80103f26:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f29:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f2d:	84 c0                	test   %al,%al
80103f2f:	74 30                	je     80103f61 <mpinit+0x147>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f31:	83 ec 08             	sub    $0x8,%esp
80103f34:	6a 70                	push   $0x70
80103f36:	6a 22                	push   $0x22
80103f38:	e8 ae fc ff ff       	call   80103beb <outb>
80103f3d:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f40:	83 ec 0c             	sub    $0xc,%esp
80103f43:	6a 23                	push   $0x23
80103f45:	e8 84 fc ff ff       	call   80103bce <inb>
80103f4a:	83 c4 10             	add    $0x10,%esp
80103f4d:	83 c8 01             	or     $0x1,%eax
80103f50:	0f b6 c0             	movzbl %al,%eax
80103f53:	83 ec 08             	sub    $0x8,%esp
80103f56:	50                   	push   %eax
80103f57:	6a 23                	push   $0x23
80103f59:	e8 8d fc ff ff       	call   80103beb <outb>
80103f5e:	83 c4 10             	add    $0x10,%esp
  }
}
80103f61:	90                   	nop
80103f62:	c9                   	leave  
80103f63:	c3                   	ret    

80103f64 <outb>:
{
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	83 ec 08             	sub    $0x8,%esp
80103f6a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f70:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103f74:	89 d0                	mov    %edx,%eax
80103f76:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f79:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f7d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f81:	ee                   	out    %al,(%dx)
}
80103f82:	90                   	nop
80103f83:	c9                   	leave  
80103f84:	c3                   	ret    

80103f85 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103f85:	f3 0f 1e fb          	endbr32 
80103f89:	55                   	push   %ebp
80103f8a:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103f8c:	68 ff 00 00 00       	push   $0xff
80103f91:	6a 21                	push   $0x21
80103f93:	e8 cc ff ff ff       	call   80103f64 <outb>
80103f98:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103f9b:	68 ff 00 00 00       	push   $0xff
80103fa0:	68 a1 00 00 00       	push   $0xa1
80103fa5:	e8 ba ff ff ff       	call   80103f64 <outb>
80103faa:	83 c4 08             	add    $0x8,%esp
}
80103fad:	90                   	nop
80103fae:	c9                   	leave  
80103faf:	c3                   	ret    

80103fb0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fb0:	f3 0f 1e fb          	endbr32 
80103fb4:	55                   	push   %ebp
80103fb5:	89 e5                	mov    %esp,%ebp
80103fb7:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103fba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fca:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fcd:	8b 10                	mov    (%eax),%edx
80103fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd2:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103fd4:	e8 bc d0 ff ff       	call   80101095 <filealloc>
80103fd9:	8b 55 08             	mov    0x8(%ebp),%edx
80103fdc:	89 02                	mov    %eax,(%edx)
80103fde:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe1:	8b 00                	mov    (%eax),%eax
80103fe3:	85 c0                	test   %eax,%eax
80103fe5:	0f 84 c8 00 00 00    	je     801040b3 <pipealloc+0x103>
80103feb:	e8 a5 d0 ff ff       	call   80101095 <filealloc>
80103ff0:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ff3:	89 02                	mov    %eax,(%edx)
80103ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff8:	8b 00                	mov    (%eax),%eax
80103ffa:	85 c0                	test   %eax,%eax
80103ffc:	0f 84 b1 00 00 00    	je     801040b3 <pipealloc+0x103>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104002:	e8 c4 ed ff ff       	call   80102dcb <kalloc>
80104007:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010400a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010400e:	0f 84 a2 00 00 00    	je     801040b6 <pipealloc+0x106>
    goto bad;
  p->readopen = 1;
80104014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104017:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010401e:	00 00 00 
  p->writeopen = 1;
80104021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104024:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010402b:	00 00 00 
  p->nwrite = 0;
8010402e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104031:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104038:	00 00 00 
  p->nread = 0;
8010403b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403e:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104045:	00 00 00 
  initlock(&p->lock, "pipe");
80104048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404b:	83 ec 08             	sub    $0x8,%esp
8010404e:	68 bf 92 10 80       	push   $0x801092bf
80104053:	50                   	push   %eax
80104054:	e8 67 11 00 00       	call   801051c0 <initlock>
80104059:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010405c:	8b 45 08             	mov    0x8(%ebp),%eax
8010405f:	8b 00                	mov    (%eax),%eax
80104061:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104067:	8b 45 08             	mov    0x8(%ebp),%eax
8010406a:	8b 00                	mov    (%eax),%eax
8010406c:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104070:	8b 45 08             	mov    0x8(%ebp),%eax
80104073:	8b 00                	mov    (%eax),%eax
80104075:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104079:	8b 45 08             	mov    0x8(%ebp),%eax
8010407c:	8b 00                	mov    (%eax),%eax
8010407e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104081:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104084:	8b 45 0c             	mov    0xc(%ebp),%eax
80104087:	8b 00                	mov    (%eax),%eax
80104089:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010408f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104092:	8b 00                	mov    (%eax),%eax
80104094:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104098:	8b 45 0c             	mov    0xc(%ebp),%eax
8010409b:	8b 00                	mov    (%eax),%eax
8010409d:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a4:	8b 00                	mov    (%eax),%eax
801040a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040a9:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040ac:	b8 00 00 00 00       	mov    $0x0,%eax
801040b1:	eb 51                	jmp    80104104 <pipealloc+0x154>
    goto bad;
801040b3:	90                   	nop
801040b4:	eb 01                	jmp    801040b7 <pipealloc+0x107>
    goto bad;
801040b6:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
801040b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040bb:	74 0e                	je     801040cb <pipealloc+0x11b>
    kfree((char*)p);
801040bd:	83 ec 0c             	sub    $0xc,%esp
801040c0:	ff 75 f4             	pushl  -0xc(%ebp)
801040c3:	e8 65 ec ff ff       	call   80102d2d <kfree>
801040c8:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040cb:	8b 45 08             	mov    0x8(%ebp),%eax
801040ce:	8b 00                	mov    (%eax),%eax
801040d0:	85 c0                	test   %eax,%eax
801040d2:	74 11                	je     801040e5 <pipealloc+0x135>
    fileclose(*f0);
801040d4:	8b 45 08             	mov    0x8(%ebp),%eax
801040d7:	8b 00                	mov    (%eax),%eax
801040d9:	83 ec 0c             	sub    $0xc,%esp
801040dc:	50                   	push   %eax
801040dd:	e8 79 d0 ff ff       	call   8010115b <fileclose>
801040e2:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801040e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040e8:	8b 00                	mov    (%eax),%eax
801040ea:	85 c0                	test   %eax,%eax
801040ec:	74 11                	je     801040ff <pipealloc+0x14f>
    fileclose(*f1);
801040ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f1:	8b 00                	mov    (%eax),%eax
801040f3:	83 ec 0c             	sub    $0xc,%esp
801040f6:	50                   	push   %eax
801040f7:	e8 5f d0 ff ff       	call   8010115b <fileclose>
801040fc:	83 c4 10             	add    $0x10,%esp
  return -1;
801040ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104104:	c9                   	leave  
80104105:	c3                   	ret    

80104106 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104106:	f3 0f 1e fb          	endbr32 
8010410a:	55                   	push   %ebp
8010410b:	89 e5                	mov    %esp,%ebp
8010410d:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104110:	8b 45 08             	mov    0x8(%ebp),%eax
80104113:	83 ec 0c             	sub    $0xc,%esp
80104116:	50                   	push   %eax
80104117:	e8 ca 10 00 00       	call   801051e6 <acquire>
8010411c:	83 c4 10             	add    $0x10,%esp
  if(writable){
8010411f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104123:	74 23                	je     80104148 <pipeclose+0x42>
    p->writeopen = 0;
80104125:	8b 45 08             	mov    0x8(%ebp),%eax
80104128:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010412f:	00 00 00 
    wakeup(&p->nread);
80104132:	8b 45 08             	mov    0x8(%ebp),%eax
80104135:	05 34 02 00 00       	add    $0x234,%eax
8010413a:	83 ec 0c             	sub    $0xc,%esp
8010413d:	50                   	push   %eax
8010413e:	e8 23 0d 00 00       	call   80104e66 <wakeup>
80104143:	83 c4 10             	add    $0x10,%esp
80104146:	eb 21                	jmp    80104169 <pipeclose+0x63>
  } else {
    p->readopen = 0;
80104148:	8b 45 08             	mov    0x8(%ebp),%eax
8010414b:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104152:	00 00 00 
    wakeup(&p->nwrite);
80104155:	8b 45 08             	mov    0x8(%ebp),%eax
80104158:	05 38 02 00 00       	add    $0x238,%eax
8010415d:	83 ec 0c             	sub    $0xc,%esp
80104160:	50                   	push   %eax
80104161:	e8 00 0d 00 00       	call   80104e66 <wakeup>
80104166:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104169:	8b 45 08             	mov    0x8(%ebp),%eax
8010416c:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104172:	85 c0                	test   %eax,%eax
80104174:	75 2c                	jne    801041a2 <pipeclose+0x9c>
80104176:	8b 45 08             	mov    0x8(%ebp),%eax
80104179:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010417f:	85 c0                	test   %eax,%eax
80104181:	75 1f                	jne    801041a2 <pipeclose+0x9c>
    release(&p->lock);
80104183:	8b 45 08             	mov    0x8(%ebp),%eax
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	50                   	push   %eax
8010418a:	e8 c9 10 00 00       	call   80105258 <release>
8010418f:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104192:	83 ec 0c             	sub    $0xc,%esp
80104195:	ff 75 08             	pushl  0x8(%ebp)
80104198:	e8 90 eb ff ff       	call   80102d2d <kfree>
8010419d:	83 c4 10             	add    $0x10,%esp
801041a0:	eb 10                	jmp    801041b2 <pipeclose+0xac>
  } else
    release(&p->lock);
801041a2:	8b 45 08             	mov    0x8(%ebp),%eax
801041a5:	83 ec 0c             	sub    $0xc,%esp
801041a8:	50                   	push   %eax
801041a9:	e8 aa 10 00 00       	call   80105258 <release>
801041ae:	83 c4 10             	add    $0x10,%esp
}
801041b1:	90                   	nop
801041b2:	90                   	nop
801041b3:	c9                   	leave  
801041b4:	c3                   	ret    

801041b5 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041b5:	f3 0f 1e fb          	endbr32 
801041b9:	55                   	push   %ebp
801041ba:	89 e5                	mov    %esp,%ebp
801041bc:	53                   	push   %ebx
801041bd:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801041c0:	8b 45 08             	mov    0x8(%ebp),%eax
801041c3:	83 ec 0c             	sub    $0xc,%esp
801041c6:	50                   	push   %eax
801041c7:	e8 1a 10 00 00       	call   801051e6 <acquire>
801041cc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801041cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041d6:	e9 ad 00 00 00       	jmp    80104288 <pipewrite+0xd3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
801041db:	8b 45 08             	mov    0x8(%ebp),%eax
801041de:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041e4:	85 c0                	test   %eax,%eax
801041e6:	74 0c                	je     801041f4 <pipewrite+0x3f>
801041e8:	e8 a2 02 00 00       	call   8010448f <myproc>
801041ed:	8b 40 24             	mov    0x24(%eax),%eax
801041f0:	85 c0                	test   %eax,%eax
801041f2:	74 19                	je     8010420d <pipewrite+0x58>
        release(&p->lock);
801041f4:	8b 45 08             	mov    0x8(%ebp),%eax
801041f7:	83 ec 0c             	sub    $0xc,%esp
801041fa:	50                   	push   %eax
801041fb:	e8 58 10 00 00       	call   80105258 <release>
80104200:	83 c4 10             	add    $0x10,%esp
        return -1;
80104203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104208:	e9 a9 00 00 00       	jmp    801042b6 <pipewrite+0x101>
      }
      wakeup(&p->nread);
8010420d:	8b 45 08             	mov    0x8(%ebp),%eax
80104210:	05 34 02 00 00       	add    $0x234,%eax
80104215:	83 ec 0c             	sub    $0xc,%esp
80104218:	50                   	push   %eax
80104219:	e8 48 0c 00 00       	call   80104e66 <wakeup>
8010421e:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104221:	8b 45 08             	mov    0x8(%ebp),%eax
80104224:	8b 55 08             	mov    0x8(%ebp),%edx
80104227:	81 c2 38 02 00 00    	add    $0x238,%edx
8010422d:	83 ec 08             	sub    $0x8,%esp
80104230:	50                   	push   %eax
80104231:	52                   	push   %edx
80104232:	e8 3d 0b 00 00       	call   80104d74 <sleep>
80104237:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010423a:	8b 45 08             	mov    0x8(%ebp),%eax
8010423d:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104243:	8b 45 08             	mov    0x8(%ebp),%eax
80104246:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010424c:	05 00 02 00 00       	add    $0x200,%eax
80104251:	39 c2                	cmp    %eax,%edx
80104253:	74 86                	je     801041db <pipewrite+0x26>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104255:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104258:	8b 45 0c             	mov    0xc(%ebp),%eax
8010425b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010425e:	8b 45 08             	mov    0x8(%ebp),%eax
80104261:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104267:	8d 48 01             	lea    0x1(%eax),%ecx
8010426a:	8b 55 08             	mov    0x8(%ebp),%edx
8010426d:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104273:	25 ff 01 00 00       	and    $0x1ff,%eax
80104278:	89 c1                	mov    %eax,%ecx
8010427a:	0f b6 13             	movzbl (%ebx),%edx
8010427d:	8b 45 08             	mov    0x8(%ebp),%eax
80104280:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80104284:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010428e:	7c aa                	jl     8010423a <pipewrite+0x85>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104290:	8b 45 08             	mov    0x8(%ebp),%eax
80104293:	05 34 02 00 00       	add    $0x234,%eax
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	50                   	push   %eax
8010429c:	e8 c5 0b 00 00       	call   80104e66 <wakeup>
801042a1:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801042a4:	8b 45 08             	mov    0x8(%ebp),%eax
801042a7:	83 ec 0c             	sub    $0xc,%esp
801042aa:	50                   	push   %eax
801042ab:	e8 a8 0f 00 00       	call   80105258 <release>
801042b0:	83 c4 10             	add    $0x10,%esp
  return n;
801042b3:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b9:	c9                   	leave  
801042ba:	c3                   	ret    

801042bb <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042bb:	f3 0f 1e fb          	endbr32 
801042bf:	55                   	push   %ebp
801042c0:	89 e5                	mov    %esp,%ebp
801042c2:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801042c5:	8b 45 08             	mov    0x8(%ebp),%eax
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	50                   	push   %eax
801042cc:	e8 15 0f 00 00       	call   801051e6 <acquire>
801042d1:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042d4:	eb 3e                	jmp    80104314 <piperead+0x59>
    if(myproc()->killed){
801042d6:	e8 b4 01 00 00       	call   8010448f <myproc>
801042db:	8b 40 24             	mov    0x24(%eax),%eax
801042de:	85 c0                	test   %eax,%eax
801042e0:	74 19                	je     801042fb <piperead+0x40>
      release(&p->lock);
801042e2:	8b 45 08             	mov    0x8(%ebp),%eax
801042e5:	83 ec 0c             	sub    $0xc,%esp
801042e8:	50                   	push   %eax
801042e9:	e8 6a 0f 00 00       	call   80105258 <release>
801042ee:	83 c4 10             	add    $0x10,%esp
      return -1;
801042f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042f6:	e9 be 00 00 00       	jmp    801043b9 <piperead+0xfe>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801042fb:	8b 45 08             	mov    0x8(%ebp),%eax
801042fe:	8b 55 08             	mov    0x8(%ebp),%edx
80104301:	81 c2 34 02 00 00    	add    $0x234,%edx
80104307:	83 ec 08             	sub    $0x8,%esp
8010430a:	50                   	push   %eax
8010430b:	52                   	push   %edx
8010430c:	e8 63 0a 00 00       	call   80104d74 <sleep>
80104311:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104314:	8b 45 08             	mov    0x8(%ebp),%eax
80104317:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010431d:	8b 45 08             	mov    0x8(%ebp),%eax
80104320:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104326:	39 c2                	cmp    %eax,%edx
80104328:	75 0d                	jne    80104337 <piperead+0x7c>
8010432a:	8b 45 08             	mov    0x8(%ebp),%eax
8010432d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104333:	85 c0                	test   %eax,%eax
80104335:	75 9f                	jne    801042d6 <piperead+0x1b>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104337:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010433e:	eb 48                	jmp    80104388 <piperead+0xcd>
    if(p->nread == p->nwrite)
80104340:	8b 45 08             	mov    0x8(%ebp),%eax
80104343:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104349:	8b 45 08             	mov    0x8(%ebp),%eax
8010434c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104352:	39 c2                	cmp    %eax,%edx
80104354:	74 3c                	je     80104392 <piperead+0xd7>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104356:	8b 45 08             	mov    0x8(%ebp),%eax
80104359:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010435f:	8d 48 01             	lea    0x1(%eax),%ecx
80104362:	8b 55 08             	mov    0x8(%ebp),%edx
80104365:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010436b:	25 ff 01 00 00       	and    $0x1ff,%eax
80104370:	89 c1                	mov    %eax,%ecx
80104372:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104375:	8b 45 0c             	mov    0xc(%ebp),%eax
80104378:	01 c2                	add    %eax,%edx
8010437a:	8b 45 08             	mov    0x8(%ebp),%eax
8010437d:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
80104382:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104384:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104388:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010438e:	7c b0                	jl     80104340 <piperead+0x85>
80104390:	eb 01                	jmp    80104393 <piperead+0xd8>
      break;
80104392:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104393:	8b 45 08             	mov    0x8(%ebp),%eax
80104396:	05 38 02 00 00       	add    $0x238,%eax
8010439b:	83 ec 0c             	sub    $0xc,%esp
8010439e:	50                   	push   %eax
8010439f:	e8 c2 0a 00 00       	call   80104e66 <wakeup>
801043a4:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043a7:	8b 45 08             	mov    0x8(%ebp),%eax
801043aa:	83 ec 0c             	sub    $0xc,%esp
801043ad:	50                   	push   %eax
801043ae:	e8 a5 0e 00 00       	call   80105258 <release>
801043b3:	83 c4 10             	add    $0x10,%esp
  return i;
801043b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043b9:	c9                   	leave  
801043ba:	c3                   	ret    

801043bb <readeflags>:
{
801043bb:	55                   	push   %ebp
801043bc:	89 e5                	mov    %esp,%ebp
801043be:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043c1:	9c                   	pushf  
801043c2:	58                   	pop    %eax
801043c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043c9:	c9                   	leave  
801043ca:	c3                   	ret    

801043cb <sti>:
{
801043cb:	55                   	push   %ebp
801043cc:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043ce:	fb                   	sti    
}
801043cf:	90                   	nop
801043d0:	5d                   	pop    %ebp
801043d1:	c3                   	ret    

801043d2 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043d2:	f3 0f 1e fb          	endbr32 
801043d6:	55                   	push   %ebp
801043d7:	89 e5                	mov    %esp,%ebp
801043d9:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801043dc:	83 ec 08             	sub    $0x8,%esp
801043df:	68 c4 92 10 80       	push   $0x801092c4
801043e4:	68 c0 4d 11 80       	push   $0x80114dc0
801043e9:	e8 d2 0d 00 00       	call   801051c0 <initlock>
801043ee:	83 c4 10             	add    $0x10,%esp
}
801043f1:	90                   	nop
801043f2:	c9                   	leave  
801043f3:	c3                   	ret    

801043f4 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
801043f4:	f3 0f 1e fb          	endbr32 
801043f8:	55                   	push   %ebp
801043f9:	89 e5                	mov    %esp,%ebp
801043fb:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801043fe:	e8 10 00 00 00       	call   80104413 <mycpu>
80104403:	2d 20 48 11 80       	sub    $0x80114820,%eax
80104408:	c1 f8 04             	sar    $0x4,%eax
8010440b:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104411:	c9                   	leave  
80104412:	c3                   	ret    

80104413 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80104413:	f3 0f 1e fb          	endbr32 
80104417:	55                   	push   %ebp
80104418:	89 e5                	mov    %esp,%ebp
8010441a:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010441d:	e8 99 ff ff ff       	call   801043bb <readeflags>
80104422:	25 00 02 00 00       	and    $0x200,%eax
80104427:	85 c0                	test   %eax,%eax
80104429:	74 0d                	je     80104438 <mycpu+0x25>
    panic("mycpu called with interrupts enabled\n");
8010442b:	83 ec 0c             	sub    $0xc,%esp
8010442e:	68 cc 92 10 80       	push   $0x801092cc
80104433:	e8 d0 c1 ff ff       	call   80100608 <panic>
  
  apicid = lapicid();
80104438:	e8 21 ed ff ff       	call   8010315e <lapicid>
8010443d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80104440:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104447:	eb 2d                	jmp    80104476 <mycpu+0x63>
    if (cpus[i].apicid == apicid)
80104449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010444c:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104452:	05 20 48 11 80       	add    $0x80114820,%eax
80104457:	0f b6 00             	movzbl (%eax),%eax
8010445a:	0f b6 c0             	movzbl %al,%eax
8010445d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104460:	75 10                	jne    80104472 <mycpu+0x5f>
      return &cpus[i];
80104462:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104465:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010446b:	05 20 48 11 80       	add    $0x80114820,%eax
80104470:	eb 1b                	jmp    8010448d <mycpu+0x7a>
  for (i = 0; i < ncpu; ++i) {
80104472:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104476:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
8010447b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010447e:	7c c9                	jl     80104449 <mycpu+0x36>
  }
  panic("unknown apicid\n");
80104480:	83 ec 0c             	sub    $0xc,%esp
80104483:	68 f2 92 10 80       	push   $0x801092f2
80104488:	e8 7b c1 ff ff       	call   80100608 <panic>
}
8010448d:	c9                   	leave  
8010448e:	c3                   	ret    

8010448f <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
8010448f:	f3 0f 1e fb          	endbr32 
80104493:	55                   	push   %ebp
80104494:	89 e5                	mov    %esp,%ebp
80104496:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80104499:	e8 d4 0e 00 00       	call   80105372 <pushcli>
  c = mycpu();
8010449e:	e8 70 ff ff ff       	call   80104413 <mycpu>
801044a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
801044a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a9:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801044af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
801044b2:	e8 0c 0f 00 00       	call   801053c3 <popcli>
  return p;
801044b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801044ba:	c9                   	leave  
801044bb:	c3                   	ret    

801044bc <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801044bc:	f3 0f 1e fb          	endbr32 
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801044c6:	83 ec 0c             	sub    $0xc,%esp
801044c9:	68 c0 4d 11 80       	push   $0x80114dc0
801044ce:	e8 13 0d 00 00       	call   801051e6 <acquire>
801044d3:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044d6:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
801044dd:	eb 11                	jmp    801044f0 <allocproc+0x34>
    if(p->state == UNUSED)
801044df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e2:	8b 40 0c             	mov    0xc(%eax),%eax
801044e5:	85 c0                	test   %eax,%eax
801044e7:	74 2a                	je     80104513 <allocproc+0x57>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044e9:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
801044f0:	81 7d f4 f4 70 11 80 	cmpl   $0x801170f4,-0xc(%ebp)
801044f7:	72 e6                	jb     801044df <allocproc+0x23>
      goto found;

  release(&ptable.lock);
801044f9:	83 ec 0c             	sub    $0xc,%esp
801044fc:	68 c0 4d 11 80       	push   $0x80114dc0
80104501:	e8 52 0d 00 00       	call   80105258 <release>
80104506:	83 c4 10             	add    $0x10,%esp
  return 0;
80104509:	b8 00 00 00 00       	mov    $0x0,%eax
8010450e:	e9 b6 00 00 00       	jmp    801045c9 <allocproc+0x10d>
      goto found;
80104513:	90                   	nop
80104514:	f3 0f 1e fb          	endbr32 

found:
  p->state = EMBRYO;
80104518:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451b:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104522:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104527:	8d 50 01             	lea    0x1(%eax),%edx
8010452a:	89 15 00 c0 10 80    	mov    %edx,0x8010c000
80104530:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104533:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80104536:	83 ec 0c             	sub    $0xc,%esp
80104539:	68 c0 4d 11 80       	push   $0x80114dc0
8010453e:	e8 15 0d 00 00       	call   80105258 <release>
80104543:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104546:	e8 80 e8 ff ff       	call   80102dcb <kalloc>
8010454b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010454e:	89 42 08             	mov    %eax,0x8(%edx)
80104551:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104554:	8b 40 08             	mov    0x8(%eax),%eax
80104557:	85 c0                	test   %eax,%eax
80104559:	75 11                	jne    8010456c <allocproc+0xb0>
    p->state = UNUSED;
8010455b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104565:	b8 00 00 00 00       	mov    $0x0,%eax
8010456a:	eb 5d                	jmp    801045c9 <allocproc+0x10d>
  }
  sp = p->kstack + KSTACKSIZE;
8010456c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456f:	8b 40 08             	mov    0x8(%eax),%eax
80104572:	05 00 10 00 00       	add    $0x1000,%eax
80104577:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010457a:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010457e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104581:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104584:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104587:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010458b:	ba fb 69 10 80       	mov    $0x801069fb,%edx
80104590:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104593:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104595:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104599:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010459f:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801045a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a5:	8b 40 1c             	mov    0x1c(%eax),%eax
801045a8:	83 ec 04             	sub    $0x4,%esp
801045ab:	6a 14                	push   $0x14
801045ad:	6a 00                	push   $0x0
801045af:	50                   	push   %eax
801045b0:	e8 d0 0e 00 00       	call   80105485 <memset>
801045b5:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801045b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bb:	8b 40 1c             	mov    0x1c(%eax),%eax
801045be:	ba 2a 4d 10 80       	mov    $0x80104d2a,%edx
801045c3:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801045c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801045c9:	c9                   	leave  
801045ca:	c3                   	ret    

801045cb <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801045cb:	f3 0f 1e fb          	endbr32 
801045cf:	55                   	push   %ebp
801045d0:	89 e5                	mov    %esp,%ebp
801045d2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801045d5:	e8 e2 fe ff ff       	call   801044bc <allocproc>
801045da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
801045dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e0:	a3 40 c6 10 80       	mov    %eax,0x8010c640
  if((p->pgdir = setupkvm()) == 0)
801045e5:	e8 e4 39 00 00       	call   80107fce <setupkvm>
801045ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045ed:	89 42 04             	mov    %eax,0x4(%edx)
801045f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f3:	8b 40 04             	mov    0x4(%eax),%eax
801045f6:	85 c0                	test   %eax,%eax
801045f8:	75 0d                	jne    80104607 <userinit+0x3c>
    panic("userinit: out of memory?");
801045fa:	83 ec 0c             	sub    $0xc,%esp
801045fd:	68 02 93 10 80       	push   $0x80109302
80104602:	e8 01 c0 ff ff       	call   80100608 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104607:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010460c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460f:	8b 40 04             	mov    0x4(%eax),%eax
80104612:	83 ec 04             	sub    $0x4,%esp
80104615:	52                   	push   %edx
80104616:	68 e0 c4 10 80       	push   $0x8010c4e0
8010461b:	50                   	push   %eax
8010461c:	e8 26 3c 00 00       	call   80108247 <inituvm>
80104621:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104624:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104627:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010462d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104630:	8b 40 18             	mov    0x18(%eax),%eax
80104633:	83 ec 04             	sub    $0x4,%esp
80104636:	6a 4c                	push   $0x4c
80104638:	6a 00                	push   $0x0
8010463a:	50                   	push   %eax
8010463b:	e8 45 0e 00 00       	call   80105485 <memset>
80104640:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104646:	8b 40 18             	mov    0x18(%eax),%eax
80104649:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010464f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104652:	8b 40 18             	mov    0x18(%eax),%eax
80104655:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010465b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465e:	8b 50 18             	mov    0x18(%eax),%edx
80104661:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104664:	8b 40 18             	mov    0x18(%eax),%eax
80104667:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010466b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010466f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104672:	8b 50 18             	mov    0x18(%eax),%edx
80104675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104678:	8b 40 18             	mov    0x18(%eax),%eax
8010467b:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010467f:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104683:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104686:	8b 40 18             	mov    0x18(%eax),%eax
80104689:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104693:	8b 40 18             	mov    0x18(%eax),%eax
80104696:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010469d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a0:	8b 40 18             	mov    0x18(%eax),%eax
801046a3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801046aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ad:	83 c0 6c             	add    $0x6c,%eax
801046b0:	83 ec 04             	sub    $0x4,%esp
801046b3:	6a 10                	push   $0x10
801046b5:	68 1b 93 10 80       	push   $0x8010931b
801046ba:	50                   	push   %eax
801046bb:	e8 e0 0f 00 00       	call   801056a0 <safestrcpy>
801046c0:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801046c3:	83 ec 0c             	sub    $0xc,%esp
801046c6:	68 24 93 10 80       	push   $0x80109324
801046cb:	e8 76 df ff ff       	call   80102646 <namei>
801046d0:	83 c4 10             	add    $0x10,%esp
801046d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046d6:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801046d9:	83 ec 0c             	sub    $0xc,%esp
801046dc:	68 c0 4d 11 80       	push   $0x80114dc0
801046e1:	e8 00 0b 00 00       	call   801051e6 <acquire>
801046e6:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
801046e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801046f3:	83 ec 0c             	sub    $0xc,%esp
801046f6:	68 c0 4d 11 80       	push   $0x80114dc0
801046fb:	e8 58 0b 00 00       	call   80105258 <release>
80104700:	83 c4 10             	add    $0x10,%esp
}
80104703:	90                   	nop
80104704:	c9                   	leave  
80104705:	c3                   	ret    

80104706 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104706:	f3 0f 1e fb          	endbr32 
8010470a:	55                   	push   %ebp
8010470b:	89 e5                	mov    %esp,%ebp
8010470d:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80104710:	e8 7a fd ff ff       	call   8010448f <myproc>
80104715:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80104718:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010471b:	8b 00                	mov    (%eax),%eax
8010471d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104720:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104724:	7e 2e                	jle    80104754 <growproc+0x4e>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104726:	8b 55 08             	mov    0x8(%ebp),%edx
80104729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010472c:	01 c2                	add    %eax,%edx
8010472e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104731:	8b 40 04             	mov    0x4(%eax),%eax
80104734:	83 ec 04             	sub    $0x4,%esp
80104737:	52                   	push   %edx
80104738:	ff 75 f4             	pushl  -0xc(%ebp)
8010473b:	50                   	push   %eax
8010473c:	e8 4b 3c 00 00       	call   8010838c <allocuvm>
80104741:	83 c4 10             	add    $0x10,%esp
80104744:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010474b:	75 3b                	jne    80104788 <growproc+0x82>
      return -1;
8010474d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104752:	eb 4f                	jmp    801047a3 <growproc+0x9d>
  } else if(n < 0){
80104754:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104758:	79 2e                	jns    80104788 <growproc+0x82>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010475a:	8b 55 08             	mov    0x8(%ebp),%edx
8010475d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104760:	01 c2                	add    %eax,%edx
80104762:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104765:	8b 40 04             	mov    0x4(%eax),%eax
80104768:	83 ec 04             	sub    $0x4,%esp
8010476b:	52                   	push   %edx
8010476c:	ff 75 f4             	pushl  -0xc(%ebp)
8010476f:	50                   	push   %eax
80104770:	e8 20 3d 00 00       	call   80108495 <deallocuvm>
80104775:	83 c4 10             	add    $0x10,%esp
80104778:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010477b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010477f:	75 07                	jne    80104788 <growproc+0x82>
      return -1;
80104781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104786:	eb 1b                	jmp    801047a3 <growproc+0x9d>
  }
  curproc->sz = sz;
80104788:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010478b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010478e:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80104790:	83 ec 0c             	sub    $0xc,%esp
80104793:	ff 75 f0             	pushl  -0x10(%ebp)
80104796:	e8 09 39 00 00       	call   801080a4 <switchuvm>
8010479b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010479e:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047a3:	c9                   	leave  
801047a4:	c3                   	ret    

801047a5 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801047a5:	f3 0f 1e fb          	endbr32 
801047a9:	55                   	push   %ebp
801047aa:	89 e5                	mov    %esp,%ebp
801047ac:	57                   	push   %edi
801047ad:	56                   	push   %esi
801047ae:	53                   	push   %ebx
801047af:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
801047b2:	e8 d8 fc ff ff       	call   8010448f <myproc>
801047b7:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
801047ba:	e8 fd fc ff ff       	call   801044bc <allocproc>
801047bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801047c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801047c6:	75 0a                	jne    801047d2 <fork+0x2d>
    return -1;
801047c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047cd:	e9 48 01 00 00       	jmp    8010491a <fork+0x175>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801047d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047d5:	8b 10                	mov    (%eax),%edx
801047d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047da:	8b 40 04             	mov    0x4(%eax),%eax
801047dd:	83 ec 08             	sub    $0x8,%esp
801047e0:	52                   	push   %edx
801047e1:	50                   	push   %eax
801047e2:	e8 5c 3e 00 00       	call   80108643 <copyuvm>
801047e7:	83 c4 10             	add    $0x10,%esp
801047ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047ed:	89 42 04             	mov    %eax,0x4(%edx)
801047f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047f3:	8b 40 04             	mov    0x4(%eax),%eax
801047f6:	85 c0                	test   %eax,%eax
801047f8:	75 30                	jne    8010482a <fork+0x85>
    kfree(np->kstack);
801047fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047fd:	8b 40 08             	mov    0x8(%eax),%eax
80104800:	83 ec 0c             	sub    $0xc,%esp
80104803:	50                   	push   %eax
80104804:	e8 24 e5 ff ff       	call   80102d2d <kfree>
80104809:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010480c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010480f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104816:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104819:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104825:	e9 f0 00 00 00       	jmp    8010491a <fork+0x175>
  }
  np->sz = curproc->sz;
8010482a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010482d:	8b 10                	mov    (%eax),%edx
8010482f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104832:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80104834:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104837:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010483a:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
8010483d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104840:	8b 48 18             	mov    0x18(%eax),%ecx
80104843:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104846:	8b 40 18             	mov    0x18(%eax),%eax
80104849:	89 c2                	mov    %eax,%edx
8010484b:	89 cb                	mov    %ecx,%ebx
8010484d:	b8 13 00 00 00       	mov    $0x13,%eax
80104852:	89 d7                	mov    %edx,%edi
80104854:	89 de                	mov    %ebx,%esi
80104856:	89 c1                	mov    %eax,%ecx
80104858:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010485a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010485d:	8b 40 18             	mov    0x18(%eax),%eax
80104860:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104867:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010486e:	eb 3b                	jmp    801048ab <fork+0x106>
    if(curproc->ofile[i])
80104870:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104873:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104876:	83 c2 08             	add    $0x8,%edx
80104879:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010487d:	85 c0                	test   %eax,%eax
8010487f:	74 26                	je     801048a7 <fork+0x102>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104881:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104884:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104887:	83 c2 08             	add    $0x8,%edx
8010488a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010488e:	83 ec 0c             	sub    $0xc,%esp
80104891:	50                   	push   %eax
80104892:	e8 6f c8 ff ff       	call   80101106 <filedup>
80104897:	83 c4 10             	add    $0x10,%esp
8010489a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010489d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801048a0:	83 c1 08             	add    $0x8,%ecx
801048a3:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
801048a7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801048ab:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801048af:	7e bf                	jle    80104870 <fork+0xcb>
  np->cwd = idup(curproc->cwd);
801048b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048b4:	8b 40 68             	mov    0x68(%eax),%eax
801048b7:	83 ec 0c             	sub    $0xc,%esp
801048ba:	50                   	push   %eax
801048bb:	e8 dd d1 ff ff       	call   80101a9d <idup>
801048c0:	83 c4 10             	add    $0x10,%esp
801048c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801048c6:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801048c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048cc:	8d 50 6c             	lea    0x6c(%eax),%edx
801048cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
801048d2:	83 c0 6c             	add    $0x6c,%eax
801048d5:	83 ec 04             	sub    $0x4,%esp
801048d8:	6a 10                	push   $0x10
801048da:	52                   	push   %edx
801048db:	50                   	push   %eax
801048dc:	e8 bf 0d 00 00       	call   801056a0 <safestrcpy>
801048e1:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
801048e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801048e7:	8b 40 10             	mov    0x10(%eax),%eax
801048ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
801048ed:	83 ec 0c             	sub    $0xc,%esp
801048f0:	68 c0 4d 11 80       	push   $0x80114dc0
801048f5:	e8 ec 08 00 00       	call   801051e6 <acquire>
801048fa:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
801048fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104900:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104907:	83 ec 0c             	sub    $0xc,%esp
8010490a:	68 c0 4d 11 80       	push   $0x80114dc0
8010490f:	e8 44 09 00 00       	call   80105258 <release>
80104914:	83 c4 10             	add    $0x10,%esp

  return pid;
80104917:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
8010491a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010491d:	5b                   	pop    %ebx
8010491e:	5e                   	pop    %esi
8010491f:	5f                   	pop    %edi
80104920:	5d                   	pop    %ebp
80104921:	c3                   	ret    

80104922 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104922:	f3 0f 1e fb          	endbr32 
80104926:	55                   	push   %ebp
80104927:	89 e5                	mov    %esp,%ebp
80104929:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
8010492c:	e8 5e fb ff ff       	call   8010448f <myproc>
80104931:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80104934:	a1 40 c6 10 80       	mov    0x8010c640,%eax
80104939:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010493c:	75 0d                	jne    8010494b <exit+0x29>
    panic("init exiting");
8010493e:	83 ec 0c             	sub    $0xc,%esp
80104941:	68 26 93 10 80       	push   $0x80109326
80104946:	e8 bd bc ff ff       	call   80100608 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010494b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104952:	eb 3f                	jmp    80104993 <exit+0x71>
    if(curproc->ofile[fd]){
80104954:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104957:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010495a:	83 c2 08             	add    $0x8,%edx
8010495d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104961:	85 c0                	test   %eax,%eax
80104963:	74 2a                	je     8010498f <exit+0x6d>
      fileclose(curproc->ofile[fd]);
80104965:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104968:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010496b:	83 c2 08             	add    $0x8,%edx
8010496e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104972:	83 ec 0c             	sub    $0xc,%esp
80104975:	50                   	push   %eax
80104976:	e8 e0 c7 ff ff       	call   8010115b <fileclose>
8010497b:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
8010497e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104981:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104984:	83 c2 08             	add    $0x8,%edx
80104987:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010498e:	00 
  for(fd = 0; fd < NOFILE; fd++){
8010498f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104993:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104997:	7e bb                	jle    80104954 <exit+0x32>
    }
  }

  begin_op();
80104999:	e8 32 ed ff ff       	call   801036d0 <begin_op>
  iput(curproc->cwd);
8010499e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049a1:	8b 40 68             	mov    0x68(%eax),%eax
801049a4:	83 ec 0c             	sub    $0xc,%esp
801049a7:	50                   	push   %eax
801049a8:	e8 97 d2 ff ff       	call   80101c44 <iput>
801049ad:	83 c4 10             	add    $0x10,%esp
  end_op();
801049b0:	e8 ab ed ff ff       	call   80103760 <end_op>
  curproc->cwd = 0;
801049b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049b8:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801049bf:	83 ec 0c             	sub    $0xc,%esp
801049c2:	68 c0 4d 11 80       	push   $0x80114dc0
801049c7:	e8 1a 08 00 00       	call   801051e6 <acquire>
801049cc:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801049cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049d2:	8b 40 14             	mov    0x14(%eax),%eax
801049d5:	83 ec 0c             	sub    $0xc,%esp
801049d8:	50                   	push   %eax
801049d9:	e8 41 04 00 00       	call   80104e1f <wakeup1>
801049de:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049e1:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
801049e8:	eb 3a                	jmp    80104a24 <exit+0x102>
    if(p->parent == curproc){
801049ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ed:	8b 40 14             	mov    0x14(%eax),%eax
801049f0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801049f3:	75 28                	jne    80104a1d <exit+0xfb>
      p->parent = initproc;
801049f5:	8b 15 40 c6 10 80    	mov    0x8010c640,%edx
801049fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049fe:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a04:	8b 40 0c             	mov    0xc(%eax),%eax
80104a07:	83 f8 05             	cmp    $0x5,%eax
80104a0a:	75 11                	jne    80104a1d <exit+0xfb>
        wakeup1(initproc);
80104a0c:	a1 40 c6 10 80       	mov    0x8010c640,%eax
80104a11:	83 ec 0c             	sub    $0xc,%esp
80104a14:	50                   	push   %eax
80104a15:	e8 05 04 00 00       	call   80104e1f <wakeup1>
80104a1a:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a1d:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104a24:	81 7d f4 f4 70 11 80 	cmpl   $0x801170f4,-0xc(%ebp)
80104a2b:	72 bd                	jb     801049ea <exit+0xc8>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a30:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104a37:	e8 f3 01 00 00       	call   80104c2f <sched>
  panic("zombie exit");
80104a3c:	83 ec 0c             	sub    $0xc,%esp
80104a3f:	68 33 93 10 80       	push   $0x80109333
80104a44:	e8 bf bb ff ff       	call   80100608 <panic>

80104a49 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104a49:	f3 0f 1e fb          	endbr32 
80104a4d:	55                   	push   %ebp
80104a4e:	89 e5                	mov    %esp,%ebp
80104a50:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104a53:	e8 37 fa ff ff       	call   8010448f <myproc>
80104a58:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104a5b:	83 ec 0c             	sub    $0xc,%esp
80104a5e:	68 c0 4d 11 80       	push   $0x80114dc0
80104a63:	e8 7e 07 00 00       	call   801051e6 <acquire>
80104a68:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104a6b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a72:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
80104a79:	e9 a4 00 00 00       	jmp    80104b22 <wait+0xd9>
      if(p->parent != curproc)
80104a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a81:	8b 40 14             	mov    0x14(%eax),%eax
80104a84:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104a87:	0f 85 8d 00 00 00    	jne    80104b1a <wait+0xd1>
        continue;
      havekids = 1;
80104a8d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a97:	8b 40 0c             	mov    0xc(%eax),%eax
80104a9a:	83 f8 05             	cmp    $0x5,%eax
80104a9d:	75 7c                	jne    80104b1b <wait+0xd2>
        // Found one.
        pid = p->pid;
80104a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa2:	8b 40 10             	mov    0x10(%eax),%eax
80104aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aab:	8b 40 08             	mov    0x8(%eax),%eax
80104aae:	83 ec 0c             	sub    $0xc,%esp
80104ab1:	50                   	push   %eax
80104ab2:	e8 76 e2 ff ff       	call   80102d2d <kfree>
80104ab7:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104abd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac7:	8b 40 04             	mov    0x4(%eax),%eax
80104aca:	83 ec 0c             	sub    $0xc,%esp
80104acd:	50                   	push   %eax
80104ace:	e8 8c 3a 00 00       	call   8010855f <freevm>
80104ad3:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad9:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aed:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af4:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104afe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104b05:	83 ec 0c             	sub    $0xc,%esp
80104b08:	68 c0 4d 11 80       	push   $0x80114dc0
80104b0d:	e8 46 07 00 00       	call   80105258 <release>
80104b12:	83 c4 10             	add    $0x10,%esp
        return pid;
80104b15:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104b18:	eb 54                	jmp    80104b6e <wait+0x125>
        continue;
80104b1a:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b1b:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104b22:	81 7d f4 f4 70 11 80 	cmpl   $0x801170f4,-0xc(%ebp)
80104b29:	0f 82 4f ff ff ff    	jb     80104a7e <wait+0x35>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104b2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b33:	74 0a                	je     80104b3f <wait+0xf6>
80104b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b38:	8b 40 24             	mov    0x24(%eax),%eax
80104b3b:	85 c0                	test   %eax,%eax
80104b3d:	74 17                	je     80104b56 <wait+0x10d>
      release(&ptable.lock);
80104b3f:	83 ec 0c             	sub    $0xc,%esp
80104b42:	68 c0 4d 11 80       	push   $0x80114dc0
80104b47:	e8 0c 07 00 00       	call   80105258 <release>
80104b4c:	83 c4 10             	add    $0x10,%esp
      return -1;
80104b4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b54:	eb 18                	jmp    80104b6e <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104b56:	83 ec 08             	sub    $0x8,%esp
80104b59:	68 c0 4d 11 80       	push   $0x80114dc0
80104b5e:	ff 75 ec             	pushl  -0x14(%ebp)
80104b61:	e8 0e 02 00 00       	call   80104d74 <sleep>
80104b66:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104b69:	e9 fd fe ff ff       	jmp    80104a6b <wait+0x22>
  }
}
80104b6e:	c9                   	leave  
80104b6f:	c3                   	ret    

80104b70 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104b70:	f3 0f 1e fb          	endbr32 
80104b74:	55                   	push   %ebp
80104b75:	89 e5                	mov    %esp,%ebp
80104b77:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104b7a:	e8 94 f8 ff ff       	call   80104413 <mycpu>
80104b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b85:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104b8c:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104b8f:	e8 37 f8 ff ff       	call   801043cb <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104b94:	83 ec 0c             	sub    $0xc,%esp
80104b97:	68 c0 4d 11 80       	push   $0x80114dc0
80104b9c:	e8 45 06 00 00       	call   801051e6 <acquire>
80104ba1:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ba4:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
80104bab:	eb 64                	jmp    80104c11 <scheduler+0xa1>
      if(p->state != RUNNABLE)
80104bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb0:	8b 40 0c             	mov    0xc(%eax),%eax
80104bb3:	83 f8 03             	cmp    $0x3,%eax
80104bb6:	75 51                	jne    80104c09 <scheduler+0x99>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bbe:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104bc4:	83 ec 0c             	sub    $0xc,%esp
80104bc7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bca:	e8 d5 34 00 00       	call   801080a4 <switchuvm>
80104bcf:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd5:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bdf:	8b 40 1c             	mov    0x1c(%eax),%eax
80104be2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104be5:	83 c2 04             	add    $0x4,%edx
80104be8:	83 ec 08             	sub    $0x8,%esp
80104beb:	50                   	push   %eax
80104bec:	52                   	push   %edx
80104bed:	e8 27 0b 00 00       	call   80105719 <swtch>
80104bf2:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104bf5:	e8 8d 34 00 00       	call   80108087 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bfd:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104c04:	00 00 00 
80104c07:	eb 01                	jmp    80104c0a <scheduler+0x9a>
        continue;
80104c09:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c0a:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104c11:	81 7d f4 f4 70 11 80 	cmpl   $0x801170f4,-0xc(%ebp)
80104c18:	72 93                	jb     80104bad <scheduler+0x3d>
    }
    release(&ptable.lock);
80104c1a:	83 ec 0c             	sub    $0xc,%esp
80104c1d:	68 c0 4d 11 80       	push   $0x80114dc0
80104c22:	e8 31 06 00 00       	call   80105258 <release>
80104c27:	83 c4 10             	add    $0x10,%esp
    sti();
80104c2a:	e9 60 ff ff ff       	jmp    80104b8f <scheduler+0x1f>

80104c2f <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104c2f:	f3 0f 1e fb          	endbr32 
80104c33:	55                   	push   %ebp
80104c34:	89 e5                	mov    %esp,%ebp
80104c36:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104c39:	e8 51 f8 ff ff       	call   8010448f <myproc>
80104c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104c41:	83 ec 0c             	sub    $0xc,%esp
80104c44:	68 c0 4d 11 80       	push   $0x80114dc0
80104c49:	e8 df 06 00 00       	call   8010532d <holding>
80104c4e:	83 c4 10             	add    $0x10,%esp
80104c51:	85 c0                	test   %eax,%eax
80104c53:	75 0d                	jne    80104c62 <sched+0x33>
    panic("sched ptable.lock");
80104c55:	83 ec 0c             	sub    $0xc,%esp
80104c58:	68 3f 93 10 80       	push   $0x8010933f
80104c5d:	e8 a6 b9 ff ff       	call   80100608 <panic>
  if(mycpu()->ncli != 1)
80104c62:	e8 ac f7 ff ff       	call   80104413 <mycpu>
80104c67:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c6d:	83 f8 01             	cmp    $0x1,%eax
80104c70:	74 0d                	je     80104c7f <sched+0x50>
    panic("sched locks");
80104c72:	83 ec 0c             	sub    $0xc,%esp
80104c75:	68 51 93 10 80       	push   $0x80109351
80104c7a:	e8 89 b9 ff ff       	call   80100608 <panic>
  if(p->state == RUNNING)
80104c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c82:	8b 40 0c             	mov    0xc(%eax),%eax
80104c85:	83 f8 04             	cmp    $0x4,%eax
80104c88:	75 0d                	jne    80104c97 <sched+0x68>
    panic("sched running");
80104c8a:	83 ec 0c             	sub    $0xc,%esp
80104c8d:	68 5d 93 10 80       	push   $0x8010935d
80104c92:	e8 71 b9 ff ff       	call   80100608 <panic>
  if(readeflags()&FL_IF)
80104c97:	e8 1f f7 ff ff       	call   801043bb <readeflags>
80104c9c:	25 00 02 00 00       	and    $0x200,%eax
80104ca1:	85 c0                	test   %eax,%eax
80104ca3:	74 0d                	je     80104cb2 <sched+0x83>
    panic("sched interruptible");
80104ca5:	83 ec 0c             	sub    $0xc,%esp
80104ca8:	68 6b 93 10 80       	push   $0x8010936b
80104cad:	e8 56 b9 ff ff       	call   80100608 <panic>
  intena = mycpu()->intena;
80104cb2:	e8 5c f7 ff ff       	call   80104413 <mycpu>
80104cb7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104cc0:	e8 4e f7 ff ff       	call   80104413 <mycpu>
80104cc5:	8b 40 04             	mov    0x4(%eax),%eax
80104cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ccb:	83 c2 1c             	add    $0x1c,%edx
80104cce:	83 ec 08             	sub    $0x8,%esp
80104cd1:	50                   	push   %eax
80104cd2:	52                   	push   %edx
80104cd3:	e8 41 0a 00 00       	call   80105719 <swtch>
80104cd8:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104cdb:	e8 33 f7 ff ff       	call   80104413 <mycpu>
80104ce0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ce3:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104ce9:	90                   	nop
80104cea:	c9                   	leave  
80104ceb:	c3                   	ret    

80104cec <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104cec:	f3 0f 1e fb          	endbr32 
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104cf6:	83 ec 0c             	sub    $0xc,%esp
80104cf9:	68 c0 4d 11 80       	push   $0x80114dc0
80104cfe:	e8 e3 04 00 00       	call   801051e6 <acquire>
80104d03:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104d06:	e8 84 f7 ff ff       	call   8010448f <myproc>
80104d0b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104d12:	e8 18 ff ff ff       	call   80104c2f <sched>
  release(&ptable.lock);
80104d17:	83 ec 0c             	sub    $0xc,%esp
80104d1a:	68 c0 4d 11 80       	push   $0x80114dc0
80104d1f:	e8 34 05 00 00       	call   80105258 <release>
80104d24:	83 c4 10             	add    $0x10,%esp
}
80104d27:	90                   	nop
80104d28:	c9                   	leave  
80104d29:	c3                   	ret    

80104d2a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104d2a:	f3 0f 1e fb          	endbr32 
80104d2e:	55                   	push   %ebp
80104d2f:	89 e5                	mov    %esp,%ebp
80104d31:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104d34:	83 ec 0c             	sub    $0xc,%esp
80104d37:	68 c0 4d 11 80       	push   $0x80114dc0
80104d3c:	e8 17 05 00 00       	call   80105258 <release>
80104d41:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104d44:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104d49:	85 c0                	test   %eax,%eax
80104d4b:	74 24                	je     80104d71 <forkret+0x47>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104d4d:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
80104d54:	00 00 00 
    iinit(ROOTDEV);
80104d57:	83 ec 0c             	sub    $0xc,%esp
80104d5a:	6a 01                	push   $0x1
80104d5c:	e8 f4 c9 ff ff       	call   80101755 <iinit>
80104d61:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104d64:	83 ec 0c             	sub    $0xc,%esp
80104d67:	6a 01                	push   $0x1
80104d69:	e8 2f e7 ff ff       	call   8010349d <initlog>
80104d6e:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104d71:	90                   	nop
80104d72:	c9                   	leave  
80104d73:	c3                   	ret    

80104d74 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104d74:	f3 0f 1e fb          	endbr32 
80104d78:	55                   	push   %ebp
80104d79:	89 e5                	mov    %esp,%ebp
80104d7b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104d7e:	e8 0c f7 ff ff       	call   8010448f <myproc>
80104d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104d86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d8a:	75 0d                	jne    80104d99 <sleep+0x25>
    panic("sleep");
80104d8c:	83 ec 0c             	sub    $0xc,%esp
80104d8f:	68 7f 93 10 80       	push   $0x8010937f
80104d94:	e8 6f b8 ff ff       	call   80100608 <panic>

  if(lk == 0)
80104d99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104d9d:	75 0d                	jne    80104dac <sleep+0x38>
    panic("sleep without lk");
80104d9f:	83 ec 0c             	sub    $0xc,%esp
80104da2:	68 85 93 10 80       	push   $0x80109385
80104da7:	e8 5c b8 ff ff       	call   80100608 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104dac:	81 7d 0c c0 4d 11 80 	cmpl   $0x80114dc0,0xc(%ebp)
80104db3:	74 1e                	je     80104dd3 <sleep+0x5f>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104db5:	83 ec 0c             	sub    $0xc,%esp
80104db8:	68 c0 4d 11 80       	push   $0x80114dc0
80104dbd:	e8 24 04 00 00       	call   801051e6 <acquire>
80104dc2:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104dc5:	83 ec 0c             	sub    $0xc,%esp
80104dc8:	ff 75 0c             	pushl  0xc(%ebp)
80104dcb:	e8 88 04 00 00       	call   80105258 <release>
80104dd0:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd6:	8b 55 08             	mov    0x8(%ebp),%edx
80104dd9:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ddf:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104de6:	e8 44 fe ff ff       	call   80104c2f <sched>

  // Tidy up.
  p->chan = 0;
80104deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dee:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104df5:	81 7d 0c c0 4d 11 80 	cmpl   $0x80114dc0,0xc(%ebp)
80104dfc:	74 1e                	je     80104e1c <sleep+0xa8>
    release(&ptable.lock);
80104dfe:	83 ec 0c             	sub    $0xc,%esp
80104e01:	68 c0 4d 11 80       	push   $0x80114dc0
80104e06:	e8 4d 04 00 00       	call   80105258 <release>
80104e0b:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104e0e:	83 ec 0c             	sub    $0xc,%esp
80104e11:	ff 75 0c             	pushl  0xc(%ebp)
80104e14:	e8 cd 03 00 00       	call   801051e6 <acquire>
80104e19:	83 c4 10             	add    $0x10,%esp
  }
}
80104e1c:	90                   	nop
80104e1d:	c9                   	leave  
80104e1e:	c3                   	ret    

80104e1f <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104e1f:	f3 0f 1e fb          	endbr32 
80104e23:	55                   	push   %ebp
80104e24:	89 e5                	mov    %esp,%ebp
80104e26:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e29:	c7 45 fc f4 4d 11 80 	movl   $0x80114df4,-0x4(%ebp)
80104e30:	eb 27                	jmp    80104e59 <wakeup1+0x3a>
    if(p->state == SLEEPING && p->chan == chan)
80104e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e35:	8b 40 0c             	mov    0xc(%eax),%eax
80104e38:	83 f8 02             	cmp    $0x2,%eax
80104e3b:	75 15                	jne    80104e52 <wakeup1+0x33>
80104e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e40:	8b 40 20             	mov    0x20(%eax),%eax
80104e43:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e46:	75 0a                	jne    80104e52 <wakeup1+0x33>
      p->state = RUNNABLE;
80104e48:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e4b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e52:	81 45 fc 8c 00 00 00 	addl   $0x8c,-0x4(%ebp)
80104e59:	81 7d fc f4 70 11 80 	cmpl   $0x801170f4,-0x4(%ebp)
80104e60:	72 d0                	jb     80104e32 <wakeup1+0x13>
}
80104e62:	90                   	nop
80104e63:	90                   	nop
80104e64:	c9                   	leave  
80104e65:	c3                   	ret    

80104e66 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104e66:	f3 0f 1e fb          	endbr32 
80104e6a:	55                   	push   %ebp
80104e6b:	89 e5                	mov    %esp,%ebp
80104e6d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104e70:	83 ec 0c             	sub    $0xc,%esp
80104e73:	68 c0 4d 11 80       	push   $0x80114dc0
80104e78:	e8 69 03 00 00       	call   801051e6 <acquire>
80104e7d:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104e80:	83 ec 0c             	sub    $0xc,%esp
80104e83:	ff 75 08             	pushl  0x8(%ebp)
80104e86:	e8 94 ff ff ff       	call   80104e1f <wakeup1>
80104e8b:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104e8e:	83 ec 0c             	sub    $0xc,%esp
80104e91:	68 c0 4d 11 80       	push   $0x80114dc0
80104e96:	e8 bd 03 00 00       	call   80105258 <release>
80104e9b:	83 c4 10             	add    $0x10,%esp
}
80104e9e:	90                   	nop
80104e9f:	c9                   	leave  
80104ea0:	c3                   	ret    

80104ea1 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104ea1:	f3 0f 1e fb          	endbr32 
80104ea5:	55                   	push   %ebp
80104ea6:	89 e5                	mov    %esp,%ebp
80104ea8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104eab:	83 ec 0c             	sub    $0xc,%esp
80104eae:	68 c0 4d 11 80       	push   $0x80114dc0
80104eb3:	e8 2e 03 00 00       	call   801051e6 <acquire>
80104eb8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ebb:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
80104ec2:	eb 48                	jmp    80104f0c <kill+0x6b>
    if(p->pid == pid){
80104ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec7:	8b 40 10             	mov    0x10(%eax),%eax
80104eca:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ecd:	75 36                	jne    80104f05 <kill+0x64>
      p->killed = 1;
80104ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104edc:	8b 40 0c             	mov    0xc(%eax),%eax
80104edf:	83 f8 02             	cmp    $0x2,%eax
80104ee2:	75 0a                	jne    80104eee <kill+0x4d>
        p->state = RUNNABLE;
80104ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104eee:	83 ec 0c             	sub    $0xc,%esp
80104ef1:	68 c0 4d 11 80       	push   $0x80114dc0
80104ef6:	e8 5d 03 00 00       	call   80105258 <release>
80104efb:	83 c4 10             	add    $0x10,%esp
      return 0;
80104efe:	b8 00 00 00 00       	mov    $0x0,%eax
80104f03:	eb 25                	jmp    80104f2a <kill+0x89>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f05:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104f0c:	81 7d f4 f4 70 11 80 	cmpl   $0x801170f4,-0xc(%ebp)
80104f13:	72 af                	jb     80104ec4 <kill+0x23>
    }
  }
  release(&ptable.lock);
80104f15:	83 ec 0c             	sub    $0xc,%esp
80104f18:	68 c0 4d 11 80       	push   $0x80114dc0
80104f1d:	e8 36 03 00 00       	call   80105258 <release>
80104f22:	83 c4 10             	add    $0x10,%esp
  return -1;
80104f25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f2a:	c9                   	leave  
80104f2b:	c3                   	ret    

80104f2c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104f2c:	f3 0f 1e fb          	endbr32 
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f36:	c7 45 f0 f4 4d 11 80 	movl   $0x80114df4,-0x10(%ebp)
80104f3d:	e9 da 00 00 00       	jmp    8010501c <procdump+0xf0>
    if(p->state == UNUSED)
80104f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f45:	8b 40 0c             	mov    0xc(%eax),%eax
80104f48:	85 c0                	test   %eax,%eax
80104f4a:	0f 84 c4 00 00 00    	je     80105014 <procdump+0xe8>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f53:	8b 40 0c             	mov    0xc(%eax),%eax
80104f56:	83 f8 05             	cmp    $0x5,%eax
80104f59:	77 23                	ja     80104f7e <procdump+0x52>
80104f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f5e:	8b 40 0c             	mov    0xc(%eax),%eax
80104f61:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104f68:	85 c0                	test   %eax,%eax
80104f6a:	74 12                	je     80104f7e <procdump+0x52>
      state = states[p->state];
80104f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f6f:	8b 40 0c             	mov    0xc(%eax),%eax
80104f72:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104f79:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104f7c:	eb 07                	jmp    80104f85 <procdump+0x59>
    else
      state = "???";
80104f7e:	c7 45 ec 96 93 10 80 	movl   $0x80109396,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f88:	8d 50 6c             	lea    0x6c(%eax),%edx
80104f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f8e:	8b 40 10             	mov    0x10(%eax),%eax
80104f91:	52                   	push   %edx
80104f92:	ff 75 ec             	pushl  -0x14(%ebp)
80104f95:	50                   	push   %eax
80104f96:	68 9a 93 10 80       	push   $0x8010939a
80104f9b:	e8 78 b4 ff ff       	call   80100418 <cprintf>
80104fa0:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fa6:	8b 40 0c             	mov    0xc(%eax),%eax
80104fa9:	83 f8 02             	cmp    $0x2,%eax
80104fac:	75 54                	jne    80105002 <procdump+0xd6>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fb1:	8b 40 1c             	mov    0x1c(%eax),%eax
80104fb4:	8b 40 0c             	mov    0xc(%eax),%eax
80104fb7:	83 c0 08             	add    $0x8,%eax
80104fba:	89 c2                	mov    %eax,%edx
80104fbc:	83 ec 08             	sub    $0x8,%esp
80104fbf:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104fc2:	50                   	push   %eax
80104fc3:	52                   	push   %edx
80104fc4:	e8 e5 02 00 00       	call   801052ae <getcallerpcs>
80104fc9:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104fcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104fd3:	eb 1c                	jmp    80104ff1 <procdump+0xc5>
        cprintf(" %p", pc[i]);
80104fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd8:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104fdc:	83 ec 08             	sub    $0x8,%esp
80104fdf:	50                   	push   %eax
80104fe0:	68 a3 93 10 80       	push   $0x801093a3
80104fe5:	e8 2e b4 ff ff       	call   80100418 <cprintf>
80104fea:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104fed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ff1:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104ff5:	7f 0b                	jg     80105002 <procdump+0xd6>
80104ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ffa:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ffe:	85 c0                	test   %eax,%eax
80105000:	75 d3                	jne    80104fd5 <procdump+0xa9>
    }
    cprintf("\n");
80105002:	83 ec 0c             	sub    $0xc,%esp
80105005:	68 a7 93 10 80       	push   $0x801093a7
8010500a:	e8 09 b4 ff ff       	call   80100418 <cprintf>
8010500f:	83 c4 10             	add    $0x10,%esp
80105012:	eb 01                	jmp    80105015 <procdump+0xe9>
      continue;
80105014:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105015:	81 45 f0 8c 00 00 00 	addl   $0x8c,-0x10(%ebp)
8010501c:	81 7d f0 f4 70 11 80 	cmpl   $0x801170f4,-0x10(%ebp)
80105023:	0f 82 19 ff ff ff    	jb     80104f42 <procdump+0x16>
  }
}
80105029:	90                   	nop
8010502a:	90                   	nop
8010502b:	c9                   	leave  
8010502c:	c3                   	ret    

8010502d <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010502d:	f3 0f 1e fb          	endbr32 
80105031:	55                   	push   %ebp
80105032:	89 e5                	mov    %esp,%ebp
80105034:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80105037:	8b 45 08             	mov    0x8(%ebp),%eax
8010503a:	83 c0 04             	add    $0x4,%eax
8010503d:	83 ec 08             	sub    $0x8,%esp
80105040:	68 d3 93 10 80       	push   $0x801093d3
80105045:	50                   	push   %eax
80105046:	e8 75 01 00 00       	call   801051c0 <initlock>
8010504b:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
8010504e:	8b 45 08             	mov    0x8(%ebp),%eax
80105051:	8b 55 0c             	mov    0xc(%ebp),%edx
80105054:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80105057:	8b 45 08             	mov    0x8(%ebp),%eax
8010505a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80105060:	8b 45 08             	mov    0x8(%ebp),%eax
80105063:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
8010506a:	90                   	nop
8010506b:	c9                   	leave  
8010506c:	c3                   	ret    

8010506d <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
8010506d:	f3 0f 1e fb          	endbr32 
80105071:	55                   	push   %ebp
80105072:	89 e5                	mov    %esp,%ebp
80105074:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80105077:	8b 45 08             	mov    0x8(%ebp),%eax
8010507a:	83 c0 04             	add    $0x4,%eax
8010507d:	83 ec 0c             	sub    $0xc,%esp
80105080:	50                   	push   %eax
80105081:	e8 60 01 00 00       	call   801051e6 <acquire>
80105086:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80105089:	eb 15                	jmp    801050a0 <acquiresleep+0x33>
    sleep(lk, &lk->lk);
8010508b:	8b 45 08             	mov    0x8(%ebp),%eax
8010508e:	83 c0 04             	add    $0x4,%eax
80105091:	83 ec 08             	sub    $0x8,%esp
80105094:	50                   	push   %eax
80105095:	ff 75 08             	pushl  0x8(%ebp)
80105098:	e8 d7 fc ff ff       	call   80104d74 <sleep>
8010509d:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801050a0:	8b 45 08             	mov    0x8(%ebp),%eax
801050a3:	8b 00                	mov    (%eax),%eax
801050a5:	85 c0                	test   %eax,%eax
801050a7:	75 e2                	jne    8010508b <acquiresleep+0x1e>
  }
  lk->locked = 1;
801050a9:	8b 45 08             	mov    0x8(%ebp),%eax
801050ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
801050b2:	e8 d8 f3 ff ff       	call   8010448f <myproc>
801050b7:	8b 50 10             	mov    0x10(%eax),%edx
801050ba:	8b 45 08             	mov    0x8(%ebp),%eax
801050bd:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
801050c0:	8b 45 08             	mov    0x8(%ebp),%eax
801050c3:	83 c0 04             	add    $0x4,%eax
801050c6:	83 ec 0c             	sub    $0xc,%esp
801050c9:	50                   	push   %eax
801050ca:	e8 89 01 00 00       	call   80105258 <release>
801050cf:	83 c4 10             	add    $0x10,%esp
}
801050d2:	90                   	nop
801050d3:	c9                   	leave  
801050d4:	c3                   	ret    

801050d5 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801050d5:	f3 0f 1e fb          	endbr32 
801050d9:	55                   	push   %ebp
801050da:	89 e5                	mov    %esp,%ebp
801050dc:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801050df:	8b 45 08             	mov    0x8(%ebp),%eax
801050e2:	83 c0 04             	add    $0x4,%eax
801050e5:	83 ec 0c             	sub    $0xc,%esp
801050e8:	50                   	push   %eax
801050e9:	e8 f8 00 00 00       	call   801051e6 <acquire>
801050ee:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801050f1:	8b 45 08             	mov    0x8(%ebp),%eax
801050f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801050fa:	8b 45 08             	mov    0x8(%ebp),%eax
801050fd:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80105104:	83 ec 0c             	sub    $0xc,%esp
80105107:	ff 75 08             	pushl  0x8(%ebp)
8010510a:	e8 57 fd ff ff       	call   80104e66 <wakeup>
8010510f:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80105112:	8b 45 08             	mov    0x8(%ebp),%eax
80105115:	83 c0 04             	add    $0x4,%eax
80105118:	83 ec 0c             	sub    $0xc,%esp
8010511b:	50                   	push   %eax
8010511c:	e8 37 01 00 00       	call   80105258 <release>
80105121:	83 c4 10             	add    $0x10,%esp
}
80105124:	90                   	nop
80105125:	c9                   	leave  
80105126:	c3                   	ret    

80105127 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105127:	f3 0f 1e fb          	endbr32 
8010512b:	55                   	push   %ebp
8010512c:	89 e5                	mov    %esp,%ebp
8010512e:	53                   	push   %ebx
8010512f:	83 ec 14             	sub    $0x14,%esp
  int r;
  
  acquire(&lk->lk);
80105132:	8b 45 08             	mov    0x8(%ebp),%eax
80105135:	83 c0 04             	add    $0x4,%eax
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	50                   	push   %eax
8010513c:	e8 a5 00 00 00       	call   801051e6 <acquire>
80105141:	83 c4 10             	add    $0x10,%esp
  r = lk->locked && (lk->pid == myproc()->pid);
80105144:	8b 45 08             	mov    0x8(%ebp),%eax
80105147:	8b 00                	mov    (%eax),%eax
80105149:	85 c0                	test   %eax,%eax
8010514b:	74 19                	je     80105166 <holdingsleep+0x3f>
8010514d:	8b 45 08             	mov    0x8(%ebp),%eax
80105150:	8b 58 3c             	mov    0x3c(%eax),%ebx
80105153:	e8 37 f3 ff ff       	call   8010448f <myproc>
80105158:	8b 40 10             	mov    0x10(%eax),%eax
8010515b:	39 c3                	cmp    %eax,%ebx
8010515d:	75 07                	jne    80105166 <holdingsleep+0x3f>
8010515f:	b8 01 00 00 00       	mov    $0x1,%eax
80105164:	eb 05                	jmp    8010516b <holdingsleep+0x44>
80105166:	b8 00 00 00 00       	mov    $0x0,%eax
8010516b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
8010516e:	8b 45 08             	mov    0x8(%ebp),%eax
80105171:	83 c0 04             	add    $0x4,%eax
80105174:	83 ec 0c             	sub    $0xc,%esp
80105177:	50                   	push   %eax
80105178:	e8 db 00 00 00       	call   80105258 <release>
8010517d:	83 c4 10             	add    $0x10,%esp
  return r;
80105180:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105183:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105186:	c9                   	leave  
80105187:	c3                   	ret    

80105188 <readeflags>:
{
80105188:	55                   	push   %ebp
80105189:	89 e5                	mov    %esp,%ebp
8010518b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010518e:	9c                   	pushf  
8010518f:	58                   	pop    %eax
80105190:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105193:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105196:	c9                   	leave  
80105197:	c3                   	ret    

80105198 <cli>:
{
80105198:	55                   	push   %ebp
80105199:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010519b:	fa                   	cli    
}
8010519c:	90                   	nop
8010519d:	5d                   	pop    %ebp
8010519e:	c3                   	ret    

8010519f <sti>:
{
8010519f:	55                   	push   %ebp
801051a0:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801051a2:	fb                   	sti    
}
801051a3:	90                   	nop
801051a4:	5d                   	pop    %ebp
801051a5:	c3                   	ret    

801051a6 <xchg>:
{
801051a6:	55                   	push   %ebp
801051a7:	89 e5                	mov    %esp,%ebp
801051a9:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
801051ac:	8b 55 08             	mov    0x8(%ebp),%edx
801051af:	8b 45 0c             	mov    0xc(%ebp),%eax
801051b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051b5:	f0 87 02             	lock xchg %eax,(%edx)
801051b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
801051bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801051be:	c9                   	leave  
801051bf:	c3                   	ret    

801051c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801051c0:	f3 0f 1e fb          	endbr32 
801051c4:	55                   	push   %ebp
801051c5:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801051c7:	8b 45 08             	mov    0x8(%ebp),%eax
801051ca:	8b 55 0c             	mov    0xc(%ebp),%edx
801051cd:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801051d0:	8b 45 08             	mov    0x8(%ebp),%eax
801051d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801051d9:	8b 45 08             	mov    0x8(%ebp),%eax
801051dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801051e3:	90                   	nop
801051e4:	5d                   	pop    %ebp
801051e5:	c3                   	ret    

801051e6 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801051e6:	f3 0f 1e fb          	endbr32 
801051ea:	55                   	push   %ebp
801051eb:	89 e5                	mov    %esp,%ebp
801051ed:	53                   	push   %ebx
801051ee:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801051f1:	e8 7c 01 00 00       	call   80105372 <pushcli>
  if(holding(lk))
801051f6:	8b 45 08             	mov    0x8(%ebp),%eax
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	50                   	push   %eax
801051fd:	e8 2b 01 00 00       	call   8010532d <holding>
80105202:	83 c4 10             	add    $0x10,%esp
80105205:	85 c0                	test   %eax,%eax
80105207:	74 0d                	je     80105216 <acquire+0x30>
    panic("acquire");
80105209:	83 ec 0c             	sub    $0xc,%esp
8010520c:	68 de 93 10 80       	push   $0x801093de
80105211:	e8 f2 b3 ff ff       	call   80100608 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80105216:	90                   	nop
80105217:	8b 45 08             	mov    0x8(%ebp),%eax
8010521a:	83 ec 08             	sub    $0x8,%esp
8010521d:	6a 01                	push   $0x1
8010521f:	50                   	push   %eax
80105220:	e8 81 ff ff ff       	call   801051a6 <xchg>
80105225:	83 c4 10             	add    $0x10,%esp
80105228:	85 c0                	test   %eax,%eax
8010522a:	75 eb                	jne    80105217 <acquire+0x31>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010522c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80105231:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105234:	e8 da f1 ff ff       	call   80104413 <mycpu>
80105239:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010523c:	8b 45 08             	mov    0x8(%ebp),%eax
8010523f:	83 c0 0c             	add    $0xc,%eax
80105242:	83 ec 08             	sub    $0x8,%esp
80105245:	50                   	push   %eax
80105246:	8d 45 08             	lea    0x8(%ebp),%eax
80105249:	50                   	push   %eax
8010524a:	e8 5f 00 00 00       	call   801052ae <getcallerpcs>
8010524f:	83 c4 10             	add    $0x10,%esp
}
80105252:	90                   	nop
80105253:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105256:	c9                   	leave  
80105257:	c3                   	ret    

80105258 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105258:	f3 0f 1e fb          	endbr32 
8010525c:	55                   	push   %ebp
8010525d:	89 e5                	mov    %esp,%ebp
8010525f:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105262:	83 ec 0c             	sub    $0xc,%esp
80105265:	ff 75 08             	pushl  0x8(%ebp)
80105268:	e8 c0 00 00 00       	call   8010532d <holding>
8010526d:	83 c4 10             	add    $0x10,%esp
80105270:	85 c0                	test   %eax,%eax
80105272:	75 0d                	jne    80105281 <release+0x29>
    panic("release");
80105274:	83 ec 0c             	sub    $0xc,%esp
80105277:	68 e6 93 10 80       	push   $0x801093e6
8010527c:	e8 87 b3 ff ff       	call   80100608 <panic>

  lk->pcs[0] = 0;
80105281:	8b 45 08             	mov    0x8(%ebp),%eax
80105284:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010528b:	8b 45 08             	mov    0x8(%ebp),%eax
8010528e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105295:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010529a:	8b 45 08             	mov    0x8(%ebp),%eax
8010529d:	8b 55 08             	mov    0x8(%ebp),%edx
801052a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
801052a6:	e8 18 01 00 00       	call   801053c3 <popcli>
}
801052ab:	90                   	nop
801052ac:	c9                   	leave  
801052ad:	c3                   	ret    

801052ae <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801052ae:	f3 0f 1e fb          	endbr32 
801052b2:	55                   	push   %ebp
801052b3:	89 e5                	mov    %esp,%ebp
801052b5:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801052b8:	8b 45 08             	mov    0x8(%ebp),%eax
801052bb:	83 e8 08             	sub    $0x8,%eax
801052be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801052c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801052c8:	eb 38                	jmp    80105302 <getcallerpcs+0x54>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801052ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801052ce:	74 53                	je     80105323 <getcallerpcs+0x75>
801052d0:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801052d7:	76 4a                	jbe    80105323 <getcallerpcs+0x75>
801052d9:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801052dd:	74 44                	je     80105323 <getcallerpcs+0x75>
      break;
    pcs[i] = ebp[1];     // saved %eip
801052df:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801052e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ec:	01 c2                	add    %eax,%edx
801052ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052f1:	8b 40 04             	mov    0x4(%eax),%eax
801052f4:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801052f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052f9:	8b 00                	mov    (%eax),%eax
801052fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801052fe:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105302:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105306:	7e c2                	jle    801052ca <getcallerpcs+0x1c>
  }
  for(; i < 10; i++)
80105308:	eb 19                	jmp    80105323 <getcallerpcs+0x75>
    pcs[i] = 0;
8010530a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010530d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105314:	8b 45 0c             	mov    0xc(%ebp),%eax
80105317:	01 d0                	add    %edx,%eax
80105319:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010531f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105323:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105327:	7e e1                	jle    8010530a <getcallerpcs+0x5c>
}
80105329:	90                   	nop
8010532a:	90                   	nop
8010532b:	c9                   	leave  
8010532c:	c3                   	ret    

8010532d <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010532d:	f3 0f 1e fb          	endbr32 
80105331:	55                   	push   %ebp
80105332:	89 e5                	mov    %esp,%ebp
80105334:	53                   	push   %ebx
80105335:	83 ec 14             	sub    $0x14,%esp
  int r;
  pushcli();
80105338:	e8 35 00 00 00       	call   80105372 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010533d:	8b 45 08             	mov    0x8(%ebp),%eax
80105340:	8b 00                	mov    (%eax),%eax
80105342:	85 c0                	test   %eax,%eax
80105344:	74 16                	je     8010535c <holding+0x2f>
80105346:	8b 45 08             	mov    0x8(%ebp),%eax
80105349:	8b 58 08             	mov    0x8(%eax),%ebx
8010534c:	e8 c2 f0 ff ff       	call   80104413 <mycpu>
80105351:	39 c3                	cmp    %eax,%ebx
80105353:	75 07                	jne    8010535c <holding+0x2f>
80105355:	b8 01 00 00 00       	mov    $0x1,%eax
8010535a:	eb 05                	jmp    80105361 <holding+0x34>
8010535c:	b8 00 00 00 00       	mov    $0x0,%eax
80105361:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
80105364:	e8 5a 00 00 00       	call   801053c3 <popcli>
  return r;
80105369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010536c:	83 c4 14             	add    $0x14,%esp
8010536f:	5b                   	pop    %ebx
80105370:	5d                   	pop    %ebp
80105371:	c3                   	ret    

80105372 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105372:	f3 0f 1e fb          	endbr32 
80105376:	55                   	push   %ebp
80105377:	89 e5                	mov    %esp,%ebp
80105379:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
8010537c:	e8 07 fe ff ff       	call   80105188 <readeflags>
80105381:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80105384:	e8 0f fe ff ff       	call   80105198 <cli>
  if(mycpu()->ncli == 0)
80105389:	e8 85 f0 ff ff       	call   80104413 <mycpu>
8010538e:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105394:	85 c0                	test   %eax,%eax
80105396:	75 14                	jne    801053ac <pushcli+0x3a>
    mycpu()->intena = eflags & FL_IF;
80105398:	e8 76 f0 ff ff       	call   80104413 <mycpu>
8010539d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053a0:	81 e2 00 02 00 00    	and    $0x200,%edx
801053a6:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
801053ac:	e8 62 f0 ff ff       	call   80104413 <mycpu>
801053b1:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801053b7:	83 c2 01             	add    $0x1,%edx
801053ba:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
801053c0:	90                   	nop
801053c1:	c9                   	leave  
801053c2:	c3                   	ret    

801053c3 <popcli>:

void
popcli(void)
{
801053c3:	f3 0f 1e fb          	endbr32 
801053c7:	55                   	push   %ebp
801053c8:	89 e5                	mov    %esp,%ebp
801053ca:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801053cd:	e8 b6 fd ff ff       	call   80105188 <readeflags>
801053d2:	25 00 02 00 00       	and    $0x200,%eax
801053d7:	85 c0                	test   %eax,%eax
801053d9:	74 0d                	je     801053e8 <popcli+0x25>
    panic("popcli - interruptible");
801053db:	83 ec 0c             	sub    $0xc,%esp
801053de:	68 ee 93 10 80       	push   $0x801093ee
801053e3:	e8 20 b2 ff ff       	call   80100608 <panic>
  if(--mycpu()->ncli < 0)
801053e8:	e8 26 f0 ff ff       	call   80104413 <mycpu>
801053ed:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801053f3:	83 ea 01             	sub    $0x1,%edx
801053f6:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801053fc:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105402:	85 c0                	test   %eax,%eax
80105404:	79 0d                	jns    80105413 <popcli+0x50>
    panic("popcli");
80105406:	83 ec 0c             	sub    $0xc,%esp
80105409:	68 05 94 10 80       	push   $0x80109405
8010540e:	e8 f5 b1 ff ff       	call   80100608 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105413:	e8 fb ef ff ff       	call   80104413 <mycpu>
80105418:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010541e:	85 c0                	test   %eax,%eax
80105420:	75 14                	jne    80105436 <popcli+0x73>
80105422:	e8 ec ef ff ff       	call   80104413 <mycpu>
80105427:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010542d:	85 c0                	test   %eax,%eax
8010542f:	74 05                	je     80105436 <popcli+0x73>
    sti();
80105431:	e8 69 fd ff ff       	call   8010519f <sti>
}
80105436:	90                   	nop
80105437:	c9                   	leave  
80105438:	c3                   	ret    

80105439 <stosb>:
{
80105439:	55                   	push   %ebp
8010543a:	89 e5                	mov    %esp,%ebp
8010543c:	57                   	push   %edi
8010543d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010543e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105441:	8b 55 10             	mov    0x10(%ebp),%edx
80105444:	8b 45 0c             	mov    0xc(%ebp),%eax
80105447:	89 cb                	mov    %ecx,%ebx
80105449:	89 df                	mov    %ebx,%edi
8010544b:	89 d1                	mov    %edx,%ecx
8010544d:	fc                   	cld    
8010544e:	f3 aa                	rep stos %al,%es:(%edi)
80105450:	89 ca                	mov    %ecx,%edx
80105452:	89 fb                	mov    %edi,%ebx
80105454:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105457:	89 55 10             	mov    %edx,0x10(%ebp)
}
8010545a:	90                   	nop
8010545b:	5b                   	pop    %ebx
8010545c:	5f                   	pop    %edi
8010545d:	5d                   	pop    %ebp
8010545e:	c3                   	ret    

8010545f <stosl>:
{
8010545f:	55                   	push   %ebp
80105460:	89 e5                	mov    %esp,%ebp
80105462:	57                   	push   %edi
80105463:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105464:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105467:	8b 55 10             	mov    0x10(%ebp),%edx
8010546a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010546d:	89 cb                	mov    %ecx,%ebx
8010546f:	89 df                	mov    %ebx,%edi
80105471:	89 d1                	mov    %edx,%ecx
80105473:	fc                   	cld    
80105474:	f3 ab                	rep stos %eax,%es:(%edi)
80105476:	89 ca                	mov    %ecx,%edx
80105478:	89 fb                	mov    %edi,%ebx
8010547a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010547d:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105480:	90                   	nop
80105481:	5b                   	pop    %ebx
80105482:	5f                   	pop    %edi
80105483:	5d                   	pop    %ebp
80105484:	c3                   	ret    

80105485 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105485:	f3 0f 1e fb          	endbr32 
80105489:	55                   	push   %ebp
8010548a:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
8010548c:	8b 45 08             	mov    0x8(%ebp),%eax
8010548f:	83 e0 03             	and    $0x3,%eax
80105492:	85 c0                	test   %eax,%eax
80105494:	75 43                	jne    801054d9 <memset+0x54>
80105496:	8b 45 10             	mov    0x10(%ebp),%eax
80105499:	83 e0 03             	and    $0x3,%eax
8010549c:	85 c0                	test   %eax,%eax
8010549e:	75 39                	jne    801054d9 <memset+0x54>
    c &= 0xFF;
801054a0:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801054a7:	8b 45 10             	mov    0x10(%ebp),%eax
801054aa:	c1 e8 02             	shr    $0x2,%eax
801054ad:	89 c1                	mov    %eax,%ecx
801054af:	8b 45 0c             	mov    0xc(%ebp),%eax
801054b2:	c1 e0 18             	shl    $0x18,%eax
801054b5:	89 c2                	mov    %eax,%edx
801054b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ba:	c1 e0 10             	shl    $0x10,%eax
801054bd:	09 c2                	or     %eax,%edx
801054bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c2:	c1 e0 08             	shl    $0x8,%eax
801054c5:	09 d0                	or     %edx,%eax
801054c7:	0b 45 0c             	or     0xc(%ebp),%eax
801054ca:	51                   	push   %ecx
801054cb:	50                   	push   %eax
801054cc:	ff 75 08             	pushl  0x8(%ebp)
801054cf:	e8 8b ff ff ff       	call   8010545f <stosl>
801054d4:	83 c4 0c             	add    $0xc,%esp
801054d7:	eb 12                	jmp    801054eb <memset+0x66>
  } else
    stosb(dst, c, n);
801054d9:	8b 45 10             	mov    0x10(%ebp),%eax
801054dc:	50                   	push   %eax
801054dd:	ff 75 0c             	pushl  0xc(%ebp)
801054e0:	ff 75 08             	pushl  0x8(%ebp)
801054e3:	e8 51 ff ff ff       	call   80105439 <stosb>
801054e8:	83 c4 0c             	add    $0xc,%esp
  return dst;
801054eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801054ee:	c9                   	leave  
801054ef:	c3                   	ret    

801054f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801054f0:	f3 0f 1e fb          	endbr32 
801054f4:	55                   	push   %ebp
801054f5:	89 e5                	mov    %esp,%ebp
801054f7:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
801054fa:	8b 45 08             	mov    0x8(%ebp),%eax
801054fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105500:	8b 45 0c             	mov    0xc(%ebp),%eax
80105503:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105506:	eb 30                	jmp    80105538 <memcmp+0x48>
    if(*s1 != *s2)
80105508:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010550b:	0f b6 10             	movzbl (%eax),%edx
8010550e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105511:	0f b6 00             	movzbl (%eax),%eax
80105514:	38 c2                	cmp    %al,%dl
80105516:	74 18                	je     80105530 <memcmp+0x40>
      return *s1 - *s2;
80105518:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010551b:	0f b6 00             	movzbl (%eax),%eax
8010551e:	0f b6 d0             	movzbl %al,%edx
80105521:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105524:	0f b6 00             	movzbl (%eax),%eax
80105527:	0f b6 c0             	movzbl %al,%eax
8010552a:	29 c2                	sub    %eax,%edx
8010552c:	89 d0                	mov    %edx,%eax
8010552e:	eb 1a                	jmp    8010554a <memcmp+0x5a>
    s1++, s2++;
80105530:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105534:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80105538:	8b 45 10             	mov    0x10(%ebp),%eax
8010553b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010553e:	89 55 10             	mov    %edx,0x10(%ebp)
80105541:	85 c0                	test   %eax,%eax
80105543:	75 c3                	jne    80105508 <memcmp+0x18>
  }

  return 0;
80105545:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010554a:	c9                   	leave  
8010554b:	c3                   	ret    

8010554c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010554c:	f3 0f 1e fb          	endbr32 
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105556:	8b 45 0c             	mov    0xc(%ebp),%eax
80105559:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010555c:	8b 45 08             	mov    0x8(%ebp),%eax
8010555f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105562:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105565:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105568:	73 54                	jae    801055be <memmove+0x72>
8010556a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010556d:	8b 45 10             	mov    0x10(%ebp),%eax
80105570:	01 d0                	add    %edx,%eax
80105572:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80105575:	73 47                	jae    801055be <memmove+0x72>
    s += n;
80105577:	8b 45 10             	mov    0x10(%ebp),%eax
8010557a:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010557d:	8b 45 10             	mov    0x10(%ebp),%eax
80105580:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105583:	eb 13                	jmp    80105598 <memmove+0x4c>
      *--d = *--s;
80105585:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105589:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010558d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105590:	0f b6 10             	movzbl (%eax),%edx
80105593:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105596:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105598:	8b 45 10             	mov    0x10(%ebp),%eax
8010559b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010559e:	89 55 10             	mov    %edx,0x10(%ebp)
801055a1:	85 c0                	test   %eax,%eax
801055a3:	75 e0                	jne    80105585 <memmove+0x39>
  if(s < d && s + n > d){
801055a5:	eb 24                	jmp    801055cb <memmove+0x7f>
  } else
    while(n-- > 0)
      *d++ = *s++;
801055a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055aa:	8d 42 01             	lea    0x1(%edx),%eax
801055ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
801055b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055b3:	8d 48 01             	lea    0x1(%eax),%ecx
801055b6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
801055b9:	0f b6 12             	movzbl (%edx),%edx
801055bc:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801055be:	8b 45 10             	mov    0x10(%ebp),%eax
801055c1:	8d 50 ff             	lea    -0x1(%eax),%edx
801055c4:	89 55 10             	mov    %edx,0x10(%ebp)
801055c7:	85 c0                	test   %eax,%eax
801055c9:	75 dc                	jne    801055a7 <memmove+0x5b>

  return dst;
801055cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801055ce:	c9                   	leave  
801055cf:	c3                   	ret    

801055d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801055d0:	f3 0f 1e fb          	endbr32 
801055d4:	55                   	push   %ebp
801055d5:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801055d7:	ff 75 10             	pushl  0x10(%ebp)
801055da:	ff 75 0c             	pushl  0xc(%ebp)
801055dd:	ff 75 08             	pushl  0x8(%ebp)
801055e0:	e8 67 ff ff ff       	call   8010554c <memmove>
801055e5:	83 c4 0c             	add    $0xc,%esp
}
801055e8:	c9                   	leave  
801055e9:	c3                   	ret    

801055ea <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801055ea:	f3 0f 1e fb          	endbr32 
801055ee:	55                   	push   %ebp
801055ef:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801055f1:	eb 0c                	jmp    801055ff <strncmp+0x15>
    n--, p++, q++;
801055f3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801055f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801055fb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
801055ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105603:	74 1a                	je     8010561f <strncmp+0x35>
80105605:	8b 45 08             	mov    0x8(%ebp),%eax
80105608:	0f b6 00             	movzbl (%eax),%eax
8010560b:	84 c0                	test   %al,%al
8010560d:	74 10                	je     8010561f <strncmp+0x35>
8010560f:	8b 45 08             	mov    0x8(%ebp),%eax
80105612:	0f b6 10             	movzbl (%eax),%edx
80105615:	8b 45 0c             	mov    0xc(%ebp),%eax
80105618:	0f b6 00             	movzbl (%eax),%eax
8010561b:	38 c2                	cmp    %al,%dl
8010561d:	74 d4                	je     801055f3 <strncmp+0x9>
  if(n == 0)
8010561f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105623:	75 07                	jne    8010562c <strncmp+0x42>
    return 0;
80105625:	b8 00 00 00 00       	mov    $0x0,%eax
8010562a:	eb 16                	jmp    80105642 <strncmp+0x58>
  return (uchar)*p - (uchar)*q;
8010562c:	8b 45 08             	mov    0x8(%ebp),%eax
8010562f:	0f b6 00             	movzbl (%eax),%eax
80105632:	0f b6 d0             	movzbl %al,%edx
80105635:	8b 45 0c             	mov    0xc(%ebp),%eax
80105638:	0f b6 00             	movzbl (%eax),%eax
8010563b:	0f b6 c0             	movzbl %al,%eax
8010563e:	29 c2                	sub    %eax,%edx
80105640:	89 d0                	mov    %edx,%eax
}
80105642:	5d                   	pop    %ebp
80105643:	c3                   	ret    

80105644 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105644:	f3 0f 1e fb          	endbr32 
80105648:	55                   	push   %ebp
80105649:	89 e5                	mov    %esp,%ebp
8010564b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
8010564e:	8b 45 08             	mov    0x8(%ebp),%eax
80105651:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105654:	90                   	nop
80105655:	8b 45 10             	mov    0x10(%ebp),%eax
80105658:	8d 50 ff             	lea    -0x1(%eax),%edx
8010565b:	89 55 10             	mov    %edx,0x10(%ebp)
8010565e:	85 c0                	test   %eax,%eax
80105660:	7e 2c                	jle    8010568e <strncpy+0x4a>
80105662:	8b 55 0c             	mov    0xc(%ebp),%edx
80105665:	8d 42 01             	lea    0x1(%edx),%eax
80105668:	89 45 0c             	mov    %eax,0xc(%ebp)
8010566b:	8b 45 08             	mov    0x8(%ebp),%eax
8010566e:	8d 48 01             	lea    0x1(%eax),%ecx
80105671:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105674:	0f b6 12             	movzbl (%edx),%edx
80105677:	88 10                	mov    %dl,(%eax)
80105679:	0f b6 00             	movzbl (%eax),%eax
8010567c:	84 c0                	test   %al,%al
8010567e:	75 d5                	jne    80105655 <strncpy+0x11>
    ;
  while(n-- > 0)
80105680:	eb 0c                	jmp    8010568e <strncpy+0x4a>
    *s++ = 0;
80105682:	8b 45 08             	mov    0x8(%ebp),%eax
80105685:	8d 50 01             	lea    0x1(%eax),%edx
80105688:	89 55 08             	mov    %edx,0x8(%ebp)
8010568b:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
8010568e:	8b 45 10             	mov    0x10(%ebp),%eax
80105691:	8d 50 ff             	lea    -0x1(%eax),%edx
80105694:	89 55 10             	mov    %edx,0x10(%ebp)
80105697:	85 c0                	test   %eax,%eax
80105699:	7f e7                	jg     80105682 <strncpy+0x3e>
  return os;
8010569b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010569e:	c9                   	leave  
8010569f:	c3                   	ret    

801056a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801056a0:	f3 0f 1e fb          	endbr32 
801056a4:	55                   	push   %ebp
801056a5:	89 e5                	mov    %esp,%ebp
801056a7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801056aa:	8b 45 08             	mov    0x8(%ebp),%eax
801056ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801056b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056b4:	7f 05                	jg     801056bb <safestrcpy+0x1b>
    return os;
801056b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056b9:	eb 31                	jmp    801056ec <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
801056bb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801056bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056c3:	7e 1e                	jle    801056e3 <safestrcpy+0x43>
801056c5:	8b 55 0c             	mov    0xc(%ebp),%edx
801056c8:	8d 42 01             	lea    0x1(%edx),%eax
801056cb:	89 45 0c             	mov    %eax,0xc(%ebp)
801056ce:	8b 45 08             	mov    0x8(%ebp),%eax
801056d1:	8d 48 01             	lea    0x1(%eax),%ecx
801056d4:	89 4d 08             	mov    %ecx,0x8(%ebp)
801056d7:	0f b6 12             	movzbl (%edx),%edx
801056da:	88 10                	mov    %dl,(%eax)
801056dc:	0f b6 00             	movzbl (%eax),%eax
801056df:	84 c0                	test   %al,%al
801056e1:	75 d8                	jne    801056bb <safestrcpy+0x1b>
    ;
  *s = 0;
801056e3:	8b 45 08             	mov    0x8(%ebp),%eax
801056e6:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801056e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801056ec:	c9                   	leave  
801056ed:	c3                   	ret    

801056ee <strlen>:

int
strlen(const char *s)
{
801056ee:	f3 0f 1e fb          	endbr32 
801056f2:	55                   	push   %ebp
801056f3:	89 e5                	mov    %esp,%ebp
801056f5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801056f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801056ff:	eb 04                	jmp    80105705 <strlen+0x17>
80105701:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105705:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105708:	8b 45 08             	mov    0x8(%ebp),%eax
8010570b:	01 d0                	add    %edx,%eax
8010570d:	0f b6 00             	movzbl (%eax),%eax
80105710:	84 c0                	test   %al,%al
80105712:	75 ed                	jne    80105701 <strlen+0x13>
    ;
  return n;
80105714:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105717:	c9                   	leave  
80105718:	c3                   	ret    

80105719 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105719:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010571d:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105721:	55                   	push   %ebp
  pushl %ebx
80105722:	53                   	push   %ebx
  pushl %esi
80105723:	56                   	push   %esi
  pushl %edi
80105724:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105725:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105727:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105729:	5f                   	pop    %edi
  popl %esi
8010572a:	5e                   	pop    %esi
  popl %ebx
8010572b:	5b                   	pop    %ebx
  popl %ebp
8010572c:	5d                   	pop    %ebp
  ret
8010572d:	c3                   	ret    

8010572e <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010572e:	f3 0f 1e fb          	endbr32 
80105732:	55                   	push   %ebp
80105733:	89 e5                	mov    %esp,%ebp
80105735:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105738:	e8 52 ed ff ff       	call   8010448f <myproc>
8010573d:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105740:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105743:	8b 00                	mov    (%eax),%eax
80105745:	39 45 08             	cmp    %eax,0x8(%ebp)
80105748:	73 0f                	jae    80105759 <fetchint+0x2b>
8010574a:	8b 45 08             	mov    0x8(%ebp),%eax
8010574d:	8d 50 04             	lea    0x4(%eax),%edx
80105750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105753:	8b 00                	mov    (%eax),%eax
80105755:	39 c2                	cmp    %eax,%edx
80105757:	76 07                	jbe    80105760 <fetchint+0x32>
    return -1;
80105759:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575e:	eb 0f                	jmp    8010576f <fetchint+0x41>
  *ip = *(int*)(addr);
80105760:	8b 45 08             	mov    0x8(%ebp),%eax
80105763:	8b 10                	mov    (%eax),%edx
80105765:	8b 45 0c             	mov    0xc(%ebp),%eax
80105768:	89 10                	mov    %edx,(%eax)
  return 0;
8010576a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010576f:	c9                   	leave  
80105770:	c3                   	ret    

80105771 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105771:	f3 0f 1e fb          	endbr32 
80105775:	55                   	push   %ebp
80105776:	89 e5                	mov    %esp,%ebp
80105778:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
8010577b:	e8 0f ed ff ff       	call   8010448f <myproc>
80105780:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80105783:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105786:	8b 00                	mov    (%eax),%eax
80105788:	39 45 08             	cmp    %eax,0x8(%ebp)
8010578b:	72 07                	jb     80105794 <fetchstr+0x23>
    return -1;
8010578d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105792:	eb 43                	jmp    801057d7 <fetchstr+0x66>
  *pp = (char*)addr;
80105794:	8b 55 08             	mov    0x8(%ebp),%edx
80105797:	8b 45 0c             	mov    0xc(%ebp),%eax
8010579a:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
8010579c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010579f:	8b 00                	mov    (%eax),%eax
801057a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
801057a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801057a7:	8b 00                	mov    (%eax),%eax
801057a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057ac:	eb 1c                	jmp    801057ca <fetchstr+0x59>
    if(*s == 0)
801057ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b1:	0f b6 00             	movzbl (%eax),%eax
801057b4:	84 c0                	test   %al,%al
801057b6:	75 0e                	jne    801057c6 <fetchstr+0x55>
      return s - *pp;
801057b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801057bb:	8b 00                	mov    (%eax),%eax
801057bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057c0:	29 c2                	sub    %eax,%edx
801057c2:	89 d0                	mov    %edx,%eax
801057c4:	eb 11                	jmp    801057d7 <fetchstr+0x66>
  for(s = *pp; s < ep; s++){
801057c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801057ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057cd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801057d0:	72 dc                	jb     801057ae <fetchstr+0x3d>
  }
  return -1;
801057d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057d7:	c9                   	leave  
801057d8:	c3                   	ret    

801057d9 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801057d9:	f3 0f 1e fb          	endbr32 
801057dd:	55                   	push   %ebp
801057de:	89 e5                	mov    %esp,%ebp
801057e0:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801057e3:	e8 a7 ec ff ff       	call   8010448f <myproc>
801057e8:	8b 40 18             	mov    0x18(%eax),%eax
801057eb:	8b 40 44             	mov    0x44(%eax),%eax
801057ee:	8b 55 08             	mov    0x8(%ebp),%edx
801057f1:	c1 e2 02             	shl    $0x2,%edx
801057f4:	01 d0                	add    %edx,%eax
801057f6:	83 c0 04             	add    $0x4,%eax
801057f9:	83 ec 08             	sub    $0x8,%esp
801057fc:	ff 75 0c             	pushl  0xc(%ebp)
801057ff:	50                   	push   %eax
80105800:	e8 29 ff ff ff       	call   8010572e <fetchint>
80105805:	83 c4 10             	add    $0x10,%esp
}
80105808:	c9                   	leave  
80105809:	c3                   	ret    

8010580a <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010580a:	f3 0f 1e fb          	endbr32 
8010580e:	55                   	push   %ebp
8010580f:	89 e5                	mov    %esp,%ebp
80105811:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80105814:	e8 76 ec ff ff       	call   8010448f <myproc>
80105819:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
8010581c:	83 ec 08             	sub    $0x8,%esp
8010581f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105822:	50                   	push   %eax
80105823:	ff 75 08             	pushl  0x8(%ebp)
80105826:	e8 ae ff ff ff       	call   801057d9 <argint>
8010582b:	83 c4 10             	add    $0x10,%esp
8010582e:	85 c0                	test   %eax,%eax
80105830:	79 07                	jns    80105839 <argptr+0x2f>
    return -1;
80105832:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105837:	eb 3b                	jmp    80105874 <argptr+0x6a>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105839:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010583d:	78 1f                	js     8010585e <argptr+0x54>
8010583f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105842:	8b 00                	mov    (%eax),%eax
80105844:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105847:	39 d0                	cmp    %edx,%eax
80105849:	76 13                	jbe    8010585e <argptr+0x54>
8010584b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010584e:	89 c2                	mov    %eax,%edx
80105850:	8b 45 10             	mov    0x10(%ebp),%eax
80105853:	01 c2                	add    %eax,%edx
80105855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105858:	8b 00                	mov    (%eax),%eax
8010585a:	39 c2                	cmp    %eax,%edx
8010585c:	76 07                	jbe    80105865 <argptr+0x5b>
    return -1;
8010585e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105863:	eb 0f                	jmp    80105874 <argptr+0x6a>
  *pp = (char*)i;
80105865:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105868:	89 c2                	mov    %eax,%edx
8010586a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010586d:	89 10                	mov    %edx,(%eax)
  return 0;
8010586f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105874:	c9                   	leave  
80105875:	c3                   	ret    

80105876 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105876:	f3 0f 1e fb          	endbr32 
8010587a:	55                   	push   %ebp
8010587b:	89 e5                	mov    %esp,%ebp
8010587d:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105880:	83 ec 08             	sub    $0x8,%esp
80105883:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105886:	50                   	push   %eax
80105887:	ff 75 08             	pushl  0x8(%ebp)
8010588a:	e8 4a ff ff ff       	call   801057d9 <argint>
8010588f:	83 c4 10             	add    $0x10,%esp
80105892:	85 c0                	test   %eax,%eax
80105894:	79 07                	jns    8010589d <argstr+0x27>
    return -1;
80105896:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589b:	eb 12                	jmp    801058af <argstr+0x39>
  return fetchstr(addr, pp);
8010589d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058a0:	83 ec 08             	sub    $0x8,%esp
801058a3:	ff 75 0c             	pushl  0xc(%ebp)
801058a6:	50                   	push   %eax
801058a7:	e8 c5 fe ff ff       	call   80105771 <fetchstr>
801058ac:	83 c4 10             	add    $0x10,%esp
}
801058af:	c9                   	leave  
801058b0:	c3                   	ret    

801058b1 <syscall>:
[SYS_dump_rawphymem] sys_dump_rawphymem,
};

void
syscall(void)
{
801058b1:	f3 0f 1e fb          	endbr32 
801058b5:	55                   	push   %ebp
801058b6:	89 e5                	mov    %esp,%ebp
801058b8:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
801058bb:	e8 cf eb ff ff       	call   8010448f <myproc>
801058c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
801058c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c6:	8b 40 18             	mov    0x18(%eax),%eax
801058c9:	8b 40 1c             	mov    0x1c(%eax),%eax
801058cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801058cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058d3:	7e 2f                	jle    80105904 <syscall+0x53>
801058d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d8:	83 f8 18             	cmp    $0x18,%eax
801058db:	77 27                	ja     80105904 <syscall+0x53>
801058dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058e0:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
801058e7:	85 c0                	test   %eax,%eax
801058e9:	74 19                	je     80105904 <syscall+0x53>
    curproc->tf->eax = syscalls[num]();
801058eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ee:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
801058f5:	ff d0                	call   *%eax
801058f7:	89 c2                	mov    %eax,%edx
801058f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058fc:	8b 40 18             	mov    0x18(%eax),%eax
801058ff:	89 50 1c             	mov    %edx,0x1c(%eax)
80105902:	eb 2c                	jmp    80105930 <syscall+0x7f>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105904:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105907:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
8010590a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010590d:	8b 40 10             	mov    0x10(%eax),%eax
80105910:	ff 75 f0             	pushl  -0x10(%ebp)
80105913:	52                   	push   %edx
80105914:	50                   	push   %eax
80105915:	68 0c 94 10 80       	push   $0x8010940c
8010591a:	e8 f9 aa ff ff       	call   80100418 <cprintf>
8010591f:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105925:	8b 40 18             	mov    0x18(%eax),%eax
80105928:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010592f:	90                   	nop
80105930:	90                   	nop
80105931:	c9                   	leave  
80105932:	c3                   	ret    

80105933 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105933:	f3 0f 1e fb          	endbr32 
80105937:	55                   	push   %ebp
80105938:	89 e5                	mov    %esp,%ebp
8010593a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010593d:	83 ec 08             	sub    $0x8,%esp
80105940:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105943:	50                   	push   %eax
80105944:	ff 75 08             	pushl  0x8(%ebp)
80105947:	e8 8d fe ff ff       	call   801057d9 <argint>
8010594c:	83 c4 10             	add    $0x10,%esp
8010594f:	85 c0                	test   %eax,%eax
80105951:	79 07                	jns    8010595a <argfd+0x27>
    return -1;
80105953:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105958:	eb 4f                	jmp    801059a9 <argfd+0x76>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010595a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595d:	85 c0                	test   %eax,%eax
8010595f:	78 20                	js     80105981 <argfd+0x4e>
80105961:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105964:	83 f8 0f             	cmp    $0xf,%eax
80105967:	7f 18                	jg     80105981 <argfd+0x4e>
80105969:	e8 21 eb ff ff       	call   8010448f <myproc>
8010596e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105971:	83 c2 08             	add    $0x8,%edx
80105974:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105978:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010597b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010597f:	75 07                	jne    80105988 <argfd+0x55>
    return -1;
80105981:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105986:	eb 21                	jmp    801059a9 <argfd+0x76>
  if(pfd)
80105988:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010598c:	74 08                	je     80105996 <argfd+0x63>
    *pfd = fd;
8010598e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105991:	8b 45 0c             	mov    0xc(%ebp),%eax
80105994:	89 10                	mov    %edx,(%eax)
  if(pf)
80105996:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010599a:	74 08                	je     801059a4 <argfd+0x71>
    *pf = f;
8010599c:	8b 45 10             	mov    0x10(%ebp),%eax
8010599f:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059a2:	89 10                	mov    %edx,(%eax)
  return 0;
801059a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059a9:	c9                   	leave  
801059aa:	c3                   	ret    

801059ab <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801059ab:	f3 0f 1e fb          	endbr32 
801059af:	55                   	push   %ebp
801059b0:	89 e5                	mov    %esp,%ebp
801059b2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801059b5:	e8 d5 ea ff ff       	call   8010448f <myproc>
801059ba:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801059bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801059c4:	eb 2a                	jmp    801059f0 <fdalloc+0x45>
    if(curproc->ofile[fd] == 0){
801059c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059cc:	83 c2 08             	add    $0x8,%edx
801059cf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801059d3:	85 c0                	test   %eax,%eax
801059d5:	75 15                	jne    801059ec <fdalloc+0x41>
      curproc->ofile[fd] = f;
801059d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059dd:	8d 4a 08             	lea    0x8(%edx),%ecx
801059e0:	8b 55 08             	mov    0x8(%ebp),%edx
801059e3:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801059e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ea:	eb 0f                	jmp    801059fb <fdalloc+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801059ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801059f0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801059f4:	7e d0                	jle    801059c6 <fdalloc+0x1b>
    }
  }
  return -1;
801059f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059fb:	c9                   	leave  
801059fc:	c3                   	ret    

801059fd <sys_dup>:

int
sys_dup(void)
{
801059fd:	f3 0f 1e fb          	endbr32 
80105a01:	55                   	push   %ebp
80105a02:	89 e5                	mov    %esp,%ebp
80105a04:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105a07:	83 ec 04             	sub    $0x4,%esp
80105a0a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a0d:	50                   	push   %eax
80105a0e:	6a 00                	push   $0x0
80105a10:	6a 00                	push   $0x0
80105a12:	e8 1c ff ff ff       	call   80105933 <argfd>
80105a17:	83 c4 10             	add    $0x10,%esp
80105a1a:	85 c0                	test   %eax,%eax
80105a1c:	79 07                	jns    80105a25 <sys_dup+0x28>
    return -1;
80105a1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a23:	eb 31                	jmp    80105a56 <sys_dup+0x59>
  if((fd=fdalloc(f)) < 0)
80105a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a28:	83 ec 0c             	sub    $0xc,%esp
80105a2b:	50                   	push   %eax
80105a2c:	e8 7a ff ff ff       	call   801059ab <fdalloc>
80105a31:	83 c4 10             	add    $0x10,%esp
80105a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a3b:	79 07                	jns    80105a44 <sys_dup+0x47>
    return -1;
80105a3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a42:	eb 12                	jmp    80105a56 <sys_dup+0x59>
  filedup(f);
80105a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a47:	83 ec 0c             	sub    $0xc,%esp
80105a4a:	50                   	push   %eax
80105a4b:	e8 b6 b6 ff ff       	call   80101106 <filedup>
80105a50:	83 c4 10             	add    $0x10,%esp
  return fd;
80105a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105a56:	c9                   	leave  
80105a57:	c3                   	ret    

80105a58 <sys_read>:

int
sys_read(void)
{
80105a58:	f3 0f 1e fb          	endbr32 
80105a5c:	55                   	push   %ebp
80105a5d:	89 e5                	mov    %esp,%ebp
80105a5f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a62:	83 ec 04             	sub    $0x4,%esp
80105a65:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a68:	50                   	push   %eax
80105a69:	6a 00                	push   $0x0
80105a6b:	6a 00                	push   $0x0
80105a6d:	e8 c1 fe ff ff       	call   80105933 <argfd>
80105a72:	83 c4 10             	add    $0x10,%esp
80105a75:	85 c0                	test   %eax,%eax
80105a77:	78 2e                	js     80105aa7 <sys_read+0x4f>
80105a79:	83 ec 08             	sub    $0x8,%esp
80105a7c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a7f:	50                   	push   %eax
80105a80:	6a 02                	push   $0x2
80105a82:	e8 52 fd ff ff       	call   801057d9 <argint>
80105a87:	83 c4 10             	add    $0x10,%esp
80105a8a:	85 c0                	test   %eax,%eax
80105a8c:	78 19                	js     80105aa7 <sys_read+0x4f>
80105a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a91:	83 ec 04             	sub    $0x4,%esp
80105a94:	50                   	push   %eax
80105a95:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a98:	50                   	push   %eax
80105a99:	6a 01                	push   $0x1
80105a9b:	e8 6a fd ff ff       	call   8010580a <argptr>
80105aa0:	83 c4 10             	add    $0x10,%esp
80105aa3:	85 c0                	test   %eax,%eax
80105aa5:	79 07                	jns    80105aae <sys_read+0x56>
    return -1;
80105aa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aac:	eb 17                	jmp    80105ac5 <sys_read+0x6d>
  return fileread(f, p, n);
80105aae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105ab1:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab7:	83 ec 04             	sub    $0x4,%esp
80105aba:	51                   	push   %ecx
80105abb:	52                   	push   %edx
80105abc:	50                   	push   %eax
80105abd:	e8 e0 b7 ff ff       	call   801012a2 <fileread>
80105ac2:	83 c4 10             	add    $0x10,%esp
}
80105ac5:	c9                   	leave  
80105ac6:	c3                   	ret    

80105ac7 <sys_write>:

int
sys_write(void)
{
80105ac7:	f3 0f 1e fb          	endbr32 
80105acb:	55                   	push   %ebp
80105acc:	89 e5                	mov    %esp,%ebp
80105ace:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ad1:	83 ec 04             	sub    $0x4,%esp
80105ad4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ad7:	50                   	push   %eax
80105ad8:	6a 00                	push   $0x0
80105ada:	6a 00                	push   $0x0
80105adc:	e8 52 fe ff ff       	call   80105933 <argfd>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	78 2e                	js     80105b16 <sys_write+0x4f>
80105ae8:	83 ec 08             	sub    $0x8,%esp
80105aeb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105aee:	50                   	push   %eax
80105aef:	6a 02                	push   $0x2
80105af1:	e8 e3 fc ff ff       	call   801057d9 <argint>
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	85 c0                	test   %eax,%eax
80105afb:	78 19                	js     80105b16 <sys_write+0x4f>
80105afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b00:	83 ec 04             	sub    $0x4,%esp
80105b03:	50                   	push   %eax
80105b04:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b07:	50                   	push   %eax
80105b08:	6a 01                	push   $0x1
80105b0a:	e8 fb fc ff ff       	call   8010580a <argptr>
80105b0f:	83 c4 10             	add    $0x10,%esp
80105b12:	85 c0                	test   %eax,%eax
80105b14:	79 07                	jns    80105b1d <sys_write+0x56>
    return -1;
80105b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1b:	eb 17                	jmp    80105b34 <sys_write+0x6d>
  return filewrite(f, p, n);
80105b1d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b20:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b26:	83 ec 04             	sub    $0x4,%esp
80105b29:	51                   	push   %ecx
80105b2a:	52                   	push   %edx
80105b2b:	50                   	push   %eax
80105b2c:	e8 2d b8 ff ff       	call   8010135e <filewrite>
80105b31:	83 c4 10             	add    $0x10,%esp
}
80105b34:	c9                   	leave  
80105b35:	c3                   	ret    

80105b36 <sys_close>:

int
sys_close(void)
{
80105b36:	f3 0f 1e fb          	endbr32 
80105b3a:	55                   	push   %ebp
80105b3b:	89 e5                	mov    %esp,%ebp
80105b3d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105b40:	83 ec 04             	sub    $0x4,%esp
80105b43:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b46:	50                   	push   %eax
80105b47:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b4a:	50                   	push   %eax
80105b4b:	6a 00                	push   $0x0
80105b4d:	e8 e1 fd ff ff       	call   80105933 <argfd>
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	85 c0                	test   %eax,%eax
80105b57:	79 07                	jns    80105b60 <sys_close+0x2a>
    return -1;
80105b59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5e:	eb 27                	jmp    80105b87 <sys_close+0x51>
  myproc()->ofile[fd] = 0;
80105b60:	e8 2a e9 ff ff       	call   8010448f <myproc>
80105b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b68:	83 c2 08             	add    $0x8,%edx
80105b6b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105b72:	00 
  fileclose(f);
80105b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b76:	83 ec 0c             	sub    $0xc,%esp
80105b79:	50                   	push   %eax
80105b7a:	e8 dc b5 ff ff       	call   8010115b <fileclose>
80105b7f:	83 c4 10             	add    $0x10,%esp
  return 0;
80105b82:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b87:	c9                   	leave  
80105b88:	c3                   	ret    

80105b89 <sys_fstat>:

int
sys_fstat(void)
{
80105b89:	f3 0f 1e fb          	endbr32 
80105b8d:	55                   	push   %ebp
80105b8e:	89 e5                	mov    %esp,%ebp
80105b90:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105b93:	83 ec 04             	sub    $0x4,%esp
80105b96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b99:	50                   	push   %eax
80105b9a:	6a 00                	push   $0x0
80105b9c:	6a 00                	push   $0x0
80105b9e:	e8 90 fd ff ff       	call   80105933 <argfd>
80105ba3:	83 c4 10             	add    $0x10,%esp
80105ba6:	85 c0                	test   %eax,%eax
80105ba8:	78 17                	js     80105bc1 <sys_fstat+0x38>
80105baa:	83 ec 04             	sub    $0x4,%esp
80105bad:	6a 14                	push   $0x14
80105baf:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bb2:	50                   	push   %eax
80105bb3:	6a 01                	push   $0x1
80105bb5:	e8 50 fc ff ff       	call   8010580a <argptr>
80105bba:	83 c4 10             	add    $0x10,%esp
80105bbd:	85 c0                	test   %eax,%eax
80105bbf:	79 07                	jns    80105bc8 <sys_fstat+0x3f>
    return -1;
80105bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc6:	eb 13                	jmp    80105bdb <sys_fstat+0x52>
  return filestat(f, st);
80105bc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bce:	83 ec 08             	sub    $0x8,%esp
80105bd1:	52                   	push   %edx
80105bd2:	50                   	push   %eax
80105bd3:	e8 6f b6 ff ff       	call   80101247 <filestat>
80105bd8:	83 c4 10             	add    $0x10,%esp
}
80105bdb:	c9                   	leave  
80105bdc:	c3                   	ret    

80105bdd <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105bdd:	f3 0f 1e fb          	endbr32 
80105be1:	55                   	push   %ebp
80105be2:	89 e5                	mov    %esp,%ebp
80105be4:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105be7:	83 ec 08             	sub    $0x8,%esp
80105bea:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105bed:	50                   	push   %eax
80105bee:	6a 00                	push   $0x0
80105bf0:	e8 81 fc ff ff       	call   80105876 <argstr>
80105bf5:	83 c4 10             	add    $0x10,%esp
80105bf8:	85 c0                	test   %eax,%eax
80105bfa:	78 15                	js     80105c11 <sys_link+0x34>
80105bfc:	83 ec 08             	sub    $0x8,%esp
80105bff:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105c02:	50                   	push   %eax
80105c03:	6a 01                	push   $0x1
80105c05:	e8 6c fc ff ff       	call   80105876 <argstr>
80105c0a:	83 c4 10             	add    $0x10,%esp
80105c0d:	85 c0                	test   %eax,%eax
80105c0f:	79 0a                	jns    80105c1b <sys_link+0x3e>
    return -1;
80105c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c16:	e9 68 01 00 00       	jmp    80105d83 <sys_link+0x1a6>

  begin_op();
80105c1b:	e8 b0 da ff ff       	call   801036d0 <begin_op>
  if((ip = namei(old)) == 0){
80105c20:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105c23:	83 ec 0c             	sub    $0xc,%esp
80105c26:	50                   	push   %eax
80105c27:	e8 1a ca ff ff       	call   80102646 <namei>
80105c2c:	83 c4 10             	add    $0x10,%esp
80105c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c36:	75 0f                	jne    80105c47 <sys_link+0x6a>
    end_op();
80105c38:	e8 23 db ff ff       	call   80103760 <end_op>
    return -1;
80105c3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c42:	e9 3c 01 00 00       	jmp    80105d83 <sys_link+0x1a6>
  }

  ilock(ip);
80105c47:	83 ec 0c             	sub    $0xc,%esp
80105c4a:	ff 75 f4             	pushl  -0xc(%ebp)
80105c4d:	e8 89 be ff ff       	call   80101adb <ilock>
80105c52:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c58:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105c5c:	66 83 f8 01          	cmp    $0x1,%ax
80105c60:	75 1d                	jne    80105c7f <sys_link+0xa2>
    iunlockput(ip);
80105c62:	83 ec 0c             	sub    $0xc,%esp
80105c65:	ff 75 f4             	pushl  -0xc(%ebp)
80105c68:	e8 ab c0 ff ff       	call   80101d18 <iunlockput>
80105c6d:	83 c4 10             	add    $0x10,%esp
    end_op();
80105c70:	e8 eb da ff ff       	call   80103760 <end_op>
    return -1;
80105c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c7a:	e9 04 01 00 00       	jmp    80105d83 <sys_link+0x1a6>
  }

  ip->nlink++;
80105c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c82:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105c86:	83 c0 01             	add    $0x1,%eax
80105c89:	89 c2                	mov    %eax,%edx
80105c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c8e:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105c92:	83 ec 0c             	sub    $0xc,%esp
80105c95:	ff 75 f4             	pushl  -0xc(%ebp)
80105c98:	e8 55 bc ff ff       	call   801018f2 <iupdate>
80105c9d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105ca0:	83 ec 0c             	sub    $0xc,%esp
80105ca3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ca6:	e8 47 bf ff ff       	call   80101bf2 <iunlock>
80105cab:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105cae:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cb1:	83 ec 08             	sub    $0x8,%esp
80105cb4:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105cb7:	52                   	push   %edx
80105cb8:	50                   	push   %eax
80105cb9:	e8 a8 c9 ff ff       	call   80102666 <nameiparent>
80105cbe:	83 c4 10             	add    $0x10,%esp
80105cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cc8:	74 71                	je     80105d3b <sys_link+0x15e>
    goto bad;
  ilock(dp);
80105cca:	83 ec 0c             	sub    $0xc,%esp
80105ccd:	ff 75 f0             	pushl  -0x10(%ebp)
80105cd0:	e8 06 be ff ff       	call   80101adb <ilock>
80105cd5:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cdb:	8b 10                	mov    (%eax),%edx
80105cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce0:	8b 00                	mov    (%eax),%eax
80105ce2:	39 c2                	cmp    %eax,%edx
80105ce4:	75 1d                	jne    80105d03 <sys_link+0x126>
80105ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce9:	8b 40 04             	mov    0x4(%eax),%eax
80105cec:	83 ec 04             	sub    $0x4,%esp
80105cef:	50                   	push   %eax
80105cf0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105cf3:	50                   	push   %eax
80105cf4:	ff 75 f0             	pushl  -0x10(%ebp)
80105cf7:	e8 a7 c6 ff ff       	call   801023a3 <dirlink>
80105cfc:	83 c4 10             	add    $0x10,%esp
80105cff:	85 c0                	test   %eax,%eax
80105d01:	79 10                	jns    80105d13 <sys_link+0x136>
    iunlockput(dp);
80105d03:	83 ec 0c             	sub    $0xc,%esp
80105d06:	ff 75 f0             	pushl  -0x10(%ebp)
80105d09:	e8 0a c0 ff ff       	call   80101d18 <iunlockput>
80105d0e:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105d11:	eb 29                	jmp    80105d3c <sys_link+0x15f>
  }
  iunlockput(dp);
80105d13:	83 ec 0c             	sub    $0xc,%esp
80105d16:	ff 75 f0             	pushl  -0x10(%ebp)
80105d19:	e8 fa bf ff ff       	call   80101d18 <iunlockput>
80105d1e:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105d21:	83 ec 0c             	sub    $0xc,%esp
80105d24:	ff 75 f4             	pushl  -0xc(%ebp)
80105d27:	e8 18 bf ff ff       	call   80101c44 <iput>
80105d2c:	83 c4 10             	add    $0x10,%esp

  end_op();
80105d2f:	e8 2c da ff ff       	call   80103760 <end_op>

  return 0;
80105d34:	b8 00 00 00 00       	mov    $0x0,%eax
80105d39:	eb 48                	jmp    80105d83 <sys_link+0x1a6>
    goto bad;
80105d3b:	90                   	nop

bad:
  ilock(ip);
80105d3c:	83 ec 0c             	sub    $0xc,%esp
80105d3f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d42:	e8 94 bd ff ff       	call   80101adb <ilock>
80105d47:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d4d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105d51:	83 e8 01             	sub    $0x1,%eax
80105d54:	89 c2                	mov    %eax,%edx
80105d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d59:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105d5d:	83 ec 0c             	sub    $0xc,%esp
80105d60:	ff 75 f4             	pushl  -0xc(%ebp)
80105d63:	e8 8a bb ff ff       	call   801018f2 <iupdate>
80105d68:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105d6b:	83 ec 0c             	sub    $0xc,%esp
80105d6e:	ff 75 f4             	pushl  -0xc(%ebp)
80105d71:	e8 a2 bf ff ff       	call   80101d18 <iunlockput>
80105d76:	83 c4 10             	add    $0x10,%esp
  end_op();
80105d79:	e8 e2 d9 ff ff       	call   80103760 <end_op>
  return -1;
80105d7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d83:	c9                   	leave  
80105d84:	c3                   	ret    

80105d85 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105d85:	f3 0f 1e fb          	endbr32 
80105d89:	55                   	push   %ebp
80105d8a:	89 e5                	mov    %esp,%ebp
80105d8c:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d8f:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105d96:	eb 40                	jmp    80105dd8 <isdirempty+0x53>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d9b:	6a 10                	push   $0x10
80105d9d:	50                   	push   %eax
80105d9e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105da1:	50                   	push   %eax
80105da2:	ff 75 08             	pushl  0x8(%ebp)
80105da5:	e8 39 c2 ff ff       	call   80101fe3 <readi>
80105daa:	83 c4 10             	add    $0x10,%esp
80105dad:	83 f8 10             	cmp    $0x10,%eax
80105db0:	74 0d                	je     80105dbf <isdirempty+0x3a>
      panic("isdirempty: readi");
80105db2:	83 ec 0c             	sub    $0xc,%esp
80105db5:	68 28 94 10 80       	push   $0x80109428
80105dba:	e8 49 a8 ff ff       	call   80100608 <panic>
    if(de.inum != 0)
80105dbf:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105dc3:	66 85 c0             	test   %ax,%ax
80105dc6:	74 07                	je     80105dcf <isdirempty+0x4a>
      return 0;
80105dc8:	b8 00 00 00 00       	mov    $0x0,%eax
80105dcd:	eb 1b                	jmp    80105dea <isdirempty+0x65>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd2:	83 c0 10             	add    $0x10,%eax
80105dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dd8:	8b 45 08             	mov    0x8(%ebp),%eax
80105ddb:	8b 50 58             	mov    0x58(%eax),%edx
80105dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de1:	39 c2                	cmp    %eax,%edx
80105de3:	77 b3                	ja     80105d98 <isdirempty+0x13>
  }
  return 1;
80105de5:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105dea:	c9                   	leave  
80105deb:	c3                   	ret    

80105dec <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105dec:	f3 0f 1e fb          	endbr32 
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105df6:	83 ec 08             	sub    $0x8,%esp
80105df9:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105dfc:	50                   	push   %eax
80105dfd:	6a 00                	push   $0x0
80105dff:	e8 72 fa ff ff       	call   80105876 <argstr>
80105e04:	83 c4 10             	add    $0x10,%esp
80105e07:	85 c0                	test   %eax,%eax
80105e09:	79 0a                	jns    80105e15 <sys_unlink+0x29>
    return -1;
80105e0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e10:	e9 bf 01 00 00       	jmp    80105fd4 <sys_unlink+0x1e8>

  begin_op();
80105e15:	e8 b6 d8 ff ff       	call   801036d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105e1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105e1d:	83 ec 08             	sub    $0x8,%esp
80105e20:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105e23:	52                   	push   %edx
80105e24:	50                   	push   %eax
80105e25:	e8 3c c8 ff ff       	call   80102666 <nameiparent>
80105e2a:	83 c4 10             	add    $0x10,%esp
80105e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e34:	75 0f                	jne    80105e45 <sys_unlink+0x59>
    end_op();
80105e36:	e8 25 d9 ff ff       	call   80103760 <end_op>
    return -1;
80105e3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e40:	e9 8f 01 00 00       	jmp    80105fd4 <sys_unlink+0x1e8>
  }

  ilock(dp);
80105e45:	83 ec 0c             	sub    $0xc,%esp
80105e48:	ff 75 f4             	pushl  -0xc(%ebp)
80105e4b:	e8 8b bc ff ff       	call   80101adb <ilock>
80105e50:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105e53:	83 ec 08             	sub    $0x8,%esp
80105e56:	68 3a 94 10 80       	push   $0x8010943a
80105e5b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e5e:	50                   	push   %eax
80105e5f:	e8 62 c4 ff ff       	call   801022c6 <namecmp>
80105e64:	83 c4 10             	add    $0x10,%esp
80105e67:	85 c0                	test   %eax,%eax
80105e69:	0f 84 49 01 00 00    	je     80105fb8 <sys_unlink+0x1cc>
80105e6f:	83 ec 08             	sub    $0x8,%esp
80105e72:	68 3c 94 10 80       	push   $0x8010943c
80105e77:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e7a:	50                   	push   %eax
80105e7b:	e8 46 c4 ff ff       	call   801022c6 <namecmp>
80105e80:	83 c4 10             	add    $0x10,%esp
80105e83:	85 c0                	test   %eax,%eax
80105e85:	0f 84 2d 01 00 00    	je     80105fb8 <sys_unlink+0x1cc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105e8b:	83 ec 04             	sub    $0x4,%esp
80105e8e:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105e91:	50                   	push   %eax
80105e92:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105e95:	50                   	push   %eax
80105e96:	ff 75 f4             	pushl  -0xc(%ebp)
80105e99:	e8 47 c4 ff ff       	call   801022e5 <dirlookup>
80105e9e:	83 c4 10             	add    $0x10,%esp
80105ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ea4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ea8:	0f 84 0d 01 00 00    	je     80105fbb <sys_unlink+0x1cf>
    goto bad;
  ilock(ip);
80105eae:	83 ec 0c             	sub    $0xc,%esp
80105eb1:	ff 75 f0             	pushl  -0x10(%ebp)
80105eb4:	e8 22 bc ff ff       	call   80101adb <ilock>
80105eb9:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ebf:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105ec3:	66 85 c0             	test   %ax,%ax
80105ec6:	7f 0d                	jg     80105ed5 <sys_unlink+0xe9>
    panic("unlink: nlink < 1");
80105ec8:	83 ec 0c             	sub    $0xc,%esp
80105ecb:	68 3f 94 10 80       	push   $0x8010943f
80105ed0:	e8 33 a7 ff ff       	call   80100608 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed8:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105edc:	66 83 f8 01          	cmp    $0x1,%ax
80105ee0:	75 25                	jne    80105f07 <sys_unlink+0x11b>
80105ee2:	83 ec 0c             	sub    $0xc,%esp
80105ee5:	ff 75 f0             	pushl  -0x10(%ebp)
80105ee8:	e8 98 fe ff ff       	call   80105d85 <isdirempty>
80105eed:	83 c4 10             	add    $0x10,%esp
80105ef0:	85 c0                	test   %eax,%eax
80105ef2:	75 13                	jne    80105f07 <sys_unlink+0x11b>
    iunlockput(ip);
80105ef4:	83 ec 0c             	sub    $0xc,%esp
80105ef7:	ff 75 f0             	pushl  -0x10(%ebp)
80105efa:	e8 19 be ff ff       	call   80101d18 <iunlockput>
80105eff:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105f02:	e9 b5 00 00 00       	jmp    80105fbc <sys_unlink+0x1d0>
  }

  memset(&de, 0, sizeof(de));
80105f07:	83 ec 04             	sub    $0x4,%esp
80105f0a:	6a 10                	push   $0x10
80105f0c:	6a 00                	push   $0x0
80105f0e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f11:	50                   	push   %eax
80105f12:	e8 6e f5 ff ff       	call   80105485 <memset>
80105f17:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f1a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105f1d:	6a 10                	push   $0x10
80105f1f:	50                   	push   %eax
80105f20:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f23:	50                   	push   %eax
80105f24:	ff 75 f4             	pushl  -0xc(%ebp)
80105f27:	e8 10 c2 ff ff       	call   8010213c <writei>
80105f2c:	83 c4 10             	add    $0x10,%esp
80105f2f:	83 f8 10             	cmp    $0x10,%eax
80105f32:	74 0d                	je     80105f41 <sys_unlink+0x155>
    panic("unlink: writei");
80105f34:	83 ec 0c             	sub    $0xc,%esp
80105f37:	68 51 94 10 80       	push   $0x80109451
80105f3c:	e8 c7 a6 ff ff       	call   80100608 <panic>
  if(ip->type == T_DIR){
80105f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f44:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105f48:	66 83 f8 01          	cmp    $0x1,%ax
80105f4c:	75 21                	jne    80105f6f <sys_unlink+0x183>
    dp->nlink--;
80105f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f51:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105f55:	83 e8 01             	sub    $0x1,%eax
80105f58:	89 c2                	mov    %eax,%edx
80105f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f5d:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105f61:	83 ec 0c             	sub    $0xc,%esp
80105f64:	ff 75 f4             	pushl  -0xc(%ebp)
80105f67:	e8 86 b9 ff ff       	call   801018f2 <iupdate>
80105f6c:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105f6f:	83 ec 0c             	sub    $0xc,%esp
80105f72:	ff 75 f4             	pushl  -0xc(%ebp)
80105f75:	e8 9e bd ff ff       	call   80101d18 <iunlockput>
80105f7a:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f80:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105f84:	83 e8 01             	sub    $0x1,%eax
80105f87:	89 c2                	mov    %eax,%edx
80105f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f8c:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105f90:	83 ec 0c             	sub    $0xc,%esp
80105f93:	ff 75 f0             	pushl  -0x10(%ebp)
80105f96:	e8 57 b9 ff ff       	call   801018f2 <iupdate>
80105f9b:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105f9e:	83 ec 0c             	sub    $0xc,%esp
80105fa1:	ff 75 f0             	pushl  -0x10(%ebp)
80105fa4:	e8 6f bd ff ff       	call   80101d18 <iunlockput>
80105fa9:	83 c4 10             	add    $0x10,%esp

  end_op();
80105fac:	e8 af d7 ff ff       	call   80103760 <end_op>

  return 0;
80105fb1:	b8 00 00 00 00       	mov    $0x0,%eax
80105fb6:	eb 1c                	jmp    80105fd4 <sys_unlink+0x1e8>
    goto bad;
80105fb8:	90                   	nop
80105fb9:	eb 01                	jmp    80105fbc <sys_unlink+0x1d0>
    goto bad;
80105fbb:	90                   	nop

bad:
  iunlockput(dp);
80105fbc:	83 ec 0c             	sub    $0xc,%esp
80105fbf:	ff 75 f4             	pushl  -0xc(%ebp)
80105fc2:	e8 51 bd ff ff       	call   80101d18 <iunlockput>
80105fc7:	83 c4 10             	add    $0x10,%esp
  end_op();
80105fca:	e8 91 d7 ff ff       	call   80103760 <end_op>
  return -1;
80105fcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fd4:	c9                   	leave  
80105fd5:	c3                   	ret    

80105fd6 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105fd6:	f3 0f 1e fb          	endbr32 
80105fda:	55                   	push   %ebp
80105fdb:	89 e5                	mov    %esp,%ebp
80105fdd:	83 ec 38             	sub    $0x38,%esp
80105fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105fe3:	8b 55 10             	mov    0x10(%ebp),%edx
80105fe6:	8b 45 14             	mov    0x14(%ebp),%eax
80105fe9:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105fed:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105ff1:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105ff5:	83 ec 08             	sub    $0x8,%esp
80105ff8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105ffb:	50                   	push   %eax
80105ffc:	ff 75 08             	pushl  0x8(%ebp)
80105fff:	e8 62 c6 ff ff       	call   80102666 <nameiparent>
80106004:	83 c4 10             	add    $0x10,%esp
80106007:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010600a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010600e:	75 0a                	jne    8010601a <create+0x44>
    return 0;
80106010:	b8 00 00 00 00       	mov    $0x0,%eax
80106015:	e9 8e 01 00 00       	jmp    801061a8 <create+0x1d2>
  ilock(dp);
8010601a:	83 ec 0c             	sub    $0xc,%esp
8010601d:	ff 75 f4             	pushl  -0xc(%ebp)
80106020:	e8 b6 ba ff ff       	call   80101adb <ilock>
80106025:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
80106028:	83 ec 04             	sub    $0x4,%esp
8010602b:	6a 00                	push   $0x0
8010602d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106030:	50                   	push   %eax
80106031:	ff 75 f4             	pushl  -0xc(%ebp)
80106034:	e8 ac c2 ff ff       	call   801022e5 <dirlookup>
80106039:	83 c4 10             	add    $0x10,%esp
8010603c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010603f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106043:	74 50                	je     80106095 <create+0xbf>
    iunlockput(dp);
80106045:	83 ec 0c             	sub    $0xc,%esp
80106048:	ff 75 f4             	pushl  -0xc(%ebp)
8010604b:	e8 c8 bc ff ff       	call   80101d18 <iunlockput>
80106050:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106053:	83 ec 0c             	sub    $0xc,%esp
80106056:	ff 75 f0             	pushl  -0x10(%ebp)
80106059:	e8 7d ba ff ff       	call   80101adb <ilock>
8010605e:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106061:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106066:	75 15                	jne    8010607d <create+0xa7>
80106068:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010606b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010606f:	66 83 f8 02          	cmp    $0x2,%ax
80106073:	75 08                	jne    8010607d <create+0xa7>
      return ip;
80106075:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106078:	e9 2b 01 00 00       	jmp    801061a8 <create+0x1d2>
    iunlockput(ip);
8010607d:	83 ec 0c             	sub    $0xc,%esp
80106080:	ff 75 f0             	pushl  -0x10(%ebp)
80106083:	e8 90 bc ff ff       	call   80101d18 <iunlockput>
80106088:	83 c4 10             	add    $0x10,%esp
    return 0;
8010608b:	b8 00 00 00 00       	mov    $0x0,%eax
80106090:	e9 13 01 00 00       	jmp    801061a8 <create+0x1d2>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106095:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609c:	8b 00                	mov    (%eax),%eax
8010609e:	83 ec 08             	sub    $0x8,%esp
801060a1:	52                   	push   %edx
801060a2:	50                   	push   %eax
801060a3:	e8 6f b7 ff ff       	call   80101817 <ialloc>
801060a8:	83 c4 10             	add    $0x10,%esp
801060ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060b2:	75 0d                	jne    801060c1 <create+0xeb>
    panic("create: ialloc");
801060b4:	83 ec 0c             	sub    $0xc,%esp
801060b7:	68 60 94 10 80       	push   $0x80109460
801060bc:	e8 47 a5 ff ff       	call   80100608 <panic>

  ilock(ip);
801060c1:	83 ec 0c             	sub    $0xc,%esp
801060c4:	ff 75 f0             	pushl  -0x10(%ebp)
801060c7:	e8 0f ba ff ff       	call   80101adb <ilock>
801060cc:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801060cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060d2:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801060d6:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801060da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060dd:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801060e1:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
801060e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060e8:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
801060ee:	83 ec 0c             	sub    $0xc,%esp
801060f1:	ff 75 f0             	pushl  -0x10(%ebp)
801060f4:	e8 f9 b7 ff ff       	call   801018f2 <iupdate>
801060f9:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801060fc:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106101:	75 6a                	jne    8010616d <create+0x197>
    dp->nlink++;  // for ".."
80106103:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106106:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010610a:	83 c0 01             	add    $0x1,%eax
8010610d:	89 c2                	mov    %eax,%edx
8010610f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106112:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106116:	83 ec 0c             	sub    $0xc,%esp
80106119:	ff 75 f4             	pushl  -0xc(%ebp)
8010611c:	e8 d1 b7 ff ff       	call   801018f2 <iupdate>
80106121:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106124:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106127:	8b 40 04             	mov    0x4(%eax),%eax
8010612a:	83 ec 04             	sub    $0x4,%esp
8010612d:	50                   	push   %eax
8010612e:	68 3a 94 10 80       	push   $0x8010943a
80106133:	ff 75 f0             	pushl  -0x10(%ebp)
80106136:	e8 68 c2 ff ff       	call   801023a3 <dirlink>
8010613b:	83 c4 10             	add    $0x10,%esp
8010613e:	85 c0                	test   %eax,%eax
80106140:	78 1e                	js     80106160 <create+0x18a>
80106142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106145:	8b 40 04             	mov    0x4(%eax),%eax
80106148:	83 ec 04             	sub    $0x4,%esp
8010614b:	50                   	push   %eax
8010614c:	68 3c 94 10 80       	push   $0x8010943c
80106151:	ff 75 f0             	pushl  -0x10(%ebp)
80106154:	e8 4a c2 ff ff       	call   801023a3 <dirlink>
80106159:	83 c4 10             	add    $0x10,%esp
8010615c:	85 c0                	test   %eax,%eax
8010615e:	79 0d                	jns    8010616d <create+0x197>
      panic("create dots");
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	68 6f 94 10 80       	push   $0x8010946f
80106168:	e8 9b a4 ff ff       	call   80100608 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010616d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106170:	8b 40 04             	mov    0x4(%eax),%eax
80106173:	83 ec 04             	sub    $0x4,%esp
80106176:	50                   	push   %eax
80106177:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010617a:	50                   	push   %eax
8010617b:	ff 75 f4             	pushl  -0xc(%ebp)
8010617e:	e8 20 c2 ff ff       	call   801023a3 <dirlink>
80106183:	83 c4 10             	add    $0x10,%esp
80106186:	85 c0                	test   %eax,%eax
80106188:	79 0d                	jns    80106197 <create+0x1c1>
    panic("create: dirlink");
8010618a:	83 ec 0c             	sub    $0xc,%esp
8010618d:	68 7b 94 10 80       	push   $0x8010947b
80106192:	e8 71 a4 ff ff       	call   80100608 <panic>

  iunlockput(dp);
80106197:	83 ec 0c             	sub    $0xc,%esp
8010619a:	ff 75 f4             	pushl  -0xc(%ebp)
8010619d:	e8 76 bb ff ff       	call   80101d18 <iunlockput>
801061a2:	83 c4 10             	add    $0x10,%esp

  return ip;
801061a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801061a8:	c9                   	leave  
801061a9:	c3                   	ret    

801061aa <sys_open>:

int
sys_open(void)
{
801061aa:	f3 0f 1e fb          	endbr32 
801061ae:	55                   	push   %ebp
801061af:	89 e5                	mov    %esp,%ebp
801061b1:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801061b4:	83 ec 08             	sub    $0x8,%esp
801061b7:	8d 45 e8             	lea    -0x18(%ebp),%eax
801061ba:	50                   	push   %eax
801061bb:	6a 00                	push   $0x0
801061bd:	e8 b4 f6 ff ff       	call   80105876 <argstr>
801061c2:	83 c4 10             	add    $0x10,%esp
801061c5:	85 c0                	test   %eax,%eax
801061c7:	78 15                	js     801061de <sys_open+0x34>
801061c9:	83 ec 08             	sub    $0x8,%esp
801061cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061cf:	50                   	push   %eax
801061d0:	6a 01                	push   $0x1
801061d2:	e8 02 f6 ff ff       	call   801057d9 <argint>
801061d7:	83 c4 10             	add    $0x10,%esp
801061da:	85 c0                	test   %eax,%eax
801061dc:	79 0a                	jns    801061e8 <sys_open+0x3e>
    return -1;
801061de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061e3:	e9 61 01 00 00       	jmp    80106349 <sys_open+0x19f>

  begin_op();
801061e8:	e8 e3 d4 ff ff       	call   801036d0 <begin_op>

  if(omode & O_CREATE){
801061ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061f0:	25 00 02 00 00       	and    $0x200,%eax
801061f5:	85 c0                	test   %eax,%eax
801061f7:	74 2a                	je     80106223 <sys_open+0x79>
    ip = create(path, T_FILE, 0, 0);
801061f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061fc:	6a 00                	push   $0x0
801061fe:	6a 00                	push   $0x0
80106200:	6a 02                	push   $0x2
80106202:	50                   	push   %eax
80106203:	e8 ce fd ff ff       	call   80105fd6 <create>
80106208:	83 c4 10             	add    $0x10,%esp
8010620b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010620e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106212:	75 75                	jne    80106289 <sys_open+0xdf>
      end_op();
80106214:	e8 47 d5 ff ff       	call   80103760 <end_op>
      return -1;
80106219:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010621e:	e9 26 01 00 00       	jmp    80106349 <sys_open+0x19f>
    }
  } else {
    if((ip = namei(path)) == 0){
80106223:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106226:	83 ec 0c             	sub    $0xc,%esp
80106229:	50                   	push   %eax
8010622a:	e8 17 c4 ff ff       	call   80102646 <namei>
8010622f:	83 c4 10             	add    $0x10,%esp
80106232:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106235:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106239:	75 0f                	jne    8010624a <sys_open+0xa0>
      end_op();
8010623b:	e8 20 d5 ff ff       	call   80103760 <end_op>
      return -1;
80106240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106245:	e9 ff 00 00 00       	jmp    80106349 <sys_open+0x19f>
    }
    ilock(ip);
8010624a:	83 ec 0c             	sub    $0xc,%esp
8010624d:	ff 75 f4             	pushl  -0xc(%ebp)
80106250:	e8 86 b8 ff ff       	call   80101adb <ilock>
80106255:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106258:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010625b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010625f:	66 83 f8 01          	cmp    $0x1,%ax
80106263:	75 24                	jne    80106289 <sys_open+0xdf>
80106265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106268:	85 c0                	test   %eax,%eax
8010626a:	74 1d                	je     80106289 <sys_open+0xdf>
      iunlockput(ip);
8010626c:	83 ec 0c             	sub    $0xc,%esp
8010626f:	ff 75 f4             	pushl  -0xc(%ebp)
80106272:	e8 a1 ba ff ff       	call   80101d18 <iunlockput>
80106277:	83 c4 10             	add    $0x10,%esp
      end_op();
8010627a:	e8 e1 d4 ff ff       	call   80103760 <end_op>
      return -1;
8010627f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106284:	e9 c0 00 00 00       	jmp    80106349 <sys_open+0x19f>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106289:	e8 07 ae ff ff       	call   80101095 <filealloc>
8010628e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106291:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106295:	74 17                	je     801062ae <sys_open+0x104>
80106297:	83 ec 0c             	sub    $0xc,%esp
8010629a:	ff 75 f0             	pushl  -0x10(%ebp)
8010629d:	e8 09 f7 ff ff       	call   801059ab <fdalloc>
801062a2:	83 c4 10             	add    $0x10,%esp
801062a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801062a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801062ac:	79 2e                	jns    801062dc <sys_open+0x132>
    if(f)
801062ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062b2:	74 0e                	je     801062c2 <sys_open+0x118>
      fileclose(f);
801062b4:	83 ec 0c             	sub    $0xc,%esp
801062b7:	ff 75 f0             	pushl  -0x10(%ebp)
801062ba:	e8 9c ae ff ff       	call   8010115b <fileclose>
801062bf:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801062c2:	83 ec 0c             	sub    $0xc,%esp
801062c5:	ff 75 f4             	pushl  -0xc(%ebp)
801062c8:	e8 4b ba ff ff       	call   80101d18 <iunlockput>
801062cd:	83 c4 10             	add    $0x10,%esp
    end_op();
801062d0:	e8 8b d4 ff ff       	call   80103760 <end_op>
    return -1;
801062d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062da:	eb 6d                	jmp    80106349 <sys_open+0x19f>
  }
  iunlock(ip);
801062dc:	83 ec 0c             	sub    $0xc,%esp
801062df:	ff 75 f4             	pushl  -0xc(%ebp)
801062e2:	e8 0b b9 ff ff       	call   80101bf2 <iunlock>
801062e7:	83 c4 10             	add    $0x10,%esp
  end_op();
801062ea:	e8 71 d4 ff ff       	call   80103760 <end_op>

  f->type = FD_INODE;
801062ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f2:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801062f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062fe:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106301:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106304:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010630b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010630e:	83 e0 01             	and    $0x1,%eax
80106311:	85 c0                	test   %eax,%eax
80106313:	0f 94 c0             	sete   %al
80106316:	89 c2                	mov    %eax,%edx
80106318:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010631b:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010631e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106321:	83 e0 01             	and    $0x1,%eax
80106324:	85 c0                	test   %eax,%eax
80106326:	75 0a                	jne    80106332 <sys_open+0x188>
80106328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010632b:	83 e0 02             	and    $0x2,%eax
8010632e:	85 c0                	test   %eax,%eax
80106330:	74 07                	je     80106339 <sys_open+0x18f>
80106332:	b8 01 00 00 00       	mov    $0x1,%eax
80106337:	eb 05                	jmp    8010633e <sys_open+0x194>
80106339:	b8 00 00 00 00       	mov    $0x0,%eax
8010633e:	89 c2                	mov    %eax,%edx
80106340:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106343:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106346:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106349:	c9                   	leave  
8010634a:	c3                   	ret    

8010634b <sys_mkdir>:

int
sys_mkdir(void)
{
8010634b:	f3 0f 1e fb          	endbr32 
8010634f:	55                   	push   %ebp
80106350:	89 e5                	mov    %esp,%ebp
80106352:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106355:	e8 76 d3 ff ff       	call   801036d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010635a:	83 ec 08             	sub    $0x8,%esp
8010635d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106360:	50                   	push   %eax
80106361:	6a 00                	push   $0x0
80106363:	e8 0e f5 ff ff       	call   80105876 <argstr>
80106368:	83 c4 10             	add    $0x10,%esp
8010636b:	85 c0                	test   %eax,%eax
8010636d:	78 1b                	js     8010638a <sys_mkdir+0x3f>
8010636f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106372:	6a 00                	push   $0x0
80106374:	6a 00                	push   $0x0
80106376:	6a 01                	push   $0x1
80106378:	50                   	push   %eax
80106379:	e8 58 fc ff ff       	call   80105fd6 <create>
8010637e:	83 c4 10             	add    $0x10,%esp
80106381:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106388:	75 0c                	jne    80106396 <sys_mkdir+0x4b>
    end_op();
8010638a:	e8 d1 d3 ff ff       	call   80103760 <end_op>
    return -1;
8010638f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106394:	eb 18                	jmp    801063ae <sys_mkdir+0x63>
  }
  iunlockput(ip);
80106396:	83 ec 0c             	sub    $0xc,%esp
80106399:	ff 75 f4             	pushl  -0xc(%ebp)
8010639c:	e8 77 b9 ff ff       	call   80101d18 <iunlockput>
801063a1:	83 c4 10             	add    $0x10,%esp
  end_op();
801063a4:	e8 b7 d3 ff ff       	call   80103760 <end_op>
  return 0;
801063a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063ae:	c9                   	leave  
801063af:	c3                   	ret    

801063b0 <sys_mknod>:

int
sys_mknod(void)
{
801063b0:	f3 0f 1e fb          	endbr32 
801063b4:	55                   	push   %ebp
801063b5:	89 e5                	mov    %esp,%ebp
801063b7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801063ba:	e8 11 d3 ff ff       	call   801036d0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801063bf:	83 ec 08             	sub    $0x8,%esp
801063c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063c5:	50                   	push   %eax
801063c6:	6a 00                	push   $0x0
801063c8:	e8 a9 f4 ff ff       	call   80105876 <argstr>
801063cd:	83 c4 10             	add    $0x10,%esp
801063d0:	85 c0                	test   %eax,%eax
801063d2:	78 4f                	js     80106423 <sys_mknod+0x73>
     argint(1, &major) < 0 ||
801063d4:	83 ec 08             	sub    $0x8,%esp
801063d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063da:	50                   	push   %eax
801063db:	6a 01                	push   $0x1
801063dd:	e8 f7 f3 ff ff       	call   801057d9 <argint>
801063e2:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
801063e5:	85 c0                	test   %eax,%eax
801063e7:	78 3a                	js     80106423 <sys_mknod+0x73>
     argint(2, &minor) < 0 ||
801063e9:	83 ec 08             	sub    $0x8,%esp
801063ec:	8d 45 e8             	lea    -0x18(%ebp),%eax
801063ef:	50                   	push   %eax
801063f0:	6a 02                	push   $0x2
801063f2:	e8 e2 f3 ff ff       	call   801057d9 <argint>
801063f7:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
801063fa:	85 c0                	test   %eax,%eax
801063fc:	78 25                	js     80106423 <sys_mknod+0x73>
     (ip = create(path, T_DEV, major, minor)) == 0){
801063fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106401:	0f bf c8             	movswl %ax,%ecx
80106404:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106407:	0f bf d0             	movswl %ax,%edx
8010640a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010640d:	51                   	push   %ecx
8010640e:	52                   	push   %edx
8010640f:	6a 03                	push   $0x3
80106411:	50                   	push   %eax
80106412:	e8 bf fb ff ff       	call   80105fd6 <create>
80106417:	83 c4 10             	add    $0x10,%esp
8010641a:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
8010641d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106421:	75 0c                	jne    8010642f <sys_mknod+0x7f>
    end_op();
80106423:	e8 38 d3 ff ff       	call   80103760 <end_op>
    return -1;
80106428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642d:	eb 18                	jmp    80106447 <sys_mknod+0x97>
  }
  iunlockput(ip);
8010642f:	83 ec 0c             	sub    $0xc,%esp
80106432:	ff 75 f4             	pushl  -0xc(%ebp)
80106435:	e8 de b8 ff ff       	call   80101d18 <iunlockput>
8010643a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010643d:	e8 1e d3 ff ff       	call   80103760 <end_op>
  return 0;
80106442:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106447:	c9                   	leave  
80106448:	c3                   	ret    

80106449 <sys_chdir>:

int
sys_chdir(void)
{
80106449:	f3 0f 1e fb          	endbr32 
8010644d:	55                   	push   %ebp
8010644e:	89 e5                	mov    %esp,%ebp
80106450:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106453:	e8 37 e0 ff ff       	call   8010448f <myproc>
80106458:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
8010645b:	e8 70 d2 ff ff       	call   801036d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106460:	83 ec 08             	sub    $0x8,%esp
80106463:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106466:	50                   	push   %eax
80106467:	6a 00                	push   $0x0
80106469:	e8 08 f4 ff ff       	call   80105876 <argstr>
8010646e:	83 c4 10             	add    $0x10,%esp
80106471:	85 c0                	test   %eax,%eax
80106473:	78 18                	js     8010648d <sys_chdir+0x44>
80106475:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106478:	83 ec 0c             	sub    $0xc,%esp
8010647b:	50                   	push   %eax
8010647c:	e8 c5 c1 ff ff       	call   80102646 <namei>
80106481:	83 c4 10             	add    $0x10,%esp
80106484:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106487:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010648b:	75 0c                	jne    80106499 <sys_chdir+0x50>
    end_op();
8010648d:	e8 ce d2 ff ff       	call   80103760 <end_op>
    return -1;
80106492:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106497:	eb 68                	jmp    80106501 <sys_chdir+0xb8>
  }
  ilock(ip);
80106499:	83 ec 0c             	sub    $0xc,%esp
8010649c:	ff 75 f0             	pushl  -0x10(%ebp)
8010649f:	e8 37 b6 ff ff       	call   80101adb <ilock>
801064a4:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801064a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064aa:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801064ae:	66 83 f8 01          	cmp    $0x1,%ax
801064b2:	74 1a                	je     801064ce <sys_chdir+0x85>
    iunlockput(ip);
801064b4:	83 ec 0c             	sub    $0xc,%esp
801064b7:	ff 75 f0             	pushl  -0x10(%ebp)
801064ba:	e8 59 b8 ff ff       	call   80101d18 <iunlockput>
801064bf:	83 c4 10             	add    $0x10,%esp
    end_op();
801064c2:	e8 99 d2 ff ff       	call   80103760 <end_op>
    return -1;
801064c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064cc:	eb 33                	jmp    80106501 <sys_chdir+0xb8>
  }
  iunlock(ip);
801064ce:	83 ec 0c             	sub    $0xc,%esp
801064d1:	ff 75 f0             	pushl  -0x10(%ebp)
801064d4:	e8 19 b7 ff ff       	call   80101bf2 <iunlock>
801064d9:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
801064dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064df:	8b 40 68             	mov    0x68(%eax),%eax
801064e2:	83 ec 0c             	sub    $0xc,%esp
801064e5:	50                   	push   %eax
801064e6:	e8 59 b7 ff ff       	call   80101c44 <iput>
801064eb:	83 c4 10             	add    $0x10,%esp
  end_op();
801064ee:	e8 6d d2 ff ff       	call   80103760 <end_op>
  curproc->cwd = ip;
801064f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801064f9:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801064fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106501:	c9                   	leave  
80106502:	c3                   	ret    

80106503 <sys_exec>:

int
sys_exec(void)
{
80106503:	f3 0f 1e fb          	endbr32 
80106507:	55                   	push   %ebp
80106508:	89 e5                	mov    %esp,%ebp
8010650a:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106510:	83 ec 08             	sub    $0x8,%esp
80106513:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106516:	50                   	push   %eax
80106517:	6a 00                	push   $0x0
80106519:	e8 58 f3 ff ff       	call   80105876 <argstr>
8010651e:	83 c4 10             	add    $0x10,%esp
80106521:	85 c0                	test   %eax,%eax
80106523:	78 18                	js     8010653d <sys_exec+0x3a>
80106525:	83 ec 08             	sub    $0x8,%esp
80106528:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010652e:	50                   	push   %eax
8010652f:	6a 01                	push   $0x1
80106531:	e8 a3 f2 ff ff       	call   801057d9 <argint>
80106536:	83 c4 10             	add    $0x10,%esp
80106539:	85 c0                	test   %eax,%eax
8010653b:	79 0a                	jns    80106547 <sys_exec+0x44>
    return -1;
8010653d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106542:	e9 c6 00 00 00       	jmp    8010660d <sys_exec+0x10a>
  }
  memset(argv, 0, sizeof(argv));
80106547:	83 ec 04             	sub    $0x4,%esp
8010654a:	68 80 00 00 00       	push   $0x80
8010654f:	6a 00                	push   $0x0
80106551:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106557:	50                   	push   %eax
80106558:	e8 28 ef ff ff       	call   80105485 <memset>
8010655d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106560:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010656a:	83 f8 1f             	cmp    $0x1f,%eax
8010656d:	76 0a                	jbe    80106579 <sys_exec+0x76>
      return -1;
8010656f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106574:	e9 94 00 00 00       	jmp    8010660d <sys_exec+0x10a>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106579:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010657c:	c1 e0 02             	shl    $0x2,%eax
8010657f:	89 c2                	mov    %eax,%edx
80106581:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106587:	01 c2                	add    %eax,%edx
80106589:	83 ec 08             	sub    $0x8,%esp
8010658c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106592:	50                   	push   %eax
80106593:	52                   	push   %edx
80106594:	e8 95 f1 ff ff       	call   8010572e <fetchint>
80106599:	83 c4 10             	add    $0x10,%esp
8010659c:	85 c0                	test   %eax,%eax
8010659e:	79 07                	jns    801065a7 <sys_exec+0xa4>
      return -1;
801065a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a5:	eb 66                	jmp    8010660d <sys_exec+0x10a>
    if(uarg == 0){
801065a7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801065ad:	85 c0                	test   %eax,%eax
801065af:	75 27                	jne    801065d8 <sys_exec+0xd5>
      argv[i] = 0;
801065b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b4:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801065bb:	00 00 00 00 
      break;
801065bf:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801065c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065c3:	83 ec 08             	sub    $0x8,%esp
801065c6:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801065cc:	52                   	push   %edx
801065cd:	50                   	push   %eax
801065ce:	e8 5d a6 ff ff       	call   80100c30 <exec>
801065d3:	83 c4 10             	add    $0x10,%esp
801065d6:	eb 35                	jmp    8010660d <sys_exec+0x10a>
    if(fetchstr(uarg, &argv[i]) < 0)
801065d8:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801065de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065e1:	c1 e2 02             	shl    $0x2,%edx
801065e4:	01 c2                	add    %eax,%edx
801065e6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801065ec:	83 ec 08             	sub    $0x8,%esp
801065ef:	52                   	push   %edx
801065f0:	50                   	push   %eax
801065f1:	e8 7b f1 ff ff       	call   80105771 <fetchstr>
801065f6:	83 c4 10             	add    $0x10,%esp
801065f9:	85 c0                	test   %eax,%eax
801065fb:	79 07                	jns    80106604 <sys_exec+0x101>
      return -1;
801065fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106602:	eb 09                	jmp    8010660d <sys_exec+0x10a>
  for(i=0;; i++){
80106604:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80106608:	e9 5a ff ff ff       	jmp    80106567 <sys_exec+0x64>
}
8010660d:	c9                   	leave  
8010660e:	c3                   	ret    

8010660f <sys_pipe>:

int
sys_pipe(void)
{
8010660f:	f3 0f 1e fb          	endbr32 
80106613:	55                   	push   %ebp
80106614:	89 e5                	mov    %esp,%ebp
80106616:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106619:	83 ec 04             	sub    $0x4,%esp
8010661c:	6a 08                	push   $0x8
8010661e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106621:	50                   	push   %eax
80106622:	6a 00                	push   $0x0
80106624:	e8 e1 f1 ff ff       	call   8010580a <argptr>
80106629:	83 c4 10             	add    $0x10,%esp
8010662c:	85 c0                	test   %eax,%eax
8010662e:	79 0a                	jns    8010663a <sys_pipe+0x2b>
    return -1;
80106630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106635:	e9 ae 00 00 00       	jmp    801066e8 <sys_pipe+0xd9>
  if(pipealloc(&rf, &wf) < 0)
8010663a:	83 ec 08             	sub    $0x8,%esp
8010663d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106640:	50                   	push   %eax
80106641:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106644:	50                   	push   %eax
80106645:	e8 66 d9 ff ff       	call   80103fb0 <pipealloc>
8010664a:	83 c4 10             	add    $0x10,%esp
8010664d:	85 c0                	test   %eax,%eax
8010664f:	79 0a                	jns    8010665b <sys_pipe+0x4c>
    return -1;
80106651:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106656:	e9 8d 00 00 00       	jmp    801066e8 <sys_pipe+0xd9>
  fd0 = -1;
8010665b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106662:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106665:	83 ec 0c             	sub    $0xc,%esp
80106668:	50                   	push   %eax
80106669:	e8 3d f3 ff ff       	call   801059ab <fdalloc>
8010666e:	83 c4 10             	add    $0x10,%esp
80106671:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106678:	78 18                	js     80106692 <sys_pipe+0x83>
8010667a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010667d:	83 ec 0c             	sub    $0xc,%esp
80106680:	50                   	push   %eax
80106681:	e8 25 f3 ff ff       	call   801059ab <fdalloc>
80106686:	83 c4 10             	add    $0x10,%esp
80106689:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010668c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106690:	79 3e                	jns    801066d0 <sys_pipe+0xc1>
    if(fd0 >= 0)
80106692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106696:	78 13                	js     801066ab <sys_pipe+0x9c>
      myproc()->ofile[fd0] = 0;
80106698:	e8 f2 dd ff ff       	call   8010448f <myproc>
8010669d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066a0:	83 c2 08             	add    $0x8,%edx
801066a3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801066aa:	00 
    fileclose(rf);
801066ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066ae:	83 ec 0c             	sub    $0xc,%esp
801066b1:	50                   	push   %eax
801066b2:	e8 a4 aa ff ff       	call   8010115b <fileclose>
801066b7:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801066ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066bd:	83 ec 0c             	sub    $0xc,%esp
801066c0:	50                   	push   %eax
801066c1:	e8 95 aa ff ff       	call   8010115b <fileclose>
801066c6:	83 c4 10             	add    $0x10,%esp
    return -1;
801066c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ce:	eb 18                	jmp    801066e8 <sys_pipe+0xd9>
  }
  fd[0] = fd0;
801066d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801066d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066d6:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801066d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801066db:	8d 50 04             	lea    0x4(%eax),%edx
801066de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066e1:	89 02                	mov    %eax,(%edx)
  return 0;
801066e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066e8:	c9                   	leave  
801066e9:	c3                   	ret    

801066ea <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801066ea:	f3 0f 1e fb          	endbr32 
801066ee:	55                   	push   %ebp
801066ef:	89 e5                	mov    %esp,%ebp
801066f1:	83 ec 08             	sub    $0x8,%esp
  return fork();
801066f4:	e8 ac e0 ff ff       	call   801047a5 <fork>
}
801066f9:	c9                   	leave  
801066fa:	c3                   	ret    

801066fb <sys_exit>:

int
sys_exit(void)
{
801066fb:	f3 0f 1e fb          	endbr32 
801066ff:	55                   	push   %ebp
80106700:	89 e5                	mov    %esp,%ebp
80106702:	83 ec 08             	sub    $0x8,%esp
  exit();
80106705:	e8 18 e2 ff ff       	call   80104922 <exit>
  return 0;  // not reached
8010670a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010670f:	c9                   	leave  
80106710:	c3                   	ret    

80106711 <sys_wait>:

int
sys_wait(void)
{
80106711:	f3 0f 1e fb          	endbr32 
80106715:	55                   	push   %ebp
80106716:	89 e5                	mov    %esp,%ebp
80106718:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010671b:	e8 29 e3 ff ff       	call   80104a49 <wait>
}
80106720:	c9                   	leave  
80106721:	c3                   	ret    

80106722 <sys_kill>:

int
sys_kill(void)
{
80106722:	f3 0f 1e fb          	endbr32 
80106726:	55                   	push   %ebp
80106727:	89 e5                	mov    %esp,%ebp
80106729:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010672c:	83 ec 08             	sub    $0x8,%esp
8010672f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106732:	50                   	push   %eax
80106733:	6a 00                	push   $0x0
80106735:	e8 9f f0 ff ff       	call   801057d9 <argint>
8010673a:	83 c4 10             	add    $0x10,%esp
8010673d:	85 c0                	test   %eax,%eax
8010673f:	79 07                	jns    80106748 <sys_kill+0x26>
    return -1;
80106741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106746:	eb 0f                	jmp    80106757 <sys_kill+0x35>
  return kill(pid);
80106748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010674b:	83 ec 0c             	sub    $0xc,%esp
8010674e:	50                   	push   %eax
8010674f:	e8 4d e7 ff ff       	call   80104ea1 <kill>
80106754:	83 c4 10             	add    $0x10,%esp
}
80106757:	c9                   	leave  
80106758:	c3                   	ret    

80106759 <sys_getpid>:

int
sys_getpid(void)
{
80106759:	f3 0f 1e fb          	endbr32 
8010675d:	55                   	push   %ebp
8010675e:	89 e5                	mov    %esp,%ebp
80106760:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106763:	e8 27 dd ff ff       	call   8010448f <myproc>
80106768:	8b 40 10             	mov    0x10(%eax),%eax
}
8010676b:	c9                   	leave  
8010676c:	c3                   	ret    

8010676d <sys_sbrk>:

int
sys_sbrk(void)
{
8010676d:	f3 0f 1e fb          	endbr32 
80106771:	55                   	push   %ebp
80106772:	89 e5                	mov    %esp,%ebp
80106774:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106777:	83 ec 08             	sub    $0x8,%esp
8010677a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010677d:	50                   	push   %eax
8010677e:	6a 00                	push   $0x0
80106780:	e8 54 f0 ff ff       	call   801057d9 <argint>
80106785:	83 c4 10             	add    $0x10,%esp
80106788:	85 c0                	test   %eax,%eax
8010678a:	79 07                	jns    80106793 <sys_sbrk+0x26>
    return -1;
8010678c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106791:	eb 27                	jmp    801067ba <sys_sbrk+0x4d>
  addr = myproc()->sz;
80106793:	e8 f7 dc ff ff       	call   8010448f <myproc>
80106798:	8b 00                	mov    (%eax),%eax
8010679a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010679d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067a0:	83 ec 0c             	sub    $0xc,%esp
801067a3:	50                   	push   %eax
801067a4:	e8 5d df ff ff       	call   80104706 <growproc>
801067a9:	83 c4 10             	add    $0x10,%esp
801067ac:	85 c0                	test   %eax,%eax
801067ae:	79 07                	jns    801067b7 <sys_sbrk+0x4a>
    return -1;
801067b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067b5:	eb 03                	jmp    801067ba <sys_sbrk+0x4d>
  return addr;
801067b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801067ba:	c9                   	leave  
801067bb:	c3                   	ret    

801067bc <sys_sleep>:

int
sys_sleep(void)
{
801067bc:	f3 0f 1e fb          	endbr32 
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801067c6:	83 ec 08             	sub    $0x8,%esp
801067c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067cc:	50                   	push   %eax
801067cd:	6a 00                	push   $0x0
801067cf:	e8 05 f0 ff ff       	call   801057d9 <argint>
801067d4:	83 c4 10             	add    $0x10,%esp
801067d7:	85 c0                	test   %eax,%eax
801067d9:	79 07                	jns    801067e2 <sys_sleep+0x26>
    return -1;
801067db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067e0:	eb 76                	jmp    80106858 <sys_sleep+0x9c>
  acquire(&tickslock);
801067e2:	83 ec 0c             	sub    $0xc,%esp
801067e5:	68 00 71 11 80       	push   $0x80117100
801067ea:	e8 f7 e9 ff ff       	call   801051e6 <acquire>
801067ef:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801067f2:	a1 40 79 11 80       	mov    0x80117940,%eax
801067f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801067fa:	eb 38                	jmp    80106834 <sys_sleep+0x78>
    if(myproc()->killed){
801067fc:	e8 8e dc ff ff       	call   8010448f <myproc>
80106801:	8b 40 24             	mov    0x24(%eax),%eax
80106804:	85 c0                	test   %eax,%eax
80106806:	74 17                	je     8010681f <sys_sleep+0x63>
      release(&tickslock);
80106808:	83 ec 0c             	sub    $0xc,%esp
8010680b:	68 00 71 11 80       	push   $0x80117100
80106810:	e8 43 ea ff ff       	call   80105258 <release>
80106815:	83 c4 10             	add    $0x10,%esp
      return -1;
80106818:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010681d:	eb 39                	jmp    80106858 <sys_sleep+0x9c>
    }
    sleep(&ticks, &tickslock);
8010681f:	83 ec 08             	sub    $0x8,%esp
80106822:	68 00 71 11 80       	push   $0x80117100
80106827:	68 40 79 11 80       	push   $0x80117940
8010682c:	e8 43 e5 ff ff       	call   80104d74 <sleep>
80106831:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106834:	a1 40 79 11 80       	mov    0x80117940,%eax
80106839:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010683c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010683f:	39 d0                	cmp    %edx,%eax
80106841:	72 b9                	jb     801067fc <sys_sleep+0x40>
  }
  release(&tickslock);
80106843:	83 ec 0c             	sub    $0xc,%esp
80106846:	68 00 71 11 80       	push   $0x80117100
8010684b:	e8 08 ea ff ff       	call   80105258 <release>
80106850:	83 c4 10             	add    $0x10,%esp
  return 0;
80106853:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106858:	c9                   	leave  
80106859:	c3                   	ret    

8010685a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010685a:	f3 0f 1e fb          	endbr32 
8010685e:	55                   	push   %ebp
8010685f:	89 e5                	mov    %esp,%ebp
80106861:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106864:	83 ec 0c             	sub    $0xc,%esp
80106867:	68 00 71 11 80       	push   $0x80117100
8010686c:	e8 75 e9 ff ff       	call   801051e6 <acquire>
80106871:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106874:	a1 40 79 11 80       	mov    0x80117940,%eax
80106879:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010687c:	83 ec 0c             	sub    $0xc,%esp
8010687f:	68 00 71 11 80       	push   $0x80117100
80106884:	e8 cf e9 ff ff       	call   80105258 <release>
80106889:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010688c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010688f:	c9                   	leave  
80106890:	c3                   	ret    

80106891 <sys_mencrypt>:

//changed: added wrapper here
int sys_mencrypt(void) {
80106891:	f3 0f 1e fb          	endbr32 
80106895:	55                   	push   %ebp
80106896:	89 e5                	mov    %esp,%ebp
80106898:	83 ec 18             	sub    $0x18,%esp
  int len;
  char * virtual_addr;

  if(argint(1, &len) < 0)
8010689b:	83 ec 08             	sub    $0x8,%esp
8010689e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068a1:	50                   	push   %eax
801068a2:	6a 01                	push   $0x1
801068a4:	e8 30 ef ff ff       	call   801057d9 <argint>
801068a9:	83 c4 10             	add    $0x10,%esp
801068ac:	85 c0                	test   %eax,%eax
801068ae:	79 07                	jns    801068b7 <sys_mencrypt+0x26>
    return -1;
801068b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b5:	eb 50                	jmp    80106907 <sys_mencrypt+0x76>
  if (len <= 0) {
801068b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ba:	85 c0                	test   %eax,%eax
801068bc:	7f 07                	jg     801068c5 <sys_mencrypt+0x34>
    return -1;
801068be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c3:	eb 42                	jmp    80106907 <sys_mencrypt+0x76>
  }
  if(argptr(0, &virtual_addr, 1) < 0)
801068c5:	83 ec 04             	sub    $0x4,%esp
801068c8:	6a 01                	push   $0x1
801068ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068cd:	50                   	push   %eax
801068ce:	6a 00                	push   $0x0
801068d0:	e8 35 ef ff ff       	call   8010580a <argptr>
801068d5:	83 c4 10             	add    $0x10,%esp
801068d8:	85 c0                	test   %eax,%eax
801068da:	79 07                	jns    801068e3 <sys_mencrypt+0x52>
    return -1;
801068dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068e1:	eb 24                	jmp    80106907 <sys_mencrypt+0x76>
  if ((void *) virtual_addr >= P2V(PHYSTOP)) {
801068e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068e6:	3d ff ff ff 8d       	cmp    $0x8dffffff,%eax
801068eb:	76 07                	jbe    801068f4 <sys_mencrypt+0x63>
    return -1;
801068ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068f2:	eb 13                	jmp    80106907 <sys_mencrypt+0x76>
  }
  return mencrypt(virtual_addr, len);
801068f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068fa:	83 ec 08             	sub    $0x8,%esp
801068fd:	52                   	push   %edx
801068fe:	50                   	push   %eax
801068ff:	e8 c1 21 00 00       	call   80108ac5 <mencrypt>
80106904:	83 c4 10             	add    $0x10,%esp
}
80106907:	c9                   	leave  
80106908:	c3                   	ret    

80106909 <sys_getpgtable>:

int sys_getpgtable(void) {
80106909:	f3 0f 1e fb          	endbr32 
8010690d:	55                   	push   %ebp
8010690e:	89 e5                	mov    %esp,%ebp
80106910:	83 ec 18             	sub    $0x18,%esp
  struct pt_entry * entries; 
  int num, wsetOnly;

  if(argint(2, &wsetOnly) < 0)
80106913:	83 ec 08             	sub    $0x8,%esp
80106916:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106919:	50                   	push   %eax
8010691a:	6a 02                	push   $0x2
8010691c:	e8 b8 ee ff ff       	call   801057d9 <argint>
80106921:	83 c4 10             	add    $0x10,%esp
80106924:	85 c0                	test   %eax,%eax
80106926:	79 07                	jns    8010692f <sys_getpgtable+0x26>
    return -1;
80106928:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010692d:	eb 56                	jmp    80106985 <sys_getpgtable+0x7c>
  if(argint(1, &num) < 0)
8010692f:	83 ec 08             	sub    $0x8,%esp
80106932:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106935:	50                   	push   %eax
80106936:	6a 01                	push   $0x1
80106938:	e8 9c ee ff ff       	call   801057d9 <argint>
8010693d:	83 c4 10             	add    $0x10,%esp
80106940:	85 c0                	test   %eax,%eax
80106942:	79 07                	jns    8010694b <sys_getpgtable+0x42>
    return -1;
80106944:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106949:	eb 3a                	jmp    80106985 <sys_getpgtable+0x7c>
  if(argptr(0, (char**)&entries, num*sizeof(struct pt_entry)) < 0){
8010694b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010694e:	c1 e0 03             	shl    $0x3,%eax
80106951:	83 ec 04             	sub    $0x4,%esp
80106954:	50                   	push   %eax
80106955:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106958:	50                   	push   %eax
80106959:	6a 00                	push   $0x0
8010695b:	e8 aa ee ff ff       	call   8010580a <argptr>
80106960:	83 c4 10             	add    $0x10,%esp
80106963:	85 c0                	test   %eax,%eax
80106965:	79 07                	jns    8010696e <sys_getpgtable+0x65>
    return -1;
80106967:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010696c:	eb 17                	jmp    80106985 <sys_getpgtable+0x7c>
  }
  return getpgtable(entries, num, wsetOnly);
8010696e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106971:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106977:	83 ec 04             	sub    $0x4,%esp
8010697a:	51                   	push   %ecx
8010697b:	52                   	push   %edx
8010697c:	50                   	push   %eax
8010697d:	e8 19 23 00 00       	call   80108c9b <getpgtable>
80106982:	83 c4 10             	add    $0x10,%esp
}
80106985:	c9                   	leave  
80106986:	c3                   	ret    

80106987 <sys_dump_rawphymem>:


int sys_dump_rawphymem(void) {
80106987:	f3 0f 1e fb          	endbr32 
8010698b:	55                   	push   %ebp
8010698c:	89 e5                	mov    %esp,%ebp
8010698e:	83 ec 18             	sub    $0x18,%esp
  char * physical_addr; 
  char * buffer;

  if(argptr(1, &buffer, PGSIZE) < 0)
80106991:	83 ec 04             	sub    $0x4,%esp
80106994:	68 00 10 00 00       	push   $0x1000
80106999:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010699c:	50                   	push   %eax
8010699d:	6a 01                	push   $0x1
8010699f:	e8 66 ee ff ff       	call   8010580a <argptr>
801069a4:	83 c4 10             	add    $0x10,%esp
801069a7:	85 c0                	test   %eax,%eax
801069a9:	79 07                	jns    801069b2 <sys_dump_rawphymem+0x2b>
    return -1;
801069ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069b0:	eb 2f                	jmp    801069e1 <sys_dump_rawphymem+0x5a>
  if(argint(0, (int*)&physical_addr) < 0)
801069b2:	83 ec 08             	sub    $0x8,%esp
801069b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069b8:	50                   	push   %eax
801069b9:	6a 00                	push   $0x0
801069bb:	e8 19 ee ff ff       	call   801057d9 <argint>
801069c0:	83 c4 10             	add    $0x10,%esp
801069c3:	85 c0                	test   %eax,%eax
801069c5:	79 07                	jns    801069ce <sys_dump_rawphymem+0x47>
    return -1;
801069c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069cc:	eb 13                	jmp    801069e1 <sys_dump_rawphymem+0x5a>
  return dump_rawphymem(physical_addr, buffer);
801069ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
801069d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069d4:	83 ec 08             	sub    $0x8,%esp
801069d7:	52                   	push   %edx
801069d8:	50                   	push   %eax
801069d9:	e8 dd 24 00 00       	call   80108ebb <dump_rawphymem>
801069de:	83 c4 10             	add    $0x10,%esp
}
801069e1:	c9                   	leave  
801069e2:	c3                   	ret    

801069e3 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801069e3:	1e                   	push   %ds
  pushl %es
801069e4:	06                   	push   %es
  pushl %fs
801069e5:	0f a0                	push   %fs
  pushl %gs
801069e7:	0f a8                	push   %gs
  pushal
801069e9:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801069ea:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801069ee:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801069f0:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801069f2:	54                   	push   %esp
  call trap
801069f3:	e8 df 01 00 00       	call   80106bd7 <trap>
  addl $4, %esp
801069f8:	83 c4 04             	add    $0x4,%esp

801069fb <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801069fb:	61                   	popa   
  popl %gs
801069fc:	0f a9                	pop    %gs
  popl %fs
801069fe:	0f a1                	pop    %fs
  popl %es
80106a00:	07                   	pop    %es
  popl %ds
80106a01:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106a02:	83 c4 08             	add    $0x8,%esp
  iret
80106a05:	cf                   	iret   

80106a06 <lidt>:
{
80106a06:	55                   	push   %ebp
80106a07:	89 e5                	mov    %esp,%ebp
80106a09:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a0f:	83 e8 01             	sub    $0x1,%eax
80106a12:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a16:	8b 45 08             	mov    0x8(%ebp),%eax
80106a19:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a1d:	8b 45 08             	mov    0x8(%ebp),%eax
80106a20:	c1 e8 10             	shr    $0x10,%eax
80106a23:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106a27:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a2a:	0f 01 18             	lidtl  (%eax)
}
80106a2d:	90                   	nop
80106a2e:	c9                   	leave  
80106a2f:	c3                   	ret    

80106a30 <rcr2>:

static inline uint
rcr2(void)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106a36:	0f 20 d0             	mov    %cr2,%eax
80106a39:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106a3f:	c9                   	leave  
80106a40:	c3                   	ret    

80106a41 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106a41:	f3 0f 1e fb          	endbr32 
80106a45:	55                   	push   %ebp
80106a46:	89 e5                	mov    %esp,%ebp
80106a48:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106a4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106a52:	e9 c3 00 00 00       	jmp    80106b1a <tvinit+0xd9>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a5a:	8b 04 85 84 c0 10 80 	mov    -0x7fef3f7c(,%eax,4),%eax
80106a61:	89 c2                	mov    %eax,%edx
80106a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a66:	66 89 14 c5 40 71 11 	mov    %dx,-0x7fee8ec0(,%eax,8)
80106a6d:	80 
80106a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a71:	66 c7 04 c5 42 71 11 	movw   $0x8,-0x7fee8ebe(,%eax,8)
80106a78:	80 08 00 
80106a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a7e:	0f b6 14 c5 44 71 11 	movzbl -0x7fee8ebc(,%eax,8),%edx
80106a85:	80 
80106a86:	83 e2 e0             	and    $0xffffffe0,%edx
80106a89:	88 14 c5 44 71 11 80 	mov    %dl,-0x7fee8ebc(,%eax,8)
80106a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a93:	0f b6 14 c5 44 71 11 	movzbl -0x7fee8ebc(,%eax,8),%edx
80106a9a:	80 
80106a9b:	83 e2 1f             	and    $0x1f,%edx
80106a9e:	88 14 c5 44 71 11 80 	mov    %dl,-0x7fee8ebc(,%eax,8)
80106aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aa8:	0f b6 14 c5 45 71 11 	movzbl -0x7fee8ebb(,%eax,8),%edx
80106aaf:	80 
80106ab0:	83 e2 f0             	and    $0xfffffff0,%edx
80106ab3:	83 ca 0e             	or     $0xe,%edx
80106ab6:	88 14 c5 45 71 11 80 	mov    %dl,-0x7fee8ebb(,%eax,8)
80106abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ac0:	0f b6 14 c5 45 71 11 	movzbl -0x7fee8ebb(,%eax,8),%edx
80106ac7:	80 
80106ac8:	83 e2 ef             	and    $0xffffffef,%edx
80106acb:	88 14 c5 45 71 11 80 	mov    %dl,-0x7fee8ebb(,%eax,8)
80106ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ad5:	0f b6 14 c5 45 71 11 	movzbl -0x7fee8ebb(,%eax,8),%edx
80106adc:	80 
80106add:	83 e2 9f             	and    $0xffffff9f,%edx
80106ae0:	88 14 c5 45 71 11 80 	mov    %dl,-0x7fee8ebb(,%eax,8)
80106ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aea:	0f b6 14 c5 45 71 11 	movzbl -0x7fee8ebb(,%eax,8),%edx
80106af1:	80 
80106af2:	83 ca 80             	or     $0xffffff80,%edx
80106af5:	88 14 c5 45 71 11 80 	mov    %dl,-0x7fee8ebb(,%eax,8)
80106afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aff:	8b 04 85 84 c0 10 80 	mov    -0x7fef3f7c(,%eax,4),%eax
80106b06:	c1 e8 10             	shr    $0x10,%eax
80106b09:	89 c2                	mov    %eax,%edx
80106b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b0e:	66 89 14 c5 46 71 11 	mov    %dx,-0x7fee8eba(,%eax,8)
80106b15:	80 
  for(i = 0; i < 256; i++)
80106b16:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b1a:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106b21:	0f 8e 30 ff ff ff    	jle    80106a57 <tvinit+0x16>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106b27:	a1 84 c1 10 80       	mov    0x8010c184,%eax
80106b2c:	66 a3 40 73 11 80    	mov    %ax,0x80117340
80106b32:	66 c7 05 42 73 11 80 	movw   $0x8,0x80117342
80106b39:	08 00 
80106b3b:	0f b6 05 44 73 11 80 	movzbl 0x80117344,%eax
80106b42:	83 e0 e0             	and    $0xffffffe0,%eax
80106b45:	a2 44 73 11 80       	mov    %al,0x80117344
80106b4a:	0f b6 05 44 73 11 80 	movzbl 0x80117344,%eax
80106b51:	83 e0 1f             	and    $0x1f,%eax
80106b54:	a2 44 73 11 80       	mov    %al,0x80117344
80106b59:	0f b6 05 45 73 11 80 	movzbl 0x80117345,%eax
80106b60:	83 c8 0f             	or     $0xf,%eax
80106b63:	a2 45 73 11 80       	mov    %al,0x80117345
80106b68:	0f b6 05 45 73 11 80 	movzbl 0x80117345,%eax
80106b6f:	83 e0 ef             	and    $0xffffffef,%eax
80106b72:	a2 45 73 11 80       	mov    %al,0x80117345
80106b77:	0f b6 05 45 73 11 80 	movzbl 0x80117345,%eax
80106b7e:	83 c8 60             	or     $0x60,%eax
80106b81:	a2 45 73 11 80       	mov    %al,0x80117345
80106b86:	0f b6 05 45 73 11 80 	movzbl 0x80117345,%eax
80106b8d:	83 c8 80             	or     $0xffffff80,%eax
80106b90:	a2 45 73 11 80       	mov    %al,0x80117345
80106b95:	a1 84 c1 10 80       	mov    0x8010c184,%eax
80106b9a:	c1 e8 10             	shr    $0x10,%eax
80106b9d:	66 a3 46 73 11 80    	mov    %ax,0x80117346

  initlock(&tickslock, "time");
80106ba3:	83 ec 08             	sub    $0x8,%esp
80106ba6:	68 8c 94 10 80       	push   $0x8010948c
80106bab:	68 00 71 11 80       	push   $0x80117100
80106bb0:	e8 0b e6 ff ff       	call   801051c0 <initlock>
80106bb5:	83 c4 10             	add    $0x10,%esp
}
80106bb8:	90                   	nop
80106bb9:	c9                   	leave  
80106bba:	c3                   	ret    

80106bbb <idtinit>:

void
idtinit(void)
{
80106bbb:	f3 0f 1e fb          	endbr32 
80106bbf:	55                   	push   %ebp
80106bc0:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106bc2:	68 00 08 00 00       	push   $0x800
80106bc7:	68 40 71 11 80       	push   $0x80117140
80106bcc:	e8 35 fe ff ff       	call   80106a06 <lidt>
80106bd1:	83 c4 08             	add    $0x8,%esp
}
80106bd4:	90                   	nop
80106bd5:	c9                   	leave  
80106bd6:	c3                   	ret    

80106bd7 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106bd7:	f3 0f 1e fb          	endbr32 
80106bdb:	55                   	push   %ebp
80106bdc:	89 e5                	mov    %esp,%ebp
80106bde:	57                   	push   %edi
80106bdf:	56                   	push   %esi
80106be0:	53                   	push   %ebx
80106be1:	83 ec 2c             	sub    $0x2c,%esp
  if(tf->trapno == T_SYSCALL){
80106be4:	8b 45 08             	mov    0x8(%ebp),%eax
80106be7:	8b 40 30             	mov    0x30(%eax),%eax
80106bea:	83 f8 40             	cmp    $0x40,%eax
80106bed:	75 3b                	jne    80106c2a <trap+0x53>
    if(myproc()->killed)
80106bef:	e8 9b d8 ff ff       	call   8010448f <myproc>
80106bf4:	8b 40 24             	mov    0x24(%eax),%eax
80106bf7:	85 c0                	test   %eax,%eax
80106bf9:	74 05                	je     80106c00 <trap+0x29>
      exit();
80106bfb:	e8 22 dd ff ff       	call   80104922 <exit>
    myproc()->tf = tf;
80106c00:	e8 8a d8 ff ff       	call   8010448f <myproc>
80106c05:	8b 55 08             	mov    0x8(%ebp),%edx
80106c08:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106c0b:	e8 a1 ec ff ff       	call   801058b1 <syscall>
    if(myproc()->killed)
80106c10:	e8 7a d8 ff ff       	call   8010448f <myproc>
80106c15:	8b 40 24             	mov    0x24(%eax),%eax
80106c18:	85 c0                	test   %eax,%eax
80106c1a:	0f 84 45 02 00 00    	je     80106e65 <trap+0x28e>
      exit();
80106c20:	e8 fd dc ff ff       	call   80104922 <exit>
    return;
80106c25:	e9 3b 02 00 00       	jmp    80106e65 <trap+0x28e>
  }
  char *addr;
  switch(tf->trapno){
80106c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c2d:	8b 40 30             	mov    0x30(%eax),%eax
80106c30:	83 e8 0e             	sub    $0xe,%eax
80106c33:	83 f8 31             	cmp    $0x31,%eax
80106c36:	0f 87 f1 00 00 00    	ja     80106d2d <trap+0x156>
80106c3c:	8b 04 85 64 95 10 80 	mov    -0x7fef6a9c(,%eax,4),%eax
80106c43:	3e ff e0             	notrack jmp *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106c46:	e8 a9 d7 ff ff       	call   801043f4 <cpuid>
80106c4b:	85 c0                	test   %eax,%eax
80106c4d:	75 3d                	jne    80106c8c <trap+0xb5>
      acquire(&tickslock);
80106c4f:	83 ec 0c             	sub    $0xc,%esp
80106c52:	68 00 71 11 80       	push   $0x80117100
80106c57:	e8 8a e5 ff ff       	call   801051e6 <acquire>
80106c5c:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106c5f:	a1 40 79 11 80       	mov    0x80117940,%eax
80106c64:	83 c0 01             	add    $0x1,%eax
80106c67:	a3 40 79 11 80       	mov    %eax,0x80117940
      wakeup(&ticks);
80106c6c:	83 ec 0c             	sub    $0xc,%esp
80106c6f:	68 40 79 11 80       	push   $0x80117940
80106c74:	e8 ed e1 ff ff       	call   80104e66 <wakeup>
80106c79:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106c7c:	83 ec 0c             	sub    $0xc,%esp
80106c7f:	68 00 71 11 80       	push   $0x80117100
80106c84:	e8 cf e5 ff ff       	call   80105258 <release>
80106c89:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106c8c:	e8 f3 c4 ff ff       	call   80103184 <lapiceoi>
    break;
80106c91:	e9 4f 01 00 00       	jmp    80106de5 <trap+0x20e>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106c96:	e8 f8 bc ff ff       	call   80102993 <ideintr>
    lapiceoi();
80106c9b:	e8 e4 c4 ff ff       	call   80103184 <lapiceoi>
    break;
80106ca0:	e9 40 01 00 00       	jmp    80106de5 <trap+0x20e>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106ca5:	e8 10 c3 ff ff       	call   80102fba <kbdintr>
    lapiceoi();
80106caa:	e8 d5 c4 ff ff       	call   80103184 <lapiceoi>
    break;
80106caf:	e9 31 01 00 00       	jmp    80106de5 <trap+0x20e>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106cb4:	e8 8e 03 00 00       	call   80107047 <uartintr>
    lapiceoi();
80106cb9:	e8 c6 c4 ff ff       	call   80103184 <lapiceoi>
    break;
80106cbe:	e9 22 01 00 00       	jmp    80106de5 <trap+0x20e>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc6:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106cc9:	8b 45 08             	mov    0x8(%ebp),%eax
80106ccc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106cd0:	0f b7 d8             	movzwl %ax,%ebx
80106cd3:	e8 1c d7 ff ff       	call   801043f4 <cpuid>
80106cd8:	56                   	push   %esi
80106cd9:	53                   	push   %ebx
80106cda:	50                   	push   %eax
80106cdb:	68 94 94 10 80       	push   $0x80109494
80106ce0:	e8 33 97 ff ff       	call   80100418 <cprintf>
80106ce5:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106ce8:	e8 97 c4 ff ff       	call   80103184 <lapiceoi>
    break;
80106ced:	e9 f3 00 00 00       	jmp    80106de5 <trap+0x20e>
  case T_PGFLT:
    //Food for thought: How can one distinguish between a regular page fault and a decryption request?
    cprintf("p4Debug : Page fault !\n");
80106cf2:	83 ec 0c             	sub    $0xc,%esp
80106cf5:	68 b8 94 10 80       	push   $0x801094b8
80106cfa:	e8 19 97 ff ff       	call   80100418 <cprintf>
80106cff:	83 c4 10             	add    $0x10,%esp
    addr = (char*)rcr2();
80106d02:	e8 29 fd ff ff       	call   80106a30 <rcr2>
80106d07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (mdecrypt(addr))
80106d0a:	83 ec 0c             	sub    $0xc,%esp
80106d0d:	ff 75 e4             	pushl  -0x1c(%ebp)
80106d10:	e8 2b 1c 00 00       	call   80108940 <mdecrypt>
80106d15:	83 c4 10             	add    $0x10,%esp
80106d18:	85 c0                	test   %eax,%eax
80106d1a:	0f 84 c4 00 00 00    	je     80106de4 <trap+0x20d>
    {
        panic("p4Debug: Memory fault");
80106d20:	83 ec 0c             	sub    $0xc,%esp
80106d23:	68 d0 94 10 80       	push   $0x801094d0
80106d28:	e8 db 98 ff ff       	call   80100608 <panic>
        exit();
    };
    break;
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106d2d:	e8 5d d7 ff ff       	call   8010448f <myproc>
80106d32:	85 c0                	test   %eax,%eax
80106d34:	74 11                	je     80106d47 <trap+0x170>
80106d36:	8b 45 08             	mov    0x8(%ebp),%eax
80106d39:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106d3d:	0f b7 c0             	movzwl %ax,%eax
80106d40:	83 e0 03             	and    $0x3,%eax
80106d43:	85 c0                	test   %eax,%eax
80106d45:	75 39                	jne    80106d80 <trap+0x1a9>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106d47:	e8 e4 fc ff ff       	call   80106a30 <rcr2>
80106d4c:	89 c3                	mov    %eax,%ebx
80106d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80106d51:	8b 70 38             	mov    0x38(%eax),%esi
80106d54:	e8 9b d6 ff ff       	call   801043f4 <cpuid>
80106d59:	8b 55 08             	mov    0x8(%ebp),%edx
80106d5c:	8b 52 30             	mov    0x30(%edx),%edx
80106d5f:	83 ec 0c             	sub    $0xc,%esp
80106d62:	53                   	push   %ebx
80106d63:	56                   	push   %esi
80106d64:	50                   	push   %eax
80106d65:	52                   	push   %edx
80106d66:	68 e8 94 10 80       	push   $0x801094e8
80106d6b:	e8 a8 96 ff ff       	call   80100418 <cprintf>
80106d70:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106d73:	83 ec 0c             	sub    $0xc,%esp
80106d76:	68 1a 95 10 80       	push   $0x8010951a
80106d7b:	e8 88 98 ff ff       	call   80100608 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d80:	e8 ab fc ff ff       	call   80106a30 <rcr2>
80106d85:	89 c6                	mov    %eax,%esi
80106d87:	8b 45 08             	mov    0x8(%ebp),%eax
80106d8a:	8b 40 38             	mov    0x38(%eax),%eax
80106d8d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106d90:	e8 5f d6 ff ff       	call   801043f4 <cpuid>
80106d95:	89 c3                	mov    %eax,%ebx
80106d97:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9a:	8b 48 34             	mov    0x34(%eax),%ecx
80106d9d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80106da0:	8b 45 08             	mov    0x8(%ebp),%eax
80106da3:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106da6:	e8 e4 d6 ff ff       	call   8010448f <myproc>
80106dab:	8d 50 6c             	lea    0x6c(%eax),%edx
80106dae:	89 55 cc             	mov    %edx,-0x34(%ebp)
80106db1:	e8 d9 d6 ff ff       	call   8010448f <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106db6:	8b 40 10             	mov    0x10(%eax),%eax
80106db9:	56                   	push   %esi
80106dba:	ff 75 d4             	pushl  -0x2c(%ebp)
80106dbd:	53                   	push   %ebx
80106dbe:	ff 75 d0             	pushl  -0x30(%ebp)
80106dc1:	57                   	push   %edi
80106dc2:	ff 75 cc             	pushl  -0x34(%ebp)
80106dc5:	50                   	push   %eax
80106dc6:	68 20 95 10 80       	push   $0x80109520
80106dcb:	e8 48 96 ff ff       	call   80100418 <cprintf>
80106dd0:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106dd3:	e8 b7 d6 ff ff       	call   8010448f <myproc>
80106dd8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106ddf:	eb 04                	jmp    80106de5 <trap+0x20e>
    break;
80106de1:	90                   	nop
80106de2:	eb 01                	jmp    80106de5 <trap+0x20e>
    break;
80106de4:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106de5:	e8 a5 d6 ff ff       	call   8010448f <myproc>
80106dea:	85 c0                	test   %eax,%eax
80106dec:	74 23                	je     80106e11 <trap+0x23a>
80106dee:	e8 9c d6 ff ff       	call   8010448f <myproc>
80106df3:	8b 40 24             	mov    0x24(%eax),%eax
80106df6:	85 c0                	test   %eax,%eax
80106df8:	74 17                	je     80106e11 <trap+0x23a>
80106dfa:	8b 45 08             	mov    0x8(%ebp),%eax
80106dfd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e01:	0f b7 c0             	movzwl %ax,%eax
80106e04:	83 e0 03             	and    $0x3,%eax
80106e07:	83 f8 03             	cmp    $0x3,%eax
80106e0a:	75 05                	jne    80106e11 <trap+0x23a>
    exit();
80106e0c:	e8 11 db ff ff       	call   80104922 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106e11:	e8 79 d6 ff ff       	call   8010448f <myproc>
80106e16:	85 c0                	test   %eax,%eax
80106e18:	74 1d                	je     80106e37 <trap+0x260>
80106e1a:	e8 70 d6 ff ff       	call   8010448f <myproc>
80106e1f:	8b 40 0c             	mov    0xc(%eax),%eax
80106e22:	83 f8 04             	cmp    $0x4,%eax
80106e25:	75 10                	jne    80106e37 <trap+0x260>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106e27:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2a:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106e2d:	83 f8 20             	cmp    $0x20,%eax
80106e30:	75 05                	jne    80106e37 <trap+0x260>
    yield();
80106e32:	e8 b5 de ff ff       	call   80104cec <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e37:	e8 53 d6 ff ff       	call   8010448f <myproc>
80106e3c:	85 c0                	test   %eax,%eax
80106e3e:	74 26                	je     80106e66 <trap+0x28f>
80106e40:	e8 4a d6 ff ff       	call   8010448f <myproc>
80106e45:	8b 40 24             	mov    0x24(%eax),%eax
80106e48:	85 c0                	test   %eax,%eax
80106e4a:	74 1a                	je     80106e66 <trap+0x28f>
80106e4c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e4f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e53:	0f b7 c0             	movzwl %ax,%eax
80106e56:	83 e0 03             	and    $0x3,%eax
80106e59:	83 f8 03             	cmp    $0x3,%eax
80106e5c:	75 08                	jne    80106e66 <trap+0x28f>
    exit();
80106e5e:	e8 bf da ff ff       	call   80104922 <exit>
80106e63:	eb 01                	jmp    80106e66 <trap+0x28f>
    return;
80106e65:	90                   	nop
}
80106e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e69:	5b                   	pop    %ebx
80106e6a:	5e                   	pop    %esi
80106e6b:	5f                   	pop    %edi
80106e6c:	5d                   	pop    %ebp
80106e6d:	c3                   	ret    

80106e6e <inb>:
{
80106e6e:	55                   	push   %ebp
80106e6f:	89 e5                	mov    %esp,%ebp
80106e71:	83 ec 14             	sub    $0x14,%esp
80106e74:	8b 45 08             	mov    0x8(%ebp),%eax
80106e77:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e7b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106e7f:	89 c2                	mov    %eax,%edx
80106e81:	ec                   	in     (%dx),%al
80106e82:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106e85:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106e89:	c9                   	leave  
80106e8a:	c3                   	ret    

80106e8b <outb>:
{
80106e8b:	55                   	push   %ebp
80106e8c:	89 e5                	mov    %esp,%ebp
80106e8e:	83 ec 08             	sub    $0x8,%esp
80106e91:	8b 45 08             	mov    0x8(%ebp),%eax
80106e94:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e97:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106e9b:	89 d0                	mov    %edx,%eax
80106e9d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ea0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106ea4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106ea8:	ee                   	out    %al,(%dx)
}
80106ea9:	90                   	nop
80106eaa:	c9                   	leave  
80106eab:	c3                   	ret    

80106eac <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106eac:	f3 0f 1e fb          	endbr32 
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106eb6:	6a 00                	push   $0x0
80106eb8:	68 fa 03 00 00       	push   $0x3fa
80106ebd:	e8 c9 ff ff ff       	call   80106e8b <outb>
80106ec2:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106ec5:	68 80 00 00 00       	push   $0x80
80106eca:	68 fb 03 00 00       	push   $0x3fb
80106ecf:	e8 b7 ff ff ff       	call   80106e8b <outb>
80106ed4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106ed7:	6a 0c                	push   $0xc
80106ed9:	68 f8 03 00 00       	push   $0x3f8
80106ede:	e8 a8 ff ff ff       	call   80106e8b <outb>
80106ee3:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106ee6:	6a 00                	push   $0x0
80106ee8:	68 f9 03 00 00       	push   $0x3f9
80106eed:	e8 99 ff ff ff       	call   80106e8b <outb>
80106ef2:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106ef5:	6a 03                	push   $0x3
80106ef7:	68 fb 03 00 00       	push   $0x3fb
80106efc:	e8 8a ff ff ff       	call   80106e8b <outb>
80106f01:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106f04:	6a 00                	push   $0x0
80106f06:	68 fc 03 00 00       	push   $0x3fc
80106f0b:	e8 7b ff ff ff       	call   80106e8b <outb>
80106f10:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106f13:	6a 01                	push   $0x1
80106f15:	68 f9 03 00 00       	push   $0x3f9
80106f1a:	e8 6c ff ff ff       	call   80106e8b <outb>
80106f1f:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106f22:	68 fd 03 00 00       	push   $0x3fd
80106f27:	e8 42 ff ff ff       	call   80106e6e <inb>
80106f2c:	83 c4 04             	add    $0x4,%esp
80106f2f:	3c ff                	cmp    $0xff,%al
80106f31:	74 61                	je     80106f94 <uartinit+0xe8>
    return;
  uart = 1;
80106f33:	c7 05 44 c6 10 80 01 	movl   $0x1,0x8010c644
80106f3a:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106f3d:	68 fa 03 00 00       	push   $0x3fa
80106f42:	e8 27 ff ff ff       	call   80106e6e <inb>
80106f47:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106f4a:	68 f8 03 00 00       	push   $0x3f8
80106f4f:	e8 1a ff ff ff       	call   80106e6e <inb>
80106f54:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106f57:	83 ec 08             	sub    $0x8,%esp
80106f5a:	6a 00                	push   $0x0
80106f5c:	6a 04                	push   $0x4
80106f5e:	e8 e2 bc ff ff       	call   80102c45 <ioapicenable>
80106f63:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106f66:	c7 45 f4 2c 96 10 80 	movl   $0x8010962c,-0xc(%ebp)
80106f6d:	eb 19                	jmp    80106f88 <uartinit+0xdc>
    uartputc(*p);
80106f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f72:	0f b6 00             	movzbl (%eax),%eax
80106f75:	0f be c0             	movsbl %al,%eax
80106f78:	83 ec 0c             	sub    $0xc,%esp
80106f7b:	50                   	push   %eax
80106f7c:	e8 16 00 00 00       	call   80106f97 <uartputc>
80106f81:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106f84:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f8b:	0f b6 00             	movzbl (%eax),%eax
80106f8e:	84 c0                	test   %al,%al
80106f90:	75 dd                	jne    80106f6f <uartinit+0xc3>
80106f92:	eb 01                	jmp    80106f95 <uartinit+0xe9>
    return;
80106f94:	90                   	nop
}
80106f95:	c9                   	leave  
80106f96:	c3                   	ret    

80106f97 <uartputc>:

void
uartputc(int c)
{
80106f97:	f3 0f 1e fb          	endbr32 
80106f9b:	55                   	push   %ebp
80106f9c:	89 e5                	mov    %esp,%ebp
80106f9e:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106fa1:	a1 44 c6 10 80       	mov    0x8010c644,%eax
80106fa6:	85 c0                	test   %eax,%eax
80106fa8:	74 53                	je     80106ffd <uartputc+0x66>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106faa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106fb1:	eb 11                	jmp    80106fc4 <uartputc+0x2d>
    microdelay(10);
80106fb3:	83 ec 0c             	sub    $0xc,%esp
80106fb6:	6a 0a                	push   $0xa
80106fb8:	e8 e6 c1 ff ff       	call   801031a3 <microdelay>
80106fbd:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106fc0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106fc4:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106fc8:	7f 1a                	jg     80106fe4 <uartputc+0x4d>
80106fca:	83 ec 0c             	sub    $0xc,%esp
80106fcd:	68 fd 03 00 00       	push   $0x3fd
80106fd2:	e8 97 fe ff ff       	call   80106e6e <inb>
80106fd7:	83 c4 10             	add    $0x10,%esp
80106fda:	0f b6 c0             	movzbl %al,%eax
80106fdd:	83 e0 20             	and    $0x20,%eax
80106fe0:	85 c0                	test   %eax,%eax
80106fe2:	74 cf                	je     80106fb3 <uartputc+0x1c>
  outb(COM1+0, c);
80106fe4:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe7:	0f b6 c0             	movzbl %al,%eax
80106fea:	83 ec 08             	sub    $0x8,%esp
80106fed:	50                   	push   %eax
80106fee:	68 f8 03 00 00       	push   $0x3f8
80106ff3:	e8 93 fe ff ff       	call   80106e8b <outb>
80106ff8:	83 c4 10             	add    $0x10,%esp
80106ffb:	eb 01                	jmp    80106ffe <uartputc+0x67>
    return;
80106ffd:	90                   	nop
}
80106ffe:	c9                   	leave  
80106fff:	c3                   	ret    

80107000 <uartgetc>:

static int
uartgetc(void)
{
80107000:	f3 0f 1e fb          	endbr32 
80107004:	55                   	push   %ebp
80107005:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107007:	a1 44 c6 10 80       	mov    0x8010c644,%eax
8010700c:	85 c0                	test   %eax,%eax
8010700e:	75 07                	jne    80107017 <uartgetc+0x17>
    return -1;
80107010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107015:	eb 2e                	jmp    80107045 <uartgetc+0x45>
  if(!(inb(COM1+5) & 0x01))
80107017:	68 fd 03 00 00       	push   $0x3fd
8010701c:	e8 4d fe ff ff       	call   80106e6e <inb>
80107021:	83 c4 04             	add    $0x4,%esp
80107024:	0f b6 c0             	movzbl %al,%eax
80107027:	83 e0 01             	and    $0x1,%eax
8010702a:	85 c0                	test   %eax,%eax
8010702c:	75 07                	jne    80107035 <uartgetc+0x35>
    return -1;
8010702e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107033:	eb 10                	jmp    80107045 <uartgetc+0x45>
  return inb(COM1+0);
80107035:	68 f8 03 00 00       	push   $0x3f8
8010703a:	e8 2f fe ff ff       	call   80106e6e <inb>
8010703f:	83 c4 04             	add    $0x4,%esp
80107042:	0f b6 c0             	movzbl %al,%eax
}
80107045:	c9                   	leave  
80107046:	c3                   	ret    

80107047 <uartintr>:

void
uartintr(void)
{
80107047:	f3 0f 1e fb          	endbr32 
8010704b:	55                   	push   %ebp
8010704c:	89 e5                	mov    %esp,%ebp
8010704e:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107051:	83 ec 0c             	sub    $0xc,%esp
80107054:	68 00 70 10 80       	push   $0x80107000
80107059:	e8 4a 98 ff ff       	call   801008a8 <consoleintr>
8010705e:	83 c4 10             	add    $0x10,%esp
}
80107061:	90                   	nop
80107062:	c9                   	leave  
80107063:	c3                   	ret    

80107064 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107064:	6a 00                	push   $0x0
  pushl $0
80107066:	6a 00                	push   $0x0
  jmp alltraps
80107068:	e9 76 f9 ff ff       	jmp    801069e3 <alltraps>

8010706d <vector1>:
.globl vector1
vector1:
  pushl $0
8010706d:	6a 00                	push   $0x0
  pushl $1
8010706f:	6a 01                	push   $0x1
  jmp alltraps
80107071:	e9 6d f9 ff ff       	jmp    801069e3 <alltraps>

80107076 <vector2>:
.globl vector2
vector2:
  pushl $0
80107076:	6a 00                	push   $0x0
  pushl $2
80107078:	6a 02                	push   $0x2
  jmp alltraps
8010707a:	e9 64 f9 ff ff       	jmp    801069e3 <alltraps>

8010707f <vector3>:
.globl vector3
vector3:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $3
80107081:	6a 03                	push   $0x3
  jmp alltraps
80107083:	e9 5b f9 ff ff       	jmp    801069e3 <alltraps>

80107088 <vector4>:
.globl vector4
vector4:
  pushl $0
80107088:	6a 00                	push   $0x0
  pushl $4
8010708a:	6a 04                	push   $0x4
  jmp alltraps
8010708c:	e9 52 f9 ff ff       	jmp    801069e3 <alltraps>

80107091 <vector5>:
.globl vector5
vector5:
  pushl $0
80107091:	6a 00                	push   $0x0
  pushl $5
80107093:	6a 05                	push   $0x5
  jmp alltraps
80107095:	e9 49 f9 ff ff       	jmp    801069e3 <alltraps>

8010709a <vector6>:
.globl vector6
vector6:
  pushl $0
8010709a:	6a 00                	push   $0x0
  pushl $6
8010709c:	6a 06                	push   $0x6
  jmp alltraps
8010709e:	e9 40 f9 ff ff       	jmp    801069e3 <alltraps>

801070a3 <vector7>:
.globl vector7
vector7:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $7
801070a5:	6a 07                	push   $0x7
  jmp alltraps
801070a7:	e9 37 f9 ff ff       	jmp    801069e3 <alltraps>

801070ac <vector8>:
.globl vector8
vector8:
  pushl $8
801070ac:	6a 08                	push   $0x8
  jmp alltraps
801070ae:	e9 30 f9 ff ff       	jmp    801069e3 <alltraps>

801070b3 <vector9>:
.globl vector9
vector9:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $9
801070b5:	6a 09                	push   $0x9
  jmp alltraps
801070b7:	e9 27 f9 ff ff       	jmp    801069e3 <alltraps>

801070bc <vector10>:
.globl vector10
vector10:
  pushl $10
801070bc:	6a 0a                	push   $0xa
  jmp alltraps
801070be:	e9 20 f9 ff ff       	jmp    801069e3 <alltraps>

801070c3 <vector11>:
.globl vector11
vector11:
  pushl $11
801070c3:	6a 0b                	push   $0xb
  jmp alltraps
801070c5:	e9 19 f9 ff ff       	jmp    801069e3 <alltraps>

801070ca <vector12>:
.globl vector12
vector12:
  pushl $12
801070ca:	6a 0c                	push   $0xc
  jmp alltraps
801070cc:	e9 12 f9 ff ff       	jmp    801069e3 <alltraps>

801070d1 <vector13>:
.globl vector13
vector13:
  pushl $13
801070d1:	6a 0d                	push   $0xd
  jmp alltraps
801070d3:	e9 0b f9 ff ff       	jmp    801069e3 <alltraps>

801070d8 <vector14>:
.globl vector14
vector14:
  pushl $14
801070d8:	6a 0e                	push   $0xe
  jmp alltraps
801070da:	e9 04 f9 ff ff       	jmp    801069e3 <alltraps>

801070df <vector15>:
.globl vector15
vector15:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $15
801070e1:	6a 0f                	push   $0xf
  jmp alltraps
801070e3:	e9 fb f8 ff ff       	jmp    801069e3 <alltraps>

801070e8 <vector16>:
.globl vector16
vector16:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $16
801070ea:	6a 10                	push   $0x10
  jmp alltraps
801070ec:	e9 f2 f8 ff ff       	jmp    801069e3 <alltraps>

801070f1 <vector17>:
.globl vector17
vector17:
  pushl $17
801070f1:	6a 11                	push   $0x11
  jmp alltraps
801070f3:	e9 eb f8 ff ff       	jmp    801069e3 <alltraps>

801070f8 <vector18>:
.globl vector18
vector18:
  pushl $0
801070f8:	6a 00                	push   $0x0
  pushl $18
801070fa:	6a 12                	push   $0x12
  jmp alltraps
801070fc:	e9 e2 f8 ff ff       	jmp    801069e3 <alltraps>

80107101 <vector19>:
.globl vector19
vector19:
  pushl $0
80107101:	6a 00                	push   $0x0
  pushl $19
80107103:	6a 13                	push   $0x13
  jmp alltraps
80107105:	e9 d9 f8 ff ff       	jmp    801069e3 <alltraps>

8010710a <vector20>:
.globl vector20
vector20:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $20
8010710c:	6a 14                	push   $0x14
  jmp alltraps
8010710e:	e9 d0 f8 ff ff       	jmp    801069e3 <alltraps>

80107113 <vector21>:
.globl vector21
vector21:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $21
80107115:	6a 15                	push   $0x15
  jmp alltraps
80107117:	e9 c7 f8 ff ff       	jmp    801069e3 <alltraps>

8010711c <vector22>:
.globl vector22
vector22:
  pushl $0
8010711c:	6a 00                	push   $0x0
  pushl $22
8010711e:	6a 16                	push   $0x16
  jmp alltraps
80107120:	e9 be f8 ff ff       	jmp    801069e3 <alltraps>

80107125 <vector23>:
.globl vector23
vector23:
  pushl $0
80107125:	6a 00                	push   $0x0
  pushl $23
80107127:	6a 17                	push   $0x17
  jmp alltraps
80107129:	e9 b5 f8 ff ff       	jmp    801069e3 <alltraps>

8010712e <vector24>:
.globl vector24
vector24:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $24
80107130:	6a 18                	push   $0x18
  jmp alltraps
80107132:	e9 ac f8 ff ff       	jmp    801069e3 <alltraps>

80107137 <vector25>:
.globl vector25
vector25:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $25
80107139:	6a 19                	push   $0x19
  jmp alltraps
8010713b:	e9 a3 f8 ff ff       	jmp    801069e3 <alltraps>

80107140 <vector26>:
.globl vector26
vector26:
  pushl $0
80107140:	6a 00                	push   $0x0
  pushl $26
80107142:	6a 1a                	push   $0x1a
  jmp alltraps
80107144:	e9 9a f8 ff ff       	jmp    801069e3 <alltraps>

80107149 <vector27>:
.globl vector27
vector27:
  pushl $0
80107149:	6a 00                	push   $0x0
  pushl $27
8010714b:	6a 1b                	push   $0x1b
  jmp alltraps
8010714d:	e9 91 f8 ff ff       	jmp    801069e3 <alltraps>

80107152 <vector28>:
.globl vector28
vector28:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $28
80107154:	6a 1c                	push   $0x1c
  jmp alltraps
80107156:	e9 88 f8 ff ff       	jmp    801069e3 <alltraps>

8010715b <vector29>:
.globl vector29
vector29:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $29
8010715d:	6a 1d                	push   $0x1d
  jmp alltraps
8010715f:	e9 7f f8 ff ff       	jmp    801069e3 <alltraps>

80107164 <vector30>:
.globl vector30
vector30:
  pushl $0
80107164:	6a 00                	push   $0x0
  pushl $30
80107166:	6a 1e                	push   $0x1e
  jmp alltraps
80107168:	e9 76 f8 ff ff       	jmp    801069e3 <alltraps>

8010716d <vector31>:
.globl vector31
vector31:
  pushl $0
8010716d:	6a 00                	push   $0x0
  pushl $31
8010716f:	6a 1f                	push   $0x1f
  jmp alltraps
80107171:	e9 6d f8 ff ff       	jmp    801069e3 <alltraps>

80107176 <vector32>:
.globl vector32
vector32:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $32
80107178:	6a 20                	push   $0x20
  jmp alltraps
8010717a:	e9 64 f8 ff ff       	jmp    801069e3 <alltraps>

8010717f <vector33>:
.globl vector33
vector33:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $33
80107181:	6a 21                	push   $0x21
  jmp alltraps
80107183:	e9 5b f8 ff ff       	jmp    801069e3 <alltraps>

80107188 <vector34>:
.globl vector34
vector34:
  pushl $0
80107188:	6a 00                	push   $0x0
  pushl $34
8010718a:	6a 22                	push   $0x22
  jmp alltraps
8010718c:	e9 52 f8 ff ff       	jmp    801069e3 <alltraps>

80107191 <vector35>:
.globl vector35
vector35:
  pushl $0
80107191:	6a 00                	push   $0x0
  pushl $35
80107193:	6a 23                	push   $0x23
  jmp alltraps
80107195:	e9 49 f8 ff ff       	jmp    801069e3 <alltraps>

8010719a <vector36>:
.globl vector36
vector36:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $36
8010719c:	6a 24                	push   $0x24
  jmp alltraps
8010719e:	e9 40 f8 ff ff       	jmp    801069e3 <alltraps>

801071a3 <vector37>:
.globl vector37
vector37:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $37
801071a5:	6a 25                	push   $0x25
  jmp alltraps
801071a7:	e9 37 f8 ff ff       	jmp    801069e3 <alltraps>

801071ac <vector38>:
.globl vector38
vector38:
  pushl $0
801071ac:	6a 00                	push   $0x0
  pushl $38
801071ae:	6a 26                	push   $0x26
  jmp alltraps
801071b0:	e9 2e f8 ff ff       	jmp    801069e3 <alltraps>

801071b5 <vector39>:
.globl vector39
vector39:
  pushl $0
801071b5:	6a 00                	push   $0x0
  pushl $39
801071b7:	6a 27                	push   $0x27
  jmp alltraps
801071b9:	e9 25 f8 ff ff       	jmp    801069e3 <alltraps>

801071be <vector40>:
.globl vector40
vector40:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $40
801071c0:	6a 28                	push   $0x28
  jmp alltraps
801071c2:	e9 1c f8 ff ff       	jmp    801069e3 <alltraps>

801071c7 <vector41>:
.globl vector41
vector41:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $41
801071c9:	6a 29                	push   $0x29
  jmp alltraps
801071cb:	e9 13 f8 ff ff       	jmp    801069e3 <alltraps>

801071d0 <vector42>:
.globl vector42
vector42:
  pushl $0
801071d0:	6a 00                	push   $0x0
  pushl $42
801071d2:	6a 2a                	push   $0x2a
  jmp alltraps
801071d4:	e9 0a f8 ff ff       	jmp    801069e3 <alltraps>

801071d9 <vector43>:
.globl vector43
vector43:
  pushl $0
801071d9:	6a 00                	push   $0x0
  pushl $43
801071db:	6a 2b                	push   $0x2b
  jmp alltraps
801071dd:	e9 01 f8 ff ff       	jmp    801069e3 <alltraps>

801071e2 <vector44>:
.globl vector44
vector44:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $44
801071e4:	6a 2c                	push   $0x2c
  jmp alltraps
801071e6:	e9 f8 f7 ff ff       	jmp    801069e3 <alltraps>

801071eb <vector45>:
.globl vector45
vector45:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $45
801071ed:	6a 2d                	push   $0x2d
  jmp alltraps
801071ef:	e9 ef f7 ff ff       	jmp    801069e3 <alltraps>

801071f4 <vector46>:
.globl vector46
vector46:
  pushl $0
801071f4:	6a 00                	push   $0x0
  pushl $46
801071f6:	6a 2e                	push   $0x2e
  jmp alltraps
801071f8:	e9 e6 f7 ff ff       	jmp    801069e3 <alltraps>

801071fd <vector47>:
.globl vector47
vector47:
  pushl $0
801071fd:	6a 00                	push   $0x0
  pushl $47
801071ff:	6a 2f                	push   $0x2f
  jmp alltraps
80107201:	e9 dd f7 ff ff       	jmp    801069e3 <alltraps>

80107206 <vector48>:
.globl vector48
vector48:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $48
80107208:	6a 30                	push   $0x30
  jmp alltraps
8010720a:	e9 d4 f7 ff ff       	jmp    801069e3 <alltraps>

8010720f <vector49>:
.globl vector49
vector49:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $49
80107211:	6a 31                	push   $0x31
  jmp alltraps
80107213:	e9 cb f7 ff ff       	jmp    801069e3 <alltraps>

80107218 <vector50>:
.globl vector50
vector50:
  pushl $0
80107218:	6a 00                	push   $0x0
  pushl $50
8010721a:	6a 32                	push   $0x32
  jmp alltraps
8010721c:	e9 c2 f7 ff ff       	jmp    801069e3 <alltraps>

80107221 <vector51>:
.globl vector51
vector51:
  pushl $0
80107221:	6a 00                	push   $0x0
  pushl $51
80107223:	6a 33                	push   $0x33
  jmp alltraps
80107225:	e9 b9 f7 ff ff       	jmp    801069e3 <alltraps>

8010722a <vector52>:
.globl vector52
vector52:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $52
8010722c:	6a 34                	push   $0x34
  jmp alltraps
8010722e:	e9 b0 f7 ff ff       	jmp    801069e3 <alltraps>

80107233 <vector53>:
.globl vector53
vector53:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $53
80107235:	6a 35                	push   $0x35
  jmp alltraps
80107237:	e9 a7 f7 ff ff       	jmp    801069e3 <alltraps>

8010723c <vector54>:
.globl vector54
vector54:
  pushl $0
8010723c:	6a 00                	push   $0x0
  pushl $54
8010723e:	6a 36                	push   $0x36
  jmp alltraps
80107240:	e9 9e f7 ff ff       	jmp    801069e3 <alltraps>

80107245 <vector55>:
.globl vector55
vector55:
  pushl $0
80107245:	6a 00                	push   $0x0
  pushl $55
80107247:	6a 37                	push   $0x37
  jmp alltraps
80107249:	e9 95 f7 ff ff       	jmp    801069e3 <alltraps>

8010724e <vector56>:
.globl vector56
vector56:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $56
80107250:	6a 38                	push   $0x38
  jmp alltraps
80107252:	e9 8c f7 ff ff       	jmp    801069e3 <alltraps>

80107257 <vector57>:
.globl vector57
vector57:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $57
80107259:	6a 39                	push   $0x39
  jmp alltraps
8010725b:	e9 83 f7 ff ff       	jmp    801069e3 <alltraps>

80107260 <vector58>:
.globl vector58
vector58:
  pushl $0
80107260:	6a 00                	push   $0x0
  pushl $58
80107262:	6a 3a                	push   $0x3a
  jmp alltraps
80107264:	e9 7a f7 ff ff       	jmp    801069e3 <alltraps>

80107269 <vector59>:
.globl vector59
vector59:
  pushl $0
80107269:	6a 00                	push   $0x0
  pushl $59
8010726b:	6a 3b                	push   $0x3b
  jmp alltraps
8010726d:	e9 71 f7 ff ff       	jmp    801069e3 <alltraps>

80107272 <vector60>:
.globl vector60
vector60:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $60
80107274:	6a 3c                	push   $0x3c
  jmp alltraps
80107276:	e9 68 f7 ff ff       	jmp    801069e3 <alltraps>

8010727b <vector61>:
.globl vector61
vector61:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $61
8010727d:	6a 3d                	push   $0x3d
  jmp alltraps
8010727f:	e9 5f f7 ff ff       	jmp    801069e3 <alltraps>

80107284 <vector62>:
.globl vector62
vector62:
  pushl $0
80107284:	6a 00                	push   $0x0
  pushl $62
80107286:	6a 3e                	push   $0x3e
  jmp alltraps
80107288:	e9 56 f7 ff ff       	jmp    801069e3 <alltraps>

8010728d <vector63>:
.globl vector63
vector63:
  pushl $0
8010728d:	6a 00                	push   $0x0
  pushl $63
8010728f:	6a 3f                	push   $0x3f
  jmp alltraps
80107291:	e9 4d f7 ff ff       	jmp    801069e3 <alltraps>

80107296 <vector64>:
.globl vector64
vector64:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $64
80107298:	6a 40                	push   $0x40
  jmp alltraps
8010729a:	e9 44 f7 ff ff       	jmp    801069e3 <alltraps>

8010729f <vector65>:
.globl vector65
vector65:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $65
801072a1:	6a 41                	push   $0x41
  jmp alltraps
801072a3:	e9 3b f7 ff ff       	jmp    801069e3 <alltraps>

801072a8 <vector66>:
.globl vector66
vector66:
  pushl $0
801072a8:	6a 00                	push   $0x0
  pushl $66
801072aa:	6a 42                	push   $0x42
  jmp alltraps
801072ac:	e9 32 f7 ff ff       	jmp    801069e3 <alltraps>

801072b1 <vector67>:
.globl vector67
vector67:
  pushl $0
801072b1:	6a 00                	push   $0x0
  pushl $67
801072b3:	6a 43                	push   $0x43
  jmp alltraps
801072b5:	e9 29 f7 ff ff       	jmp    801069e3 <alltraps>

801072ba <vector68>:
.globl vector68
vector68:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $68
801072bc:	6a 44                	push   $0x44
  jmp alltraps
801072be:	e9 20 f7 ff ff       	jmp    801069e3 <alltraps>

801072c3 <vector69>:
.globl vector69
vector69:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $69
801072c5:	6a 45                	push   $0x45
  jmp alltraps
801072c7:	e9 17 f7 ff ff       	jmp    801069e3 <alltraps>

801072cc <vector70>:
.globl vector70
vector70:
  pushl $0
801072cc:	6a 00                	push   $0x0
  pushl $70
801072ce:	6a 46                	push   $0x46
  jmp alltraps
801072d0:	e9 0e f7 ff ff       	jmp    801069e3 <alltraps>

801072d5 <vector71>:
.globl vector71
vector71:
  pushl $0
801072d5:	6a 00                	push   $0x0
  pushl $71
801072d7:	6a 47                	push   $0x47
  jmp alltraps
801072d9:	e9 05 f7 ff ff       	jmp    801069e3 <alltraps>

801072de <vector72>:
.globl vector72
vector72:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $72
801072e0:	6a 48                	push   $0x48
  jmp alltraps
801072e2:	e9 fc f6 ff ff       	jmp    801069e3 <alltraps>

801072e7 <vector73>:
.globl vector73
vector73:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $73
801072e9:	6a 49                	push   $0x49
  jmp alltraps
801072eb:	e9 f3 f6 ff ff       	jmp    801069e3 <alltraps>

801072f0 <vector74>:
.globl vector74
vector74:
  pushl $0
801072f0:	6a 00                	push   $0x0
  pushl $74
801072f2:	6a 4a                	push   $0x4a
  jmp alltraps
801072f4:	e9 ea f6 ff ff       	jmp    801069e3 <alltraps>

801072f9 <vector75>:
.globl vector75
vector75:
  pushl $0
801072f9:	6a 00                	push   $0x0
  pushl $75
801072fb:	6a 4b                	push   $0x4b
  jmp alltraps
801072fd:	e9 e1 f6 ff ff       	jmp    801069e3 <alltraps>

80107302 <vector76>:
.globl vector76
vector76:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $76
80107304:	6a 4c                	push   $0x4c
  jmp alltraps
80107306:	e9 d8 f6 ff ff       	jmp    801069e3 <alltraps>

8010730b <vector77>:
.globl vector77
vector77:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $77
8010730d:	6a 4d                	push   $0x4d
  jmp alltraps
8010730f:	e9 cf f6 ff ff       	jmp    801069e3 <alltraps>

80107314 <vector78>:
.globl vector78
vector78:
  pushl $0
80107314:	6a 00                	push   $0x0
  pushl $78
80107316:	6a 4e                	push   $0x4e
  jmp alltraps
80107318:	e9 c6 f6 ff ff       	jmp    801069e3 <alltraps>

8010731d <vector79>:
.globl vector79
vector79:
  pushl $0
8010731d:	6a 00                	push   $0x0
  pushl $79
8010731f:	6a 4f                	push   $0x4f
  jmp alltraps
80107321:	e9 bd f6 ff ff       	jmp    801069e3 <alltraps>

80107326 <vector80>:
.globl vector80
vector80:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $80
80107328:	6a 50                	push   $0x50
  jmp alltraps
8010732a:	e9 b4 f6 ff ff       	jmp    801069e3 <alltraps>

8010732f <vector81>:
.globl vector81
vector81:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $81
80107331:	6a 51                	push   $0x51
  jmp alltraps
80107333:	e9 ab f6 ff ff       	jmp    801069e3 <alltraps>

80107338 <vector82>:
.globl vector82
vector82:
  pushl $0
80107338:	6a 00                	push   $0x0
  pushl $82
8010733a:	6a 52                	push   $0x52
  jmp alltraps
8010733c:	e9 a2 f6 ff ff       	jmp    801069e3 <alltraps>

80107341 <vector83>:
.globl vector83
vector83:
  pushl $0
80107341:	6a 00                	push   $0x0
  pushl $83
80107343:	6a 53                	push   $0x53
  jmp alltraps
80107345:	e9 99 f6 ff ff       	jmp    801069e3 <alltraps>

8010734a <vector84>:
.globl vector84
vector84:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $84
8010734c:	6a 54                	push   $0x54
  jmp alltraps
8010734e:	e9 90 f6 ff ff       	jmp    801069e3 <alltraps>

80107353 <vector85>:
.globl vector85
vector85:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $85
80107355:	6a 55                	push   $0x55
  jmp alltraps
80107357:	e9 87 f6 ff ff       	jmp    801069e3 <alltraps>

8010735c <vector86>:
.globl vector86
vector86:
  pushl $0
8010735c:	6a 00                	push   $0x0
  pushl $86
8010735e:	6a 56                	push   $0x56
  jmp alltraps
80107360:	e9 7e f6 ff ff       	jmp    801069e3 <alltraps>

80107365 <vector87>:
.globl vector87
vector87:
  pushl $0
80107365:	6a 00                	push   $0x0
  pushl $87
80107367:	6a 57                	push   $0x57
  jmp alltraps
80107369:	e9 75 f6 ff ff       	jmp    801069e3 <alltraps>

8010736e <vector88>:
.globl vector88
vector88:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $88
80107370:	6a 58                	push   $0x58
  jmp alltraps
80107372:	e9 6c f6 ff ff       	jmp    801069e3 <alltraps>

80107377 <vector89>:
.globl vector89
vector89:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $89
80107379:	6a 59                	push   $0x59
  jmp alltraps
8010737b:	e9 63 f6 ff ff       	jmp    801069e3 <alltraps>

80107380 <vector90>:
.globl vector90
vector90:
  pushl $0
80107380:	6a 00                	push   $0x0
  pushl $90
80107382:	6a 5a                	push   $0x5a
  jmp alltraps
80107384:	e9 5a f6 ff ff       	jmp    801069e3 <alltraps>

80107389 <vector91>:
.globl vector91
vector91:
  pushl $0
80107389:	6a 00                	push   $0x0
  pushl $91
8010738b:	6a 5b                	push   $0x5b
  jmp alltraps
8010738d:	e9 51 f6 ff ff       	jmp    801069e3 <alltraps>

80107392 <vector92>:
.globl vector92
vector92:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $92
80107394:	6a 5c                	push   $0x5c
  jmp alltraps
80107396:	e9 48 f6 ff ff       	jmp    801069e3 <alltraps>

8010739b <vector93>:
.globl vector93
vector93:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $93
8010739d:	6a 5d                	push   $0x5d
  jmp alltraps
8010739f:	e9 3f f6 ff ff       	jmp    801069e3 <alltraps>

801073a4 <vector94>:
.globl vector94
vector94:
  pushl $0
801073a4:	6a 00                	push   $0x0
  pushl $94
801073a6:	6a 5e                	push   $0x5e
  jmp alltraps
801073a8:	e9 36 f6 ff ff       	jmp    801069e3 <alltraps>

801073ad <vector95>:
.globl vector95
vector95:
  pushl $0
801073ad:	6a 00                	push   $0x0
  pushl $95
801073af:	6a 5f                	push   $0x5f
  jmp alltraps
801073b1:	e9 2d f6 ff ff       	jmp    801069e3 <alltraps>

801073b6 <vector96>:
.globl vector96
vector96:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $96
801073b8:	6a 60                	push   $0x60
  jmp alltraps
801073ba:	e9 24 f6 ff ff       	jmp    801069e3 <alltraps>

801073bf <vector97>:
.globl vector97
vector97:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $97
801073c1:	6a 61                	push   $0x61
  jmp alltraps
801073c3:	e9 1b f6 ff ff       	jmp    801069e3 <alltraps>

801073c8 <vector98>:
.globl vector98
vector98:
  pushl $0
801073c8:	6a 00                	push   $0x0
  pushl $98
801073ca:	6a 62                	push   $0x62
  jmp alltraps
801073cc:	e9 12 f6 ff ff       	jmp    801069e3 <alltraps>

801073d1 <vector99>:
.globl vector99
vector99:
  pushl $0
801073d1:	6a 00                	push   $0x0
  pushl $99
801073d3:	6a 63                	push   $0x63
  jmp alltraps
801073d5:	e9 09 f6 ff ff       	jmp    801069e3 <alltraps>

801073da <vector100>:
.globl vector100
vector100:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $100
801073dc:	6a 64                	push   $0x64
  jmp alltraps
801073de:	e9 00 f6 ff ff       	jmp    801069e3 <alltraps>

801073e3 <vector101>:
.globl vector101
vector101:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $101
801073e5:	6a 65                	push   $0x65
  jmp alltraps
801073e7:	e9 f7 f5 ff ff       	jmp    801069e3 <alltraps>

801073ec <vector102>:
.globl vector102
vector102:
  pushl $0
801073ec:	6a 00                	push   $0x0
  pushl $102
801073ee:	6a 66                	push   $0x66
  jmp alltraps
801073f0:	e9 ee f5 ff ff       	jmp    801069e3 <alltraps>

801073f5 <vector103>:
.globl vector103
vector103:
  pushl $0
801073f5:	6a 00                	push   $0x0
  pushl $103
801073f7:	6a 67                	push   $0x67
  jmp alltraps
801073f9:	e9 e5 f5 ff ff       	jmp    801069e3 <alltraps>

801073fe <vector104>:
.globl vector104
vector104:
  pushl $0
801073fe:	6a 00                	push   $0x0
  pushl $104
80107400:	6a 68                	push   $0x68
  jmp alltraps
80107402:	e9 dc f5 ff ff       	jmp    801069e3 <alltraps>

80107407 <vector105>:
.globl vector105
vector105:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $105
80107409:	6a 69                	push   $0x69
  jmp alltraps
8010740b:	e9 d3 f5 ff ff       	jmp    801069e3 <alltraps>

80107410 <vector106>:
.globl vector106
vector106:
  pushl $0
80107410:	6a 00                	push   $0x0
  pushl $106
80107412:	6a 6a                	push   $0x6a
  jmp alltraps
80107414:	e9 ca f5 ff ff       	jmp    801069e3 <alltraps>

80107419 <vector107>:
.globl vector107
vector107:
  pushl $0
80107419:	6a 00                	push   $0x0
  pushl $107
8010741b:	6a 6b                	push   $0x6b
  jmp alltraps
8010741d:	e9 c1 f5 ff ff       	jmp    801069e3 <alltraps>

80107422 <vector108>:
.globl vector108
vector108:
  pushl $0
80107422:	6a 00                	push   $0x0
  pushl $108
80107424:	6a 6c                	push   $0x6c
  jmp alltraps
80107426:	e9 b8 f5 ff ff       	jmp    801069e3 <alltraps>

8010742b <vector109>:
.globl vector109
vector109:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $109
8010742d:	6a 6d                	push   $0x6d
  jmp alltraps
8010742f:	e9 af f5 ff ff       	jmp    801069e3 <alltraps>

80107434 <vector110>:
.globl vector110
vector110:
  pushl $0
80107434:	6a 00                	push   $0x0
  pushl $110
80107436:	6a 6e                	push   $0x6e
  jmp alltraps
80107438:	e9 a6 f5 ff ff       	jmp    801069e3 <alltraps>

8010743d <vector111>:
.globl vector111
vector111:
  pushl $0
8010743d:	6a 00                	push   $0x0
  pushl $111
8010743f:	6a 6f                	push   $0x6f
  jmp alltraps
80107441:	e9 9d f5 ff ff       	jmp    801069e3 <alltraps>

80107446 <vector112>:
.globl vector112
vector112:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $112
80107448:	6a 70                	push   $0x70
  jmp alltraps
8010744a:	e9 94 f5 ff ff       	jmp    801069e3 <alltraps>

8010744f <vector113>:
.globl vector113
vector113:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $113
80107451:	6a 71                	push   $0x71
  jmp alltraps
80107453:	e9 8b f5 ff ff       	jmp    801069e3 <alltraps>

80107458 <vector114>:
.globl vector114
vector114:
  pushl $0
80107458:	6a 00                	push   $0x0
  pushl $114
8010745a:	6a 72                	push   $0x72
  jmp alltraps
8010745c:	e9 82 f5 ff ff       	jmp    801069e3 <alltraps>

80107461 <vector115>:
.globl vector115
vector115:
  pushl $0
80107461:	6a 00                	push   $0x0
  pushl $115
80107463:	6a 73                	push   $0x73
  jmp alltraps
80107465:	e9 79 f5 ff ff       	jmp    801069e3 <alltraps>

8010746a <vector116>:
.globl vector116
vector116:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $116
8010746c:	6a 74                	push   $0x74
  jmp alltraps
8010746e:	e9 70 f5 ff ff       	jmp    801069e3 <alltraps>

80107473 <vector117>:
.globl vector117
vector117:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $117
80107475:	6a 75                	push   $0x75
  jmp alltraps
80107477:	e9 67 f5 ff ff       	jmp    801069e3 <alltraps>

8010747c <vector118>:
.globl vector118
vector118:
  pushl $0
8010747c:	6a 00                	push   $0x0
  pushl $118
8010747e:	6a 76                	push   $0x76
  jmp alltraps
80107480:	e9 5e f5 ff ff       	jmp    801069e3 <alltraps>

80107485 <vector119>:
.globl vector119
vector119:
  pushl $0
80107485:	6a 00                	push   $0x0
  pushl $119
80107487:	6a 77                	push   $0x77
  jmp alltraps
80107489:	e9 55 f5 ff ff       	jmp    801069e3 <alltraps>

8010748e <vector120>:
.globl vector120
vector120:
  pushl $0
8010748e:	6a 00                	push   $0x0
  pushl $120
80107490:	6a 78                	push   $0x78
  jmp alltraps
80107492:	e9 4c f5 ff ff       	jmp    801069e3 <alltraps>

80107497 <vector121>:
.globl vector121
vector121:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $121
80107499:	6a 79                	push   $0x79
  jmp alltraps
8010749b:	e9 43 f5 ff ff       	jmp    801069e3 <alltraps>

801074a0 <vector122>:
.globl vector122
vector122:
  pushl $0
801074a0:	6a 00                	push   $0x0
  pushl $122
801074a2:	6a 7a                	push   $0x7a
  jmp alltraps
801074a4:	e9 3a f5 ff ff       	jmp    801069e3 <alltraps>

801074a9 <vector123>:
.globl vector123
vector123:
  pushl $0
801074a9:	6a 00                	push   $0x0
  pushl $123
801074ab:	6a 7b                	push   $0x7b
  jmp alltraps
801074ad:	e9 31 f5 ff ff       	jmp    801069e3 <alltraps>

801074b2 <vector124>:
.globl vector124
vector124:
  pushl $0
801074b2:	6a 00                	push   $0x0
  pushl $124
801074b4:	6a 7c                	push   $0x7c
  jmp alltraps
801074b6:	e9 28 f5 ff ff       	jmp    801069e3 <alltraps>

801074bb <vector125>:
.globl vector125
vector125:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $125
801074bd:	6a 7d                	push   $0x7d
  jmp alltraps
801074bf:	e9 1f f5 ff ff       	jmp    801069e3 <alltraps>

801074c4 <vector126>:
.globl vector126
vector126:
  pushl $0
801074c4:	6a 00                	push   $0x0
  pushl $126
801074c6:	6a 7e                	push   $0x7e
  jmp alltraps
801074c8:	e9 16 f5 ff ff       	jmp    801069e3 <alltraps>

801074cd <vector127>:
.globl vector127
vector127:
  pushl $0
801074cd:	6a 00                	push   $0x0
  pushl $127
801074cf:	6a 7f                	push   $0x7f
  jmp alltraps
801074d1:	e9 0d f5 ff ff       	jmp    801069e3 <alltraps>

801074d6 <vector128>:
.globl vector128
vector128:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $128
801074d8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801074dd:	e9 01 f5 ff ff       	jmp    801069e3 <alltraps>

801074e2 <vector129>:
.globl vector129
vector129:
  pushl $0
801074e2:	6a 00                	push   $0x0
  pushl $129
801074e4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801074e9:	e9 f5 f4 ff ff       	jmp    801069e3 <alltraps>

801074ee <vector130>:
.globl vector130
vector130:
  pushl $0
801074ee:	6a 00                	push   $0x0
  pushl $130
801074f0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801074f5:	e9 e9 f4 ff ff       	jmp    801069e3 <alltraps>

801074fa <vector131>:
.globl vector131
vector131:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $131
801074fc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107501:	e9 dd f4 ff ff       	jmp    801069e3 <alltraps>

80107506 <vector132>:
.globl vector132
vector132:
  pushl $0
80107506:	6a 00                	push   $0x0
  pushl $132
80107508:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010750d:	e9 d1 f4 ff ff       	jmp    801069e3 <alltraps>

80107512 <vector133>:
.globl vector133
vector133:
  pushl $0
80107512:	6a 00                	push   $0x0
  pushl $133
80107514:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107519:	e9 c5 f4 ff ff       	jmp    801069e3 <alltraps>

8010751e <vector134>:
.globl vector134
vector134:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $134
80107520:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107525:	e9 b9 f4 ff ff       	jmp    801069e3 <alltraps>

8010752a <vector135>:
.globl vector135
vector135:
  pushl $0
8010752a:	6a 00                	push   $0x0
  pushl $135
8010752c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107531:	e9 ad f4 ff ff       	jmp    801069e3 <alltraps>

80107536 <vector136>:
.globl vector136
vector136:
  pushl $0
80107536:	6a 00                	push   $0x0
  pushl $136
80107538:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010753d:	e9 a1 f4 ff ff       	jmp    801069e3 <alltraps>

80107542 <vector137>:
.globl vector137
vector137:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $137
80107544:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107549:	e9 95 f4 ff ff       	jmp    801069e3 <alltraps>

8010754e <vector138>:
.globl vector138
vector138:
  pushl $0
8010754e:	6a 00                	push   $0x0
  pushl $138
80107550:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107555:	e9 89 f4 ff ff       	jmp    801069e3 <alltraps>

8010755a <vector139>:
.globl vector139
vector139:
  pushl $0
8010755a:	6a 00                	push   $0x0
  pushl $139
8010755c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107561:	e9 7d f4 ff ff       	jmp    801069e3 <alltraps>

80107566 <vector140>:
.globl vector140
vector140:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $140
80107568:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010756d:	e9 71 f4 ff ff       	jmp    801069e3 <alltraps>

80107572 <vector141>:
.globl vector141
vector141:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $141
80107574:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107579:	e9 65 f4 ff ff       	jmp    801069e3 <alltraps>

8010757e <vector142>:
.globl vector142
vector142:
  pushl $0
8010757e:	6a 00                	push   $0x0
  pushl $142
80107580:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107585:	e9 59 f4 ff ff       	jmp    801069e3 <alltraps>

8010758a <vector143>:
.globl vector143
vector143:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $143
8010758c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107591:	e9 4d f4 ff ff       	jmp    801069e3 <alltraps>

80107596 <vector144>:
.globl vector144
vector144:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $144
80107598:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010759d:	e9 41 f4 ff ff       	jmp    801069e3 <alltraps>

801075a2 <vector145>:
.globl vector145
vector145:
  pushl $0
801075a2:	6a 00                	push   $0x0
  pushl $145
801075a4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801075a9:	e9 35 f4 ff ff       	jmp    801069e3 <alltraps>

801075ae <vector146>:
.globl vector146
vector146:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $146
801075b0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801075b5:	e9 29 f4 ff ff       	jmp    801069e3 <alltraps>

801075ba <vector147>:
.globl vector147
vector147:
  pushl $0
801075ba:	6a 00                	push   $0x0
  pushl $147
801075bc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801075c1:	e9 1d f4 ff ff       	jmp    801069e3 <alltraps>

801075c6 <vector148>:
.globl vector148
vector148:
  pushl $0
801075c6:	6a 00                	push   $0x0
  pushl $148
801075c8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801075cd:	e9 11 f4 ff ff       	jmp    801069e3 <alltraps>

801075d2 <vector149>:
.globl vector149
vector149:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $149
801075d4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801075d9:	e9 05 f4 ff ff       	jmp    801069e3 <alltraps>

801075de <vector150>:
.globl vector150
vector150:
  pushl $0
801075de:	6a 00                	push   $0x0
  pushl $150
801075e0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801075e5:	e9 f9 f3 ff ff       	jmp    801069e3 <alltraps>

801075ea <vector151>:
.globl vector151
vector151:
  pushl $0
801075ea:	6a 00                	push   $0x0
  pushl $151
801075ec:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801075f1:	e9 ed f3 ff ff       	jmp    801069e3 <alltraps>

801075f6 <vector152>:
.globl vector152
vector152:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $152
801075f8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801075fd:	e9 e1 f3 ff ff       	jmp    801069e3 <alltraps>

80107602 <vector153>:
.globl vector153
vector153:
  pushl $0
80107602:	6a 00                	push   $0x0
  pushl $153
80107604:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107609:	e9 d5 f3 ff ff       	jmp    801069e3 <alltraps>

8010760e <vector154>:
.globl vector154
vector154:
  pushl $0
8010760e:	6a 00                	push   $0x0
  pushl $154
80107610:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107615:	e9 c9 f3 ff ff       	jmp    801069e3 <alltraps>

8010761a <vector155>:
.globl vector155
vector155:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $155
8010761c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107621:	e9 bd f3 ff ff       	jmp    801069e3 <alltraps>

80107626 <vector156>:
.globl vector156
vector156:
  pushl $0
80107626:	6a 00                	push   $0x0
  pushl $156
80107628:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010762d:	e9 b1 f3 ff ff       	jmp    801069e3 <alltraps>

80107632 <vector157>:
.globl vector157
vector157:
  pushl $0
80107632:	6a 00                	push   $0x0
  pushl $157
80107634:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107639:	e9 a5 f3 ff ff       	jmp    801069e3 <alltraps>

8010763e <vector158>:
.globl vector158
vector158:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $158
80107640:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107645:	e9 99 f3 ff ff       	jmp    801069e3 <alltraps>

8010764a <vector159>:
.globl vector159
vector159:
  pushl $0
8010764a:	6a 00                	push   $0x0
  pushl $159
8010764c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107651:	e9 8d f3 ff ff       	jmp    801069e3 <alltraps>

80107656 <vector160>:
.globl vector160
vector160:
  pushl $0
80107656:	6a 00                	push   $0x0
  pushl $160
80107658:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010765d:	e9 81 f3 ff ff       	jmp    801069e3 <alltraps>

80107662 <vector161>:
.globl vector161
vector161:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $161
80107664:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107669:	e9 75 f3 ff ff       	jmp    801069e3 <alltraps>

8010766e <vector162>:
.globl vector162
vector162:
  pushl $0
8010766e:	6a 00                	push   $0x0
  pushl $162
80107670:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107675:	e9 69 f3 ff ff       	jmp    801069e3 <alltraps>

8010767a <vector163>:
.globl vector163
vector163:
  pushl $0
8010767a:	6a 00                	push   $0x0
  pushl $163
8010767c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107681:	e9 5d f3 ff ff       	jmp    801069e3 <alltraps>

80107686 <vector164>:
.globl vector164
vector164:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $164
80107688:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010768d:	e9 51 f3 ff ff       	jmp    801069e3 <alltraps>

80107692 <vector165>:
.globl vector165
vector165:
  pushl $0
80107692:	6a 00                	push   $0x0
  pushl $165
80107694:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107699:	e9 45 f3 ff ff       	jmp    801069e3 <alltraps>

8010769e <vector166>:
.globl vector166
vector166:
  pushl $0
8010769e:	6a 00                	push   $0x0
  pushl $166
801076a0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801076a5:	e9 39 f3 ff ff       	jmp    801069e3 <alltraps>

801076aa <vector167>:
.globl vector167
vector167:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $167
801076ac:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801076b1:	e9 2d f3 ff ff       	jmp    801069e3 <alltraps>

801076b6 <vector168>:
.globl vector168
vector168:
  pushl $0
801076b6:	6a 00                	push   $0x0
  pushl $168
801076b8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801076bd:	e9 21 f3 ff ff       	jmp    801069e3 <alltraps>

801076c2 <vector169>:
.globl vector169
vector169:
  pushl $0
801076c2:	6a 00                	push   $0x0
  pushl $169
801076c4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801076c9:	e9 15 f3 ff ff       	jmp    801069e3 <alltraps>

801076ce <vector170>:
.globl vector170
vector170:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $170
801076d0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801076d5:	e9 09 f3 ff ff       	jmp    801069e3 <alltraps>

801076da <vector171>:
.globl vector171
vector171:
  pushl $0
801076da:	6a 00                	push   $0x0
  pushl $171
801076dc:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801076e1:	e9 fd f2 ff ff       	jmp    801069e3 <alltraps>

801076e6 <vector172>:
.globl vector172
vector172:
  pushl $0
801076e6:	6a 00                	push   $0x0
  pushl $172
801076e8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801076ed:	e9 f1 f2 ff ff       	jmp    801069e3 <alltraps>

801076f2 <vector173>:
.globl vector173
vector173:
  pushl $0
801076f2:	6a 00                	push   $0x0
  pushl $173
801076f4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801076f9:	e9 e5 f2 ff ff       	jmp    801069e3 <alltraps>

801076fe <vector174>:
.globl vector174
vector174:
  pushl $0
801076fe:	6a 00                	push   $0x0
  pushl $174
80107700:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107705:	e9 d9 f2 ff ff       	jmp    801069e3 <alltraps>

8010770a <vector175>:
.globl vector175
vector175:
  pushl $0
8010770a:	6a 00                	push   $0x0
  pushl $175
8010770c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107711:	e9 cd f2 ff ff       	jmp    801069e3 <alltraps>

80107716 <vector176>:
.globl vector176
vector176:
  pushl $0
80107716:	6a 00                	push   $0x0
  pushl $176
80107718:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010771d:	e9 c1 f2 ff ff       	jmp    801069e3 <alltraps>

80107722 <vector177>:
.globl vector177
vector177:
  pushl $0
80107722:	6a 00                	push   $0x0
  pushl $177
80107724:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107729:	e9 b5 f2 ff ff       	jmp    801069e3 <alltraps>

8010772e <vector178>:
.globl vector178
vector178:
  pushl $0
8010772e:	6a 00                	push   $0x0
  pushl $178
80107730:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107735:	e9 a9 f2 ff ff       	jmp    801069e3 <alltraps>

8010773a <vector179>:
.globl vector179
vector179:
  pushl $0
8010773a:	6a 00                	push   $0x0
  pushl $179
8010773c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107741:	e9 9d f2 ff ff       	jmp    801069e3 <alltraps>

80107746 <vector180>:
.globl vector180
vector180:
  pushl $0
80107746:	6a 00                	push   $0x0
  pushl $180
80107748:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010774d:	e9 91 f2 ff ff       	jmp    801069e3 <alltraps>

80107752 <vector181>:
.globl vector181
vector181:
  pushl $0
80107752:	6a 00                	push   $0x0
  pushl $181
80107754:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107759:	e9 85 f2 ff ff       	jmp    801069e3 <alltraps>

8010775e <vector182>:
.globl vector182
vector182:
  pushl $0
8010775e:	6a 00                	push   $0x0
  pushl $182
80107760:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107765:	e9 79 f2 ff ff       	jmp    801069e3 <alltraps>

8010776a <vector183>:
.globl vector183
vector183:
  pushl $0
8010776a:	6a 00                	push   $0x0
  pushl $183
8010776c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107771:	e9 6d f2 ff ff       	jmp    801069e3 <alltraps>

80107776 <vector184>:
.globl vector184
vector184:
  pushl $0
80107776:	6a 00                	push   $0x0
  pushl $184
80107778:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010777d:	e9 61 f2 ff ff       	jmp    801069e3 <alltraps>

80107782 <vector185>:
.globl vector185
vector185:
  pushl $0
80107782:	6a 00                	push   $0x0
  pushl $185
80107784:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107789:	e9 55 f2 ff ff       	jmp    801069e3 <alltraps>

8010778e <vector186>:
.globl vector186
vector186:
  pushl $0
8010778e:	6a 00                	push   $0x0
  pushl $186
80107790:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107795:	e9 49 f2 ff ff       	jmp    801069e3 <alltraps>

8010779a <vector187>:
.globl vector187
vector187:
  pushl $0
8010779a:	6a 00                	push   $0x0
  pushl $187
8010779c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801077a1:	e9 3d f2 ff ff       	jmp    801069e3 <alltraps>

801077a6 <vector188>:
.globl vector188
vector188:
  pushl $0
801077a6:	6a 00                	push   $0x0
  pushl $188
801077a8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801077ad:	e9 31 f2 ff ff       	jmp    801069e3 <alltraps>

801077b2 <vector189>:
.globl vector189
vector189:
  pushl $0
801077b2:	6a 00                	push   $0x0
  pushl $189
801077b4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801077b9:	e9 25 f2 ff ff       	jmp    801069e3 <alltraps>

801077be <vector190>:
.globl vector190
vector190:
  pushl $0
801077be:	6a 00                	push   $0x0
  pushl $190
801077c0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801077c5:	e9 19 f2 ff ff       	jmp    801069e3 <alltraps>

801077ca <vector191>:
.globl vector191
vector191:
  pushl $0
801077ca:	6a 00                	push   $0x0
  pushl $191
801077cc:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801077d1:	e9 0d f2 ff ff       	jmp    801069e3 <alltraps>

801077d6 <vector192>:
.globl vector192
vector192:
  pushl $0
801077d6:	6a 00                	push   $0x0
  pushl $192
801077d8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801077dd:	e9 01 f2 ff ff       	jmp    801069e3 <alltraps>

801077e2 <vector193>:
.globl vector193
vector193:
  pushl $0
801077e2:	6a 00                	push   $0x0
  pushl $193
801077e4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801077e9:	e9 f5 f1 ff ff       	jmp    801069e3 <alltraps>

801077ee <vector194>:
.globl vector194
vector194:
  pushl $0
801077ee:	6a 00                	push   $0x0
  pushl $194
801077f0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801077f5:	e9 e9 f1 ff ff       	jmp    801069e3 <alltraps>

801077fa <vector195>:
.globl vector195
vector195:
  pushl $0
801077fa:	6a 00                	push   $0x0
  pushl $195
801077fc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107801:	e9 dd f1 ff ff       	jmp    801069e3 <alltraps>

80107806 <vector196>:
.globl vector196
vector196:
  pushl $0
80107806:	6a 00                	push   $0x0
  pushl $196
80107808:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010780d:	e9 d1 f1 ff ff       	jmp    801069e3 <alltraps>

80107812 <vector197>:
.globl vector197
vector197:
  pushl $0
80107812:	6a 00                	push   $0x0
  pushl $197
80107814:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107819:	e9 c5 f1 ff ff       	jmp    801069e3 <alltraps>

8010781e <vector198>:
.globl vector198
vector198:
  pushl $0
8010781e:	6a 00                	push   $0x0
  pushl $198
80107820:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107825:	e9 b9 f1 ff ff       	jmp    801069e3 <alltraps>

8010782a <vector199>:
.globl vector199
vector199:
  pushl $0
8010782a:	6a 00                	push   $0x0
  pushl $199
8010782c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107831:	e9 ad f1 ff ff       	jmp    801069e3 <alltraps>

80107836 <vector200>:
.globl vector200
vector200:
  pushl $0
80107836:	6a 00                	push   $0x0
  pushl $200
80107838:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010783d:	e9 a1 f1 ff ff       	jmp    801069e3 <alltraps>

80107842 <vector201>:
.globl vector201
vector201:
  pushl $0
80107842:	6a 00                	push   $0x0
  pushl $201
80107844:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107849:	e9 95 f1 ff ff       	jmp    801069e3 <alltraps>

8010784e <vector202>:
.globl vector202
vector202:
  pushl $0
8010784e:	6a 00                	push   $0x0
  pushl $202
80107850:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107855:	e9 89 f1 ff ff       	jmp    801069e3 <alltraps>

8010785a <vector203>:
.globl vector203
vector203:
  pushl $0
8010785a:	6a 00                	push   $0x0
  pushl $203
8010785c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107861:	e9 7d f1 ff ff       	jmp    801069e3 <alltraps>

80107866 <vector204>:
.globl vector204
vector204:
  pushl $0
80107866:	6a 00                	push   $0x0
  pushl $204
80107868:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010786d:	e9 71 f1 ff ff       	jmp    801069e3 <alltraps>

80107872 <vector205>:
.globl vector205
vector205:
  pushl $0
80107872:	6a 00                	push   $0x0
  pushl $205
80107874:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107879:	e9 65 f1 ff ff       	jmp    801069e3 <alltraps>

8010787e <vector206>:
.globl vector206
vector206:
  pushl $0
8010787e:	6a 00                	push   $0x0
  pushl $206
80107880:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107885:	e9 59 f1 ff ff       	jmp    801069e3 <alltraps>

8010788a <vector207>:
.globl vector207
vector207:
  pushl $0
8010788a:	6a 00                	push   $0x0
  pushl $207
8010788c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107891:	e9 4d f1 ff ff       	jmp    801069e3 <alltraps>

80107896 <vector208>:
.globl vector208
vector208:
  pushl $0
80107896:	6a 00                	push   $0x0
  pushl $208
80107898:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010789d:	e9 41 f1 ff ff       	jmp    801069e3 <alltraps>

801078a2 <vector209>:
.globl vector209
vector209:
  pushl $0
801078a2:	6a 00                	push   $0x0
  pushl $209
801078a4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801078a9:	e9 35 f1 ff ff       	jmp    801069e3 <alltraps>

801078ae <vector210>:
.globl vector210
vector210:
  pushl $0
801078ae:	6a 00                	push   $0x0
  pushl $210
801078b0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801078b5:	e9 29 f1 ff ff       	jmp    801069e3 <alltraps>

801078ba <vector211>:
.globl vector211
vector211:
  pushl $0
801078ba:	6a 00                	push   $0x0
  pushl $211
801078bc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801078c1:	e9 1d f1 ff ff       	jmp    801069e3 <alltraps>

801078c6 <vector212>:
.globl vector212
vector212:
  pushl $0
801078c6:	6a 00                	push   $0x0
  pushl $212
801078c8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801078cd:	e9 11 f1 ff ff       	jmp    801069e3 <alltraps>

801078d2 <vector213>:
.globl vector213
vector213:
  pushl $0
801078d2:	6a 00                	push   $0x0
  pushl $213
801078d4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801078d9:	e9 05 f1 ff ff       	jmp    801069e3 <alltraps>

801078de <vector214>:
.globl vector214
vector214:
  pushl $0
801078de:	6a 00                	push   $0x0
  pushl $214
801078e0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801078e5:	e9 f9 f0 ff ff       	jmp    801069e3 <alltraps>

801078ea <vector215>:
.globl vector215
vector215:
  pushl $0
801078ea:	6a 00                	push   $0x0
  pushl $215
801078ec:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801078f1:	e9 ed f0 ff ff       	jmp    801069e3 <alltraps>

801078f6 <vector216>:
.globl vector216
vector216:
  pushl $0
801078f6:	6a 00                	push   $0x0
  pushl $216
801078f8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801078fd:	e9 e1 f0 ff ff       	jmp    801069e3 <alltraps>

80107902 <vector217>:
.globl vector217
vector217:
  pushl $0
80107902:	6a 00                	push   $0x0
  pushl $217
80107904:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107909:	e9 d5 f0 ff ff       	jmp    801069e3 <alltraps>

8010790e <vector218>:
.globl vector218
vector218:
  pushl $0
8010790e:	6a 00                	push   $0x0
  pushl $218
80107910:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107915:	e9 c9 f0 ff ff       	jmp    801069e3 <alltraps>

8010791a <vector219>:
.globl vector219
vector219:
  pushl $0
8010791a:	6a 00                	push   $0x0
  pushl $219
8010791c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107921:	e9 bd f0 ff ff       	jmp    801069e3 <alltraps>

80107926 <vector220>:
.globl vector220
vector220:
  pushl $0
80107926:	6a 00                	push   $0x0
  pushl $220
80107928:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010792d:	e9 b1 f0 ff ff       	jmp    801069e3 <alltraps>

80107932 <vector221>:
.globl vector221
vector221:
  pushl $0
80107932:	6a 00                	push   $0x0
  pushl $221
80107934:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107939:	e9 a5 f0 ff ff       	jmp    801069e3 <alltraps>

8010793e <vector222>:
.globl vector222
vector222:
  pushl $0
8010793e:	6a 00                	push   $0x0
  pushl $222
80107940:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107945:	e9 99 f0 ff ff       	jmp    801069e3 <alltraps>

8010794a <vector223>:
.globl vector223
vector223:
  pushl $0
8010794a:	6a 00                	push   $0x0
  pushl $223
8010794c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107951:	e9 8d f0 ff ff       	jmp    801069e3 <alltraps>

80107956 <vector224>:
.globl vector224
vector224:
  pushl $0
80107956:	6a 00                	push   $0x0
  pushl $224
80107958:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010795d:	e9 81 f0 ff ff       	jmp    801069e3 <alltraps>

80107962 <vector225>:
.globl vector225
vector225:
  pushl $0
80107962:	6a 00                	push   $0x0
  pushl $225
80107964:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107969:	e9 75 f0 ff ff       	jmp    801069e3 <alltraps>

8010796e <vector226>:
.globl vector226
vector226:
  pushl $0
8010796e:	6a 00                	push   $0x0
  pushl $226
80107970:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107975:	e9 69 f0 ff ff       	jmp    801069e3 <alltraps>

8010797a <vector227>:
.globl vector227
vector227:
  pushl $0
8010797a:	6a 00                	push   $0x0
  pushl $227
8010797c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107981:	e9 5d f0 ff ff       	jmp    801069e3 <alltraps>

80107986 <vector228>:
.globl vector228
vector228:
  pushl $0
80107986:	6a 00                	push   $0x0
  pushl $228
80107988:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010798d:	e9 51 f0 ff ff       	jmp    801069e3 <alltraps>

80107992 <vector229>:
.globl vector229
vector229:
  pushl $0
80107992:	6a 00                	push   $0x0
  pushl $229
80107994:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107999:	e9 45 f0 ff ff       	jmp    801069e3 <alltraps>

8010799e <vector230>:
.globl vector230
vector230:
  pushl $0
8010799e:	6a 00                	push   $0x0
  pushl $230
801079a0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801079a5:	e9 39 f0 ff ff       	jmp    801069e3 <alltraps>

801079aa <vector231>:
.globl vector231
vector231:
  pushl $0
801079aa:	6a 00                	push   $0x0
  pushl $231
801079ac:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801079b1:	e9 2d f0 ff ff       	jmp    801069e3 <alltraps>

801079b6 <vector232>:
.globl vector232
vector232:
  pushl $0
801079b6:	6a 00                	push   $0x0
  pushl $232
801079b8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801079bd:	e9 21 f0 ff ff       	jmp    801069e3 <alltraps>

801079c2 <vector233>:
.globl vector233
vector233:
  pushl $0
801079c2:	6a 00                	push   $0x0
  pushl $233
801079c4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801079c9:	e9 15 f0 ff ff       	jmp    801069e3 <alltraps>

801079ce <vector234>:
.globl vector234
vector234:
  pushl $0
801079ce:	6a 00                	push   $0x0
  pushl $234
801079d0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801079d5:	e9 09 f0 ff ff       	jmp    801069e3 <alltraps>

801079da <vector235>:
.globl vector235
vector235:
  pushl $0
801079da:	6a 00                	push   $0x0
  pushl $235
801079dc:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801079e1:	e9 fd ef ff ff       	jmp    801069e3 <alltraps>

801079e6 <vector236>:
.globl vector236
vector236:
  pushl $0
801079e6:	6a 00                	push   $0x0
  pushl $236
801079e8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801079ed:	e9 f1 ef ff ff       	jmp    801069e3 <alltraps>

801079f2 <vector237>:
.globl vector237
vector237:
  pushl $0
801079f2:	6a 00                	push   $0x0
  pushl $237
801079f4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801079f9:	e9 e5 ef ff ff       	jmp    801069e3 <alltraps>

801079fe <vector238>:
.globl vector238
vector238:
  pushl $0
801079fe:	6a 00                	push   $0x0
  pushl $238
80107a00:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107a05:	e9 d9 ef ff ff       	jmp    801069e3 <alltraps>

80107a0a <vector239>:
.globl vector239
vector239:
  pushl $0
80107a0a:	6a 00                	push   $0x0
  pushl $239
80107a0c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107a11:	e9 cd ef ff ff       	jmp    801069e3 <alltraps>

80107a16 <vector240>:
.globl vector240
vector240:
  pushl $0
80107a16:	6a 00                	push   $0x0
  pushl $240
80107a18:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107a1d:	e9 c1 ef ff ff       	jmp    801069e3 <alltraps>

80107a22 <vector241>:
.globl vector241
vector241:
  pushl $0
80107a22:	6a 00                	push   $0x0
  pushl $241
80107a24:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107a29:	e9 b5 ef ff ff       	jmp    801069e3 <alltraps>

80107a2e <vector242>:
.globl vector242
vector242:
  pushl $0
80107a2e:	6a 00                	push   $0x0
  pushl $242
80107a30:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107a35:	e9 a9 ef ff ff       	jmp    801069e3 <alltraps>

80107a3a <vector243>:
.globl vector243
vector243:
  pushl $0
80107a3a:	6a 00                	push   $0x0
  pushl $243
80107a3c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107a41:	e9 9d ef ff ff       	jmp    801069e3 <alltraps>

80107a46 <vector244>:
.globl vector244
vector244:
  pushl $0
80107a46:	6a 00                	push   $0x0
  pushl $244
80107a48:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107a4d:	e9 91 ef ff ff       	jmp    801069e3 <alltraps>

80107a52 <vector245>:
.globl vector245
vector245:
  pushl $0
80107a52:	6a 00                	push   $0x0
  pushl $245
80107a54:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107a59:	e9 85 ef ff ff       	jmp    801069e3 <alltraps>

80107a5e <vector246>:
.globl vector246
vector246:
  pushl $0
80107a5e:	6a 00                	push   $0x0
  pushl $246
80107a60:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107a65:	e9 79 ef ff ff       	jmp    801069e3 <alltraps>

80107a6a <vector247>:
.globl vector247
vector247:
  pushl $0
80107a6a:	6a 00                	push   $0x0
  pushl $247
80107a6c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107a71:	e9 6d ef ff ff       	jmp    801069e3 <alltraps>

80107a76 <vector248>:
.globl vector248
vector248:
  pushl $0
80107a76:	6a 00                	push   $0x0
  pushl $248
80107a78:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107a7d:	e9 61 ef ff ff       	jmp    801069e3 <alltraps>

80107a82 <vector249>:
.globl vector249
vector249:
  pushl $0
80107a82:	6a 00                	push   $0x0
  pushl $249
80107a84:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107a89:	e9 55 ef ff ff       	jmp    801069e3 <alltraps>

80107a8e <vector250>:
.globl vector250
vector250:
  pushl $0
80107a8e:	6a 00                	push   $0x0
  pushl $250
80107a90:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107a95:	e9 49 ef ff ff       	jmp    801069e3 <alltraps>

80107a9a <vector251>:
.globl vector251
vector251:
  pushl $0
80107a9a:	6a 00                	push   $0x0
  pushl $251
80107a9c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107aa1:	e9 3d ef ff ff       	jmp    801069e3 <alltraps>

80107aa6 <vector252>:
.globl vector252
vector252:
  pushl $0
80107aa6:	6a 00                	push   $0x0
  pushl $252
80107aa8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107aad:	e9 31 ef ff ff       	jmp    801069e3 <alltraps>

80107ab2 <vector253>:
.globl vector253
vector253:
  pushl $0
80107ab2:	6a 00                	push   $0x0
  pushl $253
80107ab4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107ab9:	e9 25 ef ff ff       	jmp    801069e3 <alltraps>

80107abe <vector254>:
.globl vector254
vector254:
  pushl $0
80107abe:	6a 00                	push   $0x0
  pushl $254
80107ac0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107ac5:	e9 19 ef ff ff       	jmp    801069e3 <alltraps>

80107aca <vector255>:
.globl vector255
vector255:
  pushl $0
80107aca:	6a 00                	push   $0x0
  pushl $255
80107acc:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107ad1:	e9 0d ef ff ff       	jmp    801069e3 <alltraps>

80107ad6 <lgdt>:
{
80107ad6:	55                   	push   %ebp
80107ad7:	89 e5                	mov    %esp,%ebp
80107ad9:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107adc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107adf:	83 e8 01             	sub    $0x1,%eax
80107ae2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80107ae9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107aed:	8b 45 08             	mov    0x8(%ebp),%eax
80107af0:	c1 e8 10             	shr    $0x10,%eax
80107af3:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107af7:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107afa:	0f 01 10             	lgdtl  (%eax)
}
80107afd:	90                   	nop
80107afe:	c9                   	leave  
80107aff:	c3                   	ret    

80107b00 <ltr>:
{
80107b00:	55                   	push   %ebp
80107b01:	89 e5                	mov    %esp,%ebp
80107b03:	83 ec 04             	sub    $0x4,%esp
80107b06:	8b 45 08             	mov    0x8(%ebp),%eax
80107b09:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107b0d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107b11:	0f 00 d8             	ltr    %ax
}
80107b14:	90                   	nop
80107b15:	c9                   	leave  
80107b16:	c3                   	ret    

80107b17 <lcr3>:

static inline void
lcr3(uint val)
{
80107b17:	55                   	push   %ebp
80107b18:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80107b1d:	0f 22 d8             	mov    %eax,%cr3
}
80107b20:	90                   	nop
80107b21:	5d                   	pop    %ebp
80107b22:	c3                   	ret    

80107b23 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107b23:	f3 0f 1e fb          	endbr32 
80107b27:	55                   	push   %ebp
80107b28:	89 e5                	mov    %esp,%ebp
80107b2a:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107b2d:	e8 c2 c8 ff ff       	call   801043f4 <cpuid>
80107b32:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107b38:	05 20 48 11 80       	add    $0x80114820,%eax
80107b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b43:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b4c:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b55:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b5c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107b60:	83 e2 f0             	and    $0xfffffff0,%edx
80107b63:	83 ca 0a             	or     $0xa,%edx
80107b66:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107b70:	83 ca 10             	or     $0x10,%edx
80107b73:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b79:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107b7d:	83 e2 9f             	and    $0xffffff9f,%edx
80107b80:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b86:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107b8a:	83 ca 80             	or     $0xffffff80,%edx
80107b8d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b93:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107b97:	83 ca 0f             	or     $0xf,%edx
80107b9a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ba4:	83 e2 ef             	and    $0xffffffef,%edx
80107ba7:	88 50 7e             	mov    %dl,0x7e(%eax)
80107baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bad:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107bb1:	83 e2 df             	and    $0xffffffdf,%edx
80107bb4:	88 50 7e             	mov    %dl,0x7e(%eax)
80107bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bba:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107bbe:	83 ca 40             	or     $0x40,%edx
80107bc1:	88 50 7e             	mov    %dl,0x7e(%eax)
80107bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc7:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107bcb:	83 ca 80             	or     $0xffffff80,%edx
80107bce:	88 50 7e             	mov    %dl,0x7e(%eax)
80107bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd4:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bdb:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107be2:	ff ff 
80107be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be7:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107bee:	00 00 
80107bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf3:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bfd:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107c04:	83 e2 f0             	and    $0xfffffff0,%edx
80107c07:	83 ca 02             	or     $0x2,%edx
80107c0a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c13:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107c1a:	83 ca 10             	or     $0x10,%edx
80107c1d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c26:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107c2d:	83 e2 9f             	and    $0xffffff9f,%edx
80107c30:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c39:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107c40:	83 ca 80             	or     $0xffffff80,%edx
80107c43:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c4c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107c53:	83 ca 0f             	or     $0xf,%edx
80107c56:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107c66:	83 e2 ef             	and    $0xffffffef,%edx
80107c69:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c72:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107c79:	83 e2 df             	and    $0xffffffdf,%edx
80107c7c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c85:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107c8c:	83 ca 40             	or     $0x40,%edx
80107c8f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c98:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107c9f:	83 ca 80             	or     $0xffffff80,%edx
80107ca2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cab:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb5:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107cbc:	ff ff 
80107cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc1:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107cc8:	00 00 
80107cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccd:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd7:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107cde:	83 e2 f0             	and    $0xfffffff0,%edx
80107ce1:	83 ca 0a             	or     $0xa,%edx
80107ce4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ced:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107cf4:	83 ca 10             	or     $0x10,%edx
80107cf7:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d00:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107d07:	83 ca 60             	or     $0x60,%edx
80107d0a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d13:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107d1a:	83 ca 80             	or     $0xffffff80,%edx
80107d1d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d26:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107d2d:	83 ca 0f             	or     $0xf,%edx
80107d30:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d39:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107d40:	83 e2 ef             	and    $0xffffffef,%edx
80107d43:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107d53:	83 e2 df             	and    $0xffffffdf,%edx
80107d56:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107d66:	83 ca 40             	or     $0x40,%edx
80107d69:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d72:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107d79:	83 ca 80             	or     $0xffffff80,%edx
80107d7c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d85:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8f:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107d96:	ff ff 
80107d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9b:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107da2:	00 00 
80107da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da7:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db1:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107db8:	83 e2 f0             	and    $0xfffffff0,%edx
80107dbb:	83 ca 02             	or     $0x2,%edx
80107dbe:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc7:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107dce:	83 ca 10             	or     $0x10,%edx
80107dd1:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dda:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107de1:	83 ca 60             	or     $0x60,%edx
80107de4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ded:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107df4:	83 ca 80             	or     $0xffffff80,%edx
80107df7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e00:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e07:	83 ca 0f             	or     $0xf,%edx
80107e0a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e13:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e1a:	83 e2 ef             	and    $0xffffffef,%edx
80107e1d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e26:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e2d:	83 e2 df             	and    $0xffffffdf,%edx
80107e30:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e39:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e40:	83 ca 40             	or     $0x40,%edx
80107e43:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e53:	83 ca 80             	or     $0xffffff80,%edx
80107e56:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5f:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e69:	83 c0 70             	add    $0x70,%eax
80107e6c:	83 ec 08             	sub    $0x8,%esp
80107e6f:	6a 30                	push   $0x30
80107e71:	50                   	push   %eax
80107e72:	e8 5f fc ff ff       	call   80107ad6 <lgdt>
80107e77:	83 c4 10             	add    $0x10,%esp
}
80107e7a:	90                   	nop
80107e7b:	c9                   	leave  
80107e7c:	c3                   	ret    

80107e7d <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107e7d:	f3 0f 1e fb          	endbr32 
80107e81:	55                   	push   %ebp
80107e82:	89 e5                	mov    %esp,%ebp
80107e84:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107e87:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e8a:	c1 e8 16             	shr    $0x16,%eax
80107e8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107e94:	8b 45 08             	mov    0x8(%ebp),%eax
80107e97:	01 d0                	add    %edx,%eax
80107e99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e9f:	8b 00                	mov    (%eax),%eax
80107ea1:	83 e0 01             	and    $0x1,%eax
80107ea4:	85 c0                	test   %eax,%eax
80107ea6:	74 14                	je     80107ebc <walkpgdir+0x3f>
    //if (!alloc)
      //cprintf("page directory is good\n");
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107eab:	8b 00                	mov    (%eax),%eax
80107ead:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107eb2:	05 00 00 00 80       	add    $0x80000000,%eax
80107eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107eba:	eb 42                	jmp    80107efe <walkpgdir+0x81>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107ebc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107ec0:	74 0e                	je     80107ed0 <walkpgdir+0x53>
80107ec2:	e8 04 af ff ff       	call   80102dcb <kalloc>
80107ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ece:	75 07                	jne    80107ed7 <walkpgdir+0x5a>
      return 0;
80107ed0:	b8 00 00 00 00       	mov    $0x0,%eax
80107ed5:	eb 3e                	jmp    80107f15 <walkpgdir+0x98>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107ed7:	83 ec 04             	sub    $0x4,%esp
80107eda:	68 00 10 00 00       	push   $0x1000
80107edf:	6a 00                	push   $0x0
80107ee1:	ff 75 f4             	pushl  -0xc(%ebp)
80107ee4:	e8 9c d5 ff ff       	call   80105485 <memset>
80107ee9:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eef:	05 00 00 00 80       	add    $0x80000000,%eax
80107ef4:	83 c8 07             	or     $0x7,%eax
80107ef7:	89 c2                	mov    %eax,%edx
80107ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107efc:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107efe:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f01:	c1 e8 0c             	shr    $0xc,%eax
80107f04:	25 ff 03 00 00       	and    $0x3ff,%eax
80107f09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f13:	01 d0                	add    %edx,%eax
}
80107f15:	c9                   	leave  
80107f16:	c3                   	ret    

80107f17 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107f17:	f3 0f 1e fb          	endbr32 
80107f1b:	55                   	push   %ebp
80107f1c:	89 e5                	mov    %esp,%ebp
80107f1e:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107f21:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f24:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107f2c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f2f:	8b 45 10             	mov    0x10(%ebp),%eax
80107f32:	01 d0                	add    %edx,%eax
80107f34:	83 e8 01             	sub    $0x1,%eax
80107f37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107f3f:	83 ec 04             	sub    $0x4,%esp
80107f42:	6a 01                	push   $0x1
80107f44:	ff 75 f4             	pushl  -0xc(%ebp)
80107f47:	ff 75 08             	pushl  0x8(%ebp)
80107f4a:	e8 2e ff ff ff       	call   80107e7d <walkpgdir>
80107f4f:	83 c4 10             	add    $0x10,%esp
80107f52:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f55:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f59:	75 07                	jne    80107f62 <mappages+0x4b>
      return -1;
80107f5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f60:	eb 6a                	jmp    80107fcc <mappages+0xb5>
    if(*pte & (PTE_P | PTE_E))
80107f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f65:	8b 00                	mov    (%eax),%eax
80107f67:	25 01 04 00 00       	and    $0x401,%eax
80107f6c:	85 c0                	test   %eax,%eax
80107f6e:	74 0d                	je     80107f7d <mappages+0x66>
      panic("p4Debug, remapping page");
80107f70:	83 ec 0c             	sub    $0xc,%esp
80107f73:	68 34 96 10 80       	push   $0x80109634
80107f78:	e8 8b 86 ff ff       	call   80100608 <panic>

    if (perm & PTE_E)
80107f7d:	8b 45 18             	mov    0x18(%ebp),%eax
80107f80:	25 00 04 00 00       	and    $0x400,%eax
80107f85:	85 c0                	test   %eax,%eax
80107f87:	74 12                	je     80107f9b <mappages+0x84>
      *pte = pa | perm | PTE_E;
80107f89:	8b 45 18             	mov    0x18(%ebp),%eax
80107f8c:	0b 45 14             	or     0x14(%ebp),%eax
80107f8f:	80 cc 04             	or     $0x4,%ah
80107f92:	89 c2                	mov    %eax,%edx
80107f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f97:	89 10                	mov    %edx,(%eax)
80107f99:	eb 10                	jmp    80107fab <mappages+0x94>
    else
      *pte = pa | perm | PTE_P;
80107f9b:	8b 45 18             	mov    0x18(%ebp),%eax
80107f9e:	0b 45 14             	or     0x14(%ebp),%eax
80107fa1:	83 c8 01             	or     $0x1,%eax
80107fa4:	89 c2                	mov    %eax,%edx
80107fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fa9:	89 10                	mov    %edx,(%eax)


    if(a == last)
80107fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107fb1:	74 13                	je     80107fc6 <mappages+0xaf>
      break;
    a += PGSIZE;
80107fb3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107fba:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107fc1:	e9 79 ff ff ff       	jmp    80107f3f <mappages+0x28>
      break;
80107fc6:	90                   	nop
  }
  return 0;
80107fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fcc:	c9                   	leave  
80107fcd:	c3                   	ret    

80107fce <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107fce:	f3 0f 1e fb          	endbr32 
80107fd2:	55                   	push   %ebp
80107fd3:	89 e5                	mov    %esp,%ebp
80107fd5:	53                   	push   %ebx
80107fd6:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107fd9:	e8 ed ad ff ff       	call   80102dcb <kalloc>
80107fde:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fe1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107fe5:	75 07                	jne    80107fee <setupkvm+0x20>
    return 0;
80107fe7:	b8 00 00 00 00       	mov    $0x0,%eax
80107fec:	eb 78                	jmp    80108066 <setupkvm+0x98>
  memset(pgdir, 0, PGSIZE);
80107fee:	83 ec 04             	sub    $0x4,%esp
80107ff1:	68 00 10 00 00       	push   $0x1000
80107ff6:	6a 00                	push   $0x0
80107ff8:	ff 75 f0             	pushl  -0x10(%ebp)
80107ffb:	e8 85 d4 ff ff       	call   80105485 <memset>
80108000:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108003:	c7 45 f4 a0 c4 10 80 	movl   $0x8010c4a0,-0xc(%ebp)
8010800a:	eb 4e                	jmp    8010805a <setupkvm+0x8c>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010800c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800f:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80108012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108015:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801b:	8b 58 08             	mov    0x8(%eax),%ebx
8010801e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108021:	8b 40 04             	mov    0x4(%eax),%eax
80108024:	29 c3                	sub    %eax,%ebx
80108026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108029:	8b 00                	mov    (%eax),%eax
8010802b:	83 ec 0c             	sub    $0xc,%esp
8010802e:	51                   	push   %ecx
8010802f:	52                   	push   %edx
80108030:	53                   	push   %ebx
80108031:	50                   	push   %eax
80108032:	ff 75 f0             	pushl  -0x10(%ebp)
80108035:	e8 dd fe ff ff       	call   80107f17 <mappages>
8010803a:	83 c4 20             	add    $0x20,%esp
8010803d:	85 c0                	test   %eax,%eax
8010803f:	79 15                	jns    80108056 <setupkvm+0x88>
      freevm(pgdir);
80108041:	83 ec 0c             	sub    $0xc,%esp
80108044:	ff 75 f0             	pushl  -0x10(%ebp)
80108047:	e8 13 05 00 00       	call   8010855f <freevm>
8010804c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010804f:	b8 00 00 00 00       	mov    $0x0,%eax
80108054:	eb 10                	jmp    80108066 <setupkvm+0x98>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108056:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010805a:	81 7d f4 e0 c4 10 80 	cmpl   $0x8010c4e0,-0xc(%ebp)
80108061:	72 a9                	jb     8010800c <setupkvm+0x3e>
    }
  return pgdir;
80108063:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108066:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108069:	c9                   	leave  
8010806a:	c3                   	ret    

8010806b <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010806b:	f3 0f 1e fb          	endbr32 
8010806f:	55                   	push   %ebp
80108070:	89 e5                	mov    %esp,%ebp
80108072:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108075:	e8 54 ff ff ff       	call   80107fce <setupkvm>
8010807a:	a3 44 79 11 80       	mov    %eax,0x80117944
  switchkvm();
8010807f:	e8 03 00 00 00       	call   80108087 <switchkvm>
}
80108084:	90                   	nop
80108085:	c9                   	leave  
80108086:	c3                   	ret    

80108087 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108087:	f3 0f 1e fb          	endbr32 
8010808b:	55                   	push   %ebp
8010808c:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010808e:	a1 44 79 11 80       	mov    0x80117944,%eax
80108093:	05 00 00 00 80       	add    $0x80000000,%eax
80108098:	50                   	push   %eax
80108099:	e8 79 fa ff ff       	call   80107b17 <lcr3>
8010809e:	83 c4 04             	add    $0x4,%esp
}
801080a1:	90                   	nop
801080a2:	c9                   	leave  
801080a3:	c3                   	ret    

801080a4 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801080a4:	f3 0f 1e fb          	endbr32 
801080a8:	55                   	push   %ebp
801080a9:	89 e5                	mov    %esp,%ebp
801080ab:	56                   	push   %esi
801080ac:	53                   	push   %ebx
801080ad:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
801080b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801080b4:	75 0d                	jne    801080c3 <switchuvm+0x1f>
    panic("switchuvm: no process");
801080b6:	83 ec 0c             	sub    $0xc,%esp
801080b9:	68 4c 96 10 80       	push   $0x8010964c
801080be:	e8 45 85 ff ff       	call   80100608 <panic>
  if(p->kstack == 0)
801080c3:	8b 45 08             	mov    0x8(%ebp),%eax
801080c6:	8b 40 08             	mov    0x8(%eax),%eax
801080c9:	85 c0                	test   %eax,%eax
801080cb:	75 0d                	jne    801080da <switchuvm+0x36>
    panic("switchuvm: no kstack");
801080cd:	83 ec 0c             	sub    $0xc,%esp
801080d0:	68 62 96 10 80       	push   $0x80109662
801080d5:	e8 2e 85 ff ff       	call   80100608 <panic>
  if(p->pgdir == 0)
801080da:	8b 45 08             	mov    0x8(%ebp),%eax
801080dd:	8b 40 04             	mov    0x4(%eax),%eax
801080e0:	85 c0                	test   %eax,%eax
801080e2:	75 0d                	jne    801080f1 <switchuvm+0x4d>
    panic("switchuvm: no pgdir");
801080e4:	83 ec 0c             	sub    $0xc,%esp
801080e7:	68 77 96 10 80       	push   $0x80109677
801080ec:	e8 17 85 ff ff       	call   80100608 <panic>

  pushcli();
801080f1:	e8 7c d2 ff ff       	call   80105372 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801080f6:	e8 18 c3 ff ff       	call   80104413 <mycpu>
801080fb:	89 c3                	mov    %eax,%ebx
801080fd:	e8 11 c3 ff ff       	call   80104413 <mycpu>
80108102:	83 c0 08             	add    $0x8,%eax
80108105:	89 c6                	mov    %eax,%esi
80108107:	e8 07 c3 ff ff       	call   80104413 <mycpu>
8010810c:	83 c0 08             	add    $0x8,%eax
8010810f:	c1 e8 10             	shr    $0x10,%eax
80108112:	88 45 f7             	mov    %al,-0x9(%ebp)
80108115:	e8 f9 c2 ff ff       	call   80104413 <mycpu>
8010811a:	83 c0 08             	add    $0x8,%eax
8010811d:	c1 e8 18             	shr    $0x18,%eax
80108120:	89 c2                	mov    %eax,%edx
80108122:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80108129:	67 00 
8010812b:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80108132:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80108136:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
8010813c:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108143:	83 e0 f0             	and    $0xfffffff0,%eax
80108146:	83 c8 09             	or     $0x9,%eax
80108149:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010814f:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108156:	83 c8 10             	or     $0x10,%eax
80108159:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010815f:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108166:	83 e0 9f             	and    $0xffffff9f,%eax
80108169:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010816f:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108176:	83 c8 80             	or     $0xffffff80,%eax
80108179:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010817f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108186:	83 e0 f0             	and    $0xfffffff0,%eax
80108189:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010818f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108196:	83 e0 ef             	and    $0xffffffef,%eax
80108199:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010819f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801081a6:	83 e0 df             	and    $0xffffffdf,%eax
801081a9:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801081af:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801081b6:	83 c8 40             	or     $0x40,%eax
801081b9:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801081bf:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801081c6:	83 e0 7f             	and    $0x7f,%eax
801081c9:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801081cf:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801081d5:	e8 39 c2 ff ff       	call   80104413 <mycpu>
801081da:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081e1:	83 e2 ef             	and    $0xffffffef,%edx
801081e4:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801081ea:	e8 24 c2 ff ff       	call   80104413 <mycpu>
801081ef:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801081f5:	8b 45 08             	mov    0x8(%ebp),%eax
801081f8:	8b 40 08             	mov    0x8(%eax),%eax
801081fb:	89 c3                	mov    %eax,%ebx
801081fd:	e8 11 c2 ff ff       	call   80104413 <mycpu>
80108202:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80108208:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010820b:	e8 03 c2 ff ff       	call   80104413 <mycpu>
80108210:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80108216:	83 ec 0c             	sub    $0xc,%esp
80108219:	6a 28                	push   $0x28
8010821b:	e8 e0 f8 ff ff       	call   80107b00 <ltr>
80108220:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80108223:	8b 45 08             	mov    0x8(%ebp),%eax
80108226:	8b 40 04             	mov    0x4(%eax),%eax
80108229:	05 00 00 00 80       	add    $0x80000000,%eax
8010822e:	83 ec 0c             	sub    $0xc,%esp
80108231:	50                   	push   %eax
80108232:	e8 e0 f8 ff ff       	call   80107b17 <lcr3>
80108237:	83 c4 10             	add    $0x10,%esp
  popcli();
8010823a:	e8 84 d1 ff ff       	call   801053c3 <popcli>
}
8010823f:	90                   	nop
80108240:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108243:	5b                   	pop    %ebx
80108244:	5e                   	pop    %esi
80108245:	5d                   	pop    %ebp
80108246:	c3                   	ret    

80108247 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108247:	f3 0f 1e fb          	endbr32 
8010824b:	55                   	push   %ebp
8010824c:	89 e5                	mov    %esp,%ebp
8010824e:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80108251:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108258:	76 0d                	jbe    80108267 <inituvm+0x20>
    panic("inituvm: more than a page");
8010825a:	83 ec 0c             	sub    $0xc,%esp
8010825d:	68 8b 96 10 80       	push   $0x8010968b
80108262:	e8 a1 83 ff ff       	call   80100608 <panic>
  mem = kalloc();
80108267:	e8 5f ab ff ff       	call   80102dcb <kalloc>
8010826c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010826f:	83 ec 04             	sub    $0x4,%esp
80108272:	68 00 10 00 00       	push   $0x1000
80108277:	6a 00                	push   $0x0
80108279:	ff 75 f4             	pushl  -0xc(%ebp)
8010827c:	e8 04 d2 ff ff       	call   80105485 <memset>
80108281:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108284:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108287:	05 00 00 00 80       	add    $0x80000000,%eax
8010828c:	83 ec 0c             	sub    $0xc,%esp
8010828f:	6a 06                	push   $0x6
80108291:	50                   	push   %eax
80108292:	68 00 10 00 00       	push   $0x1000
80108297:	6a 00                	push   $0x0
80108299:	ff 75 08             	pushl  0x8(%ebp)
8010829c:	e8 76 fc ff ff       	call   80107f17 <mappages>
801082a1:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801082a4:	83 ec 04             	sub    $0x4,%esp
801082a7:	ff 75 10             	pushl  0x10(%ebp)
801082aa:	ff 75 0c             	pushl  0xc(%ebp)
801082ad:	ff 75 f4             	pushl  -0xc(%ebp)
801082b0:	e8 97 d2 ff ff       	call   8010554c <memmove>
801082b5:	83 c4 10             	add    $0x10,%esp
}
801082b8:	90                   	nop
801082b9:	c9                   	leave  
801082ba:	c3                   	ret    

801082bb <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801082bb:	f3 0f 1e fb          	endbr32 
801082bf:	55                   	push   %ebp
801082c0:	89 e5                	mov    %esp,%ebp
801082c2:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801082c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801082c8:	25 ff 0f 00 00       	and    $0xfff,%eax
801082cd:	85 c0                	test   %eax,%eax
801082cf:	74 0d                	je     801082de <loaduvm+0x23>
    panic("loaduvm: addr must be page aligned");
801082d1:	83 ec 0c             	sub    $0xc,%esp
801082d4:	68 a8 96 10 80       	push   $0x801096a8
801082d9:	e8 2a 83 ff ff       	call   80100608 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801082de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082e5:	e9 8f 00 00 00       	jmp    80108379 <loaduvm+0xbe>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801082ea:	8b 55 0c             	mov    0xc(%ebp),%edx
801082ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f0:	01 d0                	add    %edx,%eax
801082f2:	83 ec 04             	sub    $0x4,%esp
801082f5:	6a 00                	push   $0x0
801082f7:	50                   	push   %eax
801082f8:	ff 75 08             	pushl  0x8(%ebp)
801082fb:	e8 7d fb ff ff       	call   80107e7d <walkpgdir>
80108300:	83 c4 10             	add    $0x10,%esp
80108303:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108306:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010830a:	75 0d                	jne    80108319 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
8010830c:	83 ec 0c             	sub    $0xc,%esp
8010830f:	68 cb 96 10 80       	push   $0x801096cb
80108314:	e8 ef 82 ff ff       	call   80100608 <panic>
    pa = PTE_ADDR(*pte);
80108319:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010831c:	8b 00                	mov    (%eax),%eax
8010831e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108323:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108326:	8b 45 18             	mov    0x18(%ebp),%eax
80108329:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010832c:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108331:	77 0b                	ja     8010833e <loaduvm+0x83>
      n = sz - i;
80108333:	8b 45 18             	mov    0x18(%ebp),%eax
80108336:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108339:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010833c:	eb 07                	jmp    80108345 <loaduvm+0x8a>
    else
      n = PGSIZE;
8010833e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108345:	8b 55 14             	mov    0x14(%ebp),%edx
80108348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834b:	01 d0                	add    %edx,%eax
8010834d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108350:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108356:	ff 75 f0             	pushl  -0x10(%ebp)
80108359:	50                   	push   %eax
8010835a:	52                   	push   %edx
8010835b:	ff 75 10             	pushl  0x10(%ebp)
8010835e:	e8 80 9c ff ff       	call   80101fe3 <readi>
80108363:	83 c4 10             	add    $0x10,%esp
80108366:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80108369:	74 07                	je     80108372 <loaduvm+0xb7>
      return -1;
8010836b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108370:	eb 18                	jmp    8010838a <loaduvm+0xcf>
  for(i = 0; i < sz; i += PGSIZE){
80108372:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837c:	3b 45 18             	cmp    0x18(%ebp),%eax
8010837f:	0f 82 65 ff ff ff    	jb     801082ea <loaduvm+0x2f>
  }
  return 0;
80108385:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010838a:	c9                   	leave  
8010838b:	c3                   	ret    

8010838c <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010838c:	f3 0f 1e fb          	endbr32 
80108390:	55                   	push   %ebp
80108391:	89 e5                	mov    %esp,%ebp
80108393:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108396:	8b 45 10             	mov    0x10(%ebp),%eax
80108399:	85 c0                	test   %eax,%eax
8010839b:	79 0a                	jns    801083a7 <allocuvm+0x1b>
    return 0;
8010839d:	b8 00 00 00 00       	mov    $0x0,%eax
801083a2:	e9 ec 00 00 00       	jmp    80108493 <allocuvm+0x107>
  if(newsz < oldsz)
801083a7:	8b 45 10             	mov    0x10(%ebp),%eax
801083aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
801083ad:	73 08                	jae    801083b7 <allocuvm+0x2b>
    return oldsz;
801083af:	8b 45 0c             	mov    0xc(%ebp),%eax
801083b2:	e9 dc 00 00 00       	jmp    80108493 <allocuvm+0x107>

  a = PGROUNDUP(oldsz);
801083b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801083ba:	05 ff 0f 00 00       	add    $0xfff,%eax
801083bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801083c7:	e9 b8 00 00 00       	jmp    80108484 <allocuvm+0xf8>
    mem = kalloc();
801083cc:	e8 fa a9 ff ff       	call   80102dcb <kalloc>
801083d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801083d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801083d8:	75 2e                	jne    80108408 <allocuvm+0x7c>
      cprintf("allocuvm out of memory\n");
801083da:	83 ec 0c             	sub    $0xc,%esp
801083dd:	68 e9 96 10 80       	push   $0x801096e9
801083e2:	e8 31 80 ff ff       	call   80100418 <cprintf>
801083e7:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801083ea:	83 ec 04             	sub    $0x4,%esp
801083ed:	ff 75 0c             	pushl  0xc(%ebp)
801083f0:	ff 75 10             	pushl  0x10(%ebp)
801083f3:	ff 75 08             	pushl  0x8(%ebp)
801083f6:	e8 9a 00 00 00       	call   80108495 <deallocuvm>
801083fb:	83 c4 10             	add    $0x10,%esp
      return 0;
801083fe:	b8 00 00 00 00       	mov    $0x0,%eax
80108403:	e9 8b 00 00 00       	jmp    80108493 <allocuvm+0x107>
    }
    memset(mem, 0, PGSIZE);
80108408:	83 ec 04             	sub    $0x4,%esp
8010840b:	68 00 10 00 00       	push   $0x1000
80108410:	6a 00                	push   $0x0
80108412:	ff 75 f0             	pushl  -0x10(%ebp)
80108415:	e8 6b d0 ff ff       	call   80105485 <memset>
8010841a:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010841d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108420:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108429:	83 ec 0c             	sub    $0xc,%esp
8010842c:	6a 06                	push   $0x6
8010842e:	52                   	push   %edx
8010842f:	68 00 10 00 00       	push   $0x1000
80108434:	50                   	push   %eax
80108435:	ff 75 08             	pushl  0x8(%ebp)
80108438:	e8 da fa ff ff       	call   80107f17 <mappages>
8010843d:	83 c4 20             	add    $0x20,%esp
80108440:	85 c0                	test   %eax,%eax
80108442:	79 39                	jns    8010847d <allocuvm+0xf1>
      cprintf("allocuvm out of memory (2)\n");
80108444:	83 ec 0c             	sub    $0xc,%esp
80108447:	68 01 97 10 80       	push   $0x80109701
8010844c:	e8 c7 7f ff ff       	call   80100418 <cprintf>
80108451:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108454:	83 ec 04             	sub    $0x4,%esp
80108457:	ff 75 0c             	pushl  0xc(%ebp)
8010845a:	ff 75 10             	pushl  0x10(%ebp)
8010845d:	ff 75 08             	pushl  0x8(%ebp)
80108460:	e8 30 00 00 00       	call   80108495 <deallocuvm>
80108465:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80108468:	83 ec 0c             	sub    $0xc,%esp
8010846b:	ff 75 f0             	pushl  -0x10(%ebp)
8010846e:	e8 ba a8 ff ff       	call   80102d2d <kfree>
80108473:	83 c4 10             	add    $0x10,%esp
      return 0;
80108476:	b8 00 00 00 00       	mov    $0x0,%eax
8010847b:	eb 16                	jmp    80108493 <allocuvm+0x107>
  for(; a < newsz; a += PGSIZE){
8010847d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108484:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108487:	3b 45 10             	cmp    0x10(%ebp),%eax
8010848a:	0f 82 3c ff ff ff    	jb     801083cc <allocuvm+0x40>
    }
  }
  return newsz;
80108490:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108493:	c9                   	leave  
80108494:	c3                   	ret    

80108495 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108495:	f3 0f 1e fb          	endbr32 
80108499:	55                   	push   %ebp
8010849a:	89 e5                	mov    %esp,%ebp
8010849c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010849f:	8b 45 10             	mov    0x10(%ebp),%eax
801084a2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801084a5:	72 08                	jb     801084af <deallocuvm+0x1a>
    return oldsz;
801084a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801084aa:	e9 ae 00 00 00       	jmp    8010855d <deallocuvm+0xc8>

  a = PGROUNDUP(newsz);
801084af:	8b 45 10             	mov    0x10(%ebp),%eax
801084b2:	05 ff 0f 00 00       	add    $0xfff,%eax
801084b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801084bf:	e9 8a 00 00 00       	jmp    8010854e <deallocuvm+0xb9>
    pte = walkpgdir(pgdir, (char*)a, 0);
801084c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c7:	83 ec 04             	sub    $0x4,%esp
801084ca:	6a 00                	push   $0x0
801084cc:	50                   	push   %eax
801084cd:	ff 75 08             	pushl  0x8(%ebp)
801084d0:	e8 a8 f9 ff ff       	call   80107e7d <walkpgdir>
801084d5:	83 c4 10             	add    $0x10,%esp
801084d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801084db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084df:	75 16                	jne    801084f7 <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801084e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e4:	c1 e8 16             	shr    $0x16,%eax
801084e7:	83 c0 01             	add    $0x1,%eax
801084ea:	c1 e0 16             	shl    $0x16,%eax
801084ed:	2d 00 10 00 00       	sub    $0x1000,%eax
801084f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801084f5:	eb 50                	jmp    80108547 <deallocuvm+0xb2>
    else if((*pte & (PTE_P | PTE_E)) != 0){
801084f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084fa:	8b 00                	mov    (%eax),%eax
801084fc:	25 01 04 00 00       	and    $0x401,%eax
80108501:	85 c0                	test   %eax,%eax
80108503:	74 42                	je     80108547 <deallocuvm+0xb2>
      pa = PTE_ADDR(*pte);
80108505:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108508:	8b 00                	mov    (%eax),%eax
8010850a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010850f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108512:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108516:	75 0d                	jne    80108525 <deallocuvm+0x90>
        panic("kfree");
80108518:	83 ec 0c             	sub    $0xc,%esp
8010851b:	68 1d 97 10 80       	push   $0x8010971d
80108520:	e8 e3 80 ff ff       	call   80100608 <panic>
      char *v = P2V(pa);
80108525:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108528:	05 00 00 00 80       	add    $0x80000000,%eax
8010852d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108530:	83 ec 0c             	sub    $0xc,%esp
80108533:	ff 75 e8             	pushl  -0x18(%ebp)
80108536:	e8 f2 a7 ff ff       	call   80102d2d <kfree>
8010853b:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
8010853e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108547:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010854e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108551:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108554:	0f 82 6a ff ff ff    	jb     801084c4 <deallocuvm+0x2f>
    }
  }
  return newsz;
8010855a:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010855d:	c9                   	leave  
8010855e:	c3                   	ret    

8010855f <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010855f:	f3 0f 1e fb          	endbr32 
80108563:	55                   	push   %ebp
80108564:	89 e5                	mov    %esp,%ebp
80108566:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108569:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010856d:	75 0d                	jne    8010857c <freevm+0x1d>
    panic("freevm: no pgdir");
8010856f:	83 ec 0c             	sub    $0xc,%esp
80108572:	68 23 97 10 80       	push   $0x80109723
80108577:	e8 8c 80 ff ff       	call   80100608 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010857c:	83 ec 04             	sub    $0x4,%esp
8010857f:	6a 00                	push   $0x0
80108581:	68 00 00 00 80       	push   $0x80000000
80108586:	ff 75 08             	pushl  0x8(%ebp)
80108589:	e8 07 ff ff ff       	call   80108495 <deallocuvm>
8010858e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108591:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108598:	eb 4a                	jmp    801085e4 <freevm+0x85>
    if(pgdir[i] & (PTE_P | PTE_E)){
8010859a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010859d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085a4:	8b 45 08             	mov    0x8(%ebp),%eax
801085a7:	01 d0                	add    %edx,%eax
801085a9:	8b 00                	mov    (%eax),%eax
801085ab:	25 01 04 00 00       	and    $0x401,%eax
801085b0:	85 c0                	test   %eax,%eax
801085b2:	74 2c                	je     801085e0 <freevm+0x81>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801085b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085be:	8b 45 08             	mov    0x8(%ebp),%eax
801085c1:	01 d0                	add    %edx,%eax
801085c3:	8b 00                	mov    (%eax),%eax
801085c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085ca:	05 00 00 00 80       	add    $0x80000000,%eax
801085cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801085d2:	83 ec 0c             	sub    $0xc,%esp
801085d5:	ff 75 f0             	pushl  -0x10(%ebp)
801085d8:	e8 50 a7 ff ff       	call   80102d2d <kfree>
801085dd:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801085e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801085e4:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801085eb:	76 ad                	jbe    8010859a <freevm+0x3b>
    }
  }
  kfree((char*)pgdir);
801085ed:	83 ec 0c             	sub    $0xc,%esp
801085f0:	ff 75 08             	pushl  0x8(%ebp)
801085f3:	e8 35 a7 ff ff       	call   80102d2d <kfree>
801085f8:	83 c4 10             	add    $0x10,%esp
}
801085fb:	90                   	nop
801085fc:	c9                   	leave  
801085fd:	c3                   	ret    

801085fe <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801085fe:	f3 0f 1e fb          	endbr32 
80108602:	55                   	push   %ebp
80108603:	89 e5                	mov    %esp,%ebp
80108605:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108608:	83 ec 04             	sub    $0x4,%esp
8010860b:	6a 00                	push   $0x0
8010860d:	ff 75 0c             	pushl  0xc(%ebp)
80108610:	ff 75 08             	pushl  0x8(%ebp)
80108613:	e8 65 f8 ff ff       	call   80107e7d <walkpgdir>
80108618:	83 c4 10             	add    $0x10,%esp
8010861b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010861e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108622:	75 0d                	jne    80108631 <clearpteu+0x33>
    panic("clearpteu");
80108624:	83 ec 0c             	sub    $0xc,%esp
80108627:	68 34 97 10 80       	push   $0x80109734
8010862c:	e8 d7 7f ff ff       	call   80100608 <panic>
  *pte &= ~PTE_U;
80108631:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108634:	8b 00                	mov    (%eax),%eax
80108636:	83 e0 fb             	and    $0xfffffffb,%eax
80108639:	89 c2                	mov    %eax,%edx
8010863b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010863e:	89 10                	mov    %edx,(%eax)
}
80108640:	90                   	nop
80108641:	c9                   	leave  
80108642:	c3                   	ret    

80108643 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108643:	f3 0f 1e fb          	endbr32 
80108647:	55                   	push   %ebp
80108648:	89 e5                	mov    %esp,%ebp
8010864a:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010864d:	e8 7c f9 ff ff       	call   80107fce <setupkvm>
80108652:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108655:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108659:	75 0a                	jne    80108665 <copyuvm+0x22>
    return 0;
8010865b:	b8 00 00 00 00       	mov    $0x0,%eax
80108660:	e9 fa 00 00 00       	jmp    8010875f <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108665:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010866c:	e9 c9 00 00 00       	jmp    8010873a <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108674:	83 ec 04             	sub    $0x4,%esp
80108677:	6a 00                	push   $0x0
80108679:	50                   	push   %eax
8010867a:	ff 75 08             	pushl  0x8(%ebp)
8010867d:	e8 fb f7 ff ff       	call   80107e7d <walkpgdir>
80108682:	83 c4 10             	add    $0x10,%esp
80108685:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108688:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010868c:	75 0d                	jne    8010869b <copyuvm+0x58>
      panic("p4Debug: inside copyuvm, pte should exist");
8010868e:	83 ec 0c             	sub    $0xc,%esp
80108691:	68 40 97 10 80       	push   $0x80109740
80108696:	e8 6d 7f ff ff       	call   80100608 <panic>
    if(!(*pte & (PTE_P | PTE_E)))
8010869b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010869e:	8b 00                	mov    (%eax),%eax
801086a0:	25 01 04 00 00       	and    $0x401,%eax
801086a5:	85 c0                	test   %eax,%eax
801086a7:	75 0d                	jne    801086b6 <copyuvm+0x73>
      panic("p4Debug: inside copyuvm, page not present");
801086a9:	83 ec 0c             	sub    $0xc,%esp
801086ac:	68 6c 97 10 80       	push   $0x8010976c
801086b1:	e8 52 7f ff ff       	call   80100608 <panic>
    pa = PTE_ADDR(*pte);
801086b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086b9:	8b 00                	mov    (%eax),%eax
801086bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801086c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086c6:	8b 00                	mov    (%eax),%eax
801086c8:	25 ff 0f 00 00       	and    $0xfff,%eax
801086cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801086d0:	e8 f6 a6 ff ff       	call   80102dcb <kalloc>
801086d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801086d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801086dc:	74 6d                	je     8010874b <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801086de:	8b 45 e8             	mov    -0x18(%ebp),%eax
801086e1:	05 00 00 00 80       	add    $0x80000000,%eax
801086e6:	83 ec 04             	sub    $0x4,%esp
801086e9:	68 00 10 00 00       	push   $0x1000
801086ee:	50                   	push   %eax
801086ef:	ff 75 e0             	pushl  -0x20(%ebp)
801086f2:	e8 55 ce ff ff       	call   8010554c <memmove>
801086f7:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801086fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801086fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108700:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80108706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108709:	83 ec 0c             	sub    $0xc,%esp
8010870c:	52                   	push   %edx
8010870d:	51                   	push   %ecx
8010870e:	68 00 10 00 00       	push   $0x1000
80108713:	50                   	push   %eax
80108714:	ff 75 f0             	pushl  -0x10(%ebp)
80108717:	e8 fb f7 ff ff       	call   80107f17 <mappages>
8010871c:	83 c4 20             	add    $0x20,%esp
8010871f:	85 c0                	test   %eax,%eax
80108721:	79 10                	jns    80108733 <copyuvm+0xf0>
      kfree(mem);
80108723:	83 ec 0c             	sub    $0xc,%esp
80108726:	ff 75 e0             	pushl  -0x20(%ebp)
80108729:	e8 ff a5 ff ff       	call   80102d2d <kfree>
8010872e:	83 c4 10             	add    $0x10,%esp
      goto bad;
80108731:	eb 19                	jmp    8010874c <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80108733:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010873a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010873d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108740:	0f 82 2b ff ff ff    	jb     80108671 <copyuvm+0x2e>
    }
  }
  return d;
80108746:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108749:	eb 14                	jmp    8010875f <copyuvm+0x11c>
      goto bad;
8010874b:	90                   	nop

bad:
  freevm(d);
8010874c:	83 ec 0c             	sub    $0xc,%esp
8010874f:	ff 75 f0             	pushl  -0x10(%ebp)
80108752:	e8 08 fe ff ff       	call   8010855f <freevm>
80108757:	83 c4 10             	add    $0x10,%esp
  return 0;
8010875a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010875f:	c9                   	leave  
80108760:	c3                   	ret    

80108761 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108761:	f3 0f 1e fb          	endbr32 
80108765:	55                   	push   %ebp
80108766:	89 e5                	mov    %esp,%ebp
80108768:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010876b:	83 ec 04             	sub    $0x4,%esp
8010876e:	6a 00                	push   $0x0
80108770:	ff 75 0c             	pushl  0xc(%ebp)
80108773:	ff 75 08             	pushl  0x8(%ebp)
80108776:	e8 02 f7 ff ff       	call   80107e7d <walkpgdir>
8010877b:	83 c4 10             	add    $0x10,%esp
8010877e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // p4Debug: Check for page's present and encrypted flags.
  if(((*pte & PTE_P) | (*pte & PTE_E)) == 0)
80108781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108784:	8b 00                	mov    (%eax),%eax
80108786:	25 01 04 00 00       	and    $0x401,%eax
8010878b:	85 c0                	test   %eax,%eax
8010878d:	75 07                	jne    80108796 <uva2ka+0x35>
    return 0;
8010878f:	b8 00 00 00 00       	mov    $0x0,%eax
80108794:	eb 22                	jmp    801087b8 <uva2ka+0x57>
  if((*pte & PTE_U) == 0)
80108796:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108799:	8b 00                	mov    (%eax),%eax
8010879b:	83 e0 04             	and    $0x4,%eax
8010879e:	85 c0                	test   %eax,%eax
801087a0:	75 07                	jne    801087a9 <uva2ka+0x48>
    return 0;
801087a2:	b8 00 00 00 00       	mov    $0x0,%eax
801087a7:	eb 0f                	jmp    801087b8 <uva2ka+0x57>
  return (char*)P2V(PTE_ADDR(*pte));
801087a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ac:	8b 00                	mov    (%eax),%eax
801087ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087b3:	05 00 00 00 80       	add    $0x80000000,%eax
}
801087b8:	c9                   	leave  
801087b9:	c3                   	ret    

801087ba <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801087ba:	f3 0f 1e fb          	endbr32 
801087be:	55                   	push   %ebp
801087bf:	89 e5                	mov    %esp,%ebp
801087c1:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801087c4:	8b 45 10             	mov    0x10(%ebp),%eax
801087c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801087ca:	eb 7f                	jmp    8010884b <copyout+0x91>
    va0 = (uint)PGROUNDDOWN(va);
801087cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801087cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801087d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087da:	83 ec 08             	sub    $0x8,%esp
801087dd:	50                   	push   %eax
801087de:	ff 75 08             	pushl  0x8(%ebp)
801087e1:	e8 7b ff ff ff       	call   80108761 <uva2ka>
801087e6:	83 c4 10             	add    $0x10,%esp
801087e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801087ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801087f0:	75 07                	jne    801087f9 <copyout+0x3f>
    {
      //p4Debug : Cannot find page in kernel space.
      return -1;
801087f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087f7:	eb 61                	jmp    8010885a <copyout+0xa0>
    }
    n = PGSIZE - (va - va0);
801087f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087fc:	2b 45 0c             	sub    0xc(%ebp),%eax
801087ff:	05 00 10 00 00       	add    $0x1000,%eax
80108804:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108807:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010880a:	3b 45 14             	cmp    0x14(%ebp),%eax
8010880d:	76 06                	jbe    80108815 <copyout+0x5b>
      n = len;
8010880f:	8b 45 14             	mov    0x14(%ebp),%eax
80108812:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108815:	8b 45 0c             	mov    0xc(%ebp),%eax
80108818:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010881b:	89 c2                	mov    %eax,%edx
8010881d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108820:	01 d0                	add    %edx,%eax
80108822:	83 ec 04             	sub    $0x4,%esp
80108825:	ff 75 f0             	pushl  -0x10(%ebp)
80108828:	ff 75 f4             	pushl  -0xc(%ebp)
8010882b:	50                   	push   %eax
8010882c:	e8 1b cd ff ff       	call   8010554c <memmove>
80108831:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108834:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108837:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010883a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010883d:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108840:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108843:	05 00 10 00 00       	add    $0x1000,%eax
80108848:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
8010884b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010884f:	0f 85 77 ff ff ff    	jne    801087cc <copyout+0x12>
  }
  return 0;
80108855:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010885a:	c9                   	leave  
8010885b:	c3                   	ret    

8010885c <translate_and_set>:

//This function is just like uva2ka but sets the PTE_E bit and clears PTE_P
char* translate_and_set(pde_t *pgdir, char *uva) {
8010885c:	f3 0f 1e fb          	endbr32 
80108860:	55                   	push   %ebp
80108861:	89 e5                	mov    %esp,%ebp
80108863:	83 ec 18             	sub    $0x18,%esp
  cprintf("p4Debug: setting PTE_E for %p, VPN %d\n", uva, PPN(uva));
80108866:	8b 45 0c             	mov    0xc(%ebp),%eax
80108869:	c1 e8 0c             	shr    $0xc,%eax
8010886c:	83 ec 04             	sub    $0x4,%esp
8010886f:	50                   	push   %eax
80108870:	ff 75 0c             	pushl  0xc(%ebp)
80108873:	68 98 97 10 80       	push   $0x80109798
80108878:	e8 9b 7b ff ff       	call   80100418 <cprintf>
8010887d:	83 c4 10             	add    $0x10,%esp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80108880:	83 ec 04             	sub    $0x4,%esp
80108883:	6a 00                	push   $0x0
80108885:	ff 75 0c             	pushl  0xc(%ebp)
80108888:	ff 75 08             	pushl  0x8(%ebp)
8010888b:	e8 ed f5 ff ff       	call   80107e7d <walkpgdir>
80108890:	83 c4 10             	add    $0x10,%esp
80108893:	89 45 f4             	mov    %eax,-0xc(%ebp)

  //p4Debug: If page is not present AND it is not encrypted.
  if((*pte & PTE_P) == 0 && (*pte & PTE_E) == 0)
80108896:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108899:	8b 00                	mov    (%eax),%eax
8010889b:	83 e0 01             	and    $0x1,%eax
8010889e:	85 c0                	test   %eax,%eax
801088a0:	75 18                	jne    801088ba <translate_and_set+0x5e>
801088a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088a5:	8b 00                	mov    (%eax),%eax
801088a7:	25 00 04 00 00       	and    $0x400,%eax
801088ac:	85 c0                	test   %eax,%eax
801088ae:	75 0a                	jne    801088ba <translate_and_set+0x5e>
    return 0;
801088b0:	b8 00 00 00 00       	mov    $0x0,%eax
801088b5:	e9 84 00 00 00       	jmp    8010893e <translate_and_set+0xe2>
  //p4Debug: If page is already encrypted, i.e. PTE_E is set, return NULL as error;
  if((*pte & PTE_E)) {
801088ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088bd:	8b 00                	mov    (%eax),%eax
801088bf:	25 00 04 00 00       	and    $0x400,%eax
801088c4:	85 c0                	test   %eax,%eax
801088c6:	74 07                	je     801088cf <translate_and_set+0x73>
    return 0;
801088c8:	b8 00 00 00 00       	mov    $0x0,%eax
801088cd:	eb 6f                	jmp    8010893e <translate_and_set+0xe2>
  }
  // p4Debug: Check if users are allowed to use this page
  if((*pte & PTE_U) == 0)
801088cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d2:	8b 00                	mov    (%eax),%eax
801088d4:	83 e0 04             	and    $0x4,%eax
801088d7:	85 c0                	test   %eax,%eax
801088d9:	75 07                	jne    801088e2 <translate_and_set+0x86>
    return 0;
801088db:	b8 00 00 00 00       	mov    $0x0,%eax
801088e0:	eb 5c                	jmp    8010893e <translate_and_set+0xe2>
  //p4Debug: Set Page as encrypted and not present so that we can trap(see trap.c) to decrypt page
  cprintf("p4Debug: PTE was %x and its pointer %p\n", *pte, pte);
801088e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e5:	8b 00                	mov    (%eax),%eax
801088e7:	83 ec 04             	sub    $0x4,%esp
801088ea:	ff 75 f4             	pushl  -0xc(%ebp)
801088ed:	50                   	push   %eax
801088ee:	68 c0 97 10 80       	push   $0x801097c0
801088f3:	e8 20 7b ff ff       	call   80100418 <cprintf>
801088f8:	83 c4 10             	add    $0x10,%esp
  *pte = *pte | PTE_E;
801088fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088fe:	8b 00                	mov    (%eax),%eax
80108900:	80 cc 04             	or     $0x4,%ah
80108903:	89 c2                	mov    %eax,%edx
80108905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108908:	89 10                	mov    %edx,(%eax)
  *pte = *pte & ~PTE_P;
8010890a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010890d:	8b 00                	mov    (%eax),%eax
8010890f:	83 e0 fe             	and    $0xfffffffe,%eax
80108912:	89 c2                	mov    %eax,%edx
80108914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108917:	89 10                	mov    %edx,(%eax)
  cprintf("p4Debug: PTE is now %x\n", *pte);
80108919:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010891c:	8b 00                	mov    (%eax),%eax
8010891e:	83 ec 08             	sub    $0x8,%esp
80108921:	50                   	push   %eax
80108922:	68 e8 97 10 80       	push   $0x801097e8
80108927:	e8 ec 7a ff ff       	call   80100418 <cprintf>
8010892c:	83 c4 10             	add    $0x10,%esp
  return (char*)P2V(PTE_ADDR(*pte));
8010892f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108932:	8b 00                	mov    (%eax),%eax
80108934:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108939:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010893e:	c9                   	leave  
8010893f:	c3                   	ret    

80108940 <mdecrypt>:


int mdecrypt(char *virtual_addr) {
80108940:	f3 0f 1e fb          	endbr32 
80108944:	55                   	push   %ebp
80108945:	89 e5                	mov    %esp,%ebp
80108947:	83 ec 28             	sub    $0x28,%esp
  cprintf("DECRYPT ASDF");
8010894a:	83 ec 0c             	sub    $0xc,%esp
8010894d:	68 00 98 10 80       	push   $0x80109800
80108952:	e8 c1 7a ff ff       	call   80100418 <cprintf>
80108957:	83 c4 10             	add    $0x10,%esp
  cprintf("p4Debug:  mdecrypt VPN %d, %p, pid %d\n", PPN(virtual_addr), virtual_addr, myproc()->pid);
8010895a:	e8 30 bb ff ff       	call   8010448f <myproc>
8010895f:	8b 40 10             	mov    0x10(%eax),%eax
80108962:	8b 55 08             	mov    0x8(%ebp),%edx
80108965:	c1 ea 0c             	shr    $0xc,%edx
80108968:	50                   	push   %eax
80108969:	ff 75 08             	pushl  0x8(%ebp)
8010896c:	52                   	push   %edx
8010896d:	68 10 98 10 80       	push   $0x80109810
80108972:	e8 a1 7a ff ff       	call   80100418 <cprintf>
80108977:	83 c4 10             	add    $0x10,%esp
  //p4Debug: virtual_addr is a virtual address in this PID's userspace.
  struct proc * p = myproc();
8010897a:	e8 10 bb ff ff       	call   8010448f <myproc>
8010897f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pde_t* mypd = p->pgdir;
80108982:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108985:	8b 40 04             	mov    0x4(%eax),%eax
80108988:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //set the present bit to true and encrypt bit to false
  pte_t * pte = walkpgdir(mypd, virtual_addr, 0);
8010898b:	83 ec 04             	sub    $0x4,%esp
8010898e:	6a 00                	push   $0x0
80108990:	ff 75 08             	pushl  0x8(%ebp)
80108993:	ff 75 e8             	pushl  -0x18(%ebp)
80108996:	e8 e2 f4 ff ff       	call   80107e7d <walkpgdir>
8010899b:	83 c4 10             	add    $0x10,%esp
8010899e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (!pte || *pte == 0) {
801089a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801089a5:	74 09                	je     801089b0 <mdecrypt+0x70>
801089a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801089aa:	8b 00                	mov    (%eax),%eax
801089ac:	85 c0                	test   %eax,%eax
801089ae:	75 1a                	jne    801089ca <mdecrypt+0x8a>
    cprintf("p4Debug: walkpgdir failed\n");
801089b0:	83 ec 0c             	sub    $0xc,%esp
801089b3:	68 37 98 10 80       	push   $0x80109837
801089b8:	e8 5b 7a ff ff       	call   80100418 <cprintf>
801089bd:	83 c4 10             	add    $0x10,%esp
    return -1;
801089c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801089c5:	e9 f9 00 00 00       	jmp    80108ac3 <mdecrypt+0x183>
  }
  cprintf("p4Debug: pte was %x\n", *pte);
801089ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801089cd:	8b 00                	mov    (%eax),%eax
801089cf:	83 ec 08             	sub    $0x8,%esp
801089d2:	50                   	push   %eax
801089d3:	68 52 98 10 80       	push   $0x80109852
801089d8:	e8 3b 7a ff ff       	call   80100418 <cprintf>
801089dd:	83 c4 10             	add    $0x10,%esp
  *pte = *pte & ~PTE_E;
801089e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801089e3:	8b 00                	mov    (%eax),%eax
801089e5:	80 e4 fb             	and    $0xfb,%ah
801089e8:	89 c2                	mov    %eax,%edx
801089ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801089ed:	89 10                	mov    %edx,(%eax)
  *pte = *pte | PTE_P;
801089ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801089f2:	8b 00                	mov    (%eax),%eax
801089f4:	83 c8 01             	or     $0x1,%eax
801089f7:	89 c2                	mov    %eax,%edx
801089f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801089fc:	89 10                	mov    %edx,(%eax)
  cprintf("p4Debug: pte is %x\n", *pte);
801089fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108a01:	8b 00                	mov    (%eax),%eax
80108a03:	83 ec 08             	sub    $0x8,%esp
80108a06:	50                   	push   %eax
80108a07:	68 67 98 10 80       	push   $0x80109867
80108a0c:	e8 07 7a ff ff       	call   80100418 <cprintf>
80108a11:	83 c4 10             	add    $0x10,%esp
  char * original = uva2ka(mypd, virtual_addr) + OFFSET(virtual_addr);
80108a14:	83 ec 08             	sub    $0x8,%esp
80108a17:	ff 75 08             	pushl  0x8(%ebp)
80108a1a:	ff 75 e8             	pushl  -0x18(%ebp)
80108a1d:	e8 3f fd ff ff       	call   80108761 <uva2ka>
80108a22:	83 c4 10             	add    $0x10,%esp
80108a25:	8b 55 08             	mov    0x8(%ebp),%edx
80108a28:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80108a2e:	01 d0                	add    %edx,%eax
80108a30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  cprintf("p4Debug: Original in decrypt was %p\n", original);
80108a33:	83 ec 08             	sub    $0x8,%esp
80108a36:	ff 75 e0             	pushl  -0x20(%ebp)
80108a39:	68 7c 98 10 80       	push   $0x8010987c
80108a3e:	e8 d5 79 ff ff       	call   80100418 <cprintf>
80108a43:	83 c4 10             	add    $0x10,%esp
  virtual_addr = (char *)PGROUNDDOWN((uint)virtual_addr);
80108a46:	8b 45 08             	mov    0x8(%ebp),%eax
80108a49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a4e:	89 45 08             	mov    %eax,0x8(%ebp)
  cprintf("p4Debug: mdecrypt: rounded down va is %p\n", virtual_addr);
80108a51:	83 ec 08             	sub    $0x8,%esp
80108a54:	ff 75 08             	pushl  0x8(%ebp)
80108a57:	68 a4 98 10 80       	push   $0x801098a4
80108a5c:	e8 b7 79 ff ff       	call   80100418 <cprintf>
80108a61:	83 c4 10             	add    $0x10,%esp

  char * kvp = uva2ka(mypd, virtual_addr);
80108a64:	83 ec 08             	sub    $0x8,%esp
80108a67:	ff 75 08             	pushl  0x8(%ebp)
80108a6a:	ff 75 e8             	pushl  -0x18(%ebp)
80108a6d:	e8 ef fc ff ff       	call   80108761 <uva2ka>
80108a72:	83 c4 10             	add    $0x10,%esp
80108a75:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (!kvp || *kvp == 0) {
80108a78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80108a7c:	74 0a                	je     80108a88 <mdecrypt+0x148>
80108a7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a81:	0f b6 00             	movzbl (%eax),%eax
80108a84:	84 c0                	test   %al,%al
80108a86:	75 07                	jne    80108a8f <mdecrypt+0x14f>
    return -1;
80108a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108a8d:	eb 34                	jmp    80108ac3 <mdecrypt+0x183>
  }
  char * slider = virtual_addr;
80108a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80108a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int offset = 0; offset < PGSIZE; offset++) {
80108a95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108a9c:	eb 17                	jmp    80108ab5 <mdecrypt+0x175>
    *slider = *slider ^ 0xFF;
80108a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aa1:	0f b6 00             	movzbl (%eax),%eax
80108aa4:	f7 d0                	not    %eax
80108aa6:	89 c2                	mov    %eax,%edx
80108aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aab:	88 10                	mov    %dl,(%eax)
    slider++;
80108aad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  for (int offset = 0; offset < PGSIZE; offset++) {
80108ab1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108ab5:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80108abc:	7e e0                	jle    80108a9e <mdecrypt+0x15e>
  }
  return 0;
80108abe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108ac3:	c9                   	leave  
80108ac4:	c3                   	ret    

80108ac5 <mencrypt>:

int mencrypt(char *virtual_addr, int len) {
80108ac5:	f3 0f 1e fb          	endbr32 
80108ac9:	55                   	push   %ebp
80108aca:	89 e5                	mov    %esp,%ebp
80108acc:	83 ec 38             	sub    $0x38,%esp
  cprintf("p4Debug: mencrypt: %p %d\n", virtual_addr, len);
80108acf:	83 ec 04             	sub    $0x4,%esp
80108ad2:	ff 75 0c             	pushl  0xc(%ebp)
80108ad5:	ff 75 08             	pushl  0x8(%ebp)
80108ad8:	68 ce 98 10 80       	push   $0x801098ce
80108add:	e8 36 79 ff ff       	call   80100418 <cprintf>
80108ae2:	83 c4 10             	add    $0x10,%esp
  //the given pointer is a virtual address in this pid's userspace
  struct proc * p = myproc();
80108ae5:	e8 a5 b9 ff ff       	call   8010448f <myproc>
80108aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pde_t* mypd = p->pgdir;
80108aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108af0:	8b 40 04             	mov    0x4(%eax),%eax
80108af3:	89 45 e0             	mov    %eax,-0x20(%ebp)

  virtual_addr = (char *)PGROUNDDOWN((uint)virtual_addr);
80108af6:	8b 45 08             	mov    0x8(%ebp),%eax
80108af9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108afe:	89 45 08             	mov    %eax,0x8(%ebp)

  //error checking first. all or nothing.
  char * slider = virtual_addr;
80108b01:	8b 45 08             	mov    0x8(%ebp),%eax
80108b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int i = 0; i < len; i++) { 
80108b07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108b0e:	eb 55                	jmp    80108b65 <mencrypt+0xa0>
    //check page table for each translation first
    char * kvp = uva2ka(mypd, slider);
80108b10:	83 ec 08             	sub    $0x8,%esp
80108b13:	ff 75 f4             	pushl  -0xc(%ebp)
80108b16:	ff 75 e0             	pushl  -0x20(%ebp)
80108b19:	e8 43 fc ff ff       	call   80108761 <uva2ka>
80108b1e:	83 c4 10             	add    $0x10,%esp
80108b21:	89 45 d0             	mov    %eax,-0x30(%ebp)
    cprintf("p4Debug: slider %p, kvp for err check is %p\n",slider, kvp);
80108b24:	83 ec 04             	sub    $0x4,%esp
80108b27:	ff 75 d0             	pushl  -0x30(%ebp)
80108b2a:	ff 75 f4             	pushl  -0xc(%ebp)
80108b2d:	68 e8 98 10 80       	push   $0x801098e8
80108b32:	e8 e1 78 ff ff       	call   80100418 <cprintf>
80108b37:	83 c4 10             	add    $0x10,%esp
    if (!kvp) {
80108b3a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
80108b3e:	75 1a                	jne    80108b5a <mencrypt+0x95>
      cprintf("p4Debug: mencrypt: kvp = NULL\n");
80108b40:	83 ec 0c             	sub    $0xc,%esp
80108b43:	68 18 99 10 80       	push   $0x80109918
80108b48:	e8 cb 78 ff ff       	call   80100418 <cprintf>
80108b4d:	83 c4 10             	add    $0x10,%esp
      return -1;
80108b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108b55:	e9 3f 01 00 00       	jmp    80108c99 <mencrypt+0x1d4>
    }
    slider = slider + PGSIZE;
80108b5a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  for (int i = 0; i < len; i++) { 
80108b61:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b68:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108b6b:	7c a3                	jl     80108b10 <mencrypt+0x4b>
  }

  //encrypt stage. Have to do this before setting flag 
  //or else we'll page fault
  slider = virtual_addr;
80108b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80108b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int i = 0; i < len; i++) {
80108b73:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80108b7a:	e9 f8 00 00 00       	jmp    80108c77 <mencrypt+0x1b2>
    cprintf("p4Debug: mencryptr: VPN %d, %p\n", PPN(slider), slider);
80108b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b82:	c1 e8 0c             	shr    $0xc,%eax
80108b85:	83 ec 04             	sub    $0x4,%esp
80108b88:	ff 75 f4             	pushl  -0xc(%ebp)
80108b8b:	50                   	push   %eax
80108b8c:	68 38 99 10 80       	push   $0x80109938
80108b91:	e8 82 78 ff ff       	call   80100418 <cprintf>
80108b96:	83 c4 10             	add    $0x10,%esp
    //kvp = kernel virtual pointer
    //virtual address in kernel space that maps to the given pointer
    char * kvp = uva2ka(mypd, slider);
80108b99:	83 ec 08             	sub    $0x8,%esp
80108b9c:	ff 75 f4             	pushl  -0xc(%ebp)
80108b9f:	ff 75 e0             	pushl  -0x20(%ebp)
80108ba2:	e8 ba fb ff ff       	call   80108761 <uva2ka>
80108ba7:	83 c4 10             	add    $0x10,%esp
80108baa:	89 45 dc             	mov    %eax,-0x24(%ebp)
    cprintf("p4Debug: kvp for encrypt stage is %p\n", kvp);
80108bad:	83 ec 08             	sub    $0x8,%esp
80108bb0:	ff 75 dc             	pushl  -0x24(%ebp)
80108bb3:	68 58 99 10 80       	push   $0x80109958
80108bb8:	e8 5b 78 ff ff       	call   80100418 <cprintf>
80108bbd:	83 c4 10             	add    $0x10,%esp
    pte_t * mypte = walkpgdir(mypd, slider, 0);
80108bc0:	83 ec 04             	sub    $0x4,%esp
80108bc3:	6a 00                	push   $0x0
80108bc5:	ff 75 f4             	pushl  -0xc(%ebp)
80108bc8:	ff 75 e0             	pushl  -0x20(%ebp)
80108bcb:	e8 ad f2 ff ff       	call   80107e7d <walkpgdir>
80108bd0:	83 c4 10             	add    $0x10,%esp
80108bd3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    cprintf("p4Debug: pte is %x\n", *mypte);
80108bd6:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108bd9:	8b 00                	mov    (%eax),%eax
80108bdb:	83 ec 08             	sub    $0x8,%esp
80108bde:	50                   	push   %eax
80108bdf:	68 67 98 10 80       	push   $0x80109867
80108be4:	e8 2f 78 ff ff       	call   80100418 <cprintf>
80108be9:	83 c4 10             	add    $0x10,%esp
    if (*mypte & PTE_E) {
80108bec:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108bef:	8b 00                	mov    (%eax),%eax
80108bf1:	25 00 04 00 00       	and    $0x400,%eax
80108bf6:	85 c0                	test   %eax,%eax
80108bf8:	74 19                	je     80108c13 <mencrypt+0x14e>
      cprintf("p4Debug: already encrypted\n");
80108bfa:	83 ec 0c             	sub    $0xc,%esp
80108bfd:	68 7e 99 10 80       	push   $0x8010997e
80108c02:	e8 11 78 ff ff       	call   80100418 <cprintf>
80108c07:	83 c4 10             	add    $0x10,%esp
      slider += PGSIZE;
80108c0a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
      continue;
80108c11:	eb 60                	jmp    80108c73 <mencrypt+0x1ae>
    }
    for (int offset = 0; offset < PGSIZE; offset++) {
80108c13:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80108c1a:	eb 17                	jmp    80108c33 <mencrypt+0x16e>
      *slider = *slider ^ 0xFF;
80108c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c1f:	0f b6 00             	movzbl (%eax),%eax
80108c22:	f7 d0                	not    %eax
80108c24:	89 c2                	mov    %eax,%edx
80108c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c29:	88 10                	mov    %dl,(%eax)
      slider++;
80108c2b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    for (int offset = 0; offset < PGSIZE; offset++) {
80108c2f:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80108c33:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
80108c3a:	7e e0                	jle    80108c1c <mencrypt+0x157>
    }
    char * kvp_translated = translate_and_set(mypd, slider-PGSIZE);
80108c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c3f:	2d 00 10 00 00       	sub    $0x1000,%eax
80108c44:	83 ec 08             	sub    $0x8,%esp
80108c47:	50                   	push   %eax
80108c48:	ff 75 e0             	pushl  -0x20(%ebp)
80108c4b:	e8 0c fc ff ff       	call   8010885c <translate_and_set>
80108c50:	83 c4 10             	add    $0x10,%esp
80108c53:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (!kvp_translated) {
80108c56:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80108c5a:	75 17                	jne    80108c73 <mencrypt+0x1ae>
      cprintf("p4Debug: translate failed!");
80108c5c:	83 ec 0c             	sub    $0xc,%esp
80108c5f:	68 9a 99 10 80       	push   $0x8010999a
80108c64:	e8 af 77 ff ff       	call   80100418 <cprintf>
80108c69:	83 c4 10             	add    $0x10,%esp
      return -1;
80108c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108c71:	eb 26                	jmp    80108c99 <mencrypt+0x1d4>
  for (int i = 0; i < len; i++) {
80108c73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80108c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c7a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108c7d:	0f 8c fc fe ff ff    	jl     80108b7f <mencrypt+0xba>
    }
  }

  switchuvm(myproc());
80108c83:	e8 07 b8 ff ff       	call   8010448f <myproc>
80108c88:	83 ec 0c             	sub    $0xc,%esp
80108c8b:	50                   	push   %eax
80108c8c:	e8 13 f4 ff ff       	call   801080a4 <switchuvm>
80108c91:	83 c4 10             	add    $0x10,%esp
  return 0;
80108c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c99:	c9                   	leave  
80108c9a:	c3                   	ret    

80108c9b <getpgtable>:

int getpgtable(struct pt_entry* pt_entries, int num, int wsetOnly) {
80108c9b:	f3 0f 1e fb          	endbr32 
80108c9f:	55                   	push   %ebp
80108ca0:	89 e5                	mov    %esp,%ebp
80108ca2:	83 ec 28             	sub    $0x28,%esp
  cprintf("p4Debug: getpgtable: %p, %d\n", pt_entries, num);
80108ca5:	83 ec 04             	sub    $0x4,%esp
80108ca8:	ff 75 0c             	pushl  0xc(%ebp)
80108cab:	ff 75 08             	pushl  0x8(%ebp)
80108cae:	68 b5 99 10 80       	push   $0x801099b5
80108cb3:	e8 60 77 ff ff       	call   80100418 <cprintf>
80108cb8:	83 c4 10             	add    $0x10,%esp

  struct proc *curproc = myproc();
80108cbb:	e8 cf b7 ff ff       	call   8010448f <myproc>
80108cc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pde_t *pgdir = curproc->pgdir;
80108cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cc6:	8b 40 04             	mov    0x4(%eax),%eax
80108cc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint uva = 0;
80108ccc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if (curproc->sz % PGSIZE == 0)
80108cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cd6:	8b 00                	mov    (%eax),%eax
80108cd8:	25 ff 0f 00 00       	and    $0xfff,%eax
80108cdd:	85 c0                	test   %eax,%eax
80108cdf:	75 0f                	jne    80108cf0 <getpgtable+0x55>
    uva = curproc->sz - PGSIZE;
80108ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ce4:	8b 00                	mov    (%eax),%eax
80108ce6:	2d 00 10 00 00       	sub    $0x1000,%eax
80108ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108cee:	eb 0d                	jmp    80108cfd <getpgtable+0x62>
  else 
    uva = PGROUNDDOWN(curproc->sz);
80108cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cf3:	8b 00                	mov    (%eax),%eax
80108cf5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)

  int i = 0;
80108cfd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (;;uva -=PGSIZE)
  {
    
    pte_t *pte = walkpgdir(pgdir, (const void *)uva, 0);
80108d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d07:	83 ec 04             	sub    $0x4,%esp
80108d0a:	6a 00                	push   $0x0
80108d0c:	50                   	push   %eax
80108d0d:	ff 75 e8             	pushl  -0x18(%ebp)
80108d10:	e8 68 f1 ff ff       	call   80107e7d <walkpgdir>
80108d15:	83 c4 10             	add    $0x10,%esp
80108d18:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    if (!(*pte & PTE_U) || !(*pte & (PTE_P | PTE_E)))
80108d1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108d1e:	8b 00                	mov    (%eax),%eax
80108d20:	83 e0 04             	and    $0x4,%eax
80108d23:	85 c0                	test   %eax,%eax
80108d25:	0f 84 7e 01 00 00    	je     80108ea9 <getpgtable+0x20e>
80108d2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108d2e:	8b 00                	mov    (%eax),%eax
80108d30:	25 01 04 00 00       	and    $0x401,%eax
80108d35:	85 c0                	test   %eax,%eax
80108d37:	0f 84 6c 01 00 00    	je     80108ea9 <getpgtable+0x20e>
      continue;

    pt_entries[i].pdx = PDX(uva);
80108d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d40:	c1 e8 16             	shr    $0x16,%eax
80108d43:	89 c1                	mov    %eax,%ecx
80108d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d48:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80108d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80108d52:	01 c2                	add    %eax,%edx
80108d54:	89 c8                	mov    %ecx,%eax
80108d56:	66 25 ff 03          	and    $0x3ff,%ax
80108d5a:	66 25 ff 03          	and    $0x3ff,%ax
80108d5e:	89 c1                	mov    %eax,%ecx
80108d60:	0f b7 02             	movzwl (%edx),%eax
80108d63:	66 25 00 fc          	and    $0xfc00,%ax
80108d67:	09 c8                	or     %ecx,%eax
80108d69:	66 89 02             	mov    %ax,(%edx)
    pt_entries[i].ptx = PTX(uva);
80108d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d6f:	c1 e8 0c             	shr    $0xc,%eax
80108d72:	89 c1                	mov    %eax,%ecx
80108d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d77:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80108d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80108d81:	01 c2                	add    %eax,%edx
80108d83:	89 c8                	mov    %ecx,%eax
80108d85:	66 25 ff 03          	and    $0x3ff,%ax
80108d89:	0f b7 c0             	movzwl %ax,%eax
80108d8c:	25 ff 03 00 00       	and    $0x3ff,%eax
80108d91:	c1 e0 0a             	shl    $0xa,%eax
80108d94:	89 c1                	mov    %eax,%ecx
80108d96:	8b 02                	mov    (%edx),%eax
80108d98:	25 ff 03 f0 ff       	and    $0xfff003ff,%eax
80108d9d:	09 c8                	or     %ecx,%eax
80108d9f:	89 02                	mov    %eax,(%edx)
    pt_entries[i].ppage = *pte >> PTXSHIFT;
80108da1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108da4:	8b 00                	mov    (%eax),%eax
80108da6:	c1 e8 0c             	shr    $0xc,%eax
80108da9:	89 c2                	mov    %eax,%edx
80108dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dae:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80108db5:	8b 45 08             	mov    0x8(%ebp),%eax
80108db8:	01 c8                	add    %ecx,%eax
80108dba:	81 e2 ff ff 0f 00    	and    $0xfffff,%edx
80108dc0:	89 d1                	mov    %edx,%ecx
80108dc2:	81 e1 ff ff 0f 00    	and    $0xfffff,%ecx
80108dc8:	8b 50 04             	mov    0x4(%eax),%edx
80108dcb:	81 e2 00 00 f0 ff    	and    $0xfff00000,%edx
80108dd1:	09 ca                	or     %ecx,%edx
80108dd3:	89 50 04             	mov    %edx,0x4(%eax)
    pt_entries[i].present = *pte & PTE_P;
80108dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108dd9:	8b 08                	mov    (%eax),%ecx
80108ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dde:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80108de5:	8b 45 08             	mov    0x8(%ebp),%eax
80108de8:	01 c2                	add    %eax,%edx
80108dea:	89 c8                	mov    %ecx,%eax
80108dec:	83 e0 01             	and    $0x1,%eax
80108def:	83 e0 01             	and    $0x1,%eax
80108df2:	c1 e0 04             	shl    $0x4,%eax
80108df5:	89 c1                	mov    %eax,%ecx
80108df7:	0f b6 42 06          	movzbl 0x6(%edx),%eax
80108dfb:	83 e0 ef             	and    $0xffffffef,%eax
80108dfe:	09 c8                	or     %ecx,%eax
80108e00:	88 42 06             	mov    %al,0x6(%edx)
    pt_entries[i].writable = (*pte & PTE_W) > 0;
80108e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108e06:	8b 00                	mov    (%eax),%eax
80108e08:	83 e0 02             	and    $0x2,%eax
80108e0b:	89 c2                	mov    %eax,%edx
80108e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e10:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80108e17:	8b 45 08             	mov    0x8(%ebp),%eax
80108e1a:	01 c8                	add    %ecx,%eax
80108e1c:	85 d2                	test   %edx,%edx
80108e1e:	0f 95 c2             	setne  %dl
80108e21:	83 e2 01             	and    $0x1,%edx
80108e24:	89 d1                	mov    %edx,%ecx
80108e26:	c1 e1 05             	shl    $0x5,%ecx
80108e29:	0f b6 50 06          	movzbl 0x6(%eax),%edx
80108e2d:	83 e2 df             	and    $0xffffffdf,%edx
80108e30:	09 ca                	or     %ecx,%edx
80108e32:	88 50 06             	mov    %dl,0x6(%eax)
    pt_entries[i].encrypted = (*pte & PTE_E) > 0;
80108e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108e38:	8b 00                	mov    (%eax),%eax
80108e3a:	25 00 04 00 00       	and    $0x400,%eax
80108e3f:	89 c2                	mov    %eax,%edx
80108e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e44:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80108e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80108e4e:	01 c8                	add    %ecx,%eax
80108e50:	85 d2                	test   %edx,%edx
80108e52:	0f 95 c2             	setne  %dl
80108e55:	89 d1                	mov    %edx,%ecx
80108e57:	c1 e1 07             	shl    $0x7,%ecx
80108e5a:	0f b6 50 06          	movzbl 0x6(%eax),%edx
80108e5e:	83 e2 7f             	and    $0x7f,%edx
80108e61:	09 ca                	or     %ecx,%edx
80108e63:	88 50 06             	mov    %dl,0x6(%eax)
    pt_entries[i].ref = (*pte & PTE_A) > 0;
80108e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108e69:	8b 00                	mov    (%eax),%eax
80108e6b:	83 e0 20             	and    $0x20,%eax
80108e6e:	89 c2                	mov    %eax,%edx
80108e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e73:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80108e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80108e7d:	01 c8                	add    %ecx,%eax
80108e7f:	85 d2                	test   %edx,%edx
80108e81:	0f 95 c2             	setne  %dl
80108e84:	89 d1                	mov    %edx,%ecx
80108e86:	83 e1 01             	and    $0x1,%ecx
80108e89:	0f b6 50 07          	movzbl 0x7(%eax),%edx
80108e8d:	83 e2 fe             	and    $0xfffffffe,%edx
80108e90:	09 ca                	or     %ecx,%edx
80108e92:	88 50 07             	mov    %dl,0x7(%eax)
    //PT_A flag needs to be modified as per clock algo.
    i ++;
80108e95:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if (uva == 0 || i == num) break;
80108e99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108e9d:	74 17                	je     80108eb6 <getpgtable+0x21b>
80108e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ea2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108ea5:	74 0f                	je     80108eb6 <getpgtable+0x21b>
80108ea7:	eb 01                	jmp    80108eaa <getpgtable+0x20f>
      continue;
80108ea9:	90                   	nop
  for (;;uva -=PGSIZE)
80108eaa:	81 6d f4 00 10 00 00 	subl   $0x1000,-0xc(%ebp)
  {
80108eb1:	e9 4e fe ff ff       	jmp    80108d04 <getpgtable+0x69>

  }

  return i;
80108eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
80108eb9:	c9                   	leave  
80108eba:	c3                   	ret    

80108ebb <dump_rawphymem>:


int dump_rawphymem(char *physical_addr, char * buffer) {
80108ebb:	f3 0f 1e fb          	endbr32 
80108ebf:	55                   	push   %ebp
80108ec0:	89 e5                	mov    %esp,%ebp
80108ec2:	56                   	push   %esi
80108ec3:	53                   	push   %ebx
80108ec4:	83 ec 10             	sub    $0x10,%esp
  *buffer = *buffer;
80108ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
80108eca:	0f b6 10             	movzbl (%eax),%edx
80108ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ed0:	88 10                	mov    %dl,(%eax)
  cprintf("p4Debug: dump_rawphymem: %p, %p\n", physical_addr, buffer);
80108ed2:	83 ec 04             	sub    $0x4,%esp
80108ed5:	ff 75 0c             	pushl  0xc(%ebp)
80108ed8:	ff 75 08             	pushl  0x8(%ebp)
80108edb:	68 d4 99 10 80       	push   $0x801099d4
80108ee0:	e8 33 75 ff ff       	call   80100418 <cprintf>
80108ee5:	83 c4 10             	add    $0x10,%esp
  int retval = copyout(myproc()->pgdir, (uint) buffer, (void *) PGROUNDDOWN((int)P2V(physical_addr)), PGSIZE);
80108ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80108eeb:	05 00 00 00 80       	add    $0x80000000,%eax
80108ef0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ef5:	89 c6                	mov    %eax,%esi
80108ef7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80108efa:	e8 90 b5 ff ff       	call   8010448f <myproc>
80108eff:	8b 40 04             	mov    0x4(%eax),%eax
80108f02:	68 00 10 00 00       	push   $0x1000
80108f07:	56                   	push   %esi
80108f08:	53                   	push   %ebx
80108f09:	50                   	push   %eax
80108f0a:	e8 ab f8 ff ff       	call   801087ba <copyout>
80108f0f:	83 c4 10             	add    $0x10,%esp
80108f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (retval)
80108f15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108f19:	74 07                	je     80108f22 <dump_rawphymem+0x67>
    return -1;
80108f1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f20:	eb 05                	jmp    80108f27 <dump_rawphymem+0x6c>
  return 0;
80108f22:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108f27:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108f2a:	5b                   	pop    %ebx
80108f2b:	5e                   	pop    %esi
80108f2c:	5d                   	pop    %ebp
80108f2d:	c3                   	ret    
