package com.atrosys.model;

/**
 * Contract type for contract table.
 */

public enum ServiceContractTableRecordType {
    SUBS_CONTRACT(0, "فرم اشتراک"),
    SERVICE_FORM("سرویس فرم");

    private final int value;
    private final String faStr;

    ServiceContractTableRecordType(int value, String faStr) {
        this.value = value;
        this.faStr = faStr;
        Counter.nextValue = value + 1;
    }

    ServiceContractTableRecordType(String faStr) {
        this.value = Counter.nextValue++;
        this.faStr = faStr;
    }

    public int getValue() {
        return value;
    }

    public String getFaStr() {
        return faStr;
    }

    public static ServiceContractTableRecordType fromValue(int value) {
        for (ServiceContractTableRecordType serviceContractTableRecordType : ServiceContractTableRecordType.values()) {
            if (serviceContractTableRecordType.getValue() == value)
                return serviceContractTableRecordType;
        }
        return null;
    }

    private static class Counter {
        private static int nextValue = 0;
    }

}
