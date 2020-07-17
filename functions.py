#все функции, необходимые для программы

# -*- coding: utf-8 -*-

from threading import Thread
import requests
import json
import os
from bs4 import BeautifulSoup as BS
from fake_useragent import UserAgent
import random
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import io
import chardet
import codecs
os.environ["PYTHONIOENCODING"] = "utf-8"
#import socks  #это что бы заходить через порт тор-браузера. Он должен быть открыт.
#import socket
#socks.set_default_proxy(socks.SOCKS5, "localhost", 9150)
#socket.socket = socks.socksocket

UserAgent().chrome  #иммитируем браузер
#headers =  {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}
headers =  {'User-Agent': 'Cromium/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/527.36 (KHTML, like Gecko) Chrome/37.0.2271.91 Safari/517.32'}

def test_user(name): #возвращает true если пользователь существует
    s = requests.Session()
    r=s.get('https://forum.cubixworld.ru/users/'+name+'/',headers=headers)
    return(len(r.text)>20000)

def GetTag(s1,s2,s3): #возвращает содержимое тэга в тексте S2 между подстрокой s1 и символом s3
    Str=''
    k=s2.find(s1)+len(s1)
    m=k
    if k>0:
        while s2[k]!=s3:
            Str=Str+s2[k]
            k=k+1
    return(Str)
        
def auth(login,password): #возвращает валидность логина и пароля. Возможные ответы. "Вход выполнен", "Пользователь не найден", "Неверный пароль"
    url='https://forum.cubixworld.ru/'
    s = requests.Session()
    s.get(url,headers=headers)
    name='enw_'+login
    data = {
            'name':name,
            'password':password,
            'autoriz':'войти',
            }
    r=s.post(url,headers=headers,data=data)
    if r.text.find(name+'/options/')>0:
        return('Вход выполнен')
    else:
        if test_user(name):
            return('Неверный пароль')
        else:
            return('Пользователь не найден')
            

def test_email(email): #возвращает 'Валидный email', если емаил введён правильно
    b='Валидный email'
    if email.find('@')==0:
        b='Отсутствует символ "@"'
    if email.find('.')==0:
        b='Отсутствует домен'
    for i in 'абвгдеёжзийклмнопрстуфхцчъыьэюяАБВГДЕЁЖЗИЙКЛМНУФХЦЧШЩЪЫЬЭЮЯ':
        if email.find(i)>0:
            b='Cимвол "'+i+'"'
            break    
    return(b)


def send_mail(email,text): #отсылает письмо
    smtpObj = smtplib.SMTP('smtp.gmail.com', 587)
    smtpObj.starttls()
    smtpObj.login('KubGU.FKTiPM.36.2@gmail.com','eA3MREuR')
    toaddr = [email]
    msg = MIMEMultipart('mixed')
    msg['Subject'] = 'Проверка корректности email-адреса'
    msg['From'] = 'Типа программа для изучения английского. '
    msg['To'] = ', '.join(toaddr[0:len(toaddr)-1])
    sss=text.encode('utf-8')
    #part1 = MIMEText(text, 'plain')#для текстового письма
    part1 = MIMEText(text, 'html')#для html письма
    msg.attach(part1)
    smtpObj.sendmail('KubGU.FKTiPM.36.2@gmail.com',toaddr,msg.as_string())
    smtpObj.quit()    

def Zam(s,s1,s2): #заменяет в строке s подстроку s1 на s2
    str1=s[1:s.find(str(s1))]
    str2=s[(s.find(str(s1))+len(str(s1))-2):len(str(s))]
    return(str1+str(s2)+str2)


def registr(login,email,password1,password2): #совершает регистрацию. Возвращает проверочный код и сообщение
    global code
    m=open('mail.txt','r',encoding="utf-8")
    html=(m.read()).encode('utf-8')
    m.close()
    html=html.decode('UTF-8')
    name='enw_'+login
    if test_user(name):
        print('start')
        return(['Пользователь уже существует',code])
    else:
        url='https://cubixworld.ru/register'
        s = requests.Session()
        s.get(url,headers=headers)  
        data = {
                'name':name,
                'email':email,
                'onepassword':password1,
                'twopassword':password2,
                'send':'',
                    }
        r=s.post(url,headers=headers,data=data)
        if test_user(name):
            code=random.randint(100000,999999)
            pos_login=text.find('Text')
            pos_pass=text.find('12345678')
            pos_code=text.find('3141592')
            
            text=Zam(text,'Test',login)
            text=Zam(text,'12345678',password1)
            text=Zam(text,'314159',code)
            print('start')
            #Str='Ваш проверочный код "'+str(code)+'". Введите его в программу для подтверждения регистрации'
            send_mail(email,text)
            print('end')
            return(['Регистрация завершена, проверьте почту',code])        
        else:   
            return(['Эта почта уже используется',code])


def get_text(login,ID): #возвращает содержимое поля
    name=login+'.'+ID+'/'
    url='https://www.mailforspam.com/mail/'+name
    s = requests.Session()
    r = s.get(url,headers=headers)
    g = GetTag("location.href = '/mail/"+name,r.text,"'")
    if (len(g)==0):
        return('')
    if (len(g))>5:
        return('')
    m = s.get(url+g+'/',headers=headers)
    f=(GetTag('<p id="messagebody">\n                ',m.text,'<'))
    return(f)

def set_text(login,ID,text): #загружает текст в поле ID
    send_mail(login+'.'+ID+'@mailforspam.com',text)



code=0

