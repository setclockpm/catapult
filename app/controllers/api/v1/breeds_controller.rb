module Api
  module V1
    class BreedsController < ApplicationController

      def index
        render json: Breed.includes(:tags), include: [:tags]
      end
      
      def create
        @breed ||= Breed.new
        @breed.attributes = breed_attributes
        save_breed(status: :created) or render_error
      end
      
      def show
        load_breed_with_tags
      end
      
      # Looked into how nested attributes work and looks like it's still being discussed often
      # https://stackoverflow.com/questions/32079897/serializing-deeply-nested-associations-with-active-model-serializers
      # https://github.com/rails-api/active_model_serializers/pull/1762
      def update
        load_breed
        @breed.attributes = breed_attributes
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
        
        def load_breed
          @breed = Breed.find(params[:id])
        end
        
        def render_error
          render json: @breed.errors, status: :unprocessable_entity
        end
        
        def save_breed(params)
          if @breed.save
            render json: @breed, status: params[:status], location: api_v1_breed_url(@breed)
          else
            false
          end
        end
        
        def update_breed(params)
          if @breed.save && @breed.save_tags
            render json: @breed, include: [:tags], status: params[:status], location: api_v1_breed_url(@breed)
          else
            false
          end
        end
        
        def breed_params
          ActiveModelSerializers::Deserialization.jsonapi_parse(params)
        end
        
        def breed_attributes
          attributes = breed_params
          attributes.delete(:id)
          attributes || {}
        end
        
    end
  end
end  