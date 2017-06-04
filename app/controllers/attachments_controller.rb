class AttachmentsController < ApplicationController
  load_and_authorize_resource
  # before_action :set_attachment, only: [:show, :edit, :update, :destroy, :download]

  # GET /documents
  # GET /documents.json
  def index
    @attachments = Attachment.all
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  def download
    send_data(@attachment.file_contents,
              type: @attachment.content_type,
              filename: @attachment.filename)
  end

  # GET /documents/new
  def new
    @attachment = Attachment.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.uploaded_file(params[:attachment][:file])

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachment, notice: 'Attachment was successfully created.' }
        format.json { render :show, status: :created, location: @attachment }
      else
        format.html { render :new }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to @attachment, notice: 'Attachment was successfully updated.' }
        format.json { render :show, status: :ok, location: @attachment }
      else
        format.html { render :edit }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to attachments_url, notice: 'Attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:file)
    end
end
