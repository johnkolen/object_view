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

def replace file, target, content, **options
  if options[:after]
    content = "#{target}#{content}"
  end
  re = /#{Regexp.escape target}/
  past = /#{Regexp.escape content}/ if options[:after]
  if File.exist? file
    tmp = "/tmp/ovreplace"
    File.open(file, "r") do |f|
      File.open(tmp, "w") do |g|
        f.each_line do |line|
          if past =~ line
            g.write line
          else
            g.write line.gsub(re, content)
          end
        end
      end
      FileUtils.mv file, "#{file}.old"
      FileUtils.mv tmp, file
      puts "old #{file} is #{file}.old"
    end
  end
end

namespace :object_view do
  desc "Add CSS path to package.json"
  task :package do
    root = Rails.root
    tgt_b = "vendor/object_view/stylesheets"
    tgt = root.join(tgt_b)
    FileUtils.mkdir_p tgt, verbose: true
    FileUtils.rmdir tgt # makes room for the symlink
    FileUtils.ln_s(ObjectView::Engine.root.join("app/assets/stylesheets"),
                   tgt,
                   force: true, verbose: true)
    replace root.join("package.json"),
            "--load-path=node_modules",
            " --load-path=#{tgt_b}",
            after: true
    puts "Added CSS path to package.json"
  end

  desc "Add object_view/bootstrap to css"
  task :css => :environment do
    root = Rails.root
    append "#{root}/app/assets/stylesheets/application.bootstrap.scss",
           '@import "object_view/bootstrap"' do
      append "#{root}/app/assets/stylesheets/application.scss",
             '@import "object_view/bootstrap.scss"'
    end
    puts "Added object_view/bootstrap to css"
  end

  desc "Add object_view/controller to application.js"
  task :js => :environment do
    root = Rails.root
    append "#{root}/app/javascript/application.js",
           'import "object_view/controllers"'
    puts "Added object_view/controller to application.js"
  end

  desc "Add ObjectView mount to routes"
  task :route do
    replace "config/routes.rb",
            "Rails.application.routes.draw do",
            "\n  mount ObjectView::Engine => \"/ove\"",
            after: true
    puts "Added ObjectView mount to routes"
  end

  desc "Install object_view"
  task :install => :environment do
    Rake::Task["object_view:route"].invoke
    Rake::Task["object_view:package"].invoke
    Rake::Task["object_view:css"].invoke
    Rake::Task["object_view:js"].invoke
    #root = Rails.root
    #local = File.expand_path("#{File.dirname(__FILE__)}../../..")
    #FileUtils::cp("#{local}/bin/gemlink.sh", "#{root}/bin/gemlink.sh")
    #system "#{root}/bin/gemlink.sh"
    #system("ln -sf #{local}/app #{root}/vendor/object_view")
    #puts "add '--load-path=vendor/object_view/assets/stylesheets' to package.json at end of 'build:css:compile' line"
  end
end
