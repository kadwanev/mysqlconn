mysqlconn - The mysql connection assistant
------------------------------------------

Store mysql connection credentials in a simple, secure configuration file. Many destinations can then be used with
the *db_key* you specify. You can also run script files against the names you select. The mysql prompt is set
for safety.

### Instructions

Install:

`gem install mysqlconn`

Create `~/.db_connection_alias.yml`

    config:
      default_arg:          # default arguments
        mysql: -A -C
        mysqldump: --quick --single-transaction -C
    db_key:
      host: hostname
      port: port			# Optional
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

`mysqlconn db_key [any additional mysql options]`

Look at that beautiful prompt:

    mysqluser@db_key [database]> select now();
    +---------------------+
    | now()               |
    +---------------------+
    | 2014-04-15 11:09:33 |
    +---------------------+
    1 row in set (0.02 sec)
    
    mysqluser@db_key [database]>

Pipe:

`mysqlconn db_key < script.sql > output`

etc..

To mysqldump:

`mysqldumpconn db_key [any additional mysqldump options]`

Verbose:

Add `-v` BEFORE the db_key to print out the final executed command to STDERR. BEWARE: It will print plain password.

### Autocomplete

Add to bash.completion.d or wherever:

    _mysqlconn() {
      local cur=${COMP_WORDS[COMP_CWORD]}
      COMPREPLY=( $( compgen -W "$(mysqlconn -l)" -- $cur ) )
    }
    complete -F _mysqlconn mysqlconn
    complete -F _mysqlconn mysqldumpconn

### License

Apache 2.0 - go nuts
