class FormsController < ApplicationController
  #before_action :set_form, only: [:show, :edit, :update, :destroy]
  def adopt
    @adopt = StaticPage.first.adopt
    @errors = []
  end

  def send_adoption
    flash[:success] = "Your form was submitted successfully. An email with information about your adoption status should be sent to you shortly."
    redirect_to "/adopt"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_params
      params.fetch(:form, {})
    end
end
