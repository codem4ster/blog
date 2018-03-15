module ApplicationHelper
  # returns url path for specified or current locale
  def path(pathname, locale = I18n.locale)
    send("#{pathname}_#{locale}_path")
  end

  # returns asset path from webpack manifest file
  def webpack_asset(file_path)
    @webpack ||= Webpack.new
    '/dist/' + @webpack.asset_path(file_path)
  end

  # hangi sayfada ise o sayfanın css assetlerini basar
  def webpack_page_css_tag
    @page_asset ||= "pages/#{controller_path}/#{action_name}"
    location = webpack_asset("#{@page_asset}.css")
    %(<link href="#{location}" rel="stylesheet" />)
  end

  # hangi sayfada ise o sayfanın js assetlerini basar
  def webpack_page_js_tag
    @page_asset ||= "pages/#{controller_path}/#{action_name}.js"
    location = webpack_asset("#{@page_asset}.js")
    %(<script src="#{location}" type="text/javascript"></script>)
  end

  # eğer varsa mevcut kullanıcıyı döndürür yoksa null döndürür
  def current_user
    User.current
  end
end
