class Account::DashboardController < Account::ApplicationController
  def index
    # redirect_to alto.root_path
    redirect_to [:account, :teams]
  end
end
