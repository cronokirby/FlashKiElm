var {ipcRenderer} = require('electron')
var Elm = require('../elm/Main');
var container = document.getElementById('container');
var init = ipcRenderer.sendSync('GetInit');
var app = Elm.Main.embed(container, init);


app.ports.sendModel.subscribe(function(model){
    ipcRenderer.send('Store', model)
});


ipcRenderer.on('Save', event => {
    app.ports.onQuit.send(["Serialize"])
})
