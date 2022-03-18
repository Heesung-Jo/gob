package com.entity; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity;
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
import javax.persistence.OneToMany;
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
@Entity
public class level0table { 

	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	


	 private String realname;
	 private String currentgrade;
	 private String person_charge;
	 private Integer realgrade;
	 private String viewname;

	 public level0table() {
		 
	 }
          

}