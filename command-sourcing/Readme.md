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

Instead of doing:
```
Rails.configuration.command_bus = Arkency::CommandBus.new
```
