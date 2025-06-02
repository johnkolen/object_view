#!/bin/bash

fgrep "object_view" Gemfile || cat ../ovtest.gemfile >> Gemfile

bundle install
exit
bin/rake object_view:install

if ! [ -e app/views/static ]; then
    bin/rails generate controller static index
    bin/rails generate model person name:string age:integer
    bin/rails db:migrate
    bin/rails generate object_view:controller person
fi

f=app/views/static/index.html.erb
fgrep button $f || cat - >> $f <<EOF
<div class="ov-field" data-controller="modal-object">
OV FIELD
<button class="btn btn-primary" data-action="click->modal-object#edit">Button</button>
 </div>
EOF
