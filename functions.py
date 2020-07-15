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
#import socks  #это что бы заходить через порт тор-браузера. Он должен быть открыт.
#import socket
#socks.set_default_proxy(socks.SOCKS5, "localhost", 9150)
#socket.socket = socks.socksocket

UserAgent().chrome  #иммитируем браузер
headers =  {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}
#headers =  {'User-Agent': 'Cromium/4.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/527.36 (KHTML, like Gecko) Chrome/37.0.2271.91 Safari/517.32'}

def test_user(name): #возвращает true если пользователь существует
    s = requests.Session()
    r=s.get('https://forum.cubixworld.ru/users/'+name+'/',headers=headers)
    return(len(r.text)>20000)

        
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
    if email.find('@')>email.find('.'):
        b='Неверный формат'
    for i in 'абвгдеёжзийклмнопрстуфхцчъыьэюяАБВГДЕЁЖЗИЙКЛМНУФХЦЧШЩЪЫЬЭЮЯ':
        if email.find(i)>0:
            b='Cимвол "'+i+'"'
            break    
    return(b)


def send_mail(email,text): #отсылает письмо
    a = smtplib.SMTP('smtp.gmail.com', 587)
    a.starttls()
    a.login('KubGU.FKTiPM.36.2@gmail.com','eA3MREuR')
    a.sendmail("KubGU.FKTiPM.36.2@gmail.com",email,text)
    a.quit()    

def registr(login,email,password1,password2): #совершает регистрацию. Возвращает проверочный код и сообщение
    global code
    name='enw_'+login
    if test_user(name):
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
            Str='verification code: '+str(code)
            send_mail(email,'1234')
            return(['Регистрация завершена, проверьте почту',code])        
        else:   
            return(['Эта почта уже используется',code])


def get_text(login,ID): #возвращает содержимое поля
    name=login+'.'+ID
    url='https://www.mailforspam.com/mail/'+name
    s = requests.Session()
    s.get(url,headers=headers)

    
    return(0)

def set_text(login,ID,text): #загружает текст в поле ID 
    return(0)

def dob_slova(login,password,slova):
    return(0)

code=0

