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



