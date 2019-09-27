Pod::Spec.new do |s|
s.name = 'SlowKit'
s.version = '0.0.2'
s.swift_version = '5.0'
s.summary = 'Simple framework for fast iOS MVVM development'
s.homepage = 'https://github.com/volokhin/SlowKit'
s.ios.deployment_target = '8.0'
s.platform = :ios, '8.0'
s.license = {
:type => 'MIT',
:file => 'LICENSE'
}
s.author = {
'a.volokhin' => 'volokhin@bk.ru'
}
s.source = {
:git => 'https://github.com/volokhin/SlowKit.git',
:tag => "#{s.version}" }
s.framework = "UIKit"
s.source_files = 'SlowKit/SlowKit/**/*.{swift}'
end