When logging into and reporting from postrges with Grafana, it sometimes comes to timezone issues. In my example, I did not maintain it in postgres properly at the beginning leading to Grafana reporting data one hour "to late", i.e., it was showing me data from one hour ago as to be most recent. I could only determine that by zooming out.
In case you face such issue, you need to adjust the databases timezone accordingly to be in sync with RSyslog (and mstz likely your network components as well). 
For me, the following statements (as postgres) did solve the issue (I live in Europe/Berlin TZ);
```
alter database "postgres" set time zone 'Europe/Berlin'; 
alter table systemevents alter COLUMN devicereportedtime TYPE TIMESTAMP WITH TIME ZONE USING devicereportedtime AT TIME ZONE 'UTC+1';
truncate table systemevents;
```
