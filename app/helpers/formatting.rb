helpers do
  def create_form(post)
    "<article id='#{post.id}'>
      <a href='/posts/#{post.id}/vote' class='fa fa-sort-desc vote-button'></a>
      <h2><a href='/posts/#{post.id}'>#{post.title}</a></h2>
      <p>
        <span class='points'>#{post.points}</span>
        <span class='username'>#{post.username}</span>
        <span class='timestamp'>#{post.time_since_creation}</span>
        <span class='comment-count'>#{post.comment_count}</span>
        <a class='delete' href='/posts/#{post.id}'></a>
      </p>
    </article>"
  end

#used for access purposes

  def current_user
    @current_user ||= User.find_by_id(session[:id]) if session[:id]
  end

#figure out quickly if someone is logged in or not
#will return true or false if logged in or not
  def logged_in?
    !current_user
  end

end
