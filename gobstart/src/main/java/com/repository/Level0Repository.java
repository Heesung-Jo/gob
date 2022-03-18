package com.repository;

import com.entity.processdata;
import com.entity.answerlist;
import com.entity.answerstructure;
import com.entity.basequestion;
import com.entity.coadata;
import com.entity.level0table;
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
public interface Level0Repository extends JpaRepository<level0table, Integer> {

	List<level0table> findByRealname(String name1);
}



