package main;

import java.util.ArrayList;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.IOException;

public class Animation {
    int index;    // W - 0 ; S - 1 ; A - 2 ; D - 3
    double frequency;
    final double originalFrequency;
    int numberOfFrames;
    ArrayList<BufferedImage> frames = new ArrayList<BufferedImage>();;
    int currentFrame = 0;
    int animationLength;

    double currentTime;
    double delta;
    double lastTime;


    public Animation(int index, double frequency, ArrayList<String> files){
        this.index = index;
        this.frequency = frequency;
        this.originalFrequency = this.frequency;
        this.numberOfFrames = files.size();
        this.loadImages(files);
    }

    private void loadImages(ArrayList<String> files){
        for(int i = 0; i < this.numberOfFrames; i++){
            BufferedImage image;
            try {
                image = ImageIO.read(getClass().getResourceAsStream("/files/"+files.get(i)+".png"));
                this.frames.add(image);
            } catch(IOException e){e.printStackTrace();}
        this.animationLength = this.frames.size();
        }
    }
    public void setCurrentFrame(int index){
        this.currentFrame = index;
    }

    public BufferedImage update(){

        this.updateTime();
        if (this.delta >= 1000/frequency){
            this.currentFrame = (this.currentFrame + 1) % (this.animationLength);
            this.lastTime = this.currentTime;
        }
        return frames.get(currentFrame);
    }

    public BufferedImage setFrame(int index){

        this.updateTime();
        this.currentFrame = (index) % (this.animationLength);
        this.lastTime = this.currentTime;
        
        return frames.get(currentFrame);
    }

    public BufferedImage nextFrame(){

        this.updateTime();
        this.currentFrame = (this.currentFrame + 1) % (this.animationLength);
        this.lastTime = this.currentTime;
        
        return frames.get(currentFrame);
    }

    public BufferedImage getCurrentFrame(){
        return frames.get(currentFrame);
    }

    private void updateTime(){
        this.currentTime = System.currentTimeMillis();
        this.delta = this.currentTime - this.lastTime;
    }

    public void changeFrequency(double frequency){
        this.frequency = frequency;
    }

    public void resetFrequency(){
        this.frequency = this.originalFrequency;
    }
}
