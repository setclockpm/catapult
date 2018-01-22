require "rails_helper"
# puts "JSON: #{JSON.pretty_unparse(json)}\n\n"
# I love you ^


RSpec.describe "Tags API", type: :request do
  
  describe 'GET /tags' do

    before do
      air_lynx_breed   = FactoryGirl.create(:breed, name: "Air Lynx")
      climbs_trees_tag = FactoryGirl.create(:tag, name: 'tree climber')
      flyer_tag        = FactoryGirl.create(:tag, name: 'flyer')
      FactoryGirl.create(:tag, name: 'large ears')
      air_lynx_breed.tags << flyer_tag
      get api_v1_tags_path
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    
    it "will return collection of tags (index)" do
      json = JSON.parse(response.body)      
      expect(json["data"].length).to eq 3 #[tree climber, flyer, large ears]
    end
    
  end
  
  
  
  describe 'GET breeds/:breed_id/tags' do
    # make HTTP get request before each example
    before do
      earth_puma_breed = FactoryGirl.create(:breed_with_tags, name: "Earth Puma", tags_count: 1)
      air_lynx_breed   = FactoryGirl.create(:breed, name: "Air Lynx")
      climbs_trees_tag = FactoryGirl.create(:tag, name: 'tree climber')
      flyer_tag        = FactoryGirl.create(:tag, name: 'flyer')
      air_lynx_breed.tags << [climbs_trees_tag, flyer_tag]
      earth_puma_breed.tags << climbs_trees_tag
      get api_v1_breed_tags_path(air_lynx_breed)
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    
    it "will return collection of tags (index)" do
      json = JSON.parse(response.body)      
      expect(json["data"].length).to eq 2 #['flyer', 'tree climber']
    end
    
  end
  
  
  
  describe "POST breeds/:breed_id/tags" do
    let(:valid_attributes) { { data: { type: 'breeds', id: '1', attributes: { tags: ["hairless", "loves attention"] } } } }
   
    context 'when the request is valid' do
      before do
        air_lynx_breed = FactoryGirl.create(:breed_with_tags, tags_count: 1, name: "Air Lynx")
        post api_v1_breed_tags_path(air_lynx_breed), params: valid_attributes
      end 

      it 'replaces a breeds tags' do
        json          = JSON.parse(response.body)
        tags = json["data"]
        
        expect(tags.size).to eq(2)
        expect(tags.first["attributes"]["name"]).to eq("hairless")
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(200)
      end
    end


    context 'when the request is invalid' do
      before do
        post api_v1_tags_path, { params: { data: {} } }
      end

      it 'returns status code 422 + error message' do
        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        expect(json['breed'][0]).to match(/cannot be blank/)
      end

    end

  end
  
  
  
  describe "PATCH /tags" do
    
    let(:valid_attributes) { { data: { type: 'tag', id: '1', attributes: { name: "Noisy" } } } }
    
    context 'when the request is valid' do
      before do
        tag = FactoryGirl.create(:tag, name: 'Outdoor')
        patch api_v1_tag_path(tag), params: valid_attributes 
      end

      it 'updates a tag' do
        json = JSON.parse(response.body)
        attributes = json["data"]["attributes"]
        expect(attributes["name"]).to eq('Noisy')
      end
      ``
      it 'has a response code of 200' do
        expect(response).to have_http_status(200)
      end
        
    end


    context 'when the request is invalid' do
      before do
        tag = FactoryGirl.create(:tag, name: 'Outdoor')
        patch api_v1_tag_path(tag), { params: { data: { type: 'tag', id: '1', attributes: { name: nil } } } }
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
    
    context 'deleting a tag' do
      before do
        @shock_hazard_tag = FactoryGirl.create(:tag, name: "shock-hazard")
        cant_swim_tag     = FactoryGirl.create(:tag, name: "can't swim")
        FactoryGirl.create(:breed_with_tags, name: "Robo-Kitchy",  tags_count: 1).tags << @shock_hazard_tag
        @thundercat_breed = FactoryGirl.create(:breed, name: "Thundercat")
        @thundercat_breed.tags << [cant_swim_tag, @shock_hazard_tag]
      end

      it 'returns status code 204 and deletes all associations' do
        expect {
          delete api_v1_tag_path(@shock_hazard_tag)
        }.to change(Tag.all, :count).by(-1)
        expect(response).to have_http_status(204)
        expect(@thundercat_breed.tags.size).to eq(1)
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
