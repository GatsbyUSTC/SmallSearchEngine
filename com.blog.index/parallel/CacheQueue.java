package parallel;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.LinkedBlockingQueue;

public class CacheQueue implements Runnable {
	private LinkedBlockingQueue<StringBuffer> cacheQueue;
	private CountDownLatch countDownLatch;
	public CacheQueue(LinkedBlockingQueue<StringBuffer> queue, CountDownLatch startsig){
		cacheQueue = queue;
		countDownLatch = startsig;
	}
	@Override
	public void run() {
		// TODO Auto-generated method stub
		try {
			countDownLatch.await();
		} catch (InterruptedException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		BlogReader blogReader = new BlogReader();
		StringBuffer buffer;
		while((buffer = blogReader.getNextBuffer()) != null ){ 
			try {
				cacheQueue.put(buffer);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		for(int i=0;i < MainThread.THREADNUM;i++){
			buffer = new StringBuffer("End of Queue");
			try {
				cacheQueue.put(buffer);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
