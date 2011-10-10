File.open("app/mailers/task_mailer.rb","r"){|file| file.read}.gsub(/def (\w+)/){$stdout = File.new("app/views/task_mailer/#{$1}.html.erb","w"); puts IO.read("app/views/task_mailer/_template.html.erb"); File.new("app/views/task_mailer/#{$1}.text.erb","w")}






    
