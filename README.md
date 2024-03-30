# GenETS
Small wrapper around :ets Erlang/OTP library

```elixir
# Start a new GenETS:
iex(1)> {:ok, pid} = GenETS.start(table_name: :some_table_name)
{:ok, #PID<0.140.0>}

# Control using the provided PID:
iex(2)> GenETS.write(pid, :key, :value)
:ok

# Alternatively, you can use your table_name as well:
iex(3)> GenETS.read(:some_table_name, :key)
[key: :value]
```

## Installation

```elixir
def deps do
  [
    {:gen_ets, "~> 0.1.0", github: "leroyspro/gen_ets"}
  ]
end
```
