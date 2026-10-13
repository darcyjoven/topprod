/*
================================================================================
檔案代號:srd_file
檔案名稱:生产计画资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table srd_file
(
srd01       number(5) NOT NULL,      /*年度                                   */
srd02       number(5) NOT NULL,      /*月份                                   */
srd03       varchar2(10) NOT NULL,   /*机台生产线                             */
srd04       varchar2(40) NOT NULL,   /*生产料号                               */
srd05       varchar2(10) NOT NULL,   /*班别                                   */
srd01d      number(5),               /*计划日1                                */
srd01e      number(15,3),            /*计划生产量1                            */
srd02d      number(5),               /*计划日2                                */
srd02e      number(15,3),            /*计划生产量2                            */
srd03d      number(5),               /*计划日3                                */
srd03e      number(15,3),            /*计划生产量3                            */
srd04d      number(5),               /*计划日4                                */
srd04e      number(15,3),            /*计划生产量4                            */
srd05d      number(5),               /*计划日5                                */
srd05e      number(15,3),            /*计划生产量5                            */
srd06d      number(5),               /*计划日6                                */
srd06e      number(15,3),            /*计划生产量6                            */
srd07d      number(5),               /*计划日7                                */
srd07e      number(15,3),            /*计划生产量7                            */
srd08d      number(5),               /*计划日8                                */
srd08e      number(15,3),            /*计划生产量8                            */
srd09d      number(5),               /*计划日9                                */
srd09e      number(15,3),            /*计划生产量9                            */
srd10d      number(5),               /*计划日10                               */
srd10e      number(15,3),            /*计划生产量10                           */
srd11d      number(5),               /*计划日11                               */
srd11e      number(15,3),            /*计划生产量11                           */
srd12d      number(5),               /*计划日12                               */
srd12e      number(15,3),            /*计划生产量12                           */
srd13d      number(5),               /*计划日13                               */
srd13e      number(15,3),            /*计划生产量13                           */
srd14d      number(5),               /*计划日14                               */
srd14e      number(15,3),            /*计划生产量14                           */
srd15d      number(5),               /*计划日15                               */
srd15e      number(15,3),            /*计划生产量15                           */
srd16d      number(5),               /*计划日16                               */
srd16e      number(15,3),            /*计划生产量16                           */
srd17d      number(5),               /*计划日17                               */
srd17e      number(15,3),            /*计划生产量17                           */
srd18d      number(5),               /*计划日18                               */
srd18e      number(15,3),            /*计划生产量18                           */
srd19d      number(5),               /*计划日19                               */
srd19e      number(15,3),            /*计划生产量19                           */
srd20d      number(5),               /*计划日20                               */
srd20e      number(15,3),            /*计划生产量20                           */
srd21d      number(5),               /*计划日21                               */
srd21e      number(15,3),            /*计划生产量21                           */
srd22d      number(5),               /*计划日22                               */
srd22e      number(15,3),            /*计划生产量22                           */
srd23d      number(5),               /*计划日23                               */
srd23e      number(15,3),            /*计划生产量23                           */
srd24d      number(5),               /*计划日24                               */
srd24e      number(15,3),            /*计划生产量24                           */
srd25d      number(5),               /*计划日25                               */
srd25e      number(15,3),            /*计划生产量25                           */
srd26d      number(5),               /*计划日26                               */
srd26e      number(15,3),            /*计划生产量26                           */
srd27d      number(5),               /*计划日27                               */
srd27e      number(15,3),            /*计划生产量27                           */
srd28d      number(5),               /*计划日28                               */
srd28e      number(15,3),            /*计划生产量28                           */
srd29d      number(5),               /*计划日29                               */
srd29e      number(15,3),            /*计划生产量29                           */
srd30d      number(5),               /*计划日30                               */
srd30e      number(15,3),            /*计划生产量30                           */
srd31d      number(5),               /*计划日31                               */
srd31e      number(15,3),            /*计划生产量31                           */
srd32d      number(5),               /*计划日32                               */
srd32e      number(15,3),            /*计划生产量32                           */
srd33d      number(5),               /*计划日33                               */
srd33e      number(15,3),            /*计划生产量33                           */
srd34d      number(5),               /*计划日34                               */
srd34e      number(15,3),            /*计划生产量34                           */
srd35d      number(5),               /*计划日35                               */
srd35e      number(15,3),            /*计划生产量35                           */
srd36d      number(5),               /*计划日36                               */
srd36e      number(15,3),            /*计划生产量36                           */
srd37d      number(5),               /*计划日37                               */
srd37e      number(15,3),            /*计划生产量37                           */
srd38d      number(5),               /*计划日38                               */
srd38e      number(15,3),            /*计划生产量38                           */
srd39d      number(5),               /*计划日39                               */
srd39e      number(15,3),            /*计划生产量39                           */
srd40d      number(5),               /*计划日40                               */
srd40e      number(15,3),            /*计划生产量40                           */
srd41d      number(5),               /*计划日41                               */
srd41e      number(15,3),            /*计划生产量41                           */
srd42d      number(5),               /*计划日42                               */
srd42e      number(15,3),            /*计划生产量42                           */
srd051      varchar2(20),            /*特性代码                               */
srdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
srdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table srd_file add  constraint srd_pk primary key  (srd01,srd02,srd03,srd04,srd05) enable validate;
grant select on srd_file to tiptopgp;
grant update on srd_file to tiptopgp;
grant delete on srd_file to tiptopgp;
grant insert on srd_file to tiptopgp;
grant index on srd_file to public;
grant select on srd_file to ods;
