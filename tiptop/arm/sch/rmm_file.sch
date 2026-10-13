/*
================================================================================
檔案代號:rmm_file
檔案名稱:不良品分析单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmm_file
(
rmm01       varchar2(20) NOT NULL,   /*不良品分析单单号                       */
                                     /*不良品分析單單號                       */
rmm02       number(5) NOT NULL,      /*不良品分析单项次                       */
                                     /*不良品分析單項次                       */
rmm03       varchar2(20),            /*RMA 单号                               */
                                     /*RMA 單號                               */
rmm04       number(5),               /*项次                                   */
                                     /*項次                                   */
rmm05       varchar2(1),             /*判定结果                               */
                                     /*判定結果                               */
                                     /* 1.可用                                */
                                     /* 2.不良                                */
                                     /* 3.報廢                                */
rmmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmmlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table rmm_file add  constraint rmm_pk primary key  (rmm01,rmm02) enable validate;
grant select on rmm_file to tiptopgp;
grant update on rmm_file to tiptopgp;
grant delete on rmm_file to tiptopgp;
grant insert on rmm_file to tiptopgp;
grant index on rmm_file to public;
grant select on rmm_file to ods;
