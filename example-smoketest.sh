#!/bin/bash

set -eux

#####This example smoketest can be used for a Spring Cloud Config Server

PLAINTXT="lorem ipsum"
echo $PLAINTXT > plain.txt

#Encryption
printf "Beginning smoketest:\n\n Encrypting string...\n"
curl $SMOKETEST_URL/encrypt -d $PLAINTXT > encrypted.txt

#Decrypting
curl $SMOKETEST_URL/decrypt  -d `cat encrypted.txt` > decrypted.txt

#Comparing the plain text with the decrypted tet
cmp -s plain.txt decrypted.txt
#This will return either a zero or 1 -- we can pass this back to the blue/green deploy
exit $?
