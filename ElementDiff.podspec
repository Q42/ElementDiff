Pod::Spec.new do |s|
  s.name              = "ElementDiff"
  s.version           = "0.6.0"
  s.summary           = "Animate tableview for view model arrays"

  s.description       = <<-DESC
  Animate UITableView s and UICollectionViews based on changes in view model arrays.
                        DESC

  s.license           = 'MIT'
  s.author            = { "Tom Lokhorst" => "tom@lokhorst.eu" }
  s.social_media_url  = "https://twitter.com/tomlokhorst"
  s.homepage          = "https://github.com/Q42/ElementDiff"

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.swift_version     = '4.0'

  s.source            = { :git => "https://github.com/Q42/ElementDiff.git", :tag => s.version.to_s }
  s.requires_arc      = true

  s.source_files      = 'Sources/**/*'

end
