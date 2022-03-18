package com.repository;

import com.entity.processdata;
import com.entity.basequestion;
import com.entity.coadata;
import com.entity.teamdata;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import java.util.ArrayList;
import java.util.List;

/**
 * User: HolyEyE
 * Date: 2013. 12. 3. Time: 오전 1:08
 */
@Repository
public interface BasequestionRepository extends JpaRepository<basequestion, Integer> {

	 @Query("select m.mainprocess from basequestion m group by m.mainprocess order by m.mainprocess")
	 List<String> findlist();
	 
	 List<basequestion> findBySubprocess(String name);
	 List<basequestion> findByProoptionname(String name);
	 List<basequestion> findByMainprocess(String name);
	 List<basequestion> findByMainprocessAndSubprocess(String name1, String name2);
	 basequestion findByRealname(String name);
}



