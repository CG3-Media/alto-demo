class Account::DashboardController < Account::ApplicationController
  def index
    redirect_to alto.root_path
  end
end
