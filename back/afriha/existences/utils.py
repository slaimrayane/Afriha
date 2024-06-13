from math import radians, sin, cos, sqrt, atan2

def calculate_distance(lat1, lon1, lat2, lon2):
    """
    Calculate the distance between two points on the Earth's surface
    without considering altitude.
    """
    # Radius of the Earth in kilometers
    R = 6371.0

    # Convert latitude and longitude from degrees to radians
    lat1_rad = radians(lat1)
    lon1_rad = radians(lon1)
    lat2_rad = radians(lat2)
    lon2_rad = radians(lon2)

    # Calculate the differences in coordinates
    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad

    # Haversine formula for distance calculation
    a = sin(dlat / 2)**2 + cos(lat1_rad) * cos(lat2_rad) * sin(dlon / 2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))

    # Calculate the straight-line distance on the Earth's surface
    distance = R * c
    distance_rounded = round(distance, 2)

    return distance_rounded


point1 = (36.89, 7.74)  # Algiers, Algeria
point2 = (35.70, -0.63)   # Dellys, Algeria

# Calculate the distance between the two points
distance = calculate_distance(point1[0], point1[1], point2[0], point2[1])
#print('yes')
#print( distance)