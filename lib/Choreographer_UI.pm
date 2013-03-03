package Choreographer_UI;
use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Stagehand::Stagehand;
use Data::Dumper;
use Validate;

use lib '../Choreographer/lib/';

use Dancer::Choreographer;

# Load everything up
setting_the_stage();

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

# ===== Models =====
prefix '/models' => sub {

   # ===== CRUD =====

   # ----- List -----
   get '/' => sub {
       template 'index';
   };

   # ----- Create / Update -----
   any ['post', 'put'] => '/?' => sub {
      set serializer => 'JSON';
      my %params = params;
      my $success;

      my $msg = validate_model( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      if ( request->method() eq "POST" ) {
         #delete $params{'id'};
         #resultset('Model')->create($msg);
         $success = "Model added Successfully";
      } else {
         #resultset('Model')->find(param 'id')->update($msg);
         $success = "Model updated Successfully";
      }
      my $response;
      if ($msg->{'app_folder'}) {
         my $obj; # Obj to submit to choreographer
         my $app_path = $msg->{'app_folder'};
         delete $msg->{'app_folder'};
         my $write_file = $msg->{'write_file'};
         delete $msg->{'write_file'};
         my $app_name = $msg->{'app_name'};
         delete $msg->{'app_name'};
         push @$obj, {
                        settings => {
                           app_path => $app_path,
                           app_name => $app_name,
                           module_only => 1,
                           write_files => $write_file
                        },
                        models => [
                           $msg
                        ]
                     };
         $response = submit_json($obj);
      }
      if (ref $response eq 'HASH' and @{$response->{success}}) {
         return { success => [ { success => $response->{success} } ],
                  output  => $response->{output} };
      } else {
         return { errors => $response->{errors},
                  output  => $response->{output} };
      }
   };

   # ===== Views =====
   get '/add' => sub {
       template 'models/model_builder_form';
   };

   # ----- Field Validation -----
   post '/textfield' => sub {
      set serializer => 'JSON';
      my %params = params;

      my $msg = validate_textfield( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      return { success => [ { success => "Textfield Successfully added" } ] };
   };
   post '/emailfield' => sub {
      set serializer => 'JSON';
      my %params = params;

      my $msg = validate_emailfield( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      return { success => [ { success => "Email field Successfully added" } ] };
   };
   post '/textareafield' => sub {
      set serializer => 'JSON';
      my %params = params;

      my $msg = validate_textareafield( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      return { success => [ { success => "Text Area Successfully added" } ] };
   };
   post '/checkboxfield' => sub {
      set serializer => 'JSON';
      my %params = params;

      my $msg = validate_checkboxfield( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      return { success => [ { success => "Checkbox Successfully added" } ] };
   };
   post '/radiofield' => sub {
      set serializer => 'JSON';
      my %params = params;

      my $msg = validate_radiofield( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      return { success => [ { success => "Radio Button Successfully added" } ] };
   };
   post '/selectfield' => sub {
      set serializer => 'JSON';
      my %params = params;

      my $msg = validate_selectfield( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      return { success => [ { success => "Select Successfully added" } ] };
   };
   post '/filefield' => sub {
      set serializer => 'JSON';
      my %params = params;

      my $msg = validate_filefield( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      return { success => [ { success => "File field Successfully added" } ] };
   };
   post '/tinymce' => sub {
      set serializer => 'JSON';
      my %params = params;

      my $msg = validate_tinymce( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      return { success => [ { success => "Tiny MCE Successfully added" } ] };
   };
   post '/datepicker' => sub {
      set serializer => 'JSON';
      my %params = params;

      my $msg = validate_datepicker( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      return { success => [ { success => "Date Picker Successfully added" } ] };
   };
   post '/line_of_text' => sub {
      set serializer => 'JSON';
      my %params = params;

      my $msg = validate_line_of_text( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      return { success => [ { success => "Line of text Successfully added" } ] };
   };
   post '/session_variable' => sub {
      set serializer => 'JSON';
      my %params = params;

      my $msg = validate_session_variable( \%params );
      if ($msg->{errors}) {
         return $msg;
      }
      return { success => [ { success => "Session Variable Successfully added" } ] };
   };
};  # End Models prefix

#--- Validate Models -------------------------------------------------------------  
sub validate_model {
   my $params = shift;
	my (%sql, $error, @error_list, $stmt);

	($sql{'app_folder'}, $error) = Validate::val_text( 0, 64, $params->{'app_folder'} );
		if ( $error-> { msg } ) { push @error_list, { "app_folder" => $error->{ msg } }; }	
   my $app_name_mand = 0;
   if ($sql{'app_folder'}) {
      $app_name_mand = 1;
   }
	($sql{'app_name'}, $error) = Validate::val_text( $app_name_mand, 64, $params->{'app_name'} );
		if ( $error-> { msg } ) { push @error_list, { "app_name" => $error->{ msg } }; }	
	($sql{'readable_name'}, $error) = Validate::val_text( 1, 64, $params->{'readable_name'} );
		if ( $error-> { msg } ) { push @error_list, { "readable_name" => $error->{ msg } }; }	
	($sql{'table_name'}, $error) = Validate::val_text( 1, 64, $params->{'table_name'} );
		if ( $error-> { msg } ) { push @error_list, { "table_name" => $error->{ msg } }; }	
	$sql{'write_file'} = ($params->{'write_file'}) ? 1 : 0;
	$sql{'overlay'} = ($params->{'overlay'}) ? 1 : 0;

   my $labels = (ref $params->{'label_name[]'} eq 'ARRAY') ? $params->{'label_name[]'} : [$params->{'label_name[]'}];
   my $max_lengths = (ref $params->{'max_length[]'} eq 'ARRAY') ? $params->{'max_length[]'} : [$params->{'max_length[]'}];
   my $mandatory = (ref $params->{'mandatory[]'} eq 'ARRAY') ? $params->{'mandatory[]'} : [$params->{'mandatory[]'}];
   my $static_label = (ref $params->{'static_label[]'} eq 'ARRAY') ? $params->{'static_label[]'} : [$params->{'static_label[]'}];
   my $inline = (ref $params->{'inline[]'} eq 'ARRAY') ? $params->{'inline[]'} : [$params->{'inline[]'}];
   my $options = (ref $params->{'options[]'} eq 'ARRAY') ? $params->{'options[]'} : [$params->{'options[]'}];
   my $orders = (ref $params->{'order[]'} eq 'ARRAY') ? $params->{'order[]'} : [$params->{'order[]'}];
   my $types = (ref $params->{'type[]'} eq 'ARRAY') ? $params->{'type[]'} : [$params->{'type[]'}];

   if ( $params->{'label_name[]'} ) {
      for my $i ( 0 .. $#$labels ) {
         my %element;
         ($sql{'attributes'}->[$i]{'label'}, $error) = Validate::val_text( 1, 64, $labels->[$i] );
            if ( $error-> { msg } ) { push @error_list, { "generic" => "Label Name: ".$error->{ msg } }; }	
         ($sql{'attributes'}->[$i]{'max_length'}, $error) = Validate::val_int( 1, $max_lengths->[$i] );
            if ( $error-> { msg } ) { push @error_list, { "generic" => "Max length: ".$error->{ msg } }; }	
         $sql{'attributes'}->[$i]{'mandatory'} = ($mandatory->[$i]) ? 1 : 0;
         $sql{'attributes'}->[$i]{'static_label'} = ($static_label->[$i]) ? 1 : 0;
         $sql{'attributes'}->[$i]{'inline'} = ($inline->[$i]) ? 1 : 0;

         if ($options->[$i]) {
            @{ $sql{'attributes'}->[$i]{'options'} } = ($options->[$i] eq 'undefined') ? () : split(',', $options->[$i]);
            for my $j ( 0 .. $#{ $sql{'attributes'}->[$i]{'options'} }) {
               ($sql{'attributes'}->[$i]{'options'}->[$j], $error) = Validate::val_text( 1, 64, $sql{'attributes'}->[$i]{'options'}->[$j] );
                  if ( $error-> { msg } ) { push @error_list, { "generic" => "Option: ".$error->{ msg } }; }	
            }
         }

         ($sql{'attributes'}->[$i]{'order'}, $error) = Validate::val_number( 1, 16, $orders->[$i] );
            if ( $error-> { msg } ) { push @error_list, { "generic" => "Order: ".$error->{ msg } }; }	
         ($sql{'attributes'}->[$i]{'type'}, $error) = Validate::val_text( 1, 64, $types->[$i] );
            if ( $error-> { msg } ) { push @error_list, { "generic" => "Type: ".$error->{ msg } }; }	
      }
   }

   for my $key ( keys %sql ) {
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings in the future.
   }
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
	return \%sql;
}

#--- Validate -------------------------------------------------------------  
sub validate_textfield {
   my $params = shift;
   my (%sql, $error, @error_list);
	my $prefix = 'tx_';
	
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 64, $params->{$prefix.'label_name'} );  # check field label
      if ( $error-> { msg } ) { push @error_list, { $prefix."label_name" => $error->{ msg } }; }
   ($sql{'form_name'}, $error) = Validate::val_selected( $params->{$prefix.'max_length'} );   # check field length
      if ( $error-> { msg } ) { push @error_list, { $prefix."max_length" => $error->{ msg } }; }

   for my $key ( keys %sql ) { 
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings.
   }   
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
   return \%sql;
}

#--- Validate -------------------------------------------------------------  
sub validate_emailfield {
   my $params = shift;
   my (%sql, $error, @error_list);
	my $prefix = 'em_';
	
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 64, $params->{$prefix.'label_name'} );  # check field label
      if ( $error-> { msg } ) { push @error_list, { $prefix."label_name" => $error->{ msg } }; }
   ($sql{'form_name'}, $error) = Validate::val_selected( $params->{$prefix.'max_length'} );   # check field length
      if ( $error-> { msg } ) { push @error_list, { $prefix."max_length" => $error->{ msg } }; }

   for my $key ( keys %sql ) { 
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings.
   }   
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
   return \%sql;
}

#--- Validate -------------------------------------------------------------  
sub validate_textareafield {
   my $params = shift;
   my (%sql, $error, @error_list);
	my $prefix = 'ta_';
	
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 64, $params->{$prefix.'label_name'} );  # check field label
      if ( $error-> { msg } ) { push @error_list, { $prefix."label_name" => $error->{ msg } }; }
   ($sql{'form_name'}, $error) = Validate::val_number( 1, 8, $params->{$prefix.'max_length'} );   # check field length
      if ( $error-> { msg } ) { push @error_list, { $prefix."max_length" => $error->{ msg } }; }

   for my $key ( keys %sql ) { 
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings.
   }   
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
   return \%sql;
}

#--- Validate -------------------------------------------------------------  
sub validate_checkboxfield {
   my $params = shift;
   my (%sql, $error, @error_list);
	my $prefix = 'cb_';
	
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 64, $params->{$prefix.'label_name'} );  # check field label
      if ( $error-> { msg } ) { push @error_list, { $prefix."label_name" => $error->{ msg } }; }
   ($sql{'form_name'}, $error) = Validate::val_selected( $params->{$prefix.'max_length'} );   # check field length
      if ( $error-> { msg } ) { push @error_list, { $prefix."max_length" => $error->{ msg } }; }

   for my $key ( keys %sql ) { 
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings.
   }   
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
   return \%sql;
}

#--- Validate -------------------------------------------------------------  
sub validate_radiofield {
   my $params = shift;
   my (%sql, $error, @error_list);
	my $prefix = 'ra_';
	
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 64, $params->{$prefix.'label_name'} );  # check field label
      if ( $error-> { msg } ) { push @error_list, { $prefix."label_name" => $error->{ msg } }; }
   ($sql{'form_name'}, $error) = Validate::val_selected( $params->{$prefix.'max_length'} );   # check field length
      if ( $error-> { msg } ) { push @error_list, { $prefix."max_length" => $error->{ msg } }; }

   for my $key ( keys %sql ) { 
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings.
   }   
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
   return \%sql;
}

#--- Validate -------------------------------------------------------------  
sub validate_selectfield {
   my $params = shift;
   my (%sql, $error, @error_list);
	my $prefix = 'sl_';
	
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 64, $params->{$prefix.'label_name'} );  # check field label
      if ( $error-> { msg } ) { push @error_list, { $prefix."label_name" => $error->{ msg } }; }
   ($sql{'form_name'}, $error) = Validate::val_selected( $params->{$prefix.'max_length'} );   # check field length
      if ( $error-> { msg } ) { push @error_list, { $prefix."max_length" => $error->{ msg } }; }

   for my $key ( keys %sql ) { 
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings.
   }   
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
   return \%sql;
}

#--- Validate -------------------------------------------------------------  
sub validate_filefield {
   my $params = shift;
   my (%sql, $error, @error_list);
	my $prefix = 'fl_';
	
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 64, $params->{$prefix.'label_name'} );  # check field label
      if ( $error-> { msg } ) { push @error_list, { $prefix."label_name" => $error->{ msg } }; }
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 16, $params->{$prefix.'max_length'} );   # check field length
      if ( $error-> { msg } ) { push @error_list, { $prefix."max_length" => $error->{ msg } }; }

   for my $key ( keys %sql ) { 
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings.
   }   
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
   return \%sql;
}

#--- Validate -------------------------------------------------------------  
sub validate_tinymce {
   my $params = shift;
   my (%sql, $error, @error_list);
	my $prefix = 'tm_';
	
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 64, $params->{$prefix.'label_name'} );  # check field label
      if ( $error-> { msg } ) { push @error_list, { $prefix."label_name" => $error->{ msg } }; }
   ($sql{'form_name'}, $error) = Validate::val_number( 1, 8, $params->{$prefix.'max_length'} );   # check field length
      if ( $error-> { msg } ) { push @error_list, { $prefix."max_length" => $error->{ msg } }; }

   for my $key ( keys %sql ) { 
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings.
   }   
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
   return \%sql;
}

#--- Validate -------------------------------------------------------------  
sub validate_datepicker {
   my $params = shift;
   my (%sql, $error, @error_list);
	my $prefix = 'dp_';
	
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 64, $params->{$prefix.'label_name'} );  # check field label
      if ( $error-> { msg } ) { push @error_list, { $prefix."label_name" => $error->{ msg } }; }
   ($sql{'form_name'}, $error) = Validate::val_selected( $params->{$prefix.'max_length'} );   # check field length
      if ( $error-> { msg } ) { push @error_list, { $prefix."max_length" => $error->{ msg } }; }

   for my $key ( keys %sql ) { 
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings.
   }   
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
   return \%sql;
}

#--- Validate -------------------------------------------------------------  
sub validate_line_of_text {
   my $params = shift;
   my (%sql, $error, @error_list);
	my $prefix = 'lt_';
	
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 64, $params->{$prefix.'label_name'} );  # check field label
      if ( $error-> { msg } ) { push @error_list, { $prefix."label_name" => $error->{ msg } }; }

   for my $key ( keys %sql ) { 
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings.
   }   
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
   return \%sql;
}

#--- Validate -------------------------------------------------------------  
sub validate_session_variable {
   my $params = shift;
   my (%sql, $error, @error_list);
	my $prefix = 'sv_';
	
   ($sql{'form_name'}, $error) = Validate::val_text( 1, 64, $params->{$prefix.'label_name'} );  # check field label
      if ( $error-> { msg } ) { push @error_list, { $prefix."label_name" => $error->{ msg } }; }

   for my $key ( keys %sql ) { 
      if (not $sql{$key}) { $sql{$key} = ''; } # Set all undefined variables to avoid warnings.
   }   
   if (@error_list) {
      return { 'errors' => \@error_list };
   }
   return \%sql;
}

# ===== Helper Functions =====
sub submit_json {
   my $obj = shift;

   my $response = choreograph(to_json($obj));

   return $response;
}
true;
