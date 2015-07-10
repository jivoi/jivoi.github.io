---
layout: post
title: "Data Science at the Command Line"
modified: 2015-07-10 17:18:00 +0300
category: [books]
tags: [linux,cli]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
Notes from book

### Urls
- [http://datascienceatthecommandline.com/](http://datascienceatthecommandline.com/)
- [seven-command-line-tools-for-data-science](http://jeroenjanssens.com/2013/09/19/seven-command-line-tools-for-data-science.html)

### CH02 - Getting Started
{% highlight bash %}
# install tools
mkdir datascience
cd datascience
vagrant init data-science-toolbox/data-science-at-the-command-line
vagrant up

# github
git clone https://github.com/jeroenjanssens/data-science-at-the-command-line.git

# jq
https://stedolan.github.io/jq/download/

# json2csv
https://github.com/jehiah/json2csv
go get github.com/jehiah/json2csv

# xml2json
https://github.com/buglabs/node-xml2json

# csvkit
pip install csvkit (in2csv, sql2csv, csvlook, csvsql)
{% endhighlight %}

### CH03 - Obtaining Data
{% highlight bash %}
# playing with some cli tools

parallel -j1 --progress --delay 0.1 --results results "curl -sL ""'http://api.nytimes.com/svc/search/v2/articlesearch.json?q=New+York+'""'Fashion+Week&begin_date={1}0101&end_date={1}1231&page={2}&api-key='""'<your-api-key>'" ::: {2009..2013} ::: {0..99} > /dev/null

cat results/1/*/2/*/stdout | jq -c '.response.docs[] | {date: .pub_date, type: .document_type, ''title: .headline.main }' | json2csv -p -k date,type,title > fashion.csv

< fashion.csv cols -c date cut -dT -f1 | head | csvlook

< fashion.csv Rio -ge 'g + geom_freqpoly(aes(as.Date(date), color=type), ''binwidth=7) + scale_x_date() + labs(x="date", title="Coverage of New York'' Fashion Week in New York Times")' | display

# in2csv - able to convert Microsoft Excel spreadsheets to CSV files
$ in2csv data/imdb-250.xlsx > data/imdb-250.csv

# csvlook - nicely format the data into a table
$ in2csv data/imdb-250.xlsx | head | csvcut -c Title,Year,Rating | csvlook

# sql2csv - querying relational databases
$ sql2csv --db 'sqlite:///data/iris.db' --query 'SELECT * FROM iris ''WHERE sepal_length > 7.5'

# jq - commandline JSON processor
$ curl -s http://api.randomuser.me | jq '.'

# curlicue - to log in api using the OAuth protocol
$ curlicue-setup 'https://api.twitter.com/oauth/request_token' 'https://api.twitter.com/oauth/authorize?oauth_token=$oauth_token' 'https://api.twitter.com/oauth/access_token' > credentials
$ curlicue -f credentials 'https://api.twitter.com/1/statuses/home_timeline.xml'
{% endhighlight %}

### CH05 - Scrubbing Data
{% highlight bash %}
# create file that contains 10 lines
$ seq -f "Line %g" 10 | tee lines

# print the first three lines
$ < lines head -n 3
$ < lines sed -n '1,3p'
$ < lines awk 'NR<=3'

# print the last three lines
$ < lines tail -n 3

# remove the first three lines
$ < lines tail -n +4
$ < lines sed '1,3d'
$ < lines sed -n '1,3!p

# remove last three lines
$ < lines head -n -3

# print (or extract) specific lines
$ < lines sed -n '4,6p'
$ < lines awk '(NR>=4)&&(NR<=6)'
$ < lines head -n 6 | tail -n 3

# print odd numbered lines
$ < lines sed -n '1~2p'
$ < lines awk 'NR%2

# print even numbered lines
$ < lines sed -n '0~2p'
$ < lines awk '(NR+1)%2'

# grep pattern
$ grep -E '^CHAPTER (.*)\. The' alice.txt

# outputting only a certain percentage of data
$ seq 1000 | sample -r 1% | jq -c '{line: .}'
$ seq 10000 | sample -r 1% -d 1000 -s 5 | jq -c '{line: .}'

# extract fields
$ grep -i chapter alice.txt | cut -d' ' -f3-
$ sed -rn 's/^CHAPTER ([IVXLCDM]{1,})\. (.*)$/\2/p' alice.txt > /dev/null

# remove set of characters
$ grep -i chapter alice.txt | cut -c 9-

# create a data set of all the words that start with an “a”
$ < alice.txt tr '[:upper:]' '[:lower:]' | grep -oE '\w{2,}' | grep -E '^a.*e$' | sort | uniq -c | sort -nr | awk '{print $2","$1}' | header -a word,count | head | csvlook

# one character needs to be replaced
$ echo 'hello world!' | tr ' !' '_?'

# to delete individual characters
$ echo 'hello world!' | tr -d -c '[a-z]'

# convert our text to uppercase
$ echo 'hello world!' | tr '[a-z]' '[A-Z]'
$ echo 'hello world!' | tr '[:lower:]' '[:upper:]

# to change a word, remove repeated spaces, and remove leading spaces
$ echo ' hello world!' | sed -re 's/hello/bye/;s/\s+/ /g;s/\s+//'

# with body cmd you can apply any command-line tool to the file (i.e., everything excluding the header)
$ echo -e "value\n7\n2\n5\n3" | body sort -n
$ seq 5 | header -a count | body wc -l

# header cmd allows us, as the name implies, to manipulate the header of a CSV file
$ < tips.csv header
$ seq 5 | header -a count
$ < iris.csv header -d | head
$ < iris.csv  header -e 'tr "[:lower:]" "[:upper:]"'|head
$ seq 5 | header -a line | body wc -l | header -r count

# cols cmd allows you to apply a certain command to only a subset of the columns
$ < tips.csv cols -c day body "tr '[a-z]' '[A-Z]'" | head -n 5 | csvlook

# csvsql allows you to execute SQL queries directly on CSV files
$ seq 5 | header -a value | csvsql --query "SELECT SUM(value) AS sum FROM stdin"
$ seq 5 | header -a value | csvsql --query "SELECT * FROM stdin"
$ < iris.csv csvsql --query "SELECT sepal_length, petal_length, sepal_width, petal_width FROM stdin" | csvlook

# change the attribute "gender" to "sex" using sed
$ sed -e 's/"gender":/"sex":/g' data/users.json | fold | head -n 3

# working with HTML/XML and JSON
$ curl -sL 'http://en.wikipedia.org/wiki/List_of_countries_and_territories_by_border/area_ratio' > wiki.html
$ < wiki.html scrape -b -e 'table.wikitable > tr:not(:first-child)'
$ < table.html xml2json > table.json
$ < table.json jq '.' | head -n 25
$ < table.json jq -c '.html.body.tr[] | {country: .td[1][],border:.td[2][], surface: .td[3][]}' > countries.json
$ < countries.json json2csv -p -k country,border,surface > countries.csv
$ < countries.json json2csv -p -k country,border,surface |csvlook|head -10
$ < countries.json json2csv -p -k country,border,surface |cols -c country body "tr '[a-z]' '[A-Z]'"

# csvcut cmd allow to extracted and reordered colums
$ < iris.csv csvcut -c sepal_length,petal_length,sepal_width,petal_width

# exclude all the bills of which the party size was 4 or less
$ csvgrep -c size -i -r "[1-4]" tips.csv | csvlook
$ < tips.csv awk -F, '($1 > 40.0) && ($5 ~ /S/)' | csvlook
$ < tips.csv csvsql --query "SELECT * FROM stdin WHERE bill > 40 AND day LIKE '%S%'" | csvlook

# merging columns
$ < names.csv csvsql --query "SELECT id, first_name || ' ' || last_name AS full_name, born FROM stdin" | csvlook

# splitting up Iris data set into three CSV files
$ < iris.csv fieldsplit -d, -k -F species -p . -s .csv

# concatenate the files back using cat
$ cat Iris-setosa.csv <(< Iris-versicolor.csv header -d) <(< Iris-virginica.csv header -d) | sed -n '1p;49,54p' | csvlook

# csvjoin cmd allow to join the two data sets
$ csvjoin -c species iris.csv irismeta.csv | csvcut -c sepal_length,sepal_width,species,usda_id | sed -n '1p;49,54p' | csvloo
{% endhighlight %}

### CH06 - Managing Your Data Workflow
{% highlight bash %}
# drake is command-line tool created by Factual that allows you to:
• Formalize your data workflow steps in terms of input and output dependencies
• Run specific steps of your workflow from the command line
• Use inline code (e.g., Python and R)
• Store and retrieve data from external sources (e.g., S3 and HDFS)

$ sudo apt-get install openjdk-6-jdk
$ sudo apt-get install leiningen
$ git clone https://github.com/Factual/drake.git
$ cd drake
$ lein uberjar
$ mv drake.jar ~/.bin/
$ cd ~/.bin/
$ java -jar drake.jar
$ git clone https://github.com/flatland/drip.git
$ cd drip
$ make prefix=~/.bin install
$ cd bin
$ wget https://github.com/jeroenjanssens/data-science-at-the-command-line/blob/master/tools/drake

# top 5 downloaded books of Project Gutenberg
$ curl -s 'http://www.gutenberg.org/browse/scores/top' | grep -E '^<li>' | head -n 5 | sed -E "s/.*ebooks\/([0-9]+).*/\\1/"

# same step with Drakefile
top-5 <-
        curl -s 'http://www.gutenberg.org/browse/scores/top' |
        grep -E '^<li>' |
        head -n 5 |
        sed -E "s/.*ebooks\/([0-9]+)\">([^<]+)<.*/\\1,\\2/" > top-5
$ drake

# add variables to drake 02.drake
NUM=5
BASE=data/

top.html <- [-timecheck]
        curl -s 'http://www.gutenberg.org/browse/scores/top' > $OUTPUT

top-$[NUM] <- top.html
        < $INPUT grep -E '^<li>' |
        head -n $[NUM] |
        sed -E "s/.*ebooks\/([0-9]+)\">([^<]+)<.*/\\1,\\2/" > $OUTPUT
$ drake --debug -w 02.drake
$ NUM=10 drake -w 02.drake
{% endhighlight %}

### CH07 - Exploring Data
{% highlight bash %}
# to get the number of unique values for each column
$ csvstat data/investments2.csv --unique

# csvstat gives a lot of information
$ csvstat data/datatypes.csv
$ csvstat data/investments2.csv -c 2,13,19,24
{% endhighlight %}

### CH08 - Parallel Pipelines
{% highlight bash %}
# looping over files
$ find data -name '*.csv' -print0 | parallel -0 echo "Processing {}"

# simple parallel processing
$ for i in {1..4}; do;(./slow.sh $i; echo Processed $i) &;done

# parallel - cli tool that allows us to parallelize commands and pipelines
$ seq 5 | parallel "echo {}^2 | bc"
$ < input.csv parallel -C, "mv {1} {2}"
$ < input.csv parallel -C, --header : "invite {name} {email}"
$ seq 5 | parallel -j0 "echo Hi {}"
$ seq 5 | parallel "echo \"Hi {}\" > data/hi-{}.txt"
$ seq 5 | parallel --results data/outdir "echo Hi {}"
$ seq 100 | parallel -C, -k -j100% "echo '{1}^2' | bc -l"|tail

# awscli
pip install awscli
# Getting Your Access Key ID and Secret Access Key
https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html
aws configure
aws ec2 describe-instances
aws ec2 describe-instances | jq '.Reservations[].Instances[] | {public_dns: .PublicDnsName, state: .State.Name}'
aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | select(.State.Name=="running") | .PublicDnsName' > instances

# running commands on remote machines
$ parallel --nonall --slf instances hostname
$ parallel --nonall --slf instances "sudo apt-get install -y parallel"

# Distributing Local Data Among Remote Machines
$ seq 1000 | parallel -N100 --pipe --slf hosts "(hostname; wc -l) | paste -sd:"
{% endhighlight %}

### CH09 - Modeling Data
{% highlight bash %}
# obtain the two data sets using  curl
$ parallel "curl -sL http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-{}.csv > wine-{}.csv" ::: red white
{% endhighlight %}
