module.exports = {
    "presets": [
        ["@babel/preset-env", { "targets": { "node": "current" } }],    
        [
          "babel-preset-vite",
          {
            "env": true,
            "glob": false
          }
        ]
      ]
};
