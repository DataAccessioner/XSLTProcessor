/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dataaccessioner.xsltprocessor;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.io.File;
import java.io.FileOutputStream;
import java.text.MessageFormat;
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

    java.util.ResourceBundle bundle;
    
    public XSLTProcessor() {
        bundle = java.util.ResourceBundle.getBundle("org/dataaccessioner/xsltprocessor/resources/MessagesBundle"); // NOI18N
    }

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
    
    private int transformCount = 0;
    private int transformsDone = 0;
    private String statusMessage = "";
    private PropertyChangeSupport propertyChangeSupport = new PropertyChangeSupport( this );
    
    public void addPropertyChangeListener( PropertyChangeListener listener ) {
      propertyChangeSupport.addPropertyChangeListener( listener );
    }
    
    public void runTransforms(List<String> sourcePaths, List<String> transformPaths, String destination){
        transformCount = sourcePaths.size()*transformPaths.size();
        transformsDone = 0;
        setStatusMessage(bundle.getString("set_out.msg"));
        File destinationDir = new File(destination);
        destinationDir.mkdirs();
        setStatusMessage(destinationDir.getAbsolutePath()+"\n");
        if(!destinationDir.canWrite()){
            setStatusMessage(MessageFormat.format(
                    bundle.getString("invalid_out.error.body0"), destinationDir
                            .getAbsolutePath())
                    +"\n"+bundle.getString("canceled.msg")+"\n");
            return;
        }

        Map<String,Transformer> transforms = new HashMap<String,Transformer>();
        TransformerFactory factory = TransformerFactory.newInstance();
        for (String transformPath : transformPaths) {
            try {
                String transformName = new File(transformPath).getName().replaceAll("\\.xslt?", "");
                setStatusMessage(MessageFormat.format(bundle.getString("set_trans.msg"), transformName));
                transforms.put(transformName, factory.newTransformer(new javax.xml.transform.stream.StreamSource(transformPath)));
                setStatusMessage(bundle.getString("done")+"\n");
            } catch (TransformerConfigurationException ex) {
                String warning = MessageFormat.format(bundle.getString("set_trans.wrn"), transformPath);
                Logger.getLogger(XSLTProcessor.class.getName())
                        .log(Level.WARNING, warning, ex);
                setStatusMessage(warning+"\n");
            }
        }
        for (String sourcePath : sourcePaths) {
            File source = new File(sourcePath);
            if(!source.canRead()){
                setStatusMessage(MessageFormat.format(bundle.getString("set_src.wrn"), source.getName()));
                continue;
            }
            for (String transformName : transforms.keySet()) {
                File report = new File(destination, source.getName().replaceAll("\\.xml?", "") + "_" + transformName);                
                setStatusMessage(MessageFormat.format(bundle.getString("run_src.msg"), report.getName()));
                
                try {
                    FileOutputStream out = new FileOutputStream(report, false);
                    Result result = new StreamResult(out);
                    transforms.get(transformName).transform(new JDOMSource(new SAXBuilder().build(source)), result);
                    out.close();
                    setStatusMessage(bundle.getString("done")+"\n");
                } catch (Exception ex) {
                    String message = MessageFormat.format(bundle.getString("run_trans.wrn"),new Object[] { sourcePath, transformName});
                    Logger.getLogger(XSLTProcessor.class.getName())
                            .log(Level.WARNING, message, ex);
                    setStatusMessage("\n"+message+"\n");
                } finally {
                    updateTransformsDone();
                }
            }
        }
        setStatusMessage(bundle.getString("done")+"\n");
    }

    private void updateTransformsDone(){        
        propertyChangeSupport.firePropertyChange("statusPercent", 
                (int) ((double)transformCount/transformsDone++)*100, 
                (int) ((double)transformCount/transformsDone)*100);
    }
    
    public int getStatusPercent() {
        return (int) ((double)transformCount/transformsDone)*100;
    }

    public String getStatusMessage() {
        return statusMessage;
    }

    private void setStatusMessage(String statusMessage) {
        String old = this.statusMessage;
        this.statusMessage = statusMessage;
        propertyChangeSupport.firePropertyChange("status", old, statusMessage);
    }

}
