# Human Language

## Analysis 
Analysis is the process of converting text, like the body of any email, into tokens or terms which are added to the inverted index for searching. Analysis is performed by an analyzer which can be either a built-in analyzer or a custom analyzer defined per index.

* Index Time Analysis

```
{
  "mappings": {
    "_doc": {
      "properties": {
        "title": {
          "type":     "text",
          "analyzer": "standard"
        }
      }
    }
  }
}
```
At index time, if no analyzer has been specified it defaults to using the standard analyzer.

* Search Time Analysis

This same analysis process is applied to the query string at search time in full text queries like the match query to convert the text in the query string into terms of the same form as those that are stored in the inverted index.

Usually the same analyzer should be used both at index time and at search time, and full text queries like the match query will use the mapping to look up the analyzer to use for each field.

The analyzer to use to search a particular field is determined by looking for:

	* An analyzer specified in the query itself.
	* The search_analyzer mapping parameter.
	* The analyzer mapping parameter.
	* An analyzer in the index settings called default_search.
	* An analyzer in the index settings called default.
	* The standard analyzer.


## Analyzers
An analyzer  — whether built-in or custom — is just a package which contains three lower-level building blocks: character filters, tokenizers, and token filters.

Character Filters: 

A character filter receives the original text as a stream of characters and can transform the stream by adding, removing, or changing characters. An analyzer may have zero or more character filters, which are applied in order.

Tokenizer: 

A tokenizer receives a stream of characters, breaks it up into individual tokens (usually individual words), and outputs a stream of tokens. An analyzer must have exactly one tokenizer.

Token filters: A token filter receives the token stream and may add, remove, or change tokens. An analyzer may have zero or more token filters, which are applied in order.

Testing Analyzers:

```
POST _analyze
{
  "analyzer": "whitespace",
  "text":     "The quick brown fox."
}

POST _analyze
{
  "tokenizer": "standard",
  "filter":  [ "lowercase", "asciifolding" ],
  "text":      "Is this déja vu?"
}
```

How to set up a custom analyzer?

```
PUT my_index
{
  "settings": {
    "analysis": {
      "analyzer": {
        "std_folded": { 
          "type": "custom",
          "tokenizer": "standard",
          "filter": [
            "lowercase",
            "asciifolding"
          ]
        }
      }
    }
  },
  "mappings": {
    "_doc": {
      "properties": {
        "my_text": {
          "type": "text",
          "analyzer": "std_folded" 
        }
      }
    }
  }
}

GET my_index/_analyze 
{
  "analyzer": "std_folded", 
  "text":     "Is this déjà vu?"
}

GET my_index/_analyze 
{
  "field": "my_text", 
  "text":  "Is this déjà vu?"
}
```
 

## Normalizing tokens

Breaking text into tokens is only half the job. To make those tokens more easily searchable, they need to go through a normalization process to remove insignificant differences between otherwise identical words, such as uppercase versus lowercase. Perhaps we also need to remove significant differences, to make esta, ésta, and está all searchable as the same word. Would you search for déjà vu, or just for deja vu?

Example: lowercase filter

The QUICK Brown FOX! = the, quick, brown, fox

It doesn’t matter whether users search for fox or FOX, as long as the same analysis process is applied at query time and at search time. The lowercase filter will trans‐ form a query for FOX into a query for fox, which is the same token that we have stored in our inverted index.

```
{
	"settings": { 
		"analysis": {
			"analyzer": { 
				"my_lowercaser": { 
					"tokenizer": "standard", 
					"filter": [ "lowercase" ] 
				} 
			}
		}
	}
}
```


## Stop words
A token filter of type stop that removes stop words from token streams.

The following are settings that can be set for a stop token filter type:

*stopwords*: A list of stop words to use. Defaults to _english_ stop words.

*stopwords_path*: A path (either relative to config location, or absolute) to a stopwords file configuration. Each stop word should be in its own "line" (separated by a line break). The file must be UTF-8 encoded.

*ignore_case*: Set to true to lower case all words first. Defaults to false.

*remove_trailing*: Set to false in order to not ignore the last term of a search if it is a stop word. This is very useful for the completion suggester as a query like green a can be extended to green apple even though you remove stop words in general. Defaults to true.


## Synonyms
The synonym token filter allows to easily handle synonyms during the analysis process.
