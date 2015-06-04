pimatic-smartmeter
===============

Reading Smartmeter energy usage through P1 port

##Installation
To enable the smartmeter plugin add this to the plugins in the config.json file.

```
...
{
  "plugin": "smartmeter",
  "serialport": "/dev/ttyUSB0"
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

##Configuration

The only configuration you can do currently is what serialport to use. You do this in the plugin section, as you can see in the installation section.

