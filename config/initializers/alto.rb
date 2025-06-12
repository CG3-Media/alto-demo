# Alto Configuration
Alto.configure do |config|
  # User model configuration
  config.user_model = "User"

  # Current user configuration (optional - smart defaults usually work)
  # Uncomment and customize only if you have non-standard authentication:
  #
  # For apps using Current.user pattern:
  # config.current_user { Current.user }
  #
  # For session-based authentication:
  # config.current_user { User.find_by(id: session[:user_id]) }
  #
  # For custom authentication:
  # config.current_user { your_authentication_method }

  # User display name (customize for your user model)
  # config.user_display_name do |user_id|
  #   user = User.find_by(id: user_id)
  #   user&.name || user&.email || "User ##{user_id}"
  # end

  # Permission methods (customize for your authentication system)

  # Who can access Alto at all?
  config.permission :can_access_alto? do
    user_signed_in?  # Devise helper, adjust for your auth system
  end

  # Who can submit new tickets?
  config.permission :can_submit_tickets? do
    user_signed_in?
  end

  # Who can comment on tickets?
  config.permission :can_comment? do
    user_signed_in?
  end

  # Who can vote on tickets and comments?
  config.permission :can_vote? do
    user_signed_in?
  end

  # Who can edit any ticket? (Usually admins only)
  config.permission :can_edit_tickets? do
    user_signed_in?
  end

  # Who can access the admin area?
  config.permission :can_access_admin? do
    current_user.email.include?("admin")
  end

  # Who can manage boards? (Create, edit, delete boards)
  config.permission :can_manage_boards? do
    user_signed_in?
  end

  # Who can access specific boards? (board-level access control)
  # config.permission :can_access_board? do |board|
  #   case board.slug
  #   when 'internal'
  #     current_user&.staff?
  #   else
  #     current_user.present?
  #   end
  # end

  config.user_profile_avatar_url do |user_id|
    "https://avatar.iran.liara.run/public/#{user_id}"
  end

  # Board configuration
  config.allow_board_deletion_with_tickets = false
end
