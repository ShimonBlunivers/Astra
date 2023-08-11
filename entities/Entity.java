package entities;
import java.awt.Rectangle;
import java.awt.Graphics2D;
import main.GamePanel;
import main.Sprite;

public class Entity {
    
    public GamePanel world;
    
    public Rectangle rect = new Rectangle(100, 100); // Default settings for Entity
    public Sprite sprite = new Sprite(this.rect.width, this.rect.height, "entities/0");
    public Rectangle legRect = new Rectangle(100, 100);

    public int walkSpeed;
    public int runSpeed;
    public boolean isRunning;
    
    public int legRectDivider = 0;
    public int legRectYOffset;

    public float health;
    public float maxHealth;
    public float armor = 0;

    public Entity(GamePanel world){
        
        this.maxHealth = 100;
        this.health = this.maxHealth;
        this.world = world;
        this.sprite.visible = true;
        EntityManager.entities.add(this);
    }

    public void update(){
        if (this.health <= 0) this.kill();
        this.sprite.update();
        this.updateLegRect();
    }

    public void move(int speedX, int speedY){
        this.rect.x += speedX;
        this.rect.y += speedY;
        this.updateLegRect();
    }

    public void loadLegRect() {
        this.legRect = new Rectangle(0, this.rect.height - this.rect.height / this.legRectDivider, this.rect.width, this.rect.height / legRectDivider);
        if (this.legRectDivider == 0) this.legRectYOffset = 0;
        else this.legRectYOffset = this.rect.height - this.rect.height / this.legRectDivider;
    }

    public void updateLegRect() {
        this.legRect.x = this.rect.x;
        if (this.legRectDivider == 0) this.legRectYOffset = 0;
        else this.legRectYOffset = this.rect.height - this.rect.height / this.legRectDivider;
        this.legRect.y = this.rect.y + this.legRectYOffset;
    }

    public void damage(float dmg){
        if (calculateDamage(dmg) == 0) return;
        float modifiedDmg = calculateDamage(dmg);
        this.health -= modifiedDmg;
        if (this.health < 0) this.health = 0;
    }

    private float calculateDamage(float dmg){
        if (dmg <= this.armor) return 0;
        float modifiedDmg = dmg - this.armor;
        return modifiedDmg;
    }

    public void kill(){

    }

    public void draw(Graphics2D g2){
        if(this.sprite.visible)
        {
            this.sprite.draw(g2, this.rect.x + world.x, this.rect.y + world.y);
        }
    }
}