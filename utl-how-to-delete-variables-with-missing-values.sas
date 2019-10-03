How to delete variables with missing values                                                                                
                                                                                                                           
github                                                                                                                     
https://tinyurl.com/y3uzuacu                                                                                               
https://github.com/rogerjdeangelis/utl-how-to-delete-variables-with-missing-values                                         
                                                                                                                           
   Four Solutions                                                                                                          
       a. freq nlevels                                                                                                     
                                                                                                                           
       b. one pass view                                                                                                    
          Paul Dorfman                                                                                                     
          sashole@bellsouth.net                                                                                            
                                                                                                                           
       c. hash drop                                                                                                        
          Paul Dorfman                                                                                                     
          sashole@bellsouth.net                                                                                            
                                                                                                                           
       d. hash keep                                                                                                        
          Paul Dorfman                                                                                                     
          sashole@bellsouth.net                                                                                            
                                                                                                                           
                                                                                                                           
sas forum                                                                                                                  
https://tinyurl.com/yylxk6lx                                                                                               
https://communities.sas.com/t5/SAS-Programming/How-to-delete-variables-with-missing-values/m-p/593273                      
                                                                                                                           
*_                   _                                                                                                     
(_)_ __  _ __  _   _| |_                                                                                                   
| | '_ \| '_ \| | | | __|                                                                                                  
| | | | | |_) | |_| | |_                                                                                                   
|_|_| |_| .__/ \__,_|\__|                                                                                                  
        |_|                                                                                                                
;                                                                                                                          
                                                                                                                           
                                                                                                                           
data have;                                                                                                                 
  input VarA VarB VarC VarD VarE VarF;                                                                                     
datalines;                                                                                                                 
1 2 3 1 2 3                                                                                                                
1 2 3 1 2 3                                                                                                                
1 2 3 1 2 .                                                                                                                
1 2 3 . 2 .                                                                                                                
1 2 3 1 2 3                                                                                                                
1 . 3 1 . 3                                                                                                                
1 . 3 1 . 3                                                                                                                
;;;;                                                                                                                       
run;quit;                                                                                                                  
                                                                                                                           
*           _                                                                                                              
 _ __ _   _| | ___  ___                                                                                                    
| '__| | | | |/ _ \/ __|                                                                                                   
| |  | |_| | |  __/\__ \                                                                                                   
|_|   \__,_|_|\___||___/                                                                                                   
                                                                                                                           
;                                                                                                                          
                                                                                                                           
Up to 40 obs WORK.HAVE total obs=7              | RULES                                                                    
                                                |                                                                          
 VARA    VARB    VARC    VARD    VARE    VARF   | Drop VarB VarD VarE VarF                                                 
                                                | because they have at least one missing                                   
   1       2       3       1       2       3    |                                                                          
   1       2       3       1       2       3    |                                                                          
   1       2       3       1       2       .    |                                                                          
   1       2       3       .       2       .    |                                                                          
   1       2       3       1       2       3    |                                                                          
   1       .       3       1       .       3    |                                                                          
   1       .       3       1       .       3    |                                                                          
                                                                                                                           
*            _               _                                                                                             
  ___  _   _| |_ _ __  _   _| |_                                                                                           
 / _ \| | | | __| '_ \| | | | __|                                                                                          
| (_) | |_| | |_| |_) | |_| | |_                                                                                           
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                          
                |_|                                                                                                        
;                                                                                                                          
                                                                                                                           
                                                                                                                           
WORK.WANT total obs=7                                                                                                      
                                                                                                                           
 VARA    VARC                                                                                                              
                                                                                                                           
   1       3                                                                                                               
   1       3                                                                                                               
   1       3                                                                                                               
   1       3                                                                                                               
   1       3                                                                                                               
   1       3                                                                                                               
   1       3                                                                                                               
                                                                                                                           
*                                                                                                                          
 _ __  _ __ ___   ___ ___  ___ ___                                                                                         
| '_ \| '__/ _ \ / __/ _ \/ __/ __|                                                                                        
| |_) | | | (_) | (_|  __/\__ \__ \                                                                                        
| .__/|_|  \___/ \___\___||___/___/                                                                                        
|_|                                                                                                                        
  __ _      / _|_ __ ___  __ _                                                                                             
 / _` |    | |_| '__/ _ \/ _` |                                                                                            
| (_| |_   |  _| | |  __/ (_| |                                                                                            
 \__,_(_)  |_| |_|  \___|\__, |                                                                                            
                            |_|                                                                                            
;                                                                                                                          
* package in one datastep;                                                                                                 
                                                                                                                           
data want;                                                                                                                 
                                                                                                                           
 if _n_=0 then do; %let rc=%sysfunc(dosubl('                                                                               
                                                                                                                           
    ods exclude all;                                                                                                       
    ods output nlevels=havMis(keep=tablevar nmisslevels);                                                                  
    proc freq data=have nlevels;                                                                                           
    tables _all_ / noprint;                                                                                                
    run;quit;                                                                                                              
    ods select all;                                                                                                        
                                                                                                                           
    proc sql;                                                                                                              
      select tablevar into :_vars separated by " " from havMis where nmisslevels ne 0                                      
    ;quit;                                                                                                                 
                                                                                                                           
    %put &_vars;                                                                                                           
                                                                                                                           
    '));                                                                                                                   
 end;                                                                                                                      
                                                                                                                           
 set have ( drop = &_vars );                                                                                               
                                                                                                                           
run;quit;                                                                                                                  
                                                                                                                           
*_        _               _           _                                                                                    
| |__    | |__   __ _ ___| |__     __| |_ __ ___  _ __                                                                     
| '_ \   | '_ \ / _` / __| '_ \   / _` | '__/ _ \| '_ \                                                                    
| |_) |  | | | | (_| \__ \ | | | | (_| | | | (_) | |_) |                                                                   
|_.__(_) |_| |_|\__,_|___/_| |_|  \__,_|_|  \___/| .__/                                                                    
                                                 |_|                                                                       
;                                                                                                                          
                                                                                                                           
A plethora of single-step self-contained variants are possible via a hash                                                  
or hashes. For example, this one is based on composing a DROP list via                                                     
auxiliary hash X:                                                                                                          
                                                                                                                           
data have ;                                                                                                                
  input VarA VarB VarC VarD VarE VarF ;                                                                                    
  cards ;                                                                                                                  
1 2 3 1 2 3                                                                                                                
1 2 3 1 2 3                                                                                                                
1 2 3 1 2 .                                                                                                                
1 2 3 . 2 .                                                                                                                
1 2 3 1 2 3                                                                                                                
1 . 3 1 . 3                                                                                                                
1 . 3 1 . 3                                                                                                                
;                                                                                                                          
run ;                                                                                                                      
                                                                                                                           
data _null_ ;                                                                                                              
  set have end = z ;                                                                                                       
  array v var: ;                                                                                                           
  if _n_ = 1 then do ;                                                                                                     
    dcl hash h (ordered:"a") ;                                                                                             
    h.definekey ("_n_") ;                                                                                                  
    do over v ;                                                                                                            
      h.definedata (vname (v)) ;                                                                                           
    end ;                                                                                                                  
    h.definedone() ;                                                                                                       
    dcl hash x () ;                                                                                                        
    x.definekey ("vn") ;                                                                                                   
    x.definedone () ;                                                                                                      
    dcl hiter ix ("x") ;                                                                                                   
  end ;                                                                                                                    
  h.add() ;                                                                                                                
  do over v ;                                                                                                              
    if N (v) then continue ;                                                                                               
    vn = put (vname (v), $32.) ;                                                                                           
    x.ref() ;                                                                                                              
  end ;                                                                                                                    
  if z ;                                                                                                                   
  length kill $ 32767 ;                                                                                                    
  do while (ix.next() = 0) ;                                                                                               
    kill = catx (" ", kill, vn) ;                                                                                          
  end ;                                                                                                                    
  h.output (dataset: cats ("want(drop=",kill,")")) ;                                                                       
run ;                                                                                                                      
                                                                                                                           
*          _               _       _                                                                                       
  ___     | |__   __ _ ___| |__   | | _____  ___ _ __                                                                      
 / __|    | '_ \ / _` / __| '_ \  | |/ / _ \/ _ \ '_ \                                                                     
| (__ _   | | | | (_| \__ \ | | | |   <  __/  __/ |_) |                                                                    
 \___(_)  |_| |_|\__,_|___/_| |_| |_|\_\___|\___| .__/                                                                     
                                                |_|                                                                        
;                                                                                                                          
                                                                                                                           
This one is based on defining only the needed variables to hash H in the                                                   
first place:                                                                                                               
                                                                                                                           
data _null_ ;                                                                                                              
  if _n_ = 1 then do ;                                                                                                     
    dcl hash x () ;                                                                                                        
    x.definekey ("vn") ;                                                                                                   
    x.definedone () ;                                                                                                      
    dcl hiter ix ("x") ;                                                                                                   
  end ;                                                                                                                    
  set have end = z ;                                                                                                       
  array v var: ;                                                                                                           
  do over v ;                                                                                                              
    if N (v) then continue ;                                                                                               
    vn = put (vname (v), $32.) ;                                                                                           
    x.ref() ;                                                                                                              
  end ;                                                                                                                    
  if z ;                                                                                                                   
  x.output (dataset:"hash") ;                                                                                              
  dcl hash h (dataset:"have", multidata:"y") ;                                                                             
  h.definekey ("vara") ;                                                                                                   
  do over v ;                                                                                                              
    do k = 1 by 0 while (ix.next() = 0) ;                                                                                  
      if vname (v) = vn then k = 0 ;                                                                                       
    end ;                                                                                                                  
    if k then h.definedata (vname (v)) ;                                                                                   
  end ;                                                                                                                    
  h.definedone() ;                                                                                                         
  h.output (dataset: "want") ;                                                                                             
run ;                                                                                                                      
                                                                                                                           
                                                                                                                           
Practically, though, perhaps the most economical method is to auto-define a                                                
view with the unneeded vars dropped and then refer to it instead of HAVE                                                   
downstream. This way, the entire thing requires nothing more than a single                                                 
pass through the input. For example:                                                                                       
                                                                                                                           
*    _                                                    _                                                                
  __| |     ___  _ __   ___   _ __   __ _ ___ ___  __   _(_) _____      __                                                 
 / _` |    / _ \| '_ \ / _ \ | '_ \ / _` / __/ __| \ \ / / |/ _ \ \ /\ / /                                                 
| (_| |_  | (_) | | | |  __/ | |_) | (_| \__ \__ \  \ V /| |  __/\ V  V /                                                  
 \__,_(_)  \___/|_| |_|\___| | .__/ \__,_|___/___/   \_/ |_|\___| \_/\_/                                                   
                             |_|                                                                                           
;                                                                                                                          
                                                                                                                           
data have ;                                                                                                                
  input VarA VarB VarC VarD VarE VarF ;                                                                                    
  cards ;                                                                                                                  
1 2 3 1 2 3                                                                                                                
1 2 3 1 2 3                                                                                                                
1 2 3 1 2 .                                                                                                                
1 2 3 . 2 .                                                                                                                
1 2 3 1 2 3                                                                                                                
1 . 3 1 . 3                                                                                                                
1 . 3 1 . 3                                                                                                                
;                                                                                                                          
run ;                                                                                                                      
                                                                                                                           
                                                                                                                           
data _null_ ;                                                                                                              
  do until (z) ;                                                                                                           
    set have end = z ;                                                                                                     
    array v var: ;                                                                                                         
    length _d $ 32767 ;                                                                                                    
    do over v ;                                                                                                            
      if missing (v) and findw (_d, vname(v)) = 0 then _d = catx (" ", _d, vname (v)) ;                                    
    end ;                                                                                                                  
  end ;                                                                                                                    
  call execute (cats ("data vhave/view=vhave; set have(drop=", _d, ");                                                     
run;")) ;                                                                                                                  
run ;                                                                                                                      
                                                                                                                           
