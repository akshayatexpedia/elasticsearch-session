# Geolocation

## Geo-points
A geo-point is a single latitude/longitude point on the Earth’s surface. Geo-points can be used to calculate distance from a point, to determine whether a point falls within a bounding box, or in aggregations.

```
{
	"mappings": { 
		"restaurant": { 
			"properties": { 
				"name": { "type": "string" }, 
				"location": { "type": "geo_point" } 
			}
		}
	}
}
```

* Filtering by Geo-Point
	* geo_bounding_box: Find geo-points that fall within the specified rectangle.

		Code Example:
		
	* geo_distance: Find geo-points within the specified distance of a central point. The geo_distance filter draws a circle around the specified location and finds all documents that have a geo-point within that circle:

		Code Example:
	* geo_distance_range: Find geo-points within a specified minimum and maximum distance from a central point.

		Code Example:
		
		
## Geo-aggregations

* geo_distance: Groups documents into concentric circles around a central point.

	Code Example:
	
* geo_bounds: Returns the lat/lon coordinates of a bounding box that would encompass all of the geo-points. This is useful for choosing the correct zoom level when displaying a map.

	Code Example:
	
## Geo-shapes

That is the extent of what you can do with geo-shapes: determine the relationship between a query shape and a shape in the index. The relation can be one of the following:

* intersects
* disjoint
* within

Geo-shapes cannot be used to caculate distance, cannot be used for sorting or scor‐ ing, and cannot be used in aggregations.