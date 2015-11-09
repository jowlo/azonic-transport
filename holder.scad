echo(version=version());

module pie_slice(radius, angle, step) {
	for(theta = [0:step:angle-step]) {
		rotate([0,0,0])
		linear_extrude(height = radius*2, center=true)
		polygon( 
			points = [
				[0,0],
				[radius * cos(theta+step) ,radius * sin(theta+step)],
				[radius*cos(theta),radius*sin(theta)]
			] 
		);
	}
}

module partial_rotate_extrude(angle, radius, convex) {
	intersection () {
		rotate_extrude(convexity=convex) translate([radius,0,0]) children(0);
		pie_slice(radius*2, angle, angle/5);
	}
}

module clip(clip_off, clip_thick) {
              union(){
            translate([clip_off+clip_thick/2,1.5*clip_thick])
                    circle(r=clip_thick/2, $fn=40);
          difference(){
                polygon([
                    [0,-clip_thick*2], [clip_off+clip_thick-clip_thick/1.5,0], [clip_thick+clip_off,0],
                    [clip_off+clip_thick,1.5*clip_thick],
                    [0,1.5*clip_thick]
                ]);
              
                translate([0.75*(clip_off+clip_thick),-3*clip_off]){
                    color("red")
                        scale([1,2,1])
                            circle(1.5*clip_off, $fn=40);
                }
              
                translate([clip_off/2,1.5*clip_thick])
                    circle(r=clip_off/2, $fn=40);
                    translate([clip_off,0])
                    difference(){
                        translate([clip_thick-clip_thick/1.5,-1])
                            square(2*clip_thick);
                        translate([clip_thick-clip_thick/1.5,2*(clip_thick/1.5)])
                            scale([1,2,1])
                                circle(r=clip_thick/1.5, $fn=40);
                    }
                
                }
                
          }
}

module clips(clip_off,clip_hoff,clip_thick){
     translate([0,0,clip_hoff])
            partial_rotate_extrude(30, inner_d/2 + width, $fn=40)
                clip(clip_off, clip_thick);
     translate([0,0,-clip_hoff])
            rotate([0,0,180])
                partial_rotate_extrude(30, inner_d/2 + width, 20, $fn=40)
                    mirror([0,1,0]) clip(clip_off, clip_thick);     

}    


module cylinder(inner_d, width, inset, inset_height, inset_off){
    rotate_extrude($fn=50)
        translate([inner_d/2, 0])
            union() {
            polygon([
            [0,height/2], [width,height/2],
            [width,-height/2], [0, -height/2],
            [0,-inset_height/2 -inset_off], [-inset,-inset_height/2],
            [-inset, inset_height/2 - inset_off], [0,inset_height/2],
            ]);
            translate([width/2,height/2])
                circle(r=width/2, $fn=20);
            translate([width/2,-height/2])
                circle(r=width/2, $fn=20);
            }    
    }

            

    
height = 34;
width = 3;
inset = 2;
inset_height=10;
inset_off = 1;
inner_d = 29;
    
clip_off = 3;
clip_thick = 2;

clip_hoff = height/2-2*clip_thick;
    
    union(){
        clips(clip_off,clip_hoff,clip_thick);
        cylinder(inner_d, width, inset, inset_height, inset_off);
    }
    
    clip(clip_off,clip_thick);
