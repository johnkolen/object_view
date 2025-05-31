module ObjectView
  class PeopleController < ApplicationController
    before_action :set_person, only: %i[ show edit update destroy ]
    before_action :set_klass

    # GET /people
    def index
      @objects = @people = Person.all
    end

    # GET /people/1
    def show
    end

    # GET /people/new
    def new
      @object = @person = Person.new
      @object.add_builds!  # Used by Object View for templates
    end

    # GET /people/1/edit
    def edit
      @object.add_builds!  # Used by Object View for templates
    end

    # POST /people
    def create
      @object = @person = Person.new(person_params)

      if @person.save
        redirect_to @person, notice: "Person was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /people/1
    def update
      if @person.update(person_params)
        redirect_to @person, notice: "Person was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /people/1
    def destroy
      @person.destroy!
      redirect_to people_path, notice: "Person was successfully destroyed.", status: :see_other
    end

    def self.person_params
      [
      :name, :date_of_birth, :ssn, :age, :happy,
      phone_numbers_attributes: [[:number, :active, :person_id, :id, :_destroy]]
      ]
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_person
        @object = @person = Person.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def person_params
        params.expect! person: self.class.person_params
      end
  end
end
