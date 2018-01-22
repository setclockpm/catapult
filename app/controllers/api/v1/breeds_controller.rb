module Api
  module V1
    class BreedsController < ApplicationController

      def index
        render json: Breed.all
      end
      
      def stats
        render json: Breed.includes(:tags), include: [:tags]
      end
      
      def show
        render json: load_breed, include: [:tags]
      end
      
      def create
        @breed ||= Breed.new
        @breed.attributes = breed_params
        create_breed(status: :created) or render_error
      end
      
      def update
        load_breed
        @breed.attributes = breed_params
        update_breed(status: nil) or render_error
      end
      
      def destroy
        load_breed
        @breed.destroy
        head 204
      end
    
    
      private
        
        def load_breed
          @breed = Breed.find(params[:id])
        end
        
        def render_error
          render json: @breed.errors, status: :unprocessable_entity
        end
        
        def create_breed(params)
          if @breed.save && @breed.add_tags
            render json: @breed, include: [:tags], status: params[:status], location: api_v1_breed_url(@breed)
          else
            false
          end
        end
        
        def update_breed(params)
          if @breed.save && @breed.update_tags
            render json: @breed, include: [:tags], status: params[:status], location: api_v1_breed_url(@breed)
          else
            false
          end
        end
        
        def breed_params
          ActiveModelSerializers::Deserialization.jsonapi_parse(params)
        end
        
    end
  end
end  