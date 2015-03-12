class UserManagement

  def self.remove_user_id_on_comments(user)
    user.comments.update_all(user_id: nil)
  end

end
