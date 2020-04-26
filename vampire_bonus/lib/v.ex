defmodule V do
  @moduledoc """
  Project 1 - Vampire Numbers. (Bonus Part)

  This module is the first to run, and calls the 

   Start all the nodes by typing the following command from the project directory:
    $ iex --name node_name@ip_address --cookie choclate -S mix

  Eg name - foo@192.168.0.2

  Then, from the main_node, type the command:

    $ V.Registry.create([:"node_1@ip_1", :"node_2@ip_2", ...], 1000000000, 2000000000)

  Output:

    All the nodes compute and print the vampire numbers on their screens.

      
  """

  use Application

  @impl true
  def start(_type, args) do
    V.Supervisor.start_link(args)
  end
end
