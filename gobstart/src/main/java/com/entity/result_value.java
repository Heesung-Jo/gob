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

import javax.inject.Inject;

@Getter
@Setter
@Entity
public class result_value { 

	 // 210506 현재는 쓰지 않고 있으며, 나중에 자식과 부모 노드가 여러개가 발생하는 것을 대비하기 위해서 만들었음
	
	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	
	
	 private String name; 
	 private String val;
	 
	 @JsonIgnore
	 @ManyToOne
     @JoinColumn(name = "processoption_id")
     private processoption processoption;
	 
	 public result_value() {
		 
	 }
	 

}