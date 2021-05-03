require "BigDecimal"

module Methods
  # enum for methods
  E = "euler"
  IE = "improved_euler"
  RK4 = "rk4"
end

class Approx
  def initialize(function:, y0:, t0:, tf:, step_size:, method:)
    @method = method
    # initial value
    @y = y0
    # intial time
    @t = t0
    # final time
    @tf = tf
    # step size
    @h = step_size
    # round number counts from k = 0 to k = n
    @n = ((BigDecimal(@tf.to_s) - @t) / @h).to_i
    # derivative function
    @F = function
    @points = []
    puts "method: #{@method}"
    puts "start: y=#{@y}, t=#{@t}"
    puts "end: t=#{@tf}"
    puts "iterations (excluding initial): #{@n}"
    puts "step size: #{@h}"
  end

  def euler(y, t, h)
    return [t + h, y + @F.(t, y) * h]
  end

  def improved_euler(y, t, h)
    m = @F.(t, y)
    y1 = y + m * h
    t1 = t + h
    return [t + h, y + (m + @F.(t1, y1)) / 2 * h]
  end

  def rk4(y, t, h)
    m1 = @F.(t, y)
    m2 = @F.(t + h / 2.0, y + h * m1 / 2.0)
    m3 = @F.(t + h / 2.0, y + h * m2 / 2.0)
    m4 = @F.(t + h, y + h * m3)
    return [t + h, y + h * (m1 + 2 * m2 + 2 * m3 + m4) / 6]
  end

  def run(verbose: true, round: 13)
    @points.push([@t, @y])

    for i in 0...@n
      @t, @y = eval "#{@method} #{@y}, #{@t}, #{@h}"
      @points.push([@t, @y]) if verbose
    end

    if verbose
      @points.each_with_index do |e, i|
        puts "#{i}. #{e.map { |j| sprintf "%0.#{round}f", j.round(round) }.join ' '}"
      end
      return @points
    else
      puts sprintf("#{@n}. #{@t} %0.#{round}f", @y.round(round))
      return @y.round(round)
    end
    # note that sprintf rounds inconsistently as of 3.0.0
    # sprintf "%.1f", 123.25 # => 123.2
    # 123.25.round(1) # => 123.3
  end
end

# a = Approx.new(
#   function: ->(t, y) { -2 * t * y ** 2 },
#   t0: 0.3,
#   y0: 0.9174305975196,
#   step_size: 0.1,
#   method: Methods::RK4,
#   tf: 2.0
# )
#
# a.run(verbose: true, round: 6)
