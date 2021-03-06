using Distributions
using SimJulia

# Model components

function visit(customer::Process, time_in_bank::Float64, clerk::Resource)
	arrive = now(customer)
	@printf("%8.3f %s: Here I am\n", arrive, customer)
	request(customer, clerk)
	wait = now(customer) - arrive
	@printf("%8.3f %s: Waited %6.3f\n", now(customer), customer, wait)
	hold(customer, time_in_bank)
	release(customer, clerk)
	@printf("%8.3f %s: Finished\n", now(customer), customer)
end

function generate(source::Process, number::Int64, mean_time_between_arrivals::Float64, clerk::Resource)
	d = Exponential(mean_time_between_arrivals)
	for i = 1:number
		c = Process(simulation(source), @sprintf("Customer%02d", i))
		activate(c, now(source), visit, 12.0, clerk)
		t = rand(d)
		hold(source, t)
	end
end

# Experiment data

max_number = 5
max_time = 400.0
mean_time_between_arrivals = 10.0
theseed = 99999

# Model/Experiment

srand(theseed)
sim = Simulation(uint(16))
k = Resource(sim, "Counter", uint(1), false)
s = Process(sim, "Source")
activate(s, 0.0, generate, max_number, mean_time_between_arrivals, k)
run(sim, max_time)
