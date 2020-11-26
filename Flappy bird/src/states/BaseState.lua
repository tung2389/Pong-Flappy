-- Base state. Other state class will inherit from BaseState class

BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:update() end
function BaseState:render() end
function BaseState:exit() end