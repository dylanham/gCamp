class TermsController < PublicController

  def index
  end

  def about_page
    @projects = Project.all
    @users = User.all
    @comments = Comment.all
    @memberships = Membership.all
    @tasks = Task.all
  end

end
