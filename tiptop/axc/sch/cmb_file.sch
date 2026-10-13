/*
================================================================================
檔案代號:cmb_file
檔案名稱:LCM 料件价格单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cmb_file
(
cmb01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
cmb02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
cmb03       varchar2(2),             /*异动类型                               */
                                     /*異動類別                               */
                                     /*銷售: 1A,1B,1C                         */
                                     /*進貨: 2A,2B,2C                         */
cmb04       date,                    /*异动日期-起值                          */
                                     /*異動日期-起值                          */
cmb05       date,                    /*异动日期-迄值                          */
                                     /*異動日期-迄值                          */
cmb06       number(20,6),            /*异动单价                               */
                                     /*異動單價                               */
cmb021      number(5) DEFAULT '0' NOT NULL, /*年度*/
cmb022      number(5) DEFAULT '0' NOT NULL, /*期别*/
cmblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cmb_file add  constraint cmb_pk primary key  (cmb01,cmb02,cmb021,cmb022) enable validate;
grant select on cmb_file to tiptopgp;
grant update on cmb_file to tiptopgp;
grant delete on cmb_file to tiptopgp;
grant insert on cmb_file to tiptopgp;
grant index on cmb_file to public;
grant select on cmb_file to ods;
