const os = require('os');
const interfaces = os.networkInterfaces();
for (const name of Object.keys(interfaces)) {
    if (name.includes('Wi-Fi')) {
        for (const iface of interfaces[name]) {
            if ('IPv4' === iface.family && !iface.internal) {
                console.log(iface.address);
            }
        }
    }
}
