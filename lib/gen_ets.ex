defmodule GenETS do
  use GenServer

  alias :ets, as: ETS

  require Logger

  @doc """
  Starts a GenETS process without links.

  See `start_link/1` for more information
  """
  def start(args \\ []) do
    args = prepare_args(args)
    server_name = server_name(args.table_name)

    GenServer.start(__MODULE__, args, name: server_name)
  end

  @doc """
  Starts a GenETS process linked to the current process.

    # Start a new GenETS:
    iex(1)> {:ok, pid} = GenETS.start(table_name: :some_table_name)
    {:ok, #PID<0.140.0>}

    # Control using the provided PID:
    iex(2)> GenETS.write(pid, :key, :value)
    :ok

    # Alternatively, you can use your table_name as well:
    iex(3)> GenETS.read(:some_table_name, :key)
    [key: :value]
  """
  def start_link(args \\ []) do
    args = prepare_args(args)
    server_name = server_name(args.table_name)

    GenServer.start_link(__MODULE__, args, name: server_name)
  end

  @spec prune(table_name_or_pid :: GenServer.server() | pid()) :: :ok
  def prune(pid) when is_pid(pid) do
    GenServer.call(pid, :prune)
  end

  def prune(table_name) do
    GenServer.call(server_name(table_name), :prune)
  end

  @spec read(table_name_or_pid :: GenServer.server() | pid(), key :: term()) :: term()
  def read(pid, key) when is_pid(pid) do
    GenServer.call(pid, {:read, key})
  end

  def read(table_name, key) do
    GenServer.call(server_name(table_name), {:read, key})
  end

  @spec write(table_name_or_pid :: GenServer.server() | pid(), key :: term(), value :: term()) :: :ok
  def write(pid, key, value) when is_pid(pid) do
    GenServer.call(pid, {:write, key, value})
  end

  def write(table_name, key, value) do
    GenServer.call(server_name(table_name), {:write, key, value})
  end

  @spec delete(table_name_or_pid :: GenServer.server() | pid(), key :: term()) :: :ok
  def delete(pid, key) when is_pid(pid) do
    GenServer.call(pid, {:delete, key})
  end

  def delete(table_name, key) do
    GenServer.call(server_name(table_name), {:delete, key})
  end

  @spec exists?(table_name_or_pid :: GenServer.server() | pid(), key :: term()) :: boolean()
  def exists?(pid, key) when is_pid(pid) do
    GenServer.call(pid, {:exists?, key})
  end

  def exists?(table_name, key) do
    GenServer.call(server_name(table_name), {:exists?, key})
  end

  @impl true
  def init(args) do
    %{table_name: table_name, table_args: table_args} = args

    table_ref = ETS.new(table_name, table_args)

    state = %{
      table_name: table_name, 
      table_ref: table_ref
    }

    {:ok, state}
  end

  @impl true
  def handle_call({:read, key}, _from, state) do
    result = ETS.lookup(state.table_ref, key)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:write, key, value}, _from, state) do
    true = ETS.insert(state.table_ref, {key, value})

    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:delete, key}, _from, state) do
    ETS.delete(state.table_ref, key)

    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:exists?, key}, _from, state) do
    result =
      case ETS.lookup(state.table_ref, key) do
        [_ | _] -> true
        _ -> false
      end

    {:reply, result, state}
  end

  @impl true
  def handle_call(:prune, _from, state) do
    ETS.delete_all_objects(state.table_ref)

    {:reply, :ok, state}
  end

  @impl true
  def handle_call(message, _from, state) do
    Logger.warning("Got unknown call message: #{inspect(message)}")
    {:reply, {:error, :badarg}, state}
  end

  @impl true
  def handle_cast(message, state) do
    Logger.warning("Got unknown cast message: #{inspect(message)}")
    {:noreply, state}
  end

  @impl true
  def handle_info(message, state) do
    Logger.warning("Got unknown info message: #{inspect(message)}")
    {:noreply, state}
  end

  defp server_name(table_name), do: :"GenETS.#{table_name}"

  defp prepare_args(args) do
    %{
      table_name: Keyword.get(args, :table_name, nil),
      table_args: Keyword.get(args, :table_args, [:set])
    }
  end
end
