
def main
  print "Input Rx, Ry: "
  input = gets().split(/[\s\,]/).collect{ |x| x.to_i}
  rx = input.first
  ry = input.last

  print "Input Xc, Yc: "
  input = gets().split(/[\s\,]/).collect{ |x| x.to_i}
  xc = input.first
  yc = input.last

  ellipse(rx, ry, xc, yc)
end

def hash_point k, x, y, ryx=nil, rxy=nil, region
  {
    k: k,
    x: x,
    y: y,
    ryx: ryx,
    rxy: rxy,
    region: region
  }
end

def ellipse rx, ry, x, y
  p1 = []
  p1 << ry**2 - (rx**2 * ry) + (0.25 * rx**2)

  k = 0
  points = []
  points << hash_point(0, 0, ry, 0, 0, 1)


  ryx = 2 * ry**2 * points.last[:x]
  rxy = 2 * rx**2 * points.last[:y]

  while (ryx < rxy)

    ryx = 2 * ry**2 * points.last[:x]
    rxy = 2 * rx**2 * points.last[:y]
    ryx_1 = 2 * ry**2 * points.last[:x] + 2 * ry ** 2
    rxy_1 = 2 * rx**2 * points.last[:y] + 2 * rx ** 2

    if p1.last < 0 and ryx < rxy
      p1 << p1.last + ryx_1 + ry**2
      points << hash_point(k, points.last[:x] + 1, points.last[:y], ryx, rxy, 1)
    elsif p1.last > 0 and ryx < rxy
      p1 << p1.last + ryx_1 - rxy_1 + ry**2
      points << hash_point(k, points.last[:x] + 1, points.last[:y] - 1, ryx, rxy, 1)
    end
    k += 1
  end


  p1 << ((ry ** 2) * ((points.last[:x] + 0.5) ** 2)) + ((rx ** 2) * ((points.last[:y] - 1) ** 2)) - ((rx ** 2) * (ry ** 2))

  while (points.last[:y] > 0)
    ryx = 2 * ry**2 * points.last[:x]
    rxy = 2 * rx**2 * points.last[:y]

    ryx_1 = 2 * ry**2 * points.last[:x] + 2 * ry ** 2
    rxy_1 = 2 * rx**2 * points.last[:y] + 2 * rx ** 2

    if p1.last < 0
      p1 << p1.last + ryx_1 - rxy + rx**2
      points << hash_point(k, points.last[:x] + 1, points.last[:y] - 1, ryx, rxy, 2)
    elsif p1.last > 0
      p1 << p1.last - rxy_1 + rx**2
      points << hash_point(k, points.last[:x], points.last[:y] - 1, ryx, rxy, 2)
    end
    k += 1
  end

  print " k |   pk  |  (x, y)  | 2ryx | 2rxy | region |\n"
  print "===|=======|==========|======|======|========|\n"
  points.zip(p1).each do |point, pk|
    print "#{"%2d" % point[:k]} | #{"%5d" % pk } | (#{"%2d" % point[:x]}, #{"%2d" % point[:y]}) | #{"%4d" % point[:ryx]} | #{"%4d" % point[:rxy]} |    #{point[:region]}   |\n"
  end


  array = []
  1.upto(4).each do |n_quadant|
    print "Quadant ##{n_quadant}\n"
    print "  (x, y)  \n"
    print "==========\n"
    points.each do |point|
      case n_quadant
      when 1
        array << [x  + point[:x], y + point[:y]]
        print "(#{"%2d" % (x  + point[:x])}, #{"%2d" % (y + point[:y])})\n"
      when 2
        array << [x  - point[:x], y + point[:y]]
        print "(#{"%2d" % (x -  point[:x])}, #{"%2d" % (y + point[:y])})\n"
      when 3
        array << [x  - point[:x], y - point[:y]]
        print "(#{"%2d" % (x - point[:x])}, #{"%2d" % (y - point[:y])})\n"
      when 4
        array << [x  + point[:x], y - point[:y]]
        print "(#{"%2d" % (x + point[:x])}, #{"%2d" % (y - point[:y])})\n"
      end
    end
    print "==============================\n\n"
  end

  min_point = array.flatten.min
  max_point = array.flatten.max
  plot_graph(min_point, max_point, array, x, y)
end

def plot_graph min_point, max_point, points, xc, yc

  print "   y\n"
  print "   |\n"
  max_point.downto(min_point).each do |y_axis|
    print "#{"%3d" % y_axis.abs}|"
    min_point.upto(max_point).each do |x_axis|
      if [x_axis, y_axis] == [xc, yc]
        print "O"
      elsif points.include? [x_axis, y_axis]
        print "O"
      elsif x_axis == 0
        print "|"
      elsif y_axis == 0
        print "-"
      else
        print "+"
      end
    end
    print "\n"
  end

  print "    "
  min_point.upto(max_point).each do |x_axis|
    print "-"
  end
  print "x\n    "
  min_point.upto(max_point).each do |x_axis|
    print "#{x_axis.abs % 10}"
  end
  print "\n"
end


if __FILE__ == $0
  main
end
