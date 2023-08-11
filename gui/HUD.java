package gui;

import java.awt.Color;
import java.util.ArrayList;

import config.Settings;
import main.GamePanel;

import java.awt.Graphics2D;

public class HUD {

    GamePanel world;

    public ArrayList<Bar> barList = new ArrayList<>();

    Bar healthBar;

    int yOffset = 20;

    public HUD(GamePanel world){
        this.world = world;
        this.healthBar = new HealthBar(this, "health", this.world.player, 10, yOffset, 60, Settings.screenHeight - (yOffset*2), new Color(255, 0, 0),  new Color(150, 0, 0));
    }

    public void update(){
        for (Bar bar : this.barList){
            bar.update();
        }
    }
    public void draw(Graphics2D g2){
        for (Bar bar : this.barList){
            bar.draw(g2);
        }
    }

}
