# Start

Add credentials to config/database.yml for both development and test
```
development:
  username: d4kanban_user
  password: d4kanban_password
test:
  username: d4kanban_user
  password: d4kanban_password
```


```
$ psql
postgres=# CREATE ROLE d4kanban_user WITH CREATEDB LOGIN PASSWORD 'd4kanban_password';
```

```bash
$ bin/rake db:create
```

Add ObjectView and Devise to Gemfile and install them.

```bash
bin/rails generate devise:install
bin/rake object_view:install
bin/rails generate devise user
bin/rails generate devise:views
```
