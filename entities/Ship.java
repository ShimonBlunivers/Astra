package entities;

import main.GamePanel;
import main.KeyHandler;

public class Ship extends Entity {
    
    GamePanel world;
    KeyHandler keys;

    public Ship(GamePanel world) {
        super(world);
    }
}
