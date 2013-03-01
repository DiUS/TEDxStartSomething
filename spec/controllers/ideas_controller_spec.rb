require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe IdeasController do

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # IdeasController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe 'POST react' do
    let(:member) { mock_model Member }
    let(:idea) { mock_model Idea }

    before :each do
      Idea.should_receive(:find).and_return idea
      controller.stub(:member).and_return member
    end

    it 'creates an actions taken entry' do
      Reaction.should_receive(:create!).with(:idea => idea, :member => member, :text => 'this is my reaction')
      post :react, {:id => 1, :text => 'this is my reaction', :format => 'json'}, valid_session 
    end
  end

  describe "GET show" do
    let(:idea_view_model) { mock IdeaViewModel }
    let(:member) { mock_model Member }
    let(:params) { {:id => 1} }

    before do
      controller.stub(:member).and_return member
      idea_view_model.should_receive(:as_json).and_return({ 'idea' => 'cool' })
      IdeaViewModel.stub(:new).and_return idea_view_model
    end

    it 'uses a view model to construct the json response' do
      IdeaViewModel.should_receive(:new).and_return idea_view_model
      get :show, params.merge(:format => :json), valid_session
    end

    it 'renders a open in app layout when showing via html' do
      IdeaViewModel.should_receive(:new).and_return idea_view_model
      get :show, params.merge(:format => :html), valid_session
      controller.should render_template(:layout => 'layouts/open_in_app')
    end

    it "assigns the requested idea as @idea" do
      get :show, params.merge(:format => :json), valid_session
      assigns(:idea).should eq({ 'idea' => 'cool' })
    end
  end

  describe "POST create" do
    let(:talk) { Talk.first }
    let(:valid_attributes) { 
      { 
        description: 'Body language affects how others see us, but it may also change how we see ourselves.',
        talks: [
          talk.as_json
        ],
        actions: [
          { description: 'Examine your own body language in different social situations.' },
        ]        
      }
    }

    describe "with valid params" do
      it "creates a new idea" do
        expect {
          post :create, { :format => 'json', :idea => valid_attributes}, valid_session
        }.to change(Idea, :count).by(1)
      end

      it "assigns a newly created idea as @idea" do
        post :create, { :format => 'json', :idea => valid_attributes}, valid_session
        assigns(:idea).should be_a(Idea)
        assigns(:idea).should be_persisted
      end

      it "assigns the member to the idea" do
        post :create, { :format => 'json', :idea => valid_attributes}, valid_session
        assigns(:idea).member.should be_a(Member)
      end

      it "should link it up to the ideas listed" do
        post :create, { :format => 'json', :idea => valid_attributes}, valid_session
        assigns(:idea).talks.should include(talk)
      end

      it "adds subordinate action entities" do
        post :create, { :format => 'json', :idea => valid_attributes}, valid_session
        assigns(:idea).actions.first.should be_a(Action)
      end

      it "return the json of the created idea" do
        post :create, { :format => 'json', :idea => valid_attributes}, valid_session
        idea_json = JSON.parse(response.body)
        idea_json['description'].should eq valid_attributes[:description]
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved idea as @idea" do
        # Trigger the behavior that occurs when invalid params are submitted
        Idea.any_instance.stub(:save).and_return(false)
        post :create, { :format => 'json', :idea => { "description" => "invalid value" }}, valid_session
        assigns(:idea).should be_a_new(Idea)
      end

    end
  end

  describe 'GET random' do
    it 'gets recent ideas' do
      idea = Idea.first
      Idea.should_receive(:find).with(:first, :order => 'rand()').and_return idea
      get :random, { :format => :json }
      response.body.should eql idea.to_json
    end
  end
end