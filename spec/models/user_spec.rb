require 'rails_helper'

RSpec::Matchers.define :be_able_to_see do |*projects|
  match do |user| 
   	expect(user.visible_projects).to eq(projects)
   	projects.all? {|p| expect(user.can_view?(p)).to be_truthy}
   	(all_projects - projects).all? do |p|
   	  expect(user.can_view?(p)).to be_falsey
   	end
   end
end

RSpec.describe "visibility" do
  let(:user) {create(:user, email: "user@example.com", password: "password")}
  let(:project_1) {create(:project, name: "Project 1")}
  let(:project_2) {create(:project, name: "Project 2")}
  let(:all_projects) {[project_1, project_2]}

  it "a user can see their projects" do
  	user.projects << project_1
  	expect(user).to be_able_to_see(project_1)
  end

  it "an admin can see their projects" do
  	user.admin = true
  	expect(user).to be_able_to_see(project_1, project_2)
  end

  it "a user can see public projects" do
  	user.projects << project_1
  	project_2.update_attribute(:public, true)
  	expect(user).to be_able_to_see(project_1, project_2)
  end

  it "no dupes in project list" do
  	user.projects << project_1
    project_1.update_attribute(:public, true)
    expect(user).to be_able_to_see(project_1)
  end
end



RSpec.describe User, type: :model do
  let(:project) {create(:project)}
  let(:user)    {create(:user)}

  it "cannot view a project it is not a part of" do
  	expect(user.can_view?(project)).to be_falsy
  end

  it "can view a project it is a part of" do
  	Role.create(user: user, project: project)
  	expect(user.can_view?(project)).to be_truthy
  end 
end

RSpec.describe "public roles" do
  let(:project) {create(:project)}
  let(:user)    {create(:user)}

  it "allows an admin to view a project" do
  	user.admin = true
  	expect(user.can_view?(project)).to be_truthy
  end

  it "allows a user to view a public project" do
  	project.update_attribute(:public, true)
  	expect(user.can_view?(project)).to be_truthy
  end
end

RSpec.describe "visible projects" do
  let(:user)    {create(:user)}
  let(:project_1) {create(:project, name: "Project 1")}
  let(:project_2) {create(:project, name: "Project 2")}

  it "allows a user to see their projects" do
  	user.projects << project_1
  	expect(user.visible_projects).to eq([project_1])
  end

  it "allows an admin the see all projects" do
  	user.admin = true
  	expect(user.visible_projects).to match_array(Project.all)
  end

  it "allows a user to see public projects" do
  	user.projects << project_1
  	project_2.update(public: true)
  	expect(user.visible_projects).to match_array([project_1, project_2])
  end

  it "has no duplicates in project list" do
  	user.projects << project_1
  	project_1.update(public: true)
  	expect(user.visible_projects).to match_array([project_1])
  end
end

