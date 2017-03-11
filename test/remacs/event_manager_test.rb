require 'test_helper'

class EventManagerTest < Minitest::Test # :nodoc:
  def test_can_bind_events
    event_manager = Remacs::EventManager.new
    assert event_manager.respond_to?(:bind)
  end

  def test_can_unbind_events
    event_manager = Remacs::EventManager.new
    assert event_manager.respond_to?(:unbind)
  end

  def test_can_trigger_events
    event_manager = Remacs::EventManager.new
    assert event_manager.respond_to?(:trigger)
  end

  def stop_after_me(_event)
    false
  end

  def continue_after_me(_event)
    true
  end

  def test_return_false_when_action_returns_false
    event_manager = Remacs::EventManager.new
    event_manager.bind 't', self, :stop_after_me
    event_manager_binding = event_manager.trigger 't'

    refute event_manager_binding
  end

  def test_return_true_when_action_returns_true
    event_manager = Remacs::EventManager.new
    event_manager.bind 't', self, :continue_after_me
    event_manager_binding = event_manager.trigger 't'

    assert event_manager_binding
  end

  def test_separate_binding_stacks
    event_manager = Remacs::EventManager.new
    event_manager.bind 'event', self, :stop_after_me
    doesnot_stop_execution = event_manager.trigger 'another_event'

    assert doesnot_stop_execution
  end

  def test_trigger_all_stack
    event_manager = Remacs::EventManager.new
    event_manager.bind_all self, :stop_after_me
    event_manager_binding = event_manager.trigger 't'

    refute event_manager_binding
  end
end
