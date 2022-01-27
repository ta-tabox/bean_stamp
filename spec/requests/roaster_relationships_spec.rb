require 'rails_helper'

RSpec.describe 'RoasterRelationships', type: :request do
  let(:user) { create(:user) }
  let(:roaster) { create(:roaster) }
  let(:relationship) { user.roaster_relationships.find_by(roaster_id: roaster.id) }

  describe 'POST #create' do
    subject { proc { post roaster_relationships_path, params: { roaster_id: roaster.id } } }
    context 'when user is not signed in' do
      it 'redirects to new_user_session_path ' do
        subject.call
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user is signed in' do
      before { sign_in user }
      it { is_expected.to change(RoasterRelationship, :count).by(1) }
      context 'with Ajax' do
        subject { proc { post roaster_relationships_path, xhr: true, params: { roaster_id: roaster.id } } }
        it { is_expected.to change(RoasterRelationship, :count).by(1) }
      end
    end
  end

  describe 'DELET #destroy' do
    subject { proc { delete roaster_relationship_path relationship } }
    before do
      user.follow_roaster(roaster)
    end
    context 'when user is not signed in' do
      it 'redirects to new_user_session_path ' do
        subject.call
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when user is signed in' do
      before { sign_in user }
      it { is_expected.to change(RoasterRelationship, :count).by(-1) }
      context 'with Ajax' do
        subject { proc { delete roaster_relationship_path relationship, xhr: true } }
        it { is_expected.to change(RoasterRelationship, :count).by(-1) }
      end
    end
  end
end
