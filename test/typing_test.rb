require "test_helper"

class TypingTest < Minitest::Test
  Typing = Steep::Typing

  include TestHelper

  def test_1
    typing = Steep::Typing.new

    node = parse_ruby("123").node
    type = parse_method_type("() -> String").return_type

    typing.add_typing(node, type)

    assert_equal type, typing.type_of(node: node)
  end

  def test_new_child_with_save
    typing = Steep::Typing.new

    node = parse_ruby("123 + 456").node
    type = parse_method_type("() -> String").return_type

    typing.add_typing(node, type)

    typing.new_child do |typing_|
      assert_equal type, typing.type_of(node: node)

      typing_.add_typing(node.children[0], type)
      typing_.add_typing(node.children[1], type)

      typing_.save!
    end

    assert_equal type, typing.type_of(node: node)
    assert_equal type, typing.type_of(node: node.children[0])
    assert_equal type, typing.type_of(node: node.children[1])
  end

  def test_new_child_without_save
    typing = Steep::Typing.new

    node = parse_ruby("123 + 456").node
    type = parse_method_type("() -> String").return_type

    typing.add_typing(node, type)

    typing.new_child do |typing_|
      assert_equal type, typing.type_of(node: node)

      typing_.add_typing(node.children[0], type)
      typing_.add_typing(node.children[1], type)
    end

    assert_equal type, typing.type_of(node: node)
    assert_raises { typing.type_of(node: node.children[0]) }
    assert_raises { typing.type_of(node: node.children[1]) }
  end
end
