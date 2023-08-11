package entities;

import main.GamePanel;
import main.Sprite;
import java.awt.Rectangle;

import config.Settings;

public class Player extends Entity {
    
    int characterIndex;    

    public Player(GamePanel world){
        super(world);
        int size[] = {2, 4};
        this.rect = new Rectangle((config.Settings.screenWidth/2) - (size[0] * config.Settings.scale / 2), (config.Settings.screenHeight/2) - (size[1] * config.Settings.scale / 2), size[0] * config.Settings.scale, size[1] * config.Settings.scale);
        this.characterIndex = 0;
        this.walkSpeed = 5;
        this.runSpeed = 10;
        this.isRunning = false;

        this.maxHealth = 100;
        this.health = this.maxHealth;

        String[] animationFiles = {"walkup", "walkdown", "walkleft", "walkright"};
        int[] animationLength = {4, 4, 8, 8};
        float[] animationFrequency = {4, 4, 8, 8};
    
        this.sprite = new Sprite(this.rect.width, this.rect.height, true, "characters/" + this.characterIndex + "/animations", animationFiles, animationLength, animationFrequency);
        this.sprite.visible = true;
        this.legRectDivider = 4;

        this.loadLegRect();
    }   

    @Override
    public void move(int speedX, int speedY){
        this.rect.x += speedX;
        this.world.x -= speedX;
        this.rect.y += speedY;
        this.world.y -= speedY;
        this.updateLegRect();
    }

    public void setPosition(int x, int y){
        this.rect.x = x;
        this.rect.y = y;
        this.updateLegRect();
        this.centerScreenOnPlayer();
    }

    public void centerScreenOnPlayer(){
        this.world.x = -(this.rect.x + (this.rect.width/2)) + (Settings.screenWidth/2);
        this.world.y = -(this.rect.y + (this.rect.height/2)) + (Settings.screenHeight/2);
    }
}
