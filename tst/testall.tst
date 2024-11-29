gap> START_TEST("regex package: testall.tst");
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
reg_Match("a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?aaaaaaaaaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaaaaaaaaa");
[ true, 1 ]
gap> STOP_TEST( "testall.tst", 10000 );