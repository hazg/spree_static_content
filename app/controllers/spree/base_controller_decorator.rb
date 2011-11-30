module Spree
  Spree::BaseController.class_eval do
    # ProductsHelper needed for seo_url method used when generating
    # taxonomies partial in content/show.html.erb.
    # helper :products
    # Use before_filter instead of prepend_before_filter to ensure that
    # ApplicationController filters that the view may require are run.
    before_filter :render_page_if_exists

    # Checks if page is not beeing overriden by static one that starts with /
    #
    # Using request.path allows us to override dynamic pages including
    # the home page, product and taxon pages.
    def render_page_if_exists
      # If we don't know if page exists we assume it's and we query DB.
      # But we realy don't want to query DB on each page we're sure doesn't exist!
      
      # FIXME: I have no time to trace multiple slashes problem, sorry for this way. 
      # tested at spree => 0.80.0.beta, rails => 3.1.3
      path = request.path.gsub( /^\/*/, '' )


      return if Rails.cache.fetch('page_not_exist/'+path)
      


      if @page = Page.visible.find_by_slug('/' + path)

        #load @content object to load correct meta_keywords & meta_description
        @content = @page
        
        if @page.layout && !@page.layout.empty?
          render :template => 'static_content/show', :layout => @page.layout
        else
          render :template => 'static_content/show'
        end
      else
        Rails.cache.write('page_not_exist/'+path, true)
        return(nil)
      end
    end
  end
end
