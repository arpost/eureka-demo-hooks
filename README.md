# eureka-demo-hooks
Scripts specific to the demo site that are invoked using Eureka!'s hooks mechanism. The contents of the hooks directory go into the `/etc/eureka/hooks` directory. The following hooks are defined:

* `activation`: Invoked by Eureka! when a user account is activated. It creates the source and destination files for the user, registers those files with eureka-protempa-etl, and creates the appropriates files and database records in i2b2.
