import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;

public class Jaccard {
    public static boolean detail;
	
	/**
	 * 
	 */
	public static void main(String[] args) {
		Scanner argScan = new Scanner(args[1]);
		int numTrials = argScan.nextInt();
		argScan.close();
        detail = (args.length == 3);
		try {
			readFile(args[0], args[0], numTrials);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void readFile(String experiment, String out, int numTrials) throws FileNotFoundException {
        PrintWriter write;
        if(!detail) {
            write = new PrintWriter(new FileOutputStream("java_out/" + out + "_out.txt"));
        } else {
            write = new PrintWriter(new FileOutputStream("java_out/" + out + "_detailed_out.txt"));
        }
		HashMap<Integer, String> varNames = new HashMap<Integer, String>();
		Scanner varScan = new Scanner(new FileInputStream(experiment + "_VarNames.txt"));
		List<HashMap<String, List<String>>> trials = new ArrayList<HashMap<String, List<String>>>();
		int idx = 1;
		while(varScan.hasNextLine()) {
			String s = varScan.nextLine();
			Scanner stringScan = new Scanner(s);
			//stringScan.next();
			while(stringScan.hasNext()) {
				varNames.put(idx, stringScan.next());
				idx++;
			}
			stringScan.close();
		}
        //System.out.println(varNames.toString());
        //System.exit(0);
		
		int[] edgeCount = new int[numTrials];
		
		for(int i = 0; i < numTrials; i++) {
			idx = 1;
			Scanner fileScan = new Scanner(new FileInputStream(experiment + "_" + i + ".txt" ));
            // Skip the header from the updated line creation
            //fileScan.nextLine();
			
			HashMap<String, List<String>> m = new HashMap<String, List<String>>();
			trials.add(m);
			for(int j = 0; j < varNames.size(); j++) {
				String name = varNames.get(j + 1);
				m.put(name, new ArrayList<String>());
                String nameLine = fileScan.nextLine();
                if(nameLine.contains(":")) {
                    nameLine = nameLine.replace(":", " range ");
                }
                nameLine = nameLine.replace(",", " ");
                nameLine = nameLine.replace(")", " ");
                
                if(nameLine.charAt(0) == 'c') {
                    nameLine = nameLine.substring(2);
                }
                //System.out.println(nameLine);
                Scanner nameScan = new Scanner(nameLine);
                
                
                /**
				while(!fileScan.hasNextInt()) {
                    String check = "";
                    if(fileScan.hasNext()) {
                        check = fileScan.next();
                    } else {
                        idx++; break;
                    }
                    //System.out.println(check);
					if(check.contains("integer")) {
						idx++;
						break;
					} else {
                        fileScan.nextChar();
                    }
				} */
				List<String> l = m.get(name);
                while(nameScan.hasNextInt()) {
                    int min = nameScan.nextInt();
                    l.add(varNames.get(min));
                    edgeCount[i]++;
                    if(nameScan.hasNext() && !nameScan.hasNextInt()) {
                       String test = nameScan.next();
                       if(!test.equals("range")) {
                           System.out.println("Something is wrong here");
                           break;
                       }
                            int max = nameScan.nextInt();
                            for(int q = min + 1; q <= max; q++) {
                                l.add(varNames.get(q));
                                edgeCount[i]++;
                            }
                            
                        
                    }
                }
                /**
				while(fileScan.hasNextInt()) {
					l.add(varNames.get(fileScan.nextInt()));
                    System.out.println(l.get(edgeCount[i]));
					edgeCount[i]++;
                    if(! fileScan.hasNextInt()) {
                        fileScan.nextChar();
                    }
				} */
				idx++;
                /**
                for(int k = 0; k < l.size(); k++) {
                    System.out.print(l.get(k) + ", ");
                    
                }
                System.out.println(); */
                
			}
			
		}
        //System.out.println("Got here");
		idx = 1;
		for(int i = 0; i < numTrials; i++) {
            if(detail) {
                write.println("Trial" + (i + 1) + ":[" + edgeCount[i] + "]");
            }
			HashMap<String, List<String>> m1 = trials.get(i);
			for(int j = i + 1; j < numTrials; j++) {
				int intersect = 0;
				HashMap<String, List<String>> m2 = trials.get(j);
				
				for(int k = 1; k <= varNames.size(); k++) {
                    
					String name = varNames.get(k);
                    //System.out.println(name);
					List<String> l1 = m1.get(name);
					List<String> l2 = m2.get(name);
					if(l1 == null || l2 == null || l1.isEmpty() || l2.isEmpty()) {
                        if(l1 == null) {
                            System.out.println(i + 1 + name);
                        } else if (l2 == null) {
                            System.out.println(j + 1 + name);
                        }
						continue;
					}
					for(String s : l1) {
						if(l2.contains(s)) {
							intersect++;
						}
					}
				}
				double jaccard = ((double) intersect) / (edgeCount[i] + edgeCount[j] - intersect);
                if(detail) {
                    write.println("Trial " + (i + 1) + " to trial " + (j + 1) + ":  " + intersect + " jaccard: " + jaccard);
                }
                else {
                    write.println(jaccard);
                }
				
			}
			write.println();
			
			
		}
		
		write.close();
		
	}
}
