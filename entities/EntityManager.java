package entities;

import java.awt.Graphics2D;
import java.util.ArrayList;
import java.util.Comparator;

public class EntityManager {
    
    public static ArrayList<Entity> entities = new ArrayList<>();

    public void update(){
        for (Entity entity : entities){
            entity.update();
        }
    }

    public void draw(Graphics2D g2){
        this.sortEntityListByY();
        for (Entity entity : entities){
            entity.draw(g2);
        }
    }

    private void sortEntityListByY(){ 
        entities.sort(Comparator.comparingInt(entity -> entity.legRect.y + entity.legRect.height));
    }
}
