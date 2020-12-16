Z=bp.generate.multiType(5,[1 3],@test_multi_type_gen);
bp.plot.treeplot(Z,Z(3,:))
bp.estimate.multiTypeRelariveFreq(Z)
