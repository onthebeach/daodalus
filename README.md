# DAODALUS  [![Build Status](https://travis-ci.org/onthebeach/daodalus.png)](http://travis-ci.org/onthebeach/daodalus) [![Code Climate](https://codeclimate.com/github/onthebeach/daodalus.png)](https://codeclimate.com/github/onthebeach/daodalus)

### Take the sting out of constructing complex MongoDB queries, updates and aggregations.

In Greek mythology, Daedalus tried to prevent Icarus from flying too close to the sun, but Icarus ignored his father's warning, the wax holding together his wings melted, and he fell to his death. 'Daodalus' hopes to succeed where Daedalus failed by preventing your application code from flying too close to the code that interacts with your datastore.

Originally conceived of as an implementation of the Data Access Object pattern, it has evolved since then into more of a DSL to simplify doing complicated things with Mongo. However, by separating your models from the object used to interact with their stored form, we hope Daodalus still encourages your application and data layers to keep their distance from each other.

Find the docs [here](http://onthebeach.github.io/daodalus).

## Registering connections

Before being able to use Daodalus you will need to create and register one or more connections to your instance (or instances) of MongoDB. Here's how you do it:

    conn = Mongo::MongoClient.new('localhost', 27017, pool_size: 5)
    Daodalus::Connection.register(conn, :name)

If you leave off the name, the connection will be registered as `:default`.

The connection can be any MongoDB connection class provided by the Ruby Mongo Driver - so you could also use a `MongoShardedClient` or `MongoReplicaSetClient` here.

## Creating a DAO

Create a DAO by specifying a database and collection (and optional connection name, defaulting to 'default'):

    dao = Daodalus::DAO.new(:my_db, :my_collection, :my_connection)

The `connection` name must match one of the connections you registered earlier.

## Access to MongoDB Collection Methods

You now have access to several basic MongoDB methods as defined on the `Mongo::Collection` class of the MongoDB Ruby driver. The following methods work unchanged:

* `#find`
* `#update`
* `#insert`
* `#save`
* `#remove`
* `#count`
* `#aggregate`

However, `#find_one` and `#find_and_modify` work slightly differently. While the original methods return either the matched document or `nil`, Daodalus is allergic to `nil`s, and so avoids them by using optional types instead. So the values returned will be either `Some[value]` or `None`. You can read more about optional types and see the implementation used by Daodalus [here](http://github.com/rsslldnphy/optional).

These are the only methods exposed by the Daodalus DAO - but should you need to call any other methods on the collection, the `Mongo::Collection` object can be accessed directly by calling `dao.coll`.

## Queries

Queries are built up by chaining together one or more 'where' clauses, like this:

    dao.where(:name).eq('Terry').and(:paws).gte(3).find

Note that a longer-form version of the clause name usually exists as an alias if you prefer to be a bit more verbose. So the above could equally be expressed as:

    dao.where(:name).equals('Terry').and(:paws).greater_than_or_equal(3).find

Notice the `find` at the end of the chain? This is what terminates the chain and sends your query to Mongo. You can also use `find_one` here (which, remember, will return an `Option`) as well as some other methods for updating and aggregation that we'll come to later.

If you need to make multiple assertions about the same field, you can simply chain them like this:

    dao.where(:paws).gt(2).lt(5).find

But bear in mind that it's not possible to make an equality assertion *and* another assertion on the same field. (Which makes sense if you think about it.) This will raise an `InvalidQueryError`.

Querying against nested fields works just like it does in plain Mongo, using the dot operator. (You can pass field names as strings or symbols, it's up to you.)

    dao.where(:'paws.2.toes').gt(3) # the third element of the paws array has a toes field that is > than 3

Here is the complete list of currently implemented 'where' clauses you can use with Daodalus.

| Clause     | Alias                      | Usage                         |
| ---------- | -------------------------- | ----------------------------- |
| `#eq`       | `#equals`                   | `dao.where(:paws).eq(4)`      |
| `#ne`       | `#not_equal`                | `dao.where(:paws).ne(4)`      |
| `#lt`       | `#less_than`                | `dao.where(:paws).lt(4)`      |
| `#gt`       | `#greater_than`             | `dao.where(:paws).gt(4)`      |
| `#lte`      | `#less_than_or_equal`       | `dao.where(:paws).lte(4)`     |
| `#gte`      | `#greater_than_or_equal`    | `dao.where(:paws).gte(4)`     |
| `#in`       | -                          | `dao.where(:paws).in(4, 3)`   |
| `#nin`      | `#not_in`                   | `dao.where(:paws).gte(4)`     |
| `#all`      | -                          | `dao.where(:likes).all('tuna', 'catnip')`     |
| `#size`      | -                   | `dao.where(:likes).size(3)`     |
| `#exists`      | -                   | `dao.where(:tail).exists`     |
| `#does_not_exist` | `#exists(false)`    | `dao.where(:tail).does_not_exist`     |

### Logic

Using `#not` will negate the following where clause (one only), whatever it might be. So:

    dao.where(:paws).not.gte(4)

translates as:

    { 'paws' : { '$not' : { '$gte' : 4 } } }

The MongoDB `or` and `nor` operators have different names in Daodalus so that they make more sense in the context they're in. So, to match *any* of a set of clauses, use `#any` like this:

    dao.where.any(
      dao.where(:paws).eq(3),
      dao.where(:name).eq('Terry')
    )

    # translates as { '$or' : [ { 'paws' : 3 }, { 'name' : 'Terry' }] }

...and to match only if *none* of a set of clauses match, use `#none`:

    dao.where.none(
      dao.where(:paws).eq(3),
      dao.where(:name).eq('Terry')
    )

    # translates as { '$nor' : [ { 'paws' : 3 }, { 'name' : 'Terry' }] }

### Matching array elements

You can also ensure a specific array element matches a number of conditions using the `#elem_match` method.

    dao.where(:foods).elem_match(
      dao.where(:type).eq(:wet).and(:name).eq("Whiskas")
    )

    # translates as { 'foods' : { '$elemMatch' : { 'type' : 'wet', 'name' : 'Whiskas' } } }

This will match only documents with a `foods` array which contains an element with a `type` value of "wet" *and* a `name` value of "Whiskas".

### The hard way

If you want to just pass a hash as a where clause just as you would if you were using the driver directly, you can do that too, like this:

    dao.where(name: 'Terry', paws: 3)

This can be more readable for simple equality matching over a number of fields.

## Selecting Fields to be Returned (Projection)

You don't always want the whole document to be returned. Mongo allows you to specify which fields you're interested in. To do this in Daodalus, use `#select`. Here's how to specify a bunch of fields to be selected:

    dao.select(:name, :paws, :tail)

NB. Although MongoDB *always* selects the `_id` field by default, Daodalus does not do this (in order to reduce the number of 'special cases'). If you need the `_id` field, simply specify it as part of the select.

### Chaining selects

If you're selecting lots of fields, you may wish to split the statement over multiple lines - or you could wish to separate groups of selected fields for semantic reasons. To help keep this neat, selects can be chained with the `and` method like this:

    dao.select(:cats, :dogs, :fish).and(:pigs, :sheep, :horseys)

### The positional operator

In Mongo, if you want to select only the first matched subdocument in an array you use the positional operator (`$`). In Daodalus, we've given that the slightly more descriptive name of `#by_position`. Use it like this:

    dao.select(:cats).by_position.where(:'cats.paws').gt(3) # select and return only the first cat with > 3 paws

You could also have specified the positional operator manually as part of the field name like this:

    dao.select(:'cats.$').where(:'cats.paws').gt(3)

### Slice

To select a subsection of an array, use `#slice`.

    dao.select(:favourite_foods).slice(4)      # get the first four
    dao.select(:favourite_foods).slice(-4)     # get the last four
    dao.select(:favourite_foods).slice(10, 4)  # get four, starting with the 10th
    dao.select(:favourite_foods).slice(-10, 4) # get four, starting with the 10th from last

### Elem_match

It's also possible to use `#elem_match` as part of a select clause, in a similar way to how it's used in a where clause. This time, it makes sure that only the first element in an array that matches the provided query is returned.

    dao.select(:favourite_foods).elem_match(
      dao.where(:price).lte(5_00)
    )

## Updating

Updating can be done using the various update methods listed below, followed by the `update`, `upsert`, or `find_and_modify` methods to end the chain (in the same way that we've used `find` and `find_and_modify` up to now). So you end up with something like this:

    dao.set(name: 'Poor Terry').dec(:paws).where(:name).eq('Terry').update
    dao.set(name: 'Poor Terry').dec(:paws).where(:name).eq('Terry').upsert
    dao.set(name: 'Poor Terry').where(:name).eq('Terry').find_and_modify

Each method also accepts an optional hash of options to pass to the respective Mongo driver method. See Mongo docs for details.

Here's the list of all currently implemented update methods you can use and how to use them:

| Method   | Usage                         |
| -------- | ----------------------------- |
| `#set`   | `dao.set(paws: 3)`            |
| `#unset`   | `dao.unset(:name, :paws)`   |
| `#inc`   | `dao.inc(:paws, 2) #default is 1`            | 
| `#dec`   | `dao.dec(:paws) #default is 1`            | 
| `#rename` | `dao.rename(:paws, :feet)` | 
| `#pop_first` | `dao.pop_first(:likes)` | 
| `#pop_last` | `dao.pop_last(:likes)` | 
| `#push` | `dao.push(:likes, 'Marxist political economy')` | 
| `#push_all` | `dao.push_all(:likes, ['bananas', 'crisps'])` | 
| `#add_to_set` | `dao.add_to_set(:likes, 'bananas')` |
| `#add_each_to_set` | `dao.add_each_to_set(:likes, ['bananas', 'crisps'])` | 
| `#pull` | `dao.pull(:likes, 'Marxist political economy')` | 
| `#pull_all` | `dao.pull_all(:likes, ['bananas', 'crisps'])` |

NB. `#push`, `#add_to_set`, and `#pull` can all accept multiple arguments - they will be converted to the appropriate array based `all` or `each` command under the hood. So you can write `dao.push(:likes, 'Marxist political economy', 'cake')` for example.

## Aggregation Framework

Using the aggregation framework involves simply chaining together a series of pipeline operators to build the query you want, finishing the (arbitrarily long) chain with a call to `aggregate`. Let's look at the different pipeline operators in turn.

### Match

Match allows you to query for a subset of documents in exactly the same way as you do with `where` - except as part of the aggregation pipeline. All the same methods are supported. This is what it looks like:

    dao.match(:paws).gt(3).and(:name).in("Jemima", "Terry").aggregate

    dao.match.any(
      dao.where(:name).eq('Terry'),
      dao.where(likes: 'tuna')
    ).aggregate

Ok, not that exciting yet. But it becomes exciting when you start combining it with the other operators!

### Group

This works very similar to a `GROUP BY` in SQL. As such Daodalus adds an alias for the method `group_by` - which you may find makes your code read a bit nicer. You can group by a single key like this:

    dao.group_by(:'$name').aggregate

which will give you result documents of the form `{ '_id' : 'whatever the name is' }`. You can also group by multiple keys like this (you need to provide a name, or alias, for each one):

    dao.group_by(name: '$name', paws: '$paws').aggregate

which will produce result documents of the form `{ '_id' : { 'name' : 'whatever the name is', 'paws' : 'no of paws' } }`.

The `$`s are required to indicate that you want the value of the specified field, rather than just the string literal you're passing. For more info see the Mongo docs.

Group also allows you to build aggregates of fields in various ways. You must always provide a name/alias for an aggregate field, by following the call to the function with a call to `as`, like this:

    dao.group_by('$breed').sum(1).as(:total).aggregate

Here are the aggregate group functions supported by Daodalus:

| Function      | Alias          | Usage                                                |
| ------------- | -------------- | ---------------------------------------------------- |
| `#sum`        | `#total`       | `dao.group_by('$breed').sum('$paws').as(:total_paws)` | 
| `#add_to_set` | `#distinct`    | `dao.group_by(1).distinct('$breeds').as(:breeds)`     | 
| `#push`       | `#collect`     | `dao.group_by(1).collect('$names').as(:names)`        |
| `#first`       | -            | `dao.group_by(1).first('$names').as(:name)`        |
| `#last`       | -             | `dao.group_by(1).last('$names').as(:name)`        |
| `#max`       | -              | `dao.group_by(1).max('$paws').as(:max_paws)`        |
| `#min`       | -              | `dao.group_by(1).min('$paws').as(:min_paws)`        |
| `#avg`       | `#average`     | `dao.group_by(1).average('$paws').as(:average_paws)`        |

### Project

Return a subset of fields from an aggregation and perform simple calculations on the returned fields with `#project`.

To simply return one or more fields as they are, pass them to `#project` like this:

    dao.project(:name, :paws, :'food.type').aggregate
    # NB. as with #select, the '_id' field is excluded by default

To give aliases to your fields, pass a hash in the structure you want. You'll need to use the `$` operator to signify the fields you want your aliases to refer to.

    dao.project(cat: "$name").aggregate

Another way to provide aliases is to use the `as` method like this:

    dao.project("$paws").as(:feet).aggregate

You can chain `project` calls together using `and`, like this:

    dao.project(:name, :likes).and(feet: "$paws").and("$foods.name").as(:foods).aggregate

You can build nested documents by using nested projects:

    dao.project(
      dao.project(:name, :paws)
    ).as(:cat).aggregate

And finally, you can perform simple operations on the data, like this:

    dao.project(4).minus("$paws").as(:accidents).aggregate

Here's the list of the currently supported `project` functions:

| Function      | Alias          | Usage                                                |
| ------------- | -------------- | ---------------------------------------------------- |
| `#eq`        | -               | `dao.project('$breed').eq('Tabby').as(:is_tabby)` | 
| `#add`        | `#plus`        | `dao.project('$paws').plus('$lives', 3).as(:a_number)` | 
| `#subtract`        | `#minus`        | `dao.project('$paws').minus(1).as(:less_paws)` | 
| `#divide`        | `#divided_by`        | `dao.project('$paws').divided_by(2).as(:half_my_paws)` | 
| `#multiply`        | `#multiplied_by`        | `dao.project('$paws').multiplied_by(2).as(:double_paws)` | 
| `#mod`        | -        | `dao.project('$paws').mod(2).as(:odd_paws)` | 

### Skip and Limit

Some very simple aggregation functions, analogous to the identically named methods you can use with a normal Mongo cursor. Skip an certain number of documents with `#skip` and limit the number returned with `#limit`.

    dao.skip(100).limit(20).aggregate

### Sort

Again, analogous to the method on `MongoCursor`. Pass a hash with the fields you want to sort by as keys and either `1` for ascending order or `-1` for descending order. If you like, instead of `1` and `-1` you can also use the symbols `:asc` and `:desc` like this:

    dao.sort(breed: :asc, paws: :desc).aggregate

### Unwind

If you have an array field and you want to unwind the document into one copy for each array element ('unwinding' them out of the array) use `#unwind`. Using it is simple, just pass it the field name you want to unwind. Remember it has to be an array field!

    dao.unwind(:likes).aggregate

## License

Daodalus is Copyright © 2012-2013 On The Beach Ltd.

It is free software, and may be redistributed under the terms specified in the LICENSE file.
