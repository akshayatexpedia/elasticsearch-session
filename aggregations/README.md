# Aggregations

## Bucket Aggregations
A bucket is simply a collection of documents that meet a certain criteria. Buckets can also be nested inside other buckets, giving you a hierarchy or conditional partitioning scheme. 

ElasticSearch has a variety of buckets, which allow you to partition documents in many ways (by hour, by most-popular terms, by age ranges, by geographical location, and more).

## Metrics Aggregations
Bucket aggregations with metric

## Filtering Queries and Aggregations
A natural extension to aggregation scoping is filtering. Because the aggregation operates in the context of the query scope, any filter applied to the query will also apply to the aggregation.

The query (which happens to include a filter) returns a certain subset of documents, and the aggregation operates on those documents.