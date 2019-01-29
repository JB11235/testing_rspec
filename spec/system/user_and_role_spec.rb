require "rails_helper"

RSpec.describe "with users and roles" do
  def log_in_as(user)
  	visit new_user_session_path
  	fill_in("user_email", with: user.email)
  	fill_in("user_password", with: user.password)
  	click_button("Log in")
  end

  let(:user) {User.create(email: "test@example.com", password: "password")}

  it "allows a logged in user to view th e project index page" do
  	log_in_as(user)
  	visit(projects_path)
  	expect(current_path).to eq(projects_path)
  end

  it "does allow a user to see the project page if not logged in" do
  	visit(projects_path)
  	expect(current_path).to eq(user_session_path)
  end
end

RSpec.describe "roles" do
  let(:user) {create(:user)}
  let(:project) { create(:project, name: "Project Gutenberg")}

  it "allows a user who is part of a project to see that project" do
    project.roles.create(user: user)
    login_as(user)
    visit(project_path(project))
    expect(current_path).to eq(project_path(project))
  end

  it "doesn't allow a user who is not part of a project to see the project" do
    login_as(user)
    visit(project_path(project))
    expect(current_path).not_to eq(project_path(project))
  end
end

RSpec.describe "index page" do
  let(:user) {create(:user)}
  let!(:my_project) { create(:project, name: "My Project")}
  let!(:not_my_project) { create(:project, name: "Not My Project")}

  it "allows users to see only projects that are visible" do
    my_project.roles.create(user: user)
    login_as(user)
    visit(projects_path)
    expect(page).to have_selector("#project_#{my_project.id}")
    expect(page).not_to have_selector("#project_#{not_my_project.id}")
  end
end
