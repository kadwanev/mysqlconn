mysqlconn - The mysql connection assistant
==========================================

### Instructions

Install:

`gem install mysqlconn`

Create `~/.db_connection_alias.yml`

    db_key:
      host: hostname
      user: username		# Optional
      password: password		# Optional
    #  password: ''		# Optional, prompt for password
      database: database		# Optional
    db_key2:
      ...

Protect configuration file:

`chmod 600 ~/.db_connection_alias.yml`

### Usage

Connect:

`mysqlconn db_key [additional options]`

Pipe:

`mysqlconn db_key < script.sql > output`

etc..

### License

MIT - go nuts

