@everywhere using EVOCLUS, TSPLIB, JLD

@everywhere const sdump = joinpath(pwd(),"Data","Simple")



@everywhere function runner(tgt::Symbol)
  tsp = readTSPLIB(tgt)
  file = jldopen(joinpath(sdump,"$(tsp.name).jld"), "w")
  for i in 1:10
    dict = runGA(tsp)
    file["$i"] = dict
  end
  close(file)
end



@everywhere function runGA(tsp::TSP)
  objfun = tsp.ffx
  N = tsp.dimension
  initPopulation = randperm
  populationSize = 100
  crossoverRate = 0.5
  mutationRate = 0.15
  ɛ = .1
  selection = tournament(2)
  crossover = ox1
  mutation = insertion!
  iterations = 5000
  tol = 0.0
  tolIter = 10001
  vstep = 10001
  rebal = true
  inform = true
  robust = true
  signature = tsp.name

  dict = sGA(objfun,N,initPopulation,populationSize,crossoverRate,
             mutationRate,ɛ,selection,crossover,mutation,iterations,tol,
             tolIter,vstep,rebal,inform,robust,signature)
  return dict
end

function main()
  allTSP = findTSP(TSPLIB95_path)
  pmap(runner,allTSP[1:1])
end

main()
