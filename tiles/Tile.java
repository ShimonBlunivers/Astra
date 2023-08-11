package tiles;

import java.awt.image.BufferedImage;
import java.util.ArrayList;

import main.Animator;
import main.WorldManager;

import java.awt.Rectangle;

public class Tile {
    public int index;
    public int nameIndex;
    public String name;
    public TileClass tileClass;
    public BufferedImage texture;
    public Rectangle rect;
    public WorldManager worldManager;
    public ArrayList<Tile> myList;

    public Animator animator;
    public boolean isAnimated, isWall, visible, floorTile;

    public Tile(TileClass tileClass, WorldManager worldManager, int index, boolean floorTile){
        this.index = index;
        if (tileClass == tileClass.tileManager.getEmpty()) this.visible = false;
        else this.visible = true;
        this.worldManager = worldManager;
        this.tileClass = tileClass;
        this.name = this.tileClass.name;
        this.floorTile = floorTile;

        if (this.floorTile) {
            this.worldManager.tileManager.addFloorTile(this);
            this.myList = this.worldManager.tileManager.getFloorTileList(name);
        }
        else {
            this.worldManager.tileManager.addWorldTile(this);
            
            this.myList = this.worldManager.tileManager.getWorldTileList(name);
        }

        
        this.nameIndex = this.myList.size() - 1;
        
        this.texture = tileClass.texture;
        this.rect = new Rectangle(0, 0, tileClass.width, tileClass.height);
        this.isAnimated = tileClass.isAnimated;
        this.isWall = tileClass.isWall;
        if (this.tileClass.animationList.size() > 0 )
        {
            if (this.isAnimated){
                this.animator = new Animator(this);
                this.animator.addAnimation(1, this.tileClass.animationList);
            }
            else{
                this.animator = new Animator(this);
                this.animator.addAnimation(-1, this.tileClass.animationList); // Nebude se měnit animace
            }
        }
    }

}
