package fau.popl.exercise2

public abstract class Animal {
	protected static int idCounter;
	private String name;
	private Boolean carnivore;
	private String id;
	
	public Animal(name:String, carnivore:Boolean) {
		this.name = name;
		this.carnivore = carnivore;
	}

	public def getName():String {
		return this.name;
	}

	public def setName(name:String) {
		this.name = name;
	}

	public def getCarnivore():Boolean {
		return this.carnivore;
	}

	public def setCarnivore(carnivore:Boolean) {
		this.carnivore = carnivore;
	}

	@Override
	public def toString():String {
	    StringBuilder result = new StringBuilder();
	    String NEW_LINE = System.getProperty("line.separator");

	    result.append(this.getClass().getName() + NEW_LINE);

	    return result.toString();
  	}
}

public class Mammal extends Animal {
	public Mammal(String name, Boolean carnivore) {
		super(name, carnivore);
	}
}

public class Bird extends Animal {
	protected Double wingSpan; 

	public Mammal(String name, Boolean carnivore, Double wingSpan) {
		this.wingSpan = wingSpan
		super(name, carnivore);
	}

	public void setWingSpan(Double wingSpan) {
		this.wingSpan = wingSpan;
	}

	public Double getWingSpan() {
		return this.wingSpan;
	}
}

public class Reptile extends Animal {
	protected Double bodyTemperature; 

	public Mammal(String name, Boolean carnivore, Double bodyTemperature) {
		this.bodyTemperature = bodyTemperature
		super(name, carnivore);
	}

	public void setBodyTemperature(Double bodyTemperature) {
		this.bodyTemperature = bodyTemperature;
	}

	public Double getTemperature() {
		return this.bodyTemperature;
	}
}