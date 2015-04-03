get '/' do
  if session[:id]
    @todos= Todo.all.order(:id)
    erb :index
  else
    erb :login
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.new(name: params[:name], email: params[:email], password: params[:password])
  if user.save
    session[:id] = user.id
    redirect "/"
  else
    @errors = user.errors.full_messages
  end
end

get '/login' do
  erb :login
end

post '/login' do
  @user = User.find_by(email: params[:email])

  if @user && @user.authenticate(params[:password])
    session[:id] = @user.id
    redirect "/"
  else
    session[:errors]
    redirect "/login"
  end
end

get '/logout' do
  session[:id] = nil
  redirect "/"
end


post '/todos/new' do
  @todo = Todo.create(todo_content: params[:todo_content], category: params[:category])
  if @todo.save
    redirect '/'
  else
    status 400
  end
end

put '/todos/:id/complete' do
  todo = Todo.find(params[:id])
  todo.completed = !todo.completed
  todo.save
  coin_count(session[:id])

  content_type :json
  {id: todo.id, completed: todo.completed}.to_json
end

get '/todos/:id/delete' do
  todo = Todo.find(params[:id])
  todo.destroy
  redirect '/'
end


get '/shop' do
  @current_user = User.find(session[:id])
    # p response = HTTParty.get("http://free.apisigning.com/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=#{ENV['amazon_access_key_id']}&Operation=ItemSearch&Keywords=#{keyword}&ResponseGroup=Images,ItemAttributes&SearchIndex=All&MinimumPrice=4000&MaximumPrice=5000&Timestamp=#{Time.now.utc.iso8601}")
  #&Signature=[Request Signature]
  #
    @items = session[:searched_items]

  erb :shop
end


post '/shop' do
  request = Vacuum.new
  request.configure(
    aws_access_key_id: ENV['amazon_access_key_id'],
    aws_secret_access_key: ENV['amazon_secret_access_key'],
    associate_tag: 'tag'
)

  if (params[:keyword])
    keyword = params[:keyword]
    response = request.item_search(
      query: {
        'Keywords' => keyword,
        'SearchIndex' => 'All'
      }
      )
    begin

      session[:searched_items] = response.parsed_response["ItemSearchResponse"]["Items"]["Item"]
      .select do |item|
        item and item.include?("MediumImage") and item["ItemAttributes"]["ListPrice"]
      end
      .map do |item|
        {
          url: item["DetailPageURL"],
          image: item["MediumImage"]["URL"],
          title: item["ItemAttributes"]["Title"],
          price: item["ItemAttributes"]["ListPrice"]
        }
      end
    rescue
      @items = []
      @error = "No items found!"
    end
    byebug
  # else
  #   @items = []
  end
  redirect '/shop'
end

# post '/users/:id' do
#   tweet = Tweet.create(content: params[:content])
#   tweet.user = User.find(params[:id])
#   tweet.save

#   redirect "/users/#{params[:id]}"
# end

# get '/todo/:id' do
#   @post = Post.find(params[:id])
#   erb :post
# end


# delete '/tasks/:id/' do
#   # write logic for deleting posts here.
#   post = Post.find(params[:id])
#   post.destroy
#   content_type :json
#   {post_id: post.id}.to_json
# end

# post '/' do
#   post = Post.create( title: params[:title],
#                username: Faker::Internet.user_name,
#                comment_count: rand(1000) )

#   if (post.save)
#     create_form(post)
#   else
#     status 400
#   end
# end

# get '/sort' do
#   if params[:key] == "new"
#     sorted_posts = Post.all.sort {|a,b| b.created_at <=> a.created_at}
#   elsif params[:key] == "comments"
#     sorted_posts = Post.all.sort {|a,b| b.comment_count <=> a.comment_count}
#   elsif params[:key] == "popular"
#      sorted_posts = Post.all.sort {|a,b| b.points <=> a.points}
#   end
#   content_type :json
#   sorted_posts.map do |post|
#     create_form(post)
#   end.to_json
# end

