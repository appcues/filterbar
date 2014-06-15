gulp = require('gulp')
coffee = require('gulp-coffee')
less = require('gulp-less')
concat = require('gulp-concat')
uglify = require('gulp-uglify')
header = require('gulp-header')
rename = require('gulp-rename')
gutil = require('gulp-util')
wrap = require('gulp-wrap-umd')


pkg = require('./package.json')
banner = "/*! #{ pkg.name } #{ pkg.version } */\n"
filename = pkg.main
minFilename = filename.replace('.js', '.min.js')
AMDFilename = filename.replace('.js', '-amd.js')
minAMDFilename = filename.replace('.js', '-amd.min.js')

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

    gulp.src(src)
        .pipe(concat(AMDFilename))
        .pipe(header(banner))
        .pipe(gulp.dest('./'))
        .pipe(wrap({
            namespace: pkg.name
            exports: pkg.name
        }))
        .pipe(gulp.dest('./'))

gulp.task 'uglify', ->
    gulp.src(pkg.main)
        .pipe(uglify())
        .pipe(header(banner))
        .pipe(rename(minFilename))
        .pipe(gulp.dest('./'))

    gulp.src(AMDFilename)
        .pipe(uglify())
        .pipe(header(banner))
        .pipe(rename(minAMDFilename))
        .pipe(gulp.dest('./'))

gulp.task 'js', ->
    gulp.run 'coffee', ->
        gulp.run 'concat', ->
            gulp.run 'uglify', ->

gulp.task 'less', ->
    gulp.src('./src/styles/**/*.less')
        .pipe(less({
            paths: ['./src/styles']
            compress: true
        }))
        .pipe(gulp.dest('./build'));

gulp.task 'default', ->
    gulp.watch './src/**/*.coffee', ->
        gulp.run 'js'

    gulp.watch './src/**/*.less', ->
        gulp.run 'less'

    gulp.watch './package.json', ->
        gulp.run 'js'