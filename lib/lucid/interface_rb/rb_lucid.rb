module Lucid
  module InterfaceRb
    # It is necessary for the RbLucid module to be mixed in to the top level
    # object. This is what allows TDL test definitions and hooks to be
    # resolved as valid methods.
    module RbLucid
      class << self
        attr_writer :rb_language

        def alias_adverb(adverb)
          alias_method adverb, :register_rb_step_definition
        end

        def build_rb_world_factory(domain_modules, proc)
          @rb_language.build_rb_world_factory(domain_modules, proc)
        end

        def register_rb_hook(phase, tag_names, proc)
          @rb_language.register_rb_hook(phase, tag_names, proc)
        end

        def register_rb_transform(regexp, proc)
          @rb_language.register_rb_transform(regexp, proc)
        end

        def register_rb_step_definition(regexp, proc_or_sym, options = {})
          @rb_language.register_rb_step_definition(regexp, proc_or_sym, options)
        end
      end

      # Registers any number of +domain_modules+ (Ruby Modules) and/or a Proc.
      # The +proc+ will be executed once before each scenario to create an
      # Object that the scenario's steps will run within. Any +domain_modules+
      # will be mixed into this Object (via Object#extend).
      #
      # This method is typically called from one or more Ruby scripts under
      # <tt>features/support</tt>. You can call this method as many times as you
      # like (to register more modules), but if you try to register more than
      # one Proc you will get an error.
      #
      # Lucid will not yield anything to the +proc+. Examples:
      #
      #    Domain do
      #      MyClass.new
      #    end
      #
      #    Domain(MyModule)
      #
      def Domain(*domain_modules, &proc)
        RbLucid.build_rb_world_factory(domain_modules, proc)
      end

      # Registers a proc that will run before each Scenario. You can register as many
      # as you want (typically from ruby scripts under <tt>support/hooks.rb</tt>).
      def Before(*tag_expressions, &proc)
        RbLucid.register_rb_hook('before', tag_expressions, proc)
      end

      # Registers a proc that will run after each Scenario. You can register as many
      # as you want (typically from ruby scripts under <tt>support/hooks.rb</tt>).
      def After(*tag_expressions, &proc)
        RbLucid.register_rb_hook('after', tag_expressions, proc)
      end

      # Registers a proc that will be wrapped around each scenario. The proc
      # should accept two arguments: two arguments: the scenario and a "block"
      # argument (but passed as a regular argument, since blocks cannot accept
      # blocks in 1.8), on which it should call the .call method. You can register
      # as many  as you want (typically from ruby scripts under <tt>support/hooks.rb</tt>).
      def Around(*tag_expressions, &proc)
        RbLucid.register_rb_hook('around', tag_expressions, proc)
      end

      # Registers a proc that will run after each Step. You can register as
      # as you want (typically from ruby scripts under <tt>support/hooks.rb</tt>).
      def AfterStep(*tag_expressions, &proc)
        RbLucid.register_rb_hook('after_step', tag_expressions, proc)
      end

      # Registers a proc that will be called with a step definition argument if it
      # matches the pattern passed as the first argument to Transform. Alternatively, if
      # the pattern contains captures then they will be yielded as arguments to the
      # provided proc. The return value of the proc is consequently yielded to the
      # step definition.
      def Transform(regexp, &proc)
        RbLucid.register_rb_transform(regexp, proc)
      end

      # Registers a proc that will run after Lucid is configured. You can register as
      # as you want (typically from ruby scripts under <tt>support/hooks.rb</tt>).
      # TODO: Deprecate this
      def AfterConfiguration(&proc)
        RbLucid.register_rb_hook('after_configuration', [], proc)
      end

      # Registers a new Ruby StepDefinition. This method is aliased
      # to <tt>Given</tt>, <tt>When</tt> and <tt>Then</tt>, and
      # also to the i18n translations whenever a feature of a
      # new language is loaded.
      #
      # If provided, the +symbol+ is sent to the <tt>Domain</tt> object
      # as defined by #Domain. A new <tt>Domain</tt> object is created
      # for each scenario and is shared across step definitions within
      # that scenario. If the +options+ hash contains an <tt>:on</tt>
      # key, the value for this is assumed to be a proc. This proc
      # will be executed in the context of the <tt>Domain</tt> object
      # and then sent the +symbol+.
      #
      # If no +symbol+ if provided then the +&proc+ gets executed in
      # the context of the <tt>Domain</tt> object.
      def register_rb_step_definition(regexp, symbol = nil, options = {}, &proc)
        proc_or_sym = symbol || proc
        RbLucid.register_rb_step_definition(regexp, proc_or_sym, options)
      end
    end
  end
end

extend(Lucid::InterfaceRb::RbLucid)
