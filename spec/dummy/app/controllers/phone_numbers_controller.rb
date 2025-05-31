class PhoneNumbersController < ApplicationController
  before_action :set_phone_number, only: %i[ show edit update destroy ]
  before_action :set_klass

  # GET /phone_numbers
  def index
    @objects = @phone_numbers = PhoneNumber.all
  end

  # GET /phone_numbers/1
  def show
  end

  # GET /phone_numbers/new
  def new
    @object = @phone_number = PhoneNumber.new
    @object.add_builds!  # Used by Object View for templates
  end

  # GET /phone_numbers/1/edit
  def edit
    @object.add_builds!  # Used by Object View for templates
  end

  # POST /phone_numbers
  def create
    @object = @phone_number = PhoneNumber.new(phone_number_params)

    if @phone_number.save
      redirect_to @phone_number, notice: "Phone number was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /phone_numbers/1
  def update
    if @phone_number.update(phone_number_params)
      redirect_to @phone_number, notice: "Phone number was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /phone_numbers/1
  def destroy
    @phone_number.destroy!
    redirect_to phone_numbers_path, notice: "Phone number was successfully destroyed.", status: :see_other
  end

  def self.phone_number_params
    [
    :number, :active, :person_id,
    
    ]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phone_number
      @phone_number = PhoneNumber.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def phone_number_params
      params.fetch(:phone_number, {})

    end
end
