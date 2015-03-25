module.exports = (grunt) ->

  grunt.initConfig
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

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-jasmine-nodejs'

  grunt.registerTask 'test', ['jasmine_nodejs']
  grunt.registerTask 'default', ['test']

