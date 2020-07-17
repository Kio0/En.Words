{$reference System.Windows.Forms.dll}
{$reference 'System.Drawing.dll'}
{$apptype windows}
///содержит функции считывания экрана, эмуляции клавиатуры и мыши и взаимодействия с буфером обмена
Unit Bot;
interface 
uses System.Windows.Forms;
uses System.Drawing;
uses GraphABC;
type Kord=record//координаты
x: integer;
y: integer;
end;
var P: picture; //скриншот экрана
///возвращает скриншот экрана
Function PrintScreen(): picture; //возвращает текущее состояние экрана
///возвращает позицию левого верхнего угла изображения на экране. 0,0 если такого нет. 
///Delta - допустимая разница в цвете. Вычисляется как среднее арифметическое разниц всех пикселей.
///x1,y1,x2,y2 - координаты зоны поиска. Если хоть одна равна 0, обыскиввается весь экран.
Function PosPicture(Pic: picture; Delta: byte;x1,y1,x2,y2: integer ): Kord;
///нажимает ЛКМ по координатам x,y. Если x или y равны 0, кликает в текущем месте.
Procedure MouseKey(x,y: integer);
///сдвигает мышку на координаты X,Y
Procedure MouseMove(x,y: integer); 
///нажимает на кнопку с идентефикатором n если m=1 то кнопка нажимается, если 2 - отжимается
procedure Key(n: integer;m:integer);
///Возвращает текстовое содержимое буфера обмена
function GetText():string;
///Задаёт текстовое содержимое буфера обмена
procedure SetText(s:string);
///Измеряет разницу между цветами
Function Rast(c1,c2: color): byte; //разница, расстояние между двумя цветами
///вырезает кусок изображения
Function Copy(P: picture; x1,x2,y1,y2: integer): picture; //вырезает кусок фотки
///считает усреднённый цвет изображения
Function Col(P:picture):color; //считает усреднённый цвет изображения
///считает количесто пикселей данного цвета в изображении
Function kolPix(P: picture; c: color; rastoianie: integer): real; //возвращает долю пикселей, близких к указанному цвету
///смещает персонажа в указанном направлении от 1 до 8 в течении t милисекунд
Procedure Run(n: byte; t: integer); 
implementation
Function Col(P:picture):color; //считает усреднённый цвет изображения
var i,r,SumR,SumG,SumB,kol: integer;
begin
for i:=1 to P.Width-1 do
for r:=1 to P.Height-1 do begin  
SumR:=SumR+GetRed  (P.GetPixel(i,r));
SumG:=SumG+GetGreen(P.GetPixel(i,r));
SumB:=SumB+GetBlue (P.GetPixel(i,r));
kol:=kol+1;
end;
if kol>0 then Col:=RGB(SumR div kol,SumG div kol,SumB div kol);
end;
Function Rast(c1,c2: color): byte; //разница, расстояние между двумя цветами
var dr,dg,db: byte;
begin
dr:=(GetRed(c1)-GetRed(c2))*(GetRed(c1)-GetRed(c2));
dg:=(GetGreen(c1)-GetGreen(c2))*(GetGreen(c1)-GetGreen(c2));
db:=(GetBlue(c1)-GetBlue(c2))*(GetBlue(c1)-GetBlue(c2));
Rast:=Round(sqrt((dr+dg+db)/3));
end;
Function kolPix(P: picture; c: color; rastoianie: integer): real; //возвращает долю пикселей, близких к указанному цвету. rastoianie-допустимая пограшность
var i,r,kol: integer;
begin
for i:=1 to P.Width-1 do
for r:=1 to P.Height-1 do if Rast(P.GetPixel(i,r),c)<=rastoianie then kol:=kol+1;
kolPix:=kol/((P.Width-1)*(P.Height-1));
end;
Function Copy(P: picture; x1,x2,y1,y2: integer): picture; //вырезает кусок фотки
var i,r: integer;
PP: picture;
begin
PP:=new Picture(x2-x1+1,y2-y1+1);
for i:=x1 to x2-1 do
for r:=y1 to y2-1 do begin
PP.SetPixel(i-x1+1,r-y1+1,P.GetPixel(i,r));
Copy:=PP;
end;
end;
function GetText():string;
begin
GetText:=Clipboard.GetText()
end;
procedure SetText(s:string);
begin
  Clipboard.SetText(s);
end;
function keybd_event(dwFlags, dx, dy, dwData, dwExtraInfo: integer): boolean;
external 'user32.dll';
function mouse_event(dwFlags, dx, dy, dwData, dwExtraInfo: integer): boolean;//управление мышкой
external 'user32.dll';
function SetCursorPos(x,y: integer): boolean;  //управление местоположением курсора
 external 'user32.dll';
Function PosPicture(Pic: picture; Delta: byte; x1,y1,x2,y2: integer): Kord;
var i,r,g,h: integer;
var K,K1:kord;

function testir(x,y: integer; Pic: picture; Delta: byte): boolean; //считает, нужная ли позиция изображения 
var i,r: integer;
var Sum,Max: integer; //sum - текущая суммарная разность изображений. Max - максимальная допустимая разность изображений. 
begin
Sum:=0;
Max:=Delta*(Pic.Height-1)*(Pic.Width-1); //максимальное отличие изображения
for i:=1 to Pic.Width-1 do begin
if Sum>Max then break; 
for r:=1 to Pic.Height-1 do begin
if Sum>Max then break; //досрочно выходим из цикла если отличие слишком велико.
if P.GetPixel(x+i-1,y+r-1)<>clWhite then if Pic.GetPixel(i,r)<>clWhite then Sum:=Sum+Rast(P.GetPixel(x+i-1,y+r-1),Pic.GetPixel(i,r));
end; end;
testir:=Sum<=Max;
end;

begin
if x1*y1*x2*y2<1 then begin x1:=2; y1:=2; x2:=P.Height-2; y2:=P.Height-2; end; //задаём весь экран
//проверяем на верность заданных параметров
if x1>x2 then begin i:=x1; x1:=x2; x2:=i; end; if y1>y2 then begin i:=y1; y1:=y2; y2:=i; end;
if x1<2 then x1:=2; if y1<2 then y1:=2;
if x2>P.Height-2 then x2:=P.Height-2; if y2>P.Height-2 then y2:=P.Height-2;

x2:=x2-Pic.Width;
y2:=y2-Pic.Height; //считаем зону, в которой ищем изображение.
for i:=x1 to x2 do begin
if K<>K1 then break;
for r:=y1 to y2 do if testir(i,r,Pic,Delta) then begin K.x:=i; K.y:=r; break; end; //перебираем пиксели, пока не встретим совпадение.
end;
PosPicture:=K;
end;


Procedure MouseKey(x,y: integer); //кликает на выбраных координатах. Если они равны 0, кликает в текущем месте.
begin
if (x>0) and (y>0) then SetCursorPos(x,y); //перенос курсора
mouse_event(2 or 4, 0, 0, 0, 0); // Одиночный клик мышью
end;
Procedure MouseMove(x,y: integer); //сдвигает мышку на координаты X,Y
begin
SetCursorPos(x,y); //перенос курсора
end;
procedure Key(n: integer;m:integer);
begin
keybd_event(n, 0, m, 0, 0); //Нажатие 'f'.
end;
Procedure Run(n: byte; t: integer);
begin
case n of 
1: begin Key(Ord('W'),1);                  sleep(t); Key(Ord('W'),2);                  end;
2: begin Key(Ord('W'),1); Key(Ord('D'),1); sleep(t); Key(Ord('W'),2); Key(Ord('D'),2); end;
3: begin Key(Ord('D'),1);                  sleep(t); Key(Ord('D'),2);                  end;
4: begin Key(Ord('D'),1); Key(Ord('S'),1); sleep(t); Key(Ord('D'),2); Key(Ord('S'),2); end;
5: begin Key(Ord('S'),1);                  sleep(t); Key(Ord('S'),2);                  end;
6: begin Key(Ord('S'),1); Key(Ord('A'),1); sleep(t); Key(Ord('S'),2); Key(Ord('A'),2); end;
7: begin Key(Ord('A'),1);                  sleep(t); Key(Ord('A'),2);                  end;
8: begin Key(Ord('A'),1); Key(Ord('W'),1); sleep(t); Key(Ord('A'),2); Key(Ord('W'),2); end;
end;
end;
Function PrintScreen(): picture; //возвращает текущее состояние экрана
var BMP: System.Drawing.image;
var i: integer;
var img := new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height);
var gh := Graphics.FromImage(img);
begin
gh.CopyFromScreen(0,0,0,0, img.Size);
img.Save('ScreenShot.bmp');
P:=new Picture('ScreenShot.bmp');
PrintScreen:=P;
end;
begin
end.