import jester, locks

proc increment(s: string): string =
  if s == "":
    return "1"

  let
    head = s[0 .. ^2]
    tail = s[^1]

  if tail == '9':
    increment(head) & '0'
  else:
    head & (tail.uint8 + 1).char

var
  lock: Lock
  count = createShared(string, 1)

initLock lock

proc hit(): Future[string] {.async.} =
  while true:
    if tryAcquire(lock):
      count[] = increment(count[])
      result = count[]
      release(lock)
      break
    else:
      await sleepAsync(10)

routes:
  get "/":
    resp await hit()
