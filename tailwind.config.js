const daisyui = require('daisyui')

module.exports = {
  content: [
    './app/views/**/*.{html,html.erb,erb}',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  safelist: [
    // DaisyUI form components
    'form-control', 'label', 'label-text', 'label-text-alt', 'label-text-alt-error',
    'input', 'input-bordered', 'input-error',
    'textarea', 'textarea-bordered', 'textarea-error',
    'file-input', 'file-input-bordered', 'file-input-neutral',
    'select', 'select-bordered', 'select-error',
    // DaisyUI button components
    'btn', 'btn-primary', 'btn-outline', 'btn-ghost', 'btn-sm', 'btn-circle', 'btn-lg',
    // DaisyUI layout components
    'dropdown', 'dropdown-bottom', 'dropdown-content', 'menu',
    'alert', 'alert-error', 'alert-warning', 'alert-success', 'alert-info',
    'card', 'card-body',
    'divider',
    'tabs', 'tab',
    'modal', 'modal-box',
    // DaisyUI utility classes
    'join',
    'badge',
    'skeleton',
  ],
  theme: {
    extend: {},
  },
  plugins: [daisyui],
  daisyui: {
    themes: ['light'],
  },
}
