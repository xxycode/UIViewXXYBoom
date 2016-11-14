Pod::Spec.new do |s|
s.name = 'UIViewXXYBoom'
s.version = '1.0'
s.license = 'MIT'
s.summary = 'An Amazing Animation Effect.'
s.homepage = 'https://github.com/xxycode/UIViewXXYBoom'
s.authors = { '肖学源' => 'xxycode@gmail.com' }
s.source = { :git => 'https://github.com/xxycode/UIViewXXYBoom.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '6.0'
s.source_files = 'XXYBoom/UIViewXXYBoom.swift'
end