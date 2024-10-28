// CKEditor custom configuration file
CKEDITOR.editorConfig = function (config) {
    // Disable any version check or updates if such an option exists
    config.versionCheck = false; // This is a placeholder; CKEditor doesn't usually have this option by default
    
    // Set other CKEditor configurations
    config.language = 'en'; // Set the language
    config.height = 400;    // Editor height
    
    // Remove unnecessary plugins (if any) to speed up load time or reduce complexity
    config.removePlugins = 'elementspath';
    
    // Define the toolbar (if you want a custom toolbar)
    config.toolbar = [
        { name: 'basicstyles', items: ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript'] },
        { name: 'paragraph', items: ['NumberedList', 'BulletedList', 'Blockquote'] },
        { name: 'links', items: ['Link', 'Unlink'] },
        { name: 'insert', items: ['Image', 'Table', 'HorizontalRule', 'SpecialChar'] },
        { name: 'tools', items: ['Maximize'] }
    ];

    // Disable the automatic update notification
    config.disableNativeSpellChecker = false;
    
    // Optional: Disable specific dialogs
    config.removeDialogTabs = 'image:advanced;link:advanced';
    
    // Optional: Change skin/theme of the editor
    config.skin = 'moono';  // You can use 'moono', 'moono-lisa', or other available skins
};

