/*
================================================================================
檔案代號:obh_file
檔案名稱:下阶营运中心销售预测单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table obh_file
(
obh01       varchar2(40) NOT NULL,   /*料件编号                               */
obh02       varchar2(1) NOT NULL,    /*计划期别格式                           */
obh021      number(10) NOT NULL,     /*起始期别                               */
obh03       number(5) NOT NULL,      /*序号                                   */
obh04       varchar2(10) NOT NULL,   /*下阶营运中心                           */
obh05       number(15,3),            /*下阶需求量                             */
obh06       number(15,3),            /*下阶调整量                             */
obh07       number(15,3),            /*小计                                   */
obh08       varchar2(1),             /*No                                     */
obh09       varchar2(1),             /*No                                     */
obhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
obhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table obh_file add  constraint obh_pk primary key  (obh01,obh02,obh021,obh03,obh04) enable validate;
grant select on obh_file to tiptopgp;
grant update on obh_file to tiptopgp;
grant delete on obh_file to tiptopgp;
grant insert on obh_file to tiptopgp;
grant index on obh_file to public;
grant select on obh_file to ods;
