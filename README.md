# eureka-demo-hooks
Scripts specific to the demo site that are invoked using Eureka!'s hooks mechanism. The contents of the hooks directory go into the `/etc/eureka/hooks` directory. The following hooks are defined:

##activation
Invoked by Eureka! when a user account is activated. It creates the source and destination files for the user, registers those files with eureka-protempa-etl, and creates the appropriates files and database records in i2b2.

###Set up
Add to the `etc` directory a file called `local_config.sh` containing the following lines:
```
EK_BACKEND_USER=<eureka backend db user>
EK_BACKEND_PWD=<eureka backend db password>

I2B2_PM_USER=<i2b2 pm db user>
I2B2_PM_PWD=<i2b2 pm db password>

I2B2_HIVE_USER=<i2b2 hive db user>
I2B2_HIVE_PWD=<i2b2 hive db password>

ORACLE_SID=<oracle database SID>
```

###Running the scripts
Each script takes three arguments:
* Eureka username
* Eureka user full name
* Eureka encrypted password
The `30-create-ds.xml`, `40-create-sourceconfig.sh` and `50-create-destconfig.sh` scripts write to JBoss' deployment directory, the `/etc/eureka/sourceconfig` and `/etc/eureka/destconfig` directory, respectively, and must be run as a user with write privileges.
