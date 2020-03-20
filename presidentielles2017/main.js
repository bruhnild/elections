// Configuration carte

mapboxgl.accessToken =
  "pk.eyJ1IjoibWFraW5hY29ycHVzIiwiYSI6ImNqY3E4ZTNwcTFta3ozMm80d2xzY29wM2MifQ.Nwl_FHrWAIQ46s_lY0KNiQ";

var map = new mapboxgl.Map({
  container: "map",
  style: "mapbox://styles/mapbox/light-v10", // stylesheet location
  center: [1.441, 43.5952], // lat/long
  zoom: 11.7, // Zoom
  pitch: 10, // Inclinaison
  bearing: 0 // Rotation
});

// Boutons 2D et 3D

var toggleableLayers = [
  {
    id: 0,
    isActive: true,
    label: "2D",
    layers: ["voteparticipation"]
  },
  {
    id: 1,
    isActive: false,
    label: "3D",
    layers: ["voteparticipation3d"]
  }
];

// Activation des fonctions au chargement de la carte

map.on("load", function() {
  addSources();
  addLayers();
  initMap();
  createMenu();
});

function addSources() {
  // Ajout de la source postgis avec martin : https://visu-tiles.makina-corpus.net/index.json

  map.addSource("citoyennete.cartepresidentielles2017toulouse", {
    type: "vector",
    tiles: [
      // 'https://visu-tiles.makina-corpus.net/citoyennete.citoyennete.cartepresidentielles2017toulouse/{z}/{x}/{y}.pbf'
      "https://visu-tiles.makina-corpus.net/citoyennete.cartepresidentielles2017toulouse/{z}/{x}/{y}.pbf"
    ]
  });

  // Ajout de la source mapbox

  // map.addSource('citoyennete.cartepresidentielles2017toulouse', {
  // type: 'vector',
  // url: 'mapbox://makinacorpus.2opxkter'});
}

// Ajout des couches

function addLayers() {
  var layers = map.getStyle().layers;

  var labelLayerId;
  for (var i = 0; i < layers.length; i++) {
    if (layers[i].type === "symbol" && layers[i].layout["text-field"]) {
      labelLayerId = layers[i].id;
      break;
    }
  }

  // Vote participation 2D
  map.addLayer({
    id: "voteparticipation",
    type: "fill",
    source: "citoyennete.cartepresidentielles2017toulouse",
    "source-layer": "citoyennete.cartepresidentielles2017toulouse",
    layout: { visibility: "visible" },
    paint: {
      "fill-color": [
        "case",
        ["has", "pourcentage_participation"],
        [
          "case",
          ["<", ["get", "pourcentage_participation"], 0],
          "#fcfbfd",
          ["<", ["get", "pourcentage_participation"], 55],
          "#e4e3f0",
          ["<", ["get", "pourcentage_participation"], 65],
          "#babbdb",
          ["<", ["get", "pourcentage_participation"], 73],
          "#8c88c0",
          ["<", ["get", "pourcentage_participation"], 77],
          "#63439c",
          ["<", ["get", "pourcentage_participation"], 85],
          "#3f007d",
          "#b10026"
        ],
        "#fff"
      ],
      "fill-opacity": 0.5,
      "fill-outline-color": "white"
    }
  });

  // Vote participation 3D

  map.addLayer({
    id: "voteparticipation3d",
    type: "fill-extrusion",
    source: "citoyennete.cartepresidentielles2017toulouse",
    "source-layer": "citoyennete.cartepresidentielles2017toulouse",
    layout: { visibility: "none" },
    paint: {
      "fill-extrusion-color": [
        "case",
        ["has", "pourcentage_participation"],
        [
          "case",
          ["<", ["get", "pourcentage_participation"], 0],
          "#fcfbfd",
          ["<", ["get", "pourcentage_participation"], 55],
          "#e4e3f0",
          ["<", ["get", "pourcentage_participation"], 65],
          "#babbdb",
          ["<", ["get", "pourcentage_participation"], 73],
          "#8c88c0",
          ["<", ["get", "pourcentage_participation"], 77],
          "#63439c",
          ["<", ["get", "pourcentage_participation"], 85],
          "#3f007d",
          "#b10026"
        ],
        "#fff"
      ],
      "fill-extrusion-opacity": 0.5,
      "fill-extrusion-height": [
        "case",
        ["has", "pourcentage_participation"],
        [
          "case",
          ["<", ["get", "pourcentage_participation"], 0],
          0,
          ["<", ["get", "pourcentage_participation"], 55],
          100,
          ["<", ["get", "pourcentage_participation"], 65],
          300,
          ["<", ["get", "pourcentage_participation"], 73],
          500,
          ["<", ["get", "pourcentage_participation"], 77],
          700,
          ["<", ["get", "pourcentage_participation"], 85],
          900,
          600
        ],
        500
      ]
    }
  });

  // Candidats gagnants 2D

  map.addLayer({
    id: "candidatgagnant",
    type: "fill",
    source: "citoyennete.cartepresidentielles2017toulouse",
    "source-layer": "citoyennete.cartepresidentielles2017toulouse",
    layout: { visibility: "none" },
    paint: {
      "fill-color": ["get", "couleur"],
      "fill-opacity": 0.5,
      "fill-outline-color": "white"
    }
  });

  // Candidats gagnants 3D

  map.addLayer({
    id: "candidatgagnant3d",
    type: "fill-extrusion",
    source: "citoyennete.cartepresidentielles2017toulouse",
    "source-layer": "citoyennete.cartepresidentielles2017toulouse",
    layout: { visibility: "none" },
    paint: {
      "fill-extrusion-color": ["get", "couleur"],
      "fill-extrusion-opacity": 0.5,
      "fill-extrusion-height": [
        "case",
        ["has", "pourcentage_participation"],
        [
          "case",
          ["<", ["get", "pourcentage_participation"], 0],
          0,
          ["<", ["get", "pourcentage_participation"], 55],
          100,
          ["<", ["get", "pourcentage_participation"], 65],
          300,
          ["<", ["get", "pourcentage_participation"], 73],
          500,
          ["<", ["get", "pourcentage_participation"], 77],
          700,
          ["<", ["get", "pourcentage_participation"], 85],
          900,
          600
        ],
        500
      ],
      "fill-extrusion-base": 0
    }
  });

  // MACRON 2D

  map.addLayer({
    id: "macron",
    type: "fill",
    source: "citoyennete.cartepresidentielles2017toulouse",
    "source-layer": "citoyennete.cartepresidentielles2017toulouse",
    layout: { visibility: "none" },
    paint: {
      "fill-color": [
        "case",
        ["has", "nb_voix_3_participation"],
        [
          "case",

          ["<", ["get", "nb_voix_3_participation"], 13.6],
          "#FFB400",
          ["<", ["get", "nb_voix_3_participation"], 25],
          "#F2B100",
          ["<", ["get", "nb_voix_3_participation"], 26.5],
          "#E4A700",
          ["<", ["get", "nb_voix_3_participation"], 28],
          "#C99400",
          ["<", ["get", "nb_voix_3_participation"], 29.5],
          "#AF8000",
          ["<", ["get", "nb_voix_3_participation"], 40],
          "#946C00",
          "#b10026"
        ],
        "#fff"
      ],
      "fill-opacity": 0.5,
      "fill-outline-color": "white"
    }
  });

  // MACRON 3D

  map.addLayer({
    id: "macron3d",
    type: "fill-extrusion",
    source: "citoyennete.cartepresidentielles2017toulouse",
    "source-layer": "citoyennete.cartepresidentielles2017toulouse",
    layout: { visibility: "none" },
    paint: {
      "fill-extrusion-color": [
        "case",
        ["has", "nb_voix_3_participation"],
        [
          "case",

          ["<", ["get", "nb_voix_3_participation"], 13.6],
          "#FFB400",
          ["<", ["get", "nb_voix_3_participation"], 25],
          "#F2B100",
          ["<", ["get", "nb_voix_3_participation"], 26.5],
          "#E4A700",
          ["<", ["get", "nb_voix_3_participation"], 28],
          "#C99400",
          ["<", ["get", "nb_voix_3_participation"], 29.5],
          "#AF8000",
          ["<", ["get", "nb_voix_3_participation"], 40],
          "#946C00",
          "#b10026"
        ],
        "#fff"
      ],
      "fill-extrusion-opacity": 0.5,
      "fill-extrusion-height": [
        "case",
        ["has", "nb_voix_3_participation"],
        [
          "case",
          ["<", ["get", "nb_voix_3_participation"], 13.6],
          0,
          ["<", ["get", "nb_voix_3_participation"], 25],
          100,
          ["<", ["get", "nb_voix_3_participation"], 26.5],
          300,
          ["<", ["get", "nb_voix_3_participation"], 28],
          500,
          ["<", ["get", "nb_voix_3_participation"], 29.5],
          700,
          ["<", ["get", "nb_voix_3_participation"], 40],
          900,
          600
        ],
        500
      ]
    }
  });

  // MELANCHON 2D

  map.addLayer({
    id: "melanchon",
    type: "fill",
    source: "citoyennete.cartepresidentielles2017toulouse",
    "source-layer": "citoyennete.cartepresidentielles2017toulouse",
    layout: { visibility: "none" },
    paint: {
      "fill-color": [
        "case",
        ["has", "nb_voix_9_participation"],
        [
          "case",

          ["<", ["get", "nb_voix_9_participation"], 21.5],
          "#af3045",
          ["<", ["get", "nb_voix_9_participation"], 26.2],
          "#B01832",
          ["<", ["get", "nb_voix_9_participation"], 28.9],
          "#B1273E",
          ["<", ["get", "nb_voix_9_participation"], 31.1],
          "#B14658",
          ["<", ["get", "nb_voix_9_participation"], 34.8],
          "#B26572",
          ["<", ["get", "nb_voix_9_participation"], 56],
          "#B3848C",
          "#b10026"
        ],
        "#fff"
      ],
      "fill-opacity": 0.5,
      "fill-outline-color": "white"
    }
  });

  // MELANCHON 3D

  map.addLayer({
    id: "melanchon3d",
    type: "fill-extrusion",
    source: "citoyennete.cartepresidentielles2017toulouse",
    "source-layer": "citoyennete.cartepresidentielles2017toulouse",
    layout: { visibility: "none" },
    paint: {
      "fill-extrusion-color": [
        "case",
        ["has", "nb_voix_9_participation"],
        [
          "case",

          ["<", ["get", "nb_voix_9_participation"], 21.5],
          "#af3045",
          ["<", ["get", "nb_voix_9_participation"], 26.2],
          "#B01832",
          ["<", ["get", "nb_voix_9_participation"], 28.9],
          "#B1273E",
          ["<", ["get", "nb_voix_9_participation"], 31.1],
          "#B14658",
          ["<", ["get", "nb_voix_9_participation"], 34.8],
          "#B26572",
          ["<", ["get", "nb_voix_9_participation"], 56],
          "#B3848C",
          "#b10026"
        ],
        "#fff"
      ],
      "fill-extrusion-opacity": 0.5,
      "fill-extrusion-height": [
        "case",
        ["has", "nb_voix_9_participation"],
        [
          "case",

          ["<", ["get", "nb_voix_9_participation"], 21.5],
          0,
          ["<", ["get", "nb_voix_9_participation"], 26.2],
          100,
          ["<", ["get", "nb_voix_9_participation"], 28.9],
          300,
          ["<", ["get", "nb_voix_9_participation"], 31.1],
          500,
          ["<", ["get", "nb_voix_9_participation"], 34.8],
          700,
          ["<", ["get", "nb_voix_9_participation"], 56],
          900,
          600
        ],
        500
      ]
    }
  });

  // FILLON 2D

  map.addLayer({
    id: "fillon",
    type: "fill",
    source: "citoyennete.cartepresidentielles2017toulouse",
    "source-layer": "citoyennete.cartepresidentielles2017toulouse",
    layout: { visibility: "none" },
    paint: {
      "fill-color": [
        "case",
        ["has", "nb_voix_11_participation"],
        [
          "case",

          ["<", ["get", "nb_voix_11_participation"], 10.4],
          "#3d68c6",
          ["<", ["get", "nb_voix_11_participation"], 12.7],
          "#2457C4",
          ["<", ["get", "nb_voix_11_participation"], 14.8],
          "#3360C2",
          ["<", ["get", "nb_voix_11_participation"], 17.7],
          "#5072BD",
          ["<", ["get", "nb_voix_11_participation"], 23.6],
          "#6B83B8",
          ["<", ["get", "nb_voix_11_participation"], 50],
          "#8493B3",
          "#b10026"
        ],
        "#fff"
      ],
      "fill-opacity": 0.5,
      "fill-outline-color": "white"
    }
  });

  // FILLON 3D

  map.addLayer({
    id: "fillon3d",
    type: "fill-extrusion",
    source: "citoyennete.cartepresidentielles2017toulouse",
    "source-layer": "citoyennete.cartepresidentielles2017toulouse",
    layout: { visibility: "none" },
    paint: {
      "fill-extrusion-color": [
        "case",
        ["has", "nb_voix_11_participation"],
        [
          "case",

          ["<", ["get", "nb_voix_11_participation"], 10.4],
          "#3d68c6",
          ["<", ["get", "nb_voix_11_participation"], 12.7],
          "#2457C4",
          ["<", ["get", "nb_voix_11_participation"], 14.8],
          "#3360C2",
          ["<", ["get", "nb_voix_11_participation"], 17.7],
          "#5072BD",
          ["<", ["get", "nb_voix_11_participation"], 23.6],
          "#6B83B8",
          ["<", ["get", "nb_voix_11_participation"], 50],
          "#8493B3",
          "#b10026"
        ],
        "#fff"
      ],
      "fill-extrusion-opacity": 0.5,
      "fill-extrusion-height": [
        "case",
        ["has", "nb_voix_11_participation"],
        [
          "case",

          ["<", ["get", "nb_voix_11_participation"], 10.4],
          0,
          ["<", ["get", "nb_voix_11_participation"], 12.7],
          100,
          ["<", ["get", "nb_voix_11_participation"], 14.8],
          300,
          ["<", ["get", "nb_voix_11_participation"], 17.7],
          500,
          ["<", ["get", "nb_voix_11_participation"], 23.6],
          700,
          ["<", ["get", "nb_voix_11_participation"], 50],
          900,
          600
        ],
        500
      ]
    }
  });
}

// Configuration affichage boutons couches

document.getElementById("1").addEventListener("click", function() {
  map.flyTo({
    zoom: 11.7,
    center: [1.441, 43.5952],
    pitch: 10,
    bearing: 0
  });
  map.setLayoutProperty("voteparticipation", "visibility", "visible");
  map.setLayoutProperty("voteparticipation3d", "visibility", "none");
  map.setLayoutProperty("candidatgagnant", "visibility", "none");
  map.setLayoutProperty("candidatgagnant3d", "visibility", "none");
  map.setLayoutProperty("macron", "visibility", "none");
  map.setLayoutProperty("macron3d", "visibility", "none");
  map.setLayoutProperty("fillon", "visibility", "none");
  map.setLayoutProperty("fillon3d", "visibility", "none");
  map.setLayoutProperty("melanchon", "visibility", "none");
  map.setLayoutProperty("melanchon3d", "visibility", "none");
});

document.getElementById("2").addEventListener("click", function() {
  map.flyTo({
    zoom: 11.7,
    center: [1.441, 43.5952],
    pitch: 10,
    bearing: 0
  });
  map.setLayoutProperty("voteparticipation", "visibility", "none");
  map.setLayoutProperty("voteparticipation3d", "visibility", "none");
  map.setLayoutProperty("candidatgagnant", "visibility", "visible");
  map.setLayoutProperty("candidatgagnant3d", "visibility", "none");
  map.setLayoutProperty("macron", "visibility", "none");
  map.setLayoutProperty("macron3d", "visibility", "none");
  map.setLayoutProperty("fillon", "visibility", "none");
  map.setLayoutProperty("fillon3d", "visibility", "none");
  map.setLayoutProperty("melanchon", "visibility", "none");
  map.setLayoutProperty("melanchon3d", "visibility", "none");
});

document.getElementById("3").addEventListener("click", function() {
  map.flyTo({
    zoom: 11.7,
    center: [1.441, 43.5952],
    pitch: 10,
    bearing: 0
  });
  map.setLayoutProperty("voteparticipation", "visibility", "none");
  map.setLayoutProperty("voteparticipation3d", "visibility", "none");
  map.setLayoutProperty("candidatgagnant", "visibility", "none");
  map.setLayoutProperty("candidatgagnant3d", "visibility", "none");
  map.setLayoutProperty("macron", "visibility", "visible");
  map.setLayoutProperty("macron3d", "visibility", "none");
  map.setLayoutProperty("fillon", "visibility", "none");
  map.setLayoutProperty("fillon3d", "visibility", "none");
  map.setLayoutProperty("melanchon", "visibility", "none");
  map.setLayoutProperty("melanchon3d", "visibility", "none");
});

document.getElementById("4").addEventListener("click", function() {
  map.flyTo({
    zoom: 11.7,
    center: [1.441, 43.5952],
    pitch: 10,
    bearing: 0
  });
  map.setLayoutProperty("voteparticipation", "visibility", "none");
  map.setLayoutProperty("voteparticipation3d", "visibility", "none");
  map.setLayoutProperty("candidatgagnant", "visibility", "none");
  map.setLayoutProperty("candidatgagnant3d", "visibility", "none");
  map.setLayoutProperty("macron", "visibility", "none");
  map.setLayoutProperty("macron3d", "visibility", "none");
  map.setLayoutProperty("fillon", "visibility", "visible");
  map.setLayoutProperty("fillon3d", "visibility", "none");
  map.setLayoutProperty("melanchon", "visibility", "none");
  map.setLayoutProperty("melanchon3d", "visibility", "none");
});

document.getElementById("5").addEventListener("click", function() {
  map.flyTo({
    zoom: 11.7,
    center: [1.441, 43.5952],
    pitch: 10,
    bearing: 0
  });
  map.setLayoutProperty("voteparticipation", "visibility", "none");
  map.setLayoutProperty("voteparticipation3d", "visibility", "none");
  map.setLayoutProperty("candidatgagnant", "visibility", "none");
  map.setLayoutProperty("candidatgagnant3d", "visibility", "none");
  map.setLayoutProperty("macron", "visibility", "none");
  map.setLayoutProperty("macron3d", "visibility", "none");
  map.setLayoutProperty("fillon", "visibility", "none");
  map.setLayoutProperty("fillon3d", "visibility", "none");
  map.setLayoutProperty("melanchon", "visibility", "visible");
  map.setLayoutProperty("melanchon3d", "visibility", "none");
});

// Ajoute les couches actives en 3D

function add3D(e) {
  e.preventDefault();
  e.stopPropagation();

  map.flyTo({
    zoom: 11.7,
    center: [1.441, 43.5952],
    pitch: 50,
    bearing: 20
  });

  toggleableLayers.forEach(function(toggleableLayer) {
    if ("toggleableLayer" + toggleableLayer.id === e.target.id) {
      toggleableLayer.isActive = !toggleableLayer.isActive;
      toggleableLayer.layers.forEach(function(layer) {
        map.setLayoutProperty(
          layer,
          "visibility",
          toggleableLayer.isActive ? "visible" : "none"
        );
      });

      this.className = toggleableLayer.isActive ? "active" : "";
      return;
    }
  });

  map.setLayoutProperty("voteparticipation", "visibility", "none");
  map.setLayoutProperty("voteparticipation3d", "visibility", "visible");
  map.setLayoutProperty("candidatgagnant", "visibility", "none");
  map.setLayoutProperty("candidatgagnant3d", "visibility", "visible");
  map.setLayoutProperty("macron", "visibility", "none");
  map.setLayoutProperty("macron3d", "visibility", "visible");
  map.setLayoutProperty("fillon", "visibility", "none");
  map.setLayoutProperty("fillon3d", "visibility", "visible");
  map.setLayoutProperty("melanchon", "visibility", "none");
  map.setLayoutProperty("melanchon3d", "visibility", "visible");
}

// Enlève la 3D

function remove3D(e) {
  e.preventDefault();
  e.stopPropagation();

  map.flyTo({
    zoom: 11.7,
    center: [1.441, 43.5952],
    pitch: 10,
    bearing: 0
  });

  toggleableLayers.forEach(function(toggleableLayer) {
    if ("toggleableLayer" + toggleableLayer.id === e.target.id) {
      toggleableLayer.isActive = !toggleableLayer.isActive;
      toggleableLayer.layers.forEach(function(layer) {
        map.setLayoutProperty(
          layer,
          "visibility",
          toggleableLayer.isActive ? "visible" : "none"
        );
      });

      this.className = toggleableLayer.isActive ? "active" : "";
      return;
    }
  });

  map.setLayoutProperty("voteparticipation", "visibility", "visible");
  map.setLayoutProperty("voteparticipation3d", "visibility", "none");
  map.setLayoutProperty("candidatgagnant", "visibility", "visible");
  map.setLayoutProperty("candidatgagnant3d", "visibility", "none");
  map.setLayoutProperty("macron", "visibility", "visible");
  map.setLayoutProperty("macron3d", "visibility", "none");
  map.setLayoutProperty("fillon", "visibility", "visible");
  map.setLayoutProperty("fillon3d", "visibility", "none");
  map.setLayoutProperty("melanchon", "visibility", "visible");
  map.setLayoutProperty("melanchon3d", "visibility", "none");
}

// Crée le menu toggleable

function createMenu() {
  for (var i = 0; i < toggleableLayers.length; i++) {
    var toggleableLayer = toggleableLayers[i];

    var link = document.createElement("a");
    link.href = "#";
    link.className = toggleableLayer.isActive ? "active" : "";
    link.textContent = toggleableLayer.label;
    link.id = "toggleableLayer" + i;
    link.onclick = toggleableLayer.id === 0 ? remove3D : add3D;

    var layers = document.getElementById("menu");
    layers.appendChild(link);
  }
}

// Ajout boutons de carte, échelle et popup

function initMap() {
  //Ajout échelle cartographique
  map.addControl(
    new mapboxgl.ScaleControl({
      maxWidth: 120,
      unit: "metric"
    })
  );

  //Ajout boutons de controle

  var nav = new mapboxgl.NavigationControl();
  map.addControl(nav, "top-right");

  // Configuration fenêtre d'informations
  map.on("mousemove", function(e) {
    var popup = map.queryRenderedFeatures(e.point, {
      layers: [
        "voteparticipation",
        "candidatgagnant",
        "macron",
        "fillon",
        "melanchon"
      ]
    });
    if (popup.length > 0) {
      document.getElementById("bv").innerHTML =
        '<div style="text-align: center;"><span style="font-family: trebuchet ms, sans-serif;"><font size="2"><b>' +
        popup[0].properties.nom +
        '<div style="text-align: center;"><span style="font-family: trebuchet ms, sans-serif;"><font size="1"><font size="1">' +
        " (n°" +
        popup[0].properties.bv2017 +
        ")" +
        "</font></b></font></span></div>";
      createGraph(popup[0].properties);
    }
  });
}

//Créer le graphique

function createGraph(data, backgroundColor) {
  var horizontalBarChartData = {
    labels: ["Macron", "Fillon", "Mélenchon"],
    datasets: [
      {
        label: "Participation : " + data.pourcentage_participation + "%",
        backgroundColor: [
          data.candidat_9_couleur,
          data.candidat_3_couleur,
          data.candidat_11_couleur
        ],
        barPercentage: 1.0,
        borderColor: [
          data.candidat_9_couleur,
          data.candidat_3_couleur,
          data.candidat_11_couleur
        ],
        borderWidth: 1,
        data: [
          data.nb_voix_9_participation,
          data.nb_voix_3_participation,
          data.nb_voix_11_participation
        ]
      }
    ]
  };

  var ctx = document.getElementById("canvas").getContext("2d");
  window.myHorizontalBar = new Chart(ctx, {
    type: "horizontalBar",
    data: horizontalBarChartData,
    options: {
      // Elements options apply to all of the options unless overridden in a dataset
      // In this case, we are setting the border of each horizontal bar to be 2px wide
      elements: {
        rectangle: {
          borderWidth: 2,
          hoverBorderColor: true,
          hoverBackgroundColor: true
        }
      },
      responsive: true,
      legend: {
        position: "bottom"
      },

      title: {
        display: true
      },
      scales: {
        xAxes: [
          {
            ticks: {
              min: 0, // Edit the value according to what you need
              max: 100,
              display: false
            },
            gridLines: { display: false }
          }
        ],
        yAxes: [
          {
            stacked: true,
            gridLines: { display: false }
          }
        ]
      }
    }
  });
}
