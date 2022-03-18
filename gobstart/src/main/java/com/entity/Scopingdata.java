package com.entity; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.CascadeType;
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

import org.springframework.format.annotation.NumberFormat;
import org.springframework.stereotype.*;
import com.enumfolder.bspl;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Set;

import javax.annotation.Nullable;
import javax.inject.Inject;

@Getter
@Setter
@Entity
public class Scopingdata { 

	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	

	 @Enumerated(EnumType.STRING)
	 private bspl bspl;

	 private String coaname; 
	 private String realcoaname;
	 private String process;
	 
	 private Integer currentgrade;
	 private String person_charge;
	 
	 
	 @OneToOne(mappedBy = "Scopingdata", cascade = CascadeType.ALL)
	 private teamdata teamdata; 

	 
	 @Column(nullable = true) 
	 private String coalevel;
	 
	 
     private Double cashamount;
     
     private Integer quality1;     
     private Integer quality2;     
     private Integer quality3;     
     private Integer quality4;     
     private Integer quality5;     
     private Integer quality6; 
     
     @Column(nullable = true) 
     private String materiality;
     
	 public Scopingdata() {
		 
	 }
           


}