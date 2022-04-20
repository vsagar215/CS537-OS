
_mkdir:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  13:	83 ec 10             	sub    $0x10,%esp
  16:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  18:	83 3b 01             	cmpl   $0x1,(%ebx)
  1b:	7f 17                	jg     34 <main+0x34>
    printf(2, "Usage: mkdir files...\n");
  1d:	83 ec 08             	sub    $0x8,%esp
  20:	68 6a 08 00 00       	push   $0x86a
  25:	6a 02                	push   $0x2
  27:	e8 77 04 00 00       	call   4a3 <printf>
  2c:	83 c4 10             	add    $0x10,%esp
    exit();
  2f:	e8 db 02 00 00       	call   30f <exit>
  }

  for(i = 1; i < argc; i++){
  34:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  3b:	eb 4b                	jmp    88 <main+0x88>
    if(mkdir(argv[i]) < 0){
  3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  47:	8b 43 04             	mov    0x4(%ebx),%eax
  4a:	01 d0                	add    %edx,%eax
  4c:	8b 00                	mov    (%eax),%eax
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	50                   	push   %eax
  52:	e8 20 03 00 00       	call   377 <mkdir>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	85 c0                	test   %eax,%eax
  5c:	79 26                	jns    84 <main+0x84>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  68:	8b 43 04             	mov    0x4(%ebx),%eax
  6b:	01 d0                	add    %edx,%eax
  6d:	8b 00                	mov    (%eax),%eax
  6f:	83 ec 04             	sub    $0x4,%esp
  72:	50                   	push   %eax
  73:	68 81 08 00 00       	push   $0x881
  78:	6a 02                	push   $0x2
  7a:	e8 24 04 00 00       	call   4a3 <printf>
  7f:	83 c4 10             	add    $0x10,%esp
      break;
  82:	eb 0b                	jmp    8f <main+0x8f>
  for(i = 1; i < argc; i++){
  84:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8b:	3b 03                	cmp    (%ebx),%eax
  8d:	7c ae                	jl     3d <main+0x3d>
    }
  }

  exit();
  8f:	e8 7b 02 00 00       	call   30f <exit>

00000094 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	57                   	push   %edi
  98:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9c:	8b 55 10             	mov    0x10(%ebp),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	89 cb                	mov    %ecx,%ebx
  a4:	89 df                	mov    %ebx,%edi
  a6:	89 d1                	mov    %edx,%ecx
  a8:	fc                   	cld    
  a9:	f3 aa                	rep stos %al,%es:(%edi)
  ab:	89 ca                	mov    %ecx,%edx
  ad:	89 fb                	mov    %edi,%ebx
  af:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b5:	90                   	nop
  b6:	5b                   	pop    %ebx
  b7:	5f                   	pop    %edi
  b8:	5d                   	pop    %ebp
  b9:	c3                   	ret    

000000ba <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  ba:	f3 0f 1e fb          	endbr32 
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ca:	90                   	nop
  cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ce:	8d 42 01             	lea    0x1(%edx),%eax
  d1:	89 45 0c             	mov    %eax,0xc(%ebp)
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	8d 48 01             	lea    0x1(%eax),%ecx
  da:	89 4d 08             	mov    %ecx,0x8(%ebp)
  dd:	0f b6 12             	movzbl (%edx),%edx
  e0:	88 10                	mov    %dl,(%eax)
  e2:	0f b6 00             	movzbl (%eax),%eax
  e5:	84 c0                	test   %al,%al
  e7:	75 e2                	jne    cb <strcpy+0x11>
    ;
  return os;
  e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	f3 0f 1e fb          	endbr32 
  f2:	55                   	push   %ebp
  f3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  f5:	eb 08                	jmp    ff <strcmp+0x11>
    p++, q++;
  f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  fb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	0f b6 00             	movzbl (%eax),%eax
 105:	84 c0                	test   %al,%al
 107:	74 10                	je     119 <strcmp+0x2b>
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	0f b6 10             	movzbl (%eax),%edx
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	38 c2                	cmp    %al,%dl
 117:	74 de                	je     f7 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 119:	8b 45 08             	mov    0x8(%ebp),%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	0f b6 d0             	movzbl %al,%edx
 122:	8b 45 0c             	mov    0xc(%ebp),%eax
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	0f b6 c0             	movzbl %al,%eax
 12b:	29 c2                	sub    %eax,%edx
 12d:	89 d0                	mov    %edx,%eax
}
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    

00000131 <strlen>:

uint
strlen(const char *s)
{
 131:	f3 0f 1e fb          	endbr32 
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 13b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 142:	eb 04                	jmp    148 <strlen+0x17>
 144:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 148:	8b 55 fc             	mov    -0x4(%ebp),%edx
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	01 d0                	add    %edx,%eax
 150:	0f b6 00             	movzbl (%eax),%eax
 153:	84 c0                	test   %al,%al
 155:	75 ed                	jne    144 <strlen+0x13>
    ;
  return n;
 157:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15a:	c9                   	leave  
 15b:	c3                   	ret    

0000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	f3 0f 1e fb          	endbr32 
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 163:	8b 45 10             	mov    0x10(%ebp),%eax
 166:	50                   	push   %eax
 167:	ff 75 0c             	pushl  0xc(%ebp)
 16a:	ff 75 08             	pushl  0x8(%ebp)
 16d:	e8 22 ff ff ff       	call   94 <stosb>
 172:	83 c4 0c             	add    $0xc,%esp
  return dst;
 175:	8b 45 08             	mov    0x8(%ebp),%eax
}
 178:	c9                   	leave  
 179:	c3                   	ret    

0000017a <strchr>:

char*
strchr(const char *s, char c)
{
 17a:	f3 0f 1e fb          	endbr32 
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	83 ec 04             	sub    $0x4,%esp
 184:	8b 45 0c             	mov    0xc(%ebp),%eax
 187:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 18a:	eb 14                	jmp    1a0 <strchr+0x26>
    if(*s == c)
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	38 45 fc             	cmp    %al,-0x4(%ebp)
 195:	75 05                	jne    19c <strchr+0x22>
      return (char*)s;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	eb 13                	jmp    1af <strchr+0x35>
  for(; *s; s++)
 19c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	84 c0                	test   %al,%al
 1a8:	75 e2                	jne    18c <strchr+0x12>
  return 0;
 1aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1af:	c9                   	leave  
 1b0:	c3                   	ret    

000001b1 <gets>:

char*
gets(char *buf, int max)
{
 1b1:	f3 0f 1e fb          	endbr32 
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c2:	eb 42                	jmp    206 <gets+0x55>
    cc = read(0, &c, 1);
 1c4:	83 ec 04             	sub    $0x4,%esp
 1c7:	6a 01                	push   $0x1
 1c9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1cc:	50                   	push   %eax
 1cd:	6a 00                	push   $0x0
 1cf:	e8 53 01 00 00       	call   327 <read>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1de:	7e 33                	jle    213 <gets+0x62>
      break;
    buf[i++] = c;
 1e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e3:	8d 50 01             	lea    0x1(%eax),%edx
 1e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e9:	89 c2                	mov    %eax,%edx
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	01 c2                	add    %eax,%edx
 1f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1f6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fa:	3c 0a                	cmp    $0xa,%al
 1fc:	74 16                	je     214 <gets+0x63>
 1fe:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 202:	3c 0d                	cmp    $0xd,%al
 204:	74 0e                	je     214 <gets+0x63>
  for(i=0; i+1 < max; ){
 206:	8b 45 f4             	mov    -0xc(%ebp),%eax
 209:	83 c0 01             	add    $0x1,%eax
 20c:	39 45 0c             	cmp    %eax,0xc(%ebp)
 20f:	7f b3                	jg     1c4 <gets+0x13>
 211:	eb 01                	jmp    214 <gets+0x63>
      break;
 213:	90                   	nop
      break;
  }
  buf[i] = '\0';
 214:	8b 55 f4             	mov    -0xc(%ebp),%edx
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	01 d0                	add    %edx,%eax
 21c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 222:	c9                   	leave  
 223:	c3                   	ret    

00000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	f3 0f 1e fb          	endbr32 
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	6a 00                	push   $0x0
 233:	ff 75 08             	pushl  0x8(%ebp)
 236:	e8 14 01 00 00       	call   34f <open>
 23b:	83 c4 10             	add    $0x10,%esp
 23e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 245:	79 07                	jns    24e <stat+0x2a>
    return -1;
 247:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 24c:	eb 25                	jmp    273 <stat+0x4f>
  r = fstat(fd, st);
 24e:	83 ec 08             	sub    $0x8,%esp
 251:	ff 75 0c             	pushl  0xc(%ebp)
 254:	ff 75 f4             	pushl  -0xc(%ebp)
 257:	e8 0b 01 00 00       	call   367 <fstat>
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 262:	83 ec 0c             	sub    $0xc,%esp
 265:	ff 75 f4             	pushl  -0xc(%ebp)
 268:	e8 ca 00 00 00       	call   337 <close>
 26d:	83 c4 10             	add    $0x10,%esp
  return r;
 270:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <atoi>:

int
atoi(const char *s)
{
 275:	f3 0f 1e fb          	endbr32 
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 27f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 286:	eb 25                	jmp    2ad <atoi+0x38>
    n = n*10 + *s++ - '0';
 288:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28b:	89 d0                	mov    %edx,%eax
 28d:	c1 e0 02             	shl    $0x2,%eax
 290:	01 d0                	add    %edx,%eax
 292:	01 c0                	add    %eax,%eax
 294:	89 c1                	mov    %eax,%ecx
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	8d 50 01             	lea    0x1(%eax),%edx
 29c:	89 55 08             	mov    %edx,0x8(%ebp)
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	0f be c0             	movsbl %al,%eax
 2a5:	01 c8                	add    %ecx,%eax
 2a7:	83 e8 30             	sub    $0x30,%eax
 2aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2f                	cmp    $0x2f,%al
 2b5:	7e 0a                	jle    2c1 <atoi+0x4c>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 00             	movzbl (%eax),%eax
 2bd:	3c 39                	cmp    $0x39,%al
 2bf:	7e c7                	jle    288 <atoi+0x13>
  return n;
 2c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c6:	f3 0f 1e fb          	endbr32 
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2dc:	eb 17                	jmp    2f5 <memmove+0x2f>
    *dst++ = *src++;
 2de:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2e1:	8d 42 01             	lea    0x1(%edx),%eax
 2e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ea:	8d 48 01             	lea    0x1(%eax),%ecx
 2ed:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2f0:	0f b6 12             	movzbl (%edx),%edx
 2f3:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2f5:	8b 45 10             	mov    0x10(%ebp),%eax
 2f8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2fb:	89 55 10             	mov    %edx,0x10(%ebp)
 2fe:	85 c0                	test   %eax,%eax
 300:	7f dc                	jg     2de <memmove+0x18>
  return vdst;
 302:	8b 45 08             	mov    0x8(%ebp),%eax
}
 305:	c9                   	leave  
 306:	c3                   	ret    

00000307 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 307:	b8 01 00 00 00       	mov    $0x1,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <exit>:
SYSCALL(exit)
 30f:	b8 02 00 00 00       	mov    $0x2,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <wait>:
SYSCALL(wait)
 317:	b8 03 00 00 00       	mov    $0x3,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <pipe>:
SYSCALL(pipe)
 31f:	b8 04 00 00 00       	mov    $0x4,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <read>:
SYSCALL(read)
 327:	b8 05 00 00 00       	mov    $0x5,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <write>:
SYSCALL(write)
 32f:	b8 10 00 00 00       	mov    $0x10,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <close>:
SYSCALL(close)
 337:	b8 15 00 00 00       	mov    $0x15,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <kill>:
SYSCALL(kill)
 33f:	b8 06 00 00 00       	mov    $0x6,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <exec>:
SYSCALL(exec)
 347:	b8 07 00 00 00       	mov    $0x7,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <open>:
SYSCALL(open)
 34f:	b8 0f 00 00 00       	mov    $0xf,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <mknod>:
SYSCALL(mknod)
 357:	b8 11 00 00 00       	mov    $0x11,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <unlink>:
SYSCALL(unlink)
 35f:	b8 12 00 00 00       	mov    $0x12,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <fstat>:
SYSCALL(fstat)
 367:	b8 08 00 00 00       	mov    $0x8,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <link>:
SYSCALL(link)
 36f:	b8 13 00 00 00       	mov    $0x13,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <mkdir>:
SYSCALL(mkdir)
 377:	b8 14 00 00 00       	mov    $0x14,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <chdir>:
SYSCALL(chdir)
 37f:	b8 09 00 00 00       	mov    $0x9,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <dup>:
SYSCALL(dup)
 387:	b8 0a 00 00 00       	mov    $0xa,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <getpid>:
SYSCALL(getpid)
 38f:	b8 0b 00 00 00       	mov    $0xb,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <sbrk>:
SYSCALL(sbrk)
 397:	b8 0c 00 00 00       	mov    $0xc,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <sleep>:
SYSCALL(sleep)
 39f:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <uptime>:
SYSCALL(uptime)
 3a7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <mencrypt>:
SYSCALL(mencrypt)
 3af:	b8 16 00 00 00       	mov    $0x16,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <getpgtable>:
SYSCALL(getpgtable)
 3b7:	b8 17 00 00 00       	mov    $0x17,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 3bf:	b8 18 00 00 00       	mov    $0x18,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c7:	f3 0f 1e fb          	endbr32 
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 18             	sub    $0x18,%esp
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3d7:	83 ec 04             	sub    $0x4,%esp
 3da:	6a 01                	push   $0x1
 3dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3df:	50                   	push   %eax
 3e0:	ff 75 08             	pushl  0x8(%ebp)
 3e3:	e8 47 ff ff ff       	call   32f <write>
 3e8:	83 c4 10             	add    $0x10,%esp
}
 3eb:	90                   	nop
 3ec:	c9                   	leave  
 3ed:	c3                   	ret    

000003ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ee:	f3 0f 1e fb          	endbr32 
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 403:	74 17                	je     41c <printint+0x2e>
 405:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 409:	79 11                	jns    41c <printint+0x2e>
    neg = 1;
 40b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	f7 d8                	neg    %eax
 417:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41a:	eb 06                	jmp    422 <printint+0x34>
  } else {
    x = xx;
 41c:	8b 45 0c             	mov    0xc(%ebp),%eax
 41f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 429:	8b 4d 10             	mov    0x10(%ebp),%ecx
 42c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42f:	ba 00 00 00 00       	mov    $0x0,%edx
 434:	f7 f1                	div    %ecx
 436:	89 d1                	mov    %edx,%ecx
 438:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43b:	8d 50 01             	lea    0x1(%eax),%edx
 43e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 441:	0f b6 91 ec 0a 00 00 	movzbl 0xaec(%ecx),%edx
 448:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 44c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 44f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 452:	ba 00 00 00 00       	mov    $0x0,%edx
 457:	f7 f1                	div    %ecx
 459:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 460:	75 c7                	jne    429 <printint+0x3b>
  if(neg)
 462:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 466:	74 2d                	je     495 <printint+0xa7>
    buf[i++] = '-';
 468:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46b:	8d 50 01             	lea    0x1(%eax),%edx
 46e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 471:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 476:	eb 1d                	jmp    495 <printint+0xa7>
    putc(fd, buf[i]);
 478:	8d 55 dc             	lea    -0x24(%ebp),%edx
 47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47e:	01 d0                	add    %edx,%eax
 480:	0f b6 00             	movzbl (%eax),%eax
 483:	0f be c0             	movsbl %al,%eax
 486:	83 ec 08             	sub    $0x8,%esp
 489:	50                   	push   %eax
 48a:	ff 75 08             	pushl  0x8(%ebp)
 48d:	e8 35 ff ff ff       	call   3c7 <putc>
 492:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 495:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49d:	79 d9                	jns    478 <printint+0x8a>
}
 49f:	90                   	nop
 4a0:	90                   	nop
 4a1:	c9                   	leave  
 4a2:	c3                   	ret    

000004a3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4a3:	f3 0f 1e fb          	endbr32 
 4a7:	55                   	push   %ebp
 4a8:	89 e5                	mov    %esp,%ebp
 4aa:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b4:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b7:	83 c0 04             	add    $0x4,%eax
 4ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c4:	e9 59 01 00 00       	jmp    622 <printf+0x17f>
    c = fmt[i] & 0xff;
 4c9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4cf:	01 d0                	add    %edx,%eax
 4d1:	0f b6 00             	movzbl (%eax),%eax
 4d4:	0f be c0             	movsbl %al,%eax
 4d7:	25 ff 00 00 00       	and    $0xff,%eax
 4dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e3:	75 2c                	jne    511 <printf+0x6e>
      if(c == '%'){
 4e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e9:	75 0c                	jne    4f7 <printf+0x54>
        state = '%';
 4eb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4f2:	e9 27 01 00 00       	jmp    61e <printf+0x17b>
      } else {
        putc(fd, c);
 4f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4fa:	0f be c0             	movsbl %al,%eax
 4fd:	83 ec 08             	sub    $0x8,%esp
 500:	50                   	push   %eax
 501:	ff 75 08             	pushl  0x8(%ebp)
 504:	e8 be fe ff ff       	call   3c7 <putc>
 509:	83 c4 10             	add    $0x10,%esp
 50c:	e9 0d 01 00 00       	jmp    61e <printf+0x17b>
      }
    } else if(state == '%'){
 511:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 515:	0f 85 03 01 00 00    	jne    61e <printf+0x17b>
      if(c == 'd'){
 51b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51f:	75 1e                	jne    53f <printf+0x9c>
        printint(fd, *ap, 10, 1);
 521:	8b 45 e8             	mov    -0x18(%ebp),%eax
 524:	8b 00                	mov    (%eax),%eax
 526:	6a 01                	push   $0x1
 528:	6a 0a                	push   $0xa
 52a:	50                   	push   %eax
 52b:	ff 75 08             	pushl  0x8(%ebp)
 52e:	e8 bb fe ff ff       	call   3ee <printint>
 533:	83 c4 10             	add    $0x10,%esp
        ap++;
 536:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53a:	e9 d8 00 00 00       	jmp    617 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 53f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 543:	74 06                	je     54b <printf+0xa8>
 545:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 549:	75 1e                	jne    569 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 54b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54e:	8b 00                	mov    (%eax),%eax
 550:	6a 00                	push   $0x0
 552:	6a 10                	push   $0x10
 554:	50                   	push   %eax
 555:	ff 75 08             	pushl  0x8(%ebp)
 558:	e8 91 fe ff ff       	call   3ee <printint>
 55d:	83 c4 10             	add    $0x10,%esp
        ap++;
 560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 564:	e9 ae 00 00 00       	jmp    617 <printf+0x174>
      } else if(c == 's'){
 569:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 56d:	75 43                	jne    5b2 <printf+0x10f>
        s = (char*)*ap;
 56f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 572:	8b 00                	mov    (%eax),%eax
 574:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 577:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 57b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57f:	75 25                	jne    5a6 <printf+0x103>
          s = "(null)";
 581:	c7 45 f4 9d 08 00 00 	movl   $0x89d,-0xc(%ebp)
        while(*s != 0){
 588:	eb 1c                	jmp    5a6 <printf+0x103>
          putc(fd, *s);
 58a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58d:	0f b6 00             	movzbl (%eax),%eax
 590:	0f be c0             	movsbl %al,%eax
 593:	83 ec 08             	sub    $0x8,%esp
 596:	50                   	push   %eax
 597:	ff 75 08             	pushl  0x8(%ebp)
 59a:	e8 28 fe ff ff       	call   3c7 <putc>
 59f:	83 c4 10             	add    $0x10,%esp
          s++;
 5a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a9:	0f b6 00             	movzbl (%eax),%eax
 5ac:	84 c0                	test   %al,%al
 5ae:	75 da                	jne    58a <printf+0xe7>
 5b0:	eb 65                	jmp    617 <printf+0x174>
        }
      } else if(c == 'c'){
 5b2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b6:	75 1d                	jne    5d5 <printf+0x132>
        putc(fd, *ap);
 5b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bb:	8b 00                	mov    (%eax),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	50                   	push   %eax
 5c4:	ff 75 08             	pushl  0x8(%ebp)
 5c7:	e8 fb fd ff ff       	call   3c7 <putc>
 5cc:	83 c4 10             	add    $0x10,%esp
        ap++;
 5cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d3:	eb 42                	jmp    617 <printf+0x174>
      } else if(c == '%'){
 5d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d9:	75 17                	jne    5f2 <printf+0x14f>
        putc(fd, c);
 5db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5de:	0f be c0             	movsbl %al,%eax
 5e1:	83 ec 08             	sub    $0x8,%esp
 5e4:	50                   	push   %eax
 5e5:	ff 75 08             	pushl  0x8(%ebp)
 5e8:	e8 da fd ff ff       	call   3c7 <putc>
 5ed:	83 c4 10             	add    $0x10,%esp
 5f0:	eb 25                	jmp    617 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f2:	83 ec 08             	sub    $0x8,%esp
 5f5:	6a 25                	push   $0x25
 5f7:	ff 75 08             	pushl  0x8(%ebp)
 5fa:	e8 c8 fd ff ff       	call   3c7 <putc>
 5ff:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 605:	0f be c0             	movsbl %al,%eax
 608:	83 ec 08             	sub    $0x8,%esp
 60b:	50                   	push   %eax
 60c:	ff 75 08             	pushl  0x8(%ebp)
 60f:	e8 b3 fd ff ff       	call   3c7 <putc>
 614:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 617:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 61e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 622:	8b 55 0c             	mov    0xc(%ebp),%edx
 625:	8b 45 f0             	mov    -0x10(%ebp),%eax
 628:	01 d0                	add    %edx,%eax
 62a:	0f b6 00             	movzbl (%eax),%eax
 62d:	84 c0                	test   %al,%al
 62f:	0f 85 94 fe ff ff    	jne    4c9 <printf+0x26>
    }
  }
}
 635:	90                   	nop
 636:	90                   	nop
 637:	c9                   	leave  
 638:	c3                   	ret    

00000639 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 639:	f3 0f 1e fb          	endbr32 
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	83 e8 08             	sub    $0x8,%eax
 649:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64c:	a1 08 0b 00 00       	mov    0xb08,%eax
 651:	89 45 fc             	mov    %eax,-0x4(%ebp)
 654:	eb 24                	jmp    67a <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 65e:	72 12                	jb     672 <free+0x39>
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 666:	77 24                	ja     68c <free+0x53>
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 670:	72 1a                	jb     68c <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 680:	76 d4                	jbe    656 <free+0x1d>
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 68a:	73 ca                	jae    656 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	8b 40 04             	mov    0x4(%eax),%eax
 692:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	01 c2                	add    %eax,%edx
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	39 c2                	cmp    %eax,%edx
 6a5:	75 24                	jne    6cb <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	8b 50 04             	mov    0x4(%eax),%edx
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	8b 40 04             	mov    0x4(%eax),%eax
 6b5:	01 c2                	add    %eax,%edx
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	8b 10                	mov    (%eax),%edx
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	89 10                	mov    %edx,(%eax)
 6c9:	eb 0a                	jmp    6d5 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 10                	mov    (%eax),%edx
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 40 04             	mov    0x4(%eax),%eax
 6db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	01 d0                	add    %edx,%eax
 6e7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6ea:	75 20                	jne    70c <free+0xd3>
    p->s.size += bp->s.size;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 50 04             	mov    0x4(%eax),%edx
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 40 04             	mov    0x4(%eax),%eax
 6f8:	01 c2                	add    %eax,%edx
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	8b 10                	mov    (%eax),%edx
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	89 10                	mov    %edx,(%eax)
 70a:	eb 08                	jmp    714 <free+0xdb>
  } else
    p->s.ptr = bp;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 712:	89 10                	mov    %edx,(%eax)
  freep = p;
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	a3 08 0b 00 00       	mov    %eax,0xb08
}
 71c:	90                   	nop
 71d:	c9                   	leave  
 71e:	c3                   	ret    

0000071f <morecore>:

static Header*
morecore(uint nu)
{
 71f:	f3 0f 1e fb          	endbr32 
 723:	55                   	push   %ebp
 724:	89 e5                	mov    %esp,%ebp
 726:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 729:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 730:	77 07                	ja     739 <morecore+0x1a>
    nu = 4096;
 732:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	c1 e0 03             	shl    $0x3,%eax
 73f:	83 ec 0c             	sub    $0xc,%esp
 742:	50                   	push   %eax
 743:	e8 4f fc ff ff       	call   397 <sbrk>
 748:	83 c4 10             	add    $0x10,%esp
 74b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 74e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 752:	75 07                	jne    75b <morecore+0x3c>
    return 0;
 754:	b8 00 00 00 00       	mov    $0x0,%eax
 759:	eb 26                	jmp    781 <morecore+0x62>
  hp = (Header*)p;
 75b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 761:	8b 45 f0             	mov    -0x10(%ebp),%eax
 764:	8b 55 08             	mov    0x8(%ebp),%edx
 767:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 76a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76d:	83 c0 08             	add    $0x8,%eax
 770:	83 ec 0c             	sub    $0xc,%esp
 773:	50                   	push   %eax
 774:	e8 c0 fe ff ff       	call   639 <free>
 779:	83 c4 10             	add    $0x10,%esp
  return freep;
 77c:	a1 08 0b 00 00       	mov    0xb08,%eax
}
 781:	c9                   	leave  
 782:	c3                   	ret    

00000783 <malloc>:

void*
malloc(uint nbytes)
{
 783:	f3 0f 1e fb          	endbr32 
 787:	55                   	push   %ebp
 788:	89 e5                	mov    %esp,%ebp
 78a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	83 c0 07             	add    $0x7,%eax
 793:	c1 e8 03             	shr    $0x3,%eax
 796:	83 c0 01             	add    $0x1,%eax
 799:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 79c:	a1 08 0b 00 00       	mov    0xb08,%eax
 7a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a8:	75 23                	jne    7cd <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 7aa:	c7 45 f0 00 0b 00 00 	movl   $0xb00,-0x10(%ebp)
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	a3 08 0b 00 00       	mov    %eax,0xb08
 7b9:	a1 08 0b 00 00       	mov    0xb08,%eax
 7be:	a3 00 0b 00 00       	mov    %eax,0xb00
    base.s.size = 0;
 7c3:	c7 05 04 0b 00 00 00 	movl   $0x0,0xb04
 7ca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d0:	8b 00                	mov    (%eax),%eax
 7d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7de:	77 4d                	ja     82d <malloc+0xaa>
      if(p->s.size == nunits)
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7e9:	75 0c                	jne    7f7 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	8b 10                	mov    (%eax),%edx
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	89 10                	mov    %edx,(%eax)
 7f5:	eb 26                	jmp    81d <malloc+0x9a>
      else {
        p->s.size -= nunits;
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 40 04             	mov    0x4(%eax),%eax
 7fd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 800:	89 c2                	mov    %eax,%edx
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	8b 40 04             	mov    0x4(%eax),%eax
 80e:	c1 e0 03             	shl    $0x3,%eax
 811:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	8b 55 ec             	mov    -0x14(%ebp),%edx
 81a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 81d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 820:	a3 08 0b 00 00       	mov    %eax,0xb08
      return (void*)(p + 1);
 825:	8b 45 f4             	mov    -0xc(%ebp),%eax
 828:	83 c0 08             	add    $0x8,%eax
 82b:	eb 3b                	jmp    868 <malloc+0xe5>
    }
    if(p == freep)
 82d:	a1 08 0b 00 00       	mov    0xb08,%eax
 832:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 835:	75 1e                	jne    855 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 837:	83 ec 0c             	sub    $0xc,%esp
 83a:	ff 75 ec             	pushl  -0x14(%ebp)
 83d:	e8 dd fe ff ff       	call   71f <morecore>
 842:	83 c4 10             	add    $0x10,%esp
 845:	89 45 f4             	mov    %eax,-0xc(%ebp)
 848:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 84c:	75 07                	jne    855 <malloc+0xd2>
        return 0;
 84e:	b8 00 00 00 00       	mov    $0x0,%eax
 853:	eb 13                	jmp    868 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	8b 00                	mov    (%eax),%eax
 860:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 863:	e9 6d ff ff ff       	jmp    7d5 <malloc+0x52>
  }
}
 868:	c9                   	leave  
 869:	c3                   	ret    
