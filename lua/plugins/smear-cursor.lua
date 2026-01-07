return {
  "sphamba/smear-cursor.nvim",
  opts = {
    -- Default  Range
    -- 0.6      [0, 1]
    -- 0.45     [0, 1]
    -- 0.5      [0, 1]
    -- 0.5      [0, 1]
    -- 0.85     [0, 1]
    -- 0.9      [0, 1]

    -- Faster smear
    stiffness = 0.8,
    trailing_stiffness = 0.6,
    stiffness_insert_mode = 0.7,
    trailing_stiffness_insert_mode = 0.7,
    damping = 0.95,
    damping_insert_mode = 0.95,
    distance_stop_animating = 0.5,

    -- Smooth cursor without smear
    -- stiffness = 0.5,
    -- trailing_stiffness = 0.5,
    -- matrix_pixel_threshold = 0.5,
  },
}
