
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;

  m = 0;
   a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  11:	e9 ae 00 00 00       	jmp    c4 <grep+0xc4>
    m += n;
  16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  19:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1f:	05 60 0e 00 00       	add    $0xe60,%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  27:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2e:	eb 44                	jmp    74 <grep+0x74>
      *q = 0;
  30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  33:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  36:	83 ec 08             	sub    $0x8,%esp
  39:	ff 75 f0             	pushl  -0x10(%ebp)
  3c:	ff 75 08             	pushl  0x8(%ebp)
  3f:	e8 97 01 00 00       	call   1db <match>
  44:	83 c4 10             	add    $0x10,%esp
  47:	85 c0                	test   %eax,%eax
  49:	74 20                	je     6b <grep+0x6b>
        *q = '\n';
  4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4e:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  54:	83 c0 01             	add    $0x1,%eax
  57:	2b 45 f0             	sub    -0x10(%ebp),%eax
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	50                   	push   %eax
  5e:	ff 75 f0             	pushl  -0x10(%ebp)
  61:	6a 01                	push   $0x1
  63:	e8 76 05 00 00       	call   5de <write>
  68:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6e:	83 c0 01             	add    $0x1,%eax
  71:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  74:	83 ec 08             	sub    $0x8,%esp
  77:	6a 0a                	push   $0xa
  79:	ff 75 f0             	pushl  -0x10(%ebp)
  7c:	e8 a8 03 00 00       	call   429 <strchr>
  81:	83 c4 10             	add    $0x10,%esp
  84:	89 45 e8             	mov    %eax,-0x18(%ebp)
  87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8b:	75 a3                	jne    30 <grep+0x30>
    }
    if(p == buf)
  8d:	81 7d f0 60 0e 00 00 	cmpl   $0xe60,-0x10(%ebp)
  94:	75 07                	jne    9d <grep+0x9d>
      m = 0;
  96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a1:	7e 21                	jle    c4 <grep+0xc4>
      m -= p - buf;
  a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a6:	2d 60 0e 00 00       	sub    $0xe60,%eax
  ab:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  ae:	83 ec 04             	sub    $0x4,%esp
  b1:	ff 75 f4             	pushl  -0xc(%ebp)
  b4:	ff 75 f0             	pushl  -0x10(%ebp)
  b7:	68 60 0e 00 00       	push   $0xe60
  bc:	e8 b4 04 00 00       	call   575 <memmove>
  c1:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c7:	ba ff 03 00 00       	mov    $0x3ff,%edx
  cc:	29 c2                	sub    %eax,%edx
  ce:	89 d0                	mov    %edx,%eax
  d0:	89 c2                	mov    %eax,%edx
  d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d5:	05 60 0e 00 00       	add    $0xe60,%eax
  da:	83 ec 04             	sub    $0x4,%esp
  dd:	52                   	push   %edx
  de:	50                   	push   %eax
  df:	ff 75 0c             	pushl  0xc(%ebp)
  e2:	e8 ef 04 00 00       	call   5d6 <read>
  e7:	83 c4 10             	add    $0x10,%esp
  ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f1:	0f 8f 1f ff ff ff    	jg     16 <grep+0x16>
    }
  }
}
  f7:	90                   	nop
  f8:	90                   	nop
  f9:	c9                   	leave  
  fa:	c3                   	ret    

000000fb <main>:

int
main(int argc, char *argv[])
{
  fb:	f3 0f 1e fb          	endbr32 
  ff:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 103:	83 e4 f0             	and    $0xfffffff0,%esp
 106:	ff 71 fc             	pushl  -0x4(%ecx)
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	53                   	push   %ebx
 10d:	51                   	push   %ecx
 10e:	83 ec 10             	sub    $0x10,%esp
 111:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
 113:	83 3b 01             	cmpl   $0x1,(%ebx)
 116:	7f 17                	jg     12f <main+0x34>
    printf(2, "usage: grep pattern [file ...]\n");
 118:	83 ec 08             	sub    $0x8,%esp
 11b:	68 1c 0b 00 00       	push   $0xb1c
 120:	6a 02                	push   $0x2
 122:	e8 2b 06 00 00       	call   752 <printf>
 127:	83 c4 10             	add    $0x10,%esp
    exit();
 12a:	e8 8f 04 00 00       	call   5be <exit>
  }
  pattern = argv[1];
 12f:	8b 43 04             	mov    0x4(%ebx),%eax
 132:	8b 40 04             	mov    0x4(%eax),%eax
 135:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(argc <= 2){
 138:	83 3b 02             	cmpl   $0x2,(%ebx)
 13b:	7f 15                	jg     152 <main+0x57>
    grep(pattern, 0);
 13d:	83 ec 08             	sub    $0x8,%esp
 140:	6a 00                	push   $0x0
 142:	ff 75 f0             	pushl  -0x10(%ebp)
 145:	e8 b6 fe ff ff       	call   0 <grep>
 14a:	83 c4 10             	add    $0x10,%esp
    exit();
 14d:	e8 6c 04 00 00       	call   5be <exit>
  }

  for(i = 2; i < argc; i++){
 152:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 159:	eb 74                	jmp    1cf <main+0xd4>
    if((fd = open(argv[i], 0)) < 0){
 15b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 165:	8b 43 04             	mov    0x4(%ebx),%eax
 168:	01 d0                	add    %edx,%eax
 16a:	8b 00                	mov    (%eax),%eax
 16c:	83 ec 08             	sub    $0x8,%esp
 16f:	6a 00                	push   $0x0
 171:	50                   	push   %eax
 172:	e8 87 04 00 00       	call   5fe <open>
 177:	83 c4 10             	add    $0x10,%esp
 17a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 181:	79 29                	jns    1ac <main+0xb1>
      printf(1, "grep: cannot open %s\n", argv[i]);
 183:	8b 45 f4             	mov    -0xc(%ebp),%eax
 186:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18d:	8b 43 04             	mov    0x4(%ebx),%eax
 190:	01 d0                	add    %edx,%eax
 192:	8b 00                	mov    (%eax),%eax
 194:	83 ec 04             	sub    $0x4,%esp
 197:	50                   	push   %eax
 198:	68 3c 0b 00 00       	push   $0xb3c
 19d:	6a 01                	push   $0x1
 19f:	e8 ae 05 00 00       	call   752 <printf>
 1a4:	83 c4 10             	add    $0x10,%esp
      exit();
 1a7:	e8 12 04 00 00       	call   5be <exit>
    }
    grep(pattern, fd);
 1ac:	83 ec 08             	sub    $0x8,%esp
 1af:	ff 75 ec             	pushl  -0x14(%ebp)
 1b2:	ff 75 f0             	pushl  -0x10(%ebp)
 1b5:	e8 46 fe ff ff       	call   0 <grep>
 1ba:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1bd:	83 ec 0c             	sub    $0xc,%esp
 1c0:	ff 75 ec             	pushl  -0x14(%ebp)
 1c3:	e8 1e 04 00 00       	call   5e6 <close>
 1c8:	83 c4 10             	add    $0x10,%esp
  for(i = 2; i < argc; i++){
 1cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d2:	3b 03                	cmp    (%ebx),%eax
 1d4:	7c 85                	jl     15b <main+0x60>
  }
  exit();
 1d6:	e8 e3 03 00 00       	call   5be <exit>

000001db <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1db:	f3 0f 1e fb          	endbr32 
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	3c 5e                	cmp    $0x5e,%al
 1ed:	75 17                	jne    206 <match+0x2b>
    return matchhere(re+1, text);
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	83 c0 01             	add    $0x1,%eax
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	ff 75 0c             	pushl  0xc(%ebp)
 1fb:	50                   	push   %eax
 1fc:	e8 38 00 00 00       	call   239 <matchhere>
 201:	83 c4 10             	add    $0x10,%esp
 204:	eb 31                	jmp    237 <match+0x5c>
  do{  // must look at empty string
    if(matchhere(re, text))
 206:	83 ec 08             	sub    $0x8,%esp
 209:	ff 75 0c             	pushl  0xc(%ebp)
 20c:	ff 75 08             	pushl  0x8(%ebp)
 20f:	e8 25 00 00 00       	call   239 <matchhere>
 214:	83 c4 10             	add    $0x10,%esp
 217:	85 c0                	test   %eax,%eax
 219:	74 07                	je     222 <match+0x47>
      return 1;
 21b:	b8 01 00 00 00       	mov    $0x1,%eax
 220:	eb 15                	jmp    237 <match+0x5c>
  }while(*text++ != '\0');
 222:	8b 45 0c             	mov    0xc(%ebp),%eax
 225:	8d 50 01             	lea    0x1(%eax),%edx
 228:	89 55 0c             	mov    %edx,0xc(%ebp)
 22b:	0f b6 00             	movzbl (%eax),%eax
 22e:	84 c0                	test   %al,%al
 230:	75 d4                	jne    206 <match+0x2b>
  return 0;
 232:	b8 00 00 00 00       	mov    $0x0,%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 239:	f3 0f 1e fb          	endbr32 
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	84 c0                	test   %al,%al
 24b:	75 0a                	jne    257 <matchhere+0x1e>
    return 1;
 24d:	b8 01 00 00 00       	mov    $0x1,%eax
 252:	e9 99 00 00 00       	jmp    2f0 <matchhere+0xb7>
  if(re[1] == '*')
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	83 c0 01             	add    $0x1,%eax
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	3c 2a                	cmp    $0x2a,%al
 262:	75 21                	jne    285 <matchhere+0x4c>
    return matchstar(re[0], re+2, text);
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	8d 50 02             	lea    0x2(%eax),%edx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	0f be c0             	movsbl %al,%eax
 273:	83 ec 04             	sub    $0x4,%esp
 276:	ff 75 0c             	pushl  0xc(%ebp)
 279:	52                   	push   %edx
 27a:	50                   	push   %eax
 27b:	e8 72 00 00 00       	call   2f2 <matchstar>
 280:	83 c4 10             	add    $0x10,%esp
 283:	eb 6b                	jmp    2f0 <matchhere+0xb7>
  if(re[0] == '$' && re[1] == '\0')
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	0f b6 00             	movzbl (%eax),%eax
 28b:	3c 24                	cmp    $0x24,%al
 28d:	75 1d                	jne    2ac <matchhere+0x73>
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	83 c0 01             	add    $0x1,%eax
 295:	0f b6 00             	movzbl (%eax),%eax
 298:	84 c0                	test   %al,%al
 29a:	75 10                	jne    2ac <matchhere+0x73>
    return *text == '\0';
 29c:	8b 45 0c             	mov    0xc(%ebp),%eax
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	84 c0                	test   %al,%al
 2a4:	0f 94 c0             	sete   %al
 2a7:	0f b6 c0             	movzbl %al,%eax
 2aa:	eb 44                	jmp    2f0 <matchhere+0xb7>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	0f b6 00             	movzbl (%eax),%eax
 2b2:	84 c0                	test   %al,%al
 2b4:	74 35                	je     2eb <matchhere+0xb2>
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 00             	movzbl (%eax),%eax
 2bc:	3c 2e                	cmp    $0x2e,%al
 2be:	74 10                	je     2d0 <matchhere+0x97>
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	0f b6 10             	movzbl (%eax),%edx
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	0f b6 00             	movzbl (%eax),%eax
 2cc:	38 c2                	cmp    %al,%dl
 2ce:	75 1b                	jne    2eb <matchhere+0xb2>
    return matchhere(re+1, text+1);
 2d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d3:	8d 50 01             	lea    0x1(%eax),%edx
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	83 c0 01             	add    $0x1,%eax
 2dc:	83 ec 08             	sub    $0x8,%esp
 2df:	52                   	push   %edx
 2e0:	50                   	push   %eax
 2e1:	e8 53 ff ff ff       	call   239 <matchhere>
 2e6:	83 c4 10             	add    $0x10,%esp
 2e9:	eb 05                	jmp    2f0 <matchhere+0xb7>
  return 0;
 2eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f0:	c9                   	leave  
 2f1:	c3                   	ret    

000002f2 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2f2:	f3 0f 1e fb          	endbr32 
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2fc:	83 ec 08             	sub    $0x8,%esp
 2ff:	ff 75 10             	pushl  0x10(%ebp)
 302:	ff 75 0c             	pushl  0xc(%ebp)
 305:	e8 2f ff ff ff       	call   239 <matchhere>
 30a:	83 c4 10             	add    $0x10,%esp
 30d:	85 c0                	test   %eax,%eax
 30f:	74 07                	je     318 <matchstar+0x26>
      return 1;
 311:	b8 01 00 00 00       	mov    $0x1,%eax
 316:	eb 29                	jmp    341 <matchstar+0x4f>
  }while(*text!='\0' && (*text++==c || c=='.'));
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	0f b6 00             	movzbl (%eax),%eax
 31e:	84 c0                	test   %al,%al
 320:	74 1a                	je     33c <matchstar+0x4a>
 322:	8b 45 10             	mov    0x10(%ebp),%eax
 325:	8d 50 01             	lea    0x1(%eax),%edx
 328:	89 55 10             	mov    %edx,0x10(%ebp)
 32b:	0f b6 00             	movzbl (%eax),%eax
 32e:	0f be c0             	movsbl %al,%eax
 331:	39 45 08             	cmp    %eax,0x8(%ebp)
 334:	74 c6                	je     2fc <matchstar+0xa>
 336:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 33a:	74 c0                	je     2fc <matchstar+0xa>
  return 0;
 33c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
 346:	57                   	push   %edi
 347:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 348:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34b:	8b 55 10             	mov    0x10(%ebp),%edx
 34e:	8b 45 0c             	mov    0xc(%ebp),%eax
 351:	89 cb                	mov    %ecx,%ebx
 353:	89 df                	mov    %ebx,%edi
 355:	89 d1                	mov    %edx,%ecx
 357:	fc                   	cld    
 358:	f3 aa                	rep stos %al,%es:(%edi)
 35a:	89 ca                	mov    %ecx,%edx
 35c:	89 fb                	mov    %edi,%ebx
 35e:	89 5d 08             	mov    %ebx,0x8(%ebp)
 361:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 364:	90                   	nop
 365:	5b                   	pop    %ebx
 366:	5f                   	pop    %edi
 367:	5d                   	pop    %ebp
 368:	c3                   	ret    

00000369 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 369:	f3 0f 1e fb          	endbr32 
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
 370:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 379:	90                   	nop
 37a:	8b 55 0c             	mov    0xc(%ebp),%edx
 37d:	8d 42 01             	lea    0x1(%edx),%eax
 380:	89 45 0c             	mov    %eax,0xc(%ebp)
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	8d 48 01             	lea    0x1(%eax),%ecx
 389:	89 4d 08             	mov    %ecx,0x8(%ebp)
 38c:	0f b6 12             	movzbl (%edx),%edx
 38f:	88 10                	mov    %dl,(%eax)
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	84 c0                	test   %al,%al
 396:	75 e2                	jne    37a <strcpy+0x11>
    ;
  return os;
 398:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 39b:	c9                   	leave  
 39c:	c3                   	ret    

0000039d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39d:	f3 0f 1e fb          	endbr32 
 3a1:	55                   	push   %ebp
 3a2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3a4:	eb 08                	jmp    3ae <strcmp+0x11>
    p++, q++;
 3a6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3aa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 3ae:	8b 45 08             	mov    0x8(%ebp),%eax
 3b1:	0f b6 00             	movzbl (%eax),%eax
 3b4:	84 c0                	test   %al,%al
 3b6:	74 10                	je     3c8 <strcmp+0x2b>
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	0f b6 10             	movzbl (%eax),%edx
 3be:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c1:	0f b6 00             	movzbl (%eax),%eax
 3c4:	38 c2                	cmp    %al,%dl
 3c6:	74 de                	je     3a6 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 3c8:	8b 45 08             	mov    0x8(%ebp),%eax
 3cb:	0f b6 00             	movzbl (%eax),%eax
 3ce:	0f b6 d0             	movzbl %al,%edx
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	0f b6 00             	movzbl (%eax),%eax
 3d7:	0f b6 c0             	movzbl %al,%eax
 3da:	29 c2                	sub    %eax,%edx
 3dc:	89 d0                	mov    %edx,%eax
}
 3de:	5d                   	pop    %ebp
 3df:	c3                   	ret    

000003e0 <strlen>:

uint
strlen(const char *s)
{
 3e0:	f3 0f 1e fb          	endbr32 
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f1:	eb 04                	jmp    3f7 <strlen+0x17>
 3f3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3fa:	8b 45 08             	mov    0x8(%ebp),%eax
 3fd:	01 d0                	add    %edx,%eax
 3ff:	0f b6 00             	movzbl (%eax),%eax
 402:	84 c0                	test   %al,%al
 404:	75 ed                	jne    3f3 <strlen+0x13>
    ;
  return n;
 406:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 409:	c9                   	leave  
 40a:	c3                   	ret    

0000040b <memset>:

void*
memset(void *dst, int c, uint n)
{
 40b:	f3 0f 1e fb          	endbr32 
 40f:	55                   	push   %ebp
 410:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 412:	8b 45 10             	mov    0x10(%ebp),%eax
 415:	50                   	push   %eax
 416:	ff 75 0c             	pushl  0xc(%ebp)
 419:	ff 75 08             	pushl  0x8(%ebp)
 41c:	e8 22 ff ff ff       	call   343 <stosb>
 421:	83 c4 0c             	add    $0xc,%esp
  return dst;
 424:	8b 45 08             	mov    0x8(%ebp),%eax
}
 427:	c9                   	leave  
 428:	c3                   	ret    

00000429 <strchr>:

char*
strchr(const char *s, char c)
{
 429:	f3 0f 1e fb          	endbr32 
 42d:	55                   	push   %ebp
 42e:	89 e5                	mov    %esp,%ebp
 430:	83 ec 04             	sub    $0x4,%esp
 433:	8b 45 0c             	mov    0xc(%ebp),%eax
 436:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 439:	eb 14                	jmp    44f <strchr+0x26>
    if(*s == c)
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	0f b6 00             	movzbl (%eax),%eax
 441:	38 45 fc             	cmp    %al,-0x4(%ebp)
 444:	75 05                	jne    44b <strchr+0x22>
      return (char*)s;
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	eb 13                	jmp    45e <strchr+0x35>
  for(; *s; s++)
 44b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	0f b6 00             	movzbl (%eax),%eax
 455:	84 c0                	test   %al,%al
 457:	75 e2                	jne    43b <strchr+0x12>
  return 0;
 459:	b8 00 00 00 00       	mov    $0x0,%eax
}
 45e:	c9                   	leave  
 45f:	c3                   	ret    

00000460 <gets>:

char*
gets(char *buf, int max)
{
 460:	f3 0f 1e fb          	endbr32 
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 471:	eb 42                	jmp    4b5 <gets+0x55>
    cc = read(0, &c, 1);
 473:	83 ec 04             	sub    $0x4,%esp
 476:	6a 01                	push   $0x1
 478:	8d 45 ef             	lea    -0x11(%ebp),%eax
 47b:	50                   	push   %eax
 47c:	6a 00                	push   $0x0
 47e:	e8 53 01 00 00       	call   5d6 <read>
 483:	83 c4 10             	add    $0x10,%esp
 486:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 489:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48d:	7e 33                	jle    4c2 <gets+0x62>
      break;
    buf[i++] = c;
 48f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 492:	8d 50 01             	lea    0x1(%eax),%edx
 495:	89 55 f4             	mov    %edx,-0xc(%ebp)
 498:	89 c2                	mov    %eax,%edx
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	01 c2                	add    %eax,%edx
 49f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4a3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4a5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4a9:	3c 0a                	cmp    $0xa,%al
 4ab:	74 16                	je     4c3 <gets+0x63>
 4ad:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b1:	3c 0d                	cmp    $0xd,%al
 4b3:	74 0e                	je     4c3 <gets+0x63>
  for(i=0; i+1 < max; ){
 4b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b8:	83 c0 01             	add    $0x1,%eax
 4bb:	39 45 0c             	cmp    %eax,0xc(%ebp)
 4be:	7f b3                	jg     473 <gets+0x13>
 4c0:	eb 01                	jmp    4c3 <gets+0x63>
      break;
 4c2:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4c6:	8b 45 08             	mov    0x8(%ebp),%eax
 4c9:	01 d0                	add    %edx,%eax
 4cb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4d1:	c9                   	leave  
 4d2:	c3                   	ret    

000004d3 <stat>:

int
stat(const char *n, struct stat *st)
{
 4d3:	f3 0f 1e fb          	endbr32 
 4d7:	55                   	push   %ebp
 4d8:	89 e5                	mov    %esp,%ebp
 4da:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4dd:	83 ec 08             	sub    $0x8,%esp
 4e0:	6a 00                	push   $0x0
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	e8 14 01 00 00       	call   5fe <open>
 4ea:	83 c4 10             	add    $0x10,%esp
 4ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f4:	79 07                	jns    4fd <stat+0x2a>
    return -1;
 4f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4fb:	eb 25                	jmp    522 <stat+0x4f>
  r = fstat(fd, st);
 4fd:	83 ec 08             	sub    $0x8,%esp
 500:	ff 75 0c             	pushl  0xc(%ebp)
 503:	ff 75 f4             	pushl  -0xc(%ebp)
 506:	e8 0b 01 00 00       	call   616 <fstat>
 50b:	83 c4 10             	add    $0x10,%esp
 50e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 511:	83 ec 0c             	sub    $0xc,%esp
 514:	ff 75 f4             	pushl  -0xc(%ebp)
 517:	e8 ca 00 00 00       	call   5e6 <close>
 51c:	83 c4 10             	add    $0x10,%esp
  return r;
 51f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 522:	c9                   	leave  
 523:	c3                   	ret    

00000524 <atoi>:

int
atoi(const char *s)
{
 524:	f3 0f 1e fb          	endbr32 
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 52e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 535:	eb 25                	jmp    55c <atoi+0x38>
    n = n*10 + *s++ - '0';
 537:	8b 55 fc             	mov    -0x4(%ebp),%edx
 53a:	89 d0                	mov    %edx,%eax
 53c:	c1 e0 02             	shl    $0x2,%eax
 53f:	01 d0                	add    %edx,%eax
 541:	01 c0                	add    %eax,%eax
 543:	89 c1                	mov    %eax,%ecx
 545:	8b 45 08             	mov    0x8(%ebp),%eax
 548:	8d 50 01             	lea    0x1(%eax),%edx
 54b:	89 55 08             	mov    %edx,0x8(%ebp)
 54e:	0f b6 00             	movzbl (%eax),%eax
 551:	0f be c0             	movsbl %al,%eax
 554:	01 c8                	add    %ecx,%eax
 556:	83 e8 30             	sub    $0x30,%eax
 559:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	0f b6 00             	movzbl (%eax),%eax
 562:	3c 2f                	cmp    $0x2f,%al
 564:	7e 0a                	jle    570 <atoi+0x4c>
 566:	8b 45 08             	mov    0x8(%ebp),%eax
 569:	0f b6 00             	movzbl (%eax),%eax
 56c:	3c 39                	cmp    $0x39,%al
 56e:	7e c7                	jle    537 <atoi+0x13>
  return n;
 570:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 573:	c9                   	leave  
 574:	c3                   	ret    

00000575 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 575:	f3 0f 1e fb          	endbr32 
 579:	55                   	push   %ebp
 57a:	89 e5                	mov    %esp,%ebp
 57c:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 585:	8b 45 0c             	mov    0xc(%ebp),%eax
 588:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 58b:	eb 17                	jmp    5a4 <memmove+0x2f>
    *dst++ = *src++;
 58d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 590:	8d 42 01             	lea    0x1(%edx),%eax
 593:	89 45 f8             	mov    %eax,-0x8(%ebp)
 596:	8b 45 fc             	mov    -0x4(%ebp),%eax
 599:	8d 48 01             	lea    0x1(%eax),%ecx
 59c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 59f:	0f b6 12             	movzbl (%edx),%edx
 5a2:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 5a4:	8b 45 10             	mov    0x10(%ebp),%eax
 5a7:	8d 50 ff             	lea    -0x1(%eax),%edx
 5aa:	89 55 10             	mov    %edx,0x10(%ebp)
 5ad:	85 c0                	test   %eax,%eax
 5af:	7f dc                	jg     58d <memmove+0x18>
  return vdst;
 5b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b4:	c9                   	leave  
 5b5:	c3                   	ret    

000005b6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5b6:	b8 01 00 00 00       	mov    $0x1,%eax
 5bb:	cd 40                	int    $0x40
 5bd:	c3                   	ret    

000005be <exit>:
SYSCALL(exit)
 5be:	b8 02 00 00 00       	mov    $0x2,%eax
 5c3:	cd 40                	int    $0x40
 5c5:	c3                   	ret    

000005c6 <wait>:
SYSCALL(wait)
 5c6:	b8 03 00 00 00       	mov    $0x3,%eax
 5cb:	cd 40                	int    $0x40
 5cd:	c3                   	ret    

000005ce <pipe>:
SYSCALL(pipe)
 5ce:	b8 04 00 00 00       	mov    $0x4,%eax
 5d3:	cd 40                	int    $0x40
 5d5:	c3                   	ret    

000005d6 <read>:
SYSCALL(read)
 5d6:	b8 05 00 00 00       	mov    $0x5,%eax
 5db:	cd 40                	int    $0x40
 5dd:	c3                   	ret    

000005de <write>:
SYSCALL(write)
 5de:	b8 10 00 00 00       	mov    $0x10,%eax
 5e3:	cd 40                	int    $0x40
 5e5:	c3                   	ret    

000005e6 <close>:
SYSCALL(close)
 5e6:	b8 15 00 00 00       	mov    $0x15,%eax
 5eb:	cd 40                	int    $0x40
 5ed:	c3                   	ret    

000005ee <kill>:
SYSCALL(kill)
 5ee:	b8 06 00 00 00       	mov    $0x6,%eax
 5f3:	cd 40                	int    $0x40
 5f5:	c3                   	ret    

000005f6 <exec>:
SYSCALL(exec)
 5f6:	b8 07 00 00 00       	mov    $0x7,%eax
 5fb:	cd 40                	int    $0x40
 5fd:	c3                   	ret    

000005fe <open>:
SYSCALL(open)
 5fe:	b8 0f 00 00 00       	mov    $0xf,%eax
 603:	cd 40                	int    $0x40
 605:	c3                   	ret    

00000606 <mknod>:
SYSCALL(mknod)
 606:	b8 11 00 00 00       	mov    $0x11,%eax
 60b:	cd 40                	int    $0x40
 60d:	c3                   	ret    

0000060e <unlink>:
SYSCALL(unlink)
 60e:	b8 12 00 00 00       	mov    $0x12,%eax
 613:	cd 40                	int    $0x40
 615:	c3                   	ret    

00000616 <fstat>:
SYSCALL(fstat)
 616:	b8 08 00 00 00       	mov    $0x8,%eax
 61b:	cd 40                	int    $0x40
 61d:	c3                   	ret    

0000061e <link>:
SYSCALL(link)
 61e:	b8 13 00 00 00       	mov    $0x13,%eax
 623:	cd 40                	int    $0x40
 625:	c3                   	ret    

00000626 <mkdir>:
SYSCALL(mkdir)
 626:	b8 14 00 00 00       	mov    $0x14,%eax
 62b:	cd 40                	int    $0x40
 62d:	c3                   	ret    

0000062e <chdir>:
SYSCALL(chdir)
 62e:	b8 09 00 00 00       	mov    $0x9,%eax
 633:	cd 40                	int    $0x40
 635:	c3                   	ret    

00000636 <dup>:
SYSCALL(dup)
 636:	b8 0a 00 00 00       	mov    $0xa,%eax
 63b:	cd 40                	int    $0x40
 63d:	c3                   	ret    

0000063e <getpid>:
SYSCALL(getpid)
 63e:	b8 0b 00 00 00       	mov    $0xb,%eax
 643:	cd 40                	int    $0x40
 645:	c3                   	ret    

00000646 <sbrk>:
SYSCALL(sbrk)
 646:	b8 0c 00 00 00       	mov    $0xc,%eax
 64b:	cd 40                	int    $0x40
 64d:	c3                   	ret    

0000064e <sleep>:
SYSCALL(sleep)
 64e:	b8 0d 00 00 00       	mov    $0xd,%eax
 653:	cd 40                	int    $0x40
 655:	c3                   	ret    

00000656 <uptime>:
SYSCALL(uptime)
 656:	b8 0e 00 00 00       	mov    $0xe,%eax
 65b:	cd 40                	int    $0x40
 65d:	c3                   	ret    

0000065e <mencrypt>:
SYSCALL(mencrypt)
 65e:	b8 16 00 00 00       	mov    $0x16,%eax
 663:	cd 40                	int    $0x40
 665:	c3                   	ret    

00000666 <getpgtable>:
SYSCALL(getpgtable)
 666:	b8 17 00 00 00       	mov    $0x17,%eax
 66b:	cd 40                	int    $0x40
 66d:	c3                   	ret    

0000066e <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 66e:	b8 18 00 00 00       	mov    $0x18,%eax
 673:	cd 40                	int    $0x40
 675:	c3                   	ret    

00000676 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 676:	f3 0f 1e fb          	endbr32 
 67a:	55                   	push   %ebp
 67b:	89 e5                	mov    %esp,%ebp
 67d:	83 ec 18             	sub    $0x18,%esp
 680:	8b 45 0c             	mov    0xc(%ebp),%eax
 683:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 686:	83 ec 04             	sub    $0x4,%esp
 689:	6a 01                	push   $0x1
 68b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 68e:	50                   	push   %eax
 68f:	ff 75 08             	pushl  0x8(%ebp)
 692:	e8 47 ff ff ff       	call   5de <write>
 697:	83 c4 10             	add    $0x10,%esp
}
 69a:	90                   	nop
 69b:	c9                   	leave  
 69c:	c3                   	ret    

0000069d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 69d:	f3 0f 1e fb          	endbr32 
 6a1:	55                   	push   %ebp
 6a2:	89 e5                	mov    %esp,%ebp
 6a4:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6ae:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6b2:	74 17                	je     6cb <printint+0x2e>
 6b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6b8:	79 11                	jns    6cb <printint+0x2e>
    neg = 1;
 6ba:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c4:	f7 d8                	neg    %eax
 6c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6c9:	eb 06                	jmp    6d1 <printint+0x34>
  } else {
    x = xx;
 6cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6db:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6de:	ba 00 00 00 00       	mov    $0x0,%edx
 6e3:	f7 f1                	div    %ecx
 6e5:	89 d1                	mov    %edx,%ecx
 6e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ea:	8d 50 01             	lea    0x1(%eax),%edx
 6ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6f0:	0f b6 91 24 0e 00 00 	movzbl 0xe24(%ecx),%edx
 6f7:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 6fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 701:	ba 00 00 00 00       	mov    $0x0,%edx
 706:	f7 f1                	div    %ecx
 708:	89 45 ec             	mov    %eax,-0x14(%ebp)
 70b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 70f:	75 c7                	jne    6d8 <printint+0x3b>
  if(neg)
 711:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 715:	74 2d                	je     744 <printint+0xa7>
    buf[i++] = '-';
 717:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71a:	8d 50 01             	lea    0x1(%eax),%edx
 71d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 720:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 725:	eb 1d                	jmp    744 <printint+0xa7>
    putc(fd, buf[i]);
 727:	8d 55 dc             	lea    -0x24(%ebp),%edx
 72a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72d:	01 d0                	add    %edx,%eax
 72f:	0f b6 00             	movzbl (%eax),%eax
 732:	0f be c0             	movsbl %al,%eax
 735:	83 ec 08             	sub    $0x8,%esp
 738:	50                   	push   %eax
 739:	ff 75 08             	pushl  0x8(%ebp)
 73c:	e8 35 ff ff ff       	call   676 <putc>
 741:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 744:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 748:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 74c:	79 d9                	jns    727 <printint+0x8a>
}
 74e:	90                   	nop
 74f:	90                   	nop
 750:	c9                   	leave  
 751:	c3                   	ret    

00000752 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 752:	f3 0f 1e fb          	endbr32 
 756:	55                   	push   %ebp
 757:	89 e5                	mov    %esp,%ebp
 759:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 75c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 763:	8d 45 0c             	lea    0xc(%ebp),%eax
 766:	83 c0 04             	add    $0x4,%eax
 769:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 76c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 773:	e9 59 01 00 00       	jmp    8d1 <printf+0x17f>
    c = fmt[i] & 0xff;
 778:	8b 55 0c             	mov    0xc(%ebp),%edx
 77b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77e:	01 d0                	add    %edx,%eax
 780:	0f b6 00             	movzbl (%eax),%eax
 783:	0f be c0             	movsbl %al,%eax
 786:	25 ff 00 00 00       	and    $0xff,%eax
 78b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 78e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 792:	75 2c                	jne    7c0 <printf+0x6e>
      if(c == '%'){
 794:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 798:	75 0c                	jne    7a6 <printf+0x54>
        state = '%';
 79a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7a1:	e9 27 01 00 00       	jmp    8cd <printf+0x17b>
      } else {
        putc(fd, c);
 7a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a9:	0f be c0             	movsbl %al,%eax
 7ac:	83 ec 08             	sub    $0x8,%esp
 7af:	50                   	push   %eax
 7b0:	ff 75 08             	pushl  0x8(%ebp)
 7b3:	e8 be fe ff ff       	call   676 <putc>
 7b8:	83 c4 10             	add    $0x10,%esp
 7bb:	e9 0d 01 00 00       	jmp    8cd <printf+0x17b>
      }
    } else if(state == '%'){
 7c0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7c4:	0f 85 03 01 00 00    	jne    8cd <printf+0x17b>
      if(c == 'd'){
 7ca:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7ce:	75 1e                	jne    7ee <printf+0x9c>
        printint(fd, *ap, 10, 1);
 7d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	6a 01                	push   $0x1
 7d7:	6a 0a                	push   $0xa
 7d9:	50                   	push   %eax
 7da:	ff 75 08             	pushl  0x8(%ebp)
 7dd:	e8 bb fe ff ff       	call   69d <printint>
 7e2:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e9:	e9 d8 00 00 00       	jmp    8c6 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 7ee:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7f2:	74 06                	je     7fa <printf+0xa8>
 7f4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7f8:	75 1e                	jne    818 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 7fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7fd:	8b 00                	mov    (%eax),%eax
 7ff:	6a 00                	push   $0x0
 801:	6a 10                	push   $0x10
 803:	50                   	push   %eax
 804:	ff 75 08             	pushl  0x8(%ebp)
 807:	e8 91 fe ff ff       	call   69d <printint>
 80c:	83 c4 10             	add    $0x10,%esp
        ap++;
 80f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 813:	e9 ae 00 00 00       	jmp    8c6 <printf+0x174>
      } else if(c == 's'){
 818:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 81c:	75 43                	jne    861 <printf+0x10f>
        s = (char*)*ap;
 81e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 821:	8b 00                	mov    (%eax),%eax
 823:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 826:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 82a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 82e:	75 25                	jne    855 <printf+0x103>
          s = "(null)";
 830:	c7 45 f4 52 0b 00 00 	movl   $0xb52,-0xc(%ebp)
        while(*s != 0){
 837:	eb 1c                	jmp    855 <printf+0x103>
          putc(fd, *s);
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	0f b6 00             	movzbl (%eax),%eax
 83f:	0f be c0             	movsbl %al,%eax
 842:	83 ec 08             	sub    $0x8,%esp
 845:	50                   	push   %eax
 846:	ff 75 08             	pushl  0x8(%ebp)
 849:	e8 28 fe ff ff       	call   676 <putc>
 84e:	83 c4 10             	add    $0x10,%esp
          s++;
 851:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	0f b6 00             	movzbl (%eax),%eax
 85b:	84 c0                	test   %al,%al
 85d:	75 da                	jne    839 <printf+0xe7>
 85f:	eb 65                	jmp    8c6 <printf+0x174>
        }
      } else if(c == 'c'){
 861:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 865:	75 1d                	jne    884 <printf+0x132>
        putc(fd, *ap);
 867:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86a:	8b 00                	mov    (%eax),%eax
 86c:	0f be c0             	movsbl %al,%eax
 86f:	83 ec 08             	sub    $0x8,%esp
 872:	50                   	push   %eax
 873:	ff 75 08             	pushl  0x8(%ebp)
 876:	e8 fb fd ff ff       	call   676 <putc>
 87b:	83 c4 10             	add    $0x10,%esp
        ap++;
 87e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 882:	eb 42                	jmp    8c6 <printf+0x174>
      } else if(c == '%'){
 884:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 888:	75 17                	jne    8a1 <printf+0x14f>
        putc(fd, c);
 88a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 88d:	0f be c0             	movsbl %al,%eax
 890:	83 ec 08             	sub    $0x8,%esp
 893:	50                   	push   %eax
 894:	ff 75 08             	pushl  0x8(%ebp)
 897:	e8 da fd ff ff       	call   676 <putc>
 89c:	83 c4 10             	add    $0x10,%esp
 89f:	eb 25                	jmp    8c6 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8a1:	83 ec 08             	sub    $0x8,%esp
 8a4:	6a 25                	push   $0x25
 8a6:	ff 75 08             	pushl  0x8(%ebp)
 8a9:	e8 c8 fd ff ff       	call   676 <putc>
 8ae:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b4:	0f be c0             	movsbl %al,%eax
 8b7:	83 ec 08             	sub    $0x8,%esp
 8ba:	50                   	push   %eax
 8bb:	ff 75 08             	pushl  0x8(%ebp)
 8be:	e8 b3 fd ff ff       	call   676 <putc>
 8c3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 8cd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8d1:	8b 55 0c             	mov    0xc(%ebp),%edx
 8d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d7:	01 d0                	add    %edx,%eax
 8d9:	0f b6 00             	movzbl (%eax),%eax
 8dc:	84 c0                	test   %al,%al
 8de:	0f 85 94 fe ff ff    	jne    778 <printf+0x26>
    }
  }
}
 8e4:	90                   	nop
 8e5:	90                   	nop
 8e6:	c9                   	leave  
 8e7:	c3                   	ret    

000008e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e8:	f3 0f 1e fb          	endbr32 
 8ec:	55                   	push   %ebp
 8ed:	89 e5                	mov    %esp,%ebp
 8ef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8f2:	8b 45 08             	mov    0x8(%ebp),%eax
 8f5:	83 e8 08             	sub    $0x8,%eax
 8f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fb:	a1 48 0e 00 00       	mov    0xe48,%eax
 900:	89 45 fc             	mov    %eax,-0x4(%ebp)
 903:	eb 24                	jmp    929 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	8b 00                	mov    (%eax),%eax
 90a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 90d:	72 12                	jb     921 <free+0x39>
 90f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 912:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 915:	77 24                	ja     93b <free+0x53>
 917:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91a:	8b 00                	mov    (%eax),%eax
 91c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 91f:	72 1a                	jb     93b <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 921:	8b 45 fc             	mov    -0x4(%ebp),%eax
 924:	8b 00                	mov    (%eax),%eax
 926:	89 45 fc             	mov    %eax,-0x4(%ebp)
 929:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 92f:	76 d4                	jbe    905 <free+0x1d>
 931:	8b 45 fc             	mov    -0x4(%ebp),%eax
 934:	8b 00                	mov    (%eax),%eax
 936:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 939:	73 ca                	jae    905 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 93b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93e:	8b 40 04             	mov    0x4(%eax),%eax
 941:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 948:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94b:	01 c2                	add    %eax,%edx
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	8b 00                	mov    (%eax),%eax
 952:	39 c2                	cmp    %eax,%edx
 954:	75 24                	jne    97a <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 956:	8b 45 f8             	mov    -0x8(%ebp),%eax
 959:	8b 50 04             	mov    0x4(%eax),%edx
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	8b 00                	mov    (%eax),%eax
 961:	8b 40 04             	mov    0x4(%eax),%eax
 964:	01 c2                	add    %eax,%edx
 966:	8b 45 f8             	mov    -0x8(%ebp),%eax
 969:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 96c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96f:	8b 00                	mov    (%eax),%eax
 971:	8b 10                	mov    (%eax),%edx
 973:	8b 45 f8             	mov    -0x8(%ebp),%eax
 976:	89 10                	mov    %edx,(%eax)
 978:	eb 0a                	jmp    984 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 97a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97d:	8b 10                	mov    (%eax),%edx
 97f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 982:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 984:	8b 45 fc             	mov    -0x4(%ebp),%eax
 987:	8b 40 04             	mov    0x4(%eax),%eax
 98a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 991:	8b 45 fc             	mov    -0x4(%ebp),%eax
 994:	01 d0                	add    %edx,%eax
 996:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 999:	75 20                	jne    9bb <free+0xd3>
    p->s.size += bp->s.size;
 99b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99e:	8b 50 04             	mov    0x4(%eax),%edx
 9a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a4:	8b 40 04             	mov    0x4(%eax),%eax
 9a7:	01 c2                	add    %eax,%edx
 9a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ac:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b2:	8b 10                	mov    (%eax),%edx
 9b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b7:	89 10                	mov    %edx,(%eax)
 9b9:	eb 08                	jmp    9c3 <free+0xdb>
  } else
    p->s.ptr = bp;
 9bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9be:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9c1:	89 10                	mov    %edx,(%eax)
  freep = p;
 9c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c6:	a3 48 0e 00 00       	mov    %eax,0xe48
}
 9cb:	90                   	nop
 9cc:	c9                   	leave  
 9cd:	c3                   	ret    

000009ce <morecore>:

static Header*
morecore(uint nu)
{
 9ce:	f3 0f 1e fb          	endbr32 
 9d2:	55                   	push   %ebp
 9d3:	89 e5                	mov    %esp,%ebp
 9d5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9d8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9df:	77 07                	ja     9e8 <morecore+0x1a>
    nu = 4096;
 9e1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9e8:	8b 45 08             	mov    0x8(%ebp),%eax
 9eb:	c1 e0 03             	shl    $0x3,%eax
 9ee:	83 ec 0c             	sub    $0xc,%esp
 9f1:	50                   	push   %eax
 9f2:	e8 4f fc ff ff       	call   646 <sbrk>
 9f7:	83 c4 10             	add    $0x10,%esp
 9fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9fd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a01:	75 07                	jne    a0a <morecore+0x3c>
    return 0;
 a03:	b8 00 00 00 00       	mov    $0x0,%eax
 a08:	eb 26                	jmp    a30 <morecore+0x62>
  hp = (Header*)p;
 a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a13:	8b 55 08             	mov    0x8(%ebp),%edx
 a16:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1c:	83 c0 08             	add    $0x8,%eax
 a1f:	83 ec 0c             	sub    $0xc,%esp
 a22:	50                   	push   %eax
 a23:	e8 c0 fe ff ff       	call   8e8 <free>
 a28:	83 c4 10             	add    $0x10,%esp
  return freep;
 a2b:	a1 48 0e 00 00       	mov    0xe48,%eax
}
 a30:	c9                   	leave  
 a31:	c3                   	ret    

00000a32 <malloc>:

void*
malloc(uint nbytes)
{
 a32:	f3 0f 1e fb          	endbr32 
 a36:	55                   	push   %ebp
 a37:	89 e5                	mov    %esp,%ebp
 a39:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a3c:	8b 45 08             	mov    0x8(%ebp),%eax
 a3f:	83 c0 07             	add    $0x7,%eax
 a42:	c1 e8 03             	shr    $0x3,%eax
 a45:	83 c0 01             	add    $0x1,%eax
 a48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a4b:	a1 48 0e 00 00       	mov    0xe48,%eax
 a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a57:	75 23                	jne    a7c <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 a59:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
 a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a63:	a3 48 0e 00 00       	mov    %eax,0xe48
 a68:	a1 48 0e 00 00       	mov    0xe48,%eax
 a6d:	a3 40 0e 00 00       	mov    %eax,0xe40
    base.s.size = 0;
 a72:	c7 05 44 0e 00 00 00 	movl   $0x0,0xe44
 a79:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7f:	8b 00                	mov    (%eax),%eax
 a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a87:	8b 40 04             	mov    0x4(%eax),%eax
 a8a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a8d:	77 4d                	ja     adc <malloc+0xaa>
      if(p->s.size == nunits)
 a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a92:	8b 40 04             	mov    0x4(%eax),%eax
 a95:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a98:	75 0c                	jne    aa6 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9d:	8b 10                	mov    (%eax),%edx
 a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa2:	89 10                	mov    %edx,(%eax)
 aa4:	eb 26                	jmp    acc <malloc+0x9a>
      else {
        p->s.size -= nunits;
 aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa9:	8b 40 04             	mov    0x4(%eax),%eax
 aac:	2b 45 ec             	sub    -0x14(%ebp),%eax
 aaf:	89 c2                	mov    %eax,%edx
 ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	8b 40 04             	mov    0x4(%eax),%eax
 abd:	c1 e0 03             	shl    $0x3,%eax
 ac0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ac9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 acf:	a3 48 0e 00 00       	mov    %eax,0xe48
      return (void*)(p + 1);
 ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad7:	83 c0 08             	add    $0x8,%eax
 ada:	eb 3b                	jmp    b17 <malloc+0xe5>
    }
    if(p == freep)
 adc:	a1 48 0e 00 00       	mov    0xe48,%eax
 ae1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ae4:	75 1e                	jne    b04 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 ae6:	83 ec 0c             	sub    $0xc,%esp
 ae9:	ff 75 ec             	pushl  -0x14(%ebp)
 aec:	e8 dd fe ff ff       	call   9ce <morecore>
 af1:	83 c4 10             	add    $0x10,%esp
 af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 afb:	75 07                	jne    b04 <malloc+0xd2>
        return 0;
 afd:	b8 00 00 00 00       	mov    $0x0,%eax
 b02:	eb 13                	jmp    b17 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0d:	8b 00                	mov    (%eax),%eax
 b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b12:	e9 6d ff ff ff       	jmp    a84 <malloc+0x52>
  }
}
 b17:	c9                   	leave  
 b18:	c3                   	ret    
