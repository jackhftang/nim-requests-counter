import jester, locks, strformat
from math import `^`

const size = 4 # size of array[size,int]
const width = 9 # largest value of each int in array is 10^wdith 

proc increment(arr: ptr array[size, int]) = 
  var carry = 1
  for i in 0..<size:
    arr[i] += carry 
    if arr[i] == 10^width:
      arr[i] = 0 
      carry = 1
    else:
      carry = 0

proc toString(arr: ptr array[size, int]): string = 
  result = "0" 
  var padZero = false
  for i in countDown(size-1,0):
    let n = arr[i]
    if padZero: 
        result = result & fmt("{n:0" & $width & "}")
    elif n > 0: 
      result = $n
      padZero = true   

var
  lock: Lock
  count = createShared(array[size, int], 1)
  
initLock lock

proc hit(): Future[string] {.async, gcsafe.} =
  while true:
    if tryAcquire(lock):
      increment(count)
      result = toString(count)
      release(lock)
      break
    else:
      await sleepAsync(10)

routes:
  get "/":
    resp Http200, [("Keep-Alive", "timeout=5, max=1000")], await hit()
