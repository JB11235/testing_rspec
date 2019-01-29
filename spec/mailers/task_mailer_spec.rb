require "rails_helper"

RSpec.describe TaskMailer, type: :mailer do
  describe "task_completed_email" do
  	let(:project) {create(:project, name: "Mail Project")}
  	let(:task) { create(:task, title: "Learn how to test mailers", size: 3, project: project)}
  	let(:email) { TaskMailer.task_completed_email(task)}

  	it "renders the email" do
  	  expect(email.subject).to eq("A task has been completed")
  	  expect(email.to).to eq(["monitor@tasks.com"])
  	  expect(email.body.to_s).to match(/Learn how to test mailers/)
  	end
  end
end
