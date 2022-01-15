Plain Dashboards that run without modification:

## DNSmasq - Query Reporting V1.0.json
A simple dasborad for analyzing DNSmasq RSyslog entries from the Syslog Database. This dashboard should run strait away from the basic setup and does not need any extra settings.

## DNSmasq - Query Reporting V2.0.json
A dashboard that needs the [posgresql script](../postgres/autopartitioning_setup.sql) to be executed to be working. 
That way, not only the data is partiotined daily but also the hostnames are derived from the /etc/host entries of the DNSmasq daemon. 
In order to speed the respective queries up, the IP to hostname mapping is persoisted on a daily bases preserving the latest entry per IP.
