module ContextMenuRelations
  module Hooks
    class IssueHooks < Redmine::Hook::ViewListener
      # Remove protection, all requests are Ajax requests
      def protect_against_forgery?
        false
      end

      # Work around prompt to remote needing a url for the link_to and
      # that the javascript `promptToRemote` doesn't work with
      # existing url parameters

      # Add our own promptToRemoteWithOptions Javascript
      def view_layouts_base_html_head(context={})
        return javascript_tag(<<-EOJS
  function promptToRemoteWithOptions(text, param, url) {
    value = prompt(text + ':');
    if (value) {
     if (url.indexOf('?')> 0) {
        var finalUrl = url + '&' + param + '=' + encodeURIComponent(value);
      } else {
        var finalUrl = url + '?' + param + '=' + encodeURIComponent(value);
      }

      $.getScript(finalUrl)
      return false;
    }
  }
      EOJS
                              )
      end
      
      # * :issues
      # * :can
      # * :back

      render_on :view_issues_context_menu_end, :partial=> 'context_menus/context_relation'
    end
  end
end
