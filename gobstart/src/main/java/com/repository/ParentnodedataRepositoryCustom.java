package com.repository;





import com.entity.processdata;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.cache.annotation.Cacheable;

public interface ParentnodedataRepositoryCustom  {
   
	List<String> findstartlist();

} // The End...
