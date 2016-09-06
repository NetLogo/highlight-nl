module.exports = (grunt) ->

  massAlias =
    (glob, base) ->
      files = grunt.file.expand({ filter: 'isFile' }, glob)
      regex = new RegExp(".*?/#{base}/(.*)\.js")
      splitter = (file) ->
        alias = file.match(regex)[1]
        "#{file}:#{alias}"
      files.map(splitter)

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffeelint: {
      app: ['src/**/*.coffee'],
      options: {
        configFile: 'coffeelint.json'
      }
    },
    coffee: {

      compile: {
        files: [
          {
            expand: true,
            cwd: 'src',
            src: ['**/*.coffee'],
            dest: 'target/highlight-nl',
            ext: '.js'
          }
        ]
      },

      test: {
        files: [
          {
            expand: true,
            cwd: 'test',
            src: ['**/*.coffee'],
            dest: 'test/target/highlight-nl',
            ext: '.js'
          }
        ]
      }

    },
    browserify: {
      main: {
        src: ['target/highlight-nl/highlight-nl.js'],
        dest: 'dist/highlight-nl.js',
        options: {
          alias: []
        }
      }
    },
    copy: {

      publish: {
        files: [

          {
            src: ['target/highlight-nl/highlight-nl/*']
          , dest: 'publish'
          , expand:  true
          , filter:  'isFile'
          , flatten: true
          }

        ],
      }

      stylesheets: {
        files: [

          {
            src: ['stylesheets/*']
          , dest: 'dist'
          , expand:  true
          , filter:  'isFile'
          , flatten: true
          }

        ],
      }

    },

    uglify: {
      options: {
        mangle: {
          except: []
        }
      },
      main: {
        files: {
          'dist/highlight-nl.min.js': ['dist/highlight-nl.js']
        }
      }
    }

  })

  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-uglify')

  # I do this because inlining it in `browserify`'s options causes the value to
  # be evaluated before any of the tasks are run, but we need to wait until
  # `coffee` runs for this to work --JAB (8/21/14)
  grunt.task.registerTask('gen_aliases', 'Find aliases, then run browserify', ->
    aliases = massAlias('./target/highlight-nl/**/*.js', 'highlight-nl')
    grunt.config(['browserify', 'main', 'options', 'alias'], aliases);
    return
  )

  grunt.registerTask('default', ['coffeelint', 'coffee:compile', 'copy:publish', 'copy:stylesheets'
                               , 'gen_aliases', 'browserify', 'uglify:main'])
