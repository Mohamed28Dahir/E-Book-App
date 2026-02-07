const os = require('os');
const interfaces = os.networkInterfaces();
let ipAddress = 'localhost';

for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name]) {
        // Skip internal (i.e. 127.0.0.1) and non-ipv4 addresses
        if ('IPv4' !== iface.family || iface.internal) {
            continue;
        }
        ipAddress = iface.address;
        console.log(`Found IP: ${ipAddress} (${name})`);
    }
}
