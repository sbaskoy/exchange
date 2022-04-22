package com.example.kurtakip;

import android.os.AsyncTask;
import android.util.Log;

import com.google.firebase.crashlytics.buildtools.reloc.org.apache.commons.io.IOUtils;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;


public class ExchangeService {
    public static ArrayList<Currency> getExchange()  {
        try {
            URL url = new URL("https://www.tcmb.gov.tr/kurlar/today.xml");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestProperty("accept", "application/json");

            InputStream responseStream = connection.getInputStream();
            StringWriter writer = new StringWriter();

            IOUtils.copy(responseStream, writer);
            String theString = writer.toString();
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(new InputSource(new StringReader(theString)));
            doc.getDocumentElement().normalize();
            NodeList list = doc.getElementsByTagName("Currency");
            ArrayList<Currency> currencies=new ArrayList<Currency>();
            for (int temp = 0; temp < list.getLength(); temp++) {
                Node node = list.item(temp);
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    Element element = (Element) node;
                    String kod=element.getAttribute("Kod");
                    String name=element.getElementsByTagName("CurrencyName").item(0).getTextContent();
                    String buy=element.getElementsByTagName("ForexBuying").item(0).getTextContent();
                    String sell=element.getElementsByTagName("ForexSelling").item(0).getTextContent();
                    currencies.add(new Currency(
                            name,kod,buy,sell
                    ));
                }
            }

            return currencies;

        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        } catch (SAXException e) {
            e.printStackTrace();
        }
        return null;
    }

}
