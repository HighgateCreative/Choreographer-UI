package Choreographer_UI;
use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Validate;

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
};  # End Models

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
sub fillinform {
   my $template = shift;
   my $fifvalues = shift;
   my $html = template $template, $fifvalues;
   return HTML::FillInForm->fill( \$html, $fifvalues );
}

true;
