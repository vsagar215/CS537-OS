
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
8010002d:	b8 3e 3a 10 80       	mov    $0x80103a3e,%eax
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
80100041:	68 f8 90 10 80       	push   $0x801090f8
80100046:	68 60 d6 10 80       	push   $0x8010d660
8010004b:	e8 1c 52 00 00       	call   8010526c <initlock>
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
8010008f:	68 ff 90 10 80       	push   $0x801090ff
80100094:	50                   	push   %eax
80100095:	e8 3f 50 00 00       	call   801050d9 <initsleeplock>
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
801000d7:	e8 b6 51 00 00       	call   80105292 <acquire>
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
80100116:	e8 e9 51 00 00       	call   80105304 <release>
8010011b:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
8010011e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100121:	83 c0 0c             	add    $0xc,%eax
80100124:	83 ec 0c             	sub    $0xc,%esp
80100127:	50                   	push   %eax
80100128:	e8 ec 4f 00 00       	call   80105119 <acquiresleep>
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
80100197:	e8 68 51 00 00       	call   80105304 <release>
8010019c:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
8010019f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a2:	83 c0 0c             	add    $0xc,%eax
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	50                   	push   %eax
801001a9:	e8 6b 4f 00 00       	call   80105119 <acquiresleep>
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
801001cb:	68 06 91 10 80       	push   $0x80109106
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
80100207:	e8 91 28 00 00       	call   80102a9d <iderw>
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
80100228:	e8 a6 4f 00 00       	call   801051d3 <holdingsleep>
8010022d:	83 c4 10             	add    $0x10,%esp
80100230:	85 c0                	test   %eax,%eax
80100232:	75 0d                	jne    80100241 <bwrite+0x2d>
    panic("bwrite");
80100234:	83 ec 0c             	sub    $0xc,%esp
80100237:	68 17 91 10 80       	push   $0x80109117
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
80100256:	e8 42 28 00 00       	call   80102a9d <iderw>
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
80100275:	e8 59 4f 00 00       	call   801051d3 <holdingsleep>
8010027a:	83 c4 10             	add    $0x10,%esp
8010027d:	85 c0                	test   %eax,%eax
8010027f:	75 0d                	jne    8010028e <brelse+0x2d>
    panic("brelse");
80100281:	83 ec 0c             	sub    $0xc,%esp
80100284:	68 1e 91 10 80       	push   $0x8010911e
80100289:	e8 7a 03 00 00       	call   80100608 <panic>

  releasesleep(&b->lock);
8010028e:	8b 45 08             	mov    0x8(%ebp),%eax
80100291:	83 c0 0c             	add    $0xc,%eax
80100294:	83 ec 0c             	sub    $0xc,%esp
80100297:	50                   	push   %eax
80100298:	e8 e4 4e 00 00       	call   80105181 <releasesleep>
8010029d:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002a0:	83 ec 0c             	sub    $0xc,%esp
801002a3:	68 60 d6 10 80       	push   $0x8010d660
801002a8:	e8 e5 4f 00 00       	call   80105292 <acquire>
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
80100318:	e8 e7 4f 00 00       	call   80105304 <release>
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
80100438:	e8 9c 4f 00 00       	call   801053d9 <holding>
8010043d:	83 c4 10             	add    $0x10,%esp
80100440:	85 c0                	test   %eax,%eax
80100442:	75 10                	jne    80100454 <cprintf+0x3c>
    acquire(&cons.lock);
80100444:	83 ec 0c             	sub    $0xc,%esp
80100447:	68 c0 c5 10 80       	push   $0x8010c5c0
8010044c:	e8 41 4e 00 00       	call   80105292 <acquire>
80100451:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100454:	8b 45 08             	mov    0x8(%ebp),%eax
80100457:	85 c0                	test   %eax,%eax
80100459:	75 0d                	jne    80100468 <cprintf+0x50>
    panic("null fmt");
8010045b:	83 ec 0c             	sub    $0xc,%esp
8010045e:	68 28 91 10 80       	push   $0x80109128
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
801004ee:	8b 04 85 38 91 10 80 	mov    -0x7fef6ec8(,%eax,4),%eax
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
8010054c:	c7 45 ec 31 91 10 80 	movl   $0x80109131,-0x14(%ebp)
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
801005fd:	e8 02 4d 00 00       	call   80105304 <release>
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
80100621:	e8 69 2b 00 00       	call   8010318f <lapicid>
80100626:	83 ec 08             	sub    $0x8,%esp
80100629:	50                   	push   %eax
8010062a:	68 90 91 10 80       	push   $0x80109190
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
80100649:	68 a4 91 10 80       	push   $0x801091a4
8010064e:	e8 c5 fd ff ff       	call   80100418 <cprintf>
80100653:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
80100656:	83 ec 08             	sub    $0x8,%esp
80100659:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010065c:	50                   	push   %eax
8010065d:	8d 45 08             	lea    0x8(%ebp),%eax
80100660:	50                   	push   %eax
80100661:	e8 f4 4c 00 00       	call   8010535a <getcallerpcs>
80100666:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100669:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100670:	eb 1c                	jmp    8010068e <panic+0x86>
    cprintf(" %p", pcs[i]);
80100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100675:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100679:	83 ec 08             	sub    $0x8,%esp
8010067c:	50                   	push   %eax
8010067d:	68 a6 91 10 80       	push   $0x801091a6
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
80100772:	68 aa 91 10 80       	push   $0x801091aa
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
8010079f:	e8 54 4e 00 00       	call   801055f8 <memmove>
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
801007c9:	e8 63 4d 00 00       	call   80105531 <memset>
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
80100865:	e8 b9 67 00 00       	call   80107023 <uartputc>
8010086a:	83 c4 10             	add    $0x10,%esp
8010086d:	83 ec 0c             	sub    $0xc,%esp
80100870:	6a 20                	push   $0x20
80100872:	e8 ac 67 00 00       	call   80107023 <uartputc>
80100877:	83 c4 10             	add    $0x10,%esp
8010087a:	83 ec 0c             	sub    $0xc,%esp
8010087d:	6a 08                	push   $0x8
8010087f:	e8 9f 67 00 00       	call   80107023 <uartputc>
80100884:	83 c4 10             	add    $0x10,%esp
80100887:	eb 0e                	jmp    80100897 <consputc+0x5a>
  } else
    uartputc(c);
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	ff 75 08             	pushl  0x8(%ebp)
8010088f:	e8 8f 67 00 00       	call   80107023 <uartputc>
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
801008c1:	e8 cc 49 00 00       	call   80105292 <acquire>
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
80100a17:	e8 f6 44 00 00       	call   80104f12 <wakeup>
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
80100a3a:	e8 c5 48 00 00       	call   80105304 <release>
80100a3f:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a46:	74 05                	je     80100a4d <consoleintr+0x1a5>
    procdump();  // now call procdump() wo. cons.lock held
80100a48:	e8 8b 45 00 00       	call   80104fd8 <procdump>
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
80100a60:	e8 be 11 00 00       	call   80101c23 <iunlock>
80100a65:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a68:	8b 45 10             	mov    0x10(%ebp),%eax
80100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a6e:	83 ec 0c             	sub    $0xc,%esp
80100a71:	68 c0 c5 10 80       	push   $0x8010c5c0
80100a76:	e8 17 48 00 00       	call   80105292 <acquire>
80100a7b:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a7e:	e9 ab 00 00 00       	jmp    80100b2e <consoleread+0xde>
    while(input.r == input.w){
      if(myproc()->killed){
80100a83:	e8 38 3a 00 00       	call   801044c0 <myproc>
80100a88:	8b 40 24             	mov    0x24(%eax),%eax
80100a8b:	85 c0                	test   %eax,%eax
80100a8d:	74 28                	je     80100ab7 <consoleread+0x67>
        release(&cons.lock);
80100a8f:	83 ec 0c             	sub    $0xc,%esp
80100a92:	68 c0 c5 10 80       	push   $0x8010c5c0
80100a97:	e8 68 48 00 00       	call   80105304 <release>
80100a9c:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a9f:	83 ec 0c             	sub    $0xc,%esp
80100aa2:	ff 75 08             	pushl  0x8(%ebp)
80100aa5:	e8 62 10 00 00       	call   80101b0c <ilock>
80100aaa:	83 c4 10             	add    $0x10,%esp
        return -1;
80100aad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ab2:	e9 ab 00 00 00       	jmp    80100b62 <consoleread+0x112>
      }
      sleep(&input.r, &cons.lock);
80100ab7:	83 ec 08             	sub    $0x8,%esp
80100aba:	68 c0 c5 10 80       	push   $0x8010c5c0
80100abf:	68 40 20 11 80       	push   $0x80112040
80100ac4:	e8 57 43 00 00       	call   80104e20 <sleep>
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
80100b42:	e8 bd 47 00 00       	call   80105304 <release>
80100b47:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b4a:	83 ec 0c             	sub    $0xc,%esp
80100b4d:	ff 75 08             	pushl  0x8(%ebp)
80100b50:	e8 b7 0f 00 00       	call   80101b0c <ilock>
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
80100b74:	e8 aa 10 00 00       	call   80101c23 <iunlock>
80100b79:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b7c:	83 ec 0c             	sub    $0xc,%esp
80100b7f:	68 c0 c5 10 80       	push   $0x8010c5c0
80100b84:	e8 09 47 00 00       	call   80105292 <acquire>
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
80100bc6:	e8 39 47 00 00       	call   80105304 <release>
80100bcb:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bce:	83 ec 0c             	sub    $0xc,%esp
80100bd1:	ff 75 08             	pushl  0x8(%ebp)
80100bd4:	e8 33 0f 00 00       	call   80101b0c <ilock>
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
80100bee:	68 bd 91 10 80       	push   $0x801091bd
80100bf3:	68 c0 c5 10 80       	push   $0x8010c5c0
80100bf8:	e8 6f 46 00 00       	call   8010526c <initlock>
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
80100c25:	e8 4c 20 00 00       	call   80102c76 <ioapicenable>
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
80100c37:	81 ec 28 01 00 00    	sub    $0x128,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100c3d:	e8 7e 38 00 00       	call   801044c0 <myproc>
80100c42:	89 45 cc             	mov    %eax,-0x34(%ebp)

  begin_op();
80100c45:	e8 b7 2a 00 00       	call   80103701 <begin_op>

  if((ip = namei(path)) == 0){
80100c4a:	83 ec 0c             	sub    $0xc,%esp
80100c4d:	ff 75 08             	pushl  0x8(%ebp)
80100c50:	e8 22 1a 00 00       	call   80102677 <namei>
80100c55:	83 c4 10             	add    $0x10,%esp
80100c58:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c5b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c5f:	75 1f                	jne    80100c80 <exec+0x50>
    end_op();
80100c61:	e8 2b 2b 00 00       	call   80103791 <end_op>
    cprintf("exec: fail\n");
80100c66:	83 ec 0c             	sub    $0xc,%esp
80100c69:	68 c5 91 10 80       	push   $0x801091c5
80100c6e:	e8 a5 f7 ff ff       	call   80100418 <cprintf>
80100c73:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c7b:	e9 22 04 00 00       	jmp    801010a2 <exec+0x472>
  }
  ilock(ip);
80100c80:	83 ec 0c             	sub    $0xc,%esp
80100c83:	ff 75 d8             	pushl  -0x28(%ebp)
80100c86:	e8 81 0e 00 00       	call   80101b0c <ilock>
80100c8b:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c8e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c95:	6a 34                	push   $0x34
80100c97:	6a 00                	push   $0x0
80100c99:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c9f:	50                   	push   %eax
80100ca0:	ff 75 d8             	pushl  -0x28(%ebp)
80100ca3:	e8 6c 13 00 00       	call   80102014 <readi>
80100ca8:	83 c4 10             	add    $0x10,%esp
80100cab:	83 f8 34             	cmp    $0x34,%eax
80100cae:	0f 85 97 03 00 00    	jne    8010104b <exec+0x41b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100cb4:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
80100cba:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100cbf:	0f 85 89 03 00 00    	jne    8010104e <exec+0x41e>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100cc5:	e8 dc 74 00 00       	call   801081a6 <setupkvm>
80100cca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100ccd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100cd1:	0f 84 7a 03 00 00    	je     80101051 <exec+0x421>
    goto bad;

  // Load program into memory.
  sz = 0;
80100cd7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cde:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100ce5:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
80100ceb:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cee:	e9 de 00 00 00       	jmp    80100dd1 <exec+0x1a1>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cf6:	6a 20                	push   $0x20
80100cf8:	50                   	push   %eax
80100cf9:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
80100cff:	50                   	push   %eax
80100d00:	ff 75 d8             	pushl  -0x28(%ebp)
80100d03:	e8 0c 13 00 00       	call   80102014 <readi>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	83 f8 20             	cmp    $0x20,%eax
80100d0e:	0f 85 40 03 00 00    	jne    80101054 <exec+0x424>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100d14:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
80100d1a:	83 f8 01             	cmp    $0x1,%eax
80100d1d:	0f 85 a0 00 00 00    	jne    80100dc3 <exec+0x193>
      continue;
    if(ph.memsz < ph.filesz)
80100d23:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100d29:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100d2f:	39 c2                	cmp    %eax,%edx
80100d31:	0f 82 20 03 00 00    	jb     80101057 <exec+0x427>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100d37:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100d3d:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100d43:	01 c2                	add    %eax,%edx
80100d45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d4b:	39 c2                	cmp    %eax,%edx
80100d4d:	0f 82 07 03 00 00    	jb     8010105a <exec+0x42a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d53:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100d59:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100d5f:	01 d0                	add    %edx,%eax
80100d61:	83 ec 04             	sub    $0x4,%esp
80100d64:	50                   	push   %eax
80100d65:	ff 75 e0             	pushl  -0x20(%ebp)
80100d68:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d6b:	e8 f4 77 00 00       	call   80108564 <allocuvm>
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d7a:	0f 84 dd 02 00 00    	je     8010105d <exec+0x42d>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100d80:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d86:	25 ff 0f 00 00       	and    $0xfff,%eax
80100d8b:	85 c0                	test   %eax,%eax
80100d8d:	0f 85 cd 02 00 00    	jne    80101060 <exec+0x430>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d93:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100d99:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100d9f:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100da5:	83 ec 0c             	sub    $0xc,%esp
80100da8:	52                   	push   %edx
80100da9:	50                   	push   %eax
80100daa:	ff 75 d8             	pushl  -0x28(%ebp)
80100dad:	51                   	push   %ecx
80100dae:	ff 75 d4             	pushl  -0x2c(%ebp)
80100db1:	e8 dd 76 00 00       	call   80108493 <loaduvm>
80100db6:	83 c4 20             	add    $0x20,%esp
80100db9:	85 c0                	test   %eax,%eax
80100dbb:	0f 88 a2 02 00 00    	js     80101063 <exec+0x433>
80100dc1:	eb 01                	jmp    80100dc4 <exec+0x194>
      continue;
80100dc3:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dc4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100dcb:	83 c0 20             	add    $0x20,%eax
80100dce:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100dd1:	0f b7 85 30 ff ff ff 	movzwl -0xd0(%ebp),%eax
80100dd8:	0f b7 c0             	movzwl %ax,%eax
80100ddb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100dde:	0f 8c 0f ff ff ff    	jl     80100cf3 <exec+0xc3>
      goto bad;
  }
  iunlockput(ip);
80100de4:	83 ec 0c             	sub    $0xc,%esp
80100de7:	ff 75 d8             	pushl  -0x28(%ebp)
80100dea:	e8 5a 0f 00 00       	call   80101d49 <iunlockput>
80100def:	83 c4 10             	add    $0x10,%esp
  end_op();
80100df2:	e8 9a 29 00 00       	call   80103791 <end_op>
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
80100e20:	e8 3f 77 00 00       	call   80108564 <allocuvm>
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e2b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e2f:	0f 84 31 02 00 00    	je     80101066 <exec+0x436>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e38:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e3d:	83 ec 08             	sub    $0x8,%esp
80100e40:	50                   	push   %eax
80100e41:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e44:	e8 8d 79 00 00       	call   801087d6 <clearpteu>
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
80100e62:	0f 87 01 02 00 00    	ja     80101069 <exec+0x439>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e72:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e75:	01 d0                	add    %edx,%eax
80100e77:	8b 00                	mov    (%eax),%eax
80100e79:	83 ec 0c             	sub    $0xc,%esp
80100e7c:	50                   	push   %eax
80100e7d:	e8 18 49 00 00       	call   8010579a <strlen>
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
80100eaa:	e8 eb 48 00 00       	call   8010579a <strlen>
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
80100ed0:	e8 bd 7a 00 00       	call   80108992 <copyout>
80100ed5:	83 c4 10             	add    $0x10,%esp
80100ed8:	85 c0                	test   %eax,%eax
80100eda:	0f 88 8c 01 00 00    	js     8010106c <exec+0x43c>
      goto bad;
    ustack[3+argc] = sp;
80100ee0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee3:	8d 50 03             	lea    0x3(%eax),%edx
80100ee6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ee9:	89 84 95 38 ff ff ff 	mov    %eax,-0xc8(%ebp,%edx,4)
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
80100f13:	c7 84 85 38 ff ff ff 	movl   $0x0,-0xc8(%ebp,%eax,4)
80100f1a:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f1e:	c7 85 38 ff ff ff ff 	movl   $0xffffffff,-0xc8(%ebp)
80100f25:	ff ff ff 
  ustack[1] = argc;
80100f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f2b:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f34:	83 c0 01             	add    $0x1,%eax
80100f37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f41:	29 d0                	sub    %edx,%eax
80100f43:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

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
80100f5f:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
80100f65:	50                   	push   %eax
80100f66:	ff 75 dc             	pushl  -0x24(%ebp)
80100f69:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f6c:	e8 21 7a 00 00       	call   80108992 <copyout>
80100f71:	83 c4 10             	add    $0x10,%esp
80100f74:	85 c0                	test   %eax,%eax
80100f76:	0f 88 f3 00 00 00    	js     8010106f <exec+0x43f>
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
80100fab:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100fae:	83 c0 6c             	add    $0x6c,%eax
80100fb1:	83 ec 04             	sub    $0x4,%esp
80100fb4:	6a 10                	push   $0x10
80100fb6:	ff 75 f0             	pushl  -0x10(%ebp)
80100fb9:	50                   	push   %eax
80100fba:	e8 8d 47 00 00       	call   8010574c <safestrcpy>
80100fbf:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100fc2:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100fc5:	8b 40 04             	mov    0x4(%eax),%eax
80100fc8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  curproc->pgdir = pgdir;
80100fcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100fce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100fd1:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100fd4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100fd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100fda:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100fdc:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100fdf:	8b 40 18             	mov    0x18(%eax),%eax
80100fe2:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
80100fe8:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100feb:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100fee:	8b 40 18             	mov    0x18(%eax),%eax
80100ff1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ff4:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100ff7:	83 ec 0c             	sub    $0xc,%esp
80100ffa:	ff 75 cc             	pushl  -0x34(%ebp)
80100ffd:	e8 7a 72 00 00       	call   8010827c <switchuvm>
80101002:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	ff 75 c8             	pushl  -0x38(%ebp)
8010100b:	e8 27 77 00 00       	call   80108737 <freevm>
80101010:	83 c4 10             	add    $0x10,%esp


  /*resetting process queue*/
  curproc->clock.index = -1;
80101013:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101016:	c7 80 bc 00 00 00 ff 	movl   $0xffffffff,0xbc(%eax)
8010101d:	ff ff ff 
  for(int i = 0; i < CLOCKSIZE; i++) curproc->clock.queue[i].vpn = -1;
80101020:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
80101027:	eb 15                	jmp    8010103e <exec+0x40e>
80101029:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010102c:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010102f:	83 c2 0e             	add    $0xe,%edx
80101032:	c7 44 d0 0c ff ff ff 	movl   $0xffffffff,0xc(%eax,%edx,8)
80101039:	ff 
8010103a:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
8010103e:	83 7d d0 07          	cmpl   $0x7,-0x30(%ebp)
80101042:	7e e5                	jle    80101029 <exec+0x3f9>

  return 0;
80101044:	b8 00 00 00 00       	mov    $0x0,%eax
80101049:	eb 57                	jmp    801010a2 <exec+0x472>
    goto bad;
8010104b:	90                   	nop
8010104c:	eb 22                	jmp    80101070 <exec+0x440>
    goto bad;
8010104e:	90                   	nop
8010104f:	eb 1f                	jmp    80101070 <exec+0x440>
    goto bad;
80101051:	90                   	nop
80101052:	eb 1c                	jmp    80101070 <exec+0x440>
      goto bad;
80101054:	90                   	nop
80101055:	eb 19                	jmp    80101070 <exec+0x440>
      goto bad;
80101057:	90                   	nop
80101058:	eb 16                	jmp    80101070 <exec+0x440>
      goto bad;
8010105a:	90                   	nop
8010105b:	eb 13                	jmp    80101070 <exec+0x440>
      goto bad;
8010105d:	90                   	nop
8010105e:	eb 10                	jmp    80101070 <exec+0x440>
      goto bad;
80101060:	90                   	nop
80101061:	eb 0d                	jmp    80101070 <exec+0x440>
      goto bad;
80101063:	90                   	nop
80101064:	eb 0a                	jmp    80101070 <exec+0x440>
    goto bad;
80101066:	90                   	nop
80101067:	eb 07                	jmp    80101070 <exec+0x440>
      goto bad;
80101069:	90                   	nop
8010106a:	eb 04                	jmp    80101070 <exec+0x440>
      goto bad;
8010106c:	90                   	nop
8010106d:	eb 01                	jmp    80101070 <exec+0x440>
    goto bad;
8010106f:	90                   	nop

 bad:
  if(pgdir)
80101070:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101074:	74 0e                	je     80101084 <exec+0x454>
    freevm(pgdir);
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	ff 75 d4             	pushl  -0x2c(%ebp)
8010107c:	e8 b6 76 00 00       	call   80108737 <freevm>
80101081:	83 c4 10             	add    $0x10,%esp
  if(ip){
80101084:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101088:	74 13                	je     8010109d <exec+0x46d>
    iunlockput(ip);
8010108a:	83 ec 0c             	sub    $0xc,%esp
8010108d:	ff 75 d8             	pushl  -0x28(%ebp)
80101090:	e8 b4 0c 00 00       	call   80101d49 <iunlockput>
80101095:	83 c4 10             	add    $0x10,%esp
    end_op();
80101098:	e8 f4 26 00 00       	call   80103791 <end_op>
  }
  return -1;
8010109d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010a2:	c9                   	leave  
801010a3:	c3                   	ret    

801010a4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010a4:	f3 0f 1e fb          	endbr32 
801010a8:	55                   	push   %ebp
801010a9:	89 e5                	mov    %esp,%ebp
801010ab:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
801010ae:	83 ec 08             	sub    $0x8,%esp
801010b1:	68 d1 91 10 80       	push   $0x801091d1
801010b6:	68 60 20 11 80       	push   $0x80112060
801010bb:	e8 ac 41 00 00       	call   8010526c <initlock>
801010c0:	83 c4 10             	add    $0x10,%esp
}
801010c3:	90                   	nop
801010c4:	c9                   	leave  
801010c5:	c3                   	ret    

801010c6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010c6:	f3 0f 1e fb          	endbr32 
801010ca:	55                   	push   %ebp
801010cb:	89 e5                	mov    %esp,%ebp
801010cd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
801010d0:	83 ec 0c             	sub    $0xc,%esp
801010d3:	68 60 20 11 80       	push   $0x80112060
801010d8:	e8 b5 41 00 00       	call   80105292 <acquire>
801010dd:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010e0:	c7 45 f4 94 20 11 80 	movl   $0x80112094,-0xc(%ebp)
801010e7:	eb 2d                	jmp    80101116 <filealloc+0x50>
    if(f->ref == 0){
801010e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010ec:	8b 40 04             	mov    0x4(%eax),%eax
801010ef:	85 c0                	test   %eax,%eax
801010f1:	75 1f                	jne    80101112 <filealloc+0x4c>
      f->ref = 1;
801010f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010f6:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
801010fd:	83 ec 0c             	sub    $0xc,%esp
80101100:	68 60 20 11 80       	push   $0x80112060
80101105:	e8 fa 41 00 00       	call   80105304 <release>
8010110a:	83 c4 10             	add    $0x10,%esp
      return f;
8010110d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101110:	eb 23                	jmp    80101135 <filealloc+0x6f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101112:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101116:	b8 f4 29 11 80       	mov    $0x801129f4,%eax
8010111b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010111e:	72 c9                	jb     801010e9 <filealloc+0x23>
    }
  }
  release(&ftable.lock);
80101120:	83 ec 0c             	sub    $0xc,%esp
80101123:	68 60 20 11 80       	push   $0x80112060
80101128:	e8 d7 41 00 00       	call   80105304 <release>
8010112d:	83 c4 10             	add    $0x10,%esp
  return 0;
80101130:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101135:	c9                   	leave  
80101136:	c3                   	ret    

80101137 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101137:	f3 0f 1e fb          	endbr32 
8010113b:	55                   	push   %ebp
8010113c:	89 e5                	mov    %esp,%ebp
8010113e:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101141:	83 ec 0c             	sub    $0xc,%esp
80101144:	68 60 20 11 80       	push   $0x80112060
80101149:	e8 44 41 00 00       	call   80105292 <acquire>
8010114e:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101151:	8b 45 08             	mov    0x8(%ebp),%eax
80101154:	8b 40 04             	mov    0x4(%eax),%eax
80101157:	85 c0                	test   %eax,%eax
80101159:	7f 0d                	jg     80101168 <filedup+0x31>
    panic("filedup");
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	68 d8 91 10 80       	push   $0x801091d8
80101163:	e8 a0 f4 ff ff       	call   80100608 <panic>
  f->ref++;
80101168:	8b 45 08             	mov    0x8(%ebp),%eax
8010116b:	8b 40 04             	mov    0x4(%eax),%eax
8010116e:	8d 50 01             	lea    0x1(%eax),%edx
80101171:	8b 45 08             	mov    0x8(%ebp),%eax
80101174:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101177:	83 ec 0c             	sub    $0xc,%esp
8010117a:	68 60 20 11 80       	push   $0x80112060
8010117f:	e8 80 41 00 00       	call   80105304 <release>
80101184:	83 c4 10             	add    $0x10,%esp
  return f;
80101187:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010118a:	c9                   	leave  
8010118b:	c3                   	ret    

8010118c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010118c:	f3 0f 1e fb          	endbr32 
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 60 20 11 80       	push   $0x80112060
8010119e:	e8 ef 40 00 00       	call   80105292 <acquire>
801011a3:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801011a6:	8b 45 08             	mov    0x8(%ebp),%eax
801011a9:	8b 40 04             	mov    0x4(%eax),%eax
801011ac:	85 c0                	test   %eax,%eax
801011ae:	7f 0d                	jg     801011bd <fileclose+0x31>
    panic("fileclose");
801011b0:	83 ec 0c             	sub    $0xc,%esp
801011b3:	68 e0 91 10 80       	push   $0x801091e0
801011b8:	e8 4b f4 ff ff       	call   80100608 <panic>
  if(--f->ref > 0){
801011bd:	8b 45 08             	mov    0x8(%ebp),%eax
801011c0:	8b 40 04             	mov    0x4(%eax),%eax
801011c3:	8d 50 ff             	lea    -0x1(%eax),%edx
801011c6:	8b 45 08             	mov    0x8(%ebp),%eax
801011c9:	89 50 04             	mov    %edx,0x4(%eax)
801011cc:	8b 45 08             	mov    0x8(%ebp),%eax
801011cf:	8b 40 04             	mov    0x4(%eax),%eax
801011d2:	85 c0                	test   %eax,%eax
801011d4:	7e 15                	jle    801011eb <fileclose+0x5f>
    release(&ftable.lock);
801011d6:	83 ec 0c             	sub    $0xc,%esp
801011d9:	68 60 20 11 80       	push   $0x80112060
801011de:	e8 21 41 00 00       	call   80105304 <release>
801011e3:	83 c4 10             	add    $0x10,%esp
801011e6:	e9 8b 00 00 00       	jmp    80101276 <fileclose+0xea>
    return;
  }
  ff = *f;
801011eb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ee:	8b 10                	mov    (%eax),%edx
801011f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
801011f3:	8b 50 04             	mov    0x4(%eax),%edx
801011f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801011f9:	8b 50 08             	mov    0x8(%eax),%edx
801011fc:	89 55 e8             	mov    %edx,-0x18(%ebp)
801011ff:	8b 50 0c             	mov    0xc(%eax),%edx
80101202:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101205:	8b 50 10             	mov    0x10(%eax),%edx
80101208:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010120b:	8b 40 14             	mov    0x14(%eax),%eax
8010120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101211:	8b 45 08             	mov    0x8(%ebp),%eax
80101214:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010121b:	8b 45 08             	mov    0x8(%ebp),%eax
8010121e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 60 20 11 80       	push   $0x80112060
8010122c:	e8 d3 40 00 00       	call   80105304 <release>
80101231:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101234:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101237:	83 f8 01             	cmp    $0x1,%eax
8010123a:	75 19                	jne    80101255 <fileclose+0xc9>
    pipeclose(ff.pipe, ff.writable);
8010123c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101240:	0f be d0             	movsbl %al,%edx
80101243:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101246:	83 ec 08             	sub    $0x8,%esp
80101249:	52                   	push   %edx
8010124a:	50                   	push   %eax
8010124b:	e8 e7 2e 00 00       	call   80104137 <pipeclose>
80101250:	83 c4 10             	add    $0x10,%esp
80101253:	eb 21                	jmp    80101276 <fileclose+0xea>
  else if(ff.type == FD_INODE){
80101255:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101258:	83 f8 02             	cmp    $0x2,%eax
8010125b:	75 19                	jne    80101276 <fileclose+0xea>
    begin_op();
8010125d:	e8 9f 24 00 00       	call   80103701 <begin_op>
    iput(ff.ip);
80101262:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101265:	83 ec 0c             	sub    $0xc,%esp
80101268:	50                   	push   %eax
80101269:	e8 07 0a 00 00       	call   80101c75 <iput>
8010126e:	83 c4 10             	add    $0x10,%esp
    end_op();
80101271:	e8 1b 25 00 00       	call   80103791 <end_op>
  }
}
80101276:	c9                   	leave  
80101277:	c3                   	ret    

80101278 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101278:	f3 0f 1e fb          	endbr32 
8010127c:	55                   	push   %ebp
8010127d:	89 e5                	mov    %esp,%ebp
8010127f:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101282:	8b 45 08             	mov    0x8(%ebp),%eax
80101285:	8b 00                	mov    (%eax),%eax
80101287:	83 f8 02             	cmp    $0x2,%eax
8010128a:	75 40                	jne    801012cc <filestat+0x54>
    ilock(f->ip);
8010128c:	8b 45 08             	mov    0x8(%ebp),%eax
8010128f:	8b 40 10             	mov    0x10(%eax),%eax
80101292:	83 ec 0c             	sub    $0xc,%esp
80101295:	50                   	push   %eax
80101296:	e8 71 08 00 00       	call   80101b0c <ilock>
8010129b:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010129e:	8b 45 08             	mov    0x8(%ebp),%eax
801012a1:	8b 40 10             	mov    0x10(%eax),%eax
801012a4:	83 ec 08             	sub    $0x8,%esp
801012a7:	ff 75 0c             	pushl  0xc(%ebp)
801012aa:	50                   	push   %eax
801012ab:	e8 1a 0d 00 00       	call   80101fca <stati>
801012b0:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801012b3:	8b 45 08             	mov    0x8(%ebp),%eax
801012b6:	8b 40 10             	mov    0x10(%eax),%eax
801012b9:	83 ec 0c             	sub    $0xc,%esp
801012bc:	50                   	push   %eax
801012bd:	e8 61 09 00 00       	call   80101c23 <iunlock>
801012c2:	83 c4 10             	add    $0x10,%esp
    return 0;
801012c5:	b8 00 00 00 00       	mov    $0x0,%eax
801012ca:	eb 05                	jmp    801012d1 <filestat+0x59>
  }
  return -1;
801012cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012d1:	c9                   	leave  
801012d2:	c3                   	ret    

801012d3 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012d3:	f3 0f 1e fb          	endbr32 
801012d7:	55                   	push   %ebp
801012d8:	89 e5                	mov    %esp,%ebp
801012da:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801012dd:	8b 45 08             	mov    0x8(%ebp),%eax
801012e0:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801012e4:	84 c0                	test   %al,%al
801012e6:	75 0a                	jne    801012f2 <fileread+0x1f>
    return -1;
801012e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012ed:	e9 9b 00 00 00       	jmp    8010138d <fileread+0xba>
  if(f->type == FD_PIPE)
801012f2:	8b 45 08             	mov    0x8(%ebp),%eax
801012f5:	8b 00                	mov    (%eax),%eax
801012f7:	83 f8 01             	cmp    $0x1,%eax
801012fa:	75 1a                	jne    80101316 <fileread+0x43>
    return piperead(f->pipe, addr, n);
801012fc:	8b 45 08             	mov    0x8(%ebp),%eax
801012ff:	8b 40 0c             	mov    0xc(%eax),%eax
80101302:	83 ec 04             	sub    $0x4,%esp
80101305:	ff 75 10             	pushl  0x10(%ebp)
80101308:	ff 75 0c             	pushl  0xc(%ebp)
8010130b:	50                   	push   %eax
8010130c:	e8 db 2f 00 00       	call   801042ec <piperead>
80101311:	83 c4 10             	add    $0x10,%esp
80101314:	eb 77                	jmp    8010138d <fileread+0xba>
  if(f->type == FD_INODE){
80101316:	8b 45 08             	mov    0x8(%ebp),%eax
80101319:	8b 00                	mov    (%eax),%eax
8010131b:	83 f8 02             	cmp    $0x2,%eax
8010131e:	75 60                	jne    80101380 <fileread+0xad>
    ilock(f->ip);
80101320:	8b 45 08             	mov    0x8(%ebp),%eax
80101323:	8b 40 10             	mov    0x10(%eax),%eax
80101326:	83 ec 0c             	sub    $0xc,%esp
80101329:	50                   	push   %eax
8010132a:	e8 dd 07 00 00       	call   80101b0c <ilock>
8010132f:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101332:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101335:	8b 45 08             	mov    0x8(%ebp),%eax
80101338:	8b 50 14             	mov    0x14(%eax),%edx
8010133b:	8b 45 08             	mov    0x8(%ebp),%eax
8010133e:	8b 40 10             	mov    0x10(%eax),%eax
80101341:	51                   	push   %ecx
80101342:	52                   	push   %edx
80101343:	ff 75 0c             	pushl  0xc(%ebp)
80101346:	50                   	push   %eax
80101347:	e8 c8 0c 00 00       	call   80102014 <readi>
8010134c:	83 c4 10             	add    $0x10,%esp
8010134f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101352:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101356:	7e 11                	jle    80101369 <fileread+0x96>
      f->off += r;
80101358:	8b 45 08             	mov    0x8(%ebp),%eax
8010135b:	8b 50 14             	mov    0x14(%eax),%edx
8010135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101361:	01 c2                	add    %eax,%edx
80101363:	8b 45 08             	mov    0x8(%ebp),%eax
80101366:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101369:	8b 45 08             	mov    0x8(%ebp),%eax
8010136c:	8b 40 10             	mov    0x10(%eax),%eax
8010136f:	83 ec 0c             	sub    $0xc,%esp
80101372:	50                   	push   %eax
80101373:	e8 ab 08 00 00       	call   80101c23 <iunlock>
80101378:	83 c4 10             	add    $0x10,%esp
    return r;
8010137b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010137e:	eb 0d                	jmp    8010138d <fileread+0xba>
  }
  panic("fileread");
80101380:	83 ec 0c             	sub    $0xc,%esp
80101383:	68 ea 91 10 80       	push   $0x801091ea
80101388:	e8 7b f2 ff ff       	call   80100608 <panic>
}
8010138d:	c9                   	leave  
8010138e:	c3                   	ret    

8010138f <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010138f:	f3 0f 1e fb          	endbr32 
80101393:	55                   	push   %ebp
80101394:	89 e5                	mov    %esp,%ebp
80101396:	53                   	push   %ebx
80101397:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010139a:	8b 45 08             	mov    0x8(%ebp),%eax
8010139d:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801013a1:	84 c0                	test   %al,%al
801013a3:	75 0a                	jne    801013af <filewrite+0x20>
    return -1;
801013a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013aa:	e9 1b 01 00 00       	jmp    801014ca <filewrite+0x13b>
  if(f->type == FD_PIPE)
801013af:	8b 45 08             	mov    0x8(%ebp),%eax
801013b2:	8b 00                	mov    (%eax),%eax
801013b4:	83 f8 01             	cmp    $0x1,%eax
801013b7:	75 1d                	jne    801013d6 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801013b9:	8b 45 08             	mov    0x8(%ebp),%eax
801013bc:	8b 40 0c             	mov    0xc(%eax),%eax
801013bf:	83 ec 04             	sub    $0x4,%esp
801013c2:	ff 75 10             	pushl  0x10(%ebp)
801013c5:	ff 75 0c             	pushl  0xc(%ebp)
801013c8:	50                   	push   %eax
801013c9:	e8 18 2e 00 00       	call   801041e6 <pipewrite>
801013ce:	83 c4 10             	add    $0x10,%esp
801013d1:	e9 f4 00 00 00       	jmp    801014ca <filewrite+0x13b>
  if(f->type == FD_INODE){
801013d6:	8b 45 08             	mov    0x8(%ebp),%eax
801013d9:	8b 00                	mov    (%eax),%eax
801013db:	83 f8 02             	cmp    $0x2,%eax
801013de:	0f 85 d9 00 00 00    	jne    801014bd <filewrite+0x12e>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
801013e4:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801013eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801013f2:	e9 a3 00 00 00       	jmp    8010149a <filewrite+0x10b>
      int n1 = n - i;
801013f7:	8b 45 10             	mov    0x10(%ebp),%eax
801013fa:	2b 45 f4             	sub    -0xc(%ebp),%eax
801013fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101400:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101403:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101406:	7e 06                	jle    8010140e <filewrite+0x7f>
        n1 = max;
80101408:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010140b:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010140e:	e8 ee 22 00 00       	call   80103701 <begin_op>
      ilock(f->ip);
80101413:	8b 45 08             	mov    0x8(%ebp),%eax
80101416:	8b 40 10             	mov    0x10(%eax),%eax
80101419:	83 ec 0c             	sub    $0xc,%esp
8010141c:	50                   	push   %eax
8010141d:	e8 ea 06 00 00       	call   80101b0c <ilock>
80101422:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101425:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101428:	8b 45 08             	mov    0x8(%ebp),%eax
8010142b:	8b 50 14             	mov    0x14(%eax),%edx
8010142e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101431:	8b 45 0c             	mov    0xc(%ebp),%eax
80101434:	01 c3                	add    %eax,%ebx
80101436:	8b 45 08             	mov    0x8(%ebp),%eax
80101439:	8b 40 10             	mov    0x10(%eax),%eax
8010143c:	51                   	push   %ecx
8010143d:	52                   	push   %edx
8010143e:	53                   	push   %ebx
8010143f:	50                   	push   %eax
80101440:	e8 28 0d 00 00       	call   8010216d <writei>
80101445:	83 c4 10             	add    $0x10,%esp
80101448:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010144b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010144f:	7e 11                	jle    80101462 <filewrite+0xd3>
        f->off += r;
80101451:	8b 45 08             	mov    0x8(%ebp),%eax
80101454:	8b 50 14             	mov    0x14(%eax),%edx
80101457:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010145a:	01 c2                	add    %eax,%edx
8010145c:	8b 45 08             	mov    0x8(%ebp),%eax
8010145f:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101462:	8b 45 08             	mov    0x8(%ebp),%eax
80101465:	8b 40 10             	mov    0x10(%eax),%eax
80101468:	83 ec 0c             	sub    $0xc,%esp
8010146b:	50                   	push   %eax
8010146c:	e8 b2 07 00 00       	call   80101c23 <iunlock>
80101471:	83 c4 10             	add    $0x10,%esp
      end_op();
80101474:	e8 18 23 00 00       	call   80103791 <end_op>

      if(r < 0)
80101479:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010147d:	78 29                	js     801014a8 <filewrite+0x119>
        break;
      if(r != n1)
8010147f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101482:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101485:	74 0d                	je     80101494 <filewrite+0x105>
        panic("short filewrite");
80101487:	83 ec 0c             	sub    $0xc,%esp
8010148a:	68 f3 91 10 80       	push   $0x801091f3
8010148f:	e8 74 f1 ff ff       	call   80100608 <panic>
      i += r;
80101494:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101497:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
8010149a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010149d:	3b 45 10             	cmp    0x10(%ebp),%eax
801014a0:	0f 8c 51 ff ff ff    	jl     801013f7 <filewrite+0x68>
801014a6:	eb 01                	jmp    801014a9 <filewrite+0x11a>
        break;
801014a8:	90                   	nop
    }
    return i == n ? n : -1;
801014a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014ac:	3b 45 10             	cmp    0x10(%ebp),%eax
801014af:	75 05                	jne    801014b6 <filewrite+0x127>
801014b1:	8b 45 10             	mov    0x10(%ebp),%eax
801014b4:	eb 14                	jmp    801014ca <filewrite+0x13b>
801014b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014bb:	eb 0d                	jmp    801014ca <filewrite+0x13b>
  }
  panic("filewrite");
801014bd:	83 ec 0c             	sub    $0xc,%esp
801014c0:	68 03 92 10 80       	push   $0x80109203
801014c5:	e8 3e f1 ff ff       	call   80100608 <panic>
}
801014ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014cd:	c9                   	leave  
801014ce:	c3                   	ret    

801014cf <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801014cf:	f3 0f 1e fb          	endbr32 
801014d3:	55                   	push   %ebp
801014d4:	89 e5                	mov    %esp,%ebp
801014d6:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801014d9:	8b 45 08             	mov    0x8(%ebp),%eax
801014dc:	83 ec 08             	sub    $0x8,%esp
801014df:	6a 01                	push   $0x1
801014e1:	50                   	push   %eax
801014e2:	e8 f0 ec ff ff       	call   801001d7 <bread>
801014e7:	83 c4 10             	add    $0x10,%esp
801014ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801014ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014f0:	83 c0 5c             	add    $0x5c,%eax
801014f3:	83 ec 04             	sub    $0x4,%esp
801014f6:	6a 1c                	push   $0x1c
801014f8:	50                   	push   %eax
801014f9:	ff 75 0c             	pushl  0xc(%ebp)
801014fc:	e8 f7 40 00 00       	call   801055f8 <memmove>
80101501:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101504:	83 ec 0c             	sub    $0xc,%esp
80101507:	ff 75 f4             	pushl  -0xc(%ebp)
8010150a:	e8 52 ed ff ff       	call   80100261 <brelse>
8010150f:	83 c4 10             	add    $0x10,%esp
}
80101512:	90                   	nop
80101513:	c9                   	leave  
80101514:	c3                   	ret    

80101515 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101515:	f3 0f 1e fb          	endbr32 
80101519:	55                   	push   %ebp
8010151a:	89 e5                	mov    %esp,%ebp
8010151c:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
8010151f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101522:	8b 45 08             	mov    0x8(%ebp),%eax
80101525:	83 ec 08             	sub    $0x8,%esp
80101528:	52                   	push   %edx
80101529:	50                   	push   %eax
8010152a:	e8 a8 ec ff ff       	call   801001d7 <bread>
8010152f:	83 c4 10             	add    $0x10,%esp
80101532:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101538:	83 c0 5c             	add    $0x5c,%eax
8010153b:	83 ec 04             	sub    $0x4,%esp
8010153e:	68 00 02 00 00       	push   $0x200
80101543:	6a 00                	push   $0x0
80101545:	50                   	push   %eax
80101546:	e8 e6 3f 00 00       	call   80105531 <memset>
8010154b:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010154e:	83 ec 0c             	sub    $0xc,%esp
80101551:	ff 75 f4             	pushl  -0xc(%ebp)
80101554:	e8 f1 23 00 00       	call   8010394a <log_write>
80101559:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010155c:	83 ec 0c             	sub    $0xc,%esp
8010155f:	ff 75 f4             	pushl  -0xc(%ebp)
80101562:	e8 fa ec ff ff       	call   80100261 <brelse>
80101567:	83 c4 10             	add    $0x10,%esp
}
8010156a:	90                   	nop
8010156b:	c9                   	leave  
8010156c:	c3                   	ret    

8010156d <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010156d:	f3 0f 1e fb          	endbr32 
80101571:	55                   	push   %ebp
80101572:	89 e5                	mov    %esp,%ebp
80101574:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101577:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010157e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101585:	e9 13 01 00 00       	jmp    8010169d <balloc+0x130>
    bp = bread(dev, BBLOCK(b, sb));
8010158a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010158d:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101593:	85 c0                	test   %eax,%eax
80101595:	0f 48 c2             	cmovs  %edx,%eax
80101598:	c1 f8 0c             	sar    $0xc,%eax
8010159b:	89 c2                	mov    %eax,%edx
8010159d:	a1 78 2a 11 80       	mov    0x80112a78,%eax
801015a2:	01 d0                	add    %edx,%eax
801015a4:	83 ec 08             	sub    $0x8,%esp
801015a7:	50                   	push   %eax
801015a8:	ff 75 08             	pushl  0x8(%ebp)
801015ab:	e8 27 ec ff ff       	call   801001d7 <bread>
801015b0:	83 c4 10             	add    $0x10,%esp
801015b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801015bd:	e9 a6 00 00 00       	jmp    80101668 <balloc+0xfb>
      m = 1 << (bi % 8);
801015c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c5:	99                   	cltd   
801015c6:	c1 ea 1d             	shr    $0x1d,%edx
801015c9:	01 d0                	add    %edx,%eax
801015cb:	83 e0 07             	and    $0x7,%eax
801015ce:	29 d0                	sub    %edx,%eax
801015d0:	ba 01 00 00 00       	mov    $0x1,%edx
801015d5:	89 c1                	mov    %eax,%ecx
801015d7:	d3 e2                	shl    %cl,%edx
801015d9:	89 d0                	mov    %edx,%eax
801015db:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015e1:	8d 50 07             	lea    0x7(%eax),%edx
801015e4:	85 c0                	test   %eax,%eax
801015e6:	0f 48 c2             	cmovs  %edx,%eax
801015e9:	c1 f8 03             	sar    $0x3,%eax
801015ec:	89 c2                	mov    %eax,%edx
801015ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015f1:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801015f6:	0f b6 c0             	movzbl %al,%eax
801015f9:	23 45 e8             	and    -0x18(%ebp),%eax
801015fc:	85 c0                	test   %eax,%eax
801015fe:	75 64                	jne    80101664 <balloc+0xf7>
        bp->data[bi/8] |= m;  // Mark block in use.
80101600:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101603:	8d 50 07             	lea    0x7(%eax),%edx
80101606:	85 c0                	test   %eax,%eax
80101608:	0f 48 c2             	cmovs  %edx,%eax
8010160b:	c1 f8 03             	sar    $0x3,%eax
8010160e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101611:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101616:	89 d1                	mov    %edx,%ecx
80101618:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010161b:	09 ca                	or     %ecx,%edx
8010161d:	89 d1                	mov    %edx,%ecx
8010161f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101622:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101626:	83 ec 0c             	sub    $0xc,%esp
80101629:	ff 75 ec             	pushl  -0x14(%ebp)
8010162c:	e8 19 23 00 00       	call   8010394a <log_write>
80101631:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101634:	83 ec 0c             	sub    $0xc,%esp
80101637:	ff 75 ec             	pushl  -0x14(%ebp)
8010163a:	e8 22 ec ff ff       	call   80100261 <brelse>
8010163f:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101642:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101645:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101648:	01 c2                	add    %eax,%edx
8010164a:	8b 45 08             	mov    0x8(%ebp),%eax
8010164d:	83 ec 08             	sub    $0x8,%esp
80101650:	52                   	push   %edx
80101651:	50                   	push   %eax
80101652:	e8 be fe ff ff       	call   80101515 <bzero>
80101657:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010165a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010165d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101660:	01 d0                	add    %edx,%eax
80101662:	eb 57                	jmp    801016bb <balloc+0x14e>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101664:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101668:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010166f:	7f 17                	jg     80101688 <balloc+0x11b>
80101671:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101674:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101677:	01 d0                	add    %edx,%eax
80101679:	89 c2                	mov    %eax,%edx
8010167b:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80101680:	39 c2                	cmp    %eax,%edx
80101682:	0f 82 3a ff ff ff    	jb     801015c2 <balloc+0x55>
      }
    }
    brelse(bp);
80101688:	83 ec 0c             	sub    $0xc,%esp
8010168b:	ff 75 ec             	pushl  -0x14(%ebp)
8010168e:	e8 ce eb ff ff       	call   80100261 <brelse>
80101693:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
80101696:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010169d:	8b 15 60 2a 11 80    	mov    0x80112a60,%edx
801016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016a6:	39 c2                	cmp    %eax,%edx
801016a8:	0f 87 dc fe ff ff    	ja     8010158a <balloc+0x1d>
  }
  panic("balloc: out of blocks");
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	68 10 92 10 80       	push   $0x80109210
801016b6:	e8 4d ef ff ff       	call   80100608 <panic>
}
801016bb:	c9                   	leave  
801016bc:	c3                   	ret    

801016bd <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016bd:	f3 0f 1e fb          	endbr32 
801016c1:	55                   	push   %ebp
801016c2:	89 e5                	mov    %esp,%ebp
801016c4:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801016c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801016ca:	c1 e8 0c             	shr    $0xc,%eax
801016cd:	89 c2                	mov    %eax,%edx
801016cf:	a1 78 2a 11 80       	mov    0x80112a78,%eax
801016d4:	01 c2                	add    %eax,%edx
801016d6:	8b 45 08             	mov    0x8(%ebp),%eax
801016d9:	83 ec 08             	sub    $0x8,%esp
801016dc:	52                   	push   %edx
801016dd:	50                   	push   %eax
801016de:	e8 f4 ea ff ff       	call   801001d7 <bread>
801016e3:	83 c4 10             	add    $0x10,%esp
801016e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801016e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801016ec:	25 ff 0f 00 00       	and    $0xfff,%eax
801016f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801016f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f7:	99                   	cltd   
801016f8:	c1 ea 1d             	shr    $0x1d,%edx
801016fb:	01 d0                	add    %edx,%eax
801016fd:	83 e0 07             	and    $0x7,%eax
80101700:	29 d0                	sub    %edx,%eax
80101702:	ba 01 00 00 00       	mov    $0x1,%edx
80101707:	89 c1                	mov    %eax,%ecx
80101709:	d3 e2                	shl    %cl,%edx
8010170b:	89 d0                	mov    %edx,%eax
8010170d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101710:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101713:	8d 50 07             	lea    0x7(%eax),%edx
80101716:	85 c0                	test   %eax,%eax
80101718:	0f 48 c2             	cmovs  %edx,%eax
8010171b:	c1 f8 03             	sar    $0x3,%eax
8010171e:	89 c2                	mov    %eax,%edx
80101720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101723:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101728:	0f b6 c0             	movzbl %al,%eax
8010172b:	23 45 ec             	and    -0x14(%ebp),%eax
8010172e:	85 c0                	test   %eax,%eax
80101730:	75 0d                	jne    8010173f <bfree+0x82>
    panic("freeing free block");
80101732:	83 ec 0c             	sub    $0xc,%esp
80101735:	68 26 92 10 80       	push   $0x80109226
8010173a:	e8 c9 ee ff ff       	call   80100608 <panic>
  bp->data[bi/8] &= ~m;
8010173f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101742:	8d 50 07             	lea    0x7(%eax),%edx
80101745:	85 c0                	test   %eax,%eax
80101747:	0f 48 c2             	cmovs  %edx,%eax
8010174a:	c1 f8 03             	sar    $0x3,%eax
8010174d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101750:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101755:	89 d1                	mov    %edx,%ecx
80101757:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010175a:	f7 d2                	not    %edx
8010175c:	21 ca                	and    %ecx,%edx
8010175e:	89 d1                	mov    %edx,%ecx
80101760:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101763:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101767:	83 ec 0c             	sub    $0xc,%esp
8010176a:	ff 75 f4             	pushl  -0xc(%ebp)
8010176d:	e8 d8 21 00 00       	call   8010394a <log_write>
80101772:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101775:	83 ec 0c             	sub    $0xc,%esp
80101778:	ff 75 f4             	pushl  -0xc(%ebp)
8010177b:	e8 e1 ea ff ff       	call   80100261 <brelse>
80101780:	83 c4 10             	add    $0x10,%esp
}
80101783:	90                   	nop
80101784:	c9                   	leave  
80101785:	c3                   	ret    

80101786 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101786:	f3 0f 1e fb          	endbr32 
8010178a:	55                   	push   %ebp
8010178b:	89 e5                	mov    %esp,%ebp
8010178d:	57                   	push   %edi
8010178e:	56                   	push   %esi
8010178f:	53                   	push   %ebx
80101790:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
80101793:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
8010179a:	83 ec 08             	sub    $0x8,%esp
8010179d:	68 39 92 10 80       	push   $0x80109239
801017a2:	68 80 2a 11 80       	push   $0x80112a80
801017a7:	e8 c0 3a 00 00       	call   8010526c <initlock>
801017ac:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801017af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801017b6:	eb 2d                	jmp    801017e5 <iinit+0x5f>
    initsleeplock(&icache.inode[i].lock, "inode");
801017b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801017bb:	89 d0                	mov    %edx,%eax
801017bd:	c1 e0 03             	shl    $0x3,%eax
801017c0:	01 d0                	add    %edx,%eax
801017c2:	c1 e0 04             	shl    $0x4,%eax
801017c5:	83 c0 30             	add    $0x30,%eax
801017c8:	05 80 2a 11 80       	add    $0x80112a80,%eax
801017cd:	83 c0 10             	add    $0x10,%eax
801017d0:	83 ec 08             	sub    $0x8,%esp
801017d3:	68 40 92 10 80       	push   $0x80109240
801017d8:	50                   	push   %eax
801017d9:	e8 fb 38 00 00       	call   801050d9 <initsleeplock>
801017de:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801017e1:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801017e5:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801017e9:	7e cd                	jle    801017b8 <iinit+0x32>
  }

  readsb(dev, &sb);
801017eb:	83 ec 08             	sub    $0x8,%esp
801017ee:	68 60 2a 11 80       	push   $0x80112a60
801017f3:	ff 75 08             	pushl  0x8(%ebp)
801017f6:	e8 d4 fc ff ff       	call   801014cf <readsb>
801017fb:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801017fe:	a1 78 2a 11 80       	mov    0x80112a78,%eax
80101803:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101806:	8b 3d 74 2a 11 80    	mov    0x80112a74,%edi
8010180c:	8b 35 70 2a 11 80    	mov    0x80112a70,%esi
80101812:	8b 1d 6c 2a 11 80    	mov    0x80112a6c,%ebx
80101818:	8b 0d 68 2a 11 80    	mov    0x80112a68,%ecx
8010181e:	8b 15 64 2a 11 80    	mov    0x80112a64,%edx
80101824:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80101829:	ff 75 d4             	pushl  -0x2c(%ebp)
8010182c:	57                   	push   %edi
8010182d:	56                   	push   %esi
8010182e:	53                   	push   %ebx
8010182f:	51                   	push   %ecx
80101830:	52                   	push   %edx
80101831:	50                   	push   %eax
80101832:	68 48 92 10 80       	push   $0x80109248
80101837:	e8 dc eb ff ff       	call   80100418 <cprintf>
8010183c:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010183f:	90                   	nop
80101840:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101843:	5b                   	pop    %ebx
80101844:	5e                   	pop    %esi
80101845:	5f                   	pop    %edi
80101846:	5d                   	pop    %ebp
80101847:	c3                   	ret    

80101848 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101848:	f3 0f 1e fb          	endbr32 
8010184c:	55                   	push   %ebp
8010184d:	89 e5                	mov    %esp,%ebp
8010184f:	83 ec 28             	sub    $0x28,%esp
80101852:	8b 45 0c             	mov    0xc(%ebp),%eax
80101855:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101859:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101860:	e9 9e 00 00 00       	jmp    80101903 <ialloc+0xbb>
    bp = bread(dev, IBLOCK(inum, sb));
80101865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101868:	c1 e8 03             	shr    $0x3,%eax
8010186b:	89 c2                	mov    %eax,%edx
8010186d:	a1 74 2a 11 80       	mov    0x80112a74,%eax
80101872:	01 d0                	add    %edx,%eax
80101874:	83 ec 08             	sub    $0x8,%esp
80101877:	50                   	push   %eax
80101878:	ff 75 08             	pushl  0x8(%ebp)
8010187b:	e8 57 e9 ff ff       	call   801001d7 <bread>
80101880:	83 c4 10             	add    $0x10,%esp
80101883:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101886:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101889:	8d 50 5c             	lea    0x5c(%eax),%edx
8010188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188f:	83 e0 07             	and    $0x7,%eax
80101892:	c1 e0 06             	shl    $0x6,%eax
80101895:	01 d0                	add    %edx,%eax
80101897:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010189a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010189d:	0f b7 00             	movzwl (%eax),%eax
801018a0:	66 85 c0             	test   %ax,%ax
801018a3:	75 4c                	jne    801018f1 <ialloc+0xa9>
      memset(dip, 0, sizeof(*dip));
801018a5:	83 ec 04             	sub    $0x4,%esp
801018a8:	6a 40                	push   $0x40
801018aa:	6a 00                	push   $0x0
801018ac:	ff 75 ec             	pushl  -0x14(%ebp)
801018af:	e8 7d 3c 00 00       	call   80105531 <memset>
801018b4:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801018b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018ba:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801018be:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801018c1:	83 ec 0c             	sub    $0xc,%esp
801018c4:	ff 75 f0             	pushl  -0x10(%ebp)
801018c7:	e8 7e 20 00 00       	call   8010394a <log_write>
801018cc:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801018cf:	83 ec 0c             	sub    $0xc,%esp
801018d2:	ff 75 f0             	pushl  -0x10(%ebp)
801018d5:	e8 87 e9 ff ff       	call   80100261 <brelse>
801018da:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801018dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e0:	83 ec 08             	sub    $0x8,%esp
801018e3:	50                   	push   %eax
801018e4:	ff 75 08             	pushl  0x8(%ebp)
801018e7:	e8 fc 00 00 00       	call   801019e8 <iget>
801018ec:	83 c4 10             	add    $0x10,%esp
801018ef:	eb 30                	jmp    80101921 <ialloc+0xd9>
    }
    brelse(bp);
801018f1:	83 ec 0c             	sub    $0xc,%esp
801018f4:	ff 75 f0             	pushl  -0x10(%ebp)
801018f7:	e8 65 e9 ff ff       	call   80100261 <brelse>
801018fc:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801018ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101903:	8b 15 68 2a 11 80    	mov    0x80112a68,%edx
80101909:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190c:	39 c2                	cmp    %eax,%edx
8010190e:	0f 87 51 ff ff ff    	ja     80101865 <ialloc+0x1d>
  }
  panic("ialloc: no inodes");
80101914:	83 ec 0c             	sub    $0xc,%esp
80101917:	68 9b 92 10 80       	push   $0x8010929b
8010191c:	e8 e7 ec ff ff       	call   80100608 <panic>
}
80101921:	c9                   	leave  
80101922:	c3                   	ret    

80101923 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101923:	f3 0f 1e fb          	endbr32 
80101927:	55                   	push   %ebp
80101928:	89 e5                	mov    %esp,%ebp
8010192a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010192d:	8b 45 08             	mov    0x8(%ebp),%eax
80101930:	8b 40 04             	mov    0x4(%eax),%eax
80101933:	c1 e8 03             	shr    $0x3,%eax
80101936:	89 c2                	mov    %eax,%edx
80101938:	a1 74 2a 11 80       	mov    0x80112a74,%eax
8010193d:	01 c2                	add    %eax,%edx
8010193f:	8b 45 08             	mov    0x8(%ebp),%eax
80101942:	8b 00                	mov    (%eax),%eax
80101944:	83 ec 08             	sub    $0x8,%esp
80101947:	52                   	push   %edx
80101948:	50                   	push   %eax
80101949:	e8 89 e8 ff ff       	call   801001d7 <bread>
8010194e:	83 c4 10             	add    $0x10,%esp
80101951:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101954:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101957:	8d 50 5c             	lea    0x5c(%eax),%edx
8010195a:	8b 45 08             	mov    0x8(%ebp),%eax
8010195d:	8b 40 04             	mov    0x4(%eax),%eax
80101960:	83 e0 07             	and    $0x7,%eax
80101963:	c1 e0 06             	shl    $0x6,%eax
80101966:	01 d0                	add    %edx,%eax
80101968:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010196b:	8b 45 08             	mov    0x8(%ebp),%eax
8010196e:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101972:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101975:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101978:	8b 45 08             	mov    0x8(%ebp),%eax
8010197b:	0f b7 50 52          	movzwl 0x52(%eax),%edx
8010197f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101982:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101986:	8b 45 08             	mov    0x8(%ebp),%eax
80101989:	0f b7 50 54          	movzwl 0x54(%eax),%edx
8010198d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101990:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101994:	8b 45 08             	mov    0x8(%ebp),%eax
80101997:	0f b7 50 56          	movzwl 0x56(%eax),%edx
8010199b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199e:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801019a2:	8b 45 08             	mov    0x8(%ebp),%eax
801019a5:	8b 50 58             	mov    0x58(%eax),%edx
801019a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ab:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019ae:	8b 45 08             	mov    0x8(%ebp),%eax
801019b1:	8d 50 5c             	lea    0x5c(%eax),%edx
801019b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b7:	83 c0 0c             	add    $0xc,%eax
801019ba:	83 ec 04             	sub    $0x4,%esp
801019bd:	6a 34                	push   $0x34
801019bf:	52                   	push   %edx
801019c0:	50                   	push   %eax
801019c1:	e8 32 3c 00 00       	call   801055f8 <memmove>
801019c6:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801019c9:	83 ec 0c             	sub    $0xc,%esp
801019cc:	ff 75 f4             	pushl  -0xc(%ebp)
801019cf:	e8 76 1f 00 00       	call   8010394a <log_write>
801019d4:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801019d7:	83 ec 0c             	sub    $0xc,%esp
801019da:	ff 75 f4             	pushl  -0xc(%ebp)
801019dd:	e8 7f e8 ff ff       	call   80100261 <brelse>
801019e2:	83 c4 10             	add    $0x10,%esp
}
801019e5:	90                   	nop
801019e6:	c9                   	leave  
801019e7:	c3                   	ret    

801019e8 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019e8:	f3 0f 1e fb          	endbr32 
801019ec:	55                   	push   %ebp
801019ed:	89 e5                	mov    %esp,%ebp
801019ef:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801019f2:	83 ec 0c             	sub    $0xc,%esp
801019f5:	68 80 2a 11 80       	push   $0x80112a80
801019fa:	e8 93 38 00 00       	call   80105292 <acquire>
801019ff:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101a02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a09:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
80101a10:	eb 60                	jmp    80101a72 <iget+0x8a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a15:	8b 40 08             	mov    0x8(%eax),%eax
80101a18:	85 c0                	test   %eax,%eax
80101a1a:	7e 39                	jle    80101a55 <iget+0x6d>
80101a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a1f:	8b 00                	mov    (%eax),%eax
80101a21:	39 45 08             	cmp    %eax,0x8(%ebp)
80101a24:	75 2f                	jne    80101a55 <iget+0x6d>
80101a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a29:	8b 40 04             	mov    0x4(%eax),%eax
80101a2c:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101a2f:	75 24                	jne    80101a55 <iget+0x6d>
      ip->ref++;
80101a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a34:	8b 40 08             	mov    0x8(%eax),%eax
80101a37:	8d 50 01             	lea    0x1(%eax),%edx
80101a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a3d:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101a40:	83 ec 0c             	sub    $0xc,%esp
80101a43:	68 80 2a 11 80       	push   $0x80112a80
80101a48:	e8 b7 38 00 00       	call   80105304 <release>
80101a4d:	83 c4 10             	add    $0x10,%esp
      return ip;
80101a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a53:	eb 77                	jmp    80101acc <iget+0xe4>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a59:	75 10                	jne    80101a6b <iget+0x83>
80101a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a5e:	8b 40 08             	mov    0x8(%eax),%eax
80101a61:	85 c0                	test   %eax,%eax
80101a63:	75 06                	jne    80101a6b <iget+0x83>
      empty = ip;
80101a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a6b:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101a72:	81 7d f4 d4 46 11 80 	cmpl   $0x801146d4,-0xc(%ebp)
80101a79:	72 97                	jb     80101a12 <iget+0x2a>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a7f:	75 0d                	jne    80101a8e <iget+0xa6>
    panic("iget: no inodes");
80101a81:	83 ec 0c             	sub    $0xc,%esp
80101a84:	68 ad 92 10 80       	push   $0x801092ad
80101a89:	e8 7a eb ff ff       	call   80100608 <panic>

  ip = empty;
80101a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a97:	8b 55 08             	mov    0x8(%ebp),%edx
80101a9a:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a9f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101aa2:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aa8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ab2:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101ab9:	83 ec 0c             	sub    $0xc,%esp
80101abc:	68 80 2a 11 80       	push   $0x80112a80
80101ac1:	e8 3e 38 00 00       	call   80105304 <release>
80101ac6:	83 c4 10             	add    $0x10,%esp

  return ip;
80101ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101acc:	c9                   	leave  
80101acd:	c3                   	ret    

80101ace <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101ace:	f3 0f 1e fb          	endbr32 
80101ad2:	55                   	push   %ebp
80101ad3:	89 e5                	mov    %esp,%ebp
80101ad5:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101ad8:	83 ec 0c             	sub    $0xc,%esp
80101adb:	68 80 2a 11 80       	push   $0x80112a80
80101ae0:	e8 ad 37 00 00       	call   80105292 <acquire>
80101ae5:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aeb:	8b 40 08             	mov    0x8(%eax),%eax
80101aee:	8d 50 01             	lea    0x1(%eax),%edx
80101af1:	8b 45 08             	mov    0x8(%ebp),%eax
80101af4:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101af7:	83 ec 0c             	sub    $0xc,%esp
80101afa:	68 80 2a 11 80       	push   $0x80112a80
80101aff:	e8 00 38 00 00       	call   80105304 <release>
80101b04:	83 c4 10             	add    $0x10,%esp
  return ip;
80101b07:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101b0a:	c9                   	leave  
80101b0b:	c3                   	ret    

80101b0c <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101b0c:	f3 0f 1e fb          	endbr32 
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101b16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b1a:	74 0a                	je     80101b26 <ilock+0x1a>
80101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1f:	8b 40 08             	mov    0x8(%eax),%eax
80101b22:	85 c0                	test   %eax,%eax
80101b24:	7f 0d                	jg     80101b33 <ilock+0x27>
    panic("ilock");
80101b26:	83 ec 0c             	sub    $0xc,%esp
80101b29:	68 bd 92 10 80       	push   $0x801092bd
80101b2e:	e8 d5 ea ff ff       	call   80100608 <panic>

  acquiresleep(&ip->lock);
80101b33:	8b 45 08             	mov    0x8(%ebp),%eax
80101b36:	83 c0 0c             	add    $0xc,%eax
80101b39:	83 ec 0c             	sub    $0xc,%esp
80101b3c:	50                   	push   %eax
80101b3d:	e8 d7 35 00 00       	call   80105119 <acquiresleep>
80101b42:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101b45:	8b 45 08             	mov    0x8(%ebp),%eax
80101b48:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b4b:	85 c0                	test   %eax,%eax
80101b4d:	0f 85 cd 00 00 00    	jne    80101c20 <ilock+0x114>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b53:	8b 45 08             	mov    0x8(%ebp),%eax
80101b56:	8b 40 04             	mov    0x4(%eax),%eax
80101b59:	c1 e8 03             	shr    $0x3,%eax
80101b5c:	89 c2                	mov    %eax,%edx
80101b5e:	a1 74 2a 11 80       	mov    0x80112a74,%eax
80101b63:	01 c2                	add    %eax,%edx
80101b65:	8b 45 08             	mov    0x8(%ebp),%eax
80101b68:	8b 00                	mov    (%eax),%eax
80101b6a:	83 ec 08             	sub    $0x8,%esp
80101b6d:	52                   	push   %edx
80101b6e:	50                   	push   %eax
80101b6f:	e8 63 e6 ff ff       	call   801001d7 <bread>
80101b74:	83 c4 10             	add    $0x10,%esp
80101b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b7d:	8d 50 5c             	lea    0x5c(%eax),%edx
80101b80:	8b 45 08             	mov    0x8(%ebp),%eax
80101b83:	8b 40 04             	mov    0x4(%eax),%eax
80101b86:	83 e0 07             	and    $0x7,%eax
80101b89:	c1 e0 06             	shl    $0x6,%eax
80101b8c:	01 d0                	add    %edx,%eax
80101b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b94:	0f b7 10             	movzwl (%eax),%edx
80101b97:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9a:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ba1:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba8:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101baf:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101bb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb6:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bbd:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc4:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bcb:	8b 50 08             	mov    0x8(%eax),%edx
80101bce:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd1:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd7:	8d 50 0c             	lea    0xc(%eax),%edx
80101bda:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdd:	83 c0 5c             	add    $0x5c,%eax
80101be0:	83 ec 04             	sub    $0x4,%esp
80101be3:	6a 34                	push   $0x34
80101be5:	52                   	push   %edx
80101be6:	50                   	push   %eax
80101be7:	e8 0c 3a 00 00       	call   801055f8 <memmove>
80101bec:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101bef:	83 ec 0c             	sub    $0xc,%esp
80101bf2:	ff 75 f4             	pushl  -0xc(%ebp)
80101bf5:	e8 67 e6 ff ff       	call   80100261 <brelse>
80101bfa:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101c00:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101c07:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101c0e:	66 85 c0             	test   %ax,%ax
80101c11:	75 0d                	jne    80101c20 <ilock+0x114>
      panic("ilock: no type");
80101c13:	83 ec 0c             	sub    $0xc,%esp
80101c16:	68 c3 92 10 80       	push   $0x801092c3
80101c1b:	e8 e8 e9 ff ff       	call   80100608 <panic>
  }
}
80101c20:	90                   	nop
80101c21:	c9                   	leave  
80101c22:	c3                   	ret    

80101c23 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101c23:	f3 0f 1e fb          	endbr32 
80101c27:	55                   	push   %ebp
80101c28:	89 e5                	mov    %esp,%ebp
80101c2a:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c31:	74 20                	je     80101c53 <iunlock+0x30>
80101c33:	8b 45 08             	mov    0x8(%ebp),%eax
80101c36:	83 c0 0c             	add    $0xc,%eax
80101c39:	83 ec 0c             	sub    $0xc,%esp
80101c3c:	50                   	push   %eax
80101c3d:	e8 91 35 00 00       	call   801051d3 <holdingsleep>
80101c42:	83 c4 10             	add    $0x10,%esp
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 0a                	je     80101c53 <iunlock+0x30>
80101c49:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4c:	8b 40 08             	mov    0x8(%eax),%eax
80101c4f:	85 c0                	test   %eax,%eax
80101c51:	7f 0d                	jg     80101c60 <iunlock+0x3d>
    panic("iunlock");
80101c53:	83 ec 0c             	sub    $0xc,%esp
80101c56:	68 d2 92 10 80       	push   $0x801092d2
80101c5b:	e8 a8 e9 ff ff       	call   80100608 <panic>

  releasesleep(&ip->lock);
80101c60:	8b 45 08             	mov    0x8(%ebp),%eax
80101c63:	83 c0 0c             	add    $0xc,%eax
80101c66:	83 ec 0c             	sub    $0xc,%esp
80101c69:	50                   	push   %eax
80101c6a:	e8 12 35 00 00       	call   80105181 <releasesleep>
80101c6f:	83 c4 10             	add    $0x10,%esp
}
80101c72:	90                   	nop
80101c73:	c9                   	leave  
80101c74:	c3                   	ret    

80101c75 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101c75:	f3 0f 1e fb          	endbr32 
80101c79:	55                   	push   %ebp
80101c7a:	89 e5                	mov    %esp,%ebp
80101c7c:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101c7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c82:	83 c0 0c             	add    $0xc,%eax
80101c85:	83 ec 0c             	sub    $0xc,%esp
80101c88:	50                   	push   %eax
80101c89:	e8 8b 34 00 00       	call   80105119 <acquiresleep>
80101c8e:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101c91:	8b 45 08             	mov    0x8(%ebp),%eax
80101c94:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c97:	85 c0                	test   %eax,%eax
80101c99:	74 6a                	je     80101d05 <iput+0x90>
80101c9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101ca2:	66 85 c0             	test   %ax,%ax
80101ca5:	75 5e                	jne    80101d05 <iput+0x90>
    acquire(&icache.lock);
80101ca7:	83 ec 0c             	sub    $0xc,%esp
80101caa:	68 80 2a 11 80       	push   $0x80112a80
80101caf:	e8 de 35 00 00       	call   80105292 <acquire>
80101cb4:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cba:	8b 40 08             	mov    0x8(%eax),%eax
80101cbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101cc0:	83 ec 0c             	sub    $0xc,%esp
80101cc3:	68 80 2a 11 80       	push   $0x80112a80
80101cc8:	e8 37 36 00 00       	call   80105304 <release>
80101ccd:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101cd0:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101cd4:	75 2f                	jne    80101d05 <iput+0x90>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101cd6:	83 ec 0c             	sub    $0xc,%esp
80101cd9:	ff 75 08             	pushl  0x8(%ebp)
80101cdc:	e8 b5 01 00 00       	call   80101e96 <itrunc>
80101ce1:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101ce4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce7:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101ced:	83 ec 0c             	sub    $0xc,%esp
80101cf0:	ff 75 08             	pushl  0x8(%ebp)
80101cf3:	e8 2b fc ff ff       	call   80101923 <iupdate>
80101cf8:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101cfb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfe:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101d05:	8b 45 08             	mov    0x8(%ebp),%eax
80101d08:	83 c0 0c             	add    $0xc,%eax
80101d0b:	83 ec 0c             	sub    $0xc,%esp
80101d0e:	50                   	push   %eax
80101d0f:	e8 6d 34 00 00       	call   80105181 <releasesleep>
80101d14:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101d17:	83 ec 0c             	sub    $0xc,%esp
80101d1a:	68 80 2a 11 80       	push   $0x80112a80
80101d1f:	e8 6e 35 00 00       	call   80105292 <acquire>
80101d24:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101d27:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2a:	8b 40 08             	mov    0x8(%eax),%eax
80101d2d:	8d 50 ff             	lea    -0x1(%eax),%edx
80101d30:	8b 45 08             	mov    0x8(%ebp),%eax
80101d33:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101d36:	83 ec 0c             	sub    $0xc,%esp
80101d39:	68 80 2a 11 80       	push   $0x80112a80
80101d3e:	e8 c1 35 00 00       	call   80105304 <release>
80101d43:	83 c4 10             	add    $0x10,%esp
}
80101d46:	90                   	nop
80101d47:	c9                   	leave  
80101d48:	c3                   	ret    

80101d49 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101d49:	f3 0f 1e fb          	endbr32 
80101d4d:	55                   	push   %ebp
80101d4e:	89 e5                	mov    %esp,%ebp
80101d50:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101d53:	83 ec 0c             	sub    $0xc,%esp
80101d56:	ff 75 08             	pushl  0x8(%ebp)
80101d59:	e8 c5 fe ff ff       	call   80101c23 <iunlock>
80101d5e:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101d61:	83 ec 0c             	sub    $0xc,%esp
80101d64:	ff 75 08             	pushl  0x8(%ebp)
80101d67:	e8 09 ff ff ff       	call   80101c75 <iput>
80101d6c:	83 c4 10             	add    $0x10,%esp
}
80101d6f:	90                   	nop
80101d70:	c9                   	leave  
80101d71:	c3                   	ret    

80101d72 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d72:	f3 0f 1e fb          	endbr32 
80101d76:	55                   	push   %ebp
80101d77:	89 e5                	mov    %esp,%ebp
80101d79:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d7c:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101d80:	77 42                	ja     80101dc4 <bmap+0x52>
    if((addr = ip->addrs[bn]) == 0)
80101d82:	8b 45 08             	mov    0x8(%ebp),%eax
80101d85:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d88:	83 c2 14             	add    $0x14,%edx
80101d8b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d96:	75 24                	jne    80101dbc <bmap+0x4a>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d98:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9b:	8b 00                	mov    (%eax),%eax
80101d9d:	83 ec 0c             	sub    $0xc,%esp
80101da0:	50                   	push   %eax
80101da1:	e8 c7 f7 ff ff       	call   8010156d <balloc>
80101da6:	83 c4 10             	add    $0x10,%esp
80101da9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dac:	8b 45 08             	mov    0x8(%ebp),%eax
80101daf:	8b 55 0c             	mov    0xc(%ebp),%edx
80101db2:	8d 4a 14             	lea    0x14(%edx),%ecx
80101db5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101db8:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dbf:	e9 d0 00 00 00       	jmp    80101e94 <bmap+0x122>
  }
  bn -= NDIRECT;
80101dc4:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101dc8:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101dcc:	0f 87 b5 00 00 00    	ja     80101e87 <bmap+0x115>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd5:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101de2:	75 20                	jne    80101e04 <bmap+0x92>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101de4:	8b 45 08             	mov    0x8(%ebp),%eax
80101de7:	8b 00                	mov    (%eax),%eax
80101de9:	83 ec 0c             	sub    $0xc,%esp
80101dec:	50                   	push   %eax
80101ded:	e8 7b f7 ff ff       	call   8010156d <balloc>
80101df2:	83 c4 10             	add    $0x10,%esp
80101df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101df8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dfe:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101e04:	8b 45 08             	mov    0x8(%ebp),%eax
80101e07:	8b 00                	mov    (%eax),%eax
80101e09:	83 ec 08             	sub    $0x8,%esp
80101e0c:	ff 75 f4             	pushl  -0xc(%ebp)
80101e0f:	50                   	push   %eax
80101e10:	e8 c2 e3 ff ff       	call   801001d7 <bread>
80101e15:	83 c4 10             	add    $0x10,%esp
80101e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e1e:	83 c0 5c             	add    $0x5c,%eax
80101e21:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101e24:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e31:	01 d0                	add    %edx,%eax
80101e33:	8b 00                	mov    (%eax),%eax
80101e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e3c:	75 36                	jne    80101e74 <bmap+0x102>
      a[bn] = addr = balloc(ip->dev);
80101e3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e41:	8b 00                	mov    (%eax),%eax
80101e43:	83 ec 0c             	sub    $0xc,%esp
80101e46:	50                   	push   %eax
80101e47:	e8 21 f7 ff ff       	call   8010156d <balloc>
80101e4c:	83 c4 10             	add    $0x10,%esp
80101e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e52:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e55:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e5f:	01 c2                	add    %eax,%edx
80101e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e64:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101e66:	83 ec 0c             	sub    $0xc,%esp
80101e69:	ff 75 f0             	pushl  -0x10(%ebp)
80101e6c:	e8 d9 1a 00 00       	call   8010394a <log_write>
80101e71:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101e74:	83 ec 0c             	sub    $0xc,%esp
80101e77:	ff 75 f0             	pushl  -0x10(%ebp)
80101e7a:	e8 e2 e3 ff ff       	call   80100261 <brelse>
80101e7f:	83 c4 10             	add    $0x10,%esp
    return addr;
80101e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e85:	eb 0d                	jmp    80101e94 <bmap+0x122>
  }

  panic("bmap: out of range");
80101e87:	83 ec 0c             	sub    $0xc,%esp
80101e8a:	68 da 92 10 80       	push   $0x801092da
80101e8f:	e8 74 e7 ff ff       	call   80100608 <panic>
}
80101e94:	c9                   	leave  
80101e95:	c3                   	ret    

80101e96 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e96:	f3 0f 1e fb          	endbr32 
80101e9a:	55                   	push   %ebp
80101e9b:	89 e5                	mov    %esp,%ebp
80101e9d:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ea0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ea7:	eb 45                	jmp    80101eee <itrunc+0x58>
    if(ip->addrs[i]){
80101ea9:	8b 45 08             	mov    0x8(%ebp),%eax
80101eac:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101eaf:	83 c2 14             	add    $0x14,%edx
80101eb2:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101eb6:	85 c0                	test   %eax,%eax
80101eb8:	74 30                	je     80101eea <itrunc+0x54>
      bfree(ip->dev, ip->addrs[i]);
80101eba:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ec0:	83 c2 14             	add    $0x14,%edx
80101ec3:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101ec7:	8b 55 08             	mov    0x8(%ebp),%edx
80101eca:	8b 12                	mov    (%edx),%edx
80101ecc:	83 ec 08             	sub    $0x8,%esp
80101ecf:	50                   	push   %eax
80101ed0:	52                   	push   %edx
80101ed1:	e8 e7 f7 ff ff       	call   801016bd <bfree>
80101ed6:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80101edc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101edf:	83 c2 14             	add    $0x14,%edx
80101ee2:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101ee9:	00 
  for(i = 0; i < NDIRECT; i++){
80101eea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101eee:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101ef2:	7e b5                	jle    80101ea9 <itrunc+0x13>
    }
  }

  if(ip->addrs[NDIRECT]){
80101ef4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef7:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101efd:	85 c0                	test   %eax,%eax
80101eff:	0f 84 aa 00 00 00    	je     80101faf <itrunc+0x119>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f05:	8b 45 08             	mov    0x8(%ebp),%eax
80101f08:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101f0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f11:	8b 00                	mov    (%eax),%eax
80101f13:	83 ec 08             	sub    $0x8,%esp
80101f16:	52                   	push   %edx
80101f17:	50                   	push   %eax
80101f18:	e8 ba e2 ff ff       	call   801001d7 <bread>
80101f1d:	83 c4 10             	add    $0x10,%esp
80101f20:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f26:	83 c0 5c             	add    $0x5c,%eax
80101f29:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101f2c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101f33:	eb 3c                	jmp    80101f71 <itrunc+0xdb>
      if(a[j])
80101f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f42:	01 d0                	add    %edx,%eax
80101f44:	8b 00                	mov    (%eax),%eax
80101f46:	85 c0                	test   %eax,%eax
80101f48:	74 23                	je     80101f6d <itrunc+0xd7>
        bfree(ip->dev, a[j]);
80101f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f54:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f57:	01 d0                	add    %edx,%eax
80101f59:	8b 00                	mov    (%eax),%eax
80101f5b:	8b 55 08             	mov    0x8(%ebp),%edx
80101f5e:	8b 12                	mov    (%edx),%edx
80101f60:	83 ec 08             	sub    $0x8,%esp
80101f63:	50                   	push   %eax
80101f64:	52                   	push   %edx
80101f65:	e8 53 f7 ff ff       	call   801016bd <bfree>
80101f6a:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101f6d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f74:	83 f8 7f             	cmp    $0x7f,%eax
80101f77:	76 bc                	jbe    80101f35 <itrunc+0x9f>
    }
    brelse(bp);
80101f79:	83 ec 0c             	sub    $0xc,%esp
80101f7c:	ff 75 ec             	pushl  -0x14(%ebp)
80101f7f:	e8 dd e2 ff ff       	call   80100261 <brelse>
80101f84:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f87:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8a:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101f90:	8b 55 08             	mov    0x8(%ebp),%edx
80101f93:	8b 12                	mov    (%edx),%edx
80101f95:	83 ec 08             	sub    $0x8,%esp
80101f98:	50                   	push   %eax
80101f99:	52                   	push   %edx
80101f9a:	e8 1e f7 ff ff       	call   801016bd <bfree>
80101f9f:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101fa2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa5:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101fac:	00 00 00 
  }

  ip->size = 0;
80101faf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb2:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	ff 75 08             	pushl  0x8(%ebp)
80101fbf:	e8 5f f9 ff ff       	call   80101923 <iupdate>
80101fc4:	83 c4 10             	add    $0x10,%esp
}
80101fc7:	90                   	nop
80101fc8:	c9                   	leave  
80101fc9:	c3                   	ret    

80101fca <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101fca:	f3 0f 1e fb          	endbr32 
80101fce:	55                   	push   %ebp
80101fcf:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101fd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd4:	8b 00                	mov    (%eax),%eax
80101fd6:	89 c2                	mov    %eax,%edx
80101fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fdb:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101fde:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe1:	8b 50 04             	mov    0x4(%eax),%edx
80101fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fe7:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101fea:	8b 45 08             	mov    0x8(%ebp),%eax
80101fed:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ff4:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffa:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
80102001:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80102005:	8b 45 08             	mov    0x8(%ebp),%eax
80102008:	8b 50 58             	mov    0x58(%eax),%edx
8010200b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010200e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102011:	90                   	nop
80102012:	5d                   	pop    %ebp
80102013:	c3                   	ret    

80102014 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102014:	f3 0f 1e fb          	endbr32 
80102018:	55                   	push   %ebp
80102019:	89 e5                	mov    %esp,%ebp
8010201b:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010201e:	8b 45 08             	mov    0x8(%ebp),%eax
80102021:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102025:	66 83 f8 03          	cmp    $0x3,%ax
80102029:	75 5c                	jne    80102087 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
8010202b:	8b 45 08             	mov    0x8(%ebp),%eax
8010202e:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102032:	66 85 c0             	test   %ax,%ax
80102035:	78 20                	js     80102057 <readi+0x43>
80102037:	8b 45 08             	mov    0x8(%ebp),%eax
8010203a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010203e:	66 83 f8 09          	cmp    $0x9,%ax
80102042:	7f 13                	jg     80102057 <readi+0x43>
80102044:	8b 45 08             	mov    0x8(%ebp),%eax
80102047:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010204b:	98                   	cwtl   
8010204c:	8b 04 c5 00 2a 11 80 	mov    -0x7feed600(,%eax,8),%eax
80102053:	85 c0                	test   %eax,%eax
80102055:	75 0a                	jne    80102061 <readi+0x4d>
      return -1;
80102057:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010205c:	e9 0a 01 00 00       	jmp    8010216b <readi+0x157>
    return devsw[ip->major].read(ip, dst, n);
80102061:	8b 45 08             	mov    0x8(%ebp),%eax
80102064:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102068:	98                   	cwtl   
80102069:	8b 04 c5 00 2a 11 80 	mov    -0x7feed600(,%eax,8),%eax
80102070:	8b 55 14             	mov    0x14(%ebp),%edx
80102073:	83 ec 04             	sub    $0x4,%esp
80102076:	52                   	push   %edx
80102077:	ff 75 0c             	pushl  0xc(%ebp)
8010207a:	ff 75 08             	pushl  0x8(%ebp)
8010207d:	ff d0                	call   *%eax
8010207f:	83 c4 10             	add    $0x10,%esp
80102082:	e9 e4 00 00 00       	jmp    8010216b <readi+0x157>
  }

  if(off > ip->size || off + n < off)
80102087:	8b 45 08             	mov    0x8(%ebp),%eax
8010208a:	8b 40 58             	mov    0x58(%eax),%eax
8010208d:	39 45 10             	cmp    %eax,0x10(%ebp)
80102090:	77 0d                	ja     8010209f <readi+0x8b>
80102092:	8b 55 10             	mov    0x10(%ebp),%edx
80102095:	8b 45 14             	mov    0x14(%ebp),%eax
80102098:	01 d0                	add    %edx,%eax
8010209a:	39 45 10             	cmp    %eax,0x10(%ebp)
8010209d:	76 0a                	jbe    801020a9 <readi+0x95>
    return -1;
8010209f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020a4:	e9 c2 00 00 00       	jmp    8010216b <readi+0x157>
  if(off + n > ip->size)
801020a9:	8b 55 10             	mov    0x10(%ebp),%edx
801020ac:	8b 45 14             	mov    0x14(%ebp),%eax
801020af:	01 c2                	add    %eax,%edx
801020b1:	8b 45 08             	mov    0x8(%ebp),%eax
801020b4:	8b 40 58             	mov    0x58(%eax),%eax
801020b7:	39 c2                	cmp    %eax,%edx
801020b9:	76 0c                	jbe    801020c7 <readi+0xb3>
    n = ip->size - off;
801020bb:	8b 45 08             	mov    0x8(%ebp),%eax
801020be:	8b 40 58             	mov    0x58(%eax),%eax
801020c1:	2b 45 10             	sub    0x10(%ebp),%eax
801020c4:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020ce:	e9 89 00 00 00       	jmp    8010215c <readi+0x148>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020d3:	8b 45 10             	mov    0x10(%ebp),%eax
801020d6:	c1 e8 09             	shr    $0x9,%eax
801020d9:	83 ec 08             	sub    $0x8,%esp
801020dc:	50                   	push   %eax
801020dd:	ff 75 08             	pushl  0x8(%ebp)
801020e0:	e8 8d fc ff ff       	call   80101d72 <bmap>
801020e5:	83 c4 10             	add    $0x10,%esp
801020e8:	8b 55 08             	mov    0x8(%ebp),%edx
801020eb:	8b 12                	mov    (%edx),%edx
801020ed:	83 ec 08             	sub    $0x8,%esp
801020f0:	50                   	push   %eax
801020f1:	52                   	push   %edx
801020f2:	e8 e0 e0 ff ff       	call   801001d7 <bread>
801020f7:	83 c4 10             	add    $0x10,%esp
801020fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020fd:	8b 45 10             	mov    0x10(%ebp),%eax
80102100:	25 ff 01 00 00       	and    $0x1ff,%eax
80102105:	ba 00 02 00 00       	mov    $0x200,%edx
8010210a:	29 c2                	sub    %eax,%edx
8010210c:	8b 45 14             	mov    0x14(%ebp),%eax
8010210f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102112:	39 c2                	cmp    %eax,%edx
80102114:	0f 46 c2             	cmovbe %edx,%eax
80102117:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010211a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010211d:	8d 50 5c             	lea    0x5c(%eax),%edx
80102120:	8b 45 10             	mov    0x10(%ebp),%eax
80102123:	25 ff 01 00 00       	and    $0x1ff,%eax
80102128:	01 d0                	add    %edx,%eax
8010212a:	83 ec 04             	sub    $0x4,%esp
8010212d:	ff 75 ec             	pushl  -0x14(%ebp)
80102130:	50                   	push   %eax
80102131:	ff 75 0c             	pushl  0xc(%ebp)
80102134:	e8 bf 34 00 00       	call   801055f8 <memmove>
80102139:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010213c:	83 ec 0c             	sub    $0xc,%esp
8010213f:	ff 75 f0             	pushl  -0x10(%ebp)
80102142:	e8 1a e1 ff ff       	call   80100261 <brelse>
80102147:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010214a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010214d:	01 45 f4             	add    %eax,-0xc(%ebp)
80102150:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102153:	01 45 10             	add    %eax,0x10(%ebp)
80102156:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102159:	01 45 0c             	add    %eax,0xc(%ebp)
8010215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010215f:	3b 45 14             	cmp    0x14(%ebp),%eax
80102162:	0f 82 6b ff ff ff    	jb     801020d3 <readi+0xbf>
  }
  return n;
80102168:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010216b:	c9                   	leave  
8010216c:	c3                   	ret    

8010216d <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010216d:	f3 0f 1e fb          	endbr32 
80102171:	55                   	push   %ebp
80102172:	89 e5                	mov    %esp,%ebp
80102174:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102177:	8b 45 08             	mov    0x8(%ebp),%eax
8010217a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010217e:	66 83 f8 03          	cmp    $0x3,%ax
80102182:	75 5c                	jne    801021e0 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102184:	8b 45 08             	mov    0x8(%ebp),%eax
80102187:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010218b:	66 85 c0             	test   %ax,%ax
8010218e:	78 20                	js     801021b0 <writei+0x43>
80102190:	8b 45 08             	mov    0x8(%ebp),%eax
80102193:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102197:	66 83 f8 09          	cmp    $0x9,%ax
8010219b:	7f 13                	jg     801021b0 <writei+0x43>
8010219d:	8b 45 08             	mov    0x8(%ebp),%eax
801021a0:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021a4:	98                   	cwtl   
801021a5:	8b 04 c5 04 2a 11 80 	mov    -0x7feed5fc(,%eax,8),%eax
801021ac:	85 c0                	test   %eax,%eax
801021ae:	75 0a                	jne    801021ba <writei+0x4d>
      return -1;
801021b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021b5:	e9 3b 01 00 00       	jmp    801022f5 <writei+0x188>
    return devsw[ip->major].write(ip, src, n);
801021ba:	8b 45 08             	mov    0x8(%ebp),%eax
801021bd:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021c1:	98                   	cwtl   
801021c2:	8b 04 c5 04 2a 11 80 	mov    -0x7feed5fc(,%eax,8),%eax
801021c9:	8b 55 14             	mov    0x14(%ebp),%edx
801021cc:	83 ec 04             	sub    $0x4,%esp
801021cf:	52                   	push   %edx
801021d0:	ff 75 0c             	pushl  0xc(%ebp)
801021d3:	ff 75 08             	pushl  0x8(%ebp)
801021d6:	ff d0                	call   *%eax
801021d8:	83 c4 10             	add    $0x10,%esp
801021db:	e9 15 01 00 00       	jmp    801022f5 <writei+0x188>
  }

  if(off > ip->size || off + n < off)
801021e0:	8b 45 08             	mov    0x8(%ebp),%eax
801021e3:	8b 40 58             	mov    0x58(%eax),%eax
801021e6:	39 45 10             	cmp    %eax,0x10(%ebp)
801021e9:	77 0d                	ja     801021f8 <writei+0x8b>
801021eb:	8b 55 10             	mov    0x10(%ebp),%edx
801021ee:	8b 45 14             	mov    0x14(%ebp),%eax
801021f1:	01 d0                	add    %edx,%eax
801021f3:	39 45 10             	cmp    %eax,0x10(%ebp)
801021f6:	76 0a                	jbe    80102202 <writei+0x95>
    return -1;
801021f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021fd:	e9 f3 00 00 00       	jmp    801022f5 <writei+0x188>
  if(off + n > MAXFILE*BSIZE)
80102202:	8b 55 10             	mov    0x10(%ebp),%edx
80102205:	8b 45 14             	mov    0x14(%ebp),%eax
80102208:	01 d0                	add    %edx,%eax
8010220a:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010220f:	76 0a                	jbe    8010221b <writei+0xae>
    return -1;
80102211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102216:	e9 da 00 00 00       	jmp    801022f5 <writei+0x188>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010221b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102222:	e9 97 00 00 00       	jmp    801022be <writei+0x151>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102227:	8b 45 10             	mov    0x10(%ebp),%eax
8010222a:	c1 e8 09             	shr    $0x9,%eax
8010222d:	83 ec 08             	sub    $0x8,%esp
80102230:	50                   	push   %eax
80102231:	ff 75 08             	pushl  0x8(%ebp)
80102234:	e8 39 fb ff ff       	call   80101d72 <bmap>
80102239:	83 c4 10             	add    $0x10,%esp
8010223c:	8b 55 08             	mov    0x8(%ebp),%edx
8010223f:	8b 12                	mov    (%edx),%edx
80102241:	83 ec 08             	sub    $0x8,%esp
80102244:	50                   	push   %eax
80102245:	52                   	push   %edx
80102246:	e8 8c df ff ff       	call   801001d7 <bread>
8010224b:	83 c4 10             	add    $0x10,%esp
8010224e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102251:	8b 45 10             	mov    0x10(%ebp),%eax
80102254:	25 ff 01 00 00       	and    $0x1ff,%eax
80102259:	ba 00 02 00 00       	mov    $0x200,%edx
8010225e:	29 c2                	sub    %eax,%edx
80102260:	8b 45 14             	mov    0x14(%ebp),%eax
80102263:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102266:	39 c2                	cmp    %eax,%edx
80102268:	0f 46 c2             	cmovbe %edx,%eax
8010226b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010226e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102271:	8d 50 5c             	lea    0x5c(%eax),%edx
80102274:	8b 45 10             	mov    0x10(%ebp),%eax
80102277:	25 ff 01 00 00       	and    $0x1ff,%eax
8010227c:	01 d0                	add    %edx,%eax
8010227e:	83 ec 04             	sub    $0x4,%esp
80102281:	ff 75 ec             	pushl  -0x14(%ebp)
80102284:	ff 75 0c             	pushl  0xc(%ebp)
80102287:	50                   	push   %eax
80102288:	e8 6b 33 00 00       	call   801055f8 <memmove>
8010228d:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102290:	83 ec 0c             	sub    $0xc,%esp
80102293:	ff 75 f0             	pushl  -0x10(%ebp)
80102296:	e8 af 16 00 00       	call   8010394a <log_write>
8010229b:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010229e:	83 ec 0c             	sub    $0xc,%esp
801022a1:	ff 75 f0             	pushl  -0x10(%ebp)
801022a4:	e8 b8 df ff ff       	call   80100261 <brelse>
801022a9:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022af:	01 45 f4             	add    %eax,-0xc(%ebp)
801022b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022b5:	01 45 10             	add    %eax,0x10(%ebp)
801022b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022bb:	01 45 0c             	add    %eax,0xc(%ebp)
801022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c1:	3b 45 14             	cmp    0x14(%ebp),%eax
801022c4:	0f 82 5d ff ff ff    	jb     80102227 <writei+0xba>
  }

  if(n > 0 && off > ip->size){
801022ca:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801022ce:	74 22                	je     801022f2 <writei+0x185>
801022d0:	8b 45 08             	mov    0x8(%ebp),%eax
801022d3:	8b 40 58             	mov    0x58(%eax),%eax
801022d6:	39 45 10             	cmp    %eax,0x10(%ebp)
801022d9:	76 17                	jbe    801022f2 <writei+0x185>
    ip->size = off;
801022db:	8b 45 08             	mov    0x8(%ebp),%eax
801022de:	8b 55 10             	mov    0x10(%ebp),%edx
801022e1:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	ff 75 08             	pushl  0x8(%ebp)
801022ea:	e8 34 f6 ff ff       	call   80101923 <iupdate>
801022ef:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801022f2:	8b 45 14             	mov    0x14(%ebp),%eax
}
801022f5:	c9                   	leave  
801022f6:	c3                   	ret    

801022f7 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801022f7:	f3 0f 1e fb          	endbr32 
801022fb:	55                   	push   %ebp
801022fc:	89 e5                	mov    %esp,%ebp
801022fe:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102301:	83 ec 04             	sub    $0x4,%esp
80102304:	6a 0e                	push   $0xe
80102306:	ff 75 0c             	pushl  0xc(%ebp)
80102309:	ff 75 08             	pushl  0x8(%ebp)
8010230c:	e8 85 33 00 00       	call   80105696 <strncmp>
80102311:	83 c4 10             	add    $0x10,%esp
}
80102314:	c9                   	leave  
80102315:	c3                   	ret    

80102316 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102316:	f3 0f 1e fb          	endbr32 
8010231a:	55                   	push   %ebp
8010231b:	89 e5                	mov    %esp,%ebp
8010231d:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102320:	8b 45 08             	mov    0x8(%ebp),%eax
80102323:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102327:	66 83 f8 01          	cmp    $0x1,%ax
8010232b:	74 0d                	je     8010233a <dirlookup+0x24>
    panic("dirlookup not DIR");
8010232d:	83 ec 0c             	sub    $0xc,%esp
80102330:	68 ed 92 10 80       	push   $0x801092ed
80102335:	e8 ce e2 ff ff       	call   80100608 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010233a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102341:	eb 7b                	jmp    801023be <dirlookup+0xa8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102343:	6a 10                	push   $0x10
80102345:	ff 75 f4             	pushl  -0xc(%ebp)
80102348:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010234b:	50                   	push   %eax
8010234c:	ff 75 08             	pushl  0x8(%ebp)
8010234f:	e8 c0 fc ff ff       	call   80102014 <readi>
80102354:	83 c4 10             	add    $0x10,%esp
80102357:	83 f8 10             	cmp    $0x10,%eax
8010235a:	74 0d                	je     80102369 <dirlookup+0x53>
      panic("dirlookup read");
8010235c:	83 ec 0c             	sub    $0xc,%esp
8010235f:	68 ff 92 10 80       	push   $0x801092ff
80102364:	e8 9f e2 ff ff       	call   80100608 <panic>
    if(de.inum == 0)
80102369:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010236d:	66 85 c0             	test   %ax,%ax
80102370:	74 47                	je     801023b9 <dirlookup+0xa3>
      continue;
    if(namecmp(name, de.name) == 0){
80102372:	83 ec 08             	sub    $0x8,%esp
80102375:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102378:	83 c0 02             	add    $0x2,%eax
8010237b:	50                   	push   %eax
8010237c:	ff 75 0c             	pushl  0xc(%ebp)
8010237f:	e8 73 ff ff ff       	call   801022f7 <namecmp>
80102384:	83 c4 10             	add    $0x10,%esp
80102387:	85 c0                	test   %eax,%eax
80102389:	75 2f                	jne    801023ba <dirlookup+0xa4>
      // entry matches path element
      if(poff)
8010238b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010238f:	74 08                	je     80102399 <dirlookup+0x83>
        *poff = off;
80102391:	8b 45 10             	mov    0x10(%ebp),%eax
80102394:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102397:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102399:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010239d:	0f b7 c0             	movzwl %ax,%eax
801023a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801023a3:	8b 45 08             	mov    0x8(%ebp),%eax
801023a6:	8b 00                	mov    (%eax),%eax
801023a8:	83 ec 08             	sub    $0x8,%esp
801023ab:	ff 75 f0             	pushl  -0x10(%ebp)
801023ae:	50                   	push   %eax
801023af:	e8 34 f6 ff ff       	call   801019e8 <iget>
801023b4:	83 c4 10             	add    $0x10,%esp
801023b7:	eb 19                	jmp    801023d2 <dirlookup+0xbc>
      continue;
801023b9:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
801023ba:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801023be:	8b 45 08             	mov    0x8(%ebp),%eax
801023c1:	8b 40 58             	mov    0x58(%eax),%eax
801023c4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801023c7:	0f 82 76 ff ff ff    	jb     80102343 <dirlookup+0x2d>
    }
  }

  return 0;
801023cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023d2:	c9                   	leave  
801023d3:	c3                   	ret    

801023d4 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801023d4:	f3 0f 1e fb          	endbr32 
801023d8:	55                   	push   %ebp
801023d9:	89 e5                	mov    %esp,%ebp
801023db:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801023de:	83 ec 04             	sub    $0x4,%esp
801023e1:	6a 00                	push   $0x0
801023e3:	ff 75 0c             	pushl  0xc(%ebp)
801023e6:	ff 75 08             	pushl  0x8(%ebp)
801023e9:	e8 28 ff ff ff       	call   80102316 <dirlookup>
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023f8:	74 18                	je     80102412 <dirlink+0x3e>
    iput(ip);
801023fa:	83 ec 0c             	sub    $0xc,%esp
801023fd:	ff 75 f0             	pushl  -0x10(%ebp)
80102400:	e8 70 f8 ff ff       	call   80101c75 <iput>
80102405:	83 c4 10             	add    $0x10,%esp
    return -1;
80102408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010240d:	e9 9c 00 00 00       	jmp    801024ae <dirlink+0xda>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102412:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102419:	eb 39                	jmp    80102454 <dirlink+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010241e:	6a 10                	push   $0x10
80102420:	50                   	push   %eax
80102421:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102424:	50                   	push   %eax
80102425:	ff 75 08             	pushl  0x8(%ebp)
80102428:	e8 e7 fb ff ff       	call   80102014 <readi>
8010242d:	83 c4 10             	add    $0x10,%esp
80102430:	83 f8 10             	cmp    $0x10,%eax
80102433:	74 0d                	je     80102442 <dirlink+0x6e>
      panic("dirlink read");
80102435:	83 ec 0c             	sub    $0xc,%esp
80102438:	68 0e 93 10 80       	push   $0x8010930e
8010243d:	e8 c6 e1 ff ff       	call   80100608 <panic>
    if(de.inum == 0)
80102442:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102446:	66 85 c0             	test   %ax,%ax
80102449:	74 18                	je     80102463 <dirlink+0x8f>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010244e:	83 c0 10             	add    $0x10,%eax
80102451:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102454:	8b 45 08             	mov    0x8(%ebp),%eax
80102457:	8b 50 58             	mov    0x58(%eax),%edx
8010245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010245d:	39 c2                	cmp    %eax,%edx
8010245f:	77 ba                	ja     8010241b <dirlink+0x47>
80102461:	eb 01                	jmp    80102464 <dirlink+0x90>
      break;
80102463:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102464:	83 ec 04             	sub    $0x4,%esp
80102467:	6a 0e                	push   $0xe
80102469:	ff 75 0c             	pushl  0xc(%ebp)
8010246c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010246f:	83 c0 02             	add    $0x2,%eax
80102472:	50                   	push   %eax
80102473:	e8 78 32 00 00       	call   801056f0 <strncpy>
80102478:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010247b:	8b 45 10             	mov    0x10(%ebp),%eax
8010247e:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102482:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102485:	6a 10                	push   $0x10
80102487:	50                   	push   %eax
80102488:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010248b:	50                   	push   %eax
8010248c:	ff 75 08             	pushl  0x8(%ebp)
8010248f:	e8 d9 fc ff ff       	call   8010216d <writei>
80102494:	83 c4 10             	add    $0x10,%esp
80102497:	83 f8 10             	cmp    $0x10,%eax
8010249a:	74 0d                	je     801024a9 <dirlink+0xd5>
    panic("dirlink");
8010249c:	83 ec 0c             	sub    $0xc,%esp
8010249f:	68 1b 93 10 80       	push   $0x8010931b
801024a4:	e8 5f e1 ff ff       	call   80100608 <panic>

  return 0;
801024a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024ae:	c9                   	leave  
801024af:	c3                   	ret    

801024b0 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801024b0:	f3 0f 1e fb          	endbr32 
801024b4:	55                   	push   %ebp
801024b5:	89 e5                	mov    %esp,%ebp
801024b7:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801024ba:	eb 04                	jmp    801024c0 <skipelem+0x10>
    path++;
801024bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801024c0:	8b 45 08             	mov    0x8(%ebp),%eax
801024c3:	0f b6 00             	movzbl (%eax),%eax
801024c6:	3c 2f                	cmp    $0x2f,%al
801024c8:	74 f2                	je     801024bc <skipelem+0xc>
  if(*path == 0)
801024ca:	8b 45 08             	mov    0x8(%ebp),%eax
801024cd:	0f b6 00             	movzbl (%eax),%eax
801024d0:	84 c0                	test   %al,%al
801024d2:	75 07                	jne    801024db <skipelem+0x2b>
    return 0;
801024d4:	b8 00 00 00 00       	mov    $0x0,%eax
801024d9:	eb 77                	jmp    80102552 <skipelem+0xa2>
  s = path;
801024db:	8b 45 08             	mov    0x8(%ebp),%eax
801024de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801024e1:	eb 04                	jmp    801024e7 <skipelem+0x37>
    path++;
801024e3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
801024e7:	8b 45 08             	mov    0x8(%ebp),%eax
801024ea:	0f b6 00             	movzbl (%eax),%eax
801024ed:	3c 2f                	cmp    $0x2f,%al
801024ef:	74 0a                	je     801024fb <skipelem+0x4b>
801024f1:	8b 45 08             	mov    0x8(%ebp),%eax
801024f4:	0f b6 00             	movzbl (%eax),%eax
801024f7:	84 c0                	test   %al,%al
801024f9:	75 e8                	jne    801024e3 <skipelem+0x33>
  len = path - s;
801024fb:	8b 45 08             	mov    0x8(%ebp),%eax
801024fe:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102501:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102504:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102508:	7e 15                	jle    8010251f <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010250a:	83 ec 04             	sub    $0x4,%esp
8010250d:	6a 0e                	push   $0xe
8010250f:	ff 75 f4             	pushl  -0xc(%ebp)
80102512:	ff 75 0c             	pushl  0xc(%ebp)
80102515:	e8 de 30 00 00       	call   801055f8 <memmove>
8010251a:	83 c4 10             	add    $0x10,%esp
8010251d:	eb 26                	jmp    80102545 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010251f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102522:	83 ec 04             	sub    $0x4,%esp
80102525:	50                   	push   %eax
80102526:	ff 75 f4             	pushl  -0xc(%ebp)
80102529:	ff 75 0c             	pushl  0xc(%ebp)
8010252c:	e8 c7 30 00 00       	call   801055f8 <memmove>
80102531:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102534:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102537:	8b 45 0c             	mov    0xc(%ebp),%eax
8010253a:	01 d0                	add    %edx,%eax
8010253c:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010253f:	eb 04                	jmp    80102545 <skipelem+0x95>
    path++;
80102541:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102545:	8b 45 08             	mov    0x8(%ebp),%eax
80102548:	0f b6 00             	movzbl (%eax),%eax
8010254b:	3c 2f                	cmp    $0x2f,%al
8010254d:	74 f2                	je     80102541 <skipelem+0x91>
  return path;
8010254f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102552:	c9                   	leave  
80102553:	c3                   	ret    

80102554 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102554:	f3 0f 1e fb          	endbr32 
80102558:	55                   	push   %ebp
80102559:	89 e5                	mov    %esp,%ebp
8010255b:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010255e:	8b 45 08             	mov    0x8(%ebp),%eax
80102561:	0f b6 00             	movzbl (%eax),%eax
80102564:	3c 2f                	cmp    $0x2f,%al
80102566:	75 17                	jne    8010257f <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
80102568:	83 ec 08             	sub    $0x8,%esp
8010256b:	6a 01                	push   $0x1
8010256d:	6a 01                	push   $0x1
8010256f:	e8 74 f4 ff ff       	call   801019e8 <iget>
80102574:	83 c4 10             	add    $0x10,%esp
80102577:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010257a:	e9 ba 00 00 00       	jmp    80102639 <namex+0xe5>
  else
    ip = idup(myproc()->cwd);
8010257f:	e8 3c 1f 00 00       	call   801044c0 <myproc>
80102584:	8b 40 68             	mov    0x68(%eax),%eax
80102587:	83 ec 0c             	sub    $0xc,%esp
8010258a:	50                   	push   %eax
8010258b:	e8 3e f5 ff ff       	call   80101ace <idup>
80102590:	83 c4 10             	add    $0x10,%esp
80102593:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102596:	e9 9e 00 00 00       	jmp    80102639 <namex+0xe5>
    ilock(ip);
8010259b:	83 ec 0c             	sub    $0xc,%esp
8010259e:	ff 75 f4             	pushl  -0xc(%ebp)
801025a1:	e8 66 f5 ff ff       	call   80101b0c <ilock>
801025a6:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025ac:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801025b0:	66 83 f8 01          	cmp    $0x1,%ax
801025b4:	74 18                	je     801025ce <namex+0x7a>
      iunlockput(ip);
801025b6:	83 ec 0c             	sub    $0xc,%esp
801025b9:	ff 75 f4             	pushl  -0xc(%ebp)
801025bc:	e8 88 f7 ff ff       	call   80101d49 <iunlockput>
801025c1:	83 c4 10             	add    $0x10,%esp
      return 0;
801025c4:	b8 00 00 00 00       	mov    $0x0,%eax
801025c9:	e9 a7 00 00 00       	jmp    80102675 <namex+0x121>
    }
    if(nameiparent && *path == '\0'){
801025ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025d2:	74 20                	je     801025f4 <namex+0xa0>
801025d4:	8b 45 08             	mov    0x8(%ebp),%eax
801025d7:	0f b6 00             	movzbl (%eax),%eax
801025da:	84 c0                	test   %al,%al
801025dc:	75 16                	jne    801025f4 <namex+0xa0>
      // Stop one level early.
      iunlock(ip);
801025de:	83 ec 0c             	sub    $0xc,%esp
801025e1:	ff 75 f4             	pushl  -0xc(%ebp)
801025e4:	e8 3a f6 ff ff       	call   80101c23 <iunlock>
801025e9:	83 c4 10             	add    $0x10,%esp
      return ip;
801025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025ef:	e9 81 00 00 00       	jmp    80102675 <namex+0x121>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801025f4:	83 ec 04             	sub    $0x4,%esp
801025f7:	6a 00                	push   $0x0
801025f9:	ff 75 10             	pushl  0x10(%ebp)
801025fc:	ff 75 f4             	pushl  -0xc(%ebp)
801025ff:	e8 12 fd ff ff       	call   80102316 <dirlookup>
80102604:	83 c4 10             	add    $0x10,%esp
80102607:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010260a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010260e:	75 15                	jne    80102625 <namex+0xd1>
      iunlockput(ip);
80102610:	83 ec 0c             	sub    $0xc,%esp
80102613:	ff 75 f4             	pushl  -0xc(%ebp)
80102616:	e8 2e f7 ff ff       	call   80101d49 <iunlockput>
8010261b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010261e:	b8 00 00 00 00       	mov    $0x0,%eax
80102623:	eb 50                	jmp    80102675 <namex+0x121>
    }
    iunlockput(ip);
80102625:	83 ec 0c             	sub    $0xc,%esp
80102628:	ff 75 f4             	pushl  -0xc(%ebp)
8010262b:	e8 19 f7 ff ff       	call   80101d49 <iunlockput>
80102630:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102633:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102636:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
80102639:	83 ec 08             	sub    $0x8,%esp
8010263c:	ff 75 10             	pushl  0x10(%ebp)
8010263f:	ff 75 08             	pushl  0x8(%ebp)
80102642:	e8 69 fe ff ff       	call   801024b0 <skipelem>
80102647:	83 c4 10             	add    $0x10,%esp
8010264a:	89 45 08             	mov    %eax,0x8(%ebp)
8010264d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102651:	0f 85 44 ff ff ff    	jne    8010259b <namex+0x47>
  }
  if(nameiparent){
80102657:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010265b:	74 15                	je     80102672 <namex+0x11e>
    iput(ip);
8010265d:	83 ec 0c             	sub    $0xc,%esp
80102660:	ff 75 f4             	pushl  -0xc(%ebp)
80102663:	e8 0d f6 ff ff       	call   80101c75 <iput>
80102668:	83 c4 10             	add    $0x10,%esp
    return 0;
8010266b:	b8 00 00 00 00       	mov    $0x0,%eax
80102670:	eb 03                	jmp    80102675 <namex+0x121>
  }
  return ip;
80102672:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102675:	c9                   	leave  
80102676:	c3                   	ret    

80102677 <namei>:

struct inode*
namei(char *path)
{
80102677:	f3 0f 1e fb          	endbr32 
8010267b:	55                   	push   %ebp
8010267c:	89 e5                	mov    %esp,%ebp
8010267e:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102681:	83 ec 04             	sub    $0x4,%esp
80102684:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102687:	50                   	push   %eax
80102688:	6a 00                	push   $0x0
8010268a:	ff 75 08             	pushl  0x8(%ebp)
8010268d:	e8 c2 fe ff ff       	call   80102554 <namex>
80102692:	83 c4 10             	add    $0x10,%esp
}
80102695:	c9                   	leave  
80102696:	c3                   	ret    

80102697 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102697:	f3 0f 1e fb          	endbr32 
8010269b:	55                   	push   %ebp
8010269c:	89 e5                	mov    %esp,%ebp
8010269e:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801026a1:	83 ec 04             	sub    $0x4,%esp
801026a4:	ff 75 0c             	pushl  0xc(%ebp)
801026a7:	6a 01                	push   $0x1
801026a9:	ff 75 08             	pushl  0x8(%ebp)
801026ac:	e8 a3 fe ff ff       	call   80102554 <namex>
801026b1:	83 c4 10             	add    $0x10,%esp
}
801026b4:	c9                   	leave  
801026b5:	c3                   	ret    

801026b6 <inb>:
{
801026b6:	55                   	push   %ebp
801026b7:	89 e5                	mov    %esp,%ebp
801026b9:	83 ec 14             	sub    $0x14,%esp
801026bc:	8b 45 08             	mov    0x8(%ebp),%eax
801026bf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801026c7:	89 c2                	mov    %eax,%edx
801026c9:	ec                   	in     (%dx),%al
801026ca:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801026cd:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801026d1:	c9                   	leave  
801026d2:	c3                   	ret    

801026d3 <insl>:
{
801026d3:	55                   	push   %ebp
801026d4:	89 e5                	mov    %esp,%ebp
801026d6:	57                   	push   %edi
801026d7:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801026d8:	8b 55 08             	mov    0x8(%ebp),%edx
801026db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026de:	8b 45 10             	mov    0x10(%ebp),%eax
801026e1:	89 cb                	mov    %ecx,%ebx
801026e3:	89 df                	mov    %ebx,%edi
801026e5:	89 c1                	mov    %eax,%ecx
801026e7:	fc                   	cld    
801026e8:	f3 6d                	rep insl (%dx),%es:(%edi)
801026ea:	89 c8                	mov    %ecx,%eax
801026ec:	89 fb                	mov    %edi,%ebx
801026ee:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801026f1:	89 45 10             	mov    %eax,0x10(%ebp)
}
801026f4:	90                   	nop
801026f5:	5b                   	pop    %ebx
801026f6:	5f                   	pop    %edi
801026f7:	5d                   	pop    %ebp
801026f8:	c3                   	ret    

801026f9 <outb>:
{
801026f9:	55                   	push   %ebp
801026fa:	89 e5                	mov    %esp,%ebp
801026fc:	83 ec 08             	sub    $0x8,%esp
801026ff:	8b 45 08             	mov    0x8(%ebp),%eax
80102702:	8b 55 0c             	mov    0xc(%ebp),%edx
80102705:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102709:	89 d0                	mov    %edx,%eax
8010270b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010270e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102712:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102716:	ee                   	out    %al,(%dx)
}
80102717:	90                   	nop
80102718:	c9                   	leave  
80102719:	c3                   	ret    

8010271a <outsl>:
{
8010271a:	55                   	push   %ebp
8010271b:	89 e5                	mov    %esp,%ebp
8010271d:	56                   	push   %esi
8010271e:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010271f:	8b 55 08             	mov    0x8(%ebp),%edx
80102722:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102725:	8b 45 10             	mov    0x10(%ebp),%eax
80102728:	89 cb                	mov    %ecx,%ebx
8010272a:	89 de                	mov    %ebx,%esi
8010272c:	89 c1                	mov    %eax,%ecx
8010272e:	fc                   	cld    
8010272f:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102731:	89 c8                	mov    %ecx,%eax
80102733:	89 f3                	mov    %esi,%ebx
80102735:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102738:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010273b:	90                   	nop
8010273c:	5b                   	pop    %ebx
8010273d:	5e                   	pop    %esi
8010273e:	5d                   	pop    %ebp
8010273f:	c3                   	ret    

80102740 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102740:	f3 0f 1e fb          	endbr32 
80102744:	55                   	push   %ebp
80102745:	89 e5                	mov    %esp,%ebp
80102747:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010274a:	90                   	nop
8010274b:	68 f7 01 00 00       	push   $0x1f7
80102750:	e8 61 ff ff ff       	call   801026b6 <inb>
80102755:	83 c4 04             	add    $0x4,%esp
80102758:	0f b6 c0             	movzbl %al,%eax
8010275b:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010275e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102761:	25 c0 00 00 00       	and    $0xc0,%eax
80102766:	83 f8 40             	cmp    $0x40,%eax
80102769:	75 e0                	jne    8010274b <idewait+0xb>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010276b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010276f:	74 11                	je     80102782 <idewait+0x42>
80102771:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102774:	83 e0 21             	and    $0x21,%eax
80102777:	85 c0                	test   %eax,%eax
80102779:	74 07                	je     80102782 <idewait+0x42>
    return -1;
8010277b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102780:	eb 05                	jmp    80102787 <idewait+0x47>
  return 0;
80102782:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102787:	c9                   	leave  
80102788:	c3                   	ret    

80102789 <ideinit>:

void
ideinit(void)
{
80102789:	f3 0f 1e fb          	endbr32 
8010278d:	55                   	push   %ebp
8010278e:	89 e5                	mov    %esp,%ebp
80102790:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102793:	83 ec 08             	sub    $0x8,%esp
80102796:	68 23 93 10 80       	push   $0x80109323
8010279b:	68 00 c6 10 80       	push   $0x8010c600
801027a0:	e8 c7 2a 00 00       	call   8010526c <initlock>
801027a5:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801027a8:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
801027ad:	83 e8 01             	sub    $0x1,%eax
801027b0:	83 ec 08             	sub    $0x8,%esp
801027b3:	50                   	push   %eax
801027b4:	6a 0e                	push   $0xe
801027b6:	e8 bb 04 00 00       	call   80102c76 <ioapicenable>
801027bb:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801027be:	83 ec 0c             	sub    $0xc,%esp
801027c1:	6a 00                	push   $0x0
801027c3:	e8 78 ff ff ff       	call   80102740 <idewait>
801027c8:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801027cb:	83 ec 08             	sub    $0x8,%esp
801027ce:	68 f0 00 00 00       	push   $0xf0
801027d3:	68 f6 01 00 00       	push   $0x1f6
801027d8:	e8 1c ff ff ff       	call   801026f9 <outb>
801027dd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801027e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801027e7:	eb 24                	jmp    8010280d <ideinit+0x84>
    if(inb(0x1f7) != 0){
801027e9:	83 ec 0c             	sub    $0xc,%esp
801027ec:	68 f7 01 00 00       	push   $0x1f7
801027f1:	e8 c0 fe ff ff       	call   801026b6 <inb>
801027f6:	83 c4 10             	add    $0x10,%esp
801027f9:	84 c0                	test   %al,%al
801027fb:	74 0c                	je     80102809 <ideinit+0x80>
      havedisk1 = 1;
801027fd:	c7 05 38 c6 10 80 01 	movl   $0x1,0x8010c638
80102804:	00 00 00 
      break;
80102807:	eb 0d                	jmp    80102816 <ideinit+0x8d>
  for(i=0; i<1000; i++){
80102809:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010280d:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102814:	7e d3                	jle    801027e9 <ideinit+0x60>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102816:	83 ec 08             	sub    $0x8,%esp
80102819:	68 e0 00 00 00       	push   $0xe0
8010281e:	68 f6 01 00 00       	push   $0x1f6
80102823:	e8 d1 fe ff ff       	call   801026f9 <outb>
80102828:	83 c4 10             	add    $0x10,%esp
}
8010282b:	90                   	nop
8010282c:	c9                   	leave  
8010282d:	c3                   	ret    

8010282e <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010282e:	f3 0f 1e fb          	endbr32 
80102832:	55                   	push   %ebp
80102833:	89 e5                	mov    %esp,%ebp
80102835:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102838:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010283c:	75 0d                	jne    8010284b <idestart+0x1d>
    panic("idestart");
8010283e:	83 ec 0c             	sub    $0xc,%esp
80102841:	68 27 93 10 80       	push   $0x80109327
80102846:	e8 bd dd ff ff       	call   80100608 <panic>
  if(b->blockno >= FSSIZE)
8010284b:	8b 45 08             	mov    0x8(%ebp),%eax
8010284e:	8b 40 08             	mov    0x8(%eax),%eax
80102851:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102856:	76 0d                	jbe    80102865 <idestart+0x37>
    panic("incorrect blockno");
80102858:	83 ec 0c             	sub    $0xc,%esp
8010285b:	68 30 93 10 80       	push   $0x80109330
80102860:	e8 a3 dd ff ff       	call   80100608 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102865:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010286c:	8b 45 08             	mov    0x8(%ebp),%eax
8010286f:	8b 50 08             	mov    0x8(%eax),%edx
80102872:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102875:	0f af c2             	imul   %edx,%eax
80102878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010287b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010287f:	75 07                	jne    80102888 <idestart+0x5a>
80102881:	b8 20 00 00 00       	mov    $0x20,%eax
80102886:	eb 05                	jmp    8010288d <idestart+0x5f>
80102888:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010288d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102890:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102894:	75 07                	jne    8010289d <idestart+0x6f>
80102896:	b8 30 00 00 00       	mov    $0x30,%eax
8010289b:	eb 05                	jmp    801028a2 <idestart+0x74>
8010289d:	b8 c5 00 00 00       	mov    $0xc5,%eax
801028a2:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
801028a5:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801028a9:	7e 0d                	jle    801028b8 <idestart+0x8a>
801028ab:	83 ec 0c             	sub    $0xc,%esp
801028ae:	68 27 93 10 80       	push   $0x80109327
801028b3:	e8 50 dd ff ff       	call   80100608 <panic>

  idewait(0);
801028b8:	83 ec 0c             	sub    $0xc,%esp
801028bb:	6a 00                	push   $0x0
801028bd:	e8 7e fe ff ff       	call   80102740 <idewait>
801028c2:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801028c5:	83 ec 08             	sub    $0x8,%esp
801028c8:	6a 00                	push   $0x0
801028ca:	68 f6 03 00 00       	push   $0x3f6
801028cf:	e8 25 fe ff ff       	call   801026f9 <outb>
801028d4:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028da:	0f b6 c0             	movzbl %al,%eax
801028dd:	83 ec 08             	sub    $0x8,%esp
801028e0:	50                   	push   %eax
801028e1:	68 f2 01 00 00       	push   $0x1f2
801028e6:	e8 0e fe ff ff       	call   801026f9 <outb>
801028eb:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801028ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028f1:	0f b6 c0             	movzbl %al,%eax
801028f4:	83 ec 08             	sub    $0x8,%esp
801028f7:	50                   	push   %eax
801028f8:	68 f3 01 00 00       	push   $0x1f3
801028fd:	e8 f7 fd ff ff       	call   801026f9 <outb>
80102902:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102905:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102908:	c1 f8 08             	sar    $0x8,%eax
8010290b:	0f b6 c0             	movzbl %al,%eax
8010290e:	83 ec 08             	sub    $0x8,%esp
80102911:	50                   	push   %eax
80102912:	68 f4 01 00 00       	push   $0x1f4
80102917:	e8 dd fd ff ff       	call   801026f9 <outb>
8010291c:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
8010291f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102922:	c1 f8 10             	sar    $0x10,%eax
80102925:	0f b6 c0             	movzbl %al,%eax
80102928:	83 ec 08             	sub    $0x8,%esp
8010292b:	50                   	push   %eax
8010292c:	68 f5 01 00 00       	push   $0x1f5
80102931:	e8 c3 fd ff ff       	call   801026f9 <outb>
80102936:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102939:	8b 45 08             	mov    0x8(%ebp),%eax
8010293c:	8b 40 04             	mov    0x4(%eax),%eax
8010293f:	c1 e0 04             	shl    $0x4,%eax
80102942:	83 e0 10             	and    $0x10,%eax
80102945:	89 c2                	mov    %eax,%edx
80102947:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010294a:	c1 f8 18             	sar    $0x18,%eax
8010294d:	83 e0 0f             	and    $0xf,%eax
80102950:	09 d0                	or     %edx,%eax
80102952:	83 c8 e0             	or     $0xffffffe0,%eax
80102955:	0f b6 c0             	movzbl %al,%eax
80102958:	83 ec 08             	sub    $0x8,%esp
8010295b:	50                   	push   %eax
8010295c:	68 f6 01 00 00       	push   $0x1f6
80102961:	e8 93 fd ff ff       	call   801026f9 <outb>
80102966:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102969:	8b 45 08             	mov    0x8(%ebp),%eax
8010296c:	8b 00                	mov    (%eax),%eax
8010296e:	83 e0 04             	and    $0x4,%eax
80102971:	85 c0                	test   %eax,%eax
80102973:	74 35                	je     801029aa <idestart+0x17c>
    outb(0x1f7, write_cmd);
80102975:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102978:	0f b6 c0             	movzbl %al,%eax
8010297b:	83 ec 08             	sub    $0x8,%esp
8010297e:	50                   	push   %eax
8010297f:	68 f7 01 00 00       	push   $0x1f7
80102984:	e8 70 fd ff ff       	call   801026f9 <outb>
80102989:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010298c:	8b 45 08             	mov    0x8(%ebp),%eax
8010298f:	83 c0 5c             	add    $0x5c,%eax
80102992:	83 ec 04             	sub    $0x4,%esp
80102995:	68 80 00 00 00       	push   $0x80
8010299a:	50                   	push   %eax
8010299b:	68 f0 01 00 00       	push   $0x1f0
801029a0:	e8 75 fd ff ff       	call   8010271a <outsl>
801029a5:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
801029a8:	eb 17                	jmp    801029c1 <idestart+0x193>
    outb(0x1f7, read_cmd);
801029aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029ad:	0f b6 c0             	movzbl %al,%eax
801029b0:	83 ec 08             	sub    $0x8,%esp
801029b3:	50                   	push   %eax
801029b4:	68 f7 01 00 00       	push   $0x1f7
801029b9:	e8 3b fd ff ff       	call   801026f9 <outb>
801029be:	83 c4 10             	add    $0x10,%esp
}
801029c1:	90                   	nop
801029c2:	c9                   	leave  
801029c3:	c3                   	ret    

801029c4 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801029c4:	f3 0f 1e fb          	endbr32 
801029c8:	55                   	push   %ebp
801029c9:	89 e5                	mov    %esp,%ebp
801029cb:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801029ce:	83 ec 0c             	sub    $0xc,%esp
801029d1:	68 00 c6 10 80       	push   $0x8010c600
801029d6:	e8 b7 28 00 00       	call   80105292 <acquire>
801029db:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
801029de:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801029e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801029ea:	75 15                	jne    80102a01 <ideintr+0x3d>
    release(&idelock);
801029ec:	83 ec 0c             	sub    $0xc,%esp
801029ef:	68 00 c6 10 80       	push   $0x8010c600
801029f4:	e8 0b 29 00 00       	call   80105304 <release>
801029f9:	83 c4 10             	add    $0x10,%esp
    return;
801029fc:	e9 9a 00 00 00       	jmp    80102a9b <ideintr+0xd7>
  }
  idequeue = b->qnext;
80102a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a04:	8b 40 58             	mov    0x58(%eax),%eax
80102a07:	a3 34 c6 10 80       	mov    %eax,0x8010c634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a0f:	8b 00                	mov    (%eax),%eax
80102a11:	83 e0 04             	and    $0x4,%eax
80102a14:	85 c0                	test   %eax,%eax
80102a16:	75 2d                	jne    80102a45 <ideintr+0x81>
80102a18:	83 ec 0c             	sub    $0xc,%esp
80102a1b:	6a 01                	push   $0x1
80102a1d:	e8 1e fd ff ff       	call   80102740 <idewait>
80102a22:	83 c4 10             	add    $0x10,%esp
80102a25:	85 c0                	test   %eax,%eax
80102a27:	78 1c                	js     80102a45 <ideintr+0x81>
    insl(0x1f0, b->data, BSIZE/4);
80102a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2c:	83 c0 5c             	add    $0x5c,%eax
80102a2f:	83 ec 04             	sub    $0x4,%esp
80102a32:	68 80 00 00 00       	push   $0x80
80102a37:	50                   	push   %eax
80102a38:	68 f0 01 00 00       	push   $0x1f0
80102a3d:	e8 91 fc ff ff       	call   801026d3 <insl>
80102a42:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a48:	8b 00                	mov    (%eax),%eax
80102a4a:	83 c8 02             	or     $0x2,%eax
80102a4d:	89 c2                	mov    %eax,%edx
80102a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a52:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a57:	8b 00                	mov    (%eax),%eax
80102a59:	83 e0 fb             	and    $0xfffffffb,%eax
80102a5c:	89 c2                	mov    %eax,%edx
80102a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a61:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102a63:	83 ec 0c             	sub    $0xc,%esp
80102a66:	ff 75 f4             	pushl  -0xc(%ebp)
80102a69:	e8 a4 24 00 00       	call   80104f12 <wakeup>
80102a6e:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102a71:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102a76:	85 c0                	test   %eax,%eax
80102a78:	74 11                	je     80102a8b <ideintr+0xc7>
    idestart(idequeue);
80102a7a:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102a7f:	83 ec 0c             	sub    $0xc,%esp
80102a82:	50                   	push   %eax
80102a83:	e8 a6 fd ff ff       	call   8010282e <idestart>
80102a88:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102a8b:	83 ec 0c             	sub    $0xc,%esp
80102a8e:	68 00 c6 10 80       	push   $0x8010c600
80102a93:	e8 6c 28 00 00       	call   80105304 <release>
80102a98:	83 c4 10             	add    $0x10,%esp
}
80102a9b:	c9                   	leave  
80102a9c:	c3                   	ret    

80102a9d <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102a9d:	f3 0f 1e fb          	endbr32 
80102aa1:	55                   	push   %ebp
80102aa2:	89 e5                	mov    %esp,%ebp
80102aa4:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80102aaa:	83 c0 0c             	add    $0xc,%eax
80102aad:	83 ec 0c             	sub    $0xc,%esp
80102ab0:	50                   	push   %eax
80102ab1:	e8 1d 27 00 00       	call   801051d3 <holdingsleep>
80102ab6:	83 c4 10             	add    $0x10,%esp
80102ab9:	85 c0                	test   %eax,%eax
80102abb:	75 0d                	jne    80102aca <iderw+0x2d>
    panic("iderw: buf not locked");
80102abd:	83 ec 0c             	sub    $0xc,%esp
80102ac0:	68 42 93 10 80       	push   $0x80109342
80102ac5:	e8 3e db ff ff       	call   80100608 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102aca:	8b 45 08             	mov    0x8(%ebp),%eax
80102acd:	8b 00                	mov    (%eax),%eax
80102acf:	83 e0 06             	and    $0x6,%eax
80102ad2:	83 f8 02             	cmp    $0x2,%eax
80102ad5:	75 0d                	jne    80102ae4 <iderw+0x47>
    panic("iderw: nothing to do");
80102ad7:	83 ec 0c             	sub    $0xc,%esp
80102ada:	68 58 93 10 80       	push   $0x80109358
80102adf:	e8 24 db ff ff       	call   80100608 <panic>
  if(b->dev != 0 && !havedisk1)
80102ae4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae7:	8b 40 04             	mov    0x4(%eax),%eax
80102aea:	85 c0                	test   %eax,%eax
80102aec:	74 16                	je     80102b04 <iderw+0x67>
80102aee:	a1 38 c6 10 80       	mov    0x8010c638,%eax
80102af3:	85 c0                	test   %eax,%eax
80102af5:	75 0d                	jne    80102b04 <iderw+0x67>
    panic("iderw: ide disk 1 not present");
80102af7:	83 ec 0c             	sub    $0xc,%esp
80102afa:	68 6d 93 10 80       	push   $0x8010936d
80102aff:	e8 04 db ff ff       	call   80100608 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102b04:	83 ec 0c             	sub    $0xc,%esp
80102b07:	68 00 c6 10 80       	push   $0x8010c600
80102b0c:	e8 81 27 00 00       	call   80105292 <acquire>
80102b11:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102b14:	8b 45 08             	mov    0x8(%ebp),%eax
80102b17:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b1e:	c7 45 f4 34 c6 10 80 	movl   $0x8010c634,-0xc(%ebp)
80102b25:	eb 0b                	jmp    80102b32 <iderw+0x95>
80102b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2a:	8b 00                	mov    (%eax),%eax
80102b2c:	83 c0 58             	add    $0x58,%eax
80102b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b35:	8b 00                	mov    (%eax),%eax
80102b37:	85 c0                	test   %eax,%eax
80102b39:	75 ec                	jne    80102b27 <iderw+0x8a>
    ;
  *pp = b;
80102b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b3e:	8b 55 08             	mov    0x8(%ebp),%edx
80102b41:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102b43:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102b48:	39 45 08             	cmp    %eax,0x8(%ebp)
80102b4b:	75 23                	jne    80102b70 <iderw+0xd3>
    idestart(b);
80102b4d:	83 ec 0c             	sub    $0xc,%esp
80102b50:	ff 75 08             	pushl  0x8(%ebp)
80102b53:	e8 d6 fc ff ff       	call   8010282e <idestart>
80102b58:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b5b:	eb 13                	jmp    80102b70 <iderw+0xd3>
    sleep(b, &idelock);
80102b5d:	83 ec 08             	sub    $0x8,%esp
80102b60:	68 00 c6 10 80       	push   $0x8010c600
80102b65:	ff 75 08             	pushl  0x8(%ebp)
80102b68:	e8 b3 22 00 00       	call   80104e20 <sleep>
80102b6d:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b70:	8b 45 08             	mov    0x8(%ebp),%eax
80102b73:	8b 00                	mov    (%eax),%eax
80102b75:	83 e0 06             	and    $0x6,%eax
80102b78:	83 f8 02             	cmp    $0x2,%eax
80102b7b:	75 e0                	jne    80102b5d <iderw+0xc0>
  }


  release(&idelock);
80102b7d:	83 ec 0c             	sub    $0xc,%esp
80102b80:	68 00 c6 10 80       	push   $0x8010c600
80102b85:	e8 7a 27 00 00       	call   80105304 <release>
80102b8a:	83 c4 10             	add    $0x10,%esp
}
80102b8d:	90                   	nop
80102b8e:	c9                   	leave  
80102b8f:	c3                   	ret    

80102b90 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102b90:	f3 0f 1e fb          	endbr32 
80102b94:	55                   	push   %ebp
80102b95:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b97:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102b9c:	8b 55 08             	mov    0x8(%ebp),%edx
80102b9f:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102ba1:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102ba6:	8b 40 10             	mov    0x10(%eax),%eax
}
80102ba9:	5d                   	pop    %ebp
80102baa:	c3                   	ret    

80102bab <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102bab:	f3 0f 1e fb          	endbr32 
80102baf:	55                   	push   %ebp
80102bb0:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102bb2:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102bb7:	8b 55 08             	mov    0x8(%ebp),%edx
80102bba:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102bbc:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
80102bc4:	89 50 10             	mov    %edx,0x10(%eax)
}
80102bc7:	90                   	nop
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret    

80102bca <ioapicinit>:

void
ioapicinit(void)
{
80102bca:	f3 0f 1e fb          	endbr32 
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102bd4:	c7 05 d4 46 11 80 00 	movl   $0xfec00000,0x801146d4
80102bdb:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102bde:	6a 01                	push   $0x1
80102be0:	e8 ab ff ff ff       	call   80102b90 <ioapicread>
80102be5:	83 c4 04             	add    $0x4,%esp
80102be8:	c1 e8 10             	shr    $0x10,%eax
80102beb:	25 ff 00 00 00       	and    $0xff,%eax
80102bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102bf3:	6a 00                	push   $0x0
80102bf5:	e8 96 ff ff ff       	call   80102b90 <ioapicread>
80102bfa:	83 c4 04             	add    $0x4,%esp
80102bfd:	c1 e8 18             	shr    $0x18,%eax
80102c00:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102c03:	0f b6 05 00 48 11 80 	movzbl 0x80114800,%eax
80102c0a:	0f b6 c0             	movzbl %al,%eax
80102c0d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102c10:	74 10                	je     80102c22 <ioapicinit+0x58>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102c12:	83 ec 0c             	sub    $0xc,%esp
80102c15:	68 8c 93 10 80       	push   $0x8010938c
80102c1a:	e8 f9 d7 ff ff       	call   80100418 <cprintf>
80102c1f:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102c22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102c29:	eb 3f                	jmp    80102c6a <ioapicinit+0xa0>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c2e:	83 c0 20             	add    $0x20,%eax
80102c31:	0d 00 00 01 00       	or     $0x10000,%eax
80102c36:	89 c2                	mov    %eax,%edx
80102c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c3b:	83 c0 08             	add    $0x8,%eax
80102c3e:	01 c0                	add    %eax,%eax
80102c40:	83 ec 08             	sub    $0x8,%esp
80102c43:	52                   	push   %edx
80102c44:	50                   	push   %eax
80102c45:	e8 61 ff ff ff       	call   80102bab <ioapicwrite>
80102c4a:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c50:	83 c0 08             	add    $0x8,%eax
80102c53:	01 c0                	add    %eax,%eax
80102c55:	83 c0 01             	add    $0x1,%eax
80102c58:	83 ec 08             	sub    $0x8,%esp
80102c5b:	6a 00                	push   $0x0
80102c5d:	50                   	push   %eax
80102c5e:	e8 48 ff ff ff       	call   80102bab <ioapicwrite>
80102c63:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102c66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102c70:	7e b9                	jle    80102c2b <ioapicinit+0x61>
  }
}
80102c72:	90                   	nop
80102c73:	90                   	nop
80102c74:	c9                   	leave  
80102c75:	c3                   	ret    

80102c76 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102c76:	f3 0f 1e fb          	endbr32 
80102c7a:	55                   	push   %ebp
80102c7b:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80102c80:	83 c0 20             	add    $0x20,%eax
80102c83:	89 c2                	mov    %eax,%edx
80102c85:	8b 45 08             	mov    0x8(%ebp),%eax
80102c88:	83 c0 08             	add    $0x8,%eax
80102c8b:	01 c0                	add    %eax,%eax
80102c8d:	52                   	push   %edx
80102c8e:	50                   	push   %eax
80102c8f:	e8 17 ff ff ff       	call   80102bab <ioapicwrite>
80102c94:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102c97:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c9a:	c1 e0 18             	shl    $0x18,%eax
80102c9d:	89 c2                	mov    %eax,%edx
80102c9f:	8b 45 08             	mov    0x8(%ebp),%eax
80102ca2:	83 c0 08             	add    $0x8,%eax
80102ca5:	01 c0                	add    %eax,%eax
80102ca7:	83 c0 01             	add    $0x1,%eax
80102caa:	52                   	push   %edx
80102cab:	50                   	push   %eax
80102cac:	e8 fa fe ff ff       	call   80102bab <ioapicwrite>
80102cb1:	83 c4 08             	add    $0x8,%esp
}
80102cb4:	90                   	nop
80102cb5:	c9                   	leave  
80102cb6:	c3                   	ret    

80102cb7 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102cb7:	f3 0f 1e fb          	endbr32 
80102cbb:	55                   	push   %ebp
80102cbc:	89 e5                	mov    %esp,%ebp
80102cbe:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102cc1:	83 ec 08             	sub    $0x8,%esp
80102cc4:	68 c0 93 10 80       	push   $0x801093c0
80102cc9:	68 e0 46 11 80       	push   $0x801146e0
80102cce:	e8 99 25 00 00       	call   8010526c <initlock>
80102cd3:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102cd6:	c7 05 14 47 11 80 00 	movl   $0x0,0x80114714
80102cdd:	00 00 00 
  freerange(vstart, vend);
80102ce0:	83 ec 08             	sub    $0x8,%esp
80102ce3:	ff 75 0c             	pushl  0xc(%ebp)
80102ce6:	ff 75 08             	pushl  0x8(%ebp)
80102ce9:	e8 2e 00 00 00       	call   80102d1c <freerange>
80102cee:	83 c4 10             	add    $0x10,%esp
}
80102cf1:	90                   	nop
80102cf2:	c9                   	leave  
80102cf3:	c3                   	ret    

80102cf4 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102cf4:	f3 0f 1e fb          	endbr32 
80102cf8:	55                   	push   %ebp
80102cf9:	89 e5                	mov    %esp,%ebp
80102cfb:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102cfe:	83 ec 08             	sub    $0x8,%esp
80102d01:	ff 75 0c             	pushl  0xc(%ebp)
80102d04:	ff 75 08             	pushl  0x8(%ebp)
80102d07:	e8 10 00 00 00       	call   80102d1c <freerange>
80102d0c:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102d0f:	c7 05 14 47 11 80 01 	movl   $0x1,0x80114714
80102d16:	00 00 00 
}
80102d19:	90                   	nop
80102d1a:	c9                   	leave  
80102d1b:	c3                   	ret    

80102d1c <freerange>:

void
freerange(void *vstart, void *vend)
{
80102d1c:	f3 0f 1e fb          	endbr32 
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102d26:	8b 45 08             	mov    0x8(%ebp),%eax
80102d29:	05 ff 0f 00 00       	add    $0xfff,%eax
80102d2e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d36:	eb 15                	jmp    80102d4d <freerange+0x31>
    kfree(p);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	ff 75 f4             	pushl  -0xc(%ebp)
80102d3e:	e8 1b 00 00 00       	call   80102d5e <kfree>
80102d43:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d46:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d50:	05 00 10 00 00       	add    $0x1000,%eax
80102d55:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102d58:	73 de                	jae    80102d38 <freerange+0x1c>
}
80102d5a:	90                   	nop
80102d5b:	90                   	nop
80102d5c:	c9                   	leave  
80102d5d:	c3                   	ret    

80102d5e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102d5e:	f3 0f 1e fb          	endbr32 
80102d62:	55                   	push   %ebp
80102d63:	89 e5                	mov    %esp,%ebp
80102d65:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102d68:	8b 45 08             	mov    0x8(%ebp),%eax
80102d6b:	25 ff 0f 00 00       	and    $0xfff,%eax
80102d70:	85 c0                	test   %eax,%eax
80102d72:	75 18                	jne    80102d8c <kfree+0x2e>
80102d74:	81 7d 08 48 87 11 80 	cmpl   $0x80118748,0x8(%ebp)
80102d7b:	72 0f                	jb     80102d8c <kfree+0x2e>
80102d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80102d80:	05 00 00 00 80       	add    $0x80000000,%eax
80102d85:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102d8a:	76 0d                	jbe    80102d99 <kfree+0x3b>
    panic("kfree");
80102d8c:	83 ec 0c             	sub    $0xc,%esp
80102d8f:	68 c5 93 10 80       	push   $0x801093c5
80102d94:	e8 6f d8 ff ff       	call   80100608 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102d99:	83 ec 04             	sub    $0x4,%esp
80102d9c:	68 00 10 00 00       	push   $0x1000
80102da1:	6a 01                	push   $0x1
80102da3:	ff 75 08             	pushl  0x8(%ebp)
80102da6:	e8 86 27 00 00       	call   80105531 <memset>
80102dab:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102dae:	a1 14 47 11 80       	mov    0x80114714,%eax
80102db3:	85 c0                	test   %eax,%eax
80102db5:	74 10                	je     80102dc7 <kfree+0x69>
    acquire(&kmem.lock);
80102db7:	83 ec 0c             	sub    $0xc,%esp
80102dba:	68 e0 46 11 80       	push   $0x801146e0
80102dbf:	e8 ce 24 00 00       	call   80105292 <acquire>
80102dc4:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80102dca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102dcd:	8b 15 18 47 11 80    	mov    0x80114718,%edx
80102dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dd6:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ddb:	a3 18 47 11 80       	mov    %eax,0x80114718
  if(kmem.use_lock)
80102de0:	a1 14 47 11 80       	mov    0x80114714,%eax
80102de5:	85 c0                	test   %eax,%eax
80102de7:	74 10                	je     80102df9 <kfree+0x9b>
    release(&kmem.lock);
80102de9:	83 ec 0c             	sub    $0xc,%esp
80102dec:	68 e0 46 11 80       	push   $0x801146e0
80102df1:	e8 0e 25 00 00       	call   80105304 <release>
80102df6:	83 c4 10             	add    $0x10,%esp
}
80102df9:	90                   	nop
80102dfa:	c9                   	leave  
80102dfb:	c3                   	ret    

80102dfc <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102dfc:	f3 0f 1e fb          	endbr32 
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102e06:	a1 14 47 11 80       	mov    0x80114714,%eax
80102e0b:	85 c0                	test   %eax,%eax
80102e0d:	74 10                	je     80102e1f <kalloc+0x23>
    acquire(&kmem.lock);
80102e0f:	83 ec 0c             	sub    $0xc,%esp
80102e12:	68 e0 46 11 80       	push   $0x801146e0
80102e17:	e8 76 24 00 00       	call   80105292 <acquire>
80102e1c:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102e1f:	a1 18 47 11 80       	mov    0x80114718,%eax
80102e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102e27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102e2b:	74 0a                	je     80102e37 <kalloc+0x3b>
    kmem.freelist = r->next;
80102e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e30:	8b 00                	mov    (%eax),%eax
80102e32:	a3 18 47 11 80       	mov    %eax,0x80114718
  if(kmem.use_lock)
80102e37:	a1 14 47 11 80       	mov    0x80114714,%eax
80102e3c:	85 c0                	test   %eax,%eax
80102e3e:	74 10                	je     80102e50 <kalloc+0x54>
    release(&kmem.lock);
80102e40:	83 ec 0c             	sub    $0xc,%esp
80102e43:	68 e0 46 11 80       	push   $0x801146e0
80102e48:	e8 b7 24 00 00       	call   80105304 <release>
80102e4d:	83 c4 10             	add    $0x10,%esp
  cprintf("p4Debug : kalloc returns %d %x\n", PPN(V2P(r)), V2P(r));
80102e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e53:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80102e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e5c:	05 00 00 00 80       	add    $0x80000000,%eax
80102e61:	c1 e8 0c             	shr    $0xc,%eax
80102e64:	83 ec 04             	sub    $0x4,%esp
80102e67:	52                   	push   %edx
80102e68:	50                   	push   %eax
80102e69:	68 cc 93 10 80       	push   $0x801093cc
80102e6e:	e8 a5 d5 ff ff       	call   80100418 <cprintf>
80102e73:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102e79:	c9                   	leave  
80102e7a:	c3                   	ret    

80102e7b <inb>:
{
80102e7b:	55                   	push   %ebp
80102e7c:	89 e5                	mov    %esp,%ebp
80102e7e:	83 ec 14             	sub    $0x14,%esp
80102e81:	8b 45 08             	mov    0x8(%ebp),%eax
80102e84:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e88:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e8c:	89 c2                	mov    %eax,%edx
80102e8e:	ec                   	in     (%dx),%al
80102e8f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e92:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e96:	c9                   	leave  
80102e97:	c3                   	ret    

80102e98 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102e98:	f3 0f 1e fb          	endbr32 
80102e9c:	55                   	push   %ebp
80102e9d:	89 e5                	mov    %esp,%ebp
80102e9f:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102ea2:	6a 64                	push   $0x64
80102ea4:	e8 d2 ff ff ff       	call   80102e7b <inb>
80102ea9:	83 c4 04             	add    $0x4,%esp
80102eac:	0f b6 c0             	movzbl %al,%eax
80102eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102eb5:	83 e0 01             	and    $0x1,%eax
80102eb8:	85 c0                	test   %eax,%eax
80102eba:	75 0a                	jne    80102ec6 <kbdgetc+0x2e>
    return -1;
80102ebc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ec1:	e9 23 01 00 00       	jmp    80102fe9 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102ec6:	6a 60                	push   $0x60
80102ec8:	e8 ae ff ff ff       	call   80102e7b <inb>
80102ecd:	83 c4 04             	add    $0x4,%esp
80102ed0:	0f b6 c0             	movzbl %al,%eax
80102ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102ed6:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102edd:	75 17                	jne    80102ef6 <kbdgetc+0x5e>
    shift |= E0ESC;
80102edf:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102ee4:	83 c8 40             	or     $0x40,%eax
80102ee7:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80102eec:	b8 00 00 00 00       	mov    $0x0,%eax
80102ef1:	e9 f3 00 00 00       	jmp    80102fe9 <kbdgetc+0x151>
  } else if(data & 0x80){
80102ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ef9:	25 80 00 00 00       	and    $0x80,%eax
80102efe:	85 c0                	test   %eax,%eax
80102f00:	74 45                	je     80102f47 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102f02:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f07:	83 e0 40             	and    $0x40,%eax
80102f0a:	85 c0                	test   %eax,%eax
80102f0c:	75 08                	jne    80102f16 <kbdgetc+0x7e>
80102f0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f11:	83 e0 7f             	and    $0x7f,%eax
80102f14:	eb 03                	jmp    80102f19 <kbdgetc+0x81>
80102f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f19:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102f1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f1f:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102f24:	0f b6 00             	movzbl (%eax),%eax
80102f27:	83 c8 40             	or     $0x40,%eax
80102f2a:	0f b6 c0             	movzbl %al,%eax
80102f2d:	f7 d0                	not    %eax
80102f2f:	89 c2                	mov    %eax,%edx
80102f31:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f36:	21 d0                	and    %edx,%eax
80102f38:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80102f3d:	b8 00 00 00 00       	mov    $0x0,%eax
80102f42:	e9 a2 00 00 00       	jmp    80102fe9 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102f47:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f4c:	83 e0 40             	and    $0x40,%eax
80102f4f:	85 c0                	test   %eax,%eax
80102f51:	74 14                	je     80102f67 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f53:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102f5a:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f5f:	83 e0 bf             	and    $0xffffffbf,%eax
80102f62:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  }

  shift |= shiftcode[data];
80102f67:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f6a:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102f6f:	0f b6 00             	movzbl (%eax),%eax
80102f72:	0f b6 d0             	movzbl %al,%edx
80102f75:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f7a:	09 d0                	or     %edx,%eax
80102f7c:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  shift ^= togglecode[data];
80102f81:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f84:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102f89:	0f b6 00             	movzbl (%eax),%eax
80102f8c:	0f b6 d0             	movzbl %al,%edx
80102f8f:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102f94:	31 d0                	xor    %edx,%eax
80102f96:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102f9b:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102fa0:	83 e0 03             	and    $0x3,%eax
80102fa3:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fad:	01 d0                	add    %edx,%eax
80102faf:	0f b6 00             	movzbl (%eax),%eax
80102fb2:	0f b6 c0             	movzbl %al,%eax
80102fb5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102fb8:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102fbd:	83 e0 08             	and    $0x8,%eax
80102fc0:	85 c0                	test   %eax,%eax
80102fc2:	74 22                	je     80102fe6 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102fc4:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102fc8:	76 0c                	jbe    80102fd6 <kbdgetc+0x13e>
80102fca:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102fce:	77 06                	ja     80102fd6 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102fd0:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102fd4:	eb 10                	jmp    80102fe6 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102fd6:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102fda:	76 0a                	jbe    80102fe6 <kbdgetc+0x14e>
80102fdc:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102fe0:	77 04                	ja     80102fe6 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102fe2:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102fe6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102fe9:	c9                   	leave  
80102fea:	c3                   	ret    

80102feb <kbdintr>:

void
kbdintr(void)
{
80102feb:	f3 0f 1e fb          	endbr32 
80102fef:	55                   	push   %ebp
80102ff0:	89 e5                	mov    %esp,%ebp
80102ff2:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102ff5:	83 ec 0c             	sub    $0xc,%esp
80102ff8:	68 98 2e 10 80       	push   $0x80102e98
80102ffd:	e8 a6 d8 ff ff       	call   801008a8 <consoleintr>
80103002:	83 c4 10             	add    $0x10,%esp
}
80103005:	90                   	nop
80103006:	c9                   	leave  
80103007:	c3                   	ret    

80103008 <inb>:
{
80103008:	55                   	push   %ebp
80103009:	89 e5                	mov    %esp,%ebp
8010300b:	83 ec 14             	sub    $0x14,%esp
8010300e:	8b 45 08             	mov    0x8(%ebp),%eax
80103011:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103015:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103019:	89 c2                	mov    %eax,%edx
8010301b:	ec                   	in     (%dx),%al
8010301c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010301f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103023:	c9                   	leave  
80103024:	c3                   	ret    

80103025 <outb>:
{
80103025:	55                   	push   %ebp
80103026:	89 e5                	mov    %esp,%ebp
80103028:	83 ec 08             	sub    $0x8,%esp
8010302b:	8b 45 08             	mov    0x8(%ebp),%eax
8010302e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103031:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103035:	89 d0                	mov    %edx,%eax
80103037:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010303a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010303e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103042:	ee                   	out    %al,(%dx)
}
80103043:	90                   	nop
80103044:	c9                   	leave  
80103045:	c3                   	ret    

80103046 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80103046:	f3 0f 1e fb          	endbr32 
8010304a:	55                   	push   %ebp
8010304b:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
8010304d:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80103052:	8b 55 08             	mov    0x8(%ebp),%edx
80103055:	c1 e2 02             	shl    $0x2,%edx
80103058:	01 c2                	add    %eax,%edx
8010305a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010305d:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
8010305f:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80103064:	83 c0 20             	add    $0x20,%eax
80103067:	8b 00                	mov    (%eax),%eax
}
80103069:	90                   	nop
8010306a:	5d                   	pop    %ebp
8010306b:	c3                   	ret    

8010306c <lapicinit>:

void
lapicinit(void)
{
8010306c:	f3 0f 1e fb          	endbr32 
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80103073:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80103078:	85 c0                	test   %eax,%eax
8010307a:	0f 84 0c 01 00 00    	je     8010318c <lapicinit+0x120>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103080:	68 3f 01 00 00       	push   $0x13f
80103085:	6a 3c                	push   $0x3c
80103087:	e8 ba ff ff ff       	call   80103046 <lapicw>
8010308c:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
8010308f:	6a 0b                	push   $0xb
80103091:	68 f8 00 00 00       	push   $0xf8
80103096:	e8 ab ff ff ff       	call   80103046 <lapicw>
8010309b:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010309e:	68 20 00 02 00       	push   $0x20020
801030a3:	68 c8 00 00 00       	push   $0xc8
801030a8:	e8 99 ff ff ff       	call   80103046 <lapicw>
801030ad:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
801030b0:	68 80 96 98 00       	push   $0x989680
801030b5:	68 e0 00 00 00       	push   $0xe0
801030ba:	e8 87 ff ff ff       	call   80103046 <lapicw>
801030bf:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
801030c2:	68 00 00 01 00       	push   $0x10000
801030c7:	68 d4 00 00 00       	push   $0xd4
801030cc:	e8 75 ff ff ff       	call   80103046 <lapicw>
801030d1:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
801030d4:	68 00 00 01 00       	push   $0x10000
801030d9:	68 d8 00 00 00       	push   $0xd8
801030de:	e8 63 ff ff ff       	call   80103046 <lapicw>
801030e3:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801030e6:	a1 1c 47 11 80       	mov    0x8011471c,%eax
801030eb:	83 c0 30             	add    $0x30,%eax
801030ee:	8b 00                	mov    (%eax),%eax
801030f0:	c1 e8 10             	shr    $0x10,%eax
801030f3:	25 fc 00 00 00       	and    $0xfc,%eax
801030f8:	85 c0                	test   %eax,%eax
801030fa:	74 12                	je     8010310e <lapicinit+0xa2>
    lapicw(PCINT, MASKED);
801030fc:	68 00 00 01 00       	push   $0x10000
80103101:	68 d0 00 00 00       	push   $0xd0
80103106:	e8 3b ff ff ff       	call   80103046 <lapicw>
8010310b:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
8010310e:	6a 33                	push   $0x33
80103110:	68 dc 00 00 00       	push   $0xdc
80103115:	e8 2c ff ff ff       	call   80103046 <lapicw>
8010311a:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
8010311d:	6a 00                	push   $0x0
8010311f:	68 a0 00 00 00       	push   $0xa0
80103124:	e8 1d ff ff ff       	call   80103046 <lapicw>
80103129:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
8010312c:	6a 00                	push   $0x0
8010312e:	68 a0 00 00 00       	push   $0xa0
80103133:	e8 0e ff ff ff       	call   80103046 <lapicw>
80103138:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
8010313b:	6a 00                	push   $0x0
8010313d:	6a 2c                	push   $0x2c
8010313f:	e8 02 ff ff ff       	call   80103046 <lapicw>
80103144:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103147:	6a 00                	push   $0x0
80103149:	68 c4 00 00 00       	push   $0xc4
8010314e:	e8 f3 fe ff ff       	call   80103046 <lapicw>
80103153:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103156:	68 00 85 08 00       	push   $0x88500
8010315b:	68 c0 00 00 00       	push   $0xc0
80103160:	e8 e1 fe ff ff       	call   80103046 <lapicw>
80103165:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103168:	90                   	nop
80103169:	a1 1c 47 11 80       	mov    0x8011471c,%eax
8010316e:	05 00 03 00 00       	add    $0x300,%eax
80103173:	8b 00                	mov    (%eax),%eax
80103175:	25 00 10 00 00       	and    $0x1000,%eax
8010317a:	85 c0                	test   %eax,%eax
8010317c:	75 eb                	jne    80103169 <lapicinit+0xfd>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
8010317e:	6a 00                	push   $0x0
80103180:	6a 20                	push   $0x20
80103182:	e8 bf fe ff ff       	call   80103046 <lapicw>
80103187:	83 c4 08             	add    $0x8,%esp
8010318a:	eb 01                	jmp    8010318d <lapicinit+0x121>
    return;
8010318c:	90                   	nop
}
8010318d:	c9                   	leave  
8010318e:	c3                   	ret    

8010318f <lapicid>:

int
lapicid(void)
{
8010318f:	f3 0f 1e fb          	endbr32 
80103193:	55                   	push   %ebp
80103194:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80103196:	a1 1c 47 11 80       	mov    0x8011471c,%eax
8010319b:	85 c0                	test   %eax,%eax
8010319d:	75 07                	jne    801031a6 <lapicid+0x17>
    return 0;
8010319f:	b8 00 00 00 00       	mov    $0x0,%eax
801031a4:	eb 0d                	jmp    801031b3 <lapicid+0x24>
  return lapic[ID] >> 24;
801031a6:	a1 1c 47 11 80       	mov    0x8011471c,%eax
801031ab:	83 c0 20             	add    $0x20,%eax
801031ae:	8b 00                	mov    (%eax),%eax
801031b0:	c1 e8 18             	shr    $0x18,%eax
}
801031b3:	5d                   	pop    %ebp
801031b4:	c3                   	ret    

801031b5 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801031b5:	f3 0f 1e fb          	endbr32 
801031b9:	55                   	push   %ebp
801031ba:	89 e5                	mov    %esp,%ebp
  if(lapic)
801031bc:	a1 1c 47 11 80       	mov    0x8011471c,%eax
801031c1:	85 c0                	test   %eax,%eax
801031c3:	74 0c                	je     801031d1 <lapiceoi+0x1c>
    lapicw(EOI, 0);
801031c5:	6a 00                	push   $0x0
801031c7:	6a 2c                	push   $0x2c
801031c9:	e8 78 fe ff ff       	call   80103046 <lapicw>
801031ce:	83 c4 08             	add    $0x8,%esp
}
801031d1:	90                   	nop
801031d2:	c9                   	leave  
801031d3:	c3                   	ret    

801031d4 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801031d4:	f3 0f 1e fb          	endbr32 
801031d8:	55                   	push   %ebp
801031d9:	89 e5                	mov    %esp,%ebp
}
801031db:	90                   	nop
801031dc:	5d                   	pop    %ebp
801031dd:	c3                   	ret    

801031de <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801031de:	f3 0f 1e fb          	endbr32 
801031e2:	55                   	push   %ebp
801031e3:	89 e5                	mov    %esp,%ebp
801031e5:	83 ec 14             	sub    $0x14,%esp
801031e8:	8b 45 08             	mov    0x8(%ebp),%eax
801031eb:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801031ee:	6a 0f                	push   $0xf
801031f0:	6a 70                	push   $0x70
801031f2:	e8 2e fe ff ff       	call   80103025 <outb>
801031f7:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801031fa:	6a 0a                	push   $0xa
801031fc:	6a 71                	push   $0x71
801031fe:	e8 22 fe ff ff       	call   80103025 <outb>
80103203:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103206:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010320d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103210:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103215:	8b 45 0c             	mov    0xc(%ebp),%eax
80103218:	c1 e8 04             	shr    $0x4,%eax
8010321b:	89 c2                	mov    %eax,%edx
8010321d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103220:	83 c0 02             	add    $0x2,%eax
80103223:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103226:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010322a:	c1 e0 18             	shl    $0x18,%eax
8010322d:	50                   	push   %eax
8010322e:	68 c4 00 00 00       	push   $0xc4
80103233:	e8 0e fe ff ff       	call   80103046 <lapicw>
80103238:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010323b:	68 00 c5 00 00       	push   $0xc500
80103240:	68 c0 00 00 00       	push   $0xc0
80103245:	e8 fc fd ff ff       	call   80103046 <lapicw>
8010324a:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010324d:	68 c8 00 00 00       	push   $0xc8
80103252:	e8 7d ff ff ff       	call   801031d4 <microdelay>
80103257:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010325a:	68 00 85 00 00       	push   $0x8500
8010325f:	68 c0 00 00 00       	push   $0xc0
80103264:	e8 dd fd ff ff       	call   80103046 <lapicw>
80103269:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010326c:	6a 64                	push   $0x64
8010326e:	e8 61 ff ff ff       	call   801031d4 <microdelay>
80103273:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103276:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010327d:	eb 3d                	jmp    801032bc <lapicstartap+0xde>
    lapicw(ICRHI, apicid<<24);
8010327f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103283:	c1 e0 18             	shl    $0x18,%eax
80103286:	50                   	push   %eax
80103287:	68 c4 00 00 00       	push   $0xc4
8010328c:	e8 b5 fd ff ff       	call   80103046 <lapicw>
80103291:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103294:	8b 45 0c             	mov    0xc(%ebp),%eax
80103297:	c1 e8 0c             	shr    $0xc,%eax
8010329a:	80 cc 06             	or     $0x6,%ah
8010329d:	50                   	push   %eax
8010329e:	68 c0 00 00 00       	push   $0xc0
801032a3:	e8 9e fd ff ff       	call   80103046 <lapicw>
801032a8:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801032ab:	68 c8 00 00 00       	push   $0xc8
801032b0:	e8 1f ff ff ff       	call   801031d4 <microdelay>
801032b5:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
801032b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801032bc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801032c0:	7e bd                	jle    8010327f <lapicstartap+0xa1>
  }
}
801032c2:	90                   	nop
801032c3:	90                   	nop
801032c4:	c9                   	leave  
801032c5:	c3                   	ret    

801032c6 <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
801032c6:	f3 0f 1e fb          	endbr32 
801032ca:	55                   	push   %ebp
801032cb:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801032cd:	8b 45 08             	mov    0x8(%ebp),%eax
801032d0:	0f b6 c0             	movzbl %al,%eax
801032d3:	50                   	push   %eax
801032d4:	6a 70                	push   $0x70
801032d6:	e8 4a fd ff ff       	call   80103025 <outb>
801032db:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801032de:	68 c8 00 00 00       	push   $0xc8
801032e3:	e8 ec fe ff ff       	call   801031d4 <microdelay>
801032e8:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801032eb:	6a 71                	push   $0x71
801032ed:	e8 16 fd ff ff       	call   80103008 <inb>
801032f2:	83 c4 04             	add    $0x4,%esp
801032f5:	0f b6 c0             	movzbl %al,%eax
}
801032f8:	c9                   	leave  
801032f9:	c3                   	ret    

801032fa <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801032fa:	f3 0f 1e fb          	endbr32 
801032fe:	55                   	push   %ebp
801032ff:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103301:	6a 00                	push   $0x0
80103303:	e8 be ff ff ff       	call   801032c6 <cmos_read>
80103308:	83 c4 04             	add    $0x4,%esp
8010330b:	8b 55 08             	mov    0x8(%ebp),%edx
8010330e:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103310:	6a 02                	push   $0x2
80103312:	e8 af ff ff ff       	call   801032c6 <cmos_read>
80103317:	83 c4 04             	add    $0x4,%esp
8010331a:	8b 55 08             	mov    0x8(%ebp),%edx
8010331d:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103320:	6a 04                	push   $0x4
80103322:	e8 9f ff ff ff       	call   801032c6 <cmos_read>
80103327:	83 c4 04             	add    $0x4,%esp
8010332a:	8b 55 08             	mov    0x8(%ebp),%edx
8010332d:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103330:	6a 07                	push   $0x7
80103332:	e8 8f ff ff ff       	call   801032c6 <cmos_read>
80103337:	83 c4 04             	add    $0x4,%esp
8010333a:	8b 55 08             	mov    0x8(%ebp),%edx
8010333d:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103340:	6a 08                	push   $0x8
80103342:	e8 7f ff ff ff       	call   801032c6 <cmos_read>
80103347:	83 c4 04             	add    $0x4,%esp
8010334a:	8b 55 08             	mov    0x8(%ebp),%edx
8010334d:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80103350:	6a 09                	push   $0x9
80103352:	e8 6f ff ff ff       	call   801032c6 <cmos_read>
80103357:	83 c4 04             	add    $0x4,%esp
8010335a:	8b 55 08             	mov    0x8(%ebp),%edx
8010335d:	89 42 14             	mov    %eax,0x14(%edx)
}
80103360:	90                   	nop
80103361:	c9                   	leave  
80103362:	c3                   	ret    

80103363 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103363:	f3 0f 1e fb          	endbr32 
80103367:	55                   	push   %ebp
80103368:	89 e5                	mov    %esp,%ebp
8010336a:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010336d:	6a 0b                	push   $0xb
8010336f:	e8 52 ff ff ff       	call   801032c6 <cmos_read>
80103374:	83 c4 04             	add    $0x4,%esp
80103377:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010337d:	83 e0 04             	and    $0x4,%eax
80103380:	85 c0                	test   %eax,%eax
80103382:	0f 94 c0             	sete   %al
80103385:	0f b6 c0             	movzbl %al,%eax
80103388:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010338b:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010338e:	50                   	push   %eax
8010338f:	e8 66 ff ff ff       	call   801032fa <fill_rtcdate>
80103394:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103397:	6a 0a                	push   $0xa
80103399:	e8 28 ff ff ff       	call   801032c6 <cmos_read>
8010339e:	83 c4 04             	add    $0x4,%esp
801033a1:	25 80 00 00 00       	and    $0x80,%eax
801033a6:	85 c0                	test   %eax,%eax
801033a8:	75 27                	jne    801033d1 <cmostime+0x6e>
        continue;
    fill_rtcdate(&t2);
801033aa:	8d 45 c0             	lea    -0x40(%ebp),%eax
801033ad:	50                   	push   %eax
801033ae:	e8 47 ff ff ff       	call   801032fa <fill_rtcdate>
801033b3:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801033b6:	83 ec 04             	sub    $0x4,%esp
801033b9:	6a 18                	push   $0x18
801033bb:	8d 45 c0             	lea    -0x40(%ebp),%eax
801033be:	50                   	push   %eax
801033bf:	8d 45 d8             	lea    -0x28(%ebp),%eax
801033c2:	50                   	push   %eax
801033c3:	e8 d4 21 00 00       	call   8010559c <memcmp>
801033c8:	83 c4 10             	add    $0x10,%esp
801033cb:	85 c0                	test   %eax,%eax
801033cd:	74 05                	je     801033d4 <cmostime+0x71>
801033cf:	eb ba                	jmp    8010338b <cmostime+0x28>
        continue;
801033d1:	90                   	nop
    fill_rtcdate(&t1);
801033d2:	eb b7                	jmp    8010338b <cmostime+0x28>
      break;
801033d4:	90                   	nop
  }

  // convert
  if(bcd) {
801033d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801033d9:	0f 84 b4 00 00 00    	je     80103493 <cmostime+0x130>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801033df:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033e2:	c1 e8 04             	shr    $0x4,%eax
801033e5:	89 c2                	mov    %eax,%edx
801033e7:	89 d0                	mov    %edx,%eax
801033e9:	c1 e0 02             	shl    $0x2,%eax
801033ec:	01 d0                	add    %edx,%eax
801033ee:	01 c0                	add    %eax,%eax
801033f0:	89 c2                	mov    %eax,%edx
801033f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033f5:	83 e0 0f             	and    $0xf,%eax
801033f8:	01 d0                	add    %edx,%eax
801033fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801033fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103400:	c1 e8 04             	shr    $0x4,%eax
80103403:	89 c2                	mov    %eax,%edx
80103405:	89 d0                	mov    %edx,%eax
80103407:	c1 e0 02             	shl    $0x2,%eax
8010340a:	01 d0                	add    %edx,%eax
8010340c:	01 c0                	add    %eax,%eax
8010340e:	89 c2                	mov    %eax,%edx
80103410:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103413:	83 e0 0f             	and    $0xf,%eax
80103416:	01 d0                	add    %edx,%eax
80103418:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010341b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010341e:	c1 e8 04             	shr    $0x4,%eax
80103421:	89 c2                	mov    %eax,%edx
80103423:	89 d0                	mov    %edx,%eax
80103425:	c1 e0 02             	shl    $0x2,%eax
80103428:	01 d0                	add    %edx,%eax
8010342a:	01 c0                	add    %eax,%eax
8010342c:	89 c2                	mov    %eax,%edx
8010342e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103431:	83 e0 0f             	and    $0xf,%eax
80103434:	01 d0                	add    %edx,%eax
80103436:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010343c:	c1 e8 04             	shr    $0x4,%eax
8010343f:	89 c2                	mov    %eax,%edx
80103441:	89 d0                	mov    %edx,%eax
80103443:	c1 e0 02             	shl    $0x2,%eax
80103446:	01 d0                	add    %edx,%eax
80103448:	01 c0                	add    %eax,%eax
8010344a:	89 c2                	mov    %eax,%edx
8010344c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010344f:	83 e0 0f             	and    $0xf,%eax
80103452:	01 d0                	add    %edx,%eax
80103454:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103457:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010345a:	c1 e8 04             	shr    $0x4,%eax
8010345d:	89 c2                	mov    %eax,%edx
8010345f:	89 d0                	mov    %edx,%eax
80103461:	c1 e0 02             	shl    $0x2,%eax
80103464:	01 d0                	add    %edx,%eax
80103466:	01 c0                	add    %eax,%eax
80103468:	89 c2                	mov    %eax,%edx
8010346a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010346d:	83 e0 0f             	and    $0xf,%eax
80103470:	01 d0                	add    %edx,%eax
80103472:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103475:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103478:	c1 e8 04             	shr    $0x4,%eax
8010347b:	89 c2                	mov    %eax,%edx
8010347d:	89 d0                	mov    %edx,%eax
8010347f:	c1 e0 02             	shl    $0x2,%eax
80103482:	01 d0                	add    %edx,%eax
80103484:	01 c0                	add    %eax,%eax
80103486:	89 c2                	mov    %eax,%edx
80103488:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010348b:	83 e0 0f             	and    $0xf,%eax
8010348e:	01 d0                	add    %edx,%eax
80103490:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103493:	8b 45 08             	mov    0x8(%ebp),%eax
80103496:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103499:	89 10                	mov    %edx,(%eax)
8010349b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010349e:	89 50 04             	mov    %edx,0x4(%eax)
801034a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801034a4:	89 50 08             	mov    %edx,0x8(%eax)
801034a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034aa:	89 50 0c             	mov    %edx,0xc(%eax)
801034ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
801034b0:	89 50 10             	mov    %edx,0x10(%eax)
801034b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801034b6:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801034b9:	8b 45 08             	mov    0x8(%ebp),%eax
801034bc:	8b 40 14             	mov    0x14(%eax),%eax
801034bf:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801034c5:	8b 45 08             	mov    0x8(%ebp),%eax
801034c8:	89 50 14             	mov    %edx,0x14(%eax)
}
801034cb:	90                   	nop
801034cc:	c9                   	leave  
801034cd:	c3                   	ret    

801034ce <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801034ce:	f3 0f 1e fb          	endbr32 
801034d2:	55                   	push   %ebp
801034d3:	89 e5                	mov    %esp,%ebp
801034d5:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801034d8:	83 ec 08             	sub    $0x8,%esp
801034db:	68 ec 93 10 80       	push   $0x801093ec
801034e0:	68 20 47 11 80       	push   $0x80114720
801034e5:	e8 82 1d 00 00       	call   8010526c <initlock>
801034ea:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801034ed:	83 ec 08             	sub    $0x8,%esp
801034f0:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034f3:	50                   	push   %eax
801034f4:	ff 75 08             	pushl  0x8(%ebp)
801034f7:	e8 d3 df ff ff       	call   801014cf <readsb>
801034fc:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801034ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103502:	a3 54 47 11 80       	mov    %eax,0x80114754
  log.size = sb.nlog;
80103507:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010350a:	a3 58 47 11 80       	mov    %eax,0x80114758
  log.dev = dev;
8010350f:	8b 45 08             	mov    0x8(%ebp),%eax
80103512:	a3 64 47 11 80       	mov    %eax,0x80114764
  recover_from_log();
80103517:	e8 bf 01 00 00       	call   801036db <recover_from_log>
}
8010351c:	90                   	nop
8010351d:	c9                   	leave  
8010351e:	c3                   	ret    

8010351f <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010351f:	f3 0f 1e fb          	endbr32 
80103523:	55                   	push   %ebp
80103524:	89 e5                	mov    %esp,%ebp
80103526:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103529:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103530:	e9 95 00 00 00       	jmp    801035ca <install_trans+0xab>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103535:	8b 15 54 47 11 80    	mov    0x80114754,%edx
8010353b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010353e:	01 d0                	add    %edx,%eax
80103540:	83 c0 01             	add    $0x1,%eax
80103543:	89 c2                	mov    %eax,%edx
80103545:	a1 64 47 11 80       	mov    0x80114764,%eax
8010354a:	83 ec 08             	sub    $0x8,%esp
8010354d:	52                   	push   %edx
8010354e:	50                   	push   %eax
8010354f:	e8 83 cc ff ff       	call   801001d7 <bread>
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010355d:	83 c0 10             	add    $0x10,%eax
80103560:	8b 04 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%eax
80103567:	89 c2                	mov    %eax,%edx
80103569:	a1 64 47 11 80       	mov    0x80114764,%eax
8010356e:	83 ec 08             	sub    $0x8,%esp
80103571:	52                   	push   %edx
80103572:	50                   	push   %eax
80103573:	e8 5f cc ff ff       	call   801001d7 <bread>
80103578:	83 c4 10             	add    $0x10,%esp
8010357b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010357e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103581:	8d 50 5c             	lea    0x5c(%eax),%edx
80103584:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103587:	83 c0 5c             	add    $0x5c,%eax
8010358a:	83 ec 04             	sub    $0x4,%esp
8010358d:	68 00 02 00 00       	push   $0x200
80103592:	52                   	push   %edx
80103593:	50                   	push   %eax
80103594:	e8 5f 20 00 00       	call   801055f8 <memmove>
80103599:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010359c:	83 ec 0c             	sub    $0xc,%esp
8010359f:	ff 75 ec             	pushl  -0x14(%ebp)
801035a2:	e8 6d cc ff ff       	call   80100214 <bwrite>
801035a7:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
801035aa:	83 ec 0c             	sub    $0xc,%esp
801035ad:	ff 75 f0             	pushl  -0x10(%ebp)
801035b0:	e8 ac cc ff ff       	call   80100261 <brelse>
801035b5:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801035b8:	83 ec 0c             	sub    $0xc,%esp
801035bb:	ff 75 ec             	pushl  -0x14(%ebp)
801035be:	e8 9e cc ff ff       	call   80100261 <brelse>
801035c3:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801035c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035ca:	a1 68 47 11 80       	mov    0x80114768,%eax
801035cf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801035d2:	0f 8c 5d ff ff ff    	jl     80103535 <install_trans+0x16>
  }
}
801035d8:	90                   	nop
801035d9:	90                   	nop
801035da:	c9                   	leave  
801035db:	c3                   	ret    

801035dc <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801035dc:	f3 0f 1e fb          	endbr32 
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801035e6:	a1 54 47 11 80       	mov    0x80114754,%eax
801035eb:	89 c2                	mov    %eax,%edx
801035ed:	a1 64 47 11 80       	mov    0x80114764,%eax
801035f2:	83 ec 08             	sub    $0x8,%esp
801035f5:	52                   	push   %edx
801035f6:	50                   	push   %eax
801035f7:	e8 db cb ff ff       	call   801001d7 <bread>
801035fc:	83 c4 10             	add    $0x10,%esp
801035ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103602:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103605:	83 c0 5c             	add    $0x5c,%eax
80103608:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010360b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010360e:	8b 00                	mov    (%eax),%eax
80103610:	a3 68 47 11 80       	mov    %eax,0x80114768
  for (i = 0; i < log.lh.n; i++) {
80103615:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010361c:	eb 1b                	jmp    80103639 <read_head+0x5d>
    log.lh.block[i] = lh->block[i];
8010361e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103621:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103624:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103628:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010362b:	83 c2 10             	add    $0x10,%edx
8010362e:	89 04 95 2c 47 11 80 	mov    %eax,-0x7feeb8d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103635:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103639:	a1 68 47 11 80       	mov    0x80114768,%eax
8010363e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103641:	7c db                	jl     8010361e <read_head+0x42>
  }
  brelse(buf);
80103643:	83 ec 0c             	sub    $0xc,%esp
80103646:	ff 75 f0             	pushl  -0x10(%ebp)
80103649:	e8 13 cc ff ff       	call   80100261 <brelse>
8010364e:	83 c4 10             	add    $0x10,%esp
}
80103651:	90                   	nop
80103652:	c9                   	leave  
80103653:	c3                   	ret    

80103654 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103654:	f3 0f 1e fb          	endbr32 
80103658:	55                   	push   %ebp
80103659:	89 e5                	mov    %esp,%ebp
8010365b:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010365e:	a1 54 47 11 80       	mov    0x80114754,%eax
80103663:	89 c2                	mov    %eax,%edx
80103665:	a1 64 47 11 80       	mov    0x80114764,%eax
8010366a:	83 ec 08             	sub    $0x8,%esp
8010366d:	52                   	push   %edx
8010366e:	50                   	push   %eax
8010366f:	e8 63 cb ff ff       	call   801001d7 <bread>
80103674:	83 c4 10             	add    $0x10,%esp
80103677:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010367a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010367d:	83 c0 5c             	add    $0x5c,%eax
80103680:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103683:	8b 15 68 47 11 80    	mov    0x80114768,%edx
80103689:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010368c:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010368e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103695:	eb 1b                	jmp    801036b2 <write_head+0x5e>
    hb->block[i] = log.lh.block[i];
80103697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010369a:	83 c0 10             	add    $0x10,%eax
8010369d:	8b 0c 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%ecx
801036a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036aa:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801036ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036b2:	a1 68 47 11 80       	mov    0x80114768,%eax
801036b7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801036ba:	7c db                	jl     80103697 <write_head+0x43>
  }
  bwrite(buf);
801036bc:	83 ec 0c             	sub    $0xc,%esp
801036bf:	ff 75 f0             	pushl  -0x10(%ebp)
801036c2:	e8 4d cb ff ff       	call   80100214 <bwrite>
801036c7:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801036ca:	83 ec 0c             	sub    $0xc,%esp
801036cd:	ff 75 f0             	pushl  -0x10(%ebp)
801036d0:	e8 8c cb ff ff       	call   80100261 <brelse>
801036d5:	83 c4 10             	add    $0x10,%esp
}
801036d8:	90                   	nop
801036d9:	c9                   	leave  
801036da:	c3                   	ret    

801036db <recover_from_log>:

static void
recover_from_log(void)
{
801036db:	f3 0f 1e fb          	endbr32 
801036df:	55                   	push   %ebp
801036e0:	89 e5                	mov    %esp,%ebp
801036e2:	83 ec 08             	sub    $0x8,%esp
  read_head();
801036e5:	e8 f2 fe ff ff       	call   801035dc <read_head>
  install_trans(); // if committed, copy from log to disk
801036ea:	e8 30 fe ff ff       	call   8010351f <install_trans>
  log.lh.n = 0;
801036ef:	c7 05 68 47 11 80 00 	movl   $0x0,0x80114768
801036f6:	00 00 00 
  write_head(); // clear the log
801036f9:	e8 56 ff ff ff       	call   80103654 <write_head>
}
801036fe:	90                   	nop
801036ff:	c9                   	leave  
80103700:	c3                   	ret    

80103701 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103701:	f3 0f 1e fb          	endbr32 
80103705:	55                   	push   %ebp
80103706:	89 e5                	mov    %esp,%ebp
80103708:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010370b:	83 ec 0c             	sub    $0xc,%esp
8010370e:	68 20 47 11 80       	push   $0x80114720
80103713:	e8 7a 1b 00 00       	call   80105292 <acquire>
80103718:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010371b:	a1 60 47 11 80       	mov    0x80114760,%eax
80103720:	85 c0                	test   %eax,%eax
80103722:	74 17                	je     8010373b <begin_op+0x3a>
      sleep(&log, &log.lock);
80103724:	83 ec 08             	sub    $0x8,%esp
80103727:	68 20 47 11 80       	push   $0x80114720
8010372c:	68 20 47 11 80       	push   $0x80114720
80103731:	e8 ea 16 00 00       	call   80104e20 <sleep>
80103736:	83 c4 10             	add    $0x10,%esp
80103739:	eb e0                	jmp    8010371b <begin_op+0x1a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010373b:	8b 0d 68 47 11 80    	mov    0x80114768,%ecx
80103741:	a1 5c 47 11 80       	mov    0x8011475c,%eax
80103746:	8d 50 01             	lea    0x1(%eax),%edx
80103749:	89 d0                	mov    %edx,%eax
8010374b:	c1 e0 02             	shl    $0x2,%eax
8010374e:	01 d0                	add    %edx,%eax
80103750:	01 c0                	add    %eax,%eax
80103752:	01 c8                	add    %ecx,%eax
80103754:	83 f8 1e             	cmp    $0x1e,%eax
80103757:	7e 17                	jle    80103770 <begin_op+0x6f>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103759:	83 ec 08             	sub    $0x8,%esp
8010375c:	68 20 47 11 80       	push   $0x80114720
80103761:	68 20 47 11 80       	push   $0x80114720
80103766:	e8 b5 16 00 00       	call   80104e20 <sleep>
8010376b:	83 c4 10             	add    $0x10,%esp
8010376e:	eb ab                	jmp    8010371b <begin_op+0x1a>
    } else {
      log.outstanding += 1;
80103770:	a1 5c 47 11 80       	mov    0x8011475c,%eax
80103775:	83 c0 01             	add    $0x1,%eax
80103778:	a3 5c 47 11 80       	mov    %eax,0x8011475c
      release(&log.lock);
8010377d:	83 ec 0c             	sub    $0xc,%esp
80103780:	68 20 47 11 80       	push   $0x80114720
80103785:	e8 7a 1b 00 00       	call   80105304 <release>
8010378a:	83 c4 10             	add    $0x10,%esp
      break;
8010378d:	90                   	nop
    }
  }
}
8010378e:	90                   	nop
8010378f:	c9                   	leave  
80103790:	c3                   	ret    

80103791 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103791:	f3 0f 1e fb          	endbr32 
80103795:	55                   	push   %ebp
80103796:	89 e5                	mov    %esp,%ebp
80103798:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
8010379b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801037a2:	83 ec 0c             	sub    $0xc,%esp
801037a5:	68 20 47 11 80       	push   $0x80114720
801037aa:	e8 e3 1a 00 00       	call   80105292 <acquire>
801037af:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801037b2:	a1 5c 47 11 80       	mov    0x8011475c,%eax
801037b7:	83 e8 01             	sub    $0x1,%eax
801037ba:	a3 5c 47 11 80       	mov    %eax,0x8011475c
  if(log.committing)
801037bf:	a1 60 47 11 80       	mov    0x80114760,%eax
801037c4:	85 c0                	test   %eax,%eax
801037c6:	74 0d                	je     801037d5 <end_op+0x44>
    panic("log.committing");
801037c8:	83 ec 0c             	sub    $0xc,%esp
801037cb:	68 f0 93 10 80       	push   $0x801093f0
801037d0:	e8 33 ce ff ff       	call   80100608 <panic>
  if(log.outstanding == 0){
801037d5:	a1 5c 47 11 80       	mov    0x8011475c,%eax
801037da:	85 c0                	test   %eax,%eax
801037dc:	75 13                	jne    801037f1 <end_op+0x60>
    do_commit = 1;
801037de:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801037e5:	c7 05 60 47 11 80 01 	movl   $0x1,0x80114760
801037ec:	00 00 00 
801037ef:	eb 10                	jmp    80103801 <end_op+0x70>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801037f1:	83 ec 0c             	sub    $0xc,%esp
801037f4:	68 20 47 11 80       	push   $0x80114720
801037f9:	e8 14 17 00 00       	call   80104f12 <wakeup>
801037fe:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103801:	83 ec 0c             	sub    $0xc,%esp
80103804:	68 20 47 11 80       	push   $0x80114720
80103809:	e8 f6 1a 00 00       	call   80105304 <release>
8010380e:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103815:	74 3f                	je     80103856 <end_op+0xc5>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103817:	e8 fa 00 00 00       	call   80103916 <commit>
    acquire(&log.lock);
8010381c:	83 ec 0c             	sub    $0xc,%esp
8010381f:	68 20 47 11 80       	push   $0x80114720
80103824:	e8 69 1a 00 00       	call   80105292 <acquire>
80103829:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010382c:	c7 05 60 47 11 80 00 	movl   $0x0,0x80114760
80103833:	00 00 00 
    wakeup(&log);
80103836:	83 ec 0c             	sub    $0xc,%esp
80103839:	68 20 47 11 80       	push   $0x80114720
8010383e:	e8 cf 16 00 00       	call   80104f12 <wakeup>
80103843:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103846:	83 ec 0c             	sub    $0xc,%esp
80103849:	68 20 47 11 80       	push   $0x80114720
8010384e:	e8 b1 1a 00 00       	call   80105304 <release>
80103853:	83 c4 10             	add    $0x10,%esp
  }
}
80103856:	90                   	nop
80103857:	c9                   	leave  
80103858:	c3                   	ret    

80103859 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103859:	f3 0f 1e fb          	endbr32 
8010385d:	55                   	push   %ebp
8010385e:	89 e5                	mov    %esp,%ebp
80103860:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103863:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010386a:	e9 95 00 00 00       	jmp    80103904 <write_log+0xab>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010386f:	8b 15 54 47 11 80    	mov    0x80114754,%edx
80103875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103878:	01 d0                	add    %edx,%eax
8010387a:	83 c0 01             	add    $0x1,%eax
8010387d:	89 c2                	mov    %eax,%edx
8010387f:	a1 64 47 11 80       	mov    0x80114764,%eax
80103884:	83 ec 08             	sub    $0x8,%esp
80103887:	52                   	push   %edx
80103888:	50                   	push   %eax
80103889:	e8 49 c9 ff ff       	call   801001d7 <bread>
8010388e:	83 c4 10             	add    $0x10,%esp
80103891:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103897:	83 c0 10             	add    $0x10,%eax
8010389a:	8b 04 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%eax
801038a1:	89 c2                	mov    %eax,%edx
801038a3:	a1 64 47 11 80       	mov    0x80114764,%eax
801038a8:	83 ec 08             	sub    $0x8,%esp
801038ab:	52                   	push   %edx
801038ac:	50                   	push   %eax
801038ad:	e8 25 c9 ff ff       	call   801001d7 <bread>
801038b2:	83 c4 10             	add    $0x10,%esp
801038b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801038b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038bb:	8d 50 5c             	lea    0x5c(%eax),%edx
801038be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c1:	83 c0 5c             	add    $0x5c,%eax
801038c4:	83 ec 04             	sub    $0x4,%esp
801038c7:	68 00 02 00 00       	push   $0x200
801038cc:	52                   	push   %edx
801038cd:	50                   	push   %eax
801038ce:	e8 25 1d 00 00       	call   801055f8 <memmove>
801038d3:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801038d6:	83 ec 0c             	sub    $0xc,%esp
801038d9:	ff 75 f0             	pushl  -0x10(%ebp)
801038dc:	e8 33 c9 ff ff       	call   80100214 <bwrite>
801038e1:	83 c4 10             	add    $0x10,%esp
    brelse(from);
801038e4:	83 ec 0c             	sub    $0xc,%esp
801038e7:	ff 75 ec             	pushl  -0x14(%ebp)
801038ea:	e8 72 c9 ff ff       	call   80100261 <brelse>
801038ef:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801038f2:	83 ec 0c             	sub    $0xc,%esp
801038f5:	ff 75 f0             	pushl  -0x10(%ebp)
801038f8:	e8 64 c9 ff ff       	call   80100261 <brelse>
801038fd:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103900:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103904:	a1 68 47 11 80       	mov    0x80114768,%eax
80103909:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010390c:	0f 8c 5d ff ff ff    	jl     8010386f <write_log+0x16>
  }
}
80103912:	90                   	nop
80103913:	90                   	nop
80103914:	c9                   	leave  
80103915:	c3                   	ret    

80103916 <commit>:

static void
commit()
{
80103916:	f3 0f 1e fb          	endbr32 
8010391a:	55                   	push   %ebp
8010391b:	89 e5                	mov    %esp,%ebp
8010391d:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103920:	a1 68 47 11 80       	mov    0x80114768,%eax
80103925:	85 c0                	test   %eax,%eax
80103927:	7e 1e                	jle    80103947 <commit+0x31>
    write_log();     // Write modified blocks from cache to log
80103929:	e8 2b ff ff ff       	call   80103859 <write_log>
    write_head();    // Write header to disk -- the real commit
8010392e:	e8 21 fd ff ff       	call   80103654 <write_head>
    install_trans(); // Now install writes to home locations
80103933:	e8 e7 fb ff ff       	call   8010351f <install_trans>
    log.lh.n = 0;
80103938:	c7 05 68 47 11 80 00 	movl   $0x0,0x80114768
8010393f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103942:	e8 0d fd ff ff       	call   80103654 <write_head>
  }
}
80103947:	90                   	nop
80103948:	c9                   	leave  
80103949:	c3                   	ret    

8010394a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010394a:	f3 0f 1e fb          	endbr32 
8010394e:	55                   	push   %ebp
8010394f:	89 e5                	mov    %esp,%ebp
80103951:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103954:	a1 68 47 11 80       	mov    0x80114768,%eax
80103959:	83 f8 1d             	cmp    $0x1d,%eax
8010395c:	7f 12                	jg     80103970 <log_write+0x26>
8010395e:	a1 68 47 11 80       	mov    0x80114768,%eax
80103963:	8b 15 58 47 11 80    	mov    0x80114758,%edx
80103969:	83 ea 01             	sub    $0x1,%edx
8010396c:	39 d0                	cmp    %edx,%eax
8010396e:	7c 0d                	jl     8010397d <log_write+0x33>
    panic("too big a transaction");
80103970:	83 ec 0c             	sub    $0xc,%esp
80103973:	68 ff 93 10 80       	push   $0x801093ff
80103978:	e8 8b cc ff ff       	call   80100608 <panic>
  if (log.outstanding < 1)
8010397d:	a1 5c 47 11 80       	mov    0x8011475c,%eax
80103982:	85 c0                	test   %eax,%eax
80103984:	7f 0d                	jg     80103993 <log_write+0x49>
    panic("log_write outside of trans");
80103986:	83 ec 0c             	sub    $0xc,%esp
80103989:	68 15 94 10 80       	push   $0x80109415
8010398e:	e8 75 cc ff ff       	call   80100608 <panic>

  acquire(&log.lock);
80103993:	83 ec 0c             	sub    $0xc,%esp
80103996:	68 20 47 11 80       	push   $0x80114720
8010399b:	e8 f2 18 00 00       	call   80105292 <acquire>
801039a0:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801039a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039aa:	eb 1d                	jmp    801039c9 <log_write+0x7f>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801039ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039af:	83 c0 10             	add    $0x10,%eax
801039b2:	8b 04 85 2c 47 11 80 	mov    -0x7feeb8d4(,%eax,4),%eax
801039b9:	89 c2                	mov    %eax,%edx
801039bb:	8b 45 08             	mov    0x8(%ebp),%eax
801039be:	8b 40 08             	mov    0x8(%eax),%eax
801039c1:	39 c2                	cmp    %eax,%edx
801039c3:	74 10                	je     801039d5 <log_write+0x8b>
  for (i = 0; i < log.lh.n; i++) {
801039c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801039c9:	a1 68 47 11 80       	mov    0x80114768,%eax
801039ce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801039d1:	7c d9                	jl     801039ac <log_write+0x62>
801039d3:	eb 01                	jmp    801039d6 <log_write+0x8c>
      break;
801039d5:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801039d6:	8b 45 08             	mov    0x8(%ebp),%eax
801039d9:	8b 40 08             	mov    0x8(%eax),%eax
801039dc:	89 c2                	mov    %eax,%edx
801039de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e1:	83 c0 10             	add    $0x10,%eax
801039e4:	89 14 85 2c 47 11 80 	mov    %edx,-0x7feeb8d4(,%eax,4)
  if (i == log.lh.n)
801039eb:	a1 68 47 11 80       	mov    0x80114768,%eax
801039f0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801039f3:	75 0d                	jne    80103a02 <log_write+0xb8>
    log.lh.n++;
801039f5:	a1 68 47 11 80       	mov    0x80114768,%eax
801039fa:	83 c0 01             	add    $0x1,%eax
801039fd:	a3 68 47 11 80       	mov    %eax,0x80114768
  b->flags |= B_DIRTY; // prevent eviction
80103a02:	8b 45 08             	mov    0x8(%ebp),%eax
80103a05:	8b 00                	mov    (%eax),%eax
80103a07:	83 c8 04             	or     $0x4,%eax
80103a0a:	89 c2                	mov    %eax,%edx
80103a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80103a0f:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103a11:	83 ec 0c             	sub    $0xc,%esp
80103a14:	68 20 47 11 80       	push   $0x80114720
80103a19:	e8 e6 18 00 00       	call   80105304 <release>
80103a1e:	83 c4 10             	add    $0x10,%esp
}
80103a21:	90                   	nop
80103a22:	c9                   	leave  
80103a23:	c3                   	ret    

80103a24 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103a2a:	8b 55 08             	mov    0x8(%ebp),%edx
80103a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a30:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103a33:	f0 87 02             	lock xchg %eax,(%edx)
80103a36:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103a39:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103a3c:	c9                   	leave  
80103a3d:	c3                   	ret    

80103a3e <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103a3e:	f3 0f 1e fb          	endbr32 
80103a42:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103a46:	83 e4 f0             	and    $0xfffffff0,%esp
80103a49:	ff 71 fc             	pushl  -0x4(%ecx)
80103a4c:	55                   	push   %ebp
80103a4d:	89 e5                	mov    %esp,%ebp
80103a4f:	51                   	push   %ecx
80103a50:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103a53:	83 ec 08             	sub    $0x8,%esp
80103a56:	68 00 00 40 80       	push   $0x80400000
80103a5b:	68 48 87 11 80       	push   $0x80118748
80103a60:	e8 52 f2 ff ff       	call   80102cb7 <kinit1>
80103a65:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103a68:	e8 d6 47 00 00       	call   80108243 <kvmalloc>
  mpinit();        // detect other processors
80103a6d:	e8 d9 03 00 00       	call   80103e4b <mpinit>
  lapicinit();     // interrupt controller
80103a72:	e8 f5 f5 ff ff       	call   8010306c <lapicinit>
  seginit();       // segment descriptors
80103a77:	e8 7f 42 00 00       	call   80107cfb <seginit>
  picinit();       // disable pic
80103a7c:	e8 35 05 00 00       	call   80103fb6 <picinit>
  ioapicinit();    // another interrupt controller
80103a81:	e8 44 f1 ff ff       	call   80102bca <ioapicinit>
  consoleinit();   // console hardware
80103a86:	e8 56 d1 ff ff       	call   80100be1 <consoleinit>
  uartinit();      // serial port
80103a8b:	e8 a8 34 00 00       	call   80106f38 <uartinit>
  pinit();         // process table
80103a90:	e8 6e 09 00 00       	call   80104403 <pinit>
  tvinit();        // trap vectors
80103a95:	e8 33 30 00 00       	call   80106acd <tvinit>
  binit();         // buffer cache
80103a9a:	e8 95 c5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103a9f:	e8 00 d6 ff ff       	call   801010a4 <fileinit>
  ideinit();       // disk 
80103aa4:	e8 e0 ec ff ff       	call   80102789 <ideinit>
  startothers();   // start other processors
80103aa9:	e8 88 00 00 00       	call   80103b36 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103aae:	83 ec 08             	sub    $0x8,%esp
80103ab1:	68 00 00 00 8e       	push   $0x8e000000
80103ab6:	68 00 00 40 80       	push   $0x80400000
80103abb:	e8 34 f2 ff ff       	call   80102cf4 <kinit2>
80103ac0:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103ac3:	e8 68 0b 00 00       	call   80104630 <userinit>
  mpmain();        // finish this processor's setup
80103ac8:	e8 1e 00 00 00       	call   80103aeb <mpmain>

80103acd <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103acd:	f3 0f 1e fb          	endbr32 
80103ad1:	55                   	push   %ebp
80103ad2:	89 e5                	mov    %esp,%ebp
80103ad4:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103ad7:	e8 83 47 00 00       	call   8010825f <switchkvm>
  seginit();
80103adc:	e8 1a 42 00 00       	call   80107cfb <seginit>
  lapicinit();
80103ae1:	e8 86 f5 ff ff       	call   8010306c <lapicinit>
  mpmain();
80103ae6:	e8 00 00 00 00       	call   80103aeb <mpmain>

80103aeb <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103aeb:	f3 0f 1e fb          	endbr32 
80103aef:	55                   	push   %ebp
80103af0:	89 e5                	mov    %esp,%ebp
80103af2:	53                   	push   %ebx
80103af3:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103af6:	e8 2a 09 00 00       	call   80104425 <cpuid>
80103afb:	89 c3                	mov    %eax,%ebx
80103afd:	e8 23 09 00 00       	call   80104425 <cpuid>
80103b02:	83 ec 04             	sub    $0x4,%esp
80103b05:	53                   	push   %ebx
80103b06:	50                   	push   %eax
80103b07:	68 30 94 10 80       	push   $0x80109430
80103b0c:	e8 07 c9 ff ff       	call   80100418 <cprintf>
80103b11:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103b14:	e8 2e 31 00 00       	call   80106c47 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103b19:	e8 26 09 00 00       	call   80104444 <mycpu>
80103b1e:	05 a0 00 00 00       	add    $0xa0,%eax
80103b23:	83 ec 08             	sub    $0x8,%esp
80103b26:	6a 01                	push   $0x1
80103b28:	50                   	push   %eax
80103b29:	e8 f6 fe ff ff       	call   80103a24 <xchg>
80103b2e:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103b31:	e8 e6 10 00 00       	call   80104c1c <scheduler>

80103b36 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103b36:	f3 0f 1e fb          	endbr32 
80103b3a:	55                   	push   %ebp
80103b3b:	89 e5                	mov    %esp,%ebp
80103b3d:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103b40:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b47:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103b4c:	83 ec 04             	sub    $0x4,%esp
80103b4f:	50                   	push   %eax
80103b50:	68 0c c5 10 80       	push   $0x8010c50c
80103b55:	ff 75 f0             	pushl  -0x10(%ebp)
80103b58:	e8 9b 1a 00 00       	call   801055f8 <memmove>
80103b5d:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103b60:	c7 45 f4 20 48 11 80 	movl   $0x80114820,-0xc(%ebp)
80103b67:	eb 79                	jmp    80103be2 <startothers+0xac>
    if(c == mycpu())  // We've started already.
80103b69:	e8 d6 08 00 00       	call   80104444 <mycpu>
80103b6e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103b71:	74 67                	je     80103bda <startothers+0xa4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103b73:	e8 84 f2 ff ff       	call   80102dfc <kalloc>
80103b78:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b7e:	83 e8 04             	sub    $0x4,%eax
80103b81:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b84:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103b8a:	89 10                	mov    %edx,(%eax)
    *(void(**)(void))(code-8) = mpenter;
80103b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b8f:	83 e8 08             	sub    $0x8,%eax
80103b92:	c7 00 cd 3a 10 80    	movl   $0x80103acd,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103b98:	b8 00 b0 10 80       	mov    $0x8010b000,%eax
80103b9d:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ba6:	83 e8 0c             	sub    $0xc,%eax
80103ba9:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
80103bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bae:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb7:	0f b6 00             	movzbl (%eax),%eax
80103bba:	0f b6 c0             	movzbl %al,%eax
80103bbd:	83 ec 08             	sub    $0x8,%esp
80103bc0:	52                   	push   %edx
80103bc1:	50                   	push   %eax
80103bc2:	e8 17 f6 ff ff       	call   801031de <lapicstartap>
80103bc7:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103bca:	90                   	nop
80103bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bce:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103bd4:	85 c0                	test   %eax,%eax
80103bd6:	74 f3                	je     80103bcb <startothers+0x95>
80103bd8:	eb 01                	jmp    80103bdb <startothers+0xa5>
      continue;
80103bda:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103bdb:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103be2:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
80103be7:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103bed:	05 20 48 11 80       	add    $0x80114820,%eax
80103bf2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103bf5:	0f 82 6e ff ff ff    	jb     80103b69 <startothers+0x33>
      ;
  }
}
80103bfb:	90                   	nop
80103bfc:	90                   	nop
80103bfd:	c9                   	leave  
80103bfe:	c3                   	ret    

80103bff <inb>:
{
80103bff:	55                   	push   %ebp
80103c00:	89 e5                	mov    %esp,%ebp
80103c02:	83 ec 14             	sub    $0x14,%esp
80103c05:	8b 45 08             	mov    0x8(%ebp),%eax
80103c08:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c0c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103c10:	89 c2                	mov    %eax,%edx
80103c12:	ec                   	in     (%dx),%al
80103c13:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103c16:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103c1a:	c9                   	leave  
80103c1b:	c3                   	ret    

80103c1c <outb>:
{
80103c1c:	55                   	push   %ebp
80103c1d:	89 e5                	mov    %esp,%ebp
80103c1f:	83 ec 08             	sub    $0x8,%esp
80103c22:	8b 45 08             	mov    0x8(%ebp),%eax
80103c25:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c28:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103c2c:	89 d0                	mov    %edx,%eax
80103c2e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c31:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c35:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c39:	ee                   	out    %al,(%dx)
}
80103c3a:	90                   	nop
80103c3b:	c9                   	leave  
80103c3c:	c3                   	ret    

80103c3d <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103c3d:	f3 0f 1e fb          	endbr32 
80103c41:	55                   	push   %ebp
80103c42:	89 e5                	mov    %esp,%ebp
80103c44:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103c47:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103c55:	eb 15                	jmp    80103c6c <sum+0x2f>
    sum += addr[i];
80103c57:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103c5a:	8b 45 08             	mov    0x8(%ebp),%eax
80103c5d:	01 d0                	add    %edx,%eax
80103c5f:	0f b6 00             	movzbl (%eax),%eax
80103c62:	0f b6 c0             	movzbl %al,%eax
80103c65:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c68:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103c6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103c6f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103c72:	7c e3                	jl     80103c57 <sum+0x1a>
  return sum;
80103c74:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103c77:	c9                   	leave  
80103c78:	c3                   	ret    

80103c79 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103c79:	f3 0f 1e fb          	endbr32 
80103c7d:	55                   	push   %ebp
80103c7e:	89 e5                	mov    %esp,%ebp
80103c80:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103c83:	8b 45 08             	mov    0x8(%ebp),%eax
80103c86:	05 00 00 00 80       	add    $0x80000000,%eax
80103c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c94:	01 d0                	add    %edx,%eax
80103c96:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c9f:	eb 36                	jmp    80103cd7 <mpsearch1+0x5e>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ca1:	83 ec 04             	sub    $0x4,%esp
80103ca4:	6a 04                	push   $0x4
80103ca6:	68 44 94 10 80       	push   $0x80109444
80103cab:	ff 75 f4             	pushl  -0xc(%ebp)
80103cae:	e8 e9 18 00 00       	call   8010559c <memcmp>
80103cb3:	83 c4 10             	add    $0x10,%esp
80103cb6:	85 c0                	test   %eax,%eax
80103cb8:	75 19                	jne    80103cd3 <mpsearch1+0x5a>
80103cba:	83 ec 08             	sub    $0x8,%esp
80103cbd:	6a 10                	push   $0x10
80103cbf:	ff 75 f4             	pushl  -0xc(%ebp)
80103cc2:	e8 76 ff ff ff       	call   80103c3d <sum>
80103cc7:	83 c4 10             	add    $0x10,%esp
80103cca:	84 c0                	test   %al,%al
80103ccc:	75 05                	jne    80103cd3 <mpsearch1+0x5a>
      return (struct mp*)p;
80103cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd1:	eb 11                	jmp    80103ce4 <mpsearch1+0x6b>
  for(p = addr; p < e; p += sizeof(struct mp))
80103cd3:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cda:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cdd:	72 c2                	jb     80103ca1 <mpsearch1+0x28>
  return 0;
80103cdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103ce4:	c9                   	leave  
80103ce5:	c3                   	ret    

80103ce6 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103ce6:	f3 0f 1e fb          	endbr32 
80103cea:	55                   	push   %ebp
80103ceb:	89 e5                	mov    %esp,%ebp
80103ced:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103cf0:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cfa:	83 c0 0f             	add    $0xf,%eax
80103cfd:	0f b6 00             	movzbl (%eax),%eax
80103d00:	0f b6 c0             	movzbl %al,%eax
80103d03:	c1 e0 08             	shl    $0x8,%eax
80103d06:	89 c2                	mov    %eax,%edx
80103d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d0b:	83 c0 0e             	add    $0xe,%eax
80103d0e:	0f b6 00             	movzbl (%eax),%eax
80103d11:	0f b6 c0             	movzbl %al,%eax
80103d14:	09 d0                	or     %edx,%eax
80103d16:	c1 e0 04             	shl    $0x4,%eax
80103d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d20:	74 21                	je     80103d43 <mpsearch+0x5d>
    if((mp = mpsearch1(p, 1024)))
80103d22:	83 ec 08             	sub    $0x8,%esp
80103d25:	68 00 04 00 00       	push   $0x400
80103d2a:	ff 75 f0             	pushl  -0x10(%ebp)
80103d2d:	e8 47 ff ff ff       	call   80103c79 <mpsearch1>
80103d32:	83 c4 10             	add    $0x10,%esp
80103d35:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d38:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d3c:	74 51                	je     80103d8f <mpsearch+0xa9>
      return mp;
80103d3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d41:	eb 61                	jmp    80103da4 <mpsearch+0xbe>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d46:	83 c0 14             	add    $0x14,%eax
80103d49:	0f b6 00             	movzbl (%eax),%eax
80103d4c:	0f b6 c0             	movzbl %al,%eax
80103d4f:	c1 e0 08             	shl    $0x8,%eax
80103d52:	89 c2                	mov    %eax,%edx
80103d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d57:	83 c0 13             	add    $0x13,%eax
80103d5a:	0f b6 00             	movzbl (%eax),%eax
80103d5d:	0f b6 c0             	movzbl %al,%eax
80103d60:	09 d0                	or     %edx,%eax
80103d62:	c1 e0 0a             	shl    $0xa,%eax
80103d65:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d6b:	2d 00 04 00 00       	sub    $0x400,%eax
80103d70:	83 ec 08             	sub    $0x8,%esp
80103d73:	68 00 04 00 00       	push   $0x400
80103d78:	50                   	push   %eax
80103d79:	e8 fb fe ff ff       	call   80103c79 <mpsearch1>
80103d7e:	83 c4 10             	add    $0x10,%esp
80103d81:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d84:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d88:	74 05                	je     80103d8f <mpsearch+0xa9>
      return mp;
80103d8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d8d:	eb 15                	jmp    80103da4 <mpsearch+0xbe>
  }
  return mpsearch1(0xF0000, 0x10000);
80103d8f:	83 ec 08             	sub    $0x8,%esp
80103d92:	68 00 00 01 00       	push   $0x10000
80103d97:	68 00 00 0f 00       	push   $0xf0000
80103d9c:	e8 d8 fe ff ff       	call   80103c79 <mpsearch1>
80103da1:	83 c4 10             	add    $0x10,%esp
}
80103da4:	c9                   	leave  
80103da5:	c3                   	ret    

80103da6 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103da6:	f3 0f 1e fb          	endbr32 
80103daa:	55                   	push   %ebp
80103dab:	89 e5                	mov    %esp,%ebp
80103dad:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103db0:	e8 31 ff ff ff       	call   80103ce6 <mpsearch>
80103db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103db8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103dbc:	74 0a                	je     80103dc8 <mpconfig+0x22>
80103dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dc1:	8b 40 04             	mov    0x4(%eax),%eax
80103dc4:	85 c0                	test   %eax,%eax
80103dc6:	75 07                	jne    80103dcf <mpconfig+0x29>
    return 0;
80103dc8:	b8 00 00 00 00       	mov    $0x0,%eax
80103dcd:	eb 7a                	jmp    80103e49 <mpconfig+0xa3>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd2:	8b 40 04             	mov    0x4(%eax),%eax
80103dd5:	05 00 00 00 80       	add    $0x80000000,%eax
80103dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103ddd:	83 ec 04             	sub    $0x4,%esp
80103de0:	6a 04                	push   $0x4
80103de2:	68 49 94 10 80       	push   $0x80109449
80103de7:	ff 75 f0             	pushl  -0x10(%ebp)
80103dea:	e8 ad 17 00 00       	call   8010559c <memcmp>
80103def:	83 c4 10             	add    $0x10,%esp
80103df2:	85 c0                	test   %eax,%eax
80103df4:	74 07                	je     80103dfd <mpconfig+0x57>
    return 0;
80103df6:	b8 00 00 00 00       	mov    $0x0,%eax
80103dfb:	eb 4c                	jmp    80103e49 <mpconfig+0xa3>
  if(conf->version != 1 && conf->version != 4)
80103dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e00:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e04:	3c 01                	cmp    $0x1,%al
80103e06:	74 12                	je     80103e1a <mpconfig+0x74>
80103e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e0b:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103e0f:	3c 04                	cmp    $0x4,%al
80103e11:	74 07                	je     80103e1a <mpconfig+0x74>
    return 0;
80103e13:	b8 00 00 00 00       	mov    $0x0,%eax
80103e18:	eb 2f                	jmp    80103e49 <mpconfig+0xa3>
  if(sum((uchar*)conf, conf->length) != 0)
80103e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e1d:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e21:	0f b7 c0             	movzwl %ax,%eax
80103e24:	83 ec 08             	sub    $0x8,%esp
80103e27:	50                   	push   %eax
80103e28:	ff 75 f0             	pushl  -0x10(%ebp)
80103e2b:	e8 0d fe ff ff       	call   80103c3d <sum>
80103e30:	83 c4 10             	add    $0x10,%esp
80103e33:	84 c0                	test   %al,%al
80103e35:	74 07                	je     80103e3e <mpconfig+0x98>
    return 0;
80103e37:	b8 00 00 00 00       	mov    $0x0,%eax
80103e3c:	eb 0b                	jmp    80103e49 <mpconfig+0xa3>
  *pmp = mp;
80103e3e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e44:	89 10                	mov    %edx,(%eax)
  return conf;
80103e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103e49:	c9                   	leave  
80103e4a:	c3                   	ret    

80103e4b <mpinit>:

void
mpinit(void)
{
80103e4b:	f3 0f 1e fb          	endbr32 
80103e4f:	55                   	push   %ebp
80103e50:	89 e5                	mov    %esp,%ebp
80103e52:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103e55:	83 ec 0c             	sub    $0xc,%esp
80103e58:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103e5b:	50                   	push   %eax
80103e5c:	e8 45 ff ff ff       	call   80103da6 <mpconfig>
80103e61:	83 c4 10             	add    $0x10,%esp
80103e64:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103e6b:	75 0d                	jne    80103e7a <mpinit+0x2f>
    panic("Expect to run on an SMP");
80103e6d:	83 ec 0c             	sub    $0xc,%esp
80103e70:	68 4e 94 10 80       	push   $0x8010944e
80103e75:	e8 8e c7 ff ff       	call   80100608 <panic>
  ismp = 1;
80103e7a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e84:	8b 40 24             	mov    0x24(%eax),%eax
80103e87:	a3 1c 47 11 80       	mov    %eax,0x8011471c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e8f:	83 c0 2c             	add    $0x2c,%eax
80103e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e98:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e9c:	0f b7 d0             	movzwl %ax,%edx
80103e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ea2:	01 d0                	add    %edx,%eax
80103ea4:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103ea7:	e9 8c 00 00 00       	jmp    80103f38 <mpinit+0xed>
    switch(*p){
80103eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eaf:	0f b6 00             	movzbl (%eax),%eax
80103eb2:	0f b6 c0             	movzbl %al,%eax
80103eb5:	83 f8 04             	cmp    $0x4,%eax
80103eb8:	7f 76                	jg     80103f30 <mpinit+0xe5>
80103eba:	83 f8 03             	cmp    $0x3,%eax
80103ebd:	7d 6b                	jge    80103f2a <mpinit+0xdf>
80103ebf:	83 f8 02             	cmp    $0x2,%eax
80103ec2:	74 4e                	je     80103f12 <mpinit+0xc7>
80103ec4:	83 f8 02             	cmp    $0x2,%eax
80103ec7:	7f 67                	jg     80103f30 <mpinit+0xe5>
80103ec9:	85 c0                	test   %eax,%eax
80103ecb:	74 07                	je     80103ed4 <mpinit+0x89>
80103ecd:	83 f8 01             	cmp    $0x1,%eax
80103ed0:	74 58                	je     80103f2a <mpinit+0xdf>
80103ed2:	eb 5c                	jmp    80103f30 <mpinit+0xe5>
    case MPPROC:
      proc = (struct mpproc*)p;
80103ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
80103eda:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
80103edf:	83 f8 07             	cmp    $0x7,%eax
80103ee2:	7f 28                	jg     80103f0c <mpinit+0xc1>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103ee4:	8b 15 a0 4d 11 80    	mov    0x80114da0,%edx
80103eea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103eed:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ef1:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103ef7:	81 c2 20 48 11 80    	add    $0x80114820,%edx
80103efd:	88 02                	mov    %al,(%edx)
        ncpu++;
80103eff:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
80103f04:	83 c0 01             	add    $0x1,%eax
80103f07:	a3 a0 4d 11 80       	mov    %eax,0x80114da0
      }
      p += sizeof(struct mpproc);
80103f0c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103f10:	eb 26                	jmp    80103f38 <mpinit+0xed>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103f18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f1b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103f1f:	a2 00 48 11 80       	mov    %al,0x80114800
      p += sizeof(struct mpioapic);
80103f24:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f28:	eb 0e                	jmp    80103f38 <mpinit+0xed>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103f2a:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f2e:	eb 08                	jmp    80103f38 <mpinit+0xed>
    default:
      ismp = 0;
80103f30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103f37:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f3b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103f3e:	0f 82 68 ff ff ff    	jb     80103eac <mpinit+0x61>
    }
  }
  if(!ismp)
80103f44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103f48:	75 0d                	jne    80103f57 <mpinit+0x10c>
    panic("Didn't find a suitable machine");
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	68 68 94 10 80       	push   $0x80109468
80103f52:	e8 b1 c6 ff ff       	call   80100608 <panic>

  if(mp->imcrp){
80103f57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f5a:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f5e:	84 c0                	test   %al,%al
80103f60:	74 30                	je     80103f92 <mpinit+0x147>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f62:	83 ec 08             	sub    $0x8,%esp
80103f65:	6a 70                	push   $0x70
80103f67:	6a 22                	push   $0x22
80103f69:	e8 ae fc ff ff       	call   80103c1c <outb>
80103f6e:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f71:	83 ec 0c             	sub    $0xc,%esp
80103f74:	6a 23                	push   $0x23
80103f76:	e8 84 fc ff ff       	call   80103bff <inb>
80103f7b:	83 c4 10             	add    $0x10,%esp
80103f7e:	83 c8 01             	or     $0x1,%eax
80103f81:	0f b6 c0             	movzbl %al,%eax
80103f84:	83 ec 08             	sub    $0x8,%esp
80103f87:	50                   	push   %eax
80103f88:	6a 23                	push   $0x23
80103f8a:	e8 8d fc ff ff       	call   80103c1c <outb>
80103f8f:	83 c4 10             	add    $0x10,%esp
  }
}
80103f92:	90                   	nop
80103f93:	c9                   	leave  
80103f94:	c3                   	ret    

80103f95 <outb>:
{
80103f95:	55                   	push   %ebp
80103f96:	89 e5                	mov    %esp,%ebp
80103f98:	83 ec 08             	sub    $0x8,%esp
80103f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fa1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103fa5:	89 d0                	mov    %edx,%eax
80103fa7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103faa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103fae:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103fb2:	ee                   	out    %al,(%dx)
}
80103fb3:	90                   	nop
80103fb4:	c9                   	leave  
80103fb5:	c3                   	ret    

80103fb6 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103fb6:	f3 0f 1e fb          	endbr32 
80103fba:	55                   	push   %ebp
80103fbb:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103fbd:	68 ff 00 00 00       	push   $0xff
80103fc2:	6a 21                	push   $0x21
80103fc4:	e8 cc ff ff ff       	call   80103f95 <outb>
80103fc9:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103fcc:	68 ff 00 00 00       	push   $0xff
80103fd1:	68 a1 00 00 00       	push   $0xa1
80103fd6:	e8 ba ff ff ff       	call   80103f95 <outb>
80103fdb:	83 c4 08             	add    $0x8,%esp
}
80103fde:	90                   	nop
80103fdf:	c9                   	leave  
80103fe0:	c3                   	ret    

80103fe1 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fe1:	f3 0f 1e fb          	endbr32 
80103fe5:	55                   	push   %ebp
80103fe6:	89 e5                	mov    %esp,%ebp
80103fe8:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103feb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ffe:	8b 10                	mov    (%eax),%edx
80104000:	8b 45 08             	mov    0x8(%ebp),%eax
80104003:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104005:	e8 bc d0 ff ff       	call   801010c6 <filealloc>
8010400a:	8b 55 08             	mov    0x8(%ebp),%edx
8010400d:	89 02                	mov    %eax,(%edx)
8010400f:	8b 45 08             	mov    0x8(%ebp),%eax
80104012:	8b 00                	mov    (%eax),%eax
80104014:	85 c0                	test   %eax,%eax
80104016:	0f 84 c8 00 00 00    	je     801040e4 <pipealloc+0x103>
8010401c:	e8 a5 d0 ff ff       	call   801010c6 <filealloc>
80104021:	8b 55 0c             	mov    0xc(%ebp),%edx
80104024:	89 02                	mov    %eax,(%edx)
80104026:	8b 45 0c             	mov    0xc(%ebp),%eax
80104029:	8b 00                	mov    (%eax),%eax
8010402b:	85 c0                	test   %eax,%eax
8010402d:	0f 84 b1 00 00 00    	je     801040e4 <pipealloc+0x103>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104033:	e8 c4 ed ff ff       	call   80102dfc <kalloc>
80104038:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010403b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010403f:	0f 84 a2 00 00 00    	je     801040e7 <pipealloc+0x106>
    goto bad;
  p->readopen = 1;
80104045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104048:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010404f:	00 00 00 
  p->writeopen = 1;
80104052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104055:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010405c:	00 00 00 
  p->nwrite = 0;
8010405f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104062:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104069:	00 00 00 
  p->nread = 0;
8010406c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406f:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104076:	00 00 00 
  initlock(&p->lock, "pipe");
80104079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010407c:	83 ec 08             	sub    $0x8,%esp
8010407f:	68 87 94 10 80       	push   $0x80109487
80104084:	50                   	push   %eax
80104085:	e8 e2 11 00 00       	call   8010526c <initlock>
8010408a:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010408d:	8b 45 08             	mov    0x8(%ebp),%eax
80104090:	8b 00                	mov    (%eax),%eax
80104092:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104098:	8b 45 08             	mov    0x8(%ebp),%eax
8010409b:	8b 00                	mov    (%eax),%eax
8010409d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801040a1:	8b 45 08             	mov    0x8(%ebp),%eax
801040a4:	8b 00                	mov    (%eax),%eax
801040a6:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801040aa:	8b 45 08             	mov    0x8(%ebp),%eax
801040ad:	8b 00                	mov    (%eax),%eax
801040af:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040b2:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801040b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b8:	8b 00                	mov    (%eax),%eax
801040ba:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c3:	8b 00                	mov    (%eax),%eax
801040c5:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801040cc:	8b 00                	mov    (%eax),%eax
801040ce:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d5:	8b 00                	mov    (%eax),%eax
801040d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040da:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040dd:	b8 00 00 00 00       	mov    $0x0,%eax
801040e2:	eb 51                	jmp    80104135 <pipealloc+0x154>
    goto bad;
801040e4:	90                   	nop
801040e5:	eb 01                	jmp    801040e8 <pipealloc+0x107>
    goto bad;
801040e7:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
801040e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040ec:	74 0e                	je     801040fc <pipealloc+0x11b>
    kfree((char*)p);
801040ee:	83 ec 0c             	sub    $0xc,%esp
801040f1:	ff 75 f4             	pushl  -0xc(%ebp)
801040f4:	e8 65 ec ff ff       	call   80102d5e <kfree>
801040f9:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040fc:	8b 45 08             	mov    0x8(%ebp),%eax
801040ff:	8b 00                	mov    (%eax),%eax
80104101:	85 c0                	test   %eax,%eax
80104103:	74 11                	je     80104116 <pipealloc+0x135>
    fileclose(*f0);
80104105:	8b 45 08             	mov    0x8(%ebp),%eax
80104108:	8b 00                	mov    (%eax),%eax
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	50                   	push   %eax
8010410e:	e8 79 d0 ff ff       	call   8010118c <fileclose>
80104113:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104116:	8b 45 0c             	mov    0xc(%ebp),%eax
80104119:	8b 00                	mov    (%eax),%eax
8010411b:	85 c0                	test   %eax,%eax
8010411d:	74 11                	je     80104130 <pipealloc+0x14f>
    fileclose(*f1);
8010411f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104122:	8b 00                	mov    (%eax),%eax
80104124:	83 ec 0c             	sub    $0xc,%esp
80104127:	50                   	push   %eax
80104128:	e8 5f d0 ff ff       	call   8010118c <fileclose>
8010412d:	83 c4 10             	add    $0x10,%esp
  return -1;
80104130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104135:	c9                   	leave  
80104136:	c3                   	ret    

80104137 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104137:	f3 0f 1e fb          	endbr32 
8010413b:	55                   	push   %ebp
8010413c:	89 e5                	mov    %esp,%ebp
8010413e:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104141:	8b 45 08             	mov    0x8(%ebp),%eax
80104144:	83 ec 0c             	sub    $0xc,%esp
80104147:	50                   	push   %eax
80104148:	e8 45 11 00 00       	call   80105292 <acquire>
8010414d:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104150:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104154:	74 23                	je     80104179 <pipeclose+0x42>
    p->writeopen = 0;
80104156:	8b 45 08             	mov    0x8(%ebp),%eax
80104159:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104160:	00 00 00 
    wakeup(&p->nread);
80104163:	8b 45 08             	mov    0x8(%ebp),%eax
80104166:	05 34 02 00 00       	add    $0x234,%eax
8010416b:	83 ec 0c             	sub    $0xc,%esp
8010416e:	50                   	push   %eax
8010416f:	e8 9e 0d 00 00       	call   80104f12 <wakeup>
80104174:	83 c4 10             	add    $0x10,%esp
80104177:	eb 21                	jmp    8010419a <pipeclose+0x63>
  } else {
    p->readopen = 0;
80104179:	8b 45 08             	mov    0x8(%ebp),%eax
8010417c:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104183:	00 00 00 
    wakeup(&p->nwrite);
80104186:	8b 45 08             	mov    0x8(%ebp),%eax
80104189:	05 38 02 00 00       	add    $0x238,%eax
8010418e:	83 ec 0c             	sub    $0xc,%esp
80104191:	50                   	push   %eax
80104192:	e8 7b 0d 00 00       	call   80104f12 <wakeup>
80104197:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010419a:	8b 45 08             	mov    0x8(%ebp),%eax
8010419d:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041a3:	85 c0                	test   %eax,%eax
801041a5:	75 2c                	jne    801041d3 <pipeclose+0x9c>
801041a7:	8b 45 08             	mov    0x8(%ebp),%eax
801041aa:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801041b0:	85 c0                	test   %eax,%eax
801041b2:	75 1f                	jne    801041d3 <pipeclose+0x9c>
    release(&p->lock);
801041b4:	8b 45 08             	mov    0x8(%ebp),%eax
801041b7:	83 ec 0c             	sub    $0xc,%esp
801041ba:	50                   	push   %eax
801041bb:	e8 44 11 00 00       	call   80105304 <release>
801041c0:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801041c3:	83 ec 0c             	sub    $0xc,%esp
801041c6:	ff 75 08             	pushl  0x8(%ebp)
801041c9:	e8 90 eb ff ff       	call   80102d5e <kfree>
801041ce:	83 c4 10             	add    $0x10,%esp
801041d1:	eb 10                	jmp    801041e3 <pipeclose+0xac>
  } else
    release(&p->lock);
801041d3:	8b 45 08             	mov    0x8(%ebp),%eax
801041d6:	83 ec 0c             	sub    $0xc,%esp
801041d9:	50                   	push   %eax
801041da:	e8 25 11 00 00       	call   80105304 <release>
801041df:	83 c4 10             	add    $0x10,%esp
}
801041e2:	90                   	nop
801041e3:	90                   	nop
801041e4:	c9                   	leave  
801041e5:	c3                   	ret    

801041e6 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041e6:	f3 0f 1e fb          	endbr32 
801041ea:	55                   	push   %ebp
801041eb:	89 e5                	mov    %esp,%ebp
801041ed:	53                   	push   %ebx
801041ee:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801041f1:	8b 45 08             	mov    0x8(%ebp),%eax
801041f4:	83 ec 0c             	sub    $0xc,%esp
801041f7:	50                   	push   %eax
801041f8:	e8 95 10 00 00       	call   80105292 <acquire>
801041fd:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104200:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104207:	e9 ad 00 00 00       	jmp    801042b9 <pipewrite+0xd3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
8010420c:	8b 45 08             	mov    0x8(%ebp),%eax
8010420f:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104215:	85 c0                	test   %eax,%eax
80104217:	74 0c                	je     80104225 <pipewrite+0x3f>
80104219:	e8 a2 02 00 00       	call   801044c0 <myproc>
8010421e:	8b 40 24             	mov    0x24(%eax),%eax
80104221:	85 c0                	test   %eax,%eax
80104223:	74 19                	je     8010423e <pipewrite+0x58>
        release(&p->lock);
80104225:	8b 45 08             	mov    0x8(%ebp),%eax
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	50                   	push   %eax
8010422c:	e8 d3 10 00 00       	call   80105304 <release>
80104231:	83 c4 10             	add    $0x10,%esp
        return -1;
80104234:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104239:	e9 a9 00 00 00       	jmp    801042e7 <pipewrite+0x101>
      }
      wakeup(&p->nread);
8010423e:	8b 45 08             	mov    0x8(%ebp),%eax
80104241:	05 34 02 00 00       	add    $0x234,%eax
80104246:	83 ec 0c             	sub    $0xc,%esp
80104249:	50                   	push   %eax
8010424a:	e8 c3 0c 00 00       	call   80104f12 <wakeup>
8010424f:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104252:	8b 45 08             	mov    0x8(%ebp),%eax
80104255:	8b 55 08             	mov    0x8(%ebp),%edx
80104258:	81 c2 38 02 00 00    	add    $0x238,%edx
8010425e:	83 ec 08             	sub    $0x8,%esp
80104261:	50                   	push   %eax
80104262:	52                   	push   %edx
80104263:	e8 b8 0b 00 00       	call   80104e20 <sleep>
80104268:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010426b:	8b 45 08             	mov    0x8(%ebp),%eax
8010426e:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104274:	8b 45 08             	mov    0x8(%ebp),%eax
80104277:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010427d:	05 00 02 00 00       	add    $0x200,%eax
80104282:	39 c2                	cmp    %eax,%edx
80104284:	74 86                	je     8010420c <pipewrite+0x26>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104286:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104289:	8b 45 0c             	mov    0xc(%ebp),%eax
8010428c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010428f:	8b 45 08             	mov    0x8(%ebp),%eax
80104292:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104298:	8d 48 01             	lea    0x1(%eax),%ecx
8010429b:	8b 55 08             	mov    0x8(%ebp),%edx
8010429e:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801042a4:	25 ff 01 00 00       	and    $0x1ff,%eax
801042a9:	89 c1                	mov    %eax,%ecx
801042ab:	0f b6 13             	movzbl (%ebx),%edx
801042ae:	8b 45 08             	mov    0x8(%ebp),%eax
801042b1:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
801042b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042bc:	3b 45 10             	cmp    0x10(%ebp),%eax
801042bf:	7c aa                	jl     8010426b <pipewrite+0x85>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801042c1:	8b 45 08             	mov    0x8(%ebp),%eax
801042c4:	05 34 02 00 00       	add    $0x234,%eax
801042c9:	83 ec 0c             	sub    $0xc,%esp
801042cc:	50                   	push   %eax
801042cd:	e8 40 0c 00 00       	call   80104f12 <wakeup>
801042d2:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801042d5:	8b 45 08             	mov    0x8(%ebp),%eax
801042d8:	83 ec 0c             	sub    $0xc,%esp
801042db:	50                   	push   %eax
801042dc:	e8 23 10 00 00       	call   80105304 <release>
801042e1:	83 c4 10             	add    $0x10,%esp
  return n;
801042e4:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042ea:	c9                   	leave  
801042eb:	c3                   	ret    

801042ec <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042ec:	f3 0f 1e fb          	endbr32 
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801042f6:	8b 45 08             	mov    0x8(%ebp),%eax
801042f9:	83 ec 0c             	sub    $0xc,%esp
801042fc:	50                   	push   %eax
801042fd:	e8 90 0f 00 00       	call   80105292 <acquire>
80104302:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104305:	eb 3e                	jmp    80104345 <piperead+0x59>
    if(myproc()->killed){
80104307:	e8 b4 01 00 00       	call   801044c0 <myproc>
8010430c:	8b 40 24             	mov    0x24(%eax),%eax
8010430f:	85 c0                	test   %eax,%eax
80104311:	74 19                	je     8010432c <piperead+0x40>
      release(&p->lock);
80104313:	8b 45 08             	mov    0x8(%ebp),%eax
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	50                   	push   %eax
8010431a:	e8 e5 0f 00 00       	call   80105304 <release>
8010431f:	83 c4 10             	add    $0x10,%esp
      return -1;
80104322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104327:	e9 be 00 00 00       	jmp    801043ea <piperead+0xfe>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010432c:	8b 45 08             	mov    0x8(%ebp),%eax
8010432f:	8b 55 08             	mov    0x8(%ebp),%edx
80104332:	81 c2 34 02 00 00    	add    $0x234,%edx
80104338:	83 ec 08             	sub    $0x8,%esp
8010433b:	50                   	push   %eax
8010433c:	52                   	push   %edx
8010433d:	e8 de 0a 00 00       	call   80104e20 <sleep>
80104342:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104345:	8b 45 08             	mov    0x8(%ebp),%eax
80104348:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010434e:	8b 45 08             	mov    0x8(%ebp),%eax
80104351:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104357:	39 c2                	cmp    %eax,%edx
80104359:	75 0d                	jne    80104368 <piperead+0x7c>
8010435b:	8b 45 08             	mov    0x8(%ebp),%eax
8010435e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104364:	85 c0                	test   %eax,%eax
80104366:	75 9f                	jne    80104307 <piperead+0x1b>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104368:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010436f:	eb 48                	jmp    801043b9 <piperead+0xcd>
    if(p->nread == p->nwrite)
80104371:	8b 45 08             	mov    0x8(%ebp),%eax
80104374:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010437a:	8b 45 08             	mov    0x8(%ebp),%eax
8010437d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104383:	39 c2                	cmp    %eax,%edx
80104385:	74 3c                	je     801043c3 <piperead+0xd7>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104387:	8b 45 08             	mov    0x8(%ebp),%eax
8010438a:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104390:	8d 48 01             	lea    0x1(%eax),%ecx
80104393:	8b 55 08             	mov    0x8(%ebp),%edx
80104396:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010439c:	25 ff 01 00 00       	and    $0x1ff,%eax
801043a1:	89 c1                	mov    %eax,%ecx
801043a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801043a9:	01 c2                	add    %eax,%edx
801043ab:	8b 45 08             	mov    0x8(%ebp),%eax
801043ae:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
801043b3:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801043b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043bc:	3b 45 10             	cmp    0x10(%ebp),%eax
801043bf:	7c b0                	jl     80104371 <piperead+0x85>
801043c1:	eb 01                	jmp    801043c4 <piperead+0xd8>
      break;
801043c3:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801043c4:	8b 45 08             	mov    0x8(%ebp),%eax
801043c7:	05 38 02 00 00       	add    $0x238,%eax
801043cc:	83 ec 0c             	sub    $0xc,%esp
801043cf:	50                   	push   %eax
801043d0:	e8 3d 0b 00 00       	call   80104f12 <wakeup>
801043d5:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043d8:	8b 45 08             	mov    0x8(%ebp),%eax
801043db:	83 ec 0c             	sub    $0xc,%esp
801043de:	50                   	push   %eax
801043df:	e8 20 0f 00 00       	call   80105304 <release>
801043e4:	83 c4 10             	add    $0x10,%esp
  return i;
801043e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043ea:	c9                   	leave  
801043eb:	c3                   	ret    

801043ec <readeflags>:
{
801043ec:	55                   	push   %ebp
801043ed:	89 e5                	mov    %esp,%ebp
801043ef:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043f2:	9c                   	pushf  
801043f3:	58                   	pop    %eax
801043f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043fa:	c9                   	leave  
801043fb:	c3                   	ret    

801043fc <sti>:
{
801043fc:	55                   	push   %ebp
801043fd:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043ff:	fb                   	sti    
}
80104400:	90                   	nop
80104401:	5d                   	pop    %ebp
80104402:	c3                   	ret    

80104403 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104403:	f3 0f 1e fb          	endbr32 
80104407:	55                   	push   %ebp
80104408:	89 e5                	mov    %esp,%ebp
8010440a:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010440d:	83 ec 08             	sub    $0x8,%esp
80104410:	68 8c 94 10 80       	push   $0x8010948c
80104415:	68 c0 4d 11 80       	push   $0x80114dc0
8010441a:	e8 4d 0e 00 00       	call   8010526c <initlock>
8010441f:	83 c4 10             	add    $0x10,%esp
}
80104422:	90                   	nop
80104423:	c9                   	leave  
80104424:	c3                   	ret    

80104425 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80104425:	f3 0f 1e fb          	endbr32 
80104429:	55                   	push   %ebp
8010442a:	89 e5                	mov    %esp,%ebp
8010442c:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010442f:	e8 10 00 00 00       	call   80104444 <mycpu>
80104434:	2d 20 48 11 80       	sub    $0x80114820,%eax
80104439:	c1 f8 04             	sar    $0x4,%eax
8010443c:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104442:	c9                   	leave  
80104443:	c3                   	ret    

80104444 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80104444:	f3 0f 1e fb          	endbr32 
80104448:	55                   	push   %ebp
80104449:	89 e5                	mov    %esp,%ebp
8010444b:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010444e:	e8 99 ff ff ff       	call   801043ec <readeflags>
80104453:	25 00 02 00 00       	and    $0x200,%eax
80104458:	85 c0                	test   %eax,%eax
8010445a:	74 0d                	je     80104469 <mycpu+0x25>
    panic("mycpu called with interrupts enabled\n");
8010445c:	83 ec 0c             	sub    $0xc,%esp
8010445f:	68 94 94 10 80       	push   $0x80109494
80104464:	e8 9f c1 ff ff       	call   80100608 <panic>
  
  apicid = lapicid();
80104469:	e8 21 ed ff ff       	call   8010318f <lapicid>
8010446e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80104471:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104478:	eb 2d                	jmp    801044a7 <mycpu+0x63>
    if (cpus[i].apicid == apicid)
8010447a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447d:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104483:	05 20 48 11 80       	add    $0x80114820,%eax
80104488:	0f b6 00             	movzbl (%eax),%eax
8010448b:	0f b6 c0             	movzbl %al,%eax
8010448e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104491:	75 10                	jne    801044a3 <mycpu+0x5f>
      return &cpus[i];
80104493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104496:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010449c:	05 20 48 11 80       	add    $0x80114820,%eax
801044a1:	eb 1b                	jmp    801044be <mycpu+0x7a>
  for (i = 0; i < ncpu; ++i) {
801044a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044a7:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
801044ac:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801044af:	7c c9                	jl     8010447a <mycpu+0x36>
  }
  panic("unknown apicid\n");
801044b1:	83 ec 0c             	sub    $0xc,%esp
801044b4:	68 ba 94 10 80       	push   $0x801094ba
801044b9:	e8 4a c1 ff ff       	call   80100608 <panic>
}
801044be:	c9                   	leave  
801044bf:	c3                   	ret    

801044c0 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801044c0:	f3 0f 1e fb          	endbr32 
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801044ca:	e8 4f 0f 00 00       	call   8010541e <pushcli>
  c = mycpu();
801044cf:	e8 70 ff ff ff       	call   80104444 <mycpu>
801044d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
801044d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044da:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801044e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
801044e3:	e8 87 0f 00 00       	call   8010546f <popcli>
  return p;
801044e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801044eb:	c9                   	leave  
801044ec:	c3                   	ret    

801044ed <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801044ed:	f3 0f 1e fb          	endbr32 
801044f1:	55                   	push   %ebp
801044f2:	89 e5                	mov    %esp,%ebp
801044f4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801044f7:	83 ec 0c             	sub    $0xc,%esp
801044fa:	68 c0 4d 11 80       	push   $0x80114dc0
801044ff:	e8 8e 0d 00 00       	call   80105292 <acquire>
80104504:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104507:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
8010450e:	eb 11                	jmp    80104521 <allocproc+0x34>
    if(p->state == UNUSED)
80104510:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104513:	8b 40 0c             	mov    0xc(%eax),%eax
80104516:	85 c0                	test   %eax,%eax
80104518:	74 2a                	je     80104544 <allocproc+0x57>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010451a:	81 45 f4 c4 00 00 00 	addl   $0xc4,-0xc(%ebp)
80104521:	81 7d f4 f4 7e 11 80 	cmpl   $0x80117ef4,-0xc(%ebp)
80104528:	72 e6                	jb     80104510 <allocproc+0x23>
      goto found;

  release(&ptable.lock);
8010452a:	83 ec 0c             	sub    $0xc,%esp
8010452d:	68 c0 4d 11 80       	push   $0x80114dc0
80104532:	e8 cd 0d 00 00       	call   80105304 <release>
80104537:	83 c4 10             	add    $0x10,%esp
  return 0;
8010453a:	b8 00 00 00 00       	mov    $0x0,%eax
8010453f:	e9 ea 00 00 00       	jmp    8010462e <allocproc+0x141>
      goto found;
80104544:	90                   	nop
80104545:	f3 0f 1e fb          	endbr32 

found:
  p->state = EMBRYO;
80104549:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454c:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104553:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104558:	8d 50 01             	lea    0x1(%eax),%edx
8010455b:	89 15 00 c0 10 80    	mov    %edx,0x8010c000
80104561:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104564:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80104567:	83 ec 0c             	sub    $0xc,%esp
8010456a:	68 c0 4d 11 80       	push   $0x80114dc0
8010456f:	e8 90 0d 00 00       	call   80105304 <release>
80104574:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104577:	e8 80 e8 ff ff       	call   80102dfc <kalloc>
8010457c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010457f:	89 42 08             	mov    %eax,0x8(%edx)
80104582:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104585:	8b 40 08             	mov    0x8(%eax),%eax
80104588:	85 c0                	test   %eax,%eax
8010458a:	75 14                	jne    801045a0 <allocproc+0xb3>
    p->state = UNUSED;
8010458c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104596:	b8 00 00 00 00       	mov    $0x0,%eax
8010459b:	e9 8e 00 00 00       	jmp    8010462e <allocproc+0x141>
  }
  sp = p->kstack + KSTACKSIZE;
801045a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a3:	8b 40 08             	mov    0x8(%eax),%eax
801045a6:	05 00 10 00 00       	add    $0x1000,%eax
801045ab:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801045ae:	83 6d ec 4c          	subl   $0x4c,-0x14(%ebp)
  p->tf = (struct trapframe*)sp;
801045b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
801045b8:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801045bb:	83 6d ec 04          	subl   $0x4,-0x14(%ebp)
  *(uint*)sp = (uint)trapret;
801045bf:	ba 87 6a 10 80       	mov    $0x80106a87,%edx
801045c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045c7:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801045c9:	83 6d ec 14          	subl   $0x14,-0x14(%ebp)
  p->context = (struct context*)sp;
801045cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801045d3:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801045d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d9:	8b 40 1c             	mov    0x1c(%eax),%eax
801045dc:	83 ec 04             	sub    $0x4,%esp
801045df:	6a 14                	push   $0x14
801045e1:	6a 00                	push   $0x0
801045e3:	50                   	push   %eax
801045e4:	e8 48 0f 00 00       	call   80105531 <memset>
801045e9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801045ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ef:	8b 40 1c             	mov    0x1c(%eax),%eax
801045f2:	ba d6 4d 10 80       	mov    $0x80104dd6,%edx
801045f7:	89 50 10             	mov    %edx,0x10(%eax)

  /*init clock*/
  p->clock.index = -1;
801045fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fd:	c7 80 bc 00 00 00 ff 	movl   $0xffffffff,0xbc(%eax)
80104604:	ff ff ff 
  for(int i = 0; i < CLOCKSIZE; i++)
80104607:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010460e:	eb 15                	jmp    80104625 <allocproc+0x138>
    p->clock.queue[i].vpn = -1;
80104610:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104613:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104616:	83 c2 0e             	add    $0xe,%edx
80104619:	c7 44 d0 0c ff ff ff 	movl   $0xffffffff,0xc(%eax,%edx,8)
80104620:	ff 
  for(int i = 0; i < CLOCKSIZE; i++)
80104621:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104625:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
80104629:	7e e5                	jle    80104610 <allocproc+0x123>
  return p;
8010462b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010462e:	c9                   	leave  
8010462f:	c3                   	ret    

80104630 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104630:	f3 0f 1e fb          	endbr32 
80104634:	55                   	push   %ebp
80104635:	89 e5                	mov    %esp,%ebp
80104637:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
8010463a:	e8 ae fe ff ff       	call   801044ed <allocproc>
8010463f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80104642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104645:	a3 40 c6 10 80       	mov    %eax,0x8010c640
  if((p->pgdir = setupkvm()) == 0)
8010464a:	e8 57 3b 00 00       	call   801081a6 <setupkvm>
8010464f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104652:	89 42 04             	mov    %eax,0x4(%edx)
80104655:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104658:	8b 40 04             	mov    0x4(%eax),%eax
8010465b:	85 c0                	test   %eax,%eax
8010465d:	75 0d                	jne    8010466c <userinit+0x3c>
    panic("userinit: out of memory?");
8010465f:	83 ec 0c             	sub    $0xc,%esp
80104662:	68 ca 94 10 80       	push   $0x801094ca
80104667:	e8 9c bf ff ff       	call   80100608 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010466c:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104674:	8b 40 04             	mov    0x4(%eax),%eax
80104677:	83 ec 04             	sub    $0x4,%esp
8010467a:	52                   	push   %edx
8010467b:	68 e0 c4 10 80       	push   $0x8010c4e0
80104680:	50                   	push   %eax
80104681:	e8 99 3d 00 00       	call   8010841f <inituvm>
80104686:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468c:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104692:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104695:	8b 40 18             	mov    0x18(%eax),%eax
80104698:	83 ec 04             	sub    $0x4,%esp
8010469b:	6a 4c                	push   $0x4c
8010469d:	6a 00                	push   $0x0
8010469f:	50                   	push   %eax
801046a0:	e8 8c 0e 00 00       	call   80105531 <memset>
801046a5:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801046a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ab:	8b 40 18             	mov    0x18(%eax),%eax
801046ae:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801046b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b7:	8b 40 18             	mov    0x18(%eax),%eax
801046ba:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801046c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c3:	8b 50 18             	mov    0x18(%eax),%edx
801046c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c9:	8b 40 18             	mov    0x18(%eax),%eax
801046cc:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801046d0:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801046d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d7:	8b 50 18             	mov    0x18(%eax),%edx
801046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046dd:	8b 40 18             	mov    0x18(%eax),%eax
801046e0:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801046e4:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801046e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046eb:	8b 40 18             	mov    0x18(%eax),%eax
801046ee:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801046f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f8:	8b 40 18             	mov    0x18(%eax),%eax
801046fb:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104705:	8b 40 18             	mov    0x18(%eax),%eax
80104708:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104712:	83 c0 6c             	add    $0x6c,%eax
80104715:	83 ec 04             	sub    $0x4,%esp
80104718:	6a 10                	push   $0x10
8010471a:	68 e3 94 10 80       	push   $0x801094e3
8010471f:	50                   	push   %eax
80104720:	e8 27 10 00 00       	call   8010574c <safestrcpy>
80104725:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104728:	83 ec 0c             	sub    $0xc,%esp
8010472b:	68 ec 94 10 80       	push   $0x801094ec
80104730:	e8 42 df ff ff       	call   80102677 <namei>
80104735:	83 c4 10             	add    $0x10,%esp
80104738:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010473b:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010473e:	83 ec 0c             	sub    $0xc,%esp
80104741:	68 c0 4d 11 80       	push   $0x80114dc0
80104746:	e8 47 0b 00 00       	call   80105292 <acquire>
8010474b:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
8010474e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104751:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104758:	83 ec 0c             	sub    $0xc,%esp
8010475b:	68 c0 4d 11 80       	push   $0x80114dc0
80104760:	e8 9f 0b 00 00       	call   80105304 <release>
80104765:	83 c4 10             	add    $0x10,%esp
}
80104768:	90                   	nop
80104769:	c9                   	leave  
8010476a:	c3                   	ret    

8010476b <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010476b:	f3 0f 1e fb          	endbr32 
8010476f:	55                   	push   %ebp
80104770:	89 e5                	mov    %esp,%ebp
80104772:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80104775:	e8 46 fd ff ff       	call   801044c0 <myproc>
8010477a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
8010477d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104780:	8b 00                	mov    (%eax),%eax
80104782:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104785:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104789:	7e 2e                	jle    801047b9 <growproc+0x4e>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010478b:	8b 55 08             	mov    0x8(%ebp),%edx
8010478e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104791:	01 c2                	add    %eax,%edx
80104793:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104796:	8b 40 04             	mov    0x4(%eax),%eax
80104799:	83 ec 04             	sub    $0x4,%esp
8010479c:	52                   	push   %edx
8010479d:	ff 75 f4             	pushl  -0xc(%ebp)
801047a0:	50                   	push   %eax
801047a1:	e8 be 3d 00 00       	call   80108564 <allocuvm>
801047a6:	83 c4 10             	add    $0x10,%esp
801047a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047b0:	75 3b                	jne    801047ed <growproc+0x82>
      return -1;
801047b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047b7:	eb 4f                	jmp    80104808 <growproc+0x9d>
  } else if(n < 0){
801047b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801047bd:	79 2e                	jns    801047ed <growproc+0x82>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801047bf:	8b 55 08             	mov    0x8(%ebp),%edx
801047c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c5:	01 c2                	add    %eax,%edx
801047c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047ca:	8b 40 04             	mov    0x4(%eax),%eax
801047cd:	83 ec 04             	sub    $0x4,%esp
801047d0:	52                   	push   %edx
801047d1:	ff 75 f4             	pushl  -0xc(%ebp)
801047d4:	50                   	push   %eax
801047d5:	e8 93 3e 00 00       	call   8010866d <deallocuvm>
801047da:	83 c4 10             	add    $0x10,%esp
801047dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047e4:	75 07                	jne    801047ed <growproc+0x82>
      return -1;
801047e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047eb:	eb 1b                	jmp    80104808 <growproc+0x9d>
  }
  curproc->sz = sz;
801047ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047f3:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
801047f5:	83 ec 0c             	sub    $0xc,%esp
801047f8:	ff 75 f0             	pushl  -0x10(%ebp)
801047fb:	e8 7c 3a 00 00       	call   8010827c <switchuvm>
80104800:	83 c4 10             	add    $0x10,%esp
  return 0;
80104803:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104808:	c9                   	leave  
80104809:	c3                   	ret    

8010480a <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010480a:	f3 0f 1e fb          	endbr32 
8010480e:	55                   	push   %ebp
8010480f:	89 e5                	mov    %esp,%ebp
80104811:	57                   	push   %edi
80104812:	56                   	push   %esi
80104813:	53                   	push   %ebx
80104814:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104817:	e8 a4 fc ff ff       	call   801044c0 <myproc>
8010481c:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
8010481f:	e8 c9 fc ff ff       	call   801044ed <allocproc>
80104824:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104827:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
8010482b:	75 0a                	jne    80104837 <fork+0x2d>
    return -1;
8010482d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104832:	e9 8f 01 00 00       	jmp    801049c6 <fork+0x1bc>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104837:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010483a:	8b 10                	mov    (%eax),%edx
8010483c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010483f:	8b 40 04             	mov    0x4(%eax),%eax
80104842:	83 ec 08             	sub    $0x8,%esp
80104845:	52                   	push   %edx
80104846:	50                   	push   %eax
80104847:	e8 cf 3f 00 00       	call   8010881b <copyuvm>
8010484c:	83 c4 10             	add    $0x10,%esp
8010484f:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104852:	89 42 04             	mov    %eax,0x4(%edx)
80104855:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104858:	8b 40 04             	mov    0x4(%eax),%eax
8010485b:	85 c0                	test   %eax,%eax
8010485d:	75 30                	jne    8010488f <fork+0x85>
    kfree(np->kstack);
8010485f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104862:	8b 40 08             	mov    0x8(%eax),%eax
80104865:	83 ec 0c             	sub    $0xc,%esp
80104868:	50                   	push   %eax
80104869:	e8 f0 e4 ff ff       	call   80102d5e <kfree>
8010486e:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104871:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104874:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010487b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010487e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104885:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010488a:	e9 37 01 00 00       	jmp    801049c6 <fork+0x1bc>
  }
  np->sz = curproc->sz;
8010488f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104892:	8b 10                	mov    (%eax),%edx
80104894:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104897:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80104899:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010489c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010489f:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
801048a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801048a5:	8b 48 18             	mov    0x18(%eax),%ecx
801048a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801048ab:	8b 40 18             	mov    0x18(%eax),%eax
801048ae:	89 c2                	mov    %eax,%edx
801048b0:	89 cb                	mov    %ecx,%ebx
801048b2:	b8 13 00 00 00       	mov    $0x13,%eax
801048b7:	89 d7                	mov    %edx,%edi
801048b9:	89 de                	mov    %ebx,%esi
801048bb:	89 c1                	mov    %eax,%ecx
801048bd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  /*creating new clock, and deep copy parent's clock*/
  //newClock: np->clock.queue[i]
  for(int i = 0; i < CLOCKSIZE; i++) {
801048bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801048c6:	eb 38                	jmp    80104900 <fork+0xf6>
    np->clock.queue[i].vpn = curproc->clock.queue[i].vpn;
801048c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801048cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
801048ce:	83 c2 0e             	add    $0xe,%edx
801048d1:	8b 54 d0 0c          	mov    0xc(%eax,%edx,8),%edx
801048d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801048d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801048db:	83 c1 0e             	add    $0xe,%ecx
801048de:	89 54 c8 0c          	mov    %edx,0xc(%eax,%ecx,8)
    //might need to walk page dir
    np->clock.queue[i].pte = curproc->clock.queue[i].pte;
801048e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801048e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801048e8:	83 c2 0e             	add    $0xe,%edx
801048eb:	8b 54 d0 10          	mov    0x10(%eax,%edx,8),%edx
801048ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
801048f2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801048f5:	83 c1 0e             	add    $0xe,%ecx
801048f8:	89 54 c8 10          	mov    %edx,0x10(%eax,%ecx,8)
  for(int i = 0; i < CLOCKSIZE; i++) {
801048fc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80104900:	83 7d e0 07          	cmpl   $0x7,-0x20(%ebp)
80104904:	7e c2                	jle    801048c8 <fork+0xbe>
    //np->clock.queue[i].pte = walkpgdir(np->pgdir, (char *)curproc->clock.queue[i].vpn, 0);
  }

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104906:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104909:	8b 40 18             	mov    0x18(%eax),%eax
8010490c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104913:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010491a:	eb 3b                	jmp    80104957 <fork+0x14d>
    if(curproc->ofile[i])
8010491c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010491f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104922:	83 c2 08             	add    $0x8,%edx
80104925:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104929:	85 c0                	test   %eax,%eax
8010492b:	74 26                	je     80104953 <fork+0x149>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010492d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104930:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104933:	83 c2 08             	add    $0x8,%edx
80104936:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010493a:	83 ec 0c             	sub    $0xc,%esp
8010493d:	50                   	push   %eax
8010493e:	e8 f4 c7 ff ff       	call   80101137 <filedup>
80104943:	83 c4 10             	add    $0x10,%esp
80104946:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104949:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010494c:	83 c1 08             	add    $0x8,%ecx
8010494f:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80104953:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104957:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010495b:	7e bf                	jle    8010491c <fork+0x112>
  np->cwd = idup(curproc->cwd);
8010495d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104960:	8b 40 68             	mov    0x68(%eax),%eax
80104963:	83 ec 0c             	sub    $0xc,%esp
80104966:	50                   	push   %eax
80104967:	e8 62 d1 ff ff       	call   80101ace <idup>
8010496c:	83 c4 10             	add    $0x10,%esp
8010496f:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104972:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104975:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104978:	8d 50 6c             	lea    0x6c(%eax),%edx
8010497b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010497e:	83 c0 6c             	add    $0x6c,%eax
80104981:	83 ec 04             	sub    $0x4,%esp
80104984:	6a 10                	push   $0x10
80104986:	52                   	push   %edx
80104987:	50                   	push   %eax
80104988:	e8 bf 0d 00 00       	call   8010574c <safestrcpy>
8010498d:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104990:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104993:	8b 40 10             	mov    0x10(%eax),%eax
80104996:	89 45 d4             	mov    %eax,-0x2c(%ebp)

  acquire(&ptable.lock);
80104999:	83 ec 0c             	sub    $0xc,%esp
8010499c:	68 c0 4d 11 80       	push   $0x80114dc0
801049a1:	e8 ec 08 00 00       	call   80105292 <acquire>
801049a6:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
801049a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801049ac:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801049b3:	83 ec 0c             	sub    $0xc,%esp
801049b6:	68 c0 4d 11 80       	push   $0x80114dc0
801049bb:	e8 44 09 00 00       	call   80105304 <release>
801049c0:	83 c4 10             	add    $0x10,%esp

  return pid;
801049c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
801049c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049c9:	5b                   	pop    %ebx
801049ca:	5e                   	pop    %esi
801049cb:	5f                   	pop    %edi
801049cc:	5d                   	pop    %ebp
801049cd:	c3                   	ret    

801049ce <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801049ce:	f3 0f 1e fb          	endbr32 
801049d2:	55                   	push   %ebp
801049d3:	89 e5                	mov    %esp,%ebp
801049d5:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
801049d8:	e8 e3 fa ff ff       	call   801044c0 <myproc>
801049dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
801049e0:	a1 40 c6 10 80       	mov    0x8010c640,%eax
801049e5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801049e8:	75 0d                	jne    801049f7 <exit+0x29>
    panic("init exiting");
801049ea:	83 ec 0c             	sub    $0xc,%esp
801049ed:	68 ee 94 10 80       	push   $0x801094ee
801049f2:	e8 11 bc ff ff       	call   80100608 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801049f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801049fe:	eb 3f                	jmp    80104a3f <exit+0x71>
    if(curproc->ofile[fd]){
80104a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a03:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a06:	83 c2 08             	add    $0x8,%edx
80104a09:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a0d:	85 c0                	test   %eax,%eax
80104a0f:	74 2a                	je     80104a3b <exit+0x6d>
      fileclose(curproc->ofile[fd]);
80104a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a14:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a17:	83 c2 08             	add    $0x8,%edx
80104a1a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a1e:	83 ec 0c             	sub    $0xc,%esp
80104a21:	50                   	push   %eax
80104a22:	e8 65 c7 ff ff       	call   8010118c <fileclose>
80104a27:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80104a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a30:	83 c2 08             	add    $0x8,%edx
80104a33:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a3a:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104a3b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a3f:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a43:	7e bb                	jle    80104a00 <exit+0x32>
    }
  }

  begin_op();
80104a45:	e8 b7 ec ff ff       	call   80103701 <begin_op>
  iput(curproc->cwd);
80104a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a4d:	8b 40 68             	mov    0x68(%eax),%eax
80104a50:	83 ec 0c             	sub    $0xc,%esp
80104a53:	50                   	push   %eax
80104a54:	e8 1c d2 ff ff       	call   80101c75 <iput>
80104a59:	83 c4 10             	add    $0x10,%esp
  end_op();
80104a5c:	e8 30 ed ff ff       	call   80103791 <end_op>
  curproc->cwd = 0;
80104a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a64:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104a6b:	83 ec 0c             	sub    $0xc,%esp
80104a6e:	68 c0 4d 11 80       	push   $0x80114dc0
80104a73:	e8 1a 08 00 00       	call   80105292 <acquire>
80104a78:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a7e:	8b 40 14             	mov    0x14(%eax),%eax
80104a81:	83 ec 0c             	sub    $0xc,%esp
80104a84:	50                   	push   %eax
80104a85:	e8 41 04 00 00       	call   80104ecb <wakeup1>
80104a8a:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a8d:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
80104a94:	eb 3a                	jmp    80104ad0 <exit+0x102>
    if(p->parent == curproc){
80104a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a99:	8b 40 14             	mov    0x14(%eax),%eax
80104a9c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104a9f:	75 28                	jne    80104ac9 <exit+0xfb>
      p->parent = initproc;
80104aa1:	8b 15 40 c6 10 80    	mov    0x8010c640,%edx
80104aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aaa:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab0:	8b 40 0c             	mov    0xc(%eax),%eax
80104ab3:	83 f8 05             	cmp    $0x5,%eax
80104ab6:	75 11                	jne    80104ac9 <exit+0xfb>
        wakeup1(initproc);
80104ab8:	a1 40 c6 10 80       	mov    0x8010c640,%eax
80104abd:	83 ec 0c             	sub    $0xc,%esp
80104ac0:	50                   	push   %eax
80104ac1:	e8 05 04 00 00       	call   80104ecb <wakeup1>
80104ac6:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ac9:	81 45 f4 c4 00 00 00 	addl   $0xc4,-0xc(%ebp)
80104ad0:	81 7d f4 f4 7e 11 80 	cmpl   $0x80117ef4,-0xc(%ebp)
80104ad7:	72 bd                	jb     80104a96 <exit+0xc8>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104adc:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104ae3:	e8 f3 01 00 00       	call   80104cdb <sched>
  panic("zombie exit");
80104ae8:	83 ec 0c             	sub    $0xc,%esp
80104aeb:	68 fb 94 10 80       	push   $0x801094fb
80104af0:	e8 13 bb ff ff       	call   80100608 <panic>

80104af5 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104af5:	f3 0f 1e fb          	endbr32 
80104af9:	55                   	push   %ebp
80104afa:	89 e5                	mov    %esp,%ebp
80104afc:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104aff:	e8 bc f9 ff ff       	call   801044c0 <myproc>
80104b04:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104b07:	83 ec 0c             	sub    $0xc,%esp
80104b0a:	68 c0 4d 11 80       	push   $0x80114dc0
80104b0f:	e8 7e 07 00 00       	call   80105292 <acquire>
80104b14:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104b17:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b1e:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
80104b25:	e9 a4 00 00 00       	jmp    80104bce <wait+0xd9>
      if(p->parent != curproc)
80104b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b2d:	8b 40 14             	mov    0x14(%eax),%eax
80104b30:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104b33:	0f 85 8d 00 00 00    	jne    80104bc6 <wait+0xd1>
        continue;
      havekids = 1;
80104b39:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b43:	8b 40 0c             	mov    0xc(%eax),%eax
80104b46:	83 f8 05             	cmp    $0x5,%eax
80104b49:	75 7c                	jne    80104bc7 <wait+0xd2>
        // Found one.
        pid = p->pid;
80104b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b4e:	8b 40 10             	mov    0x10(%eax),%eax
80104b51:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b57:	8b 40 08             	mov    0x8(%eax),%eax
80104b5a:	83 ec 0c             	sub    $0xc,%esp
80104b5d:	50                   	push   %eax
80104b5e:	e8 fb e1 ff ff       	call   80102d5e <kfree>
80104b63:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b69:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b73:	8b 40 04             	mov    0x4(%eax),%eax
80104b76:	83 ec 0c             	sub    $0xc,%esp
80104b79:	50                   	push   %eax
80104b7a:	e8 b8 3b 00 00       	call   80108737 <freevm>
80104b7f:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b85:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b99:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba0:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104baa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104bb1:	83 ec 0c             	sub    $0xc,%esp
80104bb4:	68 c0 4d 11 80       	push   $0x80114dc0
80104bb9:	e8 46 07 00 00       	call   80105304 <release>
80104bbe:	83 c4 10             	add    $0x10,%esp
        return pid;
80104bc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104bc4:	eb 54                	jmp    80104c1a <wait+0x125>
        continue;
80104bc6:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bc7:	81 45 f4 c4 00 00 00 	addl   $0xc4,-0xc(%ebp)
80104bce:	81 7d f4 f4 7e 11 80 	cmpl   $0x80117ef4,-0xc(%ebp)
80104bd5:	0f 82 4f ff ff ff    	jb     80104b2a <wait+0x35>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104bdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104bdf:	74 0a                	je     80104beb <wait+0xf6>
80104be1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104be4:	8b 40 24             	mov    0x24(%eax),%eax
80104be7:	85 c0                	test   %eax,%eax
80104be9:	74 17                	je     80104c02 <wait+0x10d>
      release(&ptable.lock);
80104beb:	83 ec 0c             	sub    $0xc,%esp
80104bee:	68 c0 4d 11 80       	push   $0x80114dc0
80104bf3:	e8 0c 07 00 00       	call   80105304 <release>
80104bf8:	83 c4 10             	add    $0x10,%esp
      return -1;
80104bfb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c00:	eb 18                	jmp    80104c1a <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104c02:	83 ec 08             	sub    $0x8,%esp
80104c05:	68 c0 4d 11 80       	push   $0x80114dc0
80104c0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c0d:	e8 0e 02 00 00       	call   80104e20 <sleep>
80104c12:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104c15:	e9 fd fe ff ff       	jmp    80104b17 <wait+0x22>
  }
}
80104c1a:	c9                   	leave  
80104c1b:	c3                   	ret    

80104c1c <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c1c:	f3 0f 1e fb          	endbr32 
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104c26:	e8 19 f8 ff ff       	call   80104444 <mycpu>
80104c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c31:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104c38:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c3b:	e8 bc f7 ff ff       	call   801043fc <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c40:	83 ec 0c             	sub    $0xc,%esp
80104c43:	68 c0 4d 11 80       	push   $0x80114dc0
80104c48:	e8 45 06 00 00       	call   80105292 <acquire>
80104c4d:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c50:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
80104c57:	eb 64                	jmp    80104cbd <scheduler+0xa1>
      if(p->state != RUNNABLE)
80104c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c5c:	8b 40 0c             	mov    0xc(%eax),%eax
80104c5f:	83 f8 03             	cmp    $0x3,%eax
80104c62:	75 51                	jne    80104cb5 <scheduler+0x99>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c6a:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104c70:	83 ec 0c             	sub    $0xc,%esp
80104c73:	ff 75 f4             	pushl  -0xc(%ebp)
80104c76:	e8 01 36 00 00       	call   8010827c <switchuvm>
80104c7b:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c81:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8b:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c91:	83 c2 04             	add    $0x4,%edx
80104c94:	83 ec 08             	sub    $0x8,%esp
80104c97:	50                   	push   %eax
80104c98:	52                   	push   %edx
80104c99:	e8 27 0b 00 00       	call   801057c5 <swtch>
80104c9e:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104ca1:	e8 b9 35 00 00       	call   8010825f <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ca9:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104cb0:	00 00 00 
80104cb3:	eb 01                	jmp    80104cb6 <scheduler+0x9a>
        continue;
80104cb5:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cb6:	81 45 f4 c4 00 00 00 	addl   $0xc4,-0xc(%ebp)
80104cbd:	81 7d f4 f4 7e 11 80 	cmpl   $0x80117ef4,-0xc(%ebp)
80104cc4:	72 93                	jb     80104c59 <scheduler+0x3d>
    }
    release(&ptable.lock);
80104cc6:	83 ec 0c             	sub    $0xc,%esp
80104cc9:	68 c0 4d 11 80       	push   $0x80114dc0
80104cce:	e8 31 06 00 00       	call   80105304 <release>
80104cd3:	83 c4 10             	add    $0x10,%esp
    sti();
80104cd6:	e9 60 ff ff ff       	jmp    80104c3b <scheduler+0x1f>

80104cdb <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104cdb:	f3 0f 1e fb          	endbr32 
80104cdf:	55                   	push   %ebp
80104ce0:	89 e5                	mov    %esp,%ebp
80104ce2:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104ce5:	e8 d6 f7 ff ff       	call   801044c0 <myproc>
80104cea:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104ced:	83 ec 0c             	sub    $0xc,%esp
80104cf0:	68 c0 4d 11 80       	push   $0x80114dc0
80104cf5:	e8 df 06 00 00       	call   801053d9 <holding>
80104cfa:	83 c4 10             	add    $0x10,%esp
80104cfd:	85 c0                	test   %eax,%eax
80104cff:	75 0d                	jne    80104d0e <sched+0x33>
    panic("sched ptable.lock");
80104d01:	83 ec 0c             	sub    $0xc,%esp
80104d04:	68 07 95 10 80       	push   $0x80109507
80104d09:	e8 fa b8 ff ff       	call   80100608 <panic>
  if(mycpu()->ncli != 1)
80104d0e:	e8 31 f7 ff ff       	call   80104444 <mycpu>
80104d13:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d19:	83 f8 01             	cmp    $0x1,%eax
80104d1c:	74 0d                	je     80104d2b <sched+0x50>
    panic("sched locks");
80104d1e:	83 ec 0c             	sub    $0xc,%esp
80104d21:	68 19 95 10 80       	push   $0x80109519
80104d26:	e8 dd b8 ff ff       	call   80100608 <panic>
  if(p->state == RUNNING)
80104d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d2e:	8b 40 0c             	mov    0xc(%eax),%eax
80104d31:	83 f8 04             	cmp    $0x4,%eax
80104d34:	75 0d                	jne    80104d43 <sched+0x68>
    panic("sched running");
80104d36:	83 ec 0c             	sub    $0xc,%esp
80104d39:	68 25 95 10 80       	push   $0x80109525
80104d3e:	e8 c5 b8 ff ff       	call   80100608 <panic>
  if(readeflags()&FL_IF)
80104d43:	e8 a4 f6 ff ff       	call   801043ec <readeflags>
80104d48:	25 00 02 00 00       	and    $0x200,%eax
80104d4d:	85 c0                	test   %eax,%eax
80104d4f:	74 0d                	je     80104d5e <sched+0x83>
    panic("sched interruptible");
80104d51:	83 ec 0c             	sub    $0xc,%esp
80104d54:	68 33 95 10 80       	push   $0x80109533
80104d59:	e8 aa b8 ff ff       	call   80100608 <panic>
  intena = mycpu()->intena;
80104d5e:	e8 e1 f6 ff ff       	call   80104444 <mycpu>
80104d63:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104d6c:	e8 d3 f6 ff ff       	call   80104444 <mycpu>
80104d71:	8b 40 04             	mov    0x4(%eax),%eax
80104d74:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d77:	83 c2 1c             	add    $0x1c,%edx
80104d7a:	83 ec 08             	sub    $0x8,%esp
80104d7d:	50                   	push   %eax
80104d7e:	52                   	push   %edx
80104d7f:	e8 41 0a 00 00       	call   801057c5 <swtch>
80104d84:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104d87:	e8 b8 f6 ff ff       	call   80104444 <mycpu>
80104d8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d8f:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104d95:	90                   	nop
80104d96:	c9                   	leave  
80104d97:	c3                   	ret    

80104d98 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104d98:	f3 0f 1e fb          	endbr32 
80104d9c:	55                   	push   %ebp
80104d9d:	89 e5                	mov    %esp,%ebp
80104d9f:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104da2:	83 ec 0c             	sub    $0xc,%esp
80104da5:	68 c0 4d 11 80       	push   $0x80114dc0
80104daa:	e8 e3 04 00 00       	call   80105292 <acquire>
80104daf:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104db2:	e8 09 f7 ff ff       	call   801044c0 <myproc>
80104db7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104dbe:	e8 18 ff ff ff       	call   80104cdb <sched>
  release(&ptable.lock);
80104dc3:	83 ec 0c             	sub    $0xc,%esp
80104dc6:	68 c0 4d 11 80       	push   $0x80114dc0
80104dcb:	e8 34 05 00 00       	call   80105304 <release>
80104dd0:	83 c4 10             	add    $0x10,%esp
}
80104dd3:	90                   	nop
80104dd4:	c9                   	leave  
80104dd5:	c3                   	ret    

80104dd6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104dd6:	f3 0f 1e fb          	endbr32 
80104dda:	55                   	push   %ebp
80104ddb:	89 e5                	mov    %esp,%ebp
80104ddd:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104de0:	83 ec 0c             	sub    $0xc,%esp
80104de3:	68 c0 4d 11 80       	push   $0x80114dc0
80104de8:	e8 17 05 00 00       	call   80105304 <release>
80104ded:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104df0:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104df5:	85 c0                	test   %eax,%eax
80104df7:	74 24                	je     80104e1d <forkret+0x47>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104df9:	c7 05 04 c0 10 80 00 	movl   $0x0,0x8010c004
80104e00:	00 00 00 
    iinit(ROOTDEV);
80104e03:	83 ec 0c             	sub    $0xc,%esp
80104e06:	6a 01                	push   $0x1
80104e08:	e8 79 c9 ff ff       	call   80101786 <iinit>
80104e0d:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104e10:	83 ec 0c             	sub    $0xc,%esp
80104e13:	6a 01                	push   $0x1
80104e15:	e8 b4 e6 ff ff       	call   801034ce <initlog>
80104e1a:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104e1d:	90                   	nop
80104e1e:	c9                   	leave  
80104e1f:	c3                   	ret    

80104e20 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104e2a:	e8 91 f6 ff ff       	call   801044c0 <myproc>
80104e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104e32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e36:	75 0d                	jne    80104e45 <sleep+0x25>
    panic("sleep");
80104e38:	83 ec 0c             	sub    $0xc,%esp
80104e3b:	68 47 95 10 80       	push   $0x80109547
80104e40:	e8 c3 b7 ff ff       	call   80100608 <panic>

  if(lk == 0)
80104e45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e49:	75 0d                	jne    80104e58 <sleep+0x38>
    panic("sleep without lk");
80104e4b:	83 ec 0c             	sub    $0xc,%esp
80104e4e:	68 4d 95 10 80       	push   $0x8010954d
80104e53:	e8 b0 b7 ff ff       	call   80100608 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104e58:	81 7d 0c c0 4d 11 80 	cmpl   $0x80114dc0,0xc(%ebp)
80104e5f:	74 1e                	je     80104e7f <sleep+0x5f>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104e61:	83 ec 0c             	sub    $0xc,%esp
80104e64:	68 c0 4d 11 80       	push   $0x80114dc0
80104e69:	e8 24 04 00 00       	call   80105292 <acquire>
80104e6e:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104e71:	83 ec 0c             	sub    $0xc,%esp
80104e74:	ff 75 0c             	pushl  0xc(%ebp)
80104e77:	e8 88 04 00 00       	call   80105304 <release>
80104e7c:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e82:	8b 55 08             	mov    0x8(%ebp),%edx
80104e85:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8b:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104e92:	e8 44 fe ff ff       	call   80104cdb <sched>

  // Tidy up.
  p->chan = 0;
80104e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e9a:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104ea1:	81 7d 0c c0 4d 11 80 	cmpl   $0x80114dc0,0xc(%ebp)
80104ea8:	74 1e                	je     80104ec8 <sleep+0xa8>
    release(&ptable.lock);
80104eaa:	83 ec 0c             	sub    $0xc,%esp
80104ead:	68 c0 4d 11 80       	push   $0x80114dc0
80104eb2:	e8 4d 04 00 00       	call   80105304 <release>
80104eb7:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104eba:	83 ec 0c             	sub    $0xc,%esp
80104ebd:	ff 75 0c             	pushl  0xc(%ebp)
80104ec0:	e8 cd 03 00 00       	call   80105292 <acquire>
80104ec5:	83 c4 10             	add    $0x10,%esp
  }
}
80104ec8:	90                   	nop
80104ec9:	c9                   	leave  
80104eca:	c3                   	ret    

80104ecb <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104ecb:	f3 0f 1e fb          	endbr32 
80104ecf:	55                   	push   %ebp
80104ed0:	89 e5                	mov    %esp,%ebp
80104ed2:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ed5:	c7 45 fc f4 4d 11 80 	movl   $0x80114df4,-0x4(%ebp)
80104edc:	eb 27                	jmp    80104f05 <wakeup1+0x3a>
    if(p->state == SLEEPING && p->chan == chan)
80104ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ee1:	8b 40 0c             	mov    0xc(%eax),%eax
80104ee4:	83 f8 02             	cmp    $0x2,%eax
80104ee7:	75 15                	jne    80104efe <wakeup1+0x33>
80104ee9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104eec:	8b 40 20             	mov    0x20(%eax),%eax
80104eef:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ef2:	75 0a                	jne    80104efe <wakeup1+0x33>
      p->state = RUNNABLE;
80104ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ef7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104efe:	81 45 fc c4 00 00 00 	addl   $0xc4,-0x4(%ebp)
80104f05:	81 7d fc f4 7e 11 80 	cmpl   $0x80117ef4,-0x4(%ebp)
80104f0c:	72 d0                	jb     80104ede <wakeup1+0x13>
}
80104f0e:	90                   	nop
80104f0f:	90                   	nop
80104f10:	c9                   	leave  
80104f11:	c3                   	ret    

80104f12 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f12:	f3 0f 1e fb          	endbr32 
80104f16:	55                   	push   %ebp
80104f17:	89 e5                	mov    %esp,%ebp
80104f19:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104f1c:	83 ec 0c             	sub    $0xc,%esp
80104f1f:	68 c0 4d 11 80       	push   $0x80114dc0
80104f24:	e8 69 03 00 00       	call   80105292 <acquire>
80104f29:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104f2c:	83 ec 0c             	sub    $0xc,%esp
80104f2f:	ff 75 08             	pushl  0x8(%ebp)
80104f32:	e8 94 ff ff ff       	call   80104ecb <wakeup1>
80104f37:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104f3a:	83 ec 0c             	sub    $0xc,%esp
80104f3d:	68 c0 4d 11 80       	push   $0x80114dc0
80104f42:	e8 bd 03 00 00       	call   80105304 <release>
80104f47:	83 c4 10             	add    $0x10,%esp
}
80104f4a:	90                   	nop
80104f4b:	c9                   	leave  
80104f4c:	c3                   	ret    

80104f4d <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f4d:	f3 0f 1e fb          	endbr32 
80104f51:	55                   	push   %ebp
80104f52:	89 e5                	mov    %esp,%ebp
80104f54:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104f57:	83 ec 0c             	sub    $0xc,%esp
80104f5a:	68 c0 4d 11 80       	push   $0x80114dc0
80104f5f:	e8 2e 03 00 00       	call   80105292 <acquire>
80104f64:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f67:	c7 45 f4 f4 4d 11 80 	movl   $0x80114df4,-0xc(%ebp)
80104f6e:	eb 48                	jmp    80104fb8 <kill+0x6b>
    if(p->pid == pid){
80104f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f73:	8b 40 10             	mov    0x10(%eax),%eax
80104f76:	39 45 08             	cmp    %eax,0x8(%ebp)
80104f79:	75 36                	jne    80104fb1 <kill+0x64>
      p->killed = 1;
80104f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f7e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f88:	8b 40 0c             	mov    0xc(%eax),%eax
80104f8b:	83 f8 02             	cmp    $0x2,%eax
80104f8e:	75 0a                	jne    80104f9a <kill+0x4d>
        p->state = RUNNABLE;
80104f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f93:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104f9a:	83 ec 0c             	sub    $0xc,%esp
80104f9d:	68 c0 4d 11 80       	push   $0x80114dc0
80104fa2:	e8 5d 03 00 00       	call   80105304 <release>
80104fa7:	83 c4 10             	add    $0x10,%esp
      return 0;
80104faa:	b8 00 00 00 00       	mov    $0x0,%eax
80104faf:	eb 25                	jmp    80104fd6 <kill+0x89>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fb1:	81 45 f4 c4 00 00 00 	addl   $0xc4,-0xc(%ebp)
80104fb8:	81 7d f4 f4 7e 11 80 	cmpl   $0x80117ef4,-0xc(%ebp)
80104fbf:	72 af                	jb     80104f70 <kill+0x23>
    }
  }
  release(&ptable.lock);
80104fc1:	83 ec 0c             	sub    $0xc,%esp
80104fc4:	68 c0 4d 11 80       	push   $0x80114dc0
80104fc9:	e8 36 03 00 00       	call   80105304 <release>
80104fce:	83 c4 10             	add    $0x10,%esp
  return -1;
80104fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fd6:	c9                   	leave  
80104fd7:	c3                   	ret    

80104fd8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104fd8:	f3 0f 1e fb          	endbr32 
80104fdc:	55                   	push   %ebp
80104fdd:	89 e5                	mov    %esp,%ebp
80104fdf:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fe2:	c7 45 f0 f4 4d 11 80 	movl   $0x80114df4,-0x10(%ebp)
80104fe9:	e9 da 00 00 00       	jmp    801050c8 <procdump+0xf0>
    if(p->state == UNUSED)
80104fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ff1:	8b 40 0c             	mov    0xc(%eax),%eax
80104ff4:	85 c0                	test   %eax,%eax
80104ff6:	0f 84 c4 00 00 00    	je     801050c0 <procdump+0xe8>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fff:	8b 40 0c             	mov    0xc(%eax),%eax
80105002:	83 f8 05             	cmp    $0x5,%eax
80105005:	77 23                	ja     8010502a <procdump+0x52>
80105007:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010500a:	8b 40 0c             	mov    0xc(%eax),%eax
8010500d:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80105014:	85 c0                	test   %eax,%eax
80105016:	74 12                	je     8010502a <procdump+0x52>
      state = states[p->state];
80105018:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010501b:	8b 40 0c             	mov    0xc(%eax),%eax
8010501e:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80105025:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105028:	eb 07                	jmp    80105031 <procdump+0x59>
    else
      state = "???";
8010502a:	c7 45 ec 5e 95 10 80 	movl   $0x8010955e,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105031:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105034:	8d 50 6c             	lea    0x6c(%eax),%edx
80105037:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010503a:	8b 40 10             	mov    0x10(%eax),%eax
8010503d:	52                   	push   %edx
8010503e:	ff 75 ec             	pushl  -0x14(%ebp)
80105041:	50                   	push   %eax
80105042:	68 62 95 10 80       	push   $0x80109562
80105047:	e8 cc b3 ff ff       	call   80100418 <cprintf>
8010504c:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
8010504f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105052:	8b 40 0c             	mov    0xc(%eax),%eax
80105055:	83 f8 02             	cmp    $0x2,%eax
80105058:	75 54                	jne    801050ae <procdump+0xd6>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010505a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010505d:	8b 40 1c             	mov    0x1c(%eax),%eax
80105060:	8b 40 0c             	mov    0xc(%eax),%eax
80105063:	83 c0 08             	add    $0x8,%eax
80105066:	89 c2                	mov    %eax,%edx
80105068:	83 ec 08             	sub    $0x8,%esp
8010506b:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010506e:	50                   	push   %eax
8010506f:	52                   	push   %edx
80105070:	e8 e5 02 00 00       	call   8010535a <getcallerpcs>
80105075:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105078:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010507f:	eb 1c                	jmp    8010509d <procdump+0xc5>
        cprintf(" %p", pc[i]);
80105081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105084:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105088:	83 ec 08             	sub    $0x8,%esp
8010508b:	50                   	push   %eax
8010508c:	68 6b 95 10 80       	push   $0x8010956b
80105091:	e8 82 b3 ff ff       	call   80100418 <cprintf>
80105096:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105099:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010509d:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801050a1:	7f 0b                	jg     801050ae <procdump+0xd6>
801050a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a6:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050aa:	85 c0                	test   %eax,%eax
801050ac:	75 d3                	jne    80105081 <procdump+0xa9>
    }
    cprintf("\n");
801050ae:	83 ec 0c             	sub    $0xc,%esp
801050b1:	68 6f 95 10 80       	push   $0x8010956f
801050b6:	e8 5d b3 ff ff       	call   80100418 <cprintf>
801050bb:	83 c4 10             	add    $0x10,%esp
801050be:	eb 01                	jmp    801050c1 <procdump+0xe9>
      continue;
801050c0:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050c1:	81 45 f0 c4 00 00 00 	addl   $0xc4,-0x10(%ebp)
801050c8:	81 7d f0 f4 7e 11 80 	cmpl   $0x80117ef4,-0x10(%ebp)
801050cf:	0f 82 19 ff ff ff    	jb     80104fee <procdump+0x16>
  }
}
801050d5:	90                   	nop
801050d6:	90                   	nop
801050d7:	c9                   	leave  
801050d8:	c3                   	ret    

801050d9 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801050d9:	f3 0f 1e fb          	endbr32 
801050dd:	55                   	push   %ebp
801050de:	89 e5                	mov    %esp,%ebp
801050e0:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
801050e3:	8b 45 08             	mov    0x8(%ebp),%eax
801050e6:	83 c0 04             	add    $0x4,%eax
801050e9:	83 ec 08             	sub    $0x8,%esp
801050ec:	68 9b 95 10 80       	push   $0x8010959b
801050f1:	50                   	push   %eax
801050f2:	e8 75 01 00 00       	call   8010526c <initlock>
801050f7:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
801050fa:	8b 45 08             	mov    0x8(%ebp),%eax
801050fd:	8b 55 0c             	mov    0xc(%ebp),%edx
80105100:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80105103:	8b 45 08             	mov    0x8(%ebp),%eax
80105106:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010510c:	8b 45 08             	mov    0x8(%ebp),%eax
8010510f:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80105116:	90                   	nop
80105117:	c9                   	leave  
80105118:	c3                   	ret    

80105119 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105119:	f3 0f 1e fb          	endbr32 
8010511d:	55                   	push   %ebp
8010511e:	89 e5                	mov    %esp,%ebp
80105120:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80105123:	8b 45 08             	mov    0x8(%ebp),%eax
80105126:	83 c0 04             	add    $0x4,%eax
80105129:	83 ec 0c             	sub    $0xc,%esp
8010512c:	50                   	push   %eax
8010512d:	e8 60 01 00 00       	call   80105292 <acquire>
80105132:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80105135:	eb 15                	jmp    8010514c <acquiresleep+0x33>
    sleep(lk, &lk->lk);
80105137:	8b 45 08             	mov    0x8(%ebp),%eax
8010513a:	83 c0 04             	add    $0x4,%eax
8010513d:	83 ec 08             	sub    $0x8,%esp
80105140:	50                   	push   %eax
80105141:	ff 75 08             	pushl  0x8(%ebp)
80105144:	e8 d7 fc ff ff       	call   80104e20 <sleep>
80105149:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
8010514c:	8b 45 08             	mov    0x8(%ebp),%eax
8010514f:	8b 00                	mov    (%eax),%eax
80105151:	85 c0                	test   %eax,%eax
80105153:	75 e2                	jne    80105137 <acquiresleep+0x1e>
  }
  lk->locked = 1;
80105155:	8b 45 08             	mov    0x8(%ebp),%eax
80105158:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
8010515e:	e8 5d f3 ff ff       	call   801044c0 <myproc>
80105163:	8b 50 10             	mov    0x10(%eax),%edx
80105166:	8b 45 08             	mov    0x8(%ebp),%eax
80105169:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
8010516c:	8b 45 08             	mov    0x8(%ebp),%eax
8010516f:	83 c0 04             	add    $0x4,%eax
80105172:	83 ec 0c             	sub    $0xc,%esp
80105175:	50                   	push   %eax
80105176:	e8 89 01 00 00       	call   80105304 <release>
8010517b:	83 c4 10             	add    $0x10,%esp
}
8010517e:	90                   	nop
8010517f:	c9                   	leave  
80105180:	c3                   	ret    

80105181 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105181:	f3 0f 1e fb          	endbr32 
80105185:	55                   	push   %ebp
80105186:	89 e5                	mov    %esp,%ebp
80105188:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010518b:	8b 45 08             	mov    0x8(%ebp),%eax
8010518e:	83 c0 04             	add    $0x4,%eax
80105191:	83 ec 0c             	sub    $0xc,%esp
80105194:	50                   	push   %eax
80105195:	e8 f8 00 00 00       	call   80105292 <acquire>
8010519a:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
8010519d:	8b 45 08             	mov    0x8(%ebp),%eax
801051a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801051a6:	8b 45 08             	mov    0x8(%ebp),%eax
801051a9:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	ff 75 08             	pushl  0x8(%ebp)
801051b6:	e8 57 fd ff ff       	call   80104f12 <wakeup>
801051bb:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
801051be:	8b 45 08             	mov    0x8(%ebp),%eax
801051c1:	83 c0 04             	add    $0x4,%eax
801051c4:	83 ec 0c             	sub    $0xc,%esp
801051c7:	50                   	push   %eax
801051c8:	e8 37 01 00 00       	call   80105304 <release>
801051cd:	83 c4 10             	add    $0x10,%esp
}
801051d0:	90                   	nop
801051d1:	c9                   	leave  
801051d2:	c3                   	ret    

801051d3 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801051d3:	f3 0f 1e fb          	endbr32 
801051d7:	55                   	push   %ebp
801051d8:	89 e5                	mov    %esp,%ebp
801051da:	53                   	push   %ebx
801051db:	83 ec 14             	sub    $0x14,%esp
  int r;
  
  acquire(&lk->lk);
801051de:	8b 45 08             	mov    0x8(%ebp),%eax
801051e1:	83 c0 04             	add    $0x4,%eax
801051e4:	83 ec 0c             	sub    $0xc,%esp
801051e7:	50                   	push   %eax
801051e8:	e8 a5 00 00 00       	call   80105292 <acquire>
801051ed:	83 c4 10             	add    $0x10,%esp
  r = lk->locked && (lk->pid == myproc()->pid);
801051f0:	8b 45 08             	mov    0x8(%ebp),%eax
801051f3:	8b 00                	mov    (%eax),%eax
801051f5:	85 c0                	test   %eax,%eax
801051f7:	74 19                	je     80105212 <holdingsleep+0x3f>
801051f9:	8b 45 08             	mov    0x8(%ebp),%eax
801051fc:	8b 58 3c             	mov    0x3c(%eax),%ebx
801051ff:	e8 bc f2 ff ff       	call   801044c0 <myproc>
80105204:	8b 40 10             	mov    0x10(%eax),%eax
80105207:	39 c3                	cmp    %eax,%ebx
80105209:	75 07                	jne    80105212 <holdingsleep+0x3f>
8010520b:	b8 01 00 00 00       	mov    $0x1,%eax
80105210:	eb 05                	jmp    80105217 <holdingsleep+0x44>
80105212:	b8 00 00 00 00       	mov    $0x0,%eax
80105217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
8010521a:	8b 45 08             	mov    0x8(%ebp),%eax
8010521d:	83 c0 04             	add    $0x4,%eax
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	50                   	push   %eax
80105224:	e8 db 00 00 00       	call   80105304 <release>
80105229:	83 c4 10             	add    $0x10,%esp
  return r;
8010522c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010522f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105232:	c9                   	leave  
80105233:	c3                   	ret    

80105234 <readeflags>:
{
80105234:	55                   	push   %ebp
80105235:	89 e5                	mov    %esp,%ebp
80105237:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010523a:	9c                   	pushf  
8010523b:	58                   	pop    %eax
8010523c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010523f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105242:	c9                   	leave  
80105243:	c3                   	ret    

80105244 <cli>:
{
80105244:	55                   	push   %ebp
80105245:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105247:	fa                   	cli    
}
80105248:	90                   	nop
80105249:	5d                   	pop    %ebp
8010524a:	c3                   	ret    

8010524b <sti>:
{
8010524b:	55                   	push   %ebp
8010524c:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010524e:	fb                   	sti    
}
8010524f:	90                   	nop
80105250:	5d                   	pop    %ebp
80105251:	c3                   	ret    

80105252 <xchg>:
{
80105252:	55                   	push   %ebp
80105253:	89 e5                	mov    %esp,%ebp
80105255:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80105258:	8b 55 08             	mov    0x8(%ebp),%edx
8010525b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010525e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105261:	f0 87 02             	lock xchg %eax,(%edx)
80105264:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80105267:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010526a:	c9                   	leave  
8010526b:	c3                   	ret    

8010526c <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010526c:	f3 0f 1e fb          	endbr32 
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105273:	8b 45 08             	mov    0x8(%ebp),%eax
80105276:	8b 55 0c             	mov    0xc(%ebp),%edx
80105279:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010527c:	8b 45 08             	mov    0x8(%ebp),%eax
8010527f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105285:	8b 45 08             	mov    0x8(%ebp),%eax
80105288:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010528f:	90                   	nop
80105290:	5d                   	pop    %ebp
80105291:	c3                   	ret    

80105292 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105292:	f3 0f 1e fb          	endbr32 
80105296:	55                   	push   %ebp
80105297:	89 e5                	mov    %esp,%ebp
80105299:	53                   	push   %ebx
8010529a:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010529d:	e8 7c 01 00 00       	call   8010541e <pushcli>
  if(holding(lk))
801052a2:	8b 45 08             	mov    0x8(%ebp),%eax
801052a5:	83 ec 0c             	sub    $0xc,%esp
801052a8:	50                   	push   %eax
801052a9:	e8 2b 01 00 00       	call   801053d9 <holding>
801052ae:	83 c4 10             	add    $0x10,%esp
801052b1:	85 c0                	test   %eax,%eax
801052b3:	74 0d                	je     801052c2 <acquire+0x30>
    panic("acquire");
801052b5:	83 ec 0c             	sub    $0xc,%esp
801052b8:	68 a6 95 10 80       	push   $0x801095a6
801052bd:	e8 46 b3 ff ff       	call   80100608 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801052c2:	90                   	nop
801052c3:	8b 45 08             	mov    0x8(%ebp),%eax
801052c6:	83 ec 08             	sub    $0x8,%esp
801052c9:	6a 01                	push   $0x1
801052cb:	50                   	push   %eax
801052cc:	e8 81 ff ff ff       	call   80105252 <xchg>
801052d1:	83 c4 10             	add    $0x10,%esp
801052d4:	85 c0                	test   %eax,%eax
801052d6:	75 eb                	jne    801052c3 <acquire+0x31>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801052d8:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801052dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801052e0:	e8 5f f1 ff ff       	call   80104444 <mycpu>
801052e5:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801052e8:	8b 45 08             	mov    0x8(%ebp),%eax
801052eb:	83 c0 0c             	add    $0xc,%eax
801052ee:	83 ec 08             	sub    $0x8,%esp
801052f1:	50                   	push   %eax
801052f2:	8d 45 08             	lea    0x8(%ebp),%eax
801052f5:	50                   	push   %eax
801052f6:	e8 5f 00 00 00       	call   8010535a <getcallerpcs>
801052fb:	83 c4 10             	add    $0x10,%esp
}
801052fe:	90                   	nop
801052ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105302:	c9                   	leave  
80105303:	c3                   	ret    

80105304 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105304:	f3 0f 1e fb          	endbr32 
80105308:	55                   	push   %ebp
80105309:	89 e5                	mov    %esp,%ebp
8010530b:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010530e:	83 ec 0c             	sub    $0xc,%esp
80105311:	ff 75 08             	pushl  0x8(%ebp)
80105314:	e8 c0 00 00 00       	call   801053d9 <holding>
80105319:	83 c4 10             	add    $0x10,%esp
8010531c:	85 c0                	test   %eax,%eax
8010531e:	75 0d                	jne    8010532d <release+0x29>
    panic("release");
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	68 ae 95 10 80       	push   $0x801095ae
80105328:	e8 db b2 ff ff       	call   80100608 <panic>

  lk->pcs[0] = 0;
8010532d:	8b 45 08             	mov    0x8(%ebp),%eax
80105330:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105337:	8b 45 08             	mov    0x8(%ebp),%eax
8010533a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105341:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105346:	8b 45 08             	mov    0x8(%ebp),%eax
80105349:	8b 55 08             	mov    0x8(%ebp),%edx
8010534c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80105352:	e8 18 01 00 00       	call   8010546f <popcli>
}
80105357:	90                   	nop
80105358:	c9                   	leave  
80105359:	c3                   	ret    

8010535a <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010535a:	f3 0f 1e fb          	endbr32 
8010535e:	55                   	push   %ebp
8010535f:	89 e5                	mov    %esp,%ebp
80105361:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105364:	8b 45 08             	mov    0x8(%ebp),%eax
80105367:	83 e8 08             	sub    $0x8,%eax
8010536a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010536d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105374:	eb 38                	jmp    801053ae <getcallerpcs+0x54>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105376:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010537a:	74 53                	je     801053cf <getcallerpcs+0x75>
8010537c:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105383:	76 4a                	jbe    801053cf <getcallerpcs+0x75>
80105385:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105389:	74 44                	je     801053cf <getcallerpcs+0x75>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010538b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010538e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105395:	8b 45 0c             	mov    0xc(%ebp),%eax
80105398:	01 c2                	add    %eax,%edx
8010539a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010539d:	8b 40 04             	mov    0x4(%eax),%eax
801053a0:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801053a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053a5:	8b 00                	mov    (%eax),%eax
801053a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801053aa:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053ae:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053b2:	7e c2                	jle    80105376 <getcallerpcs+0x1c>
  }
  for(; i < 10; i++)
801053b4:	eb 19                	jmp    801053cf <getcallerpcs+0x75>
    pcs[i] = 0;
801053b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801053c3:	01 d0                	add    %edx,%eax
801053c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801053cb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053cf:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053d3:	7e e1                	jle    801053b6 <getcallerpcs+0x5c>
}
801053d5:	90                   	nop
801053d6:	90                   	nop
801053d7:	c9                   	leave  
801053d8:	c3                   	ret    

801053d9 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801053d9:	f3 0f 1e fb          	endbr32 
801053dd:	55                   	push   %ebp
801053de:	89 e5                	mov    %esp,%ebp
801053e0:	53                   	push   %ebx
801053e1:	83 ec 14             	sub    $0x14,%esp
  int r;
  pushcli();
801053e4:	e8 35 00 00 00       	call   8010541e <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801053e9:	8b 45 08             	mov    0x8(%ebp),%eax
801053ec:	8b 00                	mov    (%eax),%eax
801053ee:	85 c0                	test   %eax,%eax
801053f0:	74 16                	je     80105408 <holding+0x2f>
801053f2:	8b 45 08             	mov    0x8(%ebp),%eax
801053f5:	8b 58 08             	mov    0x8(%eax),%ebx
801053f8:	e8 47 f0 ff ff       	call   80104444 <mycpu>
801053fd:	39 c3                	cmp    %eax,%ebx
801053ff:	75 07                	jne    80105408 <holding+0x2f>
80105401:	b8 01 00 00 00       	mov    $0x1,%eax
80105406:	eb 05                	jmp    8010540d <holding+0x34>
80105408:	b8 00 00 00 00       	mov    $0x0,%eax
8010540d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
80105410:	e8 5a 00 00 00       	call   8010546f <popcli>
  return r;
80105415:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105418:	83 c4 14             	add    $0x14,%esp
8010541b:	5b                   	pop    %ebx
8010541c:	5d                   	pop    %ebp
8010541d:	c3                   	ret    

8010541e <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010541e:	f3 0f 1e fb          	endbr32 
80105422:	55                   	push   %ebp
80105423:	89 e5                	mov    %esp,%ebp
80105425:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80105428:	e8 07 fe ff ff       	call   80105234 <readeflags>
8010542d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80105430:	e8 0f fe ff ff       	call   80105244 <cli>
  if(mycpu()->ncli == 0)
80105435:	e8 0a f0 ff ff       	call   80104444 <mycpu>
8010543a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105440:	85 c0                	test   %eax,%eax
80105442:	75 14                	jne    80105458 <pushcli+0x3a>
    mycpu()->intena = eflags & FL_IF;
80105444:	e8 fb ef ff ff       	call   80104444 <mycpu>
80105449:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010544c:	81 e2 00 02 00 00    	and    $0x200,%edx
80105452:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80105458:	e8 e7 ef ff ff       	call   80104444 <mycpu>
8010545d:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105463:	83 c2 01             	add    $0x1,%edx
80105466:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
8010546c:	90                   	nop
8010546d:	c9                   	leave  
8010546e:	c3                   	ret    

8010546f <popcli>:

void
popcli(void)
{
8010546f:	f3 0f 1e fb          	endbr32 
80105473:	55                   	push   %ebp
80105474:	89 e5                	mov    %esp,%ebp
80105476:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105479:	e8 b6 fd ff ff       	call   80105234 <readeflags>
8010547e:	25 00 02 00 00       	and    $0x200,%eax
80105483:	85 c0                	test   %eax,%eax
80105485:	74 0d                	je     80105494 <popcli+0x25>
    panic("popcli - interruptible");
80105487:	83 ec 0c             	sub    $0xc,%esp
8010548a:	68 b6 95 10 80       	push   $0x801095b6
8010548f:	e8 74 b1 ff ff       	call   80100608 <panic>
  if(--mycpu()->ncli < 0)
80105494:	e8 ab ef ff ff       	call   80104444 <mycpu>
80105499:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010549f:	83 ea 01             	sub    $0x1,%edx
801054a2:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801054a8:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801054ae:	85 c0                	test   %eax,%eax
801054b0:	79 0d                	jns    801054bf <popcli+0x50>
    panic("popcli");
801054b2:	83 ec 0c             	sub    $0xc,%esp
801054b5:	68 cd 95 10 80       	push   $0x801095cd
801054ba:	e8 49 b1 ff ff       	call   80100608 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
801054bf:	e8 80 ef ff ff       	call   80104444 <mycpu>
801054c4:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801054ca:	85 c0                	test   %eax,%eax
801054cc:	75 14                	jne    801054e2 <popcli+0x73>
801054ce:	e8 71 ef ff ff       	call   80104444 <mycpu>
801054d3:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801054d9:	85 c0                	test   %eax,%eax
801054db:	74 05                	je     801054e2 <popcli+0x73>
    sti();
801054dd:	e8 69 fd ff ff       	call   8010524b <sti>
}
801054e2:	90                   	nop
801054e3:	c9                   	leave  
801054e4:	c3                   	ret    

801054e5 <stosb>:
{
801054e5:	55                   	push   %ebp
801054e6:	89 e5                	mov    %esp,%ebp
801054e8:	57                   	push   %edi
801054e9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801054ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054ed:	8b 55 10             	mov    0x10(%ebp),%edx
801054f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801054f3:	89 cb                	mov    %ecx,%ebx
801054f5:	89 df                	mov    %ebx,%edi
801054f7:	89 d1                	mov    %edx,%ecx
801054f9:	fc                   	cld    
801054fa:	f3 aa                	rep stos %al,%es:(%edi)
801054fc:	89 ca                	mov    %ecx,%edx
801054fe:	89 fb                	mov    %edi,%ebx
80105500:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105503:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105506:	90                   	nop
80105507:	5b                   	pop    %ebx
80105508:	5f                   	pop    %edi
80105509:	5d                   	pop    %ebp
8010550a:	c3                   	ret    

8010550b <stosl>:
{
8010550b:	55                   	push   %ebp
8010550c:	89 e5                	mov    %esp,%ebp
8010550e:	57                   	push   %edi
8010550f:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105510:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105513:	8b 55 10             	mov    0x10(%ebp),%edx
80105516:	8b 45 0c             	mov    0xc(%ebp),%eax
80105519:	89 cb                	mov    %ecx,%ebx
8010551b:	89 df                	mov    %ebx,%edi
8010551d:	89 d1                	mov    %edx,%ecx
8010551f:	fc                   	cld    
80105520:	f3 ab                	rep stos %eax,%es:(%edi)
80105522:	89 ca                	mov    %ecx,%edx
80105524:	89 fb                	mov    %edi,%ebx
80105526:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105529:	89 55 10             	mov    %edx,0x10(%ebp)
}
8010552c:	90                   	nop
8010552d:	5b                   	pop    %ebx
8010552e:	5f                   	pop    %edi
8010552f:	5d                   	pop    %ebp
80105530:	c3                   	ret    

80105531 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105531:	f3 0f 1e fb          	endbr32 
80105535:	55                   	push   %ebp
80105536:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105538:	8b 45 08             	mov    0x8(%ebp),%eax
8010553b:	83 e0 03             	and    $0x3,%eax
8010553e:	85 c0                	test   %eax,%eax
80105540:	75 43                	jne    80105585 <memset+0x54>
80105542:	8b 45 10             	mov    0x10(%ebp),%eax
80105545:	83 e0 03             	and    $0x3,%eax
80105548:	85 c0                	test   %eax,%eax
8010554a:	75 39                	jne    80105585 <memset+0x54>
    c &= 0xFF;
8010554c:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105553:	8b 45 10             	mov    0x10(%ebp),%eax
80105556:	c1 e8 02             	shr    $0x2,%eax
80105559:	89 c1                	mov    %eax,%ecx
8010555b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010555e:	c1 e0 18             	shl    $0x18,%eax
80105561:	89 c2                	mov    %eax,%edx
80105563:	8b 45 0c             	mov    0xc(%ebp),%eax
80105566:	c1 e0 10             	shl    $0x10,%eax
80105569:	09 c2                	or     %eax,%edx
8010556b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010556e:	c1 e0 08             	shl    $0x8,%eax
80105571:	09 d0                	or     %edx,%eax
80105573:	0b 45 0c             	or     0xc(%ebp),%eax
80105576:	51                   	push   %ecx
80105577:	50                   	push   %eax
80105578:	ff 75 08             	pushl  0x8(%ebp)
8010557b:	e8 8b ff ff ff       	call   8010550b <stosl>
80105580:	83 c4 0c             	add    $0xc,%esp
80105583:	eb 12                	jmp    80105597 <memset+0x66>
  } else
    stosb(dst, c, n);
80105585:	8b 45 10             	mov    0x10(%ebp),%eax
80105588:	50                   	push   %eax
80105589:	ff 75 0c             	pushl  0xc(%ebp)
8010558c:	ff 75 08             	pushl  0x8(%ebp)
8010558f:	e8 51 ff ff ff       	call   801054e5 <stosb>
80105594:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105597:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010559a:	c9                   	leave  
8010559b:	c3                   	ret    

8010559c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010559c:	f3 0f 1e fb          	endbr32 
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
801055a6:	8b 45 08             	mov    0x8(%ebp),%eax
801055a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801055ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801055af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801055b2:	eb 30                	jmp    801055e4 <memcmp+0x48>
    if(*s1 != *s2)
801055b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055b7:	0f b6 10             	movzbl (%eax),%edx
801055ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055bd:	0f b6 00             	movzbl (%eax),%eax
801055c0:	38 c2                	cmp    %al,%dl
801055c2:	74 18                	je     801055dc <memcmp+0x40>
      return *s1 - *s2;
801055c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055c7:	0f b6 00             	movzbl (%eax),%eax
801055ca:	0f b6 d0             	movzbl %al,%edx
801055cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055d0:	0f b6 00             	movzbl (%eax),%eax
801055d3:	0f b6 c0             	movzbl %al,%eax
801055d6:	29 c2                	sub    %eax,%edx
801055d8:	89 d0                	mov    %edx,%eax
801055da:	eb 1a                	jmp    801055f6 <memcmp+0x5a>
    s1++, s2++;
801055dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801055e0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
801055e4:	8b 45 10             	mov    0x10(%ebp),%eax
801055e7:	8d 50 ff             	lea    -0x1(%eax),%edx
801055ea:	89 55 10             	mov    %edx,0x10(%ebp)
801055ed:	85 c0                	test   %eax,%eax
801055ef:	75 c3                	jne    801055b4 <memcmp+0x18>
  }

  return 0;
801055f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055f6:	c9                   	leave  
801055f7:	c3                   	ret    

801055f8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801055f8:	f3 0f 1e fb          	endbr32 
801055fc:	55                   	push   %ebp
801055fd:	89 e5                	mov    %esp,%ebp
801055ff:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105602:	8b 45 0c             	mov    0xc(%ebp),%eax
80105605:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105608:	8b 45 08             	mov    0x8(%ebp),%eax
8010560b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010560e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105611:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105614:	73 54                	jae    8010566a <memmove+0x72>
80105616:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105619:	8b 45 10             	mov    0x10(%ebp),%eax
8010561c:	01 d0                	add    %edx,%eax
8010561e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80105621:	73 47                	jae    8010566a <memmove+0x72>
    s += n;
80105623:	8b 45 10             	mov    0x10(%ebp),%eax
80105626:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105629:	8b 45 10             	mov    0x10(%ebp),%eax
8010562c:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010562f:	eb 13                	jmp    80105644 <memmove+0x4c>
      *--d = *--s;
80105631:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105635:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105639:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010563c:	0f b6 10             	movzbl (%eax),%edx
8010563f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105642:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105644:	8b 45 10             	mov    0x10(%ebp),%eax
80105647:	8d 50 ff             	lea    -0x1(%eax),%edx
8010564a:	89 55 10             	mov    %edx,0x10(%ebp)
8010564d:	85 c0                	test   %eax,%eax
8010564f:	75 e0                	jne    80105631 <memmove+0x39>
  if(s < d && s + n > d){
80105651:	eb 24                	jmp    80105677 <memmove+0x7f>
  } else
    while(n-- > 0)
      *d++ = *s++;
80105653:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105656:	8d 42 01             	lea    0x1(%edx),%eax
80105659:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010565c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010565f:	8d 48 01             	lea    0x1(%eax),%ecx
80105662:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80105665:	0f b6 12             	movzbl (%edx),%edx
80105668:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010566a:	8b 45 10             	mov    0x10(%ebp),%eax
8010566d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105670:	89 55 10             	mov    %edx,0x10(%ebp)
80105673:	85 c0                	test   %eax,%eax
80105675:	75 dc                	jne    80105653 <memmove+0x5b>

  return dst;
80105677:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010567a:	c9                   	leave  
8010567b:	c3                   	ret    

8010567c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010567c:	f3 0f 1e fb          	endbr32 
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105683:	ff 75 10             	pushl  0x10(%ebp)
80105686:	ff 75 0c             	pushl  0xc(%ebp)
80105689:	ff 75 08             	pushl  0x8(%ebp)
8010568c:	e8 67 ff ff ff       	call   801055f8 <memmove>
80105691:	83 c4 0c             	add    $0xc,%esp
}
80105694:	c9                   	leave  
80105695:	c3                   	ret    

80105696 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105696:	f3 0f 1e fb          	endbr32 
8010569a:	55                   	push   %ebp
8010569b:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010569d:	eb 0c                	jmp    801056ab <strncmp+0x15>
    n--, p++, q++;
8010569f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801056a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801056a7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
801056ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056af:	74 1a                	je     801056cb <strncmp+0x35>
801056b1:	8b 45 08             	mov    0x8(%ebp),%eax
801056b4:	0f b6 00             	movzbl (%eax),%eax
801056b7:	84 c0                	test   %al,%al
801056b9:	74 10                	je     801056cb <strncmp+0x35>
801056bb:	8b 45 08             	mov    0x8(%ebp),%eax
801056be:	0f b6 10             	movzbl (%eax),%edx
801056c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801056c4:	0f b6 00             	movzbl (%eax),%eax
801056c7:	38 c2                	cmp    %al,%dl
801056c9:	74 d4                	je     8010569f <strncmp+0x9>
  if(n == 0)
801056cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056cf:	75 07                	jne    801056d8 <strncmp+0x42>
    return 0;
801056d1:	b8 00 00 00 00       	mov    $0x0,%eax
801056d6:	eb 16                	jmp    801056ee <strncmp+0x58>
  return (uchar)*p - (uchar)*q;
801056d8:	8b 45 08             	mov    0x8(%ebp),%eax
801056db:	0f b6 00             	movzbl (%eax),%eax
801056de:	0f b6 d0             	movzbl %al,%edx
801056e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801056e4:	0f b6 00             	movzbl (%eax),%eax
801056e7:	0f b6 c0             	movzbl %al,%eax
801056ea:	29 c2                	sub    %eax,%edx
801056ec:	89 d0                	mov    %edx,%eax
}
801056ee:	5d                   	pop    %ebp
801056ef:	c3                   	ret    

801056f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801056f0:	f3 0f 1e fb          	endbr32 
801056f4:	55                   	push   %ebp
801056f5:	89 e5                	mov    %esp,%ebp
801056f7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801056fa:	8b 45 08             	mov    0x8(%ebp),%eax
801056fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105700:	90                   	nop
80105701:	8b 45 10             	mov    0x10(%ebp),%eax
80105704:	8d 50 ff             	lea    -0x1(%eax),%edx
80105707:	89 55 10             	mov    %edx,0x10(%ebp)
8010570a:	85 c0                	test   %eax,%eax
8010570c:	7e 2c                	jle    8010573a <strncpy+0x4a>
8010570e:	8b 55 0c             	mov    0xc(%ebp),%edx
80105711:	8d 42 01             	lea    0x1(%edx),%eax
80105714:	89 45 0c             	mov    %eax,0xc(%ebp)
80105717:	8b 45 08             	mov    0x8(%ebp),%eax
8010571a:	8d 48 01             	lea    0x1(%eax),%ecx
8010571d:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105720:	0f b6 12             	movzbl (%edx),%edx
80105723:	88 10                	mov    %dl,(%eax)
80105725:	0f b6 00             	movzbl (%eax),%eax
80105728:	84 c0                	test   %al,%al
8010572a:	75 d5                	jne    80105701 <strncpy+0x11>
    ;
  while(n-- > 0)
8010572c:	eb 0c                	jmp    8010573a <strncpy+0x4a>
    *s++ = 0;
8010572e:	8b 45 08             	mov    0x8(%ebp),%eax
80105731:	8d 50 01             	lea    0x1(%eax),%edx
80105734:	89 55 08             	mov    %edx,0x8(%ebp)
80105737:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
8010573a:	8b 45 10             	mov    0x10(%ebp),%eax
8010573d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105740:	89 55 10             	mov    %edx,0x10(%ebp)
80105743:	85 c0                	test   %eax,%eax
80105745:	7f e7                	jg     8010572e <strncpy+0x3e>
  return os;
80105747:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010574a:	c9                   	leave  
8010574b:	c3                   	ret    

8010574c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010574c:	f3 0f 1e fb          	endbr32 
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105756:	8b 45 08             	mov    0x8(%ebp),%eax
80105759:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010575c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105760:	7f 05                	jg     80105767 <safestrcpy+0x1b>
    return os;
80105762:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105765:	eb 31                	jmp    80105798 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
80105767:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010576b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010576f:	7e 1e                	jle    8010578f <safestrcpy+0x43>
80105771:	8b 55 0c             	mov    0xc(%ebp),%edx
80105774:	8d 42 01             	lea    0x1(%edx),%eax
80105777:	89 45 0c             	mov    %eax,0xc(%ebp)
8010577a:	8b 45 08             	mov    0x8(%ebp),%eax
8010577d:	8d 48 01             	lea    0x1(%eax),%ecx
80105780:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105783:	0f b6 12             	movzbl (%edx),%edx
80105786:	88 10                	mov    %dl,(%eax)
80105788:	0f b6 00             	movzbl (%eax),%eax
8010578b:	84 c0                	test   %al,%al
8010578d:	75 d8                	jne    80105767 <safestrcpy+0x1b>
    ;
  *s = 0;
8010578f:	8b 45 08             	mov    0x8(%ebp),%eax
80105792:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105795:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105798:	c9                   	leave  
80105799:	c3                   	ret    

8010579a <strlen>:

int
strlen(const char *s)
{
8010579a:	f3 0f 1e fb          	endbr32 
8010579e:	55                   	push   %ebp
8010579f:	89 e5                	mov    %esp,%ebp
801057a1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801057a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801057ab:	eb 04                	jmp    801057b1 <strlen+0x17>
801057ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801057b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057b4:	8b 45 08             	mov    0x8(%ebp),%eax
801057b7:	01 d0                	add    %edx,%eax
801057b9:	0f b6 00             	movzbl (%eax),%eax
801057bc:	84 c0                	test   %al,%al
801057be:	75 ed                	jne    801057ad <strlen+0x13>
    ;
  return n;
801057c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801057c3:	c9                   	leave  
801057c4:	c3                   	ret    

801057c5 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801057c5:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801057c9:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801057cd:	55                   	push   %ebp
  pushl %ebx
801057ce:	53                   	push   %ebx
  pushl %esi
801057cf:	56                   	push   %esi
  pushl %edi
801057d0:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801057d1:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801057d3:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801057d5:	5f                   	pop    %edi
  popl %esi
801057d6:	5e                   	pop    %esi
  popl %ebx
801057d7:	5b                   	pop    %ebx
  popl %ebp
801057d8:	5d                   	pop    %ebp
  ret
801057d9:	c3                   	ret    

801057da <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801057da:	f3 0f 1e fb          	endbr32 
801057de:	55                   	push   %ebp
801057df:	89 e5                	mov    %esp,%ebp
801057e1:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
801057e4:	e8 d7 ec ff ff       	call   801044c0 <myproc>
801057e9:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801057ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ef:	8b 00                	mov    (%eax),%eax
801057f1:	39 45 08             	cmp    %eax,0x8(%ebp)
801057f4:	73 0f                	jae    80105805 <fetchint+0x2b>
801057f6:	8b 45 08             	mov    0x8(%ebp),%eax
801057f9:	8d 50 04             	lea    0x4(%eax),%edx
801057fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ff:	8b 00                	mov    (%eax),%eax
80105801:	39 c2                	cmp    %eax,%edx
80105803:	76 07                	jbe    8010580c <fetchint+0x32>
    return -1;
80105805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580a:	eb 0f                	jmp    8010581b <fetchint+0x41>
  *ip = *(int*)(addr);
8010580c:	8b 45 08             	mov    0x8(%ebp),%eax
8010580f:	8b 10                	mov    (%eax),%edx
80105811:	8b 45 0c             	mov    0xc(%ebp),%eax
80105814:	89 10                	mov    %edx,(%eax)
  return 0;
80105816:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010581b:	c9                   	leave  
8010581c:	c3                   	ret    

8010581d <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010581d:	f3 0f 1e fb          	endbr32 
80105821:	55                   	push   %ebp
80105822:	89 e5                	mov    %esp,%ebp
80105824:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105827:	e8 94 ec ff ff       	call   801044c0 <myproc>
8010582c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
8010582f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105832:	8b 00                	mov    (%eax),%eax
80105834:	39 45 08             	cmp    %eax,0x8(%ebp)
80105837:	72 07                	jb     80105840 <fetchstr+0x23>
    return -1;
80105839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583e:	eb 43                	jmp    80105883 <fetchstr+0x66>
  *pp = (char*)addr;
80105840:	8b 55 08             	mov    0x8(%ebp),%edx
80105843:	8b 45 0c             	mov    0xc(%ebp),%eax
80105846:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105848:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010584b:	8b 00                	mov    (%eax),%eax
8010584d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80105850:	8b 45 0c             	mov    0xc(%ebp),%eax
80105853:	8b 00                	mov    (%eax),%eax
80105855:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105858:	eb 1c                	jmp    80105876 <fetchstr+0x59>
    if(*s == 0)
8010585a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585d:	0f b6 00             	movzbl (%eax),%eax
80105860:	84 c0                	test   %al,%al
80105862:	75 0e                	jne    80105872 <fetchstr+0x55>
      return s - *pp;
80105864:	8b 45 0c             	mov    0xc(%ebp),%eax
80105867:	8b 00                	mov    (%eax),%eax
80105869:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010586c:	29 c2                	sub    %eax,%edx
8010586e:	89 d0                	mov    %edx,%eax
80105870:	eb 11                	jmp    80105883 <fetchstr+0x66>
  for(s = *pp; s < ep; s++){
80105872:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105879:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010587c:	72 dc                	jb     8010585a <fetchstr+0x3d>
  }
  return -1;
8010587e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105883:	c9                   	leave  
80105884:	c3                   	ret    

80105885 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105885:	f3 0f 1e fb          	endbr32 
80105889:	55                   	push   %ebp
8010588a:	89 e5                	mov    %esp,%ebp
8010588c:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010588f:	e8 2c ec ff ff       	call   801044c0 <myproc>
80105894:	8b 40 18             	mov    0x18(%eax),%eax
80105897:	8b 40 44             	mov    0x44(%eax),%eax
8010589a:	8b 55 08             	mov    0x8(%ebp),%edx
8010589d:	c1 e2 02             	shl    $0x2,%edx
801058a0:	01 d0                	add    %edx,%eax
801058a2:	83 c0 04             	add    $0x4,%eax
801058a5:	83 ec 08             	sub    $0x8,%esp
801058a8:	ff 75 0c             	pushl  0xc(%ebp)
801058ab:	50                   	push   %eax
801058ac:	e8 29 ff ff ff       	call   801057da <fetchint>
801058b1:	83 c4 10             	add    $0x10,%esp
}
801058b4:	c9                   	leave  
801058b5:	c3                   	ret    

801058b6 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801058b6:	f3 0f 1e fb          	endbr32 
801058ba:	55                   	push   %ebp
801058bb:	89 e5                	mov    %esp,%ebp
801058bd:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
801058c0:	e8 fb eb ff ff       	call   801044c0 <myproc>
801058c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
801058c8:	83 ec 08             	sub    $0x8,%esp
801058cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058ce:	50                   	push   %eax
801058cf:	ff 75 08             	pushl  0x8(%ebp)
801058d2:	e8 ae ff ff ff       	call   80105885 <argint>
801058d7:	83 c4 10             	add    $0x10,%esp
801058da:	85 c0                	test   %eax,%eax
801058dc:	79 07                	jns    801058e5 <argptr+0x2f>
    return -1;
801058de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e3:	eb 3b                	jmp    80105920 <argptr+0x6a>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801058e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058e9:	78 1f                	js     8010590a <argptr+0x54>
801058eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ee:	8b 00                	mov    (%eax),%eax
801058f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058f3:	39 d0                	cmp    %edx,%eax
801058f5:	76 13                	jbe    8010590a <argptr+0x54>
801058f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058fa:	89 c2                	mov    %eax,%edx
801058fc:	8b 45 10             	mov    0x10(%ebp),%eax
801058ff:	01 c2                	add    %eax,%edx
80105901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105904:	8b 00                	mov    (%eax),%eax
80105906:	39 c2                	cmp    %eax,%edx
80105908:	76 07                	jbe    80105911 <argptr+0x5b>
    return -1;
8010590a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590f:	eb 0f                	jmp    80105920 <argptr+0x6a>
  *pp = (char*)i;
80105911:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105914:	89 c2                	mov    %eax,%edx
80105916:	8b 45 0c             	mov    0xc(%ebp),%eax
80105919:	89 10                	mov    %edx,(%eax)
  return 0;
8010591b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105920:	c9                   	leave  
80105921:	c3                   	ret    

80105922 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105922:	f3 0f 1e fb          	endbr32 
80105926:	55                   	push   %ebp
80105927:	89 e5                	mov    %esp,%ebp
80105929:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010592c:	83 ec 08             	sub    $0x8,%esp
8010592f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105932:	50                   	push   %eax
80105933:	ff 75 08             	pushl  0x8(%ebp)
80105936:	e8 4a ff ff ff       	call   80105885 <argint>
8010593b:	83 c4 10             	add    $0x10,%esp
8010593e:	85 c0                	test   %eax,%eax
80105940:	79 07                	jns    80105949 <argstr+0x27>
    return -1;
80105942:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105947:	eb 12                	jmp    8010595b <argstr+0x39>
  return fetchstr(addr, pp);
80105949:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010594c:	83 ec 08             	sub    $0x8,%esp
8010594f:	ff 75 0c             	pushl  0xc(%ebp)
80105952:	50                   	push   %eax
80105953:	e8 c5 fe ff ff       	call   8010581d <fetchstr>
80105958:	83 c4 10             	add    $0x10,%esp
}
8010595b:	c9                   	leave  
8010595c:	c3                   	ret    

8010595d <syscall>:
[SYS_dump_rawphymem] sys_dump_rawphymem,
};

void
syscall(void)
{
8010595d:	f3 0f 1e fb          	endbr32 
80105961:	55                   	push   %ebp
80105962:	89 e5                	mov    %esp,%ebp
80105964:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80105967:	e8 54 eb ff ff       	call   801044c0 <myproc>
8010596c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
8010596f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105972:	8b 40 18             	mov    0x18(%eax),%eax
80105975:	8b 40 1c             	mov    0x1c(%eax),%eax
80105978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010597b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010597f:	7e 2f                	jle    801059b0 <syscall+0x53>
80105981:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105984:	83 f8 18             	cmp    $0x18,%eax
80105987:	77 27                	ja     801059b0 <syscall+0x53>
80105989:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010598c:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
80105993:	85 c0                	test   %eax,%eax
80105995:	74 19                	je     801059b0 <syscall+0x53>
    curproc->tf->eax = syscalls[num]();
80105997:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010599a:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
801059a1:	ff d0                	call   *%eax
801059a3:	89 c2                	mov    %eax,%edx
801059a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a8:	8b 40 18             	mov    0x18(%eax),%eax
801059ab:	89 50 1c             	mov    %edx,0x1c(%eax)
801059ae:	eb 2c                	jmp    801059dc <syscall+0x7f>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801059b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b3:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
801059b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b9:	8b 40 10             	mov    0x10(%eax),%eax
801059bc:	ff 75 f0             	pushl  -0x10(%ebp)
801059bf:	52                   	push   %edx
801059c0:	50                   	push   %eax
801059c1:	68 d4 95 10 80       	push   $0x801095d4
801059c6:	e8 4d aa ff ff       	call   80100418 <cprintf>
801059cb:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
801059ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d1:	8b 40 18             	mov    0x18(%eax),%eax
801059d4:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801059db:	90                   	nop
801059dc:	90                   	nop
801059dd:	c9                   	leave  
801059de:	c3                   	ret    

801059df <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801059df:	f3 0f 1e fb          	endbr32 
801059e3:	55                   	push   %ebp
801059e4:	89 e5                	mov    %esp,%ebp
801059e6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801059e9:	83 ec 08             	sub    $0x8,%esp
801059ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ef:	50                   	push   %eax
801059f0:	ff 75 08             	pushl  0x8(%ebp)
801059f3:	e8 8d fe ff ff       	call   80105885 <argint>
801059f8:	83 c4 10             	add    $0x10,%esp
801059fb:	85 c0                	test   %eax,%eax
801059fd:	79 07                	jns    80105a06 <argfd+0x27>
    return -1;
801059ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a04:	eb 4f                	jmp    80105a55 <argfd+0x76>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a09:	85 c0                	test   %eax,%eax
80105a0b:	78 20                	js     80105a2d <argfd+0x4e>
80105a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a10:	83 f8 0f             	cmp    $0xf,%eax
80105a13:	7f 18                	jg     80105a2d <argfd+0x4e>
80105a15:	e8 a6 ea ff ff       	call   801044c0 <myproc>
80105a1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a1d:	83 c2 08             	add    $0x8,%edx
80105a20:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a2b:	75 07                	jne    80105a34 <argfd+0x55>
    return -1;
80105a2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a32:	eb 21                	jmp    80105a55 <argfd+0x76>
  if(pfd)
80105a34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105a38:	74 08                	je     80105a42 <argfd+0x63>
    *pfd = fd;
80105a3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a40:	89 10                	mov    %edx,(%eax)
  if(pf)
80105a42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a46:	74 08                	je     80105a50 <argfd+0x71>
    *pf = f;
80105a48:	8b 45 10             	mov    0x10(%ebp),%eax
80105a4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a4e:	89 10                	mov    %edx,(%eax)
  return 0;
80105a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a55:	c9                   	leave  
80105a56:	c3                   	ret    

80105a57 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105a57:	f3 0f 1e fb          	endbr32 
80105a5b:	55                   	push   %ebp
80105a5c:	89 e5                	mov    %esp,%ebp
80105a5e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105a61:	e8 5a ea ff ff       	call   801044c0 <myproc>
80105a66:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105a69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105a70:	eb 2a                	jmp    80105a9c <fdalloc+0x45>
    if(curproc->ofile[fd] == 0){
80105a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a78:	83 c2 08             	add    $0x8,%edx
80105a7b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a7f:	85 c0                	test   %eax,%eax
80105a81:	75 15                	jne    80105a98 <fdalloc+0x41>
      curproc->ofile[fd] = f;
80105a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a89:	8d 4a 08             	lea    0x8(%edx),%ecx
80105a8c:	8b 55 08             	mov    0x8(%ebp),%edx
80105a8f:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a96:	eb 0f                	jmp    80105aa7 <fdalloc+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105a98:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105a9c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105aa0:	7e d0                	jle    80105a72 <fdalloc+0x1b>
    }
  }
  return -1;
80105aa2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa7:	c9                   	leave  
80105aa8:	c3                   	ret    

80105aa9 <sys_dup>:

int
sys_dup(void)
{
80105aa9:	f3 0f 1e fb          	endbr32 
80105aad:	55                   	push   %ebp
80105aae:	89 e5                	mov    %esp,%ebp
80105ab0:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105ab3:	83 ec 04             	sub    $0x4,%esp
80105ab6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ab9:	50                   	push   %eax
80105aba:	6a 00                	push   $0x0
80105abc:	6a 00                	push   $0x0
80105abe:	e8 1c ff ff ff       	call   801059df <argfd>
80105ac3:	83 c4 10             	add    $0x10,%esp
80105ac6:	85 c0                	test   %eax,%eax
80105ac8:	79 07                	jns    80105ad1 <sys_dup+0x28>
    return -1;
80105aca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105acf:	eb 31                	jmp    80105b02 <sys_dup+0x59>
  if((fd=fdalloc(f)) < 0)
80105ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ad4:	83 ec 0c             	sub    $0xc,%esp
80105ad7:	50                   	push   %eax
80105ad8:	e8 7a ff ff ff       	call   80105a57 <fdalloc>
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ae7:	79 07                	jns    80105af0 <sys_dup+0x47>
    return -1;
80105ae9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aee:	eb 12                	jmp    80105b02 <sys_dup+0x59>
  filedup(f);
80105af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af3:	83 ec 0c             	sub    $0xc,%esp
80105af6:	50                   	push   %eax
80105af7:	e8 3b b6 ff ff       	call   80101137 <filedup>
80105afc:	83 c4 10             	add    $0x10,%esp
  return fd;
80105aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105b02:	c9                   	leave  
80105b03:	c3                   	ret    

80105b04 <sys_read>:

int
sys_read(void)
{
80105b04:	f3 0f 1e fb          	endbr32 
80105b08:	55                   	push   %ebp
80105b09:	89 e5                	mov    %esp,%ebp
80105b0b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b0e:	83 ec 04             	sub    $0x4,%esp
80105b11:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b14:	50                   	push   %eax
80105b15:	6a 00                	push   $0x0
80105b17:	6a 00                	push   $0x0
80105b19:	e8 c1 fe ff ff       	call   801059df <argfd>
80105b1e:	83 c4 10             	add    $0x10,%esp
80105b21:	85 c0                	test   %eax,%eax
80105b23:	78 2e                	js     80105b53 <sys_read+0x4f>
80105b25:	83 ec 08             	sub    $0x8,%esp
80105b28:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b2b:	50                   	push   %eax
80105b2c:	6a 02                	push   $0x2
80105b2e:	e8 52 fd ff ff       	call   80105885 <argint>
80105b33:	83 c4 10             	add    $0x10,%esp
80105b36:	85 c0                	test   %eax,%eax
80105b38:	78 19                	js     80105b53 <sys_read+0x4f>
80105b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b3d:	83 ec 04             	sub    $0x4,%esp
80105b40:	50                   	push   %eax
80105b41:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b44:	50                   	push   %eax
80105b45:	6a 01                	push   $0x1
80105b47:	e8 6a fd ff ff       	call   801058b6 <argptr>
80105b4c:	83 c4 10             	add    $0x10,%esp
80105b4f:	85 c0                	test   %eax,%eax
80105b51:	79 07                	jns    80105b5a <sys_read+0x56>
    return -1;
80105b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b58:	eb 17                	jmp    80105b71 <sys_read+0x6d>
  return fileread(f, p, n);
80105b5a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b63:	83 ec 04             	sub    $0x4,%esp
80105b66:	51                   	push   %ecx
80105b67:	52                   	push   %edx
80105b68:	50                   	push   %eax
80105b69:	e8 65 b7 ff ff       	call   801012d3 <fileread>
80105b6e:	83 c4 10             	add    $0x10,%esp
}
80105b71:	c9                   	leave  
80105b72:	c3                   	ret    

80105b73 <sys_write>:

int
sys_write(void)
{
80105b73:	f3 0f 1e fb          	endbr32 
80105b77:	55                   	push   %ebp
80105b78:	89 e5                	mov    %esp,%ebp
80105b7a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b7d:	83 ec 04             	sub    $0x4,%esp
80105b80:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b83:	50                   	push   %eax
80105b84:	6a 00                	push   $0x0
80105b86:	6a 00                	push   $0x0
80105b88:	e8 52 fe ff ff       	call   801059df <argfd>
80105b8d:	83 c4 10             	add    $0x10,%esp
80105b90:	85 c0                	test   %eax,%eax
80105b92:	78 2e                	js     80105bc2 <sys_write+0x4f>
80105b94:	83 ec 08             	sub    $0x8,%esp
80105b97:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b9a:	50                   	push   %eax
80105b9b:	6a 02                	push   $0x2
80105b9d:	e8 e3 fc ff ff       	call   80105885 <argint>
80105ba2:	83 c4 10             	add    $0x10,%esp
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	78 19                	js     80105bc2 <sys_write+0x4f>
80105ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bac:	83 ec 04             	sub    $0x4,%esp
80105baf:	50                   	push   %eax
80105bb0:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bb3:	50                   	push   %eax
80105bb4:	6a 01                	push   $0x1
80105bb6:	e8 fb fc ff ff       	call   801058b6 <argptr>
80105bbb:	83 c4 10             	add    $0x10,%esp
80105bbe:	85 c0                	test   %eax,%eax
80105bc0:	79 07                	jns    80105bc9 <sys_write+0x56>
    return -1;
80105bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc7:	eb 17                	jmp    80105be0 <sys_write+0x6d>
  return filewrite(f, p, n);
80105bc9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105bcc:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd2:	83 ec 04             	sub    $0x4,%esp
80105bd5:	51                   	push   %ecx
80105bd6:	52                   	push   %edx
80105bd7:	50                   	push   %eax
80105bd8:	e8 b2 b7 ff ff       	call   8010138f <filewrite>
80105bdd:	83 c4 10             	add    $0x10,%esp
}
80105be0:	c9                   	leave  
80105be1:	c3                   	ret    

80105be2 <sys_close>:

int
sys_close(void)
{
80105be2:	f3 0f 1e fb          	endbr32 
80105be6:	55                   	push   %ebp
80105be7:	89 e5                	mov    %esp,%ebp
80105be9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105bec:	83 ec 04             	sub    $0x4,%esp
80105bef:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bf2:	50                   	push   %eax
80105bf3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bf6:	50                   	push   %eax
80105bf7:	6a 00                	push   $0x0
80105bf9:	e8 e1 fd ff ff       	call   801059df <argfd>
80105bfe:	83 c4 10             	add    $0x10,%esp
80105c01:	85 c0                	test   %eax,%eax
80105c03:	79 07                	jns    80105c0c <sys_close+0x2a>
    return -1;
80105c05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0a:	eb 27                	jmp    80105c33 <sys_close+0x51>
  myproc()->ofile[fd] = 0;
80105c0c:	e8 af e8 ff ff       	call   801044c0 <myproc>
80105c11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c14:	83 c2 08             	add    $0x8,%edx
80105c17:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105c1e:	00 
  fileclose(f);
80105c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c22:	83 ec 0c             	sub    $0xc,%esp
80105c25:	50                   	push   %eax
80105c26:	e8 61 b5 ff ff       	call   8010118c <fileclose>
80105c2b:	83 c4 10             	add    $0x10,%esp
  return 0;
80105c2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c33:	c9                   	leave  
80105c34:	c3                   	ret    

80105c35 <sys_fstat>:

int
sys_fstat(void)
{
80105c35:	f3 0f 1e fb          	endbr32 
80105c39:	55                   	push   %ebp
80105c3a:	89 e5                	mov    %esp,%ebp
80105c3c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105c3f:	83 ec 04             	sub    $0x4,%esp
80105c42:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c45:	50                   	push   %eax
80105c46:	6a 00                	push   $0x0
80105c48:	6a 00                	push   $0x0
80105c4a:	e8 90 fd ff ff       	call   801059df <argfd>
80105c4f:	83 c4 10             	add    $0x10,%esp
80105c52:	85 c0                	test   %eax,%eax
80105c54:	78 17                	js     80105c6d <sys_fstat+0x38>
80105c56:	83 ec 04             	sub    $0x4,%esp
80105c59:	6a 14                	push   $0x14
80105c5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c5e:	50                   	push   %eax
80105c5f:	6a 01                	push   $0x1
80105c61:	e8 50 fc ff ff       	call   801058b6 <argptr>
80105c66:	83 c4 10             	add    $0x10,%esp
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	79 07                	jns    80105c74 <sys_fstat+0x3f>
    return -1;
80105c6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c72:	eb 13                	jmp    80105c87 <sys_fstat+0x52>
  return filestat(f, st);
80105c74:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c7a:	83 ec 08             	sub    $0x8,%esp
80105c7d:	52                   	push   %edx
80105c7e:	50                   	push   %eax
80105c7f:	e8 f4 b5 ff ff       	call   80101278 <filestat>
80105c84:	83 c4 10             	add    $0x10,%esp
}
80105c87:	c9                   	leave  
80105c88:	c3                   	ret    

80105c89 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105c89:	f3 0f 1e fb          	endbr32 
80105c8d:	55                   	push   %ebp
80105c8e:	89 e5                	mov    %esp,%ebp
80105c90:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105c93:	83 ec 08             	sub    $0x8,%esp
80105c96:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c99:	50                   	push   %eax
80105c9a:	6a 00                	push   $0x0
80105c9c:	e8 81 fc ff ff       	call   80105922 <argstr>
80105ca1:	83 c4 10             	add    $0x10,%esp
80105ca4:	85 c0                	test   %eax,%eax
80105ca6:	78 15                	js     80105cbd <sys_link+0x34>
80105ca8:	83 ec 08             	sub    $0x8,%esp
80105cab:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105cae:	50                   	push   %eax
80105caf:	6a 01                	push   $0x1
80105cb1:	e8 6c fc ff ff       	call   80105922 <argstr>
80105cb6:	83 c4 10             	add    $0x10,%esp
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	79 0a                	jns    80105cc7 <sys_link+0x3e>
    return -1;
80105cbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc2:	e9 68 01 00 00       	jmp    80105e2f <sys_link+0x1a6>

  begin_op();
80105cc7:	e8 35 da ff ff       	call   80103701 <begin_op>
  if((ip = namei(old)) == 0){
80105ccc:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105ccf:	83 ec 0c             	sub    $0xc,%esp
80105cd2:	50                   	push   %eax
80105cd3:	e8 9f c9 ff ff       	call   80102677 <namei>
80105cd8:	83 c4 10             	add    $0x10,%esp
80105cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ce2:	75 0f                	jne    80105cf3 <sys_link+0x6a>
    end_op();
80105ce4:	e8 a8 da ff ff       	call   80103791 <end_op>
    return -1;
80105ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cee:	e9 3c 01 00 00       	jmp    80105e2f <sys_link+0x1a6>
  }

  ilock(ip);
80105cf3:	83 ec 0c             	sub    $0xc,%esp
80105cf6:	ff 75 f4             	pushl  -0xc(%ebp)
80105cf9:	e8 0e be ff ff       	call   80101b0c <ilock>
80105cfe:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d04:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105d08:	66 83 f8 01          	cmp    $0x1,%ax
80105d0c:	75 1d                	jne    80105d2b <sys_link+0xa2>
    iunlockput(ip);
80105d0e:	83 ec 0c             	sub    $0xc,%esp
80105d11:	ff 75 f4             	pushl  -0xc(%ebp)
80105d14:	e8 30 c0 ff ff       	call   80101d49 <iunlockput>
80105d19:	83 c4 10             	add    $0x10,%esp
    end_op();
80105d1c:	e8 70 da ff ff       	call   80103791 <end_op>
    return -1;
80105d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d26:	e9 04 01 00 00       	jmp    80105e2f <sys_link+0x1a6>
  }

  ip->nlink++;
80105d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105d32:	83 c0 01             	add    $0x1,%eax
80105d35:	89 c2                	mov    %eax,%edx
80105d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d3a:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105d3e:	83 ec 0c             	sub    $0xc,%esp
80105d41:	ff 75 f4             	pushl  -0xc(%ebp)
80105d44:	e8 da bb ff ff       	call   80101923 <iupdate>
80105d49:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105d4c:	83 ec 0c             	sub    $0xc,%esp
80105d4f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d52:	e8 cc be ff ff       	call   80101c23 <iunlock>
80105d57:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105d5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d5d:	83 ec 08             	sub    $0x8,%esp
80105d60:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105d63:	52                   	push   %edx
80105d64:	50                   	push   %eax
80105d65:	e8 2d c9 ff ff       	call   80102697 <nameiparent>
80105d6a:	83 c4 10             	add    $0x10,%esp
80105d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d74:	74 71                	je     80105de7 <sys_link+0x15e>
    goto bad;
  ilock(dp);
80105d76:	83 ec 0c             	sub    $0xc,%esp
80105d79:	ff 75 f0             	pushl  -0x10(%ebp)
80105d7c:	e8 8b bd ff ff       	call   80101b0c <ilock>
80105d81:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d87:	8b 10                	mov    (%eax),%edx
80105d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d8c:	8b 00                	mov    (%eax),%eax
80105d8e:	39 c2                	cmp    %eax,%edx
80105d90:	75 1d                	jne    80105daf <sys_link+0x126>
80105d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d95:	8b 40 04             	mov    0x4(%eax),%eax
80105d98:	83 ec 04             	sub    $0x4,%esp
80105d9b:	50                   	push   %eax
80105d9c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105d9f:	50                   	push   %eax
80105da0:	ff 75 f0             	pushl  -0x10(%ebp)
80105da3:	e8 2c c6 ff ff       	call   801023d4 <dirlink>
80105da8:	83 c4 10             	add    $0x10,%esp
80105dab:	85 c0                	test   %eax,%eax
80105dad:	79 10                	jns    80105dbf <sys_link+0x136>
    iunlockput(dp);
80105daf:	83 ec 0c             	sub    $0xc,%esp
80105db2:	ff 75 f0             	pushl  -0x10(%ebp)
80105db5:	e8 8f bf ff ff       	call   80101d49 <iunlockput>
80105dba:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105dbd:	eb 29                	jmp    80105de8 <sys_link+0x15f>
  }
  iunlockput(dp);
80105dbf:	83 ec 0c             	sub    $0xc,%esp
80105dc2:	ff 75 f0             	pushl  -0x10(%ebp)
80105dc5:	e8 7f bf ff ff       	call   80101d49 <iunlockput>
80105dca:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105dcd:	83 ec 0c             	sub    $0xc,%esp
80105dd0:	ff 75 f4             	pushl  -0xc(%ebp)
80105dd3:	e8 9d be ff ff       	call   80101c75 <iput>
80105dd8:	83 c4 10             	add    $0x10,%esp

  end_op();
80105ddb:	e8 b1 d9 ff ff       	call   80103791 <end_op>

  return 0;
80105de0:	b8 00 00 00 00       	mov    $0x0,%eax
80105de5:	eb 48                	jmp    80105e2f <sys_link+0x1a6>
    goto bad;
80105de7:	90                   	nop

bad:
  ilock(ip);
80105de8:	83 ec 0c             	sub    $0xc,%esp
80105deb:	ff 75 f4             	pushl  -0xc(%ebp)
80105dee:	e8 19 bd ff ff       	call   80101b0c <ilock>
80105df3:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df9:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105dfd:	83 e8 01             	sub    $0x1,%eax
80105e00:	89 c2                	mov    %eax,%edx
80105e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e05:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105e09:	83 ec 0c             	sub    $0xc,%esp
80105e0c:	ff 75 f4             	pushl  -0xc(%ebp)
80105e0f:	e8 0f bb ff ff       	call   80101923 <iupdate>
80105e14:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105e17:	83 ec 0c             	sub    $0xc,%esp
80105e1a:	ff 75 f4             	pushl  -0xc(%ebp)
80105e1d:	e8 27 bf ff ff       	call   80101d49 <iunlockput>
80105e22:	83 c4 10             	add    $0x10,%esp
  end_op();
80105e25:	e8 67 d9 ff ff       	call   80103791 <end_op>
  return -1;
80105e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e2f:	c9                   	leave  
80105e30:	c3                   	ret    

80105e31 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105e31:	f3 0f 1e fb          	endbr32 
80105e35:	55                   	push   %ebp
80105e36:	89 e5                	mov    %esp,%ebp
80105e38:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e3b:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105e42:	eb 40                	jmp    80105e84 <isdirempty+0x53>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e47:	6a 10                	push   $0x10
80105e49:	50                   	push   %eax
80105e4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e4d:	50                   	push   %eax
80105e4e:	ff 75 08             	pushl  0x8(%ebp)
80105e51:	e8 be c1 ff ff       	call   80102014 <readi>
80105e56:	83 c4 10             	add    $0x10,%esp
80105e59:	83 f8 10             	cmp    $0x10,%eax
80105e5c:	74 0d                	je     80105e6b <isdirempty+0x3a>
      panic("isdirempty: readi");
80105e5e:	83 ec 0c             	sub    $0xc,%esp
80105e61:	68 f0 95 10 80       	push   $0x801095f0
80105e66:	e8 9d a7 ff ff       	call   80100608 <panic>
    if(de.inum != 0)
80105e6b:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105e6f:	66 85 c0             	test   %ax,%ax
80105e72:	74 07                	je     80105e7b <isdirempty+0x4a>
      return 0;
80105e74:	b8 00 00 00 00       	mov    $0x0,%eax
80105e79:	eb 1b                	jmp    80105e96 <isdirempty+0x65>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7e:	83 c0 10             	add    $0x10,%eax
80105e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e84:	8b 45 08             	mov    0x8(%ebp),%eax
80105e87:	8b 50 58             	mov    0x58(%eax),%edx
80105e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8d:	39 c2                	cmp    %eax,%edx
80105e8f:	77 b3                	ja     80105e44 <isdirempty+0x13>
  }
  return 1;
80105e91:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105e96:	c9                   	leave  
80105e97:	c3                   	ret    

80105e98 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105e98:	f3 0f 1e fb          	endbr32 
80105e9c:	55                   	push   %ebp
80105e9d:	89 e5                	mov    %esp,%ebp
80105e9f:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105ea2:	83 ec 08             	sub    $0x8,%esp
80105ea5:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105ea8:	50                   	push   %eax
80105ea9:	6a 00                	push   $0x0
80105eab:	e8 72 fa ff ff       	call   80105922 <argstr>
80105eb0:	83 c4 10             	add    $0x10,%esp
80105eb3:	85 c0                	test   %eax,%eax
80105eb5:	79 0a                	jns    80105ec1 <sys_unlink+0x29>
    return -1;
80105eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebc:	e9 bf 01 00 00       	jmp    80106080 <sys_unlink+0x1e8>

  begin_op();
80105ec1:	e8 3b d8 ff ff       	call   80103701 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105ec6:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105ec9:	83 ec 08             	sub    $0x8,%esp
80105ecc:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105ecf:	52                   	push   %edx
80105ed0:	50                   	push   %eax
80105ed1:	e8 c1 c7 ff ff       	call   80102697 <nameiparent>
80105ed6:	83 c4 10             	add    $0x10,%esp
80105ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ee0:	75 0f                	jne    80105ef1 <sys_unlink+0x59>
    end_op();
80105ee2:	e8 aa d8 ff ff       	call   80103791 <end_op>
    return -1;
80105ee7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eec:	e9 8f 01 00 00       	jmp    80106080 <sys_unlink+0x1e8>
  }

  ilock(dp);
80105ef1:	83 ec 0c             	sub    $0xc,%esp
80105ef4:	ff 75 f4             	pushl  -0xc(%ebp)
80105ef7:	e8 10 bc ff ff       	call   80101b0c <ilock>
80105efc:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105eff:	83 ec 08             	sub    $0x8,%esp
80105f02:	68 02 96 10 80       	push   $0x80109602
80105f07:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f0a:	50                   	push   %eax
80105f0b:	e8 e7 c3 ff ff       	call   801022f7 <namecmp>
80105f10:	83 c4 10             	add    $0x10,%esp
80105f13:	85 c0                	test   %eax,%eax
80105f15:	0f 84 49 01 00 00    	je     80106064 <sys_unlink+0x1cc>
80105f1b:	83 ec 08             	sub    $0x8,%esp
80105f1e:	68 04 96 10 80       	push   $0x80109604
80105f23:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f26:	50                   	push   %eax
80105f27:	e8 cb c3 ff ff       	call   801022f7 <namecmp>
80105f2c:	83 c4 10             	add    $0x10,%esp
80105f2f:	85 c0                	test   %eax,%eax
80105f31:	0f 84 2d 01 00 00    	je     80106064 <sys_unlink+0x1cc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105f37:	83 ec 04             	sub    $0x4,%esp
80105f3a:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105f3d:	50                   	push   %eax
80105f3e:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f41:	50                   	push   %eax
80105f42:	ff 75 f4             	pushl  -0xc(%ebp)
80105f45:	e8 cc c3 ff ff       	call   80102316 <dirlookup>
80105f4a:	83 c4 10             	add    $0x10,%esp
80105f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f54:	0f 84 0d 01 00 00    	je     80106067 <sys_unlink+0x1cf>
    goto bad;
  ilock(ip);
80105f5a:	83 ec 0c             	sub    $0xc,%esp
80105f5d:	ff 75 f0             	pushl  -0x10(%ebp)
80105f60:	e8 a7 bb ff ff       	call   80101b0c <ilock>
80105f65:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f6b:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105f6f:	66 85 c0             	test   %ax,%ax
80105f72:	7f 0d                	jg     80105f81 <sys_unlink+0xe9>
    panic("unlink: nlink < 1");
80105f74:	83 ec 0c             	sub    $0xc,%esp
80105f77:	68 07 96 10 80       	push   $0x80109607
80105f7c:	e8 87 a6 ff ff       	call   80100608 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f84:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105f88:	66 83 f8 01          	cmp    $0x1,%ax
80105f8c:	75 25                	jne    80105fb3 <sys_unlink+0x11b>
80105f8e:	83 ec 0c             	sub    $0xc,%esp
80105f91:	ff 75 f0             	pushl  -0x10(%ebp)
80105f94:	e8 98 fe ff ff       	call   80105e31 <isdirempty>
80105f99:	83 c4 10             	add    $0x10,%esp
80105f9c:	85 c0                	test   %eax,%eax
80105f9e:	75 13                	jne    80105fb3 <sys_unlink+0x11b>
    iunlockput(ip);
80105fa0:	83 ec 0c             	sub    $0xc,%esp
80105fa3:	ff 75 f0             	pushl  -0x10(%ebp)
80105fa6:	e8 9e bd ff ff       	call   80101d49 <iunlockput>
80105fab:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105fae:	e9 b5 00 00 00       	jmp    80106068 <sys_unlink+0x1d0>
  }

  memset(&de, 0, sizeof(de));
80105fb3:	83 ec 04             	sub    $0x4,%esp
80105fb6:	6a 10                	push   $0x10
80105fb8:	6a 00                	push   $0x0
80105fba:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fbd:	50                   	push   %eax
80105fbe:	e8 6e f5 ff ff       	call   80105531 <memset>
80105fc3:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105fc6:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105fc9:	6a 10                	push   $0x10
80105fcb:	50                   	push   %eax
80105fcc:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fcf:	50                   	push   %eax
80105fd0:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd3:	e8 95 c1 ff ff       	call   8010216d <writei>
80105fd8:	83 c4 10             	add    $0x10,%esp
80105fdb:	83 f8 10             	cmp    $0x10,%eax
80105fde:	74 0d                	je     80105fed <sys_unlink+0x155>
    panic("unlink: writei");
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	68 19 96 10 80       	push   $0x80109619
80105fe8:	e8 1b a6 ff ff       	call   80100608 <panic>
  if(ip->type == T_DIR){
80105fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff0:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105ff4:	66 83 f8 01          	cmp    $0x1,%ax
80105ff8:	75 21                	jne    8010601b <sys_unlink+0x183>
    dp->nlink--;
80105ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ffd:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106001:	83 e8 01             	sub    $0x1,%eax
80106004:	89 c2                	mov    %eax,%edx
80106006:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106009:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
8010600d:	83 ec 0c             	sub    $0xc,%esp
80106010:	ff 75 f4             	pushl  -0xc(%ebp)
80106013:	e8 0b b9 ff ff       	call   80101923 <iupdate>
80106018:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010601b:	83 ec 0c             	sub    $0xc,%esp
8010601e:	ff 75 f4             	pushl  -0xc(%ebp)
80106021:	e8 23 bd ff ff       	call   80101d49 <iunlockput>
80106026:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106029:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010602c:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106030:	83 e8 01             	sub    $0x1,%eax
80106033:	89 c2                	mov    %eax,%edx
80106035:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106038:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
8010603c:	83 ec 0c             	sub    $0xc,%esp
8010603f:	ff 75 f0             	pushl  -0x10(%ebp)
80106042:	e8 dc b8 ff ff       	call   80101923 <iupdate>
80106047:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010604a:	83 ec 0c             	sub    $0xc,%esp
8010604d:	ff 75 f0             	pushl  -0x10(%ebp)
80106050:	e8 f4 bc ff ff       	call   80101d49 <iunlockput>
80106055:	83 c4 10             	add    $0x10,%esp

  end_op();
80106058:	e8 34 d7 ff ff       	call   80103791 <end_op>

  return 0;
8010605d:	b8 00 00 00 00       	mov    $0x0,%eax
80106062:	eb 1c                	jmp    80106080 <sys_unlink+0x1e8>
    goto bad;
80106064:	90                   	nop
80106065:	eb 01                	jmp    80106068 <sys_unlink+0x1d0>
    goto bad;
80106067:	90                   	nop

bad:
  iunlockput(dp);
80106068:	83 ec 0c             	sub    $0xc,%esp
8010606b:	ff 75 f4             	pushl  -0xc(%ebp)
8010606e:	e8 d6 bc ff ff       	call   80101d49 <iunlockput>
80106073:	83 c4 10             	add    $0x10,%esp
  end_op();
80106076:	e8 16 d7 ff ff       	call   80103791 <end_op>
  return -1;
8010607b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106080:	c9                   	leave  
80106081:	c3                   	ret    

80106082 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106082:	f3 0f 1e fb          	endbr32 
80106086:	55                   	push   %ebp
80106087:	89 e5                	mov    %esp,%ebp
80106089:	83 ec 38             	sub    $0x38,%esp
8010608c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010608f:	8b 55 10             	mov    0x10(%ebp),%edx
80106092:	8b 45 14             	mov    0x14(%ebp),%eax
80106095:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106099:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010609d:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801060a1:	83 ec 08             	sub    $0x8,%esp
801060a4:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801060a7:	50                   	push   %eax
801060a8:	ff 75 08             	pushl  0x8(%ebp)
801060ab:	e8 e7 c5 ff ff       	call   80102697 <nameiparent>
801060b0:	83 c4 10             	add    $0x10,%esp
801060b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060ba:	75 0a                	jne    801060c6 <create+0x44>
    return 0;
801060bc:	b8 00 00 00 00       	mov    $0x0,%eax
801060c1:	e9 8e 01 00 00       	jmp    80106254 <create+0x1d2>
  ilock(dp);
801060c6:	83 ec 0c             	sub    $0xc,%esp
801060c9:	ff 75 f4             	pushl  -0xc(%ebp)
801060cc:	e8 3b ba ff ff       	call   80101b0c <ilock>
801060d1:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
801060d4:	83 ec 04             	sub    $0x4,%esp
801060d7:	6a 00                	push   $0x0
801060d9:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801060dc:	50                   	push   %eax
801060dd:	ff 75 f4             	pushl  -0xc(%ebp)
801060e0:	e8 31 c2 ff ff       	call   80102316 <dirlookup>
801060e5:	83 c4 10             	add    $0x10,%esp
801060e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060ef:	74 50                	je     80106141 <create+0xbf>
    iunlockput(dp);
801060f1:	83 ec 0c             	sub    $0xc,%esp
801060f4:	ff 75 f4             	pushl  -0xc(%ebp)
801060f7:	e8 4d bc ff ff       	call   80101d49 <iunlockput>
801060fc:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801060ff:	83 ec 0c             	sub    $0xc,%esp
80106102:	ff 75 f0             	pushl  -0x10(%ebp)
80106105:	e8 02 ba ff ff       	call   80101b0c <ilock>
8010610a:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010610d:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106112:	75 15                	jne    80106129 <create+0xa7>
80106114:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106117:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010611b:	66 83 f8 02          	cmp    $0x2,%ax
8010611f:	75 08                	jne    80106129 <create+0xa7>
      return ip;
80106121:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106124:	e9 2b 01 00 00       	jmp    80106254 <create+0x1d2>
    iunlockput(ip);
80106129:	83 ec 0c             	sub    $0xc,%esp
8010612c:	ff 75 f0             	pushl  -0x10(%ebp)
8010612f:	e8 15 bc ff ff       	call   80101d49 <iunlockput>
80106134:	83 c4 10             	add    $0x10,%esp
    return 0;
80106137:	b8 00 00 00 00       	mov    $0x0,%eax
8010613c:	e9 13 01 00 00       	jmp    80106254 <create+0x1d2>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106141:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106148:	8b 00                	mov    (%eax),%eax
8010614a:	83 ec 08             	sub    $0x8,%esp
8010614d:	52                   	push   %edx
8010614e:	50                   	push   %eax
8010614f:	e8 f4 b6 ff ff       	call   80101848 <ialloc>
80106154:	83 c4 10             	add    $0x10,%esp
80106157:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010615a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010615e:	75 0d                	jne    8010616d <create+0xeb>
    panic("create: ialloc");
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	68 28 96 10 80       	push   $0x80109628
80106168:	e8 9b a4 ff ff       	call   80100608 <panic>

  ilock(ip);
8010616d:	83 ec 0c             	sub    $0xc,%esp
80106170:	ff 75 f0             	pushl  -0x10(%ebp)
80106173:	e8 94 b9 ff ff       	call   80101b0c <ilock>
80106178:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
8010617b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010617e:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106182:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80106186:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106189:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
8010618d:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80106191:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106194:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
8010619a:	83 ec 0c             	sub    $0xc,%esp
8010619d:	ff 75 f0             	pushl  -0x10(%ebp)
801061a0:	e8 7e b7 ff ff       	call   80101923 <iupdate>
801061a5:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801061a8:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801061ad:	75 6a                	jne    80106219 <create+0x197>
    dp->nlink++;  // for ".."
801061af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b2:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801061b6:	83 c0 01             	add    $0x1,%eax
801061b9:	89 c2                	mov    %eax,%edx
801061bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061be:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801061c2:	83 ec 0c             	sub    $0xc,%esp
801061c5:	ff 75 f4             	pushl  -0xc(%ebp)
801061c8:	e8 56 b7 ff ff       	call   80101923 <iupdate>
801061cd:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801061d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061d3:	8b 40 04             	mov    0x4(%eax),%eax
801061d6:	83 ec 04             	sub    $0x4,%esp
801061d9:	50                   	push   %eax
801061da:	68 02 96 10 80       	push   $0x80109602
801061df:	ff 75 f0             	pushl  -0x10(%ebp)
801061e2:	e8 ed c1 ff ff       	call   801023d4 <dirlink>
801061e7:	83 c4 10             	add    $0x10,%esp
801061ea:	85 c0                	test   %eax,%eax
801061ec:	78 1e                	js     8010620c <create+0x18a>
801061ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f1:	8b 40 04             	mov    0x4(%eax),%eax
801061f4:	83 ec 04             	sub    $0x4,%esp
801061f7:	50                   	push   %eax
801061f8:	68 04 96 10 80       	push   $0x80109604
801061fd:	ff 75 f0             	pushl  -0x10(%ebp)
80106200:	e8 cf c1 ff ff       	call   801023d4 <dirlink>
80106205:	83 c4 10             	add    $0x10,%esp
80106208:	85 c0                	test   %eax,%eax
8010620a:	79 0d                	jns    80106219 <create+0x197>
      panic("create dots");
8010620c:	83 ec 0c             	sub    $0xc,%esp
8010620f:	68 37 96 10 80       	push   $0x80109637
80106214:	e8 ef a3 ff ff       	call   80100608 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106219:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010621c:	8b 40 04             	mov    0x4(%eax),%eax
8010621f:	83 ec 04             	sub    $0x4,%esp
80106222:	50                   	push   %eax
80106223:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106226:	50                   	push   %eax
80106227:	ff 75 f4             	pushl  -0xc(%ebp)
8010622a:	e8 a5 c1 ff ff       	call   801023d4 <dirlink>
8010622f:	83 c4 10             	add    $0x10,%esp
80106232:	85 c0                	test   %eax,%eax
80106234:	79 0d                	jns    80106243 <create+0x1c1>
    panic("create: dirlink");
80106236:	83 ec 0c             	sub    $0xc,%esp
80106239:	68 43 96 10 80       	push   $0x80109643
8010623e:	e8 c5 a3 ff ff       	call   80100608 <panic>

  iunlockput(dp);
80106243:	83 ec 0c             	sub    $0xc,%esp
80106246:	ff 75 f4             	pushl  -0xc(%ebp)
80106249:	e8 fb ba ff ff       	call   80101d49 <iunlockput>
8010624e:	83 c4 10             	add    $0x10,%esp

  return ip;
80106251:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106254:	c9                   	leave  
80106255:	c3                   	ret    

80106256 <sys_open>:

int
sys_open(void)
{
80106256:	f3 0f 1e fb          	endbr32 
8010625a:	55                   	push   %ebp
8010625b:	89 e5                	mov    %esp,%ebp
8010625d:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106260:	83 ec 08             	sub    $0x8,%esp
80106263:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106266:	50                   	push   %eax
80106267:	6a 00                	push   $0x0
80106269:	e8 b4 f6 ff ff       	call   80105922 <argstr>
8010626e:	83 c4 10             	add    $0x10,%esp
80106271:	85 c0                	test   %eax,%eax
80106273:	78 15                	js     8010628a <sys_open+0x34>
80106275:	83 ec 08             	sub    $0x8,%esp
80106278:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010627b:	50                   	push   %eax
8010627c:	6a 01                	push   $0x1
8010627e:	e8 02 f6 ff ff       	call   80105885 <argint>
80106283:	83 c4 10             	add    $0x10,%esp
80106286:	85 c0                	test   %eax,%eax
80106288:	79 0a                	jns    80106294 <sys_open+0x3e>
    return -1;
8010628a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010628f:	e9 61 01 00 00       	jmp    801063f5 <sys_open+0x19f>

  begin_op();
80106294:	e8 68 d4 ff ff       	call   80103701 <begin_op>

  if(omode & O_CREATE){
80106299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010629c:	25 00 02 00 00       	and    $0x200,%eax
801062a1:	85 c0                	test   %eax,%eax
801062a3:	74 2a                	je     801062cf <sys_open+0x79>
    ip = create(path, T_FILE, 0, 0);
801062a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062a8:	6a 00                	push   $0x0
801062aa:	6a 00                	push   $0x0
801062ac:	6a 02                	push   $0x2
801062ae:	50                   	push   %eax
801062af:	e8 ce fd ff ff       	call   80106082 <create>
801062b4:	83 c4 10             	add    $0x10,%esp
801062b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801062ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062be:	75 75                	jne    80106335 <sys_open+0xdf>
      end_op();
801062c0:	e8 cc d4 ff ff       	call   80103791 <end_op>
      return -1;
801062c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ca:	e9 26 01 00 00       	jmp    801063f5 <sys_open+0x19f>
    }
  } else {
    if((ip = namei(path)) == 0){
801062cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062d2:	83 ec 0c             	sub    $0xc,%esp
801062d5:	50                   	push   %eax
801062d6:	e8 9c c3 ff ff       	call   80102677 <namei>
801062db:	83 c4 10             	add    $0x10,%esp
801062de:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062e5:	75 0f                	jne    801062f6 <sys_open+0xa0>
      end_op();
801062e7:	e8 a5 d4 ff ff       	call   80103791 <end_op>
      return -1;
801062ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f1:	e9 ff 00 00 00       	jmp    801063f5 <sys_open+0x19f>
    }
    ilock(ip);
801062f6:	83 ec 0c             	sub    $0xc,%esp
801062f9:	ff 75 f4             	pushl  -0xc(%ebp)
801062fc:	e8 0b b8 ff ff       	call   80101b0c <ilock>
80106301:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106307:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010630b:	66 83 f8 01          	cmp    $0x1,%ax
8010630f:	75 24                	jne    80106335 <sys_open+0xdf>
80106311:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106314:	85 c0                	test   %eax,%eax
80106316:	74 1d                	je     80106335 <sys_open+0xdf>
      iunlockput(ip);
80106318:	83 ec 0c             	sub    $0xc,%esp
8010631b:	ff 75 f4             	pushl  -0xc(%ebp)
8010631e:	e8 26 ba ff ff       	call   80101d49 <iunlockput>
80106323:	83 c4 10             	add    $0x10,%esp
      end_op();
80106326:	e8 66 d4 ff ff       	call   80103791 <end_op>
      return -1;
8010632b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106330:	e9 c0 00 00 00       	jmp    801063f5 <sys_open+0x19f>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106335:	e8 8c ad ff ff       	call   801010c6 <filealloc>
8010633a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010633d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106341:	74 17                	je     8010635a <sys_open+0x104>
80106343:	83 ec 0c             	sub    $0xc,%esp
80106346:	ff 75 f0             	pushl  -0x10(%ebp)
80106349:	e8 09 f7 ff ff       	call   80105a57 <fdalloc>
8010634e:	83 c4 10             	add    $0x10,%esp
80106351:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106354:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106358:	79 2e                	jns    80106388 <sys_open+0x132>
    if(f)
8010635a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010635e:	74 0e                	je     8010636e <sys_open+0x118>
      fileclose(f);
80106360:	83 ec 0c             	sub    $0xc,%esp
80106363:	ff 75 f0             	pushl  -0x10(%ebp)
80106366:	e8 21 ae ff ff       	call   8010118c <fileclose>
8010636b:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010636e:	83 ec 0c             	sub    $0xc,%esp
80106371:	ff 75 f4             	pushl  -0xc(%ebp)
80106374:	e8 d0 b9 ff ff       	call   80101d49 <iunlockput>
80106379:	83 c4 10             	add    $0x10,%esp
    end_op();
8010637c:	e8 10 d4 ff ff       	call   80103791 <end_op>
    return -1;
80106381:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106386:	eb 6d                	jmp    801063f5 <sys_open+0x19f>
  }
  iunlock(ip);
80106388:	83 ec 0c             	sub    $0xc,%esp
8010638b:	ff 75 f4             	pushl  -0xc(%ebp)
8010638e:	e8 90 b8 ff ff       	call   80101c23 <iunlock>
80106393:	83 c4 10             	add    $0x10,%esp
  end_op();
80106396:	e8 f6 d3 ff ff       	call   80103791 <end_op>

  f->type = FD_INODE;
8010639b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010639e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801063a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063aa:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801063ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801063b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063ba:	83 e0 01             	and    $0x1,%eax
801063bd:	85 c0                	test   %eax,%eax
801063bf:	0f 94 c0             	sete   %al
801063c2:	89 c2                	mov    %eax,%edx
801063c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c7:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801063ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063cd:	83 e0 01             	and    $0x1,%eax
801063d0:	85 c0                	test   %eax,%eax
801063d2:	75 0a                	jne    801063de <sys_open+0x188>
801063d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063d7:	83 e0 02             	and    $0x2,%eax
801063da:	85 c0                	test   %eax,%eax
801063dc:	74 07                	je     801063e5 <sys_open+0x18f>
801063de:	b8 01 00 00 00       	mov    $0x1,%eax
801063e3:	eb 05                	jmp    801063ea <sys_open+0x194>
801063e5:	b8 00 00 00 00       	mov    $0x0,%eax
801063ea:	89 c2                	mov    %eax,%edx
801063ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ef:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801063f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801063f5:	c9                   	leave  
801063f6:	c3                   	ret    

801063f7 <sys_mkdir>:

int
sys_mkdir(void)
{
801063f7:	f3 0f 1e fb          	endbr32 
801063fb:	55                   	push   %ebp
801063fc:	89 e5                	mov    %esp,%ebp
801063fe:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106401:	e8 fb d2 ff ff       	call   80103701 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106406:	83 ec 08             	sub    $0x8,%esp
80106409:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010640c:	50                   	push   %eax
8010640d:	6a 00                	push   $0x0
8010640f:	e8 0e f5 ff ff       	call   80105922 <argstr>
80106414:	83 c4 10             	add    $0x10,%esp
80106417:	85 c0                	test   %eax,%eax
80106419:	78 1b                	js     80106436 <sys_mkdir+0x3f>
8010641b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010641e:	6a 00                	push   $0x0
80106420:	6a 00                	push   $0x0
80106422:	6a 01                	push   $0x1
80106424:	50                   	push   %eax
80106425:	e8 58 fc ff ff       	call   80106082 <create>
8010642a:	83 c4 10             	add    $0x10,%esp
8010642d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106434:	75 0c                	jne    80106442 <sys_mkdir+0x4b>
    end_op();
80106436:	e8 56 d3 ff ff       	call   80103791 <end_op>
    return -1;
8010643b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106440:	eb 18                	jmp    8010645a <sys_mkdir+0x63>
  }
  iunlockput(ip);
80106442:	83 ec 0c             	sub    $0xc,%esp
80106445:	ff 75 f4             	pushl  -0xc(%ebp)
80106448:	e8 fc b8 ff ff       	call   80101d49 <iunlockput>
8010644d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106450:	e8 3c d3 ff ff       	call   80103791 <end_op>
  return 0;
80106455:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010645a:	c9                   	leave  
8010645b:	c3                   	ret    

8010645c <sys_mknod>:

int
sys_mknod(void)
{
8010645c:	f3 0f 1e fb          	endbr32 
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106466:	e8 96 d2 ff ff       	call   80103701 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010646b:	83 ec 08             	sub    $0x8,%esp
8010646e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106471:	50                   	push   %eax
80106472:	6a 00                	push   $0x0
80106474:	e8 a9 f4 ff ff       	call   80105922 <argstr>
80106479:	83 c4 10             	add    $0x10,%esp
8010647c:	85 c0                	test   %eax,%eax
8010647e:	78 4f                	js     801064cf <sys_mknod+0x73>
     argint(1, &major) < 0 ||
80106480:	83 ec 08             	sub    $0x8,%esp
80106483:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106486:	50                   	push   %eax
80106487:	6a 01                	push   $0x1
80106489:	e8 f7 f3 ff ff       	call   80105885 <argint>
8010648e:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80106491:	85 c0                	test   %eax,%eax
80106493:	78 3a                	js     801064cf <sys_mknod+0x73>
     argint(2, &minor) < 0 ||
80106495:	83 ec 08             	sub    $0x8,%esp
80106498:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010649b:	50                   	push   %eax
8010649c:	6a 02                	push   $0x2
8010649e:	e8 e2 f3 ff ff       	call   80105885 <argint>
801064a3:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
801064a6:	85 c0                	test   %eax,%eax
801064a8:	78 25                	js     801064cf <sys_mknod+0x73>
     (ip = create(path, T_DEV, major, minor)) == 0){
801064aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064ad:	0f bf c8             	movswl %ax,%ecx
801064b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064b3:	0f bf d0             	movswl %ax,%edx
801064b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064b9:	51                   	push   %ecx
801064ba:	52                   	push   %edx
801064bb:	6a 03                	push   $0x3
801064bd:	50                   	push   %eax
801064be:	e8 bf fb ff ff       	call   80106082 <create>
801064c3:	83 c4 10             	add    $0x10,%esp
801064c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
801064c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064cd:	75 0c                	jne    801064db <sys_mknod+0x7f>
    end_op();
801064cf:	e8 bd d2 ff ff       	call   80103791 <end_op>
    return -1;
801064d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064d9:	eb 18                	jmp    801064f3 <sys_mknod+0x97>
  }
  iunlockput(ip);
801064db:	83 ec 0c             	sub    $0xc,%esp
801064de:	ff 75 f4             	pushl  -0xc(%ebp)
801064e1:	e8 63 b8 ff ff       	call   80101d49 <iunlockput>
801064e6:	83 c4 10             	add    $0x10,%esp
  end_op();
801064e9:	e8 a3 d2 ff ff       	call   80103791 <end_op>
  return 0;
801064ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064f3:	c9                   	leave  
801064f4:	c3                   	ret    

801064f5 <sys_chdir>:

int
sys_chdir(void)
{
801064f5:	f3 0f 1e fb          	endbr32 
801064f9:	55                   	push   %ebp
801064fa:	89 e5                	mov    %esp,%ebp
801064fc:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801064ff:	e8 bc df ff ff       	call   801044c0 <myproc>
80106504:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106507:	e8 f5 d1 ff ff       	call   80103701 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010650c:	83 ec 08             	sub    $0x8,%esp
8010650f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106512:	50                   	push   %eax
80106513:	6a 00                	push   $0x0
80106515:	e8 08 f4 ff ff       	call   80105922 <argstr>
8010651a:	83 c4 10             	add    $0x10,%esp
8010651d:	85 c0                	test   %eax,%eax
8010651f:	78 18                	js     80106539 <sys_chdir+0x44>
80106521:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106524:	83 ec 0c             	sub    $0xc,%esp
80106527:	50                   	push   %eax
80106528:	e8 4a c1 ff ff       	call   80102677 <namei>
8010652d:	83 c4 10             	add    $0x10,%esp
80106530:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106533:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106537:	75 0c                	jne    80106545 <sys_chdir+0x50>
    end_op();
80106539:	e8 53 d2 ff ff       	call   80103791 <end_op>
    return -1;
8010653e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106543:	eb 68                	jmp    801065ad <sys_chdir+0xb8>
  }
  ilock(ip);
80106545:	83 ec 0c             	sub    $0xc,%esp
80106548:	ff 75 f0             	pushl  -0x10(%ebp)
8010654b:	e8 bc b5 ff ff       	call   80101b0c <ilock>
80106550:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106553:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106556:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010655a:	66 83 f8 01          	cmp    $0x1,%ax
8010655e:	74 1a                	je     8010657a <sys_chdir+0x85>
    iunlockput(ip);
80106560:	83 ec 0c             	sub    $0xc,%esp
80106563:	ff 75 f0             	pushl  -0x10(%ebp)
80106566:	e8 de b7 ff ff       	call   80101d49 <iunlockput>
8010656b:	83 c4 10             	add    $0x10,%esp
    end_op();
8010656e:	e8 1e d2 ff ff       	call   80103791 <end_op>
    return -1;
80106573:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106578:	eb 33                	jmp    801065ad <sys_chdir+0xb8>
  }
  iunlock(ip);
8010657a:	83 ec 0c             	sub    $0xc,%esp
8010657d:	ff 75 f0             	pushl  -0x10(%ebp)
80106580:	e8 9e b6 ff ff       	call   80101c23 <iunlock>
80106585:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80106588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010658b:	8b 40 68             	mov    0x68(%eax),%eax
8010658e:	83 ec 0c             	sub    $0xc,%esp
80106591:	50                   	push   %eax
80106592:	e8 de b6 ff ff       	call   80101c75 <iput>
80106597:	83 c4 10             	add    $0x10,%esp
  end_op();
8010659a:	e8 f2 d1 ff ff       	call   80103791 <end_op>
  curproc->cwd = ip;
8010659f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801065a5:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801065a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065ad:	c9                   	leave  
801065ae:	c3                   	ret    

801065af <sys_exec>:

int
sys_exec(void)
{
801065af:	f3 0f 1e fb          	endbr32 
801065b3:	55                   	push   %ebp
801065b4:	89 e5                	mov    %esp,%ebp
801065b6:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801065bc:	83 ec 08             	sub    $0x8,%esp
801065bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065c2:	50                   	push   %eax
801065c3:	6a 00                	push   $0x0
801065c5:	e8 58 f3 ff ff       	call   80105922 <argstr>
801065ca:	83 c4 10             	add    $0x10,%esp
801065cd:	85 c0                	test   %eax,%eax
801065cf:	78 18                	js     801065e9 <sys_exec+0x3a>
801065d1:	83 ec 08             	sub    $0x8,%esp
801065d4:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801065da:	50                   	push   %eax
801065db:	6a 01                	push   $0x1
801065dd:	e8 a3 f2 ff ff       	call   80105885 <argint>
801065e2:	83 c4 10             	add    $0x10,%esp
801065e5:	85 c0                	test   %eax,%eax
801065e7:	79 0a                	jns    801065f3 <sys_exec+0x44>
    return -1;
801065e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ee:	e9 c6 00 00 00       	jmp    801066b9 <sys_exec+0x10a>
  }
  memset(argv, 0, sizeof(argv));
801065f3:	83 ec 04             	sub    $0x4,%esp
801065f6:	68 80 00 00 00       	push   $0x80
801065fb:	6a 00                	push   $0x0
801065fd:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106603:	50                   	push   %eax
80106604:	e8 28 ef ff ff       	call   80105531 <memset>
80106609:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010660c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106616:	83 f8 1f             	cmp    $0x1f,%eax
80106619:	76 0a                	jbe    80106625 <sys_exec+0x76>
      return -1;
8010661b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106620:	e9 94 00 00 00       	jmp    801066b9 <sys_exec+0x10a>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106625:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106628:	c1 e0 02             	shl    $0x2,%eax
8010662b:	89 c2                	mov    %eax,%edx
8010662d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106633:	01 c2                	add    %eax,%edx
80106635:	83 ec 08             	sub    $0x8,%esp
80106638:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010663e:	50                   	push   %eax
8010663f:	52                   	push   %edx
80106640:	e8 95 f1 ff ff       	call   801057da <fetchint>
80106645:	83 c4 10             	add    $0x10,%esp
80106648:	85 c0                	test   %eax,%eax
8010664a:	79 07                	jns    80106653 <sys_exec+0xa4>
      return -1;
8010664c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106651:	eb 66                	jmp    801066b9 <sys_exec+0x10a>
    if(uarg == 0){
80106653:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106659:	85 c0                	test   %eax,%eax
8010665b:	75 27                	jne    80106684 <sys_exec+0xd5>
      argv[i] = 0;
8010665d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106660:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106667:	00 00 00 00 
      break;
8010666b:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010666c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010666f:	83 ec 08             	sub    $0x8,%esp
80106672:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106678:	52                   	push   %edx
80106679:	50                   	push   %eax
8010667a:	e8 b1 a5 ff ff       	call   80100c30 <exec>
8010667f:	83 c4 10             	add    $0x10,%esp
80106682:	eb 35                	jmp    801066b9 <sys_exec+0x10a>
    if(fetchstr(uarg, &argv[i]) < 0)
80106684:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010668a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010668d:	c1 e2 02             	shl    $0x2,%edx
80106690:	01 c2                	add    %eax,%edx
80106692:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106698:	83 ec 08             	sub    $0x8,%esp
8010669b:	52                   	push   %edx
8010669c:	50                   	push   %eax
8010669d:	e8 7b f1 ff ff       	call   8010581d <fetchstr>
801066a2:	83 c4 10             	add    $0x10,%esp
801066a5:	85 c0                	test   %eax,%eax
801066a7:	79 07                	jns    801066b0 <sys_exec+0x101>
      return -1;
801066a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ae:	eb 09                	jmp    801066b9 <sys_exec+0x10a>
  for(i=0;; i++){
801066b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
801066b4:	e9 5a ff ff ff       	jmp    80106613 <sys_exec+0x64>
}
801066b9:	c9                   	leave  
801066ba:	c3                   	ret    

801066bb <sys_pipe>:

int
sys_pipe(void)
{
801066bb:	f3 0f 1e fb          	endbr32 
801066bf:	55                   	push   %ebp
801066c0:	89 e5                	mov    %esp,%ebp
801066c2:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801066c5:	83 ec 04             	sub    $0x4,%esp
801066c8:	6a 08                	push   $0x8
801066ca:	8d 45 ec             	lea    -0x14(%ebp),%eax
801066cd:	50                   	push   %eax
801066ce:	6a 00                	push   $0x0
801066d0:	e8 e1 f1 ff ff       	call   801058b6 <argptr>
801066d5:	83 c4 10             	add    $0x10,%esp
801066d8:	85 c0                	test   %eax,%eax
801066da:	79 0a                	jns    801066e6 <sys_pipe+0x2b>
    return -1;
801066dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066e1:	e9 ae 00 00 00       	jmp    80106794 <sys_pipe+0xd9>
  if(pipealloc(&rf, &wf) < 0)
801066e6:	83 ec 08             	sub    $0x8,%esp
801066e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801066ec:	50                   	push   %eax
801066ed:	8d 45 e8             	lea    -0x18(%ebp),%eax
801066f0:	50                   	push   %eax
801066f1:	e8 eb d8 ff ff       	call   80103fe1 <pipealloc>
801066f6:	83 c4 10             	add    $0x10,%esp
801066f9:	85 c0                	test   %eax,%eax
801066fb:	79 0a                	jns    80106707 <sys_pipe+0x4c>
    return -1;
801066fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106702:	e9 8d 00 00 00       	jmp    80106794 <sys_pipe+0xd9>
  fd0 = -1;
80106707:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010670e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106711:	83 ec 0c             	sub    $0xc,%esp
80106714:	50                   	push   %eax
80106715:	e8 3d f3 ff ff       	call   80105a57 <fdalloc>
8010671a:	83 c4 10             	add    $0x10,%esp
8010671d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106724:	78 18                	js     8010673e <sys_pipe+0x83>
80106726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106729:	83 ec 0c             	sub    $0xc,%esp
8010672c:	50                   	push   %eax
8010672d:	e8 25 f3 ff ff       	call   80105a57 <fdalloc>
80106732:	83 c4 10             	add    $0x10,%esp
80106735:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106738:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010673c:	79 3e                	jns    8010677c <sys_pipe+0xc1>
    if(fd0 >= 0)
8010673e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106742:	78 13                	js     80106757 <sys_pipe+0x9c>
      myproc()->ofile[fd0] = 0;
80106744:	e8 77 dd ff ff       	call   801044c0 <myproc>
80106749:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010674c:	83 c2 08             	add    $0x8,%edx
8010674f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106756:	00 
    fileclose(rf);
80106757:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010675a:	83 ec 0c             	sub    $0xc,%esp
8010675d:	50                   	push   %eax
8010675e:	e8 29 aa ff ff       	call   8010118c <fileclose>
80106763:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106769:	83 ec 0c             	sub    $0xc,%esp
8010676c:	50                   	push   %eax
8010676d:	e8 1a aa ff ff       	call   8010118c <fileclose>
80106772:	83 c4 10             	add    $0x10,%esp
    return -1;
80106775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010677a:	eb 18                	jmp    80106794 <sys_pipe+0xd9>
  }
  fd[0] = fd0;
8010677c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010677f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106782:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106784:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106787:	8d 50 04             	lea    0x4(%eax),%edx
8010678a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010678d:	89 02                	mov    %eax,(%edx)
  return 0;
8010678f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106794:	c9                   	leave  
80106795:	c3                   	ret    

80106796 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106796:	f3 0f 1e fb          	endbr32 
8010679a:	55                   	push   %ebp
8010679b:	89 e5                	mov    %esp,%ebp
8010679d:	83 ec 08             	sub    $0x8,%esp
  return fork();
801067a0:	e8 65 e0 ff ff       	call   8010480a <fork>
}
801067a5:	c9                   	leave  
801067a6:	c3                   	ret    

801067a7 <sys_exit>:

int
sys_exit(void)
{
801067a7:	f3 0f 1e fb          	endbr32 
801067ab:	55                   	push   %ebp
801067ac:	89 e5                	mov    %esp,%ebp
801067ae:	83 ec 08             	sub    $0x8,%esp
  exit();
801067b1:	e8 18 e2 ff ff       	call   801049ce <exit>
  return 0;  // not reached
801067b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067bb:	c9                   	leave  
801067bc:	c3                   	ret    

801067bd <sys_wait>:

int
sys_wait(void)
{
801067bd:	f3 0f 1e fb          	endbr32 
801067c1:	55                   	push   %ebp
801067c2:	89 e5                	mov    %esp,%ebp
801067c4:	83 ec 08             	sub    $0x8,%esp
  return wait();
801067c7:	e8 29 e3 ff ff       	call   80104af5 <wait>
}
801067cc:	c9                   	leave  
801067cd:	c3                   	ret    

801067ce <sys_kill>:

int
sys_kill(void)
{
801067ce:	f3 0f 1e fb          	endbr32 
801067d2:	55                   	push   %ebp
801067d3:	89 e5                	mov    %esp,%ebp
801067d5:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801067d8:	83 ec 08             	sub    $0x8,%esp
801067db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067de:	50                   	push   %eax
801067df:	6a 00                	push   $0x0
801067e1:	e8 9f f0 ff ff       	call   80105885 <argint>
801067e6:	83 c4 10             	add    $0x10,%esp
801067e9:	85 c0                	test   %eax,%eax
801067eb:	79 07                	jns    801067f4 <sys_kill+0x26>
    return -1;
801067ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067f2:	eb 0f                	jmp    80106803 <sys_kill+0x35>
  return kill(pid);
801067f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067f7:	83 ec 0c             	sub    $0xc,%esp
801067fa:	50                   	push   %eax
801067fb:	e8 4d e7 ff ff       	call   80104f4d <kill>
80106800:	83 c4 10             	add    $0x10,%esp
}
80106803:	c9                   	leave  
80106804:	c3                   	ret    

80106805 <sys_getpid>:

int
sys_getpid(void)
{
80106805:	f3 0f 1e fb          	endbr32 
80106809:	55                   	push   %ebp
8010680a:	89 e5                	mov    %esp,%ebp
8010680c:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010680f:	e8 ac dc ff ff       	call   801044c0 <myproc>
80106814:	8b 40 10             	mov    0x10(%eax),%eax
}
80106817:	c9                   	leave  
80106818:	c3                   	ret    

80106819 <sys_sbrk>:

int
sys_sbrk(void)
{
80106819:	f3 0f 1e fb          	endbr32 
8010681d:	55                   	push   %ebp
8010681e:	89 e5                	mov    %esp,%ebp
80106820:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106823:	83 ec 08             	sub    $0x8,%esp
80106826:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106829:	50                   	push   %eax
8010682a:	6a 00                	push   $0x0
8010682c:	e8 54 f0 ff ff       	call   80105885 <argint>
80106831:	83 c4 10             	add    $0x10,%esp
80106834:	85 c0                	test   %eax,%eax
80106836:	79 07                	jns    8010683f <sys_sbrk+0x26>
    return -1;
80106838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010683d:	eb 27                	jmp    80106866 <sys_sbrk+0x4d>
  addr = myproc()->sz;
8010683f:	e8 7c dc ff ff       	call   801044c0 <myproc>
80106844:	8b 00                	mov    (%eax),%eax
80106846:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106849:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010684c:	83 ec 0c             	sub    $0xc,%esp
8010684f:	50                   	push   %eax
80106850:	e8 16 df ff ff       	call   8010476b <growproc>
80106855:	83 c4 10             	add    $0x10,%esp
80106858:	85 c0                	test   %eax,%eax
8010685a:	79 07                	jns    80106863 <sys_sbrk+0x4a>
    return -1;
8010685c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106861:	eb 03                	jmp    80106866 <sys_sbrk+0x4d>
  return addr;
80106863:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106866:	c9                   	leave  
80106867:	c3                   	ret    

80106868 <sys_sleep>:

int
sys_sleep(void)
{
80106868:	f3 0f 1e fb          	endbr32 
8010686c:	55                   	push   %ebp
8010686d:	89 e5                	mov    %esp,%ebp
8010686f:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106872:	83 ec 08             	sub    $0x8,%esp
80106875:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106878:	50                   	push   %eax
80106879:	6a 00                	push   $0x0
8010687b:	e8 05 f0 ff ff       	call   80105885 <argint>
80106880:	83 c4 10             	add    $0x10,%esp
80106883:	85 c0                	test   %eax,%eax
80106885:	79 07                	jns    8010688e <sys_sleep+0x26>
    return -1;
80106887:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010688c:	eb 76                	jmp    80106904 <sys_sleep+0x9c>
  acquire(&tickslock);
8010688e:	83 ec 0c             	sub    $0xc,%esp
80106891:	68 00 7f 11 80       	push   $0x80117f00
80106896:	e8 f7 e9 ff ff       	call   80105292 <acquire>
8010689b:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
8010689e:	a1 40 87 11 80       	mov    0x80118740,%eax
801068a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801068a6:	eb 38                	jmp    801068e0 <sys_sleep+0x78>
    if(myproc()->killed){
801068a8:	e8 13 dc ff ff       	call   801044c0 <myproc>
801068ad:	8b 40 24             	mov    0x24(%eax),%eax
801068b0:	85 c0                	test   %eax,%eax
801068b2:	74 17                	je     801068cb <sys_sleep+0x63>
      release(&tickslock);
801068b4:	83 ec 0c             	sub    $0xc,%esp
801068b7:	68 00 7f 11 80       	push   $0x80117f00
801068bc:	e8 43 ea ff ff       	call   80105304 <release>
801068c1:	83 c4 10             	add    $0x10,%esp
      return -1;
801068c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c9:	eb 39                	jmp    80106904 <sys_sleep+0x9c>
    }
    sleep(&ticks, &tickslock);
801068cb:	83 ec 08             	sub    $0x8,%esp
801068ce:	68 00 7f 11 80       	push   $0x80117f00
801068d3:	68 40 87 11 80       	push   $0x80118740
801068d8:	e8 43 e5 ff ff       	call   80104e20 <sleep>
801068dd:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
801068e0:	a1 40 87 11 80       	mov    0x80118740,%eax
801068e5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801068e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801068eb:	39 d0                	cmp    %edx,%eax
801068ed:	72 b9                	jb     801068a8 <sys_sleep+0x40>
  }
  release(&tickslock);
801068ef:	83 ec 0c             	sub    $0xc,%esp
801068f2:	68 00 7f 11 80       	push   $0x80117f00
801068f7:	e8 08 ea ff ff       	call   80105304 <release>
801068fc:	83 c4 10             	add    $0x10,%esp
  return 0;
801068ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106904:	c9                   	leave  
80106905:	c3                   	ret    

80106906 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106906:	f3 0f 1e fb          	endbr32 
8010690a:	55                   	push   %ebp
8010690b:	89 e5                	mov    %esp,%ebp
8010690d:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106910:	83 ec 0c             	sub    $0xc,%esp
80106913:	68 00 7f 11 80       	push   $0x80117f00
80106918:	e8 75 e9 ff ff       	call   80105292 <acquire>
8010691d:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106920:	a1 40 87 11 80       	mov    0x80118740,%eax
80106925:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106928:	83 ec 0c             	sub    $0xc,%esp
8010692b:	68 00 7f 11 80       	push   $0x80117f00
80106930:	e8 cf e9 ff ff       	call   80105304 <release>
80106935:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106938:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010693b:	c9                   	leave  
8010693c:	c3                   	ret    

8010693d <sys_mencrypt>:

//changed: added wrapper here
int sys_mencrypt(void) {
8010693d:	f3 0f 1e fb          	endbr32 
80106941:	55                   	push   %ebp
80106942:	89 e5                	mov    %esp,%ebp
80106944:	83 ec 18             	sub    $0x18,%esp
  int len;
  char * virtual_addr;

  if(argint(1, &len) < 0)
80106947:	83 ec 08             	sub    $0x8,%esp
8010694a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010694d:	50                   	push   %eax
8010694e:	6a 01                	push   $0x1
80106950:	e8 30 ef ff ff       	call   80105885 <argint>
80106955:	83 c4 10             	add    $0x10,%esp
80106958:	85 c0                	test   %eax,%eax
8010695a:	79 07                	jns    80106963 <sys_mencrypt+0x26>
    return -1;
8010695c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106961:	eb 50                	jmp    801069b3 <sys_mencrypt+0x76>
  if (len <= 0) {
80106963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106966:	85 c0                	test   %eax,%eax
80106968:	7f 07                	jg     80106971 <sys_mencrypt+0x34>
    return -1;
8010696a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010696f:	eb 42                	jmp    801069b3 <sys_mencrypt+0x76>
  }
  if(argptr(0, &virtual_addr, 1) < 0)
80106971:	83 ec 04             	sub    $0x4,%esp
80106974:	6a 01                	push   $0x1
80106976:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106979:	50                   	push   %eax
8010697a:	6a 00                	push   $0x0
8010697c:	e8 35 ef ff ff       	call   801058b6 <argptr>
80106981:	83 c4 10             	add    $0x10,%esp
80106984:	85 c0                	test   %eax,%eax
80106986:	79 07                	jns    8010698f <sys_mencrypt+0x52>
    return -1;
80106988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010698d:	eb 24                	jmp    801069b3 <sys_mencrypt+0x76>
  if ((void *) virtual_addr >= P2V(PHYSTOP)) {
8010698f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106992:	3d ff ff ff 8d       	cmp    $0x8dffffff,%eax
80106997:	76 07                	jbe    801069a0 <sys_mencrypt+0x63>
    return -1;
80106999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010699e:	eb 13                	jmp    801069b3 <sys_mencrypt+0x76>
  }
  return mencrypt(virtual_addr, len);
801069a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069a6:	83 ec 08             	sub    $0x8,%esp
801069a9:	52                   	push   %edx
801069aa:	50                   	push   %eax
801069ab:	e8 dd 22 00 00       	call   80108c8d <mencrypt>
801069b0:	83 c4 10             	add    $0x10,%esp
}
801069b3:	c9                   	leave  
801069b4:	c3                   	ret    

801069b5 <sys_getpgtable>:

int sys_getpgtable(void) {
801069b5:	f3 0f 1e fb          	endbr32 
801069b9:	55                   	push   %ebp
801069ba:	89 e5                	mov    %esp,%ebp
801069bc:	83 ec 18             	sub    $0x18,%esp
  struct pt_entry * entries; 
  int num;

  if(argint(1, &num) < 0)
801069bf:	83 ec 08             	sub    $0x8,%esp
801069c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069c5:	50                   	push   %eax
801069c6:	6a 01                	push   $0x1
801069c8:	e8 b8 ee ff ff       	call   80105885 <argint>
801069cd:	83 c4 10             	add    $0x10,%esp
801069d0:	85 c0                	test   %eax,%eax
801069d2:	79 07                	jns    801069db <sys_getpgtable+0x26>
    return -1;
801069d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069d9:	eb 36                	jmp    80106a11 <sys_getpgtable+0x5c>
  if(argptr(0, (char**)&entries, num*sizeof(struct pt_entry)) < 0){
801069db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069de:	c1 e0 03             	shl    $0x3,%eax
801069e1:	83 ec 04             	sub    $0x4,%esp
801069e4:	50                   	push   %eax
801069e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069e8:	50                   	push   %eax
801069e9:	6a 00                	push   $0x0
801069eb:	e8 c6 ee ff ff       	call   801058b6 <argptr>
801069f0:	83 c4 10             	add    $0x10,%esp
801069f3:	85 c0                	test   %eax,%eax
801069f5:	79 07                	jns    801069fe <sys_getpgtable+0x49>
    return -1;
801069f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069fc:	eb 13                	jmp    80106a11 <sys_getpgtable+0x5c>
  }
  return getpgtable(entries, num);
801069fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a04:	83 ec 08             	sub    $0x8,%esp
80106a07:	52                   	push   %edx
80106a08:	50                   	push   %eax
80106a09:	e8 55 24 00 00       	call   80108e63 <getpgtable>
80106a0e:	83 c4 10             	add    $0x10,%esp
}
80106a11:	c9                   	leave  
80106a12:	c3                   	ret    

80106a13 <sys_dump_rawphymem>:


int sys_dump_rawphymem(void) {
80106a13:	f3 0f 1e fb          	endbr32 
80106a17:	55                   	push   %ebp
80106a18:	89 e5                	mov    %esp,%ebp
80106a1a:	83 ec 18             	sub    $0x18,%esp
  char * physical_addr; 
  char * buffer;

  if(argptr(1, &buffer, PGSIZE) < 0)
80106a1d:	83 ec 04             	sub    $0x4,%esp
80106a20:	68 00 10 00 00       	push   $0x1000
80106a25:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a28:	50                   	push   %eax
80106a29:	6a 01                	push   $0x1
80106a2b:	e8 86 ee ff ff       	call   801058b6 <argptr>
80106a30:	83 c4 10             	add    $0x10,%esp
80106a33:	85 c0                	test   %eax,%eax
80106a35:	79 07                	jns    80106a3e <sys_dump_rawphymem+0x2b>
    return -1;
80106a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a3c:	eb 2f                	jmp    80106a6d <sys_dump_rawphymem+0x5a>
  if(argint(0, (int*)&physical_addr) < 0)
80106a3e:	83 ec 08             	sub    $0x8,%esp
80106a41:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a44:	50                   	push   %eax
80106a45:	6a 00                	push   $0x0
80106a47:	e8 39 ee ff ff       	call   80105885 <argint>
80106a4c:	83 c4 10             	add    $0x10,%esp
80106a4f:	85 c0                	test   %eax,%eax
80106a51:	79 07                	jns    80106a5a <sys_dump_rawphymem+0x47>
    return -1;
80106a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a58:	eb 13                	jmp    80106a6d <sys_dump_rawphymem+0x5a>
  return dump_rawphymem(physical_addr, buffer);
80106a5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a60:	83 ec 08             	sub    $0x8,%esp
80106a63:	52                   	push   %edx
80106a64:	50                   	push   %eax
80106a65:	e8 19 26 00 00       	call   80109083 <dump_rawphymem>
80106a6a:	83 c4 10             	add    $0x10,%esp
80106a6d:	c9                   	leave  
80106a6e:	c3                   	ret    

80106a6f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106a6f:	1e                   	push   %ds
  pushl %es
80106a70:	06                   	push   %es
  pushl %fs
80106a71:	0f a0                	push   %fs
  pushl %gs
80106a73:	0f a8                	push   %gs
  pushal
80106a75:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106a76:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106a7a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106a7c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106a7e:	54                   	push   %esp
  call trap
80106a7f:	e8 df 01 00 00       	call   80106c63 <trap>
  addl $4, %esp
80106a84:	83 c4 04             	add    $0x4,%esp

80106a87 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106a87:	61                   	popa   
  popl %gs
80106a88:	0f a9                	pop    %gs
  popl %fs
80106a8a:	0f a1                	pop    %fs
  popl %es
80106a8c:	07                   	pop    %es
  popl %ds
80106a8d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106a8e:	83 c4 08             	add    $0x8,%esp
  iret
80106a91:	cf                   	iret   

80106a92 <lidt>:
{
80106a92:	55                   	push   %ebp
80106a93:	89 e5                	mov    %esp,%ebp
80106a95:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106a98:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a9b:	83 e8 01             	sub    $0x1,%eax
80106a9e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80106aac:	c1 e8 10             	shr    $0x10,%eax
80106aaf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106ab3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ab6:	0f 01 18             	lidtl  (%eax)
}
80106ab9:	90                   	nop
80106aba:	c9                   	leave  
80106abb:	c3                   	ret    

80106abc <rcr2>:

static inline uint
rcr2(void)
{
80106abc:	55                   	push   %ebp
80106abd:	89 e5                	mov    %esp,%ebp
80106abf:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106ac2:	0f 20 d0             	mov    %cr2,%eax
80106ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106acb:	c9                   	leave  
80106acc:	c3                   	ret    

80106acd <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106acd:	f3 0f 1e fb          	endbr32 
80106ad1:	55                   	push   %ebp
80106ad2:	89 e5                	mov    %esp,%ebp
80106ad4:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106ad7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106ade:	e9 c3 00 00 00       	jmp    80106ba6 <tvinit+0xd9>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ae6:	8b 04 85 84 c0 10 80 	mov    -0x7fef3f7c(,%eax,4),%eax
80106aed:	89 c2                	mov    %eax,%edx
80106aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106af2:	66 89 14 c5 40 7f 11 	mov    %dx,-0x7fee80c0(,%eax,8)
80106af9:	80 
80106afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106afd:	66 c7 04 c5 42 7f 11 	movw   $0x8,-0x7fee80be(,%eax,8)
80106b04:	80 08 00 
80106b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b0a:	0f b6 14 c5 44 7f 11 	movzbl -0x7fee80bc(,%eax,8),%edx
80106b11:	80 
80106b12:	83 e2 e0             	and    $0xffffffe0,%edx
80106b15:	88 14 c5 44 7f 11 80 	mov    %dl,-0x7fee80bc(,%eax,8)
80106b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b1f:	0f b6 14 c5 44 7f 11 	movzbl -0x7fee80bc(,%eax,8),%edx
80106b26:	80 
80106b27:	83 e2 1f             	and    $0x1f,%edx
80106b2a:	88 14 c5 44 7f 11 80 	mov    %dl,-0x7fee80bc(,%eax,8)
80106b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b34:	0f b6 14 c5 45 7f 11 	movzbl -0x7fee80bb(,%eax,8),%edx
80106b3b:	80 
80106b3c:	83 e2 f0             	and    $0xfffffff0,%edx
80106b3f:	83 ca 0e             	or     $0xe,%edx
80106b42:	88 14 c5 45 7f 11 80 	mov    %dl,-0x7fee80bb(,%eax,8)
80106b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b4c:	0f b6 14 c5 45 7f 11 	movzbl -0x7fee80bb(,%eax,8),%edx
80106b53:	80 
80106b54:	83 e2 ef             	and    $0xffffffef,%edx
80106b57:	88 14 c5 45 7f 11 80 	mov    %dl,-0x7fee80bb(,%eax,8)
80106b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b61:	0f b6 14 c5 45 7f 11 	movzbl -0x7fee80bb(,%eax,8),%edx
80106b68:	80 
80106b69:	83 e2 9f             	and    $0xffffff9f,%edx
80106b6c:	88 14 c5 45 7f 11 80 	mov    %dl,-0x7fee80bb(,%eax,8)
80106b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b76:	0f b6 14 c5 45 7f 11 	movzbl -0x7fee80bb(,%eax,8),%edx
80106b7d:	80 
80106b7e:	83 ca 80             	or     $0xffffff80,%edx
80106b81:	88 14 c5 45 7f 11 80 	mov    %dl,-0x7fee80bb(,%eax,8)
80106b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b8b:	8b 04 85 84 c0 10 80 	mov    -0x7fef3f7c(,%eax,4),%eax
80106b92:	c1 e8 10             	shr    $0x10,%eax
80106b95:	89 c2                	mov    %eax,%edx
80106b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b9a:	66 89 14 c5 46 7f 11 	mov    %dx,-0x7fee80ba(,%eax,8)
80106ba1:	80 
  for(i = 0; i < 256; i++)
80106ba2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106ba6:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106bad:	0f 8e 30 ff ff ff    	jle    80106ae3 <tvinit+0x16>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106bb3:	a1 84 c1 10 80       	mov    0x8010c184,%eax
80106bb8:	66 a3 40 81 11 80    	mov    %ax,0x80118140
80106bbe:	66 c7 05 42 81 11 80 	movw   $0x8,0x80118142
80106bc5:	08 00 
80106bc7:	0f b6 05 44 81 11 80 	movzbl 0x80118144,%eax
80106bce:	83 e0 e0             	and    $0xffffffe0,%eax
80106bd1:	a2 44 81 11 80       	mov    %al,0x80118144
80106bd6:	0f b6 05 44 81 11 80 	movzbl 0x80118144,%eax
80106bdd:	83 e0 1f             	and    $0x1f,%eax
80106be0:	a2 44 81 11 80       	mov    %al,0x80118144
80106be5:	0f b6 05 45 81 11 80 	movzbl 0x80118145,%eax
80106bec:	83 c8 0f             	or     $0xf,%eax
80106bef:	a2 45 81 11 80       	mov    %al,0x80118145
80106bf4:	0f b6 05 45 81 11 80 	movzbl 0x80118145,%eax
80106bfb:	83 e0 ef             	and    $0xffffffef,%eax
80106bfe:	a2 45 81 11 80       	mov    %al,0x80118145
80106c03:	0f b6 05 45 81 11 80 	movzbl 0x80118145,%eax
80106c0a:	83 c8 60             	or     $0x60,%eax
80106c0d:	a2 45 81 11 80       	mov    %al,0x80118145
80106c12:	0f b6 05 45 81 11 80 	movzbl 0x80118145,%eax
80106c19:	83 c8 80             	or     $0xffffff80,%eax
80106c1c:	a2 45 81 11 80       	mov    %al,0x80118145
80106c21:	a1 84 c1 10 80       	mov    0x8010c184,%eax
80106c26:	c1 e8 10             	shr    $0x10,%eax
80106c29:	66 a3 46 81 11 80    	mov    %ax,0x80118146

  initlock(&tickslock, "time");
80106c2f:	83 ec 08             	sub    $0x8,%esp
80106c32:	68 54 96 10 80       	push   $0x80109654
80106c37:	68 00 7f 11 80       	push   $0x80117f00
80106c3c:	e8 2b e6 ff ff       	call   8010526c <initlock>
80106c41:	83 c4 10             	add    $0x10,%esp
}
80106c44:	90                   	nop
80106c45:	c9                   	leave  
80106c46:	c3                   	ret    

80106c47 <idtinit>:

void
idtinit(void)
{
80106c47:	f3 0f 1e fb          	endbr32 
80106c4b:	55                   	push   %ebp
80106c4c:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106c4e:	68 00 08 00 00       	push   $0x800
80106c53:	68 40 7f 11 80       	push   $0x80117f40
80106c58:	e8 35 fe ff ff       	call   80106a92 <lidt>
80106c5d:	83 c4 08             	add    $0x8,%esp
}
80106c60:	90                   	nop
80106c61:	c9                   	leave  
80106c62:	c3                   	ret    

80106c63 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106c63:	f3 0f 1e fb          	endbr32 
80106c67:	55                   	push   %ebp
80106c68:	89 e5                	mov    %esp,%ebp
80106c6a:	57                   	push   %edi
80106c6b:	56                   	push   %esi
80106c6c:	53                   	push   %ebx
80106c6d:	83 ec 2c             	sub    $0x2c,%esp
  if(tf->trapno == T_SYSCALL){
80106c70:	8b 45 08             	mov    0x8(%ebp),%eax
80106c73:	8b 40 30             	mov    0x30(%eax),%eax
80106c76:	83 f8 40             	cmp    $0x40,%eax
80106c79:	75 3b                	jne    80106cb6 <trap+0x53>
    if(myproc()->killed)
80106c7b:	e8 40 d8 ff ff       	call   801044c0 <myproc>
80106c80:	8b 40 24             	mov    0x24(%eax),%eax
80106c83:	85 c0                	test   %eax,%eax
80106c85:	74 05                	je     80106c8c <trap+0x29>
      exit();
80106c87:	e8 42 dd ff ff       	call   801049ce <exit>
    myproc()->tf = tf;
80106c8c:	e8 2f d8 ff ff       	call   801044c0 <myproc>
80106c91:	8b 55 08             	mov    0x8(%ebp),%edx
80106c94:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106c97:	e8 c1 ec ff ff       	call   8010595d <syscall>
    if(myproc()->killed)
80106c9c:	e8 1f d8 ff ff       	call   801044c0 <myproc>
80106ca1:	8b 40 24             	mov    0x24(%eax),%eax
80106ca4:	85 c0                	test   %eax,%eax
80106ca6:	0f 84 45 02 00 00    	je     80106ef1 <trap+0x28e>
      exit();
80106cac:	e8 1d dd ff ff       	call   801049ce <exit>
    return;
80106cb1:	e9 3b 02 00 00       	jmp    80106ef1 <trap+0x28e>
  }
  char *addr;
  switch(tf->trapno){
80106cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80106cb9:	8b 40 30             	mov    0x30(%eax),%eax
80106cbc:	83 e8 0e             	sub    $0xe,%eax
80106cbf:	83 f8 31             	cmp    $0x31,%eax
80106cc2:	0f 87 f1 00 00 00    	ja     80106db9 <trap+0x156>
80106cc8:	8b 04 85 2c 97 10 80 	mov    -0x7fef68d4(,%eax,4),%eax
80106ccf:	3e ff e0             	notrack jmp *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106cd2:	e8 4e d7 ff ff       	call   80104425 <cpuid>
80106cd7:	85 c0                	test   %eax,%eax
80106cd9:	75 3d                	jne    80106d18 <trap+0xb5>
      acquire(&tickslock);
80106cdb:	83 ec 0c             	sub    $0xc,%esp
80106cde:	68 00 7f 11 80       	push   $0x80117f00
80106ce3:	e8 aa e5 ff ff       	call   80105292 <acquire>
80106ce8:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106ceb:	a1 40 87 11 80       	mov    0x80118740,%eax
80106cf0:	83 c0 01             	add    $0x1,%eax
80106cf3:	a3 40 87 11 80       	mov    %eax,0x80118740
      wakeup(&ticks);
80106cf8:	83 ec 0c             	sub    $0xc,%esp
80106cfb:	68 40 87 11 80       	push   $0x80118740
80106d00:	e8 0d e2 ff ff       	call   80104f12 <wakeup>
80106d05:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106d08:	83 ec 0c             	sub    $0xc,%esp
80106d0b:	68 00 7f 11 80       	push   $0x80117f00
80106d10:	e8 ef e5 ff ff       	call   80105304 <release>
80106d15:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106d18:	e8 98 c4 ff ff       	call   801031b5 <lapiceoi>
    break;
80106d1d:	e9 4f 01 00 00       	jmp    80106e71 <trap+0x20e>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106d22:	e8 9d bc ff ff       	call   801029c4 <ideintr>
    lapiceoi();
80106d27:	e8 89 c4 ff ff       	call   801031b5 <lapiceoi>
    break;
80106d2c:	e9 40 01 00 00       	jmp    80106e71 <trap+0x20e>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106d31:	e8 b5 c2 ff ff       	call   80102feb <kbdintr>
    lapiceoi();
80106d36:	e8 7a c4 ff ff       	call   801031b5 <lapiceoi>
    break;
80106d3b:	e9 31 01 00 00       	jmp    80106e71 <trap+0x20e>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106d40:	e8 8e 03 00 00       	call   801070d3 <uartintr>
    lapiceoi();
80106d45:	e8 6b c4 ff ff       	call   801031b5 <lapiceoi>
    break;
80106d4a:	e9 22 01 00 00       	jmp    80106e71 <trap+0x20e>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d52:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106d55:	8b 45 08             	mov    0x8(%ebp),%eax
80106d58:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d5c:	0f b7 d8             	movzwl %ax,%ebx
80106d5f:	e8 c1 d6 ff ff       	call   80104425 <cpuid>
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	50                   	push   %eax
80106d67:	68 5c 96 10 80       	push   $0x8010965c
80106d6c:	e8 a7 96 ff ff       	call   80100418 <cprintf>
80106d71:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106d74:	e8 3c c4 ff ff       	call   801031b5 <lapiceoi>
    break;
80106d79:	e9 f3 00 00 00       	jmp    80106e71 <trap+0x20e>
  case T_PGFLT:
    //Food for thought: How can one distinguish between a regular page fault and a decryption request?
    cprintf("p4Debug : Page fault !\n");
80106d7e:	83 ec 0c             	sub    $0xc,%esp
80106d81:	68 80 96 10 80       	push   $0x80109680
80106d86:	e8 8d 96 ff ff       	call   80100418 <cprintf>
80106d8b:	83 c4 10             	add    $0x10,%esp
    addr = (char*)rcr2();
80106d8e:	e8 29 fd ff ff       	call   80106abc <rcr2>
80106d93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (mdecrypt(addr))
80106d96:	83 ec 0c             	sub    $0xc,%esp
80106d99:	ff 75 e4             	pushl  -0x1c(%ebp)
80106d9c:	e8 77 1d 00 00       	call   80108b18 <mdecrypt>
80106da1:	83 c4 10             	add    $0x10,%esp
80106da4:	85 c0                	test   %eax,%eax
80106da6:	0f 84 c4 00 00 00    	je     80106e70 <trap+0x20d>
    {
        panic("p4Debug: Memory fault");
80106dac:	83 ec 0c             	sub    $0xc,%esp
80106daf:	68 98 96 10 80       	push   $0x80109698
80106db4:	e8 4f 98 ff ff       	call   80100608 <panic>
        exit();
    };
    break;
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106db9:	e8 02 d7 ff ff       	call   801044c0 <myproc>
80106dbe:	85 c0                	test   %eax,%eax
80106dc0:	74 11                	je     80106dd3 <trap+0x170>
80106dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80106dc5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106dc9:	0f b7 c0             	movzwl %ax,%eax
80106dcc:	83 e0 03             	and    $0x3,%eax
80106dcf:	85 c0                	test   %eax,%eax
80106dd1:	75 39                	jne    80106e0c <trap+0x1a9>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106dd3:	e8 e4 fc ff ff       	call   80106abc <rcr2>
80106dd8:	89 c3                	mov    %eax,%ebx
80106dda:	8b 45 08             	mov    0x8(%ebp),%eax
80106ddd:	8b 70 38             	mov    0x38(%eax),%esi
80106de0:	e8 40 d6 ff ff       	call   80104425 <cpuid>
80106de5:	8b 55 08             	mov    0x8(%ebp),%edx
80106de8:	8b 52 30             	mov    0x30(%edx),%edx
80106deb:	83 ec 0c             	sub    $0xc,%esp
80106dee:	53                   	push   %ebx
80106def:	56                   	push   %esi
80106df0:	50                   	push   %eax
80106df1:	52                   	push   %edx
80106df2:	68 b0 96 10 80       	push   $0x801096b0
80106df7:	e8 1c 96 ff ff       	call   80100418 <cprintf>
80106dfc:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106dff:	83 ec 0c             	sub    $0xc,%esp
80106e02:	68 e2 96 10 80       	push   $0x801096e2
80106e07:	e8 fc 97 ff ff       	call   80100608 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e0c:	e8 ab fc ff ff       	call   80106abc <rcr2>
80106e11:	89 c6                	mov    %eax,%esi
80106e13:	8b 45 08             	mov    0x8(%ebp),%eax
80106e16:	8b 40 38             	mov    0x38(%eax),%eax
80106e19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106e1c:	e8 04 d6 ff ff       	call   80104425 <cpuid>
80106e21:	89 c3                	mov    %eax,%ebx
80106e23:	8b 45 08             	mov    0x8(%ebp),%eax
80106e26:	8b 48 34             	mov    0x34(%eax),%ecx
80106e29:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80106e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2f:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106e32:	e8 89 d6 ff ff       	call   801044c0 <myproc>
80106e37:	8d 50 6c             	lea    0x6c(%eax),%edx
80106e3a:	89 55 cc             	mov    %edx,-0x34(%ebp)
80106e3d:	e8 7e d6 ff ff       	call   801044c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e42:	8b 40 10             	mov    0x10(%eax),%eax
80106e45:	56                   	push   %esi
80106e46:	ff 75 d4             	pushl  -0x2c(%ebp)
80106e49:	53                   	push   %ebx
80106e4a:	ff 75 d0             	pushl  -0x30(%ebp)
80106e4d:	57                   	push   %edi
80106e4e:	ff 75 cc             	pushl  -0x34(%ebp)
80106e51:	50                   	push   %eax
80106e52:	68 e8 96 10 80       	push   $0x801096e8
80106e57:	e8 bc 95 ff ff       	call   80100418 <cprintf>
80106e5c:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106e5f:	e8 5c d6 ff ff       	call   801044c0 <myproc>
80106e64:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106e6b:	eb 04                	jmp    80106e71 <trap+0x20e>
    break;
80106e6d:	90                   	nop
80106e6e:	eb 01                	jmp    80106e71 <trap+0x20e>
    break;
80106e70:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e71:	e8 4a d6 ff ff       	call   801044c0 <myproc>
80106e76:	85 c0                	test   %eax,%eax
80106e78:	74 23                	je     80106e9d <trap+0x23a>
80106e7a:	e8 41 d6 ff ff       	call   801044c0 <myproc>
80106e7f:	8b 40 24             	mov    0x24(%eax),%eax
80106e82:	85 c0                	test   %eax,%eax
80106e84:	74 17                	je     80106e9d <trap+0x23a>
80106e86:	8b 45 08             	mov    0x8(%ebp),%eax
80106e89:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e8d:	0f b7 c0             	movzwl %ax,%eax
80106e90:	83 e0 03             	and    $0x3,%eax
80106e93:	83 f8 03             	cmp    $0x3,%eax
80106e96:	75 05                	jne    80106e9d <trap+0x23a>
    exit();
80106e98:	e8 31 db ff ff       	call   801049ce <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106e9d:	e8 1e d6 ff ff       	call   801044c0 <myproc>
80106ea2:	85 c0                	test   %eax,%eax
80106ea4:	74 1d                	je     80106ec3 <trap+0x260>
80106ea6:	e8 15 d6 ff ff       	call   801044c0 <myproc>
80106eab:	8b 40 0c             	mov    0xc(%eax),%eax
80106eae:	83 f8 04             	cmp    $0x4,%eax
80106eb1:	75 10                	jne    80106ec3 <trap+0x260>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106eb3:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb6:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106eb9:	83 f8 20             	cmp    $0x20,%eax
80106ebc:	75 05                	jne    80106ec3 <trap+0x260>
    yield();
80106ebe:	e8 d5 de ff ff       	call   80104d98 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ec3:	e8 f8 d5 ff ff       	call   801044c0 <myproc>
80106ec8:	85 c0                	test   %eax,%eax
80106eca:	74 26                	je     80106ef2 <trap+0x28f>
80106ecc:	e8 ef d5 ff ff       	call   801044c0 <myproc>
80106ed1:	8b 40 24             	mov    0x24(%eax),%eax
80106ed4:	85 c0                	test   %eax,%eax
80106ed6:	74 1a                	je     80106ef2 <trap+0x28f>
80106ed8:	8b 45 08             	mov    0x8(%ebp),%eax
80106edb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106edf:	0f b7 c0             	movzwl %ax,%eax
80106ee2:	83 e0 03             	and    $0x3,%eax
80106ee5:	83 f8 03             	cmp    $0x3,%eax
80106ee8:	75 08                	jne    80106ef2 <trap+0x28f>
    exit();
80106eea:	e8 df da ff ff       	call   801049ce <exit>
80106eef:	eb 01                	jmp    80106ef2 <trap+0x28f>
    return;
80106ef1:	90                   	nop
}
80106ef2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ef5:	5b                   	pop    %ebx
80106ef6:	5e                   	pop    %esi
80106ef7:	5f                   	pop    %edi
80106ef8:	5d                   	pop    %ebp
80106ef9:	c3                   	ret    

80106efa <inb>:
{
80106efa:	55                   	push   %ebp
80106efb:	89 e5                	mov    %esp,%ebp
80106efd:	83 ec 14             	sub    $0x14,%esp
80106f00:	8b 45 08             	mov    0x8(%ebp),%eax
80106f03:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f07:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106f0b:	89 c2                	mov    %eax,%edx
80106f0d:	ec                   	in     (%dx),%al
80106f0e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106f11:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106f15:	c9                   	leave  
80106f16:	c3                   	ret    

80106f17 <outb>:
{
80106f17:	55                   	push   %ebp
80106f18:	89 e5                	mov    %esp,%ebp
80106f1a:	83 ec 08             	sub    $0x8,%esp
80106f1d:	8b 45 08             	mov    0x8(%ebp),%eax
80106f20:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f23:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106f27:	89 d0                	mov    %edx,%eax
80106f29:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f2c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106f30:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106f34:	ee                   	out    %al,(%dx)
}
80106f35:	90                   	nop
80106f36:	c9                   	leave  
80106f37:	c3                   	ret    

80106f38 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106f38:	f3 0f 1e fb          	endbr32 
80106f3c:	55                   	push   %ebp
80106f3d:	89 e5                	mov    %esp,%ebp
80106f3f:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106f42:	6a 00                	push   $0x0
80106f44:	68 fa 03 00 00       	push   $0x3fa
80106f49:	e8 c9 ff ff ff       	call   80106f17 <outb>
80106f4e:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106f51:	68 80 00 00 00       	push   $0x80
80106f56:	68 fb 03 00 00       	push   $0x3fb
80106f5b:	e8 b7 ff ff ff       	call   80106f17 <outb>
80106f60:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106f63:	6a 0c                	push   $0xc
80106f65:	68 f8 03 00 00       	push   $0x3f8
80106f6a:	e8 a8 ff ff ff       	call   80106f17 <outb>
80106f6f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106f72:	6a 00                	push   $0x0
80106f74:	68 f9 03 00 00       	push   $0x3f9
80106f79:	e8 99 ff ff ff       	call   80106f17 <outb>
80106f7e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106f81:	6a 03                	push   $0x3
80106f83:	68 fb 03 00 00       	push   $0x3fb
80106f88:	e8 8a ff ff ff       	call   80106f17 <outb>
80106f8d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106f90:	6a 00                	push   $0x0
80106f92:	68 fc 03 00 00       	push   $0x3fc
80106f97:	e8 7b ff ff ff       	call   80106f17 <outb>
80106f9c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106f9f:	6a 01                	push   $0x1
80106fa1:	68 f9 03 00 00       	push   $0x3f9
80106fa6:	e8 6c ff ff ff       	call   80106f17 <outb>
80106fab:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106fae:	68 fd 03 00 00       	push   $0x3fd
80106fb3:	e8 42 ff ff ff       	call   80106efa <inb>
80106fb8:	83 c4 04             	add    $0x4,%esp
80106fbb:	3c ff                	cmp    $0xff,%al
80106fbd:	74 61                	je     80107020 <uartinit+0xe8>
    return;
  uart = 1;
80106fbf:	c7 05 44 c6 10 80 01 	movl   $0x1,0x8010c644
80106fc6:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106fc9:	68 fa 03 00 00       	push   $0x3fa
80106fce:	e8 27 ff ff ff       	call   80106efa <inb>
80106fd3:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106fd6:	68 f8 03 00 00       	push   $0x3f8
80106fdb:	e8 1a ff ff ff       	call   80106efa <inb>
80106fe0:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106fe3:	83 ec 08             	sub    $0x8,%esp
80106fe6:	6a 00                	push   $0x0
80106fe8:	6a 04                	push   $0x4
80106fea:	e8 87 bc ff ff       	call   80102c76 <ioapicenable>
80106fef:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106ff2:	c7 45 f4 f4 97 10 80 	movl   $0x801097f4,-0xc(%ebp)
80106ff9:	eb 19                	jmp    80107014 <uartinit+0xdc>
    uartputc(*p);
80106ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ffe:	0f b6 00             	movzbl (%eax),%eax
80107001:	0f be c0             	movsbl %al,%eax
80107004:	83 ec 0c             	sub    $0xc,%esp
80107007:	50                   	push   %eax
80107008:	e8 16 00 00 00       	call   80107023 <uartputc>
8010700d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107010:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107017:	0f b6 00             	movzbl (%eax),%eax
8010701a:	84 c0                	test   %al,%al
8010701c:	75 dd                	jne    80106ffb <uartinit+0xc3>
8010701e:	eb 01                	jmp    80107021 <uartinit+0xe9>
    return;
80107020:	90                   	nop
}
80107021:	c9                   	leave  
80107022:	c3                   	ret    

80107023 <uartputc>:

void
uartputc(int c)
{
80107023:	f3 0f 1e fb          	endbr32 
80107027:	55                   	push   %ebp
80107028:	89 e5                	mov    %esp,%ebp
8010702a:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010702d:	a1 44 c6 10 80       	mov    0x8010c644,%eax
80107032:	85 c0                	test   %eax,%eax
80107034:	74 53                	je     80107089 <uartputc+0x66>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107036:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010703d:	eb 11                	jmp    80107050 <uartputc+0x2d>
    microdelay(10);
8010703f:	83 ec 0c             	sub    $0xc,%esp
80107042:	6a 0a                	push   $0xa
80107044:	e8 8b c1 ff ff       	call   801031d4 <microdelay>
80107049:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010704c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107050:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107054:	7f 1a                	jg     80107070 <uartputc+0x4d>
80107056:	83 ec 0c             	sub    $0xc,%esp
80107059:	68 fd 03 00 00       	push   $0x3fd
8010705e:	e8 97 fe ff ff       	call   80106efa <inb>
80107063:	83 c4 10             	add    $0x10,%esp
80107066:	0f b6 c0             	movzbl %al,%eax
80107069:	83 e0 20             	and    $0x20,%eax
8010706c:	85 c0                	test   %eax,%eax
8010706e:	74 cf                	je     8010703f <uartputc+0x1c>
  outb(COM1+0, c);
80107070:	8b 45 08             	mov    0x8(%ebp),%eax
80107073:	0f b6 c0             	movzbl %al,%eax
80107076:	83 ec 08             	sub    $0x8,%esp
80107079:	50                   	push   %eax
8010707a:	68 f8 03 00 00       	push   $0x3f8
8010707f:	e8 93 fe ff ff       	call   80106f17 <outb>
80107084:	83 c4 10             	add    $0x10,%esp
80107087:	eb 01                	jmp    8010708a <uartputc+0x67>
    return;
80107089:	90                   	nop
}
8010708a:	c9                   	leave  
8010708b:	c3                   	ret    

8010708c <uartgetc>:

static int
uartgetc(void)
{
8010708c:	f3 0f 1e fb          	endbr32 
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107093:	a1 44 c6 10 80       	mov    0x8010c644,%eax
80107098:	85 c0                	test   %eax,%eax
8010709a:	75 07                	jne    801070a3 <uartgetc+0x17>
    return -1;
8010709c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070a1:	eb 2e                	jmp    801070d1 <uartgetc+0x45>
  if(!(inb(COM1+5) & 0x01))
801070a3:	68 fd 03 00 00       	push   $0x3fd
801070a8:	e8 4d fe ff ff       	call   80106efa <inb>
801070ad:	83 c4 04             	add    $0x4,%esp
801070b0:	0f b6 c0             	movzbl %al,%eax
801070b3:	83 e0 01             	and    $0x1,%eax
801070b6:	85 c0                	test   %eax,%eax
801070b8:	75 07                	jne    801070c1 <uartgetc+0x35>
    return -1;
801070ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070bf:	eb 10                	jmp    801070d1 <uartgetc+0x45>
  return inb(COM1+0);
801070c1:	68 f8 03 00 00       	push   $0x3f8
801070c6:	e8 2f fe ff ff       	call   80106efa <inb>
801070cb:	83 c4 04             	add    $0x4,%esp
801070ce:	0f b6 c0             	movzbl %al,%eax
}
801070d1:	c9                   	leave  
801070d2:	c3                   	ret    

801070d3 <uartintr>:

void
uartintr(void)
{
801070d3:	f3 0f 1e fb          	endbr32 
801070d7:	55                   	push   %ebp
801070d8:	89 e5                	mov    %esp,%ebp
801070da:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801070dd:	83 ec 0c             	sub    $0xc,%esp
801070e0:	68 8c 70 10 80       	push   $0x8010708c
801070e5:	e8 be 97 ff ff       	call   801008a8 <consoleintr>
801070ea:	83 c4 10             	add    $0x10,%esp
}
801070ed:	90                   	nop
801070ee:	c9                   	leave  
801070ef:	c3                   	ret    

801070f0 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801070f0:	6a 00                	push   $0x0
  pushl $0
801070f2:	6a 00                	push   $0x0
  jmp alltraps
801070f4:	e9 76 f9 ff ff       	jmp    80106a6f <alltraps>

801070f9 <vector1>:
.globl vector1
vector1:
  pushl $0
801070f9:	6a 00                	push   $0x0
  pushl $1
801070fb:	6a 01                	push   $0x1
  jmp alltraps
801070fd:	e9 6d f9 ff ff       	jmp    80106a6f <alltraps>

80107102 <vector2>:
.globl vector2
vector2:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $2
80107104:	6a 02                	push   $0x2
  jmp alltraps
80107106:	e9 64 f9 ff ff       	jmp    80106a6f <alltraps>

8010710b <vector3>:
.globl vector3
vector3:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $3
8010710d:	6a 03                	push   $0x3
  jmp alltraps
8010710f:	e9 5b f9 ff ff       	jmp    80106a6f <alltraps>

80107114 <vector4>:
.globl vector4
vector4:
  pushl $0
80107114:	6a 00                	push   $0x0
  pushl $4
80107116:	6a 04                	push   $0x4
  jmp alltraps
80107118:	e9 52 f9 ff ff       	jmp    80106a6f <alltraps>

8010711d <vector5>:
.globl vector5
vector5:
  pushl $0
8010711d:	6a 00                	push   $0x0
  pushl $5
8010711f:	6a 05                	push   $0x5
  jmp alltraps
80107121:	e9 49 f9 ff ff       	jmp    80106a6f <alltraps>

80107126 <vector6>:
.globl vector6
vector6:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $6
80107128:	6a 06                	push   $0x6
  jmp alltraps
8010712a:	e9 40 f9 ff ff       	jmp    80106a6f <alltraps>

8010712f <vector7>:
.globl vector7
vector7:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $7
80107131:	6a 07                	push   $0x7
  jmp alltraps
80107133:	e9 37 f9 ff ff       	jmp    80106a6f <alltraps>

80107138 <vector8>:
.globl vector8
vector8:
  pushl $8
80107138:	6a 08                	push   $0x8
  jmp alltraps
8010713a:	e9 30 f9 ff ff       	jmp    80106a6f <alltraps>

8010713f <vector9>:
.globl vector9
vector9:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $9
80107141:	6a 09                	push   $0x9
  jmp alltraps
80107143:	e9 27 f9 ff ff       	jmp    80106a6f <alltraps>

80107148 <vector10>:
.globl vector10
vector10:
  pushl $10
80107148:	6a 0a                	push   $0xa
  jmp alltraps
8010714a:	e9 20 f9 ff ff       	jmp    80106a6f <alltraps>

8010714f <vector11>:
.globl vector11
vector11:
  pushl $11
8010714f:	6a 0b                	push   $0xb
  jmp alltraps
80107151:	e9 19 f9 ff ff       	jmp    80106a6f <alltraps>

80107156 <vector12>:
.globl vector12
vector12:
  pushl $12
80107156:	6a 0c                	push   $0xc
  jmp alltraps
80107158:	e9 12 f9 ff ff       	jmp    80106a6f <alltraps>

8010715d <vector13>:
.globl vector13
vector13:
  pushl $13
8010715d:	6a 0d                	push   $0xd
  jmp alltraps
8010715f:	e9 0b f9 ff ff       	jmp    80106a6f <alltraps>

80107164 <vector14>:
.globl vector14
vector14:
  pushl $14
80107164:	6a 0e                	push   $0xe
  jmp alltraps
80107166:	e9 04 f9 ff ff       	jmp    80106a6f <alltraps>

8010716b <vector15>:
.globl vector15
vector15:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $15
8010716d:	6a 0f                	push   $0xf
  jmp alltraps
8010716f:	e9 fb f8 ff ff       	jmp    80106a6f <alltraps>

80107174 <vector16>:
.globl vector16
vector16:
  pushl $0
80107174:	6a 00                	push   $0x0
  pushl $16
80107176:	6a 10                	push   $0x10
  jmp alltraps
80107178:	e9 f2 f8 ff ff       	jmp    80106a6f <alltraps>

8010717d <vector17>:
.globl vector17
vector17:
  pushl $17
8010717d:	6a 11                	push   $0x11
  jmp alltraps
8010717f:	e9 eb f8 ff ff       	jmp    80106a6f <alltraps>

80107184 <vector18>:
.globl vector18
vector18:
  pushl $0
80107184:	6a 00                	push   $0x0
  pushl $18
80107186:	6a 12                	push   $0x12
  jmp alltraps
80107188:	e9 e2 f8 ff ff       	jmp    80106a6f <alltraps>

8010718d <vector19>:
.globl vector19
vector19:
  pushl $0
8010718d:	6a 00                	push   $0x0
  pushl $19
8010718f:	6a 13                	push   $0x13
  jmp alltraps
80107191:	e9 d9 f8 ff ff       	jmp    80106a6f <alltraps>

80107196 <vector20>:
.globl vector20
vector20:
  pushl $0
80107196:	6a 00                	push   $0x0
  pushl $20
80107198:	6a 14                	push   $0x14
  jmp alltraps
8010719a:	e9 d0 f8 ff ff       	jmp    80106a6f <alltraps>

8010719f <vector21>:
.globl vector21
vector21:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $21
801071a1:	6a 15                	push   $0x15
  jmp alltraps
801071a3:	e9 c7 f8 ff ff       	jmp    80106a6f <alltraps>

801071a8 <vector22>:
.globl vector22
vector22:
  pushl $0
801071a8:	6a 00                	push   $0x0
  pushl $22
801071aa:	6a 16                	push   $0x16
  jmp alltraps
801071ac:	e9 be f8 ff ff       	jmp    80106a6f <alltraps>

801071b1 <vector23>:
.globl vector23
vector23:
  pushl $0
801071b1:	6a 00                	push   $0x0
  pushl $23
801071b3:	6a 17                	push   $0x17
  jmp alltraps
801071b5:	e9 b5 f8 ff ff       	jmp    80106a6f <alltraps>

801071ba <vector24>:
.globl vector24
vector24:
  pushl $0
801071ba:	6a 00                	push   $0x0
  pushl $24
801071bc:	6a 18                	push   $0x18
  jmp alltraps
801071be:	e9 ac f8 ff ff       	jmp    80106a6f <alltraps>

801071c3 <vector25>:
.globl vector25
vector25:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $25
801071c5:	6a 19                	push   $0x19
  jmp alltraps
801071c7:	e9 a3 f8 ff ff       	jmp    80106a6f <alltraps>

801071cc <vector26>:
.globl vector26
vector26:
  pushl $0
801071cc:	6a 00                	push   $0x0
  pushl $26
801071ce:	6a 1a                	push   $0x1a
  jmp alltraps
801071d0:	e9 9a f8 ff ff       	jmp    80106a6f <alltraps>

801071d5 <vector27>:
.globl vector27
vector27:
  pushl $0
801071d5:	6a 00                	push   $0x0
  pushl $27
801071d7:	6a 1b                	push   $0x1b
  jmp alltraps
801071d9:	e9 91 f8 ff ff       	jmp    80106a6f <alltraps>

801071de <vector28>:
.globl vector28
vector28:
  pushl $0
801071de:	6a 00                	push   $0x0
  pushl $28
801071e0:	6a 1c                	push   $0x1c
  jmp alltraps
801071e2:	e9 88 f8 ff ff       	jmp    80106a6f <alltraps>

801071e7 <vector29>:
.globl vector29
vector29:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $29
801071e9:	6a 1d                	push   $0x1d
  jmp alltraps
801071eb:	e9 7f f8 ff ff       	jmp    80106a6f <alltraps>

801071f0 <vector30>:
.globl vector30
vector30:
  pushl $0
801071f0:	6a 00                	push   $0x0
  pushl $30
801071f2:	6a 1e                	push   $0x1e
  jmp alltraps
801071f4:	e9 76 f8 ff ff       	jmp    80106a6f <alltraps>

801071f9 <vector31>:
.globl vector31
vector31:
  pushl $0
801071f9:	6a 00                	push   $0x0
  pushl $31
801071fb:	6a 1f                	push   $0x1f
  jmp alltraps
801071fd:	e9 6d f8 ff ff       	jmp    80106a6f <alltraps>

80107202 <vector32>:
.globl vector32
vector32:
  pushl $0
80107202:	6a 00                	push   $0x0
  pushl $32
80107204:	6a 20                	push   $0x20
  jmp alltraps
80107206:	e9 64 f8 ff ff       	jmp    80106a6f <alltraps>

8010720b <vector33>:
.globl vector33
vector33:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $33
8010720d:	6a 21                	push   $0x21
  jmp alltraps
8010720f:	e9 5b f8 ff ff       	jmp    80106a6f <alltraps>

80107214 <vector34>:
.globl vector34
vector34:
  pushl $0
80107214:	6a 00                	push   $0x0
  pushl $34
80107216:	6a 22                	push   $0x22
  jmp alltraps
80107218:	e9 52 f8 ff ff       	jmp    80106a6f <alltraps>

8010721d <vector35>:
.globl vector35
vector35:
  pushl $0
8010721d:	6a 00                	push   $0x0
  pushl $35
8010721f:	6a 23                	push   $0x23
  jmp alltraps
80107221:	e9 49 f8 ff ff       	jmp    80106a6f <alltraps>

80107226 <vector36>:
.globl vector36
vector36:
  pushl $0
80107226:	6a 00                	push   $0x0
  pushl $36
80107228:	6a 24                	push   $0x24
  jmp alltraps
8010722a:	e9 40 f8 ff ff       	jmp    80106a6f <alltraps>

8010722f <vector37>:
.globl vector37
vector37:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $37
80107231:	6a 25                	push   $0x25
  jmp alltraps
80107233:	e9 37 f8 ff ff       	jmp    80106a6f <alltraps>

80107238 <vector38>:
.globl vector38
vector38:
  pushl $0
80107238:	6a 00                	push   $0x0
  pushl $38
8010723a:	6a 26                	push   $0x26
  jmp alltraps
8010723c:	e9 2e f8 ff ff       	jmp    80106a6f <alltraps>

80107241 <vector39>:
.globl vector39
vector39:
  pushl $0
80107241:	6a 00                	push   $0x0
  pushl $39
80107243:	6a 27                	push   $0x27
  jmp alltraps
80107245:	e9 25 f8 ff ff       	jmp    80106a6f <alltraps>

8010724a <vector40>:
.globl vector40
vector40:
  pushl $0
8010724a:	6a 00                	push   $0x0
  pushl $40
8010724c:	6a 28                	push   $0x28
  jmp alltraps
8010724e:	e9 1c f8 ff ff       	jmp    80106a6f <alltraps>

80107253 <vector41>:
.globl vector41
vector41:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $41
80107255:	6a 29                	push   $0x29
  jmp alltraps
80107257:	e9 13 f8 ff ff       	jmp    80106a6f <alltraps>

8010725c <vector42>:
.globl vector42
vector42:
  pushl $0
8010725c:	6a 00                	push   $0x0
  pushl $42
8010725e:	6a 2a                	push   $0x2a
  jmp alltraps
80107260:	e9 0a f8 ff ff       	jmp    80106a6f <alltraps>

80107265 <vector43>:
.globl vector43
vector43:
  pushl $0
80107265:	6a 00                	push   $0x0
  pushl $43
80107267:	6a 2b                	push   $0x2b
  jmp alltraps
80107269:	e9 01 f8 ff ff       	jmp    80106a6f <alltraps>

8010726e <vector44>:
.globl vector44
vector44:
  pushl $0
8010726e:	6a 00                	push   $0x0
  pushl $44
80107270:	6a 2c                	push   $0x2c
  jmp alltraps
80107272:	e9 f8 f7 ff ff       	jmp    80106a6f <alltraps>

80107277 <vector45>:
.globl vector45
vector45:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $45
80107279:	6a 2d                	push   $0x2d
  jmp alltraps
8010727b:	e9 ef f7 ff ff       	jmp    80106a6f <alltraps>

80107280 <vector46>:
.globl vector46
vector46:
  pushl $0
80107280:	6a 00                	push   $0x0
  pushl $46
80107282:	6a 2e                	push   $0x2e
  jmp alltraps
80107284:	e9 e6 f7 ff ff       	jmp    80106a6f <alltraps>

80107289 <vector47>:
.globl vector47
vector47:
  pushl $0
80107289:	6a 00                	push   $0x0
  pushl $47
8010728b:	6a 2f                	push   $0x2f
  jmp alltraps
8010728d:	e9 dd f7 ff ff       	jmp    80106a6f <alltraps>

80107292 <vector48>:
.globl vector48
vector48:
  pushl $0
80107292:	6a 00                	push   $0x0
  pushl $48
80107294:	6a 30                	push   $0x30
  jmp alltraps
80107296:	e9 d4 f7 ff ff       	jmp    80106a6f <alltraps>

8010729b <vector49>:
.globl vector49
vector49:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $49
8010729d:	6a 31                	push   $0x31
  jmp alltraps
8010729f:	e9 cb f7 ff ff       	jmp    80106a6f <alltraps>

801072a4 <vector50>:
.globl vector50
vector50:
  pushl $0
801072a4:	6a 00                	push   $0x0
  pushl $50
801072a6:	6a 32                	push   $0x32
  jmp alltraps
801072a8:	e9 c2 f7 ff ff       	jmp    80106a6f <alltraps>

801072ad <vector51>:
.globl vector51
vector51:
  pushl $0
801072ad:	6a 00                	push   $0x0
  pushl $51
801072af:	6a 33                	push   $0x33
  jmp alltraps
801072b1:	e9 b9 f7 ff ff       	jmp    80106a6f <alltraps>

801072b6 <vector52>:
.globl vector52
vector52:
  pushl $0
801072b6:	6a 00                	push   $0x0
  pushl $52
801072b8:	6a 34                	push   $0x34
  jmp alltraps
801072ba:	e9 b0 f7 ff ff       	jmp    80106a6f <alltraps>

801072bf <vector53>:
.globl vector53
vector53:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $53
801072c1:	6a 35                	push   $0x35
  jmp alltraps
801072c3:	e9 a7 f7 ff ff       	jmp    80106a6f <alltraps>

801072c8 <vector54>:
.globl vector54
vector54:
  pushl $0
801072c8:	6a 00                	push   $0x0
  pushl $54
801072ca:	6a 36                	push   $0x36
  jmp alltraps
801072cc:	e9 9e f7 ff ff       	jmp    80106a6f <alltraps>

801072d1 <vector55>:
.globl vector55
vector55:
  pushl $0
801072d1:	6a 00                	push   $0x0
  pushl $55
801072d3:	6a 37                	push   $0x37
  jmp alltraps
801072d5:	e9 95 f7 ff ff       	jmp    80106a6f <alltraps>

801072da <vector56>:
.globl vector56
vector56:
  pushl $0
801072da:	6a 00                	push   $0x0
  pushl $56
801072dc:	6a 38                	push   $0x38
  jmp alltraps
801072de:	e9 8c f7 ff ff       	jmp    80106a6f <alltraps>

801072e3 <vector57>:
.globl vector57
vector57:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $57
801072e5:	6a 39                	push   $0x39
  jmp alltraps
801072e7:	e9 83 f7 ff ff       	jmp    80106a6f <alltraps>

801072ec <vector58>:
.globl vector58
vector58:
  pushl $0
801072ec:	6a 00                	push   $0x0
  pushl $58
801072ee:	6a 3a                	push   $0x3a
  jmp alltraps
801072f0:	e9 7a f7 ff ff       	jmp    80106a6f <alltraps>

801072f5 <vector59>:
.globl vector59
vector59:
  pushl $0
801072f5:	6a 00                	push   $0x0
  pushl $59
801072f7:	6a 3b                	push   $0x3b
  jmp alltraps
801072f9:	e9 71 f7 ff ff       	jmp    80106a6f <alltraps>

801072fe <vector60>:
.globl vector60
vector60:
  pushl $0
801072fe:	6a 00                	push   $0x0
  pushl $60
80107300:	6a 3c                	push   $0x3c
  jmp alltraps
80107302:	e9 68 f7 ff ff       	jmp    80106a6f <alltraps>

80107307 <vector61>:
.globl vector61
vector61:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $61
80107309:	6a 3d                	push   $0x3d
  jmp alltraps
8010730b:	e9 5f f7 ff ff       	jmp    80106a6f <alltraps>

80107310 <vector62>:
.globl vector62
vector62:
  pushl $0
80107310:	6a 00                	push   $0x0
  pushl $62
80107312:	6a 3e                	push   $0x3e
  jmp alltraps
80107314:	e9 56 f7 ff ff       	jmp    80106a6f <alltraps>

80107319 <vector63>:
.globl vector63
vector63:
  pushl $0
80107319:	6a 00                	push   $0x0
  pushl $63
8010731b:	6a 3f                	push   $0x3f
  jmp alltraps
8010731d:	e9 4d f7 ff ff       	jmp    80106a6f <alltraps>

80107322 <vector64>:
.globl vector64
vector64:
  pushl $0
80107322:	6a 00                	push   $0x0
  pushl $64
80107324:	6a 40                	push   $0x40
  jmp alltraps
80107326:	e9 44 f7 ff ff       	jmp    80106a6f <alltraps>

8010732b <vector65>:
.globl vector65
vector65:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $65
8010732d:	6a 41                	push   $0x41
  jmp alltraps
8010732f:	e9 3b f7 ff ff       	jmp    80106a6f <alltraps>

80107334 <vector66>:
.globl vector66
vector66:
  pushl $0
80107334:	6a 00                	push   $0x0
  pushl $66
80107336:	6a 42                	push   $0x42
  jmp alltraps
80107338:	e9 32 f7 ff ff       	jmp    80106a6f <alltraps>

8010733d <vector67>:
.globl vector67
vector67:
  pushl $0
8010733d:	6a 00                	push   $0x0
  pushl $67
8010733f:	6a 43                	push   $0x43
  jmp alltraps
80107341:	e9 29 f7 ff ff       	jmp    80106a6f <alltraps>

80107346 <vector68>:
.globl vector68
vector68:
  pushl $0
80107346:	6a 00                	push   $0x0
  pushl $68
80107348:	6a 44                	push   $0x44
  jmp alltraps
8010734a:	e9 20 f7 ff ff       	jmp    80106a6f <alltraps>

8010734f <vector69>:
.globl vector69
vector69:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $69
80107351:	6a 45                	push   $0x45
  jmp alltraps
80107353:	e9 17 f7 ff ff       	jmp    80106a6f <alltraps>

80107358 <vector70>:
.globl vector70
vector70:
  pushl $0
80107358:	6a 00                	push   $0x0
  pushl $70
8010735a:	6a 46                	push   $0x46
  jmp alltraps
8010735c:	e9 0e f7 ff ff       	jmp    80106a6f <alltraps>

80107361 <vector71>:
.globl vector71
vector71:
  pushl $0
80107361:	6a 00                	push   $0x0
  pushl $71
80107363:	6a 47                	push   $0x47
  jmp alltraps
80107365:	e9 05 f7 ff ff       	jmp    80106a6f <alltraps>

8010736a <vector72>:
.globl vector72
vector72:
  pushl $0
8010736a:	6a 00                	push   $0x0
  pushl $72
8010736c:	6a 48                	push   $0x48
  jmp alltraps
8010736e:	e9 fc f6 ff ff       	jmp    80106a6f <alltraps>

80107373 <vector73>:
.globl vector73
vector73:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $73
80107375:	6a 49                	push   $0x49
  jmp alltraps
80107377:	e9 f3 f6 ff ff       	jmp    80106a6f <alltraps>

8010737c <vector74>:
.globl vector74
vector74:
  pushl $0
8010737c:	6a 00                	push   $0x0
  pushl $74
8010737e:	6a 4a                	push   $0x4a
  jmp alltraps
80107380:	e9 ea f6 ff ff       	jmp    80106a6f <alltraps>

80107385 <vector75>:
.globl vector75
vector75:
  pushl $0
80107385:	6a 00                	push   $0x0
  pushl $75
80107387:	6a 4b                	push   $0x4b
  jmp alltraps
80107389:	e9 e1 f6 ff ff       	jmp    80106a6f <alltraps>

8010738e <vector76>:
.globl vector76
vector76:
  pushl $0
8010738e:	6a 00                	push   $0x0
  pushl $76
80107390:	6a 4c                	push   $0x4c
  jmp alltraps
80107392:	e9 d8 f6 ff ff       	jmp    80106a6f <alltraps>

80107397 <vector77>:
.globl vector77
vector77:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $77
80107399:	6a 4d                	push   $0x4d
  jmp alltraps
8010739b:	e9 cf f6 ff ff       	jmp    80106a6f <alltraps>

801073a0 <vector78>:
.globl vector78
vector78:
  pushl $0
801073a0:	6a 00                	push   $0x0
  pushl $78
801073a2:	6a 4e                	push   $0x4e
  jmp alltraps
801073a4:	e9 c6 f6 ff ff       	jmp    80106a6f <alltraps>

801073a9 <vector79>:
.globl vector79
vector79:
  pushl $0
801073a9:	6a 00                	push   $0x0
  pushl $79
801073ab:	6a 4f                	push   $0x4f
  jmp alltraps
801073ad:	e9 bd f6 ff ff       	jmp    80106a6f <alltraps>

801073b2 <vector80>:
.globl vector80
vector80:
  pushl $0
801073b2:	6a 00                	push   $0x0
  pushl $80
801073b4:	6a 50                	push   $0x50
  jmp alltraps
801073b6:	e9 b4 f6 ff ff       	jmp    80106a6f <alltraps>

801073bb <vector81>:
.globl vector81
vector81:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $81
801073bd:	6a 51                	push   $0x51
  jmp alltraps
801073bf:	e9 ab f6 ff ff       	jmp    80106a6f <alltraps>

801073c4 <vector82>:
.globl vector82
vector82:
  pushl $0
801073c4:	6a 00                	push   $0x0
  pushl $82
801073c6:	6a 52                	push   $0x52
  jmp alltraps
801073c8:	e9 a2 f6 ff ff       	jmp    80106a6f <alltraps>

801073cd <vector83>:
.globl vector83
vector83:
  pushl $0
801073cd:	6a 00                	push   $0x0
  pushl $83
801073cf:	6a 53                	push   $0x53
  jmp alltraps
801073d1:	e9 99 f6 ff ff       	jmp    80106a6f <alltraps>

801073d6 <vector84>:
.globl vector84
vector84:
  pushl $0
801073d6:	6a 00                	push   $0x0
  pushl $84
801073d8:	6a 54                	push   $0x54
  jmp alltraps
801073da:	e9 90 f6 ff ff       	jmp    80106a6f <alltraps>

801073df <vector85>:
.globl vector85
vector85:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $85
801073e1:	6a 55                	push   $0x55
  jmp alltraps
801073e3:	e9 87 f6 ff ff       	jmp    80106a6f <alltraps>

801073e8 <vector86>:
.globl vector86
vector86:
  pushl $0
801073e8:	6a 00                	push   $0x0
  pushl $86
801073ea:	6a 56                	push   $0x56
  jmp alltraps
801073ec:	e9 7e f6 ff ff       	jmp    80106a6f <alltraps>

801073f1 <vector87>:
.globl vector87
vector87:
  pushl $0
801073f1:	6a 00                	push   $0x0
  pushl $87
801073f3:	6a 57                	push   $0x57
  jmp alltraps
801073f5:	e9 75 f6 ff ff       	jmp    80106a6f <alltraps>

801073fa <vector88>:
.globl vector88
vector88:
  pushl $0
801073fa:	6a 00                	push   $0x0
  pushl $88
801073fc:	6a 58                	push   $0x58
  jmp alltraps
801073fe:	e9 6c f6 ff ff       	jmp    80106a6f <alltraps>

80107403 <vector89>:
.globl vector89
vector89:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $89
80107405:	6a 59                	push   $0x59
  jmp alltraps
80107407:	e9 63 f6 ff ff       	jmp    80106a6f <alltraps>

8010740c <vector90>:
.globl vector90
vector90:
  pushl $0
8010740c:	6a 00                	push   $0x0
  pushl $90
8010740e:	6a 5a                	push   $0x5a
  jmp alltraps
80107410:	e9 5a f6 ff ff       	jmp    80106a6f <alltraps>

80107415 <vector91>:
.globl vector91
vector91:
  pushl $0
80107415:	6a 00                	push   $0x0
  pushl $91
80107417:	6a 5b                	push   $0x5b
  jmp alltraps
80107419:	e9 51 f6 ff ff       	jmp    80106a6f <alltraps>

8010741e <vector92>:
.globl vector92
vector92:
  pushl $0
8010741e:	6a 00                	push   $0x0
  pushl $92
80107420:	6a 5c                	push   $0x5c
  jmp alltraps
80107422:	e9 48 f6 ff ff       	jmp    80106a6f <alltraps>

80107427 <vector93>:
.globl vector93
vector93:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $93
80107429:	6a 5d                	push   $0x5d
  jmp alltraps
8010742b:	e9 3f f6 ff ff       	jmp    80106a6f <alltraps>

80107430 <vector94>:
.globl vector94
vector94:
  pushl $0
80107430:	6a 00                	push   $0x0
  pushl $94
80107432:	6a 5e                	push   $0x5e
  jmp alltraps
80107434:	e9 36 f6 ff ff       	jmp    80106a6f <alltraps>

80107439 <vector95>:
.globl vector95
vector95:
  pushl $0
80107439:	6a 00                	push   $0x0
  pushl $95
8010743b:	6a 5f                	push   $0x5f
  jmp alltraps
8010743d:	e9 2d f6 ff ff       	jmp    80106a6f <alltraps>

80107442 <vector96>:
.globl vector96
vector96:
  pushl $0
80107442:	6a 00                	push   $0x0
  pushl $96
80107444:	6a 60                	push   $0x60
  jmp alltraps
80107446:	e9 24 f6 ff ff       	jmp    80106a6f <alltraps>

8010744b <vector97>:
.globl vector97
vector97:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $97
8010744d:	6a 61                	push   $0x61
  jmp alltraps
8010744f:	e9 1b f6 ff ff       	jmp    80106a6f <alltraps>

80107454 <vector98>:
.globl vector98
vector98:
  pushl $0
80107454:	6a 00                	push   $0x0
  pushl $98
80107456:	6a 62                	push   $0x62
  jmp alltraps
80107458:	e9 12 f6 ff ff       	jmp    80106a6f <alltraps>

8010745d <vector99>:
.globl vector99
vector99:
  pushl $0
8010745d:	6a 00                	push   $0x0
  pushl $99
8010745f:	6a 63                	push   $0x63
  jmp alltraps
80107461:	e9 09 f6 ff ff       	jmp    80106a6f <alltraps>

80107466 <vector100>:
.globl vector100
vector100:
  pushl $0
80107466:	6a 00                	push   $0x0
  pushl $100
80107468:	6a 64                	push   $0x64
  jmp alltraps
8010746a:	e9 00 f6 ff ff       	jmp    80106a6f <alltraps>

8010746f <vector101>:
.globl vector101
vector101:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $101
80107471:	6a 65                	push   $0x65
  jmp alltraps
80107473:	e9 f7 f5 ff ff       	jmp    80106a6f <alltraps>

80107478 <vector102>:
.globl vector102
vector102:
  pushl $0
80107478:	6a 00                	push   $0x0
  pushl $102
8010747a:	6a 66                	push   $0x66
  jmp alltraps
8010747c:	e9 ee f5 ff ff       	jmp    80106a6f <alltraps>

80107481 <vector103>:
.globl vector103
vector103:
  pushl $0
80107481:	6a 00                	push   $0x0
  pushl $103
80107483:	6a 67                	push   $0x67
  jmp alltraps
80107485:	e9 e5 f5 ff ff       	jmp    80106a6f <alltraps>

8010748a <vector104>:
.globl vector104
vector104:
  pushl $0
8010748a:	6a 00                	push   $0x0
  pushl $104
8010748c:	6a 68                	push   $0x68
  jmp alltraps
8010748e:	e9 dc f5 ff ff       	jmp    80106a6f <alltraps>

80107493 <vector105>:
.globl vector105
vector105:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $105
80107495:	6a 69                	push   $0x69
  jmp alltraps
80107497:	e9 d3 f5 ff ff       	jmp    80106a6f <alltraps>

8010749c <vector106>:
.globl vector106
vector106:
  pushl $0
8010749c:	6a 00                	push   $0x0
  pushl $106
8010749e:	6a 6a                	push   $0x6a
  jmp alltraps
801074a0:	e9 ca f5 ff ff       	jmp    80106a6f <alltraps>

801074a5 <vector107>:
.globl vector107
vector107:
  pushl $0
801074a5:	6a 00                	push   $0x0
  pushl $107
801074a7:	6a 6b                	push   $0x6b
  jmp alltraps
801074a9:	e9 c1 f5 ff ff       	jmp    80106a6f <alltraps>

801074ae <vector108>:
.globl vector108
vector108:
  pushl $0
801074ae:	6a 00                	push   $0x0
  pushl $108
801074b0:	6a 6c                	push   $0x6c
  jmp alltraps
801074b2:	e9 b8 f5 ff ff       	jmp    80106a6f <alltraps>

801074b7 <vector109>:
.globl vector109
vector109:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $109
801074b9:	6a 6d                	push   $0x6d
  jmp alltraps
801074bb:	e9 af f5 ff ff       	jmp    80106a6f <alltraps>

801074c0 <vector110>:
.globl vector110
vector110:
  pushl $0
801074c0:	6a 00                	push   $0x0
  pushl $110
801074c2:	6a 6e                	push   $0x6e
  jmp alltraps
801074c4:	e9 a6 f5 ff ff       	jmp    80106a6f <alltraps>

801074c9 <vector111>:
.globl vector111
vector111:
  pushl $0
801074c9:	6a 00                	push   $0x0
  pushl $111
801074cb:	6a 6f                	push   $0x6f
  jmp alltraps
801074cd:	e9 9d f5 ff ff       	jmp    80106a6f <alltraps>

801074d2 <vector112>:
.globl vector112
vector112:
  pushl $0
801074d2:	6a 00                	push   $0x0
  pushl $112
801074d4:	6a 70                	push   $0x70
  jmp alltraps
801074d6:	e9 94 f5 ff ff       	jmp    80106a6f <alltraps>

801074db <vector113>:
.globl vector113
vector113:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $113
801074dd:	6a 71                	push   $0x71
  jmp alltraps
801074df:	e9 8b f5 ff ff       	jmp    80106a6f <alltraps>

801074e4 <vector114>:
.globl vector114
vector114:
  pushl $0
801074e4:	6a 00                	push   $0x0
  pushl $114
801074e6:	6a 72                	push   $0x72
  jmp alltraps
801074e8:	e9 82 f5 ff ff       	jmp    80106a6f <alltraps>

801074ed <vector115>:
.globl vector115
vector115:
  pushl $0
801074ed:	6a 00                	push   $0x0
  pushl $115
801074ef:	6a 73                	push   $0x73
  jmp alltraps
801074f1:	e9 79 f5 ff ff       	jmp    80106a6f <alltraps>

801074f6 <vector116>:
.globl vector116
vector116:
  pushl $0
801074f6:	6a 00                	push   $0x0
  pushl $116
801074f8:	6a 74                	push   $0x74
  jmp alltraps
801074fa:	e9 70 f5 ff ff       	jmp    80106a6f <alltraps>

801074ff <vector117>:
.globl vector117
vector117:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $117
80107501:	6a 75                	push   $0x75
  jmp alltraps
80107503:	e9 67 f5 ff ff       	jmp    80106a6f <alltraps>

80107508 <vector118>:
.globl vector118
vector118:
  pushl $0
80107508:	6a 00                	push   $0x0
  pushl $118
8010750a:	6a 76                	push   $0x76
  jmp alltraps
8010750c:	e9 5e f5 ff ff       	jmp    80106a6f <alltraps>

80107511 <vector119>:
.globl vector119
vector119:
  pushl $0
80107511:	6a 00                	push   $0x0
  pushl $119
80107513:	6a 77                	push   $0x77
  jmp alltraps
80107515:	e9 55 f5 ff ff       	jmp    80106a6f <alltraps>

8010751a <vector120>:
.globl vector120
vector120:
  pushl $0
8010751a:	6a 00                	push   $0x0
  pushl $120
8010751c:	6a 78                	push   $0x78
  jmp alltraps
8010751e:	e9 4c f5 ff ff       	jmp    80106a6f <alltraps>

80107523 <vector121>:
.globl vector121
vector121:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $121
80107525:	6a 79                	push   $0x79
  jmp alltraps
80107527:	e9 43 f5 ff ff       	jmp    80106a6f <alltraps>

8010752c <vector122>:
.globl vector122
vector122:
  pushl $0
8010752c:	6a 00                	push   $0x0
  pushl $122
8010752e:	6a 7a                	push   $0x7a
  jmp alltraps
80107530:	e9 3a f5 ff ff       	jmp    80106a6f <alltraps>

80107535 <vector123>:
.globl vector123
vector123:
  pushl $0
80107535:	6a 00                	push   $0x0
  pushl $123
80107537:	6a 7b                	push   $0x7b
  jmp alltraps
80107539:	e9 31 f5 ff ff       	jmp    80106a6f <alltraps>

8010753e <vector124>:
.globl vector124
vector124:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $124
80107540:	6a 7c                	push   $0x7c
  jmp alltraps
80107542:	e9 28 f5 ff ff       	jmp    80106a6f <alltraps>

80107547 <vector125>:
.globl vector125
vector125:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $125
80107549:	6a 7d                	push   $0x7d
  jmp alltraps
8010754b:	e9 1f f5 ff ff       	jmp    80106a6f <alltraps>

80107550 <vector126>:
.globl vector126
vector126:
  pushl $0
80107550:	6a 00                	push   $0x0
  pushl $126
80107552:	6a 7e                	push   $0x7e
  jmp alltraps
80107554:	e9 16 f5 ff ff       	jmp    80106a6f <alltraps>

80107559 <vector127>:
.globl vector127
vector127:
  pushl $0
80107559:	6a 00                	push   $0x0
  pushl $127
8010755b:	6a 7f                	push   $0x7f
  jmp alltraps
8010755d:	e9 0d f5 ff ff       	jmp    80106a6f <alltraps>

80107562 <vector128>:
.globl vector128
vector128:
  pushl $0
80107562:	6a 00                	push   $0x0
  pushl $128
80107564:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107569:	e9 01 f5 ff ff       	jmp    80106a6f <alltraps>

8010756e <vector129>:
.globl vector129
vector129:
  pushl $0
8010756e:	6a 00                	push   $0x0
  pushl $129
80107570:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107575:	e9 f5 f4 ff ff       	jmp    80106a6f <alltraps>

8010757a <vector130>:
.globl vector130
vector130:
  pushl $0
8010757a:	6a 00                	push   $0x0
  pushl $130
8010757c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107581:	e9 e9 f4 ff ff       	jmp    80106a6f <alltraps>

80107586 <vector131>:
.globl vector131
vector131:
  pushl $0
80107586:	6a 00                	push   $0x0
  pushl $131
80107588:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010758d:	e9 dd f4 ff ff       	jmp    80106a6f <alltraps>

80107592 <vector132>:
.globl vector132
vector132:
  pushl $0
80107592:	6a 00                	push   $0x0
  pushl $132
80107594:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107599:	e9 d1 f4 ff ff       	jmp    80106a6f <alltraps>

8010759e <vector133>:
.globl vector133
vector133:
  pushl $0
8010759e:	6a 00                	push   $0x0
  pushl $133
801075a0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801075a5:	e9 c5 f4 ff ff       	jmp    80106a6f <alltraps>

801075aa <vector134>:
.globl vector134
vector134:
  pushl $0
801075aa:	6a 00                	push   $0x0
  pushl $134
801075ac:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801075b1:	e9 b9 f4 ff ff       	jmp    80106a6f <alltraps>

801075b6 <vector135>:
.globl vector135
vector135:
  pushl $0
801075b6:	6a 00                	push   $0x0
  pushl $135
801075b8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801075bd:	e9 ad f4 ff ff       	jmp    80106a6f <alltraps>

801075c2 <vector136>:
.globl vector136
vector136:
  pushl $0
801075c2:	6a 00                	push   $0x0
  pushl $136
801075c4:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801075c9:	e9 a1 f4 ff ff       	jmp    80106a6f <alltraps>

801075ce <vector137>:
.globl vector137
vector137:
  pushl $0
801075ce:	6a 00                	push   $0x0
  pushl $137
801075d0:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801075d5:	e9 95 f4 ff ff       	jmp    80106a6f <alltraps>

801075da <vector138>:
.globl vector138
vector138:
  pushl $0
801075da:	6a 00                	push   $0x0
  pushl $138
801075dc:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801075e1:	e9 89 f4 ff ff       	jmp    80106a6f <alltraps>

801075e6 <vector139>:
.globl vector139
vector139:
  pushl $0
801075e6:	6a 00                	push   $0x0
  pushl $139
801075e8:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801075ed:	e9 7d f4 ff ff       	jmp    80106a6f <alltraps>

801075f2 <vector140>:
.globl vector140
vector140:
  pushl $0
801075f2:	6a 00                	push   $0x0
  pushl $140
801075f4:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801075f9:	e9 71 f4 ff ff       	jmp    80106a6f <alltraps>

801075fe <vector141>:
.globl vector141
vector141:
  pushl $0
801075fe:	6a 00                	push   $0x0
  pushl $141
80107600:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107605:	e9 65 f4 ff ff       	jmp    80106a6f <alltraps>

8010760a <vector142>:
.globl vector142
vector142:
  pushl $0
8010760a:	6a 00                	push   $0x0
  pushl $142
8010760c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107611:	e9 59 f4 ff ff       	jmp    80106a6f <alltraps>

80107616 <vector143>:
.globl vector143
vector143:
  pushl $0
80107616:	6a 00                	push   $0x0
  pushl $143
80107618:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010761d:	e9 4d f4 ff ff       	jmp    80106a6f <alltraps>

80107622 <vector144>:
.globl vector144
vector144:
  pushl $0
80107622:	6a 00                	push   $0x0
  pushl $144
80107624:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107629:	e9 41 f4 ff ff       	jmp    80106a6f <alltraps>

8010762e <vector145>:
.globl vector145
vector145:
  pushl $0
8010762e:	6a 00                	push   $0x0
  pushl $145
80107630:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107635:	e9 35 f4 ff ff       	jmp    80106a6f <alltraps>

8010763a <vector146>:
.globl vector146
vector146:
  pushl $0
8010763a:	6a 00                	push   $0x0
  pushl $146
8010763c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107641:	e9 29 f4 ff ff       	jmp    80106a6f <alltraps>

80107646 <vector147>:
.globl vector147
vector147:
  pushl $0
80107646:	6a 00                	push   $0x0
  pushl $147
80107648:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010764d:	e9 1d f4 ff ff       	jmp    80106a6f <alltraps>

80107652 <vector148>:
.globl vector148
vector148:
  pushl $0
80107652:	6a 00                	push   $0x0
  pushl $148
80107654:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107659:	e9 11 f4 ff ff       	jmp    80106a6f <alltraps>

8010765e <vector149>:
.globl vector149
vector149:
  pushl $0
8010765e:	6a 00                	push   $0x0
  pushl $149
80107660:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107665:	e9 05 f4 ff ff       	jmp    80106a6f <alltraps>

8010766a <vector150>:
.globl vector150
vector150:
  pushl $0
8010766a:	6a 00                	push   $0x0
  pushl $150
8010766c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107671:	e9 f9 f3 ff ff       	jmp    80106a6f <alltraps>

80107676 <vector151>:
.globl vector151
vector151:
  pushl $0
80107676:	6a 00                	push   $0x0
  pushl $151
80107678:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010767d:	e9 ed f3 ff ff       	jmp    80106a6f <alltraps>

80107682 <vector152>:
.globl vector152
vector152:
  pushl $0
80107682:	6a 00                	push   $0x0
  pushl $152
80107684:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107689:	e9 e1 f3 ff ff       	jmp    80106a6f <alltraps>

8010768e <vector153>:
.globl vector153
vector153:
  pushl $0
8010768e:	6a 00                	push   $0x0
  pushl $153
80107690:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107695:	e9 d5 f3 ff ff       	jmp    80106a6f <alltraps>

8010769a <vector154>:
.globl vector154
vector154:
  pushl $0
8010769a:	6a 00                	push   $0x0
  pushl $154
8010769c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801076a1:	e9 c9 f3 ff ff       	jmp    80106a6f <alltraps>

801076a6 <vector155>:
.globl vector155
vector155:
  pushl $0
801076a6:	6a 00                	push   $0x0
  pushl $155
801076a8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801076ad:	e9 bd f3 ff ff       	jmp    80106a6f <alltraps>

801076b2 <vector156>:
.globl vector156
vector156:
  pushl $0
801076b2:	6a 00                	push   $0x0
  pushl $156
801076b4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801076b9:	e9 b1 f3 ff ff       	jmp    80106a6f <alltraps>

801076be <vector157>:
.globl vector157
vector157:
  pushl $0
801076be:	6a 00                	push   $0x0
  pushl $157
801076c0:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801076c5:	e9 a5 f3 ff ff       	jmp    80106a6f <alltraps>

801076ca <vector158>:
.globl vector158
vector158:
  pushl $0
801076ca:	6a 00                	push   $0x0
  pushl $158
801076cc:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801076d1:	e9 99 f3 ff ff       	jmp    80106a6f <alltraps>

801076d6 <vector159>:
.globl vector159
vector159:
  pushl $0
801076d6:	6a 00                	push   $0x0
  pushl $159
801076d8:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801076dd:	e9 8d f3 ff ff       	jmp    80106a6f <alltraps>

801076e2 <vector160>:
.globl vector160
vector160:
  pushl $0
801076e2:	6a 00                	push   $0x0
  pushl $160
801076e4:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801076e9:	e9 81 f3 ff ff       	jmp    80106a6f <alltraps>

801076ee <vector161>:
.globl vector161
vector161:
  pushl $0
801076ee:	6a 00                	push   $0x0
  pushl $161
801076f0:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801076f5:	e9 75 f3 ff ff       	jmp    80106a6f <alltraps>

801076fa <vector162>:
.globl vector162
vector162:
  pushl $0
801076fa:	6a 00                	push   $0x0
  pushl $162
801076fc:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107701:	e9 69 f3 ff ff       	jmp    80106a6f <alltraps>

80107706 <vector163>:
.globl vector163
vector163:
  pushl $0
80107706:	6a 00                	push   $0x0
  pushl $163
80107708:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010770d:	e9 5d f3 ff ff       	jmp    80106a6f <alltraps>

80107712 <vector164>:
.globl vector164
vector164:
  pushl $0
80107712:	6a 00                	push   $0x0
  pushl $164
80107714:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107719:	e9 51 f3 ff ff       	jmp    80106a6f <alltraps>

8010771e <vector165>:
.globl vector165
vector165:
  pushl $0
8010771e:	6a 00                	push   $0x0
  pushl $165
80107720:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107725:	e9 45 f3 ff ff       	jmp    80106a6f <alltraps>

8010772a <vector166>:
.globl vector166
vector166:
  pushl $0
8010772a:	6a 00                	push   $0x0
  pushl $166
8010772c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107731:	e9 39 f3 ff ff       	jmp    80106a6f <alltraps>

80107736 <vector167>:
.globl vector167
vector167:
  pushl $0
80107736:	6a 00                	push   $0x0
  pushl $167
80107738:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010773d:	e9 2d f3 ff ff       	jmp    80106a6f <alltraps>

80107742 <vector168>:
.globl vector168
vector168:
  pushl $0
80107742:	6a 00                	push   $0x0
  pushl $168
80107744:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107749:	e9 21 f3 ff ff       	jmp    80106a6f <alltraps>

8010774e <vector169>:
.globl vector169
vector169:
  pushl $0
8010774e:	6a 00                	push   $0x0
  pushl $169
80107750:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107755:	e9 15 f3 ff ff       	jmp    80106a6f <alltraps>

8010775a <vector170>:
.globl vector170
vector170:
  pushl $0
8010775a:	6a 00                	push   $0x0
  pushl $170
8010775c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107761:	e9 09 f3 ff ff       	jmp    80106a6f <alltraps>

80107766 <vector171>:
.globl vector171
vector171:
  pushl $0
80107766:	6a 00                	push   $0x0
  pushl $171
80107768:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010776d:	e9 fd f2 ff ff       	jmp    80106a6f <alltraps>

80107772 <vector172>:
.globl vector172
vector172:
  pushl $0
80107772:	6a 00                	push   $0x0
  pushl $172
80107774:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107779:	e9 f1 f2 ff ff       	jmp    80106a6f <alltraps>

8010777e <vector173>:
.globl vector173
vector173:
  pushl $0
8010777e:	6a 00                	push   $0x0
  pushl $173
80107780:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107785:	e9 e5 f2 ff ff       	jmp    80106a6f <alltraps>

8010778a <vector174>:
.globl vector174
vector174:
  pushl $0
8010778a:	6a 00                	push   $0x0
  pushl $174
8010778c:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107791:	e9 d9 f2 ff ff       	jmp    80106a6f <alltraps>

80107796 <vector175>:
.globl vector175
vector175:
  pushl $0
80107796:	6a 00                	push   $0x0
  pushl $175
80107798:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010779d:	e9 cd f2 ff ff       	jmp    80106a6f <alltraps>

801077a2 <vector176>:
.globl vector176
vector176:
  pushl $0
801077a2:	6a 00                	push   $0x0
  pushl $176
801077a4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801077a9:	e9 c1 f2 ff ff       	jmp    80106a6f <alltraps>

801077ae <vector177>:
.globl vector177
vector177:
  pushl $0
801077ae:	6a 00                	push   $0x0
  pushl $177
801077b0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801077b5:	e9 b5 f2 ff ff       	jmp    80106a6f <alltraps>

801077ba <vector178>:
.globl vector178
vector178:
  pushl $0
801077ba:	6a 00                	push   $0x0
  pushl $178
801077bc:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801077c1:	e9 a9 f2 ff ff       	jmp    80106a6f <alltraps>

801077c6 <vector179>:
.globl vector179
vector179:
  pushl $0
801077c6:	6a 00                	push   $0x0
  pushl $179
801077c8:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801077cd:	e9 9d f2 ff ff       	jmp    80106a6f <alltraps>

801077d2 <vector180>:
.globl vector180
vector180:
  pushl $0
801077d2:	6a 00                	push   $0x0
  pushl $180
801077d4:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801077d9:	e9 91 f2 ff ff       	jmp    80106a6f <alltraps>

801077de <vector181>:
.globl vector181
vector181:
  pushl $0
801077de:	6a 00                	push   $0x0
  pushl $181
801077e0:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801077e5:	e9 85 f2 ff ff       	jmp    80106a6f <alltraps>

801077ea <vector182>:
.globl vector182
vector182:
  pushl $0
801077ea:	6a 00                	push   $0x0
  pushl $182
801077ec:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801077f1:	e9 79 f2 ff ff       	jmp    80106a6f <alltraps>

801077f6 <vector183>:
.globl vector183
vector183:
  pushl $0
801077f6:	6a 00                	push   $0x0
  pushl $183
801077f8:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801077fd:	e9 6d f2 ff ff       	jmp    80106a6f <alltraps>

80107802 <vector184>:
.globl vector184
vector184:
  pushl $0
80107802:	6a 00                	push   $0x0
  pushl $184
80107804:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107809:	e9 61 f2 ff ff       	jmp    80106a6f <alltraps>

8010780e <vector185>:
.globl vector185
vector185:
  pushl $0
8010780e:	6a 00                	push   $0x0
  pushl $185
80107810:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107815:	e9 55 f2 ff ff       	jmp    80106a6f <alltraps>

8010781a <vector186>:
.globl vector186
vector186:
  pushl $0
8010781a:	6a 00                	push   $0x0
  pushl $186
8010781c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107821:	e9 49 f2 ff ff       	jmp    80106a6f <alltraps>

80107826 <vector187>:
.globl vector187
vector187:
  pushl $0
80107826:	6a 00                	push   $0x0
  pushl $187
80107828:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010782d:	e9 3d f2 ff ff       	jmp    80106a6f <alltraps>

80107832 <vector188>:
.globl vector188
vector188:
  pushl $0
80107832:	6a 00                	push   $0x0
  pushl $188
80107834:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107839:	e9 31 f2 ff ff       	jmp    80106a6f <alltraps>

8010783e <vector189>:
.globl vector189
vector189:
  pushl $0
8010783e:	6a 00                	push   $0x0
  pushl $189
80107840:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107845:	e9 25 f2 ff ff       	jmp    80106a6f <alltraps>

8010784a <vector190>:
.globl vector190
vector190:
  pushl $0
8010784a:	6a 00                	push   $0x0
  pushl $190
8010784c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107851:	e9 19 f2 ff ff       	jmp    80106a6f <alltraps>

80107856 <vector191>:
.globl vector191
vector191:
  pushl $0
80107856:	6a 00                	push   $0x0
  pushl $191
80107858:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010785d:	e9 0d f2 ff ff       	jmp    80106a6f <alltraps>

80107862 <vector192>:
.globl vector192
vector192:
  pushl $0
80107862:	6a 00                	push   $0x0
  pushl $192
80107864:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107869:	e9 01 f2 ff ff       	jmp    80106a6f <alltraps>

8010786e <vector193>:
.globl vector193
vector193:
  pushl $0
8010786e:	6a 00                	push   $0x0
  pushl $193
80107870:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107875:	e9 f5 f1 ff ff       	jmp    80106a6f <alltraps>

8010787a <vector194>:
.globl vector194
vector194:
  pushl $0
8010787a:	6a 00                	push   $0x0
  pushl $194
8010787c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107881:	e9 e9 f1 ff ff       	jmp    80106a6f <alltraps>

80107886 <vector195>:
.globl vector195
vector195:
  pushl $0
80107886:	6a 00                	push   $0x0
  pushl $195
80107888:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010788d:	e9 dd f1 ff ff       	jmp    80106a6f <alltraps>

80107892 <vector196>:
.globl vector196
vector196:
  pushl $0
80107892:	6a 00                	push   $0x0
  pushl $196
80107894:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107899:	e9 d1 f1 ff ff       	jmp    80106a6f <alltraps>

8010789e <vector197>:
.globl vector197
vector197:
  pushl $0
8010789e:	6a 00                	push   $0x0
  pushl $197
801078a0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801078a5:	e9 c5 f1 ff ff       	jmp    80106a6f <alltraps>

801078aa <vector198>:
.globl vector198
vector198:
  pushl $0
801078aa:	6a 00                	push   $0x0
  pushl $198
801078ac:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801078b1:	e9 b9 f1 ff ff       	jmp    80106a6f <alltraps>

801078b6 <vector199>:
.globl vector199
vector199:
  pushl $0
801078b6:	6a 00                	push   $0x0
  pushl $199
801078b8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801078bd:	e9 ad f1 ff ff       	jmp    80106a6f <alltraps>

801078c2 <vector200>:
.globl vector200
vector200:
  pushl $0
801078c2:	6a 00                	push   $0x0
  pushl $200
801078c4:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801078c9:	e9 a1 f1 ff ff       	jmp    80106a6f <alltraps>

801078ce <vector201>:
.globl vector201
vector201:
  pushl $0
801078ce:	6a 00                	push   $0x0
  pushl $201
801078d0:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801078d5:	e9 95 f1 ff ff       	jmp    80106a6f <alltraps>

801078da <vector202>:
.globl vector202
vector202:
  pushl $0
801078da:	6a 00                	push   $0x0
  pushl $202
801078dc:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801078e1:	e9 89 f1 ff ff       	jmp    80106a6f <alltraps>

801078e6 <vector203>:
.globl vector203
vector203:
  pushl $0
801078e6:	6a 00                	push   $0x0
  pushl $203
801078e8:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801078ed:	e9 7d f1 ff ff       	jmp    80106a6f <alltraps>

801078f2 <vector204>:
.globl vector204
vector204:
  pushl $0
801078f2:	6a 00                	push   $0x0
  pushl $204
801078f4:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801078f9:	e9 71 f1 ff ff       	jmp    80106a6f <alltraps>

801078fe <vector205>:
.globl vector205
vector205:
  pushl $0
801078fe:	6a 00                	push   $0x0
  pushl $205
80107900:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107905:	e9 65 f1 ff ff       	jmp    80106a6f <alltraps>

8010790a <vector206>:
.globl vector206
vector206:
  pushl $0
8010790a:	6a 00                	push   $0x0
  pushl $206
8010790c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107911:	e9 59 f1 ff ff       	jmp    80106a6f <alltraps>

80107916 <vector207>:
.globl vector207
vector207:
  pushl $0
80107916:	6a 00                	push   $0x0
  pushl $207
80107918:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010791d:	e9 4d f1 ff ff       	jmp    80106a6f <alltraps>

80107922 <vector208>:
.globl vector208
vector208:
  pushl $0
80107922:	6a 00                	push   $0x0
  pushl $208
80107924:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107929:	e9 41 f1 ff ff       	jmp    80106a6f <alltraps>

8010792e <vector209>:
.globl vector209
vector209:
  pushl $0
8010792e:	6a 00                	push   $0x0
  pushl $209
80107930:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107935:	e9 35 f1 ff ff       	jmp    80106a6f <alltraps>

8010793a <vector210>:
.globl vector210
vector210:
  pushl $0
8010793a:	6a 00                	push   $0x0
  pushl $210
8010793c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107941:	e9 29 f1 ff ff       	jmp    80106a6f <alltraps>

80107946 <vector211>:
.globl vector211
vector211:
  pushl $0
80107946:	6a 00                	push   $0x0
  pushl $211
80107948:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010794d:	e9 1d f1 ff ff       	jmp    80106a6f <alltraps>

80107952 <vector212>:
.globl vector212
vector212:
  pushl $0
80107952:	6a 00                	push   $0x0
  pushl $212
80107954:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107959:	e9 11 f1 ff ff       	jmp    80106a6f <alltraps>

8010795e <vector213>:
.globl vector213
vector213:
  pushl $0
8010795e:	6a 00                	push   $0x0
  pushl $213
80107960:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107965:	e9 05 f1 ff ff       	jmp    80106a6f <alltraps>

8010796a <vector214>:
.globl vector214
vector214:
  pushl $0
8010796a:	6a 00                	push   $0x0
  pushl $214
8010796c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107971:	e9 f9 f0 ff ff       	jmp    80106a6f <alltraps>

80107976 <vector215>:
.globl vector215
vector215:
  pushl $0
80107976:	6a 00                	push   $0x0
  pushl $215
80107978:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010797d:	e9 ed f0 ff ff       	jmp    80106a6f <alltraps>

80107982 <vector216>:
.globl vector216
vector216:
  pushl $0
80107982:	6a 00                	push   $0x0
  pushl $216
80107984:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107989:	e9 e1 f0 ff ff       	jmp    80106a6f <alltraps>

8010798e <vector217>:
.globl vector217
vector217:
  pushl $0
8010798e:	6a 00                	push   $0x0
  pushl $217
80107990:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107995:	e9 d5 f0 ff ff       	jmp    80106a6f <alltraps>

8010799a <vector218>:
.globl vector218
vector218:
  pushl $0
8010799a:	6a 00                	push   $0x0
  pushl $218
8010799c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801079a1:	e9 c9 f0 ff ff       	jmp    80106a6f <alltraps>

801079a6 <vector219>:
.globl vector219
vector219:
  pushl $0
801079a6:	6a 00                	push   $0x0
  pushl $219
801079a8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801079ad:	e9 bd f0 ff ff       	jmp    80106a6f <alltraps>

801079b2 <vector220>:
.globl vector220
vector220:
  pushl $0
801079b2:	6a 00                	push   $0x0
  pushl $220
801079b4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801079b9:	e9 b1 f0 ff ff       	jmp    80106a6f <alltraps>

801079be <vector221>:
.globl vector221
vector221:
  pushl $0
801079be:	6a 00                	push   $0x0
  pushl $221
801079c0:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801079c5:	e9 a5 f0 ff ff       	jmp    80106a6f <alltraps>

801079ca <vector222>:
.globl vector222
vector222:
  pushl $0
801079ca:	6a 00                	push   $0x0
  pushl $222
801079cc:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801079d1:	e9 99 f0 ff ff       	jmp    80106a6f <alltraps>

801079d6 <vector223>:
.globl vector223
vector223:
  pushl $0
801079d6:	6a 00                	push   $0x0
  pushl $223
801079d8:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801079dd:	e9 8d f0 ff ff       	jmp    80106a6f <alltraps>

801079e2 <vector224>:
.globl vector224
vector224:
  pushl $0
801079e2:	6a 00                	push   $0x0
  pushl $224
801079e4:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801079e9:	e9 81 f0 ff ff       	jmp    80106a6f <alltraps>

801079ee <vector225>:
.globl vector225
vector225:
  pushl $0
801079ee:	6a 00                	push   $0x0
  pushl $225
801079f0:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801079f5:	e9 75 f0 ff ff       	jmp    80106a6f <alltraps>

801079fa <vector226>:
.globl vector226
vector226:
  pushl $0
801079fa:	6a 00                	push   $0x0
  pushl $226
801079fc:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107a01:	e9 69 f0 ff ff       	jmp    80106a6f <alltraps>

80107a06 <vector227>:
.globl vector227
vector227:
  pushl $0
80107a06:	6a 00                	push   $0x0
  pushl $227
80107a08:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107a0d:	e9 5d f0 ff ff       	jmp    80106a6f <alltraps>

80107a12 <vector228>:
.globl vector228
vector228:
  pushl $0
80107a12:	6a 00                	push   $0x0
  pushl $228
80107a14:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107a19:	e9 51 f0 ff ff       	jmp    80106a6f <alltraps>

80107a1e <vector229>:
.globl vector229
vector229:
  pushl $0
80107a1e:	6a 00                	push   $0x0
  pushl $229
80107a20:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107a25:	e9 45 f0 ff ff       	jmp    80106a6f <alltraps>

80107a2a <vector230>:
.globl vector230
vector230:
  pushl $0
80107a2a:	6a 00                	push   $0x0
  pushl $230
80107a2c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107a31:	e9 39 f0 ff ff       	jmp    80106a6f <alltraps>

80107a36 <vector231>:
.globl vector231
vector231:
  pushl $0
80107a36:	6a 00                	push   $0x0
  pushl $231
80107a38:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107a3d:	e9 2d f0 ff ff       	jmp    80106a6f <alltraps>

80107a42 <vector232>:
.globl vector232
vector232:
  pushl $0
80107a42:	6a 00                	push   $0x0
  pushl $232
80107a44:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107a49:	e9 21 f0 ff ff       	jmp    80106a6f <alltraps>

80107a4e <vector233>:
.globl vector233
vector233:
  pushl $0
80107a4e:	6a 00                	push   $0x0
  pushl $233
80107a50:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107a55:	e9 15 f0 ff ff       	jmp    80106a6f <alltraps>

80107a5a <vector234>:
.globl vector234
vector234:
  pushl $0
80107a5a:	6a 00                	push   $0x0
  pushl $234
80107a5c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107a61:	e9 09 f0 ff ff       	jmp    80106a6f <alltraps>

80107a66 <vector235>:
.globl vector235
vector235:
  pushl $0
80107a66:	6a 00                	push   $0x0
  pushl $235
80107a68:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107a6d:	e9 fd ef ff ff       	jmp    80106a6f <alltraps>

80107a72 <vector236>:
.globl vector236
vector236:
  pushl $0
80107a72:	6a 00                	push   $0x0
  pushl $236
80107a74:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107a79:	e9 f1 ef ff ff       	jmp    80106a6f <alltraps>

80107a7e <vector237>:
.globl vector237
vector237:
  pushl $0
80107a7e:	6a 00                	push   $0x0
  pushl $237
80107a80:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107a85:	e9 e5 ef ff ff       	jmp    80106a6f <alltraps>

80107a8a <vector238>:
.globl vector238
vector238:
  pushl $0
80107a8a:	6a 00                	push   $0x0
  pushl $238
80107a8c:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107a91:	e9 d9 ef ff ff       	jmp    80106a6f <alltraps>

80107a96 <vector239>:
.globl vector239
vector239:
  pushl $0
80107a96:	6a 00                	push   $0x0
  pushl $239
80107a98:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107a9d:	e9 cd ef ff ff       	jmp    80106a6f <alltraps>

80107aa2 <vector240>:
.globl vector240
vector240:
  pushl $0
80107aa2:	6a 00                	push   $0x0
  pushl $240
80107aa4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107aa9:	e9 c1 ef ff ff       	jmp    80106a6f <alltraps>

80107aae <vector241>:
.globl vector241
vector241:
  pushl $0
80107aae:	6a 00                	push   $0x0
  pushl $241
80107ab0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107ab5:	e9 b5 ef ff ff       	jmp    80106a6f <alltraps>

80107aba <vector242>:
.globl vector242
vector242:
  pushl $0
80107aba:	6a 00                	push   $0x0
  pushl $242
80107abc:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107ac1:	e9 a9 ef ff ff       	jmp    80106a6f <alltraps>

80107ac6 <vector243>:
.globl vector243
vector243:
  pushl $0
80107ac6:	6a 00                	push   $0x0
  pushl $243
80107ac8:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107acd:	e9 9d ef ff ff       	jmp    80106a6f <alltraps>

80107ad2 <vector244>:
.globl vector244
vector244:
  pushl $0
80107ad2:	6a 00                	push   $0x0
  pushl $244
80107ad4:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107ad9:	e9 91 ef ff ff       	jmp    80106a6f <alltraps>

80107ade <vector245>:
.globl vector245
vector245:
  pushl $0
80107ade:	6a 00                	push   $0x0
  pushl $245
80107ae0:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107ae5:	e9 85 ef ff ff       	jmp    80106a6f <alltraps>

80107aea <vector246>:
.globl vector246
vector246:
  pushl $0
80107aea:	6a 00                	push   $0x0
  pushl $246
80107aec:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107af1:	e9 79 ef ff ff       	jmp    80106a6f <alltraps>

80107af6 <vector247>:
.globl vector247
vector247:
  pushl $0
80107af6:	6a 00                	push   $0x0
  pushl $247
80107af8:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107afd:	e9 6d ef ff ff       	jmp    80106a6f <alltraps>

80107b02 <vector248>:
.globl vector248
vector248:
  pushl $0
80107b02:	6a 00                	push   $0x0
  pushl $248
80107b04:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107b09:	e9 61 ef ff ff       	jmp    80106a6f <alltraps>

80107b0e <vector249>:
.globl vector249
vector249:
  pushl $0
80107b0e:	6a 00                	push   $0x0
  pushl $249
80107b10:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107b15:	e9 55 ef ff ff       	jmp    80106a6f <alltraps>

80107b1a <vector250>:
.globl vector250
vector250:
  pushl $0
80107b1a:	6a 00                	push   $0x0
  pushl $250
80107b1c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107b21:	e9 49 ef ff ff       	jmp    80106a6f <alltraps>

80107b26 <vector251>:
.globl vector251
vector251:
  pushl $0
80107b26:	6a 00                	push   $0x0
  pushl $251
80107b28:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107b2d:	e9 3d ef ff ff       	jmp    80106a6f <alltraps>

80107b32 <vector252>:
.globl vector252
vector252:
  pushl $0
80107b32:	6a 00                	push   $0x0
  pushl $252
80107b34:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107b39:	e9 31 ef ff ff       	jmp    80106a6f <alltraps>

80107b3e <vector253>:
.globl vector253
vector253:
  pushl $0
80107b3e:	6a 00                	push   $0x0
  pushl $253
80107b40:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107b45:	e9 25 ef ff ff       	jmp    80106a6f <alltraps>

80107b4a <vector254>:
.globl vector254
vector254:
  pushl $0
80107b4a:	6a 00                	push   $0x0
  pushl $254
80107b4c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107b51:	e9 19 ef ff ff       	jmp    80106a6f <alltraps>

80107b56 <vector255>:
.globl vector255
vector255:
  pushl $0
80107b56:	6a 00                	push   $0x0
  pushl $255
80107b58:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107b5d:	e9 0d ef ff ff       	jmp    80106a6f <alltraps>

80107b62 <lgdt>:
{
80107b62:	55                   	push   %ebp
80107b63:	89 e5                	mov    %esp,%ebp
80107b65:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107b68:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b6b:	83 e8 01             	sub    $0x1,%eax
80107b6e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107b72:	8b 45 08             	mov    0x8(%ebp),%eax
80107b75:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107b79:	8b 45 08             	mov    0x8(%ebp),%eax
80107b7c:	c1 e8 10             	shr    $0x10,%eax
80107b7f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107b83:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107b86:	0f 01 10             	lgdtl  (%eax)
}
80107b89:	90                   	nop
80107b8a:	c9                   	leave  
80107b8b:	c3                   	ret    

80107b8c <ltr>:
{
80107b8c:	55                   	push   %ebp
80107b8d:	89 e5                	mov    %esp,%ebp
80107b8f:	83 ec 04             	sub    $0x4,%esp
80107b92:	8b 45 08             	mov    0x8(%ebp),%eax
80107b95:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107b99:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107b9d:	0f 00 d8             	ltr    %ax
}
80107ba0:	90                   	nop
80107ba1:	c9                   	leave  
80107ba2:	c3                   	ret    

80107ba3 <lcr3>:

static inline void
lcr3(uint val)
{
80107ba3:	55                   	push   %ebp
80107ba4:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80107ba9:	0f 22 d8             	mov    %eax,%cr3
}
80107bac:	90                   	nop
80107bad:	5d                   	pop    %ebp
80107bae:	c3                   	ret    

80107baf <clockInsert>:
#include "elf.h"


/* Clock insert and remove */

void clockInsert(uint vpn, pte_t *pte) {
80107baf:	f3 0f 1e fb          	endbr32 
80107bb3:	55                   	push   %ebp
80107bb4:	89 e5                	mov    %esp,%ebp
80107bb6:	83 ec 18             	sub    $0x18,%esp
    struct proc *currProc = myproc();
80107bb9:	e8 02 c9 ff ff       	call   801044c0 <myproc>
80107bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)

    //queue not full
    int size = currProc->clock.size;
80107bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc4:	8b 80 c0 00 00 00    	mov    0xc0(%eax),%eax
80107bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(size < CLOCKSIZE && currProc->clock.queue[size].vpn == -1) {
80107bcd:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
80107bd1:	7f 3b                	jg     80107c0e <clockInsert+0x5f>
80107bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd6:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107bd9:	83 c2 0e             	add    $0xe,%edx
80107bdc:	8b 44 d0 0c          	mov    0xc(%eax,%edx,8),%eax
80107be0:	83 f8 ff             	cmp    $0xffffffff,%eax
80107be3:	75 29                	jne    80107c0e <clockInsert+0x5f>
        size++;
80107be5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
        currProc->clock.queue[size].vpn = vpn;
80107be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bec:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107bef:	8d 4a 0e             	lea    0xe(%edx),%ecx
80107bf2:	8b 55 08             	mov    0x8(%ebp),%edx
80107bf5:	89 54 c8 0c          	mov    %edx,0xc(%eax,%ecx,8)
        currProc->clock.queue[size].pte = pte;
80107bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107bff:	8d 4a 0e             	lea    0xe(%edx),%ecx
80107c02:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c05:	89 54 c8 10          	mov    %edx,0x10(%eax,%ecx,8)
        return;
80107c09:	e9 e1 00 00 00       	jmp    80107cef <clockInsert+0x140>
    }

    //clock insert
    while(1) {
        //advance hand
        currProc->clock.index = (currProc->clock.index+1) % CLOCKSIZE;
80107c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c11:	8b 80 bc 00 00 00    	mov    0xbc(%eax),%eax
80107c17:	8d 50 01             	lea    0x1(%eax),%edx
80107c1a:	89 d0                	mov    %edx,%eax
80107c1c:	c1 f8 1f             	sar    $0x1f,%eax
80107c1f:	c1 e8 1d             	shr    $0x1d,%eax
80107c22:	01 c2                	add    %eax,%edx
80107c24:	83 e2 07             	and    $0x7,%edx
80107c27:	29 c2                	sub    %eax,%edx
80107c29:	89 d0                	mov    %edx,%eax
80107c2b:	89 c2                	mov    %eax,%edx
80107c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c30:	89 90 bc 00 00 00    	mov    %edx,0xbc(%eax)
        int hand = currProc->clock.index;
80107c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c39:	8b 80 bc 00 00 00    	mov    0xbc(%eax),%eax
80107c3f:	89 45 ec             	mov    %eax,-0x14(%ebp)

        /* find slot to insert or evit page */
        if(currProc->clock.queue[hand].vpn == -1) {
80107c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c45:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107c48:	83 c2 0e             	add    $0xe,%edx
80107c4b:	8b 44 d0 0c          	mov    0xc(%eax,%edx,8),%eax
80107c4f:	83 f8 ff             	cmp    $0xffffffff,%eax
80107c52:	75 22                	jne    80107c76 <clockInsert+0xc7>
            //insert the new page
            currProc->clock.queue[hand].vpn = vpn;
80107c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c57:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107c5a:	8d 4a 0e             	lea    0xe(%edx),%ecx
80107c5d:	8b 55 08             	mov    0x8(%ebp),%edx
80107c60:	89 54 c8 0c          	mov    %edx,0xc(%eax,%ecx,8)
            currProc->clock.queue[hand].pte = pte;
80107c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c67:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107c6a:	8d 4a 0e             	lea    0xe(%edx),%ecx
80107c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c70:	89 54 c8 10          	mov    %edx,0x10(%eax,%ecx,8)
            break;
80107c74:	eb 79                	jmp    80107cef <clockInsert+0x140>
        }
        else if(!(*(currProc->clock.queue[hand].pte) & PTE_A)) {
80107c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c79:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107c7c:	83 c2 0e             	add    $0xe,%edx
80107c7f:	8b 44 d0 10          	mov    0x10(%eax,%edx,8),%eax
80107c83:	8b 00                	mov    (%eax),%eax
80107c85:	83 e0 20             	and    $0x20,%eax
80107c88:	85 c0                	test   %eax,%eax
80107c8a:	75 3d                	jne    80107cc9 <clockInsert+0x11a>
           // page does not have ref bit set, evict it 
           // first encrypt it, then set new page into queue
           mencrypt((char *)currProc->clock.queue[hand].vpn, 1);
80107c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107c92:	83 c2 0e             	add    $0xe,%edx
80107c95:	8b 44 d0 0c          	mov    0xc(%eax,%edx,8),%eax
80107c99:	83 ec 08             	sub    $0x8,%esp
80107c9c:	6a 01                	push   $0x1
80107c9e:	50                   	push   %eax
80107c9f:	e8 e9 0f 00 00       	call   80108c8d <mencrypt>
80107ca4:	83 c4 10             	add    $0x10,%esp
           currProc->clock.queue[hand].vpn = vpn;
80107ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107caa:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107cad:	8d 4a 0e             	lea    0xe(%edx),%ecx
80107cb0:	8b 55 08             	mov    0x8(%ebp),%edx
80107cb3:	89 54 c8 0c          	mov    %edx,0xc(%eax,%ecx,8)
           currProc->clock.queue[hand].pte = pte;
80107cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cba:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107cbd:	8d 4a 0e             	lea    0xe(%edx),%ecx
80107cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
80107cc3:	89 54 c8 10          	mov    %edx,0x10(%eax,%ecx,8)
           break;
80107cc7:	eb 26                	jmp    80107cef <clockInsert+0x140>
        }
        // clear ref bit
        *(currProc->clock.queue[hand].pte) &= ~PTE_A;
80107cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccc:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107ccf:	83 c2 0e             	add    $0xe,%edx
80107cd2:	8b 44 d0 10          	mov    0x10(%eax,%edx,8),%eax
80107cd6:	8b 10                	mov    (%eax),%edx
80107cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80107cde:	83 c1 0e             	add    $0xe,%ecx
80107ce1:	8b 44 c8 10          	mov    0x10(%eax,%ecx,8),%eax
80107ce5:	83 e2 df             	and    $0xffffffdf,%edx
80107ce8:	89 10                	mov    %edx,(%eax)
    while(1) {
80107cea:	e9 1f ff ff ff       	jmp    80107c0e <clockInsert+0x5f>
    }
}
80107cef:	c9                   	leave  
80107cf0:	c3                   	ret    

80107cf1 <clockRemove>:

void clockRemove(uint vpn) {
80107cf1:	f3 0f 1e fb          	endbr32 
80107cf5:	55                   	push   %ebp
80107cf6:	89 e5                	mov    %esp,%ebp
    
}
80107cf8:	90                   	nop
80107cf9:	5d                   	pop    %ebp
80107cfa:	c3                   	ret    

80107cfb <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107cfb:	f3 0f 1e fb          	endbr32 
80107cff:	55                   	push   %ebp
80107d00:	89 e5                	mov    %esp,%ebp
80107d02:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107d05:	e8 1b c7 ff ff       	call   80104425 <cpuid>
80107d0a:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107d10:	05 20 48 11 80       	add    $0x80114820,%eax
80107d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1b:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d24:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2d:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d34:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d38:	83 e2 f0             	and    $0xfffffff0,%edx
80107d3b:	83 ca 0a             	or     $0xa,%edx
80107d3e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d44:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d48:	83 ca 10             	or     $0x10,%edx
80107d4b:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d51:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d55:	83 e2 9f             	and    $0xffffff9f,%edx
80107d58:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107d62:	83 ca 80             	or     $0xffffff80,%edx
80107d65:	88 50 7d             	mov    %dl,0x7d(%eax)
80107d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d6f:	83 ca 0f             	or     $0xf,%edx
80107d72:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d78:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d7c:	83 e2 ef             	and    $0xffffffef,%edx
80107d7f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d85:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d89:	83 e2 df             	and    $0xffffffdf,%edx
80107d8c:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d92:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d96:	83 ca 40             	or     $0x40,%edx
80107d99:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107da3:	83 ca 80             	or     $0xffffff80,%edx
80107da6:	88 50 7e             	mov    %dl,0x7e(%eax)
80107da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dac:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db3:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107dba:	ff ff 
80107dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dbf:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107dc6:	00 00 
80107dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dcb:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ddc:	83 e2 f0             	and    $0xfffffff0,%edx
80107ddf:	83 ca 02             	or     $0x2,%edx
80107de2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107deb:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107df2:	83 ca 10             	or     $0x10,%edx
80107df5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfe:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e05:	83 e2 9f             	and    $0xffffff9f,%edx
80107e08:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e11:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107e18:	83 ca 80             	or     $0xffffff80,%edx
80107e1b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e24:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e2b:	83 ca 0f             	or     $0xf,%edx
80107e2e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e37:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e3e:	83 e2 ef             	and    $0xffffffef,%edx
80107e41:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e51:	83 e2 df             	and    $0xffffffdf,%edx
80107e54:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e64:	83 ca 40             	or     $0x40,%edx
80107e67:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e70:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107e77:	83 ca 80             	or     $0xffffff80,%edx
80107e7a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e83:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e8d:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107e94:	ff ff 
80107e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e99:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107ea0:	00 00 
80107ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea5:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eaf:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107eb6:	83 e2 f0             	and    $0xfffffff0,%edx
80107eb9:	83 ca 0a             	or     $0xa,%edx
80107ebc:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec5:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107ecc:	83 ca 10             	or     $0x10,%edx
80107ecf:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed8:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107edf:	83 ca 60             	or     $0x60,%edx
80107ee2:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eeb:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107ef2:	83 ca 80             	or     $0xffffff80,%edx
80107ef5:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efe:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f05:	83 ca 0f             	or     $0xf,%edx
80107f08:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f11:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f18:	83 e2 ef             	and    $0xffffffef,%edx
80107f1b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f24:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f2b:	83 e2 df             	and    $0xffffffdf,%edx
80107f2e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f37:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f3e:	83 ca 40             	or     $0x40,%edx
80107f41:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f51:	83 ca 80             	or     $0xffffff80,%edx
80107f54:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5d:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f67:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107f6e:	ff ff 
80107f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f73:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107f7a:	00 00 
80107f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7f:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f89:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107f90:	83 e2 f0             	and    $0xfffffff0,%edx
80107f93:	83 ca 02             	or     $0x2,%edx
80107f96:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fa6:	83 ca 10             	or     $0x10,%edx
80107fa9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fb9:	83 ca 60             	or     $0x60,%edx
80107fbc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107fcc:	83 ca 80             	or     $0xffffff80,%edx
80107fcf:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107fdf:	83 ca 0f             	or     $0xf,%edx
80107fe2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107feb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ff2:	83 e2 ef             	and    $0xffffffef,%edx
80107ff5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffe:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108005:	83 e2 df             	and    $0xffffffdf,%edx
80108008:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010800e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108011:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108018:	83 ca 40             	or     $0x40,%edx
8010801b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108024:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010802b:	83 ca 80             	or     $0xffffff80,%edx
8010802e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108037:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010803e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108041:	83 c0 70             	add    $0x70,%eax
80108044:	83 ec 08             	sub    $0x8,%esp
80108047:	6a 30                	push   $0x30
80108049:	50                   	push   %eax
8010804a:	e8 13 fb ff ff       	call   80107b62 <lgdt>
8010804f:	83 c4 10             	add    $0x10,%esp
}
80108052:	90                   	nop
80108053:	c9                   	leave  
80108054:	c3                   	ret    

80108055 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108055:	f3 0f 1e fb          	endbr32 
80108059:	55                   	push   %ebp
8010805a:	89 e5                	mov    %esp,%ebp
8010805c:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010805f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108062:	c1 e8 16             	shr    $0x16,%eax
80108065:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010806c:	8b 45 08             	mov    0x8(%ebp),%eax
8010806f:	01 d0                	add    %edx,%eax
80108071:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108074:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108077:	8b 00                	mov    (%eax),%eax
80108079:	83 e0 01             	and    $0x1,%eax
8010807c:	85 c0                	test   %eax,%eax
8010807e:	74 14                	je     80108094 <walkpgdir+0x3f>
    //if (!alloc)
      //cprintf("page directory is good\n");
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108080:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108083:	8b 00                	mov    (%eax),%eax
80108085:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010808a:	05 00 00 00 80       	add    $0x80000000,%eax
8010808f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108092:	eb 42                	jmp    801080d6 <walkpgdir+0x81>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108094:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108098:	74 0e                	je     801080a8 <walkpgdir+0x53>
8010809a:	e8 5d ad ff ff       	call   80102dfc <kalloc>
8010809f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801080a6:	75 07                	jne    801080af <walkpgdir+0x5a>
      return 0;
801080a8:	b8 00 00 00 00       	mov    $0x0,%eax
801080ad:	eb 3e                	jmp    801080ed <walkpgdir+0x98>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801080af:	83 ec 04             	sub    $0x4,%esp
801080b2:	68 00 10 00 00       	push   $0x1000
801080b7:	6a 00                	push   $0x0
801080b9:	ff 75 f4             	pushl  -0xc(%ebp)
801080bc:	e8 70 d4 ff ff       	call   80105531 <memset>
801080c1:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801080c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c7:	05 00 00 00 80       	add    $0x80000000,%eax
801080cc:	83 c8 07             	or     $0x7,%eax
801080cf:	89 c2                	mov    %eax,%edx
801080d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080d4:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801080d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801080d9:	c1 e8 0c             	shr    $0xc,%eax
801080dc:	25 ff 03 00 00       	and    $0x3ff,%eax
801080e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801080e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080eb:	01 d0                	add    %edx,%eax
}
801080ed:	c9                   	leave  
801080ee:	c3                   	ret    

801080ef <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801080ef:	f3 0f 1e fb          	endbr32 
801080f3:	55                   	push   %ebp
801080f4:	89 e5                	mov    %esp,%ebp
801080f6:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801080f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801080fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108101:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108104:	8b 55 0c             	mov    0xc(%ebp),%edx
80108107:	8b 45 10             	mov    0x10(%ebp),%eax
8010810a:	01 d0                	add    %edx,%eax
8010810c:	83 e8 01             	sub    $0x1,%eax
8010810f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108114:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108117:	83 ec 04             	sub    $0x4,%esp
8010811a:	6a 01                	push   $0x1
8010811c:	ff 75 f4             	pushl  -0xc(%ebp)
8010811f:	ff 75 08             	pushl  0x8(%ebp)
80108122:	e8 2e ff ff ff       	call   80108055 <walkpgdir>
80108127:	83 c4 10             	add    $0x10,%esp
8010812a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010812d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108131:	75 07                	jne    8010813a <mappages+0x4b>
      return -1;
80108133:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108138:	eb 6a                	jmp    801081a4 <mappages+0xb5>
    if(*pte & (PTE_P | PTE_E))
8010813a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010813d:	8b 00                	mov    (%eax),%eax
8010813f:	25 01 04 00 00       	and    $0x401,%eax
80108144:	85 c0                	test   %eax,%eax
80108146:	74 0d                	je     80108155 <mappages+0x66>
      panic("p4Debug, remapping page");
80108148:	83 ec 0c             	sub    $0xc,%esp
8010814b:	68 fc 97 10 80       	push   $0x801097fc
80108150:	e8 b3 84 ff ff       	call   80100608 <panic>

    if (perm & PTE_E)
80108155:	8b 45 18             	mov    0x18(%ebp),%eax
80108158:	25 00 04 00 00       	and    $0x400,%eax
8010815d:	85 c0                	test   %eax,%eax
8010815f:	74 12                	je     80108173 <mappages+0x84>
      *pte = pa | perm | PTE_E;
80108161:	8b 45 18             	mov    0x18(%ebp),%eax
80108164:	0b 45 14             	or     0x14(%ebp),%eax
80108167:	80 cc 04             	or     $0x4,%ah
8010816a:	89 c2                	mov    %eax,%edx
8010816c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010816f:	89 10                	mov    %edx,(%eax)
80108171:	eb 10                	jmp    80108183 <mappages+0x94>
    else
      *pte = pa | perm | PTE_P;
80108173:	8b 45 18             	mov    0x18(%ebp),%eax
80108176:	0b 45 14             	or     0x14(%ebp),%eax
80108179:	83 c8 01             	or     $0x1,%eax
8010817c:	89 c2                	mov    %eax,%edx
8010817e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108181:	89 10                	mov    %edx,(%eax)


    if(a == last)
80108183:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108186:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108189:	74 13                	je     8010819e <mappages+0xaf>
      break;
    a += PGSIZE;
8010818b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108192:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108199:	e9 79 ff ff ff       	jmp    80108117 <mappages+0x28>
      break;
8010819e:	90                   	nop
  }
  return 0;
8010819f:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081a4:	c9                   	leave  
801081a5:	c3                   	ret    

801081a6 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801081a6:	f3 0f 1e fb          	endbr32 
801081aa:	55                   	push   %ebp
801081ab:	89 e5                	mov    %esp,%ebp
801081ad:	53                   	push   %ebx
801081ae:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801081b1:	e8 46 ac ff ff       	call   80102dfc <kalloc>
801081b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081bd:	75 07                	jne    801081c6 <setupkvm+0x20>
    return 0;
801081bf:	b8 00 00 00 00       	mov    $0x0,%eax
801081c4:	eb 78                	jmp    8010823e <setupkvm+0x98>
  memset(pgdir, 0, PGSIZE);
801081c6:	83 ec 04             	sub    $0x4,%esp
801081c9:	68 00 10 00 00       	push   $0x1000
801081ce:	6a 00                	push   $0x0
801081d0:	ff 75 f0             	pushl  -0x10(%ebp)
801081d3:	e8 59 d3 ff ff       	call   80105531 <memset>
801081d8:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801081db:	c7 45 f4 a0 c4 10 80 	movl   $0x8010c4a0,-0xc(%ebp)
801081e2:	eb 4e                	jmp    80108232 <setupkvm+0x8c>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801081e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e7:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
801081ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ed:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801081f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f3:	8b 58 08             	mov    0x8(%eax),%ebx
801081f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f9:	8b 40 04             	mov    0x4(%eax),%eax
801081fc:	29 c3                	sub    %eax,%ebx
801081fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108201:	8b 00                	mov    (%eax),%eax
80108203:	83 ec 0c             	sub    $0xc,%esp
80108206:	51                   	push   %ecx
80108207:	52                   	push   %edx
80108208:	53                   	push   %ebx
80108209:	50                   	push   %eax
8010820a:	ff 75 f0             	pushl  -0x10(%ebp)
8010820d:	e8 dd fe ff ff       	call   801080ef <mappages>
80108212:	83 c4 20             	add    $0x20,%esp
80108215:	85 c0                	test   %eax,%eax
80108217:	79 15                	jns    8010822e <setupkvm+0x88>
      freevm(pgdir);
80108219:	83 ec 0c             	sub    $0xc,%esp
8010821c:	ff 75 f0             	pushl  -0x10(%ebp)
8010821f:	e8 13 05 00 00       	call   80108737 <freevm>
80108224:	83 c4 10             	add    $0x10,%esp
      return 0;
80108227:	b8 00 00 00 00       	mov    $0x0,%eax
8010822c:	eb 10                	jmp    8010823e <setupkvm+0x98>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010822e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108232:	81 7d f4 e0 c4 10 80 	cmpl   $0x8010c4e0,-0xc(%ebp)
80108239:	72 a9                	jb     801081e4 <setupkvm+0x3e>
    }
  return pgdir;
8010823b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010823e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108241:	c9                   	leave  
80108242:	c3                   	ret    

80108243 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108243:	f3 0f 1e fb          	endbr32 
80108247:	55                   	push   %ebp
80108248:	89 e5                	mov    %esp,%ebp
8010824a:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010824d:	e8 54 ff ff ff       	call   801081a6 <setupkvm>
80108252:	a3 44 87 11 80       	mov    %eax,0x80118744
  switchkvm();
80108257:	e8 03 00 00 00       	call   8010825f <switchkvm>
}
8010825c:	90                   	nop
8010825d:	c9                   	leave  
8010825e:	c3                   	ret    

8010825f <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010825f:	f3 0f 1e fb          	endbr32 
80108263:	55                   	push   %ebp
80108264:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108266:	a1 44 87 11 80       	mov    0x80118744,%eax
8010826b:	05 00 00 00 80       	add    $0x80000000,%eax
80108270:	50                   	push   %eax
80108271:	e8 2d f9 ff ff       	call   80107ba3 <lcr3>
80108276:	83 c4 04             	add    $0x4,%esp
}
80108279:	90                   	nop
8010827a:	c9                   	leave  
8010827b:	c3                   	ret    

8010827c <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010827c:	f3 0f 1e fb          	endbr32 
80108280:	55                   	push   %ebp
80108281:	89 e5                	mov    %esp,%ebp
80108283:	56                   	push   %esi
80108284:	53                   	push   %ebx
80108285:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80108288:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010828c:	75 0d                	jne    8010829b <switchuvm+0x1f>
    panic("switchuvm: no process");
8010828e:	83 ec 0c             	sub    $0xc,%esp
80108291:	68 14 98 10 80       	push   $0x80109814
80108296:	e8 6d 83 ff ff       	call   80100608 <panic>
  if(p->kstack == 0)
8010829b:	8b 45 08             	mov    0x8(%ebp),%eax
8010829e:	8b 40 08             	mov    0x8(%eax),%eax
801082a1:	85 c0                	test   %eax,%eax
801082a3:	75 0d                	jne    801082b2 <switchuvm+0x36>
    panic("switchuvm: no kstack");
801082a5:	83 ec 0c             	sub    $0xc,%esp
801082a8:	68 2a 98 10 80       	push   $0x8010982a
801082ad:	e8 56 83 ff ff       	call   80100608 <panic>
  if(p->pgdir == 0)
801082b2:	8b 45 08             	mov    0x8(%ebp),%eax
801082b5:	8b 40 04             	mov    0x4(%eax),%eax
801082b8:	85 c0                	test   %eax,%eax
801082ba:	75 0d                	jne    801082c9 <switchuvm+0x4d>
    panic("switchuvm: no pgdir");
801082bc:	83 ec 0c             	sub    $0xc,%esp
801082bf:	68 3f 98 10 80       	push   $0x8010983f
801082c4:	e8 3f 83 ff ff       	call   80100608 <panic>

  pushcli();
801082c9:	e8 50 d1 ff ff       	call   8010541e <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801082ce:	e8 71 c1 ff ff       	call   80104444 <mycpu>
801082d3:	89 c3                	mov    %eax,%ebx
801082d5:	e8 6a c1 ff ff       	call   80104444 <mycpu>
801082da:	83 c0 08             	add    $0x8,%eax
801082dd:	89 c6                	mov    %eax,%esi
801082df:	e8 60 c1 ff ff       	call   80104444 <mycpu>
801082e4:	83 c0 08             	add    $0x8,%eax
801082e7:	c1 e8 10             	shr    $0x10,%eax
801082ea:	88 45 f7             	mov    %al,-0x9(%ebp)
801082ed:	e8 52 c1 ff ff       	call   80104444 <mycpu>
801082f2:	83 c0 08             	add    $0x8,%eax
801082f5:	c1 e8 18             	shr    $0x18,%eax
801082f8:	89 c2                	mov    %eax,%edx
801082fa:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80108301:	67 00 
80108303:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
8010830a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
8010830e:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80108314:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010831b:	83 e0 f0             	and    $0xfffffff0,%eax
8010831e:	83 c8 09             	or     $0x9,%eax
80108321:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108327:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010832e:	83 c8 10             	or     $0x10,%eax
80108331:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108337:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010833e:	83 e0 9f             	and    $0xffffff9f,%eax
80108341:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108347:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010834e:	83 c8 80             	or     $0xffffff80,%eax
80108351:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80108357:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010835e:	83 e0 f0             	and    $0xfffffff0,%eax
80108361:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108367:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010836e:	83 e0 ef             	and    $0xffffffef,%eax
80108371:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108377:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010837e:	83 e0 df             	and    $0xffffffdf,%eax
80108381:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108387:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010838e:	83 c8 40             	or     $0x40,%eax
80108391:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80108397:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
8010839e:	83 e0 7f             	and    $0x7f,%eax
801083a1:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801083a7:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801083ad:	e8 92 c0 ff ff       	call   80104444 <mycpu>
801083b2:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801083b9:	83 e2 ef             	and    $0xffffffef,%edx
801083bc:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801083c2:	e8 7d c0 ff ff       	call   80104444 <mycpu>
801083c7:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801083cd:	8b 45 08             	mov    0x8(%ebp),%eax
801083d0:	8b 40 08             	mov    0x8(%eax),%eax
801083d3:	89 c3                	mov    %eax,%ebx
801083d5:	e8 6a c0 ff ff       	call   80104444 <mycpu>
801083da:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
801083e0:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801083e3:	e8 5c c0 ff ff       	call   80104444 <mycpu>
801083e8:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801083ee:	83 ec 0c             	sub    $0xc,%esp
801083f1:	6a 28                	push   $0x28
801083f3:	e8 94 f7 ff ff       	call   80107b8c <ltr>
801083f8:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
801083fb:	8b 45 08             	mov    0x8(%ebp),%eax
801083fe:	8b 40 04             	mov    0x4(%eax),%eax
80108401:	05 00 00 00 80       	add    $0x80000000,%eax
80108406:	83 ec 0c             	sub    $0xc,%esp
80108409:	50                   	push   %eax
8010840a:	e8 94 f7 ff ff       	call   80107ba3 <lcr3>
8010840f:	83 c4 10             	add    $0x10,%esp
  popcli();
80108412:	e8 58 d0 ff ff       	call   8010546f <popcli>
}
80108417:	90                   	nop
80108418:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010841b:	5b                   	pop    %ebx
8010841c:	5e                   	pop    %esi
8010841d:	5d                   	pop    %ebp
8010841e:	c3                   	ret    

8010841f <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010841f:	f3 0f 1e fb          	endbr32 
80108423:	55                   	push   %ebp
80108424:	89 e5                	mov    %esp,%ebp
80108426:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80108429:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108430:	76 0d                	jbe    8010843f <inituvm+0x20>
    panic("inituvm: more than a page");
80108432:	83 ec 0c             	sub    $0xc,%esp
80108435:	68 53 98 10 80       	push   $0x80109853
8010843a:	e8 c9 81 ff ff       	call   80100608 <panic>
  mem = kalloc();
8010843f:	e8 b8 a9 ff ff       	call   80102dfc <kalloc>
80108444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108447:	83 ec 04             	sub    $0x4,%esp
8010844a:	68 00 10 00 00       	push   $0x1000
8010844f:	6a 00                	push   $0x0
80108451:	ff 75 f4             	pushl  -0xc(%ebp)
80108454:	e8 d8 d0 ff ff       	call   80105531 <memset>
80108459:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010845c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845f:	05 00 00 00 80       	add    $0x80000000,%eax
80108464:	83 ec 0c             	sub    $0xc,%esp
80108467:	6a 06                	push   $0x6
80108469:	50                   	push   %eax
8010846a:	68 00 10 00 00       	push   $0x1000
8010846f:	6a 00                	push   $0x0
80108471:	ff 75 08             	pushl  0x8(%ebp)
80108474:	e8 76 fc ff ff       	call   801080ef <mappages>
80108479:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010847c:	83 ec 04             	sub    $0x4,%esp
8010847f:	ff 75 10             	pushl  0x10(%ebp)
80108482:	ff 75 0c             	pushl  0xc(%ebp)
80108485:	ff 75 f4             	pushl  -0xc(%ebp)
80108488:	e8 6b d1 ff ff       	call   801055f8 <memmove>
8010848d:	83 c4 10             	add    $0x10,%esp
}
80108490:	90                   	nop
80108491:	c9                   	leave  
80108492:	c3                   	ret    

80108493 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108493:	f3 0f 1e fb          	endbr32 
80108497:	55                   	push   %ebp
80108498:	89 e5                	mov    %esp,%ebp
8010849a:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010849d:	8b 45 0c             	mov    0xc(%ebp),%eax
801084a0:	25 ff 0f 00 00       	and    $0xfff,%eax
801084a5:	85 c0                	test   %eax,%eax
801084a7:	74 0d                	je     801084b6 <loaduvm+0x23>
    panic("loaduvm: addr must be page aligned");
801084a9:	83 ec 0c             	sub    $0xc,%esp
801084ac:	68 70 98 10 80       	push   $0x80109870
801084b1:	e8 52 81 ff ff       	call   80100608 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801084b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084bd:	e9 8f 00 00 00       	jmp    80108551 <loaduvm+0xbe>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801084c2:	8b 55 0c             	mov    0xc(%ebp),%edx
801084c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c8:	01 d0                	add    %edx,%eax
801084ca:	83 ec 04             	sub    $0x4,%esp
801084cd:	6a 00                	push   $0x0
801084cf:	50                   	push   %eax
801084d0:	ff 75 08             	pushl  0x8(%ebp)
801084d3:	e8 7d fb ff ff       	call   80108055 <walkpgdir>
801084d8:	83 c4 10             	add    $0x10,%esp
801084db:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084e2:	75 0d                	jne    801084f1 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
801084e4:	83 ec 0c             	sub    $0xc,%esp
801084e7:	68 93 98 10 80       	push   $0x80109893
801084ec:	e8 17 81 ff ff       	call   80100608 <panic>
    pa = PTE_ADDR(*pte);
801084f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084f4:	8b 00                	mov    (%eax),%eax
801084f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801084fe:	8b 45 18             	mov    0x18(%ebp),%eax
80108501:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108504:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108509:	77 0b                	ja     80108516 <loaduvm+0x83>
      n = sz - i;
8010850b:	8b 45 18             	mov    0x18(%ebp),%eax
8010850e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108511:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108514:	eb 07                	jmp    8010851d <loaduvm+0x8a>
    else
      n = PGSIZE;
80108516:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010851d:	8b 55 14             	mov    0x14(%ebp),%edx
80108520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108523:	01 d0                	add    %edx,%eax
80108525:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108528:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010852e:	ff 75 f0             	pushl  -0x10(%ebp)
80108531:	50                   	push   %eax
80108532:	52                   	push   %edx
80108533:	ff 75 10             	pushl  0x10(%ebp)
80108536:	e8 d9 9a ff ff       	call   80102014 <readi>
8010853b:	83 c4 10             	add    $0x10,%esp
8010853e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80108541:	74 07                	je     8010854a <loaduvm+0xb7>
      return -1;
80108543:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108548:	eb 18                	jmp    80108562 <loaduvm+0xcf>
  for(i = 0; i < sz; i += PGSIZE){
8010854a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108551:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108554:	3b 45 18             	cmp    0x18(%ebp),%eax
80108557:	0f 82 65 ff ff ff    	jb     801084c2 <loaduvm+0x2f>
  }
  return 0;
8010855d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108562:	c9                   	leave  
80108563:	c3                   	ret    

80108564 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108564:	f3 0f 1e fb          	endbr32 
80108568:	55                   	push   %ebp
80108569:	89 e5                	mov    %esp,%ebp
8010856b:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010856e:	8b 45 10             	mov    0x10(%ebp),%eax
80108571:	85 c0                	test   %eax,%eax
80108573:	79 0a                	jns    8010857f <allocuvm+0x1b>
    return 0;
80108575:	b8 00 00 00 00       	mov    $0x0,%eax
8010857a:	e9 ec 00 00 00       	jmp    8010866b <allocuvm+0x107>
  if(newsz < oldsz)
8010857f:	8b 45 10             	mov    0x10(%ebp),%eax
80108582:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108585:	73 08                	jae    8010858f <allocuvm+0x2b>
    return oldsz;
80108587:	8b 45 0c             	mov    0xc(%ebp),%eax
8010858a:	e9 dc 00 00 00       	jmp    8010866b <allocuvm+0x107>

  a = PGROUNDUP(oldsz);
8010858f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108592:	05 ff 0f 00 00       	add    $0xfff,%eax
80108597:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010859c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010859f:	e9 b8 00 00 00       	jmp    8010865c <allocuvm+0xf8>
    mem = kalloc();
801085a4:	e8 53 a8 ff ff       	call   80102dfc <kalloc>
801085a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801085ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801085b0:	75 2e                	jne    801085e0 <allocuvm+0x7c>
      cprintf("allocuvm out of memory\n");
801085b2:	83 ec 0c             	sub    $0xc,%esp
801085b5:	68 b1 98 10 80       	push   $0x801098b1
801085ba:	e8 59 7e ff ff       	call   80100418 <cprintf>
801085bf:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801085c2:	83 ec 04             	sub    $0x4,%esp
801085c5:	ff 75 0c             	pushl  0xc(%ebp)
801085c8:	ff 75 10             	pushl  0x10(%ebp)
801085cb:	ff 75 08             	pushl  0x8(%ebp)
801085ce:	e8 9a 00 00 00       	call   8010866d <deallocuvm>
801085d3:	83 c4 10             	add    $0x10,%esp
      return 0;
801085d6:	b8 00 00 00 00       	mov    $0x0,%eax
801085db:	e9 8b 00 00 00       	jmp    8010866b <allocuvm+0x107>
    }
    memset(mem, 0, PGSIZE);
801085e0:	83 ec 04             	sub    $0x4,%esp
801085e3:	68 00 10 00 00       	push   $0x1000
801085e8:	6a 00                	push   $0x0
801085ea:	ff 75 f0             	pushl  -0x10(%ebp)
801085ed:	e8 3f cf ff ff       	call   80105531 <memset>
801085f2:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801085f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085f8:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801085fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108601:	83 ec 0c             	sub    $0xc,%esp
80108604:	6a 06                	push   $0x6
80108606:	52                   	push   %edx
80108607:	68 00 10 00 00       	push   $0x1000
8010860c:	50                   	push   %eax
8010860d:	ff 75 08             	pushl  0x8(%ebp)
80108610:	e8 da fa ff ff       	call   801080ef <mappages>
80108615:	83 c4 20             	add    $0x20,%esp
80108618:	85 c0                	test   %eax,%eax
8010861a:	79 39                	jns    80108655 <allocuvm+0xf1>
      cprintf("allocuvm out of memory (2)\n");
8010861c:	83 ec 0c             	sub    $0xc,%esp
8010861f:	68 c9 98 10 80       	push   $0x801098c9
80108624:	e8 ef 7d ff ff       	call   80100418 <cprintf>
80108629:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010862c:	83 ec 04             	sub    $0x4,%esp
8010862f:	ff 75 0c             	pushl  0xc(%ebp)
80108632:	ff 75 10             	pushl  0x10(%ebp)
80108635:	ff 75 08             	pushl  0x8(%ebp)
80108638:	e8 30 00 00 00       	call   8010866d <deallocuvm>
8010863d:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80108640:	83 ec 0c             	sub    $0xc,%esp
80108643:	ff 75 f0             	pushl  -0x10(%ebp)
80108646:	e8 13 a7 ff ff       	call   80102d5e <kfree>
8010864b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010864e:	b8 00 00 00 00       	mov    $0x0,%eax
80108653:	eb 16                	jmp    8010866b <allocuvm+0x107>
  for(; a < newsz; a += PGSIZE){
80108655:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010865c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010865f:	3b 45 10             	cmp    0x10(%ebp),%eax
80108662:	0f 82 3c ff ff ff    	jb     801085a4 <allocuvm+0x40>
    }
  }
  return newsz;
80108668:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010866b:	c9                   	leave  
8010866c:	c3                   	ret    

8010866d <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010866d:	f3 0f 1e fb          	endbr32 
80108671:	55                   	push   %ebp
80108672:	89 e5                	mov    %esp,%ebp
80108674:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108677:	8b 45 10             	mov    0x10(%ebp),%eax
8010867a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010867d:	72 08                	jb     80108687 <deallocuvm+0x1a>
    return oldsz;
8010867f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108682:	e9 ae 00 00 00       	jmp    80108735 <deallocuvm+0xc8>

  a = PGROUNDUP(newsz);
80108687:	8b 45 10             	mov    0x10(%ebp),%eax
8010868a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010868f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108694:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108697:	e9 8a 00 00 00       	jmp    80108726 <deallocuvm+0xb9>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010869c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010869f:	83 ec 04             	sub    $0x4,%esp
801086a2:	6a 00                	push   $0x0
801086a4:	50                   	push   %eax
801086a5:	ff 75 08             	pushl  0x8(%ebp)
801086a8:	e8 a8 f9 ff ff       	call   80108055 <walkpgdir>
801086ad:	83 c4 10             	add    $0x10,%esp
801086b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801086b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801086b7:	75 16                	jne    801086cf <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801086b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086bc:	c1 e8 16             	shr    $0x16,%eax
801086bf:	83 c0 01             	add    $0x1,%eax
801086c2:	c1 e0 16             	shl    $0x16,%eax
801086c5:	2d 00 10 00 00       	sub    $0x1000,%eax
801086ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
801086cd:	eb 50                	jmp    8010871f <deallocuvm+0xb2>
    else if((*pte & (PTE_P | PTE_E)) != 0){
801086cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086d2:	8b 00                	mov    (%eax),%eax
801086d4:	25 01 04 00 00       	and    $0x401,%eax
801086d9:	85 c0                	test   %eax,%eax
801086db:	74 42                	je     8010871f <deallocuvm+0xb2>
      pa = PTE_ADDR(*pte);
801086dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086e0:	8b 00                	mov    (%eax),%eax
801086e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801086ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801086ee:	75 0d                	jne    801086fd <deallocuvm+0x90>
        panic("kfree");
801086f0:	83 ec 0c             	sub    $0xc,%esp
801086f3:	68 e5 98 10 80       	push   $0x801098e5
801086f8:	e8 0b 7f ff ff       	call   80100608 <panic>
      char *v = P2V(pa);
801086fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108700:	05 00 00 00 80       	add    $0x80000000,%eax
80108705:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108708:	83 ec 0c             	sub    $0xc,%esp
8010870b:	ff 75 e8             	pushl  -0x18(%ebp)
8010870e:	e8 4b a6 ff ff       	call   80102d5e <kfree>
80108713:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108716:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
8010871f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108729:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010872c:	0f 82 6a ff ff ff    	jb     8010869c <deallocuvm+0x2f>
    }
  }
  return newsz;
80108732:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108735:	c9                   	leave  
80108736:	c3                   	ret    

80108737 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108737:	f3 0f 1e fb          	endbr32 
8010873b:	55                   	push   %ebp
8010873c:	89 e5                	mov    %esp,%ebp
8010873e:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108741:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108745:	75 0d                	jne    80108754 <freevm+0x1d>
    panic("freevm: no pgdir");
80108747:	83 ec 0c             	sub    $0xc,%esp
8010874a:	68 eb 98 10 80       	push   $0x801098eb
8010874f:	e8 b4 7e ff ff       	call   80100608 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108754:	83 ec 04             	sub    $0x4,%esp
80108757:	6a 00                	push   $0x0
80108759:	68 00 00 00 80       	push   $0x80000000
8010875e:	ff 75 08             	pushl  0x8(%ebp)
80108761:	e8 07 ff ff ff       	call   8010866d <deallocuvm>
80108766:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108769:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108770:	eb 4a                	jmp    801087bc <freevm+0x85>
    if(pgdir[i] & (PTE_P | PTE_E)){
80108772:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108775:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010877c:	8b 45 08             	mov    0x8(%ebp),%eax
8010877f:	01 d0                	add    %edx,%eax
80108781:	8b 00                	mov    (%eax),%eax
80108783:	25 01 04 00 00       	and    $0x401,%eax
80108788:	85 c0                	test   %eax,%eax
8010878a:	74 2c                	je     801087b8 <freevm+0x81>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010878c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010878f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108796:	8b 45 08             	mov    0x8(%ebp),%eax
80108799:	01 d0                	add    %edx,%eax
8010879b:	8b 00                	mov    (%eax),%eax
8010879d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087a2:	05 00 00 00 80       	add    $0x80000000,%eax
801087a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801087aa:	83 ec 0c             	sub    $0xc,%esp
801087ad:	ff 75 f0             	pushl  -0x10(%ebp)
801087b0:	e8 a9 a5 ff ff       	call   80102d5e <kfree>
801087b5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801087b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801087bc:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801087c3:	76 ad                	jbe    80108772 <freevm+0x3b>
    }
  }
  kfree((char*)pgdir);
801087c5:	83 ec 0c             	sub    $0xc,%esp
801087c8:	ff 75 08             	pushl  0x8(%ebp)
801087cb:	e8 8e a5 ff ff       	call   80102d5e <kfree>
801087d0:	83 c4 10             	add    $0x10,%esp
}
801087d3:	90                   	nop
801087d4:	c9                   	leave  
801087d5:	c3                   	ret    

801087d6 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801087d6:	f3 0f 1e fb          	endbr32 
801087da:	55                   	push   %ebp
801087db:	89 e5                	mov    %esp,%ebp
801087dd:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801087e0:	83 ec 04             	sub    $0x4,%esp
801087e3:	6a 00                	push   $0x0
801087e5:	ff 75 0c             	pushl  0xc(%ebp)
801087e8:	ff 75 08             	pushl  0x8(%ebp)
801087eb:	e8 65 f8 ff ff       	call   80108055 <walkpgdir>
801087f0:	83 c4 10             	add    $0x10,%esp
801087f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801087f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801087fa:	75 0d                	jne    80108809 <clearpteu+0x33>
    panic("clearpteu");
801087fc:	83 ec 0c             	sub    $0xc,%esp
801087ff:	68 fc 98 10 80       	push   $0x801098fc
80108804:	e8 ff 7d ff ff       	call   80100608 <panic>
  *pte &= ~PTE_U;
80108809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010880c:	8b 00                	mov    (%eax),%eax
8010880e:	83 e0 fb             	and    $0xfffffffb,%eax
80108811:	89 c2                	mov    %eax,%edx
80108813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108816:	89 10                	mov    %edx,(%eax)
}
80108818:	90                   	nop
80108819:	c9                   	leave  
8010881a:	c3                   	ret    

8010881b <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010881b:	f3 0f 1e fb          	endbr32 
8010881f:	55                   	push   %ebp
80108820:	89 e5                	mov    %esp,%ebp
80108822:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108825:	e8 7c f9 ff ff       	call   801081a6 <setupkvm>
8010882a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010882d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108831:	75 0a                	jne    8010883d <copyuvm+0x22>
    return 0;
80108833:	b8 00 00 00 00       	mov    $0x0,%eax
80108838:	e9 fa 00 00 00       	jmp    80108937 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
8010883d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108844:	e9 c9 00 00 00       	jmp    80108912 <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010884c:	83 ec 04             	sub    $0x4,%esp
8010884f:	6a 00                	push   $0x0
80108851:	50                   	push   %eax
80108852:	ff 75 08             	pushl  0x8(%ebp)
80108855:	e8 fb f7 ff ff       	call   80108055 <walkpgdir>
8010885a:	83 c4 10             	add    $0x10,%esp
8010885d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108860:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108864:	75 0d                	jne    80108873 <copyuvm+0x58>
      panic("p4Debug: inside copyuvm, pte should exist");
80108866:	83 ec 0c             	sub    $0xc,%esp
80108869:	68 08 99 10 80       	push   $0x80109908
8010886e:	e8 95 7d ff ff       	call   80100608 <panic>
    if(!(*pte & (PTE_P | PTE_E)))
80108873:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108876:	8b 00                	mov    (%eax),%eax
80108878:	25 01 04 00 00       	and    $0x401,%eax
8010887d:	85 c0                	test   %eax,%eax
8010887f:	75 0d                	jne    8010888e <copyuvm+0x73>
      panic("p4Debug: inside copyuvm, page not present");
80108881:	83 ec 0c             	sub    $0xc,%esp
80108884:	68 34 99 10 80       	push   $0x80109934
80108889:	e8 7a 7d ff ff       	call   80100608 <panic>
    pa = PTE_ADDR(*pte);
8010888e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108891:	8b 00                	mov    (%eax),%eax
80108893:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108898:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010889b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010889e:	8b 00                	mov    (%eax),%eax
801088a0:	25 ff 0f 00 00       	and    $0xfff,%eax
801088a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801088a8:	e8 4f a5 ff ff       	call   80102dfc <kalloc>
801088ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
801088b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801088b4:	74 6d                	je     80108923 <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801088b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801088b9:	05 00 00 00 80       	add    $0x80000000,%eax
801088be:	83 ec 04             	sub    $0x4,%esp
801088c1:	68 00 10 00 00       	push   $0x1000
801088c6:	50                   	push   %eax
801088c7:	ff 75 e0             	pushl  -0x20(%ebp)
801088ca:	e8 29 cd ff ff       	call   801055f8 <memmove>
801088cf:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801088d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801088d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801088d8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801088de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e1:	83 ec 0c             	sub    $0xc,%esp
801088e4:	52                   	push   %edx
801088e5:	51                   	push   %ecx
801088e6:	68 00 10 00 00       	push   $0x1000
801088eb:	50                   	push   %eax
801088ec:	ff 75 f0             	pushl  -0x10(%ebp)
801088ef:	e8 fb f7 ff ff       	call   801080ef <mappages>
801088f4:	83 c4 20             	add    $0x20,%esp
801088f7:	85 c0                	test   %eax,%eax
801088f9:	79 10                	jns    8010890b <copyuvm+0xf0>
      kfree(mem);
801088fb:	83 ec 0c             	sub    $0xc,%esp
801088fe:	ff 75 e0             	pushl  -0x20(%ebp)
80108901:	e8 58 a4 ff ff       	call   80102d5e <kfree>
80108906:	83 c4 10             	add    $0x10,%esp
      goto bad;
80108909:	eb 19                	jmp    80108924 <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
8010890b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108915:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108918:	0f 82 2b ff ff ff    	jb     80108849 <copyuvm+0x2e>
    }
  }
  return d;
8010891e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108921:	eb 14                	jmp    80108937 <copyuvm+0x11c>
      goto bad;
80108923:	90                   	nop

bad:
  freevm(d);
80108924:	83 ec 0c             	sub    $0xc,%esp
80108927:	ff 75 f0             	pushl  -0x10(%ebp)
8010892a:	e8 08 fe ff ff       	call   80108737 <freevm>
8010892f:	83 c4 10             	add    $0x10,%esp
  return 0;
80108932:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108937:	c9                   	leave  
80108938:	c3                   	ret    

80108939 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108939:	f3 0f 1e fb          	endbr32 
8010893d:	55                   	push   %ebp
8010893e:	89 e5                	mov    %esp,%ebp
80108940:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108943:	83 ec 04             	sub    $0x4,%esp
80108946:	6a 00                	push   $0x0
80108948:	ff 75 0c             	pushl  0xc(%ebp)
8010894b:	ff 75 08             	pushl  0x8(%ebp)
8010894e:	e8 02 f7 ff ff       	call   80108055 <walkpgdir>
80108953:	83 c4 10             	add    $0x10,%esp
80108956:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // p4Debug: Check for page's present and encrypted flags.
  if(((*pte & PTE_P) | (*pte & PTE_E)) == 0)
80108959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010895c:	8b 00                	mov    (%eax),%eax
8010895e:	25 01 04 00 00       	and    $0x401,%eax
80108963:	85 c0                	test   %eax,%eax
80108965:	75 07                	jne    8010896e <uva2ka+0x35>
    return 0;
80108967:	b8 00 00 00 00       	mov    $0x0,%eax
8010896c:	eb 22                	jmp    80108990 <uva2ka+0x57>
  if((*pte & PTE_U) == 0)
8010896e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108971:	8b 00                	mov    (%eax),%eax
80108973:	83 e0 04             	and    $0x4,%eax
80108976:	85 c0                	test   %eax,%eax
80108978:	75 07                	jne    80108981 <uva2ka+0x48>
    return 0;
8010897a:	b8 00 00 00 00       	mov    $0x0,%eax
8010897f:	eb 0f                	jmp    80108990 <uva2ka+0x57>
  return (char*)P2V(PTE_ADDR(*pte));
80108981:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108984:	8b 00                	mov    (%eax),%eax
80108986:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010898b:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108990:	c9                   	leave  
80108991:	c3                   	ret    

80108992 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108992:	f3 0f 1e fb          	endbr32 
80108996:	55                   	push   %ebp
80108997:	89 e5                	mov    %esp,%ebp
80108999:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010899c:	8b 45 10             	mov    0x10(%ebp),%eax
8010899f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801089a2:	eb 7f                	jmp    80108a23 <copyout+0x91>
    va0 = (uint)PGROUNDDOWN(va);
801089a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801089a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801089af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089b2:	83 ec 08             	sub    $0x8,%esp
801089b5:	50                   	push   %eax
801089b6:	ff 75 08             	pushl  0x8(%ebp)
801089b9:	e8 7b ff ff ff       	call   80108939 <uva2ka>
801089be:	83 c4 10             	add    $0x10,%esp
801089c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801089c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801089c8:	75 07                	jne    801089d1 <copyout+0x3f>
    {
      //p4Debug : Cannot find page in kernel space.
      return -1;
801089ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801089cf:	eb 61                	jmp    80108a32 <copyout+0xa0>
    }
    n = PGSIZE - (va - va0);
801089d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089d4:	2b 45 0c             	sub    0xc(%ebp),%eax
801089d7:	05 00 10 00 00       	add    $0x1000,%eax
801089dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801089df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089e2:	3b 45 14             	cmp    0x14(%ebp),%eax
801089e5:	76 06                	jbe    801089ed <copyout+0x5b>
      n = len;
801089e7:	8b 45 14             	mov    0x14(%ebp),%eax
801089ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801089ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801089f0:	2b 45 ec             	sub    -0x14(%ebp),%eax
801089f3:	89 c2                	mov    %eax,%edx
801089f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801089f8:	01 d0                	add    %edx,%eax
801089fa:	83 ec 04             	sub    $0x4,%esp
801089fd:	ff 75 f0             	pushl  -0x10(%ebp)
80108a00:	ff 75 f4             	pushl  -0xc(%ebp)
80108a03:	50                   	push   %eax
80108a04:	e8 ef cb ff ff       	call   801055f8 <memmove>
80108a09:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a0f:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a15:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a1b:	05 00 10 00 00       	add    $0x1000,%eax
80108a20:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108a23:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108a27:	0f 85 77 ff ff ff    	jne    801089a4 <copyout+0x12>
  }
  return 0;
80108a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a32:	c9                   	leave  
80108a33:	c3                   	ret    

80108a34 <translate_and_set>:

//This function is just like uva2ka but sets the PTE_E bit and clears PTE_P
char* translate_and_set(pde_t *pgdir, char *uva) {
80108a34:	f3 0f 1e fb          	endbr32 
80108a38:	55                   	push   %ebp
80108a39:	89 e5                	mov    %esp,%ebp
80108a3b:	83 ec 18             	sub    $0x18,%esp
  cprintf("p4Debug: setting PTE_E for %p, VPN %d\n", uva, PPN(uva));
80108a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a41:	c1 e8 0c             	shr    $0xc,%eax
80108a44:	83 ec 04             	sub    $0x4,%esp
80108a47:	50                   	push   %eax
80108a48:	ff 75 0c             	pushl  0xc(%ebp)
80108a4b:	68 60 99 10 80       	push   $0x80109960
80108a50:	e8 c3 79 ff ff       	call   80100418 <cprintf>
80108a55:	83 c4 10             	add    $0x10,%esp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80108a58:	83 ec 04             	sub    $0x4,%esp
80108a5b:	6a 00                	push   $0x0
80108a5d:	ff 75 0c             	pushl  0xc(%ebp)
80108a60:	ff 75 08             	pushl  0x8(%ebp)
80108a63:	e8 ed f5 ff ff       	call   80108055 <walkpgdir>
80108a68:	83 c4 10             	add    $0x10,%esp
80108a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  //p4Debug: If page is not present AND it is not encrypted.
  if((*pte & PTE_P) == 0 && (*pte & PTE_E) == 0)
80108a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a71:	8b 00                	mov    (%eax),%eax
80108a73:	83 e0 01             	and    $0x1,%eax
80108a76:	85 c0                	test   %eax,%eax
80108a78:	75 18                	jne    80108a92 <translate_and_set+0x5e>
80108a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a7d:	8b 00                	mov    (%eax),%eax
80108a7f:	25 00 04 00 00       	and    $0x400,%eax
80108a84:	85 c0                	test   %eax,%eax
80108a86:	75 0a                	jne    80108a92 <translate_and_set+0x5e>
    return 0;
80108a88:	b8 00 00 00 00       	mov    $0x0,%eax
80108a8d:	e9 84 00 00 00       	jmp    80108b16 <translate_and_set+0xe2>
  //p4Debug: If page is already encrypted, i.e. PTE_E is set, return NULL as error;
  if((*pte & PTE_E)) {
80108a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a95:	8b 00                	mov    (%eax),%eax
80108a97:	25 00 04 00 00       	and    $0x400,%eax
80108a9c:	85 c0                	test   %eax,%eax
80108a9e:	74 07                	je     80108aa7 <translate_and_set+0x73>
    return 0;
80108aa0:	b8 00 00 00 00       	mov    $0x0,%eax
80108aa5:	eb 6f                	jmp    80108b16 <translate_and_set+0xe2>
  }
  // p4Debug: Check if users are allowed to use this page
  if((*pte & PTE_U) == 0)
80108aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aaa:	8b 00                	mov    (%eax),%eax
80108aac:	83 e0 04             	and    $0x4,%eax
80108aaf:	85 c0                	test   %eax,%eax
80108ab1:	75 07                	jne    80108aba <translate_and_set+0x86>
    return 0;
80108ab3:	b8 00 00 00 00       	mov    $0x0,%eax
80108ab8:	eb 5c                	jmp    80108b16 <translate_and_set+0xe2>
  //p4Debug: Set Page as encrypted and not present so that we can trap(see trap.c) to decrypt page
  cprintf("p4Debug: PTE was %x and its pointer %p\n", *pte, pte);
80108aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108abd:	8b 00                	mov    (%eax),%eax
80108abf:	83 ec 04             	sub    $0x4,%esp
80108ac2:	ff 75 f4             	pushl  -0xc(%ebp)
80108ac5:	50                   	push   %eax
80108ac6:	68 88 99 10 80       	push   $0x80109988
80108acb:	e8 48 79 ff ff       	call   80100418 <cprintf>
80108ad0:	83 c4 10             	add    $0x10,%esp
  *pte = *pte | PTE_E;
80108ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad6:	8b 00                	mov    (%eax),%eax
80108ad8:	80 cc 04             	or     $0x4,%ah
80108adb:	89 c2                	mov    %eax,%edx
80108add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ae0:	89 10                	mov    %edx,(%eax)
  *pte = *pte & ~PTE_P;
80108ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ae5:	8b 00                	mov    (%eax),%eax
80108ae7:	83 e0 fe             	and    $0xfffffffe,%eax
80108aea:	89 c2                	mov    %eax,%edx
80108aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aef:	89 10                	mov    %edx,(%eax)
  cprintf("p4Debug: PTE is now %x\n", *pte);
80108af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af4:	8b 00                	mov    (%eax),%eax
80108af6:	83 ec 08             	sub    $0x8,%esp
80108af9:	50                   	push   %eax
80108afa:	68 b0 99 10 80       	push   $0x801099b0
80108aff:	e8 14 79 ff ff       	call   80100418 <cprintf>
80108b04:	83 c4 10             	add    $0x10,%esp
  return (char*)P2V(PTE_ADDR(*pte));
80108b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b0a:	8b 00                	mov    (%eax),%eax
80108b0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b11:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108b16:	c9                   	leave  
80108b17:	c3                   	ret    

80108b18 <mdecrypt>:


int mdecrypt(char *virtual_addr) {
80108b18:	f3 0f 1e fb          	endbr32 
80108b1c:	55                   	push   %ebp
80108b1d:	89 e5                	mov    %esp,%ebp
80108b1f:	83 ec 28             	sub    $0x28,%esp
  cprintf("p4Debug:  mdecrypt VPN %d, %p, pid %d\n", PPN(virtual_addr), virtual_addr, myproc()->pid);
80108b22:	e8 99 b9 ff ff       	call   801044c0 <myproc>
80108b27:	8b 40 10             	mov    0x10(%eax),%eax
80108b2a:	8b 55 08             	mov    0x8(%ebp),%edx
80108b2d:	c1 ea 0c             	shr    $0xc,%edx
80108b30:	50                   	push   %eax
80108b31:	ff 75 08             	pushl  0x8(%ebp)
80108b34:	52                   	push   %edx
80108b35:	68 c8 99 10 80       	push   $0x801099c8
80108b3a:	e8 d9 78 ff ff       	call   80100418 <cprintf>
80108b3f:	83 c4 10             	add    $0x10,%esp
  //p4Debug: virtual_addr is a virtual address in this PID's userspace.
  struct proc * p = myproc();
80108b42:	e8 79 b9 ff ff       	call   801044c0 <myproc>
80108b47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pde_t* mypd = p->pgdir;
80108b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b4d:	8b 40 04             	mov    0x4(%eax),%eax
80108b50:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //set the present bit to true and encrypt bit to false
  pte_t * pte = walkpgdir(mypd, virtual_addr, 0);
80108b53:	83 ec 04             	sub    $0x4,%esp
80108b56:	6a 00                	push   $0x0
80108b58:	ff 75 08             	pushl  0x8(%ebp)
80108b5b:	ff 75 e8             	pushl  -0x18(%ebp)
80108b5e:	e8 f2 f4 ff ff       	call   80108055 <walkpgdir>
80108b63:	83 c4 10             	add    $0x10,%esp
80108b66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (!pte || *pte == 0) {
80108b69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108b6d:	74 09                	je     80108b78 <mdecrypt+0x60>
80108b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108b72:	8b 00                	mov    (%eax),%eax
80108b74:	85 c0                	test   %eax,%eax
80108b76:	75 1a                	jne    80108b92 <mdecrypt+0x7a>
    cprintf("p4Debug: walkpgdir failed\n");
80108b78:	83 ec 0c             	sub    $0xc,%esp
80108b7b:	68 ef 99 10 80       	push   $0x801099ef
80108b80:	e8 93 78 ff ff       	call   80100418 <cprintf>
80108b85:	83 c4 10             	add    $0x10,%esp
    return -1;
80108b88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108b8d:	e9 f9 00 00 00       	jmp    80108c8b <mdecrypt+0x173>
  }
  cprintf("p4Debug: pte was %x\n", *pte);
80108b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108b95:	8b 00                	mov    (%eax),%eax
80108b97:	83 ec 08             	sub    $0x8,%esp
80108b9a:	50                   	push   %eax
80108b9b:	68 0a 9a 10 80       	push   $0x80109a0a
80108ba0:	e8 73 78 ff ff       	call   80100418 <cprintf>
80108ba5:	83 c4 10             	add    $0x10,%esp
  *pte = *pte & ~PTE_E;
80108ba8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108bab:	8b 00                	mov    (%eax),%eax
80108bad:	80 e4 fb             	and    $0xfb,%ah
80108bb0:	89 c2                	mov    %eax,%edx
80108bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108bb5:	89 10                	mov    %edx,(%eax)
  *pte = *pte | PTE_P;
80108bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108bba:	8b 00                	mov    (%eax),%eax
80108bbc:	83 c8 01             	or     $0x1,%eax
80108bbf:	89 c2                	mov    %eax,%edx
80108bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108bc4:	89 10                	mov    %edx,(%eax)
  cprintf("p4Debug: pte is %x\n", *pte);
80108bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108bc9:	8b 00                	mov    (%eax),%eax
80108bcb:	83 ec 08             	sub    $0x8,%esp
80108bce:	50                   	push   %eax
80108bcf:	68 1f 9a 10 80       	push   $0x80109a1f
80108bd4:	e8 3f 78 ff ff       	call   80100418 <cprintf>
80108bd9:	83 c4 10             	add    $0x10,%esp
  char * original = uva2ka(mypd, virtual_addr) + OFFSET(virtual_addr);
80108bdc:	83 ec 08             	sub    $0x8,%esp
80108bdf:	ff 75 08             	pushl  0x8(%ebp)
80108be2:	ff 75 e8             	pushl  -0x18(%ebp)
80108be5:	e8 4f fd ff ff       	call   80108939 <uva2ka>
80108bea:	83 c4 10             	add    $0x10,%esp
80108bed:	8b 55 08             	mov    0x8(%ebp),%edx
80108bf0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80108bf6:	01 d0                	add    %edx,%eax
80108bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  cprintf("p4Debug: Original in decrypt was %p\n", original);
80108bfb:	83 ec 08             	sub    $0x8,%esp
80108bfe:	ff 75 e0             	pushl  -0x20(%ebp)
80108c01:	68 34 9a 10 80       	push   $0x80109a34
80108c06:	e8 0d 78 ff ff       	call   80100418 <cprintf>
80108c0b:	83 c4 10             	add    $0x10,%esp
  virtual_addr = (char *)PGROUNDDOWN((uint)virtual_addr);
80108c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80108c11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c16:	89 45 08             	mov    %eax,0x8(%ebp)
  cprintf("p4Debug: mdecrypt: rounded down va is %p\n", virtual_addr);
80108c19:	83 ec 08             	sub    $0x8,%esp
80108c1c:	ff 75 08             	pushl  0x8(%ebp)
80108c1f:	68 5c 9a 10 80       	push   $0x80109a5c
80108c24:	e8 ef 77 ff ff       	call   80100418 <cprintf>
80108c29:	83 c4 10             	add    $0x10,%esp

  char * kvp = uva2ka(mypd, virtual_addr);
80108c2c:	83 ec 08             	sub    $0x8,%esp
80108c2f:	ff 75 08             	pushl  0x8(%ebp)
80108c32:	ff 75 e8             	pushl  -0x18(%ebp)
80108c35:	e8 ff fc ff ff       	call   80108939 <uva2ka>
80108c3a:	83 c4 10             	add    $0x10,%esp
80108c3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (!kvp || *kvp == 0) {
80108c40:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80108c44:	74 0a                	je     80108c50 <mdecrypt+0x138>
80108c46:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c49:	0f b6 00             	movzbl (%eax),%eax
80108c4c:	84 c0                	test   %al,%al
80108c4e:	75 07                	jne    80108c57 <mdecrypt+0x13f>
    return -1;
80108c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108c55:	eb 34                	jmp    80108c8b <mdecrypt+0x173>
  }
  char * slider = virtual_addr;
80108c57:	8b 45 08             	mov    0x8(%ebp),%eax
80108c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int offset = 0; offset < PGSIZE; offset++) {
80108c5d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108c64:	eb 17                	jmp    80108c7d <mdecrypt+0x165>
    *slider = *slider ^ 0xFF;
80108c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c69:	0f b6 00             	movzbl (%eax),%eax
80108c6c:	f7 d0                	not    %eax
80108c6e:	89 c2                	mov    %eax,%edx
80108c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c73:	88 10                	mov    %dl,(%eax)
    slider++;
80108c75:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  for (int offset = 0; offset < PGSIZE; offset++) {
80108c79:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108c7d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80108c84:	7e e0                	jle    80108c66 <mdecrypt+0x14e>
  }
  return 0;
80108c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c8b:	c9                   	leave  
80108c8c:	c3                   	ret    

80108c8d <mencrypt>:

int mencrypt(char *virtual_addr, int len) {
80108c8d:	f3 0f 1e fb          	endbr32 
80108c91:	55                   	push   %ebp
80108c92:	89 e5                	mov    %esp,%ebp
80108c94:	83 ec 38             	sub    $0x38,%esp
  cprintf("p4Debug: mencrypt: %p %d\n", virtual_addr, len);
80108c97:	83 ec 04             	sub    $0x4,%esp
80108c9a:	ff 75 0c             	pushl  0xc(%ebp)
80108c9d:	ff 75 08             	pushl  0x8(%ebp)
80108ca0:	68 86 9a 10 80       	push   $0x80109a86
80108ca5:	e8 6e 77 ff ff       	call   80100418 <cprintf>
80108caa:	83 c4 10             	add    $0x10,%esp
  //the given pointer is a virtual address in this pid's userspace
  struct proc * p = myproc();
80108cad:	e8 0e b8 ff ff       	call   801044c0 <myproc>
80108cb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pde_t* mypd = p->pgdir;
80108cb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108cb8:	8b 40 04             	mov    0x4(%eax),%eax
80108cbb:	89 45 e0             	mov    %eax,-0x20(%ebp)

  virtual_addr = (char *)PGROUNDDOWN((uint)virtual_addr);
80108cbe:	8b 45 08             	mov    0x8(%ebp),%eax
80108cc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cc6:	89 45 08             	mov    %eax,0x8(%ebp)

  //error checking first. all or nothing.
  char * slider = virtual_addr;
80108cc9:	8b 45 08             	mov    0x8(%ebp),%eax
80108ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int i = 0; i < len; i++) { 
80108ccf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108cd6:	eb 55                	jmp    80108d2d <mencrypt+0xa0>
    //check page table for each translation first
    char * kvp = uva2ka(mypd, slider);
80108cd8:	83 ec 08             	sub    $0x8,%esp
80108cdb:	ff 75 f4             	pushl  -0xc(%ebp)
80108cde:	ff 75 e0             	pushl  -0x20(%ebp)
80108ce1:	e8 53 fc ff ff       	call   80108939 <uva2ka>
80108ce6:	83 c4 10             	add    $0x10,%esp
80108ce9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    cprintf("p4Debug: slider %p, kvp for err check is %p\n",slider, kvp);
80108cec:	83 ec 04             	sub    $0x4,%esp
80108cef:	ff 75 d0             	pushl  -0x30(%ebp)
80108cf2:	ff 75 f4             	pushl  -0xc(%ebp)
80108cf5:	68 a0 9a 10 80       	push   $0x80109aa0
80108cfa:	e8 19 77 ff ff       	call   80100418 <cprintf>
80108cff:	83 c4 10             	add    $0x10,%esp
    if (!kvp) {
80108d02:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
80108d06:	75 1a                	jne    80108d22 <mencrypt+0x95>
      cprintf("p4Debug: mencrypt: kvp = NULL\n");
80108d08:	83 ec 0c             	sub    $0xc,%esp
80108d0b:	68 d0 9a 10 80       	push   $0x80109ad0
80108d10:	e8 03 77 ff ff       	call   80100418 <cprintf>
80108d15:	83 c4 10             	add    $0x10,%esp
      return -1;
80108d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d1d:	e9 3f 01 00 00       	jmp    80108e61 <mencrypt+0x1d4>
    }
    slider = slider + PGSIZE;
80108d22:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  for (int i = 0; i < len; i++) { 
80108d29:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d30:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108d33:	7c a3                	jl     80108cd8 <mencrypt+0x4b>
  }

  //encrypt stage. Have to do this before setting flag 
  //or else we'll page fault
  slider = virtual_addr;
80108d35:	8b 45 08             	mov    0x8(%ebp),%eax
80108d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int i = 0; i < len; i++) {
80108d3b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80108d42:	e9 f8 00 00 00       	jmp    80108e3f <mencrypt+0x1b2>
    cprintf("p4Debug: mencryptr: VPN %d, %p\n", PPN(slider), slider);
80108d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d4a:	c1 e8 0c             	shr    $0xc,%eax
80108d4d:	83 ec 04             	sub    $0x4,%esp
80108d50:	ff 75 f4             	pushl  -0xc(%ebp)
80108d53:	50                   	push   %eax
80108d54:	68 f0 9a 10 80       	push   $0x80109af0
80108d59:	e8 ba 76 ff ff       	call   80100418 <cprintf>
80108d5e:	83 c4 10             	add    $0x10,%esp
    //kvp = kernel virtual pointer
    //virtual address in kernel space that maps to the given pointer
    char * kvp = uva2ka(mypd, slider);
80108d61:	83 ec 08             	sub    $0x8,%esp
80108d64:	ff 75 f4             	pushl  -0xc(%ebp)
80108d67:	ff 75 e0             	pushl  -0x20(%ebp)
80108d6a:	e8 ca fb ff ff       	call   80108939 <uva2ka>
80108d6f:	83 c4 10             	add    $0x10,%esp
80108d72:	89 45 dc             	mov    %eax,-0x24(%ebp)
    cprintf("p4Debug: kvp for encrypt stage is %p\n", kvp);
80108d75:	83 ec 08             	sub    $0x8,%esp
80108d78:	ff 75 dc             	pushl  -0x24(%ebp)
80108d7b:	68 10 9b 10 80       	push   $0x80109b10
80108d80:	e8 93 76 ff ff       	call   80100418 <cprintf>
80108d85:	83 c4 10             	add    $0x10,%esp
    pte_t * mypte = walkpgdir(mypd, slider, 0);
80108d88:	83 ec 04             	sub    $0x4,%esp
80108d8b:	6a 00                	push   $0x0
80108d8d:	ff 75 f4             	pushl  -0xc(%ebp)
80108d90:	ff 75 e0             	pushl  -0x20(%ebp)
80108d93:	e8 bd f2 ff ff       	call   80108055 <walkpgdir>
80108d98:	83 c4 10             	add    $0x10,%esp
80108d9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    cprintf("p4Debug: pte is %x\n", *mypte);
80108d9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108da1:	8b 00                	mov    (%eax),%eax
80108da3:	83 ec 08             	sub    $0x8,%esp
80108da6:	50                   	push   %eax
80108da7:	68 1f 9a 10 80       	push   $0x80109a1f
80108dac:	e8 67 76 ff ff       	call   80100418 <cprintf>
80108db1:	83 c4 10             	add    $0x10,%esp
    if (*mypte & PTE_E) {
80108db4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108db7:	8b 00                	mov    (%eax),%eax
80108db9:	25 00 04 00 00       	and    $0x400,%eax
80108dbe:	85 c0                	test   %eax,%eax
80108dc0:	74 19                	je     80108ddb <mencrypt+0x14e>
      cprintf("p4Debug: already encrypted\n");
80108dc2:	83 ec 0c             	sub    $0xc,%esp
80108dc5:	68 36 9b 10 80       	push   $0x80109b36
80108dca:	e8 49 76 ff ff       	call   80100418 <cprintf>
80108dcf:	83 c4 10             	add    $0x10,%esp
      slider += PGSIZE;
80108dd2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
      continue;
80108dd9:	eb 60                	jmp    80108e3b <mencrypt+0x1ae>
    }
    for (int offset = 0; offset < PGSIZE; offset++) {
80108ddb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80108de2:	eb 17                	jmp    80108dfb <mencrypt+0x16e>
      *slider = *slider ^ 0xFF;
80108de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de7:	0f b6 00             	movzbl (%eax),%eax
80108dea:	f7 d0                	not    %eax
80108dec:	89 c2                	mov    %eax,%edx
80108dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108df1:	88 10                	mov    %dl,(%eax)
      slider++;
80108df3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    for (int offset = 0; offset < PGSIZE; offset++) {
80108df7:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80108dfb:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
80108e02:	7e e0                	jle    80108de4 <mencrypt+0x157>
    }
    char * kvp_translated = translate_and_set(mypd, slider-PGSIZE);
80108e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e07:	2d 00 10 00 00       	sub    $0x1000,%eax
80108e0c:	83 ec 08             	sub    $0x8,%esp
80108e0f:	50                   	push   %eax
80108e10:	ff 75 e0             	pushl  -0x20(%ebp)
80108e13:	e8 1c fc ff ff       	call   80108a34 <translate_and_set>
80108e18:	83 c4 10             	add    $0x10,%esp
80108e1b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (!kvp_translated) {
80108e1e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80108e22:	75 17                	jne    80108e3b <mencrypt+0x1ae>
      cprintf("p4Debug: translate failed!");
80108e24:	83 ec 0c             	sub    $0xc,%esp
80108e27:	68 52 9b 10 80       	push   $0x80109b52
80108e2c:	e8 e7 75 ff ff       	call   80100418 <cprintf>
80108e31:	83 c4 10             	add    $0x10,%esp
      return -1;
80108e34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e39:	eb 26                	jmp    80108e61 <mencrypt+0x1d4>
  for (int i = 0; i < len; i++) {
80108e3b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80108e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e42:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108e45:	0f 8c fc fe ff ff    	jl     80108d47 <mencrypt+0xba>
    }
  }

  switchuvm(myproc());
80108e4b:	e8 70 b6 ff ff       	call   801044c0 <myproc>
80108e50:	83 ec 0c             	sub    $0xc,%esp
80108e53:	50                   	push   %eax
80108e54:	e8 23 f4 ff ff       	call   8010827c <switchuvm>
80108e59:	83 c4 10             	add    $0x10,%esp
  return 0;
80108e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e61:	c9                   	leave  
80108e62:	c3                   	ret    

80108e63 <getpgtable>:

int getpgtable(struct pt_entry* pt_entries, int num) {
80108e63:	f3 0f 1e fb          	endbr32 
80108e67:	55                   	push   %ebp
80108e68:	89 e5                	mov    %esp,%ebp
80108e6a:	83 ec 28             	sub    $0x28,%esp
  cprintf("p4Debug: getpgtable: %p, %d\n", pt_entries, num);
80108e6d:	83 ec 04             	sub    $0x4,%esp
80108e70:	ff 75 0c             	pushl  0xc(%ebp)
80108e73:	ff 75 08             	pushl  0x8(%ebp)
80108e76:	68 6d 9b 10 80       	push   $0x80109b6d
80108e7b:	e8 98 75 ff ff       	call   80100418 <cprintf>
80108e80:	83 c4 10             	add    $0x10,%esp

  struct proc *curproc = myproc();
80108e83:	e8 38 b6 ff ff       	call   801044c0 <myproc>
80108e88:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pde_t *pgdir = curproc->pgdir;
80108e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e8e:	8b 40 04             	mov    0x4(%eax),%eax
80108e91:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint uva = 0;
80108e94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if (curproc->sz % PGSIZE == 0)
80108e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e9e:	8b 00                	mov    (%eax),%eax
80108ea0:	25 ff 0f 00 00       	and    $0xfff,%eax
80108ea5:	85 c0                	test   %eax,%eax
80108ea7:	75 0f                	jne    80108eb8 <getpgtable+0x55>
    uva = curproc->sz - PGSIZE;
80108ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108eac:	8b 00                	mov    (%eax),%eax
80108eae:	2d 00 10 00 00       	sub    $0x1000,%eax
80108eb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108eb6:	eb 0d                	jmp    80108ec5 <getpgtable+0x62>
  else 
    uva = PGROUNDDOWN(curproc->sz);
80108eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ebb:	8b 00                	mov    (%eax),%eax
80108ebd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ec2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  int i = 0;
80108ec5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (;;uva -=PGSIZE)
  {
    
    pte_t *pte = walkpgdir(pgdir, (const void *)uva, 0);
80108ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ecf:	83 ec 04             	sub    $0x4,%esp
80108ed2:	6a 00                	push   $0x0
80108ed4:	50                   	push   %eax
80108ed5:	ff 75 e8             	pushl  -0x18(%ebp)
80108ed8:	e8 78 f1 ff ff       	call   80108055 <walkpgdir>
80108edd:	83 c4 10             	add    $0x10,%esp
80108ee0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    if (!(*pte & PTE_U) || !(*pte & (PTE_P | PTE_E)))
80108ee3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108ee6:	8b 00                	mov    (%eax),%eax
80108ee8:	83 e0 04             	and    $0x4,%eax
80108eeb:	85 c0                	test   %eax,%eax
80108eed:	0f 84 7e 01 00 00    	je     80109071 <getpgtable+0x20e>
80108ef3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108ef6:	8b 00                	mov    (%eax),%eax
80108ef8:	25 01 04 00 00       	and    $0x401,%eax
80108efd:	85 c0                	test   %eax,%eax
80108eff:	0f 84 6c 01 00 00    	je     80109071 <getpgtable+0x20e>
      continue;

    pt_entries[i].pdx = PDX(uva);
80108f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f08:	c1 e8 16             	shr    $0x16,%eax
80108f0b:	89 c1                	mov    %eax,%ecx
80108f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f10:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80108f17:	8b 45 08             	mov    0x8(%ebp),%eax
80108f1a:	01 c2                	add    %eax,%edx
80108f1c:	89 c8                	mov    %ecx,%eax
80108f1e:	66 25 ff 03          	and    $0x3ff,%ax
80108f22:	66 25 ff 03          	and    $0x3ff,%ax
80108f26:	89 c1                	mov    %eax,%ecx
80108f28:	0f b7 02             	movzwl (%edx),%eax
80108f2b:	66 25 00 fc          	and    $0xfc00,%ax
80108f2f:	09 c8                	or     %ecx,%eax
80108f31:	66 89 02             	mov    %ax,(%edx)
    pt_entries[i].ptx = PTX(uva);
80108f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f37:	c1 e8 0c             	shr    $0xc,%eax
80108f3a:	89 c1                	mov    %eax,%ecx
80108f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f3f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80108f46:	8b 45 08             	mov    0x8(%ebp),%eax
80108f49:	01 c2                	add    %eax,%edx
80108f4b:	89 c8                	mov    %ecx,%eax
80108f4d:	66 25 ff 03          	and    $0x3ff,%ax
80108f51:	0f b7 c0             	movzwl %ax,%eax
80108f54:	25 ff 03 00 00       	and    $0x3ff,%eax
80108f59:	c1 e0 0a             	shl    $0xa,%eax
80108f5c:	89 c1                	mov    %eax,%ecx
80108f5e:	8b 02                	mov    (%edx),%eax
80108f60:	25 ff 03 f0 ff       	and    $0xfff003ff,%eax
80108f65:	09 c8                	or     %ecx,%eax
80108f67:	89 02                	mov    %eax,(%edx)
    pt_entries[i].ppage = *pte >> PTXSHIFT;
80108f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f6c:	8b 00                	mov    (%eax),%eax
80108f6e:	c1 e8 0c             	shr    $0xc,%eax
80108f71:	89 c2                	mov    %eax,%edx
80108f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f76:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80108f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80108f80:	01 c8                	add    %ecx,%eax
80108f82:	81 e2 ff ff 0f 00    	and    $0xfffff,%edx
80108f88:	89 d1                	mov    %edx,%ecx
80108f8a:	81 e1 ff ff 0f 00    	and    $0xfffff,%ecx
80108f90:	8b 50 04             	mov    0x4(%eax),%edx
80108f93:	81 e2 00 00 f0 ff    	and    $0xfff00000,%edx
80108f99:	09 ca                	or     %ecx,%edx
80108f9b:	89 50 04             	mov    %edx,0x4(%eax)
    pt_entries[i].present = *pte & PTE_P;
80108f9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108fa1:	8b 08                	mov    (%eax),%ecx
80108fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fa6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80108fad:	8b 45 08             	mov    0x8(%ebp),%eax
80108fb0:	01 c2                	add    %eax,%edx
80108fb2:	89 c8                	mov    %ecx,%eax
80108fb4:	83 e0 01             	and    $0x1,%eax
80108fb7:	83 e0 01             	and    $0x1,%eax
80108fba:	c1 e0 04             	shl    $0x4,%eax
80108fbd:	89 c1                	mov    %eax,%ecx
80108fbf:	0f b6 42 06          	movzbl 0x6(%edx),%eax
80108fc3:	83 e0 ef             	and    $0xffffffef,%eax
80108fc6:	09 c8                	or     %ecx,%eax
80108fc8:	88 42 06             	mov    %al,0x6(%edx)
    pt_entries[i].writable = (*pte & PTE_W) > 0;
80108fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108fce:	8b 00                	mov    (%eax),%eax
80108fd0:	83 e0 02             	and    $0x2,%eax
80108fd3:	89 c2                	mov    %eax,%edx
80108fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fd8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80108fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80108fe2:	01 c8                	add    %ecx,%eax
80108fe4:	85 d2                	test   %edx,%edx
80108fe6:	0f 95 c2             	setne  %dl
80108fe9:	83 e2 01             	and    $0x1,%edx
80108fec:	89 d1                	mov    %edx,%ecx
80108fee:	c1 e1 05             	shl    $0x5,%ecx
80108ff1:	0f b6 50 06          	movzbl 0x6(%eax),%edx
80108ff5:	83 e2 df             	and    $0xffffffdf,%edx
80108ff8:	09 ca                	or     %ecx,%edx
80108ffa:	88 50 06             	mov    %dl,0x6(%eax)
    pt_entries[i].encrypted = (*pte & PTE_E) > 0;
80108ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109000:	8b 00                	mov    (%eax),%eax
80109002:	25 00 04 00 00       	and    $0x400,%eax
80109007:	89 c2                	mov    %eax,%edx
80109009:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010900c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80109013:	8b 45 08             	mov    0x8(%ebp),%eax
80109016:	01 c8                	add    %ecx,%eax
80109018:	85 d2                	test   %edx,%edx
8010901a:	0f 95 c2             	setne  %dl
8010901d:	89 d1                	mov    %edx,%ecx
8010901f:	c1 e1 07             	shl    $0x7,%ecx
80109022:	0f b6 50 06          	movzbl 0x6(%eax),%edx
80109026:	83 e2 7f             	and    $0x7f,%edx
80109029:	09 ca                	or     %ecx,%edx
8010902b:	88 50 06             	mov    %dl,0x6(%eax)
    pt_entries[i].ref = (*pte & PTE_A) > 0;
8010902e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109031:	8b 00                	mov    (%eax),%eax
80109033:	83 e0 20             	and    $0x20,%eax
80109036:	89 c2                	mov    %eax,%edx
80109038:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010903b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80109042:	8b 45 08             	mov    0x8(%ebp),%eax
80109045:	01 c8                	add    %ecx,%eax
80109047:	85 d2                	test   %edx,%edx
80109049:	0f 95 c2             	setne  %dl
8010904c:	89 d1                	mov    %edx,%ecx
8010904e:	83 e1 01             	and    $0x1,%ecx
80109051:	0f b6 50 07          	movzbl 0x7(%eax),%edx
80109055:	83 e2 fe             	and    $0xfffffffe,%edx
80109058:	09 ca                	or     %ecx,%edx
8010905a:	88 50 07             	mov    %dl,0x7(%eax)
    //PT_A flag needs to be modified as per clock algo.
    i ++;
8010905d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if (uva == 0 || i == num) break;
80109061:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109065:	74 17                	je     8010907e <getpgtable+0x21b>
80109067:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010906a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010906d:	74 0f                	je     8010907e <getpgtable+0x21b>
8010906f:	eb 01                	jmp    80109072 <getpgtable+0x20f>
      continue;
80109071:	90                   	nop
  for (;;uva -=PGSIZE)
80109072:	81 6d f4 00 10 00 00 	subl   $0x1000,-0xc(%ebp)
  {
80109079:	e9 4e fe ff ff       	jmp    80108ecc <getpgtable+0x69>

  }

  return i;
8010907e:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
80109081:	c9                   	leave  
80109082:	c3                   	ret    

80109083 <dump_rawphymem>:


int dump_rawphymem(char *physical_addr, char * buffer) {
80109083:	f3 0f 1e fb          	endbr32 
80109087:	55                   	push   %ebp
80109088:	89 e5                	mov    %esp,%ebp
8010908a:	56                   	push   %esi
8010908b:	53                   	push   %ebx
8010908c:	83 ec 10             	sub    $0x10,%esp
  *buffer = *buffer;
8010908f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109092:	0f b6 10             	movzbl (%eax),%edx
80109095:	8b 45 0c             	mov    0xc(%ebp),%eax
80109098:	88 10                	mov    %dl,(%eax)
  cprintf("p4Debug: dump_rawphymem: %p, %p\n", physical_addr, buffer);
8010909a:	83 ec 04             	sub    $0x4,%esp
8010909d:	ff 75 0c             	pushl  0xc(%ebp)
801090a0:	ff 75 08             	pushl  0x8(%ebp)
801090a3:	68 8c 9b 10 80       	push   $0x80109b8c
801090a8:	e8 6b 73 ff ff       	call   80100418 <cprintf>
801090ad:	83 c4 10             	add    $0x10,%esp
  int retval = copyout(myproc()->pgdir, (uint) buffer, (void *) PGROUNDDOWN((int)P2V(physical_addr)), PGSIZE);
801090b0:	8b 45 08             	mov    0x8(%ebp),%eax
801090b3:	05 00 00 00 80       	add    $0x80000000,%eax
801090b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090bd:	89 c6                	mov    %eax,%esi
801090bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801090c2:	e8 f9 b3 ff ff       	call   801044c0 <myproc>
801090c7:	8b 40 04             	mov    0x4(%eax),%eax
801090ca:	68 00 10 00 00       	push   $0x1000
801090cf:	56                   	push   %esi
801090d0:	53                   	push   %ebx
801090d1:	50                   	push   %eax
801090d2:	e8 bb f8 ff ff       	call   80108992 <copyout>
801090d7:	83 c4 10             	add    $0x10,%esp
801090da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (retval)
801090dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801090e1:	74 07                	je     801090ea <dump_rawphymem+0x67>
    return -1;
801090e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801090e8:	eb 05                	jmp    801090ef <dump_rawphymem+0x6c>
  return 0;
801090ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
801090ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801090f2:	5b                   	pop    %ebx
801090f3:	5e                   	pop    %esi
801090f4:	5d                   	pop    %ebp
801090f5:	c3                   	ret    
