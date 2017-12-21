module.exports = function(grunt){

// Project configuration.
	grunt.initConfig({
		clean: ['build'],
		concat: {
			base_js: {
				src: ['js/jquery-2.2.0.min.js', 'js/foundation.min.js', 'js/foundation/foundation.topbar.js', 'js/vendor/modernizr.js'],
				dest:'build/js/base_scripts.js',
			},
			base_css: {
				src: ['css/normalize.css', 'css/foundation.css', 'css/app.css'],
				dest: 'build/css/base_styles.css',
			},
			tei_js: {
				src: ['js/jquery-2.2.0.min.js', 'js/browse.js', 'js/background.js', 'js/foundation', 'js/annotator.min.js', 'js/annotator-deploy.js'],
				dest: 'build/js/tei_scripts.js'
			},
			tei_css: {
				src: ['css/teibp.css', 'build/css/base_styles.css'],
				dest: 'build/css/tei_styles.css'
			},
			v_machine_js:{
				src: ['/vmachine_assets/vmachine.js','build/js/base_scripts.js'],
				dest: 'build/js/vmachine_scripts.js',
			},
			v_machine_css:{
				src: ['vmachine_assets/vmachine.css', 'build/css/base_styles.css'],
				dest:'build/css/vmachine_styles.css',
			},
		},
		watch:{
			js: {
				files: ['js/**/*.js'],
				tasks:['concat', 'uglify'],
			},
			css: {
				files:['css/**/*.css'],
				tasks: ['concat', 'cssmin'],
			}
		},
		uglify: {
	      	options: {
	        	preserveComments: false
	      	},
	      	base: {
	      		files:{
	      			'build/js/base_scripts.js': ['build/js/base_scripts.js'],
	      		}
	      	},
	      	tei: {
	      		files:{
	      			'build/js/tei_scripts.js': ['build/js/tei_scripts.js']
	      		}
	      	},
	      	vmachine:{
	      		files:{
	      			'build/js/vmachine_scripts.js': ['build/js/vmachine_scripts.js']
	      		}
	      	}
      	},
      	cssmin: {
			base: {
				files: {
				'build/css/base_styles.css': ['build/css/base_styles.css']
				}
			},
			vmachine:{
				files:{
					'build/css/vmachine_styles.css': ['build/css/vmachine_styles.css']
				}
			},
			tei: {
				files:{
					'build/css/tei_styles.css': ['build/css/tei_styles.css']
				}
			}
		},
		// can be used to minify xml - wouldn't integrate super tidily into the workflow at this stage. might be worth coming back to this later.
		// xmlmin: {                                       // Task 
  //   		dist: {                                     // Target 
  //           	options: {                              // Target options 
  //               	preserveComments: false
  //           	},
  //           files: {                                // Dictionary of files 
  //               'content/p.tidy.xml': 'content/p.xml',   // 'destination': 'source' 
  //      		}
  //       }
  //   }
});
		// causing problems with foundation, so left uncommented for now. appears optimized enough at least.
		// uncss: {
		// 	base: {
		// 		options: {
		// 			ignore: [/meta\..+/]
		// 		},
		// 		files: {
		// 			'build/css/base_styles.tidy.css': ['b.html', 't.html', 'bibliography.html', 'edition.html', 'index.html']
		// 		}
		// 	},
		// 	vmachine: {
		// 		options: {
		// 			ignore: [/meta\..+/]
		// 		},
		// 		files: {
		// 			'build/css/vmachine_styles.tidy.css': ['hell_scene.html']
		// 		}
		// 	},
		// 	tei: {
		// 		options: {
		// 			ignore: [/meta\..+/]
		// 		},
		// 		files:{
		// 			'build/css/tei_styles.tidy.css': ['content/teibp.xsl']
		// 		}
		// 	}
		// }

	grunt.loadNpmTasks('grunt-contrib-concat');
	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-cssmin');
	// grunt.loadNpmTasks('grunt-uncss');

	grunt.loadNpmTasks('grunt-xmlmin');

	grunt.registerTask('default', ['clean','concat', 
		//'uglify', 'cssmin', 
		'watch']);


};