
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  1d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  24:	eb 69                	jmp    8f <wc+0x8f>
    for(i=0; i<n; i++){
  26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  2d:	eb 58                	jmp    87 <wc+0x87>
      c++;
  2f:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	05 80 0c 00 00       	add    $0xc80,%eax
  3b:	0f b6 00             	movzbl (%eax),%eax
  3e:	3c 0a                	cmp    $0xa,%al
  40:	75 04                	jne    46 <wc+0x46>
        l++;
  42:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  49:	05 80 0c 00 00       	add    $0xc80,%eax
  4e:	0f b6 00             	movzbl (%eax),%eax
  51:	0f be c0             	movsbl %al,%eax
  54:	83 ec 08             	sub    $0x8,%esp
  57:	50                   	push   %eax
  58:	68 9b 09 00 00       	push   $0x99b
  5d:	e8 49 02 00 00       	call   2ab <strchr>
  62:	83 c4 10             	add    $0x10,%esp
  65:	85 c0                	test   %eax,%eax
  67:	74 09                	je     72 <wc+0x72>
        inword = 0;
  69:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  70:	eb 11                	jmp    83 <wc+0x83>
      else if(!inword){
  72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  76:	75 0b                	jne    83 <wc+0x83>
        w++;
  78:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  7c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  83:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8d:	7c a0                	jl     2f <wc+0x2f>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8f:	83 ec 04             	sub    $0x4,%esp
  92:	68 00 02 00 00       	push   $0x200
  97:	68 80 0c 00 00       	push   $0xc80
  9c:	ff 75 08             	pushl  0x8(%ebp)
  9f:	e8 b4 03 00 00       	call   458 <read>
  a4:	83 c4 10             	add    $0x10,%esp
  a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ae:	0f 8f 72 ff ff ff    	jg     26 <wc+0x26>
      }
    }
  }
  if(n < 0){
  b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b8:	79 17                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
  ba:	83 ec 08             	sub    $0x8,%esp
  bd:	68 a1 09 00 00       	push   $0x9a1
  c2:	6a 01                	push   $0x1
  c4:	e8 0b 05 00 00       	call   5d4 <printf>
  c9:	83 c4 10             	add    $0x10,%esp
    exit();
  cc:	e8 6f 03 00 00       	call   440 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d1:	83 ec 08             	sub    $0x8,%esp
  d4:	ff 75 0c             	pushl  0xc(%ebp)
  d7:	ff 75 e8             	pushl  -0x18(%ebp)
  da:	ff 75 ec             	pushl  -0x14(%ebp)
  dd:	ff 75 f0             	pushl  -0x10(%ebp)
  e0:	68 b1 09 00 00       	push   $0x9b1
  e5:	6a 01                	push   $0x1
  e7:	e8 e8 04 00 00       	call   5d4 <printf>
  ec:	83 c4 20             	add    $0x20,%esp
}
  ef:	90                   	nop
  f0:	c9                   	leave  
  f1:	c3                   	ret    

000000f2 <main>:

int
main(int argc, char *argv[])
{
  f2:	f3 0f 1e fb          	endbr32 
  f6:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  fa:	83 e4 f0             	and    $0xfffffff0,%esp
  fd:	ff 71 fc             	pushl  -0x4(%ecx)
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	51                   	push   %ecx
 105:	83 ec 10             	sub    $0x10,%esp
 108:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 10a:	83 3b 01             	cmpl   $0x1,(%ebx)
 10d:	7f 17                	jg     126 <main+0x34>
    wc(0, "");
 10f:	83 ec 08             	sub    $0x8,%esp
 112:	68 be 09 00 00       	push   $0x9be
 117:	6a 00                	push   $0x0
 119:	e8 e2 fe ff ff       	call   0 <wc>
 11e:	83 c4 10             	add    $0x10,%esp
    exit();
 121:	e8 1a 03 00 00       	call   440 <exit>
  }

  for(i = 1; i < argc; i++){
 126:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 12d:	e9 83 00 00 00       	jmp    1b5 <main+0xc3>
    if((fd = open(argv[i], 0)) < 0){
 132:	8b 45 f4             	mov    -0xc(%ebp),%eax
 135:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 13c:	8b 43 04             	mov    0x4(%ebx),%eax
 13f:	01 d0                	add    %edx,%eax
 141:	8b 00                	mov    (%eax),%eax
 143:	83 ec 08             	sub    $0x8,%esp
 146:	6a 00                	push   $0x0
 148:	50                   	push   %eax
 149:	e8 32 03 00 00       	call   480 <open>
 14e:	83 c4 10             	add    $0x10,%esp
 151:	89 45 f0             	mov    %eax,-0x10(%ebp)
 154:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 158:	79 29                	jns    183 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 164:	8b 43 04             	mov    0x4(%ebx),%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 04             	sub    $0x4,%esp
 16e:	50                   	push   %eax
 16f:	68 bf 09 00 00       	push   $0x9bf
 174:	6a 01                	push   $0x1
 176:	e8 59 04 00 00       	call   5d4 <printf>
 17b:	83 c4 10             	add    $0x10,%esp
      exit();
 17e:	e8 bd 02 00 00       	call   440 <exit>
    }
    wc(fd, argv[i]);
 183:	8b 45 f4             	mov    -0xc(%ebp),%eax
 186:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18d:	8b 43 04             	mov    0x4(%ebx),%eax
 190:	01 d0                	add    %edx,%eax
 192:	8b 00                	mov    (%eax),%eax
 194:	83 ec 08             	sub    $0x8,%esp
 197:	50                   	push   %eax
 198:	ff 75 f0             	pushl  -0x10(%ebp)
 19b:	e8 60 fe ff ff       	call   0 <wc>
 1a0:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1a3:	83 ec 0c             	sub    $0xc,%esp
 1a6:	ff 75 f0             	pushl  -0x10(%ebp)
 1a9:	e8 ba 02 00 00       	call   468 <close>
 1ae:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 1b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b8:	3b 03                	cmp    (%ebx),%eax
 1ba:	0f 8c 72 ff ff ff    	jl     132 <main+0x40>
  }
  exit();
 1c0:	e8 7b 02 00 00       	call   440 <exit>

000001c5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c5:	55                   	push   %ebp
 1c6:	89 e5                	mov    %esp,%ebp
 1c8:	57                   	push   %edi
 1c9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1cd:	8b 55 10             	mov    0x10(%ebp),%edx
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	89 cb                	mov    %ecx,%ebx
 1d5:	89 df                	mov    %ebx,%edi
 1d7:	89 d1                	mov    %edx,%ecx
 1d9:	fc                   	cld    
 1da:	f3 aa                	rep stos %al,%es:(%edi)
 1dc:	89 ca                	mov    %ecx,%edx
 1de:	89 fb                	mov    %edi,%ebx
 1e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e6:	90                   	nop
 1e7:	5b                   	pop    %ebx
 1e8:	5f                   	pop    %edi
 1e9:	5d                   	pop    %ebp
 1ea:	c3                   	ret    

000001eb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1eb:	f3 0f 1e fb          	endbr32 
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1fb:	90                   	nop
 1fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ff:	8d 42 01             	lea    0x1(%edx),%eax
 202:	89 45 0c             	mov    %eax,0xc(%ebp)
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	8d 48 01             	lea    0x1(%eax),%ecx
 20b:	89 4d 08             	mov    %ecx,0x8(%ebp)
 20e:	0f b6 12             	movzbl (%edx),%edx
 211:	88 10                	mov    %dl,(%eax)
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	84 c0                	test   %al,%al
 218:	75 e2                	jne    1fc <strcpy+0x11>
    ;
  return os;
 21a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21d:	c9                   	leave  
 21e:	c3                   	ret    

0000021f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21f:	f3 0f 1e fb          	endbr32 
 223:	55                   	push   %ebp
 224:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 226:	eb 08                	jmp    230 <strcmp+0x11>
    p++, q++;
 228:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 22c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	84 c0                	test   %al,%al
 238:	74 10                	je     24a <strcmp+0x2b>
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 10             	movzbl (%eax),%edx
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	38 c2                	cmp    %al,%dl
 248:	74 de                	je     228 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	0f b6 d0             	movzbl %al,%edx
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	0f b6 c0             	movzbl %al,%eax
 25c:	29 c2                	sub    %eax,%edx
 25e:	89 d0                	mov    %edx,%eax
}
 260:	5d                   	pop    %ebp
 261:	c3                   	ret    

00000262 <strlen>:

uint
strlen(const char *s)
{
 262:	f3 0f 1e fb          	endbr32 
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 26c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 273:	eb 04                	jmp    279 <strlen+0x17>
 275:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 279:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	01 d0                	add    %edx,%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	84 c0                	test   %al,%al
 286:	75 ed                	jne    275 <strlen+0x13>
    ;
  return n;
 288:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28b:	c9                   	leave  
 28c:	c3                   	ret    

0000028d <memset>:

void*
memset(void *dst, int c, uint n)
{
 28d:	f3 0f 1e fb          	endbr32 
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 294:	8b 45 10             	mov    0x10(%ebp),%eax
 297:	50                   	push   %eax
 298:	ff 75 0c             	pushl  0xc(%ebp)
 29b:	ff 75 08             	pushl  0x8(%ebp)
 29e:	e8 22 ff ff ff       	call   1c5 <stosb>
 2a3:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a9:	c9                   	leave  
 2aa:	c3                   	ret    

000002ab <strchr>:

char*
strchr(const char *s, char c)
{
 2ab:	f3 0f 1e fb          	endbr32 
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
 2b2:	83 ec 04             	sub    $0x4,%esp
 2b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2bb:	eb 14                	jmp    2d1 <strchr+0x26>
    if(*s == c)
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	38 45 fc             	cmp    %al,-0x4(%ebp)
 2c6:	75 05                	jne    2cd <strchr+0x22>
      return (char*)s;
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	eb 13                	jmp    2e0 <strchr+0x35>
  for(; *s; s++)
 2cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	0f b6 00             	movzbl (%eax),%eax
 2d7:	84 c0                	test   %al,%al
 2d9:	75 e2                	jne    2bd <strchr+0x12>
  return 0;
 2db:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <gets>:

char*
gets(char *buf, int max)
{
 2e2:	f3 0f 1e fb          	endbr32 
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2f3:	eb 42                	jmp    337 <gets+0x55>
    cc = read(0, &c, 1);
 2f5:	83 ec 04             	sub    $0x4,%esp
 2f8:	6a 01                	push   $0x1
 2fa:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2fd:	50                   	push   %eax
 2fe:	6a 00                	push   $0x0
 300:	e8 53 01 00 00       	call   458 <read>
 305:	83 c4 10             	add    $0x10,%esp
 308:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 30b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 30f:	7e 33                	jle    344 <gets+0x62>
      break;
    buf[i++] = c;
 311:	8b 45 f4             	mov    -0xc(%ebp),%eax
 314:	8d 50 01             	lea    0x1(%eax),%edx
 317:	89 55 f4             	mov    %edx,-0xc(%ebp)
 31a:	89 c2                	mov    %eax,%edx
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	01 c2                	add    %eax,%edx
 321:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 325:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 327:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32b:	3c 0a                	cmp    $0xa,%al
 32d:	74 16                	je     345 <gets+0x63>
 32f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 333:	3c 0d                	cmp    $0xd,%al
 335:	74 0e                	je     345 <gets+0x63>
  for(i=0; i+1 < max; ){
 337:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33a:	83 c0 01             	add    $0x1,%eax
 33d:	39 45 0c             	cmp    %eax,0xc(%ebp)
 340:	7f b3                	jg     2f5 <gets+0x13>
 342:	eb 01                	jmp    345 <gets+0x63>
      break;
 344:	90                   	nop
      break;
  }
  buf[i] = '\0';
 345:	8b 55 f4             	mov    -0xc(%ebp),%edx
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	01 d0                	add    %edx,%eax
 34d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <stat>:

int
stat(const char *n, struct stat *st)
{
 355:	f3 0f 1e fb          	endbr32 
 359:	55                   	push   %ebp
 35a:	89 e5                	mov    %esp,%ebp
 35c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35f:	83 ec 08             	sub    $0x8,%esp
 362:	6a 00                	push   $0x0
 364:	ff 75 08             	pushl  0x8(%ebp)
 367:	e8 14 01 00 00       	call   480 <open>
 36c:	83 c4 10             	add    $0x10,%esp
 36f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 376:	79 07                	jns    37f <stat+0x2a>
    return -1;
 378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 37d:	eb 25                	jmp    3a4 <stat+0x4f>
  r = fstat(fd, st);
 37f:	83 ec 08             	sub    $0x8,%esp
 382:	ff 75 0c             	pushl  0xc(%ebp)
 385:	ff 75 f4             	pushl  -0xc(%ebp)
 388:	e8 0b 01 00 00       	call   498 <fstat>
 38d:	83 c4 10             	add    $0x10,%esp
 390:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 393:	83 ec 0c             	sub    $0xc,%esp
 396:	ff 75 f4             	pushl  -0xc(%ebp)
 399:	e8 ca 00 00 00       	call   468 <close>
 39e:	83 c4 10             	add    $0x10,%esp
  return r;
 3a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3a4:	c9                   	leave  
 3a5:	c3                   	ret    

000003a6 <atoi>:

int
atoi(const char *s)
{
 3a6:	f3 0f 1e fb          	endbr32 
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp
 3ad:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3b7:	eb 25                	jmp    3de <atoi+0x38>
    n = n*10 + *s++ - '0';
 3b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3bc:	89 d0                	mov    %edx,%eax
 3be:	c1 e0 02             	shl    $0x2,%eax
 3c1:	01 d0                	add    %edx,%eax
 3c3:	01 c0                	add    %eax,%eax
 3c5:	89 c1                	mov    %eax,%ecx
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	8d 50 01             	lea    0x1(%eax),%edx
 3cd:	89 55 08             	mov    %edx,0x8(%ebp)
 3d0:	0f b6 00             	movzbl (%eax),%eax
 3d3:	0f be c0             	movsbl %al,%eax
 3d6:	01 c8                	add    %ecx,%eax
 3d8:	83 e8 30             	sub    $0x30,%eax
 3db:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	0f b6 00             	movzbl (%eax),%eax
 3e4:	3c 2f                	cmp    $0x2f,%al
 3e6:	7e 0a                	jle    3f2 <atoi+0x4c>
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	0f b6 00             	movzbl (%eax),%eax
 3ee:	3c 39                	cmp    $0x39,%al
 3f0:	7e c7                	jle    3b9 <atoi+0x13>
  return n;
 3f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f5:	c9                   	leave  
 3f6:	c3                   	ret    

000003f7 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f7:	f3 0f 1e fb          	endbr32 
 3fb:	55                   	push   %ebp
 3fc:	89 e5                	mov    %esp,%ebp
 3fe:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 40d:	eb 17                	jmp    426 <memmove+0x2f>
    *dst++ = *src++;
 40f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 412:	8d 42 01             	lea    0x1(%edx),%eax
 415:	89 45 f8             	mov    %eax,-0x8(%ebp)
 418:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41b:	8d 48 01             	lea    0x1(%eax),%ecx
 41e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 421:	0f b6 12             	movzbl (%edx),%edx
 424:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 426:	8b 45 10             	mov    0x10(%ebp),%eax
 429:	8d 50 ff             	lea    -0x1(%eax),%edx
 42c:	89 55 10             	mov    %edx,0x10(%ebp)
 42f:	85 c0                	test   %eax,%eax
 431:	7f dc                	jg     40f <memmove+0x18>
  return vdst;
 433:	8b 45 08             	mov    0x8(%ebp),%eax
}
 436:	c9                   	leave  
 437:	c3                   	ret    

00000438 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 438:	b8 01 00 00 00       	mov    $0x1,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <exit>:
SYSCALL(exit)
 440:	b8 02 00 00 00       	mov    $0x2,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <wait>:
SYSCALL(wait)
 448:	b8 03 00 00 00       	mov    $0x3,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <pipe>:
SYSCALL(pipe)
 450:	b8 04 00 00 00       	mov    $0x4,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <read>:
SYSCALL(read)
 458:	b8 05 00 00 00       	mov    $0x5,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <write>:
SYSCALL(write)
 460:	b8 10 00 00 00       	mov    $0x10,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <close>:
SYSCALL(close)
 468:	b8 15 00 00 00       	mov    $0x15,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <kill>:
SYSCALL(kill)
 470:	b8 06 00 00 00       	mov    $0x6,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <exec>:
SYSCALL(exec)
 478:	b8 07 00 00 00       	mov    $0x7,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <open>:
SYSCALL(open)
 480:	b8 0f 00 00 00       	mov    $0xf,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <mknod>:
SYSCALL(mknod)
 488:	b8 11 00 00 00       	mov    $0x11,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <unlink>:
SYSCALL(unlink)
 490:	b8 12 00 00 00       	mov    $0x12,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <fstat>:
SYSCALL(fstat)
 498:	b8 08 00 00 00       	mov    $0x8,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <link>:
SYSCALL(link)
 4a0:	b8 13 00 00 00       	mov    $0x13,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <mkdir>:
SYSCALL(mkdir)
 4a8:	b8 14 00 00 00       	mov    $0x14,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <chdir>:
SYSCALL(chdir)
 4b0:	b8 09 00 00 00       	mov    $0x9,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <dup>:
SYSCALL(dup)
 4b8:	b8 0a 00 00 00       	mov    $0xa,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <getpid>:
SYSCALL(getpid)
 4c0:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <sbrk>:
SYSCALL(sbrk)
 4c8:	b8 0c 00 00 00       	mov    $0xc,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <sleep>:
SYSCALL(sleep)
 4d0:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <uptime>:
SYSCALL(uptime)
 4d8:	b8 0e 00 00 00       	mov    $0xe,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <mencrypt>:
SYSCALL(mencrypt)
 4e0:	b8 16 00 00 00       	mov    $0x16,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <getpgtable>:
SYSCALL(getpgtable)
 4e8:	b8 17 00 00 00       	mov    $0x17,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 4f0:	b8 18 00 00 00       	mov    $0x18,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4f8:	f3 0f 1e fb          	endbr32 
 4fc:	55                   	push   %ebp
 4fd:	89 e5                	mov    %esp,%ebp
 4ff:	83 ec 18             	sub    $0x18,%esp
 502:	8b 45 0c             	mov    0xc(%ebp),%eax
 505:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 508:	83 ec 04             	sub    $0x4,%esp
 50b:	6a 01                	push   $0x1
 50d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 510:	50                   	push   %eax
 511:	ff 75 08             	pushl  0x8(%ebp)
 514:	e8 47 ff ff ff       	call   460 <write>
 519:	83 c4 10             	add    $0x10,%esp
}
 51c:	90                   	nop
 51d:	c9                   	leave  
 51e:	c3                   	ret    

0000051f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51f:	f3 0f 1e fb          	endbr32 
 523:	55                   	push   %ebp
 524:	89 e5                	mov    %esp,%ebp
 526:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 529:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 530:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 534:	74 17                	je     54d <printint+0x2e>
 536:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 53a:	79 11                	jns    54d <printint+0x2e>
    neg = 1;
 53c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 543:	8b 45 0c             	mov    0xc(%ebp),%eax
 546:	f7 d8                	neg    %eax
 548:	89 45 ec             	mov    %eax,-0x14(%ebp)
 54b:	eb 06                	jmp    553 <printint+0x34>
  } else {
    x = xx;
 54d:	8b 45 0c             	mov    0xc(%ebp),%eax
 550:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 553:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 55a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 55d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 560:	ba 00 00 00 00       	mov    $0x0,%edx
 565:	f7 f1                	div    %ecx
 567:	89 d1                	mov    %edx,%ecx
 569:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56c:	8d 50 01             	lea    0x1(%eax),%edx
 56f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 572:	0f b6 91 44 0c 00 00 	movzbl 0xc44(%ecx),%edx
 579:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 57d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 580:	8b 45 ec             	mov    -0x14(%ebp),%eax
 583:	ba 00 00 00 00       	mov    $0x0,%edx
 588:	f7 f1                	div    %ecx
 58a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 58d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 591:	75 c7                	jne    55a <printint+0x3b>
  if(neg)
 593:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 597:	74 2d                	je     5c6 <printint+0xa7>
    buf[i++] = '-';
 599:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59c:	8d 50 01             	lea    0x1(%eax),%edx
 59f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5a2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5a7:	eb 1d                	jmp    5c6 <printint+0xa7>
    putc(fd, buf[i]);
 5a9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5af:	01 d0                	add    %edx,%eax
 5b1:	0f b6 00             	movzbl (%eax),%eax
 5b4:	0f be c0             	movsbl %al,%eax
 5b7:	83 ec 08             	sub    $0x8,%esp
 5ba:	50                   	push   %eax
 5bb:	ff 75 08             	pushl  0x8(%ebp)
 5be:	e8 35 ff ff ff       	call   4f8 <putc>
 5c3:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 5c6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ce:	79 d9                	jns    5a9 <printint+0x8a>
}
 5d0:	90                   	nop
 5d1:	90                   	nop
 5d2:	c9                   	leave  
 5d3:	c3                   	ret    

000005d4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5d4:	f3 0f 1e fb          	endbr32 
 5d8:	55                   	push   %ebp
 5d9:	89 e5                	mov    %esp,%ebp
 5db:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5e5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5e8:	83 c0 04             	add    $0x4,%eax
 5eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5f5:	e9 59 01 00 00       	jmp    753 <printf+0x17f>
    c = fmt[i] & 0xff;
 5fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 5fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 600:	01 d0                	add    %edx,%eax
 602:	0f b6 00             	movzbl (%eax),%eax
 605:	0f be c0             	movsbl %al,%eax
 608:	25 ff 00 00 00       	and    $0xff,%eax
 60d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 610:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 614:	75 2c                	jne    642 <printf+0x6e>
      if(c == '%'){
 616:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 61a:	75 0c                	jne    628 <printf+0x54>
        state = '%';
 61c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 623:	e9 27 01 00 00       	jmp    74f <printf+0x17b>
      } else {
        putc(fd, c);
 628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62b:	0f be c0             	movsbl %al,%eax
 62e:	83 ec 08             	sub    $0x8,%esp
 631:	50                   	push   %eax
 632:	ff 75 08             	pushl  0x8(%ebp)
 635:	e8 be fe ff ff       	call   4f8 <putc>
 63a:	83 c4 10             	add    $0x10,%esp
 63d:	e9 0d 01 00 00       	jmp    74f <printf+0x17b>
      }
    } else if(state == '%'){
 642:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 646:	0f 85 03 01 00 00    	jne    74f <printf+0x17b>
      if(c == 'd'){
 64c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 650:	75 1e                	jne    670 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 652:	8b 45 e8             	mov    -0x18(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	6a 01                	push   $0x1
 659:	6a 0a                	push   $0xa
 65b:	50                   	push   %eax
 65c:	ff 75 08             	pushl  0x8(%ebp)
 65f:	e8 bb fe ff ff       	call   51f <printint>
 664:	83 c4 10             	add    $0x10,%esp
        ap++;
 667:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66b:	e9 d8 00 00 00       	jmp    748 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 670:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 674:	74 06                	je     67c <printf+0xa8>
 676:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 67a:	75 1e                	jne    69a <printf+0xc6>
        printint(fd, *ap, 16, 0);
 67c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	6a 00                	push   $0x0
 683:	6a 10                	push   $0x10
 685:	50                   	push   %eax
 686:	ff 75 08             	pushl  0x8(%ebp)
 689:	e8 91 fe ff ff       	call   51f <printint>
 68e:	83 c4 10             	add    $0x10,%esp
        ap++;
 691:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 695:	e9 ae 00 00 00       	jmp    748 <printf+0x174>
      } else if(c == 's'){
 69a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 69e:	75 43                	jne    6e3 <printf+0x10f>
        s = (char*)*ap;
 6a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a3:	8b 00                	mov    (%eax),%eax
 6a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6b0:	75 25                	jne    6d7 <printf+0x103>
          s = "(null)";
 6b2:	c7 45 f4 d3 09 00 00 	movl   $0x9d3,-0xc(%ebp)
        while(*s != 0){
 6b9:	eb 1c                	jmp    6d7 <printf+0x103>
          putc(fd, *s);
 6bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6be:	0f b6 00             	movzbl (%eax),%eax
 6c1:	0f be c0             	movsbl %al,%eax
 6c4:	83 ec 08             	sub    $0x8,%esp
 6c7:	50                   	push   %eax
 6c8:	ff 75 08             	pushl  0x8(%ebp)
 6cb:	e8 28 fe ff ff       	call   4f8 <putc>
 6d0:	83 c4 10             	add    $0x10,%esp
          s++;
 6d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6da:	0f b6 00             	movzbl (%eax),%eax
 6dd:	84 c0                	test   %al,%al
 6df:	75 da                	jne    6bb <printf+0xe7>
 6e1:	eb 65                	jmp    748 <printf+0x174>
        }
      } else if(c == 'c'){
 6e3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6e7:	75 1d                	jne    706 <printf+0x132>
        putc(fd, *ap);
 6e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	0f be c0             	movsbl %al,%eax
 6f1:	83 ec 08             	sub    $0x8,%esp
 6f4:	50                   	push   %eax
 6f5:	ff 75 08             	pushl  0x8(%ebp)
 6f8:	e8 fb fd ff ff       	call   4f8 <putc>
 6fd:	83 c4 10             	add    $0x10,%esp
        ap++;
 700:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 704:	eb 42                	jmp    748 <printf+0x174>
      } else if(c == '%'){
 706:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 70a:	75 17                	jne    723 <printf+0x14f>
        putc(fd, c);
 70c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 70f:	0f be c0             	movsbl %al,%eax
 712:	83 ec 08             	sub    $0x8,%esp
 715:	50                   	push   %eax
 716:	ff 75 08             	pushl  0x8(%ebp)
 719:	e8 da fd ff ff       	call   4f8 <putc>
 71e:	83 c4 10             	add    $0x10,%esp
 721:	eb 25                	jmp    748 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 723:	83 ec 08             	sub    $0x8,%esp
 726:	6a 25                	push   $0x25
 728:	ff 75 08             	pushl  0x8(%ebp)
 72b:	e8 c8 fd ff ff       	call   4f8 <putc>
 730:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 736:	0f be c0             	movsbl %al,%eax
 739:	83 ec 08             	sub    $0x8,%esp
 73c:	50                   	push   %eax
 73d:	ff 75 08             	pushl  0x8(%ebp)
 740:	e8 b3 fd ff ff       	call   4f8 <putc>
 745:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 748:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 74f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 753:	8b 55 0c             	mov    0xc(%ebp),%edx
 756:	8b 45 f0             	mov    -0x10(%ebp),%eax
 759:	01 d0                	add    %edx,%eax
 75b:	0f b6 00             	movzbl (%eax),%eax
 75e:	84 c0                	test   %al,%al
 760:	0f 85 94 fe ff ff    	jne    5fa <printf+0x26>
    }
  }
}
 766:	90                   	nop
 767:	90                   	nop
 768:	c9                   	leave  
 769:	c3                   	ret    

0000076a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76a:	f3 0f 1e fb          	endbr32 
 76e:	55                   	push   %ebp
 76f:	89 e5                	mov    %esp,%ebp
 771:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 774:	8b 45 08             	mov    0x8(%ebp),%eax
 777:	83 e8 08             	sub    $0x8,%eax
 77a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77d:	a1 68 0c 00 00       	mov    0xc68,%eax
 782:	89 45 fc             	mov    %eax,-0x4(%ebp)
 785:	eb 24                	jmp    7ab <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	8b 00                	mov    (%eax),%eax
 78c:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 78f:	72 12                	jb     7a3 <free+0x39>
 791:	8b 45 f8             	mov    -0x8(%ebp),%eax
 794:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 797:	77 24                	ja     7bd <free+0x53>
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7a1:	72 1a                	jb     7bd <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	8b 00                	mov    (%eax),%eax
 7a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b1:	76 d4                	jbe    787 <free+0x1d>
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7bb:	73 ca                	jae    787 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c0:	8b 40 04             	mov    0x4(%eax),%eax
 7c3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cd:	01 c2                	add    %eax,%edx
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	8b 00                	mov    (%eax),%eax
 7d4:	39 c2                	cmp    %eax,%edx
 7d6:	75 24                	jne    7fc <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 7d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7db:	8b 50 04             	mov    0x4(%eax),%edx
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	8b 00                	mov    (%eax),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	01 c2                	add    %eax,%edx
 7e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7eb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	8b 10                	mov    (%eax),%edx
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	89 10                	mov    %edx,(%eax)
 7fa:	eb 0a                	jmp    806 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 7fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ff:	8b 10                	mov    (%eax),%edx
 801:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	8b 40 04             	mov    0x4(%eax),%eax
 80c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 813:	8b 45 fc             	mov    -0x4(%ebp),%eax
 816:	01 d0                	add    %edx,%eax
 818:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 81b:	75 20                	jne    83d <free+0xd3>
    p->s.size += bp->s.size;
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 50 04             	mov    0x4(%eax),%edx
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	8b 40 04             	mov    0x4(%eax),%eax
 829:	01 c2                	add    %eax,%edx
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 831:	8b 45 f8             	mov    -0x8(%ebp),%eax
 834:	8b 10                	mov    (%eax),%edx
 836:	8b 45 fc             	mov    -0x4(%ebp),%eax
 839:	89 10                	mov    %edx,(%eax)
 83b:	eb 08                	jmp    845 <free+0xdb>
  } else
    p->s.ptr = bp;
 83d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 840:	8b 55 f8             	mov    -0x8(%ebp),%edx
 843:	89 10                	mov    %edx,(%eax)
  freep = p;
 845:	8b 45 fc             	mov    -0x4(%ebp),%eax
 848:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 84d:	90                   	nop
 84e:	c9                   	leave  
 84f:	c3                   	ret    

00000850 <morecore>:

static Header*
morecore(uint nu)
{
 850:	f3 0f 1e fb          	endbr32 
 854:	55                   	push   %ebp
 855:	89 e5                	mov    %esp,%ebp
 857:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 85a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 861:	77 07                	ja     86a <morecore+0x1a>
    nu = 4096;
 863:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 86a:	8b 45 08             	mov    0x8(%ebp),%eax
 86d:	c1 e0 03             	shl    $0x3,%eax
 870:	83 ec 0c             	sub    $0xc,%esp
 873:	50                   	push   %eax
 874:	e8 4f fc ff ff       	call   4c8 <sbrk>
 879:	83 c4 10             	add    $0x10,%esp
 87c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 87f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 883:	75 07                	jne    88c <morecore+0x3c>
    return 0;
 885:	b8 00 00 00 00       	mov    $0x0,%eax
 88a:	eb 26                	jmp    8b2 <morecore+0x62>
  hp = (Header*)p;
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 892:	8b 45 f0             	mov    -0x10(%ebp),%eax
 895:	8b 55 08             	mov    0x8(%ebp),%edx
 898:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 89b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89e:	83 c0 08             	add    $0x8,%eax
 8a1:	83 ec 0c             	sub    $0xc,%esp
 8a4:	50                   	push   %eax
 8a5:	e8 c0 fe ff ff       	call   76a <free>
 8aa:	83 c4 10             	add    $0x10,%esp
  return freep;
 8ad:	a1 68 0c 00 00       	mov    0xc68,%eax
}
 8b2:	c9                   	leave  
 8b3:	c3                   	ret    

000008b4 <malloc>:

void*
malloc(uint nbytes)
{
 8b4:	f3 0f 1e fb          	endbr32 
 8b8:	55                   	push   %ebp
 8b9:	89 e5                	mov    %esp,%ebp
 8bb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8be:	8b 45 08             	mov    0x8(%ebp),%eax
 8c1:	83 c0 07             	add    $0x7,%eax
 8c4:	c1 e8 03             	shr    $0x3,%eax
 8c7:	83 c0 01             	add    $0x1,%eax
 8ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8cd:	a1 68 0c 00 00       	mov    0xc68,%eax
 8d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d9:	75 23                	jne    8fe <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 8db:	c7 45 f0 60 0c 00 00 	movl   $0xc60,-0x10(%ebp)
 8e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e5:	a3 68 0c 00 00       	mov    %eax,0xc68
 8ea:	a1 68 0c 00 00       	mov    0xc68,%eax
 8ef:	a3 60 0c 00 00       	mov    %eax,0xc60
    base.s.size = 0;
 8f4:	c7 05 64 0c 00 00 00 	movl   $0x0,0xc64
 8fb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 901:	8b 00                	mov    (%eax),%eax
 903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 906:	8b 45 f4             	mov    -0xc(%ebp),%eax
 909:	8b 40 04             	mov    0x4(%eax),%eax
 90c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 90f:	77 4d                	ja     95e <malloc+0xaa>
      if(p->s.size == nunits)
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	8b 40 04             	mov    0x4(%eax),%eax
 917:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 91a:	75 0c                	jne    928 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 91c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91f:	8b 10                	mov    (%eax),%edx
 921:	8b 45 f0             	mov    -0x10(%ebp),%eax
 924:	89 10                	mov    %edx,(%eax)
 926:	eb 26                	jmp    94e <malloc+0x9a>
      else {
        p->s.size -= nunits;
 928:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92b:	8b 40 04             	mov    0x4(%eax),%eax
 92e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 931:	89 c2                	mov    %eax,%edx
 933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 936:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 939:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93c:	8b 40 04             	mov    0x4(%eax),%eax
 93f:	c1 e0 03             	shl    $0x3,%eax
 942:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 945:	8b 45 f4             	mov    -0xc(%ebp),%eax
 948:	8b 55 ec             	mov    -0x14(%ebp),%edx
 94b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 94e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 951:	a3 68 0c 00 00       	mov    %eax,0xc68
      return (void*)(p + 1);
 956:	8b 45 f4             	mov    -0xc(%ebp),%eax
 959:	83 c0 08             	add    $0x8,%eax
 95c:	eb 3b                	jmp    999 <malloc+0xe5>
    }
    if(p == freep)
 95e:	a1 68 0c 00 00       	mov    0xc68,%eax
 963:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 966:	75 1e                	jne    986 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 968:	83 ec 0c             	sub    $0xc,%esp
 96b:	ff 75 ec             	pushl  -0x14(%ebp)
 96e:	e8 dd fe ff ff       	call   850 <morecore>
 973:	83 c4 10             	add    $0x10,%esp
 976:	89 45 f4             	mov    %eax,-0xc(%ebp)
 979:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 97d:	75 07                	jne    986 <malloc+0xd2>
        return 0;
 97f:	b8 00 00 00 00       	mov    $0x0,%eax
 984:	eb 13                	jmp    999 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 986:	8b 45 f4             	mov    -0xc(%ebp),%eax
 989:	89 45 f0             	mov    %eax,-0x10(%ebp)
 98c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98f:	8b 00                	mov    (%eax),%eax
 991:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 994:	e9 6d ff ff ff       	jmp    906 <malloc+0x52>
  }
}
 999:	c9                   	leave  
 99a:	c3                   	ret    
