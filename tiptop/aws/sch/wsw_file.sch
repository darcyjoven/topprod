/*
================================================================================
檔案代號:wsw_file
檔案名稱:基本资料异动记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsw_file
(
wsw01       varchar2(20) NOT NULL,   /*程序编号                               */
wsw02       varchar2(20) NOT NULL,   /*档案代码                               */
wsw03       varchar2(100) NOT NULL,  /*KEY值                                  */
wsw04       varchar2(10) NOT NULL,   /*ACTION名称                             */
wsw05       varchar2(4000),          /*record 资料字串                        */
wsw06       varchar2(10) NOT NULL,   /*异动日期                               */
wsw07       varchar2(8) NOT NULL,    /*异动时间                               */
wsw08       varchar2(10),            /*资料更改者                             */
wsw09       varchar2(1)              /*处理状态                               */
);

alter table wsw_file add  constraint wsw_pk primary key  (wsw01,wsw02,wsw03,wsw04,wsw06,wsw07) enable validate;
grant select on wsw_file to tiptopgp;
grant update on wsw_file to tiptopgp;
grant delete on wsw_file to tiptopgp;
grant insert on wsw_file to tiptopgp;
grant index on wsw_file to public;
grant select on wsw_file to ods;
