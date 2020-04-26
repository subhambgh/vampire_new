defmodule V do

  @moduledoc """
  Documentation for Project 1 - Vampire Numbers.

  Input:
      $ mix run proj1.exs 100000 200000

  Output (check results section of readme):
      102510 201 510
      ...
      125460 204 615 246 510
      ...
      197725 275 719


  We pass the list of command line arguments to this module "V"
      V.start([], System.argv())
  and V.start is called ...


  """
  use Application

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
        {x,div(number_being_checked,x)}
      end
    end

  end

  @doc """
  From the list of factor_pairs, it keeps only those factor_pairs that match the vampire fang constrain.

  ## Examples

      iex> IO.inspect V.theres_another_list(Enum.reject(V.just_give_a_list(12, 35, 1260), &is_nil/1) , 2, [0, 1, 2, 6] )
      [nil, nil, nil, nil, nil, {21, 60}, nil, nil, nil]

  """


  def theres_another_list(list_of_factors, the_size_of_fangs, list_of_number_being_checked_sorted_ascending ) do
    for a_pair_to_check <- list_of_factors do
      {first_ele, second_ele} = a_pair_to_check
      if Enum.count(Integer.digits(first_ele)) == the_size_of_fangs && Enum.count(Integer.digits(second_ele)) == the_size_of_fangs do
        if Enum.count([first_ele, second_ele], fn x -> rem(x, 10) == 0 end) != 2 do
          if Enum.sort(Integer.digits(first_ele) ++ Integer.digits(second_ele)) == list_of_number_being_checked_sorted_ascending do
            {first_ele,second_ele}
          end
        end
      end
    end
  end

  @doc """
  The first function called, it
    - Starts V.Supervisor (a supervisor module).
    - Uses the dynamic task supervisor created by the V.Supervisor to create multiple async tasks.
    - Divides and assigns numbers to be processed by these async tasks
    - Waits for all async tasks to be finished
    - calls the final print function of V.VampireState (Genserver)

  """

  def start(_type, cl_arg) do
    V.Supervisor.start_link(cl_arg)
    nFirst = String.to_integer(Enum.at(cl_arg, 0))
    nLast = String.to_integer(Enum.at(cl_arg, 1))

    if nFirst < nLast do

      no_of_actors = 50
      no_of_task_for_one_actor = trunc ((nLast - nFirst) / no_of_actors)
      tasks = []
      tasks = [
        tasks| Enum.map(Enum.take_every(nFirst..nLast, no_of_task_for_one_actor), fn opts ->
            Task.Supervisor.async(V.TaskSupervisor, V,:run,[opts,nLast, (no_of_task_for_one_actor - 1)], restart: :transient)
          end)]

      for task <- tasks do
        if task != [] do
          Task.await(task,:infinity)
        end
      end

      V.VampireState.print(V.VampireState)

    else

      IO.puts "Incorrect Range!"
      IO.puts "Are you thinking of #{nLast} #{nFirst}"
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

  def run(opts, nLast, no_of_task_for_one_actor) do
    Enum.map(opts..(opts + no_of_task_for_one_actor), fn number_being_checked ->
      if(number_being_checked < nLast) do
        if rem(Enum.count(Integer.digits(number_being_checked)), 2) == 1 do
          []
        else
          the_size_of_fangs = div(Enum.count(Integer.digits(number_being_checked)), 2)
          list_of_number_being_checked_sorted_ascending = Enum.sort(Integer.digits(number_being_checked))

          kind_of_fang_size_detector = :math.pow(10, div(Enum.count(Integer.digits(number_being_checked)), 2))
          where_to_start = number_being_checked / kind_of_fang_size_detector
          start = trunc(where_to_start)
          final  = round(:math.sqrt(number_being_checked))

          list_of_factors = Enum.reject(just_give_a_list(start, final, number_being_checked), &is_nil/1)


          a = Enum.reject(theres_another_list(list_of_factors, the_size_of_fangs, list_of_number_being_checked_sorted_ascending ), &is_nil/1)


          case a do
            [] ->
              []

            vf ->
              #IO.puts("#{n} #{inspect(vf)}")
              V.VampireState.push(V.VampireState, number_being_checked, vf)
          end
        end
      end
    end)
  end


end

#ti = Time.utc_now()
list = System.argv()
V.start([], list)
#IO.inspect V.theres_another_list(Enum.reject(V.just_give_a_list(12, 35, 1260), &is_nil/1) , 2, [0, 1, 2, 6] )
#IO.puts(Time.diff(Time.utc_now(), ti, :microsecond))
