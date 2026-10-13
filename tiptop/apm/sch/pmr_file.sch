/*
================================================================================
檔案代號:pmr_file
檔案名稱:核价单-分量计价资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmr_file
(
pmr01       varchar2(20) NOT NULL,   /*核价单号                               */
                                     /*核價單號                               */
pmr02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
pmr03       number(15,3) NOT NULL,   /*启始数量                               */
                                     /*啟始數量                               */
pmr04       number(15,3) NOT NULL,   /*截止数量                               */
                                     /*截止數量                               */
pmr05       number(20,6),            /*税前单价                               */
                                     /*單價                                   */
pmr05t      number(20,6),            /*含税单价                               */
pmrplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmrlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table pmr_file add  constraint pmr_pk primary key  (pmr01,pmr02,pmr03,pmr04) enable validate;
grant select on pmr_file to tiptopgp;
grant update on pmr_file to tiptopgp;
grant delete on pmr_file to tiptopgp;
grant insert on pmr_file to tiptopgp;
grant index on pmr_file to public;
grant select on pmr_file to ods;
