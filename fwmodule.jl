module FWmodule
    
    using Pkg
    Pkg.add("DifferentialEquations")
    Pkg.add("DiffEqFlux")
    Pkg.add("OrdinaryDiffEq")
    Pkg.add("Lux")
    Pkg.add("Optim")
    Pkg.add("GalacticOptim")
    Pkg.add("Optimization")
    Pkg.add("ComponentArrays")
    Pkg.add("DiffEqSensitivity")
    Pkg.add("Flux")
    Pkg.add("LinearAlgebra")
    Pkg.add("DelimitedFiles")
    Pkg.add("Random")
    Pkg.add("Statistics")
    Pkg.add("Plots")
    Pkg.add("Optimization")
    Pkg.add("OptimizationOptimisers")
    Pkg.add("OptimizationOptimJL")
    Pkg.add("SBMLToolkit")
    Pkg.add("ModelingToolkit")
    Pkg.add("Catalyst")
    Pkg.add("Latexify")
    Pkg.add("DynamicHMC")
    Pkg.add("Turing")

    using DifferentialEquations
    using DiffEqFlux
    using OrdinaryDiffEq
    using Lux
    using Optim
    using GalacticOptim
    using Optimization
    using ComponentArrays
    using DiffEqSensitivity
    using Flux.Losses: mae, mse, logitcrossentropy
    using LinearAlgebra
    using DelimitedFiles
    using Random
    using Statistics
    using Plots
    gr()
    using Optimization, OptimizationOptimisers, OptimizationOptimJL
    using SBMLToolkit, ModelingToolkit
    using Catalyst, Latexify
    using DynamicHMC
    using Turing
    
    function import_sbml(filepath, lvl, version)
        SBMLToolkit.checksupport_file(filepath) 
        mdl = readSBML(filepath, doc -> begin
              set_level_and_version(lvl, version)(doc) 
              convert_simplify_math(doc)
              end)
        return mdl
    end
    ###
    function define_model(mdl)
        rs = ReactionSystem(mdl) 
        odesys = convert(ODESystem, rs)
        reactionsvector = reactions(rs)
        speciesvector = species(rs)
        ode_func = ODEFunction(odesys)
        return rs, odesys, reactionsvector, speciesvector, ode_func
    end
    ###
    function gen_timeseries(tspan, odesys, u0, model_param, method, abstol, reltol, saveat)
        prob       = ODEProblem(odesys, u0, tspan, model_param);
        sol        = solve(prob, method, abstol=abstol, reltol=reltol, saveat=saveat);
        X          = Array(sol);
        t          = sol.t;
        return X, t
    end
    ###
    function ude_dynamics!(du, u, p, nn_p, nn_st, t, ode_func, U) 
        ode_func(du, u, p, t) # mechanistic model
        # here we add the neural network to the mechanistic model
        NN = U(u, nn_p, nn_st)[1]
        for i in 1:length(du)
            du[i] += NN[i]
        end
    end
    ###
    function predict(θ, prob_nn, method, abstol, reltol, saveat)                
        tmp_prob = remake(prob_nn, p=θ)
        tmp_sol  = solve(
            tmp_prob, method, abstol=abstol, reltol=reltol, saveat = saveat,
            sensealg = DiffEqFlux.ForwardDiffSensitivity()
        )
        return tmp_sol
    end
    ###
    function loss(θ, prob_nn, method, abstol, reltol, saveat, N, X, _step, selected_species)
        sol = FWmodule.predict(θ, prob_nn, method, abstol, reltol, saveat);
        if  sol.retcode == :Success
            X̂ = Array(sol);
            return mae(X̂[:, 1:_step:N], X[selected_species, 1:_step:N]);
        end
        println(IJulia.orig_stdout[], "Failed...")
        return Inf;
    end
    ###
    
    ###

    # Calculate MAE metric
    function calculate_mae(simulated, observed)
        return sum(abs.(simulated - observed)) / length(observed)
    end

    # Calculate R² metric
    function calculate_r2(simulated, observed)
        mean_observed = mean(observed)
        ss_total = sum((observed .- mean_observed).^2)
        ss_residual = sum((observed .- simulated).^2)
        r2 = 1.0 - ss_residual / ss_total
        return abs(r2)
    end

    # Calculate BIC metric
    function calculate_bic(simulated, observed, num_parameters, num_data_points)
        n = num_data_points
        k = num_parameters
        residual_sum_of_squares = sum((observed .- simulated).^2)
        bic = n * log(residual_sum_of_squares / n) + k * log(n)
        return bic
    end
    #
    # Calculate combined score
    function calculate_metrics(sol_nn1, sol_nn2, X, nn_p, model_param)
    # Calculate metrics for each SBML model
        mae_nn = calculate_mae(Array(sol_nn1), X)
        mae_nn2 = calculate_mae(Array(sol_nn2), X)
        r2_nn = calculate_r2(Array(sol_nn1), X)
        r2_nn2 = calculate_r2(Array(sol_nn2), X)  
        num_parameters_nn = length(nn_p)
        num_parameters_nn2 = length(model_param)
        num_data_points = length(X)
        bic_nn = calculate_bic(Array(sol_nn1), X, num_parameters_nn, num_data_points)
        bic_nn2 = calculate_bic(Array(sol_nn2), X, num_parameters_nn2, num_data_points)

        # Calculate combined scores
        combined_score_nn = 0
        combined_score_nn2 = 0

        # Compare the results and choose the preferable model based on combined scores
        if mae_nn < mae_nn2
            combined_score_nn = combined_score_nn + 1
        elseif mae_nn > mae_nn2
            combined_score_nn2 = combined_score_nn2 + 1
        else
            combined_score_nn2 = combined_score_nn2 + 1
            combined_score_nn = combined_score_nn + 1
        end
        #
        if bic_nn < bic_nn2
            combined_score_nn = combined_score_nn + 1
        elseif bic_nn > bic_nn2
            combined_score_nn2 = combined_score_nn2 + 1
        else
            combined_score_nn2 = combined_score_nn2 + 1
            combined_score_nn = combined_score_nn + 1
        end
        #
        if r2_nn > r2_nn2
            combined_score_nn = combined_score_nn + 1
        elseif r2_nn < r2_nn2
            combined_score_nn2 = combined_score_nn2 + 1
        else
            combined_score_nn2 = combined_score_nn2 + 1
            combined_score_nn = combined_score_nn + 1
        end
    
        #
        if combined_score_nn > combined_score_nn2
            return "m1"
        elseif combined_score_nn2 > combined_score_nn
            return "m2"
        else
            return "Draw"
        end
    end
    #
end