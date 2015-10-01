CKEDITOR.editorConfig = function (config) {
  // ... other configuration ...

  config.toolbar_mini = [
    ["Bold",  "Italic",  "Underline",  "Strike",  "-",  "Subscript",  "Superscript"],
  ];
  config.toolbar = "sample";
  config.filebrowserBrowseUrl = '/elfinder_manager';

  // ... rest of the original config.js  ...
}
