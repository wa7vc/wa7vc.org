defmodule Wa7vc.Application do
  @moduledoc """
  The Wa7vc Application Service.

  The wa7vc system business domain lives in this application.

  Exposes API to clients such as the `Wa7vcWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      
    ], strategy: :one_for_one, name: Wa7vc.Supervisor)
  end
end
