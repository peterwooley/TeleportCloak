# What does TeleportCloak do?

TeleportCloak is an extremely lightweight addon that automatically equips your last item after using any of the following:

* Cloak of Coordination
* Wrap of Unity
* Shroud of Cooperation
* Ring of the Kirin Tor
* Time-Lost Artifact
* Stormpike Insignia
* Frostwolf Insignia
* Boots of the Bay
* Ruby Slippers
* Blessed Medallion of Karabor
* Brassiest Knuckle
* Argent Crusader's Tabard
* Hellscream's Reach Tabard
* Baradin's Wardens Tabard 

You can also use the macro functionality to equip these various items and use them. (You must click the macro twice)

# Toggle Warnings

A warning message will be displayed if TeleportCloak is unable to restore your last item. You can toggle the warnings off to prevent this behavior:

```
/tc warnings
```

# Macros
## Default Macro

This macro will cycle between Cloak of Coordination, Wrap of Unity, and Shroud of Cooperation

```
/click TeleportCloak LeftButton 1
```

## Custom Macros

If you wish to customize the default behavior, model your macro after the following example:

```
/tc add Boots of the Bay
/tc add Ruby Slippers
/click TeleportCloak
```
