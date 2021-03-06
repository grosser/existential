# Existential
The absolute minimum to handle custom fine grained authorization in Rails

### Installation
From your rails directory

    script/plugin install git://github.com/capotej/existential.git

### Example Usage
Then you can just use it like so:
    # specify the thoughtful class
    class User < ActiveRecord::Base
      is_existential
    end

    # allow_(action)_for? methods will get the user passed in
    class Post < ActiveRecord::Base
      def allows_edit_for?(user)
        # your crazy auth rules here, in the model where they belong
        self.user_id == user.id # this would also be the default, so ge more creative... 
      end
    end

    # your thoughtful class will have a can? method that works like so
    class PostController < ActionController::Base
      def edit
        @post = Post.find(params[:id)
       	if current_user.can?(:edit, @post)
          # render the view          
        else
          # raise an exception, yell at the user, whatever
        end
      end
    end

    # Or you can keep everything on the user...
    class User < ActiveRecord::Base
      is_essential

      def can?(action, object)
        case action.to_sym
        when :view
          public_viewable = [Movie, Dvd, Post]
          public_viewable.includ?(object.class)
        else
          super
        end
      end
    end

If you do not define any can_xxx_for? methods it will use the default:

 - can view, show for everyone
 - can xxx for owner or admin?`s

### Thanks

Thanks to [Nick Kallen](twitter.com/nk) for his excellent [post](http://pivotallabs.com/users/nick/blog/articles/272-access-control-permissions-in-rails) on this pattern, which inspired this plugin


### License

Copyright (c) 2010 Julio Capote, released under the MIT license
