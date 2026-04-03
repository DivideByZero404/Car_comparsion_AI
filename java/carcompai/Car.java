// Car.java
package carcompai;

public class Car {
    private int brandId;
    private String brandName;
    private String country;
    private int foundedYear;

    // Constructor
    public Car(int brandId, String brandName, String country, int foundedYear) {
        this.brandId = brandId;
        this.brandName = brandName;
        this.country = country;
        this.foundedYear = foundedYear;
    }

    // Getters
    public int getBrandId() {
        return brandId;
    }

    public String getBrandName() {
        return brandName;
    }

    public String getCountry() {
        return country;
    }

    public int getFoundedYear() {
        return foundedYear;
    }
}
