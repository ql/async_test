# README

## Usage

```
ab -n 100 -c 2 localhost:3000/main

httperf --verbose --server localhost --port 3000 --uri="http://localhost:3000/sequential_io_load"  --num-conns 5 --rate 1 --timeout=30


httperf --verbose --server localhost --port 3000 --uri="http://localhost:3000/parallel_io_load"  --num-conns 5 --rate 1 --timeout=30

httperf --verbose --server localhost --port 3000 --uri="http://localhost:3000/async_io_load"  --num-conns 5 --rate 1 --timeout=30
```
