
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, const char *s, ...)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 08             	sub    $0x8,%esp
  write(fd, s, strlen(s));
   a:	83 ec 0c             	sub    $0xc,%esp
   d:	ff 75 0c             	pushl  0xc(%ebp)
  10:	e8 9c 01 00 00       	call   1b1 <strlen>
  15:	83 c4 10             	add    $0x10,%esp
  18:	83 ec 04             	sub    $0x4,%esp
  1b:	50                   	push   %eax
  1c:	ff 75 0c             	pushl  0xc(%ebp)
  1f:	ff 75 08             	pushl  0x8(%ebp)
  22:	e8 88 03 00 00       	call   3af <write>
  27:	83 c4 10             	add    $0x10,%esp
}
  2a:	90                   	nop
  2b:	c9                   	leave  
  2c:	c3                   	ret    

0000002d <forktest>:

void
forktest(void)
{
  2d:	f3 0f 1e fb          	endbr32 
  31:	55                   	push   %ebp
  32:	89 e5                	mov    %esp,%ebp
  34:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
  37:	83 ec 08             	sub    $0x8,%esp
  3a:	68 48 04 00 00       	push   $0x448
  3f:	6a 01                	push   $0x1
  41:	e8 ba ff ff ff       	call   0 <printf>
  46:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  50:	eb 1d                	jmp    6f <forktest+0x42>
    pid = fork();
  52:	e8 30 03 00 00       	call   387 <fork>
  57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  5e:	78 1a                	js     7a <forktest+0x4d>
      break;
    if(pid == 0)
  60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  64:	75 05                	jne    6b <forktest+0x3e>
      exit();
  66:	e8 24 03 00 00       	call   38f <exit>
  for(n=0; n<N; n++){
  6b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  6f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  76:	7e da                	jle    52 <forktest+0x25>
  78:	eb 01                	jmp    7b <forktest+0x4e>
      break;
  7a:	90                   	nop
  }

  if(n == N){
  7b:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  82:	75 40                	jne    c4 <forktest+0x97>
    printf(1, "fork claimed to work N times!\n", N);
  84:	83 ec 04             	sub    $0x4,%esp
  87:	68 e8 03 00 00       	push   $0x3e8
  8c:	68 54 04 00 00       	push   $0x454
  91:	6a 01                	push   $0x1
  93:	e8 68 ff ff ff       	call   0 <printf>
  98:	83 c4 10             	add    $0x10,%esp
    exit();
  9b:	e8 ef 02 00 00       	call   38f <exit>
  }

  for(; n > 0; n--){
    if(wait() < 0){
  a0:	e8 f2 02 00 00       	call   397 <wait>
  a5:	85 c0                	test   %eax,%eax
  a7:	79 17                	jns    c0 <forktest+0x93>
      printf(1, "wait stopped early\n");
  a9:	83 ec 08             	sub    $0x8,%esp
  ac:	68 73 04 00 00       	push   $0x473
  b1:	6a 01                	push   $0x1
  b3:	e8 48 ff ff ff       	call   0 <printf>
  b8:	83 c4 10             	add    $0x10,%esp
      exit();
  bb:	e8 cf 02 00 00       	call   38f <exit>
  for(; n > 0; n--){
  c0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  c8:	7f d6                	jg     a0 <forktest+0x73>
    }
  }

  if(wait() != -1){
  ca:	e8 c8 02 00 00       	call   397 <wait>
  cf:	83 f8 ff             	cmp    $0xffffffff,%eax
  d2:	74 17                	je     eb <forktest+0xbe>
    printf(1, "wait got too many\n");
  d4:	83 ec 08             	sub    $0x8,%esp
  d7:	68 87 04 00 00       	push   $0x487
  dc:	6a 01                	push   $0x1
  de:	e8 1d ff ff ff       	call   0 <printf>
  e3:	83 c4 10             	add    $0x10,%esp
    exit();
  e6:	e8 a4 02 00 00       	call   38f <exit>
  }

  printf(1, "fork test OK\n");
  eb:	83 ec 08             	sub    $0x8,%esp
  ee:	68 9a 04 00 00       	push   $0x49a
  f3:	6a 01                	push   $0x1
  f5:	e8 06 ff ff ff       	call   0 <printf>
  fa:	83 c4 10             	add    $0x10,%esp
}
  fd:	90                   	nop
  fe:	c9                   	leave  
  ff:	c3                   	ret    

00000100 <main>:

int
main(void)
{
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
 10a:	e8 1e ff ff ff       	call   2d <forktest>
  exit();
 10f:	e8 7b 02 00 00       	call   38f <exit>

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	90                   	nop
 136:	5b                   	pop    %ebx
 137:	5f                   	pop    %edi
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 13a:	f3 0f 1e fb          	endbr32 
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14a:	90                   	nop
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 42 01             	lea    0x1(%edx),%eax
 151:	89 45 0c             	mov    %eax,0xc(%ebp)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	8d 48 01             	lea    0x1(%eax),%ecx
 15a:	89 4d 08             	mov    %ecx,0x8(%ebp)
 15d:	0f b6 12             	movzbl (%edx),%edx
 160:	88 10                	mov    %dl,(%eax)
 162:	0f b6 00             	movzbl (%eax),%eax
 165:	84 c0                	test   %al,%al
 167:	75 e2                	jne    14b <strcpy+0x11>
    ;
  return os;
 169:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16e:	f3 0f 1e fb          	endbr32 
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 175:	eb 08                	jmp    17f <strcmp+0x11>
    p++, q++;
 177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	84 c0                	test   %al,%al
 187:	74 10                	je     199 <strcmp+0x2b>
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 10             	movzbl (%eax),%edx
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	38 c2                	cmp    %al,%dl
 197:	74 de                	je     177 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	0f b6 d0             	movzbl %al,%edx
 1a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a5:	0f b6 00             	movzbl (%eax),%eax
 1a8:	0f b6 c0             	movzbl %al,%eax
 1ab:	29 c2                	sub    %eax,%edx
 1ad:	89 d0                	mov    %edx,%eax
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strlen>:

uint
strlen(const char *s)
{
 1b1:	f3 0f 1e fb          	endbr32 
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c2:	eb 04                	jmp    1c8 <strlen+0x17>
 1c4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	01 d0                	add    %edx,%eax
 1d0:	0f b6 00             	movzbl (%eax),%eax
 1d3:	84 c0                	test   %al,%al
 1d5:	75 ed                	jne    1c4 <strlen+0x13>
    ;
  return n;
 1d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1da:	c9                   	leave  
 1db:	c3                   	ret    

000001dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1dc:	f3 0f 1e fb          	endbr32 
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1e3:	8b 45 10             	mov    0x10(%ebp),%eax
 1e6:	50                   	push   %eax
 1e7:	ff 75 0c             	pushl  0xc(%ebp)
 1ea:	ff 75 08             	pushl  0x8(%ebp)
 1ed:	e8 22 ff ff ff       	call   114 <stosb>
 1f2:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f8:	c9                   	leave  
 1f9:	c3                   	ret    

000001fa <strchr>:

char*
strchr(const char *s, char c)
{
 1fa:	f3 0f 1e fb          	endbr32 
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	83 ec 04             	sub    $0x4,%esp
 204:	8b 45 0c             	mov    0xc(%ebp),%eax
 207:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20a:	eb 14                	jmp    220 <strchr+0x26>
    if(*s == c)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	0f b6 00             	movzbl (%eax),%eax
 212:	38 45 fc             	cmp    %al,-0x4(%ebp)
 215:	75 05                	jne    21c <strchr+0x22>
      return (char*)s;
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	eb 13                	jmp    22f <strchr+0x35>
  for(; *s; s++)
 21c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	75 e2                	jne    20c <strchr+0x12>
  return 0;
 22a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22f:	c9                   	leave  
 230:	c3                   	ret    

00000231 <gets>:

char*
gets(char *buf, int max)
{
 231:	f3 0f 1e fb          	endbr32 
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 242:	eb 42                	jmp    286 <gets+0x55>
    cc = read(0, &c, 1);
 244:	83 ec 04             	sub    $0x4,%esp
 247:	6a 01                	push   $0x1
 249:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24c:	50                   	push   %eax
 24d:	6a 00                	push   $0x0
 24f:	e8 53 01 00 00       	call   3a7 <read>
 254:	83 c4 10             	add    $0x10,%esp
 257:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25e:	7e 33                	jle    293 <gets+0x62>
      break;
    buf[i++] = c;
 260:	8b 45 f4             	mov    -0xc(%ebp),%eax
 263:	8d 50 01             	lea    0x1(%eax),%edx
 266:	89 55 f4             	mov    %edx,-0xc(%ebp)
 269:	89 c2                	mov    %eax,%edx
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	01 c2                	add    %eax,%edx
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 276:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27a:	3c 0a                	cmp    $0xa,%al
 27c:	74 16                	je     294 <gets+0x63>
 27e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 282:	3c 0d                	cmp    $0xd,%al
 284:	74 0e                	je     294 <gets+0x63>
  for(i=0; i+1 < max; ){
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	39 45 0c             	cmp    %eax,0xc(%ebp)
 28f:	7f b3                	jg     244 <gets+0x13>
 291:	eb 01                	jmp    294 <gets+0x63>
      break;
 293:	90                   	nop
      break;
  }
  buf[i] = '\0';
 294:	8b 55 f4             	mov    -0xc(%ebp),%edx
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	01 d0                	add    %edx,%eax
 29c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a2:	c9                   	leave  
 2a3:	c3                   	ret    

000002a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a4:	f3 0f 1e fb          	endbr32 
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ae:	83 ec 08             	sub    $0x8,%esp
 2b1:	6a 00                	push   $0x0
 2b3:	ff 75 08             	pushl  0x8(%ebp)
 2b6:	e8 14 01 00 00       	call   3cf <open>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c5:	79 07                	jns    2ce <stat+0x2a>
    return -1;
 2c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cc:	eb 25                	jmp    2f3 <stat+0x4f>
  r = fstat(fd, st);
 2ce:	83 ec 08             	sub    $0x8,%esp
 2d1:	ff 75 0c             	pushl  0xc(%ebp)
 2d4:	ff 75 f4             	pushl  -0xc(%ebp)
 2d7:	e8 0b 01 00 00       	call   3e7 <fstat>
 2dc:	83 c4 10             	add    $0x10,%esp
 2df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e2:	83 ec 0c             	sub    $0xc,%esp
 2e5:	ff 75 f4             	pushl  -0xc(%ebp)
 2e8:	e8 ca 00 00 00       	call   3b7 <close>
 2ed:	83 c4 10             	add    $0x10,%esp
  return r;
 2f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f3:	c9                   	leave  
 2f4:	c3                   	ret    

000002f5 <atoi>:

int
atoi(const char *s)
{
 2f5:	f3 0f 1e fb          	endbr32 
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 306:	eb 25                	jmp    32d <atoi+0x38>
    n = n*10 + *s++ - '0';
 308:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30b:	89 d0                	mov    %edx,%eax
 30d:	c1 e0 02             	shl    $0x2,%eax
 310:	01 d0                	add    %edx,%eax
 312:	01 c0                	add    %eax,%eax
 314:	89 c1                	mov    %eax,%ecx
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	8d 50 01             	lea    0x1(%eax),%edx
 31c:	89 55 08             	mov    %edx,0x8(%ebp)
 31f:	0f b6 00             	movzbl (%eax),%eax
 322:	0f be c0             	movsbl %al,%eax
 325:	01 c8                	add    %ecx,%eax
 327:	83 e8 30             	sub    $0x30,%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	0f b6 00             	movzbl (%eax),%eax
 333:	3c 2f                	cmp    $0x2f,%al
 335:	7e 0a                	jle    341 <atoi+0x4c>
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	0f b6 00             	movzbl (%eax),%eax
 33d:	3c 39                	cmp    $0x39,%al
 33f:	7e c7                	jle    308 <atoi+0x13>
  return n;
 341:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 344:	c9                   	leave  
 345:	c3                   	ret    

00000346 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 346:	f3 0f 1e fb          	endbr32 
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp
 34d:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 356:	8b 45 0c             	mov    0xc(%ebp),%eax
 359:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 35c:	eb 17                	jmp    375 <memmove+0x2f>
    *dst++ = *src++;
 35e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 361:	8d 42 01             	lea    0x1(%edx),%eax
 364:	89 45 f8             	mov    %eax,-0x8(%ebp)
 367:	8b 45 fc             	mov    -0x4(%ebp),%eax
 36a:	8d 48 01             	lea    0x1(%eax),%ecx
 36d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 370:	0f b6 12             	movzbl (%edx),%edx
 373:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 375:	8b 45 10             	mov    0x10(%ebp),%eax
 378:	8d 50 ff             	lea    -0x1(%eax),%edx
 37b:	89 55 10             	mov    %edx,0x10(%ebp)
 37e:	85 c0                	test   %eax,%eax
 380:	7f dc                	jg     35e <memmove+0x18>
  return vdst;
 382:	8b 45 08             	mov    0x8(%ebp),%eax
}
 385:	c9                   	leave  
 386:	c3                   	ret    

00000387 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 387:	b8 01 00 00 00       	mov    $0x1,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <exit>:
SYSCALL(exit)
 38f:	b8 02 00 00 00       	mov    $0x2,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <wait>:
SYSCALL(wait)
 397:	b8 03 00 00 00       	mov    $0x3,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <pipe>:
SYSCALL(pipe)
 39f:	b8 04 00 00 00       	mov    $0x4,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <read>:
SYSCALL(read)
 3a7:	b8 05 00 00 00       	mov    $0x5,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <write>:
SYSCALL(write)
 3af:	b8 10 00 00 00       	mov    $0x10,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <close>:
SYSCALL(close)
 3b7:	b8 15 00 00 00       	mov    $0x15,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <kill>:
SYSCALL(kill)
 3bf:	b8 06 00 00 00       	mov    $0x6,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <exec>:
SYSCALL(exec)
 3c7:	b8 07 00 00 00       	mov    $0x7,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <open>:
SYSCALL(open)
 3cf:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <mknod>:
SYSCALL(mknod)
 3d7:	b8 11 00 00 00       	mov    $0x11,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <unlink>:
SYSCALL(unlink)
 3df:	b8 12 00 00 00       	mov    $0x12,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <fstat>:
SYSCALL(fstat)
 3e7:	b8 08 00 00 00       	mov    $0x8,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <link>:
SYSCALL(link)
 3ef:	b8 13 00 00 00       	mov    $0x13,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <mkdir>:
SYSCALL(mkdir)
 3f7:	b8 14 00 00 00       	mov    $0x14,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <chdir>:
SYSCALL(chdir)
 3ff:	b8 09 00 00 00       	mov    $0x9,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <dup>:
SYSCALL(dup)
 407:	b8 0a 00 00 00       	mov    $0xa,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <getpid>:
SYSCALL(getpid)
 40f:	b8 0b 00 00 00       	mov    $0xb,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <sbrk>:
SYSCALL(sbrk)
 417:	b8 0c 00 00 00       	mov    $0xc,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <sleep>:
SYSCALL(sleep)
 41f:	b8 0d 00 00 00       	mov    $0xd,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <uptime>:
SYSCALL(uptime)
 427:	b8 0e 00 00 00       	mov    $0xe,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <mencrypt>:
SYSCALL(mencrypt)
 42f:	b8 16 00 00 00       	mov    $0x16,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <getpgtable>:
SYSCALL(getpgtable)
 437:	b8 17 00 00 00       	mov    $0x17,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 43f:	b8 18 00 00 00       	mov    $0x18,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    
