basePath = '../';

files = [
  JASMINE,
  JASMINE_ADAPTER,
  'build/node_modules/underscore/underscore.js',
  'build/node_modules/underscore.string/lib/underscore.string.js',
  'build/debug/ColonChord.js',
  'test/**/*[^_].js',
  {pattern: 'test/sample-song.txt', included: false}
];

autoWatch = true;

browsers = ['PhantomJS'];
