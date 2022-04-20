
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   a:	eb 31                	jmp    3d <cat+0x3d>
    if (write(1, buf, n) != n) {
   c:	83 ec 04             	sub    $0x4,%esp
   f:	ff 75 f4             	pushl  -0xc(%ebp)
  12:	68 00 0c 00 00       	push   $0xc00
  17:	6a 01                	push   $0x1
  19:	e8 b0 03 00 00       	call   3ce <write>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  24:	74 17                	je     3d <cat+0x3d>
      printf(1, "cat: write error\n");
  26:	83 ec 08             	sub    $0x8,%esp
  29:	68 09 09 00 00       	push   $0x909
  2e:	6a 01                	push   $0x1
  30:	e8 0d 05 00 00       	call   542 <printf>
  35:	83 c4 10             	add    $0x10,%esp
      exit();
  38:	e8 71 03 00 00       	call   3ae <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  3d:	83 ec 04             	sub    $0x4,%esp
  40:	68 00 02 00 00       	push   $0x200
  45:	68 00 0c 00 00       	push   $0xc00
  4a:	ff 75 08             	pushl  0x8(%ebp)
  4d:	e8 74 03 00 00       	call   3c6 <read>
  52:	83 c4 10             	add    $0x10,%esp
  55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  5c:	7f ae                	jg     c <cat+0xc>
    }
  }
  if(n < 0){
  5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  62:	79 17                	jns    7b <cat+0x7b>
    printf(1, "cat: read error\n");
  64:	83 ec 08             	sub    $0x8,%esp
  67:	68 1b 09 00 00       	push   $0x91b
  6c:	6a 01                	push   $0x1
  6e:	e8 cf 04 00 00       	call   542 <printf>
  73:	83 c4 10             	add    $0x10,%esp
    exit();
  76:	e8 33 03 00 00       	call   3ae <exit>
  }
}
  7b:	90                   	nop
  7c:	c9                   	leave  
  7d:	c3                   	ret    

0000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	f3 0f 1e fb          	endbr32 
  82:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  86:	83 e4 f0             	and    $0xfffffff0,%esp
  89:	ff 71 fc             	pushl  -0x4(%ecx)
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	53                   	push   %ebx
  90:	51                   	push   %ecx
  91:	83 ec 10             	sub    $0x10,%esp
  94:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  96:	83 3b 01             	cmpl   $0x1,(%ebx)
  99:	7f 12                	jg     ad <main+0x2f>
    cat(0);
  9b:	83 ec 0c             	sub    $0xc,%esp
  9e:	6a 00                	push   $0x0
  a0:	e8 5b ff ff ff       	call   0 <cat>
  a5:	83 c4 10             	add    $0x10,%esp
    exit();
  a8:	e8 01 03 00 00       	call   3ae <exit>
  }

  for(i = 1; i < argc; i++){
  ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  b4:	eb 71                	jmp    127 <main+0xa9>
    if((fd = open(argv[i], 0)) < 0){
  b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c0:	8b 43 04             	mov    0x4(%ebx),%eax
  c3:	01 d0                	add    %edx,%eax
  c5:	8b 00                	mov    (%eax),%eax
  c7:	83 ec 08             	sub    $0x8,%esp
  ca:	6a 00                	push   $0x0
  cc:	50                   	push   %eax
  cd:	e8 1c 03 00 00       	call   3ee <open>
  d2:	83 c4 10             	add    $0x10,%esp
  d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  dc:	79 29                	jns    107 <main+0x89>
      printf(1, "cat: cannot open %s\n", argv[i]);
  de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  e8:	8b 43 04             	mov    0x4(%ebx),%eax
  eb:	01 d0                	add    %edx,%eax
  ed:	8b 00                	mov    (%eax),%eax
  ef:	83 ec 04             	sub    $0x4,%esp
  f2:	50                   	push   %eax
  f3:	68 2c 09 00 00       	push   $0x92c
  f8:	6a 01                	push   $0x1
  fa:	e8 43 04 00 00       	call   542 <printf>
  ff:	83 c4 10             	add    $0x10,%esp
      exit();
 102:	e8 a7 02 00 00       	call   3ae <exit>
    }
    cat(fd);
 107:	83 ec 0c             	sub    $0xc,%esp
 10a:	ff 75 f0             	pushl  -0x10(%ebp)
 10d:	e8 ee fe ff ff       	call   0 <cat>
 112:	83 c4 10             	add    $0x10,%esp
    close(fd);
 115:	83 ec 0c             	sub    $0xc,%esp
 118:	ff 75 f0             	pushl  -0x10(%ebp)
 11b:	e8 b6 02 00 00       	call   3d6 <close>
 120:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 123:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 127:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12a:	3b 03                	cmp    (%ebx),%eax
 12c:	7c 88                	jl     b6 <main+0x38>
  }
  exit();
 12e:	e8 7b 02 00 00       	call   3ae <exit>

00000133 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 133:	55                   	push   %ebp
 134:	89 e5                	mov    %esp,%ebp
 136:	57                   	push   %edi
 137:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 138:	8b 4d 08             	mov    0x8(%ebp),%ecx
 13b:	8b 55 10             	mov    0x10(%ebp),%edx
 13e:	8b 45 0c             	mov    0xc(%ebp),%eax
 141:	89 cb                	mov    %ecx,%ebx
 143:	89 df                	mov    %ebx,%edi
 145:	89 d1                	mov    %edx,%ecx
 147:	fc                   	cld    
 148:	f3 aa                	rep stos %al,%es:(%edi)
 14a:	89 ca                	mov    %ecx,%edx
 14c:	89 fb                	mov    %edi,%ebx
 14e:	89 5d 08             	mov    %ebx,0x8(%ebp)
 151:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 154:	90                   	nop
 155:	5b                   	pop    %ebx
 156:	5f                   	pop    %edi
 157:	5d                   	pop    %ebp
 158:	c3                   	ret    

00000159 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 159:	f3 0f 1e fb          	endbr32 
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 169:	90                   	nop
 16a:	8b 55 0c             	mov    0xc(%ebp),%edx
 16d:	8d 42 01             	lea    0x1(%edx),%eax
 170:	89 45 0c             	mov    %eax,0xc(%ebp)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	8d 48 01             	lea    0x1(%eax),%ecx
 179:	89 4d 08             	mov    %ecx,0x8(%ebp)
 17c:	0f b6 12             	movzbl (%edx),%edx
 17f:	88 10                	mov    %dl,(%eax)
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	84 c0                	test   %al,%al
 186:	75 e2                	jne    16a <strcpy+0x11>
    ;
  return os;
 188:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18b:	c9                   	leave  
 18c:	c3                   	ret    

0000018d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18d:	f3 0f 1e fb          	endbr32 
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 194:	eb 08                	jmp    19e <strcmp+0x11>
    p++, q++;
 196:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	74 10                	je     1b8 <strcmp+0x2b>
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 10             	movzbl (%eax),%edx
 1ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	38 c2                	cmp    %al,%dl
 1b6:	74 de                	je     196 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	0f b6 00             	movzbl (%eax),%eax
 1be:	0f b6 d0             	movzbl %al,%edx
 1c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	0f b6 c0             	movzbl %al,%eax
 1ca:	29 c2                	sub    %eax,%edx
 1cc:	89 d0                	mov    %edx,%eax
}
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    

000001d0 <strlen>:

uint
strlen(const char *s)
{
 1d0:	f3 0f 1e fb          	endbr32 
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e1:	eb 04                	jmp    1e7 <strlen+0x17>
 1e3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	01 d0                	add    %edx,%eax
 1ef:	0f b6 00             	movzbl (%eax),%eax
 1f2:	84 c0                	test   %al,%al
 1f4:	75 ed                	jne    1e3 <strlen+0x13>
    ;
  return n;
 1f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fb:	f3 0f 1e fb          	endbr32 
 1ff:	55                   	push   %ebp
 200:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 202:	8b 45 10             	mov    0x10(%ebp),%eax
 205:	50                   	push   %eax
 206:	ff 75 0c             	pushl  0xc(%ebp)
 209:	ff 75 08             	pushl  0x8(%ebp)
 20c:	e8 22 ff ff ff       	call   133 <stosb>
 211:	83 c4 0c             	add    $0xc,%esp
  return dst;
 214:	8b 45 08             	mov    0x8(%ebp),%eax
}
 217:	c9                   	leave  
 218:	c3                   	ret    

00000219 <strchr>:

char*
strchr(const char *s, char c)
{
 219:	f3 0f 1e fb          	endbr32 
 21d:	55                   	push   %ebp
 21e:	89 e5                	mov    %esp,%ebp
 220:	83 ec 04             	sub    $0x4,%esp
 223:	8b 45 0c             	mov    0xc(%ebp),%eax
 226:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 229:	eb 14                	jmp    23f <strchr+0x26>
    if(*s == c)
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 00             	movzbl (%eax),%eax
 231:	38 45 fc             	cmp    %al,-0x4(%ebp)
 234:	75 05                	jne    23b <strchr+0x22>
      return (char*)s;
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	eb 13                	jmp    24e <strchr+0x35>
  for(; *s; s++)
 23b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	84 c0                	test   %al,%al
 247:	75 e2                	jne    22b <strchr+0x12>
  return 0;
 249:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <gets>:

char*
gets(char *buf, int max)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 261:	eb 42                	jmp    2a5 <gets+0x55>
    cc = read(0, &c, 1);
 263:	83 ec 04             	sub    $0x4,%esp
 266:	6a 01                	push   $0x1
 268:	8d 45 ef             	lea    -0x11(%ebp),%eax
 26b:	50                   	push   %eax
 26c:	6a 00                	push   $0x0
 26e:	e8 53 01 00 00       	call   3c6 <read>
 273:	83 c4 10             	add    $0x10,%esp
 276:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 279:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27d:	7e 33                	jle    2b2 <gets+0x62>
      break;
    buf[i++] = c;
 27f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 282:	8d 50 01             	lea    0x1(%eax),%edx
 285:	89 55 f4             	mov    %edx,-0xc(%ebp)
 288:	89 c2                	mov    %eax,%edx
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	01 c2                	add    %eax,%edx
 28f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 293:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 295:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 299:	3c 0a                	cmp    $0xa,%al
 29b:	74 16                	je     2b3 <gets+0x63>
 29d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a1:	3c 0d                	cmp    $0xd,%al
 2a3:	74 0e                	je     2b3 <gets+0x63>
  for(i=0; i+1 < max; ){
 2a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a8:	83 c0 01             	add    $0x1,%eax
 2ab:	39 45 0c             	cmp    %eax,0xc(%ebp)
 2ae:	7f b3                	jg     263 <gets+0x13>
 2b0:	eb 01                	jmp    2b3 <gets+0x63>
      break;
 2b2:	90                   	nop
      break;
  }
  buf[i] = '\0';
 2b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	01 d0                	add    %edx,%eax
 2bb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c3:	f3 0f 1e fb          	endbr32 
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2cd:	83 ec 08             	sub    $0x8,%esp
 2d0:	6a 00                	push   $0x0
 2d2:	ff 75 08             	pushl  0x8(%ebp)
 2d5:	e8 14 01 00 00       	call   3ee <open>
 2da:	83 c4 10             	add    $0x10,%esp
 2dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e4:	79 07                	jns    2ed <stat+0x2a>
    return -1;
 2e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2eb:	eb 25                	jmp    312 <stat+0x4f>
  r = fstat(fd, st);
 2ed:	83 ec 08             	sub    $0x8,%esp
 2f0:	ff 75 0c             	pushl  0xc(%ebp)
 2f3:	ff 75 f4             	pushl  -0xc(%ebp)
 2f6:	e8 0b 01 00 00       	call   406 <fstat>
 2fb:	83 c4 10             	add    $0x10,%esp
 2fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 301:	83 ec 0c             	sub    $0xc,%esp
 304:	ff 75 f4             	pushl  -0xc(%ebp)
 307:	e8 ca 00 00 00       	call   3d6 <close>
 30c:	83 c4 10             	add    $0x10,%esp
  return r;
 30f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 312:	c9                   	leave  
 313:	c3                   	ret    

00000314 <atoi>:

int
atoi(const char *s)
{
 314:	f3 0f 1e fb          	endbr32 
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 325:	eb 25                	jmp    34c <atoi+0x38>
    n = n*10 + *s++ - '0';
 327:	8b 55 fc             	mov    -0x4(%ebp),%edx
 32a:	89 d0                	mov    %edx,%eax
 32c:	c1 e0 02             	shl    $0x2,%eax
 32f:	01 d0                	add    %edx,%eax
 331:	01 c0                	add    %eax,%eax
 333:	89 c1                	mov    %eax,%ecx
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	8d 50 01             	lea    0x1(%eax),%edx
 33b:	89 55 08             	mov    %edx,0x8(%ebp)
 33e:	0f b6 00             	movzbl (%eax),%eax
 341:	0f be c0             	movsbl %al,%eax
 344:	01 c8                	add    %ecx,%eax
 346:	83 e8 30             	sub    $0x30,%eax
 349:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	0f b6 00             	movzbl (%eax),%eax
 352:	3c 2f                	cmp    $0x2f,%al
 354:	7e 0a                	jle    360 <atoi+0x4c>
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	0f b6 00             	movzbl (%eax),%eax
 35c:	3c 39                	cmp    $0x39,%al
 35e:	7e c7                	jle    327 <atoi+0x13>
  return n;
 360:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 363:	c9                   	leave  
 364:	c3                   	ret    

00000365 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 365:	f3 0f 1e fb          	endbr32 
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 375:	8b 45 0c             	mov    0xc(%ebp),%eax
 378:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 37b:	eb 17                	jmp    394 <memmove+0x2f>
    *dst++ = *src++;
 37d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 380:	8d 42 01             	lea    0x1(%edx),%eax
 383:	89 45 f8             	mov    %eax,-0x8(%ebp)
 386:	8b 45 fc             	mov    -0x4(%ebp),%eax
 389:	8d 48 01             	lea    0x1(%eax),%ecx
 38c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 38f:	0f b6 12             	movzbl (%edx),%edx
 392:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 394:	8b 45 10             	mov    0x10(%ebp),%eax
 397:	8d 50 ff             	lea    -0x1(%eax),%edx
 39a:	89 55 10             	mov    %edx,0x10(%ebp)
 39d:	85 c0                	test   %eax,%eax
 39f:	7f dc                	jg     37d <memmove+0x18>
  return vdst;
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a4:	c9                   	leave  
 3a5:	c3                   	ret    

000003a6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a6:	b8 01 00 00 00       	mov    $0x1,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <exit>:
SYSCALL(exit)
 3ae:	b8 02 00 00 00       	mov    $0x2,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <wait>:
SYSCALL(wait)
 3b6:	b8 03 00 00 00       	mov    $0x3,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <pipe>:
SYSCALL(pipe)
 3be:	b8 04 00 00 00       	mov    $0x4,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <read>:
SYSCALL(read)
 3c6:	b8 05 00 00 00       	mov    $0x5,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <write>:
SYSCALL(write)
 3ce:	b8 10 00 00 00       	mov    $0x10,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <close>:
SYSCALL(close)
 3d6:	b8 15 00 00 00       	mov    $0x15,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <kill>:
SYSCALL(kill)
 3de:	b8 06 00 00 00       	mov    $0x6,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <exec>:
SYSCALL(exec)
 3e6:	b8 07 00 00 00       	mov    $0x7,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <open>:
SYSCALL(open)
 3ee:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <mknod>:
SYSCALL(mknod)
 3f6:	b8 11 00 00 00       	mov    $0x11,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <unlink>:
SYSCALL(unlink)
 3fe:	b8 12 00 00 00       	mov    $0x12,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <fstat>:
SYSCALL(fstat)
 406:	b8 08 00 00 00       	mov    $0x8,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <link>:
SYSCALL(link)
 40e:	b8 13 00 00 00       	mov    $0x13,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <mkdir>:
SYSCALL(mkdir)
 416:	b8 14 00 00 00       	mov    $0x14,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <chdir>:
SYSCALL(chdir)
 41e:	b8 09 00 00 00       	mov    $0x9,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <dup>:
SYSCALL(dup)
 426:	b8 0a 00 00 00       	mov    $0xa,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <getpid>:
SYSCALL(getpid)
 42e:	b8 0b 00 00 00       	mov    $0xb,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <sbrk>:
SYSCALL(sbrk)
 436:	b8 0c 00 00 00       	mov    $0xc,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <sleep>:
SYSCALL(sleep)
 43e:	b8 0d 00 00 00       	mov    $0xd,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <uptime>:
SYSCALL(uptime)
 446:	b8 0e 00 00 00       	mov    $0xe,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <mencrypt>:
SYSCALL(mencrypt)
 44e:	b8 16 00 00 00       	mov    $0x16,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <getpgtable>:
SYSCALL(getpgtable)
 456:	b8 17 00 00 00       	mov    $0x17,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 45e:	b8 18 00 00 00       	mov    $0x18,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 466:	f3 0f 1e fb          	endbr32 
 46a:	55                   	push   %ebp
 46b:	89 e5                	mov    %esp,%ebp
 46d:	83 ec 18             	sub    $0x18,%esp
 470:	8b 45 0c             	mov    0xc(%ebp),%eax
 473:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 476:	83 ec 04             	sub    $0x4,%esp
 479:	6a 01                	push   $0x1
 47b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 47e:	50                   	push   %eax
 47f:	ff 75 08             	pushl  0x8(%ebp)
 482:	e8 47 ff ff ff       	call   3ce <write>
 487:	83 c4 10             	add    $0x10,%esp
}
 48a:	90                   	nop
 48b:	c9                   	leave  
 48c:	c3                   	ret    

0000048d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 48d:	f3 0f 1e fb          	endbr32 
 491:	55                   	push   %ebp
 492:	89 e5                	mov    %esp,%ebp
 494:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 497:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 49e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4a2:	74 17                	je     4bb <printint+0x2e>
 4a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a8:	79 11                	jns    4bb <printint+0x2e>
    neg = 1;
 4aa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b4:	f7 d8                	neg    %eax
 4b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b9:	eb 06                	jmp    4c1 <printint+0x34>
  } else {
    x = xx;
 4bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ce:	ba 00 00 00 00       	mov    $0x0,%edx
 4d3:	f7 f1                	div    %ecx
 4d5:	89 d1                	mov    %edx,%ecx
 4d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4da:	8d 50 01             	lea    0x1(%eax),%edx
 4dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e0:	0f b6 91 b0 0b 00 00 	movzbl 0xbb0(%ecx),%edx
 4e7:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f1:	ba 00 00 00 00       	mov    $0x0,%edx
 4f6:	f7 f1                	div    %ecx
 4f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ff:	75 c7                	jne    4c8 <printint+0x3b>
  if(neg)
 501:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 505:	74 2d                	je     534 <printint+0xa7>
    buf[i++] = '-';
 507:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50a:	8d 50 01             	lea    0x1(%eax),%edx
 50d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 510:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 515:	eb 1d                	jmp    534 <printint+0xa7>
    putc(fd, buf[i]);
 517:	8d 55 dc             	lea    -0x24(%ebp),%edx
 51a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51d:	01 d0                	add    %edx,%eax
 51f:	0f b6 00             	movzbl (%eax),%eax
 522:	0f be c0             	movsbl %al,%eax
 525:	83 ec 08             	sub    $0x8,%esp
 528:	50                   	push   %eax
 529:	ff 75 08             	pushl  0x8(%ebp)
 52c:	e8 35 ff ff ff       	call   466 <putc>
 531:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 534:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53c:	79 d9                	jns    517 <printint+0x8a>
}
 53e:	90                   	nop
 53f:	90                   	nop
 540:	c9                   	leave  
 541:	c3                   	ret    

00000542 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 542:	f3 0f 1e fb          	endbr32 
 546:	55                   	push   %ebp
 547:	89 e5                	mov    %esp,%ebp
 549:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 54c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 553:	8d 45 0c             	lea    0xc(%ebp),%eax
 556:	83 c0 04             	add    $0x4,%eax
 559:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 55c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 563:	e9 59 01 00 00       	jmp    6c1 <printf+0x17f>
    c = fmt[i] & 0xff;
 568:	8b 55 0c             	mov    0xc(%ebp),%edx
 56b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 56e:	01 d0                	add    %edx,%eax
 570:	0f b6 00             	movzbl (%eax),%eax
 573:	0f be c0             	movsbl %al,%eax
 576:	25 ff 00 00 00       	and    $0xff,%eax
 57b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 57e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 582:	75 2c                	jne    5b0 <printf+0x6e>
      if(c == '%'){
 584:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 588:	75 0c                	jne    596 <printf+0x54>
        state = '%';
 58a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 591:	e9 27 01 00 00       	jmp    6bd <printf+0x17b>
      } else {
        putc(fd, c);
 596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 599:	0f be c0             	movsbl %al,%eax
 59c:	83 ec 08             	sub    $0x8,%esp
 59f:	50                   	push   %eax
 5a0:	ff 75 08             	pushl  0x8(%ebp)
 5a3:	e8 be fe ff ff       	call   466 <putc>
 5a8:	83 c4 10             	add    $0x10,%esp
 5ab:	e9 0d 01 00 00       	jmp    6bd <printf+0x17b>
      }
    } else if(state == '%'){
 5b0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5b4:	0f 85 03 01 00 00    	jne    6bd <printf+0x17b>
      if(c == 'd'){
 5ba:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5be:	75 1e                	jne    5de <printf+0x9c>
        printint(fd, *ap, 10, 1);
 5c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	6a 01                	push   $0x1
 5c7:	6a 0a                	push   $0xa
 5c9:	50                   	push   %eax
 5ca:	ff 75 08             	pushl  0x8(%ebp)
 5cd:	e8 bb fe ff ff       	call   48d <printint>
 5d2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d9:	e9 d8 00 00 00       	jmp    6b6 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 5de:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5e2:	74 06                	je     5ea <printf+0xa8>
 5e4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e8:	75 1e                	jne    608 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 5ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ed:	8b 00                	mov    (%eax),%eax
 5ef:	6a 00                	push   $0x0
 5f1:	6a 10                	push   $0x10
 5f3:	50                   	push   %eax
 5f4:	ff 75 08             	pushl  0x8(%ebp)
 5f7:	e8 91 fe ff ff       	call   48d <printint>
 5fc:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 603:	e9 ae 00 00 00       	jmp    6b6 <printf+0x174>
      } else if(c == 's'){
 608:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 60c:	75 43                	jne    651 <printf+0x10f>
        s = (char*)*ap;
 60e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 611:	8b 00                	mov    (%eax),%eax
 613:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 616:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 61a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 61e:	75 25                	jne    645 <printf+0x103>
          s = "(null)";
 620:	c7 45 f4 41 09 00 00 	movl   $0x941,-0xc(%ebp)
        while(*s != 0){
 627:	eb 1c                	jmp    645 <printf+0x103>
          putc(fd, *s);
 629:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62c:	0f b6 00             	movzbl (%eax),%eax
 62f:	0f be c0             	movsbl %al,%eax
 632:	83 ec 08             	sub    $0x8,%esp
 635:	50                   	push   %eax
 636:	ff 75 08             	pushl  0x8(%ebp)
 639:	e8 28 fe ff ff       	call   466 <putc>
 63e:	83 c4 10             	add    $0x10,%esp
          s++;
 641:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 645:	8b 45 f4             	mov    -0xc(%ebp),%eax
 648:	0f b6 00             	movzbl (%eax),%eax
 64b:	84 c0                	test   %al,%al
 64d:	75 da                	jne    629 <printf+0xe7>
 64f:	eb 65                	jmp    6b6 <printf+0x174>
        }
      } else if(c == 'c'){
 651:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 655:	75 1d                	jne    674 <printf+0x132>
        putc(fd, *ap);
 657:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	0f be c0             	movsbl %al,%eax
 65f:	83 ec 08             	sub    $0x8,%esp
 662:	50                   	push   %eax
 663:	ff 75 08             	pushl  0x8(%ebp)
 666:	e8 fb fd ff ff       	call   466 <putc>
 66b:	83 c4 10             	add    $0x10,%esp
        ap++;
 66e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 672:	eb 42                	jmp    6b6 <printf+0x174>
      } else if(c == '%'){
 674:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 678:	75 17                	jne    691 <printf+0x14f>
        putc(fd, c);
 67a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67d:	0f be c0             	movsbl %al,%eax
 680:	83 ec 08             	sub    $0x8,%esp
 683:	50                   	push   %eax
 684:	ff 75 08             	pushl  0x8(%ebp)
 687:	e8 da fd ff ff       	call   466 <putc>
 68c:	83 c4 10             	add    $0x10,%esp
 68f:	eb 25                	jmp    6b6 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 691:	83 ec 08             	sub    $0x8,%esp
 694:	6a 25                	push   $0x25
 696:	ff 75 08             	pushl  0x8(%ebp)
 699:	e8 c8 fd ff ff       	call   466 <putc>
 69e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a4:	0f be c0             	movsbl %al,%eax
 6a7:	83 ec 08             	sub    $0x8,%esp
 6aa:	50                   	push   %eax
 6ab:	ff 75 08             	pushl  0x8(%ebp)
 6ae:	e8 b3 fd ff ff       	call   466 <putc>
 6b3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6bd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c1:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c7:	01 d0                	add    %edx,%eax
 6c9:	0f b6 00             	movzbl (%eax),%eax
 6cc:	84 c0                	test   %al,%al
 6ce:	0f 85 94 fe ff ff    	jne    568 <printf+0x26>
    }
  }
}
 6d4:	90                   	nop
 6d5:	90                   	nop
 6d6:	c9                   	leave  
 6d7:	c3                   	ret    

000006d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d8:	f3 0f 1e fb          	endbr32 
 6dc:	55                   	push   %ebp
 6dd:	89 e5                	mov    %esp,%ebp
 6df:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e2:	8b 45 08             	mov    0x8(%ebp),%eax
 6e5:	83 e8 08             	sub    $0x8,%eax
 6e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6eb:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 6f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f3:	eb 24                	jmp    719 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6fd:	72 12                	jb     711 <free+0x39>
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 705:	77 24                	ja     72b <free+0x53>
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 70f:	72 1a                	jb     72b <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	89 45 fc             	mov    %eax,-0x4(%ebp)
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71f:	76 d4                	jbe    6f5 <free+0x1d>
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	8b 00                	mov    (%eax),%eax
 726:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 729:	73 ca                	jae    6f5 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72e:	8b 40 04             	mov    0x4(%eax),%eax
 731:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 738:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73b:	01 c2                	add    %eax,%edx
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	39 c2                	cmp    %eax,%edx
 744:	75 24                	jne    76a <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	8b 50 04             	mov    0x4(%eax),%edx
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	8b 40 04             	mov    0x4(%eax),%eax
 754:	01 c2                	add    %eax,%edx
 756:	8b 45 f8             	mov    -0x8(%ebp),%eax
 759:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	8b 00                	mov    (%eax),%eax
 761:	8b 10                	mov    (%eax),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	89 10                	mov    %edx,(%eax)
 768:	eb 0a                	jmp    774 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	8b 10                	mov    (%eax),%edx
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 40 04             	mov    0x4(%eax),%eax
 77a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	01 d0                	add    %edx,%eax
 786:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 789:	75 20                	jne    7ab <free+0xd3>
    p->s.size += bp->s.size;
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 50 04             	mov    0x4(%eax),%edx
 791:	8b 45 f8             	mov    -0x8(%ebp),%eax
 794:	8b 40 04             	mov    0x4(%eax),%eax
 797:	01 c2                	add    %eax,%edx
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 79f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a2:	8b 10                	mov    (%eax),%edx
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	89 10                	mov    %edx,(%eax)
 7a9:	eb 08                	jmp    7b3 <free+0xdb>
  } else
    p->s.ptr = bp;
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	a3 e8 0b 00 00       	mov    %eax,0xbe8
}
 7bb:	90                   	nop
 7bc:	c9                   	leave  
 7bd:	c3                   	ret    

000007be <morecore>:

static Header*
morecore(uint nu)
{
 7be:	f3 0f 1e fb          	endbr32 
 7c2:	55                   	push   %ebp
 7c3:	89 e5                	mov    %esp,%ebp
 7c5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7cf:	77 07                	ja     7d8 <morecore+0x1a>
    nu = 4096;
 7d1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
 7db:	c1 e0 03             	shl    $0x3,%eax
 7de:	83 ec 0c             	sub    $0xc,%esp
 7e1:	50                   	push   %eax
 7e2:	e8 4f fc ff ff       	call   436 <sbrk>
 7e7:	83 c4 10             	add    $0x10,%esp
 7ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ed:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7f1:	75 07                	jne    7fa <morecore+0x3c>
    return 0;
 7f3:	b8 00 00 00 00       	mov    $0x0,%eax
 7f8:	eb 26                	jmp    820 <morecore+0x62>
  hp = (Header*)p;
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 800:	8b 45 f0             	mov    -0x10(%ebp),%eax
 803:	8b 55 08             	mov    0x8(%ebp),%edx
 806:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	83 c0 08             	add    $0x8,%eax
 80f:	83 ec 0c             	sub    $0xc,%esp
 812:	50                   	push   %eax
 813:	e8 c0 fe ff ff       	call   6d8 <free>
 818:	83 c4 10             	add    $0x10,%esp
  return freep;
 81b:	a1 e8 0b 00 00       	mov    0xbe8,%eax
}
 820:	c9                   	leave  
 821:	c3                   	ret    

00000822 <malloc>:

void*
malloc(uint nbytes)
{
 822:	f3 0f 1e fb          	endbr32 
 826:	55                   	push   %ebp
 827:	89 e5                	mov    %esp,%ebp
 829:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82c:	8b 45 08             	mov    0x8(%ebp),%eax
 82f:	83 c0 07             	add    $0x7,%eax
 832:	c1 e8 03             	shr    $0x3,%eax
 835:	83 c0 01             	add    $0x1,%eax
 838:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 83b:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 840:	89 45 f0             	mov    %eax,-0x10(%ebp)
 843:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 847:	75 23                	jne    86c <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 849:	c7 45 f0 e0 0b 00 00 	movl   $0xbe0,-0x10(%ebp)
 850:	8b 45 f0             	mov    -0x10(%ebp),%eax
 853:	a3 e8 0b 00 00       	mov    %eax,0xbe8
 858:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 85d:	a3 e0 0b 00 00       	mov    %eax,0xbe0
    base.s.size = 0;
 862:	c7 05 e4 0b 00 00 00 	movl   $0x0,0xbe4
 869:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 40 04             	mov    0x4(%eax),%eax
 87a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 87d:	77 4d                	ja     8cc <malloc+0xaa>
      if(p->s.size == nunits)
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	8b 40 04             	mov    0x4(%eax),%eax
 885:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 888:	75 0c                	jne    896 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	8b 10                	mov    (%eax),%edx
 88f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 892:	89 10                	mov    %edx,(%eax)
 894:	eb 26                	jmp    8bc <malloc+0x9a>
      else {
        p->s.size -= nunits;
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	8b 40 04             	mov    0x4(%eax),%eax
 89c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 89f:	89 c2                	mov    %eax,%edx
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	8b 40 04             	mov    0x4(%eax),%eax
 8ad:	c1 e0 03             	shl    $0x3,%eax
 8b0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8b9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bf:	a3 e8 0b 00 00       	mov    %eax,0xbe8
      return (void*)(p + 1);
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	83 c0 08             	add    $0x8,%eax
 8ca:	eb 3b                	jmp    907 <malloc+0xe5>
    }
    if(p == freep)
 8cc:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 8d1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8d4:	75 1e                	jne    8f4 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 8d6:	83 ec 0c             	sub    $0xc,%esp
 8d9:	ff 75 ec             	pushl  -0x14(%ebp)
 8dc:	e8 dd fe ff ff       	call   7be <morecore>
 8e1:	83 c4 10             	add    $0x10,%esp
 8e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8eb:	75 07                	jne    8f4 <malloc+0xd2>
        return 0;
 8ed:	b8 00 00 00 00       	mov    $0x0,%eax
 8f2:	eb 13                	jmp    907 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fd:	8b 00                	mov    (%eax),%eax
 8ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 902:	e9 6d ff ff ff       	jmp    874 <malloc+0x52>
  }
}
 907:	c9                   	leave  
 908:	c3                   	ret    
