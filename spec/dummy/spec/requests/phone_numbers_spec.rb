require 'rails_helper'

RSpec.describe "/people", type: :request do
  requestsSetup object: :create_phone_number,
                objects: [ :create_phone_number_sample,
                          :create_phone_number_sample ],
                user: :admin_user

  # This should return the minimal set of attributes required to create a valid
  # PhoneNumber. As you add validations to PhoneNumber, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    # skip("Add one or more hashes of attributes valid for your model")
    [
      build(:phone_number).to_params,
      build(:phone_number_sample).to_params
    ]
  }

  let(:invalid_attributes) {
    # skip("Add one or more hashes of attributes invalid for your model")
    build(:phone_number).to_params number: "9208211"  # bad param
  }
  let(:new_attributes) {
    # skip("Add one or more hash of attributes valid for your model")
    build(:phone_number_sample).to_params.slice(*%i[number active])
  }

  requests_get_index
  requests_get_show
  requests_get_new
  requests_get_edit
  requests_post_create
  requests_patch_update
  requests_delete_destroy
end
