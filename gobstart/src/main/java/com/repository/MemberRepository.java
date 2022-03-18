package com.repository;

import com.entity.member;
import com.entity.teamdata;
import com.entity.member;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface MemberRepository extends JpaRepository<member, Integer> {

    List<member> findByEmail(String name); 
    List<member> findByRealname(String name); 
    
} // The End...
