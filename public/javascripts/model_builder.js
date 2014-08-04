//--------- Listable item config ----------
textfield = {
   formid: 'textfield_form',
   prefix: 'tx',
   type: 'text',
   variables: ['label_name','max_length','mandatory','static_label','inline','options'],
   display: function(vars) {
      return '<label>' + vars.label_name + '</label>\
      <input type="text" />';
   },
   url: '/models/textfield'
};
emailfield = {
   formid: 'email_form',
   prefix: 'em',
   type: 'email',
   variables: ['label_name','max_length','mandatory','static_label','inline','options'],
   display: function(vars) {
      return '<label>' + vars.label_name + '</label>\
      <input type="text" />';
   },
   url: '/models/emailfield'
};
textareafield = {
   formid: 'textarea_form',
   prefix: 'ta',
   type: 'textarea',
   variables: ['label_name','max_length','mandatory','static_label','inline','options'],
   display: function(vars) {
      return '<label>'+ vars.label_name +'</label>\
               <textarea></textarea>';
   },
   url: '/models/textareafield'
};
tinymcefield = {
   formid: 'tinymce_form',
   prefix: 'tm',
   type: 'tinymce',
   variables: ['label_name','max_length','mandatory','static_label','inline','options'],
   display: function(vars) {
      return '<label>'+ vars.label_name +' (Tiny MCE)</label>\
               <textarea></textarea>';
   },
   url: '/models/tinymce'
};
checkboxfield = {
   formid: 'checkbox_form',
   prefix: 'cb',
   type: 'checkbox',
   variables: ['label_name','max_length','mandatory','static_label','inline','options'],
   display: function(vars) {
      return '<input type="checkbox" />\
               <label class="checkbox_label">'+vars.label_name+'</label>';
   },
   url: '/models/checkboxfield'
};
radiofield = {
   formid: 'radio_form',
   prefix: 'ra',
   type: 'radio',
   variables: ['label_name','max_length','mandatory','static_label','inline','options'],
   display: function(vars) {
               var options = "option1\noption2\noption3".split("\n");
               var options_html = '';
               for ( i in options ) {
                  options_html += '\
                     <input type="radio" value="'+options[i]+'" />\
                     <span>'+options[i]+'</span>\
                  ';
               }
      return '<label>'+vars.label_name+'</label>\
               '+options_html;
   },
   url: '/models/radiofield'
};
selectfield = {
   formid: 'select_form',
   prefix: 'sl',
   type: 'select',
   variables: ['label_name','max_length','mandatory','static_label','inline','options'],
   display: function(vars) {
               var options = "option1\noption2\noption3".split("\n");
               var options_html = '';
               for ( i in options ) {
                  options_html += '\
                     <option value="'+options[i]+'">'+options[i]+'</option>\
                  ';
               }
      return '<label>'+vars.label_name+'</label>\
      <select>\
               '+options_html+'\
               </select>';
   },
   url: '/models/selectfield'
};
filefield = {
   formid: 'file_form',
   prefix: 'fl',
   type: 'file',
   variables: ['label_name','max_length','mandatory','static_label','inline','options'],
   display: function(vars) {
      return '<label>'+vars.label_name+'</label>\
               <input type="file" />';
   },
   url: '/models/filefield'
};
datepicker = {
   formid: 'datepicker_form',
   prefix: 'dp',
   type: 'datepicker',
   variables: ['label_name','max_length','mandatory','static_label','inline','options'],
   display: function(vars) {
      return '<label>' + vars.label_name + '</label>\
      <input type="text" class="date_picker" />';
   },
   afterSave: function(itemType) {
      $('.date_picker').datepicker( { dateFormat: "dd-mm-yy" } );
   },
   url: '/models/datepicker'
};
sessionvariable = {
   formid: 'session_variable_form',
   prefix: 'sv',
   type: 'session_variable',
   variables: ['label_name','max_length','mandatory','static_label','inline','options'],
   display: function(vars) {
      return '<label>' + vars.label_name + ' (Session variable)</label>';
   },
   url: '/models/session_variable'
};
lineoftext = {
   formid: 'lineoftext_form',
   prefix: 'lt',
   type: 'line_of_text',
   variables: ['label_name','max_length','mandatory','static_label','inline','options'],
   display: function(vars) {
      return '<label>' + vars.label_name + '</label>';
   },
   url: '/models/line_of_text'
};
var element_types = [textfield,emailfield,textareafield,tinymcefield,checkboxfield,radiofield,selectfield,filefield,datepicker,lineoftext,sessionvariable];

function normalize_field_labels(element) {   
   if(element){
      if ($('#'+$(element).attr('id')+' input[name="rm"]').val()) {
         var prefix = $('#'+$(element).attr('id')+' input[name="rm"]').val().replace(/v_/, '')+"_";
      } else {
         var prefix = '';
      }
      $('#'+$(element).attr('id')+' label').each(function(){   
         if ($(this).attr('lab')) {
            var lab = $(this).attr('lab').replace(prefix, '');
         } else {
            var lab = $(this).attr('for').replace(prefix, '');
         }
         //$($("input[id='"+lab+"']")).css('background-color','#fff');
         lab = lab.slice(0,1).toUpperCase() + lab.slice(1);
         lab = lab.replace(/_/g, " ");
         $(this).removeClass('error_label');   
         $(this).text(lab);
      });
   } else {
      $('label').each(function(){   
         if ($(this).attr('lab')) {
            var lab = $(this).attr('lab');
         } else {
            var lab = $(this).attr('for');
         }
         //$($("input[id='"+lab+"']")).css('background-color','#fff');
         lab = lab.slice(0,1).toUpperCase() + lab.slice(1);
         lab = lab.replace(/_/g, " ");
         $(this).removeClass('error_label');   
         $(this).text(lab);
      });
   }
}
$(function() {
   // Kill caching
   $.ajaxSetup({ cache: false });

   var listable_element = $('.attributes.listable');

   // ========== Form Submission Functions ==========
   function listable_form_setup(options_arg) {
      // Default options
      var options = {
         overlay: false,
         form_id: '',
         url: '',
         msgdiv: 'msgs_listables',
         prefix: '',
         element: null,
         beforeSave: null,
         afterSave: null
      };
      // Extend default optiosn with options passed as arguements
      options = $.extend({},options,options_arg);

      $('#'+options.form_id).ajaxForm({
         url: options.url,
         type: "POST",
         dataType: 'json',
         beforeSubmit: function() {
            normalize_field_labels($('#'+options.form_id));
         },
         success: function(data) {
            parse_results({
               result: data,
               overlay: options.overlay,
               form: options.form_id,
               msgdiv: options.msgdiv,
               prefix: options.prefix,
               not_reset_form: true,
               leave_open: true,
               success: function(data) {
                  listable_element.listable('save', options.element, {
                     beforeSave: options.beforeSave,
                     afterSave: options.afterSave
                  });
                  $('#'+options.form_id).resetForm();
                  $.fancybox.close();
                  $('.listable-controls').hide('fast');
                  no_focus = true;
               }
            });
         }
      });
      
   };

   $.each(element_types, function(i, el) {
      if (!this.url) {
         this.url = '/models';
      }
      
      listable_form_setup({
         form_id: this.formid,
         prefix: this.prefix,
         url: this.url,
         element: this,
         beforeSave: this.beforeSave,
         afterSave: this.afterSave
      });
   });

   // Form helpers
   $('#open_extras').toggle(function() {
         $('#extra_stuff').css('display','block');
         $('.arrows').replaceWith('<span class="arrows">&#9660;</span> ')
      }, function() {
         $('#extra_stuff').css('display','none');
         $('.arrows').replaceWith('<span class="arrows">&#9654;</span> ')
      });
   $('#readable_name').blur(function(){
      var regex = / /g;
      var name = $('#readable_name').val().replace(regex,'_');
      $('#table_name').val(name.toLowerCase());
   });

   // Invoking as listable
   listable_element.listable({
      variable_vault: $('#variable_vault'),
      delete_confirmation: true,
      keyboard_shortcuts: true,
      types: element_types
   });
});
