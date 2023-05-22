-- Load input file from HDFS
inputDialouges4 = LOAD 'hdfs:///user/surbhi/PigProjectActivity1/episodeIV_dialouges.txt' USING PigStorage('\t') AS (name:chararray, dialouge:chararray);
inputDialouges5 = LOAD 'hdfs:///user/surbhi/PigProjectActivity1/episodeV_dialouges.txt' USING PigStorage('\t') AS (name:chararray, dialouge:chararray);
inputDialouges6 = LOAD 'hdfs:///user/surbhi/PigProjectActivity1/episodeVI_dialouges.txt' USING PigStorage('\t') AS (name:chararray, dialouge:chararray);


-- Filter out first 2 lines from each input file
ranked4 = Rank inputDialouges4;
OnlyDialouges4 = FILTER ranked4 BY (rank_inputDialouges4 > 2);
ranked5 = Rank inputDialouges5;
OnlyDialouges5 = FILTER ranked5 BY (rank_inputDialouges5 > 2);
ranked6 = Rank inputDialouges6;
OnlyDialouges6 = FILTER ranked6 BY (rank_inputDialouges6 > 2);

-- Merge the three inputs
inputData = UNION OnlyDialouges4, OnlyDialouges5, OnlyDialouges6;

-- Group data using the name column
GroupByName = GROUP inputData BY name;


-- Count the number of lines by each character
names = FOREACH GroupByName GENERATE $0 as name, COUNT($1) as no_of_lines;
namesOrdered = ORDER names BY no_of_lines DESC;

-- Remove Output folder
rmf hdfs:///user/surbhi/PigProjectActivity1/results;

-- Save result in HDFS folder
STORE namesOrdered INTO 'hdfs:///user/surbhi/PigProjectActivity1/results' USING PigStorage('\t');

