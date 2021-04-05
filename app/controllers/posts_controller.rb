class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  include Prawn::View
  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        receipt_pdf = Prawn::Document.new(:background => "app/assets/images/saffron.png", page_layout: :landscape)
        receipt_pdf.text "BHARTIYA JANTA PARTY", align: :center, :size => 25, style: :bold
        receipt_pdf.text "Central Office", align: :center, :size => 14, style: :italic
        receipt_pdf.text "11 Ashok Road, New Delhi-110001 ", align: :center, :size => 14
        receipt_pdf.image Rails.root.join("app/assets/images/bjp.png"), :at => [20,550], :width => 50
        receipt_pdf.move_down 30
        receipt_pdf.text "No: #{@post.title}", style: :bold
        receipt_pdf.text "Date...............", align: :right, :top_margin => 100
        receipt_pdf.move_down 5
        receipt_pdf.text "Received with thanks from Sh/Smt/M/s.........................................................................................................................................................."
        receipt_pdf.move_down 15
        receipt_pdf.text "Address.........................................................................................................................................................................................................."
        receipt_pdf.move_down 15
        receipt_pdf.text "Rs..................................................................................................................................................................................................................."
        receipt_pdf.move_down 15
        receipt_pdf.text "vide cash/cheque no.....................................................dt................................................drawn on...........................................as donation."
        receipt_pdf.move_down 20
        receipt_pdf.text "Rs................................", :size => 25, style: :bold
        receipt_pdf.text "For Treasurer", align: :right
        receipt_pdf.move_down 30
        receipt_pdf.text "Donation to the Party are exempt from Income Tax u/s 80GGB for Companies and u/s 80 GGC for Others as per Income Tax Act, 1961", style: :bold, :size => 13
        receipt_pdf.move_down 10
        receipt_pdf.text "PAN No.: AAABB015F", :size => 10, style: :bold
        receipt_pdf.text "Regn. No.: 56/R/1/89/Dt. 19 sept 1989", :size => 8, style: :bold, align: :right
        send_data receipt_pdf.render, filename: "show.pdf",
        type: "application/pdf",
        disposition: "inline"
      end
    end
  end




  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
  end
