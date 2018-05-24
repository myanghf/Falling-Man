proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config  -ruleid {1}  -id {Labtoolstcl 44-494}  -string {{ERROR: [Labtoolstcl 44-494] There is no active target available for server at localhost.
 Targets(s) ", jsn-Basys3-210183713960A" may be locked by another hw_server.}}  -suppress 

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir C:/Users/Hanfu/OneDrive/EE2020/Lab/game/game.cache/wt [current_project]
  set_property parent.project_path C:/Users/Hanfu/OneDrive/EE2020/Lab/game/game.xpr [current_project]
  set_property ip_repo_paths c:/Users/Hanfu/OneDrive/EE2020/Lab/game/game.cache/ip [current_project]
  set_property ip_output_repo c:/Users/Hanfu/OneDrive/EE2020/Lab/game/game.cache/ip [current_project]
  add_files -quiet C:/Users/Hanfu/OneDrive/EE2020/Lab/game/game.runs/synth_1/game.dcp
  read_xdc C:/Users/Hanfu/OneDrive/EE2020/Lab/lab4/Basys3_Master.xdc
  link_design -top game -part xc7a35tcpg236-1
  write_hwdef -file game.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force game_opt.dcp
  report_drc -file game_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force game_placed.dcp
  report_io -file game_io_placed.rpt
  report_utilization -file game_utilization_placed.rpt -pb game_utilization_placed.pb
  report_control_sets -verbose -file game_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force game_routed.dcp
  report_drc -file game_drc_routed.rpt -pb game_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file game_timing_summary_routed.rpt -rpx game_timing_summary_routed.rpx
  report_power -file game_power_routed.rpt -pb game_power_summary_routed.pb -rpx game_power_routed.rpx
  report_route_status -file game_route_status.rpt -pb game_route_status.pb
  report_clock_utilization -file game_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force game.mmi }
  write_bitstream -force game.bit 
  catch { write_sysdef -hwdef game.hwdef -bitfile game.bit -meminfo game.mmi -file game.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

