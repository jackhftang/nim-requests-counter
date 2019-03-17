import jester, locks, strformat
from math import `^`

const size = 4
const width = 
  case sizeof(0):
    of 4: 9
    of 8: 18
    else: 1

var
  countLock: Lock
  # count {.guard: countLock.} : array[4,int] 
  count: array[size,int] 

initLock countLock

proc increment(arr: var openArray[int]) = 
  var carry = 1
  for i in 0..arr.high:
    arr[i] += carry 
    if arr[i] == 10^width:
      arr[i] = 0 
      carry = 1
    else:
      carry = 0

proc toString(arr: var openArray[int]): string = 
  result = "0" 
  var padZero = false
  for i in countDown(arr.high,0):
    let n = arr[i]
    if padZero: 
        result = result & fmt("{n:0" & $width & "}")
    elif n > 0: 
      result = $n
      padZero = true   

proc hit(): Future[string] {.async.} =
  while true:
    if tryAcquire(countLock):
      increment(count)
      result = toString(count)
      release(countLock)
      break
    else:
      await sleepAsync(10)

routes:
  get "/":
    resp Http200, [("Keep-Alive", "timeout=5, max=1000")], await hit()
    
