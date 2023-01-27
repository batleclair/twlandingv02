class Admin::CandidatesController < ApplicationController
  def index
    @candidates = Candidate.all.order(created_at: :desc)
    authorize @candidates
  end
end
