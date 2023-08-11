package tiles;

import java.util.ArrayList;

import main.WorldManager;

import java.awt.Color;

public class TileManager {
    WorldManager worldManager;
    public ArrayList<TileClass> tileClassList = new ArrayList<>();
    public ArrayList<ArrayList<Tile>> worldTiles = new ArrayList<>();
    public ArrayList<ArrayList<Tile>> floorTiles = new ArrayList<>();
    public ArrayList<Tile> orderedWorldTileList = new ArrayList<>();
    public ArrayList<Tile> orderedFloorTileList = new ArrayList<>();

    TileClass empty;

    public TileManager(WorldManager worldManager){
        this.worldManager = worldManager;

        this.empty = new TileClass(this, "empty", false, "empty", new Color(255, 255, 255));

        new TileClass(this, "brick", true, "brick/texture", new Color(255, 0, 0));
        new TileClass(this, "floor", false, "floor/texture", new Color(0, 0, 128));
        new TileClass(this, "grass", false, "grass/texture", new Color(128, 128, 0));
        new TileClass(this, "dirt", false, "dirt/texture", new Color(0, 255, 0));
        new TileClass(this, "water", true, "water/texture", new Color(0, 0, 255));
        new TileClass(this, "door", true, "door/", 2, false, new Color(100, 0, 0));


    }

    public ArrayList<TileClass> getTileClassList(){
        return this.tileClassList;
    }

    public TileClass getEmpty(){
        return this.empty;
    }

    public void addWorldTile(Tile tile){
        this.orderedWorldTileList.add(tile);
        for (ArrayList<Tile> list : this.worldTiles) 
        {
            if (list.get(0).name.equals(tile.name)){
                list.add(tile);
                return;
            }
        }
        ArrayList<Tile> newArrayList = new ArrayList<>();
        newArrayList.add(tile);
        this.worldTiles.add(newArrayList);
    }

    
    public void addFloorTile(Tile tile){
        this.orderedFloorTileList.add(tile);
        for (ArrayList<Tile> list : this.floorTiles) 
        {
            if (list.get(0).name.equals(tile.name)){
                list.add(tile);
                return;
            }
        }
        ArrayList<Tile> newArrayList = new ArrayList<>();
        newArrayList.add(tile);
        this.floorTiles.add(newArrayList);
    }

    public void resetWorld(){
        this.worldTiles.clear();
        this.floorTiles.clear();
        this.orderedFloorTileList.clear();
        this.orderedWorldTileList.clear();
    }

    public ArrayList<Tile> getWorldTileList(String name){
        for (ArrayList<Tile> list : this.worldTiles) if (list.get(0).name == name) return list;
        return null;
    }

    public ArrayList<Tile> getFloorTileList(String name){
        for (ArrayList<Tile> list : this.floorTiles) if (list.get(0).name == name) return list;
        return null;
    }

    public Tile getWorldTileOnCoords(int x, int y){
        return this.orderedWorldTileList.get((x >= 0 || x < (this.worldManager.worldWidth * config.Settings.tileWidth) ? x / config.Settings.tileWidth : 0) + (y >= 0 || y < (this.worldManager.worldHeight * config.Settings.tileHeight) ? y / config.Settings.tileWidth : 0) * this.worldManager.worldWidth);
    } 

    public Tile getFloorTileOnCoords(int x, int y){
        return this.orderedFloorTileList.get((x >= 0 || x < (this.worldManager.worldWidth * config.Settings.tileWidth) ? x / config.Settings.tileWidth : 0) + (y >= 0 || y < (this.worldManager.worldHeight * config.Settings.tileHeight) ? y / config.Settings.tileWidth : 0) * this.worldManager.worldWidth);
    } 

    public void openDoor(int index){
        Tile theDoor = this.getWorldTileList("door").get(index);

        theDoor.animator.setFrame(1);
        theDoor.isWall = false;
    }

    public void closeDoor(int index){
        Tile theDoor = this.getWorldTileList("door").get(index);
        if(!theDoor.worldManager.getPlayer().legRect.intersects(theDoor.rect)){
            theDoor.animator.setFrame(0);
            theDoor.isWall = true;
        }
    }
}
