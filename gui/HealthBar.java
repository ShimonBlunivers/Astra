package gui;

import entities.Entity;

import java.awt.Color;

public class HealthBar extends Bar {
    
    Entity parent;

    public HealthBar(HUD hud, String name, Entity parent, int x, int y, int width, int height, Color color, Color backgroundColor){
        super(hud, name, parent.maxHealth, x, y, width, height, color, backgroundColor);
        this.parent = parent;
    }

    public void update(){
        super.update();

        this.value = this.parent.health;
    }
}
