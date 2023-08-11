package main;

import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import java.awt.Point;

import javax.swing.JFrame;

public class MouseHandler extends MouseAdapter {

    int x = 0;
    int y = 0;

    public void update(JFrame window){
        Point mousePosition = window.getMousePosition();
        if(mousePosition != null){
            x = mousePosition.x - window.getInsets().left;
            y = mousePosition.y - window.getInsets().top;
        }
    }

    @Override
    public void mouseClicked(MouseEvent e) {
        // This method is called when the mouse is clicked
        // You can get the x and y position of the mouse click using e.getX() and e.getY()
    }

    @Override
    public void mouseEntered(MouseEvent e) {
        // This method is called when the mouse enters the component
    }

    @Override
    public void mouseExited(MouseEvent e) {
        // This method is called when the mouse exits the component
    }

    @Override
    public void mousePressed(MouseEvent e) {
        // This method is called when the mouse button is pressed
    }

    @Override
    public void mouseReleased(MouseEvent e) {
        // This method is called when the mouse button is released
    }
}


