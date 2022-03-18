package com.enumfolder;

import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity; 


public enum position { 
	임원(0, "임원"), 팀장(1, "팀장"), 팀원(2, "팀원");

   private int num;
   private String value;

   position(int num, String value) {
       this.value = value;
   }



}