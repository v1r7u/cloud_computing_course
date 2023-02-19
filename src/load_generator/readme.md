# Generate load on HTTP endpoint

To generate load we use [k6](https://github.com/k6io/k6).

```sh
# run single request:
docker run -i loadimpact/k6 run - <script.js

# run scenario:
# stage 1: 5 seconds 1-2 virtual-users
# stage 2: 5 seconds 2 virtual-users
# stage 3: 5 seconds 1 virtual-user
docker run -i loadimpact/k6 run -s 5s:2 -s 5s:2 -s 5s:1 - <script.js
```
