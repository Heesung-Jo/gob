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
public class basequestion { 

	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	

	 private String mainprocess;
	 private String subprocess; 
	 private String question;
	 
	 // processoption과 연동시킬 부분임
	 private String prooptionname;
	 private String prooptionchange;
	 
	 @OneToMany(mappedBy = "basequestion", cascade = CascadeType.ALL)
	 private List<answerlist> answer = new ArrayList<>();

	 @JsonIgnore
	 @OneToMany(mappedBy = "basequestion", cascade = CascadeType.ALL)
	 private List<inputslist> inputslist = new ArrayList<>();

	 private String realname;
	 
	 private String example;
	 
	 private String examplelink;

	 private String template;
	 
	 private String inputs;
	 
	 private String inputslink;

	 
	 private String currentgrade;
	 private String person_charge;
	 private String person_confirm;
	 private String realgrade;
	 
	 
	 /* 현재는 딱히 필요없어보임(211207)
	 @OneToOne
     @JoinColumn(name = "processdata_id")
     private processdata processdata;
     */
	 
	 public basequestion() {
		 
	 }
          
	 public void setAnswer(List<answerlist> answer) {
		 this.answer = answer;
		 for(answerlist ans : answer) {
			 ans.setBasequestion(this);
		 }
	 }


}