﻿//программа для изучения слов
Uses GraphABC;
Uses Bot;
type en_word=record
 ru:string;
 en:string;
 status: string; //последовательность нулей и едениц. 0 - верно. 1 - неверно ответил. 
 kol: integer; //количество ответов, данных с последнего раза, когда спрашивалось это слово.
end;
type button=record
  name: string;
  P:picture;
  P1:picture; //активированная версия кнопки
  onn: boolean;
  butt: boolean; //если true кнопка будет меняться при наведении
  R: string;
  url: string; 
  x,y: integer; 
end;
type words=record
    kol: integer;
  w:array[1..10000] of en_word;
end;
type anim=record
  kol:integer;
  P:array[1..30] of Picture;
  sleep: integer;
end;
var P: array[1..100] of button;
var kol: integer;
var login: string;
var Regim: string; 
var kol_exp: array[1..51] of integer;
var exp: integer; //текущее количество опыта
var exp_pic: picture;
var pos_exp: integer; //последнее количество опыта
var exp_full,exp_nill: picture;
var card: anim;
var GoAnim: boolean; //что бы клики по экрану не работали во время анимации
var Kard: array[1..6] of picture;
var fon: picture;
var W: words; //изучаемые слова
var TrW: words; //изученные слова
var FaW: words; //неизвестные слова
var StrW,StrTW,StrFW: integer; //текущая страница в словаре
var kategory:array[1..17] of integer; //время между вопросами в минутах

const limit=50; //максимальное количестков изучаемых слов (в первых 5 категориях суммарно)

type Question=record
  kat: integer;
  id: integer; 
end;
var a: array[1..4] of array[1..2] of Question;

Function GetExp(): picture; //возвращает текущее изображение шкалы оптыта
var i,r,Sum,lv,gran: integer;
var P: picture;
begin
  Sum:=exp;
  for i:=1 to 30 do if Sum>kol_exp[i] then begin
  Sum:=Sum-kol_exp[i];
  end else if Lv=0 then Lv:=i;

 
  if pos_exp=exp then GetExp:=exp_pic else begin
  Sum:=exp;
  for i:=1 to 30 do if Sum>kol_exp[i] then begin
  Sum:=Sum-kol_exp[i];
  end else if Lv=0 then Lv:=i;
//Lv - текущий уровнь
//Sum - остаток опыта
//kol_exp[Lv+1] - требуется опыта
gran:=Round((exp_full.Width-47*2)*(Sum/kol_exp[Lv+1])+47);
P:=new Picture(exp_full.Width,exp_full.Height);
for i:=0 to exp_full.Width-1 do 
  for r:=0 to exp_full.Height-1 do begin
    if i<gran then P.SetPixel(i,r,exp_full.GetPixel(i,r)) else P.SetPixel(i,r,exp_nill.GetPixel(i,r));
    
    end;
    P.TextOut(P.Height div 2,P.Width div 2,Sum+' / '+kol_exp[Lv+1]);
    P.transpcolor:=P.GetPixel(1,1);
    P.Transparent:=true;
    pos_exp:=exp;
    exp_pic:=P;
    GetExp:=P;
  end;
  
  
end;

Procedure Dob(name,R,url: string; x,y: integer);  //добавляет новую кнопку с текстурой name видной в режиме R с url по клику и координатой x,y
var b: boolean;
var i: integer;
begin
  kol:=kol+1;
  P[kol].name:=name;
 b:=true;
  if fileexists('image/'+name+'.bmp') then begin P[kol].P:=new picture('image/'+name+'.bmp'); b:=false; end;
  if fileexists('image/'+name+'.png') then begin P[kol].P:=new picture('image/'+name+'.png'); b:=false; end;
  if fileexists('image/'+name+'.jpg') then begin P[kol].P:=new picture('image/'+name+'.jpg'); b:=false; end;
  if b then P[kol].P:=new Picture(1,1);
  P[kol].P.Transparent:=true;
  P[kol].R:=R;
  P[kol].url:=url;
  P[kol].x:=x;
  P[kol].y:=y;
  P[kol].butt:=false;
  
P[kol].P1:=new Picture(P[kol].P.Height,P[kol].P.Width);

 
end;
Procedure Dob(name,R,url: string; x,y: integer; butt:boolean);  //добавляет новую кнопку с текстурой name видной в режиме R с url по клику и координатой x,y
var b: boolean;
var i,g: integer;
var p1: picture;
var c: color;
Function Preobr(PP: picture): picture;
var i,h,r,g,b: byte;
var c: color;
var P1: picture;
begin
P1:=new Picture(PP.Width,PP.Height);  
for i:=0 to P1.Width-1 do
  for h:=0 to P1.Height-1 do begin
    c:=PP.GetPixel(i,h);
    r:=(GetRed(c));
    g:=(GetGreen(c));
    b:=(GetBlue(c));
    P1.SetPixel(i,h,RGB(g,r,b));
  end;


//if r<235 then r:=r+20;
//if g<235 then g:=g+20;
//if b<235 then b:=b+20;

  Preobr:=P1;

end;
begin
  kol:=kol+1;
  P[kol].name:=name;
 b:=true;
  if fileexists('image/'+name+'.bmp') then begin P[kol].P:=new picture('image/'+name+'.bmp'); b:=false; end;
  if fileexists('image/'+name+'.png') then begin P[kol].P:=new picture('image/'+name+'.png'); b:=false; end;
  if fileexists('image/'+name+'.jpg') then begin P[kol].P:=new picture('image/'+name+'.jpg'); b:=false; end;
  if b then P[kol].P:=new Picture(1,1);
  P[kol].P.Transparent:=true;
  P[kol].R:=R;
  P[kol].url:=url;
  P[kol].x:=x;
  P[kol].y:=y;
  P[kol].butt:=butt;
  


{ 
 P[kol].P1:=Preobr(P[kol].P);
 P[kol].P1.Transparent:=false;
 }
end;
Procedure Dob(name:picture; R,url: string; x,y: integer);  //добавляет новую кнопку с текстурой name видной в режиме R с url по клику и координатой x,y
begin
  kol:=kol+1;
  P[kol].name:=nil;
  P[kol].P:=name;
  P[kol].R:=R;
  P[kol].url:=url;
  P[kol].x:=x;
  P[kol].y:=y;
end;

Function intstr(s: string): int64;
var i,r,sum: int64;
begin
  for i:=1 to length(s) do 
    for r:=0 to 9 do if s[i]=r+'' then sum:=sum*10+r;
  intstr:=sum;
end;

Function ReadStr(s:string): en_word; //превращает строку с информаццией в переменную английского слова
var e: en_word;
var r: integer;
var kat: string;
begin
//формат строки
//abandon -- отказываться, покидать, прекращать ++@@1
e.en:=copy(s,1,pos('--',s)-1);
r:=pos('++',s)-pos('--',s)-2;
if pos('++',s)=0 then r:=length(s);
e.ru:=copy(s,pos('--',s)+2,r);
e.status:=copy(s,pos('++',s)+2,pos('@@',s)-pos('++',s)-2);
kat:=copy(s,pos('@@',s)+2,length(s));
e.kol:=intStr(kat);
if e.kol=0 then e.kol:=1;
ReadStr:=e;
end;


Procedure Save(); //сохраняет слова в файлы
var i,r: integer;
var wor: en_word;
var t: text;
begin

  assign(t,'word.txt');
  rewrite(t);
  for r:=1 to W.kol do begin
  wor:=W.w[r];
  write(t,wor.en+'--'+wor.ru+'++'+wor.status+'@@'+wor.kol);
  if r<W.kol then writeln(t,'');
  end;
  
  close(t);
  
end;

Procedure RisAnim(A:anim; x,y: integer);
var i,r: integer;
var P: picture;
begin
SaveWindow('image/backap.bmp');
P:=new Picture('image/backap.bmp');
GoAnim:=true;
for i:=1 to A.kol do begin
//LoadWindow('image/backap.bmp'); 
P.Draw(0,0);
A.P[i].Draw(x,y);
redraw();
sleep(A.sleep);
end;  
  GoAnim:=false;
end;
Procedure Ris();
var i,r: integer;
var CB: picture;
procedure lline(x1,y1,x2,y2: integer);
var i,x,y,a: integer;
begin
  for i:=1 to (((x2-x1)+(y2-y1)))*7 do begin
  x:=random((x2-x1)+6)+x1-3;
  y:=random((y2-y1)+6)+y1-4;
  if x1=x2 then a:=(x1-x)*(x1-x)
  else a:=(y1-y)*(y1-y);
  setpixel(x,y,ARGB(a*5,255,0,0));
  end;

end;
function Pr(s: string): string;
var i: integer; var ss: string; begin for i:=1 to length(s) do ss:=ss+'*'; Pr:=ss;end; //создаём последовательность звёздочк

begin
  fon.Draw(0,0);
for i:=1 to kol do if P[i].R=Regim then begin
  P[i].P.Draw(P[i].x,P[i].y);

if P[i].onn then for r:=1 to 5 do begin
  lline(P[i].x,P[i].y,P[i].x+P[i].P.Width,P[i].y);
  lline(P[i].x,P[i].y,P[i].x,P[i].y+P[i].P.Height);
  lline(P[i].x+P[i].P.Width,P[i].y,P[i].x+P[i].P.Width,P[i].y+P[i].P.Height);
  lline(P[i].x,P[i].y+P[i].P.Height,P[i].x+P[i].P.Width,P[i].y+P[i].P.Height);
  end;

end;

if Regim='home' then GetExp.Draw(70,20);
if (Regim=('Неизвестные слова')) or (Regim=('Изучаемые слова')) or (Regim=('Выученные слова')) then begin
  setpencolor(clGreen); 
  setbrushcolor(RGB(128,34,240));
  for r:=0 to 10 do line(70,120+r*((fon.Height-200) div 11),fon.Width-70,120+r*((fon.Height-200) div 11));
  line(70,120,70,120+r*((fon.Height-200) div 11));
  line(120,120,120,120+r*((fon.Height-200) div 11));
  line(460,120,460,120+r*((fon.Height-200) div 11));
  line(900,120,900,120+r*((fon.Height-200) div 11));
  line(fon.Width-70,120,fon.Width-70,120+r*((fon.Height-200) div 11));
  if StrW<1 then StrW:=1;
  if StrW>((W.kol-1) div 10)+1 then StrW:=((W.kol-1) div 10)+1;
  if StrTW<1 then StrTW:=1;
  if StrTW>((TrW.kol-1) div 10)+1 then StrTW:=((TrW.kol-1) div 10)+1;
  if StrFW<1 then StrFW:=1;
  if StrFW>((FaW.kol-1) div 10)+1 then StrFW:=((FaW.kol-1) div 10)+1;
//выводим слова в таблицу  
if (Regim=('Неизвестные слова')) then begin
SetFontColor(clRed);
  for r:=StrFW*10-9 to StrFW*10 do begin
    SetFontSize(20);
    DrawTextCentered(95,(120+(((r-1) mod 10)+1)*((fon.Height-200) div 11)-20),r);
    DrawTextCentered(290,(120+(((r-1) mod 10)+1)*((fon.Height-200) div 11)-20),FaW.w[r].en);
    SetFontSize(15);
    DrawTextCentered(680,(120+(((r-1) mod 10)+1)*((fon.Height-200) div 11)-20),FaW.w[r].ru);
  end;
end;
if (Regim=('Изучаемые слова')) then begin
SetFontColor(clBlue);
  for r:=StrW*10-9 to StrW*10 do begin
    SetFontSize(20);
    DrawTextCentered(95,(120+(((r-1) mod 10)+1)*((fon.Height-200) div 11)-20),r);
    DrawTextCentered(290,(120+(((r-1) mod 10)+1)*((fon.Height-200) div 11)-20),W.w[r].en);
    SetFontSize(15);
    DrawTextCentered(680,(120+(((r-1) mod 10)+1)*((fon.Height-200) div 11)-20),W.w[r].ru);
  end;
end;
if (Regim=('Выученные слова')) then begin
SetFontColor(clGreen);
  for r:=StrTW*10-9 to StrTW*10 do begin
    SetFontSize(20);
    DrawTextCentered(95,(120+(((r-1) mod 10)+1)*((fon.Height-200) div 11)-20),r);
    DrawTextCentered(290,(120+(((r-1) mod 10)+1)*((fon.Height-200) div 11)-20),TrW.w[r].en);
    SetFontSize(15);
    DrawTextCentered(680,(120+(((r-1) mod 10)+1)*((fon.Height-200) div 11)-20),TrW.w[r].ru);
  end;
end;

end;

textout(10,10,Regim);

  redraw();
end;
Procedure MouseKey(x,y,mb: integer);
var i: integer;
Procedure Used(s: string); //совершает действие S
var b: boolean;
var i: integer;
begin
  if s<>'nill' then begin

  case s of
  'W-': StrW:=StrW-1;
  'W+': StrW:=StrW+1;
  'WT-': StrTW:=StrTW-1;
  'WT+': StrTW:=StrTW+1;
  'WF-': StrFW:=StrFW-1;
  'WF+': StrFW:=StrFW+1;
  else Regim:=s;
  
  end;
  Ris();
end;
end;
begin
  for i:=1 to kol do if Regim=P[i].R then 
    if (p[i].x<=x) and (p[i].y<=y) and ((P[i].x+P[i].P.Width)>=x) and ((P[i].y+P[i].P.Height)>=y) then if P[i].url<>'' then begin
    used(P[i].url);
    break;
  end;

end;
Procedure MouseMove(x, y, mb: integer);
var i: integer;
begin
  for i:=1 to kol do if Regim=P[i].R then if P[i].butt then 
    if (p[i].x<=x) and (p[i].y<=y) and ((P[i].x+P[i].P.Width)>=x) and ((P[i].y+P[i].P.Height)>=y) then begin
    if P[i].onn=false then begin P[i].onn:=true; Ris(); end;
end else if P[i].onn=true then begin P[i].onn:=false; Ris(); end;


end;



Procedure Start();
var t: text;
var str: string;
var i,r,x1,x2,y,dx,a,b: integer;
begin
  //считываем анимацию карт
  for i:=1 to 22 do card.P[i]:=new Picture('image\card\'+i+'.png');
  for i:=1 to 22 do card.P[i].Transparent:=true;
  card.kol:=22;
  card.sleep:=20;
  //считываем словарь
    assign(t,'word.txt');
    reset(t);
    while not(eof(t)) do begin
      readln(t,str);
      W.kol:=W.kol+1;
      W.w[W.kol]:=ReadStr(str);
    end;
    assign(t,'true_word.txt');
    reset(t);
    while not(eof(t)) do begin
      readln(t,str);
      TrW.kol:=TrW.kol+1;
      TrW.w[TrW.kol]:=ReadStr(str);
    end;
    close(t);
       assign(t,'false_word.txt');
    reset(t);
    while not(eof(t)) do begin
      readln(t,str);
      FaW.kol:=FaW.kol+1;
      FaW.w[FaW.kol]:=ReadStr(str);
    end;
    close(t);
    //количество опыта для уровней
  kol_exp[1]:=1;
  kol_exp[2]:=10;
  kol_exp[3]:=10;
  kol_exp[4]:=15;
  kol_exp[5]:=20;
  kol_exp[6]:=20;
  kol_exp[7]:=30;
  kol_exp[8]:=50;
  kol_exp[9]:=60;
  kol_exp[10]:=70;
  kol_exp[11]:=80;
  kol_exp[12]:=90;
  kol_exp[13]:=100;
  kol_exp[14]:=120;
  kol_exp[15]:=140;
  kol_exp[16]:=160;
  kol_exp[17]:=180;
  kol_exp[18]:=200;
  kol_exp[19]:=230;
  kol_exp[20]:=260;
  kol_exp[21]:=300;
  kol_exp[22]:=350;
  kol_exp[23]:=400;
  kol_exp[24]:=475;
  kol_exp[25]:=550;
  kol_exp[26]:=675;
  kol_exp[27]:=750;
  kol_exp[28]:=900;
  kol_exp[29]:=1100;
  kol_exp[30]:=1300;
  kol_exp[31]:=1500;
  kol_exp[32]:=1750;
  kol_exp[33]:=2000;
  kol_exp[34]:=2500;
  kol_exp[35]:=3000;
  kol_exp[36]:=3500;
  kol_exp[37]:=4000;
  kol_exp[38]:=4500;
  kol_exp[39]:=5000;
  kol_exp[40]:=6000;
  kol_exp[41]:=7000;
  kol_exp[42]:=8000;
  kol_exp[43]:=9000;
  kol_exp[44]:=10000;
  kol_exp[45]:=12500;
  kol_exp[46]:=15000;
  kol_exp[47]:=17500;
  kol_exp[48]:=20000;
  kol_exp[49]:=22500;
  kol_exp[50]:=25000;
  fon:=new Picture('image/fon.jpg');
  exp_full:=new picture('image/progressbar.png');
  exp_nill:=new picture('image/progressbar2.png');
  exp:=1;
  setfontcolor(clWhite);
  SetFontStyle(fsBold);
  lockdrawing();
  OnMouseDown:=MouseKey;
  OnResize:=Ris;
  SetWindowSize(1188,678);
  SetWindowIsFixedSize(true);
  SetWindowCaption('CoreCraft');
  CenterWindow();
  SetBrushColor(RGB(162,127,231));
  SetFontSize(10);
  setpenStyle(psClear);
  Regim:='home';
  setbrushstyle(bsclear);

//Основное окно
   Dob('fon','home','',0,0); //фон
   Dob('settings','home','settings',fon.Width-120,50,true); //кнопка настроек
   Dob('Профиль','home','Профиль',50,50,true); //кнопка профиля
   
   Dob('Словарь','home','Словарь',(fon.Width-180*3)div 4,(fon.Height-180*2) div 3,true);
   Dob('Учить','home','Учить',(fon.Width-180*3)div 2+180,(fon.Height-180*2) div 3,true);
   Dob('Повторять','home','Повторять',((fon.Width-180*3)div 4)*3+360,(fon.Height-180*2) div 3,true);
   Dob('Тест','home','Тест',(fon.Width-180*2)div 3+60,((fon.Height-180*2) div 3)*2+180,true);
   Dob('Достижения','home','Достижения',((fon.Width-180*2)div 3)*2+120,((fon.Height-180*2) div 3)*2+180,true);   
   
//настройки   
   Dob('fon','settings','',0,0,false); //фон

//квесты
   Dob('fon','Достижения','',0,0,false); //фон
   Dob('Квесты','Достижения','',135,50,false); //соты квестов
 
//словарь
  Dob('Неизвестные слова','Словарь','Неизвестные слова',(fon.Width-390*3) div 4,170,true); //кнопка выхода 
  Dob('Изучаемые слова','Словарь','Изучаемые слова',(fon.Width-390*3) div 2+390,170,true); //кнопка выхода   
  Dob('Выученные слова','Словарь','Выученные слова',((fon.Width-390*3) div 4)*3+390*2,170,true); //кнопка выхода
  Dob('Поиск','Словарь','Поиск',(fon.Width-390*3) div 4,470,true); //кнопка выхода 
  Dob('Темы','Словарь','Темы',(fon.Width-390*3) div 2+390,470,true); //кнопка выхода   
  Dob('Добавить','Словарь','Добавить',((fon.Width-390*3) div 4)*3+390*2,470,true); //кнопка выхода

Dob('fon_Словарь','Неизвестные слова','',0,0,false); //фон
Dob('fon_Словарь','Изучаемые слова','',0,0,false); //фон
Dob('fon_Словарь','Выученные слова','',0,0,false); //фон

Dob('r','Неизвестные слова','WF+',920,540,false); //кнопки переключения страниц в словаре
Dob('r','Изучаемые слова','W+',920,540,false); //кнопки переключения страниц в словаре
Dob('r','Выученные слова','WT+',920,540,false); //кнопки переключения страниц в словаре

Dob('l','Неизвестные слова','WF-',600,540,false); //кнопки переключения страниц в словаре
Dob('l','Изучаемые слова','W-',600,540,false); //кнопки переключения страниц в словаре
Dob('l','Выученные слова','WT-',600,540,false); //кнопки переключения страниц в словаре

Dob('n','Неизвестные слова','',800,550,false); //номер страницы
Dob('n','Изучаемые слова','',800,550,false); //номер страницы
Dob('n','Выученные слова','',800,550,false); //номер страницы

//кнопки выхода

 Dob('exit','settings','home',fon.Width-120,50,true); //кнопка выхода
Dob('exit','Словарь','home',fon.Width-120,50,true); //кнопка выхода
Dob('exit','Учить','home',fon.Width-120,50,true); //кнопка выхода
Dob('exit','Повторять','home',fon.Width-120,50,true); //кнопка выхода
Dob('exit','Тест','home',fon.Width-120,50,true); //кнопка выхода
Dob('exit','Достижения','home',fon.Width-120,50,true); //кнопка выхода
Dob('exit','Неизвестные слова','Словарь',fon.Width-120,50,true); //кнопка выхода
Dob('exit','Изучаемые слова','Словарь',fon.Width-120,50,true); //кнопка выхода
Dob('exit','Выученные слова','Словарь',fon.Width-120,50,true); //кнопка выхода
Dob('exit','Поиск','Словарь',fon.Width-120,50,true); //кнопка выхода
Dob('exit','Темы','Словарь',fon.Width-120,50,true); //кнопка выхода
Dob('exit','Добавить','Словарь',fon.Width-120,50,true); //кнопка выхода
  Ris();
end;




begin

  Start();
  
  Ris();

  RisAnim(card,100,100);
  OnMouseMove:=MouseMove;
  
end.