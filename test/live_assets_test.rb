require 'test_helper'
require 'fileutils'

class LiveAssetsTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, LiveAssets
  end

  setup do
    FileUtils.mkdir_p "test/tmp"
  end

  teardown do
    FileUtils.rm_rf "test/tmp"
  end

  test "can subscribe to listener events" do
    l = LiveAssets.start_listener(:reload, ["test/tmp"])
    subscriber = []
    LiveAssets.subscribe(subscriber)

    begin
      while subscriber.empty?
        File.write("test/tmp/sample", SecureRandom.hex(20))
      end

      assert_includes subscriber, :reload
    ensure
      LiveAssets.unsubscribe(subscriber)
      l.kill
    end
  end

  test "can subscribe to existing reloadCSS events" do
    subscriber = []
    LiveAssets.subscribe(subscriber)

    begin
      while subscriber.empty?
        FileUtils.touch("test/dummy/app/assets/stylesheets/application.css")
      end

      assert_includes subscriber, :reloadCSS
    ensure
      LiveAssets.unsubscribe(subscriber)
    end
  end

  test "receives timer notifications" do
    l = LiveAssets.start_timer(:ping, 0.5)

    subscriber = []
    LiveAssets.subscribe(subscriber)

    begin
      true while subscriber.empty?
      assert_includes subscriber, :ping
    ensure
      LiveAssets.unsubscribe(subscriber)
    end
  end
end
