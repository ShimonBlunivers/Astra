package config;

public class Settings {
    public final static int screenWidth = 1280;
    public final static int screenHeight = 720;

    public final static int ratio = 10; // How many squares fit into one screen width

    public final static int scale = 50;
    

    public final static int tileWidth = (int)Math.floor(screenWidth / ratio);
    public final static int tileHeight = tileWidth;

    public final static int FPS = 60; // Neměnit, nefunguje to tak, jak si myslíš. Xdd

    public final static String hairColorCode =      "#663300";
    public final static String skinColorCode =      "#ffffcc";
    public final static String shirtColorCode =     "#33ff99";
    public final static String legColorCode =       "#006600";
    public final static String feetColorCode =      "#0033ff";
    public final static String outlineColorCode =   "#330000";
    public final static String eyeColorCode =       "#660066";
}
