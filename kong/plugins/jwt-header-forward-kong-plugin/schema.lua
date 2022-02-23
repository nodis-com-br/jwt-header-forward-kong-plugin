local typedefs = require "kong.db.schema.typedefs"

return {
  name = "jwt-header-forward",
  fields = {
    { consumer = typedefs.no_consumer },
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          {
            mappings = {
              type = "array",
              elements = {
                type = "string",
              },
            },
          },
        },
        required = true,
      },
    },
  }
}
