class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def confronta(a,b)
    return a.hierarchy.split('.').map(&:to_i) <=> b.hierarchy.split('.').map(&:to_i)
  end

  def confronta_test(a,b)
  	return a.title.split(' ')[1].split('.').map(&:to_i) <=> b.title.split(' ')[1].split('.').map(&:to_i)
  end

end
