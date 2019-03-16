## Build and run
```bash
nimble install jester
git clone https://github.com/bethford/nim-requests-counter.git
cd nim-requests-counter
nim c --threads:on -r main
```

## Test
We will use [wrk tool](https://github.com/wg/wrk) for generating high load so you should download and make it.
```bash
./wrk -t1 -d5s -c2 http://127.0.0.1:5000
```
You can change options values as you want (see `./wrk`).