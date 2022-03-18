package com.repository;




import com.entity.basicdata;
import com.entity.processdata;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


public interface ProcessdataRepository extends JpaRepository<processdata, Integer>, ProcessdataRepositoryCustom {

    /* 다른데것 참고로 나둠	
	 @Query("select m.business from coagroupdata m group by m.business ")
	 List<String> findbusiness();

	 @Query("select m.name from coagroupdata m group by m.name ")
	 List<String> findcoaname();
	*/
	
	 @Query("select m.mainprocess, m.subprocess from processdata m group by m.mainprocess, m.subprocess")
	 List<String[]> findmain_subprocess();	
	
	 List<basicdata> findByName(String name);

	 ArrayList<basicdata> findByProcessname1(String name);
	 ArrayList<basicdata> findByMainprocessAndSubprocess(String name1, String name2);
	 
	 
} // The End...
