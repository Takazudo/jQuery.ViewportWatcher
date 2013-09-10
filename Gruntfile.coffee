module.exports = (grunt) ->
  
  grunt.task.loadTasks 'misc/gruntcomponents/tasks'
  grunt.task.loadNpmTasks 'grunt-contrib-coffee'
  grunt.task.loadNpmTasks 'grunt-contrib-watch'
  grunt.task.loadNpmTasks 'grunt-contrib-concat'
  grunt.task.loadNpmTasks 'grunt-contrib-uglify'
  grunt.task.loadNpmTasks 'grunt-mocha'

  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')
    banner: """
      /*! <%= pkg.name %> (<%= pkg.repository.url %>)
       * lastupdate: <%= grunt.template.today("yyyy-mm-dd") %>
       * version: <%= pkg.version %>
       * author: <%= pkg.author %>
       * License: MIT */

      """

    growl:

      ok:
        title: 'COMPLETE!!'
        msg: '＼(^o^)／'

    coffee:

      libself:
        src: [ 'jquery.viewportwatcher.coffee' ]
        dest: 'jquery.viewportwatcher.js'

      test:
        src: [ 'tests/mocha/test.coffee' ]
        dest: 'tests/mocha/test.js'

    concat:

      banner:
        options:
          banner: '<%= banner %>'
        src: [ '<%= coffee.libself.dest %>' ]
        dest: '<%= coffee.libself.dest %>'

    uglify:

      options:
        banner: '<%= banner %>'
      libself:
        src: '<%= concat.banner.dest %>'
        dest: 'jquery.viewportwatcher.min.js'

    mocha:

      all: [ 'tests/mocha/**/*.html' ]
      
    watch:

      libself:
        files: [
          '<%= coffee.libself.src %>'
        ]
        tasks: [
          'default'
        ]

      test:
        files: [ '<%= coffee.test.src %>' ]
        tasks: [
          'default'
        ]

  grunt.registerTask 'default', [
    'coffee'
    'concat'
    'uglify'
    'mocha'
    'growl:ok'
  ]

