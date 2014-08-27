#!/bin/sh
/bin/rm -f *.out
make -C .. -j4 softpoint.x
for i in *.in; do
  ../softpoint.x leshouches < $i > `echo $i | sed 's/in$/out/'`
done
