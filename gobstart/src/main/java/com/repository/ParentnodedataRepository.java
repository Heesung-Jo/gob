package com.repository;




import com.entity.parentnodedata;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


public interface ParentnodedataRepository extends JpaRepository<parentnodedata, Integer>, ParentnodedataRepositoryCustom {

   /* 다른데것 참고로 나둠	
	 @Query("select m.business from coagroupdata m group by m.business ")
	 List<String> findbusiness();
   
	 @Query("select m.processname1, rank() over (partition by m.same_fc order by m.id) rum from parentnodedata m ")
	 ArrayList<String> findstartlist();
	*/ 

	 
	
	

} // The End...
