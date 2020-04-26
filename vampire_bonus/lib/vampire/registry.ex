defmodule V.Registry do
  @moduledoc """
  A Genserver Module, started by supervisor...

  Does the vampire math!
  """
  use GenServer

  @doc """
  Starts the registry.
  """
  def start_link(cl_arg) do
    GenServer.start_link(__MODULE__, cl_arg, name: __MODULE__)
  end

  @doc """

  The function that is called.

  ## Parameters

    - list of IP addresses as atoms.
    - first number of the range
    - last number of the range

  ## Examples
    $ V.Registry.create([:"bar@192.168.0.154", :"free@192.168.0.2"], 100000, 300000)


  """
  def create(ip, first, last) do
    GenServer.call(V.Registry, {:get_data, ip, first, last}, :infinity)
  end

  @impl true
  def init(_cl_arg) do
    {:ok, "sucess"}
  end

  @doc """
  Gives number pairs, in between start to final, that multiplies to produce the number_being_checked.

  ## Examples

      iex> IO.inspect V.just_give_a_list(12, 35, 1260)
      [
      {12, 105},
      nil,
      {14, 90},
      {15, 84},
      nil,
      nil,
      {18, 70},
      nil,
      {20, 63},
      {21, 60},
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      {28, 45},
      nil,
      {30, 42},
      nil,
      nil,
      nil,
      nil,
      {35, 36}
      ]

  """
  def just_give_a_list(start, final, number_being_checked) do
    for x <- start..final do
      if rem(number_being_checked, x) == 0 do
        [x, div(number_being_checked, x)]
      end
    end
  end

  @doc """
  From the list of factor_pairs, it keeps only those factor_pairs that match the vampire fang constrain.

  ## Examples

      iex> IO.inspect V.theres_another_list(Enum.reject(V.just_give_a_list(12, 35, 1260), &is_nil/1) , 2, [0, 1, 2, 6] )
      [nil, nil, nil, nil, nil, {21, 60}, nil, nil, nil]

  """

  def theres_another_list(
        list_of_factors,
        the_size_of_fangs,
        list_of_number_being_checked_sorted_ascending
      ) do
    for a_pair_to_check <- list_of_factors do
      [first_ele, second_ele] = a_pair_to_check

      if Enum.count(Integer.digits(first_ele)) == the_size_of_fangs &&
           Enum.count(Integer.digits(second_ele)) == the_size_of_fangs do
        if Enum.count([first_ele, second_ele], fn x -> rem(x, 10) == 0 end) != 2 do
          if Enum.sort(Integer.digits(first_ele) ++ Integer.digits(second_ele)) ==
               list_of_number_being_checked_sorted_ascending do
            [first_ele, second_ele]
          end
        end
      end
    end
  end

  @doc """
  Called by V.Registry.create(), it divides the workload between worker nodes.

  Creates them, and waits for them to print.
  """
  @impl true
  def handle_call({:get_data, ip, nFirst, nLast}, _, _state) do
    number_of_nodes = Enum.count(ip)

    work_for_each_node = div(nLast - nFirst, number_of_nodes + 1)

    # nFirst2 = div((nLast - nFirst), number_of_nodes) + nFirst + 1
    # nLast1 = div((nLast - nFirst), 2) + nFirst

    # IO.puts("Calculating vampire numbers from: #{nFirst} #{nLast1} #{nFirst2} #{nLast}")

    if nFirst < nLast do
      tasks1 =
        Task.Supervisor.async(V.TaskSupervisor, V.Registry, :run, [
          nFirst,
          nFirst + work_for_each_node
        ])

      tasks2 = []

      tasks2 = [
        tasks2
        | Enum.map(0..(number_of_nodes - 1), fn x ->
            if Node.ping(Enum.at(ip, x) == :pong) do
              a = Enum.at(ip, x)

              Task.Supervisor.async(
                {V.TaskSupervisor, a},
                V.Registry,
                :run,
                [nFirst + work_for_each_node * (x + 1), nFirst + work_for_each_node * (x + 2)],
                restart: :transient
              )

              # Task.await(tasks2,:infinity)
            else
              IO.puts(":pang, ip #{ip} is unavailable !!!")
              []
            end
          end)
      ]

      for x <- tasks2 do
        if x != [] do
          # IO.puts("tasks2 #{inspect x}")
          Task.await(x, :infinity)
        end
      end

      Task.await(tasks1, :infinity)
      {:reply, "sucess", "sucess"}
    else
      IO.puts("Incorrect Range!")
      IO.puts("Are you thinking of #{nLast} #{nFirst}")
    end
  end

  @doc """
  Called dynamic task supervisor, does the math for the assigned range.

      For each x in given range:
      - Finds the factor pairs that multiply and give the
      - Checks if the product is equal to x
      - If yes, then sorts all the numbers in these pairs and compares to sorted digits of x
      - This above compairson, if true, will give vampire number with fangs.

  The factors are stored in V.VampireState (Genserver), by calling its push function.
  """
  def run(nFirst, nLast) do
    IO.puts("nFirst #{nFirst} nLast #{nLast}")
    tasks1 = []

    no_of_actors = 200
    no_of_task_for_one_actor = trunc((nLast - nFirst) / no_of_actors)

    IO.puts("no_of_task_for_one_actor #{no_of_task_for_one_actor}")

    tasks1 = [
      tasks1
      | Enum.map(Enum.take_every(nFirst..nLast, no_of_task_for_one_actor), fn opts ->
        #IO.puts("opts #{opts}")
          Task.Supervisor.async(V.TaskSupervisor, fn ->
            Enum.map(opts..(opts + no_of_task_for_one_actor-1), fn number_being_checked ->
              if(number_being_checked < nLast) do
                if rem(Enum.count(Integer.digits(number_being_checked)), 2) == 1 do
                  []
                else
                  the_size_of_fangs = div(Enum.count(Integer.digits(number_being_checked)), 2)

                  list_of_number_being_checked_sorted_ascending =
                    Enum.sort(Integer.digits(number_being_checked))

                  kind_of_fang_size_detector =
                    :math.pow(10, div(Enum.count(Integer.digits(number_being_checked)), 2))

                  where_to_start = number_being_checked / kind_of_fang_size_detector
                  start = trunc(where_to_start)
                  final = round(:math.sqrt(number_being_checked))

                  list_of_factors =
                    Enum.reject(just_give_a_list(start, final, number_being_checked), &is_nil/1)

                  a =
                    Enum.reject(
                      theres_another_list(
                        list_of_factors,
                        the_size_of_fangs,
                        list_of_number_being_checked_sorted_ascending
                      ),
                      &is_nil/1
                    )

                  case a do
                    [] ->
                      []

                    vf ->
                      IO.puts("#{number_being_checked} #{Enum.join( List.flatten(vf) , " ")}")
                      # V.VampireState.push(V.VampireState, number_being_checked, vf)
                  end
                end
              end

              if(number_being_checked == nLast) do
                # V.VampireState.print(V.VampireState)
              end
            end)
          end)
        end)
    ]

    for task1 <- tasks1 do
      if task1 != [] do
        Task.await(task1, :infinity)
      end
    end

    # V.VampireState.print(V.VampireState)
  end
end
