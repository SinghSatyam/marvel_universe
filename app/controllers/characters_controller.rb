class CharactersController < ApplicationController

  before_filter :initialize_variables

  def index
    @per_page=20
    query=query_object
    query.merge!("offset"=>@per_page*params[:page].to_i-1) if (params[:page].present? && params[:page].to_i>0)
    @response_obj=InfinityStone.characters(query)
  end

  def show
    @response_obj=InfinityStone.character(params[:id],query_object)
  end

  private

  def initialize_variables
    @results=[]
  end

  def render(*args)
    validate_response
    super
  end

  def validate_response
    if @response_obj["code"]==200
       @results=@response_obj["data"]["results"]
       make_pagination_variables @response_obj,@per_page if @_action_name=="index"  
    else
      @status=@response_obj["status"]
      @message=@response_obj["message"]
    end
  end

  def query_object
    ts=Time.now.to_i.to_s
    query={
      "ts"=>ts,
      "apikey"=>ENV["public_key"],
      "hash"=>Digest::MD5.hexdigest("#{ts}#{ENV["private_key"]}#{ENV["public_key"]}")
    }
  end

  def make_pagination_variables response,per_page
    @total_pages=response["data"]["total"]/(per_page)
    @page_number=((response["data"]["offset"]/(per_page)+1))
    @next_page_number=@page_number+1
    @previous_page_number=@page_number-1
  end

end
