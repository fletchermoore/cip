const defaultToolbar =[
  [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
  ['bold', 'italic', 'underline'],
  [{ 'color': [] }, { 'background': [] }],
  [{ 'list': 'ordered'}, { 'list': 'bullet' }]
]

const bindings = {
  // This will overwrite the default binding also named 'tab'
  tab: {
    key: 9,
    handler: function() {
      // do nothing; eliminate default tab feature
      return true;
    }
  },
  "indent": {
    key: "tab",
    format: ["list"],
    handler: function(range, context) {
      return false; // disable list indenting
    }
  }
}

export const defaultQuillModules = {
  clipboard: {
    matchVisual: false // prevents quill from injecting extra spaces before UL & OL
  },
  toolbar: defaultToolbar,
  keyboard: {
    bindings: bindings
  }
}
