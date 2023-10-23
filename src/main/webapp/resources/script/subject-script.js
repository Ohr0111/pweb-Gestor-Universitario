function subjectValidation(){
		let name = document.querySelector(".name").value;
		let year = document.querySelector(".year").innerText.split("\n");
		let course = document.querySelector(".course").innerText.split("\n");
		
		if(name != "" && year[year.length-1]!="Seleccione" && course[course.length-1]!="Seleccione")
			return true;
		if(name == "")
			document.querySelector(".name_message").style.display = "block";
		else
			document.querySelector(".name_message").style.display = "none";
		if(year[year.length-1]=="Seleccione")
			document.querySelector(".year_message").style.display = "block";
		else
			document.querySelector(".year_message").style.display = "none";
		if(course[course.length-1]=="Seleccione")
			document.querySelector(".course_message").style.display = "block";
		else
			document.querySelector(".course_message").style.display = "none";
		
		return false;		
}
