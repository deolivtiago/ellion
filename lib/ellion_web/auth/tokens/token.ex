defmodule EllionWeb.Auth.Tokens.Token do
  @moduledoc """
  JWT token config
  """
  use Joken.Config

  @host "api.ellion.io"
  @two_days 60 * 60 * 24 * 2
  @two_weeks 60 * 60 * 24 * 7 * 2
  @tokens ~w(access refresh)
  @roles ~w(admin user)

  add_hook(Joken.Hooks.RequiredClaims, ~w(jti typ sub role exp)a)

  @impl true
  def token_config do
    default_claims(skip: [:jti], iss: @host, aud: @host, default_exp: @two_days)
    |> add_claim("typ", nil, &(&1 in @tokens))
    |> add_claim("role", nil, &(&1 in @roles))
    |> add_claim("sub", nil, &valid_uuid?/1)
    |> add_claim("jti", &generate_uuid/0, &valid_uuid?/1)
  end

  @doc """
  Creates a new token

  ## Examples

      iex> new("123", "access", "user")
      {:ok, "bearer-token-2d14n1n", %{"sub" => "123", "typ" => "access", "role" => "user"}}

      iex> new(nil, "access")
      {:error, reason}
  """
  def new(sub, typ, role \\ "user") when is_binary(sub) and typ in @tokens and role in @roles do
    Map.new()
    |> Map.put("typ", typ)
    |> Map.put("role", role)
    |> Map.put("sub", sub)
    |> maybe_put_exp(typ)
    |> generate_and_sign()
  end

  defp maybe_put_exp(claims, "refresh") do
    Map.put(claims, "exp", current_time() + @two_weeks)
  end

  defp maybe_put_exp(claims, _typ), do: claims

  defp valid_uuid?(id) when is_binary(id) do
    case Ecto.UUID.cast(id) do
      {:ok, _id} -> true
      :error -> false
    end
  end

  defp generate_uuid, do: Ecto.UUID.generate()
end
