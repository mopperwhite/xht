UrlPattern = Struct.new :host, :pattern
MetaInfo   = 
Struct.new(
  :title,
  :title_lang, 
  :author,
  :group,
  :characters,
  :language, 
  :category, 
  :tags, 
  :description, 
  :source,
  :uid,
  :cover
) do
  def initialize(*args)
    super(*args)
    @title_lang={}
    @tags = []
    @characters = []
  end
  
  [:title_lang, :characters, :tags].each do |x|
    define_method :"#{x}=" do |_|
      raise NoMethodError.new "undefined method `#{x}='"
    end
  end
end