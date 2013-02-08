package Choreographer_UI;
use Dancer ':syntax';
use Dancer::Plugin::DBIC;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

# ===== Models =====
prefix '/models' => sub {
   get '/' => sub {
       template 'index';
   };
   get '/add' => sub {
       template 'models/model_builder_form';
   };
   post '/add' => sub {
      set serializer => 'JSON';
      return params;
   };
   post '/accept' => sub {
      set serializer => 'JSON';
      return { success => [ { success => "I always accept" } ] };
   };
};  # End Models

true;
