Simulations:
  - name: sim1
    time_integrator: ti_1
    optimizer: opt1

linear_solvers:

  - name: solve_scalar
    type: tpetra
    method: gmres
    preconditioner: sgs
    tolerance: 1e-5
    max_iterations: 50
    kspace: 50
    output_level: 0

  - name: solve_cont
    type: tpetra
    method: gmres
    preconditioner: muelu
    tolerance: 1e-5
    max_iterations: 50
    kspace: 50
    output_level: 0
    muelu_xml_file_name: matches_ml_default.xml

realms:

  - name: realm_1
    mesh: 2cm_ped_35K_mks.g
    use_edges: no 

    equation_systems:
      name: theEqSys
      max_iterations: 2

      solver_system_specification:
        velocity: solve_scalar
        pressure: solve_cont
        enthalpy: solve_scalar
        mass_fraction: solve_scalar
      systems:

        - LowMachEOM:
            name: myLowMach
            max_iterations: 1
            convergence_tolerance: 1e-5

        - MassFraction:
            name: myYk
            max_iterations: 1
            convergence_tolerance: 1e-5
            number_of_species: 2

        - Enthalpy:
            name: myEnth
            max_iterations: 1
            convergence_tolerance: 1e-5

    material_properties:

      target_name: block_1

      constant_specification:
       universal_gas_constant: 8314.4621
       reference_pressure: 101325.0

      reference_quantities:
        - species_name: aN2
          mw: 28.0

        - species_name: bO2
          mw: 32.0

      specifications:
 
        - name: density
          type: ideal_gas_t

        - name: viscosity
          type: polynomial

          coefficient_declaration:
          - species_name: aO2
            coefficients: [1.7894e-5, 273.11, 110.56]

          - species_name: bN2
            coefficients: [1.7894e-5, 273.11, 110.56]

        - name: specific_heat
          type: polynomial

          coefficient_declaration:
          - species_name: aO2
            low_coefficients: [3.212936000E+00,  1.127486400E-03, -5.756150000E-07,   
                               1.313877300E-09, -8.768554000E-13, -1.005249000E+03]
            high_coefficients: [3.212936000E+00,  1.127486400E-03, -5.756150000E-07,   
                                1.313877300E-09, -8.768554000E-13, -1.005249000E+03]

          - species_name: bN2
            low_coefficients: [3.298677000E+00,  1.408240400E-03, -3.963222000E-06, 
                               5.641515000E-09, -2.444854000E-12, -1.020899900E+03]
            high_coefficients: [3.298677000E+00,  1.408240400E-03, -3.963222000E-06, 
                                5.641515000E-09, -2.444854000E-12, -1.020899900E+03]

    initial_conditions:
      - constant: ic_1
        target_name: block_1
        value:
          pressure: 0
          velocity: [0,0]  
          temperature: 300.0
          mass_fraction: [0.22, 0.78]

    boundary_conditions:

    - wall_boundary_condition: bc_bottom
      target_name: surface_1
      wall_user_data:
        velocity: [0,0,0]
        temperature: 305.0

    - inflow_boundary_condition: bc_inflow
      target_name: surface_2
      inflow_user_data:
        velocity: [0,0,10.0]
        temperature: 800.0
        mass_fraction: [ 0.85, 0.15]

    - wall_boundary_condition: bc_pipe
      target_name: surface_3
      wall_user_data:
        velocity: [0,0,0]

    - open_boundary_condition: bc_side
      target_name: surface_4
      open_user_data:
        velocity: [0,0,0]
        pressure: 0.0
        temperature: 300.0
        mass_fraction: [ 0.22, 0.78]

    - open_boundary_condition: bc_top
      target_name: surface_5
      open_user_data:
        velocity: [0,0,0]
        pressure: 0.0
        temperature: 300.0
        mass_fraction: [ 0.22, 0.78]

    solution_options:
      name: myOptions
      turbulence_model: wale
      shift_cvfem_mdot: no
      shift_cvfem_poisson: no
      reduced_sens_cvfem_poisson: yes 

      interp_rhou_together_for_mdot: no

      options:
        - hybrid_factor:
            velocity: 1.0
            enthalpy: 1.0
            mass_fraction: 1.0

        - laminar_prandtl:
            enthalpy: 0.85

        - turbulent_prandtl:
            enthalpy: 1.0

        - laminar_schmidt:
           mass_fraction: 0.85

        - turbulent_schmidt:
           mass_fraction: 1.0

        - source_terms:
            continuity: density_time_derivative

        - limiter:
            pressure: no
            velocity: no
            enthalpy: yes
            mass_fraction: yes

    output:
      output_data_base_name: nonIsoNonUniformElemOpenJet.e
      output_frequency: 5
      output_node_set: no
      output_variables:
       - velocity
       - pressure
       - temperature
       - enthalpy
       - mass_fraction

Time_Integrators:
  - StandardTimeIntegrator:
      name: ti_1
      start_time: 0
      termination_time: 0.01
      time_step: 0.001
      time_stepping_type: adaptive 
      time_step_count: 0

      realms:
        - realm_1
