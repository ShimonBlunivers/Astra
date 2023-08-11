package main;

import config.Settings;
import entities.Player;

public class Controller {
    KeyHandler keys;
    MouseHandler mouse;
    Player player;
    WorldManager worldManager;
    boolean interstellar = false;
    boolean testingDoorStatus = false;

    public Controller(KeyHandler keys, MouseHandler mouse, Player player, WorldManager worldManager){
        this.keys = keys;
        this.mouse = mouse;
        this.player = player;
        this.worldManager = worldManager;
    }

    public void update(){

        // TEST

        if(this.keys.Q){
            if (this.worldManager.tileManager.getWorldTileOnCoords(mouse.x - this.worldManager.world.x, mouse.y - this.worldManager.world.y).name == "door"){
                this.worldManager.tileManager.openDoor(this.worldManager.tileManager.getWorldTileOnCoords(mouse.x - this.worldManager.world.x, mouse.y - this.worldManager.world.y).nameIndex);
            }
        }

        if(this.keys.E){
            if (this.worldManager.tileManager.getWorldTileOnCoords(mouse.x - this.worldManager.world.x, mouse.y - this.worldManager.world.y).name == "door"){
                this.worldManager.tileManager.closeDoor(this.worldManager.tileManager.getWorldTileOnCoords(mouse.x - this.worldManager.world.x, mouse.y - this.worldManager.world.y).nameIndex);
            }
        }

        // END OF TESTING

        if(!this.interstellar){
            int speed = player.walkSpeed;
            int dirX = 0;
            int dirY = 0;

            if(this.keys.SHIFT){
                this.player.isRunning = true;
                speed = player.runSpeed;
            }
            else this.player.isRunning = false;

            if (this.keys.D) dirX++;
            if (this.keys.A) dirX--;
            if (this.keys.S) dirY++;
            if (this.keys.W) dirY--;
            this.player.sprite.changeAnimationFrequency(this.player.sprite.getCurrentAnimation().originalFrequency);

            if (dirX != 0 && !this.checkPlayerCollision(dirX, 0)[0]){
                this.player.move(speed * dirX, 0);
                if (dirX > 0) this.player.sprite.changeAnimation(3);
                else this.player.sprite.changeAnimation(2);
            }
            if (dirY != 0 && !this.checkPlayerCollision(0, dirY)[1]){
                this.player.move(0, speed * dirY);
                if (dirY > 0) this.player.sprite.changeAnimation(1);
                else this.player.sprite.changeAnimation(0);
            }

            if (dirX == 0 && dirY == 0 ){
                this.player.sprite.changeAnimation(0);
            }
            else if (this.player.isRunning) this.player.sprite.changeAnimationFrequency(this.player.sprite.getCurrentAnimation().originalFrequency + 10);
        }
    }

    public boolean[] checkPlayerCollision(int dirX, int dirY){ // X - collision; Y - collision
        boolean[] collision = new boolean[2];
        collision[0] = false;
        collision[1] = false;

        int modifier = 16;

        int shiftedLeft = this.player.legRect.x + (modifier * dirX);
        int shiftedRight = this.player.legRect.x + this.player.legRect.width + (modifier * dirX);
        int shiftedTop = this.player.legRect.y + (modifier * dirY);
        int shiftedBottom = this.player.legRect.y + this.player.legRect.height + (modifier * dirY);
        
        int shiftedLeftIndex = shiftedLeft / Settings.tileWidth;
        int shiftedRightIndex =  shiftedRight / Settings.tileWidth;
        int shiftedTopIndex = shiftedTop / Settings.tileHeight;
        int shiftedBottomIndex = shiftedBottom / Settings.tileHeight;

        if(shiftedLeft > 0 && shiftedRightIndex < this.worldManager.worldWidth && shiftedTop > 0 && shiftedBottomIndex < this.worldManager.worldHeight){ //Kontroluje, zda se hráč nachází v hranicích světa.


            // PUTTING PLAYER RIGHT NEXT TO THE WALL, IF COLLISION DETECTED

            if (dirX != 0 && dirY == 0){
                // LEFT
                if (this.worldManager.tileManager.orderedWorldTileList.get(shiftedLeftIndex + shiftedTopIndex * this.worldManager.worldWidth).isWall || this.worldManager.tileManager.orderedWorldTileList.get(shiftedLeftIndex + shiftedBottomIndex * this.worldManager.worldWidth).isWall){
                    player.setPosition(this.worldManager.tileManager.orderedWorldTileList.get(shiftedLeftIndex).rect.x + this.worldManager.tileManager.orderedWorldTileList.get(shiftedLeftIndex).rect.width + 1, player.rect.y);
                    collision[0] = true;
                }
                // RIGHT
                else if (this.worldManager.tileManager.orderedWorldTileList.get(shiftedRightIndex + shiftedTopIndex * this.worldManager.worldWidth).isWall || this.worldManager.tileManager.orderedWorldTileList.get(shiftedRightIndex + shiftedBottomIndex * this.worldManager.worldWidth).isWall){
                    player.setPosition(this.worldManager.tileManager.orderedWorldTileList.get(shiftedRightIndex).rect.x - player.legRect.width - 1, player.rect.y);
                    collision[0] = true;
                }
            }
            if (dirY != 0 && dirX == 0){
                // TOP
                if (this.worldManager.tileManager.orderedWorldTileList.get(shiftedTopIndex * this.worldManager.worldWidth + shiftedLeftIndex).isWall || this.worldManager.tileManager.orderedWorldTileList.get(shiftedTopIndex * this.worldManager.worldWidth + shiftedRightIndex).isWall){
                    player.setPosition(player.rect.x, this.worldManager.tileManager.orderedWorldTileList.get(shiftedTopIndex * this.worldManager.worldWidth).rect.y + this.worldManager.tileManager.orderedWorldTileList.get(shiftedTopIndex * this.worldManager.worldWidth).rect.height - (player.rect.height - player.legRect.height) + 1);
                    collision[1] = true;
                }
                // BOTTOM
                else if (this.worldManager.tileManager.orderedWorldTileList.get(shiftedBottomIndex * this.worldManager.worldWidth + shiftedLeftIndex).isWall || this.worldManager.tileManager.orderedWorldTileList.get(shiftedBottomIndex * this.worldManager.worldWidth + shiftedRightIndex).isWall){
                    player.setPosition(player.rect.x, this.worldManager.tileManager.orderedWorldTileList.get(shiftedBottomIndex * this.worldManager.worldWidth).rect.y - player.rect.height - 1);
                    collision[1] = true;
                }
            }
        }

        return collision;
    }
}
