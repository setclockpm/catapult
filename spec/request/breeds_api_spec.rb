require "rails_helper"

RSpec.describe "Breeds API", type: :request do
    
  describe 'GET /breeds - retuns all breeds' do
    before do
      FactoryGirl.create(:breed_with_tags, tags_count: 1)
      FactoryGirl.create(:breed, name: 'Tabby')
      FactoryGirl.create(:breed, name: 'Cymric')
      get api_v1_breeds_path
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    
    it "will return collection of breeds (index)" do
      json = JSON.parse(response.body)
      expect(json.length).to eq 1 #data without included hash
      expect(json['data'].length).to eq 3
    end
  end
  
  
  describe 'GET /breeds/:breed_id - returns breed & all tags belonging to it' do
    before do
      FactoryGirl.create(:breed_with_tags, name: 'Tabby')
      @breed_with_tags = FactoryGirl.create(:breed_with_tags, tags_count: 2)
      get api_v1_breed_path(@breed_with_tags)
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    
    it "will return a breed and associated tags (show)" do
      json = JSON.parse(response.body)
      expect(json.length).to eq 2 #data with included hash
      expect(json['data']['attributes']['name']).to eq "Norwegian Forest Cat"
      expect(json['included'].length).to eq 2 # Two associated tags
    end
    
  end
  
  
  # stats_api_v1_breeds
  describe 'GET /breeds/stats' do
    before do
      FactoryGirl.create(:breed_with_tags, tags_count: 1)
      FactoryGirl.create(:breed, name: 'Tabby')
      FactoryGirl.create(:breed, name: 'Cymric')
      get stats_api_v1_breeds_path
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
    let(:valid_attributes) { { data: { type: 'undefined', id: 'undefined', attributes: { name: "Russian Blue" } } } }
    let(:valid_attrs_with_tags) { { data: { type: 'breeds', id: 'undefined', attributes:  { name: "Burmese", tags: ["fussy", "fast"] } } } }
    let(:valid_attrs_blank_tags) { { data: { type: 'breeds', id: 'undefined', attributes: { name: "Persian", tags: nil } } } }
    let(:valid_attrs_empty_tags) { { data: { type: 'breeds', id: 'undefined', attributes: { name: "Persian", tags: [nil] } } } }

   #
    context 'when the request is valid' do

      context 'w/o tag parameters' do
        before do
          post api_v1_breeds_path, params: valid_attributes 
        end
      
        it 'creates a breed' do
          attributes = JSON.parse(response.body)["data"]["attributes"]
          expect(attributes["name"]).to eq('Russian Blue')
        end
        it 'has a response code of 201' do
          expect(response).to have_http_status(201)
        end
      end
      
      context "with tags parameters" do
        before do
          post api_v1_breeds_path, params: valid_attrs_with_tags 
        end
      
        it 'creates a breed' do
          json       = JSON.parse(response.body)
          attributes = json["data"]["attributes"]
          expect(attributes["name"]).to eq('Burmese')
          expect(json["included"].size).to eq(2)
        end
        it 'has a response code of 201' do
          expect(response).to have_http_status(201)
        end
      end
      
      context "with nil as the tags parameter" do
        before do
          post api_v1_breeds_path, params: valid_attrs_blank_tags
        end
      
        it 'creates a breed' do
          json       = JSON.parse(response.body)
          attributes = json["data"]["attributes"]
          expect(attributes["name"]).to eq('Persian')
          expect(json["included"]).to eq(nil)
        end
      end
      
      context "with empty array as the tags parameter" do
        before do
          post api_v1_breeds_path, params: valid_attrs_empty_tags
        end
      
        it 'creates a breed' do
          json       = JSON.parse(response.body)
          attributes = json["data"]["attributes"]
          expect(attributes["name"]).to eq('Persian')
          expect(json["included"]).to eq(nil)
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
        expect(json['name'][0]).to match(/can't be blank/)
      end
    end

  end





  
  describe "PATCH /breeds/:breed_id" do
    let(:valid_attributes) { { data: { type: 'breeds', id: '1', attributes: { name: "British Shorthair" } } } }
    let(:valid_attrs_with_tags) { { data: { type: 'breeds', id: '1', attributes:  { name: "Sphynx", tags: ["fussy", "fast"] } } } }
    let(:valid_attrs_empty_tags) { { data: { type: 'breeds', id: '1', attributes: { name: "Ragamuffin", tags: [nil] } } } }
    let(:valid_attrs_blank_tags) { { data: { type: 'breeds', id: '1', attributes: { name: "Bengal", tags: nil } } } }
    

    context 'when the request is valid' do
      
      context "with tags parameters" do
        before do
          breed_with_tags = FactoryGirl.create(:breed, name: 'Maine Coon')
          breed_with_tags.tags << [FactoryGirl.create(:tag, name: "invisible"), FactoryGirl.create(:tag, name: "spotted")]
          
          patch api_v1_breed_path(breed_with_tags), params: valid_attrs_with_tags
        end

        it "updates the breed and it's tags (overwrite tags, don't merge)" do
          json       = JSON.parse(response.body)
          attributes    = json["data"]["attributes"]
          included_tags = json["included"]
          
          expect(attributes["name"]).to eq('Sphynx')
          expect(included_tags.size).to eq(2)
          expect(included_tags.first["attributes"]["name"]).to eq("fussy")
        end

        it 'has a response code of 200' do
          expect(response).to have_http_status(200)
        end
      end
      
      context "with nil as the tags parameter" do
        before do
          breed = FactoryGirl.create(:breed_with_tags, name: 'Maine Coon', tags_count: 1)
          patch api_v1_breed_path(breed), params: valid_attrs_blank_tags
        end

        it "updates the breed but NOT it's tags" do
          json       = JSON.parse(response.body)
          attributes = json["data"]["attributes"]
          included_tags = json["included"]
          
          expect(attributes["name"]).to eq('Bengal')
          expect(included_tags.size).to eq(1)
        end

      end
      
      context "with empty array as the tags parameter" do
        before do
          breed = FactoryGirl.create(:breed_with_tags, name: 'Ragdoll')
          patch api_v1_breed_path(breed), params: valid_attrs_empty_tags
        end

        it 'updates a breed and deletes tags' do
          json       = JSON.parse(response.body)
          attributes = json["data"]["attributes"]
          included_tags = json["included"]
          
          expect(attributes["name"]).to eq('Ragamuffin')
          expect(json["included"]).to eq(nil)
        end

      end
      
      context 'w/o tag parameters' do
        before do
          breed = FactoryGirl.create(:breed_with_tags, name: 'Russian Blue', tags_count: 3)
          patch api_v1_breed_path(breed), params: valid_attributes 
        end

        it 'updates only the breed and NOT tags' do
          json          = JSON.parse(response.body)
          attributes    = json["data"]["attributes"]
          included_tags = json["included"]

          expect(attributes["name"]).to eq('British Shorthair')
          expect(included_tags.size).to eq(3)
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
        expect(json['name'][0]).to match(/can't be blank/)
      end
    end

  end
  
  
  
  
  
  describe "DELETE /breeds" do
    
    context 'deleting a breed with tags' do
      before do
        shock_hazard_tag = FactoryGirl.create(:tag, name: "shock-hazard")
        @cant_swim_tag = FactoryGirl.create(:tag, name: "can't swim")
        FactoryGirl.create(:breed_with_tags, name: "Robo-Kitchy",  tags_count: 1).tags << shock_hazard_tag
        @thundercat_breed = FactoryGirl.create(:breed, name: "Thundercat")
        @thundercat_breed.tags << [@cant_swim_tag, shock_hazard_tag]
      end

      it 'returns status code 204' do
        delete api_v1_breed_path(@thundercat_breed)
        expect(response).to have_http_status(204)
      end

      it 'reduces breed records by 1' do
        expect {
          delete api_v1_breed_path(@thundercat_breed)
        }.to change(Breed.all, :count).by(-1)
      end
      
      # When it comes to tags of deleted breeds, 
      # please work out a way to ensure there aren't orphaned tags left in the system that can't be deleted.
      it 'reduces tag records by 1 and not 2' do
        expect {
          delete api_v1_breed_path(@thundercat_breed)
        }.to change(Tag.all, :count).by(-1)
      end
    end
    
    context 'deleting a breed without tags' do
      before do
        @breed = FactoryGirl.create(:breed, name: "Wind Tiger")
      end

      it 'reduces breed records by 1' do
        expect {
          delete api_v1_breed_path(@breed)
        }.to change(Breed.all, :count).by(-1)
      end
    end

  end
  
end
