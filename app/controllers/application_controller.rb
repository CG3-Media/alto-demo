class ApplicationController < ActionController::Base
  include Controllers::Base

  protect_from_forgery with: :exception, prepend: true

  before_action :ensure_demo_user_signed_in

  private

  def ensure_demo_user_signed_in
    # Always redirect to Alto engine unless already there
    unless request.path.start_with?("/demo")
      # Ensure demo user is signed in first
      unless user_signed_in?
        # Create or find demo user
        demo_user = User.find_or_create_by(email: "demo@example.com") do |user|
          user.password = "altodemo"
          user.password_confirmation = "altodemo"
          user.first_name = "Demo"
          user.last_name = "User"
        end

        # Update missing details if user already existed
        if demo_user.first_name.blank? || demo_user.last_name.blank?
          demo_user.update!(
            first_name: demo_user.first_name.presence || "Demo",
            last_name: demo_user.last_name.presence || "User"
          )
        end

        # Ensure demo user has a team (required for Bullet Train)
        if demo_user.teams.empty?
          demo_user.teams.create!(name: "Demo Team", time_zone: "UTC")
        end

        # Create demo board and status set if they don't exist
        unless Alto::Board.exists?
          status_set = Alto::StatusSet.find_or_create_by(name: "Default") do |set|
            set.description = "Default status workflow"
            set.is_default = true
          end

          # Create default statuses
          unless status_set.statuses.exists?
            status_set.statuses.create!([
              {name: "Open", color: "#3b82f6", position: 0, slug: "open"},
              {name: "In Progress", color: "#f59e0b", position: 1, slug: "in-progress"},
              {name: "Completed", color: "#10b981", position: 2, slug: "completed"}
            ])
          end

          # Create demo board
          Alto::Board.create!(
            name: "Feature Requests",
            slug: "features",
            description: "Submit and vote on new feature ideas",
            status_set: status_set,
            item_label_singular: "feature"
          )
        end

        # Sign in the demo user
        sign_in(demo_user)
      end

      # Redirect everyone to Alto engine
      redirect_to "/demo"
    end
  end
end
