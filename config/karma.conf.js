basePath = '../';

files = [
  JASMINE,
  JASMINE_ADAPTER,
  'build/debug/ColonChord.js',
  'test/**/*[^_].js',
  {pattern: 'test/sample-song.txt', included: false}
];

autoWatch = true;

browsers = ['PhantomJS'];
