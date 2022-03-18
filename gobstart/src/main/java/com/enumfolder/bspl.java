package com.enumfolder;

import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity; 


public enum bspl { 
	BS(0, "BS"), PL(1, "PL");

   private int num;
   private String value;

   bspl(int num, String value) {
       this.value = value;
   }



}