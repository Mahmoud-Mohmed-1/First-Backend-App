module Api
  module V1
    class ChallengesController < ApplicationController
      before_action :authenticate_user!, only: [ :update, :destroy, :create]
      before_action :authorize_admin , only: [ :update, :destroy, :create]
      before_action :set_challenge , only: [ :update, :destroy, :show]
      def index
        @challenges = Challenge.all
        render json: @challenges
      end

      def create
        # challenge = Challenge.new(challenges_params.merge(user_id: current_user.id))
        @challenge = current_user.challenges.build(challenges_params)
        if @challenge.save
          render json: { message: "Challenge successfully created", data: @challenge }, status: :created
        else
          render json: { message: "Challenge creation failed", errors: @challenge.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        if @challenge
          render json: @challenge
        else
          render json: { message: "Challenge not found" }, status: :not_found
        end
      end

      def update
        # @challenge = current_user.challenges.find(params[:id])
        if @challenge.update(challenges_params)
          render json: { message: "Challenge successfully updated", data: @challenge }, status: :ok
        else
          render json: { message: "Challenge update failed", errors: @challenge.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @challenge
          @challenge.destroy
          render json: { message: "Challenge successfully deleted" }, status: :ok
        else
          render json: { message: "Challenge not found" }, status: :not_found
        end
      end

      private
      def authorize_admin
        admin_emails = ENV['ADMIN_EMAILS']&.split(',') || []
        unless admin_emails.include?(current_user.email)
          render json: { message: "Unauthorized access" }, status: :unauthorized
        end
      end


      def set_challenge
        @challenge = Challenge.find(params[:id])
      end
      def challenges_params
        params.require(:challenge).permit(:title, :description, :start_date, :end_date)
      end
    end
  end
end