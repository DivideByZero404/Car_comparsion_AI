package carcompai;

public class Model {

    private int modelId;
    private String brandName;
    private String modelName;
    private double price;
    private String engineCc;
    private String fuelType;
    private String transmission;
    private int releaseYear;
    private String imageUrl;
    private String topFeatures;
    private String officialUrl;

    // ⭐ ZERO-ARG CONSTRUCTOR (REQUIRED for favourites page)
    public Model() {}

    // ⭐ MAIN CONSTRUCTOR
    public Model(int modelId, String brandName, String modelName, double price,
                 String engineCc, String fuelType, String transmission,
                 int releaseYear, String imageUrl,
                 String topFeatures, String officialUrl) {

        this.modelId = modelId;
        this.brandName = brandName;
        this.modelName = modelName;
        this.price = price;
        this.engineCc = engineCc;
        this.fuelType = fuelType;
        this.transmission = transmission;
        this.releaseYear = releaseYear;
        this.imageUrl = imageUrl;
        this.topFeatures = topFeatures;
        this.officialUrl = officialUrl;
    }

    // ===========================
    //        GETTERS
    // ===========================
    public int getModelId() { return modelId; }
    public String getBrandName() { return brandName; }
    public String getModelName() { return modelName; }
    public double getPrice() { return price; }
    public String getEngineCc() { return engineCc; }
    public String getFuelType() { return fuelType; }
    public String getTransmission() { return transmission; }
    public int getReleaseYear() { return releaseYear; }
    public String getImageUrl() { return imageUrl; }
    public String getTopFeatures() { return topFeatures; }
    public String getOfficialUrl() { return officialUrl; }

    // ===========================
    //        SETTERS
    // ===========================
    public void setModelId(int modelId) { this.modelId = modelId; }
    public void setBrandName(String brandName) { this.brandName = brandName; }
    public void setModelName(String modelName) { this.modelName = modelName; }
    public void setPrice(double price) { this.price = price; }
    public void setEngineCc(String engineCc) { this.engineCc = engineCc; }
    public void setFuelType(String fuelType) { this.fuelType = fuelType; }
    public void setTransmission(String transmission) { this.transmission = transmission; }
    public void setReleaseYear(int releaseYear) { this.releaseYear = releaseYear; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public void setTopFeatures(String topFeatures) { this.topFeatures = topFeatures; }
    public void setOfficialUrl(String officialUrl) { this.officialUrl = officialUrl; }
}
