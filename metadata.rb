name              "proftpd"
maintainer        "Christopher Chow"
maintainer_email  "chris@chowie.net"
license           "Apache 2.0"
description       "Installs proftpd"
version           "1.0.0"
recipe            "proftpd", "Installs proftpd backed by a SQL database"

supports "ubuntu"

depends "apt"
