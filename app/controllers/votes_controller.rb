class VotesController < ApplicationController


  def new
    @food_truck = FoodTruck.find(params[:food_truck_id])
    @review = @food_truck.reviews.where(id: params[:review_id])
    @vote = Vote.new(review_id: params[:review_id],user_id: current_user.id)
  end

  def create
    @food_truck = FoodTruck.find(params[:food_truck_id])
    @review = @food_truck.reviews.where(id: params[:review_id])
    vote_check = Vote.find_by(review_id: params[:review_id],
                              user_id: current_user)

    if vote_check.nil?
      @vote = Vote.new(review_id: params[:review_id], user_id: current_user.id)
    else
      @vote = vote_check.destroy_if_exists(params[:vote_type])
    end

  #   if !@vote.nil?
  #     if params[:vote_type] == "upvote"
  #       @vote.upvote = 1
  #       @vote.downvote = 0
  #     elsif params[:vote_type] == "downvote"
  #       @vote.downvote = 1
  #       @vote.upvote = 0
  #     end
  #     respond_to do |format|
  #       if @vote.save
  #         check_review = Review.find(params[:review_id])
  #         format.html
  #         format.json { render json: check_review.score }
  #       end
  #     end
  #   else
  #     respond_to do |format|
  #       check_review = Review.find(params[:review_id])
  #       format.html
  #       format.json { render json: check_review.score }
  #     end
  #   end
  # end
    if !@vote.nil?
      @vote.change_vote(params[:vote_type])
      @vote.save
    end

    respond_to do |format|
      check_review = Review.find(params[:review_id])
      format.html
      format.json { render json: check_review.score }
    end
  end
end
