using Base.Test
using SimJulia

function get_served(client::Process, serv_time::Float64, my_server::Resource)
	println("$client requests 1 unit at t = $(now(client))")
	request(client, my_server)
	hold(client, serv_time)
	release(client, my_server)
	println("$client done at t = $(now(client))")
end


sim = Simulation(uint(16))
server = Resource(sim, "My server", uint(1), true)
c1 = Process(sim, "c1")
c2 = Process(sim, "c2")
c3 = Process(sim, "c3")
c4 = Process(sim, "c4")
activate(c1, 0.0, get_served, 100.0, server)
activate(c2, 0.0, get_served, 100.0, server)
activate(c3, 0.0, get_served, 100.0, server)
activate(c4, 0.0, get_served, 100.0, server)
run(sim, 1000.0)
println("")
println("TimeAverage no. waiting: $(time_average(wait_monitor(server)))")
println("Mean no. waiting: $(mean(wait_monitor(server)))")
println("Variance no. waiting: $(var(wait_monitor(server)))")
println("TimeAverage no. in service: $(time_average(activity_monitor(server)))")
println("Mean no. in service: $(mean(activity_monitor(server)))")
println("Variance no. in service: $(var(activity_monitor(server)))")
println("=====================================================================")
println("Time history for the 'server' waitQ:")
println("(time, waitQ)")
for item in wait_monitor(server)
	println(item)
end
println("=====================================================================")
println("Time history for the 'server' activeQ:")
println("(time, activeQ)")
for item in activity_monitor(server)
	println(item)
end