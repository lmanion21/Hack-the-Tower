TO RUN YATE FROM FEDORA AFTER INSTALLATION

1.) Ensure that the BladeRF is connected. Just plug in the box via the provided
USB cable, and type 'dmesg' into the terminal to check. You should see
manufacturer (Nuand) and device (BladeRF) information appear.

2.) To check the settings via the web application type in the ip address that
your web interface is configured to followed by 'nib'. For example, if your
interface is connected to localhost you would type '127.0.0.1/nib' into your
URL bar.

2a.) If you do not have permission to access the web application, you'll have
to turn off security features for Fedora by typing 'seenforce 0' into the terminal.
Bear in mind this is normally a terrible idea, but for the purpose of creating a
testing environment for the cellphones it'll be fine for now.

3.) Double check your settings in the web interface before starting up Yate.

4.) Start up Yate by typing 'sudo yate -s' into the terminal.

5.) Once you see the message 'MBTS ready' on your terminal, your BladeRF is ready
to go and can receive 2G cellphone signals.
