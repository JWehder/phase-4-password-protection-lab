class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    def create
        user = User.create!(user_params)
        session[:user_id] = user.id 
        render json: user, status: :created
    end

    def show 
        user = User.find_by(id: session[:user_id])
        if user
            render json: user
        else
            render json: { error: "Invalid username or password" }, status: :unauthorized
        end
    end


    private 

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def render_unprocessable_entity(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end


end
