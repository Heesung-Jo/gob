package com.repository;





import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TypedQuery;

import org.springframework.stereotype.Component;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.entity.childnodedata;
import com.entity.parentnodedata;
import com.entity.processdata;
import com.entity.teamdata;

import java.sql.SQLException;


@Component
public class ParentnodedataRepositoryImpl implements ParentnodedataRepositoryCustom {


    @PersistenceContext
    EntityManager em;

    @Transactional
    public List<String> findstartlist(){

    	String sql = "select vi.processname1 from (select *, rank() over (partition by m.same_fc order by m.id) as rum from parentnodedata m) as vi where rum = 1";

        Query nativeQuery = em.createNativeQuery(sql);
                         

        List<String> resultList = nativeQuery.getResultList();
    	return resultList;
    }


    
    
    
	
} // The End...
