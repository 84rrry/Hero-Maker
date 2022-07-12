class Utils{
static int id=0;
static int createUniqueId(){
if(id==0) return id;
else return id+1;
}
}
