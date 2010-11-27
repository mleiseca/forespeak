require File.dirname(__FILE__) + '/../spec_helper'

describe UserSessionsController do
  fixtures :all
  render_views

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    UserSession.any_instance.stubs(:valid?).returns(false)
    post 'create', :user_session => { :name => 'fakeuser', :password => 'fakepassword' }
    response.should render_template(:new)
  end
  # 
  # it "create action should redirect when model is valid" do
  #   # note: couldn't stub here, was getting this error: undefined method `persistence_token' for nil:NilClass
  #   UserSession.any_instance.stubs(:valid?).returns(true)
  #   post 'create', :user_session => { :name => 'fakeuser', :password => 'fakepassword' }
  #   response.should redirect_to(root_url)
  # end
  
  # it "destroy action should destroy model and redirect to index action" do
  #   user_session = UserSession.first
  #   delete :destroy, :id => user_session
  #   response.should redirect_to(root_url)
  #   UserSession.exists?(user_session.id).should be_false
  # end
end
