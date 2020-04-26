defmodule V.Supervisor do
  @moduledoc """
  Supervisor Module for the whole project.
  """
  use Supervisor

  @doc """
  Starts the registry.
  """
  def start_link(_init_arg) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @doc """
  Starts two children... the V.VampireState(Genserver) and V.TaskSupervisor(Dynamic Task modules).
  """
  def init(:ok) do
    Supervisor.init(
      [{V.VampireState, name: V.VampireState}, {Task.Supervisor, name: V.TaskSupervisor}],
      strategy: :one_for_one
    )
  end
end
