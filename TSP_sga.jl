@everywhere using EVOCLUS, TSPLIB, JLD

@everywhere const sdump = joinpath(pwd(),"Data","Simple")



@everywhere function runner(tpl::Tuple{Symbol,Int})
  tgt,i = tpl
  tsp = readTSPLIB(tgt)
  dict = runGA(tsp)
  file = jldopen(joinpath(sdump,"$(tsp.name).jld"), "r+")
  file["$i"] = dict
  close(file)
  println(tsp.name," : ",i)
  return
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

function main(k::Int)
  targets = Symbol[:berlin52,:kroa100,:pr144,:ch150,:kroB150,:pr152,:rat195,
                   :d198,:kroa200,:ts225,:pr226,:pr299,:lin318,:pcb442,:ch130,
                   :a280,:d493,:u574,:u724,:pr1002,:u1060,:d1291,:u1432,:d1655,
                   :u2152,:pr2392,:pcb3038,:fnl4461,:usa13509]
  n = length(targets)
  #instruction set
  instruct = Tuple{Symbol,Integer}[]
  #fill instruction set
  for i in 1:n
    for j in 1:k
      push!(instruct,(targets[i],j))
    end
  end

  #create .jld files
  for i in 1:n
    file = jldopen(joinpath(sdump,"$(targets[i]).jld"),"w")
    close(file)
  end
  #pmap(runner,targets)
  return shuffle(instruct)
end

instruct = main(5)
println(instruct)

