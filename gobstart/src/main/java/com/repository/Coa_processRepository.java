package com.repository;

import com.entity.processdata;
import com.entity.answerlist;
import com.entity.answerstructure;
import com.entity.basequestion;
import com.entity.coa_process;
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
public interface Coa_processRepository extends JpaRepository<coa_process, Integer> {

	List<coa_process> findByRealcoa(String name);
	
	
	 @Query("select m.process from coa_process m group by m.process")
	 List<String> findgroupprocess();	

}



