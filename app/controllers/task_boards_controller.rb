class TaskBoardsController < ApplicationController
  before_action :set_task_board, only: [:show, :edit, :update, :destroy]

  # GET /task_boards
  # GET /task_boards.json
  def index
    @task_boards = TaskBoard.all
    @task_board = TaskBoard.new
  end

  # GET /task_boards/1
  # GET /task_boards/1.json
  def show
  end

  # GET /task_boards/new
  def new
    @task_board = TaskBoard.new
  end

  # GET /task_boards/1/edit
  def edit
  end

  # POST /task_boards
  # POST /task_boards.json
  def create
    @task_board = TaskBoard.new(task_board_params)

    respond_to do |format|
      if @task_board.save
        format.html { redirect_to @task_board, notice: 'Task board was successfully created.' }
        format.json { render :show, status: :created, location: @task_board }
      else
        format.html { render :new }
        format.json { render json: @task_board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_boards/1
  # PATCH/PUT /task_boards/1.json
  def update
    respond_to do |format|
      if @task_board.update(task_board_params)
        format.html { redirect_to @task_board, notice: 'Task board was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_board }
      else
        format.html { render :edit }
        format.json { render json: @task_board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_boards/1
  # DELETE /task_boards/1.json
  def destroy
    @task_board.destroy
    respond_to do |format|
      format.html { redirect_to task_boards_url, notice: 'Task board was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_board
      @task_board = TaskBoard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_board_params
      params.require(:task_board).permit(:taskText)
    end
end
