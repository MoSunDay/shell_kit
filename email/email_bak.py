#!/usr/bin/env python
# -*- coding: utf-8 -*-

import smtplib
from email.mime.text import MIMEText
from email.header import Header

def send_email(receivere,title,content):
    sender = 'xxx'
    #receiveres = ['xx@outlook.com','xx@qq.com']
    #receiveres = ['xx@qq.com']
    receiveres = []
    receiveres.append(receivere)
    subject = title
    username = 'xx'
    password = 'xx'

    msg = MIMEText(content, 'plain', 'utf-8')
    msg['From'] = Header("xx", 'utf-8')
    msg['To'] =  Header("xx", 'utf-8')
    msg['Subject'] = Header(subject, 'utf-8')
    smtp = smtplib.SMTP()
    smtp.connect('smtp.ym.163.com')
    smtp.login(username, password)
    for receiver in receiveres:
        smtp.sendmail(sender, receiver, msg.as_string())
    smtp.quit()

if __name__ == '__main__':

    send_email("", "", "")