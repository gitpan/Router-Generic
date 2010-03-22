#!/usr/bin/perl -w

use strict;
use warnings 'all';
use Test::More 'no_plan';

use_ok('Router::Generic');

ok(
  my $router = Router::Generic->new(),
  "Got router object"
);


EN_US_A: {
  my $router = Router::Generic->new();
  $router->add_route(
    name      => 'LangLocale1',
    path      => '/{langLocale:[a-z]{2}\-[a-z]{2}}/',
    target    => '/wiki.asp'
  );
  
  is(
    $router->match('/en-us/'),
    '/wiki.asp?langLocale=en-us',
    '/en-us/ (A)'
  );
};


EN_US_B: {
  my $router = Router::Generic->new();
  $router->add_route(
    name      => 'LangLocale1',
    path      => '/:lang/:locale/',
    target    => '/wiki.asp'
  );
  
  is(
    $router->match('/en/us/'),
    '/wiki.asp?lang=en&locale=us',
    '/en/us/ (B)'
  );
};


GROUP_A: {
  $router->add_route(
    name      => "Categories",
    path      => '/categories/{*Category}',
    target    => '/category.asp',
    defaults  => {
      Category  => 'All',
    }
  );

  is(
    $router->match('/categories/') => '/category.asp?Category=All',
    '/categories/ (A)'
  );

  is(
    $router->match('/categories/Trucks/') => '/category.asp?Category=Trucks',
    '/categories/Trucks/ (B)'
  );

  is(
    $router->match('/categories/Trucks') => '/category.asp?Category=Trucks',
    '/categories/Trucks (C)'
  );

  is(
    $router->match('/categories/Trucks/with/stuff') => '/category.asp?Category=Trucks%2Fwith%2Fstuff',
    '/categories/Trucks/with/stuff (C)'
  );
};


GROUP_B: {
  $router->add_route(
    name      => "Products",
    path      => '/products/{Category}/{Product}',
    target    => '/product.asp',
    defaults  => {
      Product  => 'All',
    }
  );
  
  is(
    $router->match('/products/Trucks/') => '/product.asp?Category=Trucks&Product=All',
    '/products/Trucks/'
  );
  
  is(
    $router->match('/products/Trucks/F-150/') => '/product.asp?Category=Trucks&Product=F-150',
    '/products/Trucks/F-150/'
  );
};


GROUP_B: {
  $router->add_route(
    name      => "Foo",
    path      => '/foo/{*Bar}',
    target    => '/foo.asp'
  );
  
  is(
    $router->match('/foo/') => '/foo.asp',
    '/foo/ (A)'
  );
  
  is(
    $router->match('/foo/bar') => '/foo.asp?Bar=bar',
    '/foo/bar (B)'
  );
  
  is(
    $router->match('/foo/bar/') => '/foo.asp?Bar=bar',
    '/foo/bar/ (C)'
  );
  
  is(
    $router->match('/foo/bar/baz') => '/foo.asp?Bar=bar%2Fbaz',
    '/foo/bar/baz (D)'
  );
  
  is(
    $router->match('/foo/bar/baz/') => '/foo.asp?Bar=bar%2Fbaz',
    '/foo/bar/baz/ (D)'
  );
};



GROUP_C: {
  $router->add_route(
    name      => "Pages",
    path      => '/pages/{page:\d*}',
    target    => '/page.asp',
    defaults  => { page => 1 },
  );
  
  is(
    $router->match('/pages/') => '/page.asp?page=1',
    '/pages/ (A)'
  );
  
  is(
    $router->match('/pages/1') => '/page.asp?page=1',
    '/pages/1 (B)'
  );
  
  is(
    $router->match('/pages/1/') => '/page.asp?page=1',
    '/pages/1/ (C)'
  );
  
  is(
    $router->match('/pages/sdf/') => undef,
    '/pages/sdf/ (C)'
  );
};


GROUP_D: {
  $router->add_route(
    name      => "ProductReviews",
    path      => '/shop/:cat/{Product}/reviews/{reviewPage:\d+}',
    target    => '/product-reviews.asp'
  );
  
  is(
    $router->match('/shop/dogs/Huskie/reviews/7/') =>
      '/product-reviews.asp?cat=dogs&Product=Huskie&reviewPage=7',
    '/shop/dogs/Huskie/reviews/7/'
  );
};



# Extra:
$router->add_route(
  name      => 'Simple',
  path      => '/Foo/bar',
  target    => '/foobar.asp',
);
is( $router->match('/Foo/bar/') => '/foobar.asp', 'Simplest route works' );

$router->add_route(
  name      => 'Zipcodes1',
  path      => '/zip/:code',
  target    => '/zipcode.asp',
);

$router->add_route(
  name      => 'Zipcodes2',
  path      => '/zip/:code/hospitals/',
  target    => '/zipcode-hospitals.asp',
);

is(
  $router->match('/zip/90210/') => '/zipcode.asp?code=90210',
  'Plain zipcode',
);

is(
  $router->match('/zip/90210/hospitals/') => '/zipcode-hospitals.asp?code=90210',
  'Zipcode with hospitals'
);







