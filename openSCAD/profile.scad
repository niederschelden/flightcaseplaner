//**** Deklaration

profils = [
    ["Adam Hall 6136",17,10.6,1.2,4,"",4],
    ["Adam Hall 6137",18,11.1,1.2,4.5,"",2.5],
    ["Adam Hall 6129",22,12,1.5,7,"",2.5],
    ["Adam Hall 6106",30,20,1.5,7,"",2.5],
    ["Adam Hall 6107",30,17,1.5,9.5,"",2.5],
    ["Adam Hall 6119",30,16,1.5,10,"",2.5]
];

profil_nummer = 0;  // Default-Wert, falls keine Nummer übergeben wird

profil = profils[profil_nummer];

//**** Deklaration ENDE

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
        for (a = [rotation : segments + rotation]) [ radius + radius * cos(a), radius + radius * sin(a) ],
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
casemaker(0);