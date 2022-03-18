package com.repository;





import com.entity.basicdata;
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

public interface ProcessdataRepositoryCustom  {

	List<basicdata> getprocessquery(String name1, String name2, String para1, String para2);
	List<basicdata> getprocessquery(ArrayList<String> names, ArrayList<String> paras);
	List<basicdata> getprocessquery(String name, String para);
} // The End...
