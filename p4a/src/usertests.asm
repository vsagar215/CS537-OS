
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	f3 0f 1e fb          	endbr32 
       4:	55                   	push   %ebp
       5:	89 e5                	mov    %esp,%ebp
       7:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "iput test\n");
       a:	a1 60 65 00 00       	mov    0x6560,%eax
       f:	83 ec 08             	sub    $0x8,%esp
      12:	68 22 46 00 00       	push   $0x4622
      17:	50                   	push   %eax
      18:	e8 26 42 00 00       	call   4243 <printf>
      1d:	83 c4 10             	add    $0x10,%esp

  if(mkdir("iputdir") < 0){
      20:	83 ec 0c             	sub    $0xc,%esp
      23:	68 2d 46 00 00       	push   $0x462d
      28:	e8 ea 40 00 00       	call   4117 <mkdir>
      2d:	83 c4 10             	add    $0x10,%esp
      30:	85 c0                	test   %eax,%eax
      32:	79 1b                	jns    4f <iputtest+0x4f>
    printf(stdout, "mkdir failed\n");
      34:	a1 60 65 00 00       	mov    0x6560,%eax
      39:	83 ec 08             	sub    $0x8,%esp
      3c:	68 35 46 00 00       	push   $0x4635
      41:	50                   	push   %eax
      42:	e8 fc 41 00 00       	call   4243 <printf>
      47:	83 c4 10             	add    $0x10,%esp
    exit();
      4a:	e8 60 40 00 00       	call   40af <exit>
  }
  if(chdir("iputdir") < 0){
      4f:	83 ec 0c             	sub    $0xc,%esp
      52:	68 2d 46 00 00       	push   $0x462d
      57:	e8 c3 40 00 00       	call   411f <chdir>
      5c:	83 c4 10             	add    $0x10,%esp
      5f:	85 c0                	test   %eax,%eax
      61:	79 1b                	jns    7e <iputtest+0x7e>
    printf(stdout, "chdir iputdir failed\n");
      63:	a1 60 65 00 00       	mov    0x6560,%eax
      68:	83 ec 08             	sub    $0x8,%esp
      6b:	68 43 46 00 00       	push   $0x4643
      70:	50                   	push   %eax
      71:	e8 cd 41 00 00       	call   4243 <printf>
      76:	83 c4 10             	add    $0x10,%esp
    exit();
      79:	e8 31 40 00 00       	call   40af <exit>
  }
  if(unlink("../iputdir") < 0){
      7e:	83 ec 0c             	sub    $0xc,%esp
      81:	68 59 46 00 00       	push   $0x4659
      86:	e8 74 40 00 00       	call   40ff <unlink>
      8b:	83 c4 10             	add    $0x10,%esp
      8e:	85 c0                	test   %eax,%eax
      90:	79 1b                	jns    ad <iputtest+0xad>
    printf(stdout, "unlink ../iputdir failed\n");
      92:	a1 60 65 00 00       	mov    0x6560,%eax
      97:	83 ec 08             	sub    $0x8,%esp
      9a:	68 64 46 00 00       	push   $0x4664
      9f:	50                   	push   %eax
      a0:	e8 9e 41 00 00       	call   4243 <printf>
      a5:	83 c4 10             	add    $0x10,%esp
    exit();
      a8:	e8 02 40 00 00       	call   40af <exit>
  }
  if(chdir("/") < 0){
      ad:	83 ec 0c             	sub    $0xc,%esp
      b0:	68 7e 46 00 00       	push   $0x467e
      b5:	e8 65 40 00 00       	call   411f <chdir>
      ba:	83 c4 10             	add    $0x10,%esp
      bd:	85 c0                	test   %eax,%eax
      bf:	79 1b                	jns    dc <iputtest+0xdc>
    printf(stdout, "chdir / failed\n");
      c1:	a1 60 65 00 00       	mov    0x6560,%eax
      c6:	83 ec 08             	sub    $0x8,%esp
      c9:	68 80 46 00 00       	push   $0x4680
      ce:	50                   	push   %eax
      cf:	e8 6f 41 00 00       	call   4243 <printf>
      d4:	83 c4 10             	add    $0x10,%esp
    exit();
      d7:	e8 d3 3f 00 00       	call   40af <exit>
  }
  printf(stdout, "iput test ok\n");
      dc:	a1 60 65 00 00       	mov    0x6560,%eax
      e1:	83 ec 08             	sub    $0x8,%esp
      e4:	68 90 46 00 00       	push   $0x4690
      e9:	50                   	push   %eax
      ea:	e8 54 41 00 00       	call   4243 <printf>
      ef:	83 c4 10             	add    $0x10,%esp
}
      f2:	90                   	nop
      f3:	c9                   	leave  
      f4:	c3                   	ret    

000000f5 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      f5:	f3 0f 1e fb          	endbr32 
      f9:	55                   	push   %ebp
      fa:	89 e5                	mov    %esp,%ebp
      fc:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      ff:	a1 60 65 00 00       	mov    0x6560,%eax
     104:	83 ec 08             	sub    $0x8,%esp
     107:	68 9e 46 00 00       	push   $0x469e
     10c:	50                   	push   %eax
     10d:	e8 31 41 00 00       	call   4243 <printf>
     112:	83 c4 10             	add    $0x10,%esp

  pid = fork();
     115:	e8 8d 3f 00 00       	call   40a7 <fork>
     11a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     11d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     121:	79 1b                	jns    13e <exitiputtest+0x49>
    printf(stdout, "fork failed\n");
     123:	a1 60 65 00 00       	mov    0x6560,%eax
     128:	83 ec 08             	sub    $0x8,%esp
     12b:	68 ad 46 00 00       	push   $0x46ad
     130:	50                   	push   %eax
     131:	e8 0d 41 00 00       	call   4243 <printf>
     136:	83 c4 10             	add    $0x10,%esp
    exit();
     139:	e8 71 3f 00 00       	call   40af <exit>
  }
  if(pid == 0){
     13e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     142:	0f 85 92 00 00 00    	jne    1da <exitiputtest+0xe5>
    if(mkdir("iputdir") < 0){
     148:	83 ec 0c             	sub    $0xc,%esp
     14b:	68 2d 46 00 00       	push   $0x462d
     150:	e8 c2 3f 00 00       	call   4117 <mkdir>
     155:	83 c4 10             	add    $0x10,%esp
     158:	85 c0                	test   %eax,%eax
     15a:	79 1b                	jns    177 <exitiputtest+0x82>
      printf(stdout, "mkdir failed\n");
     15c:	a1 60 65 00 00       	mov    0x6560,%eax
     161:	83 ec 08             	sub    $0x8,%esp
     164:	68 35 46 00 00       	push   $0x4635
     169:	50                   	push   %eax
     16a:	e8 d4 40 00 00       	call   4243 <printf>
     16f:	83 c4 10             	add    $0x10,%esp
      exit();
     172:	e8 38 3f 00 00       	call   40af <exit>
    }
    if(chdir("iputdir") < 0){
     177:	83 ec 0c             	sub    $0xc,%esp
     17a:	68 2d 46 00 00       	push   $0x462d
     17f:	e8 9b 3f 00 00       	call   411f <chdir>
     184:	83 c4 10             	add    $0x10,%esp
     187:	85 c0                	test   %eax,%eax
     189:	79 1b                	jns    1a6 <exitiputtest+0xb1>
      printf(stdout, "child chdir failed\n");
     18b:	a1 60 65 00 00       	mov    0x6560,%eax
     190:	83 ec 08             	sub    $0x8,%esp
     193:	68 ba 46 00 00       	push   $0x46ba
     198:	50                   	push   %eax
     199:	e8 a5 40 00 00       	call   4243 <printf>
     19e:	83 c4 10             	add    $0x10,%esp
      exit();
     1a1:	e8 09 3f 00 00       	call   40af <exit>
    }
    if(unlink("../iputdir") < 0){
     1a6:	83 ec 0c             	sub    $0xc,%esp
     1a9:	68 59 46 00 00       	push   $0x4659
     1ae:	e8 4c 3f 00 00       	call   40ff <unlink>
     1b3:	83 c4 10             	add    $0x10,%esp
     1b6:	85 c0                	test   %eax,%eax
     1b8:	79 1b                	jns    1d5 <exitiputtest+0xe0>
      printf(stdout, "unlink ../iputdir failed\n");
     1ba:	a1 60 65 00 00       	mov    0x6560,%eax
     1bf:	83 ec 08             	sub    $0x8,%esp
     1c2:	68 64 46 00 00       	push   $0x4664
     1c7:	50                   	push   %eax
     1c8:	e8 76 40 00 00       	call   4243 <printf>
     1cd:	83 c4 10             	add    $0x10,%esp
      exit();
     1d0:	e8 da 3e 00 00       	call   40af <exit>
    }
    exit();
     1d5:	e8 d5 3e 00 00       	call   40af <exit>
  }
  wait();
     1da:	e8 d8 3e 00 00       	call   40b7 <wait>
  printf(stdout, "exitiput test ok\n");
     1df:	a1 60 65 00 00       	mov    0x6560,%eax
     1e4:	83 ec 08             	sub    $0x8,%esp
     1e7:	68 ce 46 00 00       	push   $0x46ce
     1ec:	50                   	push   %eax
     1ed:	e8 51 40 00 00       	call   4243 <printf>
     1f2:	83 c4 10             	add    $0x10,%esp
}
     1f5:	90                   	nop
     1f6:	c9                   	leave  
     1f7:	c3                   	ret    

000001f8 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1f8:	f3 0f 1e fb          	endbr32 
     1fc:	55                   	push   %ebp
     1fd:	89 e5                	mov    %esp,%ebp
     1ff:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "openiput test\n");
     202:	a1 60 65 00 00       	mov    0x6560,%eax
     207:	83 ec 08             	sub    $0x8,%esp
     20a:	68 e0 46 00 00       	push   $0x46e0
     20f:	50                   	push   %eax
     210:	e8 2e 40 00 00       	call   4243 <printf>
     215:	83 c4 10             	add    $0x10,%esp
  if(mkdir("oidir") < 0){
     218:	83 ec 0c             	sub    $0xc,%esp
     21b:	68 ef 46 00 00       	push   $0x46ef
     220:	e8 f2 3e 00 00       	call   4117 <mkdir>
     225:	83 c4 10             	add    $0x10,%esp
     228:	85 c0                	test   %eax,%eax
     22a:	79 1b                	jns    247 <openiputtest+0x4f>
    printf(stdout, "mkdir oidir failed\n");
     22c:	a1 60 65 00 00       	mov    0x6560,%eax
     231:	83 ec 08             	sub    $0x8,%esp
     234:	68 f5 46 00 00       	push   $0x46f5
     239:	50                   	push   %eax
     23a:	e8 04 40 00 00       	call   4243 <printf>
     23f:	83 c4 10             	add    $0x10,%esp
    exit();
     242:	e8 68 3e 00 00       	call   40af <exit>
  }
  pid = fork();
     247:	e8 5b 3e 00 00       	call   40a7 <fork>
     24c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     24f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     253:	79 1b                	jns    270 <openiputtest+0x78>
    printf(stdout, "fork failed\n");
     255:	a1 60 65 00 00       	mov    0x6560,%eax
     25a:	83 ec 08             	sub    $0x8,%esp
     25d:	68 ad 46 00 00       	push   $0x46ad
     262:	50                   	push   %eax
     263:	e8 db 3f 00 00       	call   4243 <printf>
     268:	83 c4 10             	add    $0x10,%esp
    exit();
     26b:	e8 3f 3e 00 00       	call   40af <exit>
  }
  if(pid == 0){
     270:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     274:	75 3b                	jne    2b1 <openiputtest+0xb9>
    int fd = open("oidir", O_RDWR);
     276:	83 ec 08             	sub    $0x8,%esp
     279:	6a 02                	push   $0x2
     27b:	68 ef 46 00 00       	push   $0x46ef
     280:	e8 6a 3e 00 00       	call   40ef <open>
     285:	83 c4 10             	add    $0x10,%esp
     288:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     28b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     28f:	78 1b                	js     2ac <openiputtest+0xb4>
      printf(stdout, "open directory for write succeeded\n");
     291:	a1 60 65 00 00       	mov    0x6560,%eax
     296:	83 ec 08             	sub    $0x8,%esp
     299:	68 0c 47 00 00       	push   $0x470c
     29e:	50                   	push   %eax
     29f:	e8 9f 3f 00 00       	call   4243 <printf>
     2a4:	83 c4 10             	add    $0x10,%esp
      exit();
     2a7:	e8 03 3e 00 00       	call   40af <exit>
    }
    exit();
     2ac:	e8 fe 3d 00 00       	call   40af <exit>
  }
  sleep(1);
     2b1:	83 ec 0c             	sub    $0xc,%esp
     2b4:	6a 01                	push   $0x1
     2b6:	e8 84 3e 00 00       	call   413f <sleep>
     2bb:	83 c4 10             	add    $0x10,%esp
  if(unlink("oidir") != 0){
     2be:	83 ec 0c             	sub    $0xc,%esp
     2c1:	68 ef 46 00 00       	push   $0x46ef
     2c6:	e8 34 3e 00 00       	call   40ff <unlink>
     2cb:	83 c4 10             	add    $0x10,%esp
     2ce:	85 c0                	test   %eax,%eax
     2d0:	74 1b                	je     2ed <openiputtest+0xf5>
    printf(stdout, "unlink failed\n");
     2d2:	a1 60 65 00 00       	mov    0x6560,%eax
     2d7:	83 ec 08             	sub    $0x8,%esp
     2da:	68 30 47 00 00       	push   $0x4730
     2df:	50                   	push   %eax
     2e0:	e8 5e 3f 00 00       	call   4243 <printf>
     2e5:	83 c4 10             	add    $0x10,%esp
    exit();
     2e8:	e8 c2 3d 00 00       	call   40af <exit>
  }
  wait();
     2ed:	e8 c5 3d 00 00       	call   40b7 <wait>
  printf(stdout, "openiput test ok\n");
     2f2:	a1 60 65 00 00       	mov    0x6560,%eax
     2f7:	83 ec 08             	sub    $0x8,%esp
     2fa:	68 3f 47 00 00       	push   $0x473f
     2ff:	50                   	push   %eax
     300:	e8 3e 3f 00 00       	call   4243 <printf>
     305:	83 c4 10             	add    $0x10,%esp
}
     308:	90                   	nop
     309:	c9                   	leave  
     30a:	c3                   	ret    

0000030b <opentest>:

// simple file system tests

void
opentest(void)
{
     30b:	f3 0f 1e fb          	endbr32 
     30f:	55                   	push   %ebp
     310:	89 e5                	mov    %esp,%ebp
     312:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
     315:	a1 60 65 00 00       	mov    0x6560,%eax
     31a:	83 ec 08             	sub    $0x8,%esp
     31d:	68 51 47 00 00       	push   $0x4751
     322:	50                   	push   %eax
     323:	e8 1b 3f 00 00       	call   4243 <printf>
     328:	83 c4 10             	add    $0x10,%esp
  fd = open("echo", 0);
     32b:	83 ec 08             	sub    $0x8,%esp
     32e:	6a 00                	push   $0x0
     330:	68 0c 46 00 00       	push   $0x460c
     335:	e8 b5 3d 00 00       	call   40ef <open>
     33a:	83 c4 10             	add    $0x10,%esp
     33d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     344:	79 1b                	jns    361 <opentest+0x56>
    printf(stdout, "open echo failed!\n");
     346:	a1 60 65 00 00       	mov    0x6560,%eax
     34b:	83 ec 08             	sub    $0x8,%esp
     34e:	68 5c 47 00 00       	push   $0x475c
     353:	50                   	push   %eax
     354:	e8 ea 3e 00 00       	call   4243 <printf>
     359:	83 c4 10             	add    $0x10,%esp
    exit();
     35c:	e8 4e 3d 00 00       	call   40af <exit>
  }
  close(fd);
     361:	83 ec 0c             	sub    $0xc,%esp
     364:	ff 75 f4             	pushl  -0xc(%ebp)
     367:	e8 6b 3d 00 00       	call   40d7 <close>
     36c:	83 c4 10             	add    $0x10,%esp
  fd = open("doesnotexist", 0);
     36f:	83 ec 08             	sub    $0x8,%esp
     372:	6a 00                	push   $0x0
     374:	68 6f 47 00 00       	push   $0x476f
     379:	e8 71 3d 00 00       	call   40ef <open>
     37e:	83 c4 10             	add    $0x10,%esp
     381:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     388:	78 1b                	js     3a5 <opentest+0x9a>
    printf(stdout, "open doesnotexist succeeded!\n");
     38a:	a1 60 65 00 00       	mov    0x6560,%eax
     38f:	83 ec 08             	sub    $0x8,%esp
     392:	68 7c 47 00 00       	push   $0x477c
     397:	50                   	push   %eax
     398:	e8 a6 3e 00 00       	call   4243 <printf>
     39d:	83 c4 10             	add    $0x10,%esp
    exit();
     3a0:	e8 0a 3d 00 00       	call   40af <exit>
  }
  printf(stdout, "open test ok\n");
     3a5:	a1 60 65 00 00       	mov    0x6560,%eax
     3aa:	83 ec 08             	sub    $0x8,%esp
     3ad:	68 9a 47 00 00       	push   $0x479a
     3b2:	50                   	push   %eax
     3b3:	e8 8b 3e 00 00       	call   4243 <printf>
     3b8:	83 c4 10             	add    $0x10,%esp
}
     3bb:	90                   	nop
     3bc:	c9                   	leave  
     3bd:	c3                   	ret    

000003be <writetest>:

void
writetest(void)
{
     3be:	f3 0f 1e fb          	endbr32 
     3c2:	55                   	push   %ebp
     3c3:	89 e5                	mov    %esp,%ebp
     3c5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     3c8:	a1 60 65 00 00       	mov    0x6560,%eax
     3cd:	83 ec 08             	sub    $0x8,%esp
     3d0:	68 a8 47 00 00       	push   $0x47a8
     3d5:	50                   	push   %eax
     3d6:	e8 68 3e 00 00       	call   4243 <printf>
     3db:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_CREATE|O_RDWR);
     3de:	83 ec 08             	sub    $0x8,%esp
     3e1:	68 02 02 00 00       	push   $0x202
     3e6:	68 b9 47 00 00       	push   $0x47b9
     3eb:	e8 ff 3c 00 00       	call   40ef <open>
     3f0:	83 c4 10             	add    $0x10,%esp
     3f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3fa:	78 22                	js     41e <writetest+0x60>
    printf(stdout, "creat small succeeded; ok\n");
     3fc:	a1 60 65 00 00       	mov    0x6560,%eax
     401:	83 ec 08             	sub    $0x8,%esp
     404:	68 bf 47 00 00       	push   $0x47bf
     409:	50                   	push   %eax
     40a:	e8 34 3e 00 00       	call   4243 <printf>
     40f:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     412:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     419:	e9 8f 00 00 00       	jmp    4ad <writetest+0xef>
    printf(stdout, "error: creat small failed!\n");
     41e:	a1 60 65 00 00       	mov    0x6560,%eax
     423:	83 ec 08             	sub    $0x8,%esp
     426:	68 da 47 00 00       	push   $0x47da
     42b:	50                   	push   %eax
     42c:	e8 12 3e 00 00       	call   4243 <printf>
     431:	83 c4 10             	add    $0x10,%esp
    exit();
     434:	e8 76 3c 00 00       	call   40af <exit>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     439:	83 ec 04             	sub    $0x4,%esp
     43c:	6a 0a                	push   $0xa
     43e:	68 f6 47 00 00       	push   $0x47f6
     443:	ff 75 f0             	pushl  -0x10(%ebp)
     446:	e8 84 3c 00 00       	call   40cf <write>
     44b:	83 c4 10             	add    $0x10,%esp
     44e:	83 f8 0a             	cmp    $0xa,%eax
     451:	74 1e                	je     471 <writetest+0xb3>
      printf(stdout, "error: write aa %d new file failed\n", i);
     453:	a1 60 65 00 00       	mov    0x6560,%eax
     458:	83 ec 04             	sub    $0x4,%esp
     45b:	ff 75 f4             	pushl  -0xc(%ebp)
     45e:	68 04 48 00 00       	push   $0x4804
     463:	50                   	push   %eax
     464:	e8 da 3d 00 00       	call   4243 <printf>
     469:	83 c4 10             	add    $0x10,%esp
      exit();
     46c:	e8 3e 3c 00 00       	call   40af <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     471:	83 ec 04             	sub    $0x4,%esp
     474:	6a 0a                	push   $0xa
     476:	68 28 48 00 00       	push   $0x4828
     47b:	ff 75 f0             	pushl  -0x10(%ebp)
     47e:	e8 4c 3c 00 00       	call   40cf <write>
     483:	83 c4 10             	add    $0x10,%esp
     486:	83 f8 0a             	cmp    $0xa,%eax
     489:	74 1e                	je     4a9 <writetest+0xeb>
      printf(stdout, "error: write bb %d new file failed\n", i);
     48b:	a1 60 65 00 00       	mov    0x6560,%eax
     490:	83 ec 04             	sub    $0x4,%esp
     493:	ff 75 f4             	pushl  -0xc(%ebp)
     496:	68 34 48 00 00       	push   $0x4834
     49b:	50                   	push   %eax
     49c:	e8 a2 3d 00 00       	call   4243 <printf>
     4a1:	83 c4 10             	add    $0x10,%esp
      exit();
     4a4:	e8 06 3c 00 00       	call   40af <exit>
  for(i = 0; i < 100; i++){
     4a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     4ad:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     4b1:	7e 86                	jle    439 <writetest+0x7b>
    }
  }
  printf(stdout, "writes ok\n");
     4b3:	a1 60 65 00 00       	mov    0x6560,%eax
     4b8:	83 ec 08             	sub    $0x8,%esp
     4bb:	68 58 48 00 00       	push   $0x4858
     4c0:	50                   	push   %eax
     4c1:	e8 7d 3d 00 00       	call   4243 <printf>
     4c6:	83 c4 10             	add    $0x10,%esp
  close(fd);
     4c9:	83 ec 0c             	sub    $0xc,%esp
     4cc:	ff 75 f0             	pushl  -0x10(%ebp)
     4cf:	e8 03 3c 00 00       	call   40d7 <close>
     4d4:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     4d7:	83 ec 08             	sub    $0x8,%esp
     4da:	6a 00                	push   $0x0
     4dc:	68 b9 47 00 00       	push   $0x47b9
     4e1:	e8 09 3c 00 00       	call   40ef <open>
     4e6:	83 c4 10             	add    $0x10,%esp
     4e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4f0:	78 3c                	js     52e <writetest+0x170>
    printf(stdout, "open small succeeded ok\n");
     4f2:	a1 60 65 00 00       	mov    0x6560,%eax
     4f7:	83 ec 08             	sub    $0x8,%esp
     4fa:	68 63 48 00 00       	push   $0x4863
     4ff:	50                   	push   %eax
     500:	e8 3e 3d 00 00       	call   4243 <printf>
     505:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     508:	83 ec 04             	sub    $0x4,%esp
     50b:	68 d0 07 00 00       	push   $0x7d0
     510:	68 40 8d 00 00       	push   $0x8d40
     515:	ff 75 f0             	pushl  -0x10(%ebp)
     518:	e8 aa 3b 00 00       	call   40c7 <read>
     51d:	83 c4 10             	add    $0x10,%esp
     520:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     523:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     52a:	75 57                	jne    583 <writetest+0x1c5>
     52c:	eb 1b                	jmp    549 <writetest+0x18b>
    printf(stdout, "error: open small failed!\n");
     52e:	a1 60 65 00 00       	mov    0x6560,%eax
     533:	83 ec 08             	sub    $0x8,%esp
     536:	68 7c 48 00 00       	push   $0x487c
     53b:	50                   	push   %eax
     53c:	e8 02 3d 00 00       	call   4243 <printf>
     541:	83 c4 10             	add    $0x10,%esp
    exit();
     544:	e8 66 3b 00 00       	call   40af <exit>
    printf(stdout, "read succeeded ok\n");
     549:	a1 60 65 00 00       	mov    0x6560,%eax
     54e:	83 ec 08             	sub    $0x8,%esp
     551:	68 97 48 00 00       	push   $0x4897
     556:	50                   	push   %eax
     557:	e8 e7 3c 00 00       	call   4243 <printf>
     55c:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     55f:	83 ec 0c             	sub    $0xc,%esp
     562:	ff 75 f0             	pushl  -0x10(%ebp)
     565:	e8 6d 3b 00 00       	call   40d7 <close>
     56a:	83 c4 10             	add    $0x10,%esp

  if(unlink("small") < 0){
     56d:	83 ec 0c             	sub    $0xc,%esp
     570:	68 b9 47 00 00       	push   $0x47b9
     575:	e8 85 3b 00 00       	call   40ff <unlink>
     57a:	83 c4 10             	add    $0x10,%esp
     57d:	85 c0                	test   %eax,%eax
     57f:	79 38                	jns    5b9 <writetest+0x1fb>
     581:	eb 1b                	jmp    59e <writetest+0x1e0>
    printf(stdout, "read failed\n");
     583:	a1 60 65 00 00       	mov    0x6560,%eax
     588:	83 ec 08             	sub    $0x8,%esp
     58b:	68 aa 48 00 00       	push   $0x48aa
     590:	50                   	push   %eax
     591:	e8 ad 3c 00 00       	call   4243 <printf>
     596:	83 c4 10             	add    $0x10,%esp
    exit();
     599:	e8 11 3b 00 00       	call   40af <exit>
    printf(stdout, "unlink small failed\n");
     59e:	a1 60 65 00 00       	mov    0x6560,%eax
     5a3:	83 ec 08             	sub    $0x8,%esp
     5a6:	68 b7 48 00 00       	push   $0x48b7
     5ab:	50                   	push   %eax
     5ac:	e8 92 3c 00 00       	call   4243 <printf>
     5b1:	83 c4 10             	add    $0x10,%esp
    exit();
     5b4:	e8 f6 3a 00 00       	call   40af <exit>
  }
  printf(stdout, "small file test ok\n");
     5b9:	a1 60 65 00 00       	mov    0x6560,%eax
     5be:	83 ec 08             	sub    $0x8,%esp
     5c1:	68 cc 48 00 00       	push   $0x48cc
     5c6:	50                   	push   %eax
     5c7:	e8 77 3c 00 00       	call   4243 <printf>
     5cc:	83 c4 10             	add    $0x10,%esp
}
     5cf:	90                   	nop
     5d0:	c9                   	leave  
     5d1:	c3                   	ret    

000005d2 <writetest1>:

void
writetest1(void)
{
     5d2:	f3 0f 1e fb          	endbr32 
     5d6:	55                   	push   %ebp
     5d7:	89 e5                	mov    %esp,%ebp
     5d9:	83 ec 18             	sub    $0x18,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     5dc:	a1 60 65 00 00       	mov    0x6560,%eax
     5e1:	83 ec 08             	sub    $0x8,%esp
     5e4:	68 e0 48 00 00       	push   $0x48e0
     5e9:	50                   	push   %eax
     5ea:	e8 54 3c 00 00       	call   4243 <printf>
     5ef:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_CREATE|O_RDWR);
     5f2:	83 ec 08             	sub    $0x8,%esp
     5f5:	68 02 02 00 00       	push   $0x202
     5fa:	68 f0 48 00 00       	push   $0x48f0
     5ff:	e8 eb 3a 00 00       	call   40ef <open>
     604:	83 c4 10             	add    $0x10,%esp
     607:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     60a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     60e:	79 1b                	jns    62b <writetest1+0x59>
    printf(stdout, "error: creat big failed!\n");
     610:	a1 60 65 00 00       	mov    0x6560,%eax
     615:	83 ec 08             	sub    $0x8,%esp
     618:	68 f4 48 00 00       	push   $0x48f4
     61d:	50                   	push   %eax
     61e:	e8 20 3c 00 00       	call   4243 <printf>
     623:	83 c4 10             	add    $0x10,%esp
    exit();
     626:	e8 84 3a 00 00       	call   40af <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     62b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     632:	eb 4b                	jmp    67f <writetest1+0xad>
    ((int*)buf)[0] = i;
     634:	ba 40 8d 00 00       	mov    $0x8d40,%edx
     639:	8b 45 f4             	mov    -0xc(%ebp),%eax
     63c:	89 02                	mov    %eax,(%edx)
    if(write(fd, buf, 512) != 512){
     63e:	83 ec 04             	sub    $0x4,%esp
     641:	68 00 02 00 00       	push   $0x200
     646:	68 40 8d 00 00       	push   $0x8d40
     64b:	ff 75 ec             	pushl  -0x14(%ebp)
     64e:	e8 7c 3a 00 00       	call   40cf <write>
     653:	83 c4 10             	add    $0x10,%esp
     656:	3d 00 02 00 00       	cmp    $0x200,%eax
     65b:	74 1e                	je     67b <writetest1+0xa9>
      printf(stdout, "error: write big file failed\n", i);
     65d:	a1 60 65 00 00       	mov    0x6560,%eax
     662:	83 ec 04             	sub    $0x4,%esp
     665:	ff 75 f4             	pushl  -0xc(%ebp)
     668:	68 0e 49 00 00       	push   $0x490e
     66d:	50                   	push   %eax
     66e:	e8 d0 3b 00 00       	call   4243 <printf>
     673:	83 c4 10             	add    $0x10,%esp
      exit();
     676:	e8 34 3a 00 00       	call   40af <exit>
  for(i = 0; i < MAXFILE; i++){
     67b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     67f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     682:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     687:	76 ab                	jbe    634 <writetest1+0x62>
    }
  }

  close(fd);
     689:	83 ec 0c             	sub    $0xc,%esp
     68c:	ff 75 ec             	pushl  -0x14(%ebp)
     68f:	e8 43 3a 00 00       	call   40d7 <close>
     694:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_RDONLY);
     697:	83 ec 08             	sub    $0x8,%esp
     69a:	6a 00                	push   $0x0
     69c:	68 f0 48 00 00       	push   $0x48f0
     6a1:	e8 49 3a 00 00       	call   40ef <open>
     6a6:	83 c4 10             	add    $0x10,%esp
     6a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     6ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     6b0:	79 1b                	jns    6cd <writetest1+0xfb>
    printf(stdout, "error: open big failed!\n");
     6b2:	a1 60 65 00 00       	mov    0x6560,%eax
     6b7:	83 ec 08             	sub    $0x8,%esp
     6ba:	68 2c 49 00 00       	push   $0x492c
     6bf:	50                   	push   %eax
     6c0:	e8 7e 3b 00 00       	call   4243 <printf>
     6c5:	83 c4 10             	add    $0x10,%esp
    exit();
     6c8:	e8 e2 39 00 00       	call   40af <exit>
  }

  n = 0;
     6cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     6d4:	83 ec 04             	sub    $0x4,%esp
     6d7:	68 00 02 00 00       	push   $0x200
     6dc:	68 40 8d 00 00       	push   $0x8d40
     6e1:	ff 75 ec             	pushl  -0x14(%ebp)
     6e4:	e8 de 39 00 00       	call   40c7 <read>
     6e9:	83 c4 10             	add    $0x10,%esp
     6ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6f3:	75 27                	jne    71c <writetest1+0x14a>
      if(n == MAXFILE - 1){
     6f5:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6fc:	75 7d                	jne    77b <writetest1+0x1a9>
        printf(stdout, "read only %d blocks from big", n);
     6fe:	a1 60 65 00 00       	mov    0x6560,%eax
     703:	83 ec 04             	sub    $0x4,%esp
     706:	ff 75 f0             	pushl  -0x10(%ebp)
     709:	68 45 49 00 00       	push   $0x4945
     70e:	50                   	push   %eax
     70f:	e8 2f 3b 00 00       	call   4243 <printf>
     714:	83 c4 10             	add    $0x10,%esp
        exit();
     717:	e8 93 39 00 00       	call   40af <exit>
      }
      break;
    } else if(i != 512){
     71c:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     723:	74 1e                	je     743 <writetest1+0x171>
      printf(stdout, "read failed %d\n", i);
     725:	a1 60 65 00 00       	mov    0x6560,%eax
     72a:	83 ec 04             	sub    $0x4,%esp
     72d:	ff 75 f4             	pushl  -0xc(%ebp)
     730:	68 62 49 00 00       	push   $0x4962
     735:	50                   	push   %eax
     736:	e8 08 3b 00 00       	call   4243 <printf>
     73b:	83 c4 10             	add    $0x10,%esp
      exit();
     73e:	e8 6c 39 00 00       	call   40af <exit>
    }
    if(((int*)buf)[0] != n){
     743:	b8 40 8d 00 00       	mov    $0x8d40,%eax
     748:	8b 00                	mov    (%eax),%eax
     74a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     74d:	74 23                	je     772 <writetest1+0x1a0>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     74f:	b8 40 8d 00 00       	mov    $0x8d40,%eax
      printf(stdout, "read content of block %d is %d\n",
     754:	8b 10                	mov    (%eax),%edx
     756:	a1 60 65 00 00       	mov    0x6560,%eax
     75b:	52                   	push   %edx
     75c:	ff 75 f0             	pushl  -0x10(%ebp)
     75f:	68 74 49 00 00       	push   $0x4974
     764:	50                   	push   %eax
     765:	e8 d9 3a 00 00       	call   4243 <printf>
     76a:	83 c4 10             	add    $0x10,%esp
      exit();
     76d:	e8 3d 39 00 00       	call   40af <exit>
    }
    n++;
     772:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    i = read(fd, buf, 512);
     776:	e9 59 ff ff ff       	jmp    6d4 <writetest1+0x102>
      break;
     77b:	90                   	nop
  }
  close(fd);
     77c:	83 ec 0c             	sub    $0xc,%esp
     77f:	ff 75 ec             	pushl  -0x14(%ebp)
     782:	e8 50 39 00 00       	call   40d7 <close>
     787:	83 c4 10             	add    $0x10,%esp
  if(unlink("big") < 0){
     78a:	83 ec 0c             	sub    $0xc,%esp
     78d:	68 f0 48 00 00       	push   $0x48f0
     792:	e8 68 39 00 00       	call   40ff <unlink>
     797:	83 c4 10             	add    $0x10,%esp
     79a:	85 c0                	test   %eax,%eax
     79c:	79 1b                	jns    7b9 <writetest1+0x1e7>
    printf(stdout, "unlink big failed\n");
     79e:	a1 60 65 00 00       	mov    0x6560,%eax
     7a3:	83 ec 08             	sub    $0x8,%esp
     7a6:	68 94 49 00 00       	push   $0x4994
     7ab:	50                   	push   %eax
     7ac:	e8 92 3a 00 00       	call   4243 <printf>
     7b1:	83 c4 10             	add    $0x10,%esp
    exit();
     7b4:	e8 f6 38 00 00       	call   40af <exit>
  }
  printf(stdout, "big files ok\n");
     7b9:	a1 60 65 00 00       	mov    0x6560,%eax
     7be:	83 ec 08             	sub    $0x8,%esp
     7c1:	68 a7 49 00 00       	push   $0x49a7
     7c6:	50                   	push   %eax
     7c7:	e8 77 3a 00 00       	call   4243 <printf>
     7cc:	83 c4 10             	add    $0x10,%esp
}
     7cf:	90                   	nop
     7d0:	c9                   	leave  
     7d1:	c3                   	ret    

000007d2 <createtest>:

void
createtest(void)
{
     7d2:	f3 0f 1e fb          	endbr32 
     7d6:	55                   	push   %ebp
     7d7:	89 e5                	mov    %esp,%ebp
     7d9:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     7dc:	a1 60 65 00 00       	mov    0x6560,%eax
     7e1:	83 ec 08             	sub    $0x8,%esp
     7e4:	68 b8 49 00 00       	push   $0x49b8
     7e9:	50                   	push   %eax
     7ea:	e8 54 3a 00 00       	call   4243 <printf>
     7ef:	83 c4 10             	add    $0x10,%esp

  name[0] = 'a';
     7f2:	c6 05 40 ad 00 00 61 	movb   $0x61,0xad40
  name[2] = '\0';
     7f9:	c6 05 42 ad 00 00 00 	movb   $0x0,0xad42
  for(i = 0; i < 52; i++){
     800:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     807:	eb 35                	jmp    83e <createtest+0x6c>
    name[1] = '0' + i;
     809:	8b 45 f4             	mov    -0xc(%ebp),%eax
     80c:	83 c0 30             	add    $0x30,%eax
     80f:	a2 41 ad 00 00       	mov    %al,0xad41
    fd = open(name, O_CREATE|O_RDWR);
     814:	83 ec 08             	sub    $0x8,%esp
     817:	68 02 02 00 00       	push   $0x202
     81c:	68 40 ad 00 00       	push   $0xad40
     821:	e8 c9 38 00 00       	call   40ef <open>
     826:	83 c4 10             	add    $0x10,%esp
     829:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     82c:	83 ec 0c             	sub    $0xc,%esp
     82f:	ff 75 f0             	pushl  -0x10(%ebp)
     832:	e8 a0 38 00 00       	call   40d7 <close>
     837:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     83a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     83e:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     842:	7e c5                	jle    809 <createtest+0x37>
  }
  name[0] = 'a';
     844:	c6 05 40 ad 00 00 61 	movb   $0x61,0xad40
  name[2] = '\0';
     84b:	c6 05 42 ad 00 00 00 	movb   $0x0,0xad42
  for(i = 0; i < 52; i++){
     852:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     859:	eb 1f                	jmp    87a <createtest+0xa8>
    name[1] = '0' + i;
     85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     85e:	83 c0 30             	add    $0x30,%eax
     861:	a2 41 ad 00 00       	mov    %al,0xad41
    unlink(name);
     866:	83 ec 0c             	sub    $0xc,%esp
     869:	68 40 ad 00 00       	push   $0xad40
     86e:	e8 8c 38 00 00       	call   40ff <unlink>
     873:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     876:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     87a:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     87e:	7e db                	jle    85b <createtest+0x89>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     880:	a1 60 65 00 00       	mov    0x6560,%eax
     885:	83 ec 08             	sub    $0x8,%esp
     888:	68 e0 49 00 00       	push   $0x49e0
     88d:	50                   	push   %eax
     88e:	e8 b0 39 00 00       	call   4243 <printf>
     893:	83 c4 10             	add    $0x10,%esp
}
     896:	90                   	nop
     897:	c9                   	leave  
     898:	c3                   	ret    

00000899 <dirtest>:

void dirtest(void)
{
     899:	f3 0f 1e fb          	endbr32 
     89d:	55                   	push   %ebp
     89e:	89 e5                	mov    %esp,%ebp
     8a0:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     8a3:	a1 60 65 00 00       	mov    0x6560,%eax
     8a8:	83 ec 08             	sub    $0x8,%esp
     8ab:	68 06 4a 00 00       	push   $0x4a06
     8b0:	50                   	push   %eax
     8b1:	e8 8d 39 00 00       	call   4243 <printf>
     8b6:	83 c4 10             	add    $0x10,%esp

  if(mkdir("dir0") < 0){
     8b9:	83 ec 0c             	sub    $0xc,%esp
     8bc:	68 12 4a 00 00       	push   $0x4a12
     8c1:	e8 51 38 00 00       	call   4117 <mkdir>
     8c6:	83 c4 10             	add    $0x10,%esp
     8c9:	85 c0                	test   %eax,%eax
     8cb:	79 1b                	jns    8e8 <dirtest+0x4f>
    printf(stdout, "mkdir failed\n");
     8cd:	a1 60 65 00 00       	mov    0x6560,%eax
     8d2:	83 ec 08             	sub    $0x8,%esp
     8d5:	68 35 46 00 00       	push   $0x4635
     8da:	50                   	push   %eax
     8db:	e8 63 39 00 00       	call   4243 <printf>
     8e0:	83 c4 10             	add    $0x10,%esp
    exit();
     8e3:	e8 c7 37 00 00       	call   40af <exit>
  }

  if(chdir("dir0") < 0){
     8e8:	83 ec 0c             	sub    $0xc,%esp
     8eb:	68 12 4a 00 00       	push   $0x4a12
     8f0:	e8 2a 38 00 00       	call   411f <chdir>
     8f5:	83 c4 10             	add    $0x10,%esp
     8f8:	85 c0                	test   %eax,%eax
     8fa:	79 1b                	jns    917 <dirtest+0x7e>
    printf(stdout, "chdir dir0 failed\n");
     8fc:	a1 60 65 00 00       	mov    0x6560,%eax
     901:	83 ec 08             	sub    $0x8,%esp
     904:	68 17 4a 00 00       	push   $0x4a17
     909:	50                   	push   %eax
     90a:	e8 34 39 00 00       	call   4243 <printf>
     90f:	83 c4 10             	add    $0x10,%esp
    exit();
     912:	e8 98 37 00 00       	call   40af <exit>
  }

  if(chdir("..") < 0){
     917:	83 ec 0c             	sub    $0xc,%esp
     91a:	68 2a 4a 00 00       	push   $0x4a2a
     91f:	e8 fb 37 00 00       	call   411f <chdir>
     924:	83 c4 10             	add    $0x10,%esp
     927:	85 c0                	test   %eax,%eax
     929:	79 1b                	jns    946 <dirtest+0xad>
    printf(stdout, "chdir .. failed\n");
     92b:	a1 60 65 00 00       	mov    0x6560,%eax
     930:	83 ec 08             	sub    $0x8,%esp
     933:	68 2d 4a 00 00       	push   $0x4a2d
     938:	50                   	push   %eax
     939:	e8 05 39 00 00       	call   4243 <printf>
     93e:	83 c4 10             	add    $0x10,%esp
    exit();
     941:	e8 69 37 00 00       	call   40af <exit>
  }

  if(unlink("dir0") < 0){
     946:	83 ec 0c             	sub    $0xc,%esp
     949:	68 12 4a 00 00       	push   $0x4a12
     94e:	e8 ac 37 00 00       	call   40ff <unlink>
     953:	83 c4 10             	add    $0x10,%esp
     956:	85 c0                	test   %eax,%eax
     958:	79 1b                	jns    975 <dirtest+0xdc>
    printf(stdout, "unlink dir0 failed\n");
     95a:	a1 60 65 00 00       	mov    0x6560,%eax
     95f:	83 ec 08             	sub    $0x8,%esp
     962:	68 3e 4a 00 00       	push   $0x4a3e
     967:	50                   	push   %eax
     968:	e8 d6 38 00 00       	call   4243 <printf>
     96d:	83 c4 10             	add    $0x10,%esp
    exit();
     970:	e8 3a 37 00 00       	call   40af <exit>
  }
  printf(stdout, "mkdir test ok\n");
     975:	a1 60 65 00 00       	mov    0x6560,%eax
     97a:	83 ec 08             	sub    $0x8,%esp
     97d:	68 52 4a 00 00       	push   $0x4a52
     982:	50                   	push   %eax
     983:	e8 bb 38 00 00       	call   4243 <printf>
     988:	83 c4 10             	add    $0x10,%esp
}
     98b:	90                   	nop
     98c:	c9                   	leave  
     98d:	c3                   	ret    

0000098e <exectest>:

void
exectest(void)
{
     98e:	f3 0f 1e fb          	endbr32 
     992:	55                   	push   %ebp
     993:	89 e5                	mov    %esp,%ebp
     995:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
     998:	a1 60 65 00 00       	mov    0x6560,%eax
     99d:	83 ec 08             	sub    $0x8,%esp
     9a0:	68 61 4a 00 00       	push   $0x4a61
     9a5:	50                   	push   %eax
     9a6:	e8 98 38 00 00       	call   4243 <printf>
     9ab:	83 c4 10             	add    $0x10,%esp
  if(exec("echo", echoargv) < 0){
     9ae:	83 ec 08             	sub    $0x8,%esp
     9b1:	68 4c 65 00 00       	push   $0x654c
     9b6:	68 0c 46 00 00       	push   $0x460c
     9bb:	e8 27 37 00 00       	call   40e7 <exec>
     9c0:	83 c4 10             	add    $0x10,%esp
     9c3:	85 c0                	test   %eax,%eax
     9c5:	79 1b                	jns    9e2 <exectest+0x54>
    printf(stdout, "exec echo failed\n");
     9c7:	a1 60 65 00 00       	mov    0x6560,%eax
     9cc:	83 ec 08             	sub    $0x8,%esp
     9cf:	68 6c 4a 00 00       	push   $0x4a6c
     9d4:	50                   	push   %eax
     9d5:	e8 69 38 00 00       	call   4243 <printf>
     9da:	83 c4 10             	add    $0x10,%esp
    exit();
     9dd:	e8 cd 36 00 00       	call   40af <exit>
  }
}
     9e2:	90                   	nop
     9e3:	c9                   	leave  
     9e4:	c3                   	ret    

000009e5 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     9e5:	f3 0f 1e fb          	endbr32 
     9e9:	55                   	push   %ebp
     9ea:	89 e5                	mov    %esp,%ebp
     9ec:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     9ef:	83 ec 0c             	sub    $0xc,%esp
     9f2:	8d 45 d8             	lea    -0x28(%ebp),%eax
     9f5:	50                   	push   %eax
     9f6:	e8 c4 36 00 00       	call   40bf <pipe>
     9fb:	83 c4 10             	add    $0x10,%esp
     9fe:	85 c0                	test   %eax,%eax
     a00:	74 17                	je     a19 <pipe1+0x34>
    printf(1, "pipe() failed\n");
     a02:	83 ec 08             	sub    $0x8,%esp
     a05:	68 7e 4a 00 00       	push   $0x4a7e
     a0a:	6a 01                	push   $0x1
     a0c:	e8 32 38 00 00       	call   4243 <printf>
     a11:	83 c4 10             	add    $0x10,%esp
    exit();
     a14:	e8 96 36 00 00       	call   40af <exit>
  }
  pid = fork();
     a19:	e8 89 36 00 00       	call   40a7 <fork>
     a1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     a21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a2c:	0f 85 89 00 00 00    	jne    abb <pipe1+0xd6>
    close(fds[0]);
     a32:	8b 45 d8             	mov    -0x28(%ebp),%eax
     a35:	83 ec 0c             	sub    $0xc,%esp
     a38:	50                   	push   %eax
     a39:	e8 99 36 00 00       	call   40d7 <close>
     a3e:	83 c4 10             	add    $0x10,%esp
    for(n = 0; n < 5; n++){
     a41:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     a48:	eb 66                	jmp    ab0 <pipe1+0xcb>
      for(i = 0; i < 1033; i++)
     a4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a51:	eb 19                	jmp    a6c <pipe1+0x87>
        buf[i] = seq++;
     a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a56:	8d 50 01             	lea    0x1(%eax),%edx
     a59:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a5c:	89 c2                	mov    %eax,%edx
     a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a61:	05 40 8d 00 00       	add    $0x8d40,%eax
     a66:	88 10                	mov    %dl,(%eax)
      for(i = 0; i < 1033; i++)
     a68:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     a6c:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     a73:	7e de                	jle    a53 <pipe1+0x6e>
      if(write(fds[1], buf, 1033) != 1033){
     a75:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a78:	83 ec 04             	sub    $0x4,%esp
     a7b:	68 09 04 00 00       	push   $0x409
     a80:	68 40 8d 00 00       	push   $0x8d40
     a85:	50                   	push   %eax
     a86:	e8 44 36 00 00       	call   40cf <write>
     a8b:	83 c4 10             	add    $0x10,%esp
     a8e:	3d 09 04 00 00       	cmp    $0x409,%eax
     a93:	74 17                	je     aac <pipe1+0xc7>
        printf(1, "pipe1 oops 1\n");
     a95:	83 ec 08             	sub    $0x8,%esp
     a98:	68 8d 4a 00 00       	push   $0x4a8d
     a9d:	6a 01                	push   $0x1
     a9f:	e8 9f 37 00 00       	call   4243 <printf>
     aa4:	83 c4 10             	add    $0x10,%esp
        exit();
     aa7:	e8 03 36 00 00       	call   40af <exit>
    for(n = 0; n < 5; n++){
     aac:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     ab0:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     ab4:	7e 94                	jle    a4a <pipe1+0x65>
      }
    }
    exit();
     ab6:	e8 f4 35 00 00       	call   40af <exit>
  } else if(pid > 0){
     abb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     abf:	0f 8e f4 00 00 00    	jle    bb9 <pipe1+0x1d4>
    close(fds[1]);
     ac5:	8b 45 dc             	mov    -0x24(%ebp),%eax
     ac8:	83 ec 0c             	sub    $0xc,%esp
     acb:	50                   	push   %eax
     acc:	e8 06 36 00 00       	call   40d7 <close>
     ad1:	83 c4 10             	add    $0x10,%esp
    total = 0;
     ad4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     adb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     ae2:	eb 66                	jmp    b4a <pipe1+0x165>
      for(i = 0; i < n; i++){
     ae4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     aeb:	eb 3b                	jmp    b28 <pipe1+0x143>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
     af0:	05 40 8d 00 00       	add    $0x8d40,%eax
     af5:	0f b6 00             	movzbl (%eax),%eax
     af8:	0f be c8             	movsbl %al,%ecx
     afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     afe:	8d 50 01             	lea    0x1(%eax),%edx
     b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
     b04:	31 c8                	xor    %ecx,%eax
     b06:	0f b6 c0             	movzbl %al,%eax
     b09:	85 c0                	test   %eax,%eax
     b0b:	74 17                	je     b24 <pipe1+0x13f>
          printf(1, "pipe1 oops 2\n");
     b0d:	83 ec 08             	sub    $0x8,%esp
     b10:	68 9b 4a 00 00       	push   $0x4a9b
     b15:	6a 01                	push   $0x1
     b17:	e8 27 37 00 00       	call   4243 <printf>
     b1c:	83 c4 10             	add    $0x10,%esp
     b1f:	e9 ac 00 00 00       	jmp    bd0 <pipe1+0x1eb>
      for(i = 0; i < n; i++){
     b24:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b2b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     b2e:	7c bd                	jl     aed <pipe1+0x108>
          return;
        }
      }
      total += n;
     b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b33:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     b36:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b3c:	3d 00 20 00 00       	cmp    $0x2000,%eax
     b41:	76 07                	jbe    b4a <pipe1+0x165>
        cc = sizeof(buf);
     b43:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     b4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b4d:	83 ec 04             	sub    $0x4,%esp
     b50:	ff 75 e8             	pushl  -0x18(%ebp)
     b53:	68 40 8d 00 00       	push   $0x8d40
     b58:	50                   	push   %eax
     b59:	e8 69 35 00 00       	call   40c7 <read>
     b5e:	83 c4 10             	add    $0x10,%esp
     b61:	89 45 ec             	mov    %eax,-0x14(%ebp)
     b64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b68:	0f 8f 76 ff ff ff    	jg     ae4 <pipe1+0xff>
    }
    if(total != 5 * 1033){
     b6e:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     b75:	74 1a                	je     b91 <pipe1+0x1ac>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b77:	83 ec 04             	sub    $0x4,%esp
     b7a:	ff 75 e4             	pushl  -0x1c(%ebp)
     b7d:	68 a9 4a 00 00       	push   $0x4aa9
     b82:	6a 01                	push   $0x1
     b84:	e8 ba 36 00 00       	call   4243 <printf>
     b89:	83 c4 10             	add    $0x10,%esp
      exit();
     b8c:	e8 1e 35 00 00       	call   40af <exit>
    }
    close(fds[0]);
     b91:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b94:	83 ec 0c             	sub    $0xc,%esp
     b97:	50                   	push   %eax
     b98:	e8 3a 35 00 00       	call   40d7 <close>
     b9d:	83 c4 10             	add    $0x10,%esp
    wait();
     ba0:	e8 12 35 00 00       	call   40b7 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     ba5:	83 ec 08             	sub    $0x8,%esp
     ba8:	68 cf 4a 00 00       	push   $0x4acf
     bad:	6a 01                	push   $0x1
     baf:	e8 8f 36 00 00       	call   4243 <printf>
     bb4:	83 c4 10             	add    $0x10,%esp
     bb7:	eb 17                	jmp    bd0 <pipe1+0x1eb>
    printf(1, "fork() failed\n");
     bb9:	83 ec 08             	sub    $0x8,%esp
     bbc:	68 c0 4a 00 00       	push   $0x4ac0
     bc1:	6a 01                	push   $0x1
     bc3:	e8 7b 36 00 00       	call   4243 <printf>
     bc8:	83 c4 10             	add    $0x10,%esp
    exit();
     bcb:	e8 df 34 00 00       	call   40af <exit>
}
     bd0:	c9                   	leave  
     bd1:	c3                   	ret    

00000bd2 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     bd2:	f3 0f 1e fb          	endbr32 
     bd6:	55                   	push   %ebp
     bd7:	89 e5                	mov    %esp,%ebp
     bd9:	83 ec 28             	sub    $0x28,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     bdc:	83 ec 08             	sub    $0x8,%esp
     bdf:	68 d9 4a 00 00       	push   $0x4ad9
     be4:	6a 01                	push   $0x1
     be6:	e8 58 36 00 00       	call   4243 <printf>
     beb:	83 c4 10             	add    $0x10,%esp
  pid1 = fork();
     bee:	e8 b4 34 00 00       	call   40a7 <fork>
     bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     bf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     bfa:	75 02                	jne    bfe <preempt+0x2c>
    for(;;)
     bfc:	eb fe                	jmp    bfc <preempt+0x2a>
      ;

  pid2 = fork();
     bfe:	e8 a4 34 00 00       	call   40a7 <fork>
     c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     c06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c0a:	75 02                	jne    c0e <preempt+0x3c>
    for(;;)
     c0c:	eb fe                	jmp    c0c <preempt+0x3a>
      ;

  pipe(pfds);
     c0e:	83 ec 0c             	sub    $0xc,%esp
     c11:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     c14:	50                   	push   %eax
     c15:	e8 a5 34 00 00       	call   40bf <pipe>
     c1a:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     c1d:	e8 85 34 00 00       	call   40a7 <fork>
     c22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     c25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     c29:	75 4d                	jne    c78 <preempt+0xa6>
    close(pfds[0]);
     c2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c2e:	83 ec 0c             	sub    $0xc,%esp
     c31:	50                   	push   %eax
     c32:	e8 a0 34 00 00       	call   40d7 <close>
     c37:	83 c4 10             	add    $0x10,%esp
    if(write(pfds[1], "x", 1) != 1)
     c3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c3d:	83 ec 04             	sub    $0x4,%esp
     c40:	6a 01                	push   $0x1
     c42:	68 e3 4a 00 00       	push   $0x4ae3
     c47:	50                   	push   %eax
     c48:	e8 82 34 00 00       	call   40cf <write>
     c4d:	83 c4 10             	add    $0x10,%esp
     c50:	83 f8 01             	cmp    $0x1,%eax
     c53:	74 12                	je     c67 <preempt+0x95>
      printf(1, "preempt write error");
     c55:	83 ec 08             	sub    $0x8,%esp
     c58:	68 e5 4a 00 00       	push   $0x4ae5
     c5d:	6a 01                	push   $0x1
     c5f:	e8 df 35 00 00       	call   4243 <printf>
     c64:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c6a:	83 ec 0c             	sub    $0xc,%esp
     c6d:	50                   	push   %eax
     c6e:	e8 64 34 00 00       	call   40d7 <close>
     c73:	83 c4 10             	add    $0x10,%esp
    for(;;)
     c76:	eb fe                	jmp    c76 <preempt+0xa4>
      ;
  }

  close(pfds[1]);
     c78:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c7b:	83 ec 0c             	sub    $0xc,%esp
     c7e:	50                   	push   %eax
     c7f:	e8 53 34 00 00       	call   40d7 <close>
     c84:	83 c4 10             	add    $0x10,%esp
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c8a:	83 ec 04             	sub    $0x4,%esp
     c8d:	68 00 20 00 00       	push   $0x2000
     c92:	68 40 8d 00 00       	push   $0x8d40
     c97:	50                   	push   %eax
     c98:	e8 2a 34 00 00       	call   40c7 <read>
     c9d:	83 c4 10             	add    $0x10,%esp
     ca0:	83 f8 01             	cmp    $0x1,%eax
     ca3:	74 14                	je     cb9 <preempt+0xe7>
    printf(1, "preempt read error");
     ca5:	83 ec 08             	sub    $0x8,%esp
     ca8:	68 f9 4a 00 00       	push   $0x4af9
     cad:	6a 01                	push   $0x1
     caf:	e8 8f 35 00 00       	call   4243 <printf>
     cb4:	83 c4 10             	add    $0x10,%esp
     cb7:	eb 7e                	jmp    d37 <preempt+0x165>
    return;
  }
  close(pfds[0]);
     cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cbc:	83 ec 0c             	sub    $0xc,%esp
     cbf:	50                   	push   %eax
     cc0:	e8 12 34 00 00       	call   40d7 <close>
     cc5:	83 c4 10             	add    $0x10,%esp
  printf(1, "kill... ");
     cc8:	83 ec 08             	sub    $0x8,%esp
     ccb:	68 0c 4b 00 00       	push   $0x4b0c
     cd0:	6a 01                	push   $0x1
     cd2:	e8 6c 35 00 00       	call   4243 <printf>
     cd7:	83 c4 10             	add    $0x10,%esp
  kill(pid1);
     cda:	83 ec 0c             	sub    $0xc,%esp
     cdd:	ff 75 f4             	pushl  -0xc(%ebp)
     ce0:	e8 fa 33 00 00       	call   40df <kill>
     ce5:	83 c4 10             	add    $0x10,%esp
  kill(pid2);
     ce8:	83 ec 0c             	sub    $0xc,%esp
     ceb:	ff 75 f0             	pushl  -0x10(%ebp)
     cee:	e8 ec 33 00 00       	call   40df <kill>
     cf3:	83 c4 10             	add    $0x10,%esp
  kill(pid3);
     cf6:	83 ec 0c             	sub    $0xc,%esp
     cf9:	ff 75 ec             	pushl  -0x14(%ebp)
     cfc:	e8 de 33 00 00       	call   40df <kill>
     d01:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
     d04:	83 ec 08             	sub    $0x8,%esp
     d07:	68 15 4b 00 00       	push   $0x4b15
     d0c:	6a 01                	push   $0x1
     d0e:	e8 30 35 00 00       	call   4243 <printf>
     d13:	83 c4 10             	add    $0x10,%esp
  wait();
     d16:	e8 9c 33 00 00       	call   40b7 <wait>
  wait();
     d1b:	e8 97 33 00 00       	call   40b7 <wait>
  wait();
     d20:	e8 92 33 00 00       	call   40b7 <wait>
  printf(1, "preempt ok\n");
     d25:	83 ec 08             	sub    $0x8,%esp
     d28:	68 1e 4b 00 00       	push   $0x4b1e
     d2d:	6a 01                	push   $0x1
     d2f:	e8 0f 35 00 00       	call   4243 <printf>
     d34:	83 c4 10             	add    $0x10,%esp
}
     d37:	c9                   	leave  
     d38:	c3                   	ret    

00000d39 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     d39:	f3 0f 1e fb          	endbr32 
     d3d:	55                   	push   %ebp
     d3e:	89 e5                	mov    %esp,%ebp
     d40:	83 ec 18             	sub    $0x18,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     d43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d4a:	eb 4f                	jmp    d9b <exitwait+0x62>
    pid = fork();
     d4c:	e8 56 33 00 00       	call   40a7 <fork>
     d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     d54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d58:	79 14                	jns    d6e <exitwait+0x35>
      printf(1, "fork failed\n");
     d5a:	83 ec 08             	sub    $0x8,%esp
     d5d:	68 ad 46 00 00       	push   $0x46ad
     d62:	6a 01                	push   $0x1
     d64:	e8 da 34 00 00       	call   4243 <printf>
     d69:	83 c4 10             	add    $0x10,%esp
      return;
     d6c:	eb 45                	jmp    db3 <exitwait+0x7a>
    }
    if(pid){
     d6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d72:	74 1e                	je     d92 <exitwait+0x59>
      if(wait() != pid){
     d74:	e8 3e 33 00 00       	call   40b7 <wait>
     d79:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     d7c:	74 19                	je     d97 <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     d7e:	83 ec 08             	sub    $0x8,%esp
     d81:	68 2a 4b 00 00       	push   $0x4b2a
     d86:	6a 01                	push   $0x1
     d88:	e8 b6 34 00 00       	call   4243 <printf>
     d8d:	83 c4 10             	add    $0x10,%esp
        return;
     d90:	eb 21                	jmp    db3 <exitwait+0x7a>
      }
    } else {
      exit();
     d92:	e8 18 33 00 00       	call   40af <exit>
  for(i = 0; i < 100; i++){
     d97:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d9b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d9f:	7e ab                	jle    d4c <exitwait+0x13>
    }
  }
  printf(1, "exitwait ok\n");
     da1:	83 ec 08             	sub    $0x8,%esp
     da4:	68 3a 4b 00 00       	push   $0x4b3a
     da9:	6a 01                	push   $0x1
     dab:	e8 93 34 00 00       	call   4243 <printf>
     db0:	83 c4 10             	add    $0x10,%esp
}
     db3:	c9                   	leave  
     db4:	c3                   	ret    

00000db5 <mem>:

void
mem(void)
{
     db5:	f3 0f 1e fb          	endbr32 
     db9:	55                   	push   %ebp
     dba:	89 e5                	mov    %esp,%ebp
     dbc:	83 ec 18             	sub    $0x18,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     dbf:	83 ec 08             	sub    $0x8,%esp
     dc2:	68 47 4b 00 00       	push   $0x4b47
     dc7:	6a 01                	push   $0x1
     dc9:	e8 75 34 00 00       	call   4243 <printf>
     dce:	83 c4 10             	add    $0x10,%esp
  ppid = getpid();
     dd1:	e8 59 33 00 00       	call   412f <getpid>
     dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     dd9:	e8 c9 32 00 00       	call   40a7 <fork>
     dde:	89 45 ec             	mov    %eax,-0x14(%ebp)
     de1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     de5:	0f 85 b7 00 00 00    	jne    ea2 <mem+0xed>
    m1 = 0;
     deb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     df2:	eb 0e                	jmp    e02 <mem+0x4d>
      *(char**)m2 = m1;
     df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     df7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dfa:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     e02:	83 ec 0c             	sub    $0xc,%esp
     e05:	68 11 27 00 00       	push   $0x2711
     e0a:	e8 14 37 00 00       	call   4523 <malloc>
     e0f:	83 c4 10             	add    $0x10,%esp
     e12:	89 45 e8             	mov    %eax,-0x18(%ebp)
     e15:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e19:	75 d9                	jne    df4 <mem+0x3f>
    }
    while(m1){
     e1b:	eb 1c                	jmp    e39 <mem+0x84>
      m2 = *(char**)m1;
     e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e20:	8b 00                	mov    (%eax),%eax
     e22:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     e25:	83 ec 0c             	sub    $0xc,%esp
     e28:	ff 75 f4             	pushl  -0xc(%ebp)
     e2b:	e8 a9 35 00 00       	call   43d9 <free>
     e30:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     e33:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(m1){
     e39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e3d:	75 de                	jne    e1d <mem+0x68>
    }
    m1 = malloc(1024*20);
     e3f:	83 ec 0c             	sub    $0xc,%esp
     e42:	68 00 50 00 00       	push   $0x5000
     e47:	e8 d7 36 00 00       	call   4523 <malloc>
     e4c:	83 c4 10             	add    $0x10,%esp
     e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     e52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e56:	75 25                	jne    e7d <mem+0xc8>
      printf(1, "couldn't allocate mem?!!\n");
     e58:	83 ec 08             	sub    $0x8,%esp
     e5b:	68 51 4b 00 00       	push   $0x4b51
     e60:	6a 01                	push   $0x1
     e62:	e8 dc 33 00 00       	call   4243 <printf>
     e67:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
     e6a:	83 ec 0c             	sub    $0xc,%esp
     e6d:	ff 75 f0             	pushl  -0x10(%ebp)
     e70:	e8 6a 32 00 00       	call   40df <kill>
     e75:	83 c4 10             	add    $0x10,%esp
      exit();
     e78:	e8 32 32 00 00       	call   40af <exit>
    }
    free(m1);
     e7d:	83 ec 0c             	sub    $0xc,%esp
     e80:	ff 75 f4             	pushl  -0xc(%ebp)
     e83:	e8 51 35 00 00       	call   43d9 <free>
     e88:	83 c4 10             	add    $0x10,%esp
    printf(1, "mem ok\n");
     e8b:	83 ec 08             	sub    $0x8,%esp
     e8e:	68 6b 4b 00 00       	push   $0x4b6b
     e93:	6a 01                	push   $0x1
     e95:	e8 a9 33 00 00       	call   4243 <printf>
     e9a:	83 c4 10             	add    $0x10,%esp
    exit();
     e9d:	e8 0d 32 00 00       	call   40af <exit>
  } else {
    wait();
     ea2:	e8 10 32 00 00       	call   40b7 <wait>
  }
}
     ea7:	90                   	nop
     ea8:	c9                   	leave  
     ea9:	c3                   	ret    

00000eaa <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     eaa:	f3 0f 1e fb          	endbr32 
     eae:	55                   	push   %ebp
     eaf:	89 e5                	mov    %esp,%ebp
     eb1:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     eb4:	83 ec 08             	sub    $0x8,%esp
     eb7:	68 73 4b 00 00       	push   $0x4b73
     ebc:	6a 01                	push   $0x1
     ebe:	e8 80 33 00 00       	call   4243 <printf>
     ec3:	83 c4 10             	add    $0x10,%esp

  unlink("sharedfd");
     ec6:	83 ec 0c             	sub    $0xc,%esp
     ec9:	68 82 4b 00 00       	push   $0x4b82
     ece:	e8 2c 32 00 00       	call   40ff <unlink>
     ed3:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", O_CREATE|O_RDWR);
     ed6:	83 ec 08             	sub    $0x8,%esp
     ed9:	68 02 02 00 00       	push   $0x202
     ede:	68 82 4b 00 00       	push   $0x4b82
     ee3:	e8 07 32 00 00       	call   40ef <open>
     ee8:	83 c4 10             	add    $0x10,%esp
     eeb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     eee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ef2:	79 17                	jns    f0b <sharedfd+0x61>
    printf(1, "fstests: cannot open sharedfd for writing");
     ef4:	83 ec 08             	sub    $0x8,%esp
     ef7:	68 8c 4b 00 00       	push   $0x4b8c
     efc:	6a 01                	push   $0x1
     efe:	e8 40 33 00 00       	call   4243 <printf>
     f03:	83 c4 10             	add    $0x10,%esp
    return;
     f06:	e9 84 01 00 00       	jmp    108f <sharedfd+0x1e5>
  }
  pid = fork();
     f0b:	e8 97 31 00 00       	call   40a7 <fork>
     f10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     f13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     f17:	75 07                	jne    f20 <sharedfd+0x76>
     f19:	b8 63 00 00 00       	mov    $0x63,%eax
     f1e:	eb 05                	jmp    f25 <sharedfd+0x7b>
     f20:	b8 70 00 00 00       	mov    $0x70,%eax
     f25:	83 ec 04             	sub    $0x4,%esp
     f28:	6a 0a                	push   $0xa
     f2a:	50                   	push   %eax
     f2b:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f2e:	50                   	push   %eax
     f2f:	e8 c8 2f 00 00       	call   3efc <memset>
     f34:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 1000; i++){
     f37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f3e:	eb 31                	jmp    f71 <sharedfd+0xc7>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     f40:	83 ec 04             	sub    $0x4,%esp
     f43:	6a 0a                	push   $0xa
     f45:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f48:	50                   	push   %eax
     f49:	ff 75 e8             	pushl  -0x18(%ebp)
     f4c:	e8 7e 31 00 00       	call   40cf <write>
     f51:	83 c4 10             	add    $0x10,%esp
     f54:	83 f8 0a             	cmp    $0xa,%eax
     f57:	74 14                	je     f6d <sharedfd+0xc3>
      printf(1, "fstests: write sharedfd failed\n");
     f59:	83 ec 08             	sub    $0x8,%esp
     f5c:	68 b8 4b 00 00       	push   $0x4bb8
     f61:	6a 01                	push   $0x1
     f63:	e8 db 32 00 00       	call   4243 <printf>
     f68:	83 c4 10             	add    $0x10,%esp
      break;
     f6b:	eb 0d                	jmp    f7a <sharedfd+0xd0>
  for(i = 0; i < 1000; i++){
     f6d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f71:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     f78:	7e c6                	jle    f40 <sharedfd+0x96>
    }
  }
  if(pid == 0)
     f7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     f7e:	75 05                	jne    f85 <sharedfd+0xdb>
    exit();
     f80:	e8 2a 31 00 00       	call   40af <exit>
  else
    wait();
     f85:	e8 2d 31 00 00       	call   40b7 <wait>
  close(fd);
     f8a:	83 ec 0c             	sub    $0xc,%esp
     f8d:	ff 75 e8             	pushl  -0x18(%ebp)
     f90:	e8 42 31 00 00       	call   40d7 <close>
     f95:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", 0);
     f98:	83 ec 08             	sub    $0x8,%esp
     f9b:	6a 00                	push   $0x0
     f9d:	68 82 4b 00 00       	push   $0x4b82
     fa2:	e8 48 31 00 00       	call   40ef <open>
     fa7:	83 c4 10             	add    $0x10,%esp
     faa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     fad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     fb1:	79 17                	jns    fca <sharedfd+0x120>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     fb3:	83 ec 08             	sub    $0x8,%esp
     fb6:	68 d8 4b 00 00       	push   $0x4bd8
     fbb:	6a 01                	push   $0x1
     fbd:	e8 81 32 00 00       	call   4243 <printf>
     fc2:	83 c4 10             	add    $0x10,%esp
    return;
     fc5:	e9 c5 00 00 00       	jmp    108f <sharedfd+0x1e5>
  }
  nc = np = 0;
     fca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     fd7:	eb 3b                	jmp    1014 <sharedfd+0x16a>
    for(i = 0; i < sizeof(buf); i++){
     fd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     fe0:	eb 2a                	jmp    100c <sharedfd+0x162>
      if(buf[i] == 'c')
     fe2:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fe8:	01 d0                	add    %edx,%eax
     fea:	0f b6 00             	movzbl (%eax),%eax
     fed:	3c 63                	cmp    $0x63,%al
     fef:	75 04                	jne    ff5 <sharedfd+0x14b>
        nc++;
     ff1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     ff5:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ffb:	01 d0                	add    %edx,%eax
     ffd:	0f b6 00             	movzbl (%eax),%eax
    1000:	3c 70                	cmp    $0x70,%al
    1002:	75 04                	jne    1008 <sharedfd+0x15e>
        np++;
    1004:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    for(i = 0; i < sizeof(buf); i++){
    1008:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    100c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    100f:	83 f8 09             	cmp    $0x9,%eax
    1012:	76 ce                	jbe    fe2 <sharedfd+0x138>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1014:	83 ec 04             	sub    $0x4,%esp
    1017:	6a 0a                	push   $0xa
    1019:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    101c:	50                   	push   %eax
    101d:	ff 75 e8             	pushl  -0x18(%ebp)
    1020:	e8 a2 30 00 00       	call   40c7 <read>
    1025:	83 c4 10             	add    $0x10,%esp
    1028:	89 45 e0             	mov    %eax,-0x20(%ebp)
    102b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    102f:	7f a8                	jg     fd9 <sharedfd+0x12f>
    }
  }
  close(fd);
    1031:	83 ec 0c             	sub    $0xc,%esp
    1034:	ff 75 e8             	pushl  -0x18(%ebp)
    1037:	e8 9b 30 00 00       	call   40d7 <close>
    103c:	83 c4 10             	add    $0x10,%esp
  unlink("sharedfd");
    103f:	83 ec 0c             	sub    $0xc,%esp
    1042:	68 82 4b 00 00       	push   $0x4b82
    1047:	e8 b3 30 00 00       	call   40ff <unlink>
    104c:	83 c4 10             	add    $0x10,%esp
  if(nc == 10000 && np == 10000){
    104f:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
    1056:	75 1d                	jne    1075 <sharedfd+0x1cb>
    1058:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
    105f:	75 14                	jne    1075 <sharedfd+0x1cb>
    printf(1, "sharedfd ok\n");
    1061:	83 ec 08             	sub    $0x8,%esp
    1064:	68 03 4c 00 00       	push   $0x4c03
    1069:	6a 01                	push   $0x1
    106b:	e8 d3 31 00 00       	call   4243 <printf>
    1070:	83 c4 10             	add    $0x10,%esp
    1073:	eb 1a                	jmp    108f <sharedfd+0x1e5>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1075:	ff 75 ec             	pushl  -0x14(%ebp)
    1078:	ff 75 f0             	pushl  -0x10(%ebp)
    107b:	68 10 4c 00 00       	push   $0x4c10
    1080:	6a 01                	push   $0x1
    1082:	e8 bc 31 00 00       	call   4243 <printf>
    1087:	83 c4 10             	add    $0x10,%esp
    exit();
    108a:	e8 20 30 00 00       	call   40af <exit>
  }
}
    108f:	c9                   	leave  
    1090:	c3                   	ret    

00001091 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1091:	f3 0f 1e fb          	endbr32 
    1095:	55                   	push   %ebp
    1096:	89 e5                	mov    %esp,%ebp
    1098:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    109b:	c7 45 c8 25 4c 00 00 	movl   $0x4c25,-0x38(%ebp)
    10a2:	c7 45 cc 28 4c 00 00 	movl   $0x4c28,-0x34(%ebp)
    10a9:	c7 45 d0 2b 4c 00 00 	movl   $0x4c2b,-0x30(%ebp)
    10b0:	c7 45 d4 2e 4c 00 00 	movl   $0x4c2e,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    10b7:	83 ec 08             	sub    $0x8,%esp
    10ba:	68 31 4c 00 00       	push   $0x4c31
    10bf:	6a 01                	push   $0x1
    10c1:	e8 7d 31 00 00       	call   4243 <printf>
    10c6:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    10c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    10d0:	e9 f0 00 00 00       	jmp    11c5 <fourfiles+0x134>
    fname = names[pi];
    10d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10d8:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    10dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    10df:	83 ec 0c             	sub    $0xc,%esp
    10e2:	ff 75 e4             	pushl  -0x1c(%ebp)
    10e5:	e8 15 30 00 00       	call   40ff <unlink>
    10ea:	83 c4 10             	add    $0x10,%esp

    pid = fork();
    10ed:	e8 b5 2f 00 00       	call   40a7 <fork>
    10f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if(pid < 0){
    10f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    10f9:	79 17                	jns    1112 <fourfiles+0x81>
      printf(1, "fork failed\n");
    10fb:	83 ec 08             	sub    $0x8,%esp
    10fe:	68 ad 46 00 00       	push   $0x46ad
    1103:	6a 01                	push   $0x1
    1105:	e8 39 31 00 00       	call   4243 <printf>
    110a:	83 c4 10             	add    $0x10,%esp
      exit();
    110d:	e8 9d 2f 00 00       	call   40af <exit>
    }

    if(pid == 0){
    1112:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    1116:	0f 85 a5 00 00 00    	jne    11c1 <fourfiles+0x130>
      fd = open(fname, O_CREATE | O_RDWR);
    111c:	83 ec 08             	sub    $0x8,%esp
    111f:	68 02 02 00 00       	push   $0x202
    1124:	ff 75 e4             	pushl  -0x1c(%ebp)
    1127:	e8 c3 2f 00 00       	call   40ef <open>
    112c:	83 c4 10             	add    $0x10,%esp
    112f:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(fd < 0){
    1132:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1136:	79 17                	jns    114f <fourfiles+0xbe>
        printf(1, "create failed\n");
    1138:	83 ec 08             	sub    $0x8,%esp
    113b:	68 41 4c 00 00       	push   $0x4c41
    1140:	6a 01                	push   $0x1
    1142:	e8 fc 30 00 00       	call   4243 <printf>
    1147:	83 c4 10             	add    $0x10,%esp
        exit();
    114a:	e8 60 2f 00 00       	call   40af <exit>
      }

      memset(buf, '0'+pi, 512);
    114f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1152:	83 c0 30             	add    $0x30,%eax
    1155:	83 ec 04             	sub    $0x4,%esp
    1158:	68 00 02 00 00       	push   $0x200
    115d:	50                   	push   %eax
    115e:	68 40 8d 00 00       	push   $0x8d40
    1163:	e8 94 2d 00 00       	call   3efc <memset>
    1168:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 12; i++){
    116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1172:	eb 42                	jmp    11b6 <fourfiles+0x125>
        if((n = write(fd, buf, 500)) != 500){
    1174:	83 ec 04             	sub    $0x4,%esp
    1177:	68 f4 01 00 00       	push   $0x1f4
    117c:	68 40 8d 00 00       	push   $0x8d40
    1181:	ff 75 e0             	pushl  -0x20(%ebp)
    1184:	e8 46 2f 00 00       	call   40cf <write>
    1189:	83 c4 10             	add    $0x10,%esp
    118c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    118f:	81 7d dc f4 01 00 00 	cmpl   $0x1f4,-0x24(%ebp)
    1196:	74 1a                	je     11b2 <fourfiles+0x121>
          printf(1, "write failed %d\n", n);
    1198:	83 ec 04             	sub    $0x4,%esp
    119b:	ff 75 dc             	pushl  -0x24(%ebp)
    119e:	68 50 4c 00 00       	push   $0x4c50
    11a3:	6a 01                	push   $0x1
    11a5:	e8 99 30 00 00       	call   4243 <printf>
    11aa:	83 c4 10             	add    $0x10,%esp
          exit();
    11ad:	e8 fd 2e 00 00       	call   40af <exit>
      for(i = 0; i < 12; i++){
    11b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11b6:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    11ba:	7e b8                	jle    1174 <fourfiles+0xe3>
        }
      }
      exit();
    11bc:	e8 ee 2e 00 00       	call   40af <exit>
  for(pi = 0; pi < 4; pi++){
    11c1:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    11c5:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    11c9:	0f 8e 06 ff ff ff    	jle    10d5 <fourfiles+0x44>
    }
  }

  for(pi = 0; pi < 4; pi++){
    11cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    11d6:	eb 09                	jmp    11e1 <fourfiles+0x150>
    wait();
    11d8:	e8 da 2e 00 00       	call   40b7 <wait>
  for(pi = 0; pi < 4; pi++){
    11dd:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    11e1:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    11e5:	7e f1                	jle    11d8 <fourfiles+0x147>
  }

  for(i = 0; i < 2; i++){
    11e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11ee:	e9 d4 00 00 00       	jmp    12c7 <fourfiles+0x236>
    fname = names[i];
    11f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11f6:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    11fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    11fd:	83 ec 08             	sub    $0x8,%esp
    1200:	6a 00                	push   $0x0
    1202:	ff 75 e4             	pushl  -0x1c(%ebp)
    1205:	e8 e5 2e 00 00       	call   40ef <open>
    120a:	83 c4 10             	add    $0x10,%esp
    120d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    total = 0;
    1210:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1217:	eb 4a                	jmp    1263 <fourfiles+0x1d2>
      for(j = 0; j < n; j++){
    1219:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1220:	eb 33                	jmp    1255 <fourfiles+0x1c4>
        if(buf[j] != '0'+i){
    1222:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1225:	05 40 8d 00 00       	add    $0x8d40,%eax
    122a:	0f b6 00             	movzbl (%eax),%eax
    122d:	0f be c0             	movsbl %al,%eax
    1230:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1233:	83 c2 30             	add    $0x30,%edx
    1236:	39 d0                	cmp    %edx,%eax
    1238:	74 17                	je     1251 <fourfiles+0x1c0>
          printf(1, "wrong char\n");
    123a:	83 ec 08             	sub    $0x8,%esp
    123d:	68 61 4c 00 00       	push   $0x4c61
    1242:	6a 01                	push   $0x1
    1244:	e8 fa 2f 00 00       	call   4243 <printf>
    1249:	83 c4 10             	add    $0x10,%esp
          exit();
    124c:	e8 5e 2e 00 00       	call   40af <exit>
      for(j = 0; j < n; j++){
    1251:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1255:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1258:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    125b:	7c c5                	jl     1222 <fourfiles+0x191>
        }
      }
      total += n;
    125d:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1260:	01 45 ec             	add    %eax,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1263:	83 ec 04             	sub    $0x4,%esp
    1266:	68 00 20 00 00       	push   $0x2000
    126b:	68 40 8d 00 00       	push   $0x8d40
    1270:	ff 75 e0             	pushl  -0x20(%ebp)
    1273:	e8 4f 2e 00 00       	call   40c7 <read>
    1278:	83 c4 10             	add    $0x10,%esp
    127b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    127e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    1282:	7f 95                	jg     1219 <fourfiles+0x188>
    }
    close(fd);
    1284:	83 ec 0c             	sub    $0xc,%esp
    1287:	ff 75 e0             	pushl  -0x20(%ebp)
    128a:	e8 48 2e 00 00       	call   40d7 <close>
    128f:	83 c4 10             	add    $0x10,%esp
    if(total != 12*500){
    1292:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    1299:	74 1a                	je     12b5 <fourfiles+0x224>
      printf(1, "wrong length %d\n", total);
    129b:	83 ec 04             	sub    $0x4,%esp
    129e:	ff 75 ec             	pushl  -0x14(%ebp)
    12a1:	68 6d 4c 00 00       	push   $0x4c6d
    12a6:	6a 01                	push   $0x1
    12a8:	e8 96 2f 00 00       	call   4243 <printf>
    12ad:	83 c4 10             	add    $0x10,%esp
      exit();
    12b0:	e8 fa 2d 00 00       	call   40af <exit>
    }
    unlink(fname);
    12b5:	83 ec 0c             	sub    $0xc,%esp
    12b8:	ff 75 e4             	pushl  -0x1c(%ebp)
    12bb:	e8 3f 2e 00 00       	call   40ff <unlink>
    12c0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 2; i++){
    12c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    12c7:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    12cb:	0f 8e 22 ff ff ff    	jle    11f3 <fourfiles+0x162>
  }

  printf(1, "fourfiles ok\n");
    12d1:	83 ec 08             	sub    $0x8,%esp
    12d4:	68 7e 4c 00 00       	push   $0x4c7e
    12d9:	6a 01                	push   $0x1
    12db:	e8 63 2f 00 00       	call   4243 <printf>
    12e0:	83 c4 10             	add    $0x10,%esp
}
    12e3:	90                   	nop
    12e4:	c9                   	leave  
    12e5:	c3                   	ret    

000012e6 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    12e6:	f3 0f 1e fb          	endbr32 
    12ea:	55                   	push   %ebp
    12eb:	89 e5                	mov    %esp,%ebp
    12ed:	83 ec 38             	sub    $0x38,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    12f0:	83 ec 08             	sub    $0x8,%esp
    12f3:	68 8c 4c 00 00       	push   $0x4c8c
    12f8:	6a 01                	push   $0x1
    12fa:	e8 44 2f 00 00       	call   4243 <printf>
    12ff:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    1302:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1309:	e9 f6 00 00 00       	jmp    1404 <createdelete+0x11e>
    pid = fork();
    130e:	e8 94 2d 00 00       	call   40a7 <fork>
    1313:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    1316:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    131a:	79 17                	jns    1333 <createdelete+0x4d>
      printf(1, "fork failed\n");
    131c:	83 ec 08             	sub    $0x8,%esp
    131f:	68 ad 46 00 00       	push   $0x46ad
    1324:	6a 01                	push   $0x1
    1326:	e8 18 2f 00 00       	call   4243 <printf>
    132b:	83 c4 10             	add    $0x10,%esp
      exit();
    132e:	e8 7c 2d 00 00       	call   40af <exit>
    }

    if(pid == 0){
    1333:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1337:	0f 85 c3 00 00 00    	jne    1400 <createdelete+0x11a>
      name[0] = 'p' + pi;
    133d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1340:	83 c0 70             	add    $0x70,%eax
    1343:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    1346:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    134a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1351:	e9 9b 00 00 00       	jmp    13f1 <createdelete+0x10b>
        name[1] = '0' + i;
    1356:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1359:	83 c0 30             	add    $0x30,%eax
    135c:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    135f:	83 ec 08             	sub    $0x8,%esp
    1362:	68 02 02 00 00       	push   $0x202
    1367:	8d 45 c8             	lea    -0x38(%ebp),%eax
    136a:	50                   	push   %eax
    136b:	e8 7f 2d 00 00       	call   40ef <open>
    1370:	83 c4 10             	add    $0x10,%esp
    1373:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if(fd < 0){
    1376:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    137a:	79 17                	jns    1393 <createdelete+0xad>
          printf(1, "create failed\n");
    137c:	83 ec 08             	sub    $0x8,%esp
    137f:	68 41 4c 00 00       	push   $0x4c41
    1384:	6a 01                	push   $0x1
    1386:	e8 b8 2e 00 00       	call   4243 <printf>
    138b:	83 c4 10             	add    $0x10,%esp
          exit();
    138e:	e8 1c 2d 00 00       	call   40af <exit>
        }
        close(fd);
    1393:	83 ec 0c             	sub    $0xc,%esp
    1396:	ff 75 ec             	pushl  -0x14(%ebp)
    1399:	e8 39 2d 00 00       	call   40d7 <close>
    139e:	83 c4 10             	add    $0x10,%esp
        if(i > 0 && (i % 2 ) == 0){
    13a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13a5:	7e 46                	jle    13ed <createdelete+0x107>
    13a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13aa:	83 e0 01             	and    $0x1,%eax
    13ad:	85 c0                	test   %eax,%eax
    13af:	75 3c                	jne    13ed <createdelete+0x107>
          name[1] = '0' + (i / 2);
    13b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b4:	89 c2                	mov    %eax,%edx
    13b6:	c1 ea 1f             	shr    $0x1f,%edx
    13b9:	01 d0                	add    %edx,%eax
    13bb:	d1 f8                	sar    %eax
    13bd:	83 c0 30             	add    $0x30,%eax
    13c0:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    13c3:	83 ec 0c             	sub    $0xc,%esp
    13c6:	8d 45 c8             	lea    -0x38(%ebp),%eax
    13c9:	50                   	push   %eax
    13ca:	e8 30 2d 00 00       	call   40ff <unlink>
    13cf:	83 c4 10             	add    $0x10,%esp
    13d2:	85 c0                	test   %eax,%eax
    13d4:	79 17                	jns    13ed <createdelete+0x107>
            printf(1, "unlink failed\n");
    13d6:	83 ec 08             	sub    $0x8,%esp
    13d9:	68 30 47 00 00       	push   $0x4730
    13de:	6a 01                	push   $0x1
    13e0:	e8 5e 2e 00 00       	call   4243 <printf>
    13e5:	83 c4 10             	add    $0x10,%esp
            exit();
    13e8:	e8 c2 2c 00 00       	call   40af <exit>
      for(i = 0; i < N; i++){
    13ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    13f1:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    13f5:	0f 8e 5b ff ff ff    	jle    1356 <createdelete+0x70>
          }
        }
      }
      exit();
    13fb:	e8 af 2c 00 00       	call   40af <exit>
  for(pi = 0; pi < 4; pi++){
    1400:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1404:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1408:	0f 8e 00 ff ff ff    	jle    130e <createdelete+0x28>
    }
  }

  for(pi = 0; pi < 4; pi++){
    140e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1415:	eb 09                	jmp    1420 <createdelete+0x13a>
    wait();
    1417:	e8 9b 2c 00 00       	call   40b7 <wait>
  for(pi = 0; pi < 4; pi++){
    141c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1420:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1424:	7e f1                	jle    1417 <createdelete+0x131>
  }

  name[0] = name[1] = name[2] = 0;
    1426:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    142a:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    142e:	88 45 c9             	mov    %al,-0x37(%ebp)
    1431:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    1435:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    1438:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    143f:	e9 b2 00 00 00       	jmp    14f6 <createdelete+0x210>
    for(pi = 0; pi < 4; pi++){
    1444:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    144b:	e9 98 00 00 00       	jmp    14e8 <createdelete+0x202>
      name[0] = 'p' + pi;
    1450:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1453:	83 c0 70             	add    $0x70,%eax
    1456:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1459:	8b 45 f4             	mov    -0xc(%ebp),%eax
    145c:	83 c0 30             	add    $0x30,%eax
    145f:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1462:	83 ec 08             	sub    $0x8,%esp
    1465:	6a 00                	push   $0x0
    1467:	8d 45 c8             	lea    -0x38(%ebp),%eax
    146a:	50                   	push   %eax
    146b:	e8 7f 2c 00 00       	call   40ef <open>
    1470:	83 c4 10             	add    $0x10,%esp
    1473:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    1476:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    147a:	74 06                	je     1482 <createdelete+0x19c>
    147c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1480:	7e 21                	jle    14a3 <createdelete+0x1bd>
    1482:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1486:	79 1b                	jns    14a3 <createdelete+0x1bd>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1488:	83 ec 04             	sub    $0x4,%esp
    148b:	8d 45 c8             	lea    -0x38(%ebp),%eax
    148e:	50                   	push   %eax
    148f:	68 a0 4c 00 00       	push   $0x4ca0
    1494:	6a 01                	push   $0x1
    1496:	e8 a8 2d 00 00       	call   4243 <printf>
    149b:	83 c4 10             	add    $0x10,%esp
        exit();
    149e:	e8 0c 2c 00 00       	call   40af <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    14a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14a7:	7e 27                	jle    14d0 <createdelete+0x1ea>
    14a9:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    14ad:	7f 21                	jg     14d0 <createdelete+0x1ea>
    14af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14b3:	78 1b                	js     14d0 <createdelete+0x1ea>
        printf(1, "oops createdelete %s did exist\n", name);
    14b5:	83 ec 04             	sub    $0x4,%esp
    14b8:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14bb:	50                   	push   %eax
    14bc:	68 c4 4c 00 00       	push   $0x4cc4
    14c1:	6a 01                	push   $0x1
    14c3:	e8 7b 2d 00 00       	call   4243 <printf>
    14c8:	83 c4 10             	add    $0x10,%esp
        exit();
    14cb:	e8 df 2b 00 00       	call   40af <exit>
      }
      if(fd >= 0)
    14d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14d4:	78 0e                	js     14e4 <createdelete+0x1fe>
        close(fd);
    14d6:	83 ec 0c             	sub    $0xc,%esp
    14d9:	ff 75 ec             	pushl  -0x14(%ebp)
    14dc:	e8 f6 2b 00 00       	call   40d7 <close>
    14e1:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    14e4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14e8:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14ec:	0f 8e 5e ff ff ff    	jle    1450 <createdelete+0x16a>
  for(i = 0; i < N; i++){
    14f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14f6:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14fa:	0f 8e 44 ff ff ff    	jle    1444 <createdelete+0x15e>
    }
  }

  for(i = 0; i < N; i++){
    1500:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1507:	eb 38                	jmp    1541 <createdelete+0x25b>
    for(pi = 0; pi < 4; pi++){
    1509:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1510:	eb 25                	jmp    1537 <createdelete+0x251>
      name[0] = 'p' + i;
    1512:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1515:	83 c0 70             	add    $0x70,%eax
    1518:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    151b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    151e:	83 c0 30             	add    $0x30,%eax
    1521:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    1524:	83 ec 0c             	sub    $0xc,%esp
    1527:	8d 45 c8             	lea    -0x38(%ebp),%eax
    152a:	50                   	push   %eax
    152b:	e8 cf 2b 00 00       	call   40ff <unlink>
    1530:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    1533:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1537:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    153b:	7e d5                	jle    1512 <createdelete+0x22c>
  for(i = 0; i < N; i++){
    153d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1541:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1545:	7e c2                	jle    1509 <createdelete+0x223>
    }
  }

  printf(1, "createdelete ok\n");
    1547:	83 ec 08             	sub    $0x8,%esp
    154a:	68 e4 4c 00 00       	push   $0x4ce4
    154f:	6a 01                	push   $0x1
    1551:	e8 ed 2c 00 00       	call   4243 <printf>
    1556:	83 c4 10             	add    $0x10,%esp
}
    1559:	90                   	nop
    155a:	c9                   	leave  
    155b:	c3                   	ret    

0000155c <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    155c:	f3 0f 1e fb          	endbr32 
    1560:	55                   	push   %ebp
    1561:	89 e5                	mov    %esp,%ebp
    1563:	83 ec 18             	sub    $0x18,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1566:	83 ec 08             	sub    $0x8,%esp
    1569:	68 f5 4c 00 00       	push   $0x4cf5
    156e:	6a 01                	push   $0x1
    1570:	e8 ce 2c 00 00       	call   4243 <printf>
    1575:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1578:	83 ec 08             	sub    $0x8,%esp
    157b:	68 02 02 00 00       	push   $0x202
    1580:	68 06 4d 00 00       	push   $0x4d06
    1585:	e8 65 2b 00 00       	call   40ef <open>
    158a:	83 c4 10             	add    $0x10,%esp
    158d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1594:	79 17                	jns    15ad <unlinkread+0x51>
    printf(1, "create unlinkread failed\n");
    1596:	83 ec 08             	sub    $0x8,%esp
    1599:	68 11 4d 00 00       	push   $0x4d11
    159e:	6a 01                	push   $0x1
    15a0:	e8 9e 2c 00 00       	call   4243 <printf>
    15a5:	83 c4 10             	add    $0x10,%esp
    exit();
    15a8:	e8 02 2b 00 00       	call   40af <exit>
  }
  write(fd, "hello", 5);
    15ad:	83 ec 04             	sub    $0x4,%esp
    15b0:	6a 05                	push   $0x5
    15b2:	68 2b 4d 00 00       	push   $0x4d2b
    15b7:	ff 75 f4             	pushl  -0xc(%ebp)
    15ba:	e8 10 2b 00 00       	call   40cf <write>
    15bf:	83 c4 10             	add    $0x10,%esp
  close(fd);
    15c2:	83 ec 0c             	sub    $0xc,%esp
    15c5:	ff 75 f4             	pushl  -0xc(%ebp)
    15c8:	e8 0a 2b 00 00       	call   40d7 <close>
    15cd:	83 c4 10             	add    $0x10,%esp

  fd = open("unlinkread", O_RDWR);
    15d0:	83 ec 08             	sub    $0x8,%esp
    15d3:	6a 02                	push   $0x2
    15d5:	68 06 4d 00 00       	push   $0x4d06
    15da:	e8 10 2b 00 00       	call   40ef <open>
    15df:	83 c4 10             	add    $0x10,%esp
    15e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    15e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15e9:	79 17                	jns    1602 <unlinkread+0xa6>
    printf(1, "open unlinkread failed\n");
    15eb:	83 ec 08             	sub    $0x8,%esp
    15ee:	68 31 4d 00 00       	push   $0x4d31
    15f3:	6a 01                	push   $0x1
    15f5:	e8 49 2c 00 00       	call   4243 <printf>
    15fa:	83 c4 10             	add    $0x10,%esp
    exit();
    15fd:	e8 ad 2a 00 00       	call   40af <exit>
  }
  if(unlink("unlinkread") != 0){
    1602:	83 ec 0c             	sub    $0xc,%esp
    1605:	68 06 4d 00 00       	push   $0x4d06
    160a:	e8 f0 2a 00 00       	call   40ff <unlink>
    160f:	83 c4 10             	add    $0x10,%esp
    1612:	85 c0                	test   %eax,%eax
    1614:	74 17                	je     162d <unlinkread+0xd1>
    printf(1, "unlink unlinkread failed\n");
    1616:	83 ec 08             	sub    $0x8,%esp
    1619:	68 49 4d 00 00       	push   $0x4d49
    161e:	6a 01                	push   $0x1
    1620:	e8 1e 2c 00 00       	call   4243 <printf>
    1625:	83 c4 10             	add    $0x10,%esp
    exit();
    1628:	e8 82 2a 00 00       	call   40af <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    162d:	83 ec 08             	sub    $0x8,%esp
    1630:	68 02 02 00 00       	push   $0x202
    1635:	68 06 4d 00 00       	push   $0x4d06
    163a:	e8 b0 2a 00 00       	call   40ef <open>
    163f:	83 c4 10             	add    $0x10,%esp
    1642:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    1645:	83 ec 04             	sub    $0x4,%esp
    1648:	6a 03                	push   $0x3
    164a:	68 63 4d 00 00       	push   $0x4d63
    164f:	ff 75 f0             	pushl  -0x10(%ebp)
    1652:	e8 78 2a 00 00       	call   40cf <write>
    1657:	83 c4 10             	add    $0x10,%esp
  close(fd1);
    165a:	83 ec 0c             	sub    $0xc,%esp
    165d:	ff 75 f0             	pushl  -0x10(%ebp)
    1660:	e8 72 2a 00 00       	call   40d7 <close>
    1665:	83 c4 10             	add    $0x10,%esp

  if(read(fd, buf, sizeof(buf)) != 5){
    1668:	83 ec 04             	sub    $0x4,%esp
    166b:	68 00 20 00 00       	push   $0x2000
    1670:	68 40 8d 00 00       	push   $0x8d40
    1675:	ff 75 f4             	pushl  -0xc(%ebp)
    1678:	e8 4a 2a 00 00       	call   40c7 <read>
    167d:	83 c4 10             	add    $0x10,%esp
    1680:	83 f8 05             	cmp    $0x5,%eax
    1683:	74 17                	je     169c <unlinkread+0x140>
    printf(1, "unlinkread read failed");
    1685:	83 ec 08             	sub    $0x8,%esp
    1688:	68 67 4d 00 00       	push   $0x4d67
    168d:	6a 01                	push   $0x1
    168f:	e8 af 2b 00 00       	call   4243 <printf>
    1694:	83 c4 10             	add    $0x10,%esp
    exit();
    1697:	e8 13 2a 00 00       	call   40af <exit>
  }
  if(buf[0] != 'h'){
    169c:	0f b6 05 40 8d 00 00 	movzbl 0x8d40,%eax
    16a3:	3c 68                	cmp    $0x68,%al
    16a5:	74 17                	je     16be <unlinkread+0x162>
    printf(1, "unlinkread wrong data\n");
    16a7:	83 ec 08             	sub    $0x8,%esp
    16aa:	68 7e 4d 00 00       	push   $0x4d7e
    16af:	6a 01                	push   $0x1
    16b1:	e8 8d 2b 00 00       	call   4243 <printf>
    16b6:	83 c4 10             	add    $0x10,%esp
    exit();
    16b9:	e8 f1 29 00 00       	call   40af <exit>
  }
  if(write(fd, buf, 10) != 10){
    16be:	83 ec 04             	sub    $0x4,%esp
    16c1:	6a 0a                	push   $0xa
    16c3:	68 40 8d 00 00       	push   $0x8d40
    16c8:	ff 75 f4             	pushl  -0xc(%ebp)
    16cb:	e8 ff 29 00 00       	call   40cf <write>
    16d0:	83 c4 10             	add    $0x10,%esp
    16d3:	83 f8 0a             	cmp    $0xa,%eax
    16d6:	74 17                	je     16ef <unlinkread+0x193>
    printf(1, "unlinkread write failed\n");
    16d8:	83 ec 08             	sub    $0x8,%esp
    16db:	68 95 4d 00 00       	push   $0x4d95
    16e0:	6a 01                	push   $0x1
    16e2:	e8 5c 2b 00 00       	call   4243 <printf>
    16e7:	83 c4 10             	add    $0x10,%esp
    exit();
    16ea:	e8 c0 29 00 00       	call   40af <exit>
  }
  close(fd);
    16ef:	83 ec 0c             	sub    $0xc,%esp
    16f2:	ff 75 f4             	pushl  -0xc(%ebp)
    16f5:	e8 dd 29 00 00       	call   40d7 <close>
    16fa:	83 c4 10             	add    $0x10,%esp
  unlink("unlinkread");
    16fd:	83 ec 0c             	sub    $0xc,%esp
    1700:	68 06 4d 00 00       	push   $0x4d06
    1705:	e8 f5 29 00 00       	call   40ff <unlink>
    170a:	83 c4 10             	add    $0x10,%esp
  printf(1, "unlinkread ok\n");
    170d:	83 ec 08             	sub    $0x8,%esp
    1710:	68 ae 4d 00 00       	push   $0x4dae
    1715:	6a 01                	push   $0x1
    1717:	e8 27 2b 00 00       	call   4243 <printf>
    171c:	83 c4 10             	add    $0x10,%esp
}
    171f:	90                   	nop
    1720:	c9                   	leave  
    1721:	c3                   	ret    

00001722 <linktest>:

void
linktest(void)
{
    1722:	f3 0f 1e fb          	endbr32 
    1726:	55                   	push   %ebp
    1727:	89 e5                	mov    %esp,%ebp
    1729:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "linktest\n");
    172c:	83 ec 08             	sub    $0x8,%esp
    172f:	68 bd 4d 00 00       	push   $0x4dbd
    1734:	6a 01                	push   $0x1
    1736:	e8 08 2b 00 00       	call   4243 <printf>
    173b:	83 c4 10             	add    $0x10,%esp

  unlink("lf1");
    173e:	83 ec 0c             	sub    $0xc,%esp
    1741:	68 c7 4d 00 00       	push   $0x4dc7
    1746:	e8 b4 29 00 00       	call   40ff <unlink>
    174b:	83 c4 10             	add    $0x10,%esp
  unlink("lf2");
    174e:	83 ec 0c             	sub    $0xc,%esp
    1751:	68 cb 4d 00 00       	push   $0x4dcb
    1756:	e8 a4 29 00 00       	call   40ff <unlink>
    175b:	83 c4 10             	add    $0x10,%esp

  fd = open("lf1", O_CREATE|O_RDWR);
    175e:	83 ec 08             	sub    $0x8,%esp
    1761:	68 02 02 00 00       	push   $0x202
    1766:	68 c7 4d 00 00       	push   $0x4dc7
    176b:	e8 7f 29 00 00       	call   40ef <open>
    1770:	83 c4 10             	add    $0x10,%esp
    1773:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    177a:	79 17                	jns    1793 <linktest+0x71>
    printf(1, "create lf1 failed\n");
    177c:	83 ec 08             	sub    $0x8,%esp
    177f:	68 cf 4d 00 00       	push   $0x4dcf
    1784:	6a 01                	push   $0x1
    1786:	e8 b8 2a 00 00       	call   4243 <printf>
    178b:	83 c4 10             	add    $0x10,%esp
    exit();
    178e:	e8 1c 29 00 00       	call   40af <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1793:	83 ec 04             	sub    $0x4,%esp
    1796:	6a 05                	push   $0x5
    1798:	68 2b 4d 00 00       	push   $0x4d2b
    179d:	ff 75 f4             	pushl  -0xc(%ebp)
    17a0:	e8 2a 29 00 00       	call   40cf <write>
    17a5:	83 c4 10             	add    $0x10,%esp
    17a8:	83 f8 05             	cmp    $0x5,%eax
    17ab:	74 17                	je     17c4 <linktest+0xa2>
    printf(1, "write lf1 failed\n");
    17ad:	83 ec 08             	sub    $0x8,%esp
    17b0:	68 e2 4d 00 00       	push   $0x4de2
    17b5:	6a 01                	push   $0x1
    17b7:	e8 87 2a 00 00       	call   4243 <printf>
    17bc:	83 c4 10             	add    $0x10,%esp
    exit();
    17bf:	e8 eb 28 00 00       	call   40af <exit>
  }
  close(fd);
    17c4:	83 ec 0c             	sub    $0xc,%esp
    17c7:	ff 75 f4             	pushl  -0xc(%ebp)
    17ca:	e8 08 29 00 00       	call   40d7 <close>
    17cf:	83 c4 10             	add    $0x10,%esp

  if(link("lf1", "lf2") < 0){
    17d2:	83 ec 08             	sub    $0x8,%esp
    17d5:	68 cb 4d 00 00       	push   $0x4dcb
    17da:	68 c7 4d 00 00       	push   $0x4dc7
    17df:	e8 2b 29 00 00       	call   410f <link>
    17e4:	83 c4 10             	add    $0x10,%esp
    17e7:	85 c0                	test   %eax,%eax
    17e9:	79 17                	jns    1802 <linktest+0xe0>
    printf(1, "link lf1 lf2 failed\n");
    17eb:	83 ec 08             	sub    $0x8,%esp
    17ee:	68 f4 4d 00 00       	push   $0x4df4
    17f3:	6a 01                	push   $0x1
    17f5:	e8 49 2a 00 00       	call   4243 <printf>
    17fa:	83 c4 10             	add    $0x10,%esp
    exit();
    17fd:	e8 ad 28 00 00       	call   40af <exit>
  }
  unlink("lf1");
    1802:	83 ec 0c             	sub    $0xc,%esp
    1805:	68 c7 4d 00 00       	push   $0x4dc7
    180a:	e8 f0 28 00 00       	call   40ff <unlink>
    180f:	83 c4 10             	add    $0x10,%esp

  if(open("lf1", 0) >= 0){
    1812:	83 ec 08             	sub    $0x8,%esp
    1815:	6a 00                	push   $0x0
    1817:	68 c7 4d 00 00       	push   $0x4dc7
    181c:	e8 ce 28 00 00       	call   40ef <open>
    1821:	83 c4 10             	add    $0x10,%esp
    1824:	85 c0                	test   %eax,%eax
    1826:	78 17                	js     183f <linktest+0x11d>
    printf(1, "unlinked lf1 but it is still there!\n");
    1828:	83 ec 08             	sub    $0x8,%esp
    182b:	68 0c 4e 00 00       	push   $0x4e0c
    1830:	6a 01                	push   $0x1
    1832:	e8 0c 2a 00 00       	call   4243 <printf>
    1837:	83 c4 10             	add    $0x10,%esp
    exit();
    183a:	e8 70 28 00 00       	call   40af <exit>
  }

  fd = open("lf2", 0);
    183f:	83 ec 08             	sub    $0x8,%esp
    1842:	6a 00                	push   $0x0
    1844:	68 cb 4d 00 00       	push   $0x4dcb
    1849:	e8 a1 28 00 00       	call   40ef <open>
    184e:	83 c4 10             	add    $0x10,%esp
    1851:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1854:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1858:	79 17                	jns    1871 <linktest+0x14f>
    printf(1, "open lf2 failed\n");
    185a:	83 ec 08             	sub    $0x8,%esp
    185d:	68 31 4e 00 00       	push   $0x4e31
    1862:	6a 01                	push   $0x1
    1864:	e8 da 29 00 00       	call   4243 <printf>
    1869:	83 c4 10             	add    $0x10,%esp
    exit();
    186c:	e8 3e 28 00 00       	call   40af <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1871:	83 ec 04             	sub    $0x4,%esp
    1874:	68 00 20 00 00       	push   $0x2000
    1879:	68 40 8d 00 00       	push   $0x8d40
    187e:	ff 75 f4             	pushl  -0xc(%ebp)
    1881:	e8 41 28 00 00       	call   40c7 <read>
    1886:	83 c4 10             	add    $0x10,%esp
    1889:	83 f8 05             	cmp    $0x5,%eax
    188c:	74 17                	je     18a5 <linktest+0x183>
    printf(1, "read lf2 failed\n");
    188e:	83 ec 08             	sub    $0x8,%esp
    1891:	68 42 4e 00 00       	push   $0x4e42
    1896:	6a 01                	push   $0x1
    1898:	e8 a6 29 00 00       	call   4243 <printf>
    189d:	83 c4 10             	add    $0x10,%esp
    exit();
    18a0:	e8 0a 28 00 00       	call   40af <exit>
  }
  close(fd);
    18a5:	83 ec 0c             	sub    $0xc,%esp
    18a8:	ff 75 f4             	pushl  -0xc(%ebp)
    18ab:	e8 27 28 00 00       	call   40d7 <close>
    18b0:	83 c4 10             	add    $0x10,%esp

  if(link("lf2", "lf2") >= 0){
    18b3:	83 ec 08             	sub    $0x8,%esp
    18b6:	68 cb 4d 00 00       	push   $0x4dcb
    18bb:	68 cb 4d 00 00       	push   $0x4dcb
    18c0:	e8 4a 28 00 00       	call   410f <link>
    18c5:	83 c4 10             	add    $0x10,%esp
    18c8:	85 c0                	test   %eax,%eax
    18ca:	78 17                	js     18e3 <linktest+0x1c1>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    18cc:	83 ec 08             	sub    $0x8,%esp
    18cf:	68 53 4e 00 00       	push   $0x4e53
    18d4:	6a 01                	push   $0x1
    18d6:	e8 68 29 00 00       	call   4243 <printf>
    18db:	83 c4 10             	add    $0x10,%esp
    exit();
    18de:	e8 cc 27 00 00       	call   40af <exit>
  }

  unlink("lf2");
    18e3:	83 ec 0c             	sub    $0xc,%esp
    18e6:	68 cb 4d 00 00       	push   $0x4dcb
    18eb:	e8 0f 28 00 00       	call   40ff <unlink>
    18f0:	83 c4 10             	add    $0x10,%esp
  if(link("lf2", "lf1") >= 0){
    18f3:	83 ec 08             	sub    $0x8,%esp
    18f6:	68 c7 4d 00 00       	push   $0x4dc7
    18fb:	68 cb 4d 00 00       	push   $0x4dcb
    1900:	e8 0a 28 00 00       	call   410f <link>
    1905:	83 c4 10             	add    $0x10,%esp
    1908:	85 c0                	test   %eax,%eax
    190a:	78 17                	js     1923 <linktest+0x201>
    printf(1, "link non-existant succeeded! oops\n");
    190c:	83 ec 08             	sub    $0x8,%esp
    190f:	68 74 4e 00 00       	push   $0x4e74
    1914:	6a 01                	push   $0x1
    1916:	e8 28 29 00 00       	call   4243 <printf>
    191b:	83 c4 10             	add    $0x10,%esp
    exit();
    191e:	e8 8c 27 00 00       	call   40af <exit>
  }

  if(link(".", "lf1") >= 0){
    1923:	83 ec 08             	sub    $0x8,%esp
    1926:	68 c7 4d 00 00       	push   $0x4dc7
    192b:	68 97 4e 00 00       	push   $0x4e97
    1930:	e8 da 27 00 00       	call   410f <link>
    1935:	83 c4 10             	add    $0x10,%esp
    1938:	85 c0                	test   %eax,%eax
    193a:	78 17                	js     1953 <linktest+0x231>
    printf(1, "link . lf1 succeeded! oops\n");
    193c:	83 ec 08             	sub    $0x8,%esp
    193f:	68 99 4e 00 00       	push   $0x4e99
    1944:	6a 01                	push   $0x1
    1946:	e8 f8 28 00 00       	call   4243 <printf>
    194b:	83 c4 10             	add    $0x10,%esp
    exit();
    194e:	e8 5c 27 00 00       	call   40af <exit>
  }

  printf(1, "linktest ok\n");
    1953:	83 ec 08             	sub    $0x8,%esp
    1956:	68 b5 4e 00 00       	push   $0x4eb5
    195b:	6a 01                	push   $0x1
    195d:	e8 e1 28 00 00       	call   4243 <printf>
    1962:	83 c4 10             	add    $0x10,%esp
}
    1965:	90                   	nop
    1966:	c9                   	leave  
    1967:	c3                   	ret    

00001968 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1968:	f3 0f 1e fb          	endbr32 
    196c:	55                   	push   %ebp
    196d:	89 e5                	mov    %esp,%ebp
    196f:	83 ec 58             	sub    $0x58,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1972:	83 ec 08             	sub    $0x8,%esp
    1975:	68 c2 4e 00 00       	push   $0x4ec2
    197a:	6a 01                	push   $0x1
    197c:	e8 c2 28 00 00       	call   4243 <printf>
    1981:	83 c4 10             	add    $0x10,%esp
  file[0] = 'C';
    1984:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1988:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    198c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1993:	e9 fc 00 00 00       	jmp    1a94 <concreate+0x12c>
    file[1] = '0' + i;
    1998:	8b 45 f4             	mov    -0xc(%ebp),%eax
    199b:	83 c0 30             	add    $0x30,%eax
    199e:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    19a1:	83 ec 0c             	sub    $0xc,%esp
    19a4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19a7:	50                   	push   %eax
    19a8:	e8 52 27 00 00       	call   40ff <unlink>
    19ad:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    19b0:	e8 f2 26 00 00       	call   40a7 <fork>
    19b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid && (i % 3) == 1){
    19b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19bc:	74 3b                	je     19f9 <concreate+0x91>
    19be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19c1:	ba 56 55 55 55       	mov    $0x55555556,%edx
    19c6:	89 c8                	mov    %ecx,%eax
    19c8:	f7 ea                	imul   %edx
    19ca:	89 c8                	mov    %ecx,%eax
    19cc:	c1 f8 1f             	sar    $0x1f,%eax
    19cf:	29 c2                	sub    %eax,%edx
    19d1:	89 d0                	mov    %edx,%eax
    19d3:	01 c0                	add    %eax,%eax
    19d5:	01 d0                	add    %edx,%eax
    19d7:	29 c1                	sub    %eax,%ecx
    19d9:	89 ca                	mov    %ecx,%edx
    19db:	83 fa 01             	cmp    $0x1,%edx
    19de:	75 19                	jne    19f9 <concreate+0x91>
      link("C0", file);
    19e0:	83 ec 08             	sub    $0x8,%esp
    19e3:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19e6:	50                   	push   %eax
    19e7:	68 d2 4e 00 00       	push   $0x4ed2
    19ec:	e8 1e 27 00 00       	call   410f <link>
    19f1:	83 c4 10             	add    $0x10,%esp
    19f4:	e9 87 00 00 00       	jmp    1a80 <concreate+0x118>
    } else if(pid == 0 && (i % 5) == 1){
    19f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19fd:	75 3b                	jne    1a3a <concreate+0xd2>
    19ff:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1a02:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1a07:	89 c8                	mov    %ecx,%eax
    1a09:	f7 ea                	imul   %edx
    1a0b:	d1 fa                	sar    %edx
    1a0d:	89 c8                	mov    %ecx,%eax
    1a0f:	c1 f8 1f             	sar    $0x1f,%eax
    1a12:	29 c2                	sub    %eax,%edx
    1a14:	89 d0                	mov    %edx,%eax
    1a16:	c1 e0 02             	shl    $0x2,%eax
    1a19:	01 d0                	add    %edx,%eax
    1a1b:	29 c1                	sub    %eax,%ecx
    1a1d:	89 ca                	mov    %ecx,%edx
    1a1f:	83 fa 01             	cmp    $0x1,%edx
    1a22:	75 16                	jne    1a3a <concreate+0xd2>
      link("C0", file);
    1a24:	83 ec 08             	sub    $0x8,%esp
    1a27:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a2a:	50                   	push   %eax
    1a2b:	68 d2 4e 00 00       	push   $0x4ed2
    1a30:	e8 da 26 00 00       	call   410f <link>
    1a35:	83 c4 10             	add    $0x10,%esp
    1a38:	eb 46                	jmp    1a80 <concreate+0x118>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1a3a:	83 ec 08             	sub    $0x8,%esp
    1a3d:	68 02 02 00 00       	push   $0x202
    1a42:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a45:	50                   	push   %eax
    1a46:	e8 a4 26 00 00       	call   40ef <open>
    1a4b:	83 c4 10             	add    $0x10,%esp
    1a4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(fd < 0){
    1a51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a55:	79 1b                	jns    1a72 <concreate+0x10a>
        printf(1, "concreate create %s failed\n", file);
    1a57:	83 ec 04             	sub    $0x4,%esp
    1a5a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a5d:	50                   	push   %eax
    1a5e:	68 d5 4e 00 00       	push   $0x4ed5
    1a63:	6a 01                	push   $0x1
    1a65:	e8 d9 27 00 00       	call   4243 <printf>
    1a6a:	83 c4 10             	add    $0x10,%esp
        exit();
    1a6d:	e8 3d 26 00 00       	call   40af <exit>
      }
      close(fd);
    1a72:	83 ec 0c             	sub    $0xc,%esp
    1a75:	ff 75 ec             	pushl  -0x14(%ebp)
    1a78:	e8 5a 26 00 00       	call   40d7 <close>
    1a7d:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1a80:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1a84:	75 05                	jne    1a8b <concreate+0x123>
      exit();
    1a86:	e8 24 26 00 00       	call   40af <exit>
    else
      wait();
    1a8b:	e8 27 26 00 00       	call   40b7 <wait>
  for(i = 0; i < 40; i++){
    1a90:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a94:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a98:	0f 8e fa fe ff ff    	jle    1998 <concreate+0x30>
  }

  memset(fa, 0, sizeof(fa));
    1a9e:	83 ec 04             	sub    $0x4,%esp
    1aa1:	6a 28                	push   $0x28
    1aa3:	6a 00                	push   $0x0
    1aa5:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1aa8:	50                   	push   %eax
    1aa9:	e8 4e 24 00 00       	call   3efc <memset>
    1aae:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1ab1:	83 ec 08             	sub    $0x8,%esp
    1ab4:	6a 00                	push   $0x0
    1ab6:	68 97 4e 00 00       	push   $0x4e97
    1abb:	e8 2f 26 00 00       	call   40ef <open>
    1ac0:	83 c4 10             	add    $0x10,%esp
    1ac3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  n = 0;
    1ac6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1acd:	e9 93 00 00 00       	jmp    1b65 <concreate+0x1fd>
    if(de.inum == 0)
    1ad2:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1ad6:	66 85 c0             	test   %ax,%ax
    1ad9:	75 05                	jne    1ae0 <concreate+0x178>
      continue;
    1adb:	e9 85 00 00 00       	jmp    1b65 <concreate+0x1fd>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1ae0:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1ae4:	3c 43                	cmp    $0x43,%al
    1ae6:	75 7d                	jne    1b65 <concreate+0x1fd>
    1ae8:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1aec:	84 c0                	test   %al,%al
    1aee:	75 75                	jne    1b65 <concreate+0x1fd>
      i = de.name[1] - '0';
    1af0:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1af4:	0f be c0             	movsbl %al,%eax
    1af7:	83 e8 30             	sub    $0x30,%eax
    1afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b01:	78 08                	js     1b0b <concreate+0x1a3>
    1b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b06:	83 f8 27             	cmp    $0x27,%eax
    1b09:	76 1e                	jbe    1b29 <concreate+0x1c1>
        printf(1, "concreate weird file %s\n", de.name);
    1b0b:	83 ec 04             	sub    $0x4,%esp
    1b0e:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b11:	83 c0 02             	add    $0x2,%eax
    1b14:	50                   	push   %eax
    1b15:	68 f1 4e 00 00       	push   $0x4ef1
    1b1a:	6a 01                	push   $0x1
    1b1c:	e8 22 27 00 00       	call   4243 <printf>
    1b21:	83 c4 10             	add    $0x10,%esp
        exit();
    1b24:	e8 86 25 00 00       	call   40af <exit>
      }
      if(fa[i]){
    1b29:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b2f:	01 d0                	add    %edx,%eax
    1b31:	0f b6 00             	movzbl (%eax),%eax
    1b34:	84 c0                	test   %al,%al
    1b36:	74 1e                	je     1b56 <concreate+0x1ee>
        printf(1, "concreate duplicate file %s\n", de.name);
    1b38:	83 ec 04             	sub    $0x4,%esp
    1b3b:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b3e:	83 c0 02             	add    $0x2,%eax
    1b41:	50                   	push   %eax
    1b42:	68 0a 4f 00 00       	push   $0x4f0a
    1b47:	6a 01                	push   $0x1
    1b49:	e8 f5 26 00 00       	call   4243 <printf>
    1b4e:	83 c4 10             	add    $0x10,%esp
        exit();
    1b51:	e8 59 25 00 00       	call   40af <exit>
      }
      fa[i] = 1;
    1b56:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b5c:	01 d0                	add    %edx,%eax
    1b5e:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b61:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1b65:	83 ec 04             	sub    $0x4,%esp
    1b68:	6a 10                	push   $0x10
    1b6a:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b6d:	50                   	push   %eax
    1b6e:	ff 75 ec             	pushl  -0x14(%ebp)
    1b71:	e8 51 25 00 00       	call   40c7 <read>
    1b76:	83 c4 10             	add    $0x10,%esp
    1b79:	85 c0                	test   %eax,%eax
    1b7b:	0f 8f 51 ff ff ff    	jg     1ad2 <concreate+0x16a>
    }
  }
  close(fd);
    1b81:	83 ec 0c             	sub    $0xc,%esp
    1b84:	ff 75 ec             	pushl  -0x14(%ebp)
    1b87:	e8 4b 25 00 00       	call   40d7 <close>
    1b8c:	83 c4 10             	add    $0x10,%esp

  if(n != 40){
    1b8f:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b93:	74 17                	je     1bac <concreate+0x244>
    printf(1, "concreate not enough files in directory listing\n");
    1b95:	83 ec 08             	sub    $0x8,%esp
    1b98:	68 28 4f 00 00       	push   $0x4f28
    1b9d:	6a 01                	push   $0x1
    1b9f:	e8 9f 26 00 00       	call   4243 <printf>
    1ba4:	83 c4 10             	add    $0x10,%esp
    exit();
    1ba7:	e8 03 25 00 00       	call   40af <exit>
  }

  for(i = 0; i < 40; i++){
    1bac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1bb3:	e9 45 01 00 00       	jmp    1cfd <concreate+0x395>
    file[1] = '0' + i;
    1bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bbb:	83 c0 30             	add    $0x30,%eax
    1bbe:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1bc1:	e8 e1 24 00 00       	call   40a7 <fork>
    1bc6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    1bc9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1bcd:	79 17                	jns    1be6 <concreate+0x27e>
      printf(1, "fork failed\n");
    1bcf:	83 ec 08             	sub    $0x8,%esp
    1bd2:	68 ad 46 00 00       	push   $0x46ad
    1bd7:	6a 01                	push   $0x1
    1bd9:	e8 65 26 00 00       	call   4243 <printf>
    1bde:	83 c4 10             	add    $0x10,%esp
      exit();
    1be1:	e8 c9 24 00 00       	call   40af <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1be6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1be9:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bee:	89 c8                	mov    %ecx,%eax
    1bf0:	f7 ea                	imul   %edx
    1bf2:	89 c8                	mov    %ecx,%eax
    1bf4:	c1 f8 1f             	sar    $0x1f,%eax
    1bf7:	29 c2                	sub    %eax,%edx
    1bf9:	89 d0                	mov    %edx,%eax
    1bfb:	89 c2                	mov    %eax,%edx
    1bfd:	01 d2                	add    %edx,%edx
    1bff:	01 c2                	add    %eax,%edx
    1c01:	89 c8                	mov    %ecx,%eax
    1c03:	29 d0                	sub    %edx,%eax
    1c05:	85 c0                	test   %eax,%eax
    1c07:	75 06                	jne    1c0f <concreate+0x2a7>
    1c09:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1c0d:	74 28                	je     1c37 <concreate+0x2cf>
       ((i % 3) == 1 && pid != 0)){
    1c0f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1c12:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1c17:	89 c8                	mov    %ecx,%eax
    1c19:	f7 ea                	imul   %edx
    1c1b:	89 c8                	mov    %ecx,%eax
    1c1d:	c1 f8 1f             	sar    $0x1f,%eax
    1c20:	29 c2                	sub    %eax,%edx
    1c22:	89 d0                	mov    %edx,%eax
    1c24:	01 c0                	add    %eax,%eax
    1c26:	01 d0                	add    %edx,%eax
    1c28:	29 c1                	sub    %eax,%ecx
    1c2a:	89 ca                	mov    %ecx,%edx
    if(((i % 3) == 0 && pid == 0) ||
    1c2c:	83 fa 01             	cmp    $0x1,%edx
    1c2f:	75 7c                	jne    1cad <concreate+0x345>
       ((i % 3) == 1 && pid != 0)){
    1c31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1c35:	74 76                	je     1cad <concreate+0x345>
      close(open(file, 0));
    1c37:	83 ec 08             	sub    $0x8,%esp
    1c3a:	6a 00                	push   $0x0
    1c3c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c3f:	50                   	push   %eax
    1c40:	e8 aa 24 00 00       	call   40ef <open>
    1c45:	83 c4 10             	add    $0x10,%esp
    1c48:	83 ec 0c             	sub    $0xc,%esp
    1c4b:	50                   	push   %eax
    1c4c:	e8 86 24 00 00       	call   40d7 <close>
    1c51:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c54:	83 ec 08             	sub    $0x8,%esp
    1c57:	6a 00                	push   $0x0
    1c59:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c5c:	50                   	push   %eax
    1c5d:	e8 8d 24 00 00       	call   40ef <open>
    1c62:	83 c4 10             	add    $0x10,%esp
    1c65:	83 ec 0c             	sub    $0xc,%esp
    1c68:	50                   	push   %eax
    1c69:	e8 69 24 00 00       	call   40d7 <close>
    1c6e:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c71:	83 ec 08             	sub    $0x8,%esp
    1c74:	6a 00                	push   $0x0
    1c76:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c79:	50                   	push   %eax
    1c7a:	e8 70 24 00 00       	call   40ef <open>
    1c7f:	83 c4 10             	add    $0x10,%esp
    1c82:	83 ec 0c             	sub    $0xc,%esp
    1c85:	50                   	push   %eax
    1c86:	e8 4c 24 00 00       	call   40d7 <close>
    1c8b:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c8e:	83 ec 08             	sub    $0x8,%esp
    1c91:	6a 00                	push   $0x0
    1c93:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c96:	50                   	push   %eax
    1c97:	e8 53 24 00 00       	call   40ef <open>
    1c9c:	83 c4 10             	add    $0x10,%esp
    1c9f:	83 ec 0c             	sub    $0xc,%esp
    1ca2:	50                   	push   %eax
    1ca3:	e8 2f 24 00 00       	call   40d7 <close>
    1ca8:	83 c4 10             	add    $0x10,%esp
    1cab:	eb 3c                	jmp    1ce9 <concreate+0x381>
    } else {
      unlink(file);
    1cad:	83 ec 0c             	sub    $0xc,%esp
    1cb0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cb3:	50                   	push   %eax
    1cb4:	e8 46 24 00 00       	call   40ff <unlink>
    1cb9:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1cbc:	83 ec 0c             	sub    $0xc,%esp
    1cbf:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cc2:	50                   	push   %eax
    1cc3:	e8 37 24 00 00       	call   40ff <unlink>
    1cc8:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1ccb:	83 ec 0c             	sub    $0xc,%esp
    1cce:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cd1:	50                   	push   %eax
    1cd2:	e8 28 24 00 00       	call   40ff <unlink>
    1cd7:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1cda:	83 ec 0c             	sub    $0xc,%esp
    1cdd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1ce0:	50                   	push   %eax
    1ce1:	e8 19 24 00 00       	call   40ff <unlink>
    1ce6:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1ce9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1ced:	75 05                	jne    1cf4 <concreate+0x38c>
      exit();
    1cef:	e8 bb 23 00 00       	call   40af <exit>
    else
      wait();
    1cf4:	e8 be 23 00 00       	call   40b7 <wait>
  for(i = 0; i < 40; i++){
    1cf9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cfd:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1d01:	0f 8e b1 fe ff ff    	jle    1bb8 <concreate+0x250>
  }

  printf(1, "concreate ok\n");
    1d07:	83 ec 08             	sub    $0x8,%esp
    1d0a:	68 59 4f 00 00       	push   $0x4f59
    1d0f:	6a 01                	push   $0x1
    1d11:	e8 2d 25 00 00       	call   4243 <printf>
    1d16:	83 c4 10             	add    $0x10,%esp
}
    1d19:	90                   	nop
    1d1a:	c9                   	leave  
    1d1b:	c3                   	ret    

00001d1c <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1d1c:	f3 0f 1e fb          	endbr32 
    1d20:	55                   	push   %ebp
    1d21:	89 e5                	mov    %esp,%ebp
    1d23:	83 ec 18             	sub    $0x18,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1d26:	83 ec 08             	sub    $0x8,%esp
    1d29:	68 67 4f 00 00       	push   $0x4f67
    1d2e:	6a 01                	push   $0x1
    1d30:	e8 0e 25 00 00       	call   4243 <printf>
    1d35:	83 c4 10             	add    $0x10,%esp

  unlink("x");
    1d38:	83 ec 0c             	sub    $0xc,%esp
    1d3b:	68 e3 4a 00 00       	push   $0x4ae3
    1d40:	e8 ba 23 00 00       	call   40ff <unlink>
    1d45:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1d48:	e8 5a 23 00 00       	call   40a7 <fork>
    1d4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1d50:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d54:	79 17                	jns    1d6d <linkunlink+0x51>
    printf(1, "fork failed\n");
    1d56:	83 ec 08             	sub    $0x8,%esp
    1d59:	68 ad 46 00 00       	push   $0x46ad
    1d5e:	6a 01                	push   $0x1
    1d60:	e8 de 24 00 00       	call   4243 <printf>
    1d65:	83 c4 10             	add    $0x10,%esp
    exit();
    1d68:	e8 42 23 00 00       	call   40af <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d71:	74 07                	je     1d7a <linkunlink+0x5e>
    1d73:	b8 01 00 00 00       	mov    $0x1,%eax
    1d78:	eb 05                	jmp    1d7f <linkunlink+0x63>
    1d7a:	b8 61 00 00 00       	mov    $0x61,%eax
    1d7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d89:	e9 9a 00 00 00       	jmp    1e28 <linkunlink+0x10c>
    x = x * 1103515245 + 12345;
    1d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d91:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d97:	05 39 30 00 00       	add    $0x3039,%eax
    1d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d9f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1da2:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1da7:	89 c8                	mov    %ecx,%eax
    1da9:	f7 e2                	mul    %edx
    1dab:	89 d0                	mov    %edx,%eax
    1dad:	d1 e8                	shr    %eax
    1daf:	89 c2                	mov    %eax,%edx
    1db1:	01 d2                	add    %edx,%edx
    1db3:	01 c2                	add    %eax,%edx
    1db5:	89 c8                	mov    %ecx,%eax
    1db7:	29 d0                	sub    %edx,%eax
    1db9:	85 c0                	test   %eax,%eax
    1dbb:	75 23                	jne    1de0 <linkunlink+0xc4>
      close(open("x", O_RDWR | O_CREATE));
    1dbd:	83 ec 08             	sub    $0x8,%esp
    1dc0:	68 02 02 00 00       	push   $0x202
    1dc5:	68 e3 4a 00 00       	push   $0x4ae3
    1dca:	e8 20 23 00 00       	call   40ef <open>
    1dcf:	83 c4 10             	add    $0x10,%esp
    1dd2:	83 ec 0c             	sub    $0xc,%esp
    1dd5:	50                   	push   %eax
    1dd6:	e8 fc 22 00 00       	call   40d7 <close>
    1ddb:	83 c4 10             	add    $0x10,%esp
    1dde:	eb 44                	jmp    1e24 <linkunlink+0x108>
    } else if((x % 3) == 1){
    1de0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1de3:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1de8:	89 c8                	mov    %ecx,%eax
    1dea:	f7 e2                	mul    %edx
    1dec:	d1 ea                	shr    %edx
    1dee:	89 d0                	mov    %edx,%eax
    1df0:	01 c0                	add    %eax,%eax
    1df2:	01 d0                	add    %edx,%eax
    1df4:	29 c1                	sub    %eax,%ecx
    1df6:	89 ca                	mov    %ecx,%edx
    1df8:	83 fa 01             	cmp    $0x1,%edx
    1dfb:	75 17                	jne    1e14 <linkunlink+0xf8>
      link("cat", "x");
    1dfd:	83 ec 08             	sub    $0x8,%esp
    1e00:	68 e3 4a 00 00       	push   $0x4ae3
    1e05:	68 78 4f 00 00       	push   $0x4f78
    1e0a:	e8 00 23 00 00       	call   410f <link>
    1e0f:	83 c4 10             	add    $0x10,%esp
    1e12:	eb 10                	jmp    1e24 <linkunlink+0x108>
    } else {
      unlink("x");
    1e14:	83 ec 0c             	sub    $0xc,%esp
    1e17:	68 e3 4a 00 00       	push   $0x4ae3
    1e1c:	e8 de 22 00 00       	call   40ff <unlink>
    1e21:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1e24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1e28:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1e2c:	0f 8e 5c ff ff ff    	jle    1d8e <linkunlink+0x72>
    }
  }

  if(pid)
    1e32:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1e36:	74 07                	je     1e3f <linkunlink+0x123>
    wait();
    1e38:	e8 7a 22 00 00       	call   40b7 <wait>
    1e3d:	eb 05                	jmp    1e44 <linkunlink+0x128>
  else
    exit();
    1e3f:	e8 6b 22 00 00       	call   40af <exit>

  printf(1, "linkunlink ok\n");
    1e44:	83 ec 08             	sub    $0x8,%esp
    1e47:	68 7c 4f 00 00       	push   $0x4f7c
    1e4c:	6a 01                	push   $0x1
    1e4e:	e8 f0 23 00 00       	call   4243 <printf>
    1e53:	83 c4 10             	add    $0x10,%esp
}
    1e56:	90                   	nop
    1e57:	c9                   	leave  
    1e58:	c3                   	ret    

00001e59 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1e59:	f3 0f 1e fb          	endbr32 
    1e5d:	55                   	push   %ebp
    1e5e:	89 e5                	mov    %esp,%ebp
    1e60:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1e63:	83 ec 08             	sub    $0x8,%esp
    1e66:	68 8b 4f 00 00       	push   $0x4f8b
    1e6b:	6a 01                	push   $0x1
    1e6d:	e8 d1 23 00 00       	call   4243 <printf>
    1e72:	83 c4 10             	add    $0x10,%esp
  unlink("bd");
    1e75:	83 ec 0c             	sub    $0xc,%esp
    1e78:	68 98 4f 00 00       	push   $0x4f98
    1e7d:	e8 7d 22 00 00       	call   40ff <unlink>
    1e82:	83 c4 10             	add    $0x10,%esp

  fd = open("bd", O_CREATE);
    1e85:	83 ec 08             	sub    $0x8,%esp
    1e88:	68 00 02 00 00       	push   $0x200
    1e8d:	68 98 4f 00 00       	push   $0x4f98
    1e92:	e8 58 22 00 00       	call   40ef <open>
    1e97:	83 c4 10             	add    $0x10,%esp
    1e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1ea1:	79 17                	jns    1eba <bigdir+0x61>
    printf(1, "bigdir create failed\n");
    1ea3:	83 ec 08             	sub    $0x8,%esp
    1ea6:	68 9b 4f 00 00       	push   $0x4f9b
    1eab:	6a 01                	push   $0x1
    1ead:	e8 91 23 00 00       	call   4243 <printf>
    1eb2:	83 c4 10             	add    $0x10,%esp
    exit();
    1eb5:	e8 f5 21 00 00       	call   40af <exit>
  }
  close(fd);
    1eba:	83 ec 0c             	sub    $0xc,%esp
    1ebd:	ff 75 f0             	pushl  -0x10(%ebp)
    1ec0:	e8 12 22 00 00       	call   40d7 <close>
    1ec5:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1ec8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1ecf:	eb 63                	jmp    1f34 <bigdir+0xdb>
    name[0] = 'x';
    1ed1:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ed8:	8d 50 3f             	lea    0x3f(%eax),%edx
    1edb:	85 c0                	test   %eax,%eax
    1edd:	0f 48 c2             	cmovs  %edx,%eax
    1ee0:	c1 f8 06             	sar    $0x6,%eax
    1ee3:	83 c0 30             	add    $0x30,%eax
    1ee6:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1eec:	99                   	cltd   
    1eed:	c1 ea 1a             	shr    $0x1a,%edx
    1ef0:	01 d0                	add    %edx,%eax
    1ef2:	83 e0 3f             	and    $0x3f,%eax
    1ef5:	29 d0                	sub    %edx,%eax
    1ef7:	83 c0 30             	add    $0x30,%eax
    1efa:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1efd:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1f01:	83 ec 08             	sub    $0x8,%esp
    1f04:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f07:	50                   	push   %eax
    1f08:	68 98 4f 00 00       	push   $0x4f98
    1f0d:	e8 fd 21 00 00       	call   410f <link>
    1f12:	83 c4 10             	add    $0x10,%esp
    1f15:	85 c0                	test   %eax,%eax
    1f17:	74 17                	je     1f30 <bigdir+0xd7>
      printf(1, "bigdir link failed\n");
    1f19:	83 ec 08             	sub    $0x8,%esp
    1f1c:	68 b1 4f 00 00       	push   $0x4fb1
    1f21:	6a 01                	push   $0x1
    1f23:	e8 1b 23 00 00       	call   4243 <printf>
    1f28:	83 c4 10             	add    $0x10,%esp
      exit();
    1f2b:	e8 7f 21 00 00       	call   40af <exit>
  for(i = 0; i < 500; i++){
    1f30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f34:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f3b:	7e 94                	jle    1ed1 <bigdir+0x78>
    }
  }

  unlink("bd");
    1f3d:	83 ec 0c             	sub    $0xc,%esp
    1f40:	68 98 4f 00 00       	push   $0x4f98
    1f45:	e8 b5 21 00 00       	call   40ff <unlink>
    1f4a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1f4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1f54:	eb 5e                	jmp    1fb4 <bigdir+0x15b>
    name[0] = 'x';
    1f56:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f5d:	8d 50 3f             	lea    0x3f(%eax),%edx
    1f60:	85 c0                	test   %eax,%eax
    1f62:	0f 48 c2             	cmovs  %edx,%eax
    1f65:	c1 f8 06             	sar    $0x6,%eax
    1f68:	83 c0 30             	add    $0x30,%eax
    1f6b:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f71:	99                   	cltd   
    1f72:	c1 ea 1a             	shr    $0x1a,%edx
    1f75:	01 d0                	add    %edx,%eax
    1f77:	83 e0 3f             	and    $0x3f,%eax
    1f7a:	29 d0                	sub    %edx,%eax
    1f7c:	83 c0 30             	add    $0x30,%eax
    1f7f:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f82:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f86:	83 ec 0c             	sub    $0xc,%esp
    1f89:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f8c:	50                   	push   %eax
    1f8d:	e8 6d 21 00 00       	call   40ff <unlink>
    1f92:	83 c4 10             	add    $0x10,%esp
    1f95:	85 c0                	test   %eax,%eax
    1f97:	74 17                	je     1fb0 <bigdir+0x157>
      printf(1, "bigdir unlink failed");
    1f99:	83 ec 08             	sub    $0x8,%esp
    1f9c:	68 c5 4f 00 00       	push   $0x4fc5
    1fa1:	6a 01                	push   $0x1
    1fa3:	e8 9b 22 00 00       	call   4243 <printf>
    1fa8:	83 c4 10             	add    $0x10,%esp
      exit();
    1fab:	e8 ff 20 00 00       	call   40af <exit>
  for(i = 0; i < 500; i++){
    1fb0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1fb4:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1fbb:	7e 99                	jle    1f56 <bigdir+0xfd>
    }
  }

  printf(1, "bigdir ok\n");
    1fbd:	83 ec 08             	sub    $0x8,%esp
    1fc0:	68 da 4f 00 00       	push   $0x4fda
    1fc5:	6a 01                	push   $0x1
    1fc7:	e8 77 22 00 00       	call   4243 <printf>
    1fcc:	83 c4 10             	add    $0x10,%esp
}
    1fcf:	90                   	nop
    1fd0:	c9                   	leave  
    1fd1:	c3                   	ret    

00001fd2 <subdir>:

void
subdir(void)
{
    1fd2:	f3 0f 1e fb          	endbr32 
    1fd6:	55                   	push   %ebp
    1fd7:	89 e5                	mov    %esp,%ebp
    1fd9:	83 ec 18             	sub    $0x18,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1fdc:	83 ec 08             	sub    $0x8,%esp
    1fdf:	68 e5 4f 00 00       	push   $0x4fe5
    1fe4:	6a 01                	push   $0x1
    1fe6:	e8 58 22 00 00       	call   4243 <printf>
    1feb:	83 c4 10             	add    $0x10,%esp

  unlink("ff");
    1fee:	83 ec 0c             	sub    $0xc,%esp
    1ff1:	68 f2 4f 00 00       	push   $0x4ff2
    1ff6:	e8 04 21 00 00       	call   40ff <unlink>
    1ffb:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dd") != 0){
    1ffe:	83 ec 0c             	sub    $0xc,%esp
    2001:	68 f5 4f 00 00       	push   $0x4ff5
    2006:	e8 0c 21 00 00       	call   4117 <mkdir>
    200b:	83 c4 10             	add    $0x10,%esp
    200e:	85 c0                	test   %eax,%eax
    2010:	74 17                	je     2029 <subdir+0x57>
    printf(1, "subdir mkdir dd failed\n");
    2012:	83 ec 08             	sub    $0x8,%esp
    2015:	68 f8 4f 00 00       	push   $0x4ff8
    201a:	6a 01                	push   $0x1
    201c:	e8 22 22 00 00       	call   4243 <printf>
    2021:	83 c4 10             	add    $0x10,%esp
    exit();
    2024:	e8 86 20 00 00       	call   40af <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    2029:	83 ec 08             	sub    $0x8,%esp
    202c:	68 02 02 00 00       	push   $0x202
    2031:	68 10 50 00 00       	push   $0x5010
    2036:	e8 b4 20 00 00       	call   40ef <open>
    203b:	83 c4 10             	add    $0x10,%esp
    203e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2041:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2045:	79 17                	jns    205e <subdir+0x8c>
    printf(1, "create dd/ff failed\n");
    2047:	83 ec 08             	sub    $0x8,%esp
    204a:	68 16 50 00 00       	push   $0x5016
    204f:	6a 01                	push   $0x1
    2051:	e8 ed 21 00 00       	call   4243 <printf>
    2056:	83 c4 10             	add    $0x10,%esp
    exit();
    2059:	e8 51 20 00 00       	call   40af <exit>
  }
  write(fd, "ff", 2);
    205e:	83 ec 04             	sub    $0x4,%esp
    2061:	6a 02                	push   $0x2
    2063:	68 f2 4f 00 00       	push   $0x4ff2
    2068:	ff 75 f4             	pushl  -0xc(%ebp)
    206b:	e8 5f 20 00 00       	call   40cf <write>
    2070:	83 c4 10             	add    $0x10,%esp
  close(fd);
    2073:	83 ec 0c             	sub    $0xc,%esp
    2076:	ff 75 f4             	pushl  -0xc(%ebp)
    2079:	e8 59 20 00 00       	call   40d7 <close>
    207e:	83 c4 10             	add    $0x10,%esp

  if(unlink("dd") >= 0){
    2081:	83 ec 0c             	sub    $0xc,%esp
    2084:	68 f5 4f 00 00       	push   $0x4ff5
    2089:	e8 71 20 00 00       	call   40ff <unlink>
    208e:	83 c4 10             	add    $0x10,%esp
    2091:	85 c0                	test   %eax,%eax
    2093:	78 17                	js     20ac <subdir+0xda>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2095:	83 ec 08             	sub    $0x8,%esp
    2098:	68 2c 50 00 00       	push   $0x502c
    209d:	6a 01                	push   $0x1
    209f:	e8 9f 21 00 00       	call   4243 <printf>
    20a4:	83 c4 10             	add    $0x10,%esp
    exit();
    20a7:	e8 03 20 00 00       	call   40af <exit>
  }

  if(mkdir("/dd/dd") != 0){
    20ac:	83 ec 0c             	sub    $0xc,%esp
    20af:	68 52 50 00 00       	push   $0x5052
    20b4:	e8 5e 20 00 00       	call   4117 <mkdir>
    20b9:	83 c4 10             	add    $0x10,%esp
    20bc:	85 c0                	test   %eax,%eax
    20be:	74 17                	je     20d7 <subdir+0x105>
    printf(1, "subdir mkdir dd/dd failed\n");
    20c0:	83 ec 08             	sub    $0x8,%esp
    20c3:	68 59 50 00 00       	push   $0x5059
    20c8:	6a 01                	push   $0x1
    20ca:	e8 74 21 00 00       	call   4243 <printf>
    20cf:	83 c4 10             	add    $0x10,%esp
    exit();
    20d2:	e8 d8 1f 00 00       	call   40af <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    20d7:	83 ec 08             	sub    $0x8,%esp
    20da:	68 02 02 00 00       	push   $0x202
    20df:	68 74 50 00 00       	push   $0x5074
    20e4:	e8 06 20 00 00       	call   40ef <open>
    20e9:	83 c4 10             	add    $0x10,%esp
    20ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20f3:	79 17                	jns    210c <subdir+0x13a>
    printf(1, "create dd/dd/ff failed\n");
    20f5:	83 ec 08             	sub    $0x8,%esp
    20f8:	68 7d 50 00 00       	push   $0x507d
    20fd:	6a 01                	push   $0x1
    20ff:	e8 3f 21 00 00       	call   4243 <printf>
    2104:	83 c4 10             	add    $0x10,%esp
    exit();
    2107:	e8 a3 1f 00 00       	call   40af <exit>
  }
  write(fd, "FF", 2);
    210c:	83 ec 04             	sub    $0x4,%esp
    210f:	6a 02                	push   $0x2
    2111:	68 95 50 00 00       	push   $0x5095
    2116:	ff 75 f4             	pushl  -0xc(%ebp)
    2119:	e8 b1 1f 00 00       	call   40cf <write>
    211e:	83 c4 10             	add    $0x10,%esp
  close(fd);
    2121:	83 ec 0c             	sub    $0xc,%esp
    2124:	ff 75 f4             	pushl  -0xc(%ebp)
    2127:	e8 ab 1f 00 00       	call   40d7 <close>
    212c:	83 c4 10             	add    $0x10,%esp

  fd = open("dd/dd/../ff", 0);
    212f:	83 ec 08             	sub    $0x8,%esp
    2132:	6a 00                	push   $0x0
    2134:	68 98 50 00 00       	push   $0x5098
    2139:	e8 b1 1f 00 00       	call   40ef <open>
    213e:	83 c4 10             	add    $0x10,%esp
    2141:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2148:	79 17                	jns    2161 <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    214a:	83 ec 08             	sub    $0x8,%esp
    214d:	68 a4 50 00 00       	push   $0x50a4
    2152:	6a 01                	push   $0x1
    2154:	e8 ea 20 00 00       	call   4243 <printf>
    2159:	83 c4 10             	add    $0x10,%esp
    exit();
    215c:	e8 4e 1f 00 00       	call   40af <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    2161:	83 ec 04             	sub    $0x4,%esp
    2164:	68 00 20 00 00       	push   $0x2000
    2169:	68 40 8d 00 00       	push   $0x8d40
    216e:	ff 75 f4             	pushl  -0xc(%ebp)
    2171:	e8 51 1f 00 00       	call   40c7 <read>
    2176:	83 c4 10             	add    $0x10,%esp
    2179:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    217c:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2180:	75 0b                	jne    218d <subdir+0x1bb>
    2182:	0f b6 05 40 8d 00 00 	movzbl 0x8d40,%eax
    2189:	3c 66                	cmp    $0x66,%al
    218b:	74 17                	je     21a4 <subdir+0x1d2>
    printf(1, "dd/dd/../ff wrong content\n");
    218d:	83 ec 08             	sub    $0x8,%esp
    2190:	68 bd 50 00 00       	push   $0x50bd
    2195:	6a 01                	push   $0x1
    2197:	e8 a7 20 00 00       	call   4243 <printf>
    219c:	83 c4 10             	add    $0x10,%esp
    exit();
    219f:	e8 0b 1f 00 00       	call   40af <exit>
  }
  close(fd);
    21a4:	83 ec 0c             	sub    $0xc,%esp
    21a7:	ff 75 f4             	pushl  -0xc(%ebp)
    21aa:	e8 28 1f 00 00       	call   40d7 <close>
    21af:	83 c4 10             	add    $0x10,%esp

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    21b2:	83 ec 08             	sub    $0x8,%esp
    21b5:	68 d8 50 00 00       	push   $0x50d8
    21ba:	68 74 50 00 00       	push   $0x5074
    21bf:	e8 4b 1f 00 00       	call   410f <link>
    21c4:	83 c4 10             	add    $0x10,%esp
    21c7:	85 c0                	test   %eax,%eax
    21c9:	74 17                	je     21e2 <subdir+0x210>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    21cb:	83 ec 08             	sub    $0x8,%esp
    21ce:	68 e4 50 00 00       	push   $0x50e4
    21d3:	6a 01                	push   $0x1
    21d5:	e8 69 20 00 00       	call   4243 <printf>
    21da:	83 c4 10             	add    $0x10,%esp
    exit();
    21dd:	e8 cd 1e 00 00       	call   40af <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    21e2:	83 ec 0c             	sub    $0xc,%esp
    21e5:	68 74 50 00 00       	push   $0x5074
    21ea:	e8 10 1f 00 00       	call   40ff <unlink>
    21ef:	83 c4 10             	add    $0x10,%esp
    21f2:	85 c0                	test   %eax,%eax
    21f4:	74 17                	je     220d <subdir+0x23b>
    printf(1, "unlink dd/dd/ff failed\n");
    21f6:	83 ec 08             	sub    $0x8,%esp
    21f9:	68 05 51 00 00       	push   $0x5105
    21fe:	6a 01                	push   $0x1
    2200:	e8 3e 20 00 00       	call   4243 <printf>
    2205:	83 c4 10             	add    $0x10,%esp
    exit();
    2208:	e8 a2 1e 00 00       	call   40af <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    220d:	83 ec 08             	sub    $0x8,%esp
    2210:	6a 00                	push   $0x0
    2212:	68 74 50 00 00       	push   $0x5074
    2217:	e8 d3 1e 00 00       	call   40ef <open>
    221c:	83 c4 10             	add    $0x10,%esp
    221f:	85 c0                	test   %eax,%eax
    2221:	78 17                	js     223a <subdir+0x268>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2223:	83 ec 08             	sub    $0x8,%esp
    2226:	68 20 51 00 00       	push   $0x5120
    222b:	6a 01                	push   $0x1
    222d:	e8 11 20 00 00       	call   4243 <printf>
    2232:	83 c4 10             	add    $0x10,%esp
    exit();
    2235:	e8 75 1e 00 00       	call   40af <exit>
  }

  if(chdir("dd") != 0){
    223a:	83 ec 0c             	sub    $0xc,%esp
    223d:	68 f5 4f 00 00       	push   $0x4ff5
    2242:	e8 d8 1e 00 00       	call   411f <chdir>
    2247:	83 c4 10             	add    $0x10,%esp
    224a:	85 c0                	test   %eax,%eax
    224c:	74 17                	je     2265 <subdir+0x293>
    printf(1, "chdir dd failed\n");
    224e:	83 ec 08             	sub    $0x8,%esp
    2251:	68 44 51 00 00       	push   $0x5144
    2256:	6a 01                	push   $0x1
    2258:	e8 e6 1f 00 00       	call   4243 <printf>
    225d:	83 c4 10             	add    $0x10,%esp
    exit();
    2260:	e8 4a 1e 00 00       	call   40af <exit>
  }
  if(chdir("dd/../../dd") != 0){
    2265:	83 ec 0c             	sub    $0xc,%esp
    2268:	68 55 51 00 00       	push   $0x5155
    226d:	e8 ad 1e 00 00       	call   411f <chdir>
    2272:	83 c4 10             	add    $0x10,%esp
    2275:	85 c0                	test   %eax,%eax
    2277:	74 17                	je     2290 <subdir+0x2be>
    printf(1, "chdir dd/../../dd failed\n");
    2279:	83 ec 08             	sub    $0x8,%esp
    227c:	68 61 51 00 00       	push   $0x5161
    2281:	6a 01                	push   $0x1
    2283:	e8 bb 1f 00 00       	call   4243 <printf>
    2288:	83 c4 10             	add    $0x10,%esp
    exit();
    228b:	e8 1f 1e 00 00       	call   40af <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2290:	83 ec 0c             	sub    $0xc,%esp
    2293:	68 7b 51 00 00       	push   $0x517b
    2298:	e8 82 1e 00 00       	call   411f <chdir>
    229d:	83 c4 10             	add    $0x10,%esp
    22a0:	85 c0                	test   %eax,%eax
    22a2:	74 17                	je     22bb <subdir+0x2e9>
    printf(1, "chdir dd/../../dd failed\n");
    22a4:	83 ec 08             	sub    $0x8,%esp
    22a7:	68 61 51 00 00       	push   $0x5161
    22ac:	6a 01                	push   $0x1
    22ae:	e8 90 1f 00 00       	call   4243 <printf>
    22b3:	83 c4 10             	add    $0x10,%esp
    exit();
    22b6:	e8 f4 1d 00 00       	call   40af <exit>
  }
  if(chdir("./..") != 0){
    22bb:	83 ec 0c             	sub    $0xc,%esp
    22be:	68 8a 51 00 00       	push   $0x518a
    22c3:	e8 57 1e 00 00       	call   411f <chdir>
    22c8:	83 c4 10             	add    $0x10,%esp
    22cb:	85 c0                	test   %eax,%eax
    22cd:	74 17                	je     22e6 <subdir+0x314>
    printf(1, "chdir ./.. failed\n");
    22cf:	83 ec 08             	sub    $0x8,%esp
    22d2:	68 8f 51 00 00       	push   $0x518f
    22d7:	6a 01                	push   $0x1
    22d9:	e8 65 1f 00 00       	call   4243 <printf>
    22de:	83 c4 10             	add    $0x10,%esp
    exit();
    22e1:	e8 c9 1d 00 00       	call   40af <exit>
  }

  fd = open("dd/dd/ffff", 0);
    22e6:	83 ec 08             	sub    $0x8,%esp
    22e9:	6a 00                	push   $0x0
    22eb:	68 d8 50 00 00       	push   $0x50d8
    22f0:	e8 fa 1d 00 00       	call   40ef <open>
    22f5:	83 c4 10             	add    $0x10,%esp
    22f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    22fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    22ff:	79 17                	jns    2318 <subdir+0x346>
    printf(1, "open dd/dd/ffff failed\n");
    2301:	83 ec 08             	sub    $0x8,%esp
    2304:	68 a2 51 00 00       	push   $0x51a2
    2309:	6a 01                	push   $0x1
    230b:	e8 33 1f 00 00       	call   4243 <printf>
    2310:	83 c4 10             	add    $0x10,%esp
    exit();
    2313:	e8 97 1d 00 00       	call   40af <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    2318:	83 ec 04             	sub    $0x4,%esp
    231b:	68 00 20 00 00       	push   $0x2000
    2320:	68 40 8d 00 00       	push   $0x8d40
    2325:	ff 75 f4             	pushl  -0xc(%ebp)
    2328:	e8 9a 1d 00 00       	call   40c7 <read>
    232d:	83 c4 10             	add    $0x10,%esp
    2330:	83 f8 02             	cmp    $0x2,%eax
    2333:	74 17                	je     234c <subdir+0x37a>
    printf(1, "read dd/dd/ffff wrong len\n");
    2335:	83 ec 08             	sub    $0x8,%esp
    2338:	68 ba 51 00 00       	push   $0x51ba
    233d:	6a 01                	push   $0x1
    233f:	e8 ff 1e 00 00       	call   4243 <printf>
    2344:	83 c4 10             	add    $0x10,%esp
    exit();
    2347:	e8 63 1d 00 00       	call   40af <exit>
  }
  close(fd);
    234c:	83 ec 0c             	sub    $0xc,%esp
    234f:	ff 75 f4             	pushl  -0xc(%ebp)
    2352:	e8 80 1d 00 00       	call   40d7 <close>
    2357:	83 c4 10             	add    $0x10,%esp

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    235a:	83 ec 08             	sub    $0x8,%esp
    235d:	6a 00                	push   $0x0
    235f:	68 74 50 00 00       	push   $0x5074
    2364:	e8 86 1d 00 00       	call   40ef <open>
    2369:	83 c4 10             	add    $0x10,%esp
    236c:	85 c0                	test   %eax,%eax
    236e:	78 17                	js     2387 <subdir+0x3b5>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2370:	83 ec 08             	sub    $0x8,%esp
    2373:	68 d8 51 00 00       	push   $0x51d8
    2378:	6a 01                	push   $0x1
    237a:	e8 c4 1e 00 00       	call   4243 <printf>
    237f:	83 c4 10             	add    $0x10,%esp
    exit();
    2382:	e8 28 1d 00 00       	call   40af <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2387:	83 ec 08             	sub    $0x8,%esp
    238a:	68 02 02 00 00       	push   $0x202
    238f:	68 fd 51 00 00       	push   $0x51fd
    2394:	e8 56 1d 00 00       	call   40ef <open>
    2399:	83 c4 10             	add    $0x10,%esp
    239c:	85 c0                	test   %eax,%eax
    239e:	78 17                	js     23b7 <subdir+0x3e5>
    printf(1, "create dd/ff/ff succeeded!\n");
    23a0:	83 ec 08             	sub    $0x8,%esp
    23a3:	68 06 52 00 00       	push   $0x5206
    23a8:	6a 01                	push   $0x1
    23aa:	e8 94 1e 00 00       	call   4243 <printf>
    23af:	83 c4 10             	add    $0x10,%esp
    exit();
    23b2:	e8 f8 1c 00 00       	call   40af <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    23b7:	83 ec 08             	sub    $0x8,%esp
    23ba:	68 02 02 00 00       	push   $0x202
    23bf:	68 22 52 00 00       	push   $0x5222
    23c4:	e8 26 1d 00 00       	call   40ef <open>
    23c9:	83 c4 10             	add    $0x10,%esp
    23cc:	85 c0                	test   %eax,%eax
    23ce:	78 17                	js     23e7 <subdir+0x415>
    printf(1, "create dd/xx/ff succeeded!\n");
    23d0:	83 ec 08             	sub    $0x8,%esp
    23d3:	68 2b 52 00 00       	push   $0x522b
    23d8:	6a 01                	push   $0x1
    23da:	e8 64 1e 00 00       	call   4243 <printf>
    23df:	83 c4 10             	add    $0x10,%esp
    exit();
    23e2:	e8 c8 1c 00 00       	call   40af <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    23e7:	83 ec 08             	sub    $0x8,%esp
    23ea:	68 00 02 00 00       	push   $0x200
    23ef:	68 f5 4f 00 00       	push   $0x4ff5
    23f4:	e8 f6 1c 00 00       	call   40ef <open>
    23f9:	83 c4 10             	add    $0x10,%esp
    23fc:	85 c0                	test   %eax,%eax
    23fe:	78 17                	js     2417 <subdir+0x445>
    printf(1, "create dd succeeded!\n");
    2400:	83 ec 08             	sub    $0x8,%esp
    2403:	68 47 52 00 00       	push   $0x5247
    2408:	6a 01                	push   $0x1
    240a:	e8 34 1e 00 00       	call   4243 <printf>
    240f:	83 c4 10             	add    $0x10,%esp
    exit();
    2412:	e8 98 1c 00 00       	call   40af <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    2417:	83 ec 08             	sub    $0x8,%esp
    241a:	6a 02                	push   $0x2
    241c:	68 f5 4f 00 00       	push   $0x4ff5
    2421:	e8 c9 1c 00 00       	call   40ef <open>
    2426:	83 c4 10             	add    $0x10,%esp
    2429:	85 c0                	test   %eax,%eax
    242b:	78 17                	js     2444 <subdir+0x472>
    printf(1, "open dd rdwr succeeded!\n");
    242d:	83 ec 08             	sub    $0x8,%esp
    2430:	68 5d 52 00 00       	push   $0x525d
    2435:	6a 01                	push   $0x1
    2437:	e8 07 1e 00 00       	call   4243 <printf>
    243c:	83 c4 10             	add    $0x10,%esp
    exit();
    243f:	e8 6b 1c 00 00       	call   40af <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    2444:	83 ec 08             	sub    $0x8,%esp
    2447:	6a 01                	push   $0x1
    2449:	68 f5 4f 00 00       	push   $0x4ff5
    244e:	e8 9c 1c 00 00       	call   40ef <open>
    2453:	83 c4 10             	add    $0x10,%esp
    2456:	85 c0                	test   %eax,%eax
    2458:	78 17                	js     2471 <subdir+0x49f>
    printf(1, "open dd wronly succeeded!\n");
    245a:	83 ec 08             	sub    $0x8,%esp
    245d:	68 76 52 00 00       	push   $0x5276
    2462:	6a 01                	push   $0x1
    2464:	e8 da 1d 00 00       	call   4243 <printf>
    2469:	83 c4 10             	add    $0x10,%esp
    exit();
    246c:	e8 3e 1c 00 00       	call   40af <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2471:	83 ec 08             	sub    $0x8,%esp
    2474:	68 91 52 00 00       	push   $0x5291
    2479:	68 fd 51 00 00       	push   $0x51fd
    247e:	e8 8c 1c 00 00       	call   410f <link>
    2483:	83 c4 10             	add    $0x10,%esp
    2486:	85 c0                	test   %eax,%eax
    2488:	75 17                	jne    24a1 <subdir+0x4cf>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    248a:	83 ec 08             	sub    $0x8,%esp
    248d:	68 9c 52 00 00       	push   $0x529c
    2492:	6a 01                	push   $0x1
    2494:	e8 aa 1d 00 00       	call   4243 <printf>
    2499:	83 c4 10             	add    $0x10,%esp
    exit();
    249c:	e8 0e 1c 00 00       	call   40af <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    24a1:	83 ec 08             	sub    $0x8,%esp
    24a4:	68 91 52 00 00       	push   $0x5291
    24a9:	68 22 52 00 00       	push   $0x5222
    24ae:	e8 5c 1c 00 00       	call   410f <link>
    24b3:	83 c4 10             	add    $0x10,%esp
    24b6:	85 c0                	test   %eax,%eax
    24b8:	75 17                	jne    24d1 <subdir+0x4ff>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    24ba:	83 ec 08             	sub    $0x8,%esp
    24bd:	68 c0 52 00 00       	push   $0x52c0
    24c2:	6a 01                	push   $0x1
    24c4:	e8 7a 1d 00 00       	call   4243 <printf>
    24c9:	83 c4 10             	add    $0x10,%esp
    exit();
    24cc:	e8 de 1b 00 00       	call   40af <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    24d1:	83 ec 08             	sub    $0x8,%esp
    24d4:	68 d8 50 00 00       	push   $0x50d8
    24d9:	68 10 50 00 00       	push   $0x5010
    24de:	e8 2c 1c 00 00       	call   410f <link>
    24e3:	83 c4 10             	add    $0x10,%esp
    24e6:	85 c0                	test   %eax,%eax
    24e8:	75 17                	jne    2501 <subdir+0x52f>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    24ea:	83 ec 08             	sub    $0x8,%esp
    24ed:	68 e4 52 00 00       	push   $0x52e4
    24f2:	6a 01                	push   $0x1
    24f4:	e8 4a 1d 00 00       	call   4243 <printf>
    24f9:	83 c4 10             	add    $0x10,%esp
    exit();
    24fc:	e8 ae 1b 00 00       	call   40af <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    2501:	83 ec 0c             	sub    $0xc,%esp
    2504:	68 fd 51 00 00       	push   $0x51fd
    2509:	e8 09 1c 00 00       	call   4117 <mkdir>
    250e:	83 c4 10             	add    $0x10,%esp
    2511:	85 c0                	test   %eax,%eax
    2513:	75 17                	jne    252c <subdir+0x55a>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2515:	83 ec 08             	sub    $0x8,%esp
    2518:	68 06 53 00 00       	push   $0x5306
    251d:	6a 01                	push   $0x1
    251f:	e8 1f 1d 00 00       	call   4243 <printf>
    2524:	83 c4 10             	add    $0x10,%esp
    exit();
    2527:	e8 83 1b 00 00       	call   40af <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    252c:	83 ec 0c             	sub    $0xc,%esp
    252f:	68 22 52 00 00       	push   $0x5222
    2534:	e8 de 1b 00 00       	call   4117 <mkdir>
    2539:	83 c4 10             	add    $0x10,%esp
    253c:	85 c0                	test   %eax,%eax
    253e:	75 17                	jne    2557 <subdir+0x585>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2540:	83 ec 08             	sub    $0x8,%esp
    2543:	68 21 53 00 00       	push   $0x5321
    2548:	6a 01                	push   $0x1
    254a:	e8 f4 1c 00 00       	call   4243 <printf>
    254f:	83 c4 10             	add    $0x10,%esp
    exit();
    2552:	e8 58 1b 00 00       	call   40af <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    2557:	83 ec 0c             	sub    $0xc,%esp
    255a:	68 d8 50 00 00       	push   $0x50d8
    255f:	e8 b3 1b 00 00       	call   4117 <mkdir>
    2564:	83 c4 10             	add    $0x10,%esp
    2567:	85 c0                	test   %eax,%eax
    2569:	75 17                	jne    2582 <subdir+0x5b0>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    256b:	83 ec 08             	sub    $0x8,%esp
    256e:	68 3c 53 00 00       	push   $0x533c
    2573:	6a 01                	push   $0x1
    2575:	e8 c9 1c 00 00       	call   4243 <printf>
    257a:	83 c4 10             	add    $0x10,%esp
    exit();
    257d:	e8 2d 1b 00 00       	call   40af <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    2582:	83 ec 0c             	sub    $0xc,%esp
    2585:	68 22 52 00 00       	push   $0x5222
    258a:	e8 70 1b 00 00       	call   40ff <unlink>
    258f:	83 c4 10             	add    $0x10,%esp
    2592:	85 c0                	test   %eax,%eax
    2594:	75 17                	jne    25ad <subdir+0x5db>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2596:	83 ec 08             	sub    $0x8,%esp
    2599:	68 59 53 00 00       	push   $0x5359
    259e:	6a 01                	push   $0x1
    25a0:	e8 9e 1c 00 00       	call   4243 <printf>
    25a5:	83 c4 10             	add    $0x10,%esp
    exit();
    25a8:	e8 02 1b 00 00       	call   40af <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    25ad:	83 ec 0c             	sub    $0xc,%esp
    25b0:	68 fd 51 00 00       	push   $0x51fd
    25b5:	e8 45 1b 00 00       	call   40ff <unlink>
    25ba:	83 c4 10             	add    $0x10,%esp
    25bd:	85 c0                	test   %eax,%eax
    25bf:	75 17                	jne    25d8 <subdir+0x606>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    25c1:	83 ec 08             	sub    $0x8,%esp
    25c4:	68 75 53 00 00       	push   $0x5375
    25c9:	6a 01                	push   $0x1
    25cb:	e8 73 1c 00 00       	call   4243 <printf>
    25d0:	83 c4 10             	add    $0x10,%esp
    exit();
    25d3:	e8 d7 1a 00 00       	call   40af <exit>
  }
  if(chdir("dd/ff") == 0){
    25d8:	83 ec 0c             	sub    $0xc,%esp
    25db:	68 10 50 00 00       	push   $0x5010
    25e0:	e8 3a 1b 00 00       	call   411f <chdir>
    25e5:	83 c4 10             	add    $0x10,%esp
    25e8:	85 c0                	test   %eax,%eax
    25ea:	75 17                	jne    2603 <subdir+0x631>
    printf(1, "chdir dd/ff succeeded!\n");
    25ec:	83 ec 08             	sub    $0x8,%esp
    25ef:	68 91 53 00 00       	push   $0x5391
    25f4:	6a 01                	push   $0x1
    25f6:	e8 48 1c 00 00       	call   4243 <printf>
    25fb:	83 c4 10             	add    $0x10,%esp
    exit();
    25fe:	e8 ac 1a 00 00       	call   40af <exit>
  }
  if(chdir("dd/xx") == 0){
    2603:	83 ec 0c             	sub    $0xc,%esp
    2606:	68 a9 53 00 00       	push   $0x53a9
    260b:	e8 0f 1b 00 00       	call   411f <chdir>
    2610:	83 c4 10             	add    $0x10,%esp
    2613:	85 c0                	test   %eax,%eax
    2615:	75 17                	jne    262e <subdir+0x65c>
    printf(1, "chdir dd/xx succeeded!\n");
    2617:	83 ec 08             	sub    $0x8,%esp
    261a:	68 af 53 00 00       	push   $0x53af
    261f:	6a 01                	push   $0x1
    2621:	e8 1d 1c 00 00       	call   4243 <printf>
    2626:	83 c4 10             	add    $0x10,%esp
    exit();
    2629:	e8 81 1a 00 00       	call   40af <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    262e:	83 ec 0c             	sub    $0xc,%esp
    2631:	68 d8 50 00 00       	push   $0x50d8
    2636:	e8 c4 1a 00 00       	call   40ff <unlink>
    263b:	83 c4 10             	add    $0x10,%esp
    263e:	85 c0                	test   %eax,%eax
    2640:	74 17                	je     2659 <subdir+0x687>
    printf(1, "unlink dd/dd/ff failed\n");
    2642:	83 ec 08             	sub    $0x8,%esp
    2645:	68 05 51 00 00       	push   $0x5105
    264a:	6a 01                	push   $0x1
    264c:	e8 f2 1b 00 00       	call   4243 <printf>
    2651:	83 c4 10             	add    $0x10,%esp
    exit();
    2654:	e8 56 1a 00 00       	call   40af <exit>
  }
  if(unlink("dd/ff") != 0){
    2659:	83 ec 0c             	sub    $0xc,%esp
    265c:	68 10 50 00 00       	push   $0x5010
    2661:	e8 99 1a 00 00       	call   40ff <unlink>
    2666:	83 c4 10             	add    $0x10,%esp
    2669:	85 c0                	test   %eax,%eax
    266b:	74 17                	je     2684 <subdir+0x6b2>
    printf(1, "unlink dd/ff failed\n");
    266d:	83 ec 08             	sub    $0x8,%esp
    2670:	68 c7 53 00 00       	push   $0x53c7
    2675:	6a 01                	push   $0x1
    2677:	e8 c7 1b 00 00       	call   4243 <printf>
    267c:	83 c4 10             	add    $0x10,%esp
    exit();
    267f:	e8 2b 1a 00 00       	call   40af <exit>
  }
  if(unlink("dd") == 0){
    2684:	83 ec 0c             	sub    $0xc,%esp
    2687:	68 f5 4f 00 00       	push   $0x4ff5
    268c:	e8 6e 1a 00 00       	call   40ff <unlink>
    2691:	83 c4 10             	add    $0x10,%esp
    2694:	85 c0                	test   %eax,%eax
    2696:	75 17                	jne    26af <subdir+0x6dd>
    printf(1, "unlink non-empty dd succeeded!\n");
    2698:	83 ec 08             	sub    $0x8,%esp
    269b:	68 dc 53 00 00       	push   $0x53dc
    26a0:	6a 01                	push   $0x1
    26a2:	e8 9c 1b 00 00       	call   4243 <printf>
    26a7:	83 c4 10             	add    $0x10,%esp
    exit();
    26aa:	e8 00 1a 00 00       	call   40af <exit>
  }
  if(unlink("dd/dd") < 0){
    26af:	83 ec 0c             	sub    $0xc,%esp
    26b2:	68 fc 53 00 00       	push   $0x53fc
    26b7:	e8 43 1a 00 00       	call   40ff <unlink>
    26bc:	83 c4 10             	add    $0x10,%esp
    26bf:	85 c0                	test   %eax,%eax
    26c1:	79 17                	jns    26da <subdir+0x708>
    printf(1, "unlink dd/dd failed\n");
    26c3:	83 ec 08             	sub    $0x8,%esp
    26c6:	68 02 54 00 00       	push   $0x5402
    26cb:	6a 01                	push   $0x1
    26cd:	e8 71 1b 00 00       	call   4243 <printf>
    26d2:	83 c4 10             	add    $0x10,%esp
    exit();
    26d5:	e8 d5 19 00 00       	call   40af <exit>
  }
  if(unlink("dd") < 0){
    26da:	83 ec 0c             	sub    $0xc,%esp
    26dd:	68 f5 4f 00 00       	push   $0x4ff5
    26e2:	e8 18 1a 00 00       	call   40ff <unlink>
    26e7:	83 c4 10             	add    $0x10,%esp
    26ea:	85 c0                	test   %eax,%eax
    26ec:	79 17                	jns    2705 <subdir+0x733>
    printf(1, "unlink dd failed\n");
    26ee:	83 ec 08             	sub    $0x8,%esp
    26f1:	68 17 54 00 00       	push   $0x5417
    26f6:	6a 01                	push   $0x1
    26f8:	e8 46 1b 00 00       	call   4243 <printf>
    26fd:	83 c4 10             	add    $0x10,%esp
    exit();
    2700:	e8 aa 19 00 00       	call   40af <exit>
  }

  printf(1, "subdir ok\n");
    2705:	83 ec 08             	sub    $0x8,%esp
    2708:	68 29 54 00 00       	push   $0x5429
    270d:	6a 01                	push   $0x1
    270f:	e8 2f 1b 00 00       	call   4243 <printf>
    2714:	83 c4 10             	add    $0x10,%esp
}
    2717:	90                   	nop
    2718:	c9                   	leave  
    2719:	c3                   	ret    

0000271a <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    271a:	f3 0f 1e fb          	endbr32 
    271e:	55                   	push   %ebp
    271f:	89 e5                	mov    %esp,%ebp
    2721:	83 ec 18             	sub    $0x18,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    2724:	83 ec 08             	sub    $0x8,%esp
    2727:	68 34 54 00 00       	push   $0x5434
    272c:	6a 01                	push   $0x1
    272e:	e8 10 1b 00 00       	call   4243 <printf>
    2733:	83 c4 10             	add    $0x10,%esp

  unlink("bigwrite");
    2736:	83 ec 0c             	sub    $0xc,%esp
    2739:	68 43 54 00 00       	push   $0x5443
    273e:	e8 bc 19 00 00       	call   40ff <unlink>
    2743:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    2746:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    274d:	e9 a8 00 00 00       	jmp    27fa <bigwrite+0xe0>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2752:	83 ec 08             	sub    $0x8,%esp
    2755:	68 02 02 00 00       	push   $0x202
    275a:	68 43 54 00 00       	push   $0x5443
    275f:	e8 8b 19 00 00       	call   40ef <open>
    2764:	83 c4 10             	add    $0x10,%esp
    2767:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    276a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    276e:	79 17                	jns    2787 <bigwrite+0x6d>
      printf(1, "cannot create bigwrite\n");
    2770:	83 ec 08             	sub    $0x8,%esp
    2773:	68 4c 54 00 00       	push   $0x544c
    2778:	6a 01                	push   $0x1
    277a:	e8 c4 1a 00 00       	call   4243 <printf>
    277f:	83 c4 10             	add    $0x10,%esp
      exit();
    2782:	e8 28 19 00 00       	call   40af <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    2787:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    278e:	eb 3f                	jmp    27cf <bigwrite+0xb5>
      int cc = write(fd, buf, sz);
    2790:	83 ec 04             	sub    $0x4,%esp
    2793:	ff 75 f4             	pushl  -0xc(%ebp)
    2796:	68 40 8d 00 00       	push   $0x8d40
    279b:	ff 75 ec             	pushl  -0x14(%ebp)
    279e:	e8 2c 19 00 00       	call   40cf <write>
    27a3:	83 c4 10             	add    $0x10,%esp
    27a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    27a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    27ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    27af:	74 1a                	je     27cb <bigwrite+0xb1>
        printf(1, "write(%d) ret %d\n", sz, cc);
    27b1:	ff 75 e8             	pushl  -0x18(%ebp)
    27b4:	ff 75 f4             	pushl  -0xc(%ebp)
    27b7:	68 64 54 00 00       	push   $0x5464
    27bc:	6a 01                	push   $0x1
    27be:	e8 80 1a 00 00       	call   4243 <printf>
    27c3:	83 c4 10             	add    $0x10,%esp
        exit();
    27c6:	e8 e4 18 00 00       	call   40af <exit>
    for(i = 0; i < 2; i++){
    27cb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    27cf:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    27d3:	7e bb                	jle    2790 <bigwrite+0x76>
      }
    }
    close(fd);
    27d5:	83 ec 0c             	sub    $0xc,%esp
    27d8:	ff 75 ec             	pushl  -0x14(%ebp)
    27db:	e8 f7 18 00 00       	call   40d7 <close>
    27e0:	83 c4 10             	add    $0x10,%esp
    unlink("bigwrite");
    27e3:	83 ec 0c             	sub    $0xc,%esp
    27e6:	68 43 54 00 00       	push   $0x5443
    27eb:	e8 0f 19 00 00       	call   40ff <unlink>
    27f0:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    27f3:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    27fa:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    2801:	0f 8e 4b ff ff ff    	jle    2752 <bigwrite+0x38>
  }

  printf(1, "bigwrite ok\n");
    2807:	83 ec 08             	sub    $0x8,%esp
    280a:	68 76 54 00 00       	push   $0x5476
    280f:	6a 01                	push   $0x1
    2811:	e8 2d 1a 00 00       	call   4243 <printf>
    2816:	83 c4 10             	add    $0x10,%esp
}
    2819:	90                   	nop
    281a:	c9                   	leave  
    281b:	c3                   	ret    

0000281c <bigfile>:

void
bigfile(void)
{
    281c:	f3 0f 1e fb          	endbr32 
    2820:	55                   	push   %ebp
    2821:	89 e5                	mov    %esp,%ebp
    2823:	83 ec 18             	sub    $0x18,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2826:	83 ec 08             	sub    $0x8,%esp
    2829:	68 83 54 00 00       	push   $0x5483
    282e:	6a 01                	push   $0x1
    2830:	e8 0e 1a 00 00       	call   4243 <printf>
    2835:	83 c4 10             	add    $0x10,%esp

  unlink("bigfile");
    2838:	83 ec 0c             	sub    $0xc,%esp
    283b:	68 91 54 00 00       	push   $0x5491
    2840:	e8 ba 18 00 00       	call   40ff <unlink>
    2845:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", O_CREATE | O_RDWR);
    2848:	83 ec 08             	sub    $0x8,%esp
    284b:	68 02 02 00 00       	push   $0x202
    2850:	68 91 54 00 00       	push   $0x5491
    2855:	e8 95 18 00 00       	call   40ef <open>
    285a:	83 c4 10             	add    $0x10,%esp
    285d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2860:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2864:	79 17                	jns    287d <bigfile+0x61>
    printf(1, "cannot create bigfile");
    2866:	83 ec 08             	sub    $0x8,%esp
    2869:	68 99 54 00 00       	push   $0x5499
    286e:	6a 01                	push   $0x1
    2870:	e8 ce 19 00 00       	call   4243 <printf>
    2875:	83 c4 10             	add    $0x10,%esp
    exit();
    2878:	e8 32 18 00 00       	call   40af <exit>
  }
  for(i = 0; i < 20; i++){
    287d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2884:	eb 52                	jmp    28d8 <bigfile+0xbc>
    memset(buf, i, 600);
    2886:	83 ec 04             	sub    $0x4,%esp
    2889:	68 58 02 00 00       	push   $0x258
    288e:	ff 75 f4             	pushl  -0xc(%ebp)
    2891:	68 40 8d 00 00       	push   $0x8d40
    2896:	e8 61 16 00 00       	call   3efc <memset>
    289b:	83 c4 10             	add    $0x10,%esp
    if(write(fd, buf, 600) != 600){
    289e:	83 ec 04             	sub    $0x4,%esp
    28a1:	68 58 02 00 00       	push   $0x258
    28a6:	68 40 8d 00 00       	push   $0x8d40
    28ab:	ff 75 ec             	pushl  -0x14(%ebp)
    28ae:	e8 1c 18 00 00       	call   40cf <write>
    28b3:	83 c4 10             	add    $0x10,%esp
    28b6:	3d 58 02 00 00       	cmp    $0x258,%eax
    28bb:	74 17                	je     28d4 <bigfile+0xb8>
      printf(1, "write bigfile failed\n");
    28bd:	83 ec 08             	sub    $0x8,%esp
    28c0:	68 af 54 00 00       	push   $0x54af
    28c5:	6a 01                	push   $0x1
    28c7:	e8 77 19 00 00       	call   4243 <printf>
    28cc:	83 c4 10             	add    $0x10,%esp
      exit();
    28cf:	e8 db 17 00 00       	call   40af <exit>
  for(i = 0; i < 20; i++){
    28d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    28d8:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    28dc:	7e a8                	jle    2886 <bigfile+0x6a>
    }
  }
  close(fd);
    28de:	83 ec 0c             	sub    $0xc,%esp
    28e1:	ff 75 ec             	pushl  -0x14(%ebp)
    28e4:	e8 ee 17 00 00       	call   40d7 <close>
    28e9:	83 c4 10             	add    $0x10,%esp

  fd = open("bigfile", 0);
    28ec:	83 ec 08             	sub    $0x8,%esp
    28ef:	6a 00                	push   $0x0
    28f1:	68 91 54 00 00       	push   $0x5491
    28f6:	e8 f4 17 00 00       	call   40ef <open>
    28fb:	83 c4 10             	add    $0x10,%esp
    28fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2901:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2905:	79 17                	jns    291e <bigfile+0x102>
    printf(1, "cannot open bigfile\n");
    2907:	83 ec 08             	sub    $0x8,%esp
    290a:	68 c5 54 00 00       	push   $0x54c5
    290f:	6a 01                	push   $0x1
    2911:	e8 2d 19 00 00       	call   4243 <printf>
    2916:	83 c4 10             	add    $0x10,%esp
    exit();
    2919:	e8 91 17 00 00       	call   40af <exit>
  }
  total = 0;
    291e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    2925:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    292c:	83 ec 04             	sub    $0x4,%esp
    292f:	68 2c 01 00 00       	push   $0x12c
    2934:	68 40 8d 00 00       	push   $0x8d40
    2939:	ff 75 ec             	pushl  -0x14(%ebp)
    293c:	e8 86 17 00 00       	call   40c7 <read>
    2941:	83 c4 10             	add    $0x10,%esp
    2944:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    2947:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    294b:	79 17                	jns    2964 <bigfile+0x148>
      printf(1, "read bigfile failed\n");
    294d:	83 ec 08             	sub    $0x8,%esp
    2950:	68 da 54 00 00       	push   $0x54da
    2955:	6a 01                	push   $0x1
    2957:	e8 e7 18 00 00       	call   4243 <printf>
    295c:	83 c4 10             	add    $0x10,%esp
      exit();
    295f:	e8 4b 17 00 00       	call   40af <exit>
    }
    if(cc == 0)
    2964:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2968:	74 7a                	je     29e4 <bigfile+0x1c8>
      break;
    if(cc != 300){
    296a:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    2971:	74 17                	je     298a <bigfile+0x16e>
      printf(1, "short read bigfile\n");
    2973:	83 ec 08             	sub    $0x8,%esp
    2976:	68 ef 54 00 00       	push   $0x54ef
    297b:	6a 01                	push   $0x1
    297d:	e8 c1 18 00 00       	call   4243 <printf>
    2982:	83 c4 10             	add    $0x10,%esp
      exit();
    2985:	e8 25 17 00 00       	call   40af <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    298a:	0f b6 05 40 8d 00 00 	movzbl 0x8d40,%eax
    2991:	0f be d0             	movsbl %al,%edx
    2994:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2997:	89 c1                	mov    %eax,%ecx
    2999:	c1 e9 1f             	shr    $0x1f,%ecx
    299c:	01 c8                	add    %ecx,%eax
    299e:	d1 f8                	sar    %eax
    29a0:	39 c2                	cmp    %eax,%edx
    29a2:	75 1a                	jne    29be <bigfile+0x1a2>
    29a4:	0f b6 05 6b 8e 00 00 	movzbl 0x8e6b,%eax
    29ab:	0f be d0             	movsbl %al,%edx
    29ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    29b1:	89 c1                	mov    %eax,%ecx
    29b3:	c1 e9 1f             	shr    $0x1f,%ecx
    29b6:	01 c8                	add    %ecx,%eax
    29b8:	d1 f8                	sar    %eax
    29ba:	39 c2                	cmp    %eax,%edx
    29bc:	74 17                	je     29d5 <bigfile+0x1b9>
      printf(1, "read bigfile wrong data\n");
    29be:	83 ec 08             	sub    $0x8,%esp
    29c1:	68 03 55 00 00       	push   $0x5503
    29c6:	6a 01                	push   $0x1
    29c8:	e8 76 18 00 00       	call   4243 <printf>
    29cd:	83 c4 10             	add    $0x10,%esp
      exit();
    29d0:	e8 da 16 00 00       	call   40af <exit>
    }
    total += cc;
    29d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    29d8:	01 45 f0             	add    %eax,-0x10(%ebp)
  for(i = 0; ; i++){
    29db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    cc = read(fd, buf, 300);
    29df:	e9 48 ff ff ff       	jmp    292c <bigfile+0x110>
      break;
    29e4:	90                   	nop
  }
  close(fd);
    29e5:	83 ec 0c             	sub    $0xc,%esp
    29e8:	ff 75 ec             	pushl  -0x14(%ebp)
    29eb:	e8 e7 16 00 00       	call   40d7 <close>
    29f0:	83 c4 10             	add    $0x10,%esp
  if(total != 20*600){
    29f3:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    29fa:	74 17                	je     2a13 <bigfile+0x1f7>
    printf(1, "read bigfile wrong total\n");
    29fc:	83 ec 08             	sub    $0x8,%esp
    29ff:	68 1c 55 00 00       	push   $0x551c
    2a04:	6a 01                	push   $0x1
    2a06:	e8 38 18 00 00       	call   4243 <printf>
    2a0b:	83 c4 10             	add    $0x10,%esp
    exit();
    2a0e:	e8 9c 16 00 00       	call   40af <exit>
  }
  unlink("bigfile");
    2a13:	83 ec 0c             	sub    $0xc,%esp
    2a16:	68 91 54 00 00       	push   $0x5491
    2a1b:	e8 df 16 00 00       	call   40ff <unlink>
    2a20:	83 c4 10             	add    $0x10,%esp

  printf(1, "bigfile test ok\n");
    2a23:	83 ec 08             	sub    $0x8,%esp
    2a26:	68 36 55 00 00       	push   $0x5536
    2a2b:	6a 01                	push   $0x1
    2a2d:	e8 11 18 00 00       	call   4243 <printf>
    2a32:	83 c4 10             	add    $0x10,%esp
}
    2a35:	90                   	nop
    2a36:	c9                   	leave  
    2a37:	c3                   	ret    

00002a38 <fourteen>:

void
fourteen(void)
{
    2a38:	f3 0f 1e fb          	endbr32 
    2a3c:	55                   	push   %ebp
    2a3d:	89 e5                	mov    %esp,%ebp
    2a3f:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2a42:	83 ec 08             	sub    $0x8,%esp
    2a45:	68 47 55 00 00       	push   $0x5547
    2a4a:	6a 01                	push   $0x1
    2a4c:	e8 f2 17 00 00       	call   4243 <printf>
    2a51:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234") != 0){
    2a54:	83 ec 0c             	sub    $0xc,%esp
    2a57:	68 56 55 00 00       	push   $0x5556
    2a5c:	e8 b6 16 00 00       	call   4117 <mkdir>
    2a61:	83 c4 10             	add    $0x10,%esp
    2a64:	85 c0                	test   %eax,%eax
    2a66:	74 17                	je     2a7f <fourteen+0x47>
    printf(1, "mkdir 12345678901234 failed\n");
    2a68:	83 ec 08             	sub    $0x8,%esp
    2a6b:	68 65 55 00 00       	push   $0x5565
    2a70:	6a 01                	push   $0x1
    2a72:	e8 cc 17 00 00       	call   4243 <printf>
    2a77:	83 c4 10             	add    $0x10,%esp
    exit();
    2a7a:	e8 30 16 00 00       	call   40af <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a7f:	83 ec 0c             	sub    $0xc,%esp
    2a82:	68 84 55 00 00       	push   $0x5584
    2a87:	e8 8b 16 00 00       	call   4117 <mkdir>
    2a8c:	83 c4 10             	add    $0x10,%esp
    2a8f:	85 c0                	test   %eax,%eax
    2a91:	74 17                	je     2aaa <fourteen+0x72>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a93:	83 ec 08             	sub    $0x8,%esp
    2a96:	68 a4 55 00 00       	push   $0x55a4
    2a9b:	6a 01                	push   $0x1
    2a9d:	e8 a1 17 00 00       	call   4243 <printf>
    2aa2:	83 c4 10             	add    $0x10,%esp
    exit();
    2aa5:	e8 05 16 00 00       	call   40af <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2aaa:	83 ec 08             	sub    $0x8,%esp
    2aad:	68 00 02 00 00       	push   $0x200
    2ab2:	68 d4 55 00 00       	push   $0x55d4
    2ab7:	e8 33 16 00 00       	call   40ef <open>
    2abc:	83 c4 10             	add    $0x10,%esp
    2abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ac6:	79 17                	jns    2adf <fourteen+0xa7>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2ac8:	83 ec 08             	sub    $0x8,%esp
    2acb:	68 04 56 00 00       	push   $0x5604
    2ad0:	6a 01                	push   $0x1
    2ad2:	e8 6c 17 00 00       	call   4243 <printf>
    2ad7:	83 c4 10             	add    $0x10,%esp
    exit();
    2ada:	e8 d0 15 00 00       	call   40af <exit>
  }
  close(fd);
    2adf:	83 ec 0c             	sub    $0xc,%esp
    2ae2:	ff 75 f4             	pushl  -0xc(%ebp)
    2ae5:	e8 ed 15 00 00       	call   40d7 <close>
    2aea:	83 c4 10             	add    $0x10,%esp
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2aed:	83 ec 08             	sub    $0x8,%esp
    2af0:	6a 00                	push   $0x0
    2af2:	68 44 56 00 00       	push   $0x5644
    2af7:	e8 f3 15 00 00       	call   40ef <open>
    2afc:	83 c4 10             	add    $0x10,%esp
    2aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2b06:	79 17                	jns    2b1f <fourteen+0xe7>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2b08:	83 ec 08             	sub    $0x8,%esp
    2b0b:	68 74 56 00 00       	push   $0x5674
    2b10:	6a 01                	push   $0x1
    2b12:	e8 2c 17 00 00       	call   4243 <printf>
    2b17:	83 c4 10             	add    $0x10,%esp
    exit();
    2b1a:	e8 90 15 00 00       	call   40af <exit>
  }
  close(fd);
    2b1f:	83 ec 0c             	sub    $0xc,%esp
    2b22:	ff 75 f4             	pushl  -0xc(%ebp)
    2b25:	e8 ad 15 00 00       	call   40d7 <close>
    2b2a:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234/12345678901234") == 0){
    2b2d:	83 ec 0c             	sub    $0xc,%esp
    2b30:	68 ae 56 00 00       	push   $0x56ae
    2b35:	e8 dd 15 00 00       	call   4117 <mkdir>
    2b3a:	83 c4 10             	add    $0x10,%esp
    2b3d:	85 c0                	test   %eax,%eax
    2b3f:	75 17                	jne    2b58 <fourteen+0x120>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2b41:	83 ec 08             	sub    $0x8,%esp
    2b44:	68 cc 56 00 00       	push   $0x56cc
    2b49:	6a 01                	push   $0x1
    2b4b:	e8 f3 16 00 00       	call   4243 <printf>
    2b50:	83 c4 10             	add    $0x10,%esp
    exit();
    2b53:	e8 57 15 00 00       	call   40af <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2b58:	83 ec 0c             	sub    $0xc,%esp
    2b5b:	68 fc 56 00 00       	push   $0x56fc
    2b60:	e8 b2 15 00 00       	call   4117 <mkdir>
    2b65:	83 c4 10             	add    $0x10,%esp
    2b68:	85 c0                	test   %eax,%eax
    2b6a:	75 17                	jne    2b83 <fourteen+0x14b>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2b6c:	83 ec 08             	sub    $0x8,%esp
    2b6f:	68 1c 57 00 00       	push   $0x571c
    2b74:	6a 01                	push   $0x1
    2b76:	e8 c8 16 00 00       	call   4243 <printf>
    2b7b:	83 c4 10             	add    $0x10,%esp
    exit();
    2b7e:	e8 2c 15 00 00       	call   40af <exit>
  }

  printf(1, "fourteen ok\n");
    2b83:	83 ec 08             	sub    $0x8,%esp
    2b86:	68 4d 57 00 00       	push   $0x574d
    2b8b:	6a 01                	push   $0x1
    2b8d:	e8 b1 16 00 00       	call   4243 <printf>
    2b92:	83 c4 10             	add    $0x10,%esp
}
    2b95:	90                   	nop
    2b96:	c9                   	leave  
    2b97:	c3                   	ret    

00002b98 <rmdot>:

void
rmdot(void)
{
    2b98:	f3 0f 1e fb          	endbr32 
    2b9c:	55                   	push   %ebp
    2b9d:	89 e5                	mov    %esp,%ebp
    2b9f:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
    2ba2:	83 ec 08             	sub    $0x8,%esp
    2ba5:	68 5a 57 00 00       	push   $0x575a
    2baa:	6a 01                	push   $0x1
    2bac:	e8 92 16 00 00       	call   4243 <printf>
    2bb1:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dots") != 0){
    2bb4:	83 ec 0c             	sub    $0xc,%esp
    2bb7:	68 66 57 00 00       	push   $0x5766
    2bbc:	e8 56 15 00 00       	call   4117 <mkdir>
    2bc1:	83 c4 10             	add    $0x10,%esp
    2bc4:	85 c0                	test   %eax,%eax
    2bc6:	74 17                	je     2bdf <rmdot+0x47>
    printf(1, "mkdir dots failed\n");
    2bc8:	83 ec 08             	sub    $0x8,%esp
    2bcb:	68 6b 57 00 00       	push   $0x576b
    2bd0:	6a 01                	push   $0x1
    2bd2:	e8 6c 16 00 00       	call   4243 <printf>
    2bd7:	83 c4 10             	add    $0x10,%esp
    exit();
    2bda:	e8 d0 14 00 00       	call   40af <exit>
  }
  if(chdir("dots") != 0){
    2bdf:	83 ec 0c             	sub    $0xc,%esp
    2be2:	68 66 57 00 00       	push   $0x5766
    2be7:	e8 33 15 00 00       	call   411f <chdir>
    2bec:	83 c4 10             	add    $0x10,%esp
    2bef:	85 c0                	test   %eax,%eax
    2bf1:	74 17                	je     2c0a <rmdot+0x72>
    printf(1, "chdir dots failed\n");
    2bf3:	83 ec 08             	sub    $0x8,%esp
    2bf6:	68 7e 57 00 00       	push   $0x577e
    2bfb:	6a 01                	push   $0x1
    2bfd:	e8 41 16 00 00       	call   4243 <printf>
    2c02:	83 c4 10             	add    $0x10,%esp
    exit();
    2c05:	e8 a5 14 00 00       	call   40af <exit>
  }
  if(unlink(".") == 0){
    2c0a:	83 ec 0c             	sub    $0xc,%esp
    2c0d:	68 97 4e 00 00       	push   $0x4e97
    2c12:	e8 e8 14 00 00       	call   40ff <unlink>
    2c17:	83 c4 10             	add    $0x10,%esp
    2c1a:	85 c0                	test   %eax,%eax
    2c1c:	75 17                	jne    2c35 <rmdot+0x9d>
    printf(1, "rm . worked!\n");
    2c1e:	83 ec 08             	sub    $0x8,%esp
    2c21:	68 91 57 00 00       	push   $0x5791
    2c26:	6a 01                	push   $0x1
    2c28:	e8 16 16 00 00       	call   4243 <printf>
    2c2d:	83 c4 10             	add    $0x10,%esp
    exit();
    2c30:	e8 7a 14 00 00       	call   40af <exit>
  }
  if(unlink("..") == 0){
    2c35:	83 ec 0c             	sub    $0xc,%esp
    2c38:	68 2a 4a 00 00       	push   $0x4a2a
    2c3d:	e8 bd 14 00 00       	call   40ff <unlink>
    2c42:	83 c4 10             	add    $0x10,%esp
    2c45:	85 c0                	test   %eax,%eax
    2c47:	75 17                	jne    2c60 <rmdot+0xc8>
    printf(1, "rm .. worked!\n");
    2c49:	83 ec 08             	sub    $0x8,%esp
    2c4c:	68 9f 57 00 00       	push   $0x579f
    2c51:	6a 01                	push   $0x1
    2c53:	e8 eb 15 00 00       	call   4243 <printf>
    2c58:	83 c4 10             	add    $0x10,%esp
    exit();
    2c5b:	e8 4f 14 00 00       	call   40af <exit>
  }
  if(chdir("/") != 0){
    2c60:	83 ec 0c             	sub    $0xc,%esp
    2c63:	68 7e 46 00 00       	push   $0x467e
    2c68:	e8 b2 14 00 00       	call   411f <chdir>
    2c6d:	83 c4 10             	add    $0x10,%esp
    2c70:	85 c0                	test   %eax,%eax
    2c72:	74 17                	je     2c8b <rmdot+0xf3>
    printf(1, "chdir / failed\n");
    2c74:	83 ec 08             	sub    $0x8,%esp
    2c77:	68 80 46 00 00       	push   $0x4680
    2c7c:	6a 01                	push   $0x1
    2c7e:	e8 c0 15 00 00       	call   4243 <printf>
    2c83:	83 c4 10             	add    $0x10,%esp
    exit();
    2c86:	e8 24 14 00 00       	call   40af <exit>
  }
  if(unlink("dots/.") == 0){
    2c8b:	83 ec 0c             	sub    $0xc,%esp
    2c8e:	68 ae 57 00 00       	push   $0x57ae
    2c93:	e8 67 14 00 00       	call   40ff <unlink>
    2c98:	83 c4 10             	add    $0x10,%esp
    2c9b:	85 c0                	test   %eax,%eax
    2c9d:	75 17                	jne    2cb6 <rmdot+0x11e>
    printf(1, "unlink dots/. worked!\n");
    2c9f:	83 ec 08             	sub    $0x8,%esp
    2ca2:	68 b5 57 00 00       	push   $0x57b5
    2ca7:	6a 01                	push   $0x1
    2ca9:	e8 95 15 00 00       	call   4243 <printf>
    2cae:	83 c4 10             	add    $0x10,%esp
    exit();
    2cb1:	e8 f9 13 00 00       	call   40af <exit>
  }
  if(unlink("dots/..") == 0){
    2cb6:	83 ec 0c             	sub    $0xc,%esp
    2cb9:	68 cc 57 00 00       	push   $0x57cc
    2cbe:	e8 3c 14 00 00       	call   40ff <unlink>
    2cc3:	83 c4 10             	add    $0x10,%esp
    2cc6:	85 c0                	test   %eax,%eax
    2cc8:	75 17                	jne    2ce1 <rmdot+0x149>
    printf(1, "unlink dots/.. worked!\n");
    2cca:	83 ec 08             	sub    $0x8,%esp
    2ccd:	68 d4 57 00 00       	push   $0x57d4
    2cd2:	6a 01                	push   $0x1
    2cd4:	e8 6a 15 00 00       	call   4243 <printf>
    2cd9:	83 c4 10             	add    $0x10,%esp
    exit();
    2cdc:	e8 ce 13 00 00       	call   40af <exit>
  }
  if(unlink("dots") != 0){
    2ce1:	83 ec 0c             	sub    $0xc,%esp
    2ce4:	68 66 57 00 00       	push   $0x5766
    2ce9:	e8 11 14 00 00       	call   40ff <unlink>
    2cee:	83 c4 10             	add    $0x10,%esp
    2cf1:	85 c0                	test   %eax,%eax
    2cf3:	74 17                	je     2d0c <rmdot+0x174>
    printf(1, "unlink dots failed!\n");
    2cf5:	83 ec 08             	sub    $0x8,%esp
    2cf8:	68 ec 57 00 00       	push   $0x57ec
    2cfd:	6a 01                	push   $0x1
    2cff:	e8 3f 15 00 00       	call   4243 <printf>
    2d04:	83 c4 10             	add    $0x10,%esp
    exit();
    2d07:	e8 a3 13 00 00       	call   40af <exit>
  }
  printf(1, "rmdot ok\n");
    2d0c:	83 ec 08             	sub    $0x8,%esp
    2d0f:	68 01 58 00 00       	push   $0x5801
    2d14:	6a 01                	push   $0x1
    2d16:	e8 28 15 00 00       	call   4243 <printf>
    2d1b:	83 c4 10             	add    $0x10,%esp
}
    2d1e:	90                   	nop
    2d1f:	c9                   	leave  
    2d20:	c3                   	ret    

00002d21 <dirfile>:

void
dirfile(void)
{
    2d21:	f3 0f 1e fb          	endbr32 
    2d25:	55                   	push   %ebp
    2d26:	89 e5                	mov    %esp,%ebp
    2d28:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "dir vs file\n");
    2d2b:	83 ec 08             	sub    $0x8,%esp
    2d2e:	68 0b 58 00 00       	push   $0x580b
    2d33:	6a 01                	push   $0x1
    2d35:	e8 09 15 00 00       	call   4243 <printf>
    2d3a:	83 c4 10             	add    $0x10,%esp

  fd = open("dirfile", O_CREATE);
    2d3d:	83 ec 08             	sub    $0x8,%esp
    2d40:	68 00 02 00 00       	push   $0x200
    2d45:	68 18 58 00 00       	push   $0x5818
    2d4a:	e8 a0 13 00 00       	call   40ef <open>
    2d4f:	83 c4 10             	add    $0x10,%esp
    2d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2d55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d59:	79 17                	jns    2d72 <dirfile+0x51>
    printf(1, "create dirfile failed\n");
    2d5b:	83 ec 08             	sub    $0x8,%esp
    2d5e:	68 20 58 00 00       	push   $0x5820
    2d63:	6a 01                	push   $0x1
    2d65:	e8 d9 14 00 00       	call   4243 <printf>
    2d6a:	83 c4 10             	add    $0x10,%esp
    exit();
    2d6d:	e8 3d 13 00 00       	call   40af <exit>
  }
  close(fd);
    2d72:	83 ec 0c             	sub    $0xc,%esp
    2d75:	ff 75 f4             	pushl  -0xc(%ebp)
    2d78:	e8 5a 13 00 00       	call   40d7 <close>
    2d7d:	83 c4 10             	add    $0x10,%esp
  if(chdir("dirfile") == 0){
    2d80:	83 ec 0c             	sub    $0xc,%esp
    2d83:	68 18 58 00 00       	push   $0x5818
    2d88:	e8 92 13 00 00       	call   411f <chdir>
    2d8d:	83 c4 10             	add    $0x10,%esp
    2d90:	85 c0                	test   %eax,%eax
    2d92:	75 17                	jne    2dab <dirfile+0x8a>
    printf(1, "chdir dirfile succeeded!\n");
    2d94:	83 ec 08             	sub    $0x8,%esp
    2d97:	68 37 58 00 00       	push   $0x5837
    2d9c:	6a 01                	push   $0x1
    2d9e:	e8 a0 14 00 00       	call   4243 <printf>
    2da3:	83 c4 10             	add    $0x10,%esp
    exit();
    2da6:	e8 04 13 00 00       	call   40af <exit>
  }
  fd = open("dirfile/xx", 0);
    2dab:	83 ec 08             	sub    $0x8,%esp
    2dae:	6a 00                	push   $0x0
    2db0:	68 51 58 00 00       	push   $0x5851
    2db5:	e8 35 13 00 00       	call   40ef <open>
    2dba:	83 c4 10             	add    $0x10,%esp
    2dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2dc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2dc4:	78 17                	js     2ddd <dirfile+0xbc>
    printf(1, "create dirfile/xx succeeded!\n");
    2dc6:	83 ec 08             	sub    $0x8,%esp
    2dc9:	68 5c 58 00 00       	push   $0x585c
    2dce:	6a 01                	push   $0x1
    2dd0:	e8 6e 14 00 00       	call   4243 <printf>
    2dd5:	83 c4 10             	add    $0x10,%esp
    exit();
    2dd8:	e8 d2 12 00 00       	call   40af <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2ddd:	83 ec 08             	sub    $0x8,%esp
    2de0:	68 00 02 00 00       	push   $0x200
    2de5:	68 51 58 00 00       	push   $0x5851
    2dea:	e8 00 13 00 00       	call   40ef <open>
    2def:	83 c4 10             	add    $0x10,%esp
    2df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2df5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2df9:	78 17                	js     2e12 <dirfile+0xf1>
    printf(1, "create dirfile/xx succeeded!\n");
    2dfb:	83 ec 08             	sub    $0x8,%esp
    2dfe:	68 5c 58 00 00       	push   $0x585c
    2e03:	6a 01                	push   $0x1
    2e05:	e8 39 14 00 00       	call   4243 <printf>
    2e0a:	83 c4 10             	add    $0x10,%esp
    exit();
    2e0d:	e8 9d 12 00 00       	call   40af <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2e12:	83 ec 0c             	sub    $0xc,%esp
    2e15:	68 51 58 00 00       	push   $0x5851
    2e1a:	e8 f8 12 00 00       	call   4117 <mkdir>
    2e1f:	83 c4 10             	add    $0x10,%esp
    2e22:	85 c0                	test   %eax,%eax
    2e24:	75 17                	jne    2e3d <dirfile+0x11c>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2e26:	83 ec 08             	sub    $0x8,%esp
    2e29:	68 7a 58 00 00       	push   $0x587a
    2e2e:	6a 01                	push   $0x1
    2e30:	e8 0e 14 00 00       	call   4243 <printf>
    2e35:	83 c4 10             	add    $0x10,%esp
    exit();
    2e38:	e8 72 12 00 00       	call   40af <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2e3d:	83 ec 0c             	sub    $0xc,%esp
    2e40:	68 51 58 00 00       	push   $0x5851
    2e45:	e8 b5 12 00 00       	call   40ff <unlink>
    2e4a:	83 c4 10             	add    $0x10,%esp
    2e4d:	85 c0                	test   %eax,%eax
    2e4f:	75 17                	jne    2e68 <dirfile+0x147>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2e51:	83 ec 08             	sub    $0x8,%esp
    2e54:	68 97 58 00 00       	push   $0x5897
    2e59:	6a 01                	push   $0x1
    2e5b:	e8 e3 13 00 00       	call   4243 <printf>
    2e60:	83 c4 10             	add    $0x10,%esp
    exit();
    2e63:	e8 47 12 00 00       	call   40af <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2e68:	83 ec 08             	sub    $0x8,%esp
    2e6b:	68 51 58 00 00       	push   $0x5851
    2e70:	68 b5 58 00 00       	push   $0x58b5
    2e75:	e8 95 12 00 00       	call   410f <link>
    2e7a:	83 c4 10             	add    $0x10,%esp
    2e7d:	85 c0                	test   %eax,%eax
    2e7f:	75 17                	jne    2e98 <dirfile+0x177>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e81:	83 ec 08             	sub    $0x8,%esp
    2e84:	68 bc 58 00 00       	push   $0x58bc
    2e89:	6a 01                	push   $0x1
    2e8b:	e8 b3 13 00 00       	call   4243 <printf>
    2e90:	83 c4 10             	add    $0x10,%esp
    exit();
    2e93:	e8 17 12 00 00       	call   40af <exit>
  }
  if(unlink("dirfile") != 0){
    2e98:	83 ec 0c             	sub    $0xc,%esp
    2e9b:	68 18 58 00 00       	push   $0x5818
    2ea0:	e8 5a 12 00 00       	call   40ff <unlink>
    2ea5:	83 c4 10             	add    $0x10,%esp
    2ea8:	85 c0                	test   %eax,%eax
    2eaa:	74 17                	je     2ec3 <dirfile+0x1a2>
    printf(1, "unlink dirfile failed!\n");
    2eac:	83 ec 08             	sub    $0x8,%esp
    2eaf:	68 db 58 00 00       	push   $0x58db
    2eb4:	6a 01                	push   $0x1
    2eb6:	e8 88 13 00 00       	call   4243 <printf>
    2ebb:	83 c4 10             	add    $0x10,%esp
    exit();
    2ebe:	e8 ec 11 00 00       	call   40af <exit>
  }

  fd = open(".", O_RDWR);
    2ec3:	83 ec 08             	sub    $0x8,%esp
    2ec6:	6a 02                	push   $0x2
    2ec8:	68 97 4e 00 00       	push   $0x4e97
    2ecd:	e8 1d 12 00 00       	call   40ef <open>
    2ed2:	83 c4 10             	add    $0x10,%esp
    2ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2edc:	78 17                	js     2ef5 <dirfile+0x1d4>
    printf(1, "open . for writing succeeded!\n");
    2ede:	83 ec 08             	sub    $0x8,%esp
    2ee1:	68 f4 58 00 00       	push   $0x58f4
    2ee6:	6a 01                	push   $0x1
    2ee8:	e8 56 13 00 00       	call   4243 <printf>
    2eed:	83 c4 10             	add    $0x10,%esp
    exit();
    2ef0:	e8 ba 11 00 00       	call   40af <exit>
  }
  fd = open(".", 0);
    2ef5:	83 ec 08             	sub    $0x8,%esp
    2ef8:	6a 00                	push   $0x0
    2efa:	68 97 4e 00 00       	push   $0x4e97
    2eff:	e8 eb 11 00 00       	call   40ef <open>
    2f04:	83 c4 10             	add    $0x10,%esp
    2f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2f0a:	83 ec 04             	sub    $0x4,%esp
    2f0d:	6a 01                	push   $0x1
    2f0f:	68 e3 4a 00 00       	push   $0x4ae3
    2f14:	ff 75 f4             	pushl  -0xc(%ebp)
    2f17:	e8 b3 11 00 00       	call   40cf <write>
    2f1c:	83 c4 10             	add    $0x10,%esp
    2f1f:	85 c0                	test   %eax,%eax
    2f21:	7e 17                	jle    2f3a <dirfile+0x219>
    printf(1, "write . succeeded!\n");
    2f23:	83 ec 08             	sub    $0x8,%esp
    2f26:	68 13 59 00 00       	push   $0x5913
    2f2b:	6a 01                	push   $0x1
    2f2d:	e8 11 13 00 00       	call   4243 <printf>
    2f32:	83 c4 10             	add    $0x10,%esp
    exit();
    2f35:	e8 75 11 00 00       	call   40af <exit>
  }
  close(fd);
    2f3a:	83 ec 0c             	sub    $0xc,%esp
    2f3d:	ff 75 f4             	pushl  -0xc(%ebp)
    2f40:	e8 92 11 00 00       	call   40d7 <close>
    2f45:	83 c4 10             	add    $0x10,%esp

  printf(1, "dir vs file OK\n");
    2f48:	83 ec 08             	sub    $0x8,%esp
    2f4b:	68 27 59 00 00       	push   $0x5927
    2f50:	6a 01                	push   $0x1
    2f52:	e8 ec 12 00 00       	call   4243 <printf>
    2f57:	83 c4 10             	add    $0x10,%esp
}
    2f5a:	90                   	nop
    2f5b:	c9                   	leave  
    2f5c:	c3                   	ret    

00002f5d <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2f5d:	f3 0f 1e fb          	endbr32 
    2f61:	55                   	push   %ebp
    2f62:	89 e5                	mov    %esp,%ebp
    2f64:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2f67:	83 ec 08             	sub    $0x8,%esp
    2f6a:	68 37 59 00 00       	push   $0x5937
    2f6f:	6a 01                	push   $0x1
    2f71:	e8 cd 12 00 00       	call   4243 <printf>
    2f76:	83 c4 10             	add    $0x10,%esp

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2f80:	e9 e7 00 00 00       	jmp    306c <iref+0x10f>
    if(mkdir("irefd") != 0){
    2f85:	83 ec 0c             	sub    $0xc,%esp
    2f88:	68 48 59 00 00       	push   $0x5948
    2f8d:	e8 85 11 00 00       	call   4117 <mkdir>
    2f92:	83 c4 10             	add    $0x10,%esp
    2f95:	85 c0                	test   %eax,%eax
    2f97:	74 17                	je     2fb0 <iref+0x53>
      printf(1, "mkdir irefd failed\n");
    2f99:	83 ec 08             	sub    $0x8,%esp
    2f9c:	68 4e 59 00 00       	push   $0x594e
    2fa1:	6a 01                	push   $0x1
    2fa3:	e8 9b 12 00 00       	call   4243 <printf>
    2fa8:	83 c4 10             	add    $0x10,%esp
      exit();
    2fab:	e8 ff 10 00 00       	call   40af <exit>
    }
    if(chdir("irefd") != 0){
    2fb0:	83 ec 0c             	sub    $0xc,%esp
    2fb3:	68 48 59 00 00       	push   $0x5948
    2fb8:	e8 62 11 00 00       	call   411f <chdir>
    2fbd:	83 c4 10             	add    $0x10,%esp
    2fc0:	85 c0                	test   %eax,%eax
    2fc2:	74 17                	je     2fdb <iref+0x7e>
      printf(1, "chdir irefd failed\n");
    2fc4:	83 ec 08             	sub    $0x8,%esp
    2fc7:	68 62 59 00 00       	push   $0x5962
    2fcc:	6a 01                	push   $0x1
    2fce:	e8 70 12 00 00       	call   4243 <printf>
    2fd3:	83 c4 10             	add    $0x10,%esp
      exit();
    2fd6:	e8 d4 10 00 00       	call   40af <exit>
    }

    mkdir("");
    2fdb:	83 ec 0c             	sub    $0xc,%esp
    2fde:	68 76 59 00 00       	push   $0x5976
    2fe3:	e8 2f 11 00 00       	call   4117 <mkdir>
    2fe8:	83 c4 10             	add    $0x10,%esp
    link("README", "");
    2feb:	83 ec 08             	sub    $0x8,%esp
    2fee:	68 76 59 00 00       	push   $0x5976
    2ff3:	68 b5 58 00 00       	push   $0x58b5
    2ff8:	e8 12 11 00 00       	call   410f <link>
    2ffd:	83 c4 10             	add    $0x10,%esp
    fd = open("", O_CREATE);
    3000:	83 ec 08             	sub    $0x8,%esp
    3003:	68 00 02 00 00       	push   $0x200
    3008:	68 76 59 00 00       	push   $0x5976
    300d:	e8 dd 10 00 00       	call   40ef <open>
    3012:	83 c4 10             	add    $0x10,%esp
    3015:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    3018:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    301c:	78 0e                	js     302c <iref+0xcf>
      close(fd);
    301e:	83 ec 0c             	sub    $0xc,%esp
    3021:	ff 75 f0             	pushl  -0x10(%ebp)
    3024:	e8 ae 10 00 00       	call   40d7 <close>
    3029:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    302c:	83 ec 08             	sub    $0x8,%esp
    302f:	68 00 02 00 00       	push   $0x200
    3034:	68 77 59 00 00       	push   $0x5977
    3039:	e8 b1 10 00 00       	call   40ef <open>
    303e:	83 c4 10             	add    $0x10,%esp
    3041:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    3044:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3048:	78 0e                	js     3058 <iref+0xfb>
      close(fd);
    304a:	83 ec 0c             	sub    $0xc,%esp
    304d:	ff 75 f0             	pushl  -0x10(%ebp)
    3050:	e8 82 10 00 00       	call   40d7 <close>
    3055:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    3058:	83 ec 0c             	sub    $0xc,%esp
    305b:	68 77 59 00 00       	push   $0x5977
    3060:	e8 9a 10 00 00       	call   40ff <unlink>
    3065:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 50 + 1; i++){
    3068:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    306c:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    3070:	0f 8e 0f ff ff ff    	jle    2f85 <iref+0x28>
  }

  chdir("/");
    3076:	83 ec 0c             	sub    $0xc,%esp
    3079:	68 7e 46 00 00       	push   $0x467e
    307e:	e8 9c 10 00 00       	call   411f <chdir>
    3083:	83 c4 10             	add    $0x10,%esp
  printf(1, "empty file name OK\n");
    3086:	83 ec 08             	sub    $0x8,%esp
    3089:	68 7a 59 00 00       	push   $0x597a
    308e:	6a 01                	push   $0x1
    3090:	e8 ae 11 00 00       	call   4243 <printf>
    3095:	83 c4 10             	add    $0x10,%esp
}
    3098:	90                   	nop
    3099:	c9                   	leave  
    309a:	c3                   	ret    

0000309b <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    309b:	f3 0f 1e fb          	endbr32 
    309f:	55                   	push   %ebp
    30a0:	89 e5                	mov    %esp,%ebp
    30a2:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
    30a5:	83 ec 08             	sub    $0x8,%esp
    30a8:	68 8e 59 00 00       	push   $0x598e
    30ad:	6a 01                	push   $0x1
    30af:	e8 8f 11 00 00       	call   4243 <printf>
    30b4:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    30b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    30be:	eb 1d                	jmp    30dd <forktest+0x42>
    pid = fork();
    30c0:	e8 e2 0f 00 00       	call   40a7 <fork>
    30c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    30c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    30cc:	78 1a                	js     30e8 <forktest+0x4d>
      break;
    if(pid == 0)
    30ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    30d2:	75 05                	jne    30d9 <forktest+0x3e>
      exit();
    30d4:	e8 d6 0f 00 00       	call   40af <exit>
  for(n=0; n<1000; n++){
    30d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    30dd:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    30e4:	7e da                	jle    30c0 <forktest+0x25>
    30e6:	eb 01                	jmp    30e9 <forktest+0x4e>
      break;
    30e8:	90                   	nop
  }

  if(n == 1000){
    30e9:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    30f0:	75 3b                	jne    312d <forktest+0x92>
    printf(1, "fork claimed to work 1000 times!\n");
    30f2:	83 ec 08             	sub    $0x8,%esp
    30f5:	68 9c 59 00 00       	push   $0x599c
    30fa:	6a 01                	push   $0x1
    30fc:	e8 42 11 00 00       	call   4243 <printf>
    3101:	83 c4 10             	add    $0x10,%esp
    exit();
    3104:	e8 a6 0f 00 00       	call   40af <exit>
  }

  for(; n > 0; n--){
    if(wait() < 0){
    3109:	e8 a9 0f 00 00       	call   40b7 <wait>
    310e:	85 c0                	test   %eax,%eax
    3110:	79 17                	jns    3129 <forktest+0x8e>
      printf(1, "wait stopped early\n");
    3112:	83 ec 08             	sub    $0x8,%esp
    3115:	68 be 59 00 00       	push   $0x59be
    311a:	6a 01                	push   $0x1
    311c:	e8 22 11 00 00       	call   4243 <printf>
    3121:	83 c4 10             	add    $0x10,%esp
      exit();
    3124:	e8 86 0f 00 00       	call   40af <exit>
  for(; n > 0; n--){
    3129:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    312d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3131:	7f d6                	jg     3109 <forktest+0x6e>
    }
  }

  if(wait() != -1){
    3133:	e8 7f 0f 00 00       	call   40b7 <wait>
    3138:	83 f8 ff             	cmp    $0xffffffff,%eax
    313b:	74 17                	je     3154 <forktest+0xb9>
    printf(1, "wait got too many\n");
    313d:	83 ec 08             	sub    $0x8,%esp
    3140:	68 d2 59 00 00       	push   $0x59d2
    3145:	6a 01                	push   $0x1
    3147:	e8 f7 10 00 00       	call   4243 <printf>
    314c:	83 c4 10             	add    $0x10,%esp
    exit();
    314f:	e8 5b 0f 00 00       	call   40af <exit>
  }

  printf(1, "fork test OK\n");
    3154:	83 ec 08             	sub    $0x8,%esp
    3157:	68 e5 59 00 00       	push   $0x59e5
    315c:	6a 01                	push   $0x1
    315e:	e8 e0 10 00 00       	call   4243 <printf>
    3163:	83 c4 10             	add    $0x10,%esp
}
    3166:	90                   	nop
    3167:	c9                   	leave  
    3168:	c3                   	ret    

00003169 <sbrktest>:

void
sbrktest(void)
{
    3169:	f3 0f 1e fb          	endbr32 
    316d:	55                   	push   %ebp
    316e:	89 e5                	mov    %esp,%ebp
    3170:	83 ec 68             	sub    $0x68,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    3173:	a1 60 65 00 00       	mov    0x6560,%eax
    3178:	83 ec 08             	sub    $0x8,%esp
    317b:	68 f3 59 00 00       	push   $0x59f3
    3180:	50                   	push   %eax
    3181:	e8 bd 10 00 00       	call   4243 <printf>
    3186:	83 c4 10             	add    $0x10,%esp
  oldbrk = sbrk(0);
    3189:	83 ec 0c             	sub    $0xc,%esp
    318c:	6a 00                	push   $0x0
    318e:	e8 a4 0f 00 00       	call   4137 <sbrk>
    3193:	83 c4 10             	add    $0x10,%esp
    3196:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    3199:	83 ec 0c             	sub    $0xc,%esp
    319c:	6a 00                	push   $0x0
    319e:	e8 94 0f 00 00       	call   4137 <sbrk>
    31a3:	83 c4 10             	add    $0x10,%esp
    31a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){
    31a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    31b0:	eb 4f                	jmp    3201 <sbrktest+0x98>
    b = sbrk(1);
    31b2:	83 ec 0c             	sub    $0xc,%esp
    31b5:	6a 01                	push   $0x1
    31b7:	e8 7b 0f 00 00       	call   4137 <sbrk>
    31bc:	83 c4 10             	add    $0x10,%esp
    31bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if(b != a){
    31c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
    31c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    31c8:	74 24                	je     31ee <sbrktest+0x85>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    31ca:	a1 60 65 00 00       	mov    0x6560,%eax
    31cf:	83 ec 0c             	sub    $0xc,%esp
    31d2:	ff 75 d0             	pushl  -0x30(%ebp)
    31d5:	ff 75 f4             	pushl  -0xc(%ebp)
    31d8:	ff 75 f0             	pushl  -0x10(%ebp)
    31db:	68 fe 59 00 00       	push   $0x59fe
    31e0:	50                   	push   %eax
    31e1:	e8 5d 10 00 00       	call   4243 <printf>
    31e6:	83 c4 20             	add    $0x20,%esp
      exit();
    31e9:	e8 c1 0e 00 00       	call   40af <exit>
    }
    *b = 1;
    31ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
    31f1:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    31f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
    31f7:	83 c0 01             	add    $0x1,%eax
    31fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; i < 5000; i++){
    31fd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3201:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    3208:	7e a8                	jle    31b2 <sbrktest+0x49>
  }
  pid = fork();
    320a:	e8 98 0e 00 00       	call   40a7 <fork>
    320f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
    3212:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3216:	79 1b                	jns    3233 <sbrktest+0xca>
    printf(stdout, "sbrk test fork failed\n");
    3218:	a1 60 65 00 00       	mov    0x6560,%eax
    321d:	83 ec 08             	sub    $0x8,%esp
    3220:	68 19 5a 00 00       	push   $0x5a19
    3225:	50                   	push   %eax
    3226:	e8 18 10 00 00       	call   4243 <printf>
    322b:	83 c4 10             	add    $0x10,%esp
    exit();
    322e:	e8 7c 0e 00 00       	call   40af <exit>
  }
  c = sbrk(1);
    3233:	83 ec 0c             	sub    $0xc,%esp
    3236:	6a 01                	push   $0x1
    3238:	e8 fa 0e 00 00       	call   4137 <sbrk>
    323d:	83 c4 10             	add    $0x10,%esp
    3240:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c = sbrk(1);
    3243:	83 ec 0c             	sub    $0xc,%esp
    3246:	6a 01                	push   $0x1
    3248:	e8 ea 0e 00 00       	call   4137 <sbrk>
    324d:	83 c4 10             	add    $0x10,%esp
    3250:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a + 1){
    3253:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3256:	83 c0 01             	add    $0x1,%eax
    3259:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    325c:	74 1b                	je     3279 <sbrktest+0x110>
    printf(stdout, "sbrk test failed post-fork\n");
    325e:	a1 60 65 00 00       	mov    0x6560,%eax
    3263:	83 ec 08             	sub    $0x8,%esp
    3266:	68 30 5a 00 00       	push   $0x5a30
    326b:	50                   	push   %eax
    326c:	e8 d2 0f 00 00       	call   4243 <printf>
    3271:	83 c4 10             	add    $0x10,%esp
    exit();
    3274:	e8 36 0e 00 00       	call   40af <exit>
  }
  if(pid == 0)
    3279:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    327d:	75 05                	jne    3284 <sbrktest+0x11b>
    exit();
    327f:	e8 2b 0e 00 00       	call   40af <exit>
  wait();
    3284:	e8 2e 0e 00 00       	call   40b7 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3289:	83 ec 0c             	sub    $0xc,%esp
    328c:	6a 00                	push   $0x0
    328e:	e8 a4 0e 00 00       	call   4137 <sbrk>
    3293:	83 c4 10             	add    $0x10,%esp
    3296:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    3299:	8b 45 f4             	mov    -0xc(%ebp),%eax
    329c:	ba 00 00 40 06       	mov    $0x6400000,%edx
    32a1:	29 c2                	sub    %eax,%edx
    32a3:	89 d0                	mov    %edx,%eax
    32a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  p = sbrk(amt);
    32a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    32ab:	83 ec 0c             	sub    $0xc,%esp
    32ae:	50                   	push   %eax
    32af:	e8 83 0e 00 00       	call   4137 <sbrk>
    32b4:	83 c4 10             	add    $0x10,%esp
    32b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (p != a) {
    32ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
    32bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    32c0:	74 1b                	je     32dd <sbrktest+0x174>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    32c2:	a1 60 65 00 00       	mov    0x6560,%eax
    32c7:	83 ec 08             	sub    $0x8,%esp
    32ca:	68 4c 5a 00 00       	push   $0x5a4c
    32cf:	50                   	push   %eax
    32d0:	e8 6e 0f 00 00       	call   4243 <printf>
    32d5:	83 c4 10             	add    $0x10,%esp
    exit();
    32d8:	e8 d2 0d 00 00       	call   40af <exit>
  }
  lastaddr = (char*) (BIG-1);
    32dd:	c7 45 d8 ff ff 3f 06 	movl   $0x63fffff,-0x28(%ebp)
  *lastaddr = 99;
    32e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
    32e7:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    32ea:	83 ec 0c             	sub    $0xc,%esp
    32ed:	6a 00                	push   $0x0
    32ef:	e8 43 0e 00 00       	call   4137 <sbrk>
    32f4:	83 c4 10             	add    $0x10,%esp
    32f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    32fa:	83 ec 0c             	sub    $0xc,%esp
    32fd:	68 00 f0 ff ff       	push   $0xfffff000
    3302:	e8 30 0e 00 00       	call   4137 <sbrk>
    3307:	83 c4 10             	add    $0x10,%esp
    330a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c == (char*)0xffffffff){
    330d:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
    3311:	75 1b                	jne    332e <sbrktest+0x1c5>
    printf(stdout, "sbrk could not deallocate\n");
    3313:	a1 60 65 00 00       	mov    0x6560,%eax
    3318:	83 ec 08             	sub    $0x8,%esp
    331b:	68 8a 5a 00 00       	push   $0x5a8a
    3320:	50                   	push   %eax
    3321:	e8 1d 0f 00 00       	call   4243 <printf>
    3326:	83 c4 10             	add    $0x10,%esp
    exit();
    3329:	e8 81 0d 00 00       	call   40af <exit>
  }
  c = sbrk(0);
    332e:	83 ec 0c             	sub    $0xc,%esp
    3331:	6a 00                	push   $0x0
    3333:	e8 ff 0d 00 00       	call   4137 <sbrk>
    3338:	83 c4 10             	add    $0x10,%esp
    333b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a - 4096){
    333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3341:	2d 00 10 00 00       	sub    $0x1000,%eax
    3346:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    3349:	74 1e                	je     3369 <sbrktest+0x200>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    334b:	a1 60 65 00 00       	mov    0x6560,%eax
    3350:	ff 75 e4             	pushl  -0x1c(%ebp)
    3353:	ff 75 f4             	pushl  -0xc(%ebp)
    3356:	68 a8 5a 00 00       	push   $0x5aa8
    335b:	50                   	push   %eax
    335c:	e8 e2 0e 00 00       	call   4243 <printf>
    3361:	83 c4 10             	add    $0x10,%esp
    exit();
    3364:	e8 46 0d 00 00       	call   40af <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3369:	83 ec 0c             	sub    $0xc,%esp
    336c:	6a 00                	push   $0x0
    336e:	e8 c4 0d 00 00       	call   4137 <sbrk>
    3373:	83 c4 10             	add    $0x10,%esp
    3376:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    3379:	83 ec 0c             	sub    $0xc,%esp
    337c:	68 00 10 00 00       	push   $0x1000
    3381:	e8 b1 0d 00 00       	call   4137 <sbrk>
    3386:	83 c4 10             	add    $0x10,%esp
    3389:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    338c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    338f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3392:	75 1a                	jne    33ae <sbrktest+0x245>
    3394:	83 ec 0c             	sub    $0xc,%esp
    3397:	6a 00                	push   $0x0
    3399:	e8 99 0d 00 00       	call   4137 <sbrk>
    339e:	83 c4 10             	add    $0x10,%esp
    33a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    33a4:	81 c2 00 10 00 00    	add    $0x1000,%edx
    33aa:	39 d0                	cmp    %edx,%eax
    33ac:	74 1e                	je     33cc <sbrktest+0x263>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    33ae:	a1 60 65 00 00       	mov    0x6560,%eax
    33b3:	ff 75 e4             	pushl  -0x1c(%ebp)
    33b6:	ff 75 f4             	pushl  -0xc(%ebp)
    33b9:	68 e0 5a 00 00       	push   $0x5ae0
    33be:	50                   	push   %eax
    33bf:	e8 7f 0e 00 00       	call   4243 <printf>
    33c4:	83 c4 10             	add    $0x10,%esp
    exit();
    33c7:	e8 e3 0c 00 00       	call   40af <exit>
  }
  if(*lastaddr == 99){
    33cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
    33cf:	0f b6 00             	movzbl (%eax),%eax
    33d2:	3c 63                	cmp    $0x63,%al
    33d4:	75 1b                	jne    33f1 <sbrktest+0x288>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    33d6:	a1 60 65 00 00       	mov    0x6560,%eax
    33db:	83 ec 08             	sub    $0x8,%esp
    33de:	68 08 5b 00 00       	push   $0x5b08
    33e3:	50                   	push   %eax
    33e4:	e8 5a 0e 00 00       	call   4243 <printf>
    33e9:	83 c4 10             	add    $0x10,%esp
    exit();
    33ec:	e8 be 0c 00 00       	call   40af <exit>
  }

  a = sbrk(0);
    33f1:	83 ec 0c             	sub    $0xc,%esp
    33f4:	6a 00                	push   $0x0
    33f6:	e8 3c 0d 00 00       	call   4137 <sbrk>
    33fb:	83 c4 10             	add    $0x10,%esp
    33fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    3401:	83 ec 0c             	sub    $0xc,%esp
    3404:	6a 00                	push   $0x0
    3406:	e8 2c 0d 00 00       	call   4137 <sbrk>
    340b:	83 c4 10             	add    $0x10,%esp
    340e:	8b 55 ec             	mov    -0x14(%ebp),%edx
    3411:	29 c2                	sub    %eax,%edx
    3413:	89 d0                	mov    %edx,%eax
    3415:	83 ec 0c             	sub    $0xc,%esp
    3418:	50                   	push   %eax
    3419:	e8 19 0d 00 00       	call   4137 <sbrk>
    341e:	83 c4 10             	add    $0x10,%esp
    3421:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a){
    3424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3427:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    342a:	74 1e                	je     344a <sbrktest+0x2e1>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    342c:	a1 60 65 00 00       	mov    0x6560,%eax
    3431:	ff 75 e4             	pushl  -0x1c(%ebp)
    3434:	ff 75 f4             	pushl  -0xc(%ebp)
    3437:	68 38 5b 00 00       	push   $0x5b38
    343c:	50                   	push   %eax
    343d:	e8 01 0e 00 00       	call   4243 <printf>
    3442:	83 c4 10             	add    $0x10,%esp
    exit();
    3445:	e8 65 0c 00 00       	call   40af <exit>
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    344a:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    3451:	eb 76                	jmp    34c9 <sbrktest+0x360>
    ppid = getpid();
    3453:	e8 d7 0c 00 00       	call   412f <getpid>
    3458:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    pid = fork();
    345b:	e8 47 0c 00 00       	call   40a7 <fork>
    3460:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    3463:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3467:	79 1b                	jns    3484 <sbrktest+0x31b>
      printf(stdout, "fork failed\n");
    3469:	a1 60 65 00 00       	mov    0x6560,%eax
    346e:	83 ec 08             	sub    $0x8,%esp
    3471:	68 ad 46 00 00       	push   $0x46ad
    3476:	50                   	push   %eax
    3477:	e8 c7 0d 00 00       	call   4243 <printf>
    347c:	83 c4 10             	add    $0x10,%esp
      exit();
    347f:	e8 2b 0c 00 00       	call   40af <exit>
    }
    if(pid == 0){
    3484:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3488:	75 33                	jne    34bd <sbrktest+0x354>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    348d:	0f b6 00             	movzbl (%eax),%eax
    3490:	0f be d0             	movsbl %al,%edx
    3493:	a1 60 65 00 00       	mov    0x6560,%eax
    3498:	52                   	push   %edx
    3499:	ff 75 f4             	pushl  -0xc(%ebp)
    349c:	68 59 5b 00 00       	push   $0x5b59
    34a1:	50                   	push   %eax
    34a2:	e8 9c 0d 00 00       	call   4243 <printf>
    34a7:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
    34aa:	83 ec 0c             	sub    $0xc,%esp
    34ad:	ff 75 d4             	pushl  -0x2c(%ebp)
    34b0:	e8 2a 0c 00 00       	call   40df <kill>
    34b5:	83 c4 10             	add    $0x10,%esp
      exit();
    34b8:	e8 f2 0b 00 00       	call   40af <exit>
    }
    wait();
    34bd:	e8 f5 0b 00 00       	call   40b7 <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    34c2:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    34c9:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    34d0:	76 81                	jbe    3453 <sbrktest+0x2ea>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    34d2:	83 ec 0c             	sub    $0xc,%esp
    34d5:	8d 45 c8             	lea    -0x38(%ebp),%eax
    34d8:	50                   	push   %eax
    34d9:	e8 e1 0b 00 00       	call   40bf <pipe>
    34de:	83 c4 10             	add    $0x10,%esp
    34e1:	85 c0                	test   %eax,%eax
    34e3:	74 17                	je     34fc <sbrktest+0x393>
    printf(1, "pipe() failed\n");
    34e5:	83 ec 08             	sub    $0x8,%esp
    34e8:	68 7e 4a 00 00       	push   $0x4a7e
    34ed:	6a 01                	push   $0x1
    34ef:	e8 4f 0d 00 00       	call   4243 <printf>
    34f4:	83 c4 10             	add    $0x10,%esp
    exit();
    34f7:	e8 b3 0b 00 00       	call   40af <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3503:	e9 86 00 00 00       	jmp    358e <sbrktest+0x425>
    if((pids[i] = fork()) == 0){
    3508:	e8 9a 0b 00 00       	call   40a7 <fork>
    350d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3510:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    3514:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3517:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    351b:	85 c0                	test   %eax,%eax
    351d:	75 4a                	jne    3569 <sbrktest+0x400>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    351f:	83 ec 0c             	sub    $0xc,%esp
    3522:	6a 00                	push   $0x0
    3524:	e8 0e 0c 00 00       	call   4137 <sbrk>
    3529:	83 c4 10             	add    $0x10,%esp
    352c:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3531:	29 c2                	sub    %eax,%edx
    3533:	89 d0                	mov    %edx,%eax
    3535:	83 ec 0c             	sub    $0xc,%esp
    3538:	50                   	push   %eax
    3539:	e8 f9 0b 00 00       	call   4137 <sbrk>
    353e:	83 c4 10             	add    $0x10,%esp
      write(fds[1], "x", 1);
    3541:	8b 45 cc             	mov    -0x34(%ebp),%eax
    3544:	83 ec 04             	sub    $0x4,%esp
    3547:	6a 01                	push   $0x1
    3549:	68 e3 4a 00 00       	push   $0x4ae3
    354e:	50                   	push   %eax
    354f:	e8 7b 0b 00 00       	call   40cf <write>
    3554:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    3557:	83 ec 0c             	sub    $0xc,%esp
    355a:	68 e8 03 00 00       	push   $0x3e8
    355f:	e8 db 0b 00 00       	call   413f <sleep>
    3564:	83 c4 10             	add    $0x10,%esp
    3567:	eb ee                	jmp    3557 <sbrktest+0x3ee>
    }
    if(pids[i] != -1)
    3569:	8b 45 f0             	mov    -0x10(%ebp),%eax
    356c:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3570:	83 f8 ff             	cmp    $0xffffffff,%eax
    3573:	74 15                	je     358a <sbrktest+0x421>
      read(fds[0], &scratch, 1);
    3575:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3578:	83 ec 04             	sub    $0x4,%esp
    357b:	6a 01                	push   $0x1
    357d:	8d 55 9f             	lea    -0x61(%ebp),%edx
    3580:	52                   	push   %edx
    3581:	50                   	push   %eax
    3582:	e8 40 0b 00 00       	call   40c7 <read>
    3587:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    358a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    358e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3591:	83 f8 09             	cmp    $0x9,%eax
    3594:	0f 86 6e ff ff ff    	jbe    3508 <sbrktest+0x39f>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    359a:	83 ec 0c             	sub    $0xc,%esp
    359d:	68 00 10 00 00       	push   $0x1000
    35a2:	e8 90 0b 00 00       	call   4137 <sbrk>
    35a7:	83 c4 10             	add    $0x10,%esp
    35aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    35ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    35b4:	eb 2b                	jmp    35e1 <sbrktest+0x478>
    if(pids[i] == -1)
    35b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    35b9:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    35bd:	83 f8 ff             	cmp    $0xffffffff,%eax
    35c0:	74 1a                	je     35dc <sbrktest+0x473>
      continue;
    kill(pids[i]);
    35c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    35c5:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    35c9:	83 ec 0c             	sub    $0xc,%esp
    35cc:	50                   	push   %eax
    35cd:	e8 0d 0b 00 00       	call   40df <kill>
    35d2:	83 c4 10             	add    $0x10,%esp
    wait();
    35d5:	e8 dd 0a 00 00       	call   40b7 <wait>
    35da:	eb 01                	jmp    35dd <sbrktest+0x474>
      continue;
    35dc:	90                   	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    35dd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    35e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    35e4:	83 f8 09             	cmp    $0x9,%eax
    35e7:	76 cd                	jbe    35b6 <sbrktest+0x44d>
  }
  if(c == (char*)0xffffffff){
    35e9:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
    35ed:	75 1b                	jne    360a <sbrktest+0x4a1>
    printf(stdout, "failed sbrk leaked memory\n");
    35ef:	a1 60 65 00 00       	mov    0x6560,%eax
    35f4:	83 ec 08             	sub    $0x8,%esp
    35f7:	68 72 5b 00 00       	push   $0x5b72
    35fc:	50                   	push   %eax
    35fd:	e8 41 0c 00 00       	call   4243 <printf>
    3602:	83 c4 10             	add    $0x10,%esp
    exit();
    3605:	e8 a5 0a 00 00       	call   40af <exit>
  }

  if(sbrk(0) > oldbrk)
    360a:	83 ec 0c             	sub    $0xc,%esp
    360d:	6a 00                	push   $0x0
    360f:	e8 23 0b 00 00       	call   4137 <sbrk>
    3614:	83 c4 10             	add    $0x10,%esp
    3617:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    361a:	73 20                	jae    363c <sbrktest+0x4d3>
    sbrk(-(sbrk(0) - oldbrk));
    361c:	83 ec 0c             	sub    $0xc,%esp
    361f:	6a 00                	push   $0x0
    3621:	e8 11 0b 00 00       	call   4137 <sbrk>
    3626:	83 c4 10             	add    $0x10,%esp
    3629:	8b 55 ec             	mov    -0x14(%ebp),%edx
    362c:	29 c2                	sub    %eax,%edx
    362e:	89 d0                	mov    %edx,%eax
    3630:	83 ec 0c             	sub    $0xc,%esp
    3633:	50                   	push   %eax
    3634:	e8 fe 0a 00 00       	call   4137 <sbrk>
    3639:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    363c:	a1 60 65 00 00       	mov    0x6560,%eax
    3641:	83 ec 08             	sub    $0x8,%esp
    3644:	68 8d 5b 00 00       	push   $0x5b8d
    3649:	50                   	push   %eax
    364a:	e8 f4 0b 00 00       	call   4243 <printf>
    364f:	83 c4 10             	add    $0x10,%esp
}
    3652:	90                   	nop
    3653:	c9                   	leave  
    3654:	c3                   	ret    

00003655 <validateint>:

void
validateint(int *p)
{
    3655:	f3 0f 1e fb          	endbr32 
    3659:	55                   	push   %ebp
    365a:	89 e5                	mov    %esp,%ebp
    365c:	53                   	push   %ebx
    365d:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    3660:	b8 0d 00 00 00       	mov    $0xd,%eax
    3665:	8b 55 08             	mov    0x8(%ebp),%edx
    3668:	89 d1                	mov    %edx,%ecx
    366a:	89 e3                	mov    %esp,%ebx
    366c:	89 cc                	mov    %ecx,%esp
    366e:	cd 40                	int    $0x40
    3670:	89 dc                	mov    %ebx,%esp
    3672:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3675:	90                   	nop
    3676:	83 c4 10             	add    $0x10,%esp
    3679:	5b                   	pop    %ebx
    367a:	5d                   	pop    %ebp
    367b:	c3                   	ret    

0000367c <validatetest>:

void
validatetest(void)
{
    367c:	f3 0f 1e fb          	endbr32 
    3680:	55                   	push   %ebp
    3681:	89 e5                	mov    %esp,%ebp
    3683:	83 ec 18             	sub    $0x18,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3686:	a1 60 65 00 00       	mov    0x6560,%eax
    368b:	83 ec 08             	sub    $0x8,%esp
    368e:	68 9b 5b 00 00       	push   $0x5b9b
    3693:	50                   	push   %eax
    3694:	e8 aa 0b 00 00       	call   4243 <printf>
    3699:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
    369c:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    36a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    36aa:	e9 8a 00 00 00       	jmp    3739 <validatetest+0xbd>
    if((pid = fork()) == 0){
    36af:	e8 f3 09 00 00       	call   40a7 <fork>
    36b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    36b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    36bb:	75 14                	jne    36d1 <validatetest+0x55>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    36bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36c0:	83 ec 0c             	sub    $0xc,%esp
    36c3:	50                   	push   %eax
    36c4:	e8 8c ff ff ff       	call   3655 <validateint>
    36c9:	83 c4 10             	add    $0x10,%esp
      exit();
    36cc:	e8 de 09 00 00       	call   40af <exit>
    }
    sleep(0);
    36d1:	83 ec 0c             	sub    $0xc,%esp
    36d4:	6a 00                	push   $0x0
    36d6:	e8 64 0a 00 00       	call   413f <sleep>
    36db:	83 c4 10             	add    $0x10,%esp
    sleep(0);
    36de:	83 ec 0c             	sub    $0xc,%esp
    36e1:	6a 00                	push   $0x0
    36e3:	e8 57 0a 00 00       	call   413f <sleep>
    36e8:	83 c4 10             	add    $0x10,%esp
    kill(pid);
    36eb:	83 ec 0c             	sub    $0xc,%esp
    36ee:	ff 75 ec             	pushl  -0x14(%ebp)
    36f1:	e8 e9 09 00 00       	call   40df <kill>
    36f6:	83 c4 10             	add    $0x10,%esp
    wait();
    36f9:	e8 b9 09 00 00       	call   40b7 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    36fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3701:	83 ec 08             	sub    $0x8,%esp
    3704:	50                   	push   %eax
    3705:	68 aa 5b 00 00       	push   $0x5baa
    370a:	e8 00 0a 00 00       	call   410f <link>
    370f:	83 c4 10             	add    $0x10,%esp
    3712:	83 f8 ff             	cmp    $0xffffffff,%eax
    3715:	74 1b                	je     3732 <validatetest+0xb6>
      printf(stdout, "link should not succeed\n");
    3717:	a1 60 65 00 00       	mov    0x6560,%eax
    371c:	83 ec 08             	sub    $0x8,%esp
    371f:	68 b5 5b 00 00       	push   $0x5bb5
    3724:	50                   	push   %eax
    3725:	e8 19 0b 00 00       	call   4243 <printf>
    372a:	83 c4 10             	add    $0x10,%esp
      exit();
    372d:	e8 7d 09 00 00       	call   40af <exit>
  for(p = 0; p <= (uint)hi; p += 4096){
    3732:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    3739:	8b 45 f0             	mov    -0x10(%ebp),%eax
    373c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    373f:	0f 86 6a ff ff ff    	jbe    36af <validatetest+0x33>
    }
  }

  printf(stdout, "validate ok\n");
    3745:	a1 60 65 00 00       	mov    0x6560,%eax
    374a:	83 ec 08             	sub    $0x8,%esp
    374d:	68 ce 5b 00 00       	push   $0x5bce
    3752:	50                   	push   %eax
    3753:	e8 eb 0a 00 00       	call   4243 <printf>
    3758:	83 c4 10             	add    $0x10,%esp
}
    375b:	90                   	nop
    375c:	c9                   	leave  
    375d:	c3                   	ret    

0000375e <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    375e:	f3 0f 1e fb          	endbr32 
    3762:	55                   	push   %ebp
    3763:	89 e5                	mov    %esp,%ebp
    3765:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
    3768:	a1 60 65 00 00       	mov    0x6560,%eax
    376d:	83 ec 08             	sub    $0x8,%esp
    3770:	68 db 5b 00 00       	push   $0x5bdb
    3775:	50                   	push   %eax
    3776:	e8 c8 0a 00 00       	call   4243 <printf>
    377b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    377e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3785:	eb 2e                	jmp    37b5 <bsstest+0x57>
    if(uninit[i] != '\0'){
    3787:	8b 45 f4             	mov    -0xc(%ebp),%eax
    378a:	05 20 66 00 00       	add    $0x6620,%eax
    378f:	0f b6 00             	movzbl (%eax),%eax
    3792:	84 c0                	test   %al,%al
    3794:	74 1b                	je     37b1 <bsstest+0x53>
      printf(stdout, "bss test failed\n");
    3796:	a1 60 65 00 00       	mov    0x6560,%eax
    379b:	83 ec 08             	sub    $0x8,%esp
    379e:	68 e5 5b 00 00       	push   $0x5be5
    37a3:	50                   	push   %eax
    37a4:	e8 9a 0a 00 00       	call   4243 <printf>
    37a9:	83 c4 10             	add    $0x10,%esp
      exit();
    37ac:	e8 fe 08 00 00       	call   40af <exit>
  for(i = 0; i < sizeof(uninit); i++){
    37b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    37b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    37b8:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    37bd:	76 c8                	jbe    3787 <bsstest+0x29>
    }
  }
  printf(stdout, "bss test ok\n");
    37bf:	a1 60 65 00 00       	mov    0x6560,%eax
    37c4:	83 ec 08             	sub    $0x8,%esp
    37c7:	68 f6 5b 00 00       	push   $0x5bf6
    37cc:	50                   	push   %eax
    37cd:	e8 71 0a 00 00       	call   4243 <printf>
    37d2:	83 c4 10             	add    $0x10,%esp
}
    37d5:	90                   	nop
    37d6:	c9                   	leave  
    37d7:	c3                   	ret    

000037d8 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    37d8:	f3 0f 1e fb          	endbr32 
    37dc:	55                   	push   %ebp
    37dd:	89 e5                	mov    %esp,%ebp
    37df:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
    37e2:	83 ec 0c             	sub    $0xc,%esp
    37e5:	68 03 5c 00 00       	push   $0x5c03
    37ea:	e8 10 09 00 00       	call   40ff <unlink>
    37ef:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    37f2:	e8 b0 08 00 00       	call   40a7 <fork>
    37f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    37fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    37fe:	0f 85 97 00 00 00    	jne    389b <bigargtest+0xc3>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    380b:	eb 12                	jmp    381f <bigargtest+0x47>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    380d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3810:	c7 04 85 80 65 00 00 	movl   $0x5c10,0x6580(,%eax,4)
    3817:	10 5c 00 00 
    for(i = 0; i < MAXARG-1; i++)
    381b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    381f:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    3823:	7e e8                	jle    380d <bigargtest+0x35>
    args[MAXARG-1] = 0;
    3825:	c7 05 fc 65 00 00 00 	movl   $0x0,0x65fc
    382c:	00 00 00 
    printf(stdout, "bigarg test\n");
    382f:	a1 60 65 00 00       	mov    0x6560,%eax
    3834:	83 ec 08             	sub    $0x8,%esp
    3837:	68 ed 5c 00 00       	push   $0x5ced
    383c:	50                   	push   %eax
    383d:	e8 01 0a 00 00       	call   4243 <printf>
    3842:	83 c4 10             	add    $0x10,%esp
    exec("echo", args);
    3845:	83 ec 08             	sub    $0x8,%esp
    3848:	68 80 65 00 00       	push   $0x6580
    384d:	68 0c 46 00 00       	push   $0x460c
    3852:	e8 90 08 00 00       	call   40e7 <exec>
    3857:	83 c4 10             	add    $0x10,%esp
    printf(stdout, "bigarg test ok\n");
    385a:	a1 60 65 00 00       	mov    0x6560,%eax
    385f:	83 ec 08             	sub    $0x8,%esp
    3862:	68 fa 5c 00 00       	push   $0x5cfa
    3867:	50                   	push   %eax
    3868:	e8 d6 09 00 00       	call   4243 <printf>
    386d:	83 c4 10             	add    $0x10,%esp
    fd = open("bigarg-ok", O_CREATE);
    3870:	83 ec 08             	sub    $0x8,%esp
    3873:	68 00 02 00 00       	push   $0x200
    3878:	68 03 5c 00 00       	push   $0x5c03
    387d:	e8 6d 08 00 00       	call   40ef <open>
    3882:	83 c4 10             	add    $0x10,%esp
    3885:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    3888:	83 ec 0c             	sub    $0xc,%esp
    388b:	ff 75 ec             	pushl  -0x14(%ebp)
    388e:	e8 44 08 00 00       	call   40d7 <close>
    3893:	83 c4 10             	add    $0x10,%esp
    exit();
    3896:	e8 14 08 00 00       	call   40af <exit>
  } else if(pid < 0){
    389b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    389f:	79 1b                	jns    38bc <bigargtest+0xe4>
    printf(stdout, "bigargtest: fork failed\n");
    38a1:	a1 60 65 00 00       	mov    0x6560,%eax
    38a6:	83 ec 08             	sub    $0x8,%esp
    38a9:	68 0a 5d 00 00       	push   $0x5d0a
    38ae:	50                   	push   %eax
    38af:	e8 8f 09 00 00       	call   4243 <printf>
    38b4:	83 c4 10             	add    $0x10,%esp
    exit();
    38b7:	e8 f3 07 00 00       	call   40af <exit>
  }
  wait();
    38bc:	e8 f6 07 00 00       	call   40b7 <wait>
  fd = open("bigarg-ok", 0);
    38c1:	83 ec 08             	sub    $0x8,%esp
    38c4:	6a 00                	push   $0x0
    38c6:	68 03 5c 00 00       	push   $0x5c03
    38cb:	e8 1f 08 00 00       	call   40ef <open>
    38d0:	83 c4 10             	add    $0x10,%esp
    38d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    38d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    38da:	79 1b                	jns    38f7 <bigargtest+0x11f>
    printf(stdout, "bigarg test failed!\n");
    38dc:	a1 60 65 00 00       	mov    0x6560,%eax
    38e1:	83 ec 08             	sub    $0x8,%esp
    38e4:	68 23 5d 00 00       	push   $0x5d23
    38e9:	50                   	push   %eax
    38ea:	e8 54 09 00 00       	call   4243 <printf>
    38ef:	83 c4 10             	add    $0x10,%esp
    exit();
    38f2:	e8 b8 07 00 00       	call   40af <exit>
  }
  close(fd);
    38f7:	83 ec 0c             	sub    $0xc,%esp
    38fa:	ff 75 ec             	pushl  -0x14(%ebp)
    38fd:	e8 d5 07 00 00       	call   40d7 <close>
    3902:	83 c4 10             	add    $0x10,%esp
  unlink("bigarg-ok");
    3905:	83 ec 0c             	sub    $0xc,%esp
    3908:	68 03 5c 00 00       	push   $0x5c03
    390d:	e8 ed 07 00 00       	call   40ff <unlink>
    3912:	83 c4 10             	add    $0x10,%esp
}
    3915:	90                   	nop
    3916:	c9                   	leave  
    3917:	c3                   	ret    

00003918 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3918:	f3 0f 1e fb          	endbr32 
    391c:	55                   	push   %ebp
    391d:	89 e5                	mov    %esp,%ebp
    391f:	53                   	push   %ebx
    3920:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;
    3923:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    392a:	83 ec 08             	sub    $0x8,%esp
    392d:	68 38 5d 00 00       	push   $0x5d38
    3932:	6a 01                	push   $0x1
    3934:	e8 0a 09 00 00       	call   4243 <printf>
    3939:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    393c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    3943:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3947:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    394a:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    394f:	89 c8                	mov    %ecx,%eax
    3951:	f7 ea                	imul   %edx
    3953:	c1 fa 06             	sar    $0x6,%edx
    3956:	89 c8                	mov    %ecx,%eax
    3958:	c1 f8 1f             	sar    $0x1f,%eax
    395b:	29 c2                	sub    %eax,%edx
    395d:	89 d0                	mov    %edx,%eax
    395f:	83 c0 30             	add    $0x30,%eax
    3962:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3965:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3968:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    396d:	89 d8                	mov    %ebx,%eax
    396f:	f7 ea                	imul   %edx
    3971:	c1 fa 06             	sar    $0x6,%edx
    3974:	89 d8                	mov    %ebx,%eax
    3976:	c1 f8 1f             	sar    $0x1f,%eax
    3979:	89 d1                	mov    %edx,%ecx
    397b:	29 c1                	sub    %eax,%ecx
    397d:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3983:	29 c3                	sub    %eax,%ebx
    3985:	89 d9                	mov    %ebx,%ecx
    3987:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    398c:	89 c8                	mov    %ecx,%eax
    398e:	f7 ea                	imul   %edx
    3990:	c1 fa 05             	sar    $0x5,%edx
    3993:	89 c8                	mov    %ecx,%eax
    3995:	c1 f8 1f             	sar    $0x1f,%eax
    3998:	29 c2                	sub    %eax,%edx
    399a:	89 d0                	mov    %edx,%eax
    399c:	83 c0 30             	add    $0x30,%eax
    399f:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    39a2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    39a5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    39aa:	89 d8                	mov    %ebx,%eax
    39ac:	f7 ea                	imul   %edx
    39ae:	c1 fa 05             	sar    $0x5,%edx
    39b1:	89 d8                	mov    %ebx,%eax
    39b3:	c1 f8 1f             	sar    $0x1f,%eax
    39b6:	89 d1                	mov    %edx,%ecx
    39b8:	29 c1                	sub    %eax,%ecx
    39ba:	6b c1 64             	imul   $0x64,%ecx,%eax
    39bd:	29 c3                	sub    %eax,%ebx
    39bf:	89 d9                	mov    %ebx,%ecx
    39c1:	ba 67 66 66 66       	mov    $0x66666667,%edx
    39c6:	89 c8                	mov    %ecx,%eax
    39c8:	f7 ea                	imul   %edx
    39ca:	c1 fa 02             	sar    $0x2,%edx
    39cd:	89 c8                	mov    %ecx,%eax
    39cf:	c1 f8 1f             	sar    $0x1f,%eax
    39d2:	29 c2                	sub    %eax,%edx
    39d4:	89 d0                	mov    %edx,%eax
    39d6:	83 c0 30             	add    $0x30,%eax
    39d9:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    39dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    39df:	ba 67 66 66 66       	mov    $0x66666667,%edx
    39e4:	89 c8                	mov    %ecx,%eax
    39e6:	f7 ea                	imul   %edx
    39e8:	c1 fa 02             	sar    $0x2,%edx
    39eb:	89 c8                	mov    %ecx,%eax
    39ed:	c1 f8 1f             	sar    $0x1f,%eax
    39f0:	29 c2                	sub    %eax,%edx
    39f2:	89 d0                	mov    %edx,%eax
    39f4:	c1 e0 02             	shl    $0x2,%eax
    39f7:	01 d0                	add    %edx,%eax
    39f9:	01 c0                	add    %eax,%eax
    39fb:	29 c1                	sub    %eax,%ecx
    39fd:	89 ca                	mov    %ecx,%edx
    39ff:	89 d0                	mov    %edx,%eax
    3a01:	83 c0 30             	add    $0x30,%eax
    3a04:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3a07:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3a0b:	83 ec 04             	sub    $0x4,%esp
    3a0e:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3a11:	50                   	push   %eax
    3a12:	68 45 5d 00 00       	push   $0x5d45
    3a17:	6a 01                	push   $0x1
    3a19:	e8 25 08 00 00       	call   4243 <printf>
    3a1e:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    3a21:	83 ec 08             	sub    $0x8,%esp
    3a24:	68 02 02 00 00       	push   $0x202
    3a29:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3a2c:	50                   	push   %eax
    3a2d:	e8 bd 06 00 00       	call   40ef <open>
    3a32:	83 c4 10             	add    $0x10,%esp
    3a35:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    3a38:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3a3c:	79 18                	jns    3a56 <fsfull+0x13e>
      printf(1, "open %s failed\n", name);
    3a3e:	83 ec 04             	sub    $0x4,%esp
    3a41:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3a44:	50                   	push   %eax
    3a45:	68 51 5d 00 00       	push   $0x5d51
    3a4a:	6a 01                	push   $0x1
    3a4c:	e8 f2 07 00 00       	call   4243 <printf>
    3a51:	83 c4 10             	add    $0x10,%esp
      break;
    3a54:	eb 6b                	jmp    3ac1 <fsfull+0x1a9>
    }
    int total = 0;
    3a56:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    3a5d:	83 ec 04             	sub    $0x4,%esp
    3a60:	68 00 02 00 00       	push   $0x200
    3a65:	68 40 8d 00 00       	push   $0x8d40
    3a6a:	ff 75 e8             	pushl  -0x18(%ebp)
    3a6d:	e8 5d 06 00 00       	call   40cf <write>
    3a72:	83 c4 10             	add    $0x10,%esp
    3a75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    3a78:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    3a7f:	7e 0c                	jle    3a8d <fsfull+0x175>
        break;
      total += cc;
    3a81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3a84:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3a87:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while(1){
    3a8b:	eb d0                	jmp    3a5d <fsfull+0x145>
        break;
    3a8d:	90                   	nop
    }
    printf(1, "wrote %d bytes\n", total);
    3a8e:	83 ec 04             	sub    $0x4,%esp
    3a91:	ff 75 ec             	pushl  -0x14(%ebp)
    3a94:	68 61 5d 00 00       	push   $0x5d61
    3a99:	6a 01                	push   $0x1
    3a9b:	e8 a3 07 00 00       	call   4243 <printf>
    3aa0:	83 c4 10             	add    $0x10,%esp
    close(fd);
    3aa3:	83 ec 0c             	sub    $0xc,%esp
    3aa6:	ff 75 e8             	pushl  -0x18(%ebp)
    3aa9:	e8 29 06 00 00       	call   40d7 <close>
    3aae:	83 c4 10             	add    $0x10,%esp
    if(total == 0)
    3ab1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3ab5:	74 09                	je     3ac0 <fsfull+0x1a8>
  for(nfiles = 0; ; nfiles++){
    3ab7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3abb:	e9 83 fe ff ff       	jmp    3943 <fsfull+0x2b>
      break;
    3ac0:	90                   	nop
  }

  while(nfiles >= 0){
    3ac1:	e9 db 00 00 00       	jmp    3ba1 <fsfull+0x289>
    char name[64];
    name[0] = 'f';
    3ac6:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3aca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3acd:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3ad2:	89 c8                	mov    %ecx,%eax
    3ad4:	f7 ea                	imul   %edx
    3ad6:	c1 fa 06             	sar    $0x6,%edx
    3ad9:	89 c8                	mov    %ecx,%eax
    3adb:	c1 f8 1f             	sar    $0x1f,%eax
    3ade:	29 c2                	sub    %eax,%edx
    3ae0:	89 d0                	mov    %edx,%eax
    3ae2:	83 c0 30             	add    $0x30,%eax
    3ae5:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3ae8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3aeb:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3af0:	89 d8                	mov    %ebx,%eax
    3af2:	f7 ea                	imul   %edx
    3af4:	c1 fa 06             	sar    $0x6,%edx
    3af7:	89 d8                	mov    %ebx,%eax
    3af9:	c1 f8 1f             	sar    $0x1f,%eax
    3afc:	89 d1                	mov    %edx,%ecx
    3afe:	29 c1                	sub    %eax,%ecx
    3b00:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3b06:	29 c3                	sub    %eax,%ebx
    3b08:	89 d9                	mov    %ebx,%ecx
    3b0a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3b0f:	89 c8                	mov    %ecx,%eax
    3b11:	f7 ea                	imul   %edx
    3b13:	c1 fa 05             	sar    $0x5,%edx
    3b16:	89 c8                	mov    %ecx,%eax
    3b18:	c1 f8 1f             	sar    $0x1f,%eax
    3b1b:	29 c2                	sub    %eax,%edx
    3b1d:	89 d0                	mov    %edx,%eax
    3b1f:	83 c0 30             	add    $0x30,%eax
    3b22:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3b25:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3b28:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3b2d:	89 d8                	mov    %ebx,%eax
    3b2f:	f7 ea                	imul   %edx
    3b31:	c1 fa 05             	sar    $0x5,%edx
    3b34:	89 d8                	mov    %ebx,%eax
    3b36:	c1 f8 1f             	sar    $0x1f,%eax
    3b39:	89 d1                	mov    %edx,%ecx
    3b3b:	29 c1                	sub    %eax,%ecx
    3b3d:	6b c1 64             	imul   $0x64,%ecx,%eax
    3b40:	29 c3                	sub    %eax,%ebx
    3b42:	89 d9                	mov    %ebx,%ecx
    3b44:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3b49:	89 c8                	mov    %ecx,%eax
    3b4b:	f7 ea                	imul   %edx
    3b4d:	c1 fa 02             	sar    $0x2,%edx
    3b50:	89 c8                	mov    %ecx,%eax
    3b52:	c1 f8 1f             	sar    $0x1f,%eax
    3b55:	29 c2                	sub    %eax,%edx
    3b57:	89 d0                	mov    %edx,%eax
    3b59:	83 c0 30             	add    $0x30,%eax
    3b5c:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3b5f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3b62:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3b67:	89 c8                	mov    %ecx,%eax
    3b69:	f7 ea                	imul   %edx
    3b6b:	c1 fa 02             	sar    $0x2,%edx
    3b6e:	89 c8                	mov    %ecx,%eax
    3b70:	c1 f8 1f             	sar    $0x1f,%eax
    3b73:	29 c2                	sub    %eax,%edx
    3b75:	89 d0                	mov    %edx,%eax
    3b77:	c1 e0 02             	shl    $0x2,%eax
    3b7a:	01 d0                	add    %edx,%eax
    3b7c:	01 c0                	add    %eax,%eax
    3b7e:	29 c1                	sub    %eax,%ecx
    3b80:	89 ca                	mov    %ecx,%edx
    3b82:	89 d0                	mov    %edx,%eax
    3b84:	83 c0 30             	add    $0x30,%eax
    3b87:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3b8a:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3b8e:	83 ec 0c             	sub    $0xc,%esp
    3b91:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3b94:	50                   	push   %eax
    3b95:	e8 65 05 00 00       	call   40ff <unlink>
    3b9a:	83 c4 10             	add    $0x10,%esp
    nfiles--;
    3b9d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  while(nfiles >= 0){
    3ba1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3ba5:	0f 89 1b ff ff ff    	jns    3ac6 <fsfull+0x1ae>
  }

  printf(1, "fsfull test finished\n");
    3bab:	83 ec 08             	sub    $0x8,%esp
    3bae:	68 71 5d 00 00       	push   $0x5d71
    3bb3:	6a 01                	push   $0x1
    3bb5:	e8 89 06 00 00       	call   4243 <printf>
    3bba:	83 c4 10             	add    $0x10,%esp
}
    3bbd:	90                   	nop
    3bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3bc1:	c9                   	leave  
    3bc2:	c3                   	ret    

00003bc3 <uio>:

void
uio()
{
    3bc3:	f3 0f 1e fb          	endbr32 
    3bc7:	55                   	push   %ebp
    3bc8:	89 e5                	mov    %esp,%ebp
    3bca:	83 ec 18             	sub    $0x18,%esp
  #define RTC_ADDR 0x70
  #define RTC_DATA 0x71

  ushort port = 0;
    3bcd:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
  uchar val = 0;
    3bd3:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
  int pid;

  printf(1, "uio test\n");
    3bd7:	83 ec 08             	sub    $0x8,%esp
    3bda:	68 87 5d 00 00       	push   $0x5d87
    3bdf:	6a 01                	push   $0x1
    3be1:	e8 5d 06 00 00       	call   4243 <printf>
    3be6:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    3be9:	e8 b9 04 00 00       	call   40a7 <fork>
    3bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3bf1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3bf5:	75 3a                	jne    3c31 <uio+0x6e>
    port = RTC_ADDR;
    3bf7:	66 c7 45 f6 70 00    	movw   $0x70,-0xa(%ebp)
    val = 0x09;  /* year */
    3bfd:	c6 45 f5 09          	movb   $0x9,-0xb(%ebp)
    /* http://wiki.osdev.org/Inline_Assembly/Examples */
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3c01:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    3c05:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
    3c09:	ee                   	out    %al,(%dx)
    port = RTC_DATA;
    3c0a:	66 c7 45 f6 71 00    	movw   $0x71,-0xa(%ebp)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3c10:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    3c14:	89 c2                	mov    %eax,%edx
    3c16:	ec                   	in     (%dx),%al
    3c17:	88 45 f5             	mov    %al,-0xb(%ebp)
    printf(1, "uio: uio succeeded; test FAILED\n");
    3c1a:	83 ec 08             	sub    $0x8,%esp
    3c1d:	68 94 5d 00 00       	push   $0x5d94
    3c22:	6a 01                	push   $0x1
    3c24:	e8 1a 06 00 00       	call   4243 <printf>
    3c29:	83 c4 10             	add    $0x10,%esp
    exit();
    3c2c:	e8 7e 04 00 00       	call   40af <exit>
  } else if(pid < 0){
    3c31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3c35:	79 17                	jns    3c4e <uio+0x8b>
    printf (1, "fork failed\n");
    3c37:	83 ec 08             	sub    $0x8,%esp
    3c3a:	68 ad 46 00 00       	push   $0x46ad
    3c3f:	6a 01                	push   $0x1
    3c41:	e8 fd 05 00 00       	call   4243 <printf>
    3c46:	83 c4 10             	add    $0x10,%esp
    exit();
    3c49:	e8 61 04 00 00       	call   40af <exit>
  }
  wait();
    3c4e:	e8 64 04 00 00       	call   40b7 <wait>
  printf(1, "uio test done\n");
    3c53:	83 ec 08             	sub    $0x8,%esp
    3c56:	68 b5 5d 00 00       	push   $0x5db5
    3c5b:	6a 01                	push   $0x1
    3c5d:	e8 e1 05 00 00       	call   4243 <printf>
    3c62:	83 c4 10             	add    $0x10,%esp
}
    3c65:	90                   	nop
    3c66:	c9                   	leave  
    3c67:	c3                   	ret    

00003c68 <argptest>:

void argptest()
{
    3c68:	f3 0f 1e fb          	endbr32 
    3c6c:	55                   	push   %ebp
    3c6d:	89 e5                	mov    %esp,%ebp
    3c6f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3c72:	83 ec 08             	sub    $0x8,%esp
    3c75:	6a 00                	push   $0x0
    3c77:	68 c4 5d 00 00       	push   $0x5dc4
    3c7c:	e8 6e 04 00 00       	call   40ef <open>
    3c81:	83 c4 10             	add    $0x10,%esp
    3c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0) {
    3c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3c8b:	79 17                	jns    3ca4 <argptest+0x3c>
    printf(2, "open failed\n");
    3c8d:	83 ec 08             	sub    $0x8,%esp
    3c90:	68 c9 5d 00 00       	push   $0x5dc9
    3c95:	6a 02                	push   $0x2
    3c97:	e8 a7 05 00 00       	call   4243 <printf>
    3c9c:	83 c4 10             	add    $0x10,%esp
    exit();
    3c9f:	e8 0b 04 00 00       	call   40af <exit>
  }
  read(fd, sbrk(0) - 1, -1);
    3ca4:	83 ec 0c             	sub    $0xc,%esp
    3ca7:	6a 00                	push   $0x0
    3ca9:	e8 89 04 00 00       	call   4137 <sbrk>
    3cae:	83 c4 10             	add    $0x10,%esp
    3cb1:	83 e8 01             	sub    $0x1,%eax
    3cb4:	83 ec 04             	sub    $0x4,%esp
    3cb7:	6a ff                	push   $0xffffffff
    3cb9:	50                   	push   %eax
    3cba:	ff 75 f4             	pushl  -0xc(%ebp)
    3cbd:	e8 05 04 00 00       	call   40c7 <read>
    3cc2:	83 c4 10             	add    $0x10,%esp
  close(fd);
    3cc5:	83 ec 0c             	sub    $0xc,%esp
    3cc8:	ff 75 f4             	pushl  -0xc(%ebp)
    3ccb:	e8 07 04 00 00       	call   40d7 <close>
    3cd0:	83 c4 10             	add    $0x10,%esp
  printf(1, "arg test passed\n");
    3cd3:	83 ec 08             	sub    $0x8,%esp
    3cd6:	68 d6 5d 00 00       	push   $0x5dd6
    3cdb:	6a 01                	push   $0x1
    3cdd:	e8 61 05 00 00       	call   4243 <printf>
    3ce2:	83 c4 10             	add    $0x10,%esp
}
    3ce5:	90                   	nop
    3ce6:	c9                   	leave  
    3ce7:	c3                   	ret    

00003ce8 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3ce8:	f3 0f 1e fb          	endbr32 
    3cec:	55                   	push   %ebp
    3ced:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3cef:	a1 64 65 00 00       	mov    0x6564,%eax
    3cf4:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3cfa:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3cff:	a3 64 65 00 00       	mov    %eax,0x6564
  return randstate;
    3d04:	a1 64 65 00 00       	mov    0x6564,%eax
}
    3d09:	5d                   	pop    %ebp
    3d0a:	c3                   	ret    

00003d0b <main>:

int
main(int argc, char *argv[])
{
    3d0b:	f3 0f 1e fb          	endbr32 
    3d0f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3d13:	83 e4 f0             	and    $0xfffffff0,%esp
    3d16:	ff 71 fc             	pushl  -0x4(%ecx)
    3d19:	55                   	push   %ebp
    3d1a:	89 e5                	mov    %esp,%ebp
    3d1c:	51                   	push   %ecx
    3d1d:	83 ec 04             	sub    $0x4,%esp
  printf(1, "usertests starting\n");
    3d20:	83 ec 08             	sub    $0x8,%esp
    3d23:	68 e7 5d 00 00       	push   $0x5de7
    3d28:	6a 01                	push   $0x1
    3d2a:	e8 14 05 00 00       	call   4243 <printf>
    3d2f:	83 c4 10             	add    $0x10,%esp

  if(open("usertests.ran", 0) >= 0){
    3d32:	83 ec 08             	sub    $0x8,%esp
    3d35:	6a 00                	push   $0x0
    3d37:	68 fb 5d 00 00       	push   $0x5dfb
    3d3c:	e8 ae 03 00 00       	call   40ef <open>
    3d41:	83 c4 10             	add    $0x10,%esp
    3d44:	85 c0                	test   %eax,%eax
    3d46:	78 17                	js     3d5f <main+0x54>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3d48:	83 ec 08             	sub    $0x8,%esp
    3d4b:	68 0c 5e 00 00       	push   $0x5e0c
    3d50:	6a 01                	push   $0x1
    3d52:	e8 ec 04 00 00       	call   4243 <printf>
    3d57:	83 c4 10             	add    $0x10,%esp
    exit();
    3d5a:	e8 50 03 00 00       	call   40af <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3d5f:	83 ec 08             	sub    $0x8,%esp
    3d62:	68 00 02 00 00       	push   $0x200
    3d67:	68 fb 5d 00 00       	push   $0x5dfb
    3d6c:	e8 7e 03 00 00       	call   40ef <open>
    3d71:	83 c4 10             	add    $0x10,%esp
    3d74:	83 ec 0c             	sub    $0xc,%esp
    3d77:	50                   	push   %eax
    3d78:	e8 5a 03 00 00       	call   40d7 <close>
    3d7d:	83 c4 10             	add    $0x10,%esp

  argptest();
    3d80:	e8 e3 fe ff ff       	call   3c68 <argptest>
  createdelete();
    3d85:	e8 5c d5 ff ff       	call   12e6 <createdelete>
  linkunlink();
    3d8a:	e8 8d df ff ff       	call   1d1c <linkunlink>
  concreate();
    3d8f:	e8 d4 db ff ff       	call   1968 <concreate>
  fourfiles();
    3d94:	e8 f8 d2 ff ff       	call   1091 <fourfiles>
  sharedfd();
    3d99:	e8 0c d1 ff ff       	call   eaa <sharedfd>

  bigargtest();
    3d9e:	e8 35 fa ff ff       	call   37d8 <bigargtest>
  bigwrite();
    3da3:	e8 72 e9 ff ff       	call   271a <bigwrite>
  bigargtest();
    3da8:	e8 2b fa ff ff       	call   37d8 <bigargtest>
  bsstest();
    3dad:	e8 ac f9 ff ff       	call   375e <bsstest>
  sbrktest();
    3db2:	e8 b2 f3 ff ff       	call   3169 <sbrktest>
  validatetest();
    3db7:	e8 c0 f8 ff ff       	call   367c <validatetest>

  opentest();
    3dbc:	e8 4a c5 ff ff       	call   30b <opentest>
  writetest();
    3dc1:	e8 f8 c5 ff ff       	call   3be <writetest>
  writetest1();
    3dc6:	e8 07 c8 ff ff       	call   5d2 <writetest1>
  createtest();
    3dcb:	e8 02 ca ff ff       	call   7d2 <createtest>

  openiputtest();
    3dd0:	e8 23 c4 ff ff       	call   1f8 <openiputtest>
  exitiputtest();
    3dd5:	e8 1b c3 ff ff       	call   f5 <exitiputtest>
  iputtest();
    3dda:	e8 21 c2 ff ff       	call   0 <iputtest>

  mem();
    3ddf:	e8 d1 cf ff ff       	call   db5 <mem>
  pipe1();
    3de4:	e8 fc cb ff ff       	call   9e5 <pipe1>
  preempt();
    3de9:	e8 e4 cd ff ff       	call   bd2 <preempt>
  exitwait();
    3dee:	e8 46 cf ff ff       	call   d39 <exitwait>

  rmdot();
    3df3:	e8 a0 ed ff ff       	call   2b98 <rmdot>
  fourteen();
    3df8:	e8 3b ec ff ff       	call   2a38 <fourteen>
  bigfile();
    3dfd:	e8 1a ea ff ff       	call   281c <bigfile>
  subdir();
    3e02:	e8 cb e1 ff ff       	call   1fd2 <subdir>
  linktest();
    3e07:	e8 16 d9 ff ff       	call   1722 <linktest>
  unlinkread();
    3e0c:	e8 4b d7 ff ff       	call   155c <unlinkread>
  dirfile();
    3e11:	e8 0b ef ff ff       	call   2d21 <dirfile>
  iref();
    3e16:	e8 42 f1 ff ff       	call   2f5d <iref>
  forktest();
    3e1b:	e8 7b f2 ff ff       	call   309b <forktest>
  bigdir(); // slow
    3e20:	e8 34 e0 ff ff       	call   1e59 <bigdir>

  uio();
    3e25:	e8 99 fd ff ff       	call   3bc3 <uio>

  exectest();
    3e2a:	e8 5f cb ff ff       	call   98e <exectest>

  exit();
    3e2f:	e8 7b 02 00 00       	call   40af <exit>

00003e34 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3e34:	55                   	push   %ebp
    3e35:	89 e5                	mov    %esp,%ebp
    3e37:	57                   	push   %edi
    3e38:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3e39:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3e3c:	8b 55 10             	mov    0x10(%ebp),%edx
    3e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e42:	89 cb                	mov    %ecx,%ebx
    3e44:	89 df                	mov    %ebx,%edi
    3e46:	89 d1                	mov    %edx,%ecx
    3e48:	fc                   	cld    
    3e49:	f3 aa                	rep stos %al,%es:(%edi)
    3e4b:	89 ca                	mov    %ecx,%edx
    3e4d:	89 fb                	mov    %edi,%ebx
    3e4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3e52:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3e55:	90                   	nop
    3e56:	5b                   	pop    %ebx
    3e57:	5f                   	pop    %edi
    3e58:	5d                   	pop    %ebp
    3e59:	c3                   	ret    

00003e5a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    3e5a:	f3 0f 1e fb          	endbr32 
    3e5e:	55                   	push   %ebp
    3e5f:	89 e5                	mov    %esp,%ebp
    3e61:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3e64:	8b 45 08             	mov    0x8(%ebp),%eax
    3e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3e6a:	90                   	nop
    3e6b:	8b 55 0c             	mov    0xc(%ebp),%edx
    3e6e:	8d 42 01             	lea    0x1(%edx),%eax
    3e71:	89 45 0c             	mov    %eax,0xc(%ebp)
    3e74:	8b 45 08             	mov    0x8(%ebp),%eax
    3e77:	8d 48 01             	lea    0x1(%eax),%ecx
    3e7a:	89 4d 08             	mov    %ecx,0x8(%ebp)
    3e7d:	0f b6 12             	movzbl (%edx),%edx
    3e80:	88 10                	mov    %dl,(%eax)
    3e82:	0f b6 00             	movzbl (%eax),%eax
    3e85:	84 c0                	test   %al,%al
    3e87:	75 e2                	jne    3e6b <strcpy+0x11>
    ;
  return os;
    3e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e8c:	c9                   	leave  
    3e8d:	c3                   	ret    

00003e8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3e8e:	f3 0f 1e fb          	endbr32 
    3e92:	55                   	push   %ebp
    3e93:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3e95:	eb 08                	jmp    3e9f <strcmp+0x11>
    p++, q++;
    3e97:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3e9b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    3e9f:	8b 45 08             	mov    0x8(%ebp),%eax
    3ea2:	0f b6 00             	movzbl (%eax),%eax
    3ea5:	84 c0                	test   %al,%al
    3ea7:	74 10                	je     3eb9 <strcmp+0x2b>
    3ea9:	8b 45 08             	mov    0x8(%ebp),%eax
    3eac:	0f b6 10             	movzbl (%eax),%edx
    3eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
    3eb2:	0f b6 00             	movzbl (%eax),%eax
    3eb5:	38 c2                	cmp    %al,%dl
    3eb7:	74 de                	je     3e97 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
    3eb9:	8b 45 08             	mov    0x8(%ebp),%eax
    3ebc:	0f b6 00             	movzbl (%eax),%eax
    3ebf:	0f b6 d0             	movzbl %al,%edx
    3ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ec5:	0f b6 00             	movzbl (%eax),%eax
    3ec8:	0f b6 c0             	movzbl %al,%eax
    3ecb:	29 c2                	sub    %eax,%edx
    3ecd:	89 d0                	mov    %edx,%eax
}
    3ecf:	5d                   	pop    %ebp
    3ed0:	c3                   	ret    

00003ed1 <strlen>:

uint
strlen(const char *s)
{
    3ed1:	f3 0f 1e fb          	endbr32 
    3ed5:	55                   	push   %ebp
    3ed6:	89 e5                	mov    %esp,%ebp
    3ed8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3edb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3ee2:	eb 04                	jmp    3ee8 <strlen+0x17>
    3ee4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3ee8:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3eeb:	8b 45 08             	mov    0x8(%ebp),%eax
    3eee:	01 d0                	add    %edx,%eax
    3ef0:	0f b6 00             	movzbl (%eax),%eax
    3ef3:	84 c0                	test   %al,%al
    3ef5:	75 ed                	jne    3ee4 <strlen+0x13>
    ;
  return n;
    3ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3efa:	c9                   	leave  
    3efb:	c3                   	ret    

00003efc <memset>:

void*
memset(void *dst, int c, uint n)
{
    3efc:	f3 0f 1e fb          	endbr32 
    3f00:	55                   	push   %ebp
    3f01:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    3f03:	8b 45 10             	mov    0x10(%ebp),%eax
    3f06:	50                   	push   %eax
    3f07:	ff 75 0c             	pushl  0xc(%ebp)
    3f0a:	ff 75 08             	pushl  0x8(%ebp)
    3f0d:	e8 22 ff ff ff       	call   3e34 <stosb>
    3f12:	83 c4 0c             	add    $0xc,%esp
  return dst;
    3f15:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3f18:	c9                   	leave  
    3f19:	c3                   	ret    

00003f1a <strchr>:

char*
strchr(const char *s, char c)
{
    3f1a:	f3 0f 1e fb          	endbr32 
    3f1e:	55                   	push   %ebp
    3f1f:	89 e5                	mov    %esp,%ebp
    3f21:	83 ec 04             	sub    $0x4,%esp
    3f24:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f27:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3f2a:	eb 14                	jmp    3f40 <strchr+0x26>
    if(*s == c)
    3f2c:	8b 45 08             	mov    0x8(%ebp),%eax
    3f2f:	0f b6 00             	movzbl (%eax),%eax
    3f32:	38 45 fc             	cmp    %al,-0x4(%ebp)
    3f35:	75 05                	jne    3f3c <strchr+0x22>
      return (char*)s;
    3f37:	8b 45 08             	mov    0x8(%ebp),%eax
    3f3a:	eb 13                	jmp    3f4f <strchr+0x35>
  for(; *s; s++)
    3f3c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3f40:	8b 45 08             	mov    0x8(%ebp),%eax
    3f43:	0f b6 00             	movzbl (%eax),%eax
    3f46:	84 c0                	test   %al,%al
    3f48:	75 e2                	jne    3f2c <strchr+0x12>
  return 0;
    3f4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3f4f:	c9                   	leave  
    3f50:	c3                   	ret    

00003f51 <gets>:

char*
gets(char *buf, int max)
{
    3f51:	f3 0f 1e fb          	endbr32 
    3f55:	55                   	push   %ebp
    3f56:	89 e5                	mov    %esp,%ebp
    3f58:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3f5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3f62:	eb 42                	jmp    3fa6 <gets+0x55>
    cc = read(0, &c, 1);
    3f64:	83 ec 04             	sub    $0x4,%esp
    3f67:	6a 01                	push   $0x1
    3f69:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3f6c:	50                   	push   %eax
    3f6d:	6a 00                	push   $0x0
    3f6f:	e8 53 01 00 00       	call   40c7 <read>
    3f74:	83 c4 10             	add    $0x10,%esp
    3f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3f7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3f7e:	7e 33                	jle    3fb3 <gets+0x62>
      break;
    buf[i++] = c;
    3f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f83:	8d 50 01             	lea    0x1(%eax),%edx
    3f86:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3f89:	89 c2                	mov    %eax,%edx
    3f8b:	8b 45 08             	mov    0x8(%ebp),%eax
    3f8e:	01 c2                	add    %eax,%edx
    3f90:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3f94:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3f96:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3f9a:	3c 0a                	cmp    $0xa,%al
    3f9c:	74 16                	je     3fb4 <gets+0x63>
    3f9e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3fa2:	3c 0d                	cmp    $0xd,%al
    3fa4:	74 0e                	je     3fb4 <gets+0x63>
  for(i=0; i+1 < max; ){
    3fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3fa9:	83 c0 01             	add    $0x1,%eax
    3fac:	39 45 0c             	cmp    %eax,0xc(%ebp)
    3faf:	7f b3                	jg     3f64 <gets+0x13>
    3fb1:	eb 01                	jmp    3fb4 <gets+0x63>
      break;
    3fb3:	90                   	nop
      break;
  }
  buf[i] = '\0';
    3fb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3fb7:	8b 45 08             	mov    0x8(%ebp),%eax
    3fba:	01 d0                	add    %edx,%eax
    3fbc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3fbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3fc2:	c9                   	leave  
    3fc3:	c3                   	ret    

00003fc4 <stat>:

int
stat(const char *n, struct stat *st)
{
    3fc4:	f3 0f 1e fb          	endbr32 
    3fc8:	55                   	push   %ebp
    3fc9:	89 e5                	mov    %esp,%ebp
    3fcb:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3fce:	83 ec 08             	sub    $0x8,%esp
    3fd1:	6a 00                	push   $0x0
    3fd3:	ff 75 08             	pushl  0x8(%ebp)
    3fd6:	e8 14 01 00 00       	call   40ef <open>
    3fdb:	83 c4 10             	add    $0x10,%esp
    3fde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3fe1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3fe5:	79 07                	jns    3fee <stat+0x2a>
    return -1;
    3fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3fec:	eb 25                	jmp    4013 <stat+0x4f>
  r = fstat(fd, st);
    3fee:	83 ec 08             	sub    $0x8,%esp
    3ff1:	ff 75 0c             	pushl  0xc(%ebp)
    3ff4:	ff 75 f4             	pushl  -0xc(%ebp)
    3ff7:	e8 0b 01 00 00       	call   4107 <fstat>
    3ffc:	83 c4 10             	add    $0x10,%esp
    3fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    4002:	83 ec 0c             	sub    $0xc,%esp
    4005:	ff 75 f4             	pushl  -0xc(%ebp)
    4008:	e8 ca 00 00 00       	call   40d7 <close>
    400d:	83 c4 10             	add    $0x10,%esp
  return r;
    4010:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    4013:	c9                   	leave  
    4014:	c3                   	ret    

00004015 <atoi>:

int
atoi(const char *s)
{
    4015:	f3 0f 1e fb          	endbr32 
    4019:	55                   	push   %ebp
    401a:	89 e5                	mov    %esp,%ebp
    401c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    401f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    4026:	eb 25                	jmp    404d <atoi+0x38>
    n = n*10 + *s++ - '0';
    4028:	8b 55 fc             	mov    -0x4(%ebp),%edx
    402b:	89 d0                	mov    %edx,%eax
    402d:	c1 e0 02             	shl    $0x2,%eax
    4030:	01 d0                	add    %edx,%eax
    4032:	01 c0                	add    %eax,%eax
    4034:	89 c1                	mov    %eax,%ecx
    4036:	8b 45 08             	mov    0x8(%ebp),%eax
    4039:	8d 50 01             	lea    0x1(%eax),%edx
    403c:	89 55 08             	mov    %edx,0x8(%ebp)
    403f:	0f b6 00             	movzbl (%eax),%eax
    4042:	0f be c0             	movsbl %al,%eax
    4045:	01 c8                	add    %ecx,%eax
    4047:	83 e8 30             	sub    $0x30,%eax
    404a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    404d:	8b 45 08             	mov    0x8(%ebp),%eax
    4050:	0f b6 00             	movzbl (%eax),%eax
    4053:	3c 2f                	cmp    $0x2f,%al
    4055:	7e 0a                	jle    4061 <atoi+0x4c>
    4057:	8b 45 08             	mov    0x8(%ebp),%eax
    405a:	0f b6 00             	movzbl (%eax),%eax
    405d:	3c 39                	cmp    $0x39,%al
    405f:	7e c7                	jle    4028 <atoi+0x13>
  return n;
    4061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4064:	c9                   	leave  
    4065:	c3                   	ret    

00004066 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4066:	f3 0f 1e fb          	endbr32 
    406a:	55                   	push   %ebp
    406b:	89 e5                	mov    %esp,%ebp
    406d:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    4070:	8b 45 08             	mov    0x8(%ebp),%eax
    4073:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    4076:	8b 45 0c             	mov    0xc(%ebp),%eax
    4079:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    407c:	eb 17                	jmp    4095 <memmove+0x2f>
    *dst++ = *src++;
    407e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4081:	8d 42 01             	lea    0x1(%edx),%eax
    4084:	89 45 f8             	mov    %eax,-0x8(%ebp)
    4087:	8b 45 fc             	mov    -0x4(%ebp),%eax
    408a:	8d 48 01             	lea    0x1(%eax),%ecx
    408d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    4090:	0f b6 12             	movzbl (%edx),%edx
    4093:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    4095:	8b 45 10             	mov    0x10(%ebp),%eax
    4098:	8d 50 ff             	lea    -0x1(%eax),%edx
    409b:	89 55 10             	mov    %edx,0x10(%ebp)
    409e:	85 c0                	test   %eax,%eax
    40a0:	7f dc                	jg     407e <memmove+0x18>
  return vdst;
    40a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
    40a5:	c9                   	leave  
    40a6:	c3                   	ret    

000040a7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    40a7:	b8 01 00 00 00       	mov    $0x1,%eax
    40ac:	cd 40                	int    $0x40
    40ae:	c3                   	ret    

000040af <exit>:
SYSCALL(exit)
    40af:	b8 02 00 00 00       	mov    $0x2,%eax
    40b4:	cd 40                	int    $0x40
    40b6:	c3                   	ret    

000040b7 <wait>:
SYSCALL(wait)
    40b7:	b8 03 00 00 00       	mov    $0x3,%eax
    40bc:	cd 40                	int    $0x40
    40be:	c3                   	ret    

000040bf <pipe>:
SYSCALL(pipe)
    40bf:	b8 04 00 00 00       	mov    $0x4,%eax
    40c4:	cd 40                	int    $0x40
    40c6:	c3                   	ret    

000040c7 <read>:
SYSCALL(read)
    40c7:	b8 05 00 00 00       	mov    $0x5,%eax
    40cc:	cd 40                	int    $0x40
    40ce:	c3                   	ret    

000040cf <write>:
SYSCALL(write)
    40cf:	b8 10 00 00 00       	mov    $0x10,%eax
    40d4:	cd 40                	int    $0x40
    40d6:	c3                   	ret    

000040d7 <close>:
SYSCALL(close)
    40d7:	b8 15 00 00 00       	mov    $0x15,%eax
    40dc:	cd 40                	int    $0x40
    40de:	c3                   	ret    

000040df <kill>:
SYSCALL(kill)
    40df:	b8 06 00 00 00       	mov    $0x6,%eax
    40e4:	cd 40                	int    $0x40
    40e6:	c3                   	ret    

000040e7 <exec>:
SYSCALL(exec)
    40e7:	b8 07 00 00 00       	mov    $0x7,%eax
    40ec:	cd 40                	int    $0x40
    40ee:	c3                   	ret    

000040ef <open>:
SYSCALL(open)
    40ef:	b8 0f 00 00 00       	mov    $0xf,%eax
    40f4:	cd 40                	int    $0x40
    40f6:	c3                   	ret    

000040f7 <mknod>:
SYSCALL(mknod)
    40f7:	b8 11 00 00 00       	mov    $0x11,%eax
    40fc:	cd 40                	int    $0x40
    40fe:	c3                   	ret    

000040ff <unlink>:
SYSCALL(unlink)
    40ff:	b8 12 00 00 00       	mov    $0x12,%eax
    4104:	cd 40                	int    $0x40
    4106:	c3                   	ret    

00004107 <fstat>:
SYSCALL(fstat)
    4107:	b8 08 00 00 00       	mov    $0x8,%eax
    410c:	cd 40                	int    $0x40
    410e:	c3                   	ret    

0000410f <link>:
SYSCALL(link)
    410f:	b8 13 00 00 00       	mov    $0x13,%eax
    4114:	cd 40                	int    $0x40
    4116:	c3                   	ret    

00004117 <mkdir>:
SYSCALL(mkdir)
    4117:	b8 14 00 00 00       	mov    $0x14,%eax
    411c:	cd 40                	int    $0x40
    411e:	c3                   	ret    

0000411f <chdir>:
SYSCALL(chdir)
    411f:	b8 09 00 00 00       	mov    $0x9,%eax
    4124:	cd 40                	int    $0x40
    4126:	c3                   	ret    

00004127 <dup>:
SYSCALL(dup)
    4127:	b8 0a 00 00 00       	mov    $0xa,%eax
    412c:	cd 40                	int    $0x40
    412e:	c3                   	ret    

0000412f <getpid>:
SYSCALL(getpid)
    412f:	b8 0b 00 00 00       	mov    $0xb,%eax
    4134:	cd 40                	int    $0x40
    4136:	c3                   	ret    

00004137 <sbrk>:
SYSCALL(sbrk)
    4137:	b8 0c 00 00 00       	mov    $0xc,%eax
    413c:	cd 40                	int    $0x40
    413e:	c3                   	ret    

0000413f <sleep>:
SYSCALL(sleep)
    413f:	b8 0d 00 00 00       	mov    $0xd,%eax
    4144:	cd 40                	int    $0x40
    4146:	c3                   	ret    

00004147 <uptime>:
SYSCALL(uptime)
    4147:	b8 0e 00 00 00       	mov    $0xe,%eax
    414c:	cd 40                	int    $0x40
    414e:	c3                   	ret    

0000414f <mencrypt>:
SYSCALL(mencrypt)
    414f:	b8 16 00 00 00       	mov    $0x16,%eax
    4154:	cd 40                	int    $0x40
    4156:	c3                   	ret    

00004157 <getpgtable>:
SYSCALL(getpgtable)
    4157:	b8 17 00 00 00       	mov    $0x17,%eax
    415c:	cd 40                	int    $0x40
    415e:	c3                   	ret    

0000415f <dump_rawphymem>:
SYSCALL(dump_rawphymem)
    415f:	b8 18 00 00 00       	mov    $0x18,%eax
    4164:	cd 40                	int    $0x40
    4166:	c3                   	ret    

00004167 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    4167:	f3 0f 1e fb          	endbr32 
    416b:	55                   	push   %ebp
    416c:	89 e5                	mov    %esp,%ebp
    416e:	83 ec 18             	sub    $0x18,%esp
    4171:	8b 45 0c             	mov    0xc(%ebp),%eax
    4174:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    4177:	83 ec 04             	sub    $0x4,%esp
    417a:	6a 01                	push   $0x1
    417c:	8d 45 f4             	lea    -0xc(%ebp),%eax
    417f:	50                   	push   %eax
    4180:	ff 75 08             	pushl  0x8(%ebp)
    4183:	e8 47 ff ff ff       	call   40cf <write>
    4188:	83 c4 10             	add    $0x10,%esp
}
    418b:	90                   	nop
    418c:	c9                   	leave  
    418d:	c3                   	ret    

0000418e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    418e:	f3 0f 1e fb          	endbr32 
    4192:	55                   	push   %ebp
    4193:	89 e5                	mov    %esp,%ebp
    4195:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    4198:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    419f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    41a3:	74 17                	je     41bc <printint+0x2e>
    41a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    41a9:	79 11                	jns    41bc <printint+0x2e>
    neg = 1;
    41ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    41b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    41b5:	f7 d8                	neg    %eax
    41b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    41ba:	eb 06                	jmp    41c2 <printint+0x34>
  } else {
    x = xx;
    41bc:	8b 45 0c             	mov    0xc(%ebp),%eax
    41bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    41c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    41c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
    41cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    41cf:	ba 00 00 00 00       	mov    $0x0,%edx
    41d4:	f7 f1                	div    %ecx
    41d6:	89 d1                	mov    %edx,%ecx
    41d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    41db:	8d 50 01             	lea    0x1(%eax),%edx
    41de:	89 55 f4             	mov    %edx,-0xc(%ebp)
    41e1:	0f b6 91 68 65 00 00 	movzbl 0x6568(%ecx),%edx
    41e8:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
    41ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
    41ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
    41f2:	ba 00 00 00 00       	mov    $0x0,%edx
    41f7:	f7 f1                	div    %ecx
    41f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    41fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4200:	75 c7                	jne    41c9 <printint+0x3b>
  if(neg)
    4202:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4206:	74 2d                	je     4235 <printint+0xa7>
    buf[i++] = '-';
    4208:	8b 45 f4             	mov    -0xc(%ebp),%eax
    420b:	8d 50 01             	lea    0x1(%eax),%edx
    420e:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4211:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    4216:	eb 1d                	jmp    4235 <printint+0xa7>
    putc(fd, buf[i]);
    4218:	8d 55 dc             	lea    -0x24(%ebp),%edx
    421b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    421e:	01 d0                	add    %edx,%eax
    4220:	0f b6 00             	movzbl (%eax),%eax
    4223:	0f be c0             	movsbl %al,%eax
    4226:	83 ec 08             	sub    $0x8,%esp
    4229:	50                   	push   %eax
    422a:	ff 75 08             	pushl  0x8(%ebp)
    422d:	e8 35 ff ff ff       	call   4167 <putc>
    4232:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
    4235:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    4239:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    423d:	79 d9                	jns    4218 <printint+0x8a>
}
    423f:	90                   	nop
    4240:	90                   	nop
    4241:	c9                   	leave  
    4242:	c3                   	ret    

00004243 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    4243:	f3 0f 1e fb          	endbr32 
    4247:	55                   	push   %ebp
    4248:	89 e5                	mov    %esp,%ebp
    424a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    424d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4254:	8d 45 0c             	lea    0xc(%ebp),%eax
    4257:	83 c0 04             	add    $0x4,%eax
    425a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    425d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4264:	e9 59 01 00 00       	jmp    43c2 <printf+0x17f>
    c = fmt[i] & 0xff;
    4269:	8b 55 0c             	mov    0xc(%ebp),%edx
    426c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    426f:	01 d0                	add    %edx,%eax
    4271:	0f b6 00             	movzbl (%eax),%eax
    4274:	0f be c0             	movsbl %al,%eax
    4277:	25 ff 00 00 00       	and    $0xff,%eax
    427c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    427f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4283:	75 2c                	jne    42b1 <printf+0x6e>
      if(c == '%'){
    4285:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4289:	75 0c                	jne    4297 <printf+0x54>
        state = '%';
    428b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    4292:	e9 27 01 00 00       	jmp    43be <printf+0x17b>
      } else {
        putc(fd, c);
    4297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    429a:	0f be c0             	movsbl %al,%eax
    429d:	83 ec 08             	sub    $0x8,%esp
    42a0:	50                   	push   %eax
    42a1:	ff 75 08             	pushl  0x8(%ebp)
    42a4:	e8 be fe ff ff       	call   4167 <putc>
    42a9:	83 c4 10             	add    $0x10,%esp
    42ac:	e9 0d 01 00 00       	jmp    43be <printf+0x17b>
      }
    } else if(state == '%'){
    42b1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    42b5:	0f 85 03 01 00 00    	jne    43be <printf+0x17b>
      if(c == 'd'){
    42bb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    42bf:	75 1e                	jne    42df <printf+0x9c>
        printint(fd, *ap, 10, 1);
    42c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    42c4:	8b 00                	mov    (%eax),%eax
    42c6:	6a 01                	push   $0x1
    42c8:	6a 0a                	push   $0xa
    42ca:	50                   	push   %eax
    42cb:	ff 75 08             	pushl  0x8(%ebp)
    42ce:	e8 bb fe ff ff       	call   418e <printint>
    42d3:	83 c4 10             	add    $0x10,%esp
        ap++;
    42d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    42da:	e9 d8 00 00 00       	jmp    43b7 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
    42df:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    42e3:	74 06                	je     42eb <printf+0xa8>
    42e5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    42e9:	75 1e                	jne    4309 <printf+0xc6>
        printint(fd, *ap, 16, 0);
    42eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    42ee:	8b 00                	mov    (%eax),%eax
    42f0:	6a 00                	push   $0x0
    42f2:	6a 10                	push   $0x10
    42f4:	50                   	push   %eax
    42f5:	ff 75 08             	pushl  0x8(%ebp)
    42f8:	e8 91 fe ff ff       	call   418e <printint>
    42fd:	83 c4 10             	add    $0x10,%esp
        ap++;
    4300:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4304:	e9 ae 00 00 00       	jmp    43b7 <printf+0x174>
      } else if(c == 's'){
    4309:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    430d:	75 43                	jne    4352 <printf+0x10f>
        s = (char*)*ap;
    430f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4312:	8b 00                	mov    (%eax),%eax
    4314:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4317:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    431b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    431f:	75 25                	jne    4346 <printf+0x103>
          s = "(null)";
    4321:	c7 45 f4 36 5e 00 00 	movl   $0x5e36,-0xc(%ebp)
        while(*s != 0){
    4328:	eb 1c                	jmp    4346 <printf+0x103>
          putc(fd, *s);
    432a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    432d:	0f b6 00             	movzbl (%eax),%eax
    4330:	0f be c0             	movsbl %al,%eax
    4333:	83 ec 08             	sub    $0x8,%esp
    4336:	50                   	push   %eax
    4337:	ff 75 08             	pushl  0x8(%ebp)
    433a:	e8 28 fe ff ff       	call   4167 <putc>
    433f:	83 c4 10             	add    $0x10,%esp
          s++;
    4342:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    4346:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4349:	0f b6 00             	movzbl (%eax),%eax
    434c:	84 c0                	test   %al,%al
    434e:	75 da                	jne    432a <printf+0xe7>
    4350:	eb 65                	jmp    43b7 <printf+0x174>
        }
      } else if(c == 'c'){
    4352:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    4356:	75 1d                	jne    4375 <printf+0x132>
        putc(fd, *ap);
    4358:	8b 45 e8             	mov    -0x18(%ebp),%eax
    435b:	8b 00                	mov    (%eax),%eax
    435d:	0f be c0             	movsbl %al,%eax
    4360:	83 ec 08             	sub    $0x8,%esp
    4363:	50                   	push   %eax
    4364:	ff 75 08             	pushl  0x8(%ebp)
    4367:	e8 fb fd ff ff       	call   4167 <putc>
    436c:	83 c4 10             	add    $0x10,%esp
        ap++;
    436f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4373:	eb 42                	jmp    43b7 <printf+0x174>
      } else if(c == '%'){
    4375:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4379:	75 17                	jne    4392 <printf+0x14f>
        putc(fd, c);
    437b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    437e:	0f be c0             	movsbl %al,%eax
    4381:	83 ec 08             	sub    $0x8,%esp
    4384:	50                   	push   %eax
    4385:	ff 75 08             	pushl  0x8(%ebp)
    4388:	e8 da fd ff ff       	call   4167 <putc>
    438d:	83 c4 10             	add    $0x10,%esp
    4390:	eb 25                	jmp    43b7 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4392:	83 ec 08             	sub    $0x8,%esp
    4395:	6a 25                	push   $0x25
    4397:	ff 75 08             	pushl  0x8(%ebp)
    439a:	e8 c8 fd ff ff       	call   4167 <putc>
    439f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    43a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    43a5:	0f be c0             	movsbl %al,%eax
    43a8:	83 ec 08             	sub    $0x8,%esp
    43ab:	50                   	push   %eax
    43ac:	ff 75 08             	pushl  0x8(%ebp)
    43af:	e8 b3 fd ff ff       	call   4167 <putc>
    43b4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    43b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    43be:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    43c2:	8b 55 0c             	mov    0xc(%ebp),%edx
    43c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43c8:	01 d0                	add    %edx,%eax
    43ca:	0f b6 00             	movzbl (%eax),%eax
    43cd:	84 c0                	test   %al,%al
    43cf:	0f 85 94 fe ff ff    	jne    4269 <printf+0x26>
    }
  }
}
    43d5:	90                   	nop
    43d6:	90                   	nop
    43d7:	c9                   	leave  
    43d8:	c3                   	ret    

000043d9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    43d9:	f3 0f 1e fb          	endbr32 
    43dd:	55                   	push   %ebp
    43de:	89 e5                	mov    %esp,%ebp
    43e0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    43e3:	8b 45 08             	mov    0x8(%ebp),%eax
    43e6:	83 e8 08             	sub    $0x8,%eax
    43e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    43ec:	a1 08 66 00 00       	mov    0x6608,%eax
    43f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    43f4:	eb 24                	jmp    441a <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    43f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43f9:	8b 00                	mov    (%eax),%eax
    43fb:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    43fe:	72 12                	jb     4412 <free+0x39>
    4400:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4403:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4406:	77 24                	ja     442c <free+0x53>
    4408:	8b 45 fc             	mov    -0x4(%ebp),%eax
    440b:	8b 00                	mov    (%eax),%eax
    440d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    4410:	72 1a                	jb     442c <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4412:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4415:	8b 00                	mov    (%eax),%eax
    4417:	89 45 fc             	mov    %eax,-0x4(%ebp)
    441a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    441d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4420:	76 d4                	jbe    43f6 <free+0x1d>
    4422:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4425:	8b 00                	mov    (%eax),%eax
    4427:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    442a:	73 ca                	jae    43f6 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    442c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    442f:	8b 40 04             	mov    0x4(%eax),%eax
    4432:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4439:	8b 45 f8             	mov    -0x8(%ebp),%eax
    443c:	01 c2                	add    %eax,%edx
    443e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4441:	8b 00                	mov    (%eax),%eax
    4443:	39 c2                	cmp    %eax,%edx
    4445:	75 24                	jne    446b <free+0x92>
    bp->s.size += p->s.ptr->s.size;
    4447:	8b 45 f8             	mov    -0x8(%ebp),%eax
    444a:	8b 50 04             	mov    0x4(%eax),%edx
    444d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4450:	8b 00                	mov    (%eax),%eax
    4452:	8b 40 04             	mov    0x4(%eax),%eax
    4455:	01 c2                	add    %eax,%edx
    4457:	8b 45 f8             	mov    -0x8(%ebp),%eax
    445a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    445d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4460:	8b 00                	mov    (%eax),%eax
    4462:	8b 10                	mov    (%eax),%edx
    4464:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4467:	89 10                	mov    %edx,(%eax)
    4469:	eb 0a                	jmp    4475 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
    446b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    446e:	8b 10                	mov    (%eax),%edx
    4470:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4473:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    4475:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4478:	8b 40 04             	mov    0x4(%eax),%eax
    447b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4482:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4485:	01 d0                	add    %edx,%eax
    4487:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    448a:	75 20                	jne    44ac <free+0xd3>
    p->s.size += bp->s.size;
    448c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    448f:	8b 50 04             	mov    0x4(%eax),%edx
    4492:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4495:	8b 40 04             	mov    0x4(%eax),%eax
    4498:	01 c2                	add    %eax,%edx
    449a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    449d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    44a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    44a3:	8b 10                	mov    (%eax),%edx
    44a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    44a8:	89 10                	mov    %edx,(%eax)
    44aa:	eb 08                	jmp    44b4 <free+0xdb>
  } else
    p->s.ptr = bp;
    44ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    44af:	8b 55 f8             	mov    -0x8(%ebp),%edx
    44b2:	89 10                	mov    %edx,(%eax)
  freep = p;
    44b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    44b7:	a3 08 66 00 00       	mov    %eax,0x6608
}
    44bc:	90                   	nop
    44bd:	c9                   	leave  
    44be:	c3                   	ret    

000044bf <morecore>:

static Header*
morecore(uint nu)
{
    44bf:	f3 0f 1e fb          	endbr32 
    44c3:	55                   	push   %ebp
    44c4:	89 e5                	mov    %esp,%ebp
    44c6:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    44c9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    44d0:	77 07                	ja     44d9 <morecore+0x1a>
    nu = 4096;
    44d2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    44d9:	8b 45 08             	mov    0x8(%ebp),%eax
    44dc:	c1 e0 03             	shl    $0x3,%eax
    44df:	83 ec 0c             	sub    $0xc,%esp
    44e2:	50                   	push   %eax
    44e3:	e8 4f fc ff ff       	call   4137 <sbrk>
    44e8:	83 c4 10             	add    $0x10,%esp
    44eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    44ee:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    44f2:	75 07                	jne    44fb <morecore+0x3c>
    return 0;
    44f4:	b8 00 00 00 00       	mov    $0x0,%eax
    44f9:	eb 26                	jmp    4521 <morecore+0x62>
  hp = (Header*)p;
    44fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    4501:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4504:	8b 55 08             	mov    0x8(%ebp),%edx
    4507:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    450a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    450d:	83 c0 08             	add    $0x8,%eax
    4510:	83 ec 0c             	sub    $0xc,%esp
    4513:	50                   	push   %eax
    4514:	e8 c0 fe ff ff       	call   43d9 <free>
    4519:	83 c4 10             	add    $0x10,%esp
  return freep;
    451c:	a1 08 66 00 00       	mov    0x6608,%eax
}
    4521:	c9                   	leave  
    4522:	c3                   	ret    

00004523 <malloc>:

void*
malloc(uint nbytes)
{
    4523:	f3 0f 1e fb          	endbr32 
    4527:	55                   	push   %ebp
    4528:	89 e5                	mov    %esp,%ebp
    452a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    452d:	8b 45 08             	mov    0x8(%ebp),%eax
    4530:	83 c0 07             	add    $0x7,%eax
    4533:	c1 e8 03             	shr    $0x3,%eax
    4536:	83 c0 01             	add    $0x1,%eax
    4539:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    453c:	a1 08 66 00 00       	mov    0x6608,%eax
    4541:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4544:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4548:	75 23                	jne    456d <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
    454a:	c7 45 f0 00 66 00 00 	movl   $0x6600,-0x10(%ebp)
    4551:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4554:	a3 08 66 00 00       	mov    %eax,0x6608
    4559:	a1 08 66 00 00       	mov    0x6608,%eax
    455e:	a3 00 66 00 00       	mov    %eax,0x6600
    base.s.size = 0;
    4563:	c7 05 04 66 00 00 00 	movl   $0x0,0x6604
    456a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    456d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4570:	8b 00                	mov    (%eax),%eax
    4572:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4575:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4578:	8b 40 04             	mov    0x4(%eax),%eax
    457b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    457e:	77 4d                	ja     45cd <malloc+0xaa>
      if(p->s.size == nunits)
    4580:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4583:	8b 40 04             	mov    0x4(%eax),%eax
    4586:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    4589:	75 0c                	jne    4597 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
    458b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    458e:	8b 10                	mov    (%eax),%edx
    4590:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4593:	89 10                	mov    %edx,(%eax)
    4595:	eb 26                	jmp    45bd <malloc+0x9a>
      else {
        p->s.size -= nunits;
    4597:	8b 45 f4             	mov    -0xc(%ebp),%eax
    459a:	8b 40 04             	mov    0x4(%eax),%eax
    459d:	2b 45 ec             	sub    -0x14(%ebp),%eax
    45a0:	89 c2                	mov    %eax,%edx
    45a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    45a5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    45a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    45ab:	8b 40 04             	mov    0x4(%eax),%eax
    45ae:	c1 e0 03             	shl    $0x3,%eax
    45b1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    45b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    45b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    45ba:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    45bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    45c0:	a3 08 66 00 00       	mov    %eax,0x6608
      return (void*)(p + 1);
    45c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    45c8:	83 c0 08             	add    $0x8,%eax
    45cb:	eb 3b                	jmp    4608 <malloc+0xe5>
    }
    if(p == freep)
    45cd:	a1 08 66 00 00       	mov    0x6608,%eax
    45d2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    45d5:	75 1e                	jne    45f5 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
    45d7:	83 ec 0c             	sub    $0xc,%esp
    45da:	ff 75 ec             	pushl  -0x14(%ebp)
    45dd:	e8 dd fe ff ff       	call   44bf <morecore>
    45e2:	83 c4 10             	add    $0x10,%esp
    45e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    45e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    45ec:	75 07                	jne    45f5 <malloc+0xd2>
        return 0;
    45ee:	b8 00 00 00 00       	mov    $0x0,%eax
    45f3:	eb 13                	jmp    4608 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    45f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    45f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    45fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    45fe:	8b 00                	mov    (%eax),%eax
    4600:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4603:	e9 6d ff ff ff       	jmp    4575 <malloc+0x52>
  }
}
    4608:	c9                   	leave  
    4609:	c3                   	ret    
