/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dataaccessioner;

import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import org.jdom.input.SAXBuilder;
import org.jdom.transform.JDOMSource;

/**
 *
 * @author Seth Shaw
 */
public class XSLTProcessor {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TESTING
//        List<String> sources = new ArrayList<String>();
//        sources.add("C:\\Temp\\TEST.xml");
//        List<String> transforms = new ArrayList<String>();
//        transforms.add("xslt\\simple_transform.xslt");
//        String destination = "C:\\Temp\\reports\\";
//        new XSLTProcessor().runTransforms(sources, transforms, destination);
        try {
            // Set cross-platform Java L&F (also called "Metal")
            UIManager.setLookAndFeel(
                    UIManager.getSystemLookAndFeelClassName());
        } catch (UnsupportedLookAndFeelException e) {
            // handle exception
        } catch (ClassNotFoundException e) {
            // handle exception
        } catch (InstantiationException e) {
            // handle exception
        } catch (IllegalAccessException e) {
            // handle exception
        }
        SwingView view = new SwingView();
        view.pack();
        view.setVisible(true);
    }
    
    public void runTransforms(List<String> sourcePaths, List<String> transformPaths, String destination){
        File destinationDir = new File(destination);
        destinationDir.mkdirs();
        
        Map<String,Transformer> transforms = new HashMap<String,Transformer>();
        TransformerFactory factory = TransformerFactory.newInstance();
        for(String transformPath: transformPaths){
            try {
                transforms.put(new File(transformPath).getName().replaceAll("\\.xslt?", ""), factory.newTransformer(new javax.xml.transform.stream.StreamSource(transformPath)));
            } catch (TransformerConfigurationException ex) {
                Logger.getLogger(XSLTProcessor.class.getName())
                        .log(Level.WARNING, "Could not add the XSLT "
                                +transformPath, ex);
            }
        }
        for (String sourcePath : sourcePaths) {
            File source = new File(sourcePath);
            for (String transformName : transforms.keySet()) {
                try {
                    FileOutputStream out = new FileOutputStream(new File(destination,source.getName().replaceAll("\\.xml?", "")+"_"+transformName), false);
                    Result result = new StreamResult(out);
                    transforms.get(transformName).transform(new JDOMSource(new SAXBuilder().build(source)), result);
                    out.close();
                } catch (Exception ex) {
                    Logger.getLogger(XSLTProcessor.class.getName())
                            .log(Level.WARNING, "Could not execute transform for "
                                    + sourcePath + " using "
                                    + transformName, ex);
                }
            }
        }
    }
}
