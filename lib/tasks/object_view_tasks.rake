def grep? file, content
  if File.exist? file
    File.open(file, "r") do |f|
      f.each_line do |line|
        return true if line.index content
      end
    end
  end
  false
end

def append file, content
  if File.exist? file
    unless grep? file, content
      File.open(file, "a") do |f|
        f.puts content
      end
    end
  else
    yield if block_given?
  end
end

namespace :object_view do
  desc "Add css/js links"
  task :install => :environment do
    root = Rails.root
    local = File.expand_path("#{File.dirname(__FILE__)}../../..")
    FileUtils::cp("#{local}/bin/gemlink.sh", "#{root}/bin/gemlink.sh")
    #system "#{root}/bin/gemlink.sh"
    append "#{root}/app/assets/stylesheets/application.bootstrap.scss",
           '@import "object_view/bootstrap"' do
      append "#{root}/app/assets/stylesheets/application.scss",
             '@import "object_view/bootstrap.scss"'
    end
    append "#{root}/app/javascript/application.js",
           'import "object_view/controllers"'
    system("ln -sf #{local}/app #{root}/vendor/object_view")
    puts "add '--load-path=vendor/object_view/assets/stylesheets' to package.json at end of 'build:css:compile' line"
  end
end
