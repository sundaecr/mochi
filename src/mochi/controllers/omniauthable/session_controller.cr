class Mochi::Controllers::Omniauthable::SessionController < ApplicationController
  def create
    redirect_to Mochi::Omniauthable::Provider.authorize_uri(params[:provider], "#{Amber.settings.host}/omniauth/#{params[:provider]}/callback")
  end

  def callback
    # TODO
    url = "#{Amber.settings.host}/omniauth/#{params[:provider]}/callback"

    # fakeuser = Mochi::Omniauthable::Provider.user(params[:provider], {"code" => params[:code]}, url)
    Mochi::Omniauthable::Provider.user(params[:provider], {"code" => params[:code]}, url)

    user = User.find_by(resource_params, :email, :email)
    if user
      session[:user_id] = user.uid
      flash[:info] = "Successfully logged in"
      redirect_to "/"
    else
      flash[:danger] = "Invalid. It doesn't look like you have registered"
      redirect_to "/"
    end
  end

  private def resource_params
    params.validation do
      required :provider
      optional :code
    end
  end
end
