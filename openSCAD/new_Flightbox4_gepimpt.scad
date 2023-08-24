//**** Deklaration
//Innenmasse in mm
base_height = 100;  // Höhe in mm
lid_height = 400;   // Höhe in mm
length = 480;       //länge innenmaß in mm
width = 580;        //breite innenmaß in mm
explode = 50;       //ersatz fürExplosionsansicht
profil_nummer = 0;  // Default-Wert, falls keine Nummer übergeben wird
//****Profildeklaration

//Profiltypen ohne Gewähr
profils = [
    ["Adam Hall 6136",17,10.6,1.2,4,"",4],
    ["Adam Hall 6137",18,11.1,1.2,4.5,"",2.5],
    ["Adam Hall 6129",22,12,1.5,7,"",2.5],
    ["Adam Hall 6106",30,20,1.5,7,"",2.5],
    ["Adam Hall 6107",30,17,1.5,9.5,"",2.5],
    ["Adam Hall 6119",30,16,1.5,10,"",2.5]
];
profil = profils[profil_nummer];
//****Deklaration ENDE



//kalkulationen und umwandlungen um den Code besser lesbar zu halten
schenkellength = profil[1];         // Schenkellänge in mm
reduction = profil[2];              //Einschubtiefe
materialthickness = profil[3];      // Materialstärke in mm
thickness = profil[4];              // Dicke in mm (4mm)
profiloffset = schenkellength - reduction; //offset für Profile
walloffset = profiloffset - materialthickness - thickness; //offset für Platten


//Aluprofil erstellen
module casemaker(height){
    strecke = [0,materialthickness,materialthickness+thickness,materialthickness*2+thickness,schenkellength];
    //<--!für rundung
    rotation=180;
    segments=90;
    radius = profil[6];
    //-->|
    points=[
        [strecke[0], radius],
        for (a = [rotation : 9 : segments + rotation]) [ radius + radius * cos(a), radius + radius * sin(a) ],
        [radius, strecke[0]],
        [strecke[4], strecke[0]],
        [strecke[4], strecke[1]],
        [profiloffset, strecke[1]],//strecke[3]
        [profiloffset, strecke[2]],//strecke[3]
        [strecke[4], strecke[2]],
        [strecke[4], strecke[3]],
        [strecke[3], strecke[3]],
        [strecke[3], strecke[4]],
        [strecke[2], strecke[4]],
        [strecke[2], profiloffset],//strecke[3]
        [strecke[1], profiloffset],//strecke[3]
        [strecke[1], strecke[4]],
        [strecke[0], strecke[4]]
    ];
    if(height > 0)  {
        color("blue", 0.4) linear_extrude(height, convexity=10) polygon(points);   
        echo(str("Aluprofil vom Typ: ",profil[0]," in der Länge ",height,"mm"));
        }
    else color("grey") polygon(points);     
}


module walls( height, explode)
    {
    for(i=[0,180]) rotate([0,0,i]) translate([0,length/2 + thickness/2 + explode, height/2]) cube([width,thickness,height], center = true);
    echo(str("2x Front: LxHxT ",width,"x",height,"x",thickness,"mm"));
    for(i=[90,270]) rotate([0,0,i]) translate([0,width/2 + thickness/2 + explode, height/2]) cube([length,thickness,height], center = true);
    echo(str("2x Seite: LxHxT ",length,"x",height,"x",thickness,"mm"));
    }
module lid(height, explode)
    {
    translate([0,0,height + thickness/2 + explode]) cube([width,length,thickness], center = true);
    echo(str("1x Deckplatte: LxHxT ",width,"x",length,"x",thickness,"mm"));
    }
module wall_profile(height, explode){
    for(i = [0,180]) rotate([0,0,i]) translate([-width/2 - explode,-length/2 - explode,0])casemaker(height-reduction);
    for(i = [90,270]) rotate([0,0,i]) translate([-length/2 - explode,-width/2 - explode,0])casemaker(height-reduction);
    }
module lid_profile(height, explode){
    for (i = [0,180])rotate([i,90,0]) translate([-(height + explode), - (length/2 + explode), -width/2 + reduction]) casemaker(width-reduction*2);
    for (i = [90,270])rotate([i,90,0]) translate([-(height + explode), - (width/2 + explode), -length/2 + reduction]) casemaker(length-reduction*2);
    }
    
module create_half_flightcase(height){    
    walls       (height, explode + walloffset);
    lid         (height, explode + walloffset);
    wall_profile(height, explode + profiloffset);
    lid_profile (height, explode + profiloffset);
}
echo(str("Beginne Shoppingliste Teil 1"));
translate([0,0,explode/2]) create_half_flightcase(lid_height);
echo(str("Beginne Shoppingliste Teil 2"));
mirror([0,0,1]) translate([0,0,explode/2]) create_half_flightcase(base_height);
echo(str("Alle Angaben ohne Gewähr"));

