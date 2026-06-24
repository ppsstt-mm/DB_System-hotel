package com.utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;


/**
*/

public class BaiduUtil {
	
    /**
     * @return
     */
    public static Map<String, String> getCityByLonLat(String key, String lng, String lat) {
        String location = lat + "," + lng;
        try {
            String url = "http://api.map.baidu.com/reverse_geocoding/v3/?ak="+key+"&output=json&coordtype=wgs84ll&location="+location;
            String result = HttpClientUtils.doGet(url);
            JSONObject o = new JSONObject(result);
            Map<String, String> area = new HashMap<>();
			area.put("province", o.getJSONObject("result").getJSONObject("addressComponent").getString("province"));
			area.put("city", o.getJSONObject("result").getJSONObject("addressComponent").getString("city"));
			area.put("district", o.getJSONObject("result").getJSONObject("addressComponent").getString("district"));
			area.put("street", o.getJSONObject("result").getJSONObject("addressComponent").getString("street"));
            return area;
        }catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
	     * @return assess_auth_token
	     */
    public static String getAuth(String ak, String sk) {
        String authHost = "https://aip.baidubce.com/oauth/2.0/auth_token?";
        String getAccessTokenUrl = authHost
                + "grant_type=client_credentials"
                + "&client_id=" + ak
                + "&client_secret=" + sk;
        try {
            URL realUrl = new URL(getAccessTokenUrl);
            HttpURLConnection connection = (HttpURLConnection) realUrl.openConnection();
            connection.setRequestMethod("GET");
            connection.connect();
            Map<String, List<String>> map = connection.getHeaderFields();
            for (String key : map.keySet()) {
                System.err.println(key + "--->" + map.get(key));
            }
            BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String result = "";
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
            /**
             */
            System.err.println("result:" + result);
            org.json.JSONObject jsonObject = new org.json.JSONObject(result);
            String access_auth_token = jsonObject.getString("access_auth_token");
            return access_auth_token;
        } catch (Exception e) {
            System.err.printf("get auth token failed");
            e.printStackTrace(System.err);
        }
        return null;
    }

}
