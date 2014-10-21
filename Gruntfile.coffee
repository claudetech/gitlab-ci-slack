module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    watch:
      coffee:
        files: 'src/*.coffee'
        tasks: ['test']

    coffee:
      dist:
        expand: true
        flatten: true
        cwd: 'src'
        src: ['*.coffee']
        dest: 'lib/'
        ext: '.js'


  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'build', ['coffee:dist']

  grunt.registerTask 'default', ['coffee', 'watch']
