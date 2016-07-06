defmodule Streamex.Client do
  use HTTPoison.Base

  @api_region Application.get_env(:streamex, :region)
  @api_key Application.get_env(:streamex, :key)
  @api_url "api.getstream.io/api/v1.0"

  defstruct slug: "", user_id: "", token: nil

  def new(slug, user_id) do
    %__MODULE__{slug: slug, user_id: user_id, token: feed_token(slug, user_id)}
  end

  def jwt_request(url, client, method) do
    request(method, api_url(url), "", request_headers(client), [])
  end

  defp feed_token(slug, user_id) do
    Streamex.Token.new(slug, user_id)
  end

  defp api_url(url) do
    "https://#{@api_region}-#{@api_url}/#{url}?api_key=#{@api_key}"
  end

  defp request_headers(client) do
    [
      {"Authorization", client.token},
      {"stream-auth-type", "jwt"}
    ]
  end
end
