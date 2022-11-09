class Admin::CandidatesController < ApplicationController
  def index
    @candidates = Candidate.all
    authorize @candidates
  end
end
