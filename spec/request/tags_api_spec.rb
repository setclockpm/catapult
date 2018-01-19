require "rails_helper"

RSpec.describe "Tags API", type: :request do
  
  describe 'GET /tags' do
    # make HTTP get request before each example
    before do
      FactoryGirl.create(:tag)
      FactoryGirl.create(:tag, title: 'Shopping')
      get api_v1_tags_path
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    
    it "will return collection of tags (index)" do
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq 2 #data and include
    end
    
    
    context 'with search parameter' do
      before do
        FactoryGirl.create(:tag, title: 'Music')
        FactoryGirl.create(:tag, title: 'Leisure')
        FactoryGirl.create(:tag, title: 'Mandatory')
        FactoryGirl.create(:tag, title: 'Unmandatory')
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    
      it "will return entire collection of tags (index) when search parameter is empty" do
        get api_v1_tags_path(q: nil)
        puts Tag.all.inspect
        json = JSON.parse(response.body)
        expect(json["data"].length).to eq 6
      end
      
      it "will return an empty array when search parameter does not match any tags in the db" do
        get api_v1_tags_path(q: 'zzzzzzz')
        json = JSON.parse(response.body)
        expect(json["data"].length).to eq 0
      end
      
      it "will return all matching tags when a search parameter is passed" do
        get api_v1_tags_path(q: 'Man')
        json = JSON.parse(response.body)
        expect(json["data"].length).to eq 2
      end
      
      it "will return all matching tags when a search parameter is passed" do
        get api_v1_tags_path(q: 'ory')
        json = JSON.parse(response.body)
        expect(json["data"].length).to eq 2
      end
      
      it "will return all matching tags when a search parameter is passed" do
        get api_v1_tags_path(q: 'Musicmanship')
        json = JSON.parse(response.body)
        expect(json["data"].length).to eq 0
      end
      
      it "will return all matching tags when a search parameter is passed" do
        get api_v1_tags_path(q: 'Mandatory Music')
        json = JSON.parse(response.body)
        expect(json["data"].length).to eq 0
      end
      
      it "will return all matching tags when a search parameter is passed" do
        get api_v1_tags_path(q: 'm')
        json = JSON.parse(response.body)
        expect(json["data"].length).to eq 3
      end
      
      it "will return all matching tags when a search parameter is passed" do
        get api_v1_tags_path(q: 'MA')
        json = JSON.parse(response.body)
        expect(json["data"].length).to eq 2
      end

    end
    
  end
  
  
  
  describe "POST /tags" do
    let(:valid_attributes) { { data: { type: 'undefined', id: 'undefined', attributes: { title: "Someday" } } } }

   #
    context 'when the request is valid' do
      before { post api_v1_tags_path, params: valid_attributes }

      it 'creates a tag' do
        attributes = JSON.parse(response.body)["data"]["attributes"]
        expect(attributes["title"]).to eq('Someday')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end


    context 'when the request is invalid' do
      before do
        post api_v1_tags_path, { params: { data: {} } }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        json = JSON.parse(response.body)
        expect(json['title'][0]).to match(/can't be blank/)
      end
    end


  end
  
  
  
  describe "PATCH /tags" do
    
    let(:valid_attributes) { { data: { type: 'tag', id: '1', attributes: { title: "Updated Tag Title" } } } }
    
    context 'when the request is valid' do
      before do
        tag = FactoryGirl.create(:tag, title: 'Outdoor')
        patch api_v1_tag_path(tag), params: valid_attributes 
      end

      it 'updates a tag' do
        attributes = JSON.parse(response.body)["data"]["attributes"]
        expect(attributes["title"]).to eq('Updated Tag Title')
      end
      ``
      it 'has a response code of 200' do
        expect(response).to have_http_status(200)
      end
        
    end


    context 'when the request is invalid' do
      before do
        tag = FactoryGirl.create(:tag, title: 'Outdoor')
        patch api_v1_tag_path(tag), { params: { data: { type: 'tag', id: '1', attributes: { title: nil } } } }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        json = JSON.parse(response.body)
        expect(json['title'][0]).to match(/can't be blank/)
      end
    end
    
  end
  
  
end
