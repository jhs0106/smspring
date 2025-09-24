import util.HttpSendData;

import java.io.IOException;
import java.util.Random;

public class Main4 {
    public static void main(String[] args) throws IOException {
        String url = "https://127.0.0.1:8443/savedata4";
        Random r = new Random();
        for (int i = 0; i < 1000; i++) {
            int num = r.nextInt(100)+1;
            HttpSendData.send(url, "?data=" + num);
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
//    public static void main(String[] args) throws IOException {
//        String url = "https://127.0.0.1:8443/iot2";
//        Random r = new Random();
//        for (int i = 0; i < 100; i++) {
//            double lat = 36.800209 + r.nextDouble(0.005);
//            double lng = 127.074968 + r.nextDouble(0.005);
//            HttpSendData.send(url, "?lat=" + lat + "&lng=" + lng);
//            try {
//                Thread.sleep(2000);
//            } catch (InterruptedException e) {
//                throw new RuntimeException(e);
//            }
//        }
//    }
}