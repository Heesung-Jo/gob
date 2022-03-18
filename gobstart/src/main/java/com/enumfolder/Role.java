package com.enumfolder;


import javax.persistence.*;
import java.io.Serializable;
import java.util.Set;

/**
 *
 * @author Mick Knutson
 */
public enum Role {

	   임원(0, "임원"), 팀장(1, "팀장"), 팀원(2, "팀원");

	   private int num;
	   private String key;
	   private String title;

	   Role(int num, String key) {
	       this.key = key;
	   } 

	   
	   Role(String key, String title) {
	        this.key = key;
	        this.title = title;
	    }

	    public String getKey() {
	        return this.key;
	    }


	    public String gettitle() {
	        return this.title;
	    }	   

	   
	} // The End...