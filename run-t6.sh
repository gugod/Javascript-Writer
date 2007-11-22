#!/bin/sh

for i in t6/*.t
do
    pugs -Ilib6 $i
done

