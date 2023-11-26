package cpas.model;

import java.util.ArrayList;
import java.util.List;

public class Food {
    private String storeName;
    private String storeAddress;
    private String storeTell;
    private List<Menu> menus = new ArrayList<>();
    private String foodPic;  // 추가된 필드
    private String origin; // 추가된 필드
    private String storeDistance; // 추가된 필드
    private double predictedRating;
    
    public double getPredictedRating() {
        return predictedRating;
    }

    public void setPredictedRating(double predictedRating) {
        this.predictedRating = predictedRating;
    }



    // Getter and setter for storeName
    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    // Getter and setter for storeAddress
    public String getStoreAddress() {
        return storeAddress;
    }

    public void setStoreAddress(String storeAddress) {
        this.storeAddress = storeAddress;
    }

    // Getter and setter for storeTell
    public String getStoreTell() {
        return storeTell;
    }

    public void setStoreTell(String storeTell) {
        this.storeTell = storeTell;
    }

    // Getter for menus
    public List<Menu> getMenus() {
        return menus;
    }

    // Method to add menu to the menus list
    public void addMenu(String menu, String price) {
        this.menus.add(new Menu(menu, price));
    }

    // Getter and setter for origin
    public String getOrigin() {
        return origin;
    }
    public void setFoodPic(String foodPic) {
        this.foodPic = foodPic;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }
    public String getFoodPic() {
        return foodPic;
    }
    public String getStoreDistance() {
        return storeDistance;
    }

    public void setStoreDistance(String storeDistance) {
        this.storeDistance = storeDistance;
    }

    public static class Menu {
        private String name;  // Corresponds to store_menu
        private String price;  // Corresponds to menu_price

        public Menu(String name, String price) {
            this.name = name;
            this.price = price;
        }

        // Getter for name
        public String getName() {
            return name;
        }

        // Getter for price
        public String getPrice() {
            return price;
        }
    }
}
