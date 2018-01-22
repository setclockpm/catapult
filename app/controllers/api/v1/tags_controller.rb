module Api  
  module V1
    class TagsController < ApplicationController

      def index
        render json: load_breed ? @breed.tags : Tag.includes(:breeds)
      end
      
      def stats
        render json: Tag.includes(:breeds), fields: { breed: [:name]}, include: [:breeds], stats: true
      end
      
      # This being called 'create' is misleading being that the tags of a breed are essentially being 
      # replaced ... but I'm abiding by path given in the spec. 
      # I probably woudl have made a custom route
      def create
        if load_breed
          update_breed_tags(status: nil)
        else
          render json: { breed: ["cannot be blank"]}, status: :unprocessable_entity
        end
      end
      
      def show
        render json: load_tag
      end

      
      def update
        load_tag
        @tag.attributes = tag_params
        save_tag(status: nil) or render_error
      end
    
      def destroy
        load_tag
        @tag.destroy
        head 204
      end
      
    
    
      private
        def load_tag
          @tag = Tag.find(params[:id])
        end
        
        def load_breed
          return false unless params[:breed_id]
          @breed = Breed.find(params[:breed_id]) rescue nil
        end
        
        def render_error
          render json: @tag.errors, status: :unprocessable_entity
        end
        
        def save_tag(params)
          if @tag.save
            render json: @tag, status: params[:status], location: api_v1_tag_url(@tag)
          else
            false
          end
        end
        
        def update_breed_tags(params)
          puts "tag_params: #{tag_params.inspect}"
          @breed.attributes = tag_params

          if @breed.update_tags
            render json: @breed.tags, status: params[:status], location: api_v1_breed_url(@breed)
          else
            render json: { breed: ["tags could not be updated"]}, status: :unprocessable_entity
          end
        end
        
        def tag_params
          ActiveModelSerializers::Deserialization.jsonapi_parse(params)
        end
        
        
    end
  end
end  