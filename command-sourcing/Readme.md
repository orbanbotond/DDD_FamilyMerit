Command Sourcing
================

This gem serves as a persistent adapter for the command bus.

Main features:
- persistence of the commands
- ability to replay the history

Usage:
------

Initialize like this:
```
Rails.configuration.command_bus = PersistedCommandBus::CommandBus.new
```

Then You will be able to replay the history as part of Your `Disaster Recovery Plan` like this:
`Rails.configuration.command_bus.replay_history`

Instead of doing:
```
Rails.configuration.command_bus = Arkency::CommandBus.new
```
