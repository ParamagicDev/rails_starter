module ShoelaceHelper
  # Returns a +sl-+ prefixed element.
  # @param {#to_s} name - The name of the element without "sl-"
  # @return {String}
  # @example
  #   <%= sl_tag "input", name: "user[name]", id: "user_name" %>
  def sl_tag(name, **options, &block)
    tag.public_send("sl_#{name.to_s.underscore}".to_sym, **options, &block)
  end

  def sl_submit(name = nil, **options, &block)
    options[:name] = options.fetch(:name, "commit")
    sl_tag("button", type: "submit", **options, &block)
  end

  def sl_input(**options, &block)
    if options[:error]
      error = render(FormErrorComponent.new(slot: "help-text", error: options[:error]))

      block_with_error = proc {
        concat block&.call
        concat error
      }

      return sl_tag("input", **options, &block_with_error)
    end

    sl_tag("input", **options, &block)
  end

  def sl_email(**options, &block)
    options[:autofocus] = options.fetch(:autofocus, true)
    options[:autocomplete] = options.fetch(:autocomplete, "email")

    sl_input(type: "email", **options, &block)
  end

  def sl_password(**options, &block)
    sl_input(type: "password", **options, &block)
  end

  # @see https://github.com/rails/rails/blob/main/actionview/lib/action_view/helpers/url_helper.rb#L209
  def app_link_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options ||= {}

    html_options = convert_options_to_data_attributes(options, html_options)

    url = url_target(name, options)
    html_options["href"] ||= url

    # Changed from "a" to "app-link"
    content_tag("app-link", name || url, html_options, &block)
  end

  # @see https://github.com/rails/rails/blob/main/actionview/lib/action_view/helpers/url_helper.rb#L460
  def app_link_to_if(condition, name, options = {}, html_options = {}, &block)
    if condition
      app_link_to(name, options, html_options) # Changed from #link_to to #app_link_to
    else
      if block_given?
        block.arity <= 1 ? capture(name, &block) : capture(name, options, html_options, &block)
      else
        ERB::Util.html_escape(name)
      end
    end
  end

  # @see https://github.com/rails/rails/blob/main/actionview/lib/action_view/helpers/url_helper.rb#L437
  def app_link_to_unless(condition, name, options = {}, html_options = {}, &block)
    app_link_to_if !condition, name, options, html_options, &block
  end

  # https://github.com/rails/rails/tree/main/actionview/lib/action_view/helpers/url_helper.rb#L734-L740
  def url_target(name, options)
    if name.respond_to?(:model_name) && options.is_a?(Hash) && options.empty?
      url_for(name)
    else
      url_for(options)
    end
  end
end
