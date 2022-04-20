
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	f3 0f 1e fb          	endbr32 
       4:	55                   	push   %ebp
       5:	89 e5                	mov    %esp,%ebp
       7:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       e:	75 05                	jne    15 <runcmd+0x15>
    exit();
      10:	e8 35 0f 00 00       	call   f4a <exit>

  switch(cmd->type){
      15:	8b 45 08             	mov    0x8(%ebp),%eax
      18:	8b 00                	mov    (%eax),%eax
      1a:	83 f8 05             	cmp    $0x5,%eax
      1d:	77 0a                	ja     29 <runcmd+0x29>
      1f:	8b 04 85 d4 14 00 00 	mov    0x14d4(,%eax,4),%eax
      26:	3e ff e0             	notrack jmp *%eax
  default:
    panic("runcmd");
      29:	83 ec 0c             	sub    $0xc,%esp
      2c:	68 a8 14 00 00       	push   $0x14a8
      31:	e8 73 03 00 00       	call   3a9 <panic>
      36:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      39:	8b 45 08             	mov    0x8(%ebp),%eax
      3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(ecmd->argv[0] == 0)
      3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      42:	8b 40 04             	mov    0x4(%eax),%eax
      45:	85 c0                	test   %eax,%eax
      47:	75 05                	jne    4e <runcmd+0x4e>
      exit();
      49:	e8 fc 0e 00 00       	call   f4a <exit>
    exec(ecmd->argv[0], ecmd->argv);
      4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      51:	8d 50 04             	lea    0x4(%eax),%edx
      54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      57:	8b 40 04             	mov    0x4(%eax),%eax
      5a:	83 ec 08             	sub    $0x8,%esp
      5d:	52                   	push   %edx
      5e:	50                   	push   %eax
      5f:	e8 1e 0f 00 00       	call   f82 <exec>
      64:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      6a:	8b 40 04             	mov    0x4(%eax),%eax
      6d:	83 ec 04             	sub    $0x4,%esp
      70:	50                   	push   %eax
      71:	68 af 14 00 00       	push   $0x14af
      76:	6a 02                	push   $0x2
      78:	e8 61 10 00 00       	call   10de <printf>
      7d:	83 c4 10             	add    $0x10,%esp
    break;
      80:	e9 c6 01 00 00       	jmp    24b <runcmd+0x24b>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      85:	8b 45 08             	mov    0x8(%ebp),%eax
      88:	89 45 e8             	mov    %eax,-0x18(%ebp)
    close(rcmd->fd);
      8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
      8e:	8b 40 14             	mov    0x14(%eax),%eax
      91:	83 ec 0c             	sub    $0xc,%esp
      94:	50                   	push   %eax
      95:	e8 d8 0e 00 00       	call   f72 <close>
      9a:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
      a0:	8b 50 10             	mov    0x10(%eax),%edx
      a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
      a6:	8b 40 08             	mov    0x8(%eax),%eax
      a9:	83 ec 08             	sub    $0x8,%esp
      ac:	52                   	push   %edx
      ad:	50                   	push   %eax
      ae:	e8 d7 0e 00 00       	call   f8a <open>
      b3:	83 c4 10             	add    $0x10,%esp
      b6:	85 c0                	test   %eax,%eax
      b8:	79 1e                	jns    d8 <runcmd+0xd8>
      printf(2, "open %s failed\n", rcmd->file);
      ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
      bd:	8b 40 08             	mov    0x8(%eax),%eax
      c0:	83 ec 04             	sub    $0x4,%esp
      c3:	50                   	push   %eax
      c4:	68 bf 14 00 00       	push   $0x14bf
      c9:	6a 02                	push   $0x2
      cb:	e8 0e 10 00 00       	call   10de <printf>
      d0:	83 c4 10             	add    $0x10,%esp
      exit();
      d3:	e8 72 0e 00 00       	call   f4a <exit>
    }
    runcmd(rcmd->cmd);
      d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
      db:	8b 40 04             	mov    0x4(%eax),%eax
      de:	83 ec 0c             	sub    $0xc,%esp
      e1:	50                   	push   %eax
      e2:	e8 19 ff ff ff       	call   0 <runcmd>
      e7:	83 c4 10             	add    $0x10,%esp
    break;
      ea:	e9 5c 01 00 00       	jmp    24b <runcmd+0x24b>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ef:	8b 45 08             	mov    0x8(%ebp),%eax
      f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fork1() == 0)
      f5:	e8 d3 02 00 00       	call   3cd <fork1>
      fa:	85 c0                	test   %eax,%eax
      fc:	75 12                	jne    110 <runcmd+0x110>
      runcmd(lcmd->left);
      fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
     101:	8b 40 04             	mov    0x4(%eax),%eax
     104:	83 ec 0c             	sub    $0xc,%esp
     107:	50                   	push   %eax
     108:	e8 f3 fe ff ff       	call   0 <runcmd>
     10d:	83 c4 10             	add    $0x10,%esp
    wait();
     110:	e8 3d 0e 00 00       	call   f52 <wait>
    runcmd(lcmd->right);
     115:	8b 45 f0             	mov    -0x10(%ebp),%eax
     118:	8b 40 08             	mov    0x8(%eax),%eax
     11b:	83 ec 0c             	sub    $0xc,%esp
     11e:	50                   	push   %eax
     11f:	e8 dc fe ff ff       	call   0 <runcmd>
     124:	83 c4 10             	add    $0x10,%esp
    break;
     127:	e9 1f 01 00 00       	jmp    24b <runcmd+0x24b>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     12c:	8b 45 08             	mov    0x8(%ebp),%eax
     12f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pipe(p) < 0)
     132:	83 ec 0c             	sub    $0xc,%esp
     135:	8d 45 dc             	lea    -0x24(%ebp),%eax
     138:	50                   	push   %eax
     139:	e8 1c 0e 00 00       	call   f5a <pipe>
     13e:	83 c4 10             	add    $0x10,%esp
     141:	85 c0                	test   %eax,%eax
     143:	79 10                	jns    155 <runcmd+0x155>
      panic("pipe");
     145:	83 ec 0c             	sub    $0xc,%esp
     148:	68 cf 14 00 00       	push   $0x14cf
     14d:	e8 57 02 00 00       	call   3a9 <panic>
     152:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     155:	e8 73 02 00 00       	call   3cd <fork1>
     15a:	85 c0                	test   %eax,%eax
     15c:	75 4c                	jne    1aa <runcmd+0x1aa>
      close(1);
     15e:	83 ec 0c             	sub    $0xc,%esp
     161:	6a 01                	push   $0x1
     163:	e8 0a 0e 00 00       	call   f72 <close>
     168:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     16b:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16e:	83 ec 0c             	sub    $0xc,%esp
     171:	50                   	push   %eax
     172:	e8 4b 0e 00 00       	call   fc2 <dup>
     177:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     17a:	8b 45 dc             	mov    -0x24(%ebp),%eax
     17d:	83 ec 0c             	sub    $0xc,%esp
     180:	50                   	push   %eax
     181:	e8 ec 0d 00 00       	call   f72 <close>
     186:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     189:	8b 45 e0             	mov    -0x20(%ebp),%eax
     18c:	83 ec 0c             	sub    $0xc,%esp
     18f:	50                   	push   %eax
     190:	e8 dd 0d 00 00       	call   f72 <close>
     195:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     198:	8b 45 ec             	mov    -0x14(%ebp),%eax
     19b:	8b 40 04             	mov    0x4(%eax),%eax
     19e:	83 ec 0c             	sub    $0xc,%esp
     1a1:	50                   	push   %eax
     1a2:	e8 59 fe ff ff       	call   0 <runcmd>
     1a7:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1aa:	e8 1e 02 00 00       	call   3cd <fork1>
     1af:	85 c0                	test   %eax,%eax
     1b1:	75 4c                	jne    1ff <runcmd+0x1ff>
      close(0);
     1b3:	83 ec 0c             	sub    $0xc,%esp
     1b6:	6a 00                	push   $0x0
     1b8:	e8 b5 0d 00 00       	call   f72 <close>
     1bd:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c3:	83 ec 0c             	sub    $0xc,%esp
     1c6:	50                   	push   %eax
     1c7:	e8 f6 0d 00 00       	call   fc2 <dup>
     1cc:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1d2:	83 ec 0c             	sub    $0xc,%esp
     1d5:	50                   	push   %eax
     1d6:	e8 97 0d 00 00       	call   f72 <close>
     1db:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1de:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1e1:	83 ec 0c             	sub    $0xc,%esp
     1e4:	50                   	push   %eax
     1e5:	e8 88 0d 00 00       	call   f72 <close>
     1ea:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
     1f0:	8b 40 08             	mov    0x8(%eax),%eax
     1f3:	83 ec 0c             	sub    $0xc,%esp
     1f6:	50                   	push   %eax
     1f7:	e8 04 fe ff ff       	call   0 <runcmd>
     1fc:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
     202:	83 ec 0c             	sub    $0xc,%esp
     205:	50                   	push   %eax
     206:	e8 67 0d 00 00       	call   f72 <close>
     20b:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     20e:	8b 45 e0             	mov    -0x20(%ebp),%eax
     211:	83 ec 0c             	sub    $0xc,%esp
     214:	50                   	push   %eax
     215:	e8 58 0d 00 00       	call   f72 <close>
     21a:	83 c4 10             	add    $0x10,%esp
    wait();
     21d:	e8 30 0d 00 00       	call   f52 <wait>
    wait();
     222:	e8 2b 0d 00 00       	call   f52 <wait>
    break;
     227:	eb 22                	jmp    24b <runcmd+0x24b>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     229:	8b 45 08             	mov    0x8(%ebp),%eax
     22c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(fork1() == 0)
     22f:	e8 99 01 00 00       	call   3cd <fork1>
     234:	85 c0                	test   %eax,%eax
     236:	75 12                	jne    24a <runcmd+0x24a>
      runcmd(bcmd->cmd);
     238:	8b 45 f4             	mov    -0xc(%ebp),%eax
     23b:	8b 40 04             	mov    0x4(%eax),%eax
     23e:	83 ec 0c             	sub    $0xc,%esp
     241:	50                   	push   %eax
     242:	e8 b9 fd ff ff       	call   0 <runcmd>
     247:	83 c4 10             	add    $0x10,%esp
    break;
     24a:	90                   	nop
  }
  exit();
     24b:	e8 fa 0c 00 00       	call   f4a <exit>

00000250 <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     250:	f3 0f 1e fb          	endbr32 
     254:	55                   	push   %ebp
     255:	89 e5                	mov    %esp,%ebp
     257:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     25a:	83 ec 08             	sub    $0x8,%esp
     25d:	68 ec 14 00 00       	push   $0x14ec
     262:	6a 02                	push   $0x2
     264:	e8 75 0e 00 00       	call   10de <printf>
     269:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     26c:	8b 45 0c             	mov    0xc(%ebp),%eax
     26f:	83 ec 04             	sub    $0x4,%esp
     272:	50                   	push   %eax
     273:	6a 00                	push   $0x0
     275:	ff 75 08             	pushl  0x8(%ebp)
     278:	e8 1a 0b 00 00       	call   d97 <memset>
     27d:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     280:	83 ec 08             	sub    $0x8,%esp
     283:	ff 75 0c             	pushl  0xc(%ebp)
     286:	ff 75 08             	pushl  0x8(%ebp)
     289:	e8 5e 0b 00 00       	call   dec <gets>
     28e:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     291:	8b 45 08             	mov    0x8(%ebp),%eax
     294:	0f b6 00             	movzbl (%eax),%eax
     297:	84 c0                	test   %al,%al
     299:	75 07                	jne    2a2 <getcmd+0x52>
    return -1;
     29b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     2a0:	eb 05                	jmp    2a7 <getcmd+0x57>
  return 0;
     2a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2a7:	c9                   	leave  
     2a8:	c3                   	ret    

000002a9 <main>:

int
main(void)
{
     2a9:	f3 0f 1e fb          	endbr32 
     2ad:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     2b1:	83 e4 f0             	and    $0xfffffff0,%esp
     2b4:	ff 71 fc             	pushl  -0x4(%ecx)
     2b7:	55                   	push   %ebp
     2b8:	89 e5                	mov    %esp,%ebp
     2ba:	51                   	push   %ecx
     2bb:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     2be:	eb 16                	jmp    2d6 <main+0x2d>
    if(fd >= 3){
     2c0:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     2c4:	7e 10                	jle    2d6 <main+0x2d>
      close(fd);
     2c6:	83 ec 0c             	sub    $0xc,%esp
     2c9:	ff 75 f4             	pushl  -0xc(%ebp)
     2cc:	e8 a1 0c 00 00       	call   f72 <close>
     2d1:	83 c4 10             	add    $0x10,%esp
      break;
     2d4:	eb 1b                	jmp    2f1 <main+0x48>
  while((fd = open("console", O_RDWR)) >= 0){
     2d6:	83 ec 08             	sub    $0x8,%esp
     2d9:	6a 02                	push   $0x2
     2db:	68 ef 14 00 00       	push   $0x14ef
     2e0:	e8 a5 0c 00 00       	call   f8a <open>
     2e5:	83 c4 10             	add    $0x10,%esp
     2e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
     2eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2ef:	79 cf                	jns    2c0 <main+0x17>
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2f1:	e9 94 00 00 00       	jmp    38a <main+0xe1>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2f6:	0f b6 05 60 1a 00 00 	movzbl 0x1a60,%eax
     2fd:	3c 63                	cmp    $0x63,%al
     2ff:	75 5f                	jne    360 <main+0xb7>
     301:	0f b6 05 61 1a 00 00 	movzbl 0x1a61,%eax
     308:	3c 64                	cmp    $0x64,%al
     30a:	75 54                	jne    360 <main+0xb7>
     30c:	0f b6 05 62 1a 00 00 	movzbl 0x1a62,%eax
     313:	3c 20                	cmp    $0x20,%al
     315:	75 49                	jne    360 <main+0xb7>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     317:	83 ec 0c             	sub    $0xc,%esp
     31a:	68 60 1a 00 00       	push   $0x1a60
     31f:	e8 48 0a 00 00       	call   d6c <strlen>
     324:	83 c4 10             	add    $0x10,%esp
     327:	83 e8 01             	sub    $0x1,%eax
     32a:	c6 80 60 1a 00 00 00 	movb   $0x0,0x1a60(%eax)
      if(chdir(buf+3) < 0)
     331:	b8 63 1a 00 00       	mov    $0x1a63,%eax
     336:	83 ec 0c             	sub    $0xc,%esp
     339:	50                   	push   %eax
     33a:	e8 7b 0c 00 00       	call   fba <chdir>
     33f:	83 c4 10             	add    $0x10,%esp
     342:	85 c0                	test   %eax,%eax
     344:	79 44                	jns    38a <main+0xe1>
        printf(2, "cannot cd %s\n", buf+3);
     346:	b8 63 1a 00 00       	mov    $0x1a63,%eax
     34b:	83 ec 04             	sub    $0x4,%esp
     34e:	50                   	push   %eax
     34f:	68 f7 14 00 00       	push   $0x14f7
     354:	6a 02                	push   $0x2
     356:	e8 83 0d 00 00       	call   10de <printf>
     35b:	83 c4 10             	add    $0x10,%esp
      continue;
     35e:	eb 2a                	jmp    38a <main+0xe1>
    }
    if(fork1() == 0)
     360:	e8 68 00 00 00       	call   3cd <fork1>
     365:	85 c0                	test   %eax,%eax
     367:	75 1c                	jne    385 <main+0xdc>
      runcmd(parsecmd(buf));
     369:	83 ec 0c             	sub    $0xc,%esp
     36c:	68 60 1a 00 00       	push   $0x1a60
     371:	e8 ce 03 00 00       	call   744 <parsecmd>
     376:	83 c4 10             	add    $0x10,%esp
     379:	83 ec 0c             	sub    $0xc,%esp
     37c:	50                   	push   %eax
     37d:	e8 7e fc ff ff       	call   0 <runcmd>
     382:	83 c4 10             	add    $0x10,%esp
    wait();
     385:	e8 c8 0b 00 00       	call   f52 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     38a:	83 ec 08             	sub    $0x8,%esp
     38d:	6a 64                	push   $0x64
     38f:	68 60 1a 00 00       	push   $0x1a60
     394:	e8 b7 fe ff ff       	call   250 <getcmd>
     399:	83 c4 10             	add    $0x10,%esp
     39c:	85 c0                	test   %eax,%eax
     39e:	0f 89 52 ff ff ff    	jns    2f6 <main+0x4d>
  }
  exit();
     3a4:	e8 a1 0b 00 00       	call   f4a <exit>

000003a9 <panic>:
}

void
panic(char *s)
{
     3a9:	f3 0f 1e fb          	endbr32 
     3ad:	55                   	push   %ebp
     3ae:	89 e5                	mov    %esp,%ebp
     3b0:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     3b3:	83 ec 04             	sub    $0x4,%esp
     3b6:	ff 75 08             	pushl  0x8(%ebp)
     3b9:	68 05 15 00 00       	push   $0x1505
     3be:	6a 02                	push   $0x2
     3c0:	e8 19 0d 00 00       	call   10de <printf>
     3c5:	83 c4 10             	add    $0x10,%esp
  exit();
     3c8:	e8 7d 0b 00 00       	call   f4a <exit>

000003cd <fork1>:
}

int
fork1(void)
{
     3cd:	f3 0f 1e fb          	endbr32 
     3d1:	55                   	push   %ebp
     3d2:	89 e5                	mov    %esp,%ebp
     3d4:	83 ec 18             	sub    $0x18,%esp
  int pid;

  pid = fork();
     3d7:	e8 66 0b 00 00       	call   f42 <fork>
     3dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     3df:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     3e3:	75 10                	jne    3f5 <fork1+0x28>
    panic("fork");
     3e5:	83 ec 0c             	sub    $0xc,%esp
     3e8:	68 09 15 00 00       	push   $0x1509
     3ed:	e8 b7 ff ff ff       	call   3a9 <panic>
     3f2:	83 c4 10             	add    $0x10,%esp
  return pid;
     3f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3f8:	c9                   	leave  
     3f9:	c3                   	ret    

000003fa <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3fa:	f3 0f 1e fb          	endbr32 
     3fe:	55                   	push   %ebp
     3ff:	89 e5                	mov    %esp,%ebp
     401:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     404:	83 ec 0c             	sub    $0xc,%esp
     407:	6a 54                	push   $0x54
     409:	e8 b0 0f 00 00       	call   13be <malloc>
     40e:	83 c4 10             	add    $0x10,%esp
     411:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     414:	83 ec 04             	sub    $0x4,%esp
     417:	6a 54                	push   $0x54
     419:	6a 00                	push   $0x0
     41b:	ff 75 f4             	pushl  -0xc(%ebp)
     41e:	e8 74 09 00 00       	call   d97 <memset>
     423:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     426:	8b 45 f4             	mov    -0xc(%ebp),%eax
     429:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     42f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     432:	c9                   	leave  
     433:	c3                   	ret    

00000434 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     434:	f3 0f 1e fb          	endbr32 
     438:	55                   	push   %ebp
     439:	89 e5                	mov    %esp,%ebp
     43b:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     43e:	83 ec 0c             	sub    $0xc,%esp
     441:	6a 18                	push   $0x18
     443:	e8 76 0f 00 00       	call   13be <malloc>
     448:	83 c4 10             	add    $0x10,%esp
     44b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     44e:	83 ec 04             	sub    $0x4,%esp
     451:	6a 18                	push   $0x18
     453:	6a 00                	push   $0x0
     455:	ff 75 f4             	pushl  -0xc(%ebp)
     458:	e8 3a 09 00 00       	call   d97 <memset>
     45d:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     460:	8b 45 f4             	mov    -0xc(%ebp),%eax
     463:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     469:	8b 45 f4             	mov    -0xc(%ebp),%eax
     46c:	8b 55 08             	mov    0x8(%ebp),%edx
     46f:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     472:	8b 45 f4             	mov    -0xc(%ebp),%eax
     475:	8b 55 0c             	mov    0xc(%ebp),%edx
     478:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     47e:	8b 55 10             	mov    0x10(%ebp),%edx
     481:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     484:	8b 45 f4             	mov    -0xc(%ebp),%eax
     487:	8b 55 14             	mov    0x14(%ebp),%edx
     48a:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     48d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     490:	8b 55 18             	mov    0x18(%ebp),%edx
     493:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     496:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     499:	c9                   	leave  
     49a:	c3                   	ret    

0000049b <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     49b:	f3 0f 1e fb          	endbr32 
     49f:	55                   	push   %ebp
     4a0:	89 e5                	mov    %esp,%ebp
     4a2:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4a5:	83 ec 0c             	sub    $0xc,%esp
     4a8:	6a 0c                	push   $0xc
     4aa:	e8 0f 0f 00 00       	call   13be <malloc>
     4af:	83 c4 10             	add    $0x10,%esp
     4b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4b5:	83 ec 04             	sub    $0x4,%esp
     4b8:	6a 0c                	push   $0xc
     4ba:	6a 00                	push   $0x0
     4bc:	ff 75 f4             	pushl  -0xc(%ebp)
     4bf:	e8 d3 08 00 00       	call   d97 <memset>
     4c4:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     4c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ca:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     4d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d3:	8b 55 08             	mov    0x8(%ebp),%edx
     4d6:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4dc:	8b 55 0c             	mov    0xc(%ebp),%edx
     4df:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4e5:	c9                   	leave  
     4e6:	c3                   	ret    

000004e7 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     4e7:	f3 0f 1e fb          	endbr32 
     4eb:	55                   	push   %ebp
     4ec:	89 e5                	mov    %esp,%ebp
     4ee:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4f1:	83 ec 0c             	sub    $0xc,%esp
     4f4:	6a 0c                	push   $0xc
     4f6:	e8 c3 0e 00 00       	call   13be <malloc>
     4fb:	83 c4 10             	add    $0x10,%esp
     4fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     501:	83 ec 04             	sub    $0x4,%esp
     504:	6a 0c                	push   $0xc
     506:	6a 00                	push   $0x0
     508:	ff 75 f4             	pushl  -0xc(%ebp)
     50b:	e8 87 08 00 00       	call   d97 <memset>
     510:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     513:	8b 45 f4             	mov    -0xc(%ebp),%eax
     516:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     51c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51f:	8b 55 08             	mov    0x8(%ebp),%edx
     522:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     525:	8b 45 f4             	mov    -0xc(%ebp),%eax
     528:	8b 55 0c             	mov    0xc(%ebp),%edx
     52b:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     52e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     531:	c9                   	leave  
     532:	c3                   	ret    

00000533 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     533:	f3 0f 1e fb          	endbr32 
     537:	55                   	push   %ebp
     538:	89 e5                	mov    %esp,%ebp
     53a:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     53d:	83 ec 0c             	sub    $0xc,%esp
     540:	6a 08                	push   $0x8
     542:	e8 77 0e 00 00       	call   13be <malloc>
     547:	83 c4 10             	add    $0x10,%esp
     54a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     54d:	83 ec 04             	sub    $0x4,%esp
     550:	6a 08                	push   $0x8
     552:	6a 00                	push   $0x0
     554:	ff 75 f4             	pushl  -0xc(%ebp)
     557:	e8 3b 08 00 00       	call   d97 <memset>
     55c:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     55f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     562:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     568:	8b 45 f4             	mov    -0xc(%ebp),%eax
     56b:	8b 55 08             	mov    0x8(%ebp),%edx
     56e:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     571:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     574:	c9                   	leave  
     575:	c3                   	ret    

00000576 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     576:	f3 0f 1e fb          	endbr32 
     57a:	55                   	push   %ebp
     57b:	89 e5                	mov    %esp,%ebp
     57d:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;

  s = *ps;
     580:	8b 45 08             	mov    0x8(%ebp),%eax
     583:	8b 00                	mov    (%eax),%eax
     585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     588:	eb 04                	jmp    58e <gettoken+0x18>
    s++;
     58a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     58e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     591:	3b 45 0c             	cmp    0xc(%ebp),%eax
     594:	73 1e                	jae    5b4 <gettoken+0x3e>
     596:	8b 45 f4             	mov    -0xc(%ebp),%eax
     599:	0f b6 00             	movzbl (%eax),%eax
     59c:	0f be c0             	movsbl %al,%eax
     59f:	83 ec 08             	sub    $0x8,%esp
     5a2:	50                   	push   %eax
     5a3:	68 20 1a 00 00       	push   $0x1a20
     5a8:	e8 08 08 00 00       	call   db5 <strchr>
     5ad:	83 c4 10             	add    $0x10,%esp
     5b0:	85 c0                	test   %eax,%eax
     5b2:	75 d6                	jne    58a <gettoken+0x14>
  if(q)
     5b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     5b8:	74 08                	je     5c2 <gettoken+0x4c>
    *q = s;
     5ba:	8b 45 10             	mov    0x10(%ebp),%eax
     5bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
     5c0:	89 10                	mov    %edx,(%eax)
  ret = *s;
     5c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5c5:	0f b6 00             	movzbl (%eax),%eax
     5c8:	0f be c0             	movsbl %al,%eax
     5cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     5ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5d1:	0f b6 00             	movzbl (%eax),%eax
     5d4:	0f be c0             	movsbl %al,%eax
     5d7:	83 f8 7c             	cmp    $0x7c,%eax
     5da:	74 2c                	je     608 <gettoken+0x92>
     5dc:	83 f8 7c             	cmp    $0x7c,%eax
     5df:	7f 48                	jg     629 <gettoken+0xb3>
     5e1:	83 f8 3e             	cmp    $0x3e,%eax
     5e4:	74 28                	je     60e <gettoken+0x98>
     5e6:	83 f8 3e             	cmp    $0x3e,%eax
     5e9:	7f 3e                	jg     629 <gettoken+0xb3>
     5eb:	83 f8 3c             	cmp    $0x3c,%eax
     5ee:	7f 39                	jg     629 <gettoken+0xb3>
     5f0:	83 f8 3b             	cmp    $0x3b,%eax
     5f3:	7d 13                	jge    608 <gettoken+0x92>
     5f5:	83 f8 29             	cmp    $0x29,%eax
     5f8:	7f 2f                	jg     629 <gettoken+0xb3>
     5fa:	83 f8 28             	cmp    $0x28,%eax
     5fd:	7d 09                	jge    608 <gettoken+0x92>
     5ff:	85 c0                	test   %eax,%eax
     601:	74 79                	je     67c <gettoken+0x106>
     603:	83 f8 26             	cmp    $0x26,%eax
     606:	75 21                	jne    629 <gettoken+0xb3>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     608:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     60c:	eb 75                	jmp    683 <gettoken+0x10d>
  case '>':
    s++;
     60e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     612:	8b 45 f4             	mov    -0xc(%ebp),%eax
     615:	0f b6 00             	movzbl (%eax),%eax
     618:	3c 3e                	cmp    $0x3e,%al
     61a:	75 63                	jne    67f <gettoken+0x109>
      ret = '+';
     61c:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     623:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     627:	eb 56                	jmp    67f <gettoken+0x109>
  default:
    ret = 'a';
     629:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     630:	eb 04                	jmp    636 <gettoken+0xc0>
      s++;
     632:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     636:	8b 45 f4             	mov    -0xc(%ebp),%eax
     639:	3b 45 0c             	cmp    0xc(%ebp),%eax
     63c:	73 44                	jae    682 <gettoken+0x10c>
     63e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     641:	0f b6 00             	movzbl (%eax),%eax
     644:	0f be c0             	movsbl %al,%eax
     647:	83 ec 08             	sub    $0x8,%esp
     64a:	50                   	push   %eax
     64b:	68 20 1a 00 00       	push   $0x1a20
     650:	e8 60 07 00 00       	call   db5 <strchr>
     655:	83 c4 10             	add    $0x10,%esp
     658:	85 c0                	test   %eax,%eax
     65a:	75 26                	jne    682 <gettoken+0x10c>
     65c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     65f:	0f b6 00             	movzbl (%eax),%eax
     662:	0f be c0             	movsbl %al,%eax
     665:	83 ec 08             	sub    $0x8,%esp
     668:	50                   	push   %eax
     669:	68 28 1a 00 00       	push   $0x1a28
     66e:	e8 42 07 00 00       	call   db5 <strchr>
     673:	83 c4 10             	add    $0x10,%esp
     676:	85 c0                	test   %eax,%eax
     678:	74 b8                	je     632 <gettoken+0xbc>
    break;
     67a:	eb 06                	jmp    682 <gettoken+0x10c>
    break;
     67c:	90                   	nop
     67d:	eb 04                	jmp    683 <gettoken+0x10d>
    break;
     67f:	90                   	nop
     680:	eb 01                	jmp    683 <gettoken+0x10d>
    break;
     682:	90                   	nop
  }
  if(eq)
     683:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     687:	74 0e                	je     697 <gettoken+0x121>
    *eq = s;
     689:	8b 45 14             	mov    0x14(%ebp),%eax
     68c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     68f:	89 10                	mov    %edx,(%eax)

  while(s < es && strchr(whitespace, *s))
     691:	eb 04                	jmp    697 <gettoken+0x121>
    s++;
     693:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     697:	8b 45 f4             	mov    -0xc(%ebp),%eax
     69a:	3b 45 0c             	cmp    0xc(%ebp),%eax
     69d:	73 1e                	jae    6bd <gettoken+0x147>
     69f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6a2:	0f b6 00             	movzbl (%eax),%eax
     6a5:	0f be c0             	movsbl %al,%eax
     6a8:	83 ec 08             	sub    $0x8,%esp
     6ab:	50                   	push   %eax
     6ac:	68 20 1a 00 00       	push   $0x1a20
     6b1:	e8 ff 06 00 00       	call   db5 <strchr>
     6b6:	83 c4 10             	add    $0x10,%esp
     6b9:	85 c0                	test   %eax,%eax
     6bb:	75 d6                	jne    693 <gettoken+0x11d>
  *ps = s;
     6bd:	8b 45 08             	mov    0x8(%ebp),%eax
     6c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6c3:	89 10                	mov    %edx,(%eax)
  return ret;
     6c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     6c8:	c9                   	leave  
     6c9:	c3                   	ret    

000006ca <peek>:

int
peek(char **ps, char *es, char *toks)
{
     6ca:	f3 0f 1e fb          	endbr32 
     6ce:	55                   	push   %ebp
     6cf:	89 e5                	mov    %esp,%ebp
     6d1:	83 ec 18             	sub    $0x18,%esp
  char *s;

  s = *ps;
     6d4:	8b 45 08             	mov    0x8(%ebp),%eax
     6d7:	8b 00                	mov    (%eax),%eax
     6d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     6dc:	eb 04                	jmp    6e2 <peek+0x18>
    s++;
     6de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     6e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6e8:	73 1e                	jae    708 <peek+0x3e>
     6ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ed:	0f b6 00             	movzbl (%eax),%eax
     6f0:	0f be c0             	movsbl %al,%eax
     6f3:	83 ec 08             	sub    $0x8,%esp
     6f6:	50                   	push   %eax
     6f7:	68 20 1a 00 00       	push   $0x1a20
     6fc:	e8 b4 06 00 00       	call   db5 <strchr>
     701:	83 c4 10             	add    $0x10,%esp
     704:	85 c0                	test   %eax,%eax
     706:	75 d6                	jne    6de <peek+0x14>
  *ps = s;
     708:	8b 45 08             	mov    0x8(%ebp),%eax
     70b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     70e:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     710:	8b 45 f4             	mov    -0xc(%ebp),%eax
     713:	0f b6 00             	movzbl (%eax),%eax
     716:	84 c0                	test   %al,%al
     718:	74 23                	je     73d <peek+0x73>
     71a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     71d:	0f b6 00             	movzbl (%eax),%eax
     720:	0f be c0             	movsbl %al,%eax
     723:	83 ec 08             	sub    $0x8,%esp
     726:	50                   	push   %eax
     727:	ff 75 10             	pushl  0x10(%ebp)
     72a:	e8 86 06 00 00       	call   db5 <strchr>
     72f:	83 c4 10             	add    $0x10,%esp
     732:	85 c0                	test   %eax,%eax
     734:	74 07                	je     73d <peek+0x73>
     736:	b8 01 00 00 00       	mov    $0x1,%eax
     73b:	eb 05                	jmp    742 <peek+0x78>
     73d:	b8 00 00 00 00       	mov    $0x0,%eax
}
     742:	c9                   	leave  
     743:	c3                   	ret    

00000744 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     744:	f3 0f 1e fb          	endbr32 
     748:	55                   	push   %ebp
     749:	89 e5                	mov    %esp,%ebp
     74b:	53                   	push   %ebx
     74c:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     74f:	8b 5d 08             	mov    0x8(%ebp),%ebx
     752:	8b 45 08             	mov    0x8(%ebp),%eax
     755:	83 ec 0c             	sub    $0xc,%esp
     758:	50                   	push   %eax
     759:	e8 0e 06 00 00       	call   d6c <strlen>
     75e:	83 c4 10             	add    $0x10,%esp
     761:	01 d8                	add    %ebx,%eax
     763:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     766:	83 ec 08             	sub    $0x8,%esp
     769:	ff 75 f4             	pushl  -0xc(%ebp)
     76c:	8d 45 08             	lea    0x8(%ebp),%eax
     76f:	50                   	push   %eax
     770:	e8 61 00 00 00       	call   7d6 <parseline>
     775:	83 c4 10             	add    $0x10,%esp
     778:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     77b:	83 ec 04             	sub    $0x4,%esp
     77e:	68 0e 15 00 00       	push   $0x150e
     783:	ff 75 f4             	pushl  -0xc(%ebp)
     786:	8d 45 08             	lea    0x8(%ebp),%eax
     789:	50                   	push   %eax
     78a:	e8 3b ff ff ff       	call   6ca <peek>
     78f:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     792:	8b 45 08             	mov    0x8(%ebp),%eax
     795:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     798:	74 26                	je     7c0 <parsecmd+0x7c>
    printf(2, "leftovers: %s\n", s);
     79a:	8b 45 08             	mov    0x8(%ebp),%eax
     79d:	83 ec 04             	sub    $0x4,%esp
     7a0:	50                   	push   %eax
     7a1:	68 0f 15 00 00       	push   $0x150f
     7a6:	6a 02                	push   $0x2
     7a8:	e8 31 09 00 00       	call   10de <printf>
     7ad:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     7b0:	83 ec 0c             	sub    $0xc,%esp
     7b3:	68 1e 15 00 00       	push   $0x151e
     7b8:	e8 ec fb ff ff       	call   3a9 <panic>
     7bd:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     7c0:	83 ec 0c             	sub    $0xc,%esp
     7c3:	ff 75 f0             	pushl  -0x10(%ebp)
     7c6:	e8 03 04 00 00       	call   bce <nulterminate>
     7cb:	83 c4 10             	add    $0x10,%esp
  return cmd;
     7ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     7d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7d4:	c9                   	leave  
     7d5:	c3                   	ret    

000007d6 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     7d6:	f3 0f 1e fb          	endbr32 
     7da:	55                   	push   %ebp
     7db:	89 e5                	mov    %esp,%ebp
     7dd:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     7e0:	83 ec 08             	sub    $0x8,%esp
     7e3:	ff 75 0c             	pushl  0xc(%ebp)
     7e6:	ff 75 08             	pushl  0x8(%ebp)
     7e9:	e8 99 00 00 00       	call   887 <parsepipe>
     7ee:	83 c4 10             	add    $0x10,%esp
     7f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     7f4:	eb 23                	jmp    819 <parseline+0x43>
    gettoken(ps, es, 0, 0);
     7f6:	6a 00                	push   $0x0
     7f8:	6a 00                	push   $0x0
     7fa:	ff 75 0c             	pushl  0xc(%ebp)
     7fd:	ff 75 08             	pushl  0x8(%ebp)
     800:	e8 71 fd ff ff       	call   576 <gettoken>
     805:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     808:	83 ec 0c             	sub    $0xc,%esp
     80b:	ff 75 f4             	pushl  -0xc(%ebp)
     80e:	e8 20 fd ff ff       	call   533 <backcmd>
     813:	83 c4 10             	add    $0x10,%esp
     816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     819:	83 ec 04             	sub    $0x4,%esp
     81c:	68 25 15 00 00       	push   $0x1525
     821:	ff 75 0c             	pushl  0xc(%ebp)
     824:	ff 75 08             	pushl  0x8(%ebp)
     827:	e8 9e fe ff ff       	call   6ca <peek>
     82c:	83 c4 10             	add    $0x10,%esp
     82f:	85 c0                	test   %eax,%eax
     831:	75 c3                	jne    7f6 <parseline+0x20>
  }
  if(peek(ps, es, ";")){
     833:	83 ec 04             	sub    $0x4,%esp
     836:	68 27 15 00 00       	push   $0x1527
     83b:	ff 75 0c             	pushl  0xc(%ebp)
     83e:	ff 75 08             	pushl  0x8(%ebp)
     841:	e8 84 fe ff ff       	call   6ca <peek>
     846:	83 c4 10             	add    $0x10,%esp
     849:	85 c0                	test   %eax,%eax
     84b:	74 35                	je     882 <parseline+0xac>
    gettoken(ps, es, 0, 0);
     84d:	6a 00                	push   $0x0
     84f:	6a 00                	push   $0x0
     851:	ff 75 0c             	pushl  0xc(%ebp)
     854:	ff 75 08             	pushl  0x8(%ebp)
     857:	e8 1a fd ff ff       	call   576 <gettoken>
     85c:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     85f:	83 ec 08             	sub    $0x8,%esp
     862:	ff 75 0c             	pushl  0xc(%ebp)
     865:	ff 75 08             	pushl  0x8(%ebp)
     868:	e8 69 ff ff ff       	call   7d6 <parseline>
     86d:	83 c4 10             	add    $0x10,%esp
     870:	83 ec 08             	sub    $0x8,%esp
     873:	50                   	push   %eax
     874:	ff 75 f4             	pushl  -0xc(%ebp)
     877:	e8 6b fc ff ff       	call   4e7 <listcmd>
     87c:	83 c4 10             	add    $0x10,%esp
     87f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     882:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     885:	c9                   	leave  
     886:	c3                   	ret    

00000887 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     887:	f3 0f 1e fb          	endbr32 
     88b:	55                   	push   %ebp
     88c:	89 e5                	mov    %esp,%ebp
     88e:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     891:	83 ec 08             	sub    $0x8,%esp
     894:	ff 75 0c             	pushl  0xc(%ebp)
     897:	ff 75 08             	pushl  0x8(%ebp)
     89a:	e8 f8 01 00 00       	call   a97 <parseexec>
     89f:	83 c4 10             	add    $0x10,%esp
     8a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     8a5:	83 ec 04             	sub    $0x4,%esp
     8a8:	68 29 15 00 00       	push   $0x1529
     8ad:	ff 75 0c             	pushl  0xc(%ebp)
     8b0:	ff 75 08             	pushl  0x8(%ebp)
     8b3:	e8 12 fe ff ff       	call   6ca <peek>
     8b8:	83 c4 10             	add    $0x10,%esp
     8bb:	85 c0                	test   %eax,%eax
     8bd:	74 35                	je     8f4 <parsepipe+0x6d>
    gettoken(ps, es, 0, 0);
     8bf:	6a 00                	push   $0x0
     8c1:	6a 00                	push   $0x0
     8c3:	ff 75 0c             	pushl  0xc(%ebp)
     8c6:	ff 75 08             	pushl  0x8(%ebp)
     8c9:	e8 a8 fc ff ff       	call   576 <gettoken>
     8ce:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8d1:	83 ec 08             	sub    $0x8,%esp
     8d4:	ff 75 0c             	pushl  0xc(%ebp)
     8d7:	ff 75 08             	pushl  0x8(%ebp)
     8da:	e8 a8 ff ff ff       	call   887 <parsepipe>
     8df:	83 c4 10             	add    $0x10,%esp
     8e2:	83 ec 08             	sub    $0x8,%esp
     8e5:	50                   	push   %eax
     8e6:	ff 75 f4             	pushl  -0xc(%ebp)
     8e9:	e8 ad fb ff ff       	call   49b <pipecmd>
     8ee:	83 c4 10             	add    $0x10,%esp
     8f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8f7:	c9                   	leave  
     8f8:	c3                   	ret    

000008f9 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8f9:	f3 0f 1e fb          	endbr32 
     8fd:	55                   	push   %ebp
     8fe:	89 e5                	mov    %esp,%ebp
     900:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     903:	e9 ba 00 00 00       	jmp    9c2 <parseredirs+0xc9>
    tok = gettoken(ps, es, 0, 0);
     908:	6a 00                	push   $0x0
     90a:	6a 00                	push   $0x0
     90c:	ff 75 10             	pushl  0x10(%ebp)
     90f:	ff 75 0c             	pushl  0xc(%ebp)
     912:	e8 5f fc ff ff       	call   576 <gettoken>
     917:	83 c4 10             	add    $0x10,%esp
     91a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     91d:	8d 45 ec             	lea    -0x14(%ebp),%eax
     920:	50                   	push   %eax
     921:	8d 45 f0             	lea    -0x10(%ebp),%eax
     924:	50                   	push   %eax
     925:	ff 75 10             	pushl  0x10(%ebp)
     928:	ff 75 0c             	pushl  0xc(%ebp)
     92b:	e8 46 fc ff ff       	call   576 <gettoken>
     930:	83 c4 10             	add    $0x10,%esp
     933:	83 f8 61             	cmp    $0x61,%eax
     936:	74 10                	je     948 <parseredirs+0x4f>
      panic("missing file for redirection");
     938:	83 ec 0c             	sub    $0xc,%esp
     93b:	68 2b 15 00 00       	push   $0x152b
     940:	e8 64 fa ff ff       	call   3a9 <panic>
     945:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     948:	83 7d f4 3e          	cmpl   $0x3e,-0xc(%ebp)
     94c:	74 31                	je     97f <parseredirs+0x86>
     94e:	83 7d f4 3e          	cmpl   $0x3e,-0xc(%ebp)
     952:	7f 6e                	jg     9c2 <parseredirs+0xc9>
     954:	83 7d f4 2b          	cmpl   $0x2b,-0xc(%ebp)
     958:	74 47                	je     9a1 <parseredirs+0xa8>
     95a:	83 7d f4 3c          	cmpl   $0x3c,-0xc(%ebp)
     95e:	75 62                	jne    9c2 <parseredirs+0xc9>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     960:	8b 55 ec             	mov    -0x14(%ebp),%edx
     963:	8b 45 f0             	mov    -0x10(%ebp),%eax
     966:	83 ec 0c             	sub    $0xc,%esp
     969:	6a 00                	push   $0x0
     96b:	6a 00                	push   $0x0
     96d:	52                   	push   %edx
     96e:	50                   	push   %eax
     96f:	ff 75 08             	pushl  0x8(%ebp)
     972:	e8 bd fa ff ff       	call   434 <redircmd>
     977:	83 c4 20             	add    $0x20,%esp
     97a:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     97d:	eb 43                	jmp    9c2 <parseredirs+0xc9>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     97f:	8b 55 ec             	mov    -0x14(%ebp),%edx
     982:	8b 45 f0             	mov    -0x10(%ebp),%eax
     985:	83 ec 0c             	sub    $0xc,%esp
     988:	6a 01                	push   $0x1
     98a:	68 01 02 00 00       	push   $0x201
     98f:	52                   	push   %edx
     990:	50                   	push   %eax
     991:	ff 75 08             	pushl  0x8(%ebp)
     994:	e8 9b fa ff ff       	call   434 <redircmd>
     999:	83 c4 20             	add    $0x20,%esp
     99c:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     99f:	eb 21                	jmp    9c2 <parseredirs+0xc9>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     9a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9a7:	83 ec 0c             	sub    $0xc,%esp
     9aa:	6a 01                	push   $0x1
     9ac:	68 01 02 00 00       	push   $0x201
     9b1:	52                   	push   %edx
     9b2:	50                   	push   %eax
     9b3:	ff 75 08             	pushl  0x8(%ebp)
     9b6:	e8 79 fa ff ff       	call   434 <redircmd>
     9bb:	83 c4 20             	add    $0x20,%esp
     9be:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9c1:	90                   	nop
  while(peek(ps, es, "<>")){
     9c2:	83 ec 04             	sub    $0x4,%esp
     9c5:	68 48 15 00 00       	push   $0x1548
     9ca:	ff 75 10             	pushl  0x10(%ebp)
     9cd:	ff 75 0c             	pushl  0xc(%ebp)
     9d0:	e8 f5 fc ff ff       	call   6ca <peek>
     9d5:	83 c4 10             	add    $0x10,%esp
     9d8:	85 c0                	test   %eax,%eax
     9da:	0f 85 28 ff ff ff    	jne    908 <parseredirs+0xf>
    }
  }
  return cmd;
     9e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9e3:	c9                   	leave  
     9e4:	c3                   	ret    

000009e5 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9e5:	f3 0f 1e fb          	endbr32 
     9e9:	55                   	push   %ebp
     9ea:	89 e5                	mov    %esp,%ebp
     9ec:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     9ef:	83 ec 04             	sub    $0x4,%esp
     9f2:	68 4b 15 00 00       	push   $0x154b
     9f7:	ff 75 0c             	pushl  0xc(%ebp)
     9fa:	ff 75 08             	pushl  0x8(%ebp)
     9fd:	e8 c8 fc ff ff       	call   6ca <peek>
     a02:	83 c4 10             	add    $0x10,%esp
     a05:	85 c0                	test   %eax,%eax
     a07:	75 10                	jne    a19 <parseblock+0x34>
    panic("parseblock");
     a09:	83 ec 0c             	sub    $0xc,%esp
     a0c:	68 4d 15 00 00       	push   $0x154d
     a11:	e8 93 f9 ff ff       	call   3a9 <panic>
     a16:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     a19:	6a 00                	push   $0x0
     a1b:	6a 00                	push   $0x0
     a1d:	ff 75 0c             	pushl  0xc(%ebp)
     a20:	ff 75 08             	pushl  0x8(%ebp)
     a23:	e8 4e fb ff ff       	call   576 <gettoken>
     a28:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     a2b:	83 ec 08             	sub    $0x8,%esp
     a2e:	ff 75 0c             	pushl  0xc(%ebp)
     a31:	ff 75 08             	pushl  0x8(%ebp)
     a34:	e8 9d fd ff ff       	call   7d6 <parseline>
     a39:	83 c4 10             	add    $0x10,%esp
     a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     a3f:	83 ec 04             	sub    $0x4,%esp
     a42:	68 58 15 00 00       	push   $0x1558
     a47:	ff 75 0c             	pushl  0xc(%ebp)
     a4a:	ff 75 08             	pushl  0x8(%ebp)
     a4d:	e8 78 fc ff ff       	call   6ca <peek>
     a52:	83 c4 10             	add    $0x10,%esp
     a55:	85 c0                	test   %eax,%eax
     a57:	75 10                	jne    a69 <parseblock+0x84>
    panic("syntax - missing )");
     a59:	83 ec 0c             	sub    $0xc,%esp
     a5c:	68 5a 15 00 00       	push   $0x155a
     a61:	e8 43 f9 ff ff       	call   3a9 <panic>
     a66:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     a69:	6a 00                	push   $0x0
     a6b:	6a 00                	push   $0x0
     a6d:	ff 75 0c             	pushl  0xc(%ebp)
     a70:	ff 75 08             	pushl  0x8(%ebp)
     a73:	e8 fe fa ff ff       	call   576 <gettoken>
     a78:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     a7b:	83 ec 04             	sub    $0x4,%esp
     a7e:	ff 75 0c             	pushl  0xc(%ebp)
     a81:	ff 75 08             	pushl  0x8(%ebp)
     a84:	ff 75 f4             	pushl  -0xc(%ebp)
     a87:	e8 6d fe ff ff       	call   8f9 <parseredirs>
     a8c:	83 c4 10             	add    $0x10,%esp
     a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     a95:	c9                   	leave  
     a96:	c3                   	ret    

00000a97 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     a97:	f3 0f 1e fb          	endbr32 
     a9b:	55                   	push   %ebp
     a9c:	89 e5                	mov    %esp,%ebp
     a9e:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     aa1:	83 ec 04             	sub    $0x4,%esp
     aa4:	68 4b 15 00 00       	push   $0x154b
     aa9:	ff 75 0c             	pushl  0xc(%ebp)
     aac:	ff 75 08             	pushl  0x8(%ebp)
     aaf:	e8 16 fc ff ff       	call   6ca <peek>
     ab4:	83 c4 10             	add    $0x10,%esp
     ab7:	85 c0                	test   %eax,%eax
     ab9:	74 16                	je     ad1 <parseexec+0x3a>
    return parseblock(ps, es);
     abb:	83 ec 08             	sub    $0x8,%esp
     abe:	ff 75 0c             	pushl  0xc(%ebp)
     ac1:	ff 75 08             	pushl  0x8(%ebp)
     ac4:	e8 1c ff ff ff       	call   9e5 <parseblock>
     ac9:	83 c4 10             	add    $0x10,%esp
     acc:	e9 fb 00 00 00       	jmp    bcc <parseexec+0x135>

  ret = execcmd();
     ad1:	e8 24 f9 ff ff       	call   3fa <execcmd>
     ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     adc:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     adf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     ae6:	83 ec 04             	sub    $0x4,%esp
     ae9:	ff 75 0c             	pushl  0xc(%ebp)
     aec:	ff 75 08             	pushl  0x8(%ebp)
     aef:	ff 75 f0             	pushl  -0x10(%ebp)
     af2:	e8 02 fe ff ff       	call   8f9 <parseredirs>
     af7:	83 c4 10             	add    $0x10,%esp
     afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     afd:	e9 87 00 00 00       	jmp    b89 <parseexec+0xf2>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b02:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b05:	50                   	push   %eax
     b06:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b09:	50                   	push   %eax
     b0a:	ff 75 0c             	pushl  0xc(%ebp)
     b0d:	ff 75 08             	pushl  0x8(%ebp)
     b10:	e8 61 fa ff ff       	call   576 <gettoken>
     b15:	83 c4 10             	add    $0x10,%esp
     b18:	89 45 e8             	mov    %eax,-0x18(%ebp)
     b1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b1f:	0f 84 84 00 00 00    	je     ba9 <parseexec+0x112>
      break;
    if(tok != 'a')
     b25:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     b29:	74 10                	je     b3b <parseexec+0xa4>
      panic("syntax");
     b2b:	83 ec 0c             	sub    $0xc,%esp
     b2e:	68 1e 15 00 00       	push   $0x151e
     b33:	e8 71 f8 ff ff       	call   3a9 <panic>
     b38:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     b3b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b44:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b48:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b4e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b51:	83 c1 08             	add    $0x8,%ecx
     b54:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     b58:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     b5c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     b60:	7e 10                	jle    b72 <parseexec+0xdb>
      panic("too many args");
     b62:	83 ec 0c             	sub    $0xc,%esp
     b65:	68 6d 15 00 00       	push   $0x156d
     b6a:	e8 3a f8 ff ff       	call   3a9 <panic>
     b6f:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     b72:	83 ec 04             	sub    $0x4,%esp
     b75:	ff 75 0c             	pushl  0xc(%ebp)
     b78:	ff 75 08             	pushl  0x8(%ebp)
     b7b:	ff 75 f0             	pushl  -0x10(%ebp)
     b7e:	e8 76 fd ff ff       	call   8f9 <parseredirs>
     b83:	83 c4 10             	add    $0x10,%esp
     b86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b89:	83 ec 04             	sub    $0x4,%esp
     b8c:	68 7b 15 00 00       	push   $0x157b
     b91:	ff 75 0c             	pushl  0xc(%ebp)
     b94:	ff 75 08             	pushl  0x8(%ebp)
     b97:	e8 2e fb ff ff       	call   6ca <peek>
     b9c:	83 c4 10             	add    $0x10,%esp
     b9f:	85 c0                	test   %eax,%eax
     ba1:	0f 84 5b ff ff ff    	je     b02 <parseexec+0x6b>
     ba7:	eb 01                	jmp    baa <parseexec+0x113>
      break;
     ba9:	90                   	nop
  }
  cmd->argv[argc] = 0;
     baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bad:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bb0:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     bb7:	00 
  cmd->eargv[argc] = 0;
     bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bbe:	83 c2 08             	add    $0x8,%edx
     bc1:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     bc8:	00 
  return ret;
     bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     bcc:	c9                   	leave  
     bcd:	c3                   	ret    

00000bce <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     bce:	f3 0f 1e fb          	endbr32 
     bd2:	55                   	push   %ebp
     bd3:	89 e5                	mov    %esp,%ebp
     bd5:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     bd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     bdc:	75 0a                	jne    be8 <nulterminate+0x1a>
    return 0;
     bde:	b8 00 00 00 00       	mov    $0x0,%eax
     be3:	e9 e5 00 00 00       	jmp    ccd <nulterminate+0xff>

  switch(cmd->type){
     be8:	8b 45 08             	mov    0x8(%ebp),%eax
     beb:	8b 00                	mov    (%eax),%eax
     bed:	83 f8 05             	cmp    $0x5,%eax
     bf0:	0f 87 d4 00 00 00    	ja     cca <nulterminate+0xfc>
     bf6:	8b 04 85 80 15 00 00 	mov    0x1580(,%eax,4),%eax
     bfd:	3e ff e0             	notrack jmp *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     c00:	8b 45 08             	mov    0x8(%ebp),%eax
     c03:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     c06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c0d:	eb 14                	jmp    c23 <nulterminate+0x55>
      *ecmd->eargv[i] = 0;
     c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c15:	83 c2 08             	add    $0x8,%edx
     c18:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     c1c:	c6 00 00             	movb   $0x0,(%eax)
    for(i=0; ecmd->argv[i]; i++)
     c1f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c29:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c2d:	85 c0                	test   %eax,%eax
     c2f:	75 de                	jne    c0f <nulterminate+0x41>
    break;
     c31:	e9 94 00 00 00       	jmp    cca <nulterminate+0xfc>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     c36:	8b 45 08             	mov    0x8(%ebp),%eax
     c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(rcmd->cmd);
     c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c3f:	8b 40 04             	mov    0x4(%eax),%eax
     c42:	83 ec 0c             	sub    $0xc,%esp
     c45:	50                   	push   %eax
     c46:	e8 83 ff ff ff       	call   bce <nulterminate>
     c4b:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c51:	8b 40 0c             	mov    0xc(%eax),%eax
     c54:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c57:	eb 71                	jmp    cca <nulterminate+0xfc>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c59:	8b 45 08             	mov    0x8(%ebp),%eax
     c5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c62:	8b 40 04             	mov    0x4(%eax),%eax
     c65:	83 ec 0c             	sub    $0xc,%esp
     c68:	50                   	push   %eax
     c69:	e8 60 ff ff ff       	call   bce <nulterminate>
     c6e:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c74:	8b 40 08             	mov    0x8(%eax),%eax
     c77:	83 ec 0c             	sub    $0xc,%esp
     c7a:	50                   	push   %eax
     c7b:	e8 4e ff ff ff       	call   bce <nulterminate>
     c80:	83 c4 10             	add    $0x10,%esp
    break;
     c83:	eb 45                	jmp    cca <nulterminate+0xfc>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     c85:	8b 45 08             	mov    0x8(%ebp),%eax
     c88:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(lcmd->left);
     c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c8e:	8b 40 04             	mov    0x4(%eax),%eax
     c91:	83 ec 0c             	sub    $0xc,%esp
     c94:	50                   	push   %eax
     c95:	e8 34 ff ff ff       	call   bce <nulterminate>
     c9a:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ca0:	8b 40 08             	mov    0x8(%eax),%eax
     ca3:	83 ec 0c             	sub    $0xc,%esp
     ca6:	50                   	push   %eax
     ca7:	e8 22 ff ff ff       	call   bce <nulterminate>
     cac:	83 c4 10             	add    $0x10,%esp
    break;
     caf:	eb 19                	jmp    cca <nulterminate+0xfc>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     cb1:	8b 45 08             	mov    0x8(%ebp),%eax
     cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    nulterminate(bcmd->cmd);
     cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cba:	8b 40 04             	mov    0x4(%eax),%eax
     cbd:	83 ec 0c             	sub    $0xc,%esp
     cc0:	50                   	push   %eax
     cc1:	e8 08 ff ff ff       	call   bce <nulterminate>
     cc6:	83 c4 10             	add    $0x10,%esp
    break;
     cc9:	90                   	nop
  }
  return cmd;
     cca:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ccd:	c9                   	leave  
     cce:	c3                   	ret    

00000ccf <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     ccf:	55                   	push   %ebp
     cd0:	89 e5                	mov    %esp,%ebp
     cd2:	57                   	push   %edi
     cd3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     cd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
     cd7:	8b 55 10             	mov    0x10(%ebp),%edx
     cda:	8b 45 0c             	mov    0xc(%ebp),%eax
     cdd:	89 cb                	mov    %ecx,%ebx
     cdf:	89 df                	mov    %ebx,%edi
     ce1:	89 d1                	mov    %edx,%ecx
     ce3:	fc                   	cld    
     ce4:	f3 aa                	rep stos %al,%es:(%edi)
     ce6:	89 ca                	mov    %ecx,%edx
     ce8:	89 fb                	mov    %edi,%ebx
     cea:	89 5d 08             	mov    %ebx,0x8(%ebp)
     ced:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     cf0:	90                   	nop
     cf1:	5b                   	pop    %ebx
     cf2:	5f                   	pop    %edi
     cf3:	5d                   	pop    %ebp
     cf4:	c3                   	ret    

00000cf5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     cf5:	f3 0f 1e fb          	endbr32 
     cf9:	55                   	push   %ebp
     cfa:	89 e5                	mov    %esp,%ebp
     cfc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     cff:	8b 45 08             	mov    0x8(%ebp),%eax
     d02:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d05:	90                   	nop
     d06:	8b 55 0c             	mov    0xc(%ebp),%edx
     d09:	8d 42 01             	lea    0x1(%edx),%eax
     d0c:	89 45 0c             	mov    %eax,0xc(%ebp)
     d0f:	8b 45 08             	mov    0x8(%ebp),%eax
     d12:	8d 48 01             	lea    0x1(%eax),%ecx
     d15:	89 4d 08             	mov    %ecx,0x8(%ebp)
     d18:	0f b6 12             	movzbl (%edx),%edx
     d1b:	88 10                	mov    %dl,(%eax)
     d1d:	0f b6 00             	movzbl (%eax),%eax
     d20:	84 c0                	test   %al,%al
     d22:	75 e2                	jne    d06 <strcpy+0x11>
    ;
  return os;
     d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d27:	c9                   	leave  
     d28:	c3                   	ret    

00000d29 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d29:	f3 0f 1e fb          	endbr32 
     d2d:	55                   	push   %ebp
     d2e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     d30:	eb 08                	jmp    d3a <strcmp+0x11>
    p++, q++;
     d32:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d36:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
     d3a:	8b 45 08             	mov    0x8(%ebp),%eax
     d3d:	0f b6 00             	movzbl (%eax),%eax
     d40:	84 c0                	test   %al,%al
     d42:	74 10                	je     d54 <strcmp+0x2b>
     d44:	8b 45 08             	mov    0x8(%ebp),%eax
     d47:	0f b6 10             	movzbl (%eax),%edx
     d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
     d4d:	0f b6 00             	movzbl (%eax),%eax
     d50:	38 c2                	cmp    %al,%dl
     d52:	74 de                	je     d32 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
     d54:	8b 45 08             	mov    0x8(%ebp),%eax
     d57:	0f b6 00             	movzbl (%eax),%eax
     d5a:	0f b6 d0             	movzbl %al,%edx
     d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
     d60:	0f b6 00             	movzbl (%eax),%eax
     d63:	0f b6 c0             	movzbl %al,%eax
     d66:	29 c2                	sub    %eax,%edx
     d68:	89 d0                	mov    %edx,%eax
}
     d6a:	5d                   	pop    %ebp
     d6b:	c3                   	ret    

00000d6c <strlen>:

uint
strlen(const char *s)
{
     d6c:	f3 0f 1e fb          	endbr32 
     d70:	55                   	push   %ebp
     d71:	89 e5                	mov    %esp,%ebp
     d73:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d7d:	eb 04                	jmp    d83 <strlen+0x17>
     d7f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d83:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d86:	8b 45 08             	mov    0x8(%ebp),%eax
     d89:	01 d0                	add    %edx,%eax
     d8b:	0f b6 00             	movzbl (%eax),%eax
     d8e:	84 c0                	test   %al,%al
     d90:	75 ed                	jne    d7f <strlen+0x13>
    ;
  return n;
     d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d95:	c9                   	leave  
     d96:	c3                   	ret    

00000d97 <memset>:

void*
memset(void *dst, int c, uint n)
{
     d97:	f3 0f 1e fb          	endbr32 
     d9b:	55                   	push   %ebp
     d9c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     d9e:	8b 45 10             	mov    0x10(%ebp),%eax
     da1:	50                   	push   %eax
     da2:	ff 75 0c             	pushl  0xc(%ebp)
     da5:	ff 75 08             	pushl  0x8(%ebp)
     da8:	e8 22 ff ff ff       	call   ccf <stosb>
     dad:	83 c4 0c             	add    $0xc,%esp
  return dst;
     db0:	8b 45 08             	mov    0x8(%ebp),%eax
}
     db3:	c9                   	leave  
     db4:	c3                   	ret    

00000db5 <strchr>:

char*
strchr(const char *s, char c)
{
     db5:	f3 0f 1e fb          	endbr32 
     db9:	55                   	push   %ebp
     dba:	89 e5                	mov    %esp,%ebp
     dbc:	83 ec 04             	sub    $0x4,%esp
     dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
     dc2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     dc5:	eb 14                	jmp    ddb <strchr+0x26>
    if(*s == c)
     dc7:	8b 45 08             	mov    0x8(%ebp),%eax
     dca:	0f b6 00             	movzbl (%eax),%eax
     dcd:	38 45 fc             	cmp    %al,-0x4(%ebp)
     dd0:	75 05                	jne    dd7 <strchr+0x22>
      return (char*)s;
     dd2:	8b 45 08             	mov    0x8(%ebp),%eax
     dd5:	eb 13                	jmp    dea <strchr+0x35>
  for(; *s; s++)
     dd7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     ddb:	8b 45 08             	mov    0x8(%ebp),%eax
     dde:	0f b6 00             	movzbl (%eax),%eax
     de1:	84 c0                	test   %al,%al
     de3:	75 e2                	jne    dc7 <strchr+0x12>
  return 0;
     de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
     dea:	c9                   	leave  
     deb:	c3                   	ret    

00000dec <gets>:

char*
gets(char *buf, int max)
{
     dec:	f3 0f 1e fb          	endbr32 
     df0:	55                   	push   %ebp
     df1:	89 e5                	mov    %esp,%ebp
     df3:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     df6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     dfd:	eb 42                	jmp    e41 <gets+0x55>
    cc = read(0, &c, 1);
     dff:	83 ec 04             	sub    $0x4,%esp
     e02:	6a 01                	push   $0x1
     e04:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e07:	50                   	push   %eax
     e08:	6a 00                	push   $0x0
     e0a:	e8 53 01 00 00       	call   f62 <read>
     e0f:	83 c4 10             	add    $0x10,%esp
     e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e19:	7e 33                	jle    e4e <gets+0x62>
      break;
    buf[i++] = c;
     e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e1e:	8d 50 01             	lea    0x1(%eax),%edx
     e21:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e24:	89 c2                	mov    %eax,%edx
     e26:	8b 45 08             	mov    0x8(%ebp),%eax
     e29:	01 c2                	add    %eax,%edx
     e2b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e2f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     e31:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e35:	3c 0a                	cmp    $0xa,%al
     e37:	74 16                	je     e4f <gets+0x63>
     e39:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e3d:	3c 0d                	cmp    $0xd,%al
     e3f:	74 0e                	je     e4f <gets+0x63>
  for(i=0; i+1 < max; ){
     e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e44:	83 c0 01             	add    $0x1,%eax
     e47:	39 45 0c             	cmp    %eax,0xc(%ebp)
     e4a:	7f b3                	jg     dff <gets+0x13>
     e4c:	eb 01                	jmp    e4f <gets+0x63>
      break;
     e4e:	90                   	nop
      break;
  }
  buf[i] = '\0';
     e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e52:	8b 45 08             	mov    0x8(%ebp),%eax
     e55:	01 d0                	add    %edx,%eax
     e57:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     e5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e5d:	c9                   	leave  
     e5e:	c3                   	ret    

00000e5f <stat>:

int
stat(const char *n, struct stat *st)
{
     e5f:	f3 0f 1e fb          	endbr32 
     e63:	55                   	push   %ebp
     e64:	89 e5                	mov    %esp,%ebp
     e66:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e69:	83 ec 08             	sub    $0x8,%esp
     e6c:	6a 00                	push   $0x0
     e6e:	ff 75 08             	pushl  0x8(%ebp)
     e71:	e8 14 01 00 00       	call   f8a <open>
     e76:	83 c4 10             	add    $0x10,%esp
     e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     e7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e80:	79 07                	jns    e89 <stat+0x2a>
    return -1;
     e82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e87:	eb 25                	jmp    eae <stat+0x4f>
  r = fstat(fd, st);
     e89:	83 ec 08             	sub    $0x8,%esp
     e8c:	ff 75 0c             	pushl  0xc(%ebp)
     e8f:	ff 75 f4             	pushl  -0xc(%ebp)
     e92:	e8 0b 01 00 00       	call   fa2 <fstat>
     e97:	83 c4 10             	add    $0x10,%esp
     e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     e9d:	83 ec 0c             	sub    $0xc,%esp
     ea0:	ff 75 f4             	pushl  -0xc(%ebp)
     ea3:	e8 ca 00 00 00       	call   f72 <close>
     ea8:	83 c4 10             	add    $0x10,%esp
  return r;
     eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     eae:	c9                   	leave  
     eaf:	c3                   	ret    

00000eb0 <atoi>:

int
atoi(const char *s)
{
     eb0:	f3 0f 1e fb          	endbr32 
     eb4:	55                   	push   %ebp
     eb5:	89 e5                	mov    %esp,%ebp
     eb7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     eba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     ec1:	eb 25                	jmp    ee8 <atoi+0x38>
    n = n*10 + *s++ - '0';
     ec3:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ec6:	89 d0                	mov    %edx,%eax
     ec8:	c1 e0 02             	shl    $0x2,%eax
     ecb:	01 d0                	add    %edx,%eax
     ecd:	01 c0                	add    %eax,%eax
     ecf:	89 c1                	mov    %eax,%ecx
     ed1:	8b 45 08             	mov    0x8(%ebp),%eax
     ed4:	8d 50 01             	lea    0x1(%eax),%edx
     ed7:	89 55 08             	mov    %edx,0x8(%ebp)
     eda:	0f b6 00             	movzbl (%eax),%eax
     edd:	0f be c0             	movsbl %al,%eax
     ee0:	01 c8                	add    %ecx,%eax
     ee2:	83 e8 30             	sub    $0x30,%eax
     ee5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     ee8:	8b 45 08             	mov    0x8(%ebp),%eax
     eeb:	0f b6 00             	movzbl (%eax),%eax
     eee:	3c 2f                	cmp    $0x2f,%al
     ef0:	7e 0a                	jle    efc <atoi+0x4c>
     ef2:	8b 45 08             	mov    0x8(%ebp),%eax
     ef5:	0f b6 00             	movzbl (%eax),%eax
     ef8:	3c 39                	cmp    $0x39,%al
     efa:	7e c7                	jle    ec3 <atoi+0x13>
  return n;
     efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     eff:	c9                   	leave  
     f00:	c3                   	ret    

00000f01 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     f01:	f3 0f 1e fb          	endbr32 
     f05:	55                   	push   %ebp
     f06:	89 e5                	mov    %esp,%ebp
     f08:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
     f0b:	8b 45 08             	mov    0x8(%ebp),%eax
     f0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     f11:	8b 45 0c             	mov    0xc(%ebp),%eax
     f14:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     f17:	eb 17                	jmp    f30 <memmove+0x2f>
    *dst++ = *src++;
     f19:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f1c:	8d 42 01             	lea    0x1(%edx),%eax
     f1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
     f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f25:	8d 48 01             	lea    0x1(%eax),%ecx
     f28:	89 4d fc             	mov    %ecx,-0x4(%ebp)
     f2b:	0f b6 12             	movzbl (%edx),%edx
     f2e:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
     f30:	8b 45 10             	mov    0x10(%ebp),%eax
     f33:	8d 50 ff             	lea    -0x1(%eax),%edx
     f36:	89 55 10             	mov    %edx,0x10(%ebp)
     f39:	85 c0                	test   %eax,%eax
     f3b:	7f dc                	jg     f19 <memmove+0x18>
  return vdst;
     f3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f40:	c9                   	leave  
     f41:	c3                   	ret    

00000f42 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f42:	b8 01 00 00 00       	mov    $0x1,%eax
     f47:	cd 40                	int    $0x40
     f49:	c3                   	ret    

00000f4a <exit>:
SYSCALL(exit)
     f4a:	b8 02 00 00 00       	mov    $0x2,%eax
     f4f:	cd 40                	int    $0x40
     f51:	c3                   	ret    

00000f52 <wait>:
SYSCALL(wait)
     f52:	b8 03 00 00 00       	mov    $0x3,%eax
     f57:	cd 40                	int    $0x40
     f59:	c3                   	ret    

00000f5a <pipe>:
SYSCALL(pipe)
     f5a:	b8 04 00 00 00       	mov    $0x4,%eax
     f5f:	cd 40                	int    $0x40
     f61:	c3                   	ret    

00000f62 <read>:
SYSCALL(read)
     f62:	b8 05 00 00 00       	mov    $0x5,%eax
     f67:	cd 40                	int    $0x40
     f69:	c3                   	ret    

00000f6a <write>:
SYSCALL(write)
     f6a:	b8 10 00 00 00       	mov    $0x10,%eax
     f6f:	cd 40                	int    $0x40
     f71:	c3                   	ret    

00000f72 <close>:
SYSCALL(close)
     f72:	b8 15 00 00 00       	mov    $0x15,%eax
     f77:	cd 40                	int    $0x40
     f79:	c3                   	ret    

00000f7a <kill>:
SYSCALL(kill)
     f7a:	b8 06 00 00 00       	mov    $0x6,%eax
     f7f:	cd 40                	int    $0x40
     f81:	c3                   	ret    

00000f82 <exec>:
SYSCALL(exec)
     f82:	b8 07 00 00 00       	mov    $0x7,%eax
     f87:	cd 40                	int    $0x40
     f89:	c3                   	ret    

00000f8a <open>:
SYSCALL(open)
     f8a:	b8 0f 00 00 00       	mov    $0xf,%eax
     f8f:	cd 40                	int    $0x40
     f91:	c3                   	ret    

00000f92 <mknod>:
SYSCALL(mknod)
     f92:	b8 11 00 00 00       	mov    $0x11,%eax
     f97:	cd 40                	int    $0x40
     f99:	c3                   	ret    

00000f9a <unlink>:
SYSCALL(unlink)
     f9a:	b8 12 00 00 00       	mov    $0x12,%eax
     f9f:	cd 40                	int    $0x40
     fa1:	c3                   	ret    

00000fa2 <fstat>:
SYSCALL(fstat)
     fa2:	b8 08 00 00 00       	mov    $0x8,%eax
     fa7:	cd 40                	int    $0x40
     fa9:	c3                   	ret    

00000faa <link>:
SYSCALL(link)
     faa:	b8 13 00 00 00       	mov    $0x13,%eax
     faf:	cd 40                	int    $0x40
     fb1:	c3                   	ret    

00000fb2 <mkdir>:
SYSCALL(mkdir)
     fb2:	b8 14 00 00 00       	mov    $0x14,%eax
     fb7:	cd 40                	int    $0x40
     fb9:	c3                   	ret    

00000fba <chdir>:
SYSCALL(chdir)
     fba:	b8 09 00 00 00       	mov    $0x9,%eax
     fbf:	cd 40                	int    $0x40
     fc1:	c3                   	ret    

00000fc2 <dup>:
SYSCALL(dup)
     fc2:	b8 0a 00 00 00       	mov    $0xa,%eax
     fc7:	cd 40                	int    $0x40
     fc9:	c3                   	ret    

00000fca <getpid>:
SYSCALL(getpid)
     fca:	b8 0b 00 00 00       	mov    $0xb,%eax
     fcf:	cd 40                	int    $0x40
     fd1:	c3                   	ret    

00000fd2 <sbrk>:
SYSCALL(sbrk)
     fd2:	b8 0c 00 00 00       	mov    $0xc,%eax
     fd7:	cd 40                	int    $0x40
     fd9:	c3                   	ret    

00000fda <sleep>:
SYSCALL(sleep)
     fda:	b8 0d 00 00 00       	mov    $0xd,%eax
     fdf:	cd 40                	int    $0x40
     fe1:	c3                   	ret    

00000fe2 <uptime>:
SYSCALL(uptime)
     fe2:	b8 0e 00 00 00       	mov    $0xe,%eax
     fe7:	cd 40                	int    $0x40
     fe9:	c3                   	ret    

00000fea <mencrypt>:
SYSCALL(mencrypt)
     fea:	b8 16 00 00 00       	mov    $0x16,%eax
     fef:	cd 40                	int    $0x40
     ff1:	c3                   	ret    

00000ff2 <getpgtable>:
SYSCALL(getpgtable)
     ff2:	b8 17 00 00 00       	mov    $0x17,%eax
     ff7:	cd 40                	int    $0x40
     ff9:	c3                   	ret    

00000ffa <dump_rawphymem>:
SYSCALL(dump_rawphymem)
     ffa:	b8 18 00 00 00       	mov    $0x18,%eax
     fff:	cd 40                	int    $0x40
    1001:	c3                   	ret    

00001002 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1002:	f3 0f 1e fb          	endbr32 
    1006:	55                   	push   %ebp
    1007:	89 e5                	mov    %esp,%ebp
    1009:	83 ec 18             	sub    $0x18,%esp
    100c:	8b 45 0c             	mov    0xc(%ebp),%eax
    100f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1012:	83 ec 04             	sub    $0x4,%esp
    1015:	6a 01                	push   $0x1
    1017:	8d 45 f4             	lea    -0xc(%ebp),%eax
    101a:	50                   	push   %eax
    101b:	ff 75 08             	pushl  0x8(%ebp)
    101e:	e8 47 ff ff ff       	call   f6a <write>
    1023:	83 c4 10             	add    $0x10,%esp
}
    1026:	90                   	nop
    1027:	c9                   	leave  
    1028:	c3                   	ret    

00001029 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1029:	f3 0f 1e fb          	endbr32 
    102d:	55                   	push   %ebp
    102e:	89 e5                	mov    %esp,%ebp
    1030:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1033:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    103a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    103e:	74 17                	je     1057 <printint+0x2e>
    1040:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1044:	79 11                	jns    1057 <printint+0x2e>
    neg = 1;
    1046:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    104d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1050:	f7 d8                	neg    %eax
    1052:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1055:	eb 06                	jmp    105d <printint+0x34>
  } else {
    x = xx;
    1057:	8b 45 0c             	mov    0xc(%ebp),%eax
    105a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    105d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1064:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1067:	8b 45 ec             	mov    -0x14(%ebp),%eax
    106a:	ba 00 00 00 00       	mov    $0x0,%edx
    106f:	f7 f1                	div    %ecx
    1071:	89 d1                	mov    %edx,%ecx
    1073:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1076:	8d 50 01             	lea    0x1(%eax),%edx
    1079:	89 55 f4             	mov    %edx,-0xc(%ebp)
    107c:	0f b6 91 30 1a 00 00 	movzbl 0x1a30(%ecx),%edx
    1083:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
    1087:	8b 4d 10             	mov    0x10(%ebp),%ecx
    108a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    108d:	ba 00 00 00 00       	mov    $0x0,%edx
    1092:	f7 f1                	div    %ecx
    1094:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1097:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    109b:	75 c7                	jne    1064 <printint+0x3b>
  if(neg)
    109d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10a1:	74 2d                	je     10d0 <printint+0xa7>
    buf[i++] = '-';
    10a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10a6:	8d 50 01             	lea    0x1(%eax),%edx
    10a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
    10ac:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    10b1:	eb 1d                	jmp    10d0 <printint+0xa7>
    putc(fd, buf[i]);
    10b3:	8d 55 dc             	lea    -0x24(%ebp),%edx
    10b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10b9:	01 d0                	add    %edx,%eax
    10bb:	0f b6 00             	movzbl (%eax),%eax
    10be:	0f be c0             	movsbl %al,%eax
    10c1:	83 ec 08             	sub    $0x8,%esp
    10c4:	50                   	push   %eax
    10c5:	ff 75 08             	pushl  0x8(%ebp)
    10c8:	e8 35 ff ff ff       	call   1002 <putc>
    10cd:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
    10d0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    10d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10d8:	79 d9                	jns    10b3 <printint+0x8a>
}
    10da:	90                   	nop
    10db:	90                   	nop
    10dc:	c9                   	leave  
    10dd:	c3                   	ret    

000010de <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    10de:	f3 0f 1e fb          	endbr32 
    10e2:	55                   	push   %ebp
    10e3:	89 e5                	mov    %esp,%ebp
    10e5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    10e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    10ef:	8d 45 0c             	lea    0xc(%ebp),%eax
    10f2:	83 c0 04             	add    $0x4,%eax
    10f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    10f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    10ff:	e9 59 01 00 00       	jmp    125d <printf+0x17f>
    c = fmt[i] & 0xff;
    1104:	8b 55 0c             	mov    0xc(%ebp),%edx
    1107:	8b 45 f0             	mov    -0x10(%ebp),%eax
    110a:	01 d0                	add    %edx,%eax
    110c:	0f b6 00             	movzbl (%eax),%eax
    110f:	0f be c0             	movsbl %al,%eax
    1112:	25 ff 00 00 00       	and    $0xff,%eax
    1117:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    111a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    111e:	75 2c                	jne    114c <printf+0x6e>
      if(c == '%'){
    1120:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1124:	75 0c                	jne    1132 <printf+0x54>
        state = '%';
    1126:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    112d:	e9 27 01 00 00       	jmp    1259 <printf+0x17b>
      } else {
        putc(fd, c);
    1132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1135:	0f be c0             	movsbl %al,%eax
    1138:	83 ec 08             	sub    $0x8,%esp
    113b:	50                   	push   %eax
    113c:	ff 75 08             	pushl  0x8(%ebp)
    113f:	e8 be fe ff ff       	call   1002 <putc>
    1144:	83 c4 10             	add    $0x10,%esp
    1147:	e9 0d 01 00 00       	jmp    1259 <printf+0x17b>
      }
    } else if(state == '%'){
    114c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1150:	0f 85 03 01 00 00    	jne    1259 <printf+0x17b>
      if(c == 'd'){
    1156:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    115a:	75 1e                	jne    117a <printf+0x9c>
        printint(fd, *ap, 10, 1);
    115c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    115f:	8b 00                	mov    (%eax),%eax
    1161:	6a 01                	push   $0x1
    1163:	6a 0a                	push   $0xa
    1165:	50                   	push   %eax
    1166:	ff 75 08             	pushl  0x8(%ebp)
    1169:	e8 bb fe ff ff       	call   1029 <printint>
    116e:	83 c4 10             	add    $0x10,%esp
        ap++;
    1171:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1175:	e9 d8 00 00 00       	jmp    1252 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
    117a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    117e:	74 06                	je     1186 <printf+0xa8>
    1180:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1184:	75 1e                	jne    11a4 <printf+0xc6>
        printint(fd, *ap, 16, 0);
    1186:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1189:	8b 00                	mov    (%eax),%eax
    118b:	6a 00                	push   $0x0
    118d:	6a 10                	push   $0x10
    118f:	50                   	push   %eax
    1190:	ff 75 08             	pushl  0x8(%ebp)
    1193:	e8 91 fe ff ff       	call   1029 <printint>
    1198:	83 c4 10             	add    $0x10,%esp
        ap++;
    119b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    119f:	e9 ae 00 00 00       	jmp    1252 <printf+0x174>
      } else if(c == 's'){
    11a4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    11a8:	75 43                	jne    11ed <printf+0x10f>
        s = (char*)*ap;
    11aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11ad:	8b 00                	mov    (%eax),%eax
    11af:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    11b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    11b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11ba:	75 25                	jne    11e1 <printf+0x103>
          s = "(null)";
    11bc:	c7 45 f4 98 15 00 00 	movl   $0x1598,-0xc(%ebp)
        while(*s != 0){
    11c3:	eb 1c                	jmp    11e1 <printf+0x103>
          putc(fd, *s);
    11c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c8:	0f b6 00             	movzbl (%eax),%eax
    11cb:	0f be c0             	movsbl %al,%eax
    11ce:	83 ec 08             	sub    $0x8,%esp
    11d1:	50                   	push   %eax
    11d2:	ff 75 08             	pushl  0x8(%ebp)
    11d5:	e8 28 fe ff ff       	call   1002 <putc>
    11da:	83 c4 10             	add    $0x10,%esp
          s++;
    11dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    11e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11e4:	0f b6 00             	movzbl (%eax),%eax
    11e7:	84 c0                	test   %al,%al
    11e9:	75 da                	jne    11c5 <printf+0xe7>
    11eb:	eb 65                	jmp    1252 <printf+0x174>
        }
      } else if(c == 'c'){
    11ed:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    11f1:	75 1d                	jne    1210 <printf+0x132>
        putc(fd, *ap);
    11f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11f6:	8b 00                	mov    (%eax),%eax
    11f8:	0f be c0             	movsbl %al,%eax
    11fb:	83 ec 08             	sub    $0x8,%esp
    11fe:	50                   	push   %eax
    11ff:	ff 75 08             	pushl  0x8(%ebp)
    1202:	e8 fb fd ff ff       	call   1002 <putc>
    1207:	83 c4 10             	add    $0x10,%esp
        ap++;
    120a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    120e:	eb 42                	jmp    1252 <printf+0x174>
      } else if(c == '%'){
    1210:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1214:	75 17                	jne    122d <printf+0x14f>
        putc(fd, c);
    1216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1219:	0f be c0             	movsbl %al,%eax
    121c:	83 ec 08             	sub    $0x8,%esp
    121f:	50                   	push   %eax
    1220:	ff 75 08             	pushl  0x8(%ebp)
    1223:	e8 da fd ff ff       	call   1002 <putc>
    1228:	83 c4 10             	add    $0x10,%esp
    122b:	eb 25                	jmp    1252 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    122d:	83 ec 08             	sub    $0x8,%esp
    1230:	6a 25                	push   $0x25
    1232:	ff 75 08             	pushl  0x8(%ebp)
    1235:	e8 c8 fd ff ff       	call   1002 <putc>
    123a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    123d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1240:	0f be c0             	movsbl %al,%eax
    1243:	83 ec 08             	sub    $0x8,%esp
    1246:	50                   	push   %eax
    1247:	ff 75 08             	pushl  0x8(%ebp)
    124a:	e8 b3 fd ff ff       	call   1002 <putc>
    124f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1252:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    1259:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    125d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1260:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1263:	01 d0                	add    %edx,%eax
    1265:	0f b6 00             	movzbl (%eax),%eax
    1268:	84 c0                	test   %al,%al
    126a:	0f 85 94 fe ff ff    	jne    1104 <printf+0x26>
    }
  }
}
    1270:	90                   	nop
    1271:	90                   	nop
    1272:	c9                   	leave  
    1273:	c3                   	ret    

00001274 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1274:	f3 0f 1e fb          	endbr32 
    1278:	55                   	push   %ebp
    1279:	89 e5                	mov    %esp,%ebp
    127b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    127e:	8b 45 08             	mov    0x8(%ebp),%eax
    1281:	83 e8 08             	sub    $0x8,%eax
    1284:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1287:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    128c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    128f:	eb 24                	jmp    12b5 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1291:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1294:	8b 00                	mov    (%eax),%eax
    1296:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    1299:	72 12                	jb     12ad <free+0x39>
    129b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    129e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12a1:	77 24                	ja     12c7 <free+0x53>
    12a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a6:	8b 00                	mov    (%eax),%eax
    12a8:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    12ab:	72 1a                	jb     12c7 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b0:	8b 00                	mov    (%eax),%eax
    12b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12bb:	76 d4                	jbe    1291 <free+0x1d>
    12bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c0:	8b 00                	mov    (%eax),%eax
    12c2:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    12c5:	73 ca                	jae    1291 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    12c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12ca:	8b 40 04             	mov    0x4(%eax),%eax
    12cd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    12d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12d7:	01 c2                	add    %eax,%edx
    12d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12dc:	8b 00                	mov    (%eax),%eax
    12de:	39 c2                	cmp    %eax,%edx
    12e0:	75 24                	jne    1306 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
    12e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12e5:	8b 50 04             	mov    0x4(%eax),%edx
    12e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12eb:	8b 00                	mov    (%eax),%eax
    12ed:	8b 40 04             	mov    0x4(%eax),%eax
    12f0:	01 c2                	add    %eax,%edx
    12f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12f5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    12f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12fb:	8b 00                	mov    (%eax),%eax
    12fd:	8b 10                	mov    (%eax),%edx
    12ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1302:	89 10                	mov    %edx,(%eax)
    1304:	eb 0a                	jmp    1310 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
    1306:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1309:	8b 10                	mov    (%eax),%edx
    130b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    130e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1310:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1313:	8b 40 04             	mov    0x4(%eax),%eax
    1316:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    131d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1320:	01 d0                	add    %edx,%eax
    1322:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    1325:	75 20                	jne    1347 <free+0xd3>
    p->s.size += bp->s.size;
    1327:	8b 45 fc             	mov    -0x4(%ebp),%eax
    132a:	8b 50 04             	mov    0x4(%eax),%edx
    132d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1330:	8b 40 04             	mov    0x4(%eax),%eax
    1333:	01 c2                	add    %eax,%edx
    1335:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1338:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    133b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    133e:	8b 10                	mov    (%eax),%edx
    1340:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1343:	89 10                	mov    %edx,(%eax)
    1345:	eb 08                	jmp    134f <free+0xdb>
  } else
    p->s.ptr = bp;
    1347:	8b 45 fc             	mov    -0x4(%ebp),%eax
    134a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    134d:	89 10                	mov    %edx,(%eax)
  freep = p;
    134f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1352:	a3 cc 1a 00 00       	mov    %eax,0x1acc
}
    1357:	90                   	nop
    1358:	c9                   	leave  
    1359:	c3                   	ret    

0000135a <morecore>:

static Header*
morecore(uint nu)
{
    135a:	f3 0f 1e fb          	endbr32 
    135e:	55                   	push   %ebp
    135f:	89 e5                	mov    %esp,%ebp
    1361:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1364:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    136b:	77 07                	ja     1374 <morecore+0x1a>
    nu = 4096;
    136d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1374:	8b 45 08             	mov    0x8(%ebp),%eax
    1377:	c1 e0 03             	shl    $0x3,%eax
    137a:	83 ec 0c             	sub    $0xc,%esp
    137d:	50                   	push   %eax
    137e:	e8 4f fc ff ff       	call   fd2 <sbrk>
    1383:	83 c4 10             	add    $0x10,%esp
    1386:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1389:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    138d:	75 07                	jne    1396 <morecore+0x3c>
    return 0;
    138f:	b8 00 00 00 00       	mov    $0x0,%eax
    1394:	eb 26                	jmp    13bc <morecore+0x62>
  hp = (Header*)p;
    1396:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1399:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    139c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    139f:	8b 55 08             	mov    0x8(%ebp),%edx
    13a2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    13a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13a8:	83 c0 08             	add    $0x8,%eax
    13ab:	83 ec 0c             	sub    $0xc,%esp
    13ae:	50                   	push   %eax
    13af:	e8 c0 fe ff ff       	call   1274 <free>
    13b4:	83 c4 10             	add    $0x10,%esp
  return freep;
    13b7:	a1 cc 1a 00 00       	mov    0x1acc,%eax
}
    13bc:	c9                   	leave  
    13bd:	c3                   	ret    

000013be <malloc>:

void*
malloc(uint nbytes)
{
    13be:	f3 0f 1e fb          	endbr32 
    13c2:	55                   	push   %ebp
    13c3:	89 e5                	mov    %esp,%ebp
    13c5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13c8:	8b 45 08             	mov    0x8(%ebp),%eax
    13cb:	83 c0 07             	add    $0x7,%eax
    13ce:	c1 e8 03             	shr    $0x3,%eax
    13d1:	83 c0 01             	add    $0x1,%eax
    13d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    13d7:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    13dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13e3:	75 23                	jne    1408 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
    13e5:	c7 45 f0 c4 1a 00 00 	movl   $0x1ac4,-0x10(%ebp)
    13ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13ef:	a3 cc 1a 00 00       	mov    %eax,0x1acc
    13f4:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    13f9:	a3 c4 1a 00 00       	mov    %eax,0x1ac4
    base.s.size = 0;
    13fe:	c7 05 c8 1a 00 00 00 	movl   $0x0,0x1ac8
    1405:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1408:	8b 45 f0             	mov    -0x10(%ebp),%eax
    140b:	8b 00                	mov    (%eax),%eax
    140d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1410:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1413:	8b 40 04             	mov    0x4(%eax),%eax
    1416:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    1419:	77 4d                	ja     1468 <malloc+0xaa>
      if(p->s.size == nunits)
    141b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141e:	8b 40 04             	mov    0x4(%eax),%eax
    1421:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    1424:	75 0c                	jne    1432 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
    1426:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1429:	8b 10                	mov    (%eax),%edx
    142b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    142e:	89 10                	mov    %edx,(%eax)
    1430:	eb 26                	jmp    1458 <malloc+0x9a>
      else {
        p->s.size -= nunits;
    1432:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1435:	8b 40 04             	mov    0x4(%eax),%eax
    1438:	2b 45 ec             	sub    -0x14(%ebp),%eax
    143b:	89 c2                	mov    %eax,%edx
    143d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1440:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1443:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1446:	8b 40 04             	mov    0x4(%eax),%eax
    1449:	c1 e0 03             	shl    $0x3,%eax
    144c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    144f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1452:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1455:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1458:	8b 45 f0             	mov    -0x10(%ebp),%eax
    145b:	a3 cc 1a 00 00       	mov    %eax,0x1acc
      return (void*)(p + 1);
    1460:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1463:	83 c0 08             	add    $0x8,%eax
    1466:	eb 3b                	jmp    14a3 <malloc+0xe5>
    }
    if(p == freep)
    1468:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    146d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1470:	75 1e                	jne    1490 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
    1472:	83 ec 0c             	sub    $0xc,%esp
    1475:	ff 75 ec             	pushl  -0x14(%ebp)
    1478:	e8 dd fe ff ff       	call   135a <morecore>
    147d:	83 c4 10             	add    $0x10,%esp
    1480:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1487:	75 07                	jne    1490 <malloc+0xd2>
        return 0;
    1489:	b8 00 00 00 00       	mov    $0x0,%eax
    148e:	eb 13                	jmp    14a3 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1490:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1493:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1496:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1499:	8b 00                	mov    (%eax),%eax
    149b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    149e:	e9 6d ff ff ff       	jmp    1410 <malloc+0x52>
  }
}
    14a3:	c9                   	leave  
    14a4:	c3                   	ret    
