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

import javax.inject.Inject;

@Getter
@Setter
@Entity
@Table
public class unitedoption { 
	
	 @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column
	 private Long id;	
	
	 private String realname;  // team 등의 옵션의 이름을 의미함. 앞에서 ^{team1: 회계팀}^ 이런식으로 들어올 계획임
	                       // 나중에 team이 겹치면 team1, team2로 구분하기 위함임 
	 private String refname; // 이게 processdetail1을 ref하는지 controldetail1을 ref하는지 알 수 없기때문에 그것을 구분하기 위함임

	 @JsonIgnore
	 @ManyToOne
     @JoinColumn(name = "processdata_id")
     private processdata processdata;
     
	 
	 // 위의 예시라면 team에 들어갈 수 있는 값임. 여기서는 회계팀만 가능하므로 option1에 회계팀이 들어갈 것임
	 // 그러나 다른 예로서, 승인이라고 하면, 1. 전결권자의 승인, 2. 운영위원회의 의결, 3. 이사회의 의결 등으로 option이 여러개일 수 있음
	 // 이 부분도 arraylist도 반영할 것인가 고민중에 있음
	 private String option1;
	 private String option2;
	 private String option3;
	 private String option4;
	 private String option5;
	 
	 private String result_value;  // 나중에 옵션값이 선택된 결과값을 받을 변수
	 
	 
	 /// 위의 option을 어떻게 활용할 것인지 결정하기 위함
	 /// 예를들어 team에 회계팀이 있는데, 옵션에 회계팀이 아니라, lstm을 활용하여, 이와 유사한 팀을 띄울 거라면, 액션은 lstm이 될 것이고
	 /// 포괄적 질문에서 해당 프로세스를 수행하는 
	 private String action_before;
	 private String action_after;
	 
	 
	 private String showing; // 드랍박스인지 텍스트 박스인지 등을 결정함
	 
	 /// 위의 예로 계속 설명한다면, 만약에 전결권자의 승인만으로는 리스크가 있다면 risk1의 값은 option1이 됨
	 /// 추후 회사에서 option1을 값으로 선택했다면 이것은 리스크가 있다고 집계되는 것임
	 private String risk1;
	 private String risk2;
	 private String risk3;
	 private String risk4;
	 private String risk5;

	 private Integer num1;
	 private Integer num2;
	 
}