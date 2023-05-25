
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name statemachine -dir "D:/Download/vga/statemachine/planAhead_run_2" -part xc6slx9tqg144-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/Download/vga/statemachine/state_test.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/Download/vga/statemachine} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "test.ucf" [current_fileset -constrset]
add_files [list {test.ucf}] -fileset [get_property constrset [current_run]]
link_design
