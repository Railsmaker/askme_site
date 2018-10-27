class HashtagsController < ApplicationController
  def show
    @tag = params[:tag]
    @questions = Question.includes(:hashtags).where(hashtags: { tag: params[:tag] } )
  end
end