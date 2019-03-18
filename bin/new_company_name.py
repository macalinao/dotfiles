#!/usr/bin/env python
import sys

vowels = "aeiou"
consonants = "bcdfghjklmnpqrstvwyz"
suffixes = [".com", ".io", ".co"]

names = [
    "a" + c1 + v1 + c2 + v2 + suffix
    for suffix in suffixes
    for v1 in vowels
    for v2 in vowels
    for c1 in consonants
    for c2 in consonants
]

print("\n".join(names))
