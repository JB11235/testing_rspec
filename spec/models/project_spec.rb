require 'rails_helper'

RSpec.describe "estimates" do 
  let(:project) { FactoryBot.build_stubbed(:project, tasks: [newly_done, old_done, small_not_done, large_not_done]) }
  let(:newly_done) {FactoryBot.build_stubbed(:task, :newly_complete) }
  let(:old_done) { FactoryBot.build_stubbed(:task, :long_complete) }
  let(:small_not_done) { FactoryBot.build_stubbed(:task, :small) }
  let(:large_not_done) { FactoryBot.build_stubbed(:task, :large) }

  it "can calculate total size" do
    expect(project.total_size).to eq(12)
    expect(project.total_size).not_to eq(5)
  end
end

RSpec.describe "task order" do
  let(:project) { create(:project, name: "Project") }

  it "makes 1 the order of the first task in an entry project" do
    expect(project.next_task_order).to eq(1)
  end

  it "gives the order of the next task as one more than the highest" do
    project.tasks.create(project_order: 1)
    project.tasks.create(project_order: 2)
    project.tasks.create(project_order: 3)
    expect(project.next_task_order).to eq(4)
  end
end



