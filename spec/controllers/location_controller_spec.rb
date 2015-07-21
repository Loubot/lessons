require 'rails_helper'
require 'spec_helper'
include Devise::TestHelpers

describe LocationsController do 
	login_teacher
	before(:each) do
		@request.env['HTTP_REFERER'] = 'http://localhost:3000/teachers/1/your-location'
	end

	it "should create a new location" do
		
		expect{
			post :create, teacher_id: 1, location: FactoryGirl.attributes_for(:location)
		}.to change(Location, :count).by(1)
	end

	it "should fail when teacher_id is missing" do
		fake_attributes = { :latitude=>4.2, :longitude=>4.2, :name=>"Home", :address=>"49 Beech Park" }
		expect{
			post :create, teacher_id: 1, location: fake_attributes
		}.to change(Location, :count).by(0)
	end

	it "should fail when latitude is missing" do
		fake_attributes = { teacher_id: 1, :longitude=>4.2, :name=>"Home", :address=>"49 Beech Park" }
		expect{
			post :create, teacher_id: 1, location: fake_attributes
		}.to change(Location, :count).by(0)
	end

	it "should fail when longitude is missing" do
		fake_attributes = { teacher_id: 1, :latitude=>4.2, :name=>"Home", :address=>"49 Beech Park" }
		expect{
			post :create, teacher_id: 1, location: fake_attributes
		}.to change(Location, :count).by(0)
	end

	it "should fail when name is missing" do
		fake_attributes = { teacher_id: 1, :latitude=>4.2,  :longitude=>4.2, :address=>"49 Beech Park" }
		expect{
			post :create, teacher_id: 1, location: fake_attributes
		}.to change(Location, :count).by(0)
	end

	it "should fail when latitude is not a float" do
		fake_attributes = { teacher_id: 1, latitude: 'a', longitude: 4.2, name: 'Home', :address=>"49 Beech Park" }
		expect{
			post :create, teacher_id: 1, location: fake_attributes
		}.to change(Location, :count).by(0)
	end

	it "should fail when longitude is not a float" do
		fake_attributes = { teacher_id: 1, latitude: 4.2, longitude: 'b', name: 'Home', :address=>"49 Beech Park" }
		expect{
			post :create, teacher_id: 1, location: fake_attributes
		}.to change(Location, :count).by(0)
	end

	it "should delete a location" do
		location = FactoryGirl.create(:location)
		
		expect{
			delete :destroy, id: location.id, teacher_id: subject.current_teacher.id
		}.to change(Location, :count).by(-1)
	end
end