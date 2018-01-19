module Api  
  module V1
    class TagsController < ApplicationController

      def index
        render json: Tag.filtered(params[:q])
      end
      
      def create
        @tag ||= Tag.new
        @tag.attributes = tag_attributes
        save_tag(status: :created) or render_error
      end
      
      # https://stackoverflow.com/questions/32079897/serializing-deeply-nested-associations-with-active-model-serializers
      # https://github.com/rails-api/active_model_serializers/pull/1762
      def update
        load_tag
        @tag.attributes = tag_attributes
        save_tag(status: nil) or render_error
      end
    
    
      private
        
        def load_tag
          @tag = Tag.find(params[:id])
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
        
        def tag_params
          ActiveModelSerializers::Deserialization.jsonapi_parse(params)
        end
        
        def tag_attributes
          attributes = tag_params
          attributes.delete(:id)# if @tag.new_record?
          attributes || {}
        end
        
    end
  end
end  