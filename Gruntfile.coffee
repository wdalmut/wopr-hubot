module.exports = (grunt) ->

  grunt.initConfig
    meta:
      src: 'src/**/*.js'
      specs: 'spec/**/*.js'

    watch:
        files: '**/*.coffee'
        tasks: ['test']

    jasmine_nodejs:
      options:
        coffee: true
        reporters:
          console:
            colors: true
            cleanStack: true
            verbose: false
      all:
        specs: [
          "spec/**"
        ]

    coffee:
      compile:
        files:
          'spec/robot_spec.js': ['spec/*.coffee']

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-jasmine-nodejs'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'test', ['coffee', 'jasmine_nodejs']
  grunt.registerTask 'default', ['test']

