# DAODALUS

### Construct complex MongoDB queries, updates and aggregations.

##### Examples:

    #!ruby
    class CatDAO
      extend Daodalus::DSL
      target :animals, :cats # or overide `connection` to supply your own


