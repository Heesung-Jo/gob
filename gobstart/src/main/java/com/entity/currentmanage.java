package com.entity; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToOne;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.springframework.stereotype.*;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Set;

import javax.inject.Inject;

@Getter
@Setter
@Entity
public class currentmanage implements Comparable<currentmanage>  { 

	
	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	
	 
	 private String grade;
	 
	 private String realturn;
	 private String viewname;
	 
	 private String realteam;
	 private Integer currentgrade;
	 private String person1;
	 private String grade1;
	 private String person2;
	 private String grade2;
	 private String person3;
	 private String grade3;
	 
	 
	 public currentmanage() {
		 
	 }
	 
	 @Override
	  public int compareTo(currentmanage o) {
	      return this.realturn.compareTo(o.realturn);
	  }


}