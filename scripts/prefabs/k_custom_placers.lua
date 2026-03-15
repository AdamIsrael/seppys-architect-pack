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
MakePlacer("sap_cottontree_small_placer", "quagmire_tree_cotton_short", "quagmire_tree_cotton_build", "sway1_loop", false, nil, nil, nil, nil, nil, cottontreeplacetestfn),
MakePlacer("sap_carrot_planted_placer", "quagmire_soil", "quagmire_crop_carrot", "crop_full", false, nil, nil, nil, nil, nil, plantedcarrotplacetestfn),
MakePlacer("sap_potato_planted_placer", "quagmire_soil", "quagmire_crop_potato", "crop_full", false, nil, nil, nil, nil, nil, plantedpotatoplacetestfn),
MakePlacer("sap_turnip_planted_placer", "quagmire_soil", "quagmire_crop_turnip", "crop_full", false, nil, nil, nil, nil, nil, plantedcarrotplacetestfn),
MakePlacer("sap_onion_planted_placer", "quagmire_soil", "quagmire_crop_onion", "crop_full", false, nil, nil, nil, nil, nil, plantedcarrotplacetestfn),
MakePlacer("sap_wheat_planted_placer", "quagmire_soil", "quagmire_crop_wheat", "crop_full", false, nil, nil, nil, nil, nil, plantedwheatplacetestfn),
MakePlacer("sap_garlic_planted_placer", "quagmire_soil", "quagmire_crop_garlic", "crop_full", false, nil, nil, nil, nil, nil, plantedcarrotplacetestfn),
MakePlacer("sap_tomato_planted_placer", "quagmire_soil", "quagmire_crop_tomato", "crop_full", false, nil, nil, nil, nil, plantedpotatoplacetestfn),
MakePlacer("sap_red_mushroom_placer", "mushrooms", "mushrooms", "red"),
MakePlacer("sap_green_mushroom_placer", "mushrooms", "mushrooms", "green"),
MakePlacer("sap_blue_mushroom_placer", "mushrooms", "mushrooms", "blue"),
MakePlacer("sap_rose_placer", "flowers", "flowers", "rose"),
MakePlacer("sap_flower_withered_placer", "withered_flowers", "withered_flowers", "wf3"),
MakePlacer("sap_mandrake_planted_placer", "mandrake", "mandrake", "ground"),
MakePlacer("sap_carrotplanted_placer", "carrot", "carrot", "planted"),
MakePlacer("sap_lumpy_sapling_placer", "pinecone", "pinecone", "idle_planted2"),
MakePlacer("sap_marsh_tree_placer", "marsh_tree", "tree_marsh", "sway1_loop"),
MakePlacer("sap_petrified_tree_short_placer", "petrified_tree_short", "petrified_tree_short", "full"),
MakePlacer("sap_petrified_tree_placer", "petrified_tree", "petrified_tree", "full"),
MakePlacer("sap_petrified_tree_tall_placer", "petrified_tree_tall", "petrified_tree_tall", "full"),
MakePlacer("sap_petrified_tree_old_placer", "petrified_tree_old", "petrified_tree_old", "full"),
MakePlacer("sap_marbletree1_placer", "marble_trees", "marble_trees", "full_1"),
MakePlacer("sap_marbletree2_placer", "marble_trees", "marble_trees", "full_2"),
MakePlacer("sap_marbletree3_placer", "marble_trees", "marble_trees", "full_3"),
MakePlacer("sap_marbletree4_placer", "marble_trees", "marble_trees", "full_4"),
MakePlacer("sap_rock1_placer", "rock", "rock", "full"),
MakePlacer("sap_rock2_placer", "rock2", "rock2", "full"),
MakePlacer("sap_rockflintless_placer", "rock_flintless", "rock_flintless", "full"),
MakePlacer("sap_rockice_placer", "ice_boulder", "ice_boulder", "full"),
MakePlacer("sap_rockmoon_placer", "rock5", "rock7", "full"),
MakePlacer("sap_moonglass_placer", "moonglass_rock", "moonglass_rock", "full"),
MakePlacer("sap_pigtorch_placer", "pigtorch", "pig_torch", "idle"),
MakePlacer("sap_rundown_placer", "merm_house", "merm_house", "idle"),
MakePlacer("sap_rabbithole_placer", "rabbithole", "rabbit_hole", "idle"),
MakePlacer("sap_hollowstump_placer", "catcoon_den", "catcoon_den", "idle"),
MakePlacer("sap_houndmound_placer", "houndbase", "hound_base", "idle"),
MakePlacer("sap_beehive_placer", "beehive", "beehive", "cocoon_small"),
MakePlacer("sap_wasphive_placer", "wasphive", "wasphive", "cocoon_small"),
MakePlacer("sap_nestground_placer", "nesting_ground", "nesting_ground", "idle", true),
MakePlacer("sap_moonspiderden_placer", "spider_mound_mutated", "spider_mound_mutated", "full"),
-- MakePlacer("kyno_statueharp_placer", "statue_small", "statue_small_harp_build", "full"),
MakePlacer("sap_marblepillar_placer", "marble_pillar", "marble_pillar", "full"),
MakePlacer("sap_succulent_plant_placer", "succulent", "succulent", "idle"),
MakePlacer("sap_driftwood1_placer", "driftwood_small1", "driftwood_small1", "idle"),
MakePlacer("sap_driftwood2_placer", "driftwood_small2", "driftwood_small2", "idle"),
MakePlacer("sap_driftwood3_placer", "driftwood_tall", "driftwood_tall", "idle"),
MakePlacer("sap_houndbone_placer", "houndbase", "hound_base", "piece2"),
MakePlacer("sap_seabones_placer", "fishbones", "fishbones", "idle_1"),
MakePlacer("sap_skeleton_placer", "skeleton", "skeletons", "idle6"),
MakePlacer("sap_oceandebris_placer", "flotsam", "flotsam", "idle_land"),
MakePlacer("sap_cavefern_placer", "ferns", "cave_ferns", "f4"),
MakePlacer("sap_redmushtree_placer", "mushroom_tree_med", "mushroom_tree_med", "idle_loop"),
MakePlacer("sap_greenmushtree_placer", "mushroom_tree_small", "mushroom_tree_small", "idle_loop"),
MakePlacer("sap_bluemushtree_placer", "mushroom_tree", "mushroom_tree_tall", "idle_loop"),
MakePlacer("sap_webbedmushtree_placer", "mushroom_tree_webbed", "mushroom_tree_webbed", "idle_loop"),
MakePlacer("sap_stalagmitefull_placer", "rock_stalagmite", "rock_stalagmite", "full"),
MakePlacer("sap_stalagmitemed_placer", "rock_stalagmite", "rock_stalagmite", "med"),
MakePlacer("sap_stalagmitelow_placer", "rock_stalagmite", "rock_stalagmite", "low"),
MakePlacer("sap_stalagmitetall_full_placer", "rock_stalagmite_tall", "rock_stalagmite_tall", "full_1"),
MakePlacer("sap_stalagmitetall_med_placer", "rock_stalagmite_tall", "rock_stalagmite_tall", "med_1"),
MakePlacer("sap_stalagmitetall_low_placer", "rock_stalagmite_tall", "rock_stalagmite_tall", "low_2"),
MakePlacer("sap_spiderhole_placer", "spider_mound", "spider_mound", "full"),
MakePlacer("sap_slurtlehole_placer", "slurtle_mound", "slurtle_mound", "idle"),
MakePlacer("sap_bananatree_placer", "cave_banana_tree", "cave_banana_tree", "idle_loop"),
MakePlacer("sap_vine1_placer", "exitrope", "copycreep_build", "idle"),
MakePlacer("sap_vine2_placer", "exitrope", "vine01_build", "idle"),
MakePlacer("sap_vine3_placer", "vine_rainforest_border", "vine_rainforest_border", "idle_1"),
MakePlacer("sap_mushtree_moon_placer", "mushroom_tree", "mutatedmushroom_tree_build", "idle_loop"),
MakePlacer("sap_cave_fern_withered_placer", "ferns", "cave_ferns_withered_build", "f2"),
MakePlacer("sap_flower_cave_withered_placer", "bulb_plant_single", "bulb_plant_single_withered_build", "idle"),
MakePlacer("sap_flower_cave_double_withered_placer", "bulb_plant_double", "bulb_plant_double_withered_build", "idle"),
MakePlacer("sap_flower_cave_triple_withered_placer", "bulb_plant_triple", "bulb_plant_triple_withered_build", "idle"),
MakePlacer("sap_cave_vent_rock_placer", "cave_vent", "cave_vent", "full")