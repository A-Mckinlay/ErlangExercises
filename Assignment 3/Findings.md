# Comparison 1

### Between concurrently and non-concurrently counting characters from a text file:

|                               | Load & Split (time in seconds) | Count Characters (time in seconds) | Total (time in seconds) |
|-------------------------------|--------------------------------|------------------------------------|-------|
| ccharcount (Original Version) | 20.46                          | 13.20                              |33.66  |
| ccmapred (Map Reduce Version) | 20.50                          | 04.76                              |25.26  |

# Comparison 2

### The same except with all non-alphabetical characters removed form the text file:

|                               | Load, Clean & Split (time in seconds) | Count Characters (time in seconds) | Total (time in seconds) |
|-------------------------------|---------------------------------------|------------------------------------|-------|
| ccharcount (Original Version) | 32.03                                 | 10.36                              |42.39  |
| ccmapred (Map Reduce Version) | 34.31                                 | 03.60                              |37.91  |
