#!/bin/bash
sed -n -f sed1.sed read_komentarze.c > sed1.out
sed -f sed2.sed read_komentarze.c > sed2.out
sed -f sed3.sed read_komentarze.c > sed3.out
#sed --debug -f sed2.sed test.txt # > sed2.out
