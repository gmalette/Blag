class Manifest
  def initialize &block
    @path = Blag.get(:manifest_path)
    if block_given?
      @infos = {:articles => {}}
      self.instance_eval(&block)
      persist!
    else
      @infos = YAML.parse(File.read(@path)).transform
    end
  end
  
  def add_article article
    metas = YAML.parse(File.read(article).split("\n\n")[0]).transform
    @infos[:articles][slug(metas['title'])] = article
  end
  
  def slug title
    tmp = title.to_url
    while @infos[:articles].any?{|slug, title| slug == tmp}
      tmp = tmp.match(/--\d+/) ? tmp.next : tmp << "--1"
    end
    tmp
  end
  
  def persist!
    FileUtils.mkdir_p File.dirname(@path)
    File.open @path, "w" do |file|
      file.puts @infos.to_yaml
    end
  end

  
end