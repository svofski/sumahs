#!/usr/bin/env python3
from utils import *


#key
data_7315='55		 50 00 00 50 50 00 00 50 50 00 00 50 50 00 00 50 50 00 00		 50 55 55 55 50 55 55 55 50 50 14 14 50 50 14 14 50 50 14 14 50 50 14 14 55 50 00 00 55 50 00 00 50 50 00 00 50 50 00 00 50 50 00 00 50 50 00 00		 50 55 55 55 50 55 55 55 50 50 14 00 50 50 14 00 50 50 14 00 50 50 14 00 55 50 00 00 55 50 00 00 50 50 00 00 50 50 00 00 50 50 00 00 50 50 00 00		 50 55 55 55 50 55 55 55 50 50 00 14 50 50 00 14 50 50 00 14 50 50 00 14 55 50 00 00 '

#keyhole
data_73a5='05			55 50 15		55 54 55 55 55 55	55 55 00 00 05 00 00 05	54 14 15 54 14 15	54 14 15 54 14 15	55 55 55 15 55 54	05 55 50 05 55 50	15			55 54 55 55 55 55	55 55 00 00 05 00 00 05	54 15 55 54 15 55	54 15 55 54 15 55	55 55 55 15 55 54	05 55 50 05 55 50	15			55 54 55 55 55 55	55 55 00 00 05 00 00 05	55 54 15 55 54 15	55 54 15 55 54 15	55 55 55 15 55 54	05			55 50			'


#questionmark
data_7285=' 01			55 00 55 55 54 54	00 15 00 00 15 00	00 54 00 05 50 00	15 40 00 54 00 00	54 00 00 54 00 00	00 00 00 54 00 00	00 00 00 14 00 01	55 40 05 00 50 00	00 14 00 00 50 00	01 40 00 14 00 00	14 00 00 00 00 00	14 00 00 00 00'

#bottle
data_72cd=' 01			55 40 01 55 40 00	14 00 00 14 00 00	14 00 01 55 40 14	00 14 51 40 05 50	00 55 50 00 05 14	05 14 05 55 50 14	14 14 50 01 45 50	00 05 50 05 05 15	40 14 05 55 50 14	01 54 50 00 05 50	14 05 51 41 45 14	00 14 05		55 50		'

# probably spiral drone?
data_741a='00 ' * 156 + \
'20 00 40 00 00 00	80 00 A0 00 60 00	A0 FF 60 FF 80 FF	40 00 00 00 20 00	80 00 A0 00 60 00	20 01 40 01 00 01	20 00 40 00 00 00	80 00 A0 00 60 00	80 FF A0 FF 60 FF	20 00 40 00 00 00	80 00 A0 00 60 00	20 01 40 01 00 01	20 00 40 00 00 00	80 00 A0 00 60 00	80 FF A0 FF 60 FF	20 00 40 00 00 00	80 00 A0 00 60 00	20 01 40 01 00 01	00			' 

# wtf
data_7523= ' 08			12 08 22 08 32 40	12 40 22 40 32 78	12			78 22 78 32		'

#robodroid
data_7090= ' 00			FF 00 00 00 FF 00	00 FF FF FF 00 C0	AA 03 00 C0 28 03	00 03 C0 3C 00 00	00 00 00 3C 03 C0	00 00 FF 00 00 00	FF 00 00 FF FF FF	00 C0 AA 03 00 C0	28 03 00 00 3C 00	00 F0 00 0F 00 00	3C 00 00 00 FF 00	00 00 FF 00 00 FF	FF FF 00 C0 AA 03	00 C0 28 03 00 3C	03 C0 00 00 00 00	00 03 C0 3C 00 00	0F F0 00 00 0F F0	00 0F FF FF F0 0C	0A A0 30 0C 02 80	30 00 3C 03 C0 00	00 00 00 03 C0 3C	00 00 0F F0 00 00	0F F0 00 0F FF FF	F0 0C 0A A0 30 0C	02 80 30 00 03 C0	00 0F 00 00 F0 00	03 C0 00 00 0F F0	00 00 0F F0 00 0F	FF FF F0 0C 0A A0	30 0C 02 80 30 03	C0 3C 00 00 00 00	00 00 3C 03 C0 00	F0 00 00 F0 00 00	0F 00 00 0F 00 00	00 F0 00 00 F0 C0	C0 00 C0 C0 03 03	00 03 03 0C 0C 00	0C 0C 30 30 00	30 30		'

#shadow
data_71f5 = ' 2A			AA AA 28 08 0A 28	08 0A 2A AA AA 00	AA 80 00 80 80 00	80 80 00 80 80 00	80 80 00 80 80 00	80 80 02 80 A0 00	00 00 2A AA AA 2A	AA AA 20 08 02 2A	AA AA 00 2A 00 00	A2 80 02 80 A0 0A	00 28 28 00 0A 00	00 00 00 00 00	3F			'

# 382, 386
data_6f10 =' 80			08 88 00 80 00 80	00 88 CC C0 00 80	FF C0 80 80 FF C0	80 00 CC C8 80 00	80 00 80 08 88 00	80 00 88 80 00 00	08 00 00 80 CC C0	80 88 FF C8 80 88	FF C8 80 80 CC C0	80 00 08 00 00 00	88 80 00 08 88 00	80 00 80 00 80 00	CC C8 80 80 FF C0	80 80 FF C0 80 88	CC C0 00 80 00 80	00 80 08 88 00 08	00 88 80 08 00 08	00 08 8C CC 00 08	0F FC 08 08 0F FC	08 00 0C CC 88 00	08 00 08 00 88 80	08 00 08 88 00 00	00 80 00 08 0C CC	08 08 8F FC 88 08	8F FC 88 08 0C CC	08 00 00 80 00 00	08 88 00 00 88 80	08 00 08 00 08 00	0C CC 88 08 0F FC	08 08 0F FC 08 08	8C CC 00 08 00 08	00 08 00 88 80	'

# tv jumper
data_718e =' FF			FF FF D5 55 57 D5	55 57 D5 55 57 FF	FF FF 0C 00 30 0C	00 30 AA 82 AA	'

# ? data_389
data_7523 = ' 08			12 08 22 08 32 40	12 40 22 40 32 78	12			78 22 78 32		'

# 
data_71a6=' 14			14 00 14 14 00 00	00 00 01 41 40 01	41 40 00 00 00 00	14 14 00 14 14 00	00 00 00 00 00 14	14 00 14 14 00 00	00 00 01 41 40 01	41 40 00 00 00 00	14 14 00 14 14	' + '00 ' * 9

#
data_6710=' 00			15 54 00 01 55 55	40 00 00 00 00 01	55 55 40 01 41 41	40 01 55 55 40 00	01 40 00 15 55 55	54 00 05 50 00 00	04 10 00 00 04 10	00 00 54 15 00 00	15 54 00 01 55 55	40 00 00 00 00 01	55 55 40 01 55 55	40 01 55 55 40 00	01 40 00 15 55 55	54 00 05 50 00 00	04 10 00 00 04 15	00 00 54 00 00 00	15 54 00 01 55 55	40 00 00 00 00 01	55 55 40 01 55 55	40 01 55 55 40 00	01 40 00 15 55 55	54 00 05 50 00 00	04 10 00 00 54 10	00 00 00 15 00 00	15 54 00 01 55 55	40 00 00 00 00 01	55 55 40 01 41 41	40 01 55 55 40 00	01 40 00 15 55 55	54 00 05 50 00 00	04 10 00 00 04 15	00 00 54 00 00 00	15 54 00 01 55 55	40 00 00 00 00 01	55 55 40 01 41 41	40 01 55 55 40 00	01 40 00 15 55 55	54 00 05 50 00 00	04 10 00 00 54 10	00 00 00 15 00 00	15 54 00 01 55 55	40 00 00 00 00 00	55 54 00 01 41 54	00 00 55 54 00 00	01 50 00 01 55 50	00 00 01 50 00 00	00 40 00 00 00 40	00 00 05 40 00 00	15 54 00 01 55 55	40 00 00 00 00 00	55 54 00 01 41 54	00 00 55 54 00 00	01 50 00 01 55 50	00 00 01 50 00 04	04 04 00 01 10 01	00 00 40 54 00 00	15 54 00 01 55 55	40 00 00 00 00 00	15 55 00 00 15 41	40 00 15 55 00 00	05 40 00 00 05 55	40 00 05 40 00 00	01 00 00 00 01 00	00 00 01 50 00 00	15 54 00 01 55 55	40 00 00 00 00 00	15 55 00 00 15 41	40 00 15 55 00 00	05 40 00 00 05 55	50 00 05 40 00 00 10 10 10 00 40 04	40 00 15 01 00	' 


data_17d2=' AA			AF 00 00 00 00 AA	AF 00 00 AA AF 00	00 00 00 AA AF 00	00 AA AF 00 00 00	00 AA AF 00 00 AA	AF 00 00 00 00 AA	AF 00 00 AA AF 00	00 00 00 AA AF 00	00 AA AF 00 00 00	00 AA AF 00 00 AA	AF 00 00 00 00 AA	AF 00 00 AA AF 00	00 00 00 AA AF 00	00 AA AF 00 00 00	00 AA AF 00 00 AA	AF 00 00 00 00 AA	AF 00 00 AA AF 00	00 00 00 AA AF 00	00 AA AF 00 00 00	00 AA AF 00 00 AA	AF 00 00 00 00 AA	AF 00 00 AA AF 00	00 00 00 AA AF 00	00 AA AF 00 00 00	00 AA AF 00 00 AA	AB C0 00 00 02 AA	AF 00 00 AA AA AA	AA AA AA AA AF 00	00' + 'AA ' * 7 + 'AF 00 00 ' + 'AA ' * 7 + 'AF 00 00 ' + 'AA ' * 7 + 'AF 00 00 ' + 'AA ' * 7 + 'AF 00 00 ' + 'AA ' * 7 + 'AF 00 00 AA AB C0	00 00 02 AA AF 00	00 AA AF 00 00 00	00 AA AF 00 00 AA	AF 00 00 00 00 AA	AF 00 00 AA AF 00	00 00 00 AA AF 00	00 AA AF 00 00 00	00 AA AF 00 00 AA	AF 00 00 00 00 AA	AF 00 00 AA AF 00	00 00 00 AA AF 00	00 AA AF 00 00 00	00 AA AF 00 00 AA	AF 00 00 00 00 AA	AF 00 00 AA AF 00	00 00 00 AA AF 00	00 AA AF 00 00 00	00 AA AF 00 00 AA	AF 00 00 00 00 AA	AF 00 00 AA AF 00	00 00 00 AA AF 00	00 AA AF 00 00 00	00 AA AF 00 00 AA	AF 00 00 00 00 AA	AF 00 00 AA AF 00	00 00 00 AA AF 00	00 AA AF 00 00 00	00 AA AF 00 00 AA	AF 00 00 00 00 AA	AF 00 00		' 

data_1642=' 02			AA AA AA AA AA AA	AF 00 00 0A AA AA	AA AA AA AA AF 00	00 2A AA AA AA AA	AA AA AF 00 00	'+ 'AA ' * 7 +		'AF 00 00		' + 'AA ' * 7 +		'AF 00 00		' + 'AA ' * 7 +		'AF 00 00 AA AB C0	' + '00 ' * 7 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AB C0		' + '00 ' * 7 +		'AA AA AA AA AA AA	' + 'AB C0 00 00		' + 'AA ' * 7 +		'F0 00 00		' + 'AA ' * 7 +		' BC 00 00 2A AA AA	AA AA AA AA AF 00	00 0A AA AA AA AA	AA AA AF 00 00 02	AA AA AA AA AA AA	AF			' + '00 ' * 7 +		' 02 AA AF 00		' + '00 ' * 7 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 8 +		'AA AF		' + '00 ' * 7 +		'02 AA AF 00 00 AA	' + 'AA AA AA AA AA AA	' + 'AF 00 00		' + 'AA ' * 7 +		'AF 00 00		' + 'AA ' * 7 +		'AF 00 00		' + 'AA ' * 7 +		'BC 00 00		' + 'AA ' * 7 +		'F0 00 00 AA AA AA	' + 'AA AA AA AB C0 00	' + '00			' 

data_66da='CC CC ' * 16 + 'F8 FE 00 FE 08 FE	00 00 F8 00 00 00	08 00 00 00 F8 02	00 02 08 02		00			'

data_6d78=' CC			CC CC C0 00 0C C0	00 0C C0 00 0C CC	CC C0 C0 00 CC C0	00 0C C0 00		0C			'

data_6d60=' 0C			CC C0 CC 00 CC C0	00 0C C0 00 0C C0	00 0C C0 00 0C CC	00 CC 0C CC C0	'

data_6d48=' CC			00 CC CC 00 CC CC	00 CC C0 CC 0C C0	CC 0C C0 00 0C C0	00 0C C0 00		0C			'

data_6e08=' 00			00 00 00 CC 00 00	CC ' + '00 ' * 8

#data_357
data_6d90=' 80 00 00 80 00 00 80		00 00 80 00 00 80		00 00 80 00 00 80		00 00 88 88 88		' 


#data_358
data_6DA8='  88			88 88 80 00 00 80		00 00 88 88 80 80		00 00 80 00 00 80		00 00 88 88 88		'
#data_359
data_6dc0=' 80 00 08 80 00 08 80		00 08 80 00 08 80		00 08 88 00 88 08		88 80 00 88 00		'

#data_360
data_6dd8=' 00			28 00 00 AA 00 02		82 80 0A 00 A0 28		00 28 AA AA AA A8		00 2A A8 00 2A 54		00 05 55 00 05 51		40 05 50 54 05 50		05 05 50 01 45 50		00 55 50 00 15		'

data_6e29=' 03			FF C0 3F 00 FC F0	03 0F F0 0C 0F F0	30 0F F0 C0 0F 3F	00 FC 03 FF C0	00			FC 00 03 FC 00 0F	3C 00 00 3C 00 00	3C 00 00 3C 00 00	3C 00 0F FF F0	0F			FF F0 3C 00 3C 00	00 3C 00 3F F0 03	FC 00 3C 00 00 FC	00 00 3F FF FF	0F			FF FC 3C 00 3F 00	00 3C 00 3F FC 00	00 3F F0 00 0F 3C	00 3C 0F FF F0	00			0F F0 00 FF F0 03	C3 F0 3F 03 F0 FC	03 F0 FF FF FF 00	03 F0 00 03 F0	FF			FF F0 F0 00 00 F0	00 00 FF FF F0 00	00 3C 00 00 0F FC	00 3C 0F FF F0	0F			FF F0 3C 00 00 F0	00 00 FF FF FC F0	00 3F F0 00 0F 3C	00 3C 0F FF F0	FF			FF FF 00 00 FC 00	03 C0 00 0F 00 00	3C 00 00 F0 00 00	F0 00 00 F0 00	0F			FF F0 3C 00 3C 3C	00 3C 0F FF F0 3C	00 3C F0 00 0F F0	00 0F 3F FF FC	0F			FF F0 3C 00 3C F0	00 0F F0 00 0F 3F	FF FF 00 00 3C 00	00 F0 0F FF C0	'


data_0b72='			0F C0 3F C0 03 C0	03 C0 03 C0 03 C0	03 C0 03 C0 03 C0	3F FC 0F F0 F0 F0	F0 3C 00 3C 00 3C	0F F0 3C 00 F0 00	F0 00 FF FC 3F C0	F0 3C F0 3C 00 30	0F F0 00 3C 00 3C	00 3C F0 F0 3F C0	00 F0 03 F0 0F 30	3C 30 F0 30 F0 30	FF FC 00 30 00 30	00			30			FF			FC C0 00 C0 00 C0	00 FF F0 00 3C 00	3C 00 3C F0 3C 3F	F0 0F FC 3C 00 F0	00 F0 00 FF F0 F0	3C F0 3C F0 3C 30	30 0F C0 FF FC 00	3C 00 F0 00 F0 00	F0 03 C0 03 C0 03	C0 03 C0 03 C0 0F	C0 3C F0 F0 3C F0	3C 3C F0 0F C0 3F	F0 F0 3C F0 3C 3F	F0 0F C0 3C F0 F0	3C F0 3C F0 3C 3F	FC 00 3C 00 3C 00	F0 3F C0		0F			C0 3C F0 F0 3C C0	0C C0 0C C0 0C C0	0C F0 3C 3C F0 0F	C0			0C26			72 0B 86 0B 9A 0B	AE 0B C2 0B D6 0B	EA 0B FE 0B 12 0C	3C 3C 75 06 80 36	51 01 01 C3 C3	' 





data_6fd0=' 03			33 00 30 00 30 00	30 00 33 33 30 30	3F F0 30 30 3F F0	30 33 33 30 00 30	00 30 00 30 03 33	00 00 33 30 00 00	03 00 00 30 33 30	30 33 3F F3 30 33	3F F3 30 30 33 30	30 00 03 00 00 00	33 30 00 30 03 33	00 30 00 30 00 33	33 30 00 30 3F F0	30 30 3F F0 30 00	33 33 30 00 30 00	30 03 33 00 30 00	33 30 03 00 03 00	03 00 03 33 33 03	03 FF 03 03 03 FF	03 03 33 33 00 03	00 03 00 03 00 33	30 00 03 33 00 00	00 30 00 03 03 33	03 03 33 FF 33 03	33 FF 33 03 03 33	03 00 00 30 00 00	03 33 00 03 00 33	30 03 00 03 00 03	33 33 00 03 03 FF	03 03 03 FF 03 00	03 33 33 00 03 00	03 00 33 30 03	'


data_63c6= ' FC			00 00 3F FF 00 00	FF FF C0 03 FF FF	F0 0F FF FF F0 0F	FF FF C0 03 FF FF	00 00 FF FC 00 00	3F 00 3F FC 00 00	FF FF 00 03 FF FF	C0 0F FF FF F0 0F	FF FF F0 03 FF FF	C0 00 FF FF 00 00	3F FC 00		'

# 16x9 ?
#print(hexdata, len(hexdata))

def tocga(b):
    s = ''
    for i in range(4):
        col = (b & 0xc0) >> 6
        b <<= 2
        s += '.123'[col]
    return s

#print(tocga(0x55))
#print(tocga(0xaa))
#print(tocga(0x00))
#print(tocga(0xff))

def printspr(data, n):
    hexdata=[int(x, 16) for x in data.split()]
    print(len(hexdata))
    line = ''
    i = 0
    for b in hexdata:
        line += tocga(b)
        i += 1
        if i == n:
            print(line)
            line = ''
            i = 0

data = []

with open('SHAMUS.COM', 'rb') as shafi:
    data = bytes(shafi.read())

def printspr2(data, offset, width, height, name):
    size = width * height
    print(f'; {name}{offset:4x} {width}x{height} {size} bytes')
    hexdata = data[offset - 0x100:]
    line = ''
    i = 0
    for b in hexdata[:size]:
        line += tocga(b)
        i += 1
        if i == width:
            print(line)
            line = ''
            i = 0

sprites=[
        # filpat_
        ['filpat_', 0x63C6, 4, 16],
        ['filpat_', 0x6406, 4, 16],
        ['filpat_', 0x644A, 4, 16],
        ['filpat_', 0x648A, 4, 16],
        ['filpat_', 0x64CA, 4, 16],
        ['filpat_', 0x650A, 4, 16],
        ['filpat_', 0x654A, 4, 16],
        ['filpat_', 0x658A, 4, 16],
        # fill_0a...
        ['fill_', 0x660A, 2, 8],
        ['fill_', 0x661A, 2, 8],
        ['fill_', 0x662A, 2, 8],
        ['fill_', 0x663A, 2, 8],
        ['fill_', 0x664A, 2, 8],
        ['fill_', 0x665A, 2, 8],
        ['fill_', 0x666A, 2, 8],
        ['fill_', 0x667A, 2, 8],
        ['fill_', 0x668A, 2, 8],
        ['fill_', 0x669A, 2, 8],
        ['fill_', 0x66AA, 2, 8],
        ['fill_', 0x66BA, 2, 8],
        ['pat4x8_vstripes_', 0x66da, 4, 8],
        ['spr_shamus_', 0x6710, 4, 12*9],
        ['spr_shamus__nohat', 0x68c0, 4, 8],

        ['key_', 0x7315, 4, 12*3],
        ['keyhole_', 0x73a5, 3, 13*3],


        ['mystery_', 0x7285, 3, 12*2],
        ['extralife_', 0x72cd, 3, 12*2], # 1 full flask + 2 half frames
        ['shadow2_', 0x723d, 3, 12*2],
        ['shadow3_', 0x71f5, 3, 12*2],
        ['spiraldrone2_', 0x6f10, 4, 8*6],
        ['spiraldrone3_', 0x6fd0, 4, 8*6],
        ['robodroid_', 0x7090, 4, 8*6],
        ['unknown_', 0x7176, 3, 8],
        ['snapjumper_', 0x718e, 3, 8],
        ['maybe_eyes_', 0x71a6, 3, 20],
        ['maybe_eyes_', 0x71e5, 3, 20],

        ['bigtitI_', 0x1570, 3, 15],
        ['bigtitB_', 0x159D, 5, 15],
        ['bigtitM_', 0x15E8, 6, 15],

        ['bigtitle_S', 0x1642, 10, 0x28],
        ['bigtitle_H', 0x17D2, 10, 0x28],
        ['bigtitle_A', 0x1962, 10, 0x28],
        ['bigtitle_M', 0x1AF2, 10, 0x28],
        ['bigtitle_U', 0x1C82, 10, 0x28],

        ['font3x8_', 0x6d48, 3, 8*19], # MORLEVAN:0123456789
        ['narrowfont_', 0xb72, 2, 10*10], # 0123456789

        ['ion_shivs_', 0x7e70, 2, (12 + 14 + 12 + 10 + 10 + 12 + 14 + 12)//2], #

        ]

for s in sprites:
    printspr2(data, s[1], s[2], s[3], s[0])
    print()

print('---')

#printspr(data_741a, 4)
#printspr(data_7523, 3)
#printspr(data_7090, 4)
#printspr(data_71f5, 3)
#printspr(data_6f10, 4)
#printspr(data_718e, 3)
#printspr(data_7523, 1)
#printspr(data_71a6, 3)
#printspr(data_6710, 4)
#printspr(data_17d2, 10)
#printspr(data_1642, 10)
#printspr(data_66da, 4)
#printspr(data_6d78, 3)
#printspr(data_6d60, 3)
#printspr(data_6d48, 3)
#printspr(data_6e08, 3)

#printspr(data_6d90, 3)  #data_357
#printspr(data_6DA8, 3)
#printspr(data_6dc0, 3)
#printspr(data_6dd8, 3)

#printspr(data_6e29, 3)
#printspr(data_0b72, 2)
#printspr(data_6fd0, 4)

#printspr(data_63c6, 4)
