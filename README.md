# elasticsearch-session

Setup
===
Download elasticsearch from[here](https://www.elastic.co/downloads/elasticsearch), and follow the steps shared below.
* Download and unzip ElasticSearch
* Run `bin/elasticsearch` (or `bin\elasticsearch.bat` on Windows)
* Run `curl http://localhost:9200` or `Invoke-RestMethod http://localhost:9200`

Once the elasticsearch is up and running.
* Run `sh fill.sh data` to create indexes needed for this session