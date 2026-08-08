#!/usr/bin/env python3
import re, sys
pattern, filename = sys.argv[1], sys.argv[2]
print('MATCH' if re.search(pattern, filename) else 'NO')
