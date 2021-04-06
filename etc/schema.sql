
create table bibliographics (

    key          TEXT PRIMARY KEY,
	title        TEXT,
	date         TEXT,
	year         INT,
	mime_type    TEXT,
	url          TEXT,
	access_type  TEXT,
	access_url   TEXT,
	language     TEXT,
	type         TEXT,
	size         INT,
	extension    TEXT
	
);


create table authors (

    id          INT PRIMARY KEY,
    key         TEXT,
    author      TEXT

);

