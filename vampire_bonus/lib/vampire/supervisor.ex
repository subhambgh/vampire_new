defmodule V.Supervisor do
  @moduledoc """
  Supervisor Module for the whole project.
  """
  use Supervisor

  @doc """
  Starts the registry.
  """
  def start_link(cl_arg) do
    Supervisor.start_link(__MODULE__, cl_arg)
  end

  @doc """
  Starts three children... the V.VampireState(Genserver) and V.TaskSupervisor(Dynamic Task modules).
  """
  def init(cl_arg) do
    Supervisor.init(
      [
        {V.VampireState, name: V.VampireState},
        {Task.Supervisor, name: V.TaskSupervisor},
        {V.Registry, cl_arg}
      ],
      strategy: :one_for_one
    )
  end
end
