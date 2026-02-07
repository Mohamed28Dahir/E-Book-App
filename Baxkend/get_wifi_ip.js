const os = require('os');
const interfaces = os.networkInterfaces();

console.log("--- NETWORK INTERFACES ---");
for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name]) {
        if ('IPv4' === iface.family && !iface.internal) {
            console.log(`Interface: ${name}`);
        }
    }
}
console.log("--------------------------");
