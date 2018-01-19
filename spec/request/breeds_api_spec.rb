require "rails_helper"

RSpec.describe "Breeds API", type: :request do
  
  describe 'GET /breeds' do
    # make HTTP get request before each example
    before do
      FactoryGirl.create(:breed_with_tags, tags_count: 1)
      FactoryGirl.create(:breed, title: 'Play ocarina')
      FactoryGirl.create(:breed, title: 'Go to the gym')
      get api_v1_breeds_path
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    
    it "will return collection of breeds (index)" do
      json = JSON.parse(response.body)
      expect(json.length).to eq 2 #data and include
      expect(json['data'].length).to eq 3
    end
    
  end
  
  
  
  
  
  
  describe "POST /breeds" do
    let(:valid_attributes) { { data: { type: 'undefined', id: 'undefined', attributes: { title: "Do Homework" } } } }

   #
    context 'when the request is valid' do
      before { post api_v1_breeds_path, params: valid_attributes }

      it 'creates a breed' do
        attributes = JSON.parse(response.body)["data"]["attributes"]
        expect(attributes["title"]).to eq('Do Homework')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end


    context 'when the request is invalid' do
      before do
        post api_v1_breeds_path, { params: { data: {} } }
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





  
  describe "PATCH /breeds" do
    let(:valid_attrs_with_tags) { { data: { type: 'breeds', id: '1', attributes: { title: "Updated Breed Title", tags: ["Urgent", "Home"] } } } }
    let(:valid_attrs_empty_tags) { { data: { type: 'breeds', id: '1', attributes: { title: "Updated Breed Title", tags: [] } } } }
    let(:valid_attrs_blank_tags) { { data: { type: 'breeds', id: '1', attributes: { title: "Updated Breed Title", tags: nil } } } }
    let(:valid_attributes) { { data: { type: 'breeds', id: '1', attributes: { title: "Updated Title" } } } }
    
   #
    context 'when the request is valid' do
      
      context "with tags parameters" do
        before do
          breed = FactoryGirl.create(:breed, title: 'Play ocarina')
          patch api_v1_breed_path(breed), params: valid_attrs_with_tags 
        end

        it 'updates a breed' do
          json       = JSON.parse(response.body)
          attributes = json["data"]["attributes"]
          expect(attributes["title"]).to eq('Updated Breed Title')
          expect(json["included"].size).to eq(2)
        end

        it 'has a response code of 200' do
          expect(response).to have_http_status(200)
        end
      end
      
      context "with nil as the tags parameter" do
        before do
          breed = FactoryGirl.create(:breed, title: 'Play ocarina')
          patch api_v1_breed_path(breed), params: valid_attrs_blank_tags
        end

        it 'updates a breed' do
          json       = JSON.parse(response.body)
          attributes = json["data"]["attributes"]
          expect(attributes["title"]).to eq('Updated Breed Title')
          expect(json["included"]).to eq(nil)
        end

      end
      
      context "with empty array as the tags parameter" do
        before do
          breed = FactoryGirl.create(:breed, title: 'Play ocarina')
          patch api_v1_breed_path(breed), params: valid_attrs_empty_tags
        end

        it 'updates a breed' do
          json       = JSON.parse(response.body)
          attributes = json["data"]["attributes"]
          expect(attributes["title"]).to eq('Updated Breed Title')
          expect(json["included"]).to eq(nil)
        end

      end
      
      context 'w/o tag parameters' do
        before do
          breed = FactoryGirl.create(:breed, title: 'Play ocarina')
          patch api_v1_breed_path(breed), params: valid_attributes 
        end

        it 'updates a breed' do
          attributes = JSON.parse(response.body)["data"]["attributes"]
          expect(attributes["title"]).to eq('Updated Title')
        end
        ``
        it 'has a response code of 200' do
          expect(response).to have_http_status(200)
        end
      end
    end


    context 'when the request is invalid' do
      before do
        post api_v1_breeds_path, { params: { data: {} } }
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
  
  
  
  
  
  
  
  
  
  describe "DELETE /breeds" do
    
    context 'deleting a breed with tags' do
      before do
        @breed = FactoryGirl.create(:breed_with_tags, tags_count: 2)
        FactoryGirl.create(:breed_with_tags, tags_count: 1)
      end

      it 'returns status code 204' do
        delete api_v1_breed_path(@breed)
        expect(response).to have_http_status(204)
      end

      it 'reduces breed records by 1' do
        expect {
          delete api_v1_breed_path(@breed)
        }.to change(Breed.all, :count).by(-1)
      end
    end
    
    context 'deleting a breed without tags' do
      before do
        @breed = FactoryGirl.create(:breed)
        FactoryGirl.create(:breed)
      end

      it 'reduces breed records by 1' do
        expect {
          delete api_v1_breed_path(@breed)
        }.to change(Breed.all, :count).by(-1)
      end
    end

  end
  
end
