require "test_helper"
require "thread"

class LiveAssets::SubscriberTest < ActiveSupport::TestCase
  test "yields server sent events from the queue" do
    queue = Queue.new
    queue << :reloadCSS
    queue << :ping
    queue << nil

    subscriber = LiveAssets::SSESubscriber.new(queue)
    stream = []
    subscriber.each do |msg|
      stream << msg
    end

    assert_equal 2, stream.length
    assert_includes stream, "event: reloadCSS\ndata: {}\n\n"
    assert_includes stream, "event: ping\ndata: {}\n\n"
  end
end
