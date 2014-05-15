// Karma configuration

module.exports = function(config){
    config.set({
    frameworks: [ 'mocha', 'chai' ],

    // list of files / patterns to load in the browser
    files: [
        'app/bower_components/angular/angular.js',
        'app/bower_components/angular-animate/angular-animate.js',
        'app/bower_components/angular-sanitize/angular-sanitize.js',
        'app/bower_components/angular-ui-router/release/angular-ui-router.js',
        'app/bower_components/ionic/release/js/ionic.js',
        'app/bower_components/ionic/release/js/ionic-angular.js',
        'app/bower_components/angular-mocks/angular-mocks.js',
        'app/scripts/*.js',
        '.tmp/test/alltests.js'
    ],

    // web server port
    port: 8080,

    // cli runner port
    runnerPort: 9100,

    // enable / disable colors in the output (reporters and logs)
    colors: true,

    // level of logging
    // possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
    logLevel: config.LOG_DEBUG,

    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: false,

    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera
    // - Safari (only Mac)
    // - PhantomJS
    // - IE (only Windows)
    browsers: ['PhantomJS'],

    // If browser does not capture in given timeout [ms], kill it
    captureTimeout: 5000,

    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: false,

    preprocessors: {
        // source files, that you wanna generate coverage for
        // do not include tests or libraries
        // (these files will be instrumented by Istanbul)
        'app/scripts/*.js': ['coverage']
    },

    coverageReporter: {
        reporters: [
            { type: 'cobertura', dir: 'test/coverage/' },
            { type: 'text-summary' }
        ]
    },

    // test results reporter to use
    // possible values: 'dots', 'progress', 'junit'
    reporters: ['dots', 'coverage']

    //junitReporter = {
    //    outputFile: 'test-results.xml'
    //};
   })
}



