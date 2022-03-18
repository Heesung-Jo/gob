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

import java.util.List;
import java.util.Set;

import javax.inject.Inject;

@Getter
@Setter
@Entity
public class coadata { 

	
	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	

	 private String bspl;

	 private String detailname; 
	 private String resultname;

	 /* 현재는 딱히 필요없어보임(211207)
	 @OneToOne
     @JoinColumn(name = "processdata_id")
     private processdata processdata;
     */
	 
	 public coadata() {
		 
	 }
           


}