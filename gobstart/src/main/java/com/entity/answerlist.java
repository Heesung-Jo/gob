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
import javax.persistence.Version;

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
public class answerlist { 

	
	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	
	 
	 private String mainprocess;       // 재고자산, 구매 등의 프로세스를 의미함
	 
	 private String subprocess1;       // 공장의 구분을 뜻함. 딸기공장, 바나나공장
	 
	 private String subprocess2;       // 공정의 구분을 뜻함. 입고, 생산, 출고공정
	 
	 private String subprocess3;       // 공정의 흐름의 뒤편 뜻함. 입고 => 생산이면 생산

	 private String step;
	 
	 private String val;

	    
	 @JsonIgnore
	 @ManyToOne
     @JoinColumn(name = "basequestion_id")
     private basequestion basequestion;

	 @JsonIgnore
	 @ManyToOne
     @JoinColumn(name = "anwserstructure_id")
     private answerstructure anwserstructure;

	 
	 
	 public answerlist() {
		 
	 }
           


}