function showNotification(message) {
    console.log("Showing notification");
    if (!("Notification" in window)) {
        console.log("This browser does not support desktop notifications.");
        return;
    }
    if (Notification.permission === "granted") {
        new Notification("Threshold alert",{ body: message });
        console.log("Finished Showing notification");
    } else if (Notification.permission !== "denied") {
        console.log("Requesting notification permission");
        Notification.requestPermission((permission => {
            console.log("User granted permission:", permission);
            if (permission === "granted") {
                new Notification("OfficeFlow", {body: "This is what future notifications will look like"});
            }
        })).then(r =>
            console.log("User granted permission")
        );
    } else {
        console.log("Notifications are blocked by the user.");
    }
}