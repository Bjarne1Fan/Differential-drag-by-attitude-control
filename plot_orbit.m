scenario = satelliteScenario;
sat_f = satellite(scenario, out.follower_ecef_pos,  out.follower_ecef_vel, ...
    "CoordinateFrame", "ecef");
sat_l = satellite(scenario, out.leader_ecef_pos,  out.leader_ecef_vel, ...
    "CoordinateFrame", "ecef");

disp(scenario)

% animate the satellite scenario
play(scenario);
disp(scenario.Viewers(1))

