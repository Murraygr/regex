gap> START_TEST("automata package: testall.tst");
gap> LoadPackage("regex",false);
true
gap> reg_Match("a", "abc");
[ true, 1 ]
gap> reg_Match("a", "hello abc");
[ true, 7 ]
gap> reg_Match("el", "hello abc");
[ true, 2 ]
gap> reg_Match("(H|h)ello", "hello abc");
[ true, 1 ]
gap> reg_Match("(H|h)ello", "Hello abc");
[ true, 1 ]
gap> reg_Match("(H|h)ello", "bello abc");
[ false, 0 ]
gap> reg_Match("meo*w", "mew");
[ true, 1 ]
gap> reg_Match("meo*w", "meow");
[ true, 1 ]
gap> reg_Match("meo*w", "meoooooow");
[ true, 1 ]
gap> reg_Match("hello+", "hell");
[ false, 0 ]
gap> reg_Match("hello+", "hello");
[ true, 1 ]
gap> reg_Match("hello+", "hellooooooo");
[ true, 1 ]
gap> reg_Match("a.", "ac");
[ true, 1 ]
gap> reg_Match("a.", "a");
[ true, 1 ]
gap> reg_Match("a.", "acd");
[ true, 1 ]
gap> reg_Match("^hello", "hello abc");
[ true, 1 ]
gap> reg_Match("^hello", "abc hello");
[ false, 0 ]
gap> reg_Match("hello$", "abc hello");
[ true, 5 ]
gap> reg_Match("hello$", "hello abc");
[ false, 0 ]
gap> reg_Match("^hello$", "hello");
[ true, 1 ]
gap> reg_Match("^hello$", "abc hello abc");
[ false, 0 ]
gap> reg_Match("a?b", "b");
[ true, 1 ]
gap> reg_Match("a?b", "ab");
[ true, 1 ]
gap> text_Match("a", "a");
true
gap> text_Match("a", "hello abc");
false
gap> text_Match("el", "hello abc");
false
gap> text_Match("(H|h)ello", "hello");
true
gap> text_Match("(H|h)ello", "Hello");
true
gap> text_Match("(H|h)ello", "bello");
false
gap> text_Match("meo*w", "mew");
true
gap> text_Match("meo*w", "meow");
true
gap> text_Match("meo*w", "meoooooow");
true
gap> text_Match("a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?aaaaaaaaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaaaaaaaa");
true
gap> STOP_TEST( "testall.tst", 10000 );