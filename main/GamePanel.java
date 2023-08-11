
package main;

import java.awt.Color;
import java.awt.Dimension;

import javax.swing.JFrame;
import javax.swing.JPanel;

import config.Settings;
import entities.EntityManager;
import entities.Player;
import gui.HUD;

import java.awt.Graphics;
import java.awt.Graphics2D;


public class GamePanel extends JPanel implements Runnable{

    public JFrame window;

    public int x = 0;
    public int y = 0;

    WorldManager worldManager = new WorldManager(this);
    EntityManager entityManager = new EntityManager();
    KeyHandler keys = new KeyHandler();
    MouseHandler mouse = new MouseHandler();
    Thread gameThread;

    public Player player = new Player(this);

    HUD hud = new HUD(this);

    public Controller controller = new Controller(keys, mouse, player, worldManager);
    
    public GamePanel(JFrame window){
        this.window = window;
        this.setPreferredSize(new Dimension(Settings.screenWidth, Settings.screenHeight));
        this.setBackground(Color.black);
        this.setDoubleBuffered(true);
        this.addKeyListener(keys);
        this.addMouseListener(mouse);
        this.setFocusable(true);

        // TESTING

        this.player.damage(10);
    }

    public void startGameThread(){
        gameThread = new Thread(this);
        gameThread.start();
    }

    @Override
    public void run() {

        double drawInterval = 1_000_000_000/Settings.FPS;
        double nextDrawTime = System.nanoTime() + drawInterval;

        while(gameThread != null)
        {
            update();   
            repaint();
            
            try {
                
                double remainingTime = nextDrawTime - System.nanoTime();
                remainingTime = remainingTime / 1_000_000;

                if(remainingTime > 0) Thread.sleep((long) remainingTime);

                nextDrawTime += drawInterval;

            } catch (InterruptedException e) { e.printStackTrace(); }
        }
    }
    
    public void update(){
        mouse.update(window);
        worldManager.update();
        entityManager.update();
        controller.update();
        hud.update();
    }

    public void paintComponent(Graphics g){
        super.paintComponent(g);

        Graphics2D g2 = (Graphics2D)g;

        worldManager.draw(g2);
        entityManager.draw(g2);
        hud.draw(g2);

        g2.drawRect(mouse.x, mouse.y, 10, 10); // Showing where the mouse is.
        g2.dispose();
    }
}
