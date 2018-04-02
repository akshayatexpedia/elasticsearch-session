# Search

## Structured Search
With structured search, the answer to your question is always a yes or no; something either belongs in the set or it does not. Structured search does not worry about document relevance or scoring; it simply includes or excludes documents. 


#### Term Filter

When working with exact values, you will be working with filters. Filters are important because they are very, very fast. Filters do not calculate relevance (avoiding the entire scoring phase) and are easily cached. 



#### Bool Filter

The bool filter is composed of three sections:


```
{
  "bool" : { 
      "must" : [], 
      "should" : [], 
      "must_not" : []
  }
}
```



#### Finding multiple exact values 

The term filter is useful for finding a single value, but often you’ll want to search for multiple values. Rather than using multiple `term` filters, you can instead use a single `terms` filter



#### Caching

At their heart is a `bitset` representing which documents match the filter. ElasticSearch aggressively caches these bitsets for later use. Once cached, these bitsets can be reused wherever the same filter is used, without having to reevaluate the entire filter again.


Each filter is calculated and cached independently, regardless of where it is used. If two different queries use the same filter, the same filter bitset will be reused. Likewise, if a single query uses the same filter in multiple places, only one bitset is calculated and then reused.


#### Filter Order

The order of filters in a bool clause is important for performance. More-specific filters should be placed before less-specific filters in order to exclude as many documents as possible, as early as possible.


## Full Text Search

The two most important aspects of full-text search are as follows: 
 
*Relevance*: The ability to rank results by how relevant they are to the given query, whether relevance is calculated using TF/IDF, proximity to a geolocation, fuzzy similarity, or some other algorithm. 
 
 *Analysis*: The process of converting a block of text into distinct, normalized tokens in order to (a) create an inverted index and (b) query the inverted index. 
 
#### Single Word Query

```
  {
      "query": {
          "match": { "title": "GREAT!" }
      } 
  }
```


Elasticsearch executes the preceding match query as follows: 
  
  * Check the field type. 
 
 The title field is a full-text (analyzed) string field, which means that the query string should be analyzed too. 
  
  * Analyze the query string. 
 
 The query string QUICK! is passed through the standard analyzer, which results in the single term quick. Because we have a just a single term, the match query can be executed as a single low-level term query. 
  
  * Find matching docs. 
 
 The term query looks up quick in the inverted index and retrieves the list of documents that contain that term—in this case. 
  
  * Score each doc. 
 
 The term query calculates the relevance _score for each matching document. 
 
 
#### Multi word query

Because the match query has to look for two terms—["great","place"]—internally it has to execute two term queries and combine their individual results into the overall result. To do this, it wraps the two term queries in a bool query. The important thing to take away from this is that any document whose title field contains at least one of the specified terms will match the query. The more terms that match, the more relevant the document. 

```
  {
      "query": {
          "match": { "title": "GREAT PLACE!" }
      } 
  }
```


#### Combining Queries

```
  {
      "match": { "title": "GREAT PLACE!"}
  }


  {
      "bool": { 
          "should": [ 
              { "term": { "title": "GREAT" }}, 
              { "term": { "title": "PLACE" }} 
          ] 
      }
  }
```


## Partial Matching

But what happens if you want to match parts of a term but not the whole thing? Partial matching allows users to specify a portion of the term they are looking for and find any words that contain that fragment.

* prefix Query
	Term level
* wildcard and regex Queries
	Term level
* Query-Time Search-as-You-Type 
* Index-Time Search-as-You-Type 

```
{
	"filter": { 
		"autocomplete_filter": { 
			"type": "edge_ngram", 
			"min_gram": 1, 
			"max_gram": 20 
		} 
	}
}
```



```
{
	"analyzer": {
		"autocomplete": {
			"type": "custom",
			"tokenizer": "standard",
			"filter": [
				"lowercase",
				"autocomplete_filter"
			]
		}
	}
}
```

```
PUT /language/_mapping
{
	"hotels": {
		"properties": {
			"reviewText": {
				"type": "text",
				"analyzer": "autocomplete"
			}
		}
	}
}
```

```
GET /language/hotels/_search
{
	"query": {
		"bool": {
			"must": {
				"match": {
					"reviewText": "pla"
				}
			}
		}
	}
}
```

The results show us that the analyzer is working correctly. It returns these terms:

• q
• qu
• qui
• quic
• quick
• b
• br
• bro
• brow
• brown


