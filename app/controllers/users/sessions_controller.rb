class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  respond_to :json

  # POST /users/sign_in
  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        message: 'Logged in successfully.',
        data: resource.as_json(only: [:id, :email]) # Adjust fields as necessary
      }, status: :ok
    else
      render json: {
        message: 'Login failed. Invalid credentials.'
      }, status: :unauthorized
    end
  end

  # DELETE /users/sign_out
  def respond_to_on_destroy
    if current_user
      # If using JWT or tokens, invalidate them here (if necessary)

      # Clear session and sign out the user
      sign_out(current_user)

      render json: {
        message: "Logged out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
