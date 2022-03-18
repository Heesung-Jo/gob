package com.repository;




import com.entity.processdata;
import com.entity.uniteddata;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


public interface UniteddataRepository extends JpaRepository<uniteddata, Integer> {

   /* 다른데것 참고로 나둠	
	 @Query("select m.business from coagroupdata m group by m.business ")
	 List<String> findbusiness();

	 @Query("select m.name from coagroupdata m group by m.name ")
	 List<String> findcoaname();
	*/

	
	 List<uniteddata> findByName(String name);
	 List<uniteddata> findByPersoncharge(String name);
	 
	 ArrayList<uniteddata> findByProcessname1(String name);
	 ArrayList<uniteddata> findByMainprocessAndSubprocess(String name1, String name2);
	 
	 
} // The End...
