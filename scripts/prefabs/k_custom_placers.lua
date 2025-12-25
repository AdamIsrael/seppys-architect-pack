local function cottontreeplacetestfn(inst)
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:Hide("swap_tapper")
    inst.AnimState:Hide("sap")
	
	inst.AnimState:SetScale(.85, .85, .85)
end

local function plantedcarrotplacetestfn(inst)
	-- inst.AnimState:AddOverrideBuild("quagmire_soil")
	inst.AnimState:Show("crop_bulb1")
	inst.AnimState:Show("crop_leaf1")
	inst.AnimState:Show("soil_back")
	inst.AnimState:Show("soil_front")
end

local function plantedpotatoplacetestfn(inst)
	inst.AnimState:Show("crop_bulb2")
	inst.AnimState:Show("crop_leaf2")
	inst.AnimState:Show("soil_back")
	inst.AnimState:Show("soil_front")
end

local function plantedturnipplacetestfn(inst)
	inst.AnimState:AddOverrideBuild("quagmire_soil")
	inst.AnimState:Hide("mouseover")
	inst.AnimState:Show("crop_bulb1")
	inst.AnimState:Show("crop_leaf1")
end

local function plantedwheatplacetestfn(inst)
	inst.AnimState:Show("crop_bulb3")
	inst.AnimState:Show("crop_leaf3")
	inst.AnimState:Show("soil_back")
	inst.AnimState:Show("soil_front")
end

return
MakePlacer("kyno_cottontree_small_placer", "quagmire_tree_cotton_short", "quagmire_tree_cotton_build", "sway1_loop", false, nil, nil, nil, nil, nil, cottontreeplacetestfn),
MakePlacer("kyno_carrot_planted_placer", "quagmire_soil", "quagmire_crop_carrot", "crop_full", false, nil, nil, nil, nil, nil, plantedcarrotplacetestfn),
MakePlacer("kyno_potato_planted_placer", "quagmire_soil", "quagmire_crop_potato", "crop_full", false, nil, nil, nil, nil, nil, plantedpotatoplacetestfn),
MakePlacer("kyno_turnip_planted_placer", "quagmire_soil", "quagmire_crop_turnip", "crop_full", false, nil, nil, nil, nil, nil, plantedcarrotplacetestfn),
MakePlacer("kyno_onion_planted_placer", "quagmire_soil", "quagmire_crop_onion", "crop_full", false, nil, nil, nil, nil, nil, plantedcarrotplacetestfn),
MakePlacer("kyno_wheat_planted_placer", "quagmire_soil", "quagmire_crop_wheat", "crop_full", false, nil, nil, nil, nil, nil, plantedwheatplacetestfn),
MakePlacer("kyno_garlic_planted_placer", "quagmire_soil", "quagmire_crop_garlic", "crop_full", false, nil, nil, nil, nil, nil, plantedcarrotplacetestfn),
MakePlacer("kyno_tomato_planted_placer", "quagmire_soil", "quagmire_crop_tomato", "crop_full", false, nil, nil, nil, nil, plantedpotatoplacetestfn),
MakePlacer("kyno_red_mushroom_placer", "mushrooms", "mushrooms", "red"),
MakePlacer("kyno_green_mushroom_placer", "mushrooms", "mushrooms", "green"),
MakePlacer("kyno_blue_mushroom_placer", "mushrooms", "mushrooms", "blue"),
MakePlacer("kyno_rose_placer", "flowers", "flowers", "rose"),
MakePlacer("kyno_flower_withered_placer", "withered_flowers", "withered_flowers", "wf3"),
MakePlacer("kyno_mandrake_planted_placer", "mandrake", "mandrake", "ground"),
MakePlacer("kyno_carrotplanted_placer", "carrot", "carrot", "planted"),
MakePlacer("kyno_lumpy_sapling_placer", "pinecone", "pinecone", "idle_planted2"),
MakePlacer("kyno_marsh_tree_placer", "marsh_tree", "tree_marsh", "sway1_loop"),
MakePlacer("kyno_petrified_tree_short_placer", "petrified_tree_short", "petrified_tree_short", "full"),
MakePlacer("kyno_petrified_tree_placer", "petrified_tree", "petrified_tree", "full"),
MakePlacer("kyno_petrified_tree_tall_placer", "petrified_tree_tall", "petrified_tree_tall", "full"),
MakePlacer("kyno_petrified_tree_old_placer", "petrified_tree_old", "petrified_tree_old", "full"),
MakePlacer("kyno_marbletree1_placer", "marble_trees", "marble_trees", "full_1"),
MakePlacer("kyno_marbletree2_placer", "marble_trees", "marble_trees", "full_2"),
MakePlacer("kyno_marbletree3_placer", "marble_trees", "marble_trees", "full_3"),
MakePlacer("kyno_marbletree4_placer", "marble_trees", "marble_trees", "full_4"),
MakePlacer("kyno_rock1_placer", "rock", "rock", "full"),
MakePlacer("kyno_rock2_placer", "rock2", "rock2", "full"),
MakePlacer("kyno_rockflintless_placer", "rock_flintless", "rock_flintless", "full"),
MakePlacer("kyno_rockice_placer", "ice_boulder", "ice_boulder", "full"),
MakePlacer("kyno_rockmoon_placer", "rock5", "rock7", "full"),
MakePlacer("kyno_moonglass_placer", "moonglass_rock", "moonglass_rock", "full"),
MakePlacer("kyno_pigtorch_placer", "pigtorch", "pig_torch", "idle"),
MakePlacer("kyno_rundown_placer", "merm_house", "merm_house", "idle"),
MakePlacer("kyno_rabbithole_placer", "rabbithole", "rabbit_hole", "idle"),
MakePlacer("kyno_hollowstump_placer", "catcoon_den", "catcoon_den", "idle"),
MakePlacer("kyno_houndmound_placer", "houndbase", "hound_base", "idle"),
MakePlacer("kyno_beehive_placer", "beehive", "beehive", "cocoon_small"),
MakePlacer("kyno_wasphive_placer", "wasphive", "wasphive", "cocoon_small"),
MakePlacer("kyno_nestground_placer", "nesting_ground", "nesting_ground", "idle", true),
MakePlacer("kyno_moonspiderden_placer", "spider_mound_mutated", "spider_mound_mutated", "full"),
-- MakePlacer("kyno_statueharp_placer", "statue_small", "statue_small_harp_build", "full"),
MakePlacer("kyno_marblepillar_placer", "marble_pillar", "marble_pillar", "full"),
MakePlacer("kyno_succulent_plant_placer", "succulent", "succulent", "idle"),
MakePlacer("kyno_driftwood1_placer", "driftwood_small1", "driftwood_small1", "idle"),
MakePlacer("kyno_driftwood2_placer", "driftwood_small2", "driftwood_small2", "idle"),
MakePlacer("kyno_driftwood3_placer", "driftwood_tall", "driftwood_tall", "idle"),
MakePlacer("kyno_houndbone_placer", "houndbase", "hound_base", "piece2"),
MakePlacer("kyno_seabones_placer", "fishbones", "fishbones", "idle_1"),
MakePlacer("kyno_skeleton_placer", "skeleton", "skeletons", "idle6"),
MakePlacer("kyno_oceandebris_placer", "flotsam", "flotsam", "idle_land"),
MakePlacer("kyno_cavefern_placer", "ferns", "cave_ferns", "f4"),
MakePlacer("kyno_redmushtree_placer", "mushroom_tree_med", "mushroom_tree_med", "idle_loop"),
MakePlacer("kyno_greenmushtree_placer", "mushroom_tree_small", "mushroom_tree_small", "idle_loop"),
MakePlacer("kyno_bluemushtree_placer", "mushroom_tree", "mushroom_tree_tall", "idle_loop"),
MakePlacer("kyno_webbedmushtree_placer", "mushroom_tree_webbed", "mushroom_tree_webbed", "idle_loop"),
MakePlacer("kyno_stalagmitefull_placer", "rock_stalagmite", "rock_stalagmite", "full"),
MakePlacer("kyno_stalagmitemed_placer", "rock_stalagmite", "rock_stalagmite", "med"),
MakePlacer("kyno_stalagmitelow_placer", "rock_stalagmite", "rock_stalagmite", "low"),
MakePlacer("kyno_stalagmitetall_full_placer", "rock_stalagmite_tall", "rock_stalagmite_tall", "full_1"),
MakePlacer("kyno_stalagmitetall_med_placer", "rock_stalagmite_tall", "rock_stalagmite_tall", "med_1"),
MakePlacer("kyno_stalagmitetall_low_placer", "rock_stalagmite_tall", "rock_stalagmite_tall", "low_2"),
MakePlacer("kyno_spiderhole_placer", "spider_mound", "spider_mound", "full"),
MakePlacer("kyno_slurtlehole_placer", "slurtle_mound", "slurtle_mound", "idle"),
MakePlacer("kyno_bananatree_placer", "cave_banana_tree", "cave_banana_tree", "idle_loop"),
MakePlacer("kyno_vine1_placer", "exitrope", "copycreep_build", "idle"),
MakePlacer("kyno_vine2_placer", "exitrope", "vine01_build", "idle"),
MakePlacer("kyno_vine3_placer", "vine_rainforest_border", "vine_rainforest_border", "idle_1"),
MakePlacer("kyno_mushtree_moon_placer", "mushroom_tree", "mutatedmushroom_tree_build", "idle_loop"),
MakePlacer("kyno_cave_fern_withered_placer", "ferns", "cave_ferns_withered_build", "f2"),
MakePlacer("kyno_flower_cave_withered_placer", "bulb_plant_single", "bulb_plant_single_withered_build", "idle"),
MakePlacer("kyno_flower_cave_double_withered_placer", "bulb_plant_double", "bulb_plant_double_withered_build", "idle"),
MakePlacer("kyno_flower_cave_triple_withered_placer", "bulb_plant_triple", "bulb_plant_triple_withered_build", "idle"),
MakePlacer("kyno_cave_vent_rock_placer", "cave_vent", "cave_vent", "full")