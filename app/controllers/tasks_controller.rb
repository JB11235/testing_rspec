class TasksController < ApplicationController
  before_action :load_task, only: %i[up down]

  def create
  	@project = Project.find(params[:task][:project_id])
    unless current_user.can_view?(@project)
      redirect_to new_user_session_path
      return
    end
  	@project.tasks.create(task_params.merge(project_order: @project.next_task_order))
  	redirect_to(@project)
  end

  def update 
    @task = Task.find(params[:id])
    completed = params[:task][:completed] == "true" && !@task.complete?
    params[:task][:completed_at] = Time.current if completed
    if @task.update_attributes(task_params)
      TaskMailer.task_completed_email(@task).deliver if completed
      redirect_to @task.project, notice: "project was successfully updated"
    else
      render action: :edit
    end
  end

  def up
  	@task.move_up
    project = @task.project.reload
    render js: "$('#task_table').html('" + escape_javascript(render_to_string(partial: "projects/task_table", locals: {project: project})) + "')"
  end

  def down
  	@task.move_down
    project = @task.project.reload
  	render js: "$('#task_table').html('" + escape_javascript(render_to_string(partial: "projects/task_table", locals: {project: project})) + "')"
  end

  private 

  def load_task
  	@task = Task.find(params[:id])
  end

  def task_params
  	params.require(:task).permit(:project_id, :title, :size, :completed_at)
  end
end
