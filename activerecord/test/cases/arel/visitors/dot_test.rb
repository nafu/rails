# frozen_string_literal: true

require_relative "../helper"
require "active_model/attribute"

module Arel
  module Visitors
    class TestDot < Arel::Test
      def setup
        @visitor = Visitors::Dot.new
      end

      # functions
      [
        Nodes::Sum,
        Nodes::Exists,
        Nodes::Max,
        Nodes::Min,
        Nodes::Avg,
      ].each do |klass|
        define_method("test_#{klass.name.gsub('::', '_')}") do
          op = klass.new(:a, "z")
          @visitor.accept op, Collectors::PlainString.new
        end
      end

      def test_named_function
        func = Nodes::NamedFunction.new "omg", "omg"
        @visitor.accept func, Collectors::PlainString.new
      end

      # unary ops
      [
        Arel::Nodes::Not,
        Arel::Nodes::Group,
        Arel::Nodes::On,
        Arel::Nodes::Grouping,
        Arel::Nodes::Offset,
        Arel::Nodes::Ordering,
        Arel::Nodes::UnqualifiedColumn,
        Arel::Nodes::ValuesList,
        Arel::Nodes::Limit,
      ].each do |klass|
        define_method("test_#{klass.name.gsub('::', '_')}") do
          op = klass.new(:a)
          @visitor.accept op, Collectors::PlainString.new
        end
      end

      # binary ops
      [
        Arel::Nodes::Assignment,
        Arel::Nodes::Between,
        Arel::Nodes::DoesNotMatch,
        Arel::Nodes::Equality,
        Arel::Nodes::GreaterThan,
        Arel::Nodes::GreaterThanOrEqual,
        Arel::Nodes::In,
        Arel::Nodes::LessThan,
        Arel::Nodes::LessThanOrEqual,
        Arel::Nodes::Matches,
        Arel::Nodes::NotEqual,
        Arel::Nodes::NotIn,
        Arel::Nodes::Or,
        Arel::Nodes::TableAlias,
        Arel::Nodes::As,
        Arel::Nodes::DeleteStatement,
        Arel::Nodes::JoinSource,
        Arel::Nodes::Casted,
      ].each do |klass|
        define_method("test_#{klass.name.gsub('::', '_')}") do
          binary = klass.new(:a, :b)
          @visitor.accept binary, Collectors::PlainString.new
        end
      end

      def test_Arel_Nodes_BindParam
        node = Arel::Nodes::BindParam.new(1)
        collector = Collectors::PlainString.new
        assert_match '[label="<f0>Arel::Nodes::BindParam"]', @visitor.accept(node, collector).value
      end

      def test_ActiveModel_Attribute
        node = ActiveModel::Attribute.with_cast_value("LIMIT", 1, nil)
        collector = Collectors::PlainString.new
        assert_match '[label="<f0>ActiveModel::Attribute::WithCastValue"]', @visitor.accept(node, collector).value
      end
    end
  end
end
