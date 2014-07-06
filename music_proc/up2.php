<?

if(!is_dir("./files")) mkdir("./files", 0755); 
move_uploaded_file($_FILES['Filedata']['tmp_name'], "./files"."/".$_FILES['Filedata']['name']);
chmod("./files"."/".$_FILES['Filedata']['name'], 0777);  

?>
