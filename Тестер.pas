//программа для изучения слов
Uses GraphABC;
type en_word=record
 ru:string;
 en:string;
 status: string; //последовательность нулей и едениц. 0 - верно. 1 - неверно ответил. 
 kat: integer; //текущая категория слова
 date: string; //дата, когда в последний раз это слово спрашивалось
end;

login: string;

type words=record
  kol: integer;
  w:array[1..10000] of en_word;
end;
var P: array[1..6] of picture;
var fon: picture;
var W:array[1..17] of words; //17 периодов повторения. 
//Час, Два часа, 12 часов, Сутки, Два дня, Неделя, Две недели. При верном ответе два раза подряд слово переходит в следующую категорию. При ошибке попадает в первую.
var kategory:array[1..17] of integer; //время между вопросами в минутах

const limit=50; //максимальное количестков изучаемых слов (в первых 5 категориях суммарно)

type Question=record
  kat: integer;
  id: integer; 
end;
var a: array[1..4] of array[1..2] of Question;

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
e.kat:=intStr(kat);
if e.kat=0 then e.kat:=1;
ReadStr:=e;
end;
Procedure Start(); //считывает данные
var i,r,g: integer;
var t: text;
var str: string;
begin
  lockdrawing();
  kategory[1]:=1;
  kategory[2]:=5;
  kategory[3]:=10;
  kategory[4]:=60;
  kategory[5]:=60;
  kategory[6]:=120;
  kategory[7]:=120;
  kategory[8]:=720;
  kategory[9]:=720;
  kategory[10]:=1440;
  kategory[11]:=1440;
  kategory[12]:=2880;
  kategory[13]:=2880;
  kategory[14]:=10080;
  kategory[15]:=10080;
  kategory[16]:=20160;
  kategory[17]:=20160;
  for i:=1 to 17 do begin 
    assign(t,'word '+i+'.txt');
    reset(t);
    while not(eof(t)) do begin
      readln(t,str);
      W[i].kol:=W[i].kol+1;
      W[i].w[W[i].kol]:=ReadStr(str);
      
      
      
    end;
    close(t)
  end;
  
 fon:=new Picture('image/fon.jpg'); 
 for i:=1 to 6 do P[i]:=new Picture('image/'+i+'.jpg');
  
  setwindowpos(100,50);
  setwindowtitle('Тестер английского');
  setwindowsize(fon.Width,fon.Height);
  
  
end;

Procedure Save(); //сохраняет слова в файлы
var i,r: integer;
var wor: en_word;
var t: text;
begin
writeln(W[1].w[52]);
for i:=1 to 17 do begin
  assign(t,'word '+i+'.txt');
  rewrite(t);
  for r:=1 to W[i].kol do begin
  wor:=W[i].w[r];
  write(t,wor.en+'--'+wor.ru+'++'+wor.status+'@@'+wor.kat);
  if r<W[i].kol then writeln(t,'');
  end;
  
  close(t);
  
  end;
  
end;


Procedure Ris();
var i,r: integer;
begin

fon.Draw(0,0);  
  
  
  redraw();
end;

begin
  Start();
  //Save();
  Ris();
  
  
end.