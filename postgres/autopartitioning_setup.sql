CREATE OR REPLACE FUNCTION isnumeric(text) RETURNS BOOLEAN AS $$
DECLARE x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION new_partition_creator() RETURNS trigger AS
  $BODY$
    DECLARE
      partition_date TEXT;
      partition_name TEXT;
      partition_start timestamp;
      partition_end timestamp;
      retire_date TEXT;
      retire_name TEXT;
   BEGIN
     partition_date := to_char(NEW. devicereportedtime,'YYYY_MM_DD');
     partition_name :=  TG_RELNAME || '_p' || '_' || partition_date;
     partition_start := to_char(NEW.devicereportedtime,'YYYY-MM-DD 00:00:00');
     partition_end := to_char(NEW.devicereportedtime,'YYYY-MM-DD 23:59:59');

     retire_date := to_char(current_date - interval '11' day ,'YYYY_MM_DD');
     retire_name :=  TG_RELNAME || '_p' || '_' || retire_date;

     IF NOT EXISTS(SELECT relname FROM pg_class WHERE relname=partition_name) THEN
        RAISE NOTICE 'A partition needs to be created %',partition_name;
        EXECUTE 'CREATE TABLE ' || partition_name || ' ( CHECK ( devicereportedtime >= ''' || partition_start || '''  AND devicereportedtime <=  ''' ||  partition_end || ''' )) INHERITS ( ' || TG_RELNAME || ' );';
        EXECUTE 'CREATE INDEX idx_' || partition_name || '_devicereportedtime ON '  || partition_name || '(devicereportedtime);';
        EXECUTE 'ALTER TABLE ' || partition_name || ' add primary key(id);';       

      	IF NOT EXISTS(SELECT relname FROM pg_class WHERE relname='ip2hostname') THEN
		create table ip2hostname (ip varchar(15), hostname varchar(256));
	END IF;
	TRUNCATE TABLE ip2hostname;
	INSERT into ip2hostname SELECT distinct  lower(split_part(message,' ', 3)) as IP, lower(split_part(message,' ', 5)) as DNS FROM systemevents where syslogtag like 'dnsmasq%' and message like ' /etc/hosts%' and devicereportedtime > now() - interval '1' day and isnumeric(left(split_part(message,' ', 3),1));
        IF EXISTS(SELECT relname FROM pg_class WHERE relname=retire_name) THEN
		EXECUTE 'DROP TABLE ' || retire_name || ';';
	END IF;
     END IF;
     EXECUTE 'INSERT INTO ' || partition_name || ' SELECT(' || TG_RELNAME || ' ' || quote_literal(NEW) || ').* RETURNING id;';
     RETURN NULL;
   END;
  $BODY$
LANGUAGE plpgsql VOLATILE
COST 100; 

CREATE TRIGGER testing_partition_insert_trigger BEFORE INSERT ON systemevents  FOR EACH ROW EXECUTE PROCEDURE new_partition_creator();

truncate table systemevents;

