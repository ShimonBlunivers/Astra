package main;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.ArrayList;

import javax.imageio.ImageIO;
import java.awt.Graphics2D;

public class Sprite {
    public int width, height;
    public boolean visible;
    public BufferedImage image;
    public Animator animator = null;
    public boolean animating = true;

    public Sprite(int width, int height, String imagePath){
        this.width = width;
        this.height = height;
        try {
            image = ImageIO.read(getClass().getResourceAsStream("/files/"+imagePath+".png"));
        } catch(IOException e){e.printStackTrace();}
        }
    
    public Sprite(int width, int height, boolean customSkin, String path, String[] animationFolders, int[] animationLength, float[] animationFrequency){
        this.width = width;
        this.height = height;
        this.animator = new Animator(this, customSkin);
        ArrayList<String> pathList = new ArrayList<>();

        for(int i = 0; i < animationFolders.length; i++)
        {
            for(int x = 1; x < animationLength[i] + 1; x++){
                pathList.add(path + "/" + animationFolders[i] + "/" + x);
            }
            
            this.animator.addAnimation(animationFrequency[i], pathList);

            pathList.clear();
        }
    }

    public void update(){
        if (this.animator != null && this.animating) this.animator.animate();
    }

    public void draw(Graphics2D g2, int x,  int y){
        g2.drawImage(this.image, x, y, width, height, null);
    }

    public void changeAnimation(int index){ // W - 0 ; S - 1 ; A - 2 ; D - 3
        this.animator.changeAnimation(index);
    }

    public void changeAnimationFrequency(double frequency){
        this.animator.changeCurrentAnimationFrequency(frequency);
    }

    public Animation getCurrentAnimation(){
        return this.animator.animations.get(this.animator.activeAnimation);
    }

}
