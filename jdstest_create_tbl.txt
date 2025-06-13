CREATE TABLE jdstest.first_read 
(
	dim_datetime TIMESTAMP,
	event_type TEXT,
	country TEXT,
	user_id INTEGER,
	source TEXT,
	topic TEXT
);

SELECT * FROM jdstest.first_read LIMIT 25;

ALTER TABLE jdstest.first_read
ALTER COLUMN user_id TYPE VARCHAR(50);


COPY jdstest.first_read FROM '/home/davidtaki/testtask/first_visit.csv' WITH CSV HEADER DELIMITER';';


CREATE TABLE jdstest.transactions 
(
	dim_datetime TIMESTAMP,
	event_type TEXT,
	user_id VARCHAR(50),
	price INTEGER
);

SELECT * FROM jdstest.transactions LIMIT 25;

COPY jdstest.transactions FROM '/home/davidtaki/testtask/buy_events.csv' WITH CSV HEADER DELIMITER';';

CREATE TABLE jdstest.returning_read 
(
	dim_datetime TIMESTAMP,
	event_type TEXT,
	country TEXT,
	user_id VARCHAR(50),
	topic TEXT
);

SELECT * FROM jdstest.returning_read LIMIT 25;

COPY jdstest.returning_read FROM '/home/davidtaki/testtask/returning_visit.csv' WITH CSV HEADER DELIMITER';';


CREATE TABLE jdstest.sub
(
	dim_datetime TIMESTAMP,
	event_type TEXT,
	user_id VARCHAR(50)
);

SELECT * FROM jdstest.sub LIMIT 25;

COPY jdstest.sub FROM '/home/davidtaki/testtask/sub_event.csv' WITH CSV HEADER DELIMITER';';

