Factory.sequence :email do |n|
  "person#{n}@example.com"
end

Factory.define :user do |user|
  user.name Faker::Name.name
  user.email "person@example.com"
  user.password "foobar"
  user.password_confirmation "foobar"
  user.admin false
end

Factory.define :admin, :class => User do |admin|
  admin.name Faker::Name.name
  admin.email "admin@example.com"
  admin.password "barfoo"
  admin.password_confirmation "barfoo"
  admin.admin true
end

Factory.define :project do |project|
  project.title "New project"
  project.content Faker::Lorem.sentence(5)
end

Factory.define :status do |status|
  status.content  "New"
end

Factory.define :task do |task|
  task.title "New task"
  task.content Faker::Lorem.sentence(5)
  task.association :user
  task.association :author, :factory => :user
  task.association :project
  task.association :status
end
