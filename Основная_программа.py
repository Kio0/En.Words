#основная программа
import functions
from tkinter import *
from tkinter import messagebox
 
 
def avtoriz():
    global root
    s=functions.auth(name.get(),password.get())
    Str=name.get()
    if s!='Вход выполнен':
        messagebox.showinfo("Error", s)
    else:
        messagebox.showinfo("Вход выполнен", "Позравляю, вы вошли!")
        
def reg():
    if functions.test_email(email.get())=='Валидный email':
        s=functions.registr(name2.get(),email.get(),password1.get(),password2.get())
        messagebox.showinfo("Error", s[0])
    else:
        messagebox.showinfo("Error", functions.test_email(email.get()))

root = Tk()
root.title("Войдите в аккаунт либо зарегестрируйтесь")
root.geometry("500x300")
name = StringVar()
name2 = StringVar()
password  = StringVar()
password1 = StringVar()
password2 = StringVar()
email = StringVar()
     
name_label = Label(text="Введите логин:")  
password_label = Label(text="Введите пароль:")

name_label.grid(row=0, column=0, sticky="w")
password_label.grid(row=1, column=0, sticky="w")
     
name_entry = Entry(textvariable=name)
password_entry = Entry(textvariable=password)
name_entry.grid(row=0,column=1, padx=5, pady=5)
password_entry.grid(row=1,column=1, padx=5, pady=5)
     
name2_label = Label(text="Введите логин:")
email_label = Label(text="Введите email:")
password1_label = Label(text="Введите пароль:")
password2_label = Label(text="Введите пароль:")

name2_label.grid(row=0, column=3, sticky="w")
email_label.grid(row=1, column=3, sticky="w")
password1_label.grid(row=2, column=3, sticky="w")
password2_label.grid(row=3, column=3, sticky="w")

name2_entry = Entry(textvariable=name2)
email_entry = Entry(textvariable=email)
password1_entry = Entry(textvariable=password1)
password2_entry = Entry(textvariable=password2)
name2_entry.grid(row=0,column=4, padx=5, pady=5)
email_entry.grid(row=1,column=4, padx=5, pady=5)
password1_entry.grid(row=2,column=4, padx=5, pady=5)
password2_entry.grid(row=3,column=4, padx=5, pady=5)
     
message_button1 = Button(text="Авторизация", command=avtoriz)
message_button1.grid(row=2,column=1, padx=5, pady=5, sticky="e")

message_button2 = Button(text="Регистрация", command=reg)
message_button2.grid(row=4,column=3, padx=5, pady=5, sticky="e")

root.mainloop()


