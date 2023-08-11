package tiles;

import javax.imageio.ImageIO;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.ArrayList;
import java.awt.Color;
import main.Animator;

public class TileClass {
    public String name;
    public boolean isAnimated, isWall;

    public Animator animator = null;

    public int width = config.Settings.tileWidth;
    public int height = config.Settings.tileHeight;

    TileManager tileManager;
    public BufferedImage texture;
    public Color color;
    
    ArrayList<String> animationList = new ArrayList<>();

    public TileClass(TileManager tileManager, String name, boolean isWall, String texturePath, Color color){
        this.tileManager = tileManager;
        this.name = name;
        this.isWall = isWall;
        this.color = color;
        this.isAnimated = false;
        try {
            this.texture = ImageIO.read(getClass().getResourceAsStream("/files/tiles/"+ texturePath +".png"));
        } catch(IOException e){e.printStackTrace();}
        this.tileManager.tileClassList.add(this);
    }
    
    public TileClass(TileManager tileManager, String name, boolean isWall, String animationPath, int animationLength, boolean isAnimated, Color color){
        this.tileManager = tileManager;
        this.name = name;
        this.isWall = isWall;
        this.color = color;
        this.isAnimated = isAnimated;
        for(int i = 0; i < animationLength; i++)
        {
            this.animationList.add("tiles/"+animationPath + i);
        }
        this.tileManager.tileClassList.add(this);
    }
}
