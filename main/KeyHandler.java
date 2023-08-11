package main;

import java.awt.event.KeyListener;
import java.awt.event.KeyEvent;

public class KeyHandler implements KeyListener {

    public boolean W, S, A, D, SHIFT, UP, DOWN, LEFT, RIGHT, Q, E;

    @Override
    public void keyTyped(KeyEvent e) {
    }

    @Override
    public void keyPressed(KeyEvent e) {

        int code = e.getKeyCode();

        if (code == KeyEvent.VK_W) W = true;
        if (code == KeyEvent.VK_S) S = true;
        if (code == KeyEvent.VK_A) A = true;
        if (code == KeyEvent.VK_D) D = true;
        if (code == KeyEvent.VK_SHIFT) SHIFT = true;
        if (code == KeyEvent.VK_UP) UP = true;
        if (code == KeyEvent.VK_DOWN) DOWN = true;
        if (code == KeyEvent.VK_LEFT) LEFT = true;
        if (code == KeyEvent.VK_RIGHT) RIGHT = true;
        if (code == KeyEvent.VK_Q) Q = true;
        if (code == KeyEvent.VK_E) E = true;
    }

    @Override
    public void keyReleased(KeyEvent e) {

        int code = e.getKeyCode();

        if (code == KeyEvent.VK_W) W = false;
        if (code == KeyEvent.VK_S) S = false;
        if (code == KeyEvent.VK_A) A = false;
        if (code == KeyEvent.VK_D) D = false;
        if (code == KeyEvent.VK_SHIFT) SHIFT = false;
        if (code == KeyEvent.VK_UP) UP = false;
        if (code == KeyEvent.VK_DOWN) DOWN = false;
        if (code == KeyEvent.VK_LEFT) LEFT = false;
        if (code == KeyEvent.VK_RIGHT) RIGHT = false;
        if (code == KeyEvent.VK_Q) Q = false;
        if (code == KeyEvent.VK_E) E = false;
    }
    
}
