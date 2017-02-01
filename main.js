'use strict'
const electron = require('electron')

const app = electron.app // this is our app
const BrowserWindow = electron.BrowserWindow // This is a Module that creates windows
const ipcMain = electron.ipcMain

const fs = require('fs')

let mainWindow // saves a global reference to mainWindow so it doesn't get garbage collected
let closing = false
app.on('ready', createWindow) // called when electron has initialized

// This will create our app window, no surprise there
function createWindow () {
  mainWindow = new BrowserWindow({
    width: 1024,
    height: 768
  }
)

  // display the index.html file
  mainWindow.loadURL(`file://${ __dirname }/src/static/index.html`)

  mainWindow.on('close', event => {
      if (closing === false) {
          closing = true;
          event.preventDefault();
          mainWindow.webContents.send('Save');
      }

 });
  // open dev tools by default so we can see any console errors
  mainWindow.webContents.openDevTools()
  mainWindow.on('closed', function () {
    mainWindow = null
  })
}

/* Mac Specific things */
// when you close all the windows on a non-mac OS it quits the app
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
      app.quit();
       }
})

// if there is no mainWindow it creates one (like when you click the dock icon)
app.on('activate', () => {
  if (mainWindow === null) { createWindow(); }


})

ipcMain.on('GetInit', event => {
    if(!fs.existsSync('dist/model.json')) {
        var fd = fs.openSync('src/static/defaultModel.json', 'r');
        var json = fs.readFileSync(fd);
        fs.writeFileSync('dist/model.json', json);
        }
    var fp = fs.openSync('dist/model.json', 'r');
    var model = JSON.parse(fs.readFileSync(fp));
    event.returnValue = model;

});


ipcMain.on('Store', (event, arg) => {
    var json = JSON.stringify(arg).toString();
    console.log(json);
    fs.writeFileSync('dist/model.json', json);
    app.quit();
})
