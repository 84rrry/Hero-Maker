class Utils{
static int id=0;
//Function to create a unique notification ID
static int createUniqueId(){
if(id==0) return id;
else return id+1;
}
}
