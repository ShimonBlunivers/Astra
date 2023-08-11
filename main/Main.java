package main;

import javax.swing.ImageIcon;
import javax.swing.JFrame;

public class Main {
  	public static void main(String[] args) {
    
		JFrame window = new JFrame();
		window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		window.setResizable(false);
		window.setTitle("Astra");

		GamePanel gamePanel = new GamePanel(window);
		window.add(gamePanel);

		window.pack();

		window.setLocationRelativeTo(null);
		window.setVisible(true);

		ImageIcon img = new ImageIcon("files/icon.png");
		window.setIconImage(img.getImage());

		gamePanel.startGameThread();
    }
}