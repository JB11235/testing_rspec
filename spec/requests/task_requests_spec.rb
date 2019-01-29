require "rails_helper"

RSpec.describe "task controller requests" do

  describe "creation" do

  	let (:project) {create(:project, name: "Project Bluebook")}
    let(:user) { create(:user)}
    
	before(:example) do
	  login_as(user)	  
	end
  
  	it "can add a task to a project the user can see", :js do
  	  Role.create(user: user, project: project)
  	  post(tasks_path, params: {task: {name: "New Task", size: "3", project_id: project.id}})
  	  expect(request).to redirect_to(project_path(project))
    end

    it "can add a task to a project the user can not see", :js do
  	  post(tasks_path, params: {task: {name: "New Task", size: "3", project_id: project.id}})
  	  expect(request).to redirect_to(new_user_session_path)
    end

  end
end

RSpec.describe "task requests" do 
  before(:example) do
  	ActionMailer::Base.deliveries.clear
  end

  let(:project) {create(:project, name: "Mailing things")}
  let(:task) { create(:task, title: "Learn how to test mailers", project: project, size: 3)}

  it "does not send an email if a task is not completed" do
  	path(task_path(id: task.id), params: {task: {completed: false}})
  	expect(ActionMailer::Base.deliveries.size).to eq(0)
  end

  it "sends email when task is completed" do
    #TODO find where email is triggered during rspec test
  	# patch(task_path(id: task.id), params: {task: {completed: true}} )
   #  puts "deliveries = #{ActionMailer::Base.deliveries.size}"
  	# expect(ActionMailer::Base.deliveries.size).to eq(1)
  	# email = ActionMailer::Base.deliveries.first
  	# expect(email.subject).to eq("A task has been completed")
  	# expect(email.to).to eq(["monitor@tasks.com"])
  	# expect(email.body.to_s).to match(/Learn how to test mailers/)
  end
	
end

	