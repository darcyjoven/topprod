create table hrck_file(
     hrck01    varchar2(20) NOT NULL,
     hrck02    varchar2(20) NOT NULL,
     hrck12    varchar2(255)  NULL,
     hrckacti  varchar2(1),
     hrckud01  varchar2(255),
     hrckud02  varchar2(40),
     hrckud03  varchar2(40),
     hrckud04  varchar2(40),
     hrckud05  varchar2(40),
     hrckud06  varchar2(40),
     hrckud07  number(15,3),
     hrckud08  number(15,3),
     hrckud09  number(15,3),
     hrckud10  number(10), 
     hrckud11  number(10), 
     hrckud12  number(10),  
     hrckud13  date,        
     hrckud14  date,        
     hrckud15  date,        
     hrckuser  varchar2(10),
     hrckgrup  varchar2(10),
     hrckmodu  varchar2(10),
     hrckdate  date,        
     hrckorig  varchar2(10),
     hrckoriu  varchar2(10) 
                          );
 alter table hrck_file add  constraint tpc_hrck_pk primary key  (hrck01) enable validate;
 grant select on hrck_file to tiptopgp;
 grant update on hrck_file to tiptopgp;
 grant delete on hrck_file to tiptopgp;
 grant insert on hrck_file to tiptopgp;
 grant index on hrck_file to public;
 grant select on hrck_file to ods;

  
