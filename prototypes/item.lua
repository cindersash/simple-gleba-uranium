local space_age_item_sounds = require("__space-age__.prototypes.item_sounds")

local uranium_bacteria = {
    type = "item",
    name = "sgu_uranium-bacteria",
    icon = "__simple-gleba-uranium__/graphics/icons/uranium-bacteria.png",
    pictures =
    {
      { size = 64, filename = "__simple-gleba-uranium__/graphics/icons/uranium-bacteria.png", scale = 0.5, mipmap_count = 4 },
      { size = 64, filename = "__simple-gleba-uranium__/graphics/icons/uranium-bacteria-2.png", scale = 0.5, mipmap_count = 4 }
    },
    subgroup = "agriculture-processes",
    order = "b[agriculture]-d[copper-bacteria]",
    inventory_move_sound = space_age_item_sounds.agriculture_inventory_move,
    pick_sound = space_age_item_sounds.agriculture_inventory_pickup,
    drop_sound = space_age_item_sounds.agriculture_inventory_move,
    stack_size = 50,
    default_import_location = "gleba",
    weight = 1 * kg,
    spoil_ticks = 1 * minute,
    spoil_result = "uranium-ore"
}

data:extend({uranium_bacteria})
