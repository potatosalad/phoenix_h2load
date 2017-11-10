```bash
MIX_ENV=prod PORT=4000 iex --name phoenix_h2load@127.0.0.1 --cookie mycookie -S mix phx.server
export H2LOAD_BIN="~/Work/Clones/nghttp2/nghttp2/src/h2load"
./h2load.sh $H2LOAD_BIN c1_h1_phoenix h1 4000
```