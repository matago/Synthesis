using EVOCLUS, TSPLIB

tsp = readTSPLIB(:usa13509)

objfun = tsp.ffx
N = tsp.dimension
initPopulation = Gen_Kmedian(tsp.weights,4)
populationSize = 100
crossoverRate = 0.5
mutationRate = 0.15
ɛ = .1
selection = tournament(2)
crossover = pmx
mutation = insertion!
iterations = 100
tol = 0.0
tolIter = 9999
vstep = 10
rebal = true
inform = true
robust = true
signature = tsp.name



store = sGA(objfun,N,initPopulation,populationSize,crossoverRate,
            mutationRate,ɛ,selection,crossover,mutation,iterations,tol,
            tolIter,vstep,rebal,inform,robust,signature)


println(store[:best])



