UrlPattern = Struct.new :host, :pattern, :tag
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
    if args.empty?
      self.title_lang={}
      self.tags = []
      self.characters = []
    end
    [:title_lang, :characters, :tags].each do |x|
      define_singleton_method :"#{x}=" do |_|
        raise NoMethodError.new "undefined method `#{x}='"
      end
    end
  end
end