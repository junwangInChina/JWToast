
Pod::Spec.new do |s|

  s.name         = "JWToast"
  s.version      = "0.0.1"
  s.summary      = "仿Android的Toast控件."

  #主页
  s.homepage     = "https://github.com/junwangInChina/JWToast"
  #证书申明
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  #作者
  s.author             = { "wangjun" => "github_work@163.com" }
  #支持版本
  s.platform     = :ios, "7.0"
  #项目地址，版本
  s.source       = { :git => "https://github.com/junwangInChina/JWToast.git", :tag => "0.0.1" }

  #库文件路径
  s.source_files  = "JWToastDemo/JWToastDemo/JWToast/**/*.{h,m}"
  #是否ARC
  s.requires_arc = true

end
