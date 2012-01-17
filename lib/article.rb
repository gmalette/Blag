class Article

  def self::manifest!
    Dir.glob("#{articles}/*.txt").each do |path|
      @@articles << Article.new(path)
    end
  end
  
  def self::find options
    options = { :date => {}, :filing => :archives }.merge(options)
    
    @@articles.select do |a|
      date = options[:date]
      [:year, :month, :day].all?{ |s| date[s].nil? || date[s].to_i == a.date.send(s) } &&
      options[:filing].to_s == a.filing.to_s
    end
  end
  
  def initialize path
    @path = path
    @meta = YAML.load(part :meta)
    @meta['ctime'] = File.ctime @path
    @meta['date'] = Date.parse(@meta['date'] || @meta['ctime'].strftime('%Y/%m/%d'))
    @meta = { :filing => :archives }.merge @meta
    @meta.each do |k, v|
      self.class.send(:define_method, k, lambda { v })
    end
  end
  
  def part which
    (@parts ||= File.new(@path).read.split(/\n\n/, 2))[which == :meta ? 0 : 1].strip
  end
  
  def render
    Markdown.new(part :body).to_html
  end
  
  def <=> other
    if other.is_a Article
      ((date <=> other.date) != 0) ? date <=> other.date : ctime <=> other.ctime
    else
      -1
    end
  end
end