package com.entity;

import com.enumfolder.Role;
import com.enumfolder.position;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;


/**
 * {@link member} is this applications notion of a user. It is good to use your own objects to interact with a
 * user especially in large applications. This ensures that as you evolve your security requirements (update Spring
 * Security, leverage new Spring Security modules, or even swap out security implementations) you can do so easily.
 *
 * @author Rob Winch
 * @author Mick Knutson
 *
 */

@Getter
@Setter
@Entity
@Table(name = "member_users")
public class member {

    @Id
    @JsonIgnore
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    private String name;

    private String email;
    private String password;
    
    private String realname;
    
    private String division;
    
    private String teamname;
    
    /*
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;
   */
    
	 @JsonIgnore
	 @OneToMany(mappedBy = "member", cascade = CascadeType.ALL)
	 private List<roledata> roledata = new ArrayList<>();
    
    
	@JsonIgnore
	@ManyToOne
    @JoinColumn(name = "teamdata_id")
    private teamdata teamdata;
    

    /**
     * Gets the email address for this user. When authenticating against this data directly, this is also used as the
     * username.
     *
     * @return
     */
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Gets the first name of the user.
     *
     * @return
     */


    /**
     * Gets the id for this user. When creating a new user this should be null, otherwise it will be non-null.
     *
     * @return
     */
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * Gets the last name of the user.
     *
     * @return
     */
    /**
     * Gets the password for this user. In some instances, this password is not actually used. For example, when an in
     * memory authentication is used the password on the spring security User object is used.
     *
     * @return
     */
    @JsonIgnore
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * Get the list of Roles for this CalendarUser
     * @return
     */
    
    /*
	 public void setRole(Role role) {
	    	this.role = role;
	    }
	    
	    public String getRoleKey() {
	        return this.role.getKey();
	    }
      */



    // --- convenience methods ---

    /**
     * Gets the full name in a formatted fashion. Note in a real application a formatter may be more appropriate, but in
     * this application simplicity is more important.
     *
     * @return
     */
    @JsonIgnore
    public String getName() {
        return getEmail();
    }

    // --- override Object ---

    @Override
    public int hashCode() {
        //return HashCodeBuilder.reflectionHashCode(this);
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        //return EqualsBuilder.reflectionEquals(this, obj);
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        member other = (member) obj;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        return true;
    }




} // The End...
