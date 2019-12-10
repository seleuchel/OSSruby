class MoviesController < ApplicationController

  
  def index

    @movies = Movie.all
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    id = params[:id]
    
    ##for_setting#######################################
    if (params[:commit] == 'Refresh')
      session[:ratings] = params[:ratings]
    end
    
    #filter#############################################
    @li = []
    @selected_ratings = session[:ratings]

    unless @selected_ratings.nil?
      @selected_ratings.each_key{
        |rating|
        @li << rating
      }
      @movies = Movie.all.where({rating: @li})
    end
    
   ####sort############################################
   
    if id == 'title_header'
      @movies = @movies.order('title')
      @css_title = 'hilite'
    end
    if id == 'release_date_header'
      @movies = @movies.order('release_date')
      @css_release_date = 'hilite'
    end
  end
  
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.html.haml by default
  end
  
  def new
    @movie = Movie.new
    # default: render 'new' template
  end
  
  def create
    params.require(:movie)
    permitted=params[:movie].permit(:title,:rating,:release_date)
    
    @movie = Movie.create!(permitted)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end
  
  #edit page
  def edit
    @movie = Movie.find params[:id]
  end

  #update page
  def update
    @movie = Movie.find params[:id]
    permitted = params[:movie].permit(:title,:rating,:release_date)
    @movie.update_attributes!(permitted)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end
  
  #제거를 위한 링크
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def hilite(header);
    return 'hilite' if @sort == header; end
  
end