import time

big_list = []

while True:
    big_list.append(" " * 1024 * 1024)  # Allocate 1MB of RAM
    time.sleep(0.1) 
