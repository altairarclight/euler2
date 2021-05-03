require_relative "euler2"

# derivative
f = ->(t, y) { (t ** 2 - y) / (y - 2 * t) }

step_sizes = [5, 10, 20,  40,  80,  160,  320].map! { |e| 1.0 / e }

euler_results = []

ie_results = []

rk4_results = []

step_sizes.each_with_index do |s, i|
  a = Approx.new(
    function: f,
    y0: 1,
    t0: 1,
    tf: 3,
    step_size: s,
    method: Methods::E
  )
  print "M#{i + 1}: "
  euler_results.push a.run(verbose: false, round: 7)
end

step_sizes.each_with_index do |s, i|
  a = Approx.new(
    function: f,
    y0: 1,
    t0: 1,
    tf: 3,
    step_size: s,
    method: Methods::IE
  )
  print "M#{i + 1}: "
  ie_results.push a.run(verbose: false, round: 7)
end

step_sizes.each_with_index do |s, i|
  a = Approx.new(
    function: f,
    y0: 1,
    t0: 1,
    tf: 3,
    step_size: s,
    method: Methods::RK4
  )
  print "M#{i + 1}: "
  rk4_results.push a.run(verbose: false, round: 7)
end

puts "Runge-Kutta ratios"
for n in 2..6
  m = rk4_results
  puts "n = #{n + 1}: #{((BigDecimal(m[n - 1], 7) - m[n - 2]) / (m[n] - m[n - 1])).to_f.round 7}"
end
