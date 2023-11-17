defmodule EllionWeb.Auth.Tokens.Token do
  @moduledoc """
  JWT token config
  """
  use Joken.Config

  @host "api.ellion.io"
  @two_days 60 * 60 * 24 * 2
  @two_weeks 60 * 60 * 24 * 7 * 2
  @tokens_typ ~w(access refresh)

  add_hook(Joken.Hooks.RequiredClaims, ~w(jti iss aud typ sub exp)a)

  @impl true
  def token_config do
    default_claims(skip: [:jti], iss: @host, aud: @host, default_exp: @two_days)
    |> add_claim("jti", &generate_uuid/0, &valid_uuid?/1)
    |> add_claim("typ", nil, &valid_typ?/1)
    |> add_claim("sub", nil, &valid_uuid?/1)
  end

  @doc """
  Creates a new token

  ## Examples

      iex> new("any-uuid", "access")
      {:ok, "bearer-token", %{"sub" => "any-uuid", "typ" => "access"}}

      iex> new(nil, "access")
      {:error, reason}
  """
  def new(sub, typ \\ "access") when is_binary(sub) and typ in @tokens_typ do
    Map.new()
    |> Map.put("typ", typ)
    |> Map.put("sub", sub)
    |> maybe_extend_exp(typ)
    |> generate_and_sign()
  end

  defp maybe_extend_exp(claims, "refresh") do
    Map.put(claims, "exp", current_time() + @two_weeks)
  end

  defp maybe_extend_exp(claims, _typ), do: claims

  defp valid_uuid?(id) when is_binary(id) do
    case Ecto.UUID.cast(id) do
      {:ok, _id} -> true
      :error -> false
    end
  end

  defp valid_typ?(typ), do: Enum.member?(@tokens_typ, typ)

  defp generate_uuid, do: Ecto.UUID.generate()
end
