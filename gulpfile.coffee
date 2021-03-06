gulp = require('gulp')
coffee = require('gulp-coffee')
less = require('gulp-less')
concat = require('gulp-concat')
uglify = require('gulp-uglify')
header = require('gulp-header')
rename = require('gulp-rename')
gutil = require('gulp-util')
clean = require('gulp-clean')


pkg = require('./package.json')
banner = "/*! #{ pkg.name } #{ pkg.version } */\n"
filename = pkg.main
minFilename = filename.replace('.js', '.min.js')


gulp.task 'coffee', ->
    try
        gulp.src('./src/**/*.coffee')
            .pipe(coffee().on('error', gutil.log))
            .pipe(gulp.dest('./build/'))

    catch e

gulp.task 'concat', ->
    src = ['build/**/*.js']
    gulp.src(src)
        .pipe(concat(pkg.main))
        .pipe(header(banner))
        .pipe(gulp.dest('./'))

gulp.task 'uglify', ->
    gulp.src(pkg.main)
        .pipe(uglify())
        .pipe(header(banner))
        .pipe(rename(minFilename))
        .pipe(gulp.dest('./'))

gulp.task 'js', ->
    gulp.run 'coffee', ->
        gulp.run 'concat', ->
            gulp.run 'uglify', ->

gulp.task 'css', ->
    gulp.src('./src/styles/filterbar.less')
        .pipe(less({
            paths: ['./src/styles']
            compress: false
        }))
        .pipe(gulp.dest('./'))

    gulp.src('./src/styles/filterbar.less')
        .pipe(less({
            paths: ['./src/styles']
            compress: true
        }))
        .pipe(rename({ext: '.min.css'}))
        .pipe(gulp.dest('./'))

gulp.task 'default', ->
    gulp.src('./build', {read: false})
        .pipe clean()

    gulp.run 'js'
    gulp.run 'css'

    gulp.watch './src/**/*.coffee', ->
        gulp.run 'js'

    gulp.watch './src/**/*.less', ->
        gulp.run 'css'

    gulp.watch './package.json', ->
        gulp.run 'js'
