module JS

using Compose

# Scripts for individual frames

framedata(line, proportion) =
  jscall("""
    data("lineinfo", {"func": "$(line.func)",
                      "file": "$(line.file)",
                      "line": "$(line.line)",
                      "percent": "$(@sprintf("%.2f", 100*proportion))"});
  """)

const frametooltip =
  jscall("""
    hover(function(){ updatetooltip(this.data("lineinfo")); },
          function(){ updatetooltip(); });
  """)

# SVG JS

const mapzoom =
  jscall("""
    node.addEventListener("mousewheel", function(event) {
      event.preventDefault();
      event.stopPropagation();

      var e = Snap(this);
      var scale = Math.pow(0.9, event.wheelDelta/100);
      var transform = e.transform().localMatrix;
      var inverse = e.transform().globalMatrix.invert();
      var x = event.clientX; var y = event.clientY;

      e.transform(transform.scale(scale, scale, inverse.x(x, y), inverse.y(x, y)));
    });
  """)

const mapdrag =
  jscall("""
    drag(
      function(dx, dy) {
        var newdx = dx, newdy = dy;
        var olddx = this.data("dx"), olddy = this.data("dy");
        dx = newdx - olddx; dy = newdy - olddy;
        this.data("dx", newdx); this.data("dy", newdy);
        var transform = this.transform().localMatrix;
        var global = this.transform().globalMatrix.split();
        scalex = global.scalex; scaley = global.scaley;
        this.transform(transform.translate(dx/scalex, dy/scaley));
      },
      function() {
        this.data("dx", 0); this.data("dy", 0);
      });
  """)

nothing

end
