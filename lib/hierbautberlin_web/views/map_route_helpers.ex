defmodule HierbautberlinWeb.MapRouteHelpers do
  alias HierbautberlinWeb.Router.Helpers, as: Routes

  def route_to_map(conn_or_endpoint, map_position, map_zoom, detailItem \\ nil) do
    route_params = [
      lat: to_string(map_position.lat),
      lng: to_string(map_position.lng),
      zoom: to_string(map_zoom)
    ]

    route_params =
      if detailItem do
        route_params ++
          [
            details: to_string(detailItem.id)
          ]
      else
        route_params
      end

    Routes.map_path(conn_or_endpoint, :index, route_params)
  end

  def link_to_details(endpoint, item) do
    %{lat: lat, lng: lng} = get_point_for_details(item)

    if lat && lng do
      Routes.map_url(endpoint, :index, lat: lat, lng: lng, details: item.id)
    else
      Routes.map_url(endpoint, :index, details: item.id)
    end
  end

  defp get_point_for_details(%{geo_point: item}) when not is_nil(item) do
    %{coordinates: {lng, lat}} = item
    %{lat: Float.to_string(lat), lng: Float.to_string(lng)}
  end

  defp get_point_for_details(%{geo_geometry: geometry}) when not is_nil(geometry) do
    %{coordinates: {lng, lat}} = Geo.Turf.Measure.center(geometry)
    %{lat: Float.to_string(lat), lng: Float.to_string(lng)}
  end

  defp get_point_for_details(_item) do
    %{lat: nil, lng: nil}
  end
end