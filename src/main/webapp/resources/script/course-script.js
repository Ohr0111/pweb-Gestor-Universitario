function courseValidation(){
		let name = document.querySelector(".name").value;
		
		
		if(name == "")
			document.querySelector(".name_message").style.display = "block";
		else{
			let years = name.split("-");
			if(parseInt(years[0])>=parseInt(years[1])){
				document.querySelector(".name_message").innerHTML="El curso inicial debe ser menor que el final";
				document.querySelector(".name_message").style.display = "block";
			}
			else{
				document.querySelector(".name_message").style.display = "none";
				return true}
			}
		
		return false;		
}