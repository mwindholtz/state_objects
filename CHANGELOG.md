## 0.0.8
  Additional tests ported from selection_options gem

## 0.0.7
  Fixed typos
  
## 0.0.6
* adding scope with _occurs.  For example:
  scope :red,   where(WalkLight.color_state_red_occurs )     # => "(color_state ='R')"  

## v0.0.5
*  (Yanked)

## v0.0.4
* Changed Gem description to focus state that Many other state machines focus on events and state transitions.
This state machine focuses on behavior.
* Cleared up documentation to explain that tests have been added to the gem.  This code has automated tests.

## v0.0.3
* Ported tests from gem selection_options_for

## v0.0.2

* initial release as a rubygem
