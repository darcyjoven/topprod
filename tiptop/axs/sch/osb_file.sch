/*
================================================================================
檔案代號:osb_file
檔案名稱:销售目标单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table osb_file
(
osb01       varchar2(20) NOT NULL,   /*目标单号                               */
                                     /*目標單號                               */
osb02       number(5) NOT NULL,      /*年度                                   */
osb03       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
osb04       number(20,6),            /*原币目标                               */
                                     /*原幣目標                               */
osb05       number(20,6),            /*本币目标                               */
                                     /*本幣目標                               */
osblegal    varchar2(10) NOT NULL,   /*所属法人                               */
osbplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table osb_file add  constraint osb_pk primary key  (osb01,osb02,osb03) enable validate;
grant select on osb_file to tiptopgp;
grant update on osb_file to tiptopgp;
grant delete on osb_file to tiptopgp;
grant insert on osb_file to tiptopgp;
grant index on osb_file to public;
grant select on osb_file to ods;
