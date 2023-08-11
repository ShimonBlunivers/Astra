package main;

import java.util.ArrayList;

import tiles.Tile;


public class Animator {
    Sprite spriteParent = null;
    Tile tileParent = null;
    ArrayList<Animation> animations = new ArrayList<Animation>();
    int numberOfAnimations = 0;
    int activeAnimation = 0;
    boolean customSkin = false;

    public Animator(Sprite spriteParent, boolean customSkin){
        this.spriteParent = spriteParent;
        this.customSkin = customSkin;
    }

    public Animator(Tile tileParent){
        this.tileParent = tileParent;
    }

    public void addAnimation(double frequency, ArrayList<String> path){
        Animation newAnimation = new Animation(numberOfAnimations, frequency, path);
        this.animations.add(newAnimation);
        if (this.numberOfAnimations == 0){
            if (this.spriteParent != null) this.spriteParent.image = animations.get(activeAnimation).getCurrentFrame();
            else if (this.tileParent != null) this.tileParent.texture = animations.get(activeAnimation).getCurrentFrame();
        } 
        this.numberOfAnimations++;
    }

    public void animate(){
        if (this.spriteParent != null) this.spriteParent.image = animations.get(activeAnimation).update();
        else if (this.tileParent != null) this.tileParent.texture = animations.get(activeAnimation).update();
    }
    public Animation getCurrentAnimation(){
        return animations.get(activeAnimation);
    }

    public void changeAnimation(int index){ // W - 0 ; S - 1 ; A - 2 ; D - 3
        this.activeAnimation = index;
    }

    public void changeCurrentAnimationFrequency(double frequency){
        this.animations.get(this.activeAnimation).changeFrequency(frequency);
    }

    public void nextFrame(){
        if (this.spriteParent != null) this.spriteParent.image = animations.get(activeAnimation).nextFrame();
        else if (this.tileParent != null) this.tileParent.texture = animations.get(activeAnimation).nextFrame();
    }

    public void setFrame(int index){
        if (this.spriteParent != null) this.spriteParent.image = animations.get(activeAnimation).setFrame(index);
        else if (this.tileParent != null) this.tileParent.texture = animations.get(activeAnimation).setFrame(index);
    }
}
