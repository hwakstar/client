<?php 
  
  $db = "test"; //database name
  $dbuser = "root"; //database username
  $dbpassword = ""; //database password
  $dbhost = "localhost"; //database host

  $return["error"] = false;
  $return["message"] = "";
  $return["success"] = false;

  $link = mysqli_connect($dbhost, $dbuser, $dbpassword, $db); 
    if(isset($_POST["email"])&&isset($_POST["username"])){
        $email = $_POST["email"];
        $password = md5($_POST["password"]);
        $name=$_POST["username"];
        $sql = "SELECT * FROM users WHERE email = '$email'";
        //building SQL query
        $res = mysqli_query($link, $sql);
        $numrows = mysqli_num_rows($res);
        //check if there is any row
        if($numrows > 0){
            $return["success"]=false;
            $return["message"]="Already user register";
            $return["error"] = true;
        
        } 
        else{
            $sqlin="INSERT INTO users (username,email,encrypted_password) VALUES ('$name','$email', '$password');";
            $resin = mysqli_query($link, $sqlin);
            $return["success"]=true;
            $return["message"]="Sucessfully register";
        }      
       
    }
  elseif(isset($_POST["email"]) && isset($_POST["password"])){
       //checking if there is POST data
       
       $email = $_POST["email"];
       $password = $_POST["password"];
       $email = mysqli_real_escape_string($link, $email);
       //escape inverted comma query conflict from string

       $sql = "SELECT * FROM users WHERE email = '$email'";
       //building SQL query
       $res = mysqli_query($link, $sql);
       $numrows = mysqli_num_rows($res);
       //check if there is any row
       if($numrows > 0){
           //is there is any data with that username
           $obj = mysqli_fetch_object($res);
           //get row as object
           //if(md5($password) == $obj->encrypted_password){
            if(md5($password) == $obj->encrypted_password){
            $return["success"] = true;
              // $return["uid"] = $obj->user_id;
               $return["email"] = $obj->email;
               $return["message"] = "Successfully login.";
              // $return["address"] = $obj->address;
           }else{
               $return["error"] = true;
               $return["message"] = "Your Password is Incorrect.";
           }
       }else{
           $return["error"] = true;
           $return["message"] = 'No Email found.';
       }
  }else{
      $return["error"] = true;
      $return["message"] = 'Send all parameters.';
      
  }

  mysqli_close($link);
 
  header('Content-Type: application/json');
  // tell browser that its a json data
  echo json_encode($return);
  //converting array to JSON string
?>