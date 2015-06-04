# #Plugin pimatic-smartmeter

module.exports = (env) ->

  Promise = env.require 'bluebird'
  
#  assert = env.require 'cassert'

  class Smartmeter extends env.plugins.Plugin

    init: (app, @framework, @config) =>      

      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("Smartmeterdevice", {
        configDef: deviceConfigDef.Smartmeterdevice,
        createCallback: (config) => new Smartmeterdevice(config)
      })      

  class Smartmeterdevice extends env.devices.Sensor

    attributes:
      actualusage:
        description: "Actual usage"
        type: "number"
        unit: ' Watt'
      activetariff:
        description: "Active tariff"
        type: "number"
        unit: " 1 or 2"
      tariff1totalusage:
        description: "Tariff 1 total usage(T1)"
        type: "number"
        unit: ' kWh'
      tariff2totalusage:
        description: "Tariff 2 total usage(T2)"
        type: "number"
        unit: ' kWh'
    actualusage: 0.0
    activetariff: 1
    tariff1totalusage: 0.0
    tariff2totalusage: 0.0    

    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @portName = @config.serialport
      super()

      P1DataStream = require "./p1meterdata"
      p1datastream = new P1DataStream({portName: @portName})
      p1datastream.on 'data', (data) =>
        @emit "actualusage", Number data.currentUsage
        @emit "activetariff", Number data.currentTariff
        @emit "tariff1totalusage", Number data.tariffOneTotalUsage
        @emit "tariff2totalusage", Number data.tariffTwoTotalUsage


    getActualusage: -> Promise.resolve @actualusage
    getActivetariff: -> Promise.resolve @activetariff
    getTariff1totalusage: -> Promise.resolve @rate1totalusage
    getTariff2totalusage: -> Promise.resolve @rate2totalusage
  plugin = new Smartmeter
  return plugin
