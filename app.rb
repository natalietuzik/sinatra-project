require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  redirect("/food_form")
end

get("/food_form") do
  erb(:food_form)
end

get("/get_foods") do
  begin
    @ingredient_one = params.fetch("ingredient_one").capitalize
    @ingredient_two = params.fetch("ingredient_two").capitalize
    @ingredient_three = params.fetch("ingredient_three").capitalize
  rescue KeyError => e
    #Redirect message
    redirect("/food_form?error=#{e.message}")
  end
 
  api_url = "https://api.spoonacular.com/recipes/findByIngredients/?apiKey=#{ENV["RECIPE_API_KEY"]}&ingredients=#{@ingredient_one},+#{@ingredient_two},+#{@ingredient_three}&number=20"

  raw_data = HTTP.get(api_url)

  
  raw_data_string = raw_data.to_s


  @parsed_data = JSON.parse(raw_data_string)
  
  
  erb(:get_foods)
end

get("/:get_foods/:get_recipe") do
  @recipe_id = params.fetch(:get_recipe)

  api_url = "https://api.spoonacular.com/recipes/#{@recipe_id}/information?apiKey=#{ENV["RECIPE_API_KEY"]}"


  raw_data = HTTP.get(api_url)

  
  raw_data_string = raw_data.to_s

  
  @parsed_recipe = JSON.parse(raw_data_string)

  @title = @parsed_recipe.fetch("title")

  @instructions = @parsed_recipe.fetch("analyzedInstructions")
  @steps = @instructions.first.fetch("steps")

  @img_url = @parsed_recipe.fetch("image")
  
  erb(:get_recipe)
end
