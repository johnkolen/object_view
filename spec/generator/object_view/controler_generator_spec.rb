require 'rails_helper'
require 'rails/generators'
require 'rails/generators/named_base'
require ObjectView::Engine.root.join('lib/generators/object_view/controller/controller_generator')

RSpec.describe ObjectView::ControllerGenerator, type: :generator do
  #pending "add some scenarios (or delete) #{__FILE__}"
  if false
    puts self.inspect
    destination File.expand_path("../../dummy", __FILE__)
    before :all do
      system "bin/rails generate model house color:string age:integer person:references"
      system "bin/rake db:migrate"
    end
    after :all do
      system "bin/rake db:rollback"
      system "bin/rails destroy model house color:string age:integer person:references"
    end
    #tests ObjectView::ControllerGenerator
    it "does something" do
      #system "bin/rails generate object_view:controller house"
      run_generator %w[house]
      expect("app/controllers/houses_controler.rb").
        to contain(/@objects/)
    ensure
      system "bin/rails destroy object_view:controller house"
    end
  end
end
