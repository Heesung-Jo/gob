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

import com.enumfolder.bspl;
import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;


@Getter
@Setter
@Entity
public class teamdata { 

	
	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	
	
	 private String teamname; 
	 private String team_company;
	 
	 private String person_charge;
	 private String person_confirm;

	 private String process;
	 
	 
	 @OneToOne  // @ManyToOne
     @JoinColumn(name = "processdata_id")
     private processdata processdata;

	 @OneToOne  // @ManyToOne
     @JoinColumn(name = "Scopingdata_id")
     private Scopingdata Scopingdata;
	 
	 @JsonIgnore
	 @OneToMany(mappedBy = "teamdata", cascade = CascadeType.ALL)
	 private List<member> member = new ArrayList<>();
	 
	 public teamdata() {
		 
	 }


}