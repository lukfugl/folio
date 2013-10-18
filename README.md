# Parchment

`Parchment` is a library for pagination. It's meant to be nearly
compatible with `WillPaginate`, but with broader -- yet more
well-defined -- semantics to allow for sources whose page identifiers
are non-ordinal (i.e.  a page identifier of `3` does not necessarily
indicate the third page).

## Installation

Add this line to your application's Gemfile:

    gem 'parchment'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parchment

## Usage

The core `Parchment` interface is defined by two mixins. Mixing
`Parchment::Sheaf` into a source of items creates a "sheaf" and provides
pagination on that sheaf. Mixing `Parchment::Sheet` into a subset of
items from a sheaf creates a "sheet" with additional properties relating
it to the sheaf and the other sheets in the sheaf.

`Parchment` also provides some basic implementations, both standalone
and by mixing these modules in to familiar classes.

### Sheets

You can mix `Parchment::Sheet` into any `Enumerable`. The mixin gives
you eight attributes and one method:

 * `ordinal_pages?` indicates whether the page identifiers in
   `current_page`, `first_page`, `last_page`, `previous_page`, and
   `next_page` should be considered ordinal or not.

 * `current_page` is the page identifier addressing this sheet within
   the sheaf.

 * `per_page` is the number of items requested from the sheaf when
   filling the sheet.

 * `first_page` is the page identifier addressing the first sheet within
   the sheaf.

 * `last_page` is the page identifier addressing the final sheet within
   the sheaf, if known.

 * `next_page` is the page identifier addressing the immediately
   following sheet within the sheaf, if there is one.

 * `previous_page` is the page identifier addressing the immediately
   preceding sheet within the sheaf, if there is one and it is known.

 * `total_entries` is the number of items in the sheaf, if known.

 * `total_pages` if the number of sheets in the sheaf, if known.
   calculated from `total_entries` and `per_page`.

`ordinal_pages?`, `first_page`, and `last_page` are common to all sheets
created by a sheaf and are configured, as available, when the sheaf
creates a blank sheet in its `build_sheet` method (see below).

`current_page`, `per_page`, and `total_entries` control the filling of a
sheet and are configured from parameters to the sheaf's `paginate`
method.

`next_page` and `previous_page` are configured, as available, when the
sheaf fills the configured sheet in its `fill_sheet` method (see below).

### Sheaves

You can mix `Parchment::Sheaf` into any class implementing two methods:

 * `build_sheet` is responsible for instantiating a `Parchment::Sheet`
   and configuring its `ordinal_pages?`, `first_page`, and `last_page`
   attributes; those values being common to any sheet returned from the
   sheaf. 

 * `fill_sheet` will receive a `Parchment::Sheet` with the
   `ordinal_pages?`, `first_page`, `last_page`, `current_page`,
   `per_page`, and `total_entries` attributes configured, and should
   populate the sheet with the corresponding items from the sheaf. It
   should also set appropriate values for the `next_page` and
   `previous_page` attributes on the sheet. If the value provided in the
   sheet's `current_page` cannot be interpreted as addressing a sheet in
   the sheaf, `Parchment::InvalidPage` should be raised.

In return, `Parchment::Sheaf` provides a `paginate` method and
`per_page` attributes for both the sheaf class and for individual sheaf
instances.

The `paginate` method coordinates the sheet creation, configuration, and
population. It takes three parameters: `page`, `per_page`, and
`total_entries`, each optional.

 * `page` configures the sheet's `current_page`, defaulting to the
   sheet's `first_page`.

 * `per_page` configures the sheet's `per_page`, defaulting to the
   sheaf's `per_page` attribute.

 * `total_entries` configures the sheet's `total_entries`, if present.
   otherwise, if the sheaf implements a `count` method, the sheet's
   `total_entries` will be set from that method.

NOTE: providing a `total_entries` parameter of nil will still bypass the
`count` method, leaving `total_entries` nil. This is useful when the
count would be too expensive and you'd rather just leave the number of
entries unknown.

The `per_page` attribute added to the sheaf instance will default to the
`per_page` attribute from the sheaf class when unset. The `per_page`
class attribute added to the sheaf class will default to global
`Parchment.per_page` when unset.

### Ordinal Sheaves

A typical use case for pagination deals with ordinal page identifiers;
e.g. "1" means the first page, "2" means the second page, etc.

As a matter of convenience for these use cases, an additional mixin is
provided: `Parchment::Sheave::Ordinal`.

Mixing this into your source instead of `Parchment::Sheave` has the same
requirements and benefits, except the responsibilities of the
`build_sheet` and `fill_sheet` methods are narrowed.

`build_sheet` no longer needs to configure `ordinal_page?`,
`first_page`, or `last_page` on the instantiated sheet; these values can
all be inferred; `ordinal_page?` will be set true and `first_page` set
to 1, while the `last_page` attribute on the sheaf is replaced by an
alias to `total_pages`. The method now simply needs to choose a type of
sheet to instantiate and return it.

Similarly, `fill_sheet` no longer needs to configure `next_page` and
`last_page`; they will be calculated from `current_page`, `first_page`,
and `last_page`. Instead, the method can focus entirely on populating
the sheet.

### Basic Sheet

As a minimal example and default simple implementation, we provide
`Parchment::Sheet::Basic`, which is simply a subclass of Array extended
with the `Parchment::Sheet` mixin.

### Enumerable Extension

If you require `parchment/core_ext/enumerable`, all `Enumerable`s will
be extended with `Parchment::Sheaf::Ordinal` and naive `build_sheet` and
`fill_sheet` methods.

`build_sheet` will simply return a `Parchment::Sheet::Basic` (decorated
by `Parchment::Sheaf::Ordinal`) to hold the results. `fill_sheet`
selects an appropriate range of items from the sheaf using `drop` and
`first`, then calls `replace` on the sheet (subclass of `Array`,
remember?) with this range.

This lets you do things like:

```
require 'lib/parchment/core_ext/enumerable'

natural_numbers = Enumerator.new do |enum|
  n = 0
  loop{ enum.yield(n += 1) }
end
page = natural_numbers.paginate(page: 3, per_page: 5, total_entries: nil)

page.ordinal_pages?                     #=> true
page.per_page                           #=> 5
page.first_page                         #=> 1
page.previous_page                      #=> 2
page.current_page                       #=> 3
page.next_page                          #=> 4 (TODO: currently nil)
page.last_page                          #=> nil
page.total_entries                      #=> nil
page.total_pages                        #=> nil
page                                    #=> [11, 12, 13, 14, 15]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
