Pod::Spec.new do |s|
         s.name         = "TestLibrary_v1"
         s.version      = "0.0.1"
         s.summary      = "W"
         s.homepage     = 'http://weibo.com/xuym1992/'
         s.license      = 'MIT'
         s.author       = { 'wangchunxiang' => 'http://www.jd.com' }
         s.platform     = :ios, "7.0"
         s.source       = { :git => "JRLibrary/TestLibrary" }
         s.source_files  = '**/*.{h,m,podspec}'
         s.library = 'TestLibrary'
         s.preserve_paths = 'TestLibrary/libTestLibrary.a'
         s.xcconfig = {'LIBRARY_SEARCH_PATHS' => '$(PROJECT_DIR)/JRLibrary/TestLibrary'}
         s.ios.vendored_libraries = "libTestLibrary.a"
        end
