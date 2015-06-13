pimatic-smartmeter
===============

Reading Smartmeter energy usage through P1 port

Installation
------------
To enable the smartmeter plugin add this to the plugins in the config.json file.

```
...
{
  "plugin": "smartmeter",
  "serialport": "/dev/ttyUSB0",
  "baudRate" : 9600,
  "dataBits" : 7,
  "parity" : "even",
  "stopBits" : 1,
  "flowControl" : true
}
...
```

and add the following to the devices

```
{
  "id": "smartmeter",
  "class": "Smartmeterdevice",
  "name": "smartmeter",
}
```

Then install through the standard pimatic plugin install page.


Configuration
-------------
You can configure what serialport to use, and the serialport settings. You do this in the plugin section, as you can see in the installation section.

