import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
import 'bootstrap'

require('jquery')

Rails.start()
Turbolinks.start()
ActiveStorage.start()

$('#micropost_image').bind('change', function() {
  var size_in_megabytes = this.files[0].size/1024/1024;
  if (size_in_megabytes > 5) {
    alert(I18n.t('.large_img_error'));
  }
});
