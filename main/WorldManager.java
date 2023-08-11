package main;

import java.awt.Color;
import javax.imageio.ImageIO;

import config.Settings;
import entities.Player;
import tiles.Tile;
import tiles.TileClass;
import tiles.TileManager;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.ArrayList;
import java.awt.Graphics2D;

public class WorldManager {
    public GamePanel world;
    public TileManager tileManager = new TileManager(this);
    int index = 0;
    public int worldWidth;
    public int worldHeight;

    public ArrayList<Tile> animatedTileList = new ArrayList<>();

    public WorldManager(GamePanel world){
        this.world = world;
        this.load();
    }

    public void load(){
        int index = 0;
        Tile newTile;
        try {
            BufferedImage worldImage = ImageIO.read(getClass().getResourceAsStream("/files/saves/world"+ this.index +".png"));
            this.worldWidth = worldImage.getWidth();
            this.worldHeight = worldImage.getHeight();

            // LOAD WORLD

            for (int y = 0; y < this.worldHeight; y++){
                for (int x = 0; x < this.worldWidth; x++){
                    boolean filled = false;
                    
                    for (TileClass tileClass : this.tileManager.getTileClassList()){
                        if (!filled && tileClass.color.equals(getColor(worldImage.getRGB(x, y)))){
                            newTile = new Tile(tileClass, this, index++, false);
                            newTile.rect.x = x * Settings.tileWidth;
                            newTile.rect.y = y * Settings.tileHeight;
                            if (newTile.isAnimated) this.animatedTileList.add(newTile);
                            filled = true;
                        }
                    }
                    if (!filled){
                        newTile = new Tile(this.tileManager.getEmpty(), this, index++, false);
                        newTile.rect.x = x * Settings.tileWidth;
                        newTile.rect.y = y * Settings.tileHeight;
                    }
                }
            }
        } catch(IOException e){e.printStackTrace();}

        // LOAD FLOOR

        try {
            BufferedImage floorImage = ImageIO.read(getClass().getResourceAsStream("/files/saves/floor"+ this.index +".png"));

            for (int y = 0; y < this.worldHeight; y++){
                for (int x = 0; x < this.worldWidth; x++){
                    boolean filled = false;
                    
                    for (TileClass tileClass : this.tileManager.getTileClassList()){
                        if (!filled && tileClass.color.equals(getColor(floorImage.getRGB(x, y)))){
                            newTile = new Tile(tileClass, this, index++, true);
                            newTile.rect.x = x * Settings.tileWidth;
                            newTile.rect.y = y * Settings.tileHeight;
                            if (newTile.isAnimated) this.animatedTileList.add(newTile);
                            filled = true;
                        }
                    }
                    if (!filled){
                        newTile = new Tile(this.tileManager.getEmpty(), this, index++, true);
                        newTile.rect.x = x * Settings.tileWidth;
                        newTile.rect.y = y * Settings.tileHeight;
                    }
                }
            }
        } catch(IOException e){e.printStackTrace();}
    }
    
    public void unload(){
        this.worldHeight = 0;
        this.worldWidth = 0;

        this.tileManager.resetWorld();
        this.animatedTileList.clear();

        this.world.x = 0;
        this.world.y = 0;
    }

    public Player getPlayer(){
        return this.world.player;
    }

    public void update(){
        for (Tile tile : this.animatedTileList){
            tile.animator.animate();
        }
    }

    public void draw(Graphics2D g2){
        for (int y = 0; y < this.worldHeight; y++){
            for (int x = 0; x < this.worldWidth; x++){

                Tile tile;

                tile = this.tileManager.orderedFloorTileList.get(x + (y * this.worldWidth));
                
                if (tile.visible && tile.rect.x + this.world.x < Settings.screenWidth && tile.rect.y + this.world.y < Settings.screenHeight && tile.rect.x + this.world.x + tile.rect.width > 0 && tile.rect.y + this.world.y + tile.rect.height > 0){
                    g2.drawImage(tile.texture, tile.rect.x + this.world.x, tile.rect.y + this.world.y, tile.rect.width, tile.rect.height, null);
                    //g2.drawRect(tile.rect.x, tile.rect.y - 500, tile.rect.width, tile.rect.height); //Hitbox
                }
                
                tile = this.tileManager.orderedWorldTileList.get(x + (y * this.worldWidth));
                
                if (tile.visible && tile.rect.x + this.world.x < Settings.screenWidth && tile.rect.y + this.world.y < Settings.screenHeight && tile.rect.x + this.world.x + tile.rect.width > 0 && tile.rect.y + this.world.y + tile.rect.height > 0){
                    g2.drawImage(tile.texture, tile.rect.x + this.world.x, tile.rect.y + this.world.y, tile.rect.width, tile.rect.height, null);
                    //g2.drawRect(tile.rect.x, tile.rect.y - 500, tile.rect.width, tile.rect.height); //Hitbox
                }
            }
        }
    }

    public static Color getColor(int value){
        int b = value & 0xff;
        int g = (value & 0xff00) >> 8;
        int r = (value & 0xff0000) >> 16;
        
        return new Color(r, g, b);
    }
}
