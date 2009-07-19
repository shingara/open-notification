class Exceptions < Merb::Controller
  
  # handle NotFound exceptions (404)
  def not_found
    render :format => :html, :layout => false
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    render :format => :html, :layout => false
  end

  def resource_not_found
    render :not_found, :format => :html, :layout => false, :status => 404
  end

end
