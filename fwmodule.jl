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
end