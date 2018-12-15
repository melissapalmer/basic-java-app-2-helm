package com.example.demo;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Greeting {

	// @Id
	// @Column(name = "id")
	@Id
	@GeneratedValue
	private Long id;
	private String say;

	public String getSay() {
		return say;
	}

	public void setSay(String say) {
		this.say = say;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result + ((say == null) ? 0 : say.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (!(obj instanceof Greeting))
			return false;
		Greeting other = (Greeting) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (say == null) {
			if (other.say != null)
				return false;
		} else if (!say.equals(other.say))
			return false;
		return true;
	}
}
