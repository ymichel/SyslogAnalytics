Plain Dashboards that run without modification:

## DNSmasq - Query Reporting.json
A simple dasborad for analyzing DNSmasq RSyslog entries from the Syslog Database.

## DNSmasq - Blacklisted.json
A common way to blacklist DNS requests in DNSmasq is to point them to 0.0.0.0. This dashboard focusses on these log entries.

## DNSmasq - Query Reporting (incl. blocked).json
A combination of the two dashboards above into one also providing extended filter mechanisms

## DNSmasq - Query Reporting V2.0.json
A dashboard that needs the [posgresql script](../postgres/autopartitioning_setup.sql) to be executed to be working. 
That way, not only the data is partiotined daily but also the hostnames are derived from the /etc/host entries of the DNSmasq daemon. 
In order to speed the respective queries up, the IP to hostname mapping is persoisted on y daily bases for the pased 24 hours.
