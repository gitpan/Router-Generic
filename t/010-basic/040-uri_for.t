#!/usr/bin/perl -w

use strict;
use warnings 'all';
use Test::More 'no_plan';

use_ok('Router::Generic');

ok(
  my $router = Router::Generic->new(),
  "Got router object"
);

$router->add_route(
  name      => "Categories",
  path      => '/categories/{*Category}',
  target    => '/category.asp',
  defaults  => {
    Category  => 'All',
  }
);

$router->add_route(
  name      => "Products",
  path      => '/products/{Category}/{Product}',
  target    => '/product.asp',
  defaults  => {
    Product  => 'All',
  }
);

$router->add_route(
  name      => "Foo",
  path      => '/foo/{*Bar}',
  target    => '/foo.asp'
);

$router->add_route(
  name      => "Pages",
  path      => '/pages/{page:\d*}/',
  target    => '/page.asp',
  defaults  => { page => 1 },
);

$router->add_route(
  name      => "ProductReviews",
  path      => '/shop/:cat/{Product}/reviews/{reviewPage:\d+}/',
  target    => '/product-reviews.asp',
  defaults  => {
    Product     => 'All',
    reviewPage  => 1,
  }
);


is(
  $router->uri_for('Categories', {
    Category  => 'Firetrucks'
  }) => '/categories/Firetrucks/',
  '/categories/Firetrucks/'
);

is(
  $router->uri_for('Products', {
    Category  => 'Pickups',
    Product   => 'F-150'
  }) => '/products/Pickups/F-150/',
  '/products/Pickups/F-150/'
);

is(
  $router->uri_for('Foo', {
    Bar => 'Bar123',
  }) => '/foo/Bar123/',
  '/foo/Bar123/'
);

is(
  $router->uri_for('Pages', {
    page  => 4,
  }) => '/pages/4/',
  '/pages/4/'
);

is(
  $router->uri_for('ProductReviews', {
    cat         => 'Tissot',
    Product     => 'T-Sport',
    reviewPage  => 3,
  }) => '/shop/Tissot/T-Sport/reviews/3/',
  '/shop/Tissot/T-Sport/reviews/3/'
);

is(
  $router->uri_for('ProductReviews', {
    cat         => 'Tissot',
    reviewPage  => 3,
  }) => '/shop/Tissot/All/reviews/3/',
  '/shop/Tissot/All/reviews/3/'
);

is(
  $router->uri_for('ProductReviews', {
    cat         => 'Tissot',
  }) => '/shop/Tissot/All/reviews/1/',
  '/shop/Tissot/All/reviews/1/'
);


BLANK_DEFAULTS: {
  my $router = Router::Generic->new();
  
  $router->add_route(
    name      => 'Blank',
    path      => '/path/to/:page',
    target    => '/page.asp',
    defaults  => {
      page  => '',
    }
  );
  
  is( $router->uri_for('Blank') => '/path/to/' );
  is( $router->match('/path/to/') => '/page.asp?page=' );
  
  $router->add_route(
    name      => 'Blank2',
    path      => '/path2/to/:page/',
    target    => '/page.asp',
    defaults  => {
      page  => '',
    }
  );
  
  is( $router->uri_for('Blank2') => '/path2/to/' );
  is( $router->match('/path2/to/') => '/page.asp?page=' );
  
  $router->add_route(
    name      => 'Undef',
    path      => '/path/for/:page',
    target    => '/page.asp',
    defaults  => {
      page  => undef,
    }
  );
  
  is( $router->uri_for('Undef') => '/path/for/' );
  is( $router->match('/path/for/') => '/page.asp' );
  
  $router->add_route(
    name      => 'Undef2',
    path      => '/path2/for/:page/',
    target    => '/page.asp',
    defaults  => {
      page  => undef,
    }
  );
  
  is( $router->uri_for('Undef2') => '/path2/for/' );
  is( $router->match('/path2/for/') => '/page.asp' );
  
  $router->add_route(
    name      => 'Undef3',
    path      => '/path3/for/:page/',
    target    => '/page.asp',
  );
  
  is( $router->uri_for('Undef3') => '/path3/for/' );
  is( $router->match('/path3/for/') => '/page.asp' );
};




