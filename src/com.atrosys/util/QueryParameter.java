package com.atrosys.util;

/**
 * Created by met on 1/29/18.
 * POJO class for Query builder parameter data.
 */

public class QueryParameter {
    String colName;
    String value;
    String operation;

    public QueryParameter(String colName, String value, String operation) {
        this.colName = colName;
        this.value = value;
        this.operation = operation;
    }

    public String getColName() {
        return colName;
    }

    public String getValue() {
        return value;
    }

    public String getOperation() {
        return operation;
    }
}
