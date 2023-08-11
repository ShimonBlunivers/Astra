package gui;

import java.awt.Rectangle;


import java.awt.Color;

import java.awt.Graphics2D;


public class Bar {

    HUD hud;

    Rectangle rect = new Rectangle();
    public String name;
    public Color color;
    public Color backgroundColor;

    float maxValue;
    float value;
    boolean empty;

    public Bar(HUD hud, String name, float maxValue, int x, int y, int width, int height, Color color, Color backgroundColor){
        this.hud = hud;
        this.name = name;
        this.hud.barList.add(this);

        this.maxValue = maxValue;
        this.value = maxValue;
        this.empty = false;

        this.rect.x = x;
        this.rect.y = y;
        this.rect.width = width;
        this.rect.height = height;
        
        this.color = color;
        this.backgroundColor = backgroundColor;
    }

    public void update(){
        if (this.value <= 0) this.empty = true;
    }

    public void draw(Graphics2D g2){
        int filledHeight = (int)(this.rect.height * this.getPercent());

        g2.setColor(this.backgroundColor);
        g2.fillRect(this.rect.x, this.rect.y, this.rect.width, this.rect.height);

        g2.setColor(this.color);
        g2.fillRect(this.rect.x, this.rect.y + this.rect.height - filledHeight, this.rect.width, filledHeight);

        g2.setColor(new Color(0, 0, 0));
        g2.drawRect(this.rect.x, this.rect.y, this.rect.width, this.rect.height);
    }

    private double getPercent(){
        return this.value / this.maxValue;
    }
}
