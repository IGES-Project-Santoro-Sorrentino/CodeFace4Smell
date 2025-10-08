// Handler for refresh button - reloads the page when projects list is updated
Shiny.addCustomMessageHandler("reloadPage", function (message) {
    console.log("Reloading page to show updated projects list...");
    window.location.reload();
});
