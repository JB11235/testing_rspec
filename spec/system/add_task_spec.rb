require "rails_helper"

RSpec.describe "adding a new task" do

  before(:example) do
    sign_in(create(:user))
  end

  let!(:project) {create(:project, name: "Project Bluebook")}
  let!(:task_1) {create(:task, project: project, title: "Search Sky", size: 1, project_order: 1)}
  let!(:task_2) {create(:task, project: project, title: "Use Telescope", size: 1, project_order: 2)}
  let!(:task_3) {create(:task, project: project, title: "Take Notes", size: 1, project_order: 3)}
  let(:user){create(:user)}

  before(:example) do
    Role.create(user: user, project: project)
    sign_in(user)
  end

  it "can add a task" do
  	visit(project_path(project))
  	fill_in("Task", with: "Find UFO's")
  	select("2", from: "Size")
  	click_on("Add Task")
  	expect(current_path).to eq(project_path(project))
  	within("#task_4") do
  	  expect(page).to have_selector(".name", text: "Find UFO's")
  	  expect(page).to have_selector(".size", text: 2)  	  
  	end
  	expect(current_path).to eq(project_path(project))
  	within("#task_2") do 
  	  expect(page).not_to have_selector(".name", text: "Find UFO's")
  	end
  end

  it "can re-order a task", js: true do
    visit(project_path(project))
    within("#task_3") do
      click_on("Up")
    end
    visit(project_path(project))
    within("#task_2") do
      expect(page).to have_selector(".name", text: "Take Notes")
    end
  end

  it "can mark a test complete" do
    visit(project_path(project))
    within("#task_3") do
      click_on("Mark Complete")
    end
    visit(project_path(project))
    within("#task_3") do
      expect(page).not_to have_selector(".complete_task")
    end
  end

 
end