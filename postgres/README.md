When logging into and reporting from postrges with Grafana, it sometimes comes to timezone issues. In my example, I did not maintain it in postgres properly at the beginning leading to Grafana reporting data one hour "to late", i.e., it was showing me data from one hour ago as to be most recent. I could only determin that by zooming out.
In case one faces such issue, one needs to adjust the databases timezone accordingly to be in sync with RSyslog (and network componeents). 
For me, the following statements (as postgres) did solve the issue;
```
alter database "postgres" set time zone 'Europe/Berlin'; 
alter table systemevents alter COLUMN devicereportedtime TYPE TIMESTAMP WITH TIME ZONE USING devicereportedtime AT TIME ZONE 'UTC+1';
truncate table systemevents;
```
