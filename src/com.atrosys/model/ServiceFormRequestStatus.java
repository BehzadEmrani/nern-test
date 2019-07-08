package com.atrosys.model;

public enum ServiceFormRequestStatus {
    WAIT_FOR_SUBS_SIGNING(1000, "امضا توسط مشترک"),
    WAIT_FOR_SHOA_SIGNING(2000, "امضا توسط اپراتور"),
    SERVICE_FORM_COMPLETED(3000, "امضا و مبادله شده"),
    IMPOSSIBLE_TO_SERVICE(4000, "عدم امکان ارائه سرویس");

    private final int value;
    private final String faStr;

    private ServiceFormRequestStatus(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    private ServiceFormRequestStatus(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }


    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }


    public static ServiceFormRequestStatus fromValue(int value) {
        for (ServiceFormRequestStatus serviceFormRequestStatus : ServiceFormRequestStatus.values()) {
            if (serviceFormRequestStatus.getValue() == value)
                return serviceFormRequestStatus;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
