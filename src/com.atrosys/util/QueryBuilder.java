package com.atrosys.util;

import java.util.List;

/**
 * Created by met on 1/29/18.
 * query string util.
 */

public class QueryBuilder {
    public static String buildWhereEQQuery(List<String[]> parameters) {
        String response = "";
        boolean leastAConditionSet = false;
        for (int i = 0; i < parameters.size(); i++) {
            String key = parameters.get(i)[0];
            String value = parameters.get(i)[1];
            if (!value.equals("-1")) {
                if (!leastAConditionSet) {
                    leastAConditionSet = true;
                    response += "WHERE ";
                } else {
                    response += " AND ";
                }
                response += key + "=" + value;
            }
        }
        return response;
    }

    public static String buildWhereQuery(List<QueryParameter> parameters, boolean putWhere) {
        String response = "";
        boolean leastAConditionSet = false;
        for (QueryParameter parameter : parameters) {
            String key = parameter.getColName();
            String operation = parameter.getOperation();
            String value = parameter.getValue();
            if (!value.equals("-1")) {
                if (!leastAConditionSet) {
                    leastAConditionSet = true;
                    if (putWhere)
                        response += "WHERE ";
                    else
                        response += "AND ";
                } else {
                    response += " AND ";
                }
                if (operation == "%")
                    response += key + " LIKE '%" + value + "%'";
                else if (operation == "=")
                    response += key + "=" + value;
            }
        }
        return response;
    }
}
