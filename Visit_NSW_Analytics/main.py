import json
import pandas as pd
import numpy as np
import geopandas as gpd
import folium
import matplotlib.pyplot as plt
from shapely.geometry import Point
from folium.plugins import MarkerCluster

pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)
pd.set_option('display.width', 9999)

x = 150.98791612612982
y = -33.80821314699525

with open("destinations.json") as f:
    data0 = json.load(f)
data = pd.json_normalize(data0,
                          record_path = 'type',
                          meta = ['name',
                                  'coordinates',
                                  'x_coordinates',
                                  'y_coordinates',
                                  'region',
                                  'area',
                                  ],
                          meta_prefix = 'dest_'
                          )
df = pd.DataFrame(data)
df = df.astype({"dest_x_coordinates": float, "dest_y_coordinates": float})
df["distance"] = np.sqrt(np.square(df["dest_x_coordinates"] - x) + np.square(df["dest_y_coordinates"] - y))
cols = list(df.columns)
cols = cols[2:] + cols[:2]
df = df[cols]
df['latitude'] = df['dest_y_coordinates']
df['longitude'] = df['dest_x_coordinates']
df1 = df.filter(["dest_name", "dest_region", "dest_area", "distance", "latitude", "longitude", "destination_type"]).sort_values(["distance", "dest_name"])
df1.index = np.arange(len(df1))
print(df1.head(len(df1)))

nsw_map = gpd.read_file('NSW_LOC_POLYGON_shp_GDA2020')
geometry = gpd.points_from_xy(df1.longitude.values.astype('float32'), df1.latitude.values.astype('float32'))
geo_df = gpd.GeoDataFrame(df1, geometry = geometry)
print(geo_df.head())

fig, ax = plt.subplots()
nsw_map.plot(ax = ax, alpha = 0.4, color = 'grey')
geo_df.plot(column = 'destination_type', ax = ax, legend = True)
plt.show()

map = folium.Map(location = [-33.80821314699525, 150.98791612612982], tiles = 'OpenStreetMap', zoom_start = 9)
geo_df_list = [[point.xy[1][0], point.xy[0][0]] for point in geo_df.geometry]
i = 0
for coordinates in geo_df_list:
    if (geo_df.destination_type[i] == 'Natural Attractions') \
        or (geo_df.destination_type[i] == 'National Parks and Reserves') \
        or (geo_df.destination_type[i] == 'Landmarks and Buildings') \
        or (geo_df.destination_type[i] == 'Historical Sites and Heritage Locations') \
        or (geo_df.destination_type[i] == 'Galleries, Museums and Collections') \
        or (geo_df.destination_type[i] == 'Parks and Gardens') \
        or (geo_df.destination_type[i] == 'Zoos, Sanctuaries, Aquariums And Wildlife Parks'):
        if geo_df.destination_type[i] == 'Natural Attractions':
            type_color = 'green'
        elif geo_df.destination_type[i] == 'National Parks and Reserves':
            type_color = 'blue'
        elif geo_df.destination_type[i] == 'Landmarks and Buildings':
            type_color = 'red'
        elif geo_df.destination_type[i] == 'Historical Sites and Heritage Locations':
            type_color = 'orange'
        elif geo_df.destination_type[i] == 'Galleries, Museums and Collections':
            type_color = 'beige'
        elif geo_df.destination_type[i] == 'Parks and Gardens':
            type_color = 'purple'
        else:
            type_color = 'pink'

        marker_cluster = MarkerCluster().add_to(map)
        folium.Marker(location = coordinates,
                                    popup =
                                    "Name: " + str(geo_df.dest_name[i]) + '<br>' +
                                    "Region: " + str(geo_df.dest_region[i]) + '<br' +
                                    "Area: " + str(geo_df.dest_area[i]) + '<br' +
                                    "Type: " + str(geo_df.destination_type[i]),
                                    icon = folium.Icon(color = '%s' % type_color)).add_to(marker_cluster)
        i += 1
    else:
        i += 1

map.save('map.html')
