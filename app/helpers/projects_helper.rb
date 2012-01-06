module ProjectsHelper

  def project_status(project)
    project.public? ? "public" : "private"
  end

  def project_users(project,status)
    users = []
    project.users.each{|u| users << u if u.access_id == status}
    return users
  end

end
