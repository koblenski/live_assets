module LiveAssets
  class Engine < ::Rails::Engine
    initializer "live_assets.start_listener" do |app|
      paths = app.paths["app/assets"].existent +
              app.paths["lib/assets"].existent +
              app.paths["vendor/assets"].existent
      paths = paths.select { |p| p =~ /stylesheets/ }

      if app.config.assets.compile
        LiveAssets.start_listener :reloadCSS, paths
        LiveAssets.start_timer :ping, 10
      end
  
      config.eager_load_namespaces << LiveAssets
    end
  end
end
