import java.util.*;
 
import kafka.javaapi.producer.Producer;
import kafka.producer.KeyedMessage;
import kafka.producer.ProducerConfig;
 
public class KafkaTest implements Runnable {

	private String[][] apps = new String[][]{ {"Adobe AIR", "Adobe Systems"}, 
		{"Adobe Flash Player 11", "Adobe Systems"}, 
		{"Adobe Reader", "Adobe Systems"}, 
		{"Amazon Kindle", "Amazon.com"}, 
		{"Angry Birds", "Rovio Entertainment Ltd."}, 
		{"Angry Birds Go!", "Rovio Entertainment Ltd."}, 
		{"Angry Birds Rio", "Rovio Entertainment Ltd."}, 
		{"Angry Birds Seasons", "Rovio Entertainment Ltd."}, 
		{"Angry Birds Space", "Rovio Entertainment Ltd."}, 
		{"Asphalt 7: Heat", "Gameloft"}, 
		{"Avast Mobile Security & Antivirus", "Avast Software"}, 
		{"Barcode Scanner", "ZXing Team"}, 
		{"Battery Doctor (Battery Saver)", "Cheetah Mobile"}, 
		{"BBM", "BlackBerry Limited"}, 
		{"Beautiful Widgets Pro", "LevelUp Studio"}, 
		{"Blurb Checkout", "Blurb, Inc."}, 
		{"Camera ZOOM FX", "androidslide"}, 
		{"Candy Crush Saga", "King"}, 
		{"ChatON", "Samsung"}, 
		{"Clash of Clans", "Supercell"}, 
		{"Clean Master (Speed Booster)", "Cheetah Mobile"}, 
		{"CM Security Antivirus AppLock", "Cheetah Mobile"}, 
		{"Cut the Rope", "ZeptoLab"}, 
		{"Despicable Me: Minion Rush", "Gameloft"}, 
		{"Doodle Jump", "Lima Sky"}, 
		{"Drag Racing", "Creative Mobile"}, 
		{"Draw Something", "OMGPop"}, 
		{"Dropbox", "Dropbox, Inc."}, 
		{"DU Battery Saver & Widgets", "DU APPS STUDIO"}, 
		{"eBay", "eBay"}, 
		{"ES File Explorer", "ES APP Group"}, 
		{"Farm Heroes Saga", "King"}, 
		{"Firefox", "Mozilla"}, 
		{"Flightradar24 - Flight Tracker", "Flightradar24"}, 
		{"Flipboard: Your News Magazine", "Flipboard"}, 
		{"Free Antivirus Security", "AVG Mobilation"}, 
		{"Fruit Ninja", "Halfbrick Studios"}, 
		{"Fruit Ninja Free", "Halfbrick Studios"}, 
		{"Geometry Dash", "RobTop Games"}, 
		{"GO Launcher EX", "GO Launcher Dev Team"}, 
		{"Google Drive", "Google"}, 
		{"Google Earth", "Google"}, 
		{"Google Play Games", "Google"}, 
		{"Google Play Movies & TV", "Google"}, 
		{"Google Play Music", "Google"}, 
		{"Google Play Newsstand", "Google"}, 
		{"Google Talkback", "Google"}, 
		{"Google Translate", "Google"}, 
		{"Grand Theft Auto III", "Rockstar Games"}, 
		{"HD Widgets", "CloudTV"}, 
		{"Hill Climb Racing", "Fingersoft"}, 
		{"HP Print Service Plugin", "Hewlett-Packard"}, 
		{"Instagram", "Instagram"}, 
		{"Jetpack Joyride", "Halfbrick Studios"}, 
		{"KakaoTalk", "Kakao Corp."}, 
		{"Kik", "Kik Interactive"}, 
		{"LINE: Free Calls & Messages", "LINE Corporation"}, 
		{"Minecraft - Pocket Edition", "Mojang"}, 
		{"MX Player", "J2 Interactive"}, 
		{"My Talking Tom", "Outfit7"}, 
		{"Netflix", "Netflix Inc."}, 
		{"Nova Launcher Prime", "TeslaCoil Software"}, 
		{"OfficeSuite 8 Pro + PDF", "MobiSystems"}, 
		{"Opera Mini", "Opera Software"}, 
		{"Pandora internet radio", "Pandora"}, 
		{"Paper Camera", "JFDP Labs"}, 
		{"PicsArt Photo Studio", "PicsArt"}, 
		{"Plants vs. Zombies", "PopCap Games"}, 
		{"Pool Billiards Pro", "TerranDroid"}, 
		{"Pou", "Zakeh"}, 
		{"Poweramp Full Version Unlocker", "Max MP"}, 
		{"Runtastic Running PRO", "Runtastic"}, 
		{"Samsung Link (AllShare Play)", "Samsung"}, 
		{"Samsung Print Service Plugin", "Samsung"}, 
		{"Samsung Push Service", "Samsung"}, 
		{"Shazam", "Shazam"}, 
		{"Shoot Bubble Deluxe", "City Games LLC"}, 
		{"Skype", "Microsoft"}, 
		{"Smart Tools", "Smart Tools co."}, 
		{"Snapchat", "Snapchat Inc."}, 
		{"Street View on Google Maps", "Google"}, 
		{"Street View on Google Maps", "Google"}, 
		{"Subway Surfers", "Kiloo Games"}, 
		{"Super-Bright LED Flashlight", "Surpax Technology Inc."}, 
		{"Talking Tom Cat 2 Free", "Outfit7"}, 
		{"Talking Tom Cat Free", "Outfit7"}, 
		{"Tango Messenger, Video & Calls", "Tango"}, 
		{"Temple Run", "Imangi Studios"}, 
		{"Temple Run 2", "Imangi Studios"}, 
		{"Threema", "Threema GmbH"}, 
		{"TuneIn Radio Pro", "TuneIn"}, 
		{"Twitter", "Twitter"}, 
		{"Viber: Free Calls & Messages", "Viber Media, Ltd"}, 
		{"Voice Search", "Google"}, 
		{"WeChat", "Tencent"}, 
		{"Where's My Perry?", "Disney Mobile"}, 
		{"Where's My Water?", "Disney Mobile"}, 
		{"Yahoo! Mail", "Yahoo!"}, 
		{"Zedge", "Zedge"} 
 };

 	private String[] protocol = {"TPC4", "UPD4"};
 	
 	private String[] port = {"80", "443"};		//65535
 	
 	private String[] source_ip = {"0.0.0.0", "127.0.0.1", "10.0.0.100"};
 	
 	private String[][] con_status = { {"SYN_SEND", " Indicates active open"},
 			{"SYN_RECEIVED", "Server just received SYN from the client"}, 
 			{"ESTABLISHED", "Client received server's SYN and session is established"}, 
 			{"LISTEN", "Server is ready to accept connection"}, 
 			{"FIN_WAIT_1", "Indicates active close"}, 
 			{"TIMED_WAIT", "Client enters this state after active close"}, 
 			{"CLOSE_WAIT", "Indicates passive close. Server just received first FIN from a client"}, 
 			{"FIN_WAIT_2", "Client just received acknowledgment of its first FIN from the server"}, 
 			{"LAST_ACK", "Server is in this state when it sends its own FIN"}, 
 			{"CLOSED", "Server received ACK from client and connection is closed"}
 	};
 
	private Thread t;
	private String threadName;
    long events;
	   
	KafkaTest(String name, long n) {
		threadName = name;
		events = n;
		System.out.println("Creating " + threadName);
	}	
	
	public void run() {
	      System.out.println("Running " +  threadName );
	      try {
	          Random rnd = new Random();
	   
	          Properties props = new Properties();
	          props.put("metadata.broker.list", "localhost:9092,localhost:9093");
	          props.put("serializer.class", "kafka.serializer.StringEncoder");
	          props.put("partitioner.class", "SimplePartitioner");
	          props.put("request.required.acks", "1");
	   
	          ProducerConfig config = new ProducerConfig(props);
	   
	          Producer<String, String> producer = new Producer<String, String>(config);
	   
	          long runtime = new Date().getTime();
	          String mac = randomMACAddress();

	          for (long nEvents = 0; nEvents < events; nEvents++) {
		          	System.out.println("Thread: " + threadName + ", " + nEvents);
		          	
		          	String target_ip = rnd.nextInt(255) + "." + rnd.nextInt(255) + "." + rnd.nextInt(255) + "." + rnd.nextInt(255);
		          	int source_port = rnd.nextInt(65535) + 1; 
	                String msg = mac + "," + runtime + "," + protocol[rnd.nextInt(2)] + "," +
	                		source_ip[rnd.nextInt(3)] + "," + source_port + "," + 
	                		target_ip + "," + port[rnd.nextInt(2)] + "," + 
	                		con_status[rnd.nextInt(con_status.length)][0] + "," + 
	                		apps[rnd.nextInt(apps.length)][0]; 
	                KeyedMessage<String, String> data = new KeyedMessage<String, String>("kafkatest", mac, msg);
	                producer.send(data);
	                
	                Thread.sleep(50);
	          }
	          producer.close();
	     } catch (InterruptedException e) {
	         System.out.println("Thread " +  threadName + " interrupted.");
	     }
	     System.out.println("Thread " +  threadName + " exiting.");
	   }
	
	   public void start ()
	   {
	      System.out.println("Starting " +  threadName );
	      if (t == null)
	      {
	         t = new Thread (this, threadName);
	         t.start ();
	      }
	   }
	   
	private String randomMACAddress() {
		Random rand = new Random();
		byte[] macAddr = new byte[6];
		rand.nextBytes(macAddr);
		macAddr[0] = (byte) (macAddr[0] & (byte) 254); // zeroing last 2 bytes to make it unicast and locally adminstrated
		StringBuilder sb = new StringBuilder(18);
		for (byte b : macAddr) {
			if (sb.length() > 0) sb.append(":");
			sb.append(String.format("%02x", b));
		}
		return sb.toString();
	}
	
    public static void main(String[] args) {
    	for (int i = 0; i < 1000; i++) {
        	KafkaTest dev = new KafkaTest("Device-" + i, 1000);
        	dev.start();	
		}
    }
}