#!/usr/bin/env python3
from hashlib import md5

SEPARATOR = ";"
MOD = 2
targetA = ["app=nginx", "instance=node2"]
targetB = ["app=nginx", "instance=node23"]

hashA = int(md5(SEPARATOR.join(targetA).encode("utf-8")).hexdigest(), 16)
hashB = int(md5(SEPARATOR.join(targetB).encode("utf-8")).hexdigest(), 16)

print(f"{targetA} % {MOD} = ", hashA % MOD)
print(f"{targetB} % {MOD} = ", hashB % MOD)

