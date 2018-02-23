#!/usr/bin/env python
# -*- coding: utf-8 -*-
from sys import argv
from email.header import Header
from email.mime.text import MIMEText
from email.utils import parseaddr, formataddr

import smtplib

def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr(( \
        Header(name, 'utf-8').encode(), \
        addr.encode('utf-8') if isinstance(addr, unicode) else addr))

from_addr = 'xxxx@outlook.com'
password = r'xxxxxxxx'
to_addr = 'xxxxxx'
smtp_server = 'smtp-mail.outlook.com'
smtp_port = 587

who, pro, data = argv[1:]

msg = MIMEText(data, 'plain', 'utf-8')
msg['From'] = _format_addr(u'xxx')
msg['To'] = _format_addr(u'<%s>' % to_addr)
msg['Subject'] = Header(pro, 'utf-8').encode()

server = smtplib.SMTP(smtp_server, smtp_port)
server.starttls()
server.login(from_addr, password)
server.sendmail(from_addr, [who], msg.as_string())
server.quit()