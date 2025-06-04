require_relative 'common'

module ObjectView
  module Rspec
    module Views
      # puts "loaded #{self}"

      include Common

      def setup_view
        klass_setup
        if @klass
          assign(:klass, @klass)
          assign(:klass_str, @klass_str)
          assign(:klass_sym, @klass_sym)
          assign(:klass_p_str, @klass_p_str)
        end
        assign(@klass_sym, object) if @klass_sym
        assign(:object, object)
        assign(:objects, objects)
      end

      def views_edit **options
        render
        pp response if options[:pp]
        name = object.class_name_u
        attrs = object.get_form options[:form] || "form"
        assert_select "form[action=?][method=?]",
                      polymorphic_path(object), "post" do
          attrs.keys.each do |k|
            # ignoring associaitons
            next unless object.attribute_names.member?(k)
            assert_select "label[for=?]", k.to_s
            #TODO: assert_select "name[for=?]", "#{name}[#{k}]"
            #TODO: assert_select "input[name=?]", "story_task[title]"
          end
        end
      end

      #########################################################

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def viewsSetup **options
          commonSetup **options
          before :all do
            setup_object
            setup_objects
            setup_user
          end
          before :each do
            setup_view
          end
          after :all do
            cleanup_objects
          end
        end

        def views_edit **options
          it "renders form with attributes" do
            views_edit **options
          end
        end

        def views_index **options
          it "renders list of model objects" do
            render
            pp response if options[:pp]
            name = objects.first.class_name_u

            assert_select "table" do
              assert_select "tr", 1 + objects.size
            end
          end
        end

        def views_show **options
          it "renders attributes" do
            render
            pp response if options[:pp]
            name = object.class_name_u
            attrs = object.get_template
            assert_select "div[class=?]", "ov-display" do
              attrs.keys.each do |k|
                next unless object.attribute_names.member?(k)
                assert_select "label[for=?]", k.to_s
              end
            end
          end
        end

        def views_new **options
          it "renders new form" do
            render
            pp response if options[:pp]
            name = object.class_name_u
            attrs = object.get_form
            assert_select "form[action=?][method=?]",
                          polymorphic_path(object), "post" do
              attrs.keys.each do |k|
                next unless object.attribute_names.member?(k)
                assert_select "label[for=?]", k.to_s
              end
            end
          end
        end

      end
    end
  end
end
