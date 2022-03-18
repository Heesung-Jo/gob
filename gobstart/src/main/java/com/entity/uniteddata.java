package com.entity; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToOne;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.springframework.stereotype.*;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import javax.inject.Inject;

@Getter
@Setter
@Entity
@DiscriminatorValue("UNITE")
public class uniteddata extends processdata { 

	

	public uniteddata() {
		super();
	}

     // 여기가 진짜임
     // 통합을 위한 추가변수들
     private String subprocesstype;
     private String productline;
     
     @JsonIgnore
     @ManyToMany(fetch = FetchType.EAGER)
     @JoinTable(name = "superpro_subpro",
             joinColumns = @JoinColumn(name = "superpro_id"),
             inverseJoinColumns = @JoinColumn(name = "subpro_id"))
     private Set<uniteddata> subunite;

     @JsonIgnore
     @ManyToMany(fetch = FetchType.EAGER, mappedBy = "subpro")
     private Set<uniteddata> superunite;
  

}