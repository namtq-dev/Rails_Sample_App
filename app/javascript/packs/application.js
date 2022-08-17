import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
import 'bootstrap'

require('jquery')

Rails.start()
Turbolinks.start()
ActiveStorage.start()
