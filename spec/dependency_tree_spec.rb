require 'bowler'
require_relative 'helpers/definition_helper'

module Bowler

  describe DependencyTree do

    include DefinitionHelper

    context "given a Pinfile" do
      it "should load a dependency tree" do
        tree = DependencyTree.load File.join( File.dirname(__FILE__), 'fixtures', 'dependency_tree_pinfile' )

        tree.should be_instance_of DependencyTree
        tree.dependencies_for([:foo]).should =~ [:bar, :foo, :required]
        tree.dependencies_for([:nyan]).should =~ [:bar, :foo, :nyan, :required]
      end

      it "should find the dependencies of dependencies" do
        tree = DependencyTree.load File.join( File.dirname(__FILE__), 'fixtures', 'dependency_tree_pinfile' )

        tree.dependencies_for([:cat]).should =~ [:cat, :nyan, :bar, :foo, :required]
      end

      it "should correctly handle recursive dependencies" do
        tree = DependencyTree.load File.join( File.dirname(__FILE__), 'fixtures', 'dependency_tree_pinfile' )

        tree.dependencies_for([:loop1]).should =~ [:loop1, :loop2, :required]
      end
    end

    context "given an array of one process" do
      before do
        @tree = DependencyTree.new stub_definition
      end

      it "should find the correct dependencies" do
        @tree.dependencies_for([:app1]).should =~ [:app2, :app3, :app1]
      end

      it "should give a correct process list" do
        @tree.process_list_for([:app2]).should == "app2=1,app3=1"
      end
    end

    context "given an array of multiple processes" do
      before do
        @tree = DependencyTree.new stub_definition
      end

      it "should find the correct dependencies" do
        @tree.dependencies_for([:app1, :other]).should =~ [:app2, :app3, :app1, :a, :b, :c, :other]
      end

      it "should give a correct process list" do
        @tree.process_list_for([:app2, :other]).should == "a=1,app2=1,app3=1,b=1,c=1,other=1"
      end
    end

  end

end
