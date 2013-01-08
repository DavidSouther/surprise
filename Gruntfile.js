module.exports = function(grunt) {
	'use strict';
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		clean: {
			all: ['lib/'],
			html: ['src/client/*html']
		},
		jade: {
			client: {
				files: {
					'src/client/components.html': ['src/client/components/**/*jade'],
					'src/client/pages.html'     : ['src/client/pages/**/*jade'],
					'lib/client/index.html'     : ['src/client/index.jade']
				}
			}
		},
		stylus: {
			client: {
				files: {
					'lib/client/styles/<%= pkg.name %>.css': ['src/client/**/*styl']
				}
			}
		},
		coffee: {
			server: {
				files: {
					'lib/<%= pkg.name %>.js': ['src/server/**/*coffee']
				}
			},
			client: {
				files: {
					'lib/client/scripts/app.js'       : 'src/client/app.coffee',
					'lib/client/scripts/filters.js'   : 'src/client/filters/**/script.coffee',
					'lib/client/scripts/services.js'  : 'src/client/services/**/script.coffee',
					'lib/client/scripts/directives.js': 'src/client/directives/**/script.coffee',
					'lib/client/scripts/components.js': 'src/client/components/**/script.coffee',
					'lib/client/scripts/pages.js'     : 'src/client/pages/**/script.coffee'
				},
				options: {
					bare: false
				}
			},
			tests: {
				files: {
					'lib/tests/tests.js': [
						'src/client/**/test.coffee'
					],
					'lib/tests/e2e.js': [
						'src/client/**/e2e.coffee'
					],
					'lib/tests/mocks.js': [
						'src/test/mocks/*coffee'
					]
				}
			}
		},
		copy: {
			vendors: {
				files: {
					'lib/client/vendors/': 'vendors/**'
				}
			},
            context: {
				files: {
					'lib/client/': 'src/client/*json'
				}
			}
		},
		testacularServer: {
			unit: {
				configFile: "src/test/config/unit.js",
				options: {
					keepalive: true
				}
			},
			e2e: {
				configFile: "src/test/config/e2e.js",
				options: {
					keepalive: true
				}
			}
		},
		testacularRun: {
			unit: {},
			e2e: {}
		},
		server: {
			base: "lib/client",
			port: 3000
		},
		watch: {
			server: {
				files: [
					'src/server/**/*coffee'
				],
				tasks: ['build-server']
			},
			client: {
				files: [
					'src/client/**/*jade',
					'src/client/**/*coffee',
					'src/client/**/*styl'
				],
				tasks: ['build-client']
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib');
	grunt.loadNpmTasks('grunt-testacular')

	grunt.registerTask('vendors', 'copy:vendors');
	grunt.registerTask('build-client', ['jade:client', 'clean:html', 'stylus:client', 'coffee:client', 'copy:context']);
	grunt.registerTask('build-server', ['coffee:server']);
	grunt.registerTask('build-tests', ['coffee:tests']);
	grunt.registerTask('build', ['build-server', 'build-client', 'build-tests']);
	grunt.registerTask('test-unit', ['testacularServer:unit', 'testacularRun:unit'])
	grunt.registerTask('test-e2e', ['server', 'testacularServer:e2e', 'testacularRun:e2e'])
	grunt.registerTask('tests', ['unit', 'e2e']);
	grunt.registerTask('default', ['clean', 'build', 'vendors', 'tests']);

	// HACK
	// Until grunt-contrib-connect comes.
	var connect = require('connect');
	grunt.registerTask('server', 'Start a custom static web server.', function() {
		grunt.log.writeln('Starting static web server in "lib/client" on port 3000.');
		try{
			connect(connect.static('lib/client')).listen(3000);
		} catch (e){}
	});

	// HACK
	// Until grunt-testacular works sanely.
	grunt.registerTask('e2e', 'Run end-2-end tests.', function(){
		grunt.log.writeln("Running e2e tests in child process.");
		var done = this.async();
		var child = require("child_process").spawn("grunt", ['test-e2e'], {stdio: "inherit"});
		child.on('exit', function(code, signal){
			done(code === 0);
		});
	});
	grunt.registerTask('unit', 'Run unit tests.', function(){
		grunt.log.writeln("Running unit tests in child process.");
		var done = this.async();
		var child = require("child_process").spawn("grunt", ['test-unit'], {stdio: "inherit"});
		child.on('exit', function(code, signal){
			done(code === 0);
		});
	});
};
