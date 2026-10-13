/*
================================================================================
檔案代號:odh_file
檔案名稱:预测模拟单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odh_file
(
odh01       varchar2(10) NOT NULL,   /*预测版本                               */
odh02       varchar2(10) NOT NULL,   /*组织编号                               */
odh03       varchar2(40) NOT NULL,   /*预测料号                               */
odh04       date NOT NULL,           /*时距                                   */
odh05       number(15,3),            /*模拟数量                               */
odh06       number(20,6),            /*模拟金额                               */
odh07       number(15,3),            /*基准数量                               */
odh08       number(20,6),            /*基准金额                               */
odh09       date                     /*基准时距                               */
);

alter table odh_file add  constraint odh_pk primary key  (odh01,odh02,odh03,odh04) enable validate;
grant select on odh_file to tiptopgp;
grant update on odh_file to tiptopgp;
grant delete on odh_file to tiptopgp;
grant insert on odh_file to tiptopgp;
grant index on odh_file to public;
grant select on odh_file to ods;
