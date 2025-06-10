## State Bag Getters/Setters

## Description

State bag getters are a little bit simpler, they just return the current value that is set in the state bag.

#### Note: If you're on the client and only using it on the current player, you can replace Player(source) with LocalPlayer

## Example for Proximity

```lua
local plyState = Player(source).state
local proximity = plyState.proximity
```