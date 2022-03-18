package com.entity; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity; 

import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.springframework.stereotype.*;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import javax.inject.Inject;

@Getter
@Setter
public class memberlist { 


	 private List<member> member = new ArrayList<>();
     
	 public memberlist() {
		 
	 }
           


}